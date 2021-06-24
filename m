Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2493F3B2D37
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 13:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhFXLJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 07:09:16 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:11370 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232361AbhFXLJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 07:09:14 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OB4Ve0017472;
        Thu, 24 Jun 2021 11:06:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-0064b401.pphosted.com with ESMTP id 39caqmrjg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 11:06:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9A6amtoU0p8D1NTIeMjo0x3CPmB6U08PB1JHY1/NChaURtc/vFY+nW5m+4nPWTKMGImkRqz9CoHpDBQk9Xox+IWPy6SKbuAMJC9Gj0PFzJN9oqiTeV2gEl06X4CRontt8gXlY4auaiUVtw2PEBgg4LWZ4spaQy05kn4BzGAfNssNK/7kjmEjU3rO+seWAJ2SwDmyU4Us8DlWuVZe/m4/2/CvH9FLkhFTjZRQTRBG1QgzhKfeKfX3OgEVQtH14byXGlTh8SfmVytX1XqhXxquakCzJfuU3ay2x+3LSSYb4frNFvl3siLj+arCywz1kyihP45G1CVMJRAdM1sDNILRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6QzQDBOIul4t6DeackeEDLUtd+juI1FJ/7dlaXv8v4=;
 b=YDDmf32L8R3736f6PIU5Ahwxfjd/0kZWi4rlnN0cwFMA/J3S/OuB80pxWzMvXdvF3um2ltSeH/0gacnj6BGApAcEBrwsRjIsYDn17bFmvIUp9KrTZ+3qsq/+sdkFDRdlytiiwH5w44GANqrOL2m6LzUq1ty98cVqOa9oNJnuoj6eOJBYGLw2K1OAF5e4QIJkKUAsWrgtIKiElLR05UOoSQErQq/cgpmsIO5Fs0obzJYgZafkJwYs14IbKN7ebtPEdud3aiEdHWMFktQk5N8TsRVTTX/XtdjG/Osf1PgXKEFgBj+OaGpGbZDzDan/n7RaEiCq4SdxbBIk6bYwTBjIZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6QzQDBOIul4t6DeackeEDLUtd+juI1FJ/7dlaXv8v4=;
 b=BE923NlTrV+gHb/ppVetryrKQ8sVn7Ng59Uba2BjJLtJMTAJh0xEy6pimvxrJJZBUSYKQnyMaw3nnsVMRAGVRM5/JFXSj+q+A4Ha6n78oMfZM+KtnwCzxrwGJads2Z5xcmde5tXEz76Q8VT5eDKKPUOYdTNNzJMJLKvxgys97Yo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB4739.namprd11.prod.outlook.com (2603:10b6:5:2a0::22)
 by DM5PR11MB1676.namprd11.prod.outlook.com (2603:10b6:4:10::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4264.18; Thu, 24 Jun 2021 11:06:47 +0000
Received: from DM6PR11MB4739.namprd11.prod.outlook.com
 ([fe80::600f:ab96:ee86:2ec4]) by DM6PR11MB4739.namprd11.prod.outlook.com
 ([fe80::600f:ab96:ee86:2ec4%6]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 11:06:47 +0000
Subject: Re: [PATCH] iwlwifi: select MAC80211_LEDS conditionally
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        David <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210624100823.854-1-liwei.song@windriver.com>
 <87sg17ilz2.fsf@codeaurora.org>
From:   Liwei Song <liwei.song@windriver.com>
Message-ID: <92d293b4-0ef1-6239-4b91-4af420786980@windriver.com>
Date:   Thu, 24 Jun 2021 19:06:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <87sg17ilz2.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR0401CA0016.apcprd04.prod.outlook.com
 (2603:1096:202:2::26) To DM6PR11MB4739.namprd11.prod.outlook.com
 (2603:10b6:5:2a0::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.157] (60.247.85.82) by HK2PR0401CA0016.apcprd04.prod.outlook.com (2603:1096:202:2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Thu, 24 Jun 2021 11:06:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0348a21c-32ec-4fdf-5ef9-08d9370028a6
X-MS-TrafficTypeDiagnostic: DM5PR11MB1676:
X-Microsoft-Antispam-PRVS: <DM5PR11MB167613B896C0562458137C8C9E079@DM5PR11MB1676.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iXdgNVYtKfee3hanrR60OmXc3fy1iBMWK4f4qiJMSOzQwJWlr72s6ZVPlAuXiH/mP2czR54pixA4yJ2YCUd1NIaeqBMzgwQxVTQOJy9L4sdt23CmHyFCm8cnMk5hZP9qWYhbhdkqtP4uNO+KqQf7rSZahI/XVOUaHowqBQ9G9mV40PWfMiC8Bj6tSJg+alDBsJeKLlT6Tdi7VbcEMUtal6u43IKikUo/xTc25PJ38dFqmjPXbrOrsMTJoNZb8Yg+GDOm+YHoHJIHLNEt5BiU0aIwl9yeu3XTJEjn92Mgsa/BQAZ5probl+sLqrAg/3BcgovVtaPoYXHI//6U/+fbQ8BSRULdUII/NSKTnMnTTq6ZT9A9vS2TwO1cJJfzQagkhdTWyLrw8Keu4MjX6KesFs02lFboKyVHh7yYzkt+lu0AkbRTbH1VXtdA4UZFfbj6J7yG67xqBjGarUbb3lOG7jHRJ9Mt9OQq/Yj5+zRtNIom32QsYOfJMyxeiFiqekx9pEHu/a23noMqhoHdTJ9US6J5W/plsshe2JRVIU+P2isC5p8AaxQ/Wjgd+X7ijXuj7whZkK38sSZh07yqYecDFLiqpuLQxWb4sTl6e0dEkXLruXbMWPrhfVJnUmLqSo4shBtUAeS7LA2GL5nl/QFS+ZJZrVaEO++L84NsNe7bVBuNt4LAlFLBaB7iLtKnhNShiujGfDStQn3ApEVMAq9et0suplbB/TuP2VDZETcvTIJ4DKbir3lP/h/LcWQs2V6n5rbsqk4wTYUA09MP7STThAn4+fqOvHdPhz6mAIp5PCNDvySyJ+lwXQtKUhji1r81H3t1tgBe2H9tJyfn7DrN9cROMq63EWQ+zQ9tstXFSjmWCnC1q/WhAe1rb1kVYmMwc58HBOZ1nL+MZacSP9Uy+m2F5AcjV9yq+w8pobh9tdQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(39850400004)(136003)(346002)(38100700002)(16526019)(186003)(26005)(66556008)(38350700002)(52116002)(8676002)(966005)(83380400001)(66476007)(53546011)(6706004)(478600001)(6486002)(2906002)(6916009)(66946007)(36756003)(5660300002)(4326008)(31696002)(6666004)(956004)(86362001)(2616005)(44832011)(316002)(31686004)(8936002)(54906003)(16576012)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXpzVGJObnpRRDJISXNST2dwNGdHU2NhNk1OZnNxNkVobjNieFlUZzVnUXpP?=
 =?utf-8?B?Sm1OWEpFZGNiT20ybjl4cElROHY3bVc0cS9RbW9KK0RnUVV2UEdkTzU2V2o0?=
 =?utf-8?B?UG13Y0tRdVJzcndzK3J6dEtrencrZExzc1ViWnJTc0VqMm8zSERqeDEwZUpN?=
 =?utf-8?B?K25pOU0rWEZLSUdlN2h0eVl2Zm9KbzNGTnJlL0swMlBYMWs2aXZsL3ZFbEdW?=
 =?utf-8?B?Ym9nTG84VFpIaVVFSnlYTEJkRnVCdzJWNWc5cXkyTG5POVpscHJlbmNiZEJm?=
 =?utf-8?B?WGJ0SE03TXU1UGxkS2JrV3RoOGw3VjlUd0J1cFZaajBBNmY4SENEZ0QvTVlr?=
 =?utf-8?B?RHo2UWhNNEc0Z1RHTmhUNmlWMmR2RkV1ajVGQUpESWR5Qk5Sc2lHQTVQeGRG?=
 =?utf-8?B?NFYzdmJXaDdzako3Q21OTWpZb3pxUnVTRFhWVkJUWGNSWElNN283RVFMaXBG?=
 =?utf-8?B?d2ZMVnpRYUxHR3djUGZPME82QWE4ZDdwMytYM2lLL054cEZEWWFmVEVpblhu?=
 =?utf-8?B?d2thMzZZUkh6TFpBRGRwV2FpQmZyMEhGUXp1cHVTMVZuMDduOVNrQzBHMTA2?=
 =?utf-8?B?aGZ4OHgwUzI5Uk1mRDZhck15alJMQmx6eCt6NUdCME42bEVOa09WL3RuLzdL?=
 =?utf-8?B?Qmx6TkltNDI0b294R2gvZ0kyU0NEOGxXRUNFQTM1TjJobW40dU5DcWNPc3J2?=
 =?utf-8?B?cS9TNmFtZ1RJU2Y3WkZCdzR3V1RBK3gvNVpqc1NUUjhYZVRoOW5HaEliRVJM?=
 =?utf-8?B?R3BHV3RKZ2lXMU5xZGFqbU5lUDNFN05Kd0syZlprRG0xTXBhWm9kV0hHREx4?=
 =?utf-8?B?cXZqbGhoMk9wQXFObng3YVJKdk5pRndhcitGQWxtV2JJQUkrYUgwSEdJcGxF?=
 =?utf-8?B?cVcwK2F1emlnQlIzQU1WSzFJVWc4VG9CY2MxRkJ6NStmdEZjalZnbjRRYity?=
 =?utf-8?B?UXZCVm05azczOVJNUjd6cElBRWR4eWFnR2NydXMvQzBkMkxjNHlYUXA2UXVt?=
 =?utf-8?B?SGxiS3hZcjE3aTBPaU5OOGNxditRV3NrejJRcngyM01iRFFuRU1raGNXZG54?=
 =?utf-8?B?MitsOHlvdmwvR2V0UGVnOEJtRW1Ma3dwcXpIVjNjbyttcnQxNFp4QVBoR1NJ?=
 =?utf-8?B?OG05QXRveU5zUTg0d2hXZGJNd3puSG9pLy9lR0YwSUQ3bWNIbisyRmZwNVhm?=
 =?utf-8?B?V0x4NlFva2lzbjlkRXRmQUhCajVlcUR0RjAxbC85bkhUWmR5U3dEVGl4L24y?=
 =?utf-8?B?M0d6OUJ2VXRPUkVDaHFoQmtEbm0rNzh4TGphM2wxUmdiMWs4UzQyWmlHVU96?=
 =?utf-8?B?ZkNZU3NvMmtnS2hQcW9maC9CNm5ZTVR1QVZoeEZuNVVvd0g3R3B4WUxpODli?=
 =?utf-8?B?UXVXQjF2WVY3L01MK0toV0pwMmplZHhZd2FqVVlTcmRXdzNEWEpqUm9oUjdN?=
 =?utf-8?B?bE5YVmhremd3WjlqUUgwNkgzOE9Rdzc1K2kvZzliNEVPTUl4aDE0VXFEcFZm?=
 =?utf-8?B?MmZaeGVaZmp0RFk1ODlZVllFbmFyYmhtRktudlA3a1orQnF2QmxSS0NGSFcv?=
 =?utf-8?B?R09DY1hLNlhjdHhKK1BDeXRyc2FYcUdHeDJzOXVQc2FIaVVDRVRicmlzeHN2?=
 =?utf-8?B?SCsxN2haVnIxMDVaNDg1U3FISTFTc254Q3oycjZEOEZGTjR5ZjQ4Ty9tRThm?=
 =?utf-8?B?OEhNRTc1dGJuVklkaTd4VEx0YW16VFNJVUc2S0hvb1ZMb1BZTW96VTY5OEE2?=
 =?utf-8?Q?9mQpWXd7GwAczLlCrtajXTHRkGL6HZHfbwXcOSB?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0348a21c-32ec-4fdf-5ef9-08d9370028a6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 11:06:47.2041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vsMQqnukjP9/3Z7gRx9ytGpEWFBtP1Bzl3w+2OIf5igSddURHgUexNN11SeTHVjzyktfuQ1OepxtrsX2w1bWu6yMI35hT/NDF5ddLTFFkko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1676
X-Proofpoint-GUID: D3PJvymkapuRzdo9HpjrXE8lS8JxqJ9G
X-Proofpoint-ORIG-GUID: D3PJvymkapuRzdo9HpjrXE8lS8JxqJ9G
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_11:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106240060
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/21 18:41, Kalle Valo wrote:
> Liwei Song <liwei.song@windriver.com> writes:
> 
>> MAC80211_LEDS depends on LEDS_CLASS=y or LEDS_CLASS=MAC80211,
>> add condition to enable it in iwlwifi/Kconfig to avoid below
>> compile warning when LEDS_CLASS was set to m:
>>
>> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>>   Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
>>   Selected by [m]:
>>   - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y] && IWLWIFI [=m] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=IWLWIFI [=m]) && (IWLMVM [=m] || IWLDVM [=m])
>>
>> Signed-off-by: Liwei Song <liwei.song@windriver.com>
> 
> Is this is a new regression or an old bug? What commit caused this?

It should be exist when the below commit change the dependency of MAC80211_LEDS
to fix some build error:

commit b64acb28da8394485f0762e657470c9fc33aca4d
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Mon Jan 25 12:36:42 2021 +0100

    ath9k: fix build error with LEDS_CLASS=m
    
    When CONFIG_ATH9K is built-in but LED support is in a loadable
    module, both ath9k drivers fails to link:
    
    x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_deinit_leds':
    gpio.c:(.text+0x36): undefined reference to `led_classdev_unregister'
    x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_init_leds':
    gpio.c:(.text+0x179): undefined reference to `led_classdev_register_ext'
    
    The problem is that the 'imply' keyword does not enforce any dependency
    but is only a weak hint to Kconfig to enable another symbol from a
    defconfig file.
    
    Change imply to a 'depends on LEDS_CLASS' that prevents the incorrect
    configuration but still allows building the driver without LED support.
    
    The 'select MAC80211_LEDS' is now ensures that the LED support is
    actually used if it is present, and the added Kconfig dependency
    on MAC80211_LEDS ensures that it cannot be enabled manually when it
    has no effect.
    
    Fixes: 197f466e93f5 ("ath9k_htc: Do not select MAC80211_LEDS by default")
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
    Link: https://lore.kernel.org/r/20210125113654.2408057-1-arnd@kernel.org

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index cd9a9bd242ba..51ec8256b7fa 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -69,7 +69,7 @@ config MAC80211_MESH
 config MAC80211_LEDS
        bool "Enable LED triggers"
        depends on MAC80211
-       depends on LEDS_CLASS
+       depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211


Thanks,
Liwei.


> 
