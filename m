Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247C63B2B28
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhFXJPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:15:34 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:9112 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231228AbhFXJPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 05:15:32 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O9D3GU017383;
        Thu, 24 Jun 2021 02:13:03 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0064b401.pphosted.com with ESMTP id 39bykjh0kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 02:13:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9Xi37Awd6UgdvoERdLK0TWB4q8R8Dduv5U+SjGtMkX28aPQ1dn8Bx9FzU3cpZZ+RVFLAcukE4UFVwgIbqIDWEx+MoTYBfz//PM6AWfRnB3x32BcWNgxdQcKE3CPimoM0MkmQt6WE1xU7QkN0CAmvfvLia6l8NRSE65V+fJ2J5lAPwIDeA+7/V5YoypmWef055lv0It51Yrh5ssV7WxPxV0b+KwBAj0pbq8pHXl8v4KARF/bUigtknyM4PiP+juzEUU3Zfru5nMS/ECikN3P5Slkz0ZsoOyRNaMzbiI6YfDydv3crImDME1qfDWJIWebZkxXtEhQ/MowVgEtcGOVTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRreO6Hua56e7ywPbsL5ybK6WjPfdzA8W6R3fcC3JT0=;
 b=jj2iDATka/5iogLtUp7YZq4FvSSwh26X2IgfDhy9pf8kTb2ilMSSCUi05bpTko71dhQYZSkND4EOLoZKRvuwYTiktvtIlo43Sc+YvUhPuSbb5y1yATnSqTedexVR6ldDh6azc8sWoNZbGQ+ty+VFADQtYdFY2vZvU3Z7h+SZWCkIdG//RTJ58hsKKJx7oP5Ow0/6SCJyKd8glXKzf04ppEBYJ4IYK1II5HZTMX8Ow9PQGUKtrwfolqH9j1YcQHLR9g8n73fm3Cwb8/NhFplpEKpXrBJLOyzHUhMqkLpED2TTQd4VKnFOLfknl4i1lswFU/cx9uhHA/LhhVpipdLoPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRreO6Hua56e7ywPbsL5ybK6WjPfdzA8W6R3fcC3JT0=;
 b=lbNLrFTB8kkKkffJIt1tkDcboeoQmNwhaPbONOskcLF8TYZswiVksXdcmfpNOOiWRvysX7WNpyyNp1WX81ip/hyDmGf04lGwuKNyrwyCw6yIihY1jv5iRyeGTt7bscL0lK0G4sNHGY6vnpWSJM0EADpVDi+RgBaUxQRLPv47TTM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB4739.namprd11.prod.outlook.com (2603:10b6:5:2a0::22)
 by DM5PR11MB1305.namprd11.prod.outlook.com (2603:10b6:3:13::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Thu, 24 Jun
 2021 08:57:27 +0000
Received: from DM6PR11MB4739.namprd11.prod.outlook.com
 ([fe80::600f:ab96:ee86:2ec4]) by DM6PR11MB4739.namprd11.prod.outlook.com
 ([fe80::600f:ab96:ee86:2ec4%6]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 08:57:27 +0000
Subject: Re: [PATCH] mac80211: add dependency for MAC80211_LEDS
To:     Johannes Berg <johannes@sipsolutions.net>,
        David <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210624074956.37298-1-liwei.song@windriver.com>
 <63d3f8ec9095031d5d6b1374f304a76c64a036f2.camel@sipsolutions.net>
From:   Liwei Song <liwei.song@windriver.com>
Message-ID: <b8b5d1d5-c991-5770-7993-0867ac75793e@windriver.com>
Date:   Thu, 24 Jun 2021 16:57:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <63d3f8ec9095031d5d6b1374f304a76c64a036f2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR02CA0181.apcprd02.prod.outlook.com
 (2603:1096:201:21::17) To DM6PR11MB4739.namprd11.prod.outlook.com
 (2603:10b6:5:2a0::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.157] (60.247.85.82) by HK2PR02CA0181.apcprd02.prod.outlook.com (2603:1096:201:21::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Thu, 24 Jun 2021 08:57:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aab772b5-72cb-4043-8ac2-08d936ee1763
X-MS-TrafficTypeDiagnostic: DM5PR11MB1305:
X-Microsoft-Antispam-PRVS: <DM5PR11MB1305431805E25C89C630ED5C9E079@DM5PR11MB1305.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VqSQMngPZqrfAKTlvfruYllPWqyqzlPqOcfmXLmj/ssQupoX3aoinQksG7qXM6NJAvt0o26XzfUdAqmoUGly3Wldegbnu619DPOOQP/fHSFYbwX6naZt1yUj1PunLo6BKaXFbjYp6iL2flXDUdkDrSGVZOLboXF4D0G4D9rmOK6t56jUSMhF+YwTgmisGdDtHpOLbhw7QaS5sR+UL65cd0+UcF0EBsAl52KlcKrsPm6gGpu1MOcK2vPz+5CDHrnnZ4Lo+/ob3sRwY/k78NhRP4yC/AAF/B2lOt+nJLV7/p2DfVRiqqVtpVXMUClnGpQwWgyVbil2mEnxASHE78Nb9NX8/Rv1ClAldU+aHCEgog+0U+DWUX2AkMPgkwvonLOOVO5g37pJYO1KwqDldmz0nmniVnw0tyJzVHETvL3hZB+ry9D0M30o8AICmIAJUZPlZsMlE3H+Sdg+923PftUeo9uSvLmT8e7XzRJeSaBQ95gpvxXI5r3YVoi+Hhet+CduIch/9r+Fh1KhAv+h7TdKBMJP64PgGJx/DoO0FQ1hqDSoeJPce5nRY3U3mVwVrdHyu0eOIroJJC6vyXZkR5rHLzMz9pHii88JzsZq6aR6hdC/YvpaxVbBBiBoQSLoxAnlwvHfSjIbxPYp0vvNNU4LiWyVK5m17PGa4zmX9VzxqXEmUgJ3jWEBh3kKQqYGRWlIWEBKASl1yPjTizEusaekzPgq4zagHrPSSJZ7SW8PRMMKEnmyYhBiv4jpFhEUZAA/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39850400004)(36756003)(26005)(16526019)(2616005)(956004)(186003)(31686004)(53546011)(86362001)(38100700002)(16576012)(31696002)(38350700002)(52116002)(2906002)(316002)(110136005)(4326008)(44832011)(6486002)(6666004)(478600001)(6706004)(83380400001)(66946007)(66476007)(8676002)(5660300002)(66556008)(8936002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1NEYVB5bmRjVGhpWm9OTlBrbkIwMCszL1hNeVBGcGs1VkNwZU9wS2RvbDVi?=
 =?utf-8?B?Znh1a0JsbTR4eTZIS1F6YWxIUm9FLzQ0VFY5OWpWWWJNcGFEeGVhQTNDMzNW?=
 =?utf-8?B?RDNKakhCaXFPMkZHQkdWZkNhZllzTllRRVZ2ZTM4ZG5NQVh5TzBRTWNPWHJQ?=
 =?utf-8?B?bWV0WFhJMWdRUXZERDlmVXJoM2hwMGdibG81Z1V4Ymg0OFhUWGNXNmtodDVK?=
 =?utf-8?B?cTF1M3NvTy8wTGhWcStnenlLZUFPKzVRYXUxblZvMFJXbzBTZlBBWkdNU2I3?=
 =?utf-8?B?VC9SL05PRTRMSHRaZ0NLYjMxZC95MFNIQTZ1T0N1NFBuRzMrSXd0bkd1SGdH?=
 =?utf-8?B?aHlDckdOVUN4eWp5Lzg0M3J6bUdZU3c5WVJjUktKUG9hQ1N2QXhySHhxMHp0?=
 =?utf-8?B?VEc1dEY4VGdQWGN3d3QrQlBORnBzS3lHMUZicTRNbk0xbTRDSlpkUmV3V1M3?=
 =?utf-8?B?dm0xYmxtVU80TDdqNjVGdUp5WjJkQjRmbmtENDZvWFdkYWZXUzJaZ0lLL1Jh?=
 =?utf-8?B?aEl0aGNyODlraC91cTFRam96TVpRMk5JU00yOUI5UkVwTFJZNlZnQzgxcHFX?=
 =?utf-8?B?NWZiWlBjSEQ2NlZSbUFLUXZWVmtkWWdGNTZKZy91dlR1eEhXU2c1MUhwZHcz?=
 =?utf-8?B?Qk5Bemo0Y1VsVm9OVjlVK2NuZXNpVUpZZEh6MzdPYnFlUWRhTHhTSld3MUEx?=
 =?utf-8?B?ekdYU2Y3SEtiYnpRYjdQNWMyY3UvdGRtdUIyd1hZVmFIVjExajR1T1BtVlQ2?=
 =?utf-8?B?VkJmZi9Uays2aFZPcnc4TjdiRTRpUXVwbENydVZVbTRxUktkQWFUWXlUaFB0?=
 =?utf-8?B?dHJZdkVGUXZRY3Y4ZnRPenl2QmtLVlloOTZjaTI3M1BzUndnY2F2U3RGN2lC?=
 =?utf-8?B?RUVmZ2s4TjNiZStGR25IZDY2N2tvVFpUeFBMMDZEVmpWbUdOSng4MThTUkhu?=
 =?utf-8?B?Y2pNMVZPTjVndVdNOTl4NnJ5UjdYQk5Wa1N0VXJNbjgwdU1NVVY3TWVLN041?=
 =?utf-8?B?RDk0TmlpaW9iL1dUNjQyNVdnMGgrV0IzQk85Rk1Ca0NibVVOb2padTJ6NjhF?=
 =?utf-8?B?M3lURkIwaVZHblpNZzZDeFphYTdTTnJVbUJtSDJoZ295ZzdjbW9HWmFaVysw?=
 =?utf-8?B?NjA5bktGM1NIZUc3Ty8xZXlCS0NYT3dyeldLNTNpQTlPWkxkSEJXOVdaWEVB?=
 =?utf-8?B?Z1JkbjkzOHlHNnpoRy94U0dHUk1ZUklURVdRTmEvYXJYUUJxS3BHeUdqK2xJ?=
 =?utf-8?B?d0Q0cXhEcFVtSGFBQk1pYklxWW9OcVczVjdUNDgzWnpFaEtYeXNkazdMcTdw?=
 =?utf-8?B?anNiYUNpNzU4b2lvbWJJMXd5Szc2d0FqOHdtbGhsWWlqdXorOFJWd01RYW9P?=
 =?utf-8?B?NWtYZTRDeEdzMXNxaTVsNjZZVWRVSkxkUE05SWV1Z0hnaGt2Ky9HRUtrL29P?=
 =?utf-8?B?djMwcng0dlkvN1JOOUlSeWZVaFVSKzlMWWJlZ0M5M1pCNkxxUUV1dFJhS0hX?=
 =?utf-8?B?b2RMVDZLOHpnQVo1bDZEdk0xeTR0SkZQZCtPdU5qMHZvTW5qalpaTzZTK0FM?=
 =?utf-8?B?VXRDRmppMzducDY3QzIvYzYveWZ4bXJETEF1NldCbSt3SG1HSVowZHJUUzA4?=
 =?utf-8?B?bnVLcnVvaU5MbzJDcHpON2NnZkJSSWF6Z1VLWHFJQWkwODRGNjlnUlNTUytY?=
 =?utf-8?B?a2NSRDhDOXJ4dlcyU0JZOVFyR0NiK0hPVjFGVWVNUFlPY0ZjV3A0dHJqeUMr?=
 =?utf-8?Q?yH3ofxoaoYQ2h8ce2UAIUpuej5u/5vJY95RFDTp?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab772b5-72cb-4043-8ac2-08d936ee1763
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 08:57:27.3515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rurwORsLKLByNzpzdGHq5dzuAL7eiTNaCuSYtC5IrQz/u+4Gegpr5dTUnF6V335de9gZy0c6ckH4vG5F6UqESV6hbwQqziLJ8I/9qZgCLXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1305
X-Proofpoint-ORIG-GUID: qsTYfTMSMf0xY_zzljknaAXFFEMZ-Dm0
X-Proofpoint-GUID: qsTYfTMSMf0xY_zzljknaAXFFEMZ-Dm0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_06:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 adultscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240049
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/21 15:51, Johannes Berg wrote:
> On Thu, 2021-06-24 at 15:49 +0800, Liwei Song wrote:
>> Let MAC80211_LEDS depends on LEDS_CLASS=IWLWIFI to fix the below warning:
>>
>> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>>   Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
>>   Selected by [m]:
>>   - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y] && IWLWIFI [=m] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=IWLWIFI [=m]) && (IWLMVM [=m] || IWLDVM [=m])
>>
>> Signed-off-by: Liwei Song <liwei.song@windriver.com>
>> ---
>>  net/mac80211/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
>> index 51ec8256b7fa..918a11fed563 100644
>> --- a/net/mac80211/Kconfig
>> +++ b/net/mac80211/Kconfig
>> @@ -69,7 +69,7 @@ config MAC80211_MESH
>>  config MAC80211_LEDS
>>  	bool "Enable LED triggers"
>>  	depends on MAC80211
>> -	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
>> +	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211 || LEDS_CLASS=IWLWIFI
> 
> Eh, no. this is the wrong way around. If anything needs to be fixed,
> then it must be in iwlwifi, not the generic core part.

Got it and thanks, I will try fix it in iwlwifi.

Thanks,
Liwei.

> 
> johannes
> 
