Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C76C3D5672
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 11:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhGZIqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 04:46:25 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:58996 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231800AbhGZIqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 04:46:24 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 16Q8WgSQ009749;
        Mon, 26 Jul 2021 09:26:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : from :
 to : cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=SJtnTLrP5tcm/qrGnjZUDcycxf3nlEY8xeexGr2I9uA=;
 b=MqvDzZG1NdxSdGJG8ctElbCOB3ZoFXtx/3CYJ9/cZTu/kmbCEgsutZ5AwViqpwwNvblK
 GAtAs52LqkdmJrCWVaj1PIOQwZUhK7dWi0RBHc/iwfbHzpfB3u5qW2fhjSx3vuh0VT3/
 omn0db3BGuS+bg30ZlQCuptyjL9Fs+YwdjdJVe1xQyk0hjTKXSFDwGYJ3xXlomEe+fFu
 DMsNV+yn0KraNo2QlQ48t+UtVTcfXzhDXJjNgLLXVU5K1c45GmuN5kdWjmD6Fhz1ANG4
 D5ZaqDt9PyWkFhkQCDRPCOX8vtqYBvmb266S2mG3uXTBDgEiI3Pd7kLMhTz4XcNvMH82 PA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a18v10fkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 09:26:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXgEHjjgphuo97FPTaYqjuNnZdji9mrCgMX+IU8MY6spOsjbiLsfN0L6AmsT2V+XKhYzTl8RE7a2PbcsuyWCKiFjmNh0Wi3sfJtpBoV9I76lgTy3q3c0hWl6OjfXKkj4V+JRXgOXOpYirfCcmtNDGz3Uy94SXO8mbz7wZ8cVfzuOeKKBmOdpgRdvvUVsqtmhRnDwcGEml71LqxlgGBe2N/kkiaFoPzpQM+Bk8548BTahQ1l8lo4Bvbxp+2RwqDGd0WiO8+sFkvPYwKjQpnn7c+O4lluRyr9aJGcFL5+TNc5Am1ViBQBlJRXjxdy7yITFY0FwwmSuOI7C8s7OdboVgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJtnTLrP5tcm/qrGnjZUDcycxf3nlEY8xeexGr2I9uA=;
 b=IByIk/7lp7yjwnovlspOHb0avLSRfmdQ5OlyUPtIXAgyw2R2zvOzqh4kFdDuS2we8/iy2LQSARqey0OwJJ6/n0pcwame4VoAugSvctACZEce32XkdJo7oAe7Tz2ufCcEPN+CoP08nNb5KLJ9MrOWHK11LrMWTOcVV3kfTogre7Fpm7c4oKs6Tu0weqXAL+YlJdKIYgUd0X5//iMgA1T/5DMoMhp0bOmBDdJ6jL0c3bXIlBFPZ0JoOjOlKw5ykZQ3QT3Rd0E/LTBfsBRwUoc/YEK5bW3ISJnvE5MnJ2N/d8sa9iiTpJkdT7yuPfOmEzTKdaqlnBFzek0+9ePbfSUbIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB4739.namprd11.prod.outlook.com (2603:10b6:5:2a0::22)
 by DM6PR11MB3705.namprd11.prod.outlook.com (2603:10b6:5:136::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Mon, 26 Jul
 2021 09:26:45 +0000
Received: from DM6PR11MB4739.namprd11.prod.outlook.com
 ([fe80::a50b:5bbb:b0d8:8896]) by DM6PR11MB4739.namprd11.prod.outlook.com
 ([fe80::a50b:5bbb:b0d8:8896%9]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 09:26:44 +0000
Subject: Re: [PATCH] iwlwifi: select MAC80211_LEDS conditionally
From:   Liwei Song <liwei.song@windriver.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        David <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210624100823.854-1-liwei.song@windriver.com>
 <87sg17ilz2.fsf@codeaurora.org>
 <92d293b4-0ef1-6239-4b91-4af420786980@windriver.com>
Message-ID: <d6dd3ec8-4614-4c96-0944-5e92a34c0191@windriver.com>
Date:   Mon, 26 Jul 2021 17:26:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <92d293b4-0ef1-6239-4b91-4af420786980@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR0401CA0001.apcprd04.prod.outlook.com
 (2603:1096:202:2::11) To DM6PR11MB4739.namprd11.prod.outlook.com
 (2603:10b6:5:2a0::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.157] (60.247.85.82) by HK2PR0401CA0001.apcprd04.prod.outlook.com (2603:1096:202:2::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Mon, 26 Jul 2021 09:26:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90eeb3e3-508c-48ea-f3f0-08d950177c09
X-MS-TrafficTypeDiagnostic: DM6PR11MB3705:
X-Microsoft-Antispam-PRVS: <DM6PR11MB370571C377B84E96EAD3B7099EE89@DM6PR11MB3705.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rQy9bJEMVnLjKB+AN+EBlNZxOTpdu7gfQT1maMUPGPw7NAzszjHG4hmmrnB/jtyLg4vG5laTA2OWyOtx9sGSfG619STaGC01kFTUJQtAz4YzxCshsbvfpskl6gEMM1EpnpZ4pllajJDUB/wguWSVs3/BhtjD6aQ5ewEOiBH/c1MGx8siskgbPt55ULZ6hritJWg8XaAkj+HizoEBDc4chpXVN9kIKvKcoSo/XyeOrrD58IrPgY+jx4xFdn13fJgGZC5r+1nXbS6d2lXHC0P3lyKEyLpSsA+z5VklqjaqqSrbXgY9flKXJ4hfd2pfH9qCuZoMHRQ+evj6dHcUXKtuXZxIMrIG9Xkabj6VsT/kOl0ipZ6MqPc8HuenoKRjDUXTr1LdYabxcyeWcjf5jyy6+AYcd6Xyp3wb2LaevFOk9LXqkrh+day8lqBRg+j+RHsUYap/dSzRukrGRWvUjVqtj9ZdVHtjOcpfssEfDjTkui0IsfOgmBix3mwzykJpHq32NAizEujiFaO8W32FVjjX2NMC9WadoSAB6Zj0XLfeHsbnWyYS6XKz0fDtDcNdKdwZ8UcYLnJUaEPA1jcQfemocPbKtBgj61NGA0jwYyLsZh+bwikxgaYGSI81BZ8NAQA8f03ch5/pgyZALtfkpNkxfvOEzarAuVSoFrRB2vCbaru2aJpQq2+TF8jO47t/elPqohWTzRzB6MB99ohi4Ta5nxv2jcV7usFG0bu8MluurNlaaI4ymynureNHowuNueQT97GCheG9gz16Pv0mwgWfXx/DEGwBSm1+F0KwMpbBqD8E5JFjOVF09X7rL+ySesS5R4PDIgQXPStcB1EEXzIvM44FPff+QytynoNurGVZ2u6qx5n5ad/hN5qRR7O7Yf0b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39840400004)(376002)(396003)(346002)(86362001)(6666004)(83380400001)(38100700002)(31686004)(26005)(31696002)(38350700002)(44832011)(53546011)(52116002)(2906002)(186003)(4326008)(8676002)(54906003)(66946007)(36756003)(5660300002)(966005)(6916009)(66476007)(66556008)(478600001)(956004)(2616005)(6486002)(16576012)(8936002)(6706004)(316002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVgvS3hKTUNpOVFRQ010TURRMFR6R2NLMnZsOW1Na3VjODlhVy9sMHRsL3NQ?=
 =?utf-8?B?QzRvcy9EUS9CQVFtaDBkbHNkWkNBa1lTdmlZZkNyQmMxbmFQemZVNHYyT3VU?=
 =?utf-8?B?cW9ZcldLZk1qcE5obTJGODhYN1pvcmZub3YwZjBiTnR0Uy9uZ0dUdEVOMFZR?=
 =?utf-8?B?NDJDVjNHQWxhRS91QkdJME4ybnYwQWRFd1NTU1JuTlI2SDJ5bFR1WnJ0TlJs?=
 =?utf-8?B?YmIwcmpmcXVhTkF6YzlPY1lSZmdjM3ZxM2pDVHhoR2thOHdzZXBYeXZWRWdR?=
 =?utf-8?B?ZktCVk9pa0hKYXpHMlhxKzJibHZKd2s0dVN3cGNlYmZ2MThSVEhuc3RyOWUz?=
 =?utf-8?B?T0VFaGtRUldnK29NVlF5Ulpsanp0UzNvdDBLL25zdGhYYndjWDRoTHdmTWp4?=
 =?utf-8?B?OTBsclJlK0xkMHM3enR3R0p4dk55SHpWNmdabFRROVRJQnh0VllJNTdoVzNP?=
 =?utf-8?B?R3BLcThObmtRcVIwL2oxSDN5ZGZqYnRtdUpickZpUzdiZHFDWXBncFFvZ0c0?=
 =?utf-8?B?QUxXd0djazhuSHhlb2E4SXhoV3VJbXlUdmk0WHNrOVNuNVcrMkx6cGNLMXR4?=
 =?utf-8?B?ejJOeUFzSzc1a1pvUUxmMG5yQmJmY2xnaW1oRjBWNnBxUElGNkNJNGxlSE4r?=
 =?utf-8?B?dzhreTUrVXRZOUZ4akJTY2I3ZUV4QiszenhCWFh4MVFZaFRPMVJxemlXZktv?=
 =?utf-8?B?ZTg0S2pjamlGQTQyY3hadU5jc2JSUXB5TmZub1JwTjdsQVZzL1pXMm5DMm9j?=
 =?utf-8?B?Y1ZQRTF5TXNjZjZzUGNZTi9oQlJqOXJtR1VhMTNmWFk4ZGZ6SzAreVNzZ3Rs?=
 =?utf-8?B?Q2FmUmhtZnBhcWNZdkdxM3FMYUxNWjVBR0JCVG1saWxZdFBRZGNWZ1l3WXRw?=
 =?utf-8?B?MmdMVm5DYzdxQ1hMWDUweFY3Nk5MVHV2T0Nwai9Tbyt1SURRY0JaekN5WFhk?=
 =?utf-8?B?dlhNM0dad2tyRlRoMmFwZUR6T0h6TWZsS04wWUpWNkZnNGRMZW9jckNmQ1Vy?=
 =?utf-8?B?T3RoWHdYdWlIQVlzYjlWdDdkTElDRXp0TjRsQmM3UDdaN2ZsQnM2SnBKYXI1?=
 =?utf-8?B?dE1jUmorT3FNcm81a1RPbmJnT25zeEo3YlZrYkEwWlRDUVJ4V0RQdGo3cGcw?=
 =?utf-8?B?aTFEL2t0TEI5SUNjY1ZHWjRLdkJ0WUlONWRFM1FrMlZKa1BKWDdTVm95SVR1?=
 =?utf-8?B?V29LWks3UUFRRk1OZ0VYR012MHc4NUhJK05oeWtLN3lJM0lTK1NyREhEM3da?=
 =?utf-8?B?VnZhY21BSFFaRW9pM2NXWGNuc3N6L2g1V3NtT2FHV2U5eFZTSUlqS1BYTVVO?=
 =?utf-8?B?WjhGcEM2QzliZnZWSVhBV3Y4bkluNXBWOGNHYjMyak9LQVBVVDdoUGF0UmFy?=
 =?utf-8?B?QTd5VmRMbFRWdVNHN1ozSHJCNEZaeVdMK09KQjVoU3d0ZHc4Ni9pa0ZFeTEv?=
 =?utf-8?B?QUpPbDRtTUFZelZNN3F1Y2VZSnJhK0hReDFIb3VkT0JYUG1YOSt2VVBBblYr?=
 =?utf-8?B?Q0xxT3FJTVBIb1BZakxtS3ErdThMU0UzRUZuMFBObFYyTkgyK1lsUmJXdXpX?=
 =?utf-8?B?cXExQUlaNVVMMDRsWjljWnVmVzVMMHJaNHJGcGdMWEJ3bkNYajNuYVdwNGRF?=
 =?utf-8?B?UGtUd25tNFI2OWhGRTJvMlFTRDhEMHlvamtKbU5tblVNbTNaWDJVTkRFdjE4?=
 =?utf-8?B?dEhWdjhwUC9HSHJXUEU4ZlZSU21LS1huWkpzSGZwVXJHRnc1My90R1ExdXF5?=
 =?utf-8?Q?mF5Jlby382BQPcoYlZH11kAoB+FnobzSyKQ729d?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90eeb3e3-508c-48ea-f3f0-08d950177c09
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 09:26:44.6676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LKYxr1q9i6FfgHGfwaV4slMOXozygoT8GdpxYKDL6hV49PNCBUuqf5PcPQ333IXfZMuNHKf2Q6kZF6QMGpuDlbonH8mpQCpS0IFgAk9tAtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3705
X-Proofpoint-ORIG-GUID: 2wCjaPMm8YRUkCwAfDjdHgYk36W4Nomz
X-Proofpoint-GUID: 2wCjaPMm8YRUkCwAfDjdHgYk36W4Nomz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-07-26_05,2021-07-26_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 mlxlogscore=999 clxscore=1011 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107260053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Any suggestion about this patch?

Thanks,
Liwei.

On 6/24/21 19:06, Liwei Song wrote:
> 
> 
> On 6/24/21 18:41, Kalle Valo wrote:
>> Liwei Song <liwei.song@windriver.com> writes:
>>
>>> MAC80211_LEDS depends on LEDS_CLASS=y or LEDS_CLASS=MAC80211,
>>> add condition to enable it in iwlwifi/Kconfig to avoid below
>>> compile warning when LEDS_CLASS was set to m:
>>>
>>> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>>>   Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
>>>   Selected by [m]:
>>>   - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y] && IWLWIFI [=m] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=IWLWIFI [=m]) && (IWLMVM [=m] || IWLDVM [=m])
>>>
>>> Signed-off-by: Liwei Song <liwei.song@windriver.com>
>>
>> Is this is a new regression or an old bug? What commit caused this?
> 
> It should be exist when the below commit change the dependency of MAC80211_LEDS
> to fix some build error:
> 
> commit b64acb28da8394485f0762e657470c9fc33aca4d
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Mon Jan 25 12:36:42 2021 +0100
> 
>     ath9k: fix build error with LEDS_CLASS=m
>     
>     When CONFIG_ATH9K is built-in but LED support is in a loadable
>     module, both ath9k drivers fails to link:
>     
>     x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_deinit_leds':
>     gpio.c:(.text+0x36): undefined reference to `led_classdev_unregister'
>     x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_init_leds':
>     gpio.c:(.text+0x179): undefined reference to `led_classdev_register_ext'
>     
>     The problem is that the 'imply' keyword does not enforce any dependency
>     but is only a weak hint to Kconfig to enable another symbol from a
>     defconfig file.
>     
>     Change imply to a 'depends on LEDS_CLASS' that prevents the incorrect
>     configuration but still allows building the driver without LED support.
>     
>     The 'select MAC80211_LEDS' is now ensures that the LED support is
>     actually used if it is present, and the added Kconfig dependency
>     on MAC80211_LEDS ensures that it cannot be enabled manually when it
>     has no effect.
>     
>     Fixes: 197f466e93f5 ("ath9k_htc: Do not select MAC80211_LEDS by default")
>     Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>     Acked-by: Johannes Berg <johannes@sipsolutions.net>
>     Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>     Link: https://lore.kernel.org/r/20210125113654.2408057-1-arnd@kernel.org
> 
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index cd9a9bd242ba..51ec8256b7fa 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -69,7 +69,7 @@ config MAC80211_MESH
>  config MAC80211_LEDS
>         bool "Enable LED triggers"
>         depends on MAC80211
> -       depends on LEDS_CLASS
> +       depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
> 
> 
> Thanks,
> Liwei.
> 
> 
>>
