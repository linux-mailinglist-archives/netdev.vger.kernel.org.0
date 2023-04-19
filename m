Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3806E7CE9
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbjDSOiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjDSOiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:38:01 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571132D66
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681915080; x=1713451080;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mmdP6rvjGOOBNoa1+94kp/cgV/pwWqqQqNGMTF7d9Cc=;
  b=cmJgoOcp6ZDMv84H8dFPVAtymuHv0JJJ+MuH6oUbrB/ytaTm7Gz1GhiN
   0AmpR829jOQNQVr5YvkFpRNLk0w64zdYxZzQvT/oGTJ1VLDO+dNUE9Psh
   fK1rX6fhonH8z+tA/mYtILDQxuB/Zklx/vmC1c/w0uLC9MQDA5SW1+Qfn
   /EZEdPjGWgik7hk3Ha/5TXkoVoz7W4UPllDejw0qKjkJjcVD2n1ApBk5B
   IPUpPLVtQPcgokL0CEFkbOaHuGaGJ9l+bFS2Yr3U3YHFBqJLkQXPh1osf
   97FVtgpbKN/+yLm6PR1CPqHqXDwTySMHNhXLrSkG4jO3NvdbGivCotSSC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="325078662"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="325078662"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 07:37:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="1021230807"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="1021230807"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 19 Apr 2023 07:36:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 07:36:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 07:36:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 07:36:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOGZ83qbBHq3Q3q+lLhzV7BTcnDZEDA/Sq3noaZwTCjKgvB+seBTwG/TIcf4uBmsZcpU+Sy9D6hVLDFza0hUfiv6M6gT5EKZckbNUrEQQF2bzA9GtTtqbNCVYyRr20p+D+PrxRJqebpS+VCJmpU0YUy1vyOE4FWLrAKoNXtBRp8rFc4iK5Fvlo8lmK6Bo92TPSQXlPKZxfPnbEu7JtCh1jYsFvOZxj3Wl0sp/89M3C0UvpCbwbuUP/1KKJpVa79Z2vD1E18viJ5PuSypr/78xk4VWrHBmr+usMeFHsrCCo/W0/zVK+lP9yDa4FO41ASp1OEDF9mKk1Ls4tZAjgnyxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4YaoQ5/tjsboH4utc8Z5GIAKerw3aZOJoOAvNjYqjmE=;
 b=aKy7YlC/LZlQzFUDtGzsloHBIFsYGn/72KTh3xNifVySTknYWNpLzv97X2+chttN580wU0XHGiE+DXtHrQFHGyIGkskPocTAsDYpncil6X8j85UP0IVTCyFMNbMQHtmt6WJB9PmWcf88B+HRe33+pyWyVIlISKknFbJ6ySNL2VzPoPNbH7BF9WPz+6y7xz++aPniBOY4uoCpyjh5pWRLnLJiFwD0QDQ4mffeFItW7cTwaB7fL9ZAWsNa0qv8AiPGf5/tY2vdw6YtQ7b49oKSVVjhUtreiNnxad3wDAu/nJ21Qdmv4VRyq6JampOL2lJi+MXuUG+A4uIKKaeA09+QUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH3PR11MB7252.namprd11.prod.outlook.com (2603:10b6:610:144::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.48; Wed, 19 Apr
 2023 14:36:48 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 14:36:48 +0000
Message-ID: <05485b0b-27be-1595-a41a-7ff5a0297e93@intel.com>
Date:   Wed, 19 Apr 2023 16:35:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 01/12] ice: Minor switchdev fixes
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <david.m.ertman@intel.com>,
        <michal.swiatkowski@linux.intel.com>,
        <marcin.szycik@linux.intel.com>, <pawel.chmielewski@intel.com>,
        <sridhar.samudrala@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-2-wojciech.drewek@intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230417093412.12161-2-wojciech.drewek@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0353.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::29) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH3PR11MB7252:EE_
X-MS-Office365-Filtering-Correlation-Id: e60b24a7-1e7d-4e9d-9ddd-08db40e3818d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3CGlqfLyv7Q4Gy77M+YgCSu95PN/S8YA2W+VcE2UtcYyze2UGpDeMyxlF/T2im4JtC4MKoSxqKmeMmoHNEUcrJZ2TDupLLyZeH0fZJHdk4hoefgzpYcnU7H6RYGNvLn1rCJDN1p12oeg7LojFPrZWcQgBhQZhE97zZyk69hzWErKd9Xez4opXGdOimz51RsQhY0M6AOhvUktfHeUNV9Go1GUvjXH6yyyiAGT/huFX2DaOn27lzWnUP0BTvJDReKar8Fsm3o5hd79ESgpPNZJWJxX7vIv1yW1zVHJHwrZDIk2g1izMDxWnhW4m/p0U0PvIk0HLgFwTFL0UYECdGwG/wNTWhofZeyds3do/STWs6mTmp63FfJdNu/qLeRWuUdDh6cD8mhGHWfnRvjf7S0hUR/xQlj54z/rjbNOupE8eQKlL1Pc061xkm817FmtNKqMBWyr9vgKMldY++vPizmszolcL4b0y2F1IxcMcIxwRdAGDFGJPd4vD/cnZDonEb2DplTpTe7BP464s2k4gMu3sWaNZt4oUnghk0h+9kzSRWxVEXnxuxbLylxXXr7YNizPE2fz74mMNRRCc0K0UGKjTzxT4GYvtokiewOjO1knlojV31wgZjvF4/mS1DQP3tkOT7Xxlm3XK5FgZZ3RXpGWyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199021)(31686004)(86362001)(2906002)(5660300002)(316002)(31696002)(41300700001)(8936002)(8676002)(6862004)(66476007)(66556008)(66946007)(4326008)(83380400001)(478600001)(82960400001)(37006003)(38100700002)(6636002)(6486002)(6666004)(36756003)(26005)(6512007)(186003)(6506007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGlXTzJSSjd4NlNFK3Y1d3BnUTF3cDEyUXJveElaMEZVUUZ3dnZqbWkyRmF0?=
 =?utf-8?B?U3hBbG9zK2RSb21JM3RIRlZOM1dUZ1RBajIvQ2RqMEVWL0pBVEFuMEx1TFJU?=
 =?utf-8?B?OFQ4VHFnZUVTZ0UwVitpMytEaFhtSEowYm8ydjA2WHluTXlFK0RqcXVUbzF5?=
 =?utf-8?B?V3ljV3dudnMzbkQvanhVemtHK3J5bTRZUDJSdGdSUHA1UmdITmlxcFVxS1po?=
 =?utf-8?B?TERwWmpET0YwU1AyeUNWRDZxSmNGbVZPZDA1UllWQm11YWFxRlJ6K2NOWEdJ?=
 =?utf-8?B?cGFrQWZ6eTJ3dXh2a1lNWUJHeFFJT2d0eHNsdEUvQ1M5Ym42ZkJpZUZWME5o?=
 =?utf-8?B?MEZTN1VBT2RJUHREYWQvSkVoYUkwK3hMMUk4d0pab09lWnhwRlRrMXhFT21N?=
 =?utf-8?B?MWJTT25xVGdGYWZwNDhocHFkc0RSRTIrOUFudCtscFFkL1NjY2hsbzhPVHhK?=
 =?utf-8?B?RmRPWjBoK0xkWkRuMzNMK2VaSVVhazVPNVllM29FRGxTdmZGcDJWQkxoL3VG?=
 =?utf-8?B?NndaVjlkYXZGTktzclptYXFldndEN1hGVWNPcmsvamJtK1NmWE1PdjNwTWU0?=
 =?utf-8?B?ck9wRU1VaytCb0tMR0UzZWhCSVFKM0ljVTM2SE53L1pOMm1qWFQ3K3A5cWly?=
 =?utf-8?B?TzVNMnlMS2R3WlNSRCtRaHM3WnRITUw3TDJ2VForbUZ1ak5HallQTlJ3RGRt?=
 =?utf-8?B?Z1dhOHhSUzZFYW80cDlQYmY1dkd2djNXUWt3YVQ1REl4Mm04alZacGZ6bHFF?=
 =?utf-8?B?elVkU01ZeVdDNXBMdGJhcFdNOGRDanF4a21XK2p6aDJEcmUwQTNWV2x4R21p?=
 =?utf-8?B?N3dqZU9FbDVQR0c1cTdzdWF5ejJlcUtZcGUwSWdDTjVIR0I5Q2tPNENSUVdK?=
 =?utf-8?B?RDBTWW5FbFUyV0VYdk5UeEQrN0NNVGRxUWNaOUg2WUxITzFmS0hWL3hPQ2RM?=
 =?utf-8?B?aW5aZFdoc0VTbzVHK0h4RWxxN2dUeStvUlhHL3NQMGFUY1ZUNEVBRWk4SlN6?=
 =?utf-8?B?ZFJpdGZ5aFFNa1dPWmZaN2hZbnc5Ty9NTkgvaGliZU80SjlZZ0RSVUVFMkhP?=
 =?utf-8?B?YTRmd3A1YlBWWHFUVmZKM0J4RTd0R1dVNkdCankwK3NpRUZGQmRnbjFuN2wx?=
 =?utf-8?B?VHcrNDFzRzVBL0NUQk5LTHhsSDlKWUFGYTV5a2RoRStpODEwV1JpcmhuK2RK?=
 =?utf-8?B?UUhMbEZEQkMreUMvWGY5bENleWl3S3NESkZVNmtucGVlQS91S0JVa0creTRD?=
 =?utf-8?B?TkVydElTK2Nnc3NhY2ZlenBUZ1gwQ0h3UmNUdDRWcnJGUVpEd0U3aDljbUNY?=
 =?utf-8?B?VUdHVkNWalcwM1BtZmg4VVdSRi84eWlMZzY4VkNPVms3U2NXSDBrYzNwakJn?=
 =?utf-8?B?SUhXNElCKzB2a0FOYlVnR3pkWk5LVVNHSGFHQzhUMmhicVJScGlGcjd3bzdl?=
 =?utf-8?B?aFRqeTJzL0NtdEh1ZmFpbUt1THZ2TEsrUnNrcHFWSDRQMVRRZ3dJNERpNnp5?=
 =?utf-8?B?d2F5S01RMWRrK2lVamo2dGpKU0daOVNOdysrWWdnbG1GRE1HWVRNMk50NzJ5?=
 =?utf-8?B?OFd5QnRyck12ckttU3hidWJLaDE0R09Rc1B1K0MyRzFlMmpTWUVpQnNkeGtr?=
 =?utf-8?B?ay9uL2FxRHdjeTBSMGhYYVMwb1M2SzIvcjBwdExrWVBDWjBOcUpGU1YxNTN3?=
 =?utf-8?B?eUcyeXAvZE1iVm5PRkZKa3NGTy9PakpGS3RpUENWQnFvWjRVNnI0WCtRc3hB?=
 =?utf-8?B?THZGWG8zbjIzUldidW5XWEF2d0x3TkpzcXArWUhHYWFFb1o3S2dUTCsyTDkz?=
 =?utf-8?B?Um5HOTRIZnZxWXhmMThTUTlOWkUxNmRNaTZUSnRZYW0rY2hNOFVXWll5Q09r?=
 =?utf-8?B?SnhKbXpodXdNNjRqVUhTd1VJRWdjazAvZXRhSVVuaUgxZ2FpM2c3Q3BoQmFy?=
 =?utf-8?B?SU9TcE53cG1sREU2MGdnaCtUMGRxUG5EM29yQit5ZW12akZMQlg3bHZnNUdk?=
 =?utf-8?B?MHhiWHdXWnNjL1J0cnYybm12OEZqRkh0Y3VYYStvcUp2ekF3dTFmdXNZZHo1?=
 =?utf-8?B?RzlaRm5ha3hkWUk4cmM4TSs0NHBlU3QzTFZ3Ym10ZEdVNUFVVXJnaG12azE0?=
 =?utf-8?B?MmdwTXNhNjFURXNFUHU2eEtlREdrbVF6bm9YOUdZQkc1alhNYm9TNjY0QURz?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e60b24a7-1e7d-4e9d-9ddd-08db40e3818d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:36:48.1602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ANJU0WVnTVjAXNFgMDfWwhMOE1zR8fLJfbNZpgzq7/g9YvlDavH3TWgo7pF82xJVj2o9QkYvUG/JFAQ1ynQN7VlaeU/+WrTKe6Kk4zZWknY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7252
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Mon, 17 Apr 2023 11:34:01 +0200

> Introduce a few fixes that are needed for bridge offload
> to work properly.
> 
> - Skip adv rule removal in ice_eswitch_disable_switchdev.
>   Advanced rules for ctrl VSI will be removed anyway when the
>   VSI will cleaned up, no need to do it explicitly.

[...]

> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 7c04057c524c..f198c845631f 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -385,7 +385,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
>  	}
>  	err = 0;
>  	/* check for changes in promiscuous modes */
> -	if (changed_flags & IFF_ALLMULTI) {
> +	if (changed_flags & IFF_ALLMULTI && !ice_is_switchdev_running(pf)) {

Nit: pls enclose bitops into separate set of braces, i.e. in this case:

	if ((changed_flags & IFF_ALLMULTI) && ...

It's more safe and also more readable I'd say (clearly states that `&`
is intended, not a typoed `&&`).

>  		if (vsi->current_netdev_flags & IFF_ALLMULTI) {
>  			err = ice_set_promisc(vsi, ICE_MCAST_PROMISC_BITS);
>  			if (err) {

Thanks,
Olek
