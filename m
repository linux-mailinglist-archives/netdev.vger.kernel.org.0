Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A49B6333C0
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 04:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiKVDMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 22:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiKVDMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 22:12:06 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B681178B2;
        Mon, 21 Nov 2022 19:12:05 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NGTn06sVmz15Mn8;
        Tue, 22 Nov 2022 11:11:32 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 11:12:01 +0800
Subject: Re: [PATCH -next] crypto: ccree - Fix section mismatch due to
 cc_debugfs_global_fini()
To:     <s.shtylyov@omp.ru>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <yoshihiro.shimoda.uh@renesas.com>
CC:     <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221122030542.23920-1-yuehaibing@huawei.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <e3a466e7-5c5d-1288-9918-982edf597c24@huawei.com>
Date:   Tue, 22 Nov 2022 11:12:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20221122030542.23920-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry， Pls ignore this.

On 2022/11/22 11:05, YueHaibing wrote:
> cc_debugfs_global_fini() is marked with __exit now, however it is used
> in __init ccree_init() for cleanup. Remove the __exit annotation to fix
> build warning:
>
> WARNING: modpost: drivers/crypto/ccree/ccree.o: section mismatch in reference: init_module (section: .init.text) -> cc_debugfs_global_fini (section: .exit.text)
>
> Fixes: 4f1c596df706 ("crypto: ccree - Remove debugfs when platform_driver_register failed")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/ccree/cc_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_debugfs.c
> index 7083767602fc..8f008f024f8f 100644
> --- a/drivers/crypto/ccree/cc_debugfs.c
> +++ b/drivers/crypto/ccree/cc_debugfs.c
> @@ -55,7 +55,7 @@ void __init cc_debugfs_global_init(void)
>  	cc_debugfs_dir = debugfs_create_dir("ccree", NULL);
>  }
>  
> -void __exit cc_debugfs_global_fini(void)
> +void cc_debugfs_global_fini(void)
>  {
>  	debugfs_remove(cc_debugfs_dir);
>  }
