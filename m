Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7290602DEA
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJROHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiJROHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:07:09 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E546D38EF
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 07:06:55 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id i9so9358017qvu.1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 07:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nXRJ+mGKI4IITMPw7WKeDO1MEUZ8nODWRpoS6eImTWQ=;
        b=EIicTXfSh/1gxMQW7tomkB1uK3Xst4+o2WwLU5zE2tGYlNF1/Zr0LYcag/oeQ2NpDD
         z0VBNQSaGYXTuwgtlQP2+C2pzEdAwiy9TGOg7bl6l5kN3suFirbx/DxfuBzcMOdF4o8O
         RbG37kzmeOTI5lOxc8p96IduM0ZU8XWy04a/J8RvjA82gR0X/v91q+p3336l3hhZb+P1
         hKyyfG33mFmpLKh5mW7KKFnPgTmFw+fUulJsrdvLMDrE6cPAlx9/G1ib2LxReZPPWPd4
         pDgc9KkMX5C3VBYsGQf3d+XY/HqvR/Qs+Tn9tMYrAkCf0Yh4WPzvaqIZMUfpI3kd2q/t
         tspw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nXRJ+mGKI4IITMPw7WKeDO1MEUZ8nODWRpoS6eImTWQ=;
        b=5xJxdfkNtM3mX9s/GVQDlsWSHNno75DDkoQjEErp75x8AvZq5vPkTRaFzqdRDtXPdw
         DV4Axt01CPLnwoOeMIMquyZieL5X/LHVmupCVbAKiahKAPSSY9mtRVWny6czhO4XN4EM
         p1V4gqDbNKWLN/V5IMuzdvoTYamqATj5U/3PsTdVOe1FtNWNlOryl5n2X4nfjG471e/1
         Ov4i/9voBVvs33XWRR/XjrZec4NKdDeTgv54Eu9zIzqqb4lokAZKgAaQQ1FmO5ndnkfA
         TWJSHCk5n9zjcwDnUKf0mv/cTCQvv6nfAzdcyRwjJRiAukYRA79U9O68LYszJx9AxnD1
         3YWQ==
X-Gm-Message-State: ACrzQf0gW6LnCZ0wqnC2ydeg9HusvFWombDbFr0IR/PVNlwEgIY0Sjig
        BcvpnISjIM/8XGK3Na+8cgY6GA==
X-Google-Smtp-Source: AMsMyM4PDfjmdcT/91AoIodppykQEeu/pBOnsv41Jj2C2tTj/VoT8LBeakbWMgvjdG/T/M+9rY3P0g==
X-Received: by 2002:a05:6214:29e3:b0:4b3:f368:de31 with SMTP id jv3-20020a05621429e300b004b3f368de31mr2433896qvb.127.1666102014405;
        Tue, 18 Oct 2022 07:06:54 -0700 (PDT)
Received: from [192.168.10.124] (pool-72-83-177-149.washdc.east.verizon.net. [72.83.177.149])
        by smtp.gmail.com with ESMTPSA id q26-20020a37f71a000000b006ed519554cfsm2314638qkj.61.2022.10.18.07.06.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 07:06:53 -0700 (PDT)
Message-ID: <a14a28c7-946d-fa2b-f3f1-69faaf269fbf@linaro.org>
Date:   Tue, 18 Oct 2022 10:06:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2] nfc: virtual_ncidev: Fix memory leak in
 virtual_nci_send()
Content-Language: en-US
To:     Shang XiaoJing <shangxiaojing@huawei.com>, bongsu.jeon@samsung.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
References: <20221018114935.8871-1-shangxiaojing@huawei.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221018114935.8871-1-shangxiaojing@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/10/2022 07:49, Shang XiaoJing wrote:
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
> changes in v2:
> - free skb in error paths too.
> ---
>  drivers/nfc/virtual_ncidev.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> index f577449e4935..3a4ad95b40a7 100644
> --- a/drivers/nfc/virtual_ncidev.c
> +++ b/drivers/nfc/virtual_ncidev.c
> @@ -54,16 +54,19 @@ static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
>  	mutex_lock(&nci_mutex);
>  	if (state != virtual_ncidev_enabled) {
>  		mutex_unlock(&nci_mutex);
> +		consume_skb(skb);

Ehhh... This looks ok, but now I wonder why none of other NCI send
driver do it. If the finding is correct, all drivers have same issue.

>  		return 0;
>  	}
>  
>  	if (send_buff) {
>  		mutex_unlock(&nci_mutex);
> +		consume_skb(skb);
>  		return -1;
>  	}
>  	send_buff = skb_copy(skb, GFP_KERNEL);
>  	mutex_unlock(&nci_mutex);
>  	wake_up_interruptible(&wq);
> +	consume_skb(skb);

This also looks ok and as well all drivers seem to be affected.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

