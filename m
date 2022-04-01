Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4684EFB76
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 22:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352270AbiDAU0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 16:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352624AbiDAU03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 16:26:29 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4CCDB1;
        Fri,  1 Apr 2022 13:22:57 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1naNnI-0005fS-ID; Fri, 01 Apr 2022 22:22:52 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1naNnI-000HUg-57; Fri, 01 Apr 2022 22:22:52 +0200
Subject: Re: [PATCH bpf-next] bpf, arm64: sign return address for jited code
To:     Xu Kuohai <xukuohai@huawei.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <20220318102936.838459-1-xukuohai@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <da82d26e-8269-5b95-2cbb-1c147e55fcd4@iogearbox.net>
Date:   Fri, 1 Apr 2022 22:22:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220318102936.838459-1-xukuohai@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26499/Fri Apr  1 10:20:48 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/22 11:29 AM, Xu Kuohai wrote:
> Sign return address for jited code when the kernel is built with pointer
> authentication enabled.
> 
> 1. Sign lr with paciasp instruction before lr is pushed to stack. Since
>     paciasp acts like landing pads for function entry, no need to insert
>     bti instruction before paciasp.
> 
> 2. Authenticate lr with autiasp instruction after lr is poped from stack.
> 
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>

This would need a rebase, but please also use the commit description to provide
some more details how this inter-operates wrt BPF infra such as tail calls and
BPF-2-BPF calls when we look back into this in few months from now.

Thanks,
Daniel
