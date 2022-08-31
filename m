Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B625A7E98
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiHaNVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiHaNU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:20:59 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F90A5FAEE;
        Wed, 31 Aug 2022 06:20:53 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 404AF7F53D;
        Wed, 31 Aug 2022 15:02:47 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E95B34064;
        Wed, 31 Aug 2022 15:02:47 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14A9A3405A;
        Wed, 31 Aug 2022 15:02:47 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Wed, 31 Aug 2022 15:02:47 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id E04B77F53D;
        Wed, 31 Aug 2022 15:02:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1661950966; bh=yHmMGWL3S8mjqUWAfdTC8rN+cSbGeS9rQTO23WI3AVM=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=FfoXSe7kUgnpcAt1Nt2fFpVvevf7l05BCeK+/MZ+QIcf3W+yzNOI2LKbuy23nOsNH
         Ko5LTv+0tpod9l0ih89ml5ILj+hGKpP2+uMbtpsi55C8hM2ayw0UlMy2DWim5HxDnV
         eAcojqlOrVy027r+RLR8DodtZKunUZPoWLp+M+4EoW7q5x0Z+vKjuKB3+BkPLStcUb
         gN8K1ry2QujyrXeMlHOmsu/2urEbPugSbbtQ+JHZbc2yNBQn6Zve9fOqf4b1bMHSwC
         lj4iSS1bDDXVCGvX+0Qm4jBqzgFrTBlycZxcw5pwiKtTMVmMnPp3uz4X+6lT8NDJ53
         R+IxmpmeUTHSg==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.12; Wed, 31
 Aug 2022 15:02:46 +0200
Message-ID: <243d3362-403d-7a94-34fa-12385100cc53@prolan.hu>
Date:   Wed, 31 Aug 2022 15:02:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH AUTOSEL 5.19 24/33] fec: Restart PPS after link state
 change
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
 <20220830171825.580603-24-sashal@kernel.org>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <20220830171825.580603-24-sashal@kernel.org>
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


On 2022. 08. 30. 19:18, Sasha Levin wrote:
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
off on backporting to 5.19 until the bugfix is applied to upstream.
