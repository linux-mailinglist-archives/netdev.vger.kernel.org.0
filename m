Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742BF1A7170
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 05:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404397AbgDNDEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 23:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404366AbgDNDE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 23:04:28 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C80C0A3BDC;
        Mon, 13 Apr 2020 20:04:28 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d24so4142674pll.8;
        Mon, 13 Apr 2020 20:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MbvabF+u187/8EV2YdBjNnt4DxiMyQXxB4Yc+xwJZGU=;
        b=FxBn4PQ0DFtrMoHimfSFsDx/X9SjvRXmnk2cbxPMT73e9GF9QEW0EWppbNhbnfYp0N
         st8Yr8lxYXHunzr9IpY17Zo5wN9h8U3z5MVuuEOT34bu4LdInJ8yddgQFZuW3K7h9tXG
         yddGBxyAaF2/NdwZQqdeKw2PughfqRDFxxw/gu7mEMHQL2noCNgbx4UINPm/wbKKe/uL
         y5qEW8yCEnv+QHH36hPyEGIs7joavBct4HA2jy+KQaKOUeGW32GuG76Vx7IeygCZvX4A
         x0i28w746D+CqyvSXTcDea+dkZcZZVOd+YCNmX221DeGzrgM7KVO6LqL+3uvOJb41oUU
         e6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MbvabF+u187/8EV2YdBjNnt4DxiMyQXxB4Yc+xwJZGU=;
        b=OVNbYd/NhQXSKu2mPU5783842nr/aJ6//X6gWKRPPH8zQB7Y6K2S+9JMfZj+troIgV
         tyhiO74xR5RNmh80jMeWxJWkGm1Ym1XOQ/M7NLXPjUuiAHF7g99QaPr6nU7aqzvKPUXc
         O9eWbVlSR14prX3rPLUJFms+LAm8wQ5yAsrlsH3DM0IHvAYjqBmx2cR2hZQ8DGxKQyaQ
         Ct6V+8OMgTNyrJTrDGobdwAKj3nMmFYVOaHu5KBTvCBPellnKM39TSzzs2MZOdKxPI6D
         R4AHKiI+PlLNv0A/cfR2kEod6vPCLroysRc9DGnbXLRghHBHVcTsBJUQ/TMojEonrC8a
         BfhA==
X-Gm-Message-State: AGi0PubWgZJhUGUjdEofCKTbDR8P4EmOYxSxFRvwvyrNTmSIaFexlqB8
        jOv3AfCXfWn+pdM47MOC/o8=
X-Google-Smtp-Source: APiQypJPkQmnxtG1lEbeRXgMFRrsBEkOfHSOsk75roTbEUJ3/Fo8ymHpbat9TXt2hsLyjGmgOV3JHQ==
X-Received: by 2002:a17:90b:4d04:: with SMTP id mw4mr25316154pjb.180.1586833468329;
        Mon, 13 Apr 2020 20:04:28 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:23b9])
        by smtp.gmail.com with ESMTPSA id g11sm150735pgi.63.2020.04.13.20.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 20:04:27 -0700 (PDT)
Date:   Mon, 13 Apr 2020 20:04:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: BPF program attached on BPF map function (read,write) is not
 working?
Message-ID: <20200414030424.csky65wqjzxpklzx@ast-mbp.dhcp.thefacebook.com>
References: <CAEKGpzh3drL1ywEfnJWhAqULcjaqGi+8GZSwG9XV-iYK4DnCpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEKGpzh3drL1ywEfnJWhAqULcjaqGi+8GZSwG9XV-iYK4DnCpA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 09, 2020 at 12:26:37PM +0900, Daniel T. Lee wrote:
> 
> So, I think this 'unable to attach bpf program on BPF map function (read,write)'
> is a bug. Or is it desired action?

desired action.

> If it is a bug, bpf_{enable|disable}_instrumentation() should only
> cover stackmap
> as the upper commit intended. Not sure but adding another flag for
> lock might work?
> 
> Or if this is an desired action, this should be covered at
> documentation with a limitation
> and tracex6 sample has to be removed.

Right. That test has to be fixed.
These two old commits:
commit 020a32d9581a ("bpf: add a test case for helper bpf_perf_event_read_value")
commit 41e9a8046c92 ("samples/bpf: add tests for more perf event types")
attached kprobe bpf to inner map accessors get_next and lookup.
That's safe only for a subset of map types and not allowed in general.
It works for hash and array because they don't take locks in these operations.
