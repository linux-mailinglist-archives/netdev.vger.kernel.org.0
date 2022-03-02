Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB47B4C9C5F
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 05:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237867AbiCBENv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 23:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiCBENu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 23:13:50 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D13F5DA77;
        Tue,  1 Mar 2022 20:13:07 -0800 (PST)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4K7gfr5cPrzdZj5;
        Wed,  2 Mar 2022 12:11:48 +0800 (CST)
Received: from [10.174.178.165] (10.174.178.165) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 12:13:05 +0800
Subject: Re: [PATCH V2] net/nfc/nci: fix infoleak in struct
 nci_set_config_param
To:     "cgel.zte@gmail.com" <cgel.zte@gmail.com>,
        "krzysztof.kozlowski@canonical.com" 
        <krzysztof.kozlowski@canonical.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20220302033307.2054766-1-chi.minghao@zte.com.cn>
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
Message-ID: <656cec43-5810-3626-2251-7db2f8868f95@huawei.com>
Date:   Wed, 2 Mar 2022 12:13:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20220302033307.2054766-1-chi.minghao@zte.com.cn>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.165]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>
>
> On 64-bit systems, struct nci_set_config_param has
> an added padding of 7 bytes between struct members
> id and len. Even though all struct members are initialized,
> the 7-byte hole will contain data from the kernel stack.
> This patch zeroes out struct nci_set_config_param before
> usage, preventing infoleaks to userspace.


How this info leaks to userspace?


nci_set_config_req() convert to use packed 'struct nci_core_set_config_cmd'

to send data, which does not contain hole.


