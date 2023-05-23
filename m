Return-Path: <netdev+bounces-4789-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B0B70E41B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2AAA280FAC
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA3B21CCF;
	Tue, 23 May 2023 18:04:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD602098A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 18:04:01 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1079CA;
	Tue, 23 May 2023 11:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684865039; x=1716401039;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=19Cl938j4SaCENVj2c58gnejr/SeqoZn2rN3RDbai60=;
  b=kTvzaI1i5cDQZ3NBSUS88LXWccsbSdFQoi1W9G21hdimm5RDFWH2bSn0
   z+q5uEYdLu5rL03IIqESc35YIiQo/IMvP8h4Bjj+4uRgJrMkzGvVWtXsk
   658+1DNMoEqRYPFGsluSmue05CXroNeFvsMWniKeCxcUwNz/O5XTILW1O
   GBbHAw9RsUTBKOpDZrRAg3MjZ17mH4Tl4E++kWxWqEakZUnND+JQ9bEeQ
   p5Zp8ExK2DBEoy8RJii4KfcCAuI7h8vRb727XWRIL2d12zV/rJ8vGVQUk
   D60VPrecTjT0ZSqV+Hd/bLhZ4sBdqYaduJ50+mpDLwtGNsStC7IUQJTpK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="333681909"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="333681909"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 11:03:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="654470899"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="654470899"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2023 11:03:58 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 11:03:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 11:03:58 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 11:03:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaU42b/ln1v6wvJhpkhddrtwzGgHQr9rzC132OFMCKcNCR6W+klgd3ersTJMXwN31sPHJqXpw/ot3LqLXcjIEwNrpRBOthPdSExApIaCFHU439rEWIjQdi188ow29s1Q4Y3p0BusU4mpwQughikMmH1kQY+dZANyiWddVvFfmE5k3TOgFeHDVEJ5KgZise4XA+3gfEC2riRXbekYRPrxUtCcpBz/MXMP9+Vm8wPJesIWtxGwXKyUmmTo+/38g/vjL/9M+AJODptu52+FillBjePipPTXgdD7dHnmvoHJ8avM7hGa9x0Mi77mpc6XVDTUJNjSJEQcpoEu/GWYpYujZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXMozgen9iugukfMK3kGd3PP95g0lXMVcbbxeLREQ/k=;
 b=HVN17mw91a8f9FXXpDoisZpI37jOzHKsKEG1bx4O3Dk40O6jUlYH/1IVd0UPKmX5L7870EW1GBzAC3gVFYSzpWwtO+qfT4XasYTaNYuugeU1qv7oos4l9qHMatS00jYGtedib6U0PZSkS3KIs9KKIY/FqOvODP6ducsTp2JokYNfu+B2jG6nLRl1o3LGsTfbpwXUALAeRyp/Y9fCNf2mHWgs7qefPlJQ25XSjXQom+LRmcO+iyGU98OWGQ8gn7NR+MRhbdwxJqLWwWACCENuhhgRshh6wicTcTjmKFCuLEmlImW+fbe5sjJszl5a9nvDJMyIC80DV+XRMEIfLEHAnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by MW4PR11MB5892.namprd11.prod.outlook.com (2603:10b6:303:16a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Tue, 23 May
 2023 18:03:56 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 18:03:55 +0000
Message-ID: <52cfebaf-79f6-c318-c14b-3716555d0e8f@intel.com>
Date: Tue, 23 May 2023 11:03:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] igb: Fix igb_down hung on surprise removal
To: Grant Grundler <grundler@chromium.org>, Pavan Chebbi
	<pavan.chebbi@broadcom.com>, Aleksandr Loktionov
	<aleksandr.loktionov@intel.com>, "Neftin, Sasha" <sasha.neftin@intel.com>,
	"Ruinskiy, Dima" <dima.ruinskiy@intel.com>
CC: Ying Hsu <yinghsu@chromium.org>, <netdev@vger.kernel.org>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Paolo Abeni <pabeni@redhat.com>, <intel-wired-lan@lists.osuosl.org>,
	<linux-kernel@vger.kernel.org>
References: <20230518072657.1.If9539da710217ed92e764cc0ba0f3d2d246a1aee@changeid>
 <CALs4sv2+Uu=Bry=B3FYzWdNrHjGWDvPCDhTFcNERVpWTjpmEyA@mail.gmail.com>
 <CANEJEGuzoBa_yYHRCa0KygUe=AOhUkSg4u6gWx+QNCuGtKod2Q@mail.gmail.com>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <CANEJEGuzoBa_yYHRCa0KygUe=AOhUkSg4u6gWx+QNCuGtKod2Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0133.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::18) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|MW4PR11MB5892:EE_
X-MS-Office365-Filtering-Correlation-Id: 56036917-8791-4708-71bc-08db5bb812b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U7Sbm+To2IeNUJX4wFsWh3zKe35Q5xOnyP/67uMJRK+7LIAO+JTp3/CxvAxfpZ3yUuvKtXjl3+qdWfKs7tuB/+t5rFTXhyDtFvGv7gms9u1K9BZcQsM6Dsb44p3k/UMaK5tSMKxlyaRKF+g3yuH/I2hSidmRILY9is4klgOaT1yMpqAxa5AN3MXbLb5MF9SKGJabMHNqKt/bupBr4ZYdzxoB0rw/Kf1fvC2XwBr8Dljwn/L1OgIzUttC4RYCTfh6K6YcFHCKVQkbR50anUy156cDp/7OOMHcdyvEnwkHOebmiJfJyrBHF32xwLIriVnd63jMT+dfDm6tvTBpBwOQSBJXs7xxfVaVxOvLkiN9+0IXMgHazR4W9juQLdCBdJZoiCl8qYb1dox10TfaKfahCqVhZOvBdEKxx9kqEWzwMm8tKqdxbIkvHETiACFamKbQTwar/Q+t0KD/BI2eQawvajP2Y4sLjGYk94caRpd9Dh+2bZjKnYgbBOqN9uugKQyekEyTN0u+YYZObIuGcLzKr0XU7D4gXZLsQT+D4SDmEwq4iBnCu3pmwQa4vupzvJmnD6i11vTGyMZEbsM5LsEYJZdVmLqeEeffx5ZmKCZHwojmppb1wAEUpB4Gtc/a2o2jWCt9a4KsEe61LbPPARMokg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199021)(6506007)(6512007)(186003)(82960400001)(53546011)(26005)(7416002)(38100700002)(2616005)(36756003)(83380400001)(2906002)(316002)(6666004)(66556008)(66476007)(4326008)(6636002)(66946007)(41300700001)(6486002)(54906003)(31696002)(110136005)(86362001)(478600001)(31686004)(8676002)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1FpMUxaZ0pQU2JUN3lyb3dMZUx6QlNIWFRGWjhjMzJwbkEvZllKY2RBV3lv?=
 =?utf-8?B?YnY2YjhLeU92anFxY095MFoxOXU4a1RYY0luNXVJNXZOd0s5eHVDMUZnSTlw?=
 =?utf-8?B?Zi92aC9Ra2ZFUmhqVUdFbWpKL3h4VEJkM2MrOXpzY202VW90K2toQnh6eEpZ?=
 =?utf-8?B?K3hJRFBJKysrK0oyWjRiUFc4ZXcvTldFTnc4TTl4NjVCZTVKV0h3ZVRZcDl3?=
 =?utf-8?B?aTZZTEZjcGtWaURmdnQ2UldtODl0VkRZdUdhU2NjWU1DWVplRkhuSHFsM2tQ?=
 =?utf-8?B?Q2ppZUsxK21yU25BTjRFS1h5d09TU2hNN1pDblJCcWllWHljelpTMVE1MDAv?=
 =?utf-8?B?MmpuMVB3S3RxTHRaUUViaU1QRnJuVnJ2NU1VMHlaUVRrUTd2cnJZVGtISDRt?=
 =?utf-8?B?eS9KTDl2WGg4K2FheTZwbXZJS2V2TCthUFg2RW14MHRpR2hIdCtPTkEvVStY?=
 =?utf-8?B?UEo3QkFFMDVKcW9QT2hSeGNCek1YQWszUXlacnhySTV5VFYwdHhaV3VMSTNs?=
 =?utf-8?B?cmxXanlxMjQ4aThvZ1NlSFY2UnFKOThBKzIyRjZ5TEVXcGhialh4dVR2bHhl?=
 =?utf-8?B?K3lySll0aTJ6N1FZL3BEcDE4eUF3ME00MkF1eEhBWVJBSmxEbTRBTnhobUlC?=
 =?utf-8?B?M2lqVUFOc3R0YWFFR3NCMTRtbGkyNFYxa2NwNWFOZlI1bzRFekNzVE5EbEJ0?=
 =?utf-8?B?NGhCeDljemZOdCs4WXpiSTh5dVVkYTJtMkpQNEtQQ3JhdGZHWlpxb3loUkF4?=
 =?utf-8?B?blRVV1pQcTJEYkVCY0lBOE0rYUQ1RVZXTlhrTUhHMGt4OFRLUmhreW1nZklm?=
 =?utf-8?B?a0JtMlVzR0pwZ3JESHNXQWM0MHF6VllrVGdxcW5vVUZFMWtwa1Noc3Rnc2Yx?=
 =?utf-8?B?dVo1UjlOWit3OVlEeVVkdHBoUkJwTHA0ZjIvbzRCbmRpZXpXVzA5UjU2R2FI?=
 =?utf-8?B?S1Jzd3hXWjRZVjFHRUhLanNRWkIxTWVVam12dUdYNm5YaTN4YUxSZ1ovTi9y?=
 =?utf-8?B?bmhkcUpmQWpGb21mRy85Wk91djNpZmppZkdnTnArdkxQWnNiOXpJRVc1NlEw?=
 =?utf-8?B?TUVtK1IySXpJcWNXY1IxVWJnSFVpaHhyS2FOVVFUb01rRlZDT1YxVFpxalFo?=
 =?utf-8?B?eTkxcEJ5b1ZJZjBaUU5KUE01Tkg2ZWlITk16M21DK1M4MHJaeWdlZk9MY2Za?=
 =?utf-8?B?VzZyNCtwZkkwdkQ0UGFjR0dXNTdFWmZQL2dWUWJ6SmNVSndXOGwxSkVlU2RT?=
 =?utf-8?B?cW9XS1E5VkpldUJyRS9jWmpldXR5bnRhaTRnZFVoeFpjTitlMVUza1h0YlJO?=
 =?utf-8?B?d2Q1UTVHRHRnVWpGTllwbmdJRFUzczd5OGJiYkdNNytzSGFSaXFWZVFlVzZT?=
 =?utf-8?B?cklpbXBqVWhZcFI3RVRCUFAwZ1JNSWNsS0JSQ0dsckpzUEJ5K0lJYlpZSmZ2?=
 =?utf-8?B?QUV1ZzZkaU52WmdyM3JzY202L1hBVEV4bTUrcDFQUFE2M01HU0dOMjM2ZFl6?=
 =?utf-8?B?SHJCZFA0cWV4TTBpSUtNRmRFcEI4KzEvQ2p2UGoyOW52OExEVlFTaURPMHRV?=
 =?utf-8?B?M251NlozWmw4VTgyL05ZeXExVTFWNHNpTzNxWDhyM2RhZTFsQ0tSVFdXcytJ?=
 =?utf-8?B?RmdwejhKbGNsZk1nWFEyRTRYcU5ZR2w1RGFmcGRPekxFRzZ3NmhiY0trSzRy?=
 =?utf-8?B?SUUzSGg5bmlzOEhGdHFaZWRBRjhHY21qOCtPMGw2ZkJVOElPNVV1OVJhaHNE?=
 =?utf-8?B?V0Z4cFJSYi9ZV2tkOGVtaFV3WjlPa2FzMlY5M1RDUDZLb3RtZWgvWFRBWXBm?=
 =?utf-8?B?UE94Q3BhcHdWUEtBMzRDa24rVlQ2elBhY09oaEJweWRpQ3d1K1hnaFNrZHdB?=
 =?utf-8?B?Q2VuQURaSUowUG00TWMzSWdtcUdXTUt1VndMQzk5cC9nbHBlQXRHdmE3OUwv?=
 =?utf-8?B?OEVzb1h1TWtmQ2JsYWxGbHdXTGRuMFNGVlpadDZFLzNMWTlYT1hQREEzSXJ1?=
 =?utf-8?B?WnBzUml2QzNOVWpicklmcVBZT25Ma0xCbWVmSHA0QmV4UUU1UUJlcXREWGRt?=
 =?utf-8?B?Y215eEVCSlVXNHVjVDIwTXFoTkxZUFk2UzRNdWh5SEErZExhSS9OQUMvQi9K?=
 =?utf-8?B?SUVwSWF5TGp4d3NuWmxpT2p6cFh4dmE4eVdXMnF1S1Q5ZXBQUXZTcWdXSnEv?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56036917-8791-4708-71bc-08db5bb812b2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 18:03:55.4715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Sx4dlGIHM/CXLPHWkO16WSsbk6VzbfJ3cBuVv8N+x6te2OoVvtrduOL2YK81GcMabODm5AV6E4fAj3RBWeILpU+z0MuXuqMj84iWrsWV2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5892
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/22/2023 1:16 PM, Grant Grundler wrote:
> On Thu, May 18, 2023 at 3:36 AM Pavan Chebbi <pavan.chebbi@broadcom.com> wrote:
>>
>> On Thu, May 18, 2023 at 12:58 PM Ying Hsu <yinghsu@chromium.org> wrote:
>>>
>>> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
>>> index 58872a4c2540..a8b217368ca1 100644
>>> --- a/drivers/net/ethernet/intel/igb/igb_main.c
>>> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
>>> @@ -9581,6 +9581,11 @@ static pci_ers_result_t igb_io_error_detected(struct pci_dev *pdev,
>>>          struct net_device *netdev = pci_get_drvdata(pdev);
>>>          struct igb_adapter *adapter = netdev_priv(netdev);
>>>
>>> +       if (state == pci_channel_io_normal) {
>>> +               dev_warn(&pdev->dev, "Non-correctable non-fatal error reported.\n");
>>> +               return PCI_ERS_RESULT_CAN_RECOVER;
>>> +       }
>>> +
>>
>> This code may be good to have. But not sure if this should be the fix
>> for igb_down() synchronization.
> 
> I have the same opinion. This appears to solve the problem - but I
> don't know if there is a better way to solve this problem.
> 
>> Intel guys may comment.
> 
> Ping? Can we please get feedback from IGB/IGC maintainers this week?
> 
> (I hope igc maintainers can confirm this isn't an issue for igc.)

Adding some of the igb and igc developers.

> cheers,
> grant
> 
>>
>>>          netif_device_detach(netdev);
>>>
>>>          if (state == pci_channel_io_perm_failure)
>>> --
>>> 2.40.1.606.ga4b1b128d6-goog
>>>
>>>

