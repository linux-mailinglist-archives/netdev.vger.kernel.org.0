Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDC0502FE2
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 22:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352221AbiDOU5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 16:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352201AbiDOU5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 16:57:42 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCEE554A2;
        Fri, 15 Apr 2022 13:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650056113; x=1681592113;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TodLhhKNVyjA6m9QSjXD8uXe9eyK3fp81BzqBHBr84w=;
  b=eGgclnPAv0Bczfq9pdTc7NFkzQefHfGwmvQ0sd1ti6Gz+g8n/ZGSCe0p
   jUBk2jrCEHFY/3u167nP67HG1u6be1SOvuzvOlNHmWnLjY60sPZB/UCTU
   7pgaHFOLNxmpE8UvT72Z/zEnXf4gMPjDFKc/UK4bpSzYMARexeb6T8eea
   Chl2HcJlxddOg+012qrtT/6vRxyWyacZI9jRM7rNQIS6DBIl9M7ndH0qc
   I1HF5SfuADdPUoocKEyo/ujxMsmPq8NiaHqCBGEnQRITbiWbyDJRBCw6R
   nfOnd5CW7fh2EQwepOwkEmUIkYdeWjiYk9mW8qezeopX2YHtOjE4z7b+Z
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="349677655"
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="349677655"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 13:55:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="656548533"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 15 Apr 2022 13:55:12 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Apr 2022 13:55:12 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 15 Apr 2022 13:55:12 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 15 Apr 2022 13:55:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMssTxGHbP4R/HQZcIErTfGr90/Lm4WkTHnOUQkf4H0RM8fFx7ZsHCRNsmLuTN8CePd5cjezBSRgzExAlBjTVuJuBE+iDRAMV8dbHdoj6F1FfjwXbwekVjFqrnMTmy38zl8suzR/1bqdYmMkduT9iWZJtQOQlPKocfFGZ0ujImIp9zFVjz6vtW6BQLiDctD7kv0H7LrlZnef7hgE7l2CmSIjre7VJB8TEu2EkEcItw7BA7LPK/DR+rEyYa/ZRnEE7kjlCPssM/iSarOhxI45QqNNkxWQEjHT4usQgxWwmreyziGTgW+7erKkt3ac3H9qbvjtiHMYdyZUOGl2CduXUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QzWySTMG3D6sZfWDui6JeUNY64vKKdO1PnU1H5BiGSQ=;
 b=Dxrc+3R6Nd9I1MFEhDeQjvLr4OB2Z9dExB21sBQTGnDuRJBo/fbWrgbpaQ0TnJP06R7HXOttUoh7TWPemhbxPWlejZFLlDPrHcE1w3uIZQNhVkpwN5N3CGghTy863vBrM0IKoVz3B6IQhhDx0lJRAIl8cOBP3vcYUHkcs/vScL1CCLrLHhb5hsP1uQNWsARYsr5VRXQLh1G0Iw+qTyvFud4UD58S9v497457kt45M9BX0S6Qwk/DvC6Qid+6pryGhGiL2+UqePAyiLgOqUWrXj7dIk0m+kjt+DZxWN1/CzHNsCzuZPvYzzyt4Amy0wUjVmukVAedMiUu5VAmBg+Wqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BN9PR11MB5337.namprd11.prod.outlook.com (2603:10b6:408:136::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 20:55:10 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acf9:f012:22dc:c354]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acf9:f012:22dc:c354%7]) with mapi id 15.20.5164.019; Fri, 15 Apr 2022
 20:55:09 +0000
Message-ID: <248da3d7-cb00-14b6-12f0-6bb9fda6d532@intel.com>
Date:   Fri, 15 Apr 2022 13:55:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [Intel-wired-lan] [PATCH net] ice: Protect vf_state check by
 cfg_lock in ice_vc_process_vf_msg()
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Ivan Vecera <ivecera@redhat.com>
CC:     Fei Liu <feliu@redhat.com>, <netdev@vger.kernel.org>,
        <mschmidt@redhat.com>, Brett Creeley <brett@pensando.io>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220413072259.3189386-1-ivecera@redhat.com>
 <YlldFriBVkKEgbBs@boxer> <YlldsfrRJURXpp5d@boxer>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <YlldsfrRJURXpp5d@boxer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0294.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::29) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1f21a4b-7980-41c1-812f-08da1f223a7d
X-MS-TrafficTypeDiagnostic: BN9PR11MB5337:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN9PR11MB533703E1337251F0B9E61C1FC6EE9@BN9PR11MB5337.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /8jdh4fTEtBp24bABXqWfhPHoSXYiF3oPjvNsYgXdj9xF+aS307Uk3OhRcSr13rdH8qOGcyXC4ONwwm6prnnmL3VSdKG8gtbQQfKcDNQKELtG30a9juTTIRzXqGGT/0JtVzvqXFUGwz5ge+yYrfAG/lHnsswfpPXTDRnrP9E+zcNP5dde9fF8QQXcFepfH/Wez0ZDhoBd9K6H2NtCb7/znxP+KczojPud0jt5SURcnd2jtujnf9yaHQtaeyt2fpcI9+bHfdKWTrcWlLMe5bjGJlyBtD53d7BygzX/eAfQFXmF9zDUm3DVCZCl71+SbcdiTEtoFeLX3oIw+b5s87ttnwQshuaVW6e0UbyCEEZ5t0UY1htw/ZcE7/+Ab+n5mXNUZzC/yIbosjX3TUoR4DpyIbEsTnvv2yS13w48sGaYMqCj2FH8Nr2gQ4Rn+Nz6ZmiMdasLLDhEmmcaUZg91xgeNE2+u1FO98pRs7NclMnTslbBOC/xHVLu3ae4lXY37tUkNpdSLSNBRdhdQo+G1E5WDiBQ3R4iYyrMlpOeOiV1hylvBJLujnceFS5xvBXnhjHhPtubTJdJ6aAYLVzE/WDqircMSyvSuuC9INwGpe5FVboi1zztnQHaW8n90Glzz00VUyLgmS41Kaq2sD2thMj2BhFPMpDRDu2bCCeHrz3qiAesX72OIAqcA+b9UfBNtGWkLmwr+9po/Yoqcc0cQZJi+ccbmu8Lt4kWJZd4fiCvuDpTVWbhLvPgjZfjEPgmLQj64DiHfXs7D+VgWpgEFIV0HcCUtFNrJeWLYnN/FKtwVOM6xolMsc61u3ZEfQqO04AXeqJcV2/yjhIabJNxXeNsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(82960400001)(6486002)(6666004)(6506007)(6512007)(966005)(26005)(38100700002)(508600001)(83380400001)(86362001)(53546011)(66946007)(2616005)(36756003)(66556008)(66476007)(31686004)(5660300002)(316002)(7416002)(54906003)(8676002)(186003)(8936002)(31696002)(2906002)(4326008)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDQ0eERCTDJqVFRSMDhmU0xsT3FyRWRMU3Z0Nmcra1k0RVN1cnArMm9kODVx?=
 =?utf-8?B?ZHlWSzVTWHRicFUxUWxncnZBNDhhQ0hOeEt1QmduK3lVUFZ4c243ejBXOFZj?=
 =?utf-8?B?MzNqZ2NOdFJGWmkzZW94b3J3NEp1SnVpdFM4VWVkSUlsb05GUDhVTWU1R2wr?=
 =?utf-8?B?Unc0YTQvZ2hucTV5UmNENTlxR1NrdDlub0hlRzNOQnBuNUdxRjh5RWRLVGFm?=
 =?utf-8?B?NGhReVBZaThsWVpWN2pqVnVKelNoZHFVcXN1S1pBNCtpWkxpNURyWmFjTEVz?=
 =?utf-8?B?ODVNclV0V09MbVB4eitlMEY4ZzJJM3NRN1NLci81a3NPbDVVSC9jSlBBNXpK?=
 =?utf-8?B?WEFOYW1nRzRtKzBEYXlNaWtWQ0grTlNUSitaTHJ5d2QvNS9PdWI0N3NuRXBs?=
 =?utf-8?B?eFpxZnAwZkYxekxYc3U2b2hNZzlYblZvOHI1bjlicU54amp0aUI4OFF4QktR?=
 =?utf-8?B?b29SbUFtOXhCcEk0c1RHanVtNnRhZG1vMFl5eStzVEUrY0dUeWl2STVrdXdr?=
 =?utf-8?B?Sm1GKy9pdUZQNnBHN1FCL0cxN3FxOWtNTFp6QWRKVjM2SWpReFJLMU9WcWFx?=
 =?utf-8?B?Mm51YUpvVjhUVjBvNDUxMW0rVDRVY1dOVG9QUXA0WWVseE5TdUtEeUhzWXcw?=
 =?utf-8?B?eGxWWS9qOHl1OE1zMFVHM0RmcmhKWFMybjUycG8vYnVRYWpxUjZZdkpJZ2k4?=
 =?utf-8?B?dXZ1UWcvMVBLMHJEZUN5Q091ZWpldkJLejkvNEw1TGFqSjNyVUh6U29oSW1q?=
 =?utf-8?B?NGp4OUEyb3hpcVZlWllPRVVCNE5RYzV6K01udWw4eDBMeTc1d0xoa2hWTlQ2?=
 =?utf-8?B?T1FjaHZOSWcrbnc4T0FRQ3hqNHNIR3krS1p0c3lWRVNUMG5GOEJpOVJ6aUZ3?=
 =?utf-8?B?c3ZlNHFxWis0OEgvSlpzRkVydTlpcEE1d3p2SmMvb1JKTnFKY0JTN3V4VHRG?=
 =?utf-8?B?a0JRekVlUXFEd2k2WmxRK24ybG5WWUQxTmQyWWZyaVJ6b2JyaHNlQUJxc09Y?=
 =?utf-8?B?cmV4b1pDMzd5NTBVNlRiOUJUUGZCeldqTXNRVzlhNHNaQzU1SXUwTmU1VVg1?=
 =?utf-8?B?b21WN25DOHRSckhOZHJlS3dCYzYrZ011T1NqeS8zRyt4blJKeG5xN3R2emY0?=
 =?utf-8?B?MFVNdWVwazdwd2pZRE1IeFNvV2dPVVhTRStTNWxoeHAwaVNHNFlONERLQUxQ?=
 =?utf-8?B?TGl4dWd0b0NSemhEbERqNkRyQ3NRN0JFdXVDNXpybkowWnM3eUtVTkNENVN0?=
 =?utf-8?B?T2JVdHNXdkZoUXdhd2xZdXBZWHNjYVR6Q3dXWDBybm1MV01MQkRIQzkzZmp2?=
 =?utf-8?B?Y0pUUnkvU3ZKRlNhVnYvSVhXNGw3VTN4MWFuODJoT2cvUDc1Qk0zbVNqUnpG?=
 =?utf-8?B?NEJ4MEtoQThpeFh1dVl5U1VySVJ2dFlIQWpNSU5BMnJhNUo1ZHoxNExkTDB3?=
 =?utf-8?B?eDEza1U0OGlPUWs4YzRVSVl3dWRETWpsSndaSEZSd1lHVWZZVmNkMkZYc2N6?=
 =?utf-8?B?R2thSU1xQjREdFpJK1dHVG5lcXo1ZlBhS3orcEFxRUhSK1lqTFFoK0hDdGEy?=
 =?utf-8?B?ekNjWVNuSFNuOGZ0TjJTU0p2bHhqeWx4NWpDWFRlUUlLQmtDb0grUHdKN09C?=
 =?utf-8?B?YXI5R3FSK1ZlY1YrRFplYmczWFVBbmptZU8rUHpDWW1wbTZpZ1A4NnpHejBz?=
 =?utf-8?B?b3oyNjlXdSs4Zlg2K1lPcWtZMnhiQjRHdzN6T29vRGQva0Q3MDdtTU9nWG5l?=
 =?utf-8?B?Qks4RmJTc0pCVFBqU2tkOFlzV05LTENsdEcxemVXTHlKZENrSE9SN044M1NS?=
 =?utf-8?B?Y1VjeFJrMDlOaG9vc1VpZWMwWmVtRTBTU3JtOEN6SkkzaU5EbVRvM0ZqNHF3?=
 =?utf-8?B?TEdyY2lzUWM1Q3dES1REVENNQ2I1SkM5Ti9ieUIxNzhyS055NGRrZk5KZUZY?=
 =?utf-8?B?MGkwMmtrZ25vZnhYMUtKLzZ1ZEV0b0RaRzZEOGR6bHU5T2F4MWhRdVNyMTUz?=
 =?utf-8?B?YnNDVnlBcVBFdzZtTUF5SGpRWThCUFVSM3ljdjdCSnlKNi9Cd0tCL0M2b1JG?=
 =?utf-8?B?S21heXJENFFhNEkycVBOS3hSemEvdzAxLzE3Nk0yUDAxWlpxNTY2Z3U0NFEz?=
 =?utf-8?B?OENLSHJ2WmllR3JGc0lwbjU3S1FHR2R4VUljLytOVjRGeUo1UDFINzJteXpa?=
 =?utf-8?B?WnVIL1AyS0ZnOUpDZW5vYmlTVnhaaFZwSHE0M3VYMmRJVFNXdmp2VkhkdnRn?=
 =?utf-8?B?Zzhnam5oV2pmNG15OTlyUDEvV25DTUh1TEUxT2lyTXZ0UGsyNENTS0FHWi90?=
 =?utf-8?B?c2dKNGRQWm42b2h2dldLbVEwN3RHaGlNYnZ3eTNzMENVeGZsWityU3JiWXQ2?=
 =?utf-8?Q?/MhHvYpnXogme+pg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f21a4b-7980-41c1-812f-08da1f223a7d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 20:55:09.8717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O/CRrGzFInQnz798sdPWH9IDMw7lpYPeZsrAF+FGcl2wRX1XwhzxTG5EwwBV52Slk6iW5ADS86MWNoBIgWUwIJlGQlKCqvP0of4TEeAaBBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5337
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/15/2022 4:57 AM, Maciej Fijalkowski wrote:

<snip>

>>> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
>>> index 5612c032f15a..553287a75b50 100644
>>> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
>>> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
>>> @@ -3625,44 +3625,39 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
>>>   		return;
>>>   	}
>>>   
>>> +	mutex_lock(&vf->cfg_lock);
>>> +
>>>   	/* Check if VF is disabled. */
>>>   	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states)) {
>>>   		err = -EPERM;
>>> -		goto error_handler;
>>> -	}
>>> -
>>> -	ops = vf->virtchnl_ops;
>>> -
>>> -	/* Perform basic checks on the msg */
>>> -	err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg, msglen);
>>> -	if (err) {
>>> -		if (err == VIRTCHNL_STATUS_ERR_PARAM)
>>> -			err = -EPERM;
>>> -		else
>>> -			err = -EINVAL;
>>> +	} else {
>>> +		/* Perform basic checks on the msg */
>>> +		err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg,
>>> +						  msglen);
>>> +		if (err) {
>>> +			if (err == VIRTCHNL_STATUS_ERR_PARAM)
>>> +				err = -EPERM;
>>> +			else
>>> +				err = -EINVAL;
>>> +		}
>> The chunk above feels a bit like unnecessary churn, no?
>> Couldn't this patch be simply focused only on extending critical section?

Agree, this doesn't seem related to the fix.

Thanks,

Tony


>>>   	}
>>> -
>>> -error_handler:
>>>   	if (err) {
>>>   		ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
>>>   				      NULL, 0);
>>>   		dev_err(dev, "Invalid message from VF %d, opcode %d, len %d, error %d\n",
>>>   			vf_id, v_opcode, msglen, err);
>>> -		ice_put_vf(vf);
>>> -		return;
>>> +		goto finish;
>>>   	}
>>>   
>>> -	mutex_lock(&vf->cfg_lock);
>>> -
>>>   	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
>>>   		ice_vc_send_msg_to_vf(vf, v_opcode,
>>>   				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
>>>   				      0);
>>> -		mutex_unlock(&vf->cfg_lock);
>>> -		ice_put_vf(vf);
>>> -		return;
>>> +		goto finish;
>>>   	}
>>>   
>>> +	ops = vf->virtchnl_ops;
>>> +
>>>   	switch (v_opcode) {
>>>   	case VIRTCHNL_OP_VERSION:
>>>   		err = ops->get_ver_msg(vf, msg);
>>> @@ -3773,6 +3768,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
>>>   			 vf_id, v_opcode, err);
>>>   	}
>>>   
>>> +finish:
>>>   	mutex_unlock(&vf->cfg_lock);
>>>   	ice_put_vf(vf);
>>>   }
>>> -- 
>>> 2.35.1
>>>
>>> _______________________________________________
>>> Intel-wired-lan mailing list
>>> Intel-wired-lan@osuosl.org
>>> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
