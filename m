Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B23D63CEB0
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiK3FYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbiK3FYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:24:36 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C317276143;
        Tue, 29 Nov 2022 21:24:34 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2AU5O5FB043970;
        Tue, 29 Nov 2022 23:24:05 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1669785845;
        bh=v9JCM7cinCQxkLHmBdwigheft5PArJwsd1wyyLAA4+E=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=SBBfUakvyFfIRXptuT/SelEqS3T4f7LFdbob8fELr5cVDbTirwZ7DGNUM8PHXB4tf
         /cOA3A2GOezRaK/b03YvV4Z/fmRsYByXu/AyXNtNa9pzzVUUlsosN1ewj/cOdm9ri4
         YyjiLNc4lRpWUbPmv6P6B0/RWnwaLH+YGeYn+0OI=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2AU5O5sh119362
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Nov 2022 23:24:05 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 29
 Nov 2022 23:24:05 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 29 Nov 2022 23:24:05 -0600
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2AU5O0FK084785;
        Tue, 29 Nov 2022 23:24:01 -0600
Message-ID: <c31f226f-dd6c-3235-ada3-6a69b66e156d@ti.com>
Date:   Wed, 30 Nov 2022 10:54:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        <pabeni@redhat.com>, <rogerq@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <spatton@ti.com>, <s-vadapalli@ti.com>
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: Fix RGMII configuration
 at SPEED_10
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
References: <20221129050639.111142-1-s-vadapalli@ti.com>
 <CALs4sv29ZdyK-k0d9_FrRPd_v_6GrC_NU_dYnU5rLWmYxVM2Zg@mail.gmail.com>
Content-Language: en-US
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <CALs4sv29ZdyK-k0d9_FrRPd_v_6GrC_NU_dYnU5rLWmYxVM2Zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 29/11/22 11:16, Pavan Chebbi wrote:
> Looks like this patch should be directed to net-next?

The commit fixed by this patch is a part of the released kernel. Thus, I
think it should be a part of net instead of net-next. Please let me know.

Regards,
Siddharth.
