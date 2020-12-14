Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F402D9D50
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 18:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408374AbgLNRLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 12:11:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408350AbgLNRLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 12:11:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607965793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bfJv7pyU3y1plqcZLspvJWWR6I6MIq6AZVeJWdRv7rM=;
        b=Izoib4uvpM0CZuJxAOtC+ncdA4CYG7WyF2VCpIrr8J5WDCQthgY74ojy3Hkyp55JpE1Rwd
        Ude/W5bUddg/mCpCdEgbQpNDP4iFfqXUXu0Tqn0E5r2Qw906a5UY0pzibM6M0ZxiLXXO64
        PFQBr7L90g0Gb7ZgOCWY194wnsfUD4I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-T-A5wV54OtWq9pcvCDe9uQ-1; Mon, 14 Dec 2020 12:09:50 -0500
X-MC-Unique: T-A5wV54OtWq9pcvCDe9uQ-1
Received: by mail-wm1-f70.google.com with SMTP id z139so1043764wmc.1
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 09:09:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bfJv7pyU3y1plqcZLspvJWWR6I6MIq6AZVeJWdRv7rM=;
        b=iVqr8zJDWJ//n056YD93Okeo09Y2OlOuSnz2FRoZhA7bcxpV/I6ExVr+8hz7S7H/oQ
         BKwR5uzsw10pIQSmgdSosvIn5ANA+Np2LA8NXFyhI9MMgXkz7j3n3rgM+stROXsEF7GM
         PwHIn7GFmrgxsRrEeru1STbOxPojhFVF64zEi+iAjDDKHGEFZ6oDORZ1KB15TGfiR+BW
         ZqrFl4Bu0i2LLKHr+UnOo1R++hrAQfgARUJ9zu0Cctpr4ZPL/9GI2Nc1TXXzSmBxvC8V
         JGU4d7QCvGNkvW2oxxvJPV6mBy2e7jPhlKMb8ucOVz+7LiNVRFfsWoIJG45cnA/GUd+r
         XfBg==
X-Gm-Message-State: AOAM530iMzpxNTnQldF6YSvEE3PQ7qVt+cPVF6C0HtW06vO7zBVPtmo2
        4agDjM46+Z49tnUmuqbf/vSYmbi8ko3fEnWxVQt5uUKbBMWIU/Zvr9wQTznPnrpOMDkVSMsxrWg
        fCrprJl+YmDgUKUEC
X-Received: by 2002:a1c:1fc4:: with SMTP id f187mr28784527wmf.107.1607965789304;
        Mon, 14 Dec 2020 09:09:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRVXsSXqA3sY4VvpK70uLZVdAE7dFO3NJoxd/7i8PSqwKK7XsINKbTuV+o1EUCRA8cYqOwUg==
X-Received: by 2002:a1c:1fc4:: with SMTP id f187mr28784511wmf.107.1607965789070;
        Mon, 14 Dec 2020 09:09:49 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id y6sm32273563wmg.39.2020.12.14.09.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 09:09:48 -0800 (PST)
Date:   Mon, 14 Dec 2020 18:09:46 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     "linux-kernel@vger kernel. org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: Urgent: BUG: PPP ioctl Transport endpoint is not connected
Message-ID: <20201214170946.GB8350@linux.home>
References: <83C781EB-5D66-426E-A216-E1B846A3EC8A@gmail.com>
 <20201209164013.GA21199@linux.home>
 <1E49F9F8-0325-439E-B200-17C8CB6A3CBE@gmail.com>
 <20201209181033.GB21199@linux.home>
 <B70AAB31-B656-43B4-97B6-6E0FA0E1E680@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B70AAB31-B656-43B4-97B6-6E0FA0E1E680@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 09:12:18PM +0200, Martin Zaharinov wrote:
> 
> 
> > On 9 Dec 2020, at 20:10, Guillaume Nault <gnault@redhat.com> wrote:
> > 
> > On Wed, Dec 09, 2020 at 06:57:44PM +0200, Martin Zaharinov wrote:
> >>> On 9 Dec 2020, at 18:40, Guillaume Nault <gnault@redhat.com> wrote:
> >>> On Wed, Dec 09, 2020 at 04:47:52PM +0200, Martin Zaharinov wrote:
> >>>> Hi All
> >>>> 
> >>>> I have problem with latest kernel release 
> >>>> And the problem is base on this late problem :
> >>>> 
> >>>> 
> >>>> https://www.mail-archive.com/search?l=netdev@vger.kernel.org&q=subject:%22Re%5C%3A+ppp%5C%2Fpppoe%2C+still+panic+4.15.3+in+ppp_push%22&o=newest&f=1
> >>>> 
> >>>> I have same problem in kernel 5.6 > now I use kernel 5.9.13 and have same problem.
> >>>> 
> >>>> 
> >>>> In kernel 5.9.13 now don’t have any crashes in dimes but in one moment accel service stop with defunct and in log have many of this line :
> >>>> 
> >>>> 
> >>>> error: vlan608: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> error: vlan617: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> error: vlan679: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> 
> >>>> In one moment connected user bump double or triple and after that service defunct and need wait to drop all session to start .
> >>>> 
> >>>> I talk with accel-ppp team and they said this is kernel related problem and to back to kernel 4.14 there is not this problem.
> >>>> 
> >>>> Problem is come after kernel 4.15 > and not have solution to this moment.
> >>> 
> >>> I'm sorry, I don't understand.
> >>> Do you mean that v4.14 worked fine (no crash, no ioctl() error)?
> >>> Did the problem start appearing in v4.15? Or did v4.15 work and the
> >>> problem appeared in v4.16?
> >> 
> >> In Telegram group I talk with Sergey and Dimka and told my the problem is come after changes from 4.14 to 4.15 
> >> Sergey write this : "as I know, there was a similar issue in kernel 4.15 so maybe it is still not fixed"
> > 
> > Ok, but what is your experience? Do you have a kernel version where
> > accel-ppp reports no ioctl() error and doesn't crash the kernel?
> Reported by Sergey and Dimka  version 4.14 < don’t have this problem,
> Only version after 4.15.0 > have problem and with patch only fix to don’t put crash log in dimes and freeze system.

If they know about some regressions, please tell them to report them
(either to the list or directly to me). Because I'm not aware of
anything that broke with 4.15.

> > 
> > There wasn't a lot of changes between 4.14 and 4.15 for PPP.
> > The only PPP patch I can see that might have been risky is commit
> > 0171c4183559 ("ppp: unlock all_ppp_mutex before registering device").
> 
> For my changes is a atomic and skb kfree .
> > 
> >> I don’t have options to test with this old kernel 4.14.xxx i don’t have support for them.
> >> 
> >> 
> >>> 
> >>>> Please help to find the problem.
> >>>> 
> >>>> Last time in link I see is make changes in ppp_generic.c 
> >>>> 
> >>>> ppp_lock(ppp);
> >>>>       spin_lock_bh(&pch->downl);
> >>>>       if (!pch->chan) {
> >>>>               /* Don't connect unregistered channels */
> >>>>               spin_unlock_bh(&pch->downl);
> >>>>               ppp_unlock(ppp);
> >>>>               ret = -ENOTCONN;
> >>>>               goto outl;
> >>>>       }
> >>>>       spin_unlock_bh(&pch->downl);
> >>>> 
> >>>> 
> >>>> But this fix only to don’t display error and freeze system 
> >>>> The problem is stay and is to big.
> >>> 
> >>> Do you use accel-ppp's unit-cache option? Does the problem go away if
> >>> you stop using it?
> >>> 
> >> 
> >> No I don’t use unit-cache , if I set unit-cache accel-ppp defunct same but user Is connect and disconnet more fast.
> >> 
> >> The problem is same with unit and without . 
> >> Only after this patch I don’t see error in dimes but this is not solution.
> > 
> > Soryy, what's "in dimes"?
> > Do you mean that reverting commit 77f840e3e5f0 ("ppp: prevent
> > unregistered channels from connecting to PPP units") fixes your problem?
> Sorry text correct in dmesg*
> 
> I don’t make any changes of ppp part of kernel 5.9.13 I use clean build for ppp .
> > 
> >> In network have customer what have power cut problem, when drop 600 user and back Is normal but in this moment kernel is locking and start to make this : 
> >> sessions:
> >>  starting: 4235
> >>  active: 3882
> >>  finishing: 378
> >> The problem is starting session is not real user normal user in this server is ~4k customers .
> > 
> > What type of session is it? L2TP, PPPoE, PPTP?
> > 
> Session is PPPoE only with radius auth
> 
> >> I use pppd_compat .
> >> 
> >> Any idea ?
> >> 
> >>>> 
> >>>> Please help to fix.
> >> Martin
> 

