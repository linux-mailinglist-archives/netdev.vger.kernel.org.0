Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C9C57308A
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbiGMIOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiGMINN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:13:13 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0000EABFB;
        Wed, 13 Jul 2022 01:12:53 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id z23-20020a7bc7d7000000b003a2e00222acso1860705wmk.0;
        Wed, 13 Jul 2022 01:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0uRDex1sPZB8+kY6pRwjfFra2BxS6+wEYBs3OQaRvL4=;
        b=czMyWCpWUG776U3vRaa14UMGbkTFNvyvooqLdkooVASOb+MgSYYymDK+xBJAr1+Kfk
         xKAE/nB6N3vhxDMiOOVIzVNBchQ1IMj6ZVqGzYxjgdHvxuhzZFxdfThrGD55Ha0xag5n
         xraVDVz10BAO8ieSsWuBun9KxgsaU3Nclb9mh/erBve+sCIF7oC8UXWO64NkMkNlviTt
         A586Ch9/rYorCbYsqZHCnXi9WzCCc2cECYaHLoyf6dNA5GHJtVhPkmcIFwO0ygEm60Ni
         NseVUc9g6bW49kel1rQibobW38H9GudctoaUDFzGkrAs3mDQWobIW6dwA2R3nC9e2FfP
         8uTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0uRDex1sPZB8+kY6pRwjfFra2BxS6+wEYBs3OQaRvL4=;
        b=sPOa333PAddxG5TN0vT5fUVYCuT0HpzGOGoEb3q/EHqRtzeKEOJIJ2iY/KzMOyxy/y
         ZzgsgwDrMUHAFRkx0U3BxYO9d/YmewxJDLhwog3JeD2YB3y5n0A6nPpZZ/i72nTr8q+1
         VIFuLRVK0NP6rEGp5mOUxGKz1NvwkEm76yhWags3VlDjB4BZKZf3JeL35ADQplkM7Ueg
         qVf2X1wZd87aFnBAzyG6PvilCSjionSPFVqKZMoEx6+bkq3onNRokKuPo0JmN4NzI3fa
         sovgS/8vgxbol5F3qs2uiSdocNJg6aiar7iGJtTE2lpUb86tl//Ajz890ceE/q2Hzmmz
         7xJg==
X-Gm-Message-State: AJIora9ervu5ISuXI6gTfrqLWFK69ef68b+RUy0WhZ1zB+9E6Penh87Q
        M3OGnEiNVI+8G+fe8O5fOZk=
X-Google-Smtp-Source: AGRyM1t2/g2aQx4hW4BD8FkYMRkeZOzwdnkao9wmFSElnULULsGShBJ93EfxE/7iVcV/SZaP2yWAhw==
X-Received: by 2002:a05:600c:42d3:b0:3a2:e7b8:8430 with SMTP id j19-20020a05600c42d300b003a2e7b88430mr2281220wme.42.1657699972267;
        Wed, 13 Jul 2022 01:12:52 -0700 (PDT)
Received: from [10.139.203.5] ([54.239.6.190])
        by smtp.gmail.com with ESMTPSA id h4-20020a1c2104000000b00397402ae674sm1414763wmh.11.2022.07.13.01.12.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 01:12:51 -0700 (PDT)
Message-ID: <016536af-2ab8-b557-abe6-1c8f2b6d7e91@gmail.com>
Date:   Wed, 13 Jul 2022 10:12:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: paul@xen.org
Subject: Re: [PATCH] xen/netback: handle empty rx queue in
 xenvif_rx_next_skb()
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220713074823.5679-1-jgross@suse.com>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20220713074823.5679-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 13/07/2022 09:48, Juergen Gross wrote:
> xenvif_rx_next_skb() is expecting the rx queue not being empty, but
> in case the loop in xenvif_rx_action() is doing multiple iterations,
> the availability of another skb in the rx queue is not being checked.
> 
> This can lead to crashes:
> 
> [40072.537261] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
> [40072.537407] IP: xenvif_rx_skb+0x23/0x590 [xen_netback]
> [40072.537534] PGD 0 P4D 0
> [40072.537644] Oops: 0000 [#1] SMP NOPTI
> [40072.537749] CPU: 0 PID: 12505 Comm: v1-c40247-q2-gu Not tainted 4.12.14-122.121-default #1 SLE12-SP5
> [40072.537867] Hardware name: HP ProLiant DL580 Gen9/ProLiant DL580 Gen9, BIOS U17 11/23/2021
> [40072.537999] task: ffff880433b38100 task.stack: ffffc90043d40000
> [40072.538112] RIP: e030:xenvif_rx_skb+0x23/0x590 [xen_netback]
> [40072.538217] RSP: e02b:ffffc90043d43de0 EFLAGS: 00010246
> [40072.538319] RAX: 0000000000000000 RBX: ffffc90043cd7cd0 RCX: 00000000000000f7
> [40072.538430] RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffffc90043d43df8
> [40072.538531] RBP: 000000000000003f R08: 000077ff80000000 R09: 0000000000000008
> [40072.538644] R10: 0000000000007ff0 R11: 00000000000008f6 R12: ffffc90043ce2708
> [40072.538745] R13: 0000000000000000 R14: ffffc90043d43ed0 R15: ffff88043ea748c0
> [40072.538861] FS: 0000000000000000(0000) GS:ffff880484600000(0000) knlGS:0000000000000000
> [40072.538988] CS: e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> [40072.539088] CR2: 0000000000000080 CR3: 0000000407ac8000 CR4: 0000000000040660
> [40072.539211] Call Trace:
> [40072.539319] xenvif_rx_action+0x71/0x90 [xen_netback]
> [40072.539429] xenvif_kthread_guest_rx+0x14a/0x29c [xen_netback]
> 
> Fix that by stopping the loop in case the rx queue becomes empty.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Paul Durrant <paul@xen.org>

