Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512004EF7F8
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 18:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbiDAQeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 12:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349503AbiDAQdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 12:33:14 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064E62A85ED
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 09:05:51 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r13so4885052wrr.9
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 09:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hklOial7Zin/mLTXaf/iXnKaJeASDMWSnjZgJ7Zag2s=;
        b=GdVx/x1hfwTLunRYxNvqUPUbdWWogD+G59+vrK1Zq0dApIBz7crwov2uLpbp0evF8O
         qyUs9lIaANPw7O3KhU0Zv+L3e4dEEHrRSw0fe7XhJprf7ouW42E8StAP8ujLRS+NX073
         JX6UcTPifPB46dqCJmLfy2NV2PHFdgkgVexgvyiEWdMDeKoVc1JF4svhuFtn5Nc4JBfp
         T+Jiq+ne3W8vPxJAK4sSPrK9MQyefGBUVJRBIbyUMcFpRZdVknmPqgEZbyOC2n4eB2o1
         cehZoqEN1gFUCChxzyMLol4VthqQGHFEtXln2pC52IumpLT1tXGylESGda8PwvsaVsDu
         zXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hklOial7Zin/mLTXaf/iXnKaJeASDMWSnjZgJ7Zag2s=;
        b=T605bzLm34cKdSLoZHxMPKu+oCdDcNme92pulX09z3R/GdAA2yM/5r0D2mYD47y5m8
         OILSkldf/CpjrRw8QlFeN1Ba/FaNgbDHFehpKOQvyZIzOq/Ye8XH00mVQCJN0RyycU7q
         IQHnOj2KclADnU5Y53x56QLEmxwupqERDYo3ZuPVhXvECfB91Vg0k75O1SRiikScghxW
         OJ6fg4WIjMFGWcz1B4TX2Jxgp2TffzusYk5VQkrnrY9u6w6ZMr9/0WZ73jpxrAxPFPF/
         V2IwAgqfIScEkmsV28cRnQBo2qo9o/IEK6nW9gaOGFPLBizHyE1E/rmyUnfL44No1uh9
         lbQg==
X-Gm-Message-State: AOAM531crbHrrldLst9/Wwr0mQiqqwvrmwRvgWrs3Hv1YzRpCLTceN03
        bSZbW8nw3qcNZkx8qvusumJkbQ==
X-Google-Smtp-Source: ABdhPJz7ieQF66lrWTCTnXwP+yJlWhUuGDKKDSZue48u1bteSU3Fw+ZtxqA7MmlmJWdrwlmtyich1Q==
X-Received: by 2002:adf:db4b:0:b0:203:e76f:fc45 with SMTP id f11-20020adfdb4b000000b00203e76ffc45mr8010081wrj.549.1648829108697;
        Fri, 01 Apr 2022 09:05:08 -0700 (PDT)
Received: from [192.168.178.8] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id g17-20020a05600c4ed100b0038ca32d0f26sm2497333wmq.17.2022.04.01.09.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 09:05:08 -0700 (PDT)
Message-ID: <8457bd5f-0541-e128-b033-05131381c590@isovalent.com>
Date:   Fri, 1 Apr 2022 17:05:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH bpf-next 3/3] bpf/bpftool: handle libbpf_probe_prog_type
 errors
Content-Language: en-GB
To:     Milan Landaverde <milan@mdaverde.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        davemarchevsky@fb.com, sdf@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220331154555.422506-1-milan@mdaverde.com>
 <20220331154555.422506-4-milan@mdaverde.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220331154555.422506-4-milan@mdaverde.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-03-31 11:45 UTC-0400 ~ Milan Landaverde <milan@mdaverde.com>
> Previously [1], we were using bpf_probe_prog_type which returned a
> bool, but the new libbpf_probe_bpf_prog_type can return a negative
> error code on failure. This change decides for bpftool to declare
> a program type is not available on probe failure.
> 
> [1] https://lore.kernel.org/bpf/20220202225916.3313522-3-andrii@kernel.org/
> 
> Signed-off-by: Milan Landaverde <milan@mdaverde.com>
> ---
>  tools/bpf/bpftool/feature.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index c2f43a5d38e0..b2fbaa7a6b15 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -564,7 +564,7 @@ probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
>  
>  		res = probe_prog_type_ifindex(prog_type, ifindex);
>  	} else {
> -		res = libbpf_probe_bpf_prog_type(prog_type, NULL);
> +		res = libbpf_probe_bpf_prog_type(prog_type, NULL) > 0;
>  	}
>  
>  #ifdef USE_LIBCAP

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thanks!
