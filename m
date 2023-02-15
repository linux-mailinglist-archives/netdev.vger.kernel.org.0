Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F04698168
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjBOQzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjBOQza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:55:30 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB7C39CEB;
        Wed, 15 Feb 2023 08:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676480123; x=1708016123;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l2Llv8vk+sry2LNHZ0atWfurvLiUms2P7R8w0uMwd48=;
  b=aNkmf1wbjl993GMLjrlxmVw++59zzDH5/5MDFqEt8xXfhLBYVYiSeDdM
   Xj+RD51XgCZMnAMqaQkRgkW6VwO9WG+l64BK8KM+CjSA+5gYE3hMcF0GY
   D10j3yTf64Uu1dYRGE/nbTKEFtyqqT0l5R1AUiq5f9QRubgO+/i8uI2TI
   xvc5llGC4VfYv3jiJsAJof8CcllcbkBStnx4YgF75v2DQ4gb0EOBxiz8W
   BdFJ8oZlWpthQgCDYzuKvzA0NVuN2/dQBZ825Ox62OJmXJDRtFEofnrGS
   CV4kyqVJkwEbs61el5HI6Zu8iI2Ls2KfDDg7WzetVZpbWscb0iZKXEdkP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="329199007"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="329199007"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 08:55:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="619526846"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="619526846"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 15 Feb 2023 08:55:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 08:55:12 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 08:55:12 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 08:55:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5FZ8HdFcpllTeMrjZkvmsfIDa6QNS8tv5/GZgsR+f8PvXNLiDsoYGu+EYzNZXC0r0lwLPntg863phLNFQQyjZhj7GxbkIzPoo2jTjDfVCHhvsnRBEleM5lmjeF7xAUvddMNKTDVEKErEb8HvqQTMgm80cYneMorwSmDMwqXUBx1cTdFAm5Qz23BJLXgEcNqmgHETDX5RZMhko5sknP/XSoZhfUc4dIzQEDTjkQozJsi7bq+JCQ5UaFTKwikw8ulTJumOr5w22mDM23P69oF+pomzcY3tqVaGyNnUlJTHsnPuDxysraNoNfLc+/vUhRLc5ucVRvwVfX8s4cPivRxFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EgkkjQPat77ij5TtR2jTGBbWQmaFWZsq+Og2eY2I8iE=;
 b=e+BnGgkeC+LR+btFMrlL4cRWurZ2h/kbR+bg7SsJ9PCVTcQ0nLruymk7liV4vI78yVAvjlB/McDmP6FpIL5bGCYnLkd3pZzJKx3cvzTZGsEhu6xyeG/LYJcmnIyZuMzZl1a3vbzB8FRg5K8EcWHwl1PtD1xMYhGkAZSZ1Arwt9xIMaKbvYMWBljt65Lm2WiMeWzRJSAd5/2+HqlE0OjJsC8dJtsbOq53muLXAYebRVhQIyWHnq47JcR2RnXGe+NVxi6QN/f9Mg/rvsC95PXzzuY7I8T/ero/LPGg2M+n8hoUIOvPg6ZukNUvwY+iNPjSUmTiExfBZdrZoiDkapzdcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB6443.namprd11.prod.outlook.com (2603:10b6:208:3a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 16:55:08 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 16:55:08 +0000
Message-ID: <9a8793de-df20-6248-2817-a7ba706aa0f3@intel.com>
Date:   Wed, 15 Feb 2023 17:53:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 3/3] net/mlx5e: TC, Add support for VxLAN GBP
 encap/decap flows offload
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-4-gavinl@nvidia.com>
 <711630a2-b810-f8b0-2dcf-1eb7056ecf1d@intel.com>
 <7537ee48-c92a-a7df-b876-9a14ce2d34c6@nvidia.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <7537ee48-c92a-a7df-b876-9a14ce2d34c6@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0047.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB6443:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f37c1b6-6528-41f1-c338-08db0f7564ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kQUoQM2k3evu06Q91cmcqK6Oe4OQRvD5QqCucKQjvj0g9Lw1BrRmQCeVjMe03ebc2Nz1qo8CcVYJ44+XOO06zzeXhghUD5DfnqlRG6+963X2AnyTX1GDdPrbiPXvCjswZm3QPomiZsWqZfiIGQqo32l9SW4mNr3/QnguBblpRGj08WtG6dx2duq12w43aylwMfrkr0JLiC9zfK/D49sc4aFZnzRoOEmy/i0MO0iCMyBKnCy3Mz0+yepks9ATKA2PACGSV0O5nK94q8tMFVVFYIPoyX3mki+02HuHG0BXFxLy2OBE2nvpGpjDEmN0Quq1am3icuAKpW4JiEiHiVeyyj73RUnjbBM2et8VjvPQPBYVLLsYjh+aRmVn5f6wkJVSMuWoBznHcMHWdZyH3MsWETuD3FlqKIBVS5jB/SXePrREKlaLsYcVTaklA4FfNoyuPSg4uhIAkGch1dA3XpbQInXLYAz9BKMsUqjMja+txdnCy3NHU/jjYeKqazqxoCd+P6d2pqc4OXgfAywtOJlBo7hv8y0V1EccswXd+a4I/ZA0rlEjw2WOfzRiXvkOhfZJnP6V9S265gLCdmOnfEncYnj9k/no8tyz5qLzWZVHSX+BiD9Byh4fnH/Xao6+6no2GRy5jnAJdea2AZLS+TmYwTQzYTGshzEbFRPwAlH9UTI1+yNJOEwntKZPADla5KVuwQyVzqDLlmgQQgvW/2h6+4tV7TpBOmX/U/g58vx2wbs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(2906002)(86362001)(31696002)(36756003)(6916009)(2616005)(54906003)(478600001)(6486002)(6512007)(53546011)(6506007)(8936002)(26005)(6666004)(316002)(4326008)(82960400001)(7416002)(186003)(41300700001)(5660300002)(66476007)(66556008)(38100700002)(8676002)(66946007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmNKTWZCTWo4YjRLT1kwZklWSVFuYllCRzRKUzJwb2FOYlNFL2Q0MkhhZTBq?=
 =?utf-8?B?ZnZCM0R3NEZFTGJqZExZOWdHNENwdGovcDlGVGFIdWk0Vk43YSs3bUpTbXRX?=
 =?utf-8?B?VGNrL2x2QlJ3TC9ITStDcE9qZHRIc24vYWZEMHlSVnJkOERsQWk0UFd3VFNk?=
 =?utf-8?B?TkVSZmhXejVnRU5lZnN6YU1GWE11V0Zhd3RxUEhlTE55NXc2VkFzZ3FLaGxY?=
 =?utf-8?B?Rk42TmFlQ2ZSazdDd0J0OXRsVFJrWkhVQ1JFMWpCUlZCNlI2OWNuK0RVU211?=
 =?utf-8?B?dVJZcFp0Q0gvL3BGZXRkWGYxVTFRZXhYeGpnSXZVU0FBakMzL0xReVdkS1dR?=
 =?utf-8?B?eTl0akhudHhab0NVQzBScUMxZkZNbTdUcEIwdlJOeCswRGt6MEV5SnJFRzlV?=
 =?utf-8?B?RUpwblZtU0N5N09MZzFmdG9SaTZMcHZub0JaSGZob2VwQjYxU1d5QjF0S2I0?=
 =?utf-8?B?a0prOWJ2L01UaUd0R05ZRDU3ckc0d3cxNUg4U0F1a2M0aXRyZkZ3RUZVUTNJ?=
 =?utf-8?B?a3VVaC9NVEFqWnVTSXpPVWZnQ011VVJMVVVocEtDMGtzMWJ6OGdnWDRhYVhs?=
 =?utf-8?B?SWZoVEpUa3pvbDVTMXNiRjJpVHRtVW1kNytiN0xOVHd6aStNekJsNHlCeDlF?=
 =?utf-8?B?TVBsZ1RNZDhLYWJQSUQ0TS9lYXRuenlvNDlkY3JzTWdmK1NjVHlBN0JDc3VX?=
 =?utf-8?B?RXVLaEVzb3N3bzBKNlgyYUwvSUVkM25heDdiTVRwOWNzT3ArcWRXWklCWWpt?=
 =?utf-8?B?QWxMeG1YbUVpNk9SY0tLTmFUb25hNlRWUVk4c3oyclJLQTNLSEwzVkNWcDc3?=
 =?utf-8?B?aXpIVHc5VTl5TmdXZE1ia0FkZWxHbUFwK1l2R2xoUTdEbFBmWGNsbGIwOXVZ?=
 =?utf-8?B?STJxRnpBc2RkWkZBYUs5Rkptd0g4WVR0dGx3K3RFOWRkY0hlMmx3em1rM0E1?=
 =?utf-8?B?eTlyQ3FPTmI3YWtNN1pzTlFmRGNUWWRYaGdvYWNnUWFNcGRUNzJUKzJPaUh5?=
 =?utf-8?B?QlN6VHh4b3NDb2NuYm1CenRWWXB5YTkzR010LzJVZmJvdVN5eHBaSG1qSXp6?=
 =?utf-8?B?VktVb25ZU3FDN3VtOVF1eThmaGlMK2pRblZRSEVRbEpnUVRvQU1GeHd2R25G?=
 =?utf-8?B?ZU1pd05wZGg4NDB4c2E0UGFNeVFXbjBVYno1Z251QlVxS2owSGdpWTd3Q3Rr?=
 =?utf-8?B?cHRCd1pZTjVVZjRBVC9NV0RPdjgwa0pQVDJPa2pFcFlqNVNPTTJGRGRMbERO?=
 =?utf-8?B?bWpPMUlYN3E1NWRXVnMvY1BkNldZQnBvVzAxZTVxOC9hSDJyQU00WnlEOXZJ?=
 =?utf-8?B?QURlTzZ1TWhIeitxOURtSkpxN3dMV244eDNqQTlUNlB0ckNHNHRsbVI5MDVL?=
 =?utf-8?B?Z0lZMmNONjhhUlNoT2k0UkNwNVNIN2doamV2VllrQ1FINys5S3N6YmxMZGpy?=
 =?utf-8?B?U2Fmd2cyUjFDMFNYYUtCL3Y2SHBOSUczbGh2dzJaWUFkQW4raHBJbTVDUEZ6?=
 =?utf-8?B?bjNCSnk1eWovbmdYREZJWWd3YnE1cmZiNHR3dmZNTmVnS1VRNUQzWFNlNUIw?=
 =?utf-8?B?VXRrbUtLaDh2OXRxS1J2YmlrdUFMOXlNdTM2RUVscXd4alNxdG83S21PeXVE?=
 =?utf-8?B?VGZ6STltUzd0OWJEbVZBekM4VW54V09DTHNZbEV1Z29CYnBOM0h4TDhZaFRM?=
 =?utf-8?B?ODFaMEZ6T0ZEaVFUL0FRQ0h2NXdCTFVPTTJpczR3dVZhZ1RZQmZFMTZFcVAr?=
 =?utf-8?B?WEo3Z3NqcDNUbUJUa1hJK3g4ZWl2MU42Q05LdGUwNjdYd3FQTmlCelZodEd3?=
 =?utf-8?B?eUJmQzBOc0tIU2tMdERHbDZxdG82VU1ZVUdHMUMvTWxDSENNbmhPUWZZTzN1?=
 =?utf-8?B?OHBqWlU3UERCNHhTbG9QdDV5WGs0VzdzeU1IZG1SSHMyNTFXamc2QUFYNUlD?=
 =?utf-8?B?dTdRaXkzWjhFTWQrUlVreEdRaS9icGVhL2dzUWlIdldGNHdNUWhlOEJwQU5T?=
 =?utf-8?B?eXdDYWFzZnRGQThBSHZ4OW9lRDRQVTRuU3d2YStyenF2WDdYN1NCTnRTRGFt?=
 =?utf-8?B?MEUzNEtaQ09SWDlTc3g0VlBscDVibVRlbTh5STdscUxPcHRrcHZnanpDNnBz?=
 =?utf-8?B?OFBxNVFBMjIzWGx6dy9mVUZ5bG52YUVsL1h4cStPbDlyVmRrMDhXWEk1Zk02?=
 =?utf-8?Q?AoHIBAH0zwj5G9BUbtquj9k=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f37c1b6-6528-41f1-c338-08db0f7564ca
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 16:55:08.2000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMuH0eJ5Xwz/G2pZuXOZAgZh4zG1rRTAULScsgEtyeoDPdd4ypamKBbN8LsrremuldpRnZDKFWAGWIBp0jmh/9c0zPaNurOdjrZ9dR1n9/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6443
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavin Li <gavinl@nvidia.com>
Date: Wed, 15 Feb 2023 10:50:04 +0800

> 
> On 2/14/2023 11:26 PM, Alexander Lobakin wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> From: Gavin Li <gavinl@nvidia.com>
>> Date: Tue, 14 Feb 2023 15:41:37 +0200
>>
>>> Add HW offloading support for TC flows with VxLAN GBP encap/decap.

[...]

>>> @@ -96,6 +99,70 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char
>>> buf[],
>>>        udp->dest = tun_key->tp_dst;
>>>        vxh->vx_flags = VXLAN_HF_VNI;
>>>        vxh->vx_vni = vxlan_vni_field(tun_id);
>>> +     if (tun_key->tun_flags & TUNNEL_VXLAN_OPT) {
>>> +             md = ip_tunnel_info_opts((struct ip_tunnel_info
>>> *)e->tun_info);
>>> +             vxlan_build_gbp_hdr(vxh, tun_key->tun_flags,
>>> +                                 (struct vxlan_metadata *)md);
>> Maybe constify both ip_tunnel_info_opts() and vxlan_build_gbp_hdr()
>> arguments instead of working around by casting away?
> The reason to cast it is a WA to use ip_tunnel_info_opts which takes
> non-const arg while>
> e->tun_info here is a const one.

That's what I'm asking - why not make ip_tunnel_info_opts() and
vxlan_build_gbp_hdr() take const tun_info?

> 
>>
>>> +     }
>>> +
>>> +     return 0;
>>> +}
[...]

Thanks,
Olek
