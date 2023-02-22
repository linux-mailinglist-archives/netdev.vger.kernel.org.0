Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3CC69FCF1
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 21:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjBVUSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 15:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjBVUSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 15:18:00 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550A819F34;
        Wed, 22 Feb 2023 12:17:59 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id s17so4922372pgv.4;
        Wed, 22 Feb 2023 12:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GsUgRdz1n/LKYXZQUijuj95d7BI1OE+ziHYOj2b1wrk=;
        b=iYJQfUSSxcHxFwHqQY6pt7G0cVaiO2IRi1YHDa6IohG7q7fHhaC0jGIWkSkn+WBvTH
         gPyQy/R63VLQvjJ5SVRuJYJvxp2LsDcPoKQLNS7sc0kfQaMzjwXvGFFU6mPsHfOQypaz
         XpFOlmB7XuA9IqfOAcQhRiaUB5yExAIAVAk3Dp3FShxPd/QaqQ3QmPH3drwo1rRXsJm3
         oC2w0Gdlv0gOjQ2lS0G8DFU27X4WUDUcrqhket5eg9bhRWrfdduhzygZdWbqSmwrxOxH
         LmtXZB9iRIdIZBHusNYalZit0VqbaM7jrsOeJqwXATyg7KrHfethx3Yy4jxQUCwPS+F3
         dbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GsUgRdz1n/LKYXZQUijuj95d7BI1OE+ziHYOj2b1wrk=;
        b=1ZSydgR7rQe4BkB2CAHu31M9mtndt010SOfQt6/zhxA8/kjEl0GasNQZ/YoBRyoG9K
         x8KNtjFyUfs9aEwN1M9ThaY16cA7H6j8l6DOMkxpt0bD8yQrBjskbQDHk8FpsMZlCIjQ
         i4KaeGUY5xTT9nDMxa2W/Po+QZZgnDneLZh4CLIm4ujLToxV4qfWNw4plcPlHxchPNbb
         nC9pSQAcsaMrsSmZJgTfdSab9tzLycLdsHZxIDxdgjXrP0AWRekl3iAaYq5WW/puxDL5
         WUvJiw3S27upA1Y3zfQj9pQB3qQdRdJnbXlGofTsJa+OS5YJ+0fjOr8mjeQYZfnztKpU
         D7AQ==
X-Gm-Message-State: AO0yUKVzV3AOaKDMR7ZUkJARmT1E4KUkawVB45zgQ36gtSDIJFoDlzcb
        O+a6X+MVpwM24TPxAMRSiXIVtebv2j4=
X-Google-Smtp-Source: AK7set8igjQ4YKJ07R2COn3rV+IstQAnzzZ8774ocpbplJMlIPOuNUAHUV2ymeLavUyX/aAxKqwh5Q==
X-Received: by 2002:a62:1b45:0:b0:5a9:d58e:796f with SMTP id b66-20020a621b45000000b005a9d58e796fmr7212177pfb.29.1677097077612;
        Wed, 22 Feb 2023 12:17:57 -0800 (PST)
Received: from MacBook-Pro-6.local ([2620:10d:c090:400::5:9cb3])
        by smtp.gmail.com with ESMTPSA id x53-20020a056a000bf500b005a8c92f7c27sm5351167pfu.212.2023.02.22.12.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 12:17:57 -0800 (PST)
Date:   Wed, 22 Feb 2023 12:17:54 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, martin.lau@kernel.org, andrii@kernel.org,
        ast@kernel.org, memxor@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, kernel-team@fb.com, toke@kernel.org
Subject: Re: [PATCH v11 bpf-next 10/10] selftests/bpf: tests for using
 dynptrs to parse skb and xdp buffers
Message-ID: <20230222201754.vsqi7s4nhngolok5@MacBook-Pro-6.local>
References: <20230222060747.2562549-1-joannelkoong@gmail.com>
 <20230222060747.2562549-11-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222060747.2562549-11-joannelkoong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 10:07:47PM -0800, Joanne Koong wrote:
>  
> -SEC("tp/syscalls/sys_enter_nanosleep")
> +SEC("tracepoint/syscalls/sys_enter_nanosleep")

Not sure what this was for, but s390 tests are failing:
libbpf: prog 'test_read_write': can't attach BPF program w/o FD (did you load it?)
libbpf: prog 'test_read_write': failed to attach to tracepoint 'syscalls/sys_enter_nanosleep': Invalid argument
verify_success:FAIL:bpf_program__attach unexpected error: -22
Please see:
https://github.com/kernel-patches/bpf/actions/runs/4240181429/jobs/7374285371

> +extern int bpf_dynptr_from_skb(struct __sk_buff *skb, __u64 flags,
> +			       struct bpf_dynptr *ptr__uninit) __ksym;
> +extern void *bpf_dynptr_slice_rdwr(const struct bpf_dynptr *ptr, __u32 offset,
> +			      void *buffer, __u32 buffer__sz) __ksym;

Please move it to some common header like bpf_experimental.h or any other.
