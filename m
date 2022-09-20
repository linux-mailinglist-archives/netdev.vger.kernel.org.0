Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0025BE9B3
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiITPJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiITPJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:09:26 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D2C1CFFF
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:09:24 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id g3so4729034wrq.13
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Ka7EPG5Xut0v8+2/48BohUWIHUgDtwFwJB88xgoGnyk=;
        b=b6bsp1ACrwaFLHldPV1fKgPrq7g4nwegTR+Ny/0mVucro9R943onenV3BEN2H5E5ur
         wDTiNHJRyAcgYah8sYTnvpiIJDfCDLukWeKqDlB2te9MThRNrRmhuNBaitBvzqsItj2t
         PJoEVgwx8G6wb/2B9vrfFYHMUbokY4ZtORyTDkTLrGfWgMauripCLTo2jATXxj8GeINq
         n6WMrjDe3v2hKJWiVZlWzh8dCAb8dqQow6yPMKcDRKKs6MfP1qgj+knNnhZ4XL9igB/E
         xs2a+VEjo79ke9xENnOyRcnveyQnlIRvgWqpNjJ1s/Z/OJdlJc5CN4l0CPQnPht91giZ
         hIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ka7EPG5Xut0v8+2/48BohUWIHUgDtwFwJB88xgoGnyk=;
        b=zXngOjvjPwQcRXPduQXBEs9QNiuphz4y7ZgbacyzB6Fk+DS6tESS4ORWi3zfh2pRlG
         iVZ/ps5sRHt78lur4lgmWNNrk0AKIsxriVgeUHLAOXIWWAqfo7J1YzbbDMpWcqB5BzVq
         yHhv/yMonVfSrb+Nx+Cm/WzqmayA+9ka38hEI9NdPJuiC/3iGOmLIap0MIg6euPFl4p7
         Ro5oPAvUC4dsGBZTN4UYxUtWhpxLlXfZjLpceAJ0in9H2q712JIZQOhlZQGeHqZLyxUa
         snzALTuGyGz8tOoR82PLqrCpCRc4IZj7Lcsz584+tKOiq/w3O6EaGVUDvDnzh1dATdgI
         scTw==
X-Gm-Message-State: ACrzQf3wsjh6zrE88LDFZMegcWiWdrhBaUZ66QqA/Cutk8wTZsN44toy
        1RKCP9HNHRr3kB1cE33LpxHBtg==
X-Google-Smtp-Source: AMsMyM5Ah4BP1hEXKyWVmR/bZ3Gv1JyrxqPKL6ZiXk9zNi2Ku0QZsVu7HE6AbEQTDFEjBBOiqiD5fg==
X-Received: by 2002:adf:e10c:0:b0:225:3168:c261 with SMTP id t12-20020adfe10c000000b002253168c261mr14090730wrz.159.1663686562838;
        Tue, 20 Sep 2022 08:09:22 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id t13-20020a5d6a4d000000b00228da845d4dsm226170wrw.94.2022.09.20.08.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 08:09:21 -0700 (PDT)
Message-ID: <7db01da4-3aa0-6b40-7816-5f5ea3bc157b@isovalent.com>
Date:   Tue, 20 Sep 2022 16:09:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [bpf-next v4 1/3] bpftool: Add auto_attach for bpf prog
 load|loadall
Content-Language: en-GB
To:     Wang Yufen <wangyufen@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
References: <1663037687-26006-1-git-send-email-wangyufen@huawei.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <1663037687-26006-1-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue Sep 13 2022 03:54:45 GMT+0100 (British Summer Time) ~ Wang Yufen
<wangyufen@huawei.com>
> Add auto_attach optional to support one-step load-attach-pin_link.
> 
> For example,
>    $ bpftool prog loadall test.o /sys/fs/bpf/test auto_attach
> 
>    $ bpftool link
>    26: tracing  name test1  tag f0da7d0058c00236  gpl
>    	loaded_at 2022-09-09T21:39:49+0800  uid 0
>    	xlated 88B  jited 55B  memlock 4096B  map_ids 3
>    	btf_id 55
>    28: kprobe  name test3  tag 002ef1bef0723833  gpl
>    	loaded_at 2022-09-09T21:39:49+0800  uid 0
>    	xlated 88B  jited 56B  memlock 4096B  map_ids 3
>    	btf_id 55
>    57: tracepoint  name oncpu  tag 7aa55dfbdcb78941  gpl
>    	loaded_at 2022-09-09T21:41:32+0800  uid 0
>    	xlated 456B  jited 265B  memlock 4096B  map_ids 17,13,14,15
>    	btf_id 82
> 
>    $ bpftool link
>    1: tracing  prog 26
>    	prog_type tracing  attach_type trace_fentry
>    3: perf_event  prog 28
>    10: perf_event  prog 57
> 
> The auto_attach optional can support tracepoints, k(ret)probes,
> u(ret)probes.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>

Looks good to me, thank you

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

