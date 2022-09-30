Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCF75F1436
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiI3UzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbiI3UzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:55:17 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5CF4F1AC;
        Fri, 30 Sep 2022 13:55:16 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id m3so7459557eda.12;
        Fri, 30 Sep 2022 13:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1K6Q0nQ5Q42g4z04WoQRYtpfm67biYFm2mWxuvCIHOg=;
        b=SlpVM0+LZ62XFANK16bQHLbikjK/JqKERbC2w9AnTEhvLIhcRRxnIsBQtmz9zQX3ob
         9h9dhCl6G4vLD8wsvGMaKJwVRoxGsPo5O5RFxmlLOvZKMdrAAWLyTghBzlhUsSKO6Gz2
         YWMhzPJTiaVo5I806ggo7ejuMMWpM6txhgt+duAy2Dh5aGpT+ApCh/NWZ8w+hg4PkIAE
         mWA+kLNtirYohN88y4+G5/LgmrPYAEUq40gG7VYx2xcZYlkx/Cm0hTSrJwcTlOhB0K+z
         kXeNFUZ1Bj7um2axCBiBEFXA2DfaYQYtu+6rUbZbsO9FziviHfyxIRfGD60/YGY42EVd
         LoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1K6Q0nQ5Q42g4z04WoQRYtpfm67biYFm2mWxuvCIHOg=;
        b=T4e3kCu+MfWc8E1UWxeQ8SueQaybeO23mnQOMp1MLqdX/VHVeXVqT3r4bhm7i1/FN/
         q4/+NpkptL9ZtyvQanQOllebt4XmVeEVLZdI5cVvvZC4NKBmyp9nPePIZVyZm3gODzZ1
         2d8F5KHu7uS7/EkeO/H50x61qJku7KuFSX3mZAM/xsQizUGy2D4i9g1RzVzgwyQApqq3
         qpzNlLmnt5XUhn8wRIq3pWTekzFiPWAf0h8ITZJiRleI+xu7v9slfJOuIFvNlHfmV3KB
         Vb0wktgwjGD6QUqYqmzAuBLLlyyCk8i6ktWauGnhkTzrtaxAzESts+j4GTcNpT3ntrOA
         +6/w==
X-Gm-Message-State: ACrzQf1+owx/Saj5fiOPlRxAiT4VS6yTogEVJVLSMLM7yh08CNRjQEvQ
        QsPPt+2cjL/v8KDoJvwN1QptrMhfJ9eWN69eXR1KzqdJ
X-Google-Smtp-Source: AMsMyM4w21D6+g+NYtAd21bjoLgpQkIkbF1JRstbzPza0hG03AHTy30/AcEhExNWT9pCsjRE6y0WIA0pR5dFurG2icU=
X-Received: by 2002:a50:eb05:0:b0:457:c6f5:5f65 with SMTP id
 y5-20020a50eb05000000b00457c6f55f65mr9082580edp.311.1664571314648; Fri, 30
 Sep 2022 13:55:14 -0700 (PDT)
MIME-Version: 1.0
References: <1664277676-2228-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1664277676-2228-1-git-send-email-wangyufen@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Sep 2022 13:55:02 -0700
Message-ID: <CAEf4BzaBPpZvxD6sDMWWRXVqKYTgwaxsggye0CRbv7q5_4jrPA@mail.gmail.com>
Subject: Re: [bpf-next v7 1/3] bpftool: Add auto_attach for bpf prog load|loadall
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     quentin@isovalent.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 4:00 AM Wang Yufen <wangyufen@huawei.com> wrote:
>
> Add auto_attach optional to support one-step load-attach-pin_link.
>
> For example,
>    $ bpftool prog loadall test.o /sys/fs/bpf/test autoattach
>
>    $ bpftool link
>    26: tracing  name test1  tag f0da7d0058c00236  gpl
>         loaded_at 2022-09-09T21:39:49+0800  uid 0
>         xlated 88B  jited 55B  memlock 4096B  map_ids 3
>         btf_id 55
>    28: kprobe  name test3  tag 002ef1bef0723833  gpl
>         loaded_at 2022-09-09T21:39:49+0800  uid 0
>         xlated 88B  jited 56B  memlock 4096B  map_ids 3
>         btf_id 55
>    57: tracepoint  name oncpu  tag 7aa55dfbdcb78941  gpl
>         loaded_at 2022-09-09T21:41:32+0800  uid 0
>         xlated 456B  jited 265B  memlock 4096B  map_ids 17,13,14,15
>         btf_id 82
>
>    $ bpftool link
>    1: tracing  prog 26
>         prog_type tracing  attach_type trace_fentry
>    3: perf_event  prog 28
>    10: perf_event  prog 57
>
> The autoattach optional can support tracepoints, k(ret)probes,
> u(ret)probes.
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---

For next revision, please also attach cover letter describing the
overall goal of the patch set (and that's where the version log
between revisions is put as well).


> v6 -> v7: add info msg print and update doc for the skip program
> v5 -> v6: skip the programs not supporting auto-attach,
>           and change optional name from "auto_attach" to "autoattach"
> v4 -> v5: some formatting nits of doc
> v3 -> v4: rename functions, update doc, bash and do_help()
> v2 -> v3: switch to extend prog load command instead of extend perf
> v2: https://patchwork.kernel.org/project/netdevbpf/patch/20220824033837.458197-1-weiyongjun1@huawei.com/
> v1: https://patchwork.kernel.org/project/netdevbpf/patch/20220816151725.153343-1-weiyongjun1@huawei.com/
>  tools/bpf/bpftool/prog.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 79 insertions(+), 2 deletions(-)
>

[...]
