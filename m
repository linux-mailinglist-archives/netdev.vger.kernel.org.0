Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273D96DB090
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjDGQ2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDGQ2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:28:33 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21AE211F;
        Fri,  7 Apr 2023 09:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680884912; x=1712420912;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=cB2173ca4X/GtXZ/WZ0rofQS6TOtVBAO5xc9G9Bseq8=;
  b=UHqLx2BanYUmI6Yh4Wx+IAXBZO/l5DpAS67CScjR3bGx94wpMc91bxwI
   voJVRLmoyZqDC1oyd0jWYG7E9vGRfaC73VMOK+HuKWeioXGvOfmHGrDVt
   aaM1layAp1XvJSulXeJjrX1/7OEPf+HBphDgNh1oeSIXHAA8d6fypK0Si
   TYrGmgBy5xxcXRqHHTL8UT4bU5S2TB1/MFwWnmg2QY0J8K5GUkeK76ItG
   /lbE+5X/v+se9/+nReeuUmTo3A168EKK56+xo+2cMiXqOgAbxUH72U1zZ
   h6wNU40l+QXGBFSP8gD626c4hSSaPnJXiA1ZIi7GPzV5i8qiESDUmxjW0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="429306096"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="429306096"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 09:28:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="690108560"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="690108560"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 07 Apr 2023 09:28:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 09:28:30 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 09:28:30 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 09:28:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZFViIHrQYe9047QfSaeCVYTuEQ0gRmQZipLcAr84lfi0XI2/u0o7+hdJGhZopD1H4HrQKyVLnnmvir9U4ZpDkSN2SEkUZ2cyBzGnFl0MwYmhgw01r+QP6NLYqO2anlklpdt8zWZa6vly5OvkBffslN4yntD/fhLK3zn4td46P1SalpSMVbdUZRUXor4Cs2mEiGnso4JSeoO3POgenBUMoE+2Jm5OCCYX1phhFJt0Qk6T1iqLTEWjWm9ouZrQHhbrBthe3pKFs+nnfftJgW5hrWfLCnCgnbx0gL4B7kI3kLgbr/q3RGSiNnbVZRoQhH1uLepcqIpe2RAXVmt664Mpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pjp8PG5aHDsuWZooEVNsZ2WM6bfFTGJzzxgquoEKQ8w=;
 b=BYqLpZiecBGlIZJxiDbuJA0GGv+WWtrkMMe67VWJ7CrFKNNeps7yZMVefVarNs+1RAldAK0Qo/gPUU612AtTUMQfhJrtNAiTc8P5pWA/+MGxjCZIpLNr0ZzZ2iklJ2W55HmdSFhh1gy2U4k5Qo0MpR4NB6O0uao+zNPb/FzIzSzIRtuNLlZeCgVxGNyFo8Pq/BgsMR8mGo2VcnFl30wEgBH4NNaCySnPQoXhJHWmR60yFvAM8Spg98u1yrd/nk6k2uBwgG5h0KgQ7/AjVpdP8mLzYOLyEfsDMH7BcbMfwYwqxDYmV2rnoDPb/uw8pd5ZUA91aw0C59ZJHY7RdU0mdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO1PR11MB4865.namprd11.prod.outlook.com (2603:10b6:303:9c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.35; Fri, 7 Apr 2023 16:28:28 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6277.031; Fri, 7 Apr 2023
 16:28:28 +0000
Date:   Fri, 7 Apr 2023 18:28:14 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
CC:     Kal Conley <kal.conley@dectris.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "Jonathan Lemon" <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
Message-ID: <ZDBEng1KEEG5lOA6@boxer>
References: <20230406130205.49996-1-kal.conley@dectris.com>
 <20230406130205.49996-2-kal.conley@dectris.com>
 <87sfdckgaa.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sfdckgaa.fsf@toke.dk>
X-ClientProxiedBy: FR2P281CA0158.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO1PR11MB4865:EE_
X-MS-Office365-Filtering-Correlation-Id: 276f776c-ea4f-4c64-6a94-08db37851e5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ywyJbSSlTrAZQ9yxvmzAr6NSonXoxL0a+qgoYpdExr33wq8G1gi5CSD2OIWaygFtTyetWEvD6OeDJz1YOQvmd3bg6FHhJpyVjVM9ATn4MCoyn7QQukz1KYgFub2M4eLj8mtT2641vL2TAXVLNwDP8zcTInAPC3Pg4euYlDLAeJ+0+6VXzI50uUl6bW+oh77wZrlb5zUsV6OLSedtMZBcI/8W4xdxKTurbsK6sxaeuMjYV0lS6ClJNT/A/CR2Nr1RtsqH6OKmEBlQ3+v4Ar2ZNeB68OlAxz8vmQZ5Ca6SsaICNOj/K14xI7Lchcn5Cnp6v1wHbCEteaCpV6JjA7lB9OBxBZwo1ifMryzk1WBwTET0VXuue8VShiNGdRDa3thUB5ydPNKysGUnlStSgVOW4bnQuje/GgpczsqvJ1SwPsuE3ysOj/U/7UkiSfElBt/a+OcD5baDUpvwr1+QzWn1c+m226svgC4GB43dPW5G+io6PU2nt6FqjV0czBH19b0MIlQxRO9NxLmPUOwenx4/63B42HjFp+XxTajoTs1MLNCXwPGPJJFZgUPPXpVOGgIg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(346002)(39860400002)(396003)(136003)(376002)(451199021)(6486002)(66946007)(8676002)(66476007)(6916009)(4326008)(66556008)(54906003)(478600001)(41300700001)(316002)(86362001)(66574015)(6512007)(6506007)(9686003)(6666004)(26005)(2906002)(7416002)(8936002)(5660300002)(44832011)(4744005)(33716001)(38100700002)(186003)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?JbZfcXsKV38ShPiYD3VUsDaxOB5yFl8edvchsDzkVB3kkKaEF1tEPdJCyO?=
 =?iso-8859-1?Q?ZHTI5q8RuF4xcbPnrf9CYj8R9L4PoXlrnokAu6wn02S8IGiSR1nNwlfx8w?=
 =?iso-8859-1?Q?oKv03raWJrXdjf0JBp2YE8F4gM46QNSekSqRIe9Zj7LWu/3GIOW7ubeETu?=
 =?iso-8859-1?Q?tFKrfcaF4Rwi6jmmL0MbaM+Gaa022wejMJi+f8ijaLLzHk6wln/84j6rv2?=
 =?iso-8859-1?Q?qBXo9a0imca/kQUm9EDy9Arf2gPopZ8lpQZsTW0ri7MUzNi8bF5Ee3CNdW?=
 =?iso-8859-1?Q?PRMhXY6QCBY1jDgMgL+HMAt/hqGfvNJEyA9h8i92l45d7ySIwwuV1xzs88?=
 =?iso-8859-1?Q?0dVJiZhs7BpOk4IOMLK0sevzIM1NO4n3HIfgAEl6CL56kmmDwT9m56BxLy?=
 =?iso-8859-1?Q?RIB6zTW+wqhX+T17STYg+OPnMI/RqZsNsk65WYFU/1WrRzvVnPpCC36kWZ?=
 =?iso-8859-1?Q?wevoH8vXIaTMcJcsOzgBb/WWvgShcn2twYrLFk9PJ/eqjSlNC8v4N4DRb2?=
 =?iso-8859-1?Q?GEOMChE2wsh37jSLF0gc7l5Lb4cBvN4xjhQgY60SonWmJhH6C6ZDKfgmRd?=
 =?iso-8859-1?Q?eF16j/uXZLNtkgfVo1YmPUWwUp62+yuqBZfzHegpde6XG3jVvjCJ77Ipmr?=
 =?iso-8859-1?Q?OAPTaD1hb5DApGpyf6X+jBytnO/BrZe7EWg2xjtC9nPz5/DgwGS/jveV8d?=
 =?iso-8859-1?Q?dDZviGhxNOqDHwYZ1IpuBc72rb99q6Wr+GycfnHmdJ6I1xOVcwR+4ip5uD?=
 =?iso-8859-1?Q?WLrNBjNP7uHnRSIxafPlfCJhDUQx5SHINya5T1B9LQ4pAMlrWwctAaJKgJ?=
 =?iso-8859-1?Q?rpRTiAyiZdftJKjJC+9aGvjC+KnExCbj0Cm+ilGwxpKrv0DT7a0o8WzLT6?=
 =?iso-8859-1?Q?o6Y3FpD9KET0SoE/mLK74QReO/RbDCeZcmhAkUMSV1FB7leoeCirLncBE+?=
 =?iso-8859-1?Q?F20UFvF1N/xkHaOlOP8OOFCCrB05JOMC+mprKyGFmscyUUeWDk9SWOyY4I?=
 =?iso-8859-1?Q?VsW0olvTY3QMojJLUuzyCE4hMe6S4UhB8w4QX/xniW4gkvkfdIpf0WuT8R?=
 =?iso-8859-1?Q?uqfB68ABNuSiqeuzE3X4VYkE4PhJdEplMF1o2l4LECFiD9hYuzzXTULm2l?=
 =?iso-8859-1?Q?5e29nobXX2Hyd2/FiH720YOY5Huvz2n6MhaGhldAY9QlUld4EuGpr6e9As?=
 =?iso-8859-1?Q?YggXmnjnAOHJ0uIDxptrKT4EWfotTTq5QH3utvmfgy072awVov9VAY5UXr?=
 =?iso-8859-1?Q?WyMrrlP2Ymh2BDO9kzmSokHBBroAIaFLP9RFiUqJo6konjbdFmj/ILeL6p?=
 =?iso-8859-1?Q?eayq3L6cbVA052bB2Sp9O4LDWb4x0fT9jdtPWsevWUq5VIUXh46d6Ei347?=
 =?iso-8859-1?Q?BeeNy4amFRu9cBv0Q2bWr05QsPiSGn31v401Y3wGNc7jI6sbjJpNq2m5Se?=
 =?iso-8859-1?Q?77ybXphAalVlP5E60gzLZXt0Eg9R7BpXZIynfMaUPzTsksjt3wFH/OtuVv?=
 =?iso-8859-1?Q?7VA02kQqWYb3H/s3ZMi8lUuI3Jn+fZDX+GaOK7/WDVsL49YL7erdVrNYvS?=
 =?iso-8859-1?Q?Q1/ha3zdmPGsqjwXvcpXR/pt8gTRmT/dxQ6DaTBAErMpeNky9Img3hROZV?=
 =?iso-8859-1?Q?s78ZqbC68kViAU3FcoiLoldhIYIM4UhKmmJ/fcldn3Gi+PDhlbp9liLA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 276f776c-ea4f-4c64-6a94-08db37851e5a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 16:28:28.4316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IocsJhuaqeANvMlv6IAdiBS1OY0bSAQxatLAlrGFirDkauYiE7NJyOo8DauQlzyYpdfxAZ5F0TqJYbQFxzqIHhPaD8QNIPI+UwjLXLPWJ/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4865
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 08:38:05PM +0200, Toke Høiland-Jørgensen wrote:
> Kal Conley <kal.conley@dectris.com> writes:
> 
> > Add core AF_XDP support for chunk sizes larger than PAGE_SIZE. This
> > enables sending/receiving jumbo ethernet frames up to the theoretical
> > maxiumum of 64 KiB. For chunk sizes > PAGE_SIZE, the UMEM is required
> > to consist of HugeTLB VMAs (and be hugepage aligned). Initially, only
> > SKB mode is usable pending future driver work.
> 
> Hmm, interesting. So how does this interact with XDP multibuf?

To me it currently does not interact with mbuf in any way as it is enabled
only for skb mode which linearizes the skb from what i see.

I'd like to hear more about Kal's use case - Kal do you use AF_XDP in SKB
mode on your side?

> 
> -Toke
> 
