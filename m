Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97511F348A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 08:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgFIG6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 02:58:31 -0400
Received: from mail-eopbgr40066.outbound.protection.outlook.com ([40.107.4.66]:63398
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725770AbgFIG6a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 02:58:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8JQk72lki02iAwhgi2JIBRRBBxOeLEDRfsDEK9HE869Ivzwd77O81mfvxaPhaMnzmP09rzzJ7uh2gzwEvXXpZu4ryaZeAVjG1BJK8tGAa+tAkfPN2sKdSdiByzT0Ofh3ueparjxyZW9R1XFvVS4Z+0H5cmUa/cQKRmNei8LK9s+7ohYxfKCb6QHepBwj4ILX+j3tYOl6EqJEph1WlJJ86E/RPDtCtZB6Bo+nnwliGABB9Yh28ikRAz5AYXuFgqexSOe98eyvNz+xD8H13/jhvrZwHYBLkvhLS++h3TryyqraQD3BssxE8SDbr6DkcVD2IM1qx4VEWC6yvKNV/1WXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwfbniCexmO1BaXUKybOutlIJi0ATeuUtxpiEEzu4KU=;
 b=mR1Vxrzu9NTabog/xKpjiKh2pDKgHEM7KQU2iFwm/Jo+gd4yovMy67uygKuXoR9VWY8qiv6lPZBQfctnkNH295BvU9uaCn2F9k7Pd4paSavVXx5Efq8dMq9/ItjeN0qxo3B1SA47XMV+jEJsiiP8IHlTwvR6xJ9n4FDOvoNdkqzBiaaPTiwOXcFv1/0xcULBc4+yj041A6O2F2QsrI+e2cf1hk5jLN9cCm/E2+/Irf8AGyFOJTHLZGyMoEzAhymZpneiaqQ46nYrjutgQIyEh8uk0cXlRpgc2EyyzPjCdu3Z60XKotAXRaG4d4mxunixU0JZT9xlQuBUMa7c98T2Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwfbniCexmO1BaXUKybOutlIJi0ATeuUtxpiEEzu4KU=;
 b=DGoJvZrzY595X7PqzI5JyYCj8ldm5dUqQJJM4ixIrYMUv87ow2PP3csay2UVti4zxuXUAKJ9/9gNAQhLA67PB5yQxxLDRBKmZpzgZR+tWpo4bx/ek9OKyqg07POMAuCsQbPWxye8+W58LkCz2ek5scntsAtBo8yfAQ5Bx7seXwg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB3953.eurprd05.prod.outlook.com
 (2603:10a6:208:2::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Tue, 9 Jun
 2020 06:58:25 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 06:58:25 +0000
Subject: Re: [RFC PATCH net-next 07/10] mlxsw: spectrum_ethtool: Add link
 extended state
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-8-amitc@mellanox.com>
 <7dcb004e-7bab-3026-7863-af16c1a4d556@gmail.com>
From:   Amit Cohen <amitc@mellanox.com>
Message-ID: <0e550c27-3e8a-2d70-65f1-78b300110ba0@mellanox.com>
Date:   Tue, 9 Jun 2020 09:58:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <7dcb004e-7bab-3026-7863-af16c1a4d556@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::33) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.5] (87.68.150.248) by AM0P190CA0023.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Tue, 9 Jun 2020 06:58:22 +0000
X-Originating-IP: [87.68.150.248]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bf878b8a-59ce-4ea4-d979-08d80c42812e
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3953:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB39530E053284E176530F6EE0D7820@AM0PR0502MB3953.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 042957ACD7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Omc9wJAyIOpehIsDqz7lljADwBbwmApjmLjHUAuvK5jlSAmL56IYSwIRzZqmC7CuEy1pwIegtOTRNvGV4X3N5fcg3+ifFxbENn6P+IzRGpbvQ2Ep/RasOjbN0cLziBgcV7FyAeBQWHjK9urBPx3lq7O/Or/W0abTeZieeyzcH7LNCTmI6t183ewNUi/oBfviBEzioU/hsKp/Pk9yA5UqIEaTcUjQuarNtcgdZSeZ76Kz5JdpMyT20LgjtpMM+7jKF/Zvusd0sHIvMl8ZAv20YUm9iahg2JbE7TxXYxJH3FfD/7eSipQNIgsDYjWrqZjKl/+rtbLIRNWXFs6G5hUwBJnAh77qcR7yp/8E1pAaVy/higD8SqNt00GdqrjXz8W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(31686004)(16576012)(2906002)(316002)(26005)(186003)(5660300002)(36756003)(66556008)(66476007)(6486002)(6666004)(66946007)(53546011)(2616005)(31696002)(478600001)(956004)(52116002)(8676002)(16526019)(4326008)(7416002)(4744005)(86362001)(83380400001)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: D6RO7mH6nhQi/rqLMy1vgy18rOm8sFPz5TUEW3RcFajmAItoBia0quSiWegz5WJ4vzU3ehD2G8htlem0n8fK1DY7ksW66xTMS6+rQ+GIhSavB2DubQEapiyC69zq92cG8wHYHgu9mW2Kc81xK6jbM6nCdX0AQF53du4gmhUchMnUrqb6ZCfPj7J1X1grmtqnyu3AGCKSnG1EbPnR6Os/4p8p2FxhjHKKOfrNVjf7r+lwU8EaGqtPRy8rNUYI3USfamaZclbqWzYdKGfFpGM6/hrZWOQxaHV6YxrAQgio9MrfPSHF/FtoZsQZJtjk4P00LAbh7RqfJDcIO2CMgqGpQMkix2sAc3DT1jZKQ4JdFakZLfrdvXeU7AJ/2/pJTpw2xAfppIdGVR4bhjqGSpY8dc8srsXo6Q36cdtpaJjOLkE1yQI3sjHNVpt0espw462dUwL0lyl/yLdT5gn3SRCARnWv9X6Zo+APJgcCu45+ww4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf878b8a-59ce-4ea4-d979-08d80c42812e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2020 06:58:25.0229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5AsyouWyR1RrzBCYOl2Os45ndrZT4SM5wzUb73FfuTecd5QK0wZfMkTWKoMEpNeDCcLpF43BKlcXea1pKsQP6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3953
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07-Jun-20 21:25, Florian Fainelli wrote:
> 
> 
> On 6/7/2020 7:59 AM, Amit Cohen wrote:
>> Implement .get_down_ext_state() as part of ethtool_ops.
>> Query link down reason from PDDR register and convert it to ethtool
>> ext_state.
>>
>> In case that more information than common ext_state is provided,
>> fill ext_substate also with the appropriate value.
>>
>> Signed-off-by: Amit Cohen <amitc@mellanox.com>
>> Reviewed-by: Petr Machata <petrm@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> 
> Is the firmware smart enough to report
> ETHTOOL_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED only when using a *KR
> link mode for instance, or do you need to sanitize that against the
> supported/advertised mode?
> 

This reason can appear with copper cable or backplane. At the moment it is only supported with AN and PD modes (not Force mode).
