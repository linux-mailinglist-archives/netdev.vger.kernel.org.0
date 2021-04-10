Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACD535AE06
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 16:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhDJOOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 10:14:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50515 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234392AbhDJOOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 10:14:18 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 363735C009D;
        Sat, 10 Apr 2021 10:14:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:14:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=blCztr7AFSPd4SPPg7VzqAdi0f
        EafCtmv2N1s0KuDv8=; b=Bg8QzpfiAbOQkjJKXPY6uMCm2VBa1Jo+DVZeByylEc
        XhWeZSOjzdX4776OGDE3MI831zj3PakKVEPbAVBNGE8bsSFm5GMXMmxQzt0D5uEP
        VAVd9XuJt3IA6lAwx9J4x51Lnv/KDFy4w/7D79YNOKYqcDxvo7321bcDMmMSM8Vx
        iPElvdIpmtPhEvccD9veCFkV+YBOO6mOviXUxvQxmLXVaJPnbB+2j2WfZDj/utwt
        p2XXuXpiWXuhabefk/+bhDP/rXxJasTvjQ2K9HJoA4QGWghkbLOYTB1FCZyNg/72
        8b0RBJud1hdYv5jSHkJCDzoRXYI6lxozLSMGcSCAs2wQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=blCztr
        7AFSPd4SPPg7VzqAdi0fEafCtmv2N1s0KuDv8=; b=nb0g5E2y59w3JLtfybRFLN
        QCE2loOgUbV2x+8o+b3VvzVlaMn6vg4IOpYHTE5ThFFkWmoYqfjFTwAygbNjoU/5
        Fd18OC+YcSdNSCbU1FbjAHjesBcV8A5FtONaFYkJ1bJKrWLKkqUvsEih/jKlkDCc
        p3NN9eQCRglU304Bam5cd8g1/UbLiajigW+7Dyu2VZKBjXTcVPNzSO+/QUgM9f3B
        CCOK7tCah1LPKTHVQknyV/nMC4kDUuDit748E/e01HaBKvG237iNMXo+gy44cFGA
        56PpQq45ois2iVLK5CI+1ErvqpNj+h3q89lY7UEnly0ppO8n6KfrwYTKicek7onw
        ==
X-ME-Sender: <xms:qrJxYPZ-fUzoNKkgv5enlRMhp9fwIbTmODTEWtGzUNYF61jkbvIDFg>
    <xme:qrJxYOYuPviDqMTOFWoMel0tWXQ61mN8Aabjei8oJvaoxna10SzhSRfaKaqyhWoMC
    jdaBXzBxUHtqLxUEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvffftggfggfgsehtjeertd
    dtreejnecuhfhrohhmpeevhhhrihhsucfvrghlsghothcuoegthhhrihhssehtrghlsgho
    thhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepkedujeeijeehjeffjeefiedtud
    dtgfelhedufeeghfeljeeitefhiedvudeifeehnecukfhppeejvddrleehrddvgeefrddu
    heeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptg
    hhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:qrJxYB_0BDiXEpFbFtbDYxGZX5H37YdjsafsMx28Se95MKtL6uFTDg>
    <xmx:qrJxYFo354DXCWglgjO9awePs28BUnxiXP4Fc5kowf6y4IGgmTXSuQ>
    <xmx:qrJxYKoxae1Ulpmf5PLWGl1EPSlapqbSD--S9Xbls7MBDXc4h82m2Q>
    <xmx:q7JxYPATiDqX0LeQjlwcASDvA41pKah142-O2xVBL6lNLmPRg4BNgA>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46A7F240054;
        Sat, 10 Apr 2021 10:14:02 -0400 (EDT)
Message-ID: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
Subject: [PATCH 0/9] Updates for mmsd
From:   Chris Talbot <chris@talbothome.com>
To:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm
Date:   Sat, 10 Apr 2021 10:13:45 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am submitting a series of patches for mmsd that I have been working
on. The patches have been successfully tested on PostmarketOS, Debian
on Mobile (Mobian), PureOS, and Fedora.

The patches fall into two catagories:
1) core fixes to mmsd to get it to work with several carriers
(including T-Mobile USA, AT&T USA, Telus Canada, and a Swedish
Carrier). 
2) A new plugin to enable mmsd functionality on Modem Manager. 

The Patches have been tested on both the Pinephone and the Librem 5,
and have been confirmed tested accross all major US carriers (as well
as several minor US carriers), Canadian carriers, French carriers, and
Swedish carriers. They been been likely tested on more carriers, but
the author can only confirm the above ones (as he has gotten positive
feedback for them).

-- 
Respectfully,
Chris Talbot

