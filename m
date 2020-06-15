Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F6B1FA2D8
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 23:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731463AbgFOVe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 17:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgFOVe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 17:34:28 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283AAC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 14:34:26 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id i1so113655ils.11
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 14:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/e/joKbEMcHd6U6CARSeFzkVEyiqoy5WnN3MLN4i0PE=;
        b=GCkLHth+zz+aChJA2ZiqDPVh/fTagtWHvXiaZPf8BnRfOtBlnESwd8q3xCPGC8TdDX
         TT6QjxKzcI7AbKcownlcw4oye1f/a+CVf2r6poo1erVBn6JdfGmwM+INzSnKqVWnoWko
         GSSrDg0QDcJibnTnbWv2gjBRHcivArsDhSHGJMjI2k0LHwiAufyXX9qzZ/fYU2VMBIt4
         tfrWoGnaxMLy+58Ce+9JyPetmmDt2JsB54V+EcHFDgeU6PrLpDXwFN0wXN+c8KSAuubC
         YTvAcFpiV5vcLCebCKUpCx27ZVaOYAJ8i3TEm3CI14/PH2hkC32P/2+5fi6xXCkmgjp2
         Ru6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/e/joKbEMcHd6U6CARSeFzkVEyiqoy5WnN3MLN4i0PE=;
        b=mps68tigYo6M3MBEDmF1yTgCE6LX5XGSsF18g30IKzoFc2Sdm4SYH+eEKUiVeeEC5V
         SXZEgnS3uKl3TQuvBrXZSaWDDwD1tg9WzopHQzaYprhwybXTuSHf4iupcRJQiGw4qS6A
         sxbUGSBnQ/0t6i5UExAcx6c21L29x5qeMOIEIO+dCqNu18CVDN8tDJY9pnmWbVAT3AwE
         IDO3SKoDqZCEsF6eZgsRpIWC9YK1Rs2zWWcyrVRmGnHcMnKBlwWBWoX8EwTBSj/u6AzC
         jdTwhriZtgpMXnII/bp/MK+mhkcZ3ydX8+You6Bf0Uhov9pjJP7cIZFp2yy6ibImiu5A
         xKBw==
X-Gm-Message-State: AOAM531mnwIEO6I8X60AWoGJjOZJeliDW13IeOZPerkbE+SMuSg9VPXa
        lQJGCmsqo0gB+AdirkNUP2FxaBHGJba+0MbWhuQ=
X-Google-Smtp-Source: ABdhPJzwnjQE+axfcQQ96TCgTe9NDCRAzujGW5Xzb9Jt590AIs7ilrBRySuwoG16aiyuobId32+iFMfPqX66p3VI3Zw=
X-Received: by 2002:a92:5b15:: with SMTP id p21mr17898ilb.22.1592256865432;
 Mon, 15 Jun 2020 14:34:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAMtihapJKityT=urbrx2yq-csRQ4u7Vcosrf0NzUZtrHfmN0cQ@mail.gmail.com>
 <CAM_iQpUKQJrj8wE+Qa8NGR3P0L+5Uz=qo-O5+k_P60HzTde6aw@mail.gmail.com>
 <CAMtihaoxAPUgQTkhjmwjKHTdvz7r+SwDEXwhzyjVDXoNR0GKQQ@mail.gmail.com> <CAMtihapcPYn-tZyypwN8ZLMWGeqErC37gFtyLp9zv-mcmcn7eg@mail.gmail.com>
In-Reply-To: <CAMtihapcPYn-tZyypwN8ZLMWGeqErC37gFtyLp9zv-mcmcn7eg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 15 Jun 2020 14:34:14 -0700
Message-ID: <CAM_iQpXuNX+75gybo3Qo9HhiZVPaDgwo3oEQuRS-ExDZGRCUCQ@mail.gmail.com>
Subject: Re: BUG: kernel NULL pointer dereference in __cgroup_bpf_run_filter_skb
To:     =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 6:06 AM Dani=C3=ABl Sonck <dsonck92@gmail.com> wrot=
e:
>
> Op zo 14 jun. 2020 om 22:43 schreef Dani=C3=ABl Sonck <dsonck92@gmail.com=
>:
> >
> > Hello,
> >
> > Op zo 14 jun. 2020 om 20:29 schreef Cong Wang <xiyou.wangcong@gmail.com=
>:
> > >
> > > Hello,
> > >
> > > On Sun, Jun 14, 2020 at 5:39 AM Dani=C3=ABl Sonck <dsonck92@gmail.com=
> wrote:
> > > >
> > > > Hello,
> > > >
> > > > I found on the archive that this bug I encountered also happened to
> > > > others. I too have a very similar stacktrace. The issue I'm
> > > > experiencing is:
> > > >
> > > > Whenever I fully boot my cluster, in some time, the host crashes wi=
th
> > > > the __cgroup_bpf_run_filter_skb NULL pointer dereference. This has
> > > > been sporadic enough before not to cause real issues. However, as o=
f
> > > > lately, the bug is triggered much more frequently. I've changed my
> > > > server hardware so I could capture serial output in order to get th=
e
> > > > trace. This trace looked very similar as reported by Lu Fengqi. As =
it
> > > > currently stands, I cannot run the cluster as it's almost instantly
> > > > crashing the host.
> > >
> > > This has been reported for multiple times. Are you able to test the
> > > attached patch? And let me know if everything goes fine with it.
> >
> > I will try out the patch. Since the host reliably crashed each time as
> > I booted up
> > the cluster VMs I will be able to tell whether it has any positive effe=
ct.
> > >
> > > I suspect we may still leak some cgroup refcnt even with the patch,
> > > but it might be much harder to trigger with this patch applied.
> >
> > Currently applying the patch to the kernel and compiling so I should
> > know in a few hours
>
> The compilation with the patch has finished and I've since rebooted to th=
e
> new kernel about 12 hours ago, so far this bug did not trigger whereas wi=
thout
> the patch, by this time it would have triggered. Regardless, I will keep =
my
> serial connection in case something pops up.

That is great. Please keep it running as this is a race condition which
is not easy to trigger reliably.

Thanks for testing!
