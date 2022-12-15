Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37A264DADC
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 13:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiLOMJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 07:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiLOMJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 07:09:23 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E958A2DA84;
        Thu, 15 Dec 2022 04:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671106161; x=1702642161;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xISv/+oLcVdpfdn+1o812Ctz3JzTjXa+dIlG+qc63dk=;
  b=hDaduNmy8J4x7HHfN09Nbk0EKnXtFx9C5bNu8hBlF6h7HDsOi+Z5xX1W
   5IsJGZoP4cdJ0SHQI+BHTUVHYA0DTWYdrr/vSPkPURclkITDq1wNdyTBg
   yVcMNTfz6w9e4vCjW1i2tKJ+xt+87G7EvjIT54159u+wAMoP5oxz/EziQ
   d9HPXjUDRsL39/jRDnNDnoOLfWz5J09xU2E7U/Znq1/FiRWCDMpVl1QXB
   qWdZ96NFZ9TEoHITwEEqH5jRf2i3449L3synurJtvA6D81NsnAld6xr+K
   JmAekN/eiJu8syIdp6y74ZpyldLtp08Daqo5wFbcQj/V5swM2lQDZi0sP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="306302889"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="306302889"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 04:08:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="651522001"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="651522001"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 15 Dec 2022 04:08:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 04:08:58 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 04:08:58 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 04:08:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnY2iUXLjklq+oAhVhYQvLvRFht1P5mWJNGJTn5bO6ZcNrwiv+xJERfpWBnRPhy6X9ZcFOmq3YsaYApyt0184dZlMvJLCOcqpVT+nmsbRuDbsjrLLyuFat61WVSju8gfJ7MEGRrJle1eHQ/2gjcER2v2d3whWhuEKh9x0jhwUW3ZdojIcJbPyaAJfZ5JfxIFt450WUvHC1LZhD29YrPilK7bxeYECyWY9SBtk7bmV7SnyTuTyon3f1KfNf/YqpX9r5F8s7psX0tWPm8Z8z4ByFBIypWNrHkOjsv6p35s5r2qZhuBxj8DlEeOB5il1bjDZPuwciAqWI58q5WwQJoSxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XTR/XuFW5257PPpV2aIErXGQCHNtw4ZzetM6TxTsYA=;
 b=nqkLL7zeSui2eAw2t3WSNOZvzqJ7xdxMsvq4reH/cwoae3AVP7+bXAjF+H6osAusIlo1cnLC9aDDyG0tT4zkRZ04CLn9W6trd9h2ERNkEwqF4Hp3o2H3Fih5W3G5DeLRq8C6d9BCFTgx73HRLu5SvK+TdH3mLUJzKKLbu6gVCEy/wmWuRTSRZ3VutSI8gPCQw92dY0UPCLUUoqI9v3qAQZAjYrW8EW3fD1VmAfgcN3czq30Pf81Z8FrYcFVRj+47ySumSd+AO9uDO+VCNvKWE6EyQ2N5V048xcl+jOuScOO+5fI+Sa3D5BBRdokHQC75Sf3H4FwIXq/npSJaOVqtzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by SA2PR11MB4971.namprd11.prod.outlook.com (2603:10b6:806:118::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 12:08:55 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::1de0:6f5e:2b10:d651]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::1de0:6f5e:2b10:d651%6]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 12:08:54 +0000
Date:   Thu, 15 Dec 2022 12:54:16 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>,
        <xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>
Subject: Re: [RFC bpf-next v2 10/14] ice: Support rx timestamp metadata for
 xdp
Message-ID: <Y5sIUI1jeN3c7iQA@lincoln>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-11-sdf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221104032532.1615099-11-sdf@google.com>
X-ClientProxiedBy: FR3P281CA0111.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::14) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|SA2PR11MB4971:EE_
X-MS-Office365-Filtering-Correlation-Id: a7179be4-64c8-4200-b58f-08dade95223d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8MrE2IXiwvOXu1gBcejrszIPfGCLUAB61j9oxsmELLuyEBneWtVyYoxe7JiYLGk5oqxgo00LVlrP9l9jdMGcuo/ZBM0eYAHIZGUpJ/Rgs7VMVAiyPIfoaJYRGwdtQjF8lRPjJHn1/5KO/+X4ZPK39v+9qltHOIJ2B/kishLV/BnKK+yby/ptzqBvdzzqHJ6dK1CAEM9eTJNNRMcttfV2Nw/rIRpCIjkwKkQ/nSpoTcCGvDIfZrgzSx9lVp69mvyyEuWnXlqCnn2ussvFH5YL/wkXGWydvjQL2fNVTRUOrUaUTdhxFFjFpi6rgs5EMm+SbZsdhgMlzPohebkLthIf2k+Aty0a71Jrml3ZH0cS3Qo/ejKUNF3qHZIJeWUhgWWiG7fzjRlIItxPtNc/uK/haVCCBGtnEXQMI47kFeepSF37S2q+ocq3R8eFJ2adA1sXZihbWC/eIBCIEt/Pr8OkCI6nG21Kk+xzzBl4GKkx73GFYkZfeB8l+zxgqZsZ0vDrHOjoM4YAsSlOzBc3nOWm/XUr/Y53IT+MQ7tYqbcVEv4IabkUNVYKC+EW9KbVaIX3sLTKDN2wEEFMnwk+tnJc0VWffDnlfc+2ObLQZ7feZ7uFmf8xbCZG3yDVj5a14A1bhXkpaHrVzNFFci64rwa6OLpH/3aRuAfgqypNFJqrjRQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199015)(478600001)(6506007)(966005)(316002)(41300700001)(44832011)(6486002)(82960400001)(186003)(9686003)(6512007)(26005)(4326008)(66476007)(66946007)(66556008)(38100700002)(86362001)(8676002)(54906003)(8936002)(5660300002)(33716001)(6666004)(6916009)(2906002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ko9pZ/siL60eZJ29iTcOoL6ebCyrMUhUA873SpwPcBCKXQSQBG4njx93n+LQ?=
 =?us-ascii?Q?Avk1lsDbxqK4HgfkWILjKpZ3Lrl5Pjuds4tt261L+sFWK1PLQVYgaXqWHAYx?=
 =?us-ascii?Q?ATHFfxlycl+d+QA4yrSVsxJ+dl/tVBQ5LjD+VuEoVxA+j/+3hry265N/9M2J?=
 =?us-ascii?Q?MrXJFFRvAUxbFBwxH2aPktp4BP3bVMvJbFjNSK7pbTwgL//fEpKqkmOizH4b?=
 =?us-ascii?Q?f+AOPY68xgdwifv73H29CFdWAISNMl/yi0lHeJHtPMipkHYoxZyrKkK1wx1o?=
 =?us-ascii?Q?HXJ/q72RTTrIZMc3/Y+6QeyBUYp9re+Ziie6B4jB/trf8zQbmQ3U1Xh/OXOE?=
 =?us-ascii?Q?kgqF+sVyf1YET64/HeE61U3RIKM8VNPSoYR4IOKcEts43n5thSPLMqmNB6o5?=
 =?us-ascii?Q?SIe665YYcfToztbn2kaeo9xWnJGWo75FBWaTknU+vSwQF/lB6e+MODEYwyRv?=
 =?us-ascii?Q?LPOD4zYTpenlUXUD51vvhvu31qWslYKfR5nz0+Zm4kdVwBrPZ78VQD7XRfJX?=
 =?us-ascii?Q?G8xqlExy3bBydB/f2sEzdLgKb9jNnWe75NTxADPH69koXYhWFgvWe9PkXxbm?=
 =?us-ascii?Q?bkcA+cXKHNVIyaeMGE8r0t3acKzlppquRJYYBr82FnXAfk39GwoDu7d16dO+?=
 =?us-ascii?Q?jQnaOvx/UGUh2WQWX9Oj/A+jLh0AgZk4FFNoaw+MuRr7Rq7wcVg7xHdnmdOa?=
 =?us-ascii?Q?YloZy55hSh6ttWYe4te8mBHG9beSlNiPdFCfpME/IEP1KbHvSFoYcaVZJ2ZY?=
 =?us-ascii?Q?ZCwjX/j/d3RivocB8FZ4v69xpfdxvZM8nQ31jjZ37H92JLvsb9lBnj/Bh+GA?=
 =?us-ascii?Q?CVq2nkNmBdrxRS2Z08tneUH/kBxUdpCzEvjF8IH6Ww93yirh9lwAebFkdilC?=
 =?us-ascii?Q?NpdPJlan8OzyeWDF8Z4dp4jnnH43VASKh1EOyWl8bz+iCkhsqEypJU9H2hWx?=
 =?us-ascii?Q?Cfxb6sME49axoFdRJU8T8SuO19QVtXK6c3XUGcvpVOZNmgK5+rLu7cgR9xI/?=
 =?us-ascii?Q?CvtG9wWT3wIZ9LGGlMVCjnEduL6bmqs+RY/i4QL3Dcu0Yaxtci8ZVTUK84WP?=
 =?us-ascii?Q?1IOO0BIfoTYkAGjM2NdqHWm9lzmSyJgpUE4GL8OVuuexjA1o3Tg19eXl59mn?=
 =?us-ascii?Q?vJ/T3iGfgvh/UGLlq2ekPbKwYauw1JAmkWRJJ3SPMLnj2oupAVcTadaZA980?=
 =?us-ascii?Q?+peEC4Scjdo8JB+Ip3agUTDHOQ+fEOvwmI4SMm7hLuiHn+51rFZL1XTAZI6I?=
 =?us-ascii?Q?hhN0UvcAXjPbvBSn586M2MGkjXYVU3MRXdUj0gH+B7M+ig73iPHiQASzfN9f?=
 =?us-ascii?Q?wIoOQYOBOSoNHZ67dbwSEqMVZ+DYQyPST52VTaIX2xztZAjrtY095lkc55ry?=
 =?us-ascii?Q?kEaoU8icRmZie3rc+PvPr13MRI13H/6ieNG4ogd8GHjf2CXVNET1+ItKmWBo?=
 =?us-ascii?Q?/JlPAkE+vyf7yDSOz61Eh0CaR+4Uz6UiLH+uLC0moi4Ms8Y79p/lGuCkbKQd?=
 =?us-ascii?Q?uEYBmogoh21+C2oMPXamLHyMVu3nNzp7eV0QvDXG4OATRNZ7MnP+ulbNG+rI?=
 =?us-ascii?Q?wiggpQ1nwW0FKivB21iI1xMJEmI7/Cr2g+zDFdW126WWNvmHfprpg0A1HD0J?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a7179be4-64c8-4200-b58f-08dade95223d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 12:08:54.7475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xLloHzRaaPwBZ29r0pELE0hO75cf/TUeU8gAQAtA615cyZVVQ/oFNNFbn0cKy/6ThWyTu+vKo8mRFDp8T9bdsaXqtj6+Jv5SS3O8mRDRKjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4971
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 08:25:28PM -0700, Stanislav Fomichev wrote:
> +			/* if (r5 == NULL) return; */
> +			BPF_JMP_IMM(BPF_JNE, BPF_REG_5, 0, S16_MAX),

S16_MAX jump crashes my system and I do not see such jumps used very often
in bpf code found in-tree, setting a fixed jump length worked for me.
Also, I think BPF_JEQ is a correct condition in this case, not BPF_JNE.

But the main reason for my reply is that I have implemented RX hash hint
for ice both as unrolled bpf code and with BPF_EMIT_CALL [0].
Both bpf_xdp_metadata_rx_hash() and bpf_xdp_metadata_rx_hash_supported() 
are implemented in those 2 ways.

RX hash is the easiest hint to read, so performance difference
should be more visible than when reading timestapm.

Counting packets in an rxdrop XDP program on a single queue
gave me the following numbers:

- unrolled:		41264360 pps
- BPF_EMIT_CALL:	40370651 pps

So, reading a single hint in an unrolled way instead of calling 2 driver
functions in a row, gives us a 2.2% performance boost.
Surely, the difference will increase, if we read more than a single hint.
Therefore, it would be great to implement at least some simple hints
functions as unrolled.

[0] https://github.com/walking-machine/linux/tree/ice-kfunc-hints-clean
