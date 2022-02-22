Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FC94BF0C7
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240865AbiBVD3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:29:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234051AbiBVD3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:29:16 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE8C22B21;
        Mon, 21 Feb 2022 19:28:51 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id f14so10726813ioz.1;
        Mon, 21 Feb 2022 19:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cc+aaqgLUgMXc7nvc5X1YC/nZGcvX9FvTSQgCEhBWrE=;
        b=UVbD7U7jcHyWdRrzrl5QAy9dVUXyotEpNEqqbFws6DqUM9ue+LVBAOFytxhih7Z2ix
         +YbiWRinseyfX2FVA2owEcTz+rOrFJ5zcg7lntWH/7CGhO/GeSlLod2QySHaF3v/0U6s
         +8/pJyeciAf9Brc/CoWE9v+onAAw/kD4mzFjZx3bi97VKpx8QUh1L63AEgukmX7cbmxK
         Xr7pvPijW24nbrxe3GakxNm6HLdGnugkClhCMuRnKngru0k1quuWJx88j1MwbmZVo2ai
         U89tlH91ofwcXdq3ZM75831VhGtx/tatjjjIWrw24fubiXPM7sbXasDoPzkn/8XIV/Vv
         nrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cc+aaqgLUgMXc7nvc5X1YC/nZGcvX9FvTSQgCEhBWrE=;
        b=oFUm7T/OAL4vGlT0/GtO+g9e2PVN3xgvVPXr2eTw/proJNUxkp5MSgYfl3ZvIpl1Zk
         1IW/cAUF4Yj6TVAxt4IshFAEtGrTSb0aBGD1A24KHJfO/gs5of63LYKDJRCO7bVWR+PC
         F9Xq5zu4k9wfsgepFV37u6O/7KNllr2zXk7Cf+nc7Y5Hob+HaWYDHrYeHV4/sdsRRFnE
         fhbzqtBsmjhNOCnv4McOUZAR2sfGWE8GFUoEVYyj7BvlbSMi56lomtdZxYZHKGiYD7HW
         ygHn436332ToI54UQ53wJRMGZMNURyGrwe2NwRMckRybsgR/i9NTYn7ZntLOq9lbus5i
         S2sw==
X-Gm-Message-State: AOAM532cogVLCg8nrun2nvD001O2JikGGcFP7ydaIB3agti1piuQgi64
        2sYsW8iXh6fBojNf7gA+4Wc=
X-Google-Smtp-Source: ABdhPJxEEhhYMasPec1HKZBCYMr3GFk54ZOTwyZpScJmFCdrwNVm8GYJeNQ2HQvO4CqsUrR6KRJA2Q==
X-Received: by 2002:a6b:fa19:0:b0:640:74d5:5dfd with SMTP id p25-20020a6bfa19000000b0064074d55dfdmr14508732ioh.100.1645500531457;
        Mon, 21 Feb 2022 19:28:51 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:fc7f:e53f:676e:280d? ([2601:284:8200:b700:fc7f:e53f:676e:280d])
        by smtp.googlemail.com with ESMTPSA id d16sm10896655iow.13.2022.02.21.19.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:28:51 -0800 (PST)
Message-ID: <4e55abf4-6d5e-87de-10e6-7da365f1ef0a@gmail.com>
Date:   Mon, 21 Feb 2022 20:28:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v3 3/4] net: tun: split run_ebpf_filter() and
 pskb_trim() into different "if statement"
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
 <20220221053440.7320-4-dongli.zhang@oracle.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220221053440.7320-4-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/22 10:34 PM, Dongli Zhang wrote:
> No functional change.
> 
> Just to split the if statement into different conditions to use
> kfree_skb_reason() to trace the reason later.
> 
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  drivers/net/tun.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


