Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A903E6A0CD2
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 16:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbjBWPY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 10:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBWPY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 10:24:56 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2BD3A853
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 07:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677165895; x=1708701895;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EqnQPyZtfKEdhHyrdVfMi8l/jclsw6cGm+VzHmSjezQ=;
  b=CY70UdqlYxuKR2Owdaj1hH4NjlvxYC2NnwqDCDU4vvI8QnzQlQ/9HdVp
   8z8N2pDMIAlo6QilTcwCbHXRbvRzQteBqUtQOWqJomkTSSVZ6xjIyLqrX
   no6lqhl/MCKuWdfzVZ35ng7x5uTr1cYf7DhSqNny7O3k1o0DZGUsaoAih
   gPgAGWS7Fl9/X2UcXXhdsB5MQojviMhZSKOLfC3sKW7KctZYEkDNUCf4y
   GShYI5dm8Ld2o5FyPooS055G5sFlFKwJmQViBMMAfzMyg80+sasa3oksR
   cONvMWV02rlc3RvRf3UI7SRZesvQzKOZ3j+GPaXOHsPT07bMRJFJRePnx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="335465985"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="335465985"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 07:23:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="665802670"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="665802670"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 23 Feb 2023 07:23:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 07:23:14 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 07:23:14 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 07:23:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUjzVc0gC2rC/yPwdDX9B2E0t0lUpOI72qCSfPWi7GX5/C6hFyuXvRbQVCJWUEbUUyPpcAoW1zB18i3/o7g42uj2y0hRz6HYzuZ/tisjxcmnddnA11BwCqU+e5Rr3AdolE4U5CPyI1hGVgnIYKZ4cu3eDGgATDiSpUpQ5EtL5KdRjA7zwT93gukwSfmsZl0l3iwv4SH0RRky2sl68T9hMMB+ZmmTrT1+Em4liqnPuoPnCiS7un3rbZTQt2dkeZ1aQnHZnIySNrLxB35CX2Fhg86YNMGlbFfvayevFFTQRaZN6DluNDsnBGi4XbItBxWRlVjg4MExZ8ljlVP9uzDF8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wH0kcIje/fVj1DxVAg8VWUmfO21NrhOAKgNmA8FKY08=;
 b=aMROY4JEy/oROYZ9s9kX60qNyEaD+9nLg56hlFk6cHu+DG7UlE47gLtwALy0LtlDxlHhBepuopWnNfV7VJdMZYOn0FP4MxL5QixHZYrvfoJWCHxixGsEwkaEX5tCctkzzlpG9sRcwnanApSfbpXkIxhYzPIVjJOYv7TL+AzHBice48qhYfPaDDkYsYJdY+1jd1hh1GSPKHwvvDxTgUthwScrSQ3cNerekWkTgqixup7RHXD04DQSn8UvInb/RvwaedqFgPZjMV6LZ/eIhu5RqCf3MRV2mPXnkp5RppYZXWtGT8wld//hzzkuy5ybImaf3Btoxd/+JWdHpat2+fdHuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB5476.namprd11.prod.outlook.com (2603:10b6:610:d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 15:23:10 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 15:23:10 +0000
Message-ID: <103076c8-12df-7ef6-2660-280301754e01@intel.com>
Date:   Thu, 23 Feb 2023 16:22:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH net-next v17] vmxnet3: Add XDP support.
Content-Language: en-US
To:     William Tu <u9012063@gmail.com>
CC:     <netdev@vger.kernel.org>, <jsankararama@vmware.com>,
        <gyang@vmware.com>, <doshir@vmware.com>,
        <alexander.duyck@gmail.com>, <alexandr.lobakin@intel.com>,
        <bang@vmware.com>, <maciej.fijalkowski@intel.com>,
        <witu@nvidia.com>, Yifeng Sun <yifengs@vmware.com>,
        Alexander Duyck <alexanderduyck@fb.com>
References: <20230221043547.21147-1-u9012063@gmail.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230221043547.21147-1-u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0186.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB5476:EE_
X-MS-Office365-Filtering-Correlation-Id: c31033bc-0120-4505-bb55-08db15b1df6c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vq55sK+TcZcXIR0ZbBwANchO9NwHuPlSi/UXJgORBRghLfnKFxcmUfMtW0hi0SxzgAHYVIb4fdCi0IQJZQG5MbhaOQJZOw9AP9ja2CQZGX3E5DPQ6xnF4lbkvTOsqxI1AFGcDGn8nmV7ypZD/BM9qv5cttolG04oXkDw/wESjOdA9z3xSFrYVMKf4NGl5+ZnTKHUNKT3G78UZaglOmZiTBSfMZRxPg9xZrc7/M9YEUUUsea37lqYTSIfQGq1QTboD8fKBPQdCuAJRD8/T5IC3PX8BxayYOt6d1RfsgCVCNKV2PQV1YQXDWbTpHttEt8tJs8YpfHAv91QgEZiKHVCXviw1qMQT6YdyFUh60w+abRkXhK90saIRsfU1ofR5Hr4kw6gfd1LcjDd9ccYgeejwgheAvgUfBf7tlUOdQtPQ1vjka41h/JdzqtRGqqa9QGqunnDgT+3WQu1vd/UILbuo63yzc/XcdSg46Yv6YIoIq4zHnGuJDrQGK9URPMY/QwLul3H2CRsqoa+kORq4qvX6dkFH/LGDQkbWp5WC0LdF2hkOKtvXCtwV14PQwt62OzTDwkb6JO4TI8lA8Zslw0k3qQjY7QGyARGfdC+VO9w1hvbCmk8Y65Epc8toPvuU8kVEK7f2wm7cJKv8+kdR+PlITyL7VVhCQr+2e0Lres6JZofUcWWhQsMoyMfXK+UkFPOSp/PX9YJexCDjDh+9xTI0xjtZ1GisF/57TaEyLfCCz0/cH+rsB24h4sL9ygsjnvd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199018)(7416002)(2906002)(31696002)(86362001)(82960400001)(38100700002)(31686004)(478600001)(6486002)(6512007)(26005)(186003)(36756003)(66556008)(66476007)(66946007)(54906003)(83380400001)(41300700001)(4326008)(6916009)(2616005)(6506007)(8936002)(8676002)(316002)(5660300002)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHNMTDFhRXVJMklHaG5BNWc3NlBPYkpYUWVDT1ZscDFPRTNQeGZlRnEzN3lv?=
 =?utf-8?B?ZHFXS0x2ejlTV2MvYTNVQm5CMFFIWTQ3V0o0SXNuYzJvNEp6VHhaREVSb1cr?=
 =?utf-8?B?R3R5am5KTUFoTFpSM1Fab09obEJ1S1ErNFl4V2x5MnRLMnNEQkVKbmNxb0Zx?=
 =?utf-8?B?WFN6eW84K0dEQ1hGRUdOUEowdGRDbFdjelhScDhhZmQybE93dmtNOEFsWnI2?=
 =?utf-8?B?TWloeVZadHp1MXBGWXl5YmhNWm5Lb2JDWGF3NC9idFFoK0J4OXNiRCtMSzVs?=
 =?utf-8?B?ckx4MWc3Ny9tTEsyV1drZWpKWnd4K1Npdk92WkRxRFdBRUtHWDFvTFBLNXRx?=
 =?utf-8?B?VHdHSDJ2amkweVZMdTJCRXErV2NCLzhjdUt2amZpaUl6YVBNM1YzZFNoUStE?=
 =?utf-8?B?TFh4ZGZTWFBpVTZ0NVg0MzBQRzVZalpOYlhXbmo2c0Y4NzBvTGVab1RJWm1n?=
 =?utf-8?B?VUZ4SWg3THpCdFN6amYzanhVKzlQbTJNODNsdkNHSVgxZnlZVmlJeFhweWsy?=
 =?utf-8?B?bGtyb0ZycmVML3pGeTVaQ1AwMk9DSXU0bTVXcVhqQzNVeHovMnQrczczcXo3?=
 =?utf-8?B?bGZEZ1JKcklZNFFCa0NqL3pyVDZ3SkU2WHl2ZFZoNjZPb29JSkNwL053Y2M5?=
 =?utf-8?B?enM0alFPQnU3Zmw4UGZTbG1WbnE5RTJwMTQrZXpVV2hTWkdQczl1dmtOeGRD?=
 =?utf-8?B?WGFIWitDR05QMHo5Y25aQmQxSGcvWkpuWGt1VWtoZkN4akM1WkJUYzkvWS9x?=
 =?utf-8?B?bkFMQjJGMVdKa1lrWnl0Nk53dE44cmhFNXhSeVNPMWlQS3lZdng1citEY0J6?=
 =?utf-8?B?Nzg5bFhYL1VtWjc4TzMycTVodnZKVTg3MW5CMGUxRFlubTFhaHF1V1RXblJN?=
 =?utf-8?B?cXlJdkV4Z01zUjJmcCttRVlLZlQ5Z2ZqbnE0MG93YXA1U3U0STFtVTB6TTU2?=
 =?utf-8?B?LzFIc1drWnY5SHNOakMxeTQ3bkZtN3k5WG9IOENYdy8xUzlkbm5uUjI2WWtP?=
 =?utf-8?B?MnhjZFBpMHhHeWRiMkJtYjN0NVNTbGNrMlQrVW56M3c1Zk9RdG11VmVnbXMw?=
 =?utf-8?B?NUVJMVNBZERWSVRNdmVaMURiclk5Y2dqQkNET0RURnFpZ2JUL2xuM0pYY3Ja?=
 =?utf-8?B?WnBucGpjUE0yUFB1ai9YazNBTjV5K2gzTkxhTmtlMlhjMVdPcDcvRlMxUTNX?=
 =?utf-8?B?aUNmWDFRTTEzc2xkYmRWOHptSEk1czEyUnc3Zmxvd3ZtSmhqcm5hdU5ucTdN?=
 =?utf-8?B?WTd6bG5kcGhGNFBEMHNkV1gwdWhoa2MwK0dzM2l2RE9uR1p5Mk1NcFpHRjF5?=
 =?utf-8?B?TnJ4aGxpTVpGelpMT0VmNnJlVEZYTXRZS1ZKV2YyV3JKL1NxNFZLMTNBRWVT?=
 =?utf-8?B?a0prUk92YkRGUWVLZTJwWGZaRXJwVW93Y1F5c29XU3JRWjNkem9oS2RKUlN2?=
 =?utf-8?B?TjNFU3UzTHZRZ0tSSnYybGZEWlFhTjg2bjI1UVluWXBIK1UrN2hUaVRsZ1kx?=
 =?utf-8?B?eUswTXcyeWJoUmtPRm1DajZIcCtGeEh2Y0F0MmFHTHEyNWdwMVhzWmxqcUtI?=
 =?utf-8?B?eThoZit3UFlVZjVwZE5FcHk1RGdiRXdQZGZyV2kvT1hrUjgrZkZ3ZElMQmpl?=
 =?utf-8?B?N1BMV1g4T0F3ZlZST1M0d1ViVklTZDVTODl6b0ZKSVBrNDJhVllVVm5SUXVn?=
 =?utf-8?B?ODJ5emFQSG9XSHhSMnBRNVBST01CeHd6MGFZYkpFTmlLalN4Y2N0NVFmVDFm?=
 =?utf-8?B?VWFZRFJndzc3UGZQMTJNVk8xcXZuYVZQblpTaGthNEFQU0hwUnVEa25seFFS?=
 =?utf-8?B?VjdUWnZqSTBIQzV0KzdRVW5ZVTc0d3ZidmwxWWtFdWNaeUZSdUZQejR3WUwr?=
 =?utf-8?B?aTJoNk9WMmFQSytWMHhDWS8xcXlUdUdRbzA2VFdaOXJ2bnZjeHJMY1RySWM2?=
 =?utf-8?B?OXVNNDR1ODg2UUR0Kzc1R3ZPYjhxQ0ZIWENjVzBRK1laV0xPa0RnK1RQckRa?=
 =?utf-8?B?eDFZUlVKSWhvdkpzY0xiUFlnZ0dNRGp1V0lBM1pUanExQVFlN2F6RUx3ZENU?=
 =?utf-8?B?ZGVYTE02QUF2d0doV2dMcnJvNmNCaTRuWnpMS2p0alZBdFlnbVJjQk9RRHls?=
 =?utf-8?B?eENIRTJjOEJPejZyYkZBQkVMdFFZdzI0UUloa0VOOFMrOUtVOTlmS2E5VWgz?=
 =?utf-8?Q?nPAVrcEt7mmPCvU2P4IP/5s=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c31033bc-0120-4505-bb55-08db15b1df6c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 15:23:10.6927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UEbDHZBCxPc34iBypNjh5Vte1gWqL3WiEF8hZu9wA20Kvi/ecklKxlWTUdh1u7EZmRL+u2Ka1DN7Xm4tzduJsTmJY7YJEXIKr0QItq//4x4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5476
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Mon, 20 Feb 2023 20:35:47 -0800

> The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.

[...]

> +static int
> +vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
> +		struct netlink_ext_ack *extack)
> +{
> +	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> +	struct bpf_prog *new_bpf_prog = bpf->prog;
> +	struct bpf_prog *old_bpf_prog;
> +	bool need_update;
> +	bool running;
> +	int err;
> +
> +	if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
> +		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");

Minor: we now have NL_SET_ERR_MSG_FMT_MOD(), so you could even print to
user what the maximum MTU you support for XDP is.

> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (adapter->netdev->features & NETIF_F_LRO) {
> +		NL_SET_ERR_MSG_MOD(extack, "LRO is not supported with XDP");
> +		adapter->netdev->features &= ~NETIF_F_LRO;
> +	}
> +
> +	old_bpf_prog = rcu_dereference(adapter->xdp_bpf_prog);
> +	if (!new_bpf_prog && !old_bpf_prog)
> +		return 0;
> +
> +	running = netif_running(netdev);
> +	need_update = !!old_bpf_prog != !!new_bpf_prog;
> +
> +	if (running && need_update)
> +		vmxnet3_quiesce_dev(adapter);

[...]

> +		bpf_warn_invalid_xdp_action(rq->adapter->netdev, prog, act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(rq->adapter->netdev, prog, act);
> +		rq->stats.xdp_aborted++;
> +		break;
> +	case XDP_DROP:
> +		rq->stats.xdp_drops++;
> +		break;
> +	}
> +
> +	page_pool_recycle_direct(rq->page_pool, page);

You can speed up stuff a bit here. recycle_direct() takes ->max_len to
sync DMA for device when recycling. You can use page_pool_put_page() and
specify the actual length which needs to be synced. This is a bit
tricky, but some systems have incredibly expensive DMA synchronization
and every byte counts there.
"Tricky" because you can't specify the original frame size here and ATST
can't specify the current xdp.data_end - xdp.data. As xdp.data may grow
to both left and right, the same with .data_end. So what you basically
need is the following:

sync_len = max(orig_len,
	       xdp.data_end - xdp.data_hard_start - page_pool->p.offset)

Because we don't care about the data between data_hard_start and
p.offset -- hardware doesn't touch it. But we care about the whole area
that might've been touched to the right of it.

Anyway, up to you. On server x86_64 platforms DMA sync is usually a noop.

> +
> +	return act;
> +}

[...]

> +static inline bool vmxnet3_xdp_enabled(struct vmxnet3_adapter *adapter)
> +{
> +	return !!rcu_access_pointer(adapter->xdp_bpf_prog);
> +}
> +
> +#endif

I feel good with the rest of the patch, thanks! Glad to see all the
feedback addressed when applicable.

Olek
