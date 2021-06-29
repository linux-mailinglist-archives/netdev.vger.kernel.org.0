Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C74F3B6C18
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 03:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhF2Bm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 21:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbhF2BmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 21:42:25 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C30C061574;
        Mon, 28 Jun 2021 18:39:58 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id s137so8190299pfc.4;
        Mon, 28 Jun 2021 18:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=O/ErM868FjVcnIZQ1/a6UobajAbqE8NQEQuGMLYOD5U=;
        b=RHuHNU2ghRnJvIjxWKz6GPZla+MZp61Jr1qdtzSp2+J+GNTn6yhcU0pcSYe11vXp8K
         ElML3JkFMEDSeaks4AVTaFCZhmlvYjuvESRIcKWJKNeQUgppkEnyRToZ5VehSGHwSG4E
         veHH6k9G0JCmrkEY5922qdxGyEyuurUywB0QU5PdFw3XreWXoGToi5ID9aW7hqh/Qo8s
         TAnlkGVaTuJaATWDoJojvm9/ZFoSZujrLBq+lWthMAavTnSYG4UDZUOnJqfJi14ulHQz
         pkfVCanbF0VHp0TX3bWz/V4pJz62vUPgAc+u+X5lNG5BAYvWd6AKV8wOuenZv7ov7IJ1
         AGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=O/ErM868FjVcnIZQ1/a6UobajAbqE8NQEQuGMLYOD5U=;
        b=AXZYEL/OQ3meGTHVASo9xsnIumv6+ok4HOGrFg6Ck+iTq87sKX0j6mN5bIlZbY8994
         AAn8+e93w/eBjMApY1STOL6/neHURSVe0FaI/EE5o8DPc/TudN+1aTyBhQl6VqLdT1Z6
         fFJ2k9unkACh5qbAltMnIolADgGxFb36R146tOtTAWnr1F9JtNV7dhDbojCscLGkyIT1
         ekhKbZVkI0klAnUFfVNdunUVAOJJpf4pbnsTf0EoGCvlLGBmPdazMC0RLKUV0gwHWoul
         R6cNXKMjlBBQK34j2uSX05oOf/MrauBGo0fc899E25sW+PI1jjxdVvrAi3E0GrTkggK6
         z2Jw==
X-Gm-Message-State: AOAM532wnglB2ZDRHzMhXmUDecJbjUIsJT/CozhUAbAwY86R6FUDVDc1
        5al4aI2/179bkf/Q7dV2FA4=
X-Google-Smtp-Source: ABdhPJzWuPYxPbGzrKbg06jDVeJOuEquPL6C2i1I7R4VErj3ilWHDs6A9oOM1hVj+XWXwo4i+K6Edw==
X-Received: by 2002:a63:dc4e:: with SMTP id f14mr25346328pgj.378.1624930797410;
        Mon, 28 Jun 2021 18:39:57 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:45ad])
        by smtp.gmail.com with ESMTPSA id 195sm15934943pfw.133.2021.06.28.18.39.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jun 2021 18:39:56 -0700 (PDT)
Date:   Mon, 28 Jun 2021 18:39:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@fb.com>, davem@davemloft.net,
        daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
Message-ID: <20210629013953.xzbfxwyjj6qqhhxn@ast-mbp.dhcp.thefacebook.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com>
 <4bf664bc-aad0-ef80-c745-af01fed8757a@fb.com>
 <de1204cc-8c20-0e09-8880-e39c9ee6d889@fb.com>
 <cfa10fa1-9ee4-95de-109d-a24cd5d43a98@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cfa10fa1-9ee4-95de-109d-a24cd5d43a98@fb.com>
User-Agent: NeoMutt/20180223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 08:54:55AM -0700, Yonghong Song wrote:
> 
> 
> On 6/25/21 7:57 AM, Alexei Starovoitov wrote:
> > On 6/24/21 11:25 PM, Yonghong Song wrote:
> > > 
> > > > +
> > > > +    ____bpf_spin_lock(&timer->lock);
> > > 
> > > I think we may still have some issues.
> > > Case 1:
> > >    1. one bpf program is running in process context,
> > >       bpf_timer_start() is called and timer->lock is taken
> > >    2. timer softirq is triggered and this callback is called
> > 
> > ___bpf_spin_lock is actually irqsave version of spin_lock.
> > So this race is not possible.
> 
> Sorry I missed that ____bpf_spin_lock() has local_irq_save(),
> so yes. the above situation cannot happen.

Yeah. It was confusing. I'll add a comment.

> > 
> > > Case 2:
> > >    1. this callback is called, timer->lock is taken
> > >    2. a nmi happens and some bpf program is called (kprobe, tracepoint,
> > >       fentry/fexit or perf_event, etc.) and that program calls
> > >       bpf_timer_start()
> > > 
> > > So we could have deadlock in both above cases?
> > 
> > Shouldn't be possible either because bpf timers are not allowed
> > in nmi-bpf-progs. I'll double check that it's the case.
> > Pretty much the same restrictions are with bpf_spin_lock.
> 
> The patch added bpf_base_func_proto() to bpf_tracing_func_proto:
> 
> Also, we have some functions inside ____bpf_spin_lock() e.g.,
> bpf_prog_inc(), hrtimer_start(), etc. If we want to be absolutely safe,
> we need to mark them not tracable for kprobe/kretprobe/fentry/fexit/...
> But I am not sure whether this is really needed or not.

Probably not.
I'll add in_nmi() runtime check to prevent nmi and kprobes.
