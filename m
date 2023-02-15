Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3FA698176
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjBOQ7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjBOQ7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:59:20 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF8A17149;
        Wed, 15 Feb 2023 08:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676480359; x=1708016359;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uZR6R+Cc+OE/5JaFqN8ObZaEzwzuFdJoq1nk3HB6XZQ=;
  b=Jn9KI3M7C2qObGTgn2m7rsmCMQ1icojAYmYzEHFIo3NOcTE/wh5vuj9F
   WIL2DIUrNCQaWULhDqeYGNkbKCPGNoWIqD+MF2hew38TcietrHsoUN7fB
   42R5aGHCWx4OWgXSP7/5MKniNhtDGfllCq7zgI6ydjvXoUetbxAxl7TPl
   nEOwkTKXUMRsOQM718GhnVcTNpE2ftb7e2969plYjW0VdIIkWuVXTz8O2
   YFVyjbG+q5ItSUqymYXWSrK1f0wbbyiBL2LixTSc/BeIDbxE9YG+dvX9v
   oRPG/jnEShTU4IgFs6O2pccZpagAm6wtBVYOGFhA+zwHY1MalECrjxjHF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="396102857"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="396102857"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 08:59:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="700055350"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="700055350"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 15 Feb 2023 08:59:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 08:59:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 08:59:04 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 08:59:04 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 08:59:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1xa8t+JkI7NX7RYMpOH9/ZLR0O4WRMHbjOFtaDwL4/ETN7nTF713bnT7UupWcJ5V5U23jRv4AY6re/e2gQxM0RyADTgpYECXiZwi4C83Bi48BQ3hlmp8nejh4GSUEPTcZzpTGa6M94lyKMCzBbmz+ynUdKj1THvMoUOH3aQPWu7+KFI0wvs3h5lsJe2kDdIRCq4YCS67hFmaeQNr5ZtnWiRSg10Zs69hZLUblqS352ITbWhNSBNv3wtWmKQ2Mnm96Gnkuahh6GxXiY5umm/LdYzQlug+j3X7JEG5YYawOUpy2JAtFFRSsm96co6VWREJ0A3nr7v9AjqF02lyti2ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATIRL8OFnWZdMEITz5fI4DFbdf0cYrl1hc4WEjmPQRU=;
 b=E+xt1jJlFI1taeh8Kq4+FKpOk8KQQCR7zD2LuynXRWDcFw7IcklF/twVFtkGbzHNcpa9mwhpikLnQj4AhUuIp7ka3BT25AEPBwGqkx1fSzCqZ5akTJEqTmYytlAJoCe16KvihXKrpTi3P9hWGKqOVg+w9G8g+etADwBAidSZTrOwaqn2VqLYhqMGFd6Ddh+z+P6TacLbd1NH5LZXSc/kje3iL3g6EF7hQZYNtaQJuxVQreRv4NPg78HHm9Lb04l8QjvjyrvQTusGhCKpa4MAPmzU+CTCCIEEgVI1MU82ur1wCELMWqpxzq+SGmyI04Tgrrr1VTrEfpiMEG9do+Tgiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DS0PR11MB7213.namprd11.prod.outlook.com (2603:10b6:8:132::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Wed, 15 Feb
 2023 16:59:01 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 16:59:01 +0000
Message-ID: <a946d81f-4c15-32af-9465-479bd1be9650@intel.com>
Date:   Wed, 15 Feb 2023 17:57:24 +0100
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
 <231a227d-dda6-fe15-e39a-68aee72a1d59@nvidia.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <231a227d-dda6-fe15-e39a-68aee72a1d59@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0088.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::8) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DS0PR11MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c7e9565-8e82-4f32-f362-08db0f75efe6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iQfta0Uj+MsqtWWyqJZPsRFaPu9DLM9dIrfgtBcmuPIGwHA1vh83A9m8yzeQJexmAL8V0F7iy1Fk7C2kGKeqLI86X96IKXOalu4SpgNk/wPtFgDxDQQ2umR4jsqKfmdCkewXcTDUYIvAUF3TvNe8BAXk/sjrSeDtSrgt1R16/OkDvAe+Wbi2xAC/Ta5gnsm/6zxcPXH3eDAtHOGXzKKr4zrx8PGokkMrPZj/gw8bbvw0xOEp0ndE7+4/+JFjo1ulWLHhzBJkBQcPhX+/DHvjGkLYQXtGQZ5495B6Dlf+z4ZEBhejDwbXVS/XBdJBn0YO11dm+/vk8U4Vz77Fmn3jqTnD/hv61BM452q+UUeZHQtupdn02LjDsSqgKblxZuro5FshqFxzo4iAcR/r92f4V+Clk40nBVgtrnDCSfDIJDAKJ4uCYqCHzp+1GPJNzBi7NS00gOH2s0RbgnNjgd1tqdOUhaA12pL+KlAdW/kJGUwv36ea/ncSwNA4iiUL/qQO7NmiHRkMpZvWmCw7Oa5d8Bf+7NsqCRJWKjaZ2SkHz8XUOjOkH7oO9xX65cGIURSd3SilGRJ4vPdz8deQuVtFn17RWLY6BLDO8Sn64V31/f2SZdr8tsBaIh4Q0N/RApEALUwQuxG4xYAoGEV3PIvj7Zr0v+XnXATZhH0As8SLAXwvBtg4nmjTFk/a6yWGzQxxMoIzaFjA2UakPBM3CfjA4FM3gP5Q+F1Pey/JqkRpAnI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199018)(82960400001)(38100700002)(86362001)(31696002)(36756003)(6916009)(4326008)(66476007)(66946007)(66556008)(8676002)(41300700001)(54906003)(316002)(5660300002)(7416002)(8936002)(2906002)(2616005)(478600001)(6486002)(53546011)(26005)(186003)(6512007)(6506007)(6666004)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODlUMDAvaUc2TDlDZndFNnA4VWppSU1sV2Z6UmJmTHBFejRxWWNDb1F0cDFy?=
 =?utf-8?B?Y1hyZjQvQzY0NGsrMWZ5SjVsK3hTVXJEb3pOLzF1R1ZpdTBYeVk2b0VXcmVq?=
 =?utf-8?B?OVNab3UxMUN4dGtzVzRWOWo5TnVXb1VIN3FWbk5RdW1SL2FwYVdqbjFMejFs?=
 =?utf-8?B?RTMrV1VURHY1dlFPMGhDbHhQMzROMnNhL1h3S01CN1NBQkU4anFITEkvU09S?=
 =?utf-8?B?SVd3Uzh4RU1DTXNCZjJhRTF1d2pkdGgwMGdRTnBpR1dTTnU2Tm1mM1RSQXlE?=
 =?utf-8?B?c1dzdythUitUdlg4QlQvM0NySitGMExpT0hxV01McUh0cXg0U3d3ZmRmR0hL?=
 =?utf-8?B?Tk5RYkhkbjZ1N0lxWHh4cklCcGJVYjNiQzJvQUVzcmNsS1JxaGxyNzE1RlVy?=
 =?utf-8?B?RmVUcGUyNGhQQityNUVyM3ZBem8wSGJseXpkS0EzWjBXanNDdHlVQ1d0UTNO?=
 =?utf-8?B?SjVhTUZ1b3R5N1hqWVhKMXNEOWVaaW1TcGNBRzJHdDc0Z1ZCRVU0Kzg2cjRu?=
 =?utf-8?B?RkJpQW1SQkNCeDkxcWIwK0RHZk50TzNpVXdBeWpmaTdFd1VVZDVjZGsxZ3pm?=
 =?utf-8?B?ZGM2NCtSbGNWN3BZRkx4VFh0RlUyU0NpQWJnMHFtQm5YeGE1YjI4cHprL1dh?=
 =?utf-8?B?ejYwbU1ZZnJieldvbjl6TUdxMEMxOVVORENabFkyMXBsVE0yb09EZkxlaklT?=
 =?utf-8?B?dXNGekxLYUNaL0tldWhqMm54bUFzbmJuL1U4VHpkc3hKWjlwS1RMYkpPTkcz?=
 =?utf-8?B?MUVKTmVGLzhOQ3Nva1JiR1V0dHpORm8waGJyVFJWWWhsUWlKOEY4ck5jOU5D?=
 =?utf-8?B?c0EzWTdrcndrMVVZLzczRGtKVTVWbGdBTWtnQWJSWEtISnBQeFQ5NjlLdk1m?=
 =?utf-8?B?SFFaNXdRTTEwYVVnZkFORFJOUk0zemRQR3YxRFhzZXA3R0RzaTlzNGlEZjVu?=
 =?utf-8?B?U01JanYybG5XRC94Q3dEZGR3WDVMRW5OV1hJSFNaMkhoSm1MWnVYcmNOYWR6?=
 =?utf-8?B?Vm1lNGs4Y05WQ1lndWg3cXZ6aDJ1NmxlcWoweFY1bnJtdlovTlJtdTJjN2pG?=
 =?utf-8?B?U0ZId3JOa240dk96Z2daSGNzNFBtckg2bitzMU5xTzZLYWw0MWQ0V1pYQVRw?=
 =?utf-8?B?aVBPQ3hNZG0xYUEvTHJtWWkwZm9xb1BMbm1OOFBnWlZSaEZ0ZUF5WnFROHVD?=
 =?utf-8?B?a3Y0MDF4eG1uYmJrVjEvT1VGSVdqVjZ0ZnFLYW1wdkhGbURzeW5qeWlZT3hO?=
 =?utf-8?B?cHVoTmtScDdYeTMyOGlBbStXRGtBN21OQ2twakFQeHQ2WG9GYllSZFhTWE9i?=
 =?utf-8?B?cHhHZjZyRmlUcjRaSjVqSmdzWDRRYW40enJuZFBHQkY4NTJsSTRwY01KdGtl?=
 =?utf-8?B?QWd6MHF0OGI3bG5VaWZHTXBXN1ZaRXlYVDRpRmhveVhpOUJvaEtGNXErTHBq?=
 =?utf-8?B?RkVka2ZFZllRVStPYkNRQStqRHl6c1VENFJVTUdWL21SbVdPN1J5WTlta3ZD?=
 =?utf-8?B?SzMxelFjUmtxMjJkT2JjUnhBUG5CL3hhME8xdFFKK1U2K1BxT3JZT2VFemJy?=
 =?utf-8?B?WlFqTXczSFNKdWxhVjQxK0RvUkh3cVNONDUraVpUdkRudnlsNVh1MDhBZ0t5?=
 =?utf-8?B?dEkwbkdaV0V6YVhvWVR0TGZJN2hvR0ZkZjhRVC9zak12ZlhiMGt6ZEloZldM?=
 =?utf-8?B?dUZWUGk3Q1RKOEdZdHN5MHBzM2NQc3owZU5CS3VRMHNpcUVXQks3TEkvc1lQ?=
 =?utf-8?B?bmhGQi8yTkY4cGxJQjhmaUU0YVo3V0x6bzlCeFAyMWpTakNjdC9qR0d1SE0x?=
 =?utf-8?B?aXR2YWZRZ3hHZXFCNzhKWXZ6ZFp5VGZrTXNyZDRIbFBMRGFZcHdzdXVLelFo?=
 =?utf-8?B?eWxyZmNpc1NVaVczRUlvRnRIeVVGUVA2MjhKeWd2UUNVMSsxd2RkdjdwRjI1?=
 =?utf-8?B?Uk1NTDgrVUxuaGhWYzlFVWRHYTB3cWVuL2ZOR05TczVscjZLc0lyWE9Ib0FL?=
 =?utf-8?B?Q1lNUTBoMWhyTzdqcWw4OXZ2UndMNHVKNENhWkMyT2srb2ZKS2ZvSkx1Lzha?=
 =?utf-8?B?WGhMalovWStHbkJkQVBlck12UWtWUTdsUitrUmliTjhvWDE0YXJ5Y3kvcDlD?=
 =?utf-8?B?SnJIN0lualo1UEoxWDQ4Z2tJNUsxYmp6NmdOYW1kZUVRU1Y4NEV1YmpSeTdN?=
 =?utf-8?Q?OsK7hEC1TRd7Ie832U7ICqg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c7e9565-8e82-4f32-f362-08db0f75efe6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 16:59:01.6506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a3aY57+YkxpYhhsNK57zNfeyXrMK+x8ICfLtQMjch+i+FY+NsTJXTJcIHT+Vpz2Of6i95GXcyzB/WRhVtZ95mrcKZ07VVnfWaqdywdb7wPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7213
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
Date: Wed, 15 Feb 2023 11:36:24 +0800

> 
> On 2/14/2023 11:26 PM, Alexander Lobakin wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> From: Gavin Li <gavinl@nvidia.com>
>> Date: Tue, 14 Feb 2023 15:41:37 +0200

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
> ACK. Sorry for the confusion---I misunderstood the comment.

Ah, no worries :D Sorry that I sent the prev mail and only then opened
this one.

>>
>>> +     }
>>> +
>>> +     return 0;
>>> +}
Thanks,
Olek
