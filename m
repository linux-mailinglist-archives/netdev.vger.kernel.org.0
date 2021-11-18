Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C88B4557CF
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbhKRJSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:18:08 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59195 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243187AbhKRJRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 04:17:39 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 298A15C01B4;
        Thu, 18 Nov 2021 04:14:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 18 Nov 2021 04:14:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FYSdKM
        XWsvcLVRpmrhkAPAuFaJOcTVO2E2gghiK47aM=; b=HOFmRcWUe/nWlw77N0aVjL
        5jarMhvAPCFo96AsXW8qcFSinG6qrgiRbjEY6fbxRCqohcWWvVMoJAXDi3k1z3Lm
        RhMcuQd2kVyrROpgbUoWRs6mmiws7eiz/aeFu7VWA5CvPIBtfAo/ZgXLvDeaFRLu
        EGMlaS7vH0iBWGuFwSBm83PPYxKMlmDxkeyUvus4xtiDVrZ2AdcXlaf0nuJ/cKNN
        w7vw6KZJVfO8Zp6Y+LEGt7M/zNQQqvVpGIFJIQmA+EzY7rPgZZ2Do5/JkX2fcHEw
        NP2TZIVe0I/mfDzFQ4w6jILKyXpxqYwGWH9iQD78sNgQDw7icqgryXQrY+TbYqOg
        ==
X-ME-Sender: <xms:ehmWYYE8cjTHKX48gQp9awPNDLPjw8LOrsyLnzZzhxePJ_KyXhvEfw>
    <xme:ehmWYRXF4ePzENxRZ5eCC4oXqJ1Tk5jShuiBl_r4yFfWFXtlw5QN5Vhhti53Pxct6
    pJZ77Quxoexrbo>
X-ME-Received: <xmr:ehmWYSIg7rp1gmSoSO4kF3Sx56KDyTJpFBm8pzuvZMrOer2oUkGWxfNGG61XexhGWuVIFBZh5mWvRsHfyyZQaY7uZCxb8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeehgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ehmWYaGmfeguN-n1NjJeQwXlvskKgzY2_ue6f2QYdnOJJ_DBMKaGFQ>
    <xmx:ehmWYeVc5Fc_HtwxHffaK_QJB67p_tNsgMPlmzJkr2vfUgCvFC4nzw>
    <xmx:ehmWYdPns1EJwzj3uzvrKu23u5orxDz6WpoXJMa2Q_dA5EOX91CXew>
    <xmx:exmWYReFTDIwTBHAfatYqDXbSEODmpAfjHZ86ma0ZraMAafxB7KYdQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Nov 2021 04:14:34 -0500 (EST)
Date:   Thu, 18 Nov 2021 11:14:31 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Maxim Petrov <mmrmaximuzz@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH iproute2] ip/ipnexthop: fix unsigned overflow in
 parse_nh_group_type_res()
Message-ID: <YZYZd7ybCb98+XoT@shredder>
References: <91362fa6-46df-c134-63b1-cc2b0d2832ee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91362fa6-46df-c134-63b1-cc2b0d2832ee@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:11:24PM +0300, Maxim Petrov wrote:
> 0UL has type 'unsigned long' which is likely to be 64bit on modern machines. At
> the same time, the '{idle,unbalanced}_timer' variables are declared as u32, so
> these variables cannot be greater than '~0UL / 100' when 'unsigned long' is 64
> bits. In such condition it is still possible to pass the check but get the
> overflow later when the timers are multiplied by 100 in 'addattr32'.
> 
> Fix the possible overflow by changing '~0UL' to 'UINT32_MAX'.
> 
> Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
