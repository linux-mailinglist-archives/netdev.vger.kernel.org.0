Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188C615A32B
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 09:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgBLIYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 03:24:46 -0500
Received: from mail-pl1-f173.google.com ([209.85.214.173]:35076 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbgBLIYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 03:24:46 -0500
Received: by mail-pl1-f173.google.com with SMTP id g6so684033plt.2
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 00:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=PzPWnEAQHRbEQBetNA8dDon3xzATcEeTrv7n8U5J1Fo=;
        b=rwkBEYE75kIgOW4hqvS7S749YcEljx4p2IuekzSR0f/mUIkR2mSm5o5VesjFTDPKfm
         1KdkGBl6TMc7qooTcR5633TODGOFw0j7IvbRzqT2R/7PfdTfPzhKKFwoIFLkpsRY4nTO
         uZ84WjTUCBe9Tf0jUIpSz42YNSufNzIG3B5I9W0DgkHHSP6vDlQxwazNW5DqMZgakpEI
         eFNKllvYdrF9XJ6ChQdTQiBCuMCZn9i1Yv0halKoIdqigU+Q8X97bIGB4GpZAebIE4/r
         tS0SUonoYETdgoIMg17MHMiWBXtIfGRUHDViqhxZgmFjDPcs1Yy4/X+FvQm3CBfg9iy+
         Q+Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=PzPWnEAQHRbEQBetNA8dDon3xzATcEeTrv7n8U5J1Fo=;
        b=kXkaAOZoaLxafcQVaZcCPVMSB+VFSo3Nqm0DntyNtzXXgRyVWVmTTPw4hiOWpqPlQ2
         PtJ2gJnXCaPqERk7UhYvrhF9pukyyWwsa6xL3WrSxWlzCMR0rIe1XGDY+dTh5r1d2ctV
         v1vxutXC0v3fv1u57I+Rgscvu8Fw+oiENccA1jXVYKx2TkoJfX97thMd3YhuEDZrBCdb
         eO4GlRUqQxYP3rvS4Xs2jDaJG5ufNB2hltZ+yXFbFU936rm/dUnpvdAkrQCJEYjgv4/7
         MekrCC/nFsJab2AeKQYMVwHCKFlWC1NTBNi9CiBq22xzLB03BW9tdJjnekqv6+R+BDw0
         TMcw==
X-Gm-Message-State: APjAAAXIHVt4mM2/Fb/+wFp77j1OoZs2fPaVgRDa+g6PHE2gAkMnyPqc
        kwB4qnDT3zPz34pzIUOUMFA=
X-Google-Smtp-Source: APXvYqymhIvLh6NGxlhYdPzrLJBHf8QezZG3f1yISlLfim22UGt3zldsVtplUlc1QimSaWHM8ASOpQ==
X-Received: by 2002:a17:90a:e397:: with SMTP id b23mr8460928pjz.135.1581495885563;
        Wed, 12 Feb 2020 00:24:45 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r17sm7044458pgn.36.2020.02.12.00.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 00:24:44 -0800 (PST)
Date:   Wed, 12 Feb 2020 16:24:34 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
Message-ID: <20200212082434.GM2159@dhcp-12-139.nay.redhat.com>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 08:37:31AM +0100, Rafał Miłecki wrote:
> Hi, I need some help with my devices running out of memory. I've
> debugging skills but I don't know net subsystem.
> 
> I run Linux based OpenWrt distribution on home wireless devices (ARM
> routers and access points with brcmfmac wireless driver). I noticed
> that using wireless monitor mode interface results in my devices (128
> MiB RAM) running out of memory in about 2 days. This is NOT a memory
> leak as putting wireless down brings back all the memory.
> 
> Interestingly this memory drain requires at least one of:
> net.ipv6.conf.default.forwarding=1
> net.ipv6.conf.all.forwarding=1
> to be set. OpenWrt happens to use both by default.
> 
> This regression was introduced by the commit 1666d49e1d41 ("mld: do
> not remove mld souce list info when set link down") - first appeared
> in 4.10 and then backported. This bug exists in 4.9.14 and 4.14.169.
> Reverting that commit from 4.9.14 and 4.14.169 /fixes/ the problem.
> 
> Can you look at possible cause/fix of this problem, please? Is there
> anything I can test or is there more info I can provide?

Hi Rafał,

Thanks for the report. Although you said this is not a memory leak. Maybe
you can try a84d01647989 ("mld: fix memory leak in mld_del_delrec()").

Thanks
Hangbin

> 
> I'm not sure why this issue appears only when using monitor mode.
> Using wireless __ap mode interface (with hostapd) won't expose this
> issue. I guess it may be a matter of monitor interfaces not being
> bridged?
> 
> -- 
> Rafał
