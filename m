Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5059A22A2FA
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 01:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733184AbgGVXUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 19:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733132AbgGVXUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 19:20:41 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F142BC0619E1;
        Wed, 22 Jul 2020 16:20:40 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id l6so3731347qkc.6;
        Wed, 22 Jul 2020 16:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jeZreKDLGQJ/Jdd2kokTsoFaBdpo+SHh85v/8w3Kt6s=;
        b=iDfPg+q2N0j+QEFb6C76HEy3RuhKS2RzaHQodwWTwlG2C9EzK7tTdMjHXFGXnPYbyM
         sALV/RvUBaC6PPkhc6k3Y6UrYaUDLj76h3bNpaXUP24E3baIO6WY/t791hu1fzp6vowe
         Gp3ZFmMSx1gFBu1B3SV+WmzEHm8xO1JlHt62/cGCtq7HtZeyCO6N+NF4LBojf/4O/f7R
         O83caGrZluNFL36fTwlDKIDC2x0m88LOJJjfu7VCkMy3pPjUX4DPvMtjNRZJN4nJQbDL
         dyp6Z8l1IfS353f8DIZnYNS589bWq4dWchVNRSIw22LjC38Icim1d06LydIFmBef3w0O
         i71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jeZreKDLGQJ/Jdd2kokTsoFaBdpo+SHh85v/8w3Kt6s=;
        b=kB1B8gI9rCnjHgP4ThZnMODESoyTEVCNdjhYIq4xaiASgP6Y7Dor5B5wN1X14AI0IH
         MohDJMnEtNLxEWo+Yj5oZEvEcBujR+j+/hNNUTFL/wt7y2srTXgqGcF+BM55DkoI0XO1
         CZDafFfQ73pPFstc/PAB/ORcORfDsslBrDGgVrlONm9ucgnET1QHE3wl3L1L5IyOpJni
         vLyMFmu9LVvFgAnmlMLLminW//oVywIhzW5+9sEiIRBlgu6XteL/p9/ASLqf/Aj3CT6L
         jQ279DqJx8HGxZgRlLjuCpTdbPkiqBYikNAa1Pv/yH6HhdWmXLKTqh28Ny+5DhPV0c6N
         O/QQ==
X-Gm-Message-State: AOAM530On9RLIcixOUa6dyQwoG+Tzko56PpaH6n65MszI0RYIHgVdx1q
        8t6BZXP7gGsMoU0XwOoMaC8=
X-Google-Smtp-Source: ABdhPJxh11At9hPgNwYpGZKxyU6SKg6Dl6hnWNxmRLW2cyP+pm0I76RQmRuj54+6S4HX3xcUeV3ZIw==
X-Received: by 2002:a37:b387:: with SMTP id c129mr2449391qkf.292.1595460040175;
        Wed, 22 Jul 2020 16:20:40 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id p17sm1091785qkj.69.2020.07.22.16.20.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 16:20:39 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id BC19B27C0054;
        Wed, 22 Jul 2020 19:20:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 22 Jul 2020 19:20:37 -0400
X-ME-Sender: <xms:xckYX6TjYGcA2LZjBrHUZvmr5zKTeELFRk3fagL4IA_GsNIfxqvOIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrhedtgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtth
    gvrhhnpedvleeigedugfegveejhfejveeuveeiteejieekvdfgjeefudehfefhgfegvdeg
    jeenucfkphephedvrdduheehrdduuddurdejudenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvg
    hngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:xckYX_xg7GvHmkSnWDADLEQvOnEx_pbaCwfsMmoqMVVcSObVwtklxg>
    <xmx:xckYX30LeDoMGnaggVRdql5GcCOCm9lWNGbiefV65Z5KwNV6HvS4Eg>
    <xmx:xckYX2CejgGDLrAJjrahTWGckjh4qdj5M_6DGlt4ZX0lEwSsjFhGxQ>
    <xmx:xckYXz7ZrquPCJejjqVMH6LPkqss1IcRdRGVugwlFBBoxflyi_sp3Vwf57k>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id C4B59328006A;
        Wed, 22 Jul 2020 19:20:36 -0400 (EDT)
Date:   Thu, 23 Jul 2020 07:20:35 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Wei Liu <wei.liu@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: [RFC 01/11] Drivers: hv: vmbus: Always use HV_HYP_PAGE_SIZE for
 gpadl
Message-ID: <20200722232035.GB35358@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
 <20200721014135.84140-2-boqun.feng@gmail.com>
 <20200721152218.ozpk2b4ymfdocu4p@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721152218.ozpk2b4ymfdocu4p@liuwe-devbox-debian-v2>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 03:22:18PM +0000, Wei Liu wrote:
> On Tue, Jul 21, 2020 at 09:41:25AM +0800, Boqun Feng wrote:
> > Since the hypervisor always uses 4K as its page size, the size of PFNs
> > used for gpadl should be HV_HYP_PAGE_SIZE rather than PAGE_SIZE, so
> > adjust this accordingly as the preparation for supporting 16K/64K page
> > size guests.
> 
> It may be worth calling out there is no change on x86 because
> HV_HYP_PAGE_SHIFT and PAGE_SHIFT are of the same value there.
> 

Sure, I will call it out in the commit log of the next version, thanks!

Regards,
Boqun

> Wei.
