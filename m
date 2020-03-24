Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9DA01914BF
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 16:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgCXPiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 11:38:18 -0400
Received: from mail-db8eur05on2042.outbound.protection.outlook.com ([40.107.20.42]:35809
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727724AbgCXPiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 11:38:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEcVdt+nTE/0vxYvp1oKMH3hmMydUFqLHZAE2yN6MpVsvrfoCtI/t6GHGcilctY/iPP9JeuAflfeG8877KuaNyHR1pMysjy6WiUnRwBkRVyo916jEN9coVTKHU7gcQKs6Dcqh9USmX2E84RxdIhgwYCEE/MSsRt01a46ZYarlleX21n8eQ2vrjr8gdv9+VgrMObPvUU3pRt+HoCIGKPXOEob8b0aHmy274IHCXNd1DHC0hwb1TghqOSODW+SJXVBmBz2AuX9J6OZiorzA2yjsHymNXA9B1Bm97lnVTDyzprL5oKdJrSOpKO9d/iLaNIVor7QCCqTQ2fsdcSMsGbZpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nd4x7nIqZlfmLEjJZGMTPpo0hSOPxbZ9HaotZGHhT9E=;
 b=gNp70PL2Zdpt1ZsyAT23dTFlEgfEZaCXv3kLR2TWMh1CQJWMhoveZKdccHEoi/CVUd/E7SW0jGvUbt+P55DVYAeP/JYNYEla5yBVqC9FjrheLs1cKddBWOviIpDlSELZ0CKxa9c9Or+arHCQoxGyUUrhKW7KmAvVntUv5siAd61lrZvJcFfQ4pDkTtik/LkGdW+rPptzUr3a/ZF4b9tkHuFQGxuvubGUtECyXF8KEivkLlrjuUEsPmOdEb3fw6UJihNCQpGMzG7+mq9AHOxj0UoqZbAC7/CgIDEw+s18S9MU3qLFfpsUZJgZZ8xvU8li0oAeiZ7L70PKZTB3C/jjow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nd4x7nIqZlfmLEjJZGMTPpo0hSOPxbZ9HaotZGHhT9E=;
 b=qiPO0MYzchgAknWlf/QVEK+XO6ViAIsxgPqUnfBrWG4BxN6yOa8fClWeyz5ejPVEdcKiRueHSh2ToXd0SIXGKmhrBw6FHej/omrSXn5eeMl/OeXYbhG6Ovweg8ETnsDMMfCgrAoKdhJmFlzYXaTg0rHdnVDXTpRuyW17n+6A5oU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=ayal@mellanox.com; 
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com (20.179.44.85) by
 DBBPR05MB6459.eurprd05.prod.outlook.com (20.179.42.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Tue, 24 Mar 2020 15:38:14 +0000
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::c26:3947:26dd:b913]) by DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::c26:3947:26dd:b913%5]) with mapi id 15.20.2835.023; Tue, 24 Mar 2020
 15:38:14 +0000
Subject: Re: [PATCH V2 ethtool] ethtool: Add support for Low Latency Reed
 Solomon
To:     Michal Kubecek <mkubecek@suse.cz>,
        Tariq Toukan <tariqt@mellanox.com>
Cc:     "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>
References: <20200324140141.20979-1-tariqt@mellanox.com>
 <20200324145415.GQ31519@unicorn.suse.cz>
From:   Aya Levin <ayal@mellanox.com>
Message-ID: <feb923c2-123c-22d0-038a-23fd1e8c4411@mellanox.com>
Date:   Tue, 24 Mar 2020 17:38:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <20200324145415.GQ31519@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0019.eurprd04.prod.outlook.com
 (2603:10a6:208:122::32) To DBBPR05MB6299.eurprd05.prod.outlook.com
 (2603:10a6:10:d1::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.13] (77.138.160.220) by AM0PR04CA0019.eurprd04.prod.outlook.com (2603:10a6:208:122::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Tue, 24 Mar 2020 15:38:13 +0000
X-Originating-IP: [77.138.160.220]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1dee5298-afc1-4271-84fb-08d7d0095dd9
X-MS-TrafficTypeDiagnostic: DBBPR05MB6459:|DBBPR05MB6459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR05MB6459DD24B93732D3D388E2A8B0F10@DBBPR05MB6459.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(110136005)(16526019)(31686004)(54906003)(316002)(16576012)(4326008)(52116002)(8676002)(5660300002)(956004)(2616005)(81156014)(81166006)(2906002)(53546011)(8936002)(478600001)(26005)(186003)(6636002)(36756003)(31696002)(107886003)(66556008)(86362001)(6486002)(66476007)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6459;H:DBBPR05MB6299.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ey2veZoZVlinj+ybRXtBGqCfKMTQtTB7GuWb1yzWSQz91/E7s+WqZFqJmIyS8UwgLp/Wh9noFCjYgO3NB/JHQU209Y1CC3cHCO3wK5tMRLe9rvrRiv4JO1KFE9ZY269UlVickS0MEma3liQqoeikoV7WyGWfKdMCZJOs3IZK0uOXMyOD3huv43NnXcwk+EZkJnNaSFaFF1q42W6OgwmAY2YpAOJ4PGxwdoIXIlM4NkmhPfuj4YNOJZSSgjKjAlNvf8wMPVdHPW9pWAI3qaS1uVQLH4hTzSgyv3oI5S+UdSmGiMDOZgwcF1S/U2P8/f7VLPSJ89VHSKQYYZCL3nbhb9NA9idCwDZ2z649Qv96oXyUGwz/bmsdoH4RMCToPnBk2f6DkDgesGSDdwnrOUyi1Htz2AP5vipKzVaD5AnJ9Lmccow/56V1Tut++kc7946r
X-MS-Exchange-AntiSpam-MessageData: KKfBw6sG770zNOYQ2yoYUmfPBgIlwzYc6BX/KTMsvZs7Br4iRibRMmgqWOj70XOjdaWefhsNC4+PikGQSOfQcbuZVpKwdHd4i3oLaOc4bK5G9+GH1vs11bXSMjn4ik+Zd+r8TvVhKmaFk3G7dY/fDw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dee5298-afc1-4271-84fb-08d7d0095dd9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 15:38:14.5713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 59TFIcdttuSRf0m9bRYdNpKA1bYJHQ80U05i0d1ZLC41QCyBZBSIFq5ambDJhwFBrHo0OeqHRELaJRYfr6oR7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6459
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/2020 4:54 PM, Michal Kubecek wrote:
> On Tue, Mar 24, 2020 at 04:01:41PM +0200, Tariq Toukan wrote:
>> From: Aya Levin <ayal@mellanox.com>
>>
>> Introduce a new FEC mode LL-RS: Low Latency Reed Solomon, update print
>> and initialization functions accordingly. In addition, update related
>> man page.
>>
>> Signed-off-by: Aya Levin <ayal@mellanox.com>
>> Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
>> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>> ---
> [...]
>> @@ -754,6 +755,12 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
>>   			fprintf(stdout, " RS");
>>   			fecreported = 1;
>>   		}
>> +		if (ethtool_link_mode_test_bit(ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
>> +					       mask)) {
>> +			fprintf(stdout, " LL-RS");
>> +			fecreported = 1;
>> +		}
>> +
>>   		if (!fecreported)
>>   			fprintf(stdout, " Not reported");
>>   		fprintf(stdout, "\n");
> 
> Kernel uses "LLRS" for this bit since commit f623e5970501 ("ethtool: Add
> support for low latency RS FEC") so if you use "LL-RS" here, the output
> will differ between ioctl and netlink code paths.
> 
> It's not necessary to use the same name also for --show-fec/--set-fec
> (string set and netlink support for these is still work in progress) but
> it would IMHO be better to be consistent.

Thanks for this comment, will re-spin shortly and lose the hyphen altogether
> 
> Michal Kubecek
> 
