Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AAC2D48A7
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 19:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732158AbgLISMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 13:12:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728099AbgLISMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 13:12:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607537443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zLiEzxUOrVlfIOo73NK6FKaWkD2tUBdf1/nXnfx8j9s=;
        b=i4rBFRGnM9xhOe8lH0pa4x6IBQ12rPg2LRKKYlZYY+aJVvjKt4AbwwClBOaV54nek6qih/
        r+MAZYX2i+J64C4QE1Ep1F/vhmIzVPuofa3nI+kPmFvVlp82RluSjmvpLoOzv9ErAEu41y
        m3rIKy4DfNIpUUg9PfyaBjLYSpXgWPU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-o7C-pqwDNmafMKC8MrViWg-1; Wed, 09 Dec 2020 13:10:37 -0500
X-MC-Unique: o7C-pqwDNmafMKC8MrViWg-1
Received: by mail-wr1-f71.google.com with SMTP id b8so948653wrv.14
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 10:10:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zLiEzxUOrVlfIOo73NK6FKaWkD2tUBdf1/nXnfx8j9s=;
        b=ZbG13K+ZOLv1hnmd2CA6qnSGI16W6dIOkTQQW+KaLIUl5/9Mdvf7FGj43Qe/b64tfO
         QNLwxQULmJkiZJEXtZRDx0n56Bac0AJrOVMJ06i2guGU6DHJ4impeX0gNgVraA/jTSEZ
         gm2KNcTb1+59FI844l47Xd5Q5qZpMusPpGeyP/9JC3qCJwofxRR3QmIv9EEvX5ZKawYt
         IfEprcxLx9ofHWx/lNQrOolEpFyXrw9ht7ThXb3T7fzz3qJJDcT5AVMND1Dpcp+kW25B
         vA7b6s5SWwoA+O8f1Qt12XDBWQhZc1/tgcxoIEsqVnYzJ+QSv/QS/yEq3HXmS5Au5bM4
         4s0Q==
X-Gm-Message-State: AOAM530EX1ENXd2pHS9vhyFIUVVdRTuL+JboGmJXl+je0IxyzdYJJDAT
        Wifz6FNoOIuNIin3mjoUyF3RXjm27tYhmFMJzNA/ZNvV1+GHpBZozHPFmRMUnPHVPoltxUZZBhJ
        UE9/AVcwdW7Pd6rJU
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr4044986wma.22.1607537436187;
        Wed, 09 Dec 2020 10:10:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwxN4ULzKv8Qu7nicL3FiyRWTqG8WM2GpWoc0OyD0FCpgyN3fQBg1PwgDWXGgRrHm3Ww4iBdw==
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr4044963wma.22.1607537435993;
        Wed, 09 Dec 2020 10:10:35 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id h15sm4555168wru.4.2020.12.09.10.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 10:10:35 -0800 (PST)
Date:   Wed, 9 Dec 2020 19:10:33 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     "linux-kernel@vger kernel. org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: Urgent: BUG: PPP ioctl Transport endpoint is not connected
Message-ID: <20201209181033.GB21199@linux.home>
References: <83C781EB-5D66-426E-A216-E1B846A3EC8A@gmail.com>
 <20201209164013.GA21199@linux.home>
 <1E49F9F8-0325-439E-B200-17C8CB6A3CBE@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1E49F9F8-0325-439E-B200-17C8CB6A3CBE@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 06:57:44PM +0200, Martin Zaharinov wrote:
> > On 9 Dec 2020, at 18:40, Guillaume Nault <gnault@redhat.com> wrote:
> > On Wed, Dec 09, 2020 at 04:47:52PM +0200, Martin Zaharinov wrote:
> >> Hi All
> >> 
> >> I have problem with latest kernel release 
> >> And the problem is base on this late problem :
> >> 
> >> 
> >> https://www.mail-archive.com/search?l=netdev@vger.kernel.org&q=subject:%22Re%5C%3A+ppp%5C%2Fpppoe%2C+still+panic+4.15.3+in+ppp_push%22&o=newest&f=1
> >> 
> >> I have same problem in kernel 5.6 > now I use kernel 5.9.13 and have same problem.
> >> 
> >> 
> >> In kernel 5.9.13 now don’t have any crashes in dimes but in one moment accel service stop with defunct and in log have many of this line :
> >> 
> >> 
> >> error: vlan608: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> error: vlan617: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> error: vlan679: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> 
> >> In one moment connected user bump double or triple and after that service defunct and need wait to drop all session to start .
> >> 
> >> I talk with accel-ppp team and they said this is kernel related problem and to back to kernel 4.14 there is not this problem.
> >> 
> >> Problem is come after kernel 4.15 > and not have solution to this moment.
> > 
> > I'm sorry, I don't understand.
> > Do you mean that v4.14 worked fine (no crash, no ioctl() error)?
> > Did the problem start appearing in v4.15? Or did v4.15 work and the
> > problem appeared in v4.16?
> 
> In Telegram group I talk with Sergey and Dimka and told my the problem is come after changes from 4.14 to 4.15 
> Sergey write this : "as I know, there was a similar issue in kernel 4.15 so maybe it is still not fixed"

Ok, but what is your experience? Do you have a kernel version where
accel-ppp reports no ioctl() error and doesn't crash the kernel?

There wasn't a lot of changes between 4.14 and 4.15 for PPP.
The only PPP patch I can see that might have been risky is commit
0171c4183559 ("ppp: unlock all_ppp_mutex before registering device").

> I don’t have options to test with this old kernel 4.14.xxx i don’t have support for them.
> 
> 
> > 
> >> Please help to find the problem.
> >> 
> >> Last time in link I see is make changes in ppp_generic.c 
> >> 
> >> ppp_lock(ppp);
> >>        spin_lock_bh(&pch->downl);
> >>        if (!pch->chan) {
> >>                /* Don't connect unregistered channels */
> >>                spin_unlock_bh(&pch->downl);
> >>                ppp_unlock(ppp);
> >>                ret = -ENOTCONN;
> >>                goto outl;
> >>        }
> >>        spin_unlock_bh(&pch->downl);
> >> 
> >> 
> >> But this fix only to don’t display error and freeze system 
> >> The problem is stay and is to big.
> > 
> > Do you use accel-ppp's unit-cache option? Does the problem go away if
> > you stop using it?
> > 
> 
> No I don’t use unit-cache , if I set unit-cache accel-ppp defunct same but user Is connect and disconnet more fast.
> 
> The problem is same with unit and without . 
> Only after this patch I don’t see error in dimes but this is not solution.

Soryy, what's "in dimes"?
Do you mean that reverting commit 77f840e3e5f0 ("ppp: prevent
unregistered channels from connecting to PPP units") fixes your problem?

> In network have customer what have power cut problem, when drop 600 user and back Is normal but in this moment kernel is locking and start to make this : 
> sessions:
>   starting: 4235
>   active: 3882
>   finishing: 378
>  The problem is starting session is not real user normal user in this server is ~4k customers .

What type of session is it? L2TP, PPPoE, PPTP?

> I use pppd_compat .
> 
> Any idea ?
> 
> >> 
> >> Please help to fix.
> Martin
> 

