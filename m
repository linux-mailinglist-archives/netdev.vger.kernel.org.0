Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FFF376ABE
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 21:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhEGTed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 15:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhEGTeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 15:34:31 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDEEC061574;
        Fri,  7 May 2021 12:33:30 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id q136so9637448qka.7;
        Fri, 07 May 2021 12:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DQeWsUe4sdL5lwcQgjwlYsUvqoVq4rgrGbWAxTRdzK0=;
        b=nGfiv21ZL8q5oVm8kipMoDb98KQPA4A9rngwmvXuqZnlY2cy9b/IbHGzKHuZ9/55Wg
         5rUH8L/Fu3n0B4hrJZ4B93X2HYBnLD/Lgrm+C58moHKKCT11Xw3AzGWg6CLYIhGjw2Lb
         sxBYCIrVWBFMASbtLYqc786mHo8oNlZnIRDVF7rJuoTPbfyqlnOLZqZwAyqypSouggs0
         yp2jIiV6O9MndUS/Sv9UxT6tVTL3ZezUAQZha9GS2GhAs+s2h+T3kfrqksj93rZHFqQj
         XaLXEGcaw6eFzEOZzgOS8jX+XQ3V8bvJnHAMEhXK/akANXg9UkdyK8Suaox+MyCAwzH0
         cAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=DQeWsUe4sdL5lwcQgjwlYsUvqoVq4rgrGbWAxTRdzK0=;
        b=rtCE5QK/6MJi2tyK62fjz022UfNIoeDMEqGr6VNpJWI9SDMW7D+wzsFwniFw0VBgh6
         Lu+QbEPaX6wJgfTU5ZPlh5arylfsGerzsPpLz15c/8YO10JsXIZfaWk1gW5SkujDEQMv
         of0+wILtJU9FMOI50+UBj4jbBj2Raw2clf3k+pmMnTELNBhiq5PE31V7gP/M1evM4pas
         h9r0vNY+K8cGTAB46LzqUqUXMC3orDlzdNXPpLpSAS7ax6ssdg0AVoDdAw6+AS2Ce9Gu
         BRoDZOytUZa9AWNbomb8vQcIlYWJNtW9KTvWeUO8AvsePu2BWA5ywNCFBRDJSDCtyklD
         S1Qg==
X-Gm-Message-State: AOAM531KZMC9+qncvoENwznre5K7fkDH2IzEp5MLwRNev94gH+L7WRfB
        fA0lYyucueiER60S9JW8x/w=
X-Google-Smtp-Source: ABdhPJw2cRhG8UHN8LXnIN2dTKp9oF06g5FI6Zqbk2WI27UC68arv2TLcX2Slci/J4LFn7amAwSThw==
X-Received: by 2002:a37:4496:: with SMTP id r144mr11246241qka.242.1620416009423;
        Fri, 07 May 2021 12:33:29 -0700 (PDT)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [199.96.183.179])
        by smtp.gmail.com with ESMTPSA id r9sm5626187qtf.62.2021.05.07.12.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 12:33:28 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 7 May 2021 15:33:27 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Alex Deucher <alexdeucher@gmail.com>, Kenny Ho <y2kenny@gmail.com>,
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
Message-ID: <YJWWByISHSPqF+aN@slm.duckdns.org>
References: <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
 <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw@mail.gmail.com>
 <YJUBer3wWKSAeXe7@phenom.ffwll.local>
 <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
 <YJVnO+TCRW83S6w4@phenom.ffwll.local>
 <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
 <YJVqL4c6SJc8wdkK@phenom.ffwll.local>
 <CADnq5_PHjiHy=Su_1VKr5ycdnXN-OuSXw0X_TeNqSj+TJs2MGA@mail.gmail.com>
 <CADnq5_OjaPw5iF_82bjNPt6v-7OcRmXmXECcN+Gdg1NcucJiHA@mail.gmail.com>
 <YJVwtS9XJlogZRqv@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJVwtS9XJlogZRqv@phenom.ffwll.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, May 07, 2021 at 06:54:13PM +0200, Daniel Vetter wrote:
> All I meant is that for the container/cgroups world starting out with
> time-sharing feels like the best fit, least because your SRIOV designers
> also seem to think that's the best first cut for cloud-y computing.
> Whether it's virtualized or containerized is a distinction that's getting
> ever more blurry, with virtualization become a lot more dynamic and
> container runtimes als possibly using hw virtualization underneath.

FWIW, I'm completely on the same boat. There are two fundamental issues with
hardware-mask based control - control granularity and work conservation.
Combined, they make it a significantly more difficult interface to use which
requires hardware-specific tuning rather than simply being able to say "I
wanna prioritize this job twice over that one".

My knoweldge of gpus is really limited but my understanding is also that the
gpu cores and threads aren't as homogeneous as the CPU counterparts across
the vendors, product generations and possibly even within a single chip,
which makes the problem even worse.

Given that GPUs are time-shareable to begin with, the most universal
solution seems pretty clear.

Thanks.

-- 
tejun
