Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DD3642A7D
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 15:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiLEOil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 09:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiLEOik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 09:38:40 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62255C74C
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 06:38:39 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id f13-20020a1cc90d000000b003d08c4cf679so6323234wmb.5
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 06:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ta40CWGoCabBWWb+cWxjc/DA/QadHc37Z/Nw+3VKEPo=;
        b=YbJlcoZQn6wCdbgM7zjho+xcIKqWbDhFahrDfQiy074ndPa+/nbyOLgwXV+fVJoROV
         xMgEsBqsKQoLUsPOuqBBFUFSbvGEBrRiLLAEEtqd8wINrSnSSvPN5uInUwCJ+gGsBhwt
         DhTFIC1w1OK9gVwCV0TXTpjKdwl2+cM8NhMitQMUxwEP0OfOf5XTKzyuVgjhF17U8iha
         EVPDxLvYxrVT8N9c8LFLHovkaA9/lz4eocFSnfIk3Y8HK23vM+cGFIsBj9eDRbVb4l5k
         qgv7e+9+YF8l+LTF5UYDKDEma8nmpOONindsoUv2qhUkq4NDnWD/+FrHFmRDYBVBOOdf
         QGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ta40CWGoCabBWWb+cWxjc/DA/QadHc37Z/Nw+3VKEPo=;
        b=koqN0+mimbHZDWVwXuVC7zNlVXef7ta2sC0ZBhO04tH04yE5U3CMclGr5cKTv0lUQC
         pRn/yeoOzDXyG1UJstoaJDiQat7ZhtQvc02Y9mFGuiOJN9qq6FQXPXcim+TNLdNzgTxR
         7VCLgIATvNWZP9MZcu1LMA9ot7nOXiHFnpYNBdysfc8HJYYCVnkW0aaecHWA0ILN+YDy
         kF5yDSiHeFaMX2ehrY/vHbb+caLi5rKgfysF+r27/reBfuCpDCdebe9P7cy4NgJ6Pp7N
         +tYcIdsz+L5L/fh1fASHseNWGMhe6+rc/n7/a5ePL7tPv8XFCGpMWxbNCrL2zQTdBsDN
         utsA==
X-Gm-Message-State: ANoB5pmpIyHEMF8tWYdTEfYWNxJ+TsgGlFpQlPpoK1K7+g6cHg8ChmIA
        ByE4fsnEdqhjPgzlSAf2YZc=
X-Google-Smtp-Source: AA0mqf72DGuSWzCpUwe9yDc2iLM2n+0etmet0hOZh30STSilHGxDXbYthNWIGCHigIPgM/UOR0Qg1Q==
X-Received: by 2002:a05:600c:3514:b0:3cf:e0ef:1f6c with SMTP id h20-20020a05600c351400b003cfe0ef1f6cmr52359780wmq.75.1670251117813;
        Mon, 05 Dec 2022 06:38:37 -0800 (PST)
Received: from [192.168.6.151] (54-240-197-232.amazon.com. [54.240.197.232])
        by smtp.gmail.com with ESMTPSA id u12-20020a5d434c000000b00241bd177f89sm14163461wrr.14.2022.12.05.06.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 06:38:37 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <ef302bc7-5c55-2bb5-d159-27fd6a8ed9df@xen.org>
Date:   Mon, 5 Dec 2022 14:38:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net] xen/netback: don't call kfree_skb() under
 spin_lock_irqsave()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Cc:     wei.liu@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jbeulich@suse.com,
        jgross@suse.com
References: <20221205141333.3974565-1-yangyingliang@huawei.com>
Organization: Xen Project
In-Reply-To: <20221205141333.3974565-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2022 14:13, Yang Yingliang wrote:
> It is not allowed to call kfree_skb() from hardware interrupt
> context or with interrupts being disabled. So replace kfree_skb()
> with dev_kfree_skb_irq() under spin_lock_irqsave().
> 
> Fixes: be81992f9086 ("xen/netback: don't queue unlimited number of packages")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Paul Durrant <paul@xen.org>
