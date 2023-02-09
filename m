Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFF6690F13
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjBIRVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBIRVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:21:01 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D0166FB1;
        Thu,  9 Feb 2023 09:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675963259; x=1707499259;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nkcfRsaCvKnABptn9I9q/bQ3xpev0sYt2m+wFXGU/XI=;
  b=ZyLP9V965sxIXkAgWLtNCHTlHS1uBJALj0aHsmlubpZ3O2k9wGlF9ZBV
   uwNfNtNWpb8cPPzAPR4NMiIzXnXwdGQFZ96Ga/JXzlC+QVGvJVH05KDhh
   O9zt6nfmzkPNyW+ubaMYp+X0qbn7BaQQj1JPwkiXDQaT8CF+2CbIjpJzP
   Iw5jS2i5P0wY7JdMQbXyNkNwAbht1NF4DCjHSO8Gd0mn6+Qb69jch+iBT
   nkCunWF93Zfsr451yDsfv3G2xG+S4OvFf5sNicL1jgCeIo03V+jPs79eu
   +H7xvqnsH57cQVUD6QcAZkliP/eYm48IflXQIxdNbuymy0YQBaV15YPSF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="328813986"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="328813986"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 09:20:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="810456441"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="810456441"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 09 Feb 2023 09:20:33 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 09:20:33 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 09:20:33 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 09:20:33 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 09:20:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKjEf5MDBJWJ7HB4FI1jBjDo2GhPwMiN4JZIIgYQqLXOvPF7kHSAtmyNkpOA+tL2iXZUOko76LE070csbiAYrG5/OIYeZwD3PnKbUL2Cu2NanhZ7B6bE/C4aLfND7PleqA2Af5rpbNT9+tFneWoOxA5DgrpX77kmT1aDTZgkjqz5BfIS7VBk1W2lHE6/Dws83lr2FVQDkCdGyqP/9ply9aaW9vJdS2YmH2BLGy60Mm7uPtsUmp+AGkX9H67Eom476eJ9Fx0mJue561G7fUgdChkJMVS0KWPC46PaawRo+HeQrghmRl6Q0LXgfj7K9UQgkorCSz1h1zeD6oouBa7+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8z6+loaqB7UqDNNPJJTQtJuP8qbuWRKJiA/ydxsqJc=;
 b=kg0t3Lq/iRORKOzubAF/7XUe4ik+usw/LdSmFZEc6QxW/4mDAERF0kyICUH8esHODQFyKj/2rQf9LGIDnMsdox/D6O9I1ihgU1IzhMULX05LYkW7l2z2CWz9gdhLeSOv+p4QC3B61P2jDGxCcZAEuDutIrr9fEDp027kKtOWL9suFjSsFTRR5N4YokBMQqIpfqDr+DXw5J1W69DmV6QXNySPQyIBTdcihCGfy40ZD0GeAchvtJX7lWBtCnVjO30u1lkKoCJDGZBYW5BAMkr620U0obu7NPK7hK18dD9jbYVZmCKaMZzR7m/P0c+AqbuAXDXjkCscT5ZR/7eOx6lVtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by CY8PR11MB7393.namprd11.prod.outlook.com (2603:10b6:930:84::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 9 Feb
 2023 17:20:31 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6064.032; Thu, 9 Feb 2023
 17:20:31 +0000
Message-ID: <a2af75b3-3dc2-0e83-558f-2b9a4ccfe5c7@intel.com>
Date:   Thu, 9 Feb 2023 09:20:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] ice: xsk: Fix cleaning of XDP_TX frames
To:     "Zaremba, Larysa" <larysa.zaremba@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
References: <20230209160130.1779890-1-larysa.zaremba@intel.com>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230209160130.1779890-1-larysa.zaremba@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0008.namprd10.prod.outlook.com
 (2603:10b6:a03:255::13) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|CY8PR11MB7393:EE_
X-MS-Office365-Filtering-Correlation-Id: 843c4052-dece-49ac-5079-08db0ac1f1f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KR9menWbMVOEaLeciafNJC3IgM1FFEROPggnrQJXpCRif7nzExi3vat+wePNxS5iJa/CNO0dLJP7L3XNw95BOMsznqIYnmaBnugSF1jUJzGl3/B8TqZl3/MvM6qTRO/W1UA4n7SIE8aLJM2Mvlk3dW6uK16Qu2l8SJQrSy4D6/v2CO/8gyImAdWyzanFk2L6brJZv8rcd5sPaBchJV2MBnGgbj/qDruprAjoXiz3Iioe9Xb9lL1hKrBrPW9NLAM7jXRQXwqICzSugqxwjL7PSkeeiJ1mgdJIZrpTNo99IE9K5QNg79BqqsAiPM1BsLEGuMZ5auFmgVKsF5TVZ0fCB70VLNj3l2gcf7RNWU1xgmPf4oCIZkwgH9HznYYWY3TG3PdYqId9WAvOCGjn1NXiJNxhzvmxX6OaR+35KzM48yXeww+5jOz/Pzmb7xfNw4op/Z+Ikf4ILCWmCQ7A6PtCgt7zFo48Cu7qsk2HIBOrx9/593xRJFrJy1qCuIaFb/GGb4xS4vnKoSWvQFFNoKnmmj4SP/GprG19ScjPEkPRKWsMqcd29Gq0t+tg3wWL9P7wSS9VEsJyJndSiFU9OMpjraIQFzBbvqVH+dW3jhY5KTI0b0XlPvm7BxHvGgKj/uPrENhAH8DSU3lTHHBAf+I2WhGweDOSsPtUZrlz+F726r0Gvh4H6eO/HfaWswFP0HVwyDuMlcsguEdm144jHEAsNTjuUswIgt/Iql4JyCL2Mp4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199018)(31696002)(66476007)(66556008)(8676002)(4326008)(86362001)(66946007)(31686004)(8936002)(316002)(41300700001)(54906003)(110136005)(4744005)(5660300002)(82960400001)(38100700002)(186003)(6506007)(53546011)(6512007)(26005)(478600001)(6486002)(2906002)(107886003)(6666004)(2616005)(83380400001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlJRTW9QeW85M1NUazBFeDE5Rko3ZzZBUXJqSi8rdTBXd3hwRjNTdDJRSnNP?=
 =?utf-8?B?MFN3RlpaeDFkRlR0Wi9wSmhDRTZoNEQ5UGJVakw3NXRVTEhTVGJYSytkNTZD?=
 =?utf-8?B?bnNUbk5BMms5VHl3cjlXQnlsQVo5YkRBL0twLzAxdllqcU9jUy9nUnpzNm1w?=
 =?utf-8?B?YVpEclljdjV3MnJLSUJGMHlXKzV2T1dyZUVkTkdXUG93U05uTkRhRUZZUzNW?=
 =?utf-8?B?TWxjU2J4QjJMYWN1bVJJYVR3WUxHUVozeUpFbXlwbVUwZGdQTE5TNnozZDli?=
 =?utf-8?B?bEZENDFZVXdLbXdDTTBEMWd5RE9rQ21xTXpOVXhXVHFtM0tBaWZUS21oNTBt?=
 =?utf-8?B?ZnRTWnJEcEVDWnJuNGtvV0pHeDkxZUl5bis2eVFLOGZyeHprWThRdGNBaGFt?=
 =?utf-8?B?bTZCQjJRTER3ZmkvT21QRlNLbStIaTRHajRpajFFcjRpNVhyVm1udDlWS1RI?=
 =?utf-8?B?OERTTGQzTHRiSDFGclR5ZFdBK3cyM0tSNXVQZ1BWWU9DREhiWUhGOWZBSElD?=
 =?utf-8?B?aDNRVFl0c2cxTDl1NlVQQjJvbEZYVFQ4OUVSVnl4MEtpT0pZMG5ZRllKZm5q?=
 =?utf-8?B?YkYwZmR1OW5rNUVYREhWNHA0eWgvc0x6aW9Ec0Y5ZzgwaHVGamQ4OUFhYjdq?=
 =?utf-8?B?RFE1ZnVCV1EwVEtNd1dZdDY4KzZtNm1mMnd0ekdud2NvUDFhS1ZqVjBYUEdy?=
 =?utf-8?B?TFZCQ0xpS2RNV1J6RzErMkR2L2ZlSzVNeDJ5YW5HSy80WmhxL2k2NDh0am5S?=
 =?utf-8?B?UW5OdWNFcnRKVmtPZWhsSVlJV0Fjd3lQVFAybTc1YkRLT1A3SkRma1R6SU03?=
 =?utf-8?B?a2V0QkpFY0JBVVl0d2tGRWorbGJrS0w5d0xKbTZXaXU1bE05WjBxQ1RzNTZI?=
 =?utf-8?B?SFJxTWZ6YkdEaG1DVjc1VlJiaVhJYnQwblVZbUtqZ3dpSGY2ZjdncGVUb2hq?=
 =?utf-8?B?SExoMmdNZklSeEd6aC9WNkpzZWpOLzBLQW1pcWdFNlR5OWh6dUkySVVRSWxP?=
 =?utf-8?B?M3pzUm1vMkw0aittYTZvejdhUEt4TFVGSkxBaVFNVnM5QmtaakdvRGw5WTdF?=
 =?utf-8?B?cVVaODBaZU9OU1QxY3Q5UHpJcG11b01IN200RXpYTGwxam10cXU5Zm9mSGhG?=
 =?utf-8?B?cnBwZWJqcllEMDJ0akVEanlWQ044dk44ekNZRVM3VDEzL1R1N0hGSW1POXB3?=
 =?utf-8?B?YmJ5bit4TkVwR1k3dndnSEdPQ3E3R0pENWFTUThObHdhVTI0L1F1MjEwUXpH?=
 =?utf-8?B?cmJERXBMaVBzTnNZV3JleTlzL1pxdllYenNJb3E5NzZWOTlrNDVJTjY2bXpO?=
 =?utf-8?B?a3RZMFh5d2kzWkhRVFlWMm1ZalRRejVxMm5tNlp3NmZJUi9mTHZTRDNkMjVB?=
 =?utf-8?B?UUp4ZnJzUjAyeHh2TW1UMkNqQnVVYS9Zam9WL3JHcmZ0cGE0Nm9ndmxaZ3N3?=
 =?utf-8?B?K1Fvb25jZm1rZlNpaVZIZXdUVDVPQnFlY1pQNTJvMGV3MXptbCtRTDZzODRt?=
 =?utf-8?B?TEttMktkZkNCRWhkczVRZE1uTWVGaTI0U1FTdXM3Vyt3bDNHa3Bra1V4TkV4?=
 =?utf-8?B?T0hLaDhEZWI0OTR0NDZXazNVaUxOVzdlWStNRWNLVkVPeGNIS1J5NHo2ckU4?=
 =?utf-8?B?K2RNdzJGNzduOGlWNlBLeWVrNlRUQnNMemJlWFp2dEZGR3JkSDQzTEpEdXl3?=
 =?utf-8?B?UzV2UlJzVWQyekI0TURTZUxkUldJekZqZWcvNE80N0JBNmFiZVZNOE80SVg1?=
 =?utf-8?B?NjVHNXlMMkl5U3RWQ3dSN29IeDdKaU9zL3ViUUxNcGh5a1VOTjI4S0E2em1H?=
 =?utf-8?B?NVNKWEM2eU5qaTI2aEwyZ0tZTFRTbjYzNnZnMnRkV1RXOVRPU2x0WGM0RWIw?=
 =?utf-8?B?S0NHcXpZQStOaHFob3hQc2dibThoWjQrNTlQU2RxVElTVk0xeTBkRUhlMWgw?=
 =?utf-8?B?eCtkWTNkNS80MmpkT3czZG5ISUZneWU3dEhMcjUrN2UyS2R0SjBYK2kvVHpq?=
 =?utf-8?B?dXkxK3l1L2F0Vk9rL05JU2NsU3V6Qnl6c2UvNzhVaTBJZ3JQaTNQcjNjaXRl?=
 =?utf-8?B?dnE2RWpoNVlibHdQb2ZKQW01THVxeGNDbWZ4TnlNOHF0K1NueW5kM3kveTVa?=
 =?utf-8?B?amVyQXBJYWVRb2E1OUV0L1NNWHZyK3dGeGpZY0lkYUkyMENpODJGZW1RbjhK?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 843c4052-dece-49ac-5079-08db0ac1f1f4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 17:20:30.9218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aTiqdak88P9ab8i5or5xjw8/+FtoyUk8l+pFvUgnSTHm8arKp69yUHok4nEtUEOICe0MhCvJSzSIvxyzWiKjixRHpWorpM7mN7K4vrYRkPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7393
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/2023 8:01 AM, Zaremba, Larysa wrote:
> Incrementation of xsk_frames inside the for-loop produces
> infinite loop, if we have both normal AF_XDP-TX and XDP_TXed
> buffers to complete.
> 
> Split xsk_frames into 2 variables (xsk_frames and completed_frames)
> to eliminate this bug.
> 
> Fixes: 29322791bc8b ("ice: xsk: change batched Tx descriptor cleaning")
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> ---
> To Tony: this is urgent and should go directly via net. It's tested and acked.

netdev maintainers,

Since it's been tested and reviewed, did you want to take this directly?

Acked-by: Tony Nguyen <anthony.l.nguyen@intel.com>

