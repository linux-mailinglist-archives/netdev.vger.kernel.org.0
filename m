Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A263460683
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 14:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357583AbhK1Nct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 08:32:49 -0500
Received: from mga12.intel.com ([192.55.52.136]:22874 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357602AbhK1Nas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 08:30:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10181"; a="215852969"
X-IronPort-AV: E=Sophos;i="5.87,271,1631602800"; 
   d="scan'208";a="215852969"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2021 05:23:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,271,1631602800"; 
   d="scan'208";a="557193055"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 28 Nov 2021 05:23:28 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 28 Nov 2021 05:23:28 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 28 Nov 2021 05:23:28 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 28 Nov 2021 05:23:28 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sun, 28 Nov 2021 05:23:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhNndYVsK7U9gzYqVxB5xRmcYdmlLUIYMglDYTdKwPVxv3utp8pOTX3J4GNnq2pL0T5CbvVTmQccZcoLAR0se8FBFQ5rn3ncodPZl114NELH2nluAek7VC2yePxuRhI1WuTk+n4eEiZ7SWHAOHJaeBzreRt3+5r3ifyKw/kITJ29U6sNsFK9/pW34oCTwbuAaJ9TSMAAi1+9HGbrsHWFGPhC+gBTAQhULhfbrBPwr0hwuV6ZKWRFOH0sJWOoONAxL1KL+x5P0XUTjvcjQeFq1h9lLlavBA88Efnkh0bhGfYmhEAxMLXqQPvFYXb85+xlVCsRFmmXX5QUZZPb1ZicAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KniN9HBSCWY/yljaPMrhIVn8b/v/RaJ+Y1xoCSEJkMU=;
 b=NN1g07Ow68SQby8Jy5GzNaiaNF/bHselSV1S5cdj/B+Lbo2b2X8F2YshxrYtoiTwLymuAYxp5vnDxayRucBvTvC2sEdooXCMjFhex1Dtsyil13hshw7tVtWuzq4o2HGaPyjlo5O0K04RPeonV1I4DH2RzUXbPW6jKHoIbd1wXca381DwGdupDMR1SbidUc/yCRu/aub2WpXKOL51CgjDuZSg8kxYITtRiBF7Zh6UAjFK/d1hJhIW4EShp3VivBGACnqKbhZX1JN6lEMeqNECJZuCFaEIPvxT8ItK1bjzdJEYHCZu9WDMNlqnb27a2FfzyGnaFYdaE/pgo1zfvKRllA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KniN9HBSCWY/yljaPMrhIVn8b/v/RaJ+Y1xoCSEJkMU=;
 b=krgoKu3KsZn+CHgslr9LW56UK1V2vzm3zkS+ZBiPozEm7gRtwhmWYJJ0WcC0BO2/D+sQyDxncsup3nt3Fgzw2yT9BzF9HhTEG8OU2hHiPS5ICK+tkKNFCY96nJ22NnGvvEPqREMbJDn5DoRE6SxyqOjS945sLoUIzjsKMcnJxc0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MWHPR1101MB2159.namprd11.prod.outlook.com (2603:10b6:301:53::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sun, 28 Nov
 2021 13:23:25 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::ad1a:85f8:d216:bea]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::ad1a:85f8:d216:bea%2]) with mapi id 15.20.4734.024; Sun, 28 Nov 2021
 13:23:25 +0000
Message-ID: <0ba36a30-95d3-a5f4-93c2-443cf2259756@intel.com>
Date:   Sun, 28 Nov 2021 15:23:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [PATCH 3/3] Revert "e1000e: Add handshake with the CSME to
 support S0ix"
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
CC:     <acelan.kao@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mark Pearson <markpearson@lenovo.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>
References: <20211122161927.874291-1-kai.heng.feng@canonical.com>
 <20211122161927.874291-3-kai.heng.feng@canonical.com>
From:   Sasha Neftin <sasha.neftin@intel.com>
In-Reply-To: <20211122161927.874291-3-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR0301CA0038.eurprd03.prod.outlook.com
 (2603:10a6:20b:469::9) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
Received: from [192.168.1.12] (5.29.60.197) by AS9PR0301CA0038.eurprd03.prod.outlook.com (2603:10a6:20b:469::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Sun, 28 Nov 2021 13:23:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe7f729d-d825-4515-976f-08d9b27241ad
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2159:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MWHPR1101MB2159E5D51F1E908EDCC4709697659@MWHPR1101MB2159.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uR5yxMQXXVhR2pruGih7sRu4Iz+ucrYtutrTanIN1We5dZ0vGyhv3Dspngs+ZhsPrwe6b2z4/oAiodFSUDtqt3Essd9aispXAvflLJtco7YHecops+N6tsVYTfHLZ1g8FUGCNmBfQd4wKwpZBNUwMK4tH2b0Qb7KjtDHhl3hsBNp5WLn+yikTC4L4Ythh1/6vs9W2PJf7ZFh9ieoEY2U4GqL5r09dTcXq6xdDdzICGUEYHW07CiLnrXjmI3Gyddvn0numbQk6u9zZ7wIfBrhv5tAh4NhOXiOcme07gWCw5AoizfQ04qIF6LL5kET9khYtuNCrrfCcjNlvMnPPrylKpjlCL3I5L5x7a23ZvM5mOpaqnLs7ssm/PKMCkR3950GHbJ2pSZTFr3i8qAZ3J+yaGVH4hpn2PueNDvVgUbvuD+AWM/ifaQItt/lqaUWOIG3yWOyTlbi7JkKsbCnnp3GKUuuplMK34bX0/2GLchjPnx6kTfEKnT83TprZlUE/dBpUYHk7Fx7wm5pWYjV/UATYJYNbGQE6CihKnSbWnzTEjAxpI4a2/jlD5MOSZQviBEyhIYa7wdPpKZX9GzaNg30kNy96KejqmzDKaNsda36v5yxJOABnM4qMHWC/BQqkEquhPft3kiMZUg5TOIsWIewxG/9wbmag57iD/kwV0pbVXBSHoyTC/ux9noPkfF5ZpgzQc6b0LgN4jzJfTIgnAjZdQv7vVQ2ZUhB6DZArowuEvvPVZfozHUoT1Y1kNkvFKlFpSvjiE9goHZ37gLiab7gED7O6GRxvELeQpxIR9j1B3RKM5zvML8w1pROL9nnMzUAX7R1V06RxioM725U891oaXXX1HiJSQjLZWvWsDIGRTk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(38100700002)(83380400001)(26005)(8676002)(2906002)(6666004)(186003)(82960400001)(19627235002)(31686004)(4326008)(53546011)(2616005)(16576012)(316002)(36756003)(956004)(54906003)(66476007)(66556008)(508600001)(66946007)(6486002)(31696002)(5660300002)(86362001)(30864003)(44832011)(107886003)(6636002)(966005)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHJycW50R1V0bGpQeHk5dlhZc1dObmxRalhEbmprdUswTmpyS2FERFdWcWJj?=
 =?utf-8?B?elhNNmlKWStIOFUrakdpTFA0dCtmaGYwekVmUmt4RFBXOGhHYzIzdWZlNWdn?=
 =?utf-8?B?N1NVY2Q3RWRQZHl1Y2tFOUFCZDBvZi85TkhiOFNpNFBQZGNuT3FLaStuamQr?=
 =?utf-8?B?Rk0rYVFIYjRNdGRlUjNuTVdldkxqS0ZubHVHNDB0ajhPVGFuWi9ma0FTT0Yw?=
 =?utf-8?B?S2s2bXNUNTlXSXBxY0d5ZFJhNGNQUWFKL1NQOVgxc0pYNlAzdXgvNGRpQ1Qx?=
 =?utf-8?B?aVZRRnVuR0ZkM05rN3ZPRWR3TEhYRGJ1bXkrL0ZBZGp3WTJ5dW5qcEo3Yjdh?=
 =?utf-8?B?Q2RqTFhiaHhJU0dLeVRYditMUU8xWFVtcXhzL09JNktpSDZCdkk0MFl4aVF4?=
 =?utf-8?B?TjRyb29lYlZZZDhEQnBIc2E2ekRpSFVBZktnUnk1NXJ6ckdJSmNMeTJ5UTUz?=
 =?utf-8?B?MHpGNHJNT1E0V3NxR2x1VDhaK2FxOUJmV01VMStaQjFMY1lCWUVoSEZ5bEIr?=
 =?utf-8?B?VFQyOWZnUWJ4T2gwY2VGbWRIQlcwMzNUWDVpMGZ1Q0NFeENwVm9qNS9sN2hP?=
 =?utf-8?B?SGdkN2N3YmRLT0t6RGZES0RRVVdwVHNWditjaGZzUkFkWUd3clFLVXlzZjNO?=
 =?utf-8?B?YWp0bXl2QkJCQkxxMUlqS1RnOUttK2NBS0xmNWZFdGxGVU9kNXNMTXVrdFQr?=
 =?utf-8?B?aHd0WWNPQ3dQM3NiNjhRaWE3bW85SDZKRzllYUNvdDJITEpmQ1JPMVNkMlVm?=
 =?utf-8?B?Qmd5eGZFV2ZFZDN6aGlwZzlNV2FFcUJsN0hQVWk3dzJyQktVOGhpQUJlZjVh?=
 =?utf-8?B?bEJnOVdUaXJMbHdaNE1hckNBME5tV2NpZDFvUXBMMENPdnNuNHRiSHpoeFVZ?=
 =?utf-8?B?aldBKzh4WUE0MzM3NU5ldnhBWFI1ODM2aTZZZzRqSmgxNkNKQlRPTG9xTHp2?=
 =?utf-8?B?S3VkTEd0ZVZuK3JaQkVRbmNTQklxTzh4QmgyK3dPYjI4Tmx6bGlZem9uSXln?=
 =?utf-8?B?S09EejFBOUIrN0NaWnRWRk8ySzBiVWphS3FHWjQ3L3lDdXB4UFlnQmJISS9h?=
 =?utf-8?B?am00VUxodnMrblk4M0JaLzFKQlJ3aEVxSGhSdjJVWHQrY3piU0J4Rk1vc3JT?=
 =?utf-8?B?UXVlMFE4ck4vSUEvaXpTQkFPclNHZ2VHYXZ4QllWZjRTVnQ5YTdSQkRoZWN6?=
 =?utf-8?B?cXo1VjJwdHo3b2Z1LzNYL1pIRzBKOHQ2ajBCM212aWZ3eDUyTjc4b2QzVVU4?=
 =?utf-8?B?SGd1TzhWM3RSaG9MZDhodk9FRzRMZHByYno5R0RodEF3K2tVa3lXbVQzNk9W?=
 =?utf-8?B?c0F4WlBlelhCMTVPbEpNbmR1UVp6SzBxd2xQV0ltWWRybWMwZGZwOVp2VTlV?=
 =?utf-8?B?V0RFVlhKQjBsWlZyTXVtUnhjNno3WjdjV0FhQWxKbm5RZHI5SnVSM0NrakdL?=
 =?utf-8?B?M3grT01udWN3MUxQeXJRSFRHcStubTQwRjg0MlBNNXpkdnJVS3h3TFhXL3pW?=
 =?utf-8?B?U3RkMjdBQXZ6RHkzQllXUkFUOEE3THFGZkRYandjUFZxSzE2VlhQZVRGRktk?=
 =?utf-8?B?Q2VJb3FLQU0vQkIwdkkyODA4Y3BlVnI4MHpBY0twZjJGZmhHMU5FamlvQWFk?=
 =?utf-8?B?elN4TWxNTkE0SWxjUW9EcU90VXhaRnQ2MTRJcFUrUXNQODMvV2FCOXhMdVlH?=
 =?utf-8?B?NDEyNnF4MmJXaThud25WUEFmMnBqWmNxY05wdHNqMEJyTVlDcXdjand3VUY4?=
 =?utf-8?B?WHFkVERQWDN5MXhETUlsUkJna2dRZXpqU2JDUStPMG90RkU4MWYrZWZVTktk?=
 =?utf-8?B?dDA3M0JTT0w1QS9OSERMM2hHUTJtZkpvaStadzR6T2JhSEZQK05xbit3Umd2?=
 =?utf-8?B?eEZRc1FIekVQR0dGRmNWUHF6YTg2a1Zha2t3NmZwQXZ4QWJxL29waDFrczBm?=
 =?utf-8?B?aGk0dFRKUDU2SWpwcnNnOUw5MEFCUmEvMENTT1lKYWFJbkZ1UzNaVFdYR0da?=
 =?utf-8?B?WE44OE5qZE1XdTNwemFDR08xU2FTQ2FPNU0wbndrTElZWkxDRWxMU2ErTjZT?=
 =?utf-8?B?blM2RzZzOXl5UkU2Z011MTRkYU5CQmR5S3ZHUStWOWp1MisySU1rT0kwWWVh?=
 =?utf-8?B?WWxMaXBkOFhSTFErR1d2cHBrNE9YUFBhQWV5S2hTM2dWc283dnBud093Wk1v?=
 =?utf-8?Q?KK0FarQopDfACai9pHfUweA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe7f729d-d825-4515-976f-08d9b27241ad
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2021 13:23:25.0534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2iAl169BG97gQbunCtKw9UlDcorrLnkErT2sDRso6T/TaYs0k2cs7wCSrLe86ye3aWS89R/13rTLrJsxSG7yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2159
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/2021 18:19, Kai-Heng Feng wrote:
> This reverts commit 3e55d231716ea361b1520b801c6778c4c48de102.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>   drivers/net/ethernet/intel/e1000e/ich8lan.h |   2 -
>   drivers/net/ethernet/intel/e1000e/netdev.c  | 328 +++++++++-----------
>   2 files changed, 154 insertions(+), 176 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
> index 1dfa1d28dae64..8f2a8f4ce0ee4 100644
> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
> @@ -47,8 +47,6 @@
>   #define E1000_SHRAH_PCH_LPT(_i)		(0x0540C + ((_i) * 8))
>   
>   #define E1000_H2ME		0x05B50	/* Host to ME */
> -#define E1000_H2ME_START_DPG	0x00000001	/* indicate the ME of DPG */
> -#define E1000_H2ME_EXIT_DPG	0x00000002	/* indicate the ME exit DPG */
>   #define E1000_H2ME_ULP		0x00000800	/* ULP Indication Bit */
>   #define E1000_H2ME_ENFORCE_SETTINGS	0x00001000	/* Enforce Settings */
>   
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 242314809e59c..52c91c52b971b 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6345,105 +6345,43 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>   	u32 mac_data;
>   	u16 phy_data;
>   
> -	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
> -		/* Request ME configure the device for S0ix */
> -		mac_data = er32(H2ME);
> -		mac_data |= E1000_H2ME_START_DPG;
> -		mac_data &= ~E1000_H2ME_EXIT_DPG;
> -		ew32(H2ME, mac_data);
> -	} else {
> -		/* Request driver configure the device to S0ix */
> -		/* Disable the periodic inband message,
> -		 * don't request PCIe clock in K1 page770_17[10:9] = 10b
> -		 */
> -		e1e_rphy(hw, HV_PM_CTRL, &phy_data);
> -		phy_data &= ~HV_PM_CTRL_K1_CLK_REQ;
> -		phy_data |= BIT(10);
> -		e1e_wphy(hw, HV_PM_CTRL, phy_data);
> -
> -		/* Make sure we don't exit K1 every time a new packet arrives
> -		 * 772_29[5] = 1 CS_Mode_Stay_In_K1
> -		 */
> -		e1e_rphy(hw, I217_CGFREG, &phy_data);
> -		phy_data |= BIT(5);
> -		e1e_wphy(hw, I217_CGFREG, phy_data);
> -
> -		/* Change the MAC/PHY interface to SMBus
> -		 * Force the SMBus in PHY page769_23[0] = 1
> -		 * Force the SMBus in MAC CTRL_EXT[11] = 1
> -		 */
> -		e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
> -		phy_data |= CV_SMB_CTRL_FORCE_SMBUS;
> -		e1e_wphy(hw, CV_SMB_CTRL, phy_data);
> -		mac_data = er32(CTRL_EXT);
> -		mac_data |= E1000_CTRL_EXT_FORCE_SMBUS;
> -		ew32(CTRL_EXT, mac_data);
> -
> -		/* DFT control: PHY bit: page769_20[0] = 1
> -		 * Gate PPW via EXTCNF_CTRL - set 0x0F00[7] = 1
> -		 */
> -		e1e_rphy(hw, I82579_DFT_CTRL, &phy_data);
> -		phy_data |= BIT(0);
> -		e1e_wphy(hw, I82579_DFT_CTRL, phy_data);
> -
> -		mac_data = er32(EXTCNF_CTRL);
> -		mac_data |= E1000_EXTCNF_CTRL_GATE_PHY_CFG;
> -		ew32(EXTCNF_CTRL, mac_data);
> -
> -		/* Enable the Dynamic Power Gating in the MAC */
> -		mac_data = er32(FEXTNVM7);
> -		mac_data |= BIT(22);
> -		ew32(FEXTNVM7, mac_data);
> -
> -		/* Disable disconnected cable conditioning for Power Gating */
> -		mac_data = er32(DPGFR);
> -		mac_data |= BIT(2);
> -		ew32(DPGFR, mac_data);
> -
> -		/* Don't wake from dynamic Power Gating with clock request */
> -		mac_data = er32(FEXTNVM12);
> -		mac_data |= BIT(12);
> -		ew32(FEXTNVM12, mac_data);
> -
> -		/* Ungate PGCB clock */
> -		mac_data = er32(FEXTNVM9);
> -		mac_data &= ~BIT(28);
> -		ew32(FEXTNVM9, mac_data);
> -
> -		/* Enable K1 off to enable mPHY Power Gating */
> -		mac_data = er32(FEXTNVM6);
> -		mac_data |= BIT(31);
> -		ew32(FEXTNVM6, mac_data);
> -
> -		/* Enable mPHY power gating for any link and speed */
> -		mac_data = er32(FEXTNVM8);
> -		mac_data |= BIT(9);
> -		ew32(FEXTNVM8, mac_data);
> -
> -		/* Enable the Dynamic Clock Gating in the DMA and MAC */
> -		mac_data = er32(CTRL_EXT);
> -		mac_data |= E1000_CTRL_EXT_DMA_DYN_CLK_EN;
> -		ew32(CTRL_EXT, mac_data);
> -
> -		/* No MAC DPG gating SLP_S0 in modern standby
> -		 * Switch the logic of the lanphypc to use PMC counter
> -		 */
> -		mac_data = er32(FEXTNVM5);
> -		mac_data |= BIT(7);
> -		ew32(FEXTNVM5, mac_data);
> -	}
> +	/* Disable the periodic inband message,
> +	 * don't request PCIe clock in K1 page770_17[10:9] = 10b
> +	 */
> +	e1e_rphy(hw, HV_PM_CTRL, &phy_data);
> +	phy_data &= ~HV_PM_CTRL_K1_CLK_REQ;
> +	phy_data |= BIT(10);
> +	e1e_wphy(hw, HV_PM_CTRL, phy_data);
>   
> -	/* Disable the time synchronization clock */
> -	mac_data = er32(FEXTNVM7);
> -	mac_data |= BIT(31);
> -	mac_data &= ~BIT(0);
> -	ew32(FEXTNVM7, mac_data);
> +	/* Make sure we don't exit K1 every time a new packet arrives
> +	 * 772_29[5] = 1 CS_Mode_Stay_In_K1
> +	 */
> +	e1e_rphy(hw, I217_CGFREG, &phy_data);
> +	phy_data |= BIT(5);
> +	e1e_wphy(hw, I217_CGFREG, phy_data);
>   
> -	/* Dynamic Power Gating Enable */
> +	/* Change the MAC/PHY interface to SMBus
> +	 * Force the SMBus in PHY page769_23[0] = 1
> +	 * Force the SMBus in MAC CTRL_EXT[11] = 1
> +	 */
> +	e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
> +	phy_data |= CV_SMB_CTRL_FORCE_SMBUS;
> +	e1e_wphy(hw, CV_SMB_CTRL, phy_data);
>   	mac_data = er32(CTRL_EXT);
> -	mac_data |= BIT(3);
> +	mac_data |= E1000_CTRL_EXT_FORCE_SMBUS;
>   	ew32(CTRL_EXT, mac_data);
>   
> +	/* DFT control: PHY bit: page769_20[0] = 1
> +	 * Gate PPW via EXTCNF_CTRL - set 0x0F00[7] = 1
> +	 */
> +	e1e_rphy(hw, I82579_DFT_CTRL, &phy_data);
> +	phy_data |= BIT(0);
> +	e1e_wphy(hw, I82579_DFT_CTRL, phy_data);
> +
> +	mac_data = er32(EXTCNF_CTRL);
> +	mac_data |= E1000_EXTCNF_CTRL_GATE_PHY_CFG;
> +	ew32(EXTCNF_CTRL, mac_data);
> +
>   	/* Check MAC Tx/Rx packet buffer pointers.
>   	 * Reset MAC Tx/Rx packet buffer pointers to suppress any
>   	 * pending traffic indication that would prevent power gating.
> @@ -6478,6 +6416,59 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>   	mac_data = er32(RDFPC);
>   	if (mac_data)
>   		ew32(RDFPC, 0);
> +
> +	/* Enable the Dynamic Power Gating in the MAC */
> +	mac_data = er32(FEXTNVM7);
> +	mac_data |= BIT(22);
> +	ew32(FEXTNVM7, mac_data);
> +
> +	/* Disable the time synchronization clock */
> +	mac_data = er32(FEXTNVM7);
> +	mac_data |= BIT(31);
> +	mac_data &= ~BIT(0);
> +	ew32(FEXTNVM7, mac_data);
> +
> +	/* Dynamic Power Gating Enable */
> +	mac_data = er32(CTRL_EXT);
> +	mac_data |= BIT(3);
> +	ew32(CTRL_EXT, mac_data);
> +
> +	/* Disable disconnected cable conditioning for Power Gating */
> +	mac_data = er32(DPGFR);
> +	mac_data |= BIT(2);
> +	ew32(DPGFR, mac_data);
> +
> +	/* Don't wake from dynamic Power Gating with clock request */
> +	mac_data = er32(FEXTNVM12);
> +	mac_data |= BIT(12);
> +	ew32(FEXTNVM12, mac_data);
> +
> +	/* Ungate PGCB clock */
> +	mac_data = er32(FEXTNVM9);
> +	mac_data &= ~BIT(28);
> +	ew32(FEXTNVM9, mac_data);
> +
> +	/* Enable K1 off to enable mPHY Power Gating */
> +	mac_data = er32(FEXTNVM6);
> +	mac_data |= BIT(31);
> +	ew32(FEXTNVM6, mac_data);
> +
> +	/* Enable mPHY power gating for any link and speed */
> +	mac_data = er32(FEXTNVM8);
> +	mac_data |= BIT(9);
> +	ew32(FEXTNVM8, mac_data);
> +
> +	/* Enable the Dynamic Clock Gating in the DMA and MAC */
> +	mac_data = er32(CTRL_EXT);
> +	mac_data |= E1000_CTRL_EXT_DMA_DYN_CLK_EN;
> +	ew32(CTRL_EXT, mac_data);
> +
> +	/* No MAC DPG gating SLP_S0 in modern standby
> +	 * Switch the logic of the lanphypc to use PMC counter
> +	 */
> +	mac_data = er32(FEXTNVM5);
> +	mac_data |= BIT(7);
> +	ew32(FEXTNVM5, mac_data);
>   }
>   
>   static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
> @@ -6486,98 +6477,87 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>   	u32 mac_data;
>   	u16 phy_data;
>   
> -	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
> -		/* Request ME unconfigure the device from S0ix */
> -		mac_data = er32(H2ME);
> -		mac_data &= ~E1000_H2ME_START_DPG;
> -		mac_data |= E1000_H2ME_EXIT_DPG;
> -		ew32(H2ME, mac_data);
> -	} else {
> -		/* Request driver unconfigure the device from S0ix */
> -
> -		/* Disable the Dynamic Power Gating in the MAC */
> -		mac_data = er32(FEXTNVM7);
> -		mac_data &= 0xFFBFFFFF;
> -		ew32(FEXTNVM7, mac_data);
> -
> -		/* Disable mPHY power gating for any link and speed */
> -		mac_data = er32(FEXTNVM8);
> -		mac_data &= ~BIT(9);
> -		ew32(FEXTNVM8, mac_data);
> -
> -		/* Disable K1 off */
> -		mac_data = er32(FEXTNVM6);
> -		mac_data &= ~BIT(31);
> -		ew32(FEXTNVM6, mac_data);
> -
> -		/* Disable Ungate PGCB clock */
> -		mac_data = er32(FEXTNVM9);
> -		mac_data |= BIT(28);
> -		ew32(FEXTNVM9, mac_data);
> -
> -		/* Cancel not waking from dynamic
> -		 * Power Gating with clock request
> -		 */
> -		mac_data = er32(FEXTNVM12);
> -		mac_data &= ~BIT(12);
> -		ew32(FEXTNVM12, mac_data);
> +	/* Disable the Dynamic Power Gating in the MAC */
> +	mac_data = er32(FEXTNVM7);
> +	mac_data &= 0xFFBFFFFF;
> +	ew32(FEXTNVM7, mac_data);
>   
> -		/* Cancel disable disconnected cable conditioning
> -		 * for Power Gating
> -		 */
> -		mac_data = er32(DPGFR);
> -		mac_data &= ~BIT(2);
> -		ew32(DPGFR, mac_data);
> +	/* Enable the time synchronization clock */
> +	mac_data = er32(FEXTNVM7);
> +	mac_data |= BIT(0);
> +	ew32(FEXTNVM7, mac_data);
>   
> -		/* Disable the Dynamic Clock Gating in the DMA and MAC */
> -		mac_data = er32(CTRL_EXT);
> -		mac_data &= 0xFFF7FFFF;
> -		ew32(CTRL_EXT, mac_data);
> +	/* Disable mPHY power gating for any link and speed */
> +	mac_data = er32(FEXTNVM8);
> +	mac_data &= ~BIT(9);
> +	ew32(FEXTNVM8, mac_data);
>   
> -		/* Revert the lanphypc logic to use the internal Gbe counter
> -		 * and not the PMC counter
> -		 */
> -		mac_data = er32(FEXTNVM5);
> -		mac_data &= 0xFFFFFF7F;
> -		ew32(FEXTNVM5, mac_data);
> +	/* Disable K1 off */
> +	mac_data = er32(FEXTNVM6);
> +	mac_data &= ~BIT(31);
> +	ew32(FEXTNVM6, mac_data);
>   
> -		/* Enable the periodic inband message,
> -		 * Request PCIe clock in K1 page770_17[10:9] =01b
> -		 */
> -		e1e_rphy(hw, HV_PM_CTRL, &phy_data);
> -		phy_data &= 0xFBFF;
> -		phy_data |= HV_PM_CTRL_K1_CLK_REQ;
> -		e1e_wphy(hw, HV_PM_CTRL, phy_data);
> +	/* Disable Ungate PGCB clock */
> +	mac_data = er32(FEXTNVM9);
> +	mac_data |= BIT(28);
> +	ew32(FEXTNVM9, mac_data);
>   
> -		/* Return back configuration
> -		 * 772_29[5] = 0 CS_Mode_Stay_In_K1
> -		 */
> -		e1e_rphy(hw, I217_CGFREG, &phy_data);
> -		phy_data &= 0xFFDF;
> -		e1e_wphy(hw, I217_CGFREG, phy_data);
> +	/* Cancel not waking from dynamic
> +	 * Power Gating with clock request
> +	 */
> +	mac_data = er32(FEXTNVM12);
> +	mac_data &= ~BIT(12);
> +	ew32(FEXTNVM12, mac_data);
>   
> -		/* Change the MAC/PHY interface to Kumeran
> -		 * Unforce the SMBus in PHY page769_23[0] = 0
> -		 * Unforce the SMBus in MAC CTRL_EXT[11] = 0
> -		 */
> -		e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
> -		phy_data &= ~CV_SMB_CTRL_FORCE_SMBUS;
> -		e1e_wphy(hw, CV_SMB_CTRL, phy_data);
> -		mac_data = er32(CTRL_EXT);
> -		mac_data &= ~E1000_CTRL_EXT_FORCE_SMBUS;
> -		ew32(CTRL_EXT, mac_data);
> -	}
> +	/* Cancel disable disconnected cable conditioning
> +	 * for Power Gating
> +	 */
> +	mac_data = er32(DPGFR);
> +	mac_data &= ~BIT(2);
> +	ew32(DPGFR, mac_data);
>   
>   	/* Disable Dynamic Power Gating */
>   	mac_data = er32(CTRL_EXT);
>   	mac_data &= 0xFFFFFFF7;
>   	ew32(CTRL_EXT, mac_data);
>   
> -	/* Enable the time synchronization clock */
> -	mac_data = er32(FEXTNVM7);
> -	mac_data &= ~BIT(31);
> -	mac_data |= BIT(0);
> -	ew32(FEXTNVM7, mac_data);
> +	/* Disable the Dynamic Clock Gating in the DMA and MAC */
> +	mac_data = er32(CTRL_EXT);
> +	mac_data &= 0xFFF7FFFF;
> +	ew32(CTRL_EXT, mac_data);
> +
> +	/* Revert the lanphypc logic to use the internal Gbe counter
> +	 * and not the PMC counter
> +	 */
> +	mac_data = er32(FEXTNVM5);
> +	mac_data &= 0xFFFFFF7F;
> +	ew32(FEXTNVM5, mac_data);
> +
> +	/* Enable the periodic inband message,
> +	 * Request PCIe clock in K1 page770_17[10:9] =01b
> +	 */
> +	e1e_rphy(hw, HV_PM_CTRL, &phy_data);
> +	phy_data &= 0xFBFF;
> +	phy_data |= HV_PM_CTRL_K1_CLK_REQ;
> +	e1e_wphy(hw, HV_PM_CTRL, phy_data);
> +
> +	/* Return back configuration
> +	 * 772_29[5] = 0 CS_Mode_Stay_In_K1
> +	 */
> +	e1e_rphy(hw, I217_CGFREG, &phy_data);
> +	phy_data &= 0xFFDF;
> +	e1e_wphy(hw, I217_CGFREG, phy_data);
> +
> +	/* Change the MAC/PHY interface to Kumeran
> +	 * Unforce the SMBus in PHY page769_23[0] = 0
> +	 * Unforce the SMBus in MAC CTRL_EXT[11] = 0
> +	 */
> +	e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
> +	phy_data &= ~CV_SMB_CTRL_FORCE_SMBUS;
> +	e1e_wphy(hw, CV_SMB_CTRL, phy_data);
> +	mac_data = er32(CTRL_EXT);
> +	mac_data &= ~E1000_CTRL_EXT_FORCE_SMBUS;
> +	ew32(CTRL_EXT, mac_data);
>   }
>   
>   static int e1000e_pm_freeze(struct device *dev)
> 
Hello Kai-Heng,
I believe it is the wrong approach. Reverting this patch will put 
corporate systems in an unpredictable state. SW will perform s0ix flow 
independent to CSME. (The CSME firmware will continue run 
independently.) LAN controller could be in an unknown state.
Please, afford us to continue to debug the problem (it is could be 
incredible complexity)

You always can skip the s0ix flow on problematic corporate systems by 
using privilege flag: ethtool --set-priv-flags enp0s31f6 s0ix-enabled off

Also, there is no impact on consumer systems.
Sasha
