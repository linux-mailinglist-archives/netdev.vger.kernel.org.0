Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224FA5FB829
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 18:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiJKQRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 12:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiJKQRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 12:17:49 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D927C75D
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 09:17:47 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j16so22396489wrh.5
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 09:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8p+Ph8umyk1fiV8rOh8aDOZpPjjfRG0WHPagf8EYGjI=;
        b=LD0gGXDMEqnlsIxmg0Bf/DhQPtX3hLNQyJtg7EC16SmGNowy/93F7CLepmdLP417rL
         4tREBjrSdHGSA/WBUkWANyn51X4CKiDUtc/bBqmqW1l9dCcVktSKDhziGWMFDFx2FfEk
         00aCa49AU1QzBU61GiEqOzXUUjkp7P1Cw0I5ifW503DsoATwzYap0kC3aaXDs58plncF
         UGvfQ/aMdB8N7MHHd5tNx0SFUcRTECD7AZjCJ0xX30IRmb/rbEXX+AbmrfvyqT0E6ypG
         k5+z8/p86SDwGtxQgD+Pg1K9AYiBcKhpcFooG1QfKfHRv4LBWVHU/Hs7IRmLGRIuZgKr
         oJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8p+Ph8umyk1fiV8rOh8aDOZpPjjfRG0WHPagf8EYGjI=;
        b=WW1x1oL6LyX0238YVeCchz/fOZt0kWa+PIMUj1LUp1val+lX2ZxYBTdkjIyxpiyb6J
         lWJCqDBnAvRHU0Kx10lJ+Yi2snXT+3emnMRQzh2SmbAd4pWTWawyEP65NxxLGB2O/zyu
         bbofCWqm0w+TW02ibXuqstCWb3HEu9urHmURuloWPdt8u8u/kIPS9CE0vJz9Eg76k53A
         0BNfsKTUGc3vFUQ+TH2jIxa14qD7DUH/YLB3sQPxcp6CtVHCuNTMX1z2e1WgAgf9j3ok
         H0nJcHyz9Tdj6x4tK6VNMBH5Ap7lEB4MVNTh8KYK1uWOm08KOfy5JzlqhzS0hRVic9j8
         aPCQ==
X-Gm-Message-State: ACrzQf08U1KaVBKHCCFkODG/cnsNfExES7CXG6KS+OUe32KfDTW42pCh
        0wXiGbPDoJTFFdzNs9RGou4ojw==
X-Google-Smtp-Source: AMsMyM7gpUdapuVTKHfKEDpK7jYbQ5SOEi2bep8snUSDGTh015napIGgYLeHXayu6RLOZacsubuMVw==
X-Received: by 2002:a5d:64cd:0:b0:22e:4af7:8182 with SMTP id f13-20020a5d64cd000000b0022e4af78182mr16328525wri.453.1665505065986;
        Tue, 11 Oct 2022 09:17:45 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id t128-20020a1c4686000000b003b4a699ce8esm11025005wma.6.2022.10.11.09.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 09:17:45 -0700 (PDT)
Message-ID: <9ea9fc0c-41e7-d7cc-7822-dcfab9398d7d@isovalent.com>
Date:   Tue, 11 Oct 2022 17:17:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [bpf-next v8 0/3] bpftool: Add autoattach for bpf prog
 load|loadall
Content-Language: en-GB
To:     Wang Yufen <wangyufen@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, llvm@lists.linux.dev
References: <1665399601-29668-1-git-send-email-wangyufen@huawei.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <1665399601-29668-1-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-10-10 18:59 UTC+0800 ~ Wang Yufen <wangyufen@huawei.com>
> This patchset add "autoattach" optional for "bpftool prog load(_all)" to support
> one-step load-attach-pin_link.
> 
> v7 -> v8: for the programs not supporting autoattach, fall back to reguler pinning
> 	  instead of skipping
> v6 -> v7: add info msg print and update doc for the skip program
> v5 -> v6: skip the programs not supporting auto-attach,
> 	  and change optional name from "auto_attach" to "autoattach"
> v4 -> v5: some formatting nits of doc
> v3 -> v4: rename functions, update doc, bash and do_help()
> v2 -> v3: switch to extend prog load command instead of extend perf
> v2: https://patchwork.kernel.org/project/netdevbpf/patch/20220824033837.458197-1-weiyongjun1@huawei.com/
> v1: https://patchwork.kernel.org/project/netdevbpf/patch/20220816151725.153343-1-weiyongjun1@huawei.com/
> 
> Wang Yufen (3):
>   bpftool: Add autoattach for bpf prog load|loadall
>   bpftool: Update doc (add autoattach to prog load)
>   bpftool: Update the bash completion(add autoattach to prog load)
> 
>  tools/bpf/bpftool/Documentation/bpftool-prog.rst | 15 ++++-
>  tools/bpf/bpftool/bash-completion/bpftool        |  1 +
>  tools/bpf/bpftool/prog.c                         | 78 +++++++++++++++++++++++-
>  3 files changed, 90 insertions(+), 4 deletions(-)
> 

The series looks good to me, thank you!

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
