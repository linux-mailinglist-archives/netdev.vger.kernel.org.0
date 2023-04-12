Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7CC6E0034
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 22:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjDLUwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 16:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjDLUwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 16:52:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F15561A1;
        Wed, 12 Apr 2023 13:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681332758; x=1712868758;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EwO6R9pbaz6U5mv9P0Lpppj2dYgjDTuXSVKAhrEfTrw=;
  b=Fq9Be8z7TzWZnXrj5+NbMQSJAdq1vJxNOyLAcr9nJj+fm5w3wYW8qoaz
   e1J/0vpCJhd6OFpETLZO+5dnqUoatKad43kXi//BuUh0STFNLgQK1L+M6
   2loplxZKn9TLvRzgutdcD5SuavB2PYk2pZLUt4DQynBUydumMw2/n58gb
   MsDXd0DX1Uwx+swpqIF4mL0Ssb8ecNWV9ohL3CmfSRKm81V20GHi63ngO
   gs0OI/rFw+FDuB/wCJ6TtT9tZ5VoQvc7vkI3ZwqmZ4jWN174dy5H+XJOo
   n3XRPH8e4DmaLE00Epz1P+HyyopKgq6SZKlwkPp1hXkuRKcT9fhn68knW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="430307090"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="430307090"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 13:52:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="863459526"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="863459526"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 12 Apr 2023 13:52:37 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 13:52:36 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 13:52:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 13:52:36 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 13:52:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqyKQWu+vbXvqhZ15jWUKWDgBSxKvYDRFJn8H0C4QtUqTifoyGho5t1ekZzuNbhkLBpCy0CHmCuFP9A9Rtnu1qiOiFwYlYkNF5cj8+Xi3DWqqxT8xo7IMQSM6flrjUzgszYdn3WJc4XgynwtpYHPmUhjufTqDr2XF/sMK6IpAcNuxpOMIt7aTOnE+9N/xzRgu/q8vneMJqAfc/d1ujOibUVt5Zoq+0DWawmTR/S/rg4fcc89to91NiBPWrJvWuzkOODbllrfJm8XKz2Arvfy1EqhCSsZddu4bHwZwfGO2GVHOkxvPj8am1pgN+z7tz+bAFM2BrvHDbQOXU5375Bb0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2O1cNI23/Qmc1ibrwJXI8PAT300CagDXuooWZ0M1GY=;
 b=czL7IXE8vMY1BivFi5FJyzZyFEhx9dF2Ws/ZpQ6u/0wOHYelZUFu5S32wG514OaHZWeOJr3b/Ze0E8fDn7ruFTr7zbx6SC0QwYLafFl7kFk18O0BiG7HmnOLZRu8G7H2xgV5HvqBGPGPuZ9671Vfqyx15zM5GUovN99fTakRL+wEzprAI4lphfDUz5/TpPdvb86sO+PzYqwM/6d4MOc52Zq9/wbcyK1QAKbTERpS5K4SxPHUdiQKhE40g6qG0934C78EWr4YXPCjqGv5Ij9JBOFik5XBVhKS2oTJrOZgdWn3xBeyb85Tn2EHuEQlPZxUvrs7nNiaT051vRRzUyU8Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB8203.namprd11.prod.outlook.com (2603:10b6:8:187::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 20:52:35 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 20:52:35 +0000
Message-ID: <afe5d929-2f0b-661c-4768-ce61d24ecc67@intel.com>
Date:   Wed, 12 Apr 2023 13:52:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v3 2/4] net: stmmac: introduce wrapper for struct
 xdp_buff
Content-Language: en-US
To:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        "Alexander Duyck" <alexanderduyck@fb.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
CC:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <xdp-hints@xdp-project.net>
References: <20230412094235.589089-1-yoong.siang.song@intel.com>
 <20230412094235.589089-3-yoong.siang.song@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412094235.589089-3-yoong.siang.song@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0094.namprd03.prod.outlook.com
 (2603:10b6:a03:333::9) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB8203:EE_
X-MS-Office365-Filtering-Correlation-Id: 47f819a7-ba99-4716-e4f4-08db3b97d7aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rw/QNyM+ZEOYgUnlH43dkyLG4Tq8HNl0xUcHU4XGbv8a3cTETtlCboqJ7fMnJ6wpamiXC7q2MQnPi9KLY85TFstBwEfQkc7CUvuiB+uRqxXx46xWlzZuZgr3qhDQJm4BznZNjmvH10cd47Ui5YjcamTtIfHIF1iAQDJ3ToA/JJplrBpp3heS6zskfXa/QHdsnn1sLy7CPywLPAy1IQb4RFQdbo2xw911Fdw4/51XF7/cYn5IGAAZ5rm/QGcK4Maxpctb9wrP30OvTbUkl2xp5CIxxe/p2160oLdGQK7KPxswedjWQb4xAP8z3BcX1U4aQFugkviLyISfuhLjOAKqgMASJ7chhQLwegu+J8KsIFWLy0D8FvBZ4pRObzj8K9qzzdLY+bcTlDBSiOktoUayFn8mQS7jWJEAK0naiE0+XZCEXaX0z+cVtv+mIpOrFi3qGRJfb4YvGmrozkct9xL7Na8f9FHsh7kGAuOJYpj/+N1IaSFVXrsDT56a1PWlvKvT69yZPpBL8x7PN2y1B4AZIUveNcHUorlNzwRsYu7+afRHFK/pB8hSG9sitEj6izPLGWTP8TTTFuVquba+88Ti3Y4Hr0/9ovabuO3YpsDEZlGKLBldL9tu0wLo29iKNjXJC2+kcFShxPSgNKYFqg8BD0HSlbAeGWT+uFocHUDxPqQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(136003)(366004)(346002)(396003)(451199021)(31686004)(478600001)(558084003)(36756003)(31696002)(82960400001)(921005)(38100700002)(86362001)(2616005)(2906002)(316002)(26005)(5660300002)(6512007)(6506007)(110136005)(53546011)(186003)(6636002)(66556008)(6486002)(66476007)(7416002)(41300700001)(8676002)(8936002)(4326008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHZSem9RSHhVQktaOHpHTDJERld2YlNnY0kzb1orZkZWZnY3dzFoQWxVRVpF?=
 =?utf-8?B?WVE0OEJBVE45cFl5ZjVYR2lRV0pibWY3bHRzMlhlWXdIVUJCN2VBN1dxd05h?=
 =?utf-8?B?OVBBeG1BUjRsb3lmdnFqVzlGOGR4S2psM0lXNWJpam5kVXA2RnhTWnN1Rzh5?=
 =?utf-8?B?VDFwa0tncE54eWswMDhDNVJrOTdGMEZpYjNzRTJyWlNSY3YrR2dNMmdHVHNr?=
 =?utf-8?B?NHViQ2pEenlObUpBQno1N2F0QnYvRlpNN3RXZWxuYlc1K2pFL3F4ZmZxWjl1?=
 =?utf-8?B?eCtmcGZSL2s2WXlMd2Vkb0MvRThzMDJsMXlWMldQTngxbWFYZFJWWmFkcXd3?=
 =?utf-8?B?LzQvdDhzb1B1MWFrb1FjSk5FQ2JBSkpwMUxMQ05Tc1E3N21wM1N3NFBrazVV?=
 =?utf-8?B?YkYrNmpFaWxXd081U0QwU2pqc1plN2kvdXRVb0ZVOUNEZ0pkbFR6eUhxRjdU?=
 =?utf-8?B?K0NybUVOK3BOQXU1SS85OUJtMFNwQTE4SHk3TG1qWkh2MnBETGh3Um5kQmw0?=
 =?utf-8?B?K3ZlakRZUElKV2MzdHRlREsrQ1N2anBvaDJvY2xNajhabXA5WmRBT1p6azJi?=
 =?utf-8?B?dFQwYm9TUU1ZWE5QMTJPS25zcHhwMUJPT0xBeUY1V3RnWlR0aXZXaHJkWGpl?=
 =?utf-8?B?TDgrdTh2dEpwZklOUDlrL2liT2dTNjFwTC83WlNEUnI0THhYREd3RG5ZbWhv?=
 =?utf-8?B?RkptMk1PVmZKUEVMMTJVMGpDRmJ0MjhUV2RYVnh3R0xnUHBHelNRay9JK3Yy?=
 =?utf-8?B?YUc2ekxEZm9MYUU1bTlWVktRNEpuajRxaERiQVMxY0JDVkhROG1hK0YzTTdj?=
 =?utf-8?B?Y3AzZUtqYXkvbVRiQWdiV2t4bnVDbE9xeThKZDdVSUhFOUhoTEZJRVJoOFAz?=
 =?utf-8?B?TUs5WVplb3M1VnJqN0dkUVpVNmJaNlZSUDN2ZEkzQTZ0OTV2bG9qS01ZWVBx?=
 =?utf-8?B?VjhLUlNSVjJaUEwzT0NNRmlCR2laRFhubGxIN2dzRjJjRktLOWVtMGRXMG1z?=
 =?utf-8?B?MU5pQmIwbHM2UW5qYmdhcEhNM25ZeUdzSlVLSTcrZDhRLzhmZ1dnOVhXWEUz?=
 =?utf-8?B?bWovRE1PUWtxN3p4cUg2N3ZFWk9YUVBwSnFtT2xUaHdBdlVaaFlmTHk2R2ZU?=
 =?utf-8?B?T2o0TndOYjlacFpJaTlKaE5UbnhzQkNISWdBVTN4SXI2MUJCMnR2aFU2dzNy?=
 =?utf-8?B?T3pxcXNnMkhqTXlTZTRWamtZWnRXcUdTWHpWWEVpekRHaVAyaWlXdXZTN3hO?=
 =?utf-8?B?aTNhSTdiMTRnbjFmZTVGdVF0M2c2V3hyUDN4a3B4SE90Z2ttMldPa2lFS3dZ?=
 =?utf-8?B?SG5waytocldzSVVkYmVjNGlWVVFJelhZYXNwdkgzZzVxblI2MHhubmxkRjFC?=
 =?utf-8?B?a3IvYkt6Ym96Q09yUXpZY1dHK1NjdUdYZTNaN1VIVDcrN2t0YS9TR0M4Yloy?=
 =?utf-8?B?dDZjYVJiZ1FOMEJFVnRURFRUQzhyYVNRZGRNQzJvV0NqZ2paSVArWmlaMy9B?=
 =?utf-8?B?YUduNjhWMy9vT3hBazk2cEpaOXdsWFhJRFhReHVHU2NzTnJ0QlppSWpyY0M1?=
 =?utf-8?B?ZmZ6RVkrbFU2VWliT1FScGt6M2JvV2JtTUpYMmZ6OC9oeVNPdzc0MWJWV2VG?=
 =?utf-8?B?OTh6aXRJU2ZqYzU4UHZBWjFjVXFBZ1Z6ZENTZFlqUE11M2lnbEVaRnZDanlx?=
 =?utf-8?B?RGswUVhRdXZmSzdHNGZCQldESXowNEliUjZXdENJVXl0R1ZxYU9lYkdvTzg3?=
 =?utf-8?B?a012OE5TTmpXcm9CYjg5YUJKRzh6UDdJREJaYjVHdGh4N1N5ZDJ0aUFJaU5S?=
 =?utf-8?B?YVNtZnFBZ281NXFUMlBPMDk4MmllZnd1RUYydWlHOTdyMmdDd3VSSWk5anpP?=
 =?utf-8?B?a0k5QUk5OUlCdndwVThjaDg0OXVtQjRXeGtkb3g4d0pLQmYvZ1FMVkdxMVNS?=
 =?utf-8?B?VGI0WjR2S1BQOHJSRUJIbk51S1R0S3JUUlVGN1BDVGJjR3ArOWFwb0piWWF6?=
 =?utf-8?B?RzZubndUQ1NuV3FXY3VEc2thb05BWDVOenZsMUV0Sno2VS9EVWV0eTV3djI4?=
 =?utf-8?B?aW1IM3BQRUZOQU5WWncwTTQzWmZJSUE4WTByNVRaWXUrY3FOUHlXcGxHbjRI?=
 =?utf-8?B?aDlTaGk5WWE0MkVDQVVYL0hlTG5ETE83eWZueng5Z1ZCTEtCNlpWdndtMzdo?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f819a7-ba99-4716-e4f4-08db3b97d7aa
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 20:52:34.9612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjLoTIAM8od2Qia/+0hEo78e8yojFPNhbOAAO7b2UDkiB4LxQlC1JA9Kco5flGFQtUm94zcWx7+ec/HQNoQF1keuqPMFhwkbjCWCHRY7Bxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8203
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 2:42 AM, Song Yoong Siang wrote:
> Introduce struct stmmac_xdp_buff as a preparation to support XDP Rx
> metadata via kfuncs.
> 
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
