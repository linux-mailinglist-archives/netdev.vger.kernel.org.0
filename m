Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0BE376B5D
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 22:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhEGVAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 17:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhEGVAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 17:00:18 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222B9C061574;
        Fri,  7 May 2021 13:59:17 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id q127so9941062qkb.1;
        Fri, 07 May 2021 13:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WM3qTdeeeQvN9wqJqOAh1ks+lZ+P1gcdIZXNpOTonrc=;
        b=r+Rn1FuazZF3GatZUdqZ9l+FO+YTxA1D3YJlPcigoUO/F7/3KKxnkKe8ET7nEtAaih
         h6fBoqyszKYVFnDS+WIP+vKhSBconGErn5q6t57LNyLRSMcUsTeSRHebj6zjsqnU8x91
         x0LcaPNDgX8NgwJDE+oQh/NazmWbYdiuBHCUfHS5bzAcrnOI8eVAd750FcUke5aERvyk
         RyJfEPfKen91mYgLYXsAZnWv3MdAYzlzFwN7wIWnOJ841tOYm5RbkLFP9VKshPpvdoKI
         PnUzOkCTWO4flAD3dS69vOC0XZLegxH4D7oQ0YhZ3bJhNRecuxNpozapdS0JCFX0VV/K
         EdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=WM3qTdeeeQvN9wqJqOAh1ks+lZ+P1gcdIZXNpOTonrc=;
        b=Rm6cV4AcgVr0g/9YbwdzM5XE3Pw6BHDCVhcO/VDK1DlXL8VMaXbd3riaSpeiDzVo44
         pm9f+rWu6oCNhI9t31M7M2pYW2CwV/kRJVvuEWdlxrXJWsgpjiQZ7BS34mbP4WHZOL0G
         YWIiXN/4xOnNVYtzQoArrWKRqvbT7Yqs7qs29qGPj6F2XsH8b1thZG4hQwbo/PTUkLax
         a0NsGl8ZLMYbJw4bxl9NLYs39sDE1HiHIQ0nmm2N7ngvKG37ieV99wCQ1Wmn5GNKjfLN
         SELZNoz+zbLjTaietR2wjijQ+rY/RjyGp3KCc9s8z8KYW8hhUB9haV5qGg7Qe6NN1X0S
         6tdQ==
X-Gm-Message-State: AOAM532S+1AdQAa+NPVn8/cbN18DcPLYWAwijeEaTXu05D3JzQcS829a
        XllG4bPIk82ILYUo+5aQ3z4=
X-Google-Smtp-Source: ABdhPJxyjJaPUgZZ5DfuESF5Im6k2ukuj2Fa/7dXtcMZSkR/HegPBCpoXKWS0kZr+E66ksFX99ZGJQ==
X-Received: by 2002:a37:8c1:: with SMTP id 184mr11654363qki.345.1620421155940;
        Fri, 07 May 2021 13:59:15 -0700 (PDT)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [199.96.183.179])
        by smtp.gmail.com with ESMTPSA id e13sm5982704qtm.35.2021.05.07.13.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 13:59:14 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 7 May 2021 16:59:13 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>, Kenny Ho <y2kenny@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kenny Ho <Kenny.Ho@amd.com>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Brian Welty <brian.welty@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Network Development <netdev@vger.kernel.org>,
        KP Singh <kpsingh@chromium.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Message-ID: <YJWqIVnX9giaKMTG@slm.duckdns.org>
References: <YJUBer3wWKSAeXe7@phenom.ffwll.local>
 <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
 <YJVnO+TCRW83S6w4@phenom.ffwll.local>
 <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
 <YJVqL4c6SJc8wdkK@phenom.ffwll.local>
 <CADnq5_PHjiHy=Su_1VKr5ycdnXN-OuSXw0X_TeNqSj+TJs2MGA@mail.gmail.com>
 <CADnq5_OjaPw5iF_82bjNPt6v-7OcRmXmXECcN+Gdg1NcucJiHA@mail.gmail.com>
 <YJVwtS9XJlogZRqv@phenom.ffwll.local>
 <YJWWByISHSPqF+aN@slm.duckdns.org>
 <CADnq5_Mwd-xHZQ4pt34=FPk2Gq3ij1FNHWsEz1LdS7_Dyo00iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_Mwd-xHZQ4pt34=FPk2Gq3ij1FNHWsEz1LdS7_Dyo00iQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, May 07, 2021 at 03:55:39PM -0400, Alex Deucher wrote:
> The problem is temporal partitioning on GPUs is much harder to enforce
> unless you have a special case like SR-IOV.  Spatial partitioning, on
> AMD GPUs at least, is widely available and easily enforced.  What is
> the point of implementing temporal style cgroups if no one can enforce
> it effectively?

So, if generic fine-grained partitioning can't be implemented, the right
thing to do is stopping pushing for full-blown cgroup interface for it. The
hardware simply isn't capable of being managed in a way which allows generic
fine-grained hierarchical scheduling and there's no point in bloating the
interface with half baked hardware dependent features.

This isn't to say that there's no way to support them, but what have been
being proposed is way too generic and ambitious in terms of interface while
being poorly developed on the internal abstraction and mechanism front. If
the hardware can't do generic, either implement the barest minimum interface
(e.g. be a part of misc controller) or go driver-specific - the feature is
hardware specific anyway. I've repeated this multiple times in these
discussions now but it'd be really helpful to try to minimize the interace
while concentrating more on internal abstractions and actual control
mechanisms.

Thanks.

-- 
tejun
