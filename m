Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B8863F24A
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 15:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiLAOIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 09:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiLAOIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 09:08:07 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECF6532DC;
        Thu,  1 Dec 2022 06:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669903685; x=1701439685;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wEtvs5kUTWiDdDeRX0XdrahLz89bMYDmNqQXxsP1D3o=;
  b=LeGAzrMVPYKWD/w09p52PKAXe4P5aD65iSmBn9Q/Oqefv6e7eOc6u1bz
   TDXqkfdESdro2nWWazNgy2Dr08BSyT0lKjOehn8LCifCKbjhdOU9MnWl8
   f4DJ0FRrBgIvVoxnE3MTgZ3BEFJoiI790THsaybT7A727hK88GFILcu9k
   eMveqOOVc0rrw8JBkzKULE9T9TtC8mOG7gfmghatnx9yxkrhscua2x+ql
   WTdZQ7nnnO04tKQCm/CN7ufEx1gFHkH70b0DG3QsVwpUXvRg6HSfOcQ3d
   0twhSls5juzl/yXPrvYS893Y5mTkYDF+NcgocsbmhYTx6bI+G+/XleQcn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="296051607"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="296051607"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 06:06:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="733430933"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="733430933"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Dec 2022 06:06:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 06:06:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 06:06:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 1 Dec 2022 06:06:32 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 1 Dec 2022 06:06:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6TTPmQ/CWZFZsOlW07dKiOlMz26e1po8N+2P0G3qjmaaQm3aweaaKviaaA4QaZ2/rhnYcnhHj2r7svw/Agk8Y03vGmqacF0PzXF2JT6maXh4kCqE5EnfsoKj6lshHvBz/ni3bGBOiHyMDn7yyb5GDxsjq376e16v37/mnDOIugE0YvBwpFzKkOvI/5rH/c87oLrcoXFigyUeMSlTkHZfhrX73NTrBnUhp0iyH9efqTmHvmt2tzhL3YsMHhtkM6kpuy4AMjJsnv03G4bdrcxf/BsMSsuGwnVkkdz4gvXw+UT+sMMj22EOyvApLmymJ6r5uKMMIspTzwPJ/c+rDmVKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ga4fncF4J7NlHJoDqK2EbDWFZvxt8cw/U/iJ8Vyoy1w=;
 b=WriQRfnfpzXF2fQsrAz2y+82EDx0xdQGRsYK/zJ49IR9WpTUNjJXnNnkO6Nh24FBL0z1PLyI+AXO5m9erY+KbgyzrHE6kZVgPXCW6u+StIF8uPicuMju1/SImoEl1elwXwUHUHFfPiIJ0uCV+lJ7wYBNK1Akka7PdRAWHiTwuLWuosOR6KIksoP1eXIT+Tjx0SwqmIxRn+b6i+xE8hOzz9zM5BQudTXyB9H0dBVfgkPEPfaeSyF+hybyI3okg+ExqjuxzjxNGP9JeP+3/jaMdi3BNh5Fbj6tGR2esUX7P8xmO9Qvi3OpBkmj3OW8BpVxIgLgiIHnyQEUR1xxLyMxYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by SA2PR11MB4988.namprd11.prod.outlook.com (2603:10b6:806:f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 14:06:26 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7da:c60:52de:f58a]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7da:c60:52de:f58a%7]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 14:06:26 +0000
Date:   Thu, 1 Dec 2022 14:52:15 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Stanislav Fomichev <sdf@google.com>, <toke@redhat.com>
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
Subject: Re: [PATCH bpf-next v2 2/8] bpf: XDP metadata RX kfuncs
Message-ID: <Y4ixjzpD9EoBgfGY@lincoln>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-3-sdf@google.com>
 <Y4eRtJOPWBOCKe1Q@lincoln>
 <CAKH8qBtseOmsWmeprdRsvz0T=vAObYE_CpsYQOX0CsLR_iXNFA@mail.gmail.com>
 <CAKH8qBstSJEN5wvcPAcrnD0at8fNeyLNwijiT4wv=wD9eAd1TA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKH8qBstSJEN5wvcPAcrnD0at8fNeyLNwijiT4wv=wD9eAd1TA@mail.gmail.com>
X-ClientProxiedBy: FR2P281CA0069.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::10) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|SA2PR11MB4988:EE_
X-MS-Office365-Filtering-Correlation-Id: 6623f741-43dd-498e-8f08-08dad3a53bfc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8k/NtQ5AnoBViDRHE9j7gPqpESuKsVAyEKz9wJTxtWNVMltaislQ06X9osCRIh0INuU10OtGlTxeJvC1XejfSmahzu1ggNBYr3JY7B+M8yarb7toJrUQPnZU77EDCd4/j6pcafsG2uJnVwki5CnsPX6Yt/sETJso84vDSmYwbYT/gVVWOgF+PJn2ERg4wBXRWjcQQDb+pIs4sH+dvD8uqQgAvtDEUMCA3Jfq4NVDllKVwH3MVx2OYL7EbYApFiJouVvZWWIghpL12DCOvg6TfA4auJlXJXrrQoa5UqcvQMGVTrFm+PuAbTkooZVMim3380ZdKgBK2i/x+xIfueeuzsIJlyN1RlxJeeweaeybfrRBpXtlvBLkyAFqo3xIatWtjFZVG3frHQf6Bb8Frd6zKTecRqWQchsF4mVJyEGSqrIRqD9bp/9JZpx6YTU26uw/q9DWV5KXt9a9iz6S8r2L+HVke+W5OfAFytdM+0ytDF+cGhHKD0j1z/RTstLrGJmcSfaazCpu/HjZ/O6nASkoJVlza4DlAEq48nWDXkMimkjSfPQ8oW0o1jQ4eUO2KkI24NvFUGo84LMXNk55owbNhg7Ca/WrQbzr20oOZ97dPqym4g/8GJsthjnxK5fZK4fo2aodbIIdwLT71ltMfNf+kbVQP9RxM1u+viqiguUjvZFrbFskQW0itBkLXcQ/OTAZ2jELCktNuuinAYgx7ING9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(366004)(396003)(346002)(39860400002)(376002)(451199015)(6666004)(2906002)(86362001)(6486002)(966005)(7416002)(478600001)(26005)(316002)(6506007)(66556008)(44832011)(5660300002)(41300700001)(4326008)(54906003)(8676002)(66476007)(8936002)(33716001)(66946007)(38100700002)(82960400001)(6512007)(186003)(53546011)(83380400001)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ggv1sa+G/KuzvmQuS7iVXOQJai2XMBcGhCIujhVqeDzIk4mP/am8cwCBfhjL?=
 =?us-ascii?Q?VtJ735T+W4F1TDxp7uq2hHa1CEqvq+ZXwRAhRinfBJ23HtOTaKDGh7Khdt6j?=
 =?us-ascii?Q?sn9qpv417vaSQbxlxHLmkxnFfk+pxFNAy1B7lPSHtk5SC0kjUNQXT20geEv+?=
 =?us-ascii?Q?qFMaDP58X2lnqlmDa7AcvpEp1rhNfyD37GOG++25NVR+gdxMeP68cWhi69UW?=
 =?us-ascii?Q?Ii+kisdKES3sWHZB6nXsAN7QE5S9QUWkP5N6mFWyujTS1sc3MetSIzcz7i0l?=
 =?us-ascii?Q?ZH/+3fBSDPHJUSrWqJKNgx8JasSOMCd+CpSuONaz6Bm7i67TPu/kjEvnUb0Q?=
 =?us-ascii?Q?oQoIbXVPEIIXYYfpt1l4bnEsZx7bAORDljnJqcIzcG6WqPs0p2kSTibk5T4A?=
 =?us-ascii?Q?gPgqlejPnV8+P9nJ8zLlG+LZAIYcJQ7mAsGBmTiGzjy+IpET3Rch+Pj3fgAJ?=
 =?us-ascii?Q?rFsepP3wBBRsi1ReMJmlIFlp5y06NLRox6UvFMfCipoHEbn6Ey8xil9EQl73?=
 =?us-ascii?Q?jC6WNCW6+267Nf9KN8fH5y4YsJbQGyY3zNePTj1VjPFR+vyunIHP1AiVtcXF?=
 =?us-ascii?Q?OrTp9gOrpjwHdT8zrvp8XxZTwTfyOX4NAhFDlyrmyp6IjR3fU6tCmxD5dN0P?=
 =?us-ascii?Q?TMhS0AmPtXpsK+wm0vvrkdxtW/pUppOgTAIZMqs2rQI9/N3L2rJnBVGdl/92?=
 =?us-ascii?Q?exInVrWUkVdfjdnLUF8UyV6NreA4seFQxAaUfAZnCXsgcoKh+n2tj7qARC9s?=
 =?us-ascii?Q?M+iHBQIyEXQsb8fZb7Up8priuVNuKiAP743ve7G+w2pFlYsoPZRZ5CSRM8zG?=
 =?us-ascii?Q?YyDEexS1EtCzlm7EEcjlN+cifCkQhOyIYqrufobl7x90dWT1K5A4M3MDKFTd?=
 =?us-ascii?Q?xRd+hnrwhnKWlIph5gl1VjJBsRGiXtFYdU6J+g8LMEqo7u9uQDdNdEHro2Wa?=
 =?us-ascii?Q?5fXWkd4XkevzOuvTkUOzCSwD1XgYYTz6TMtu9zNJpCiizu2+CEcTVCyBTUP0?=
 =?us-ascii?Q?TXMu3T80tQEGWxGU3WgsorDPpnmMYrl68TWJtIBqzsZ9GFqfq9G0ST2UREAJ?=
 =?us-ascii?Q?tu+iT1Qc/QT6La1sFKYjwdEGl6KxeSFSpggoYZYWZgaGG2rLxZBHRJ0lI2qZ?=
 =?us-ascii?Q?8s+0dWaKZObaVNGdTCXIxI6FbR+tbE6Rqo5v1YgauUA6qiea+YnOgaVcyElN?=
 =?us-ascii?Q?y+NzAIh08/CyyDyBI4BI8zR8vxmKlxXpxqscCJ5SarJjZQufmKhyBN4v797C?=
 =?us-ascii?Q?reEtIAV+15tqUyG2Nbsi21IOdQ80GuN+2geKyn9udT4jpKwRnnMCiP8Sq8ix?=
 =?us-ascii?Q?Zn4kHTDp4MAu+LOMSbjdGIZ14ZlGRS17pbv0Hghwu1GDyPpuSOFrkx0IjNbG?=
 =?us-ascii?Q?x+0TfON6hFmiTwiP7n2eyvzM6c3sSMJ0T5g1kcjS+ILQ7ON/5XkQMfUkdVDv?=
 =?us-ascii?Q?MU4HFtqk8pN9lAF9LghFxh8qi56wJrAr4STXozNwMD54RiGljTsKY+jhj7sq?=
 =?us-ascii?Q?91T4db6JrmYKSyq7YGDXI8bWrzl+1QucpgOKrd63Z8e1AyyNethUtgmRLgzr?=
 =?us-ascii?Q?EK0SZauUcSMaVVcPim2U6lG5TcY4zESAMc9nKEXTn2Ou34Izx1HvXHnfe9Zd?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6623f741-43dd-498e-8f08-08dad3a53bfc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 14:06:26.2692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sVqHUacxJdtKAdod5J/lTx8FtZ1nbPhesufKm6wl3ILSInOFhinUdpULT+QeZ5z6fVWAXL0dZWXxtdF/4X4ym+4fT7Wv9QiyejAt+u36Xrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4988
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 12:17:39PM -0800, Stanislav Fomichev wrote:
> On Wed, Nov 30, 2022 at 11:06 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Wed, Nov 30, 2022 at 9:38 AM Larysa Zaremba <larysa.zaremba@intel.com> wrote:
> > >
> > > On Mon, Nov 21, 2022 at 10:25:46AM -0800, Stanislav Fomichev wrote:
> > >
> > > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > > index 9528a066cfa5..315876fa9d30 100644
> > > > --- a/kernel/bpf/verifier.c
> > > > +++ b/kernel/bpf/verifier.c
> > > > @@ -15171,6 +15171,25 @@ static int fixup_call_args(struct bpf_verifier_env *env)
> > > >       return err;
> > > >  }
> > > >
> > > > +static int fixup_xdp_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
> > > > +{
> > > > +     struct bpf_prog_aux *aux = env->prog->aux;
> > > > +     void *resolved = NULL;
> > >
> > > First I would like to say I really like the kfunc hints impementation.
> > >
> > > I am currently trying to test possible performace benefits of the unrolled
> > > version in the ice driver. I was working on top of the RFC v2,
> > > when I noticed a problem that also persists in this newer version.
> > >
> > > For debugging purposes, I have put the following logs in this place in code.
> > >
> > > printk(KERN_ERR "func_id=%u\n", func_id);
> > > printk(KERN_ERR "XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED=%u\n",
> > >        xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED));
> > > printk(KERN_ERR "XDP_METADATA_KFUNC_RX_TIMESTAMP=%u\n",
> > >        xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP));
> > > printk(KERN_ERR "XDP_METADATA_KFUNC_RX_HASH_SUPPORTED=%u\n",
> > >        xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED));
> > > printk(KERN_ERR "XDP_METADATA_KFUNC_RX_HASH=%u\n",
> > >        xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH));
> > >
> > > Loading the program, which uses bpf_xdp_metadata_rx_timestamp_supported()
> > > and bpf_xdp_metadata_rx_timestamp(), has resulted in such messages:
> > >
> > > [  412.611888] func_id=108131
> > > [  412.611891] XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED=108126
> > > [  412.611892] XDP_METADATA_KFUNC_RX_TIMESTAMP=108128
> > > [  412.611892] XDP_METADATA_KFUNC_RX_HASH_SUPPORTED=108130
> > > [  412.611893] XDP_METADATA_KFUNC_RX_HASH=108131
> > > [  412.611894] func_id=108130
> > > [  412.611894] XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED=108126
> > > [  412.611895] XDP_METADATA_KFUNC_RX_TIMESTAMP=108128
> > > [  412.611895] XDP_METADATA_KFUNC_RX_HASH_SUPPORTED=108130
> > > [  412.611895] XDP_METADATA_KFUNC_RX_HASH=108131
> > >
> > > As you can see, I've got 108131 and 108130 IDs in program,
> > > while 108126 and 108128 would be more reasonable.
> > > It's hard to proceed with the implementation, when IDs cannot be sustainably
> > > compared.
> >
> > Thanks for the report!
> > Toke has reported a similar issue in [0], have you tried his patch?
> > I've also tried to address it in v3 [1], could you retry on top of it?
> > I'll try to insert your printk in my local build to see what happens
> > with btf ids on my side. Will get back to you..
> >
> > 0: https://lore.kernel.org/bpf/87mt8e2a69.fsf@toke.dk/
> > 1: https://lore.kernel.org/bpf/20221129193452.3448944-3-sdf@google.com/T/#u
> 
> Nope, even if I go back to v2, I still can't reproduce locally.
> Somehow in my setup they are sorted properly :-/
> Would appreciate it if you can test the v3 patch and confirm whether
> it's fixed on your side or not.
>

I've tested v3 and it looks like the isssue was resolved.
Thanks a lot!
 
> > > Furthermore, dumped vmlinux BTF shows the IDs is in the exactly reversed
> > > order:
> > >
> > > [108126] FUNC 'bpf_xdp_metadata_rx_hash' type_id=108125 linkage=static
> > > [108128] FUNC 'bpf_xdp_metadata_rx_hash_supported' type_id=108127 linkage=static
> > > [108130] FUNC 'bpf_xdp_metadata_rx_timestamp' type_id=108129 linkage=static
> > > [108131] FUNC 'bpf_xdp_metadata_rx_timestamp_supported' type_id=108127 linkage=static
> > >
> > > > +
> > > > +     if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED))
> > > > +             resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_timestamp_supported;
> > > > +     else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
> > > > +             resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_timestamp;
> > > > +     else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED))
> > > > +             resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_hash_supported;
> > > > +     else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
> > > > +             resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_hash;
> > > > +
> > > > +     if (resolved)
> > > > +             return BPF_CALL_IMM(resolved);
> > > > +     return 0;
> > > > +}
> > > > +
> > >
> > > My working tree (based on this version) is available on github [0]. Situation
> > > is also described in the last commit message.
> > > I would be great, if you could check, whether this behaviour can be reproduced
> > > on your setup.
> > >
> > > [0] https://github.com/walking-machine/linux/tree/hints-v2
