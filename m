Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0264E435F
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 16:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbiCVPzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 11:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236021AbiCVPzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 11:55:33 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95192395
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 08:54:04 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h23so23419391wrb.8
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 08:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Tt/SqUUAabCfrKOj3ZmKo00ir/Hdf+gvpwIpDHz4tJ0=;
        b=u0r3dKDia8A+bA6cPKHpTBTKwD8N19KhhoGEYRUXhw3CSMkJMsRPQZh8wfIE72d8aX
         8ACa6BFIpZ93AvJqplhYepzpe5Mdn7exXF5SvCXtpLwZB8NEaRAuxTgyVZ5mWWcW+fKS
         eXNmuJ8wqRqdtzF5yNrJ4seI0UoLO+Byx317CiZ0GRbLZoIsi8ImcLXetNR/2yfzX94V
         /G5QBSQup2v9d7WqPHbfT/+DFUkY6p6WzBWw//hnQW5rJ5mLkSi3KzDwPIzw5TPqm3FP
         +Un0m04g2I3URHC4zzHt6eJOMYm6YOuaJlvlEc8xIBVZzTeE3ooTQx99RagBk3rtEJg6
         CUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Tt/SqUUAabCfrKOj3ZmKo00ir/Hdf+gvpwIpDHz4tJ0=;
        b=7USIGG76kKOqWUEy4y69C427gsMSCmdNCs9p9pxP9181ydCJVzDJmM4iNk7rAJhoG+
         NQgjjp8OakQdD4GoK1iiA+q8nALX6w9tRtm1GlyM6qoKk+3BrAttBEkhvffzbr561yIe
         vxmf9wh2GJR9xFzmEua64uFIoU2tduJmM6KNzVQ4QSsBctAnEfN219EnPacR3TXnjN4l
         w7WHowUtvRbDGQDaHccm6Fcff7Qsdt+cfqA962HMqvitvXzXxD3tpRaDEJ9r/3ije+rm
         GJmpSFjooYfeU94wjTi36XHs/qCuKhYIDumhwI/5Greb4FjnHTokkqG7A5qIvuQOilmk
         Lz5g==
X-Gm-Message-State: AOAM530I5uJbobqdZ3k78hLS2AIkgBgnMUKi3nRVuK5iZwBr4cl93/hn
        I/Ji1zOvjnx0RRpRdNWX+GzgzA==
X-Google-Smtp-Source: ABdhPJwo5Sa4Qyqu6v1d9pTlT7/ULYTzyX2OiF25Z6tPgiwYFJ7ys4wNU6wL7LL9+VKH4HgBHcR/Rg==
X-Received: by 2002:adf:90e9:0:b0:204:2ee:7d5 with SMTP id i96-20020adf90e9000000b0020402ee07d5mr12944907wri.536.1647964443149;
        Tue, 22 Mar 2022 08:54:03 -0700 (PDT)
Received: from ?IPV6:2a02:168:f656:0:b0e1:d1e9:8b3d:5512? ([2a02:168:f656:0:b0e1:d1e9:8b3d:5512])
        by smtp.gmail.com with ESMTPSA id v10-20020a056000144a00b00203df06cf9bsm16606795wrx.106.2022.03.22.08.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 08:54:02 -0700 (PDT)
Message-ID: <ca7b331c-bd35-7d51-3df4-723bc36676f8@isovalent.com>
Date:   Tue, 22 Mar 2022 15:54:01 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH bpf-next] bpf/bpftool: add unprivileged_bpf_disabled check
 against value of 2
Content-Language: en-GB
To:     Milan Landaverde <milan@mdaverde.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Chaignon <paul@isovalent.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@corigine.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220322145012.1315376-1-milan@mdaverde.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220322145012.1315376-1-milan@mdaverde.com>
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

2022-03-22 10:49 UTC-0400 ~ Milan Landaverde <milan@mdaverde.com>
> In [1], we added a kconfig knob that can set
> /proc/sys/kernel/unprivileged_bpf_disabled to 2
> 
> We now check against this value in bpftool feature probe
> 
> [1] https://lore.kernel.org/bpf/74ec548079189e4e4dffaeb42b8987bb3c852eee.1620765074.git.daniel@iogearbox.net
> 
> Signed-off-by: Milan Landaverde <milan@mdaverde.com>

Acked-by: Quentin Monnet <quentin@isovalent.com>

Thanks!
