Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF0460680F
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiJTSSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJTSSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:18:17 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141192A70E
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:18:15 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id a18so522465qko.0
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YNdPx9O5euUhDJMz7WaT2WiuYbxbt3FHOSwAmndunww=;
        b=bjUTSa4pSc5uYn5Mu0Cp66yb10ABCznen5d7DgCdx6F33Fzrai/UvyFJ0jCmNKvm2m
         kRI54cbR/18kb2tugZspr31VJ3i1QGttdTl3umgS91nJPbNk1fZn1l80T/a3oXXG6nmE
         vXTjrW3WnqZfCUxlH5T47AZF/m+GNilgAH/Ai2OfKJlvfEr2GAkZEwNPRGhESq0UylwT
         oq7Nh3sEQqGuUh20WqCiIfWcj6XfLlRLZ5vH/+T+JE3Dj0U1D5G3Y18R5UR6ksV78gxp
         2GxCRWJKfx9ktVFVJK3RrrZWi9+JVS5aIk7xgQdIrkrCoQAYDNoR9cOIHzA3nh/PhdYu
         BaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YNdPx9O5euUhDJMz7WaT2WiuYbxbt3FHOSwAmndunww=;
        b=S9Sgb8gMY7w1FQ9+MBOYWkFbhMHbWObuljcYfUSs7QNfr9VGK5xW5jFooJa9k7wxNl
         H2I6oFmpIaF0ET2ZuqQzbDA2y1eXddGQwu2YnLwtK+660bYLFY1HQZjPPv2VnHqfnkjE
         RSN6KNlo/v9FnB6qFGh5tR5flcMY94zy6VicmqZ+p7oI9hrI5FZAaoi+INmMvaFhXkjZ
         OOygTjgX4Aw03u7oZKYn35INkJb8yy9qBeHDrDvdXWtTCxl2rGsFSwtzqmCTPr8M1S63
         v+QdFuwqSVan13fMS3Z9MNtsLwT8iM2VO/LOxHdYyzo09X96zMcfTv0JlpzHgw6aoLqI
         u6SA==
X-Gm-Message-State: ACrzQf29OM1MrZscB9ih/tgxNWMCcEe9MirhOgVhnQLycFRSK6KVz5Ba
        BRrUIX00K7Bq+rMCXVhXKdQXPA==
X-Google-Smtp-Source: AMsMyM6uaXeGLamozQX44irnQtPEdqkBIO+GO61SsjCLfxZxSTg0aKXpqk6z2VpyIPel9XbZKEaT0g==
X-Received: by 2002:a05:620a:284b:b0:6b4:8685:2aa6 with SMTP id h11-20020a05620a284b00b006b486852aa6mr10571977qkp.780.1666289894118;
        Thu, 20 Oct 2022 11:18:14 -0700 (PDT)
Received: from [192.168.10.124] (pool-72-83-177-149.washdc.east.verizon.net. [72.83.177.149])
        by smtp.gmail.com with ESMTPSA id w22-20020a05620a445600b006bbc09af9f5sm1785119qkp.101.2022.10.20.11.18.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 11:18:12 -0700 (PDT)
Message-ID: <f5b4aff3-6dd8-1dd1-6a60-c295f8b87f92@linaro.org>
Date:   Thu, 20 Oct 2022 14:18:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3] nfc: virtual_ncidev: Fix memory leak in
 virtual_nci_send()
Content-Language: en-US
To:     Shang XiaoJing <shangxiaojing@huawei.com>, bongsu.jeon@samsung.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
References: <20221020030505.15572-1-shangxiaojing@huawei.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221020030505.15572-1-shangxiaojing@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/10/2022 23:05, Shang XiaoJing wrote:
> skb should be free in virtual_nci_send(), otherwise kmemleak will report
> memleak.
> 
> Steps for reproduction (simulated in qemu):
> 	cd tools/testing/selftests/nci
> 	make
> 	./nci_dev
> 
> BUG: memory leak
> unreferenced object 0xffff888107588000 (size 208):
>   comm "nci_dev", pid 206, jiffies 4294945376 (age 368.248s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<000000008d94c8fd>] __alloc_skb+0x1da/0x290
>     [<00000000278bc7f8>] nci_send_cmd+0xa3/0x350
>     [<0000000081256a22>] nci_reset_req+0x6b/0xa0
>     [<000000009e721112>] __nci_request+0x90/0x250
>     [<000000005d556e59>] nci_dev_up+0x217/0x5b0
>     [<00000000e618ce62>] nfc_dev_up+0x114/0x220
>     [<00000000981e226b>] nfc_genl_dev_up+0x94/0xe0
>     [<000000009bb03517>] genl_family_rcv_msg_doit.isra.14+0x228/0x2d0
>     [<00000000b7f8c101>] genl_rcv_msg+0x35c/0x640
>     [<00000000c94075ff>] netlink_rcv_skb+0x11e/0x350
>     [<00000000440cfb1e>] genl_rcv+0x24/0x40
>     [<0000000062593b40>] netlink_unicast+0x43f/0x640
>     [<000000001d0b13cc>] netlink_sendmsg+0x73a/0xbf0
>     [<000000003272487f>] __sys_sendto+0x324/0x370
>     [<00000000ef9f1747>] __x64_sys_sendto+0xdd/0x1b0
>     [<000000001e437841>] do_syscall_64+0x3f/0x90
> 
> Fixes: e624e6c3e777 ("nfc: Add a virtual nci device driver")
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

