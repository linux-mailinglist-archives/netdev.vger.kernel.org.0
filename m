Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE49C6DF81B
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjDLONK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 10:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjDLONE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:13:04 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2673826A6;
        Wed, 12 Apr 2023 07:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681308782; x=1712844782;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AA3JNz177+CiLjgBZ5KXzeziWT+mfnlRMAcCC1An4Gw=;
  b=d5tleeQa/d2iuoH5lacIxbpehg3omB7u/OmvQpU5vAoeQrslvO6tEH8N
   /Y3Hc5H1knn0TwbcvuQ976VEq+KQiPWJmOGTIpw1jPWeV97Mm6/igiAWW
   xI/QHaNesq78/MnuM/uZ5AazmhFXqF+Fdr8ubVTDcYKSXjKq20gEn/1h2
   mq8IAwhZuDeaih1oHrPLwCfvPE6X4eNxsn96xR6sIl+0pCvo/zjTYvcqD
   m2FeWB4uazRNb6JW28F66VhgxC0OBewb6LiYLeQrfehw9icUT73jgrIX4
   Z9xMK0vranwql3xy14HubJ+BAjmIcPirdxRBCft00z7U2FUzsCONeChHb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="332605339"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="332605339"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 07:13:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="719389735"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="719389735"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 12 Apr 2023 07:13:00 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 07:13:00 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 07:13:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 07:12:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lddUoHUXPKU+ocY+iuks+EaWEF/W2lIiiJJ44YvpVOQbO6rMwQKk8hRPp+jiwMUiP4F6jqxpHYiUUVBqIvYoKeHGq/7Ao+PdhQRZfk/uEbDurZhs0HlE1YW/iE8cJj/iAAVpOIQyO3SR9KEpiqygJyDyBP2SKVRNYlKwO6y2FpbkroFsFR7i3+5MpZxEKSM2DhoFdx27FxcXaGxlpYJ7frXYXyWRNmwK3U4qaTAfcsoem+FzgRTECE5Aq6NxjdjgilPjpckEoqegxof/YSyulc3BNIu8xBKqG4NIQpwxwIgRUqA+AYXigccsSrgOLXxc+vAsvetjZGD7uOGnyU6yNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nwEnKrHgj+ukbtNgasJTGRONNCGek8hRnOHMgyDD2U4=;
 b=Jx+1Tu18k+xgZVnmjAlfqmeYXOSKA1PHD7Zp1TYWnGazF1RXYKu5U3VtJSRB4IaYFles+DAyrtRc3cdMSRW+GqjAi44cD6CyNWKAoz3r1pd7JGyonNnf3/75duoImPGF20Dfpo3pe5xJjsqncdn/Lmvie8EUhV4GtqaEMtwOZSIYbDB5QpKp6ToRpnltU7Mke97gmCoRJzIS0IcpkeMIbnmpQ/0zYAr8JVQvnqoo2oKBeKPUAciLYYFyfeASZxIsG6HUz90Qd1kz3Qyw9pKyV4uLuip+21J2czObyEbQhEJS/v2cUMJjZXw94YQhs229w86EZ/b9e4W+60VhBOJhDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by MW3PR11MB4571.namprd11.prod.outlook.com (2603:10b6:303:59::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 14:12:56 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3%5]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 14:12:56 +0000
Message-ID: <11811efa-7722-fded-b0bb-64808cfc1336@intel.com>
Date:   Wed, 12 Apr 2023 09:12:52 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] wifi: mt76: mt7921: fix missing unwind goto in
 `mt7921u_probe`
To:     Jiefeng Li <jiefeng_li@hust.edu.cn>, Felix Fietkau <nbd@nbd.name>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        "Shayne Chen" <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "Kalle Valo" <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
CC:     Dongliang Mu <dzm91@hust.edu.cn>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
References: <20230412062234.4810-1-jiefeng_li@hust.edu.cn>
Content-Language: en-US
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230412062234.4810-1-jiefeng_li@hust.edu.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:40::17) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|MW3PR11MB4571:EE_
X-MS-Office365-Filtering-Correlation-Id: 95a27486-f69d-4148-b419-08db3b600322
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Agxbn/jNCXctAR1QQS+w/zMsqPCSuDFvrDmhOS5GVZlQzcQyFQXmSdQupZJtYh91+PBsUr6uiY2NuJ3MlpMut8uet17ac/N9c0KvJV4W1M1+f5YdfkjGN9xVGTBjRT5fk3fcpkyzv8Xvw+5ksRO3AqLvXeH5b/JecqDtpuBI8kGb5ZTUtZRthx4jsSjG9Ezg04NuN4eFDBx2GG3u0R5vlJbDMHdNqhYP1IoMWHlMm+ju2lX58f9sR3Aik4L7rRBsmfU1Smq1k/bAToZwL6fx+D+SrNDa9bTo/fQgSLbWwupHBBmBDXXpzMKcS7cd+UPRvgxT8TmWe0bSK/3J4IUfOYmZSN4aZSQwMIDOkL1UpqqbW2xjyyJ/iexmKJMt2M//grQtnbrj/3NO3gekzSaW892rC+ii9bI7Fb4SlFzke3LEu7Vk1McZ3Py9trg/4geidEjQbZZGHxuioFfMWuWLwcDbMv9oxVQFJ5ZXnYl6l3siaVmaod0lTY8M9rEHDRwMpZglSRI7keppD2jE9c8FDv2OLItRIxxkBzeV94HErmP3vm4sn8ag5sNYh5QHqnVLXL24vi4Acsip2Lw+sIoZPcY6ZrWRH1YjFKJ7mVwZ//17UgY/v+kCR6r0NjlHQNJXg63LcIJuIu6rw46Cd6nbLYa6dMZYMjJvfFOJhAxRJHHYJ1lFV9pfV5jD1p26TVrk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199021)(66946007)(6666004)(66476007)(66556008)(4326008)(8676002)(83380400001)(6506007)(26005)(186003)(6512007)(53546011)(86362001)(921005)(38100700002)(31696002)(2616005)(82960400001)(316002)(6486002)(36756003)(478600001)(110136005)(2906002)(31686004)(41300700001)(5660300002)(7416002)(8936002)(81973001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0o5OHBPT1RoR2lEeFNHeG9GL0M2MFAxWjd2azhydDNwbzNoUFpCRkJkZDFT?=
 =?utf-8?B?akhTU0ZyYmxYRUJqS3pNVlJ2RUkxeE1kZkVhbjVMOE5GeVBFK3lYbTl3MEgv?=
 =?utf-8?B?djE2RVU2akMwbGZ3ZGdxSmxGVS9iZlJrSndzUnB2a0wrQWhkSTQ4NUREL0VN?=
 =?utf-8?B?NFhCOTdiNjZMaGxsa0w2VnNpeGVBRDZpaHBYTWJ5cDZ1dkRaTndBckJVMEc4?=
 =?utf-8?B?Ti83eHV3VmtxdndCd1AzSWdlNTMxWkprZUpzVElOckRkd3R6ZkxrTGV5ZDha?=
 =?utf-8?B?OE45U0UzdDhyMlU1QW5pMVp4SVpEMmU0VkpGUTFHempvdmFNQmRFT25aN3l3?=
 =?utf-8?B?VktmMjRxZVZWazRIdTh6RXVxWVZVaGlVS0d5YUVVYmJ1Y2xxYmZBbGxoSlp5?=
 =?utf-8?B?UWJLTWFvL2puQU5wWEhWQzJjTUxVM3NYSWxaWEo0TWdQSzNQNVBGZFh0c3Q3?=
 =?utf-8?B?RldUaUJRMktOQUZpNE01M1BHYVFCTGt6V3hOeEV4NHlleGtDZHRvOS8xQkRK?=
 =?utf-8?B?ZUc5RzVuZzQrWnBsa0dlaERBTWRWa01WL1o5NGlDVG1QVTM5bU1HaWJpaEli?=
 =?utf-8?B?a3RaTXR1K1JKOUk0SkNLeXB5a2xVWUx0U3JLZG1WdjVUcGpsVTBZb0ZHUHZU?=
 =?utf-8?B?Z2dwakkzdHVDTlo3cXpVR0pOdkQrUEpidVFJSldhMXlpSDlGNGs0dTVnQnhn?=
 =?utf-8?B?MGlDQzRyTjRjSFhKcjdBTGMvbU1lN2E2c2tKcGkyRHk2TVBEN2ZYMmFUTDNk?=
 =?utf-8?B?a2xIYkw0Smp4Mjl2R0NSZFJuMnlqYThqWjdPUU5oWTMxZUlGU0V4Qmp4MUpV?=
 =?utf-8?B?WjN2YU9NOElOVWVtWGZkVERsakt5VFhlUEtvcUZEZWhJdnczNWduaVRHWU04?=
 =?utf-8?B?Um9YOUl4ZVNpdzlwem50NHR3dXM1SG5jUjdTcHl5VjlJUjhNTzF1cFkzWkpo?=
 =?utf-8?B?bndZK3ErSVBMdDZDMllWNm1iK0w0TE1ubDNLMlNmRlNuQUtVL1RBcURIY1Bh?=
 =?utf-8?B?Mkdxb2h1eUpIYjBYRzliUEZLZ1E3L3JiOXdycFFGbEg0bkFNaEptR2hwOWpv?=
 =?utf-8?B?MkJnN3E3Z2haeXpmQVh5SkRSQW4wTU1BZnExdXJPTVY2MGxWdDBpZjF6dEZm?=
 =?utf-8?B?UjZpUUY3VSt6aFo1WGZQMlBXb0NPSlpsYU4xMVh2SWtnRGh1WUdONkhEWk1E?=
 =?utf-8?B?d2FsanBiQzdra0J6U3lESGI2ZDl4RUFCNUg5dzVQa242WUtTRmx6eWkrRzFj?=
 =?utf-8?B?RFRtRnpoejB0c0dSOWFXM2Jrb1lza2xHNkpoaW1iNWJkdWhPSVFQdWhOQlV0?=
 =?utf-8?B?RG0xVjRSdHJNc3pKWlQzK3hpTUJtaEdraEZaWjZYZXZmdzBjd3pCNnRqUCtq?=
 =?utf-8?B?UmNiYzAxN2dIbHQrSmpzVFhXa1E3UG1tbWcrOHNJejFoQ2ZtNFJHZW5FN3h1?=
 =?utf-8?B?VGRNeXlCdnA2VzM3WUt1TktqTkVwR003QlpmVm5wc0x4a1NSWGlXSEF0SGFD?=
 =?utf-8?B?WGFnY2tLKzY0em9NM1JEOUhGUDk3SGVSNzFtOUpXRUlEMm1ST25RU1JJZkJo?=
 =?utf-8?B?M2FzOU5HckcxV1ZjellPQkNxdHhJV1ZUR2lLVEVndytTU0xFZUJXblZEWDdI?=
 =?utf-8?B?ZmFkRTl2SDMwcXh4UXZxeEVxSnJ4SmdqQmNPTmJ6LzFTSXlPVHZVSm1WV0N3?=
 =?utf-8?B?T0tZbGFzOThJY1JLN05YQ1R4SlBha3dCZGVzSEx2WkYrVW1kN2pPMVhxQTMw?=
 =?utf-8?B?RHhVazNCdk8vM2xRejBMaTJ2eXdhN1A1N3VCTTFKT0pGYWh6Q0lRSmtrc0p6?=
 =?utf-8?B?NlhJSDE1YnFWZE14bXlWOVBhY1VRams3T04wRzRBN092a0NVUlNBb3NPcGlx?=
 =?utf-8?B?c2h0czNyYmRZZjFQd3l1LzZWOWp3V3dGMlo1U2pncDZPUDZNSVMrbWhNbW00?=
 =?utf-8?B?R1BIQ3Q2bk1pYTFseEUzTVVaTU5GVCsxU3UxUmxuYmxyTGN1SlRzcllseXB4?=
 =?utf-8?B?ellrMVhlWFJXWTJlVjhxR2wwVks5aDgzczduUmppZjE3RG54US9nbEk5d0Rr?=
 =?utf-8?B?dnFpWlFkTUJ0ZWN5VlUwOWttMzhtN2RVVU00UHdJRFF4VnNIL21aVzNacTY5?=
 =?utf-8?B?NXNvN0t2Y2xUYmVvMS9yYkU2UDZaTTZUNlNoZStzMUl2SDA1TjN0VEIxS0Y2?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a27486-f69d-4148-b419-08db3b600322
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 14:12:56.0950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S4UPHYlnLNKYs3xVyXxLyj59+yi2Uutx8koJYmiP5ZUiSrKAiQ0CZijRJ0YBO5kwVyh+eak/wLWA5GtGEl6j+3Yw/YscBeWnzZljel74txk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4571
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 1:22 AM, Jiefeng Li wrote:
> `mt7921u_dma_init` can only return zero or negative number according to its
> definition. When it returns non-zero number, there exists an error and this
> function should handle this error rather than return directly.
> 
> Fixes: 0d2afe09fad5 ("mt76: mt7921: add mt7921u driver")
> Signed-off-by: Jiefeng Li <jiefeng_li@hust.edu.cn>
> Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

> ---
> The issue is discovered by static analysis, and the patch is not tested yet.
> ---
>   drivers/net/wireless/mediatek/mt76/mt7921/usb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
> index 8fef09ed29c9..70c9bbdbf60e 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
> @@ -272,7 +272,7 @@ static int mt7921u_probe(struct usb_interface *usb_intf,
>   
>   	ret = mt7921u_dma_init(dev, false);
>   	if (ret)
> -		return ret;
> +		goto error;
>   
>   	hw = mt76_hw(dev);
>   	/* check hw sg support in order to enable AMSDU */
