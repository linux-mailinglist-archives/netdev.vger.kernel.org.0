Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309355A7E97
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiHaNU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiHaNU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:20:58 -0400
X-Greylist: delayed 602 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 Aug 2022 06:20:56 PDT
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7735E12A90;
        Wed, 31 Aug 2022 06:20:53 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id C50867F540;
        Wed, 31 Aug 2022 15:03:40 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B23E634064;
        Wed, 31 Aug 2022 15:03:40 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 998BF3405A;
        Wed, 31 Aug 2022 15:03:40 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Wed, 31 Aug 2022 15:03:40 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id 638A87F540;
        Wed, 31 Aug 2022 15:03:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1661951020; bh=qhxZovzJ5NVCosNILHzZdGtbXVH9Dqfa+uvEWfbbrmc=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=aEMO8oJXfSHFlMjIzvmMgbgIrFZwBRAR95OrDPIOGjcUyUW6foQCnmzUWARsYxtN9
         WajvJhrDuPneRRADIxh0waVrHfqwCn6u+9Gzwaa3Ot5lyr7E6TNMemqnGqBbl8wsL0
         3V2AzcyDXexu9k9rNffH+agpADSAfrU3A0Qaadsn9fj2uDz9P806WyCKl/8iegYV+U
         8XciyLlR3lkGvU0yW7aVuFM/AApP3RKBQgnSQkFF2lzcDe4/V8ST6CLN/MGAjkmXui
         iYWhwGoXzMz+qJmG4j9u16YmokUe/Vf6aEso2l+vwpj9Lr2f9adED+iyNwm2lsvG+T
         KxgAI3aivpBSQ==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.12; Wed, 31
 Aug 2022 15:03:40 +0200
Message-ID: <0d6d1182-921e-1da2-b315-427f25228d12@prolan.hu>
Date:   Wed, 31 Aug 2022 15:03:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH AUTOSEL 5.15 17/23] fec: Restart PPS after link state
 change
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20220830172141.581086-1-sashal@kernel.org>
 <20220830172141.581086-17-sashal@kernel.org>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <20220830172141.581086-17-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.254.7.28]
X-ClientProxiedBy: atlas.intranet.prolan.hu (10.254.0.229) To
 atlas.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A29971EF456637D67
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022. 08. 30. 19:21, Sasha Levin wrote:
> From: Csókás Bence <csokas.bence@prolan.hu>
> 
> [ Upstream commit f79959220fa5fbda939592bf91c7a9ea90419040 ]
> 
> On link state change, the controller gets reset,
> causing PPS to drop out and the PHC to lose its
> time and calibration. So we restart it if needed,
> restoring calibration and time registers.

There is an ongoing investigation on netdev@ about a potential kernel 
panic on kernels newer than 5.12 with this patch applied. Please hold 
off on backporting to 5.15 until the bugfix is applied to upstream.
