Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FAE37989E
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 22:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhEJU42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 16:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbhEJU41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 16:56:27 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741DDC061574
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 13:55:22 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id l129so16783257qke.8
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 13:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RGWzCQVatHggFsYh9q34QYS59ND04ThXP8WgUV/pEQo=;
        b=NvqNlQ+DDbdBm4PQsI9Rf18EL3NQ1+HDnh2o5Ho0fmEFDCCvjwj/BAyVm/e9Y1Hatb
         qGaYbRKBo7W75jC+Ns6BFLrYDKh5Vm1YG4PK2ilLONCNhke1OFkzjZ3uQcsiZQ2GvuAd
         QqWp9uli1ij9jb8LSszRHsVS/dosPcXNiVJjc/+6iEN1ugrSbxYbJB6yCNuekL2IQZh2
         /7Yv6iZBFbLlpNP17hMdShVm7zscu5lDJah4eWA46/opLyMRyUSImEXln4tAprvCqIun
         XHSRBjFTlNgfxDJq6TnxVDZa9mXq9mJ7Uex0s+EoTPUSvO1+b+n9WJ8eV7/pd5S0uL5z
         8gHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RGWzCQVatHggFsYh9q34QYS59ND04ThXP8WgUV/pEQo=;
        b=WAlcMoHNQho9eGPuTZscK2tVTipnRf7fJbX0byoB8ofEQgSgm1Jksu+XFUNpZ+IxxC
         4OQEfv4JTddLjJaS1grDHGLjz4zuTvOkYr0Y91lOxcgWV/qhotBsaGc56MVm/cxwqPLD
         6PI/2dfLEJvtplprjKjU+ZSyf42meYBVCZ7jIEIYWl5gFEg7cBwfSznXkgAvttLkMe/s
         czj24qBEdQkd/FTmZEzZZyzXav2zFlpqY4CzQvk6F+P/+qi6cv/kGalb7hXO7EgUpnpi
         +y3Phm7ijUvHr0FUAO9w/NeXsCRuEtyrwTSBPFn9JiWADwoNHtisPlfjYh2Mh5WFle9p
         gjaA==
X-Gm-Message-State: AOAM533ekGItKT81Ikho5i5LZDiwPm3UjZFRrtRTbdexADN4/XBdTbUp
        CkOTwaX4K7y7lCyRiwW+LEoJFw==
X-Google-Smtp-Source: ABdhPJx8UMhHJ3bftanNqNCxlCjWbLJKkAg4Vh55zf374HWPYLhBC2zUqqg5AJQmlGhETIl6tik3qA==
X-Received: by 2002:a37:9281:: with SMTP id u123mr21499190qkd.447.1620680121729;
        Mon, 10 May 2021 13:55:21 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-25-174-95-97-70.dsl.bell.ca. [174.95.97.70])
        by smtp.googlemail.com with ESMTPSA id r10sm12788024qke.9.2021.05.10.13.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 13:55:20 -0700 (PDT)
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Joe Stringer <joe@cilium.io>
References: <20210402192823.bqwgipmky3xsucs5@ast-mbp>
 <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp>
 <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
 <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
 <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
 <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpVE4XG7SPAVBmV2UtqUANg3X-1ngY7COYC03NrT6JkZ+g@mail.gmail.com>
 <CAADnVQK9BgguVorziWgpMktLHuPCgEaKa4fz-KCfhcZtT46teQ@mail.gmail.com>
 <CAM_iQpWBrxuT=Y3CbhxYpE5a+QSk-O=Vj4euegggXAAKTHRBqw@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <d38c7ccf-bc66-9b71-ef96-7fe196ac5c09@mojatatu.com>
Date:   Mon, 10 May 2021 16:55:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWBrxuT=Y3CbhxYpE5a+QSk-O=Vj4euegggXAAKTHRBqw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-09 1:37 a.m., Cong Wang wrote:
> On Tue, Apr 27, 2021 at 11:34 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:


[..]
> I am pretty sure I showed the original report to you when I sent
> timeout hashmap patch, in case you forgot here it is again:
> https://github.com/cilium/cilium/issues/5048
> 
> and let me quote the original report here:
> 
> "The current implementation (as of v1.2) for managing the contents of
> the datapath connection tracking map leaves something to be desired:
> Once per minute, the userspace cilium-agent makes a series of calls to
> the bpf() syscall to fetch all of the entries in the map to determine
> whether they should be deleted. For each entry in the map, 2-3 calls
> must be made: One to fetch the next key, one to fetch the value, and
> perhaps one to delete the entry. The maximum size of the map is 1
> million entries, and if the current count approaches this size then
> the garbage collection goroutine may spend a significant number of CPU
> cycles iterating and deleting elements from the conntrack map."
> 

That cilium PR was a good read of the general issues.
Our use case involves anywhere between 4-16M cached entries.

Like i mentioned earlier:
we want to periodically, if some condition is met in the
kernel on a map entry, to cleanup, update or send unsolicited
housekeeping events to user space.
Polling in order to achieve this for that many entries is expensive.

I would argue, again, timers generally are useful for a variety
of house keeping purposes and they are currently missing from ebpf.
Again, this despite Cong's use case.
Currently things in the ebpf datapath are triggered by either packets
showing up or from a control plane perspective by user space polling.
We need the timers for completion.

cheers,
jamal
