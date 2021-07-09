Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066F53C1DF2
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 05:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhGIDzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 23:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhGIDzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 23:55:37 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF60C061574;
        Thu,  8 Jul 2021 20:52:54 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h1so4319688plf.6;
        Thu, 08 Jul 2021 20:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TM/0jwFZF0MmFPnIVVOWW7BfdA5pgZ+Dgbp4szXA2Dc=;
        b=GkbgHBUZ/U8YO4X/gVA6WeVDCJ47faIUUv5GIG6YLR2BuVBm/gbF5QKmZJCDtqQeNL
         S0TwSGk7jrmSBYhdR8L7HQJKkLXU+TDU6QSppDvfGZEsSaB/TP2WcVNo5YoFf6RCMpzW
         HUk3igOsK5hV/oukFNNPd0LnAQTIyUoWA+DviPzki/WUnmATZcnoHLYGAm+524UNJbyM
         EjEkc1pdTFk+Nu+Tu/GPmgjy5b4JI/eJ55nO52P1RoOS0uiiAVc9tnQPFs1t9sfCgzvg
         02FhVgNvf0m4I2vCIVtMsqXM95sx0uE5Cj0x8quK9ifye2+n7r/e+74MGOkRmPuKuOQF
         j7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TM/0jwFZF0MmFPnIVVOWW7BfdA5pgZ+Dgbp4szXA2Dc=;
        b=c3uUkbHTb5TAvogtFMFmMO6FeqLF/8uQ0UGeIzVc6TWbXsp7Xv/TSpyuriRDjv5J92
         wcnp6KGk1sZSztCFDsDn7r2m3ufEymPMp1pnyDGMGK84MMiiGiBmAiYwCsWZU+P0TSr/
         EYyy491uJQ2OSKUoLkHXnaamK2XN8lq6fZQlHpib4fF91KkFCE6ru0+UUU2J/6DE3ici
         dbVRDjKE6A1EA6rup3mS91bISibK7vDFZdmG5EwBOaC4BOIQI84wnTU9YDjp/IIoVDSM
         6WmxWMR3h7neIKZfxSVHQvNyqR4SgdzPUTI2XV+fmkF4ptEE8DH+peEbRBfnjLWgoMO5
         KzSQ==
X-Gm-Message-State: AOAM531qqC+Xl/rIfbPhv6q/Lq0NtsR5G/vg4eM1KF28HaTnliL2J2P5
        5gxRaftQD7fSmlj2WvsaLUo=
X-Google-Smtp-Source: ABdhPJwlpdqXWRSBufBzP0EDSuKWhddz9tcpJ6kZBKwCU0pP1XX0GAprCIuYo41pmkkt0YoXMvh3cg==
X-Received: by 2002:a17:903:31d1:b029:120:2863:cba2 with SMTP id v17-20020a17090331d1b02901202863cba2mr29234455ple.28.1625802773776;
        Thu, 08 Jul 2021 20:52:53 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:7cf7])
        by smtp.gmail.com with ESMTPSA id s15sm4495506pfu.97.2021.07.08.20.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 20:52:53 -0700 (PDT)
Date:   Thu, 8 Jul 2021 20:52:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v5 bpf-next 00/11] bpf: Introduce BPF timers.
Message-ID: <20210709035250.tk35xdptiawpnu4x@ast-mbp.dhcp.thefacebook.com>
References: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
 <20210709015949.afjbtppsn54ebdrr@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709015949.afjbtppsn54ebdrr@kafai-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 06:59:49PM -0700, Martin KaFai Lau wrote:
> On Wed, Jul 07, 2021 at 06:18:22PM -0700, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> > 
> > The first request to support timers in bpf was made in 2013 before sys_bpf syscall
> > was added. That use case was periodic sampling. It was address with attaching
> > bpf programs to perf_events. Then during XDP development the timers were requested
> > to do garbage collection and health checks. They were worked around by implementing
> > timers in user space and triggering progs with BPF_PROG_RUN command.
> > The user space timers and perf_event+bpf timers are not armed by the bpf program.
> > They're done asynchronously vs program execution. The XDP program cannot send a
> > packet and arm the timer at the same time. The tracing prog cannot record an
> > event and arm the timer right away. This large class of use cases remained
> > unaddressed. The jiffy based and hrtimer based timers are essential part of the
> > kernel development and with this patch set the hrtimer based timers will be
> > available to bpf programs.
> > 
> > TLDR: bpf timers is a wrapper of hrtimers with all the extra safety added
> > to make sure bpf progs cannot crash the kernel.
> Looked more closely from 1-6.  Left minor comments in patch 4.
> The later verifier changes make sense to me but I won't be very useful there.

Thanks a lot for detailed code review. Much appreciate it!
