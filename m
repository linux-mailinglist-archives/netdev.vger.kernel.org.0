Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D8D4BDCCB
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379522AbiBUPtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 10:49:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379511AbiBUPtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 10:49:13 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EF724095
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 07:48:49 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cm8so20644692edb.3
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 07:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AV3DNdIg+UtXULJt0thwZ048Q1Y0fhQSNYoEkjMO2Q0=;
        b=AxhXhjCgP5813Q+O7+B6GgcKOub80Mi1M1QGGLrXcKpDdiLyhpb0id3ciKYYLngiMI
         e0x9hhlKER64yur71WOiNWqtIpDiD5KKYTmvKhY5KO0AF3U/Vx7HuC0+QvinYAQnh3wA
         5fw6wyYJ1vhS5BKpASRQ3pW4o93VzQk0tNKswSsaH70ZTe73LmEidhzBzeyXxiT3dQcB
         IhMlXVpDeL06CRP1Xedbd2PGZ+lpxc6ANAV47KgI0C20+hMo3nhwZCZd9Zqobtjbq8VM
         bLaSSEUSEyOnMjz3V3zDtRKKdbPQItoFnAUSd5mIoOaAs1A94gh208K9hkXsp3z0cbgL
         pGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AV3DNdIg+UtXULJt0thwZ048Q1Y0fhQSNYoEkjMO2Q0=;
        b=0+j1SC0K0kNG1BRiAIdukV7e/2kYpPwo4Fsa0EYvfH/RmcG5P8xT3hubg5M9At3Oe5
         NsS+mhmfqY+x0ivDBy1gebp17zueiCPHadthT4v0l66VsTK7GhnCVhGVzDIQgIAtP1/4
         y+CZRIzGTmAC8hAOd2iIzbtdSHSHxzTPYEUPNNPVCBtudqzWWsjwb4GixQwzobaKmKpJ
         XmUtHpfXVSfXLY1A+XhxGxs3mPPbUNITqAeDWXIveLbKJitEdcOy6hQXOs0FQX6eDuOC
         867mwpxs0kj+dHsen3ZpB8TBj+EV0Yi47Kur52idDVr5LnW30yfvVuH1BLovOiZzhVqh
         pSnQ==
X-Gm-Message-State: AOAM5305u5aMt5NYUhEO1A70QnXH5fEfktT4dIuKiojZMy1w1WHIoXG0
        nmqZr52pjSmeH8m6cVIJu54P4GtEg0mbgQ==
X-Google-Smtp-Source: ABdhPJyzby6JkcCPLDtXOkJhpALP2Wss8voyNJPhnXl72VlxjfV0BmXbyq9Ld6w3UzbR1gBz6KFR/A==
X-Received: by 2002:a05:6402:190b:b0:412:8cfc:c266 with SMTP id e11-20020a056402190b00b004128cfcc266mr22202959edz.274.1645458528118;
        Mon, 21 Feb 2022 07:48:48 -0800 (PST)
Received: from [192.168.1.8] ([149.86.76.215])
        by smtp.gmail.com with ESMTPSA id f3sm7454951edy.72.2022.02.21.07.48.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 07:48:47 -0800 (PST)
Message-ID: <f2c11f1a-ab7d-2d7b-7583-d1edb94cace9@isovalent.com>
Date:   Mon, 21 Feb 2022 15:48:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH bpf-next v2] bpftool: Remove usage of reallocarray()
Content-Language: en-GB
To:     =?UTF-8?Q?Mauricio_V=c3=a1squez?= <mauricio@kinvolk.io>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20220221125617.39610-1-mauricio@kinvolk.io>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220221125617.39610-1-mauricio@kinvolk.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-02-21 07:56 UTC-0500 ~ Mauricio Vásquez <mauricio@kinvolk.io>
> This commit fixes a compilation error on systems with glibc < 2.26 [0]:
> 
> ```
> In file included from main.h:14:0,
>                  from gen.c:24:
> linux/tools/include/tools/libc_compat.h:11:21: error: attempt to use poisoned "reallocarray"
>  static inline void *reallocarray(void *ptr, size_t nmemb, size_t size)
> ```
> 
> This happens because gen.c pulls <bpf/libbpf_internal.h>, and then
> <tools/libc_compat.h> (through main.h). When
> COMPAT_NEED_REALLOCARRAY is set, libc_compat.h defines reallocarray()
> which libbpf_internal.h poisons with a GCC pragma.
> 
> This commit reuses libbpf_reallocarray() implemented in commit
> 029258d7b228 ("libbpf: Remove any use of reallocarray() in libbpf").
> 
> v1 -> v2:
> - reuse libbpf_reallocarray() instead of reimplementing it
> 
> Reported-by: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
> 
> [0]: https://lore.kernel.org/bpf/3bf2bd49-9f2d-a2df-5536-bc0dde70a83b@isovalent.com/

Fixes: a9caaba399f9 ("bpftool: Implement "gen min_core_btf" logic")
Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thanks!
