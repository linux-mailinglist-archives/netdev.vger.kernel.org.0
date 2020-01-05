Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFE8130721
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 11:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgAEKmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 05:42:24 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:48361 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbgAEKmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 05:42:23 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7A3323FDE;
        Sun,  5 Jan 2020 05:42:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 05 Jan 2020 05:42:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=Bg70TfGSOPAvhp+LYYPCxqiBNS2
        gPRtQUG933et+lgI=; b=AJetH91vtZKhzoj2u3iripRVedByRfzvJr2EFhO4KVA
        iJAHXiFLyQvNAFUhZJ82BKhTRhNvCkE0sWg2K4iHzQN7w05zW73zgPnfvW4nmJdR
        CLoP1LOiJMa+JCVLg70uPcm/H2zLCyzXOgGqN4/1C/+wux/VIR/1qr48XpjLXfjb
        YfRHOXHCA7fXnPBM9p+GCfALYZjQND0sF747M713tMjE5eQlIOjS9UivwPZS+tAE
        VdQxQ3OoI6HNrJnu7RZFKUBMCeiEVQvp3+Ocv04ehS9DVS4MwisbkGcFle9qiZpq
        hCD/pOCMMsMTuBwt8TH+lv9xWcLVWL0sTMuecUl0SvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Bg70Tf
        GSOPAvhp+LYYPCxqiBNS2gPRtQUG933et+lgI=; b=VfqPxNwwpUYiqfxyxFEW2N
        jDFREgf+OQmOwR6HcArC+SF4YjPIHtNSJs2pbdS/iaJP5Fd4W2EpemB5OEj/xOA5
        ckeaHKqu0qW9owyk6w9h6gPm+iAk/pA80FuPZ9fZvhFjvR9xeCSRAHK7qcmMtkpn
        SG1tlBtw1B/imKkYl5zoijKTE124KE/n08frvrYLtAA6AB3jPHYaUlGfUHZH1EdW
        IAqnoE3LQUZ2d3Uq5N4Xtm9PxKkQ/kuUueHCxD5mKJ6zdcc5u5kPyfXgmg5eZKKw
        Y7zxLsTflB7oHrajucxBQWP53ToOlwy/VVRfD9F4zeAhsbHngyp+h32Ljc0NfQlA
        ==
X-ME-Sender: <xms:i70RXuVqxQ_zXFMmKy3X0BWIQL-8lKCPui4HVlam_Fj4zkH9Oghv4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdegkedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:i70RXuEm9pwTWEvGq7QvCVWuZ2MOqXCCuZepAw1PuxDtVBah1QsBjw>
    <xmx:i70RXq5aOrfgtxtk_klO_P-_rX6tcrYPVhFaieCAfzHVGoDbwaHYhg>
    <xmx:i70RXoKMs7vv0lB9H6TMytOHNCH8sUOtKK_bHGlMAPFa-iKN_sS9KA>
    <xmx:jr0RXsfDqkWFV76bHvqVh_Xgk6EIOvxzaZ6inZz_mHCETvipE0fDgw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D04E8005C;
        Sun,  5 Jan 2020 05:42:19 -0500 (EST)
Date:   Sun, 5 Jan 2020 11:42:16 +0100
From:   Greg KH <greg@kroah.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, Johan Hedberg <johan.hedberg@gmail.com>,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev <netdev@vger.kernel.org>,
        BlueZ devel list <linux-bluetooth@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 5/8] net: bluetooth: remove unneeded MODULE_VERSION()
 usage
Message-ID: <20200105104216.GA1679409@kroah.com>
References: <20200104195131.16577-1-info@metux.net>
 <20200104195131.16577-5-info@metux.net>
 <22BD3D36-DE54-4062-B3A1-15D9E0E256A8@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22BD3D36-DE54-4062-B3A1-15D9E0E256A8@holtmann.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 05, 2020 at 10:34:56AM +0100, Marcel Holtmann wrote:
> Hi Enrico,
> 
> > Remove MODULE_VERSION(), as it isn't needed at all: the only version
> > making sense is the kernel version.
> 
> I prefer to keep the MODULE_VERSION info since it provides this
> information via modinfo.

Sure, but it's really pointless :)

> Unless there is a kernel wide consent to remove MODULE_VERSION
> altogether, the Bluetooth subsystem is keeping it.

I've deleted them from lots of drivers/subsystems already as they do not
make any sense when you think about vendor kernels, stable kernels, and
upstream kernel versions.

thanks,

greg k-h
