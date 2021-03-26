Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C099534A5CA
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhCZKsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:48:41 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54145 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229589AbhCZKsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:48:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B95135C1448
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:48:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 26 Mar 2021 06:48:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=QRVYtamrExlvwcT270s5J+JnU3
        FbsO9dcWYla9NZFes=; b=d9v8sXYI2+kN9hAzH5DoS7rdcY8QWwSkRDhRx5XGUP
        HzioP6yKuIy7Lr8D/dn74ygp/RGlxLQdaUvTJGpYHCmM3wrjF5EQFLrvpr19VDWY
        7fqVEZsAOVMfTFAU+tUAEiCTtMjwIfWEj9eiPEtFQZEkR2xQ22hL3A6SUvH2c91A
        5qSrfbhwPrNeD1cFuT9y+qUWV/uPK+Se8MWmvBrrXJmY0xSdP/wWxHuqa1hTI5S8
        NclJjW+X8z0ZiInDWiB1GmWkRHLZ/eyW951M2MWPo0fKC26nVYGtHP493PUniJsD
        leSnZGWPU1MPnWCO+hgERXCAje6oGFAEMWwglAM2r4Rg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QRVYta
        mrExlvwcT270s5J+JnU3FbsO9dcWYla9NZFes=; b=wFDwWlrD+cQnpBbYdGQrmI
        5is4V8nCYUhAC52rktJ+4WPt3eDF66BW6bdIYfYinibokiowhBW7IUEh+lNF6Ovx
        1krxPJn56bX3Co2w8pu7iLa6jqwaokrENLWnLfwd6PP7/cWoK3O4moseE57De7Ze
        Vhg3ljivVWqfK2xPDgCFlYMAsM7Ew1R7iPsatTcxmkoXd0WG7kuG35J3r0OGaU2k
        +jZZc1j8Et7eoEx/hA1ojzoBhAUe68oVhxKNPrjgPYcC/0TRNOV5NW6cJhCE8YeI
        5kZ98RHHDNd5CZSBoR3KtA2jpCvcaNWvC8xHhTB/3JVrgCfUhOGA6QKgGzaN8T4w
        ==
X-ME-Sender: <xms:_rtdYKlWWhTRYuP6aWxJu8GF909eRBYqQMU20C38fBNkM0j_-lglJA>
    <xme:_rtdYBw9lK7GFi9uo19TtdyYiVSXtky32qvCyHM55nasauAsuwmLG7pX4uAwPey_P
    5EyaAC5HD054mZN1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehvddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgovfgvgihtqfhnlhihqddqteefjeefqddtgeculd
    ehtddmnecujfgurhepkffuhffvffgtfggggfesthejredttderjeenucfhrhhomhepvehh
    rhhishhtohhphhgvrhcuvfgrlhgsohhtuceotghhrhhishesthgrlhgsohhthhhomhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpeeujedutefhueefgedvffethfeiveevudffhedu
    hfdvteekgfeuuedvgeekiefftdenucffohhmrghinhepohhfohhnohdrohhrghenucfkph
    epjedvrdelhedrvdegfedrudehieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpegthhhrihhssehtrghlsghothhhohhmvgdrtghomh
X-ME-Proxy: <xmx:_rtdYFgi-sLKrj7iVIabYKRzEOyUn1KhxazXWXnJedfvzxGzfWcEoQ>
    <xmx:_rtdYGWcJnoGSYKSHiJi-Z2Q5vbz_3ji2g0EEd6Btbo6cYcuCFaBlQ>
    <xmx:_rtdYH1eDoWz_Vk4LIPozduIAsD95WcXAEgWnBWdifCRbDAqsj-MxQ>
    <xmx:_rtdYMoZx4hftUhvDzG16KXLoO5D2uwf7U73yVWkn24-uxHy280cPw>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7778A24006A
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:48:30 -0400 (EDT)
Message-ID: <a9ad2ecef71ba9dfe27c422d82f22d46d3275c35.camel@talbothome.com>
Subject: [PATCH 0/9] A set of patches for ofono/mmsd
From:   Christopher Talbot <chris@talbothome.com>
To:     netdev@vger.kernel.org
Date:   Fri, 26 Mar 2021 06:48:29 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am submitting a set of patches I have been workin on for mmsd.

I have been working on the assumption that the ofono mailing list is
the correct avenue to submit patches for mmsd, and I have attempted to
submit patches on a couple of occasions:

https://lists.ofono.org/hyperkitty/list/ofono@ofono.org/thread/HFGZCER3I6G52SPSG44OC4KTHDO2ZEC6/

https://lists.ofono.org/hyperkitty/list/ofono@ofono.org/thread/CVOWCDC7H4G4F3N4RTUPPLOTJQ7LCHDY/

I have also attempted to contact the ofono group on the IRC mailing
list in February, January, and December in regards to submitting
patches. I have yet to recieve a reply.

At the suggestion of some other devs, I am submitting my patches to
this mailing list for feedback.


-- 
Respectfully,
Chris Talbot

