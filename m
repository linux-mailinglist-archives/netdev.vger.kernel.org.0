Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD0D3588DD
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 17:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhDHPwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 11:52:03 -0400
Received: from mail-db8eur05on2134.outbound.protection.outlook.com ([40.107.20.134]:55553
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231480AbhDHPwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 11:52:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coHS+iBdW02orOM/NdImJ7muoeVgl6zSRm081xUf8gFMPCOQN30rcmMXy4yCOIhjj4KvdC2tojcm7lWKJxDLVvbckJIv5bdxzCEM+PPCnLijL848I4Swpe3g1kNyH04EOZndrfBvtzWQgT5Dij6BUaVIBC3fwmZy79a27N8rIjnWA/ev+3rZ3SrVq/a9OekxJtWft372isjebpezNNVKy5UwNenQo4yB9rg/VnHhFyHE4wSmLBjKc4gqCL9SZe9zbbuVXYY654S7Md3DicMDw2oX3M9JgikvNblCmDH8kD8VGHQvtZLcUugNnn0yAbGyaOjJIiQcUjUR/tu8FolqWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecUIOW5LyYut+sXClduxp5xyMCZIddfuOJkhiVEps20=;
 b=VtwxAY+21H3z4at4FG4A6bX2oQLQ5GuLDa8XTXRLSAaUtY/4042/6OrPp3YtrLCTLjdMixxYX4EIxP6PHfi1SmGhwSFz93YCnjZUztDdKrHjAnChO1P8YMLD3mSdOeIXXUKG/SJMiCaaW8r41k9t8H+lwiwmfiMThDQY/pfOMmIEurWBSVYMDjE7m3ZYD45zIco0YKnBBPdAUkOnA7MNPG6udsTSleJI5vCYv/mdUg9ia29HFzoun3Wj2Gjckkktu9hdmDbeO88GzSvE5VuJ3iSH9v33C13wNcqgpNOR2WHSgUEWdQZ6vrrv6/zDwwiI3NIlNhJFg40ZR6BXiwFwfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecUIOW5LyYut+sXClduxp5xyMCZIddfuOJkhiVEps20=;
 b=XGno+TAfZNvIeKUtqflEBKaZYcnCEZSjMEkQOdcKGEV1aH4O9yn680nWZGbh0whOETo6ZWvZiIXd4FV6/RI1AStIrxvQG/po1eRXcju18SkB9y27rnoeO13+oczNWU6mNAheCYu/7+o93Q1zQwPGvJcaObzlb8UlnrLnnTf/7jY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by VI1PR0801MB2109.eurprd08.prod.outlook.com (2603:10a6:800:8a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Thu, 8 Apr
 2021 15:51:48 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::d1ec:aee1:885c:ad1a]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::d1ec:aee1:885c:ad1a%5]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 15:51:48 +0000
Subject: Re: [PATCH] net: sched: sch_teql: fix null-pointer dereference
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210408151431.9512-1-ptikhomirov@virtuozzo.com>
 <0c385039-3780-b5d0-ba36-c1c51da9bc08@gmail.com>
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Message-ID: <a5e758d6-ccc8-643c-1409-7ce0d1bcba1f@virtuozzo.com>
Date:   Thu, 8 Apr 2021 18:51:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <0c385039-3780-b5d0-ba36-c1c51da9bc08@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.200.17.122]
X-ClientProxiedBy: AM0PR04CA0063.eurprd04.prod.outlook.com
 (2603:10a6:208:1::40) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.192] (81.200.17.122) by AM0PR04CA0063.eurprd04.prod.outlook.com (2603:10a6:208:1::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 15:51:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aee6484e-cd7c-48bf-1205-08d8faa6381c
X-MS-TrafficTypeDiagnostic: VI1PR0801MB2109:
X-Microsoft-Antispam-PRVS: <VI1PR0801MB2109723883DBD1515C4F65C6B7749@VI1PR0801MB2109.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4gqdNdrakjdBYzEzEi8oxCxLSDdhxcQVZRyLHR1kJvGCgjScwbNKJZV5VZ/yY0myDhtd0SI1fNphJHTkNPWlknjnRrc4WNxyGJ5iQuTthgQ0xUjd0g1gHG7k9BDMuk1ZYT8JalklI8jmqsoI6J/yI2iYI2VLZ4umv8POLzNPSfArYLtQUiUixPD2gnVK/UTcnpUY/W40+84ff4ho0XjsjdOa1vdx5mNo/v4KltbYdeEbERpbCKggGmtS901fb6pJ7a2u4ouZCcSr6q9Um0/rXbq0Yg3r2cx02M0K9LRmKlm1pJVg4nLgjHednUE9FCn6WPWlHlFDrYekWn8JRS+7gvRtHqfTo+1NJcMxZJmiFY+xr2zt34oCie67KyGxxt8naYCuNW96GsnLEBA48T64H1XvE312xeMR+VdW+YuGV1Km97hWhPX9hqAqNbiPrix/lRmMWtQzfUoxUiycGJyamJzc6t+jA3ZUFKf/E7fy5T2DP4Mhrnicjoa+QQKilY67GKXyHNpEgTmWWA76P5cWsanGklxbedVlz5LGUNn/UWmOd4tYjyhyxx10G6KDdcjk00iWpnyDy3tNwboiQZ/CtRsrn3vy7WK0b/RmrnVb5S6pa0d+OZBDi+tU27SVBIjULWqIeAWhTpjlRyC9T6u+Cip3I5hETtx/nr2Kh6zod7OTJGH5+L7T+00gnwvJIOpEFMq5/A5GdmDW1ON8VEvgxSDSzTstKm7dUqM+/8SnIA2/dD0YkoJbN0PJfL72d61llLGxv+tu7pl1nc9AVa01FaIR+mQWDFrdgISkOeGGioMI2c69ueEZ9vXSDrIGpuy2cfvT3kc5Im8wEhfhRbAbtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(54906003)(966005)(316002)(31696002)(86362001)(52116002)(66946007)(8676002)(478600001)(83380400001)(2616005)(5660300002)(8936002)(6486002)(38350700001)(110136005)(2906002)(956004)(36756003)(4326008)(186003)(66476007)(31686004)(16526019)(66556008)(16576012)(53546011)(26005)(38100700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N3BCNEdad3lmeXU3V0tQdmc2bUVWejZxWWRVMlp0ak9jbjdEMjcvYlFMSm0x?=
 =?utf-8?B?d20yc01mbWlmVkczR0VGRVQxak53dVI3aTg2UnZMeVVEL1EwbGdDbm5IR1Fv?=
 =?utf-8?B?Zy9CZmtlWS9rSE9hbER1NGEwajVsRWh1TTgwTXZFd2lSa3R5b05ueDdUNGtZ?=
 =?utf-8?B?WXpKZEpFcjJOdW9Da3dTWU9RT21yUzB6ZXNwWklLRk1HRGRSUWtjZFJ1ZGZN?=
 =?utf-8?B?MkRtdTgvWGk0VnBEVDdSSTZXd1V0TngrUGt0bE56bndrbzRHdXJvRXVBaDd4?=
 =?utf-8?B?RWZXUmJ2VlZ3OUw2SVZnWVVTamd2ODY4Z1RnTVhzQ2RZQnBUSGN1d3RTeXUz?=
 =?utf-8?B?T255bVZZQUFhZVBFak8yRDBUVEFIR3pINEk1cks4VnFCNjgrU2dzcFJ5OHhv?=
 =?utf-8?B?QzlpekhMakQzV2kyYi9uZ2FLTU80US8xWlhmZWlIQ05qRU5VR2ZmYU42Q0lI?=
 =?utf-8?B?QXlSaUdLYm5vMmpzSzdiYUc4cG5YL1FZR3FBd0lnL1dVblhOVityTkl6VCti?=
 =?utf-8?B?UHRsSVhmZWpNeis1VE03YzdOZ1BYQW93dGJnTkp6a1ovR3krYWJLcElxajZT?=
 =?utf-8?B?dlM5VWVZWTZ0SkVIc3g3NDhpSm56WkJnSkJub1JqNWJxekpQOTVtQWVjNGNS?=
 =?utf-8?B?ZzJMeW5IOU1qaEZ2eW9vMjJOaWlCd0E5ZHBiNjN2Q1U1RDJGWVNKT1JiZU5I?=
 =?utf-8?B?T1FWdHhDOGszcFdvV2dQRzdFTmR5YzdobXkzc2pqb01DZ05HNTE0MGEvamQy?=
 =?utf-8?B?T0hEUG5qN1hMYkhkaDNyd1I5cUJjTjFNRjhMZ3ZxZitLQnljVTA0dFpHMmdh?=
 =?utf-8?B?cHpjR3kxc0pGdERSYkMraXVtbHUxTXlMMVRzb3BkeUh2Z0tHUTNIeG9EOElH?=
 =?utf-8?B?WVRjTHR6bkl1UHI2eWlOREs4ekZiNFhMQTZqblJnTFNWbmlBQXczRitvbTln?=
 =?utf-8?B?T0ErcmlWOVdUSENkRWRKS2tBWWhmZlNkdlpWNm5nQTM3clB0cXNNUEFCWjVx?=
 =?utf-8?B?eENWV2JId2FmcllyYll3YXBMOCtuUDhIbFBJMWhQZnk5OEI2OFR1c1lXWGF3?=
 =?utf-8?B?QnErUXpoOGhuMHp2WDlTNitwWEFNQmlJWC9oQ05id3VSekhwNmR6SzFUMW9D?=
 =?utf-8?B?Q2dKYkd6QWlMZnc5cjVoVUN5dmp4a0s0SGZCUExnd0swc25vdFFpVEZCdlhw?=
 =?utf-8?B?U2tONmRwY1ZrRmZ2ZjQwRXRYR3dVK0Via29YSGhlYWk0S1kzWUFHYjFpVVJT?=
 =?utf-8?B?Rk5rcks3bDZJbGxKSzM2N3lrN3FPSEZQQXNxMmM4N0ZnWGJ1MEk1VXYzWUlO?=
 =?utf-8?B?N2d5WUI5T25BSXBpQ2h4ZkkxLytvelJTNFhIWFQzdFd6MGg2dWhxSGN0REhM?=
 =?utf-8?B?Q1pnUkc2cGpwTEI2b0tLcHUwSjNTc210bnI2RTlCNGVZVW5PT21UMmtDSkxM?=
 =?utf-8?B?ZHZ5Q0hDV0JoRjd6c1M4R2gxTndpRExVSDFKTUppbktoV3dFZlRyUng2Q1J0?=
 =?utf-8?B?RmdOM3lDTk0waUdEM1lpSUhQUjdVdE9UV1VYYWZxd3NwTDRCNVh5bzNYeWZh?=
 =?utf-8?B?UkZ1SERQbkpPL29NSmh3OEI1MU5xK1IyTk5IYnJlOVh0Uy91c3pjMGcyMU9v?=
 =?utf-8?B?V3d0L05vaXJxVjhiSkM2eXFFUVduZ044QmxzbnMxQnNidjh3c25ZaGVqVlVI?=
 =?utf-8?B?S3QwV3FKbGNINlhsRytib1RsMWNJODRoVFN4L0QvV1B0S21rU1NRVlJrVzJW?=
 =?utf-8?Q?Nl1gVr5CtW+xwtqkbgwtJFVDFGJa46QgtMg5nfG?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aee6484e-cd7c-48bf-1205-08d8faa6381c
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 15:51:48.7393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XgNwKNHP7d9AEK83E0v7RJuHPJ1fQ6Mgm2oF9QNV+HKYEY+UGMLyh53YMOZ8J25v5/371sQIw2c9SgEmU7WxdfszEYDqITkYD8yCbFcxRzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB2109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/8/21 6:26 PM, Eric Dumazet wrote:
> 
> 
> On 4/8/21 5:14 PM, Pavel Tikhomirov wrote:
>> Reproduce:
>>
>>    modprobe sch_teql
>>    tc qdisc add dev teql0 root teql0
>>
>> This leads to (for instance in Centos 7 VM) OOPS:
>>
>>
>>
>> Null pointer dereference happens on master->slaves dereference in
>> teql_destroy() as master is null-pointer.
>>
>> When qdisc_create() calls teql_qdisc_init() it imediately fails after
>> check "if (m->dev == dev)" because both devices are teql0, and it does
>> not set qdisc_priv(sch)->m leaving it zero on error path, then
>> qdisc_create() imediately calls teql_destroy() which does not expect
>> zero master pointer and we get OOPS.
>>
>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>> ---
> 
> This makes sense, thanks !
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks!

> 
> I would think bug origin is
> 
> Fixes: 87b60cfacf9f ("net_sched: fix error recovery at qdisc creation")
> 
> Can you confirm you have this backported to 3.10.0-1062.7.1.el7.x86_64 ?
> 

According to our source copy it looks backported to 1062.7.1, please see:
https://src.openvz.org/projects/OVZ/repos/vzkernel/browse/net/sched/sch_api.c?at=refs%2Ftags%2Frh7-3.10.0-1062.7.1.el7#1167

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
