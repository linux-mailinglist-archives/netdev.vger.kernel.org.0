Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78DC6C7DED
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbjCXMT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjCXMT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:19:56 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E081C15881;
        Fri, 24 Mar 2023 05:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679660371; x=1711196371;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=mpEi9Kvh0PjO2+bOGSbPqWUh9HNgZCiDpkHIPDte4WI=;
  b=SuWgqiTB9BL0USUDWzlmjXOv9DiTOWfbb1EuxPYIM6XfP25Sd0dAPpIJ
   MbE4JHRtnUAHOmat2zhbCwigbGovg6gx4cJCug8o+qYr9MnmZrPhbu6kp
   ivN/CbIBo1YW8/57A/Gd1hBw9qLKNnwgZMKQpdrxEBZklv/Rtsvjc/tgP
   rdsRu92qiEqF0mAdaNeMBOtSruoazaAOAXu/HUsLeF3S0VpHgZc6lbfSt
   kfuHpf8m6BSWI5AXZYm3DwpzC2GUL+FikMrN+99EaHhMvSNI2odJnYGNa
   mnTNtbof0k/XOh1GuT64SLUWrfxSmCgge74KJeAxJwtLWuzNZOwyISuYz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="367498773"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="367498773"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 05:19:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="1012236128"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="1012236128"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2023 05:19:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 24 Mar 2023 05:19:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 24 Mar 2023 05:19:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 24 Mar 2023 05:19:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSmICWx9ALSbA8eXmcF+TiEfvuJDvZxIgkRM5U2wFiz9SyQpuRtwFGQbgb1LUJ/QtiLy/ct9QoRp8DOIRRCc6PQhwsoro1B3gx2X29Hu7w5rQalrDVSyiqYT6xFhR3370cnemrxZSqUo8Wa5N+IsSK5btXUXt50DlbklnSsBx01JY+h+urM5iR3yFUfq4sWsUketrTArIDb0wXulOTePtBYdeqisiAoQzezuJdgaMFdygUbwfq6hASRYALJyjLri949Tl72cTgDJ7frFeEs04Omxj+5yIE/iMZsm+l3JnfMeKjkk/6sMJS7XGHcxGerX0JDdpjXSmNDJwb5TOvMIcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkudvS4OdiYeJg21G/GQwEJvfByrpNo2g2+k74zzjzU=;
 b=CCEAxy09Phy3Fi2JouaZp5mT4E2uyQJ5GQhLPlyb3sTwuGDUZSfXnr1en11rMc+CxaO03TCJY3uAJnu0cG4z68XKr57RSCveISU6LD8/j1Xn3SGA2cfK+hS8uUoZ6MrYJjni8vj1CzemRUuazakVs0NuzE4LkHZZeltt6p3VjVLRPinncnRHnhear1joq2epHzSJdo6OCySf7WPUlOd6KdcwizDCFI/loEr6riqNo4uLXp7OGWokk9Esk8J4/p4zWdITl0zqdkBcUeRY+shMQhe8VTHA1bJ6QwbBPgFbJQTa6qcMrhZCaHQHZe8BdK63+Swhl2RA2vN3mufVP/+wsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB7661.namprd11.prod.outlook.com (2603:10b6:510:27b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 12:19:10 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::dbd:99dd:96d:3ab3]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::dbd:99dd:96d:3ab3%7]) with mapi id 15.20.6178.039; Fri, 24 Mar 2023
 12:19:10 +0000
Date:   Fri, 24 Mar 2023 13:19:02 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Nuno =?iso-8859-1?Q?Gon=E7alves?= <nunog@fr24.com>
CC:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Christian Brauner" <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next V4] xsk: allow remap of fill and/or completion
 rings
Message-ID: <ZB2VNg7yVxAjJEMV@boxer>
References: <20230324100222.13434-1-nunog@fr24.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230324100222.13434-1-nunog@fr24.com>
X-ClientProxiedBy: LO2P265CA0430.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::34) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB7661:EE_
X-MS-Office365-Filtering-Correlation-Id: e4a0abae-a96d-4fa8-bca9-08db2c61f8a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Wu97DJyoZmQoILqFJSVYWVzo7kYQmURwfak/n9B4fiW5Cuy1O2kJC1izslus7VsgoPSf7gwJjrnTLqwpSpZ1X7vf0peZ8eBOF9pRbjdBbYVN1V19FaRGva5FARw2oL6v6zuRJOF3E6KgTOYE4o/NwPQm6HYsJ5WTi5wKqDccfy08ArlIQbxzjW/BRpPQv62/ID09N9BqvrFIiVz6cHvNLSZqJxuCKXsg3tuLvnUVx8Lqo3jlrKb621AtK/gKY2Snke+ZEDC9zVJjlP7DB6yiDmRNAxdCbImFh0dHmcdJk8FIqcA+DUYlZ+YsjBgYASmtMVKVRg9dClB79r1Gh0ksaLD6mZJ+3Cvr4rgna65yWRDueD2tb9wfkbgU7QThW8Tl9aBVtZwhWNl+UTPb5AZTOcKTMU5a1UglvaNIM7Bh0Pjp9EPunSccu5Z8pajj0Nsg6D7TDU/AGl7CHa0UTa+BxG8yS5T6/YC0gp4B+hRnDcgTZ1iq1snbqnzVKktBbb1C2OmlyEONuMZPrctpnfHx+Ch6+SyQaJCEklKdt9RiU1HRWrnu29PUAFcAy3y8dKUjTSSm38outpgXa/eEcObqn6/LcHhs18FgJ171GhmLQEqNkV7zM0c2GopKUPlOmWB1y+my50Hkvtom3BzR9RHOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199018)(4326008)(41300700001)(8676002)(5660300002)(7416002)(6916009)(44832011)(2906002)(66476007)(82960400001)(86362001)(38100700002)(6666004)(6486002)(316002)(478600001)(8936002)(83380400001)(66556008)(33716001)(54906003)(6512007)(26005)(66946007)(6506007)(186003)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?jG9gboowZyd+jL0U2EsRXxuuBPY5lqvnRKjVxwrMaHtvfBGOy0IK31NLPX?=
 =?iso-8859-1?Q?A9fF+aHHNdfxFbZboV4Cvj0kQtBXafQnaynPXWRCQeluum0jo9t5dOImqc?=
 =?iso-8859-1?Q?O+lc1hFe5CM0DKO65xT7Y8gi0TjAue6+bmJJqxLoZ2u0JKWVNz1f3baTMI?=
 =?iso-8859-1?Q?DVi5nZxjUieoZTinjK2ULoYOHUp/1cKzWK8AHJegZ/BNulLMLpFqb0v0Xq?=
 =?iso-8859-1?Q?8ebCpAQi599J20GrB7/Ds38Q8qeYfwPV1q5oyse+SNerGW5A7FJzOn2ms3?=
 =?iso-8859-1?Q?e9CvdwE7XBsUdfFjmLxFiWQptPZsl9ZYy/NMFr1T2HJixOuAvUiGIVhEWw?=
 =?iso-8859-1?Q?LX7nZY73ON9EkolmdP1LqVbWKZ/bL7ft0Wkz0olJAnFVNJ0G/hgxT6K6Bl?=
 =?iso-8859-1?Q?qEkBEx2duBWX9PYcxcIBuSrldiiBXNDFx7UCwM3jRzpqe1K6Eyql814wTH?=
 =?iso-8859-1?Q?eKbf5StDxTZ/AKWXytJ3/g4i7eE9hsgK60GAb1xl/6cTBGGU9z0yEWYsQz?=
 =?iso-8859-1?Q?eJ0wZQncWnwArrNpTYaz4S2ZFnK4IA3ZU6v8nCkP6HWh26/O5AG6kmYsT3?=
 =?iso-8859-1?Q?rzWLHfkAsBP3gQ8UZKV0EKdX07h8fibkiRlsVSJhtTSJd67ORjHtCNTTi9?=
 =?iso-8859-1?Q?5lSBFQUp4exiBulbxGLMebVCr+UKvQ7FuuXrObpeJKa473C9nLKNvRgW/h?=
 =?iso-8859-1?Q?CEVvC2oGCDJ48N/7c7HqGBXfjUwHttchPScOgLyBc4p3uycVej8nhI+jOu?=
 =?iso-8859-1?Q?Ud8isX4ls8CWxO8lPzGTMIfwfyk7nHnecPdhs4pkGuKCj1jpbvZrqCI2Fv?=
 =?iso-8859-1?Q?Zoimtne+Z/4YXa9CK1rMuVYVv62GLTnjFnb4MdmSHTCWNwPsDDLoWN0vaB?=
 =?iso-8859-1?Q?Qcj2XvhGpl2g/asLG2P1zELNsHFkHiIswxmKQ1jjAl7LlQXL6j6hnm+N0/?=
 =?iso-8859-1?Q?0WXfR9MfvslSwXIg+OVqt7tFMT1cgMSVCVJbPyDGIDo3VD5Y6RAryYP/2R?=
 =?iso-8859-1?Q?z9ii+eoIJWiVkVJXwk3hAbSOO1ZJphlcuEOvb+kWBa6YoQFnqTuBFs1v+P?=
 =?iso-8859-1?Q?Yu3/V6JMfPBW9RXC1oMql9akAi1N80JMHVVrm2A36Gqzuk+NGR5FTfDuyf?=
 =?iso-8859-1?Q?W3Jta11OO+ansh389eh4oGYAHx8HuxhqjnwcE3aKEJupE2FhBHCgQuw5AX?=
 =?iso-8859-1?Q?/BGGy2BYQ3LYDzxzCxG1YSM/CRnNuQOBoFZABeYpb9z0ABs0WxstnvMxbl?=
 =?iso-8859-1?Q?2E6ItaggWuab6sbQ00eik+IzO57TICPFpkZ+5iBb9jIfIPWP5Qb7MCvZR9?=
 =?iso-8859-1?Q?CJGukKZzoRAY2dcaFt/3NJ1liqXZwigvYIZVKiHQtlQuSAGr0ypNvjac8X?=
 =?iso-8859-1?Q?7cSohToR7viKUaFWY2Os2TQgoC0s5CE6K2VQeOLMETIi6a0nhJYxAmF81p?=
 =?iso-8859-1?Q?RxQgnICMMgpBeEvHEuIMeH3SsvIamEn0ghGSfYv9BGm8Ji9r97kZ9OYVxc?=
 =?iso-8859-1?Q?05aVHBtSe6RmrpmjlArIIcjy6CRHcpDwBwmzfWGKBUxdU5UV1c/M3Gfo54?=
 =?iso-8859-1?Q?BhF9M0irhDRlVlvlT8Elw1IMa/v0/CSsfv6LFUb09jKitV79kcmXGgV5xS?=
 =?iso-8859-1?Q?0luVHT88frY6LvB9jrv+ekWDUo57al/LPKB8xQMJqJ1zou+yJj3/4WyGbr?=
 =?iso-8859-1?Q?d1oJONzmSb9Iqd3Qgqw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e4a0abae-a96d-4fa8-bca9-08db2c61f8a3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 12:19:09.9549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2nkX2/ZNR9WMJ4hyD2QDGBcdf1qi17sHWRPEdJLTB+ubaxNW0itA+YuCOM+e1HVFiye0Buiy0cx24+3wlJ2OaVSbG4h3VH52NKzxnf35HgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7661
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 10:02:22AM +0000, Nuno Gonçalves wrote:
> The remap of fill and completion rings was frowned upon as they
> control the usage of UMEM which does not support concurrent use.
> At the same time this would disallow the remap of these rings
> into another process.
> 
> A possible use case is that the user wants to transfer the socket/
> UMEM ownership to another process (via SYS_pidfd_getfd) and so
> would need to also remap these rings.
> 
> This will have no impact on current usages and just relaxes the
> remap limitation.
> 
> Signed-off-by: Nuno Gonçalves <nunog@fr24.com>
> ---
> V3 -> V4: Remove undesired format changes
> V2 -> V3: Call READ_ONCE for each variable and not for the ternary operator
> V1 -> V2: Format and comment changes

thanks, it now looks good to me, i applied this locally and it builds, so:
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

but i am giving a last call to Magnus since he was acking this before.

> 
>  net/xdp/xsk.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 2ac58b282b5eb..cc1e7f15fa731 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -1301,9 +1301,10 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>  	loff_t offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
>  	unsigned long size = vma->vm_end - vma->vm_start;
>  	struct xdp_sock *xs = xdp_sk(sock->sk);
> +	int state = READ_ONCE(xs->state);
>  	struct xsk_queue *q = NULL;
> 
> -	if (READ_ONCE(xs->state) != XSK_READY)
> +	if (state != XSK_READY && state != XSK_BOUND)
>  		return -EBUSY;
> 
>  	if (offset == XDP_PGOFF_RX_RING) {
> @@ -1314,9 +1315,11 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>  		/* Matches the smp_wmb() in XDP_UMEM_REG */
>  		smp_rmb();
>  		if (offset == XDP_UMEM_PGOFF_FILL_RING)
> -			q = READ_ONCE(xs->fq_tmp);
> +			q = state == XSK_READY ? READ_ONCE(xs->fq_tmp) :
> +						 READ_ONCE(xs->pool->fq);
>  		else if (offset == XDP_UMEM_PGOFF_COMPLETION_RING)
> -			q = READ_ONCE(xs->cq_tmp);
> +			q = state == XSK_READY ? READ_ONCE(xs->cq_tmp) :
> +						 READ_ONCE(xs->pool->cq);
>  	}
> 
>  	if (!q)
> --
> 2.40.0
> 
