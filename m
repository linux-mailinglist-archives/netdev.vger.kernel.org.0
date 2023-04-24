Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4906ED159
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 17:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbjDXPaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 11:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjDXPaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 11:30:10 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751277EE9;
        Mon, 24 Apr 2023 08:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682350200; x=1713886200;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s+fj0OyjoyR1f4VUqsx/Cjgpa0MazClP37ogJrVQNEM=;
  b=k8ezAKMKbua/T5vkQMe3WZ2cFleQcR6nhyNIvpDoR2Dlw8FVJNrO5haW
   2ScOySA/kFjVo329Z8ND1/cFc9nLJZH66LBQmevW6gekr/16wvI7L2me9
   03Xpyi87+ovSZDHa10LaR52aYxcg5mEsAO2DVd64Vo8Nsq2I9+pPxFh8a
   327TrTJzuLmqqbXVOSmi/0D7ZOQLullpp10A8hiCRpFc9f+cYOmtSSPEa
   DjTj1z9zGWKc3LvI7AZbjsVDN+YtNf/F538Qjdc5dg/IEEPRvpGq3d0O6
   zdfdewHXdXB0nHtTjdjgHkC7f7uknQlO9ryyl5bbd3+c5qavJmRSAjHTy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="349282161"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="349282161"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 08:29:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="643406980"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="643406980"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 24 Apr 2023 08:29:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 08:29:54 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 08:29:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 24 Apr 2023 08:29:53 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 24 Apr 2023 08:29:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gkb7t/Rxzp48OuajR50kpqVJ3Tu6oO3IV3bbLutwYWUXo6HaLSZI+u6hiiXXFnkfb6ac22EaMAREFBCRB0VLFN0lHjkkhY3SrSphQCRebV6PC1g+N9wW3Y2iS0T6Rfcv9o5OaQop/lrXfRF2WpL5hBAdR9BSpGlHorX7FVKWAm6+htAt+mNgYnjAJ+Im3+CWdbIKbLJYpvPB4YFqIQhh3xPKQOIlUEXoRLR2xpS13GmN4WLibeUeCAc3yE5Qcu0AIK1zPOOirqAUgUZjr+oIpymljFi3kLKpjkCnh58ztQyF+rxGg0Nnodp/LLweJ99eB8eVun+7q3OtwyyrxSHXRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2VRYaVQ/QmJyFUOiQaZo0rzvB9H3iUhw0sRKLDk3t/c=;
 b=J7gDXszDaYbIr53ltBVq5QMaY3RP9XzrPUhG8E/bskSDKNPISJP84O3VIuN2FoTq8pD5mwTobyI2BhN9x8UqCVWcMK0DKfaUkyQhgVsNsEalyq0rQM4w5vmLp4BSx6AIxwtxzxr/EmeemBoWEHxlgtMSU2SDD5aheFKtTM6zUbl7mRlJnPg1uU2YmOzAWWyWCoHm5rpOETf7RZoYP9UpgNuZEZ/5cnqKGEvhFE2L2xEuDitTPR1r0M2rh3yxFYa+w6Igt14N/QuXato/gzEKRVlJzCcm1PndJ6zi5Lm3BNTl6yq0bMB20ipZYL//3p3FqurLPwbtMTQkANbu8dTlaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DS7PR11MB6127.namprd11.prod.outlook.com (2603:10b6:8:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 15:29:51 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.032; Mon, 24 Apr 2023
 15:29:51 +0000
Message-ID: <5ec6f5e4-7b6a-17b3-492c-44364644f155@intel.com>
Date:   Mon, 24 Apr 2023 17:28:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
 <ZDzKAD2SNe1q/XA6@infradead.org>
 <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
 <20230417115610.7763a87c@kernel.org> <20230417115753.7fb64b68@kernel.org>
 <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
 <20230417181950.5db68526@kernel.org>
 <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org> <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org> <ZD95RY9PjVRi7qz3@infradead.org>
 <20230419094506.2658b73f@kernel.org> <ZEDZaitjcX+egzvf@infradead.org>
 <20230420071349.5e441027@kernel.org>
 <1682062264.418752-2-xuanzhuo@linux.alibaba.com>
 <20230421065059.1bc78133@kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230421065059.1bc78133@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0077.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DS7PR11MB6127:EE_
X-MS-Office365-Filtering-Correlation-Id: df6604c8-7f5b-4c37-d678-08db44d8be94
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3bdHyJcFyGT47E2eZnYXXpJdetWygSmPdIBwGy5ye8fSfdw+fsJFppW1R5M/W6YAW1acAnR47fTN7ArR7kbAPRTYn2WXN0AINovrNilASqV2V55fovUVXDwX9W2Di0pHpfB7HAhywnL+LPzGRnto7/U1CMW+KOvsTVcDkzK/7blACksnROBYSr53if1uFOEsBpAtHdYPWdFJgwoJzpywrjyb92zrn9u8Kr9x+xyEWXPJ4Wzzv9HwXFgu3JxU7etoXN2UVZn4slGtV6Z2wpntI9EoIAVBHrviUJo82//Mv4GHYTd2jdX8Hnmw0vqleAzX9H3g2CvXYqFOfz6aticfq9/Ug7KsCqktf7BrbJ3zsa6SCkgxiGBmgqz6Yu4He7wPdjgm0UGtUDPbQR7HPTqHjsid76cFkel9WUhsS+cvjAhGAOabr4hFcY3hCuDOKDLYGOJGL466VsABkA84gV2evGp+8Sepr4srh9rVwmfoH63S2hYSM6A2BCHUa64/r60bHLjd+NL6PiT1sIk2GF+9/htgFDG27x8Sg5dLyRL2xmJGV4tPDDb72v9nrZyVOQxdBSyOw6ovMpZ5H9l7Eb54TAhaR1obzXe+U9LTfNWVniFo80rLSmSJPB0d3Y4K6846uJnpXeszu4qXwRxUFY0imQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199021)(2906002)(66476007)(66556008)(66946007)(6916009)(316002)(4326008)(7416002)(8676002)(8936002)(5660300002)(41300700001)(36756003)(31696002)(86362001)(6512007)(26005)(186003)(38100700002)(478600001)(6486002)(6666004)(83380400001)(31686004)(2616005)(6506007)(82960400001)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGgydmFoSTVCWk5mTGRtQzNnbGkwNUhNQXdHb1hCQ3pPOXd6dURUWHNCekNj?=
 =?utf-8?B?dU9CeWpVR3psaGRKSWQ5elRGRHBjaXJsdTlMVm1JTGlUdmNwN0JWVXZHUExQ?=
 =?utf-8?B?RFphbmlLT1ZUS2pQN0hSTG81UmMwaWlZV3l2MFF6aWVmZlhOZWRxVzZpYkMy?=
 =?utf-8?B?SFY4VFdocG9FZGswcjNnc3BsVnZnaTYydmN5dUR0cDN4dTBZTkxKZXVhdDQz?=
 =?utf-8?B?SDZabHk1VnoyaXljcWp0bFp3b3l3VDY4bFN6QlpVczhOSHdSWkN4cXBac2hL?=
 =?utf-8?B?VzR4eUNpZHFtSXBFamQ2Z2R6MXduL0VzODRQcFVHZ2RVM2ZXOXdkOGg5SjVS?=
 =?utf-8?B?d1hDZzk2MWNLeUxLVGFjY0o0aGhXK3gzOGZTWjlrSEUvMy9UV01jZG80QlhH?=
 =?utf-8?B?V3BUSmtHdk9yb2ZORjV5MXdVd2FVb2svZGVPMnlLUW9vVUNPWjE0NHYxWFFp?=
 =?utf-8?B?WlgwQ1ZSRXJDcDFCdndqVWFTVEdLMm81dlozWFJqNUNDdXFDcUx1WGRZT01F?=
 =?utf-8?B?dkl5bVBoVHROU1l5aS9GeXlxNmdHdmVOMHExWW5SK3BFOUUrMmoxMUxlNmRi?=
 =?utf-8?B?NThybG9VOVZ2S0w0TmxvSkQydE96ZGY4Q0JTZy92OFZCMjEydVNmVDlEbDdB?=
 =?utf-8?B?R0UzakcvOWpqME9YU2I2RjJIRUFLaGJGQlRQUUZzbk1OTXRob1N5UWVpUVhM?=
 =?utf-8?B?MzZxL3d2N1ZOck0zQjQxbXA4WmhjTEY1Wmt0MkhiT3p5SzZzZXkxVkgxYmlp?=
 =?utf-8?B?R1FBMHAwUEQwQUtyaU9LZkc5c0pQbGxqZU42ZnUrbmpDdU5qNzNxWWl2SUp0?=
 =?utf-8?B?ZC9XRlV6RHR0SzNhU2NTM1RPVVd4WityUWZzL3JESEV1Y1RPMmNTNjR5Y3ha?=
 =?utf-8?B?ZWdjNDV2S3RqaUhyVlp5S0I0S0VNUk8vNUlQNS96NmdEcmtDbDF3KzhqQUR2?=
 =?utf-8?B?SEhGejV3REVyYlNQRHRGcUFqOTlKdW9zMm1DZmxzc1pSSUwrTm01QStHUmNH?=
 =?utf-8?B?bWJsNWQ1SU5Zdk50R1hPanN1RDdPcnhNUTF6RXNnZjN2S2dEa1g2RHlrRTFD?=
 =?utf-8?B?cmNNVFRoTld0OGxnNFJjSk40VGR0UHN1cklFY3FhZnErbWl4QzZoaFE4ZDFR?=
 =?utf-8?B?MGhTS0E5TXhnbEZwellia3dVYS9vUG9lYXZGOW9pKzNpZjIrNEpnMld0dmtE?=
 =?utf-8?B?a1RVeGExSk5tbVZUVWpBNlZXUkw1TldhMFFOcTQvMzBFeEovdTJLVTVzdmlZ?=
 =?utf-8?B?MFphYzYzZkJCVXJBYVlibHFzRktDK1kvQWc5c2NsT29wVWZ1RTN3SlVHYm4x?=
 =?utf-8?B?ZFdXM24wakh3bTgvWDdvRFRBSzM5VDc1UnFHTlFpMHZFVm13eDdEbEZGTWpP?=
 =?utf-8?B?NVZrbkpoc1hEYmJUVkkxZDlRWTQ0MkRzNStOODM0aEdPSTVIU1hRWWpqOGx0?=
 =?utf-8?B?eVpIOVNnbm9pTVhTZ2VkODR1WDQ4M08rMTVOSFB5cmh3clpFVnZoTi9HQ1A1?=
 =?utf-8?B?VjdrSHN1dnY0R0hpQlA4RmFhaG5yMlpFcDJEcVNpdXlCU1lRUU1ndDlDeG51?=
 =?utf-8?B?TmJtSjZWY1dnY240NzlPZHNLd2RUYkJIZnBtZlNpbXdmTW9ZYjBockxtVTRG?=
 =?utf-8?B?MkVENTE2SmE0Slc2bnYwTUk0ZlltMmVjUktlL1dmTExjZy9abENXam9hUEpB?=
 =?utf-8?B?ckxNUzZLTnVzZ0E2YUgrd3RrMHF1OEpGVUVrTUt5L3loaG0yRXV2S0VueVl3?=
 =?utf-8?B?aFQxeExEY3V4VVg3ZGVOUElPWUFxV3ZDKzR2ZFBNcFAxRnJQdlM1eHRITDE0?=
 =?utf-8?B?MXhYRjcrYkRNbEVtNXN1ZHBhUTk3YVJsbmk1L3hkblN0Z2haQll2VjErQmlN?=
 =?utf-8?B?dkQwSENmbzU1M1o0enNZTTVVMEhSQTZpZlorNEl2dDdYTktpWXBwaWdVK0NS?=
 =?utf-8?B?K1QwOW5OdnZPNTlVdzF4bnFrZy92aGJ0NC9NSGhjTVdzaW9FQnB1OTloODd6?=
 =?utf-8?B?bzc3Zy9BRnIvd2ovYkg3NDU4SHcrYzNyeXFpRG1kWmtDYUNPTGF0bk5tT280?=
 =?utf-8?B?ak90VXpMeVc5aWpGTFVPRnNtaTNPa01GRWcxMVdJamhBamJicFlONmVDd3Nz?=
 =?utf-8?B?NlV0VXNTZmpUOGYvZWVqc21wdEdFUS83ODRtamlJd1QvWEFtTjRJUGptSE40?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df6604c8-7f5b-4c37-d678-08db44d8be94
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 15:29:50.8707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3PvDOXACA+Q7995ePWvVe5OGLYqG5yy5vcFXVrXpfg77DXup6ppQpNFFbma+fJCRwetngCt3uA045cJG9y4E85Id4B8lBtujPnhZryFT+Pc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6127
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 21 Apr 2023 06:50:59 -0700

> On Fri, 21 Apr 2023 15:31:04 +0800 Xuan Zhuo wrote:
>> I am not particularly familiar with dma-bufs. I want to know if this mechanism
>> can solve the problem of virtio-net.
>>
>> I saw this framework, allowing the driver do something inside the ops of
>> dma-bufs.
>>
>> If so, is it possible to propose a new patch based on dma-bufs?
> 
> I haven't looked in detail, maybe Olek has? AFAIU you'd need to rework

Oh no, not me. I suck at dma-bufs, tried to understand them several
times with no progress :D My knowledge is limited to "ok, if it's
DMA + userspace, then it's likely dma-buf" :smile_with_tear:

> uAPI of XSK to allow user to pass in a dma-buf region rather than just
> a user VA. So it may be a larger effort but architecturally it may be
> the right solution.
> 

I'm curious whether this could be done without tons of work. Switching
Page Pool to dma_alloc_noncoherent() is simpler :D But, as I wrote
above, we need to extend DMA API first to provide bulk allocations and
NUMA-aware allocations.
Can't we provide a shim for back-compat, i.e. if a program passes just a
user VA, create a dma-buf in the kernel already?

Thanks,
Olek
