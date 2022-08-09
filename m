Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569F858DB6E
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 17:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244501AbiHIP5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 11:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbiHIP5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 11:57:13 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4366115711;
        Tue,  9 Aug 2022 08:57:12 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id j17so4294541qtp.12;
        Tue, 09 Aug 2022 08:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=bKdTrGZoKGDHzHEhTdRC8vxYsEVE+VTG8R2zu3iWBLI=;
        b=OL6J3fXpjTbxMNOxrbKqJ3HsSPwkLSLQX90spKCJa5gUtXg+ciqIRhIVXg5fmyukvM
         LMYA9UKXCGdjIUovC/LHTyQXFx6Dqz92P/PvbjwhUGYACZixcTkYBNr/RzfSrdu2dQ0W
         hxYQS34Pyk4rB8UmaYhvrmaudBl6aWrOcSKqR0C1uzjht8fUCjGKsel/v+hxlx00Mmcd
         cp/R0VW1sBP+vrpw9ElKSm+pYbXvJRj7mjuG0tuY29YJVU1s90x6Oiw2Hb9jesBPPqlf
         SyXKdwOp+DGcGrFtL9ho4+B4aQ22M+fuKfdUsMAxiPK2Oig5A2xYrA8QTJHSnakn4ya8
         FrfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=bKdTrGZoKGDHzHEhTdRC8vxYsEVE+VTG8R2zu3iWBLI=;
        b=UUvrbHBYWfbwDqdCTOfQNM+cM1R2b/YOfNm28CdqZ4As0ov/MuLwkt/55XGcL1uWqL
         KvWqWbn5wMP3totMHpMINF0s88eE0o8npv+tNk9gnenjLzCw/n2WK0cZD3LUYTihqE7D
         1JpBAxjlCOcKwCFTukJh8UGdoA68xkmsrWSMTGZgNu7cybdZbVNhnR7H2ypeZHMDjRZ0
         6QyEAnsD+7Ee9oOO0lu5RiGKf133YoEhnbyAlKPmDQCa5eB3sqhMQsNqoCoZvyZ5+ICm
         LQv0FUY0C4LYA9nPYOKyNoZJfutAme7tMIg+XH6Yu+Yc4JOO/T3wiKbbUY9+AR8LPMNH
         ploA==
X-Gm-Message-State: ACgBeo1no46SRa/0yncfng2Vu79Bxy5oAsfWRk+JmzenjQNcsXSeZxy7
        vD1bLlGukH8NPJ6wvSQ6vsY=
X-Google-Smtp-Source: AA6agR4FPrxLzJhYLMjQ2iuBKsVUUAGuVlVils7050kg9PIs1pTlwbCH/1MhOYmFdlaraST9qan/RQ==
X-Received: by 2002:ac8:5c87:0:b0:342:8f61:1bb7 with SMTP id r7-20020ac85c87000000b003428f611bb7mr18207369qta.166.1660060631272;
        Tue, 09 Aug 2022 08:57:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k5-20020a05620a414500b006b93ef659c3sm7217736qko.39.2022.08.09.08.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 08:57:08 -0700 (PDT)
Message-ID: <7629a6f2-7eed-4574-a67f-5295930a1f22@gmail.com>
Date:   Tue, 9 Aug 2022 08:57:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: bgmac:`Fix a BUG triggered by wrong bytes_compl
Content-Language: en-US
To:     Sandor Bodo-Merle <sbodomerle@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Felix Fietkau <nbd@openwrt.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220808173939.193804-1-sbodomerle@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220808173939.193804-1-sbodomerle@gmail.com>
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

On 8/8/22 10:39, Sandor Bodo-Merle wrote:
> On one of our machines we got:
> 
> kernel BUG at lib/dynamic_queue_limits.c:27!\r\n
> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM\r\n
> CPU: 0 PID: 1166 Comm: irq/41-bgmac Tainted: G        W  O    4.14.275-rt132 #1\r\n
> Hardware name: BRCM XGS iProc\r\n
> task: ee3415c0 task.stack: ee32a000\r\n
> PC is at dql_completed+0x168/0x178\r\n
> LR is at bgmac_poll+0x18c/0x6d8\r\n
> pc : [<c03b9430>]    lr : [<c04b5a18>]    psr: 800a0313\r\n
> sp : ee32be14  ip : 000005ea  fp : 00000bd4\r\n
> r10: ee558500  r9 : c0116298  r8 : 00000002\r\n
> r7 : 00000000  r6 : ef128810  r5 : 01993267  r4 : 01993851\r\n
> r3 : ee558000  r2 : 000070e1  r1 : 00000bd4  r0 : ee52c180\r\n
> Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none\r\n
> Control: 12c5387d  Table: 8e88c04a  DAC: 00000051\r\n
> Process irq/41-bgmac (pid: 1166, stack limit = 0xee32a210)\r\n
> Stack: (0xee32be14 to 0xee32c000)\r\n
> be00:                                              ee558520 ee52c100 ef128810\r\n
> be20: 00000000 00000002 c0116298 c04b5a18 00000000 c0a0c8c4 c0951780 00000040\r\n
> be40: c0701780 ee558500 ee55d520 ef05b340 ef6f9780 ee558520 00000001 00000040\r\n
> be60: ffffe000 c0a56878 ef6fa040 c0952040 0000012c c0528744 ef6f97b0 fffcfb6a\r\n
> be80: c0a04104 2eda8000 c0a0c4ec c0a0d368 ee32bf44 c0153534 ee32be98 ee32be98\r\n
> bea0: ee32bea0 ee32bea0 ee32bea8 ee32bea8 00000000 c01462e4 ffffe000 ef6f22a8\r\n
> bec0: ffffe000 00000008 ee32bee4 c0147430 ffffe000 c094a2a8 00000003 ffffe000\r\n
> bee0: c0a54528 00208040 0000000c c0a0c8c4 c0a65980 c0124d3c 00000008 ee558520\r\n
> bf00: c094a23c c0a02080 00000000 c07a9910 ef136970 ef136970 ee30a440 ef136900\r\n
> bf20: ee30a440 00000001 ef136900 ee30a440 c016d990 00000000 c0108db0 c012500c\r\n
> bf40: ef136900 c016da14 ee30a464 ffffe000 00000001 c016dd14 00000000 c016db28\r\n
> bf60: ffffe000 ee21a080 ee30a400 00000000 ee32a000 ee30a440 c016dbfc ee25fd70\r\n
> bf80: ee21a09c c013edcc ee32a000 ee30a400 c013ec7c 00000000 00000000 00000000\r\n
> bfa0: 00000000 00000000 00000000 c0108470 00000000 00000000 00000000 00000000\r\n
> bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000\r\n
> bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000\r\n
> [<c03b9430>] (dql_completed) from [<c04b5a18>] (bgmac_poll+0x18c/0x6d8)\r\n
> [<c04b5a18>] (bgmac_poll) from [<c0528744>] (net_rx_action+0x1c4/0x494)\r\n
> [<c0528744>] (net_rx_action) from [<c0124d3c>] (do_current_softirqs+0x1ec/0x43c)\r\n
> [<c0124d3c>] (do_current_softirqs) from [<c012500c>] (__local_bh_enable+0x80/0x98)\r\n
> [<c012500c>] (__local_bh_enable) from [<c016da14>] (irq_forced_thread_fn+0x84/0x98)\r\n
> [<c016da14>] (irq_forced_thread_fn) from [<c016dd14>] (irq_thread+0x118/0x1c0)\r\n
> [<c016dd14>] (irq_thread) from [<c013edcc>] (kthread+0x150/0x158)\r\n
> [<c013edcc>] (kthread) from [<c0108470>] (ret_from_fork+0x14/0x24)\r\n
> Code: a83f15e0 0200001a 0630a0e1 c3ffffea (f201f0e7) \r\n
> 
> The issue seems similar to commit 90b3b339364c ("net: hisilicon: Fix a BUG
> trigered by wrong bytes_compl") and potentially introduced by commit
> b38c83dd0866 ("bgmac: simplify tx ring index handling").
> 
> If there is an RX interrupt between setting ring->end
> and netdev_sent_queue() we can hit the BUG_ON as bgmac_dma_tx_free()
> can miscalculate the queue size while called from bgmac_poll().
> 
> The machine which triggered the BUG runs a v4.14 RT kernel - but the issue
> seems present in mainline too.
> 
> Fixes: b38c83dd0866 ("bgmac: simplify tx ring index handling")
> Signed-off-by: Sandor Bodo-Merle <sbodomerle@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!
-- 
Florian
