Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CE52289BD
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgGUUVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGUUVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:21:12 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BACFC061794;
        Tue, 21 Jul 2020 13:21:12 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gc9so2098715pjb.2;
        Tue, 21 Jul 2020 13:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EDx5ZK+29kRWYJMGWyvrhwCnEqcR3vRhDKLN0w1LGwo=;
        b=uye3eYU52p0FszeQsbTHkxAmWAynFNUDjKPvs3VdlGUd9Vwb6HbPlR+UFraZGZvJQl
         rlVBeAL3kcQimdsLgH69eWSUdQFpIab8Sksh/PCBGHf49O94brXhoeAOysbtAdudTYWc
         mL19MgfRyazsZLEVZsyDs0mtVlYDswAbwFipqy88ZDQ+sTbNqy7XwAImSqOhwwns+s/z
         CuAhMZjp9AxvJznWpSvK3i+qrJsciBlegkTackt6Ry1vinxnFVX6Lsy6Ty9AMVG2hfTH
         T4cxg28LuAepp41Q+mpOy3vLT+/YRv563kjV6/qf7tnbRfA8/VW+1forYwB7AhXXesPH
         nJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EDx5ZK+29kRWYJMGWyvrhwCnEqcR3vRhDKLN0w1LGwo=;
        b=K7I2JYkwFLUYgHUbPB/YTtGNZQ3ELobgpwXmfWQ0bh46o+/VxyC7XApCukEJghcSEG
         9503C0MSmEN7gkjfHHiAw9m5JYY3mifrR++647yMiM4oVnClD1+fitKPcRKcHl2ifK+x
         iNKPAvB9BqJo7N9U/EncxAITsraqwIGBBRX677O6tkPVU8bWXloPmaeNBwJIgNtawJax
         e/+gUXFfX0UjvSukXafaJuUefmZN5EC1W0VmchkEzgErVZk9m+/1UWId+VbSJ3kd6T5/
         w9w5pkdEKeEeVQrPHq4wmltfUP6Al+2v6yriH/gN9CvqDR/l1NXuxkrRXAabjx0q/mxW
         RB+Q==
X-Gm-Message-State: AOAM531+HNpc50Z6zyMzc55KWl0XWuwa66FAfVbmErQdolrAVxCfrUdm
        xWervVNMkbzRDodOSnzib5E=
X-Google-Smtp-Source: ABdhPJxg9thj7QDLcyID8qlO4d9P3h86DB2rePZe/TP0afx/rxQPNJ61NtiwJ4dm5qCi/3nb3MiYcQ==
X-Received: by 2002:a17:902:7483:: with SMTP id h3mr22709694pll.114.1595362871798;
        Tue, 21 Jul 2020 13:21:11 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e3b])
        by smtp.gmail.com with ESMTPSA id b128sm21313668pfg.114.2020.07.21.13.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 13:21:11 -0700 (PDT)
Date:   Tue, 21 Jul 2020 13:21:08 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v2 0/5] bpf: compute btf_ids at build time for
 btf_iter
Message-ID: <20200721202108.btao7fx3qf3ndd2b@ast-mbp.dhcp.thefacebook.com>
References: <20200720163358.1392964-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720163358.1392964-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 09:33:58AM -0700, Yonghong Song wrote:
> Commit 5a2798ab32ba
> ("bpf: Add BTF_ID_LIST/BTF_ID/BTF_ID_UNUSED macros")
> implemented a mechanism to compute btf_ids at kernel build
> time which can simplify kernel implementation and reduce
> runtime overhead by removing in-kernel btf_id calculation.
> 
> This patch set tried to use this mechanism to compute
> btf_ids for bpf_skc_to_*() helpers and for btf_id_or_null ctx
> arguments specified during bpf iterator registration.
> Please see individual patch for details.
> 
> Changelogs:
>   v1 -> v2:
>     - v1 ([1]) is only for bpf_skc_to_*() helpers. This version
>       expanded it to cover ctx btf_id_or_null arguments
>     - abandoned the change of "extern u32 name[]" to
>       "static u32 name[]" for BPF_ID_LIST local "name" definition.
>       gcc 9 incurred a compilation error.
> 
>  [1]: https://lore.kernel.org/bpf/20200717184706.3476992-1-yhs@fb.com/T

Applied, Thanks
