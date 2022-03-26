Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2404E81F1
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 17:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbiCZQVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 12:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiCZQVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 12:21:19 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D146636173
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 09:19:42 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gb19so10200223pjb.1
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 09:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=ptIrfGPpNnvLQ0Mx/lXPFIEbNHI5aoNhb1qHknnfK4g=;
        b=X6ExkTg5omlDR81EER+azTfr125Kp1l+03rwcZ1CI5PItzI1gOSxT9CcKwyn+gM6Fq
         U5WFFbpfvDMneg4pzxzbCM0WQ8d5woGr1OkshoG0+dj9fKcvAMYi9D3XvhxLOWjWnx2Q
         I5wJIiPiKjsHAZhPWrlzkfbsRSvq4RLCc2AIW+4NKWnW4NYVxlRbP4D4i+O0MQackBLD
         aF1lE63YuN16U7BmU5bzXeGQ/rbfh+oII9thtQgvlU6FgBrT5qjl3/NyI+5vp+yDevLl
         qC0c8yEcR0WShg9qKCwfy8Q5jRzrAY3LlJGQ8bUL6yIIt1lPbLytvNq16oiOqKIosU48
         tj4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=ptIrfGPpNnvLQ0Mx/lXPFIEbNHI5aoNhb1qHknnfK4g=;
        b=JniK/VH2TwfZhv/SKThjlc1TzcNa1LHcgTrWBCmuUya91F+sTv7AUn3UbBjE8C9iZN
         V7h90apmUkLtNmSAXbUNVbdCaiW0/4LaGRroJ4Z4fxjhcZyFHKbgFYW4XbOgaZY9K2E6
         KXMNHQa9LxNshlVosZc0n1ttX4hLmUKUui1c2/PU10NeOiXx6moqI3Gh0iG/5zjiFELD
         ejyN8H7KaQSs3mliFHGfLfp02fQsonxLEqZxhosZexDgGTaMOji9ctFhKtMDkhtgHb9n
         nVM/jjVDH64F6NmUTwkcby3keV0ijyGQJGEJJNwlUDlpFJusky5L0NsCWSUAc5IeaLRr
         ug3g==
X-Gm-Message-State: AOAM531aqUmFWYAcMfN63hsLVJTK5Rr1LT7cNOslmJu/K8xj/XhSP/eD
        FzjZBzEcW1xzRLpTG2v5chRsu3moTSDg1h4M
X-Google-Smtp-Source: ABdhPJyD26oC/cRvG+SJuwr8yBAWEyCBw+iyj3vHzE2MIgEgZx4ka274A7YgxzjcSaSIQm3Nv0nMiQ==
X-Received: by 2002:a17:90b:4a92:b0:1c7:5aa4:2a74 with SMTP id lp18-20020a17090b4a9200b001c75aa42a74mr30049040pjb.239.1648311582076;
        Sat, 26 Mar 2022 09:19:42 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ck13-20020a056a00328d00b004fb1414476bsm5869156pfb.200.2022.03.26.09.19.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 09:19:41 -0700 (PDT)
Message-ID: <468b1467-1a93-c04f-cbf9-793bdcc8663c@kernel.dk>
Date:   Sat, 26 Mar 2022 10:19:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] net: remove unused TCPF_TSQ_DEFERRED
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>
References: <8d326eb1-03de-6b8b-009e-7365255dd271@kernel.dk>
In-Reply-To: <8d326eb1-03de-6b8b-009e-7365255dd271@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/26/22 9:57 AM, Jens Axboe wrote:
> tcp_release_cb() checks for this flag, but nobody is setting it. Just
> kill it off.

Should've checked closer, bit TCP_TSQ_DEFERRED can be set of course.
So just disregard this one, sorry for the noise!

-- 
Jens Axboe

