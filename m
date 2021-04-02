Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DB6352F82
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 21:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhDBTIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 15:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBTIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 15:08:15 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433C8C0613E6;
        Fri,  2 Apr 2021 12:08:13 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id c17so4121664pfn.6;
        Fri, 02 Apr 2021 12:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P6/8i5KYWBwtKewMiq4TVS1lrndCLrJeUPK5dwemxFM=;
        b=TntiS3Fs12b1MOrQAQJtAYmrceTL6VNqagyxw/qoTckayCCYX+nxjIhDtJPAYIzDVs
         XJSV6rOq8Q0dCkge1pxfqwF1/sPeCfHj9ehl/vnZT+UUkA02orlemYpbb7+B2/VOdD5d
         KnL+9+nxzwtD7jakueMhVHgR89Y5CVwGjBZ08vFmW+HVY8C5qm1a845PbWIF0a3iwpa8
         tUGHU0NvGizDy4C4k8cRS/idPwQPH+daPy0OMeyl7rBbu6V7AfdqWwm/kZbaGCCOtdD7
         VdnWoYNrJpIu71tN00MqoiEi/7NdKFpsO2liqxIJB5XYwKKIsDOIe3Kj+lKgXPwYx5Ns
         nzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P6/8i5KYWBwtKewMiq4TVS1lrndCLrJeUPK5dwemxFM=;
        b=fi7XvXo0kXt6q0JcwG7oZ79WZe8AgHDuDjn2viUR7fvhUEaiI0UlPzdwS7UEx3PvFk
         s5H9Nfiw34wHjajrXYzKC5H1BscknfWlJYJBjiWpzPnH2JvxvKSSOoygVBbwU95yo8g9
         k6DaOu82vULhmrj1cTaLADZSVhRTf/KzJURcydJlfDJePzveYQ59TK2AbJx5uKnN2qXW
         71iyPH7E8ijtYP1Jp8o8biltWcHu4BBMSmsNfsNuHfYgzAimvW5YsbVdccuLcU2umm72
         MwA5T4LY4LJtyE2ZctNpRDww2tY7uFsKIw9IGuyEmX+Pn8/TirOyUzCqL8zn4Tc9TjkC
         VE7Q==
X-Gm-Message-State: AOAM5308cskjiiaKk5GHT+XraQi64raSq0/JOXYPr01qfjM1zDFBmYKn
        NDM0SwEWzGGTtpIgJ6Tq8ocf3e60km0rbA==
X-Google-Smtp-Source: ABdhPJz25seraxy07Imz6KaRoG0kPQpZqaCFhF5Ayb89Y9TeOvdSu9ff+SFq49eH/nFxal4lPwe4YA==
X-Received: by 2002:a63:79c6:: with SMTP id u189mr12942397pgc.154.1617390492540;
        Fri, 02 Apr 2021 12:08:12 -0700 (PDT)
Received: from localhost ([112.79.204.47])
        by smtp.gmail.com with ESMTPSA id k13sm8773580pfc.50.2021.04.02.12.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 12:08:12 -0700 (PDT)
Date:   Sat, 3 Apr 2021 00:38:06 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
Message-ID: <20210402190806.nhcgappm3iocvd3d@apollo>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo>
 <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net>
 <20210331094400.ldznoctli6fljz64@apollo>
 <5d59b5ee-a21e-1860-e2e5-d03f89306fd8@iogearbox.net>
 <20210402152743.dbadpgcmrgjt4eca@apollo>
 <CAADnVQ+wqrEnOGd8E1yp+1WTAx8ZcAx3HUjJs6ipPd0eKmOrgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+wqrEnOGd8E1yp+1WTAx8ZcAx3HUjJs6ipPd0eKmOrgA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 12:02:14AM IST, Alexei Starovoitov wrote:
> On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > [...]
>
> All of these things are messy because of tc legacy. bpf tried to follow tc style
> with cls and act distinction and it didn't quite work. cls with
> direct-action is the only
> thing that became mainstream while tc style attach wasn't really addressed.
> There were several incidents where tc had tens of thousands of progs attached
> because of this attach/query/index weirdness described above.
> I think the only way to address this properly is to introduce bpf_link style of
> attaching to tc. Such bpf_link would support ingress/egress only.
> direction-action will be implied. There won't be any index and query
> will be obvious.

Note that we already have bpf_link support working (without support for pinning
ofcourse) in a limited way. The ifindex, protocol, parent_id, priority, handle,
chain_index tuple uniquely identifies a filter, so we stash this in the bpf_link
and are able to operate on the exact filter during release.

> So I would like to propose to take this patch set a step further from
> what Daniel said:
> int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
> and make this proposed api to return FD.
> To detach from tc ingress/egress just close(fd).

You mean adding an fd-based TC API to the kernel?

> The user processes will not conflict with each other and will not accidently
> detach bpf program that was attached by another user process.
> Such api will address the existing tc query/attach/detach race race conditions.

Hmm, I think we do solve the race condition by returning the id. As long as you
don't misuse the interface and go around deleting filters arbitrarily (i.e. only
detach using the id), programs won't step over each other's filters. Storing the
id from the netlink response received during detach also eliminates any
ambigiuity from probing through get_info after attach. Same goes for actions,
and the same applies to the bpf_link returning API (which stashes id/index).

Do you have any other example that can still be racy given the current API?

The only advantage of fd would be the possibility of pinning it, and extending
lifetime of the filter.

> And libbpf side of support for this api will be trivial. Single bpf
> link_create command
> with ifindex and ingress|egress arguments.
> wdyt?

--
Kartikeya
