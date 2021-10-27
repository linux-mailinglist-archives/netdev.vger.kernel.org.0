Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFA843D0E4
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240326AbhJ0SlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:41:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236868AbhJ0SlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:41:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635359927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XMEXe0ICv6BgWp98rw/aHq8v8AFBOl4vDkhRVIL80bM=;
        b=Cf+eilEk6I/qHCq0VZGva3yy/wcczIeUUS57T79r/dWWkSynzLbB9doLca+UUKOHbaJTfi
        kz9eJ/xz3lVtKdQNEYv+hgoLZQEDoQqDgP8xlw6xPTr4xWqYmOYySseyhUgMH6AkVEU9Mq
        CsYH0UA9QTDFBJR31vrgz90H91vIQ8M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-syCzS-CFOMqJ32EEJwIfdg-1; Wed, 27 Oct 2021 14:38:46 -0400
X-MC-Unique: syCzS-CFOMqJ32EEJwIfdg-1
Received: by mail-ed1-f70.google.com with SMTP id z1-20020a05640235c100b003dcf0fbfbd8so3187208edc.6
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 11:38:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XMEXe0ICv6BgWp98rw/aHq8v8AFBOl4vDkhRVIL80bM=;
        b=DhMqZGOYYno5bNhjDKFCxSZubW61uTcSKXzsB1G4fiDZ01TU2HoT+jhAqSDOpNtiHU
         IPb9VKfBZuQP0GCWQFfb4g2Md7JuCnxjEAW/16pVJz329maBUpdnJ1A+xcLWagCI2Aiy
         3uLJSFc9xTekBjewFHmmLT6BqpyiVvAR31zazauCEOSkzqODxTlI+UKw12FgSz+UlBhX
         5Nv4iIlMhIhLg5M1TiSTnvXgGqpxHqDloGitB4sWZGIENO0qw1927E/3f7lYjzmJtOIQ
         lFabvncmtekW0dasHNsA5sYL6CAbPUMzK5K4hSlbVpYYOoHxrbCd4MK/x/0KeLOT6dR6
         78+Q==
X-Gm-Message-State: AOAM530S/bfjDB38TFxMCEiY0MZfWumKb17vg0w/8bHlTjmIhKUsvtw4
        CwmGICn6PVJzynhvr0KRpCj19THn8yo/PfBbRZnWR9/uGVNRrxellCdnESIRPgRMRtz9P6OpjKQ
        TUFmK+KNXo/hlvfnd
X-Received: by 2002:a05:6402:55:: with SMTP id f21mr46840912edu.8.1635359924974;
        Wed, 27 Oct 2021 11:38:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwC2QbEl1fxg0PA8S9t6oT7SWCQwA5E14QqU1vajgt4oMNCvV6kahxQF1AxcAISTiTWcUH4uA==
X-Received: by 2002:a05:6402:55:: with SMTP id f21mr46840891edu.8.1635359924798;
        Wed, 27 Oct 2021 11:38:44 -0700 (PDT)
Received: from redhat.com ([2.55.137.59])
        by smtp.gmail.com with ESMTPSA id g8sm324197ejt.104.2021.10.27.11.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 11:38:44 -0700 (PDT)
Date:   Wed, 27 Oct 2021 14:38:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, jiri@nvidia.com,
        kuba@kernel.org, leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in copy_data
Message-ID: <20211027143801-mutt-send-email-mst@kernel.org>
References: <000000000000a4cd2105cf441e76@google.com>
 <eab57f0e-d3c6-7619-97cc-9bc3a7a07219@redhat.com>
 <CACT4Y+amyT9dk-6iVqru-wQnotmwW=bt4VwaysgzjH9=PkxGww@mail.gmail.com>
 <20211027111300-mutt-send-email-mst@kernel.org>
 <589f86e0-af0e-c172-7ec6-72148ba7b3b0@redhat.com>
 <8b5fb6ae-ab66-607f-b7c8-993c483846ca@redhat.com>
 <1c0652f7-bb1b-99e1-7e8b-0613cc764ddd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1c0652f7-bb1b-99e1-7e8b-0613cc764ddd@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 08:20:08PM +0200, Laurent Vivier wrote:
> On 27/10/2021 19:03, Laurent Vivier wrote:
> > On 27/10/2021 18:25, Laurent Vivier wrote:
> > > On 27/10/2021 17:28, Michael S. Tsirkin wrote:
> > > > On Wed, Oct 27, 2021 at 03:36:19PM +0200, Dmitry Vyukov wrote:
> > > > > On Wed, 27 Oct 2021 at 15:11, Laurent Vivier <lvivier@redhat.com> wrote:
> > > > > > 
> > > > > > On 26/10/2021 18:39, syzbot wrote:
> > > > > > > Hello,
> > > > > > > 
> > > > > > > syzbot found the following issue on:
> > > > > > > 
> > > > > > > HEAD commit:    9ae1fbdeabd3 Add linux-next specific files for 20211025
> > > > > > > git tree:       linux-next
> > > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1331363cb00000
> > > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=aeb17e42bc109064
> > > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
> > > > > > > compiler:       gcc (Debian 10.2.1-6) 10.2.1
> > > > > > > 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116ce954b00000
> > > > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132fcf62b00000
> > > > > > > 
> > > > > > > The issue was bisected to:
> > > > > > > 
> > > > > > > commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
> > > > > > > Author: Leon Romanovsky <leonro@nvidia.com>
> > > > > > > Date:   Thu Oct 21 14:16:14 2021 +0000
> > > > > > > 
> > > > > > >       devlink: Remove not-executed trap policer notifications
> > > > > > > 
> > > > > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137d8bfcb00000
> > > > > > > final oops:     https://syzkaller.appspot.com/x/report.txt?x=10fd8bfcb00000
> > > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=177d8bfcb00000
> > > > > > > 
> > > > > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > > > > Reported-by: syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com
> > > > > > > Fixes: 22849b5ea595 ("devlink: Remove not-executed trap policer notifications")
> > > > > > > 
> > > > > > > ==================================================================
> > > > > > > BUG: KASAN: slab-out-of-bounds in memcpy include/linux/fortify-string.h:225 [inline]
> > > > > > > BUG: KASAN: slab-out-of-bounds in
> > > > > > > copy_data+0xf3/0x2e0
> > > > > > > drivers/char/hw_random/virtio-rng.c:68
> > > > > > > Read of size 64 at addr ffff88801a7a1580 by task syz-executor989/6542
> > > > > > > 
> > > > > > 
> > > > > > I'm not able to reproduce the problem with next-20211026 and the C reproducer.
> > > > > > 
> > > > > > And reviewing the code in copy_data() I don't see any issue.
> > > > > > 
> > > > > > Is it possible to know what it the VM configuration used to test it?
> > > > > 
> > > > > Hi Laurent,
> > > > > 
> > > > > syzbot used e2-standard-2 GCE VM when that happened.
> > > > > You can see some info about these VMs under the "VM info" link on the dashboard.
> > > > 
> > > > Could you pls confirm whether reverting
> > > > caaf2874ba27b92bca6f0298bf88bad94067ec37 addresses this?
> > > > 
> > > 
> > > I've restarted the syzbot on top of "hwrng: virtio - don't wait on
> > > cleanup" [1] and the problem has not been triggered.
> > > 
> > > See https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
> > 
> > The problem seems to be introduced by the last patch:
> > 
> > "hwrng: virtio - always add a pending request"
> 
> I think I understand the problem.
> 
> As we check data_avail != 0 before waiting on the completion, we can have a data_idx != 0.
> 
> The following change fixes the problem for me:
> 
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -52,6 +52,8 @@ static void request_entropy(struct virtrng_info *vi)
>         struct scatterlist sg;
> 
>         reinit_completion(&vi->have_data);
> +       vi->data_avail = 0;
> +       vi->data_idx = 0;
> 
>         sg_init_one(&sg, vi->data, sizeof(vi->data));
> 
> 
> MST, do you update the patch or do you want I send a new version?
> 
> Thanks,
> Laurent

New version of the patchset pls, and note in the changelog
that just this patch changed.

-- 
MST

