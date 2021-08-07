Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6553E35C2
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 15:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhHGN5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 09:57:48 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:25428 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232265AbhHGN5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 09:57:47 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 177Dtmq4015293;
        Sat, 7 Aug 2021 13:57:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=sD/KYSDO2H+awHgbNCZ1Q+jWeSuH97UeXoYdezwqA6Q=;
 b=gyecPxgu3/OCQk0L8An8QpDECCu3fSz7226SqFDt7GvrUc8M2hQDd5qhCN52WXhOYszq
 spI71GSY1LDNQvP/xDj9unLr19HYyfCxSCdXoFgKDHEILheWEBNn4t4/V4fBuVnH9hev
 lqb144/OrxQW0vSl7UW34odhkSGv9F6ktmVqnnTBW0OhzwTdTMSv2LX7G0foHrj+xKiR
 sBYJvuAm4e/HOYTaV+NZ4bu1TpdyEsraF9+cvf/RKumlB1cEtx8xQQsYRl0y181D6qGD
 B0Nhj1oGeyguZL8cq7qqP9h9CEetr467V/ZONv6RJkyIWCwnlKT8tAE7GBDnBh3hqL1V Ow== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a9fd2raa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Aug 2021 13:57:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jyl9M87V+ySmejmgo3/gln6HlKPlOtLl/AIXLURxXLwJ0TRqCopQofAEbNeCocRiB2bcOg4+eE7fBkS6RnnUPSd9TjtcOmZZU7vdpwyqTACgvGQq1Sf6n8FQTpOn6DKTDnig2hKDr4mDU++m0pNQnqdSj3zoDl79rODjzd5H+8cLrpRm43wWMR/AdxWHcHN8RjKjQ87yvaoo1dX84JPnvZBUPOq8uhsgHlVT5jCRPJsJNjTBpE1zvOK39DKp5ZgNezyqycFoqOTJNh+VspvP6Ay7rjGSgxoqFusULZbUNqfgNVveYY3kg/Y6yfT1PTtykmbO7JgCPOcpFGY1jjzW0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sD/KYSDO2H+awHgbNCZ1Q+jWeSuH97UeXoYdezwqA6Q=;
 b=aIeyqK6KJgI/8ApMDGG9NBosVvKDvZEq/2wjGRxUSvLzcRIxYw9DuGfyHi3+QF2I6/ogUC2b+AKMR7+VmWUktifsovGN9WcP1c+stDQnxBY91zxSCiXRlNgZbPilGQpxdh+nOr4Kh4Y9zeqnMPo3W/pYkoPKpOEax4IviAyrFJqDqXigJEHkC6PIwwxSrix/ySwUTX163G8LmdwH5CM5PGH7IY4su4+QOvJmx3Ov3KblLd/dVaR4uHu6+nzPNiafSKfaN7u+JlTorqMNWq850OJMZSIeGvy+r3P0fzk8PxwZvDw7IWgZv01P2yj4ksTPj+cnET81DsAz7jgEgytwug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB2587.namprd11.prod.outlook.com (2603:10b6:5:c3::16) by
 DM6PR11MB3737.namprd11.prod.outlook.com (2603:10b6:5:144::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.17; Sat, 7 Aug 2021 13:57:16 +0000
Received: from DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::8ccc:636b:dcea:7a5d]) by DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::8ccc:636b:dcea:7a5d%5]) with mapi id 15.20.4394.019; Sat, 7 Aug 2021
 13:57:16 +0000
Subject: Re: [PATCH] atm: horizon: Fix spelling mistakes in TX comment
To:     Joe Perches <joe@perches.com>, 3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210807124903.1237510-1-jun.miao@windriver.com>
 <0b52c87bb939fe45c1cf07fe9c3409e927138046.camel@perches.com>
From:   Jun Miao <jun.miao@windriver.com>
Message-ID: <d50b58fe-298b-a285-59ec-2d3aa275d221@windriver.com>
Date:   Sat, 7 Aug 2021 21:57:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <0b52c87bb939fe45c1cf07fe9c3409e927138046.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: HK2PR0302CA0012.apcprd03.prod.outlook.com
 (2603:1096:202::22) To DM6PR11MB2587.namprd11.prod.outlook.com
 (2603:10b6:5:c3::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.214] (60.247.85.82) by HK2PR0302CA0012.apcprd03.prod.outlook.com (2603:1096:202::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.4 via Frontend Transport; Sat, 7 Aug 2021 13:57:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60a4f03d-4e8a-4e90-608a-08d959ab43e1
X-MS-TrafficTypeDiagnostic: DM6PR11MB3737:
X-Microsoft-Antispam-PRVS: <DM6PR11MB373758B4A5E0A260A390540C8EF49@DM6PR11MB3737.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cko22tGOg2ZPX49AMOzq9EENSX7u6ZKlFRe9dGPiHUkYX3EeTshY7drTTGw1CYCA2K5hSfRqIUP1xPUM2NnxSO8nCXPtXCAgRbDegE7frTdSjAAmMlCgOCN3iCxfMTmPFJp72tsfJAliG+Ez616gjO7IVYn4nsMrfPFswGggTaoaYBp9fE5aADJssGSzVbHADmmEPPs4zpuf7MVmD1T9s4iIj+quD+VgCMouNhLvBjIy6PW5GUx+lVyqXh/yQztdbnevKqvEUTtL7/EKRPeqg0io2v/PlTrpO0o2txjn2yjuHU4ZBd4NdAiEIbXYJYIUON33Bk5mA9v7zdVBc5FcmtQSizRTrorppYgNTMPpe9vWCroDWgLMiRbx4A9khcTYs1s+uZ4PuLFzab2JxASdbX9PIF1WQuqm8NWxcareb3J4H9ox2wCHFN8fg1CrGZ99KB2LXZSBrMcqy5l/oGSRAqa0J4s7sjTzeYF0RKuwkcJBIf1fnmrQ85RiN83DidMTKONEuqQmX/DO7g/7mKpGJt14G4BaEE5wg6kGFCeNvfBVKkA34AGIUfNtqeb2iJYR6NxWD5WIFpJUkCcabA7E/3N8Hk9hrH9ZT0KxgayvpxlTgyk0Th+bL6FmkjFgtkAXE71jZXqXPg227ou08BtD6u1dPQQbSTCqxjccpvWlgY80qQYsVBXBmcE6U155RTuZBmbL+ila9OkZTCicyURVvskyqpU/FzjZaZ7SKV+7BNe6dLADzC1yT+DlB9tdO0Db43xgtqNnunDYByR1CvOUqvj/vJ1gcOhVpsDi+hKrKaJ9vHt8PjT0tACmtDluPymE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39850400004)(376002)(396003)(346002)(52116002)(8676002)(8936002)(2906002)(6666004)(186003)(31696002)(6486002)(4326008)(6706004)(26005)(5660300002)(53546011)(36756003)(44832011)(86362001)(316002)(31686004)(83380400001)(66476007)(2616005)(66946007)(956004)(66556008)(478600001)(38350700002)(16576012)(38100700002)(169013001)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z084eERHK002Tmxnd0hsZzRMNlhnSy8wUlp1bFBMcTV2RzhuVU1LNVZFL1lu?=
 =?utf-8?B?TFkyajl2OVBuMTA4RytxOTNvY2laOGNvZHByV1JlWUVFQUN1dU8xSFgwNFQw?=
 =?utf-8?B?M3lKQ1B2WXpCTU04NXhpZEN6aEM3clBoMGl4UFl1TUpiTEFtOEk2NklEbklN?=
 =?utf-8?B?SGR5QXhoUTBma3RmZmlWaURTN21abmhrNFNwb0o1bnlwRXBha29ET0VuRXc3?=
 =?utf-8?B?QzFudjVGd2t1ckd3aVRZcVViY0JvZTFyclFFSklIUTBUV3ZrVXg0NkNyaHBI?=
 =?utf-8?B?cVBWVFpLMHhJY2djQzBFTTFoeEJ1TnFrNUloZ3VlVTRvR1dKRWdnN2cwbkJm?=
 =?utf-8?B?ZzJsd2NHYlRkSi9CUElVMWlvYnVwUG9ENFBONjJHeGdCaE11RmYrTkVLZFhH?=
 =?utf-8?B?cjQ1UUhURmdpdHNzZUJXSE84eS9IajF4U0pwWW15Tmc1SkNveFhSWEU4ZTRQ?=
 =?utf-8?B?L3BPdWNieHFGL1hGeHRicXJhdnBTNGhKWHcyc1NRSlBhelpYTXVaRlBvWHhr?=
 =?utf-8?B?VXpGaERuSlRVeU5vSkVKNFdiWVZoS21yb3k0OHAvSCtYc2E2aUxJa0hOdWQ1?=
 =?utf-8?B?VnZFNldKeDlXVVdMOWRtREVCaUdvblpUWmVpRXV5L2ZuRFRIMG9RbTcvM09l?=
 =?utf-8?B?bGs1aEJWbFcrQ3FRcHBEZXJjRy8wMm5zYWV5RkJFYTRCNExrblpROUhHT1dG?=
 =?utf-8?B?emZETUY3VHJleEZZTURtMXZFdURuV29PVDh2WGVwcVo1ay9aTjFmTWFidTJR?=
 =?utf-8?B?aVZLRFJSdk1TSWZFaVRVMTJnVFVsdUZ2V3ZPd09XV3hwMVJwZk9LTUN1VGsx?=
 =?utf-8?B?Y2RJTXdDSllmOTk0bFdlQjV2eFdXd1dYbEdGZU9sQ1hzbUE4cGNYbGVZZm1R?=
 =?utf-8?B?dUZCSmZpUUF0SmVlWi94MkN3SFh0SDdLQThxNllpQlRyNEZ4emEwTnRIM2ZM?=
 =?utf-8?B?cFphb2tiUnVhWTdKN2lHT1AyT0JRM0w0dGh5aXQwRk9KcGs0NC8vSTRPeDZP?=
 =?utf-8?B?alJaWGFiSU10N2FoRmNJWXhqQXJpY0ltYVJydnh3REJxMnVqVlhjWU9uS1VU?=
 =?utf-8?B?ZmhGc1BrU3lTdUNWd016ME9LQnNpdGNueVhJT1BnUXdFdHBZSFFKd2xXbEJT?=
 =?utf-8?B?dW5GdnI0S2hVMk9XOGV1VVJPR3VEVkdzdTBuL09hS2V0U0drVDlQWW9CaXZQ?=
 =?utf-8?B?Ri9UMndLa2JURHdwR3d6OVEyVVhYUE1penhGN1NrTW9WeCtJZVBMS0ZTTE9u?=
 =?utf-8?B?Y3Z4R3o5OWM2MTVONUloQ28vUHVXTWtpRjdOcWhYc0ptTzY0aFk5Qm41UGxD?=
 =?utf-8?B?Yk9FTFpnYjJvSHk5UzJwQm51clZEVVA1ZW1WUGVJQmtJZE8yem1NT3owWm1C?=
 =?utf-8?B?ZUVQQm5obHgrMG5pYVM5MTg2RUd1MkQzZkhUQUltQU51R0V0V3RJMFJmUFhI?=
 =?utf-8?B?SzRVZ1ozOTEvbHEzemtPM0Q0S0g2T0I3VlRxK1hmMk5rYzhpRU1mN0JqTVQ4?=
 =?utf-8?B?NVRWaS9IcTNtMFNJK3Rwelh0YlRLYkRUN0NTUUtJWHpxeUxIR1FaVFpMOVdU?=
 =?utf-8?B?L1Y3SkV6UlhTeWVXUVBZbTYwd0JpaUszMVd4RzVIemx3OFZLZlk5RE4rclpu?=
 =?utf-8?B?d2Y2K0VHYzVmaTdTVG1mTkF5ZnI1bFpnVmtrQjFpL3lPZTkrTVNpVEN4UUs0?=
 =?utf-8?B?OFZyZ1llU05pblBkZUIzMU5UcWRMenlIV2JuRnh2S1VTWlhUVFcrV3BQb3lt?=
 =?utf-8?Q?3ZNXd0eqdHIRcCeynjVe/PKLCKCCGTxufTqIeCw?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a4f03d-4e8a-4e90-608a-08d959ab43e1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2021 13:57:16.4548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U5xUakENSuD/B2kCyq5T0pag4M+fIOUE9voUCDyrex0tpjWjVKCjri7m9esM37t+n0daPDCZDguuZG6erDQ/ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3737
X-Proofpoint-GUID: 3uKLyLFLgaJrGGBlbG5mTwjwUUNGwZpv
X-Proofpoint-ORIG-GUID: 3uKLyLFLgaJrGGBlbG5mTwjwUUNGwZpv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-07_05,2021-08-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1011 suspectscore=0 mlxlogscore=721 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108070098
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/7/21 9:21 PM, Joe Perches wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
>
> On Sat, 2021-08-07 at 20:49 +0800, Jun Miao wrote:
>> It's "mustn't", not "musn't", meaning "shall not".
>> Let's fix that.
> Perhaps more useful to change to 'must not' for the
> non-native speaker.

Ok, V2 : Suggested-by: Joe Perches <joe@perches.com>

Thanks
Jun
>> diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
> []

What's mean this [] ?


>> @@ -2167,10 +2167,10 @@ static int hrz_open (struct atm_vcc *atm_vcc)
>>
>>
>>     // Part of the job is done by atm_pcr_goal which gives us a PCR
>>     // specification which says: EITHER grab the maximum available PCR
>> -  // (and perhaps a lower bound which we musn't pass), OR grab this
>> +  // (and perhaps a lower bound which we mustn't pass), OR grab this
>>     // amount, rounding down if you have to (and perhaps a lower bound
>> -  // which we musn't pass) OR grab this amount, rounding up if you
>> -  // have to (and perhaps an upper bound which we musn't pass). If any
>> +  // which we mustn't pass) OR grab this amount, rounding up if you
>> +  // have to (and perhaps an upper bound which we mustn't pass). If any
>>     // bounds ARE passed we fail. Note that rounding is only rounding to
>>     // match device limitations, we do not round down to satisfy
>>     // bandwidth availability even if this would not violate any given
>
