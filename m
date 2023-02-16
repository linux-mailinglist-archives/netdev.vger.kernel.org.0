Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C2069946D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjBPMfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBPMfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:35:09 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF54564A3;
        Thu, 16 Feb 2023 04:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676550908; x=1708086908;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RvzoyO3S9d8UpnXYoHO0L1aMhWxzZ4vaqKE2T4/fPkc=;
  b=KAvz66nSE9SiuSxX3KFYgn0tz1NBNhLgETjF39VDodfCciFnieejB9Om
   qonHjHlPOdt4eF0LYk49h63o33NPskbpqco7Z88fit86QPDDlEEL2hP+6
   yNVbX+u/5ClwxDzOALvM+xdPBt+JsYmLbNgkAkTOwWDGvD9kqbF5rOw/w
   4chFnU/SGHeKXtZqnoukcg0/HXrfAaMefLggJGZ+S0LxoW1fzPPLkh82j
   L2cLik5r9B+qW1wV0fQSpLmiQNnNSGlimor6daPRaLCkUzZdmNDu4cNzX
   JtW8tkOYSLegxumobVxkE2qbsSehSEzt0jR+TNQpTudWO83iTN5eAI3eh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="319767052"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="319767052"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 04:35:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="999019260"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="999019260"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 16 Feb 2023 04:35:07 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 04:35:06 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 04:35:06 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 04:35:06 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 04:35:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDBjRxe3F0wceeqgTQHIR2QIOs62A6+tMQk8Mxz14FmccfoYyfWWOK+GW/6p/LzEWd3UxUnuZb0ExNKtuDG2iWEJvq5nfzzVLJesN+Vg3UUHd3MjVY7HCS4ztterM1YM5fGY6TAXsTdKo87gduGKB1rXcy3ccmvj48I/lwaHGIGC55q9vb3xCOyc7y//tjCpAF+GmPwcT5F32DdvEoS3/D6FPQR9bHQakoQzKPd/orv4nB7n7qv+z3Cn7L/0pogPWk99rGHg+ci67g0Df2eUlhwN4XYc8c270u2OMqI4h0uldeTCQUiM/RzlLw2KDTKFlTjcTclRyHw7NOKOze1qdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ujTs6YXEbYjU72+yb6CzvAF+VcQZxj3Nsj7f9ayQWlA=;
 b=R9tXlb+14WVeWvcUm/gL2Z4VJg8WE7hjxlQFipYM6XKG5etlB95PLPnqSJVeqAi19T59qDcO3Aem03KuqXY+3ZMABlV8ySwFkAEr1A5ijdzZIAL+qGEaLB+J8hWobeYNtJdGsktayDxSS8WjavdqCXU3QnY1eg7M2//aCwkQp+t1cWymOzOOaNC/S6tbI4r2ixa1jbDRUGqjEXV3ySeQU/ZsyPpk4qYKP/UDUnsL5ov3AmJRcXp204PYUdq/9+1rJqgLeohQ4bd7i+fSF2hRGuIHzztZrfcrj3pjHE6iMSeTOFl4js7kp98YyNJgavvq5xH64USsnCeAqzpy3TAfSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by PH8PR11MB6658.namprd11.prod.outlook.com (2603:10b6:510:1c1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 12:35:04 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9%7]) with mapi id 15.20.6111.013; Thu, 16 Feb 2023
 12:35:04 +0000
Date:   Thu, 16 Feb 2023 13:16:41 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        <brouer@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>,
        <martin.lau@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <alexandr.lobakin@intel.com>, <xdp-hints@xdp-project.net>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next V1] xdp: bpf_xdp_metadata use
 NODEV for no device support
Message-ID: <Y+4eqeqeagWbWCMl@lincoln>
References: <167645577609.1860229.12489295285473044895.stgit@firesoul>
 <Y+z9/Wg7RZ3wJ8LZ@lincoln>
 <c9be8991-1186-ef0f-449c-f2dd5046ca02@intel.com>
 <836540e1-6f8c-cbef-5415-c9ebc55d94d6@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <836540e1-6f8c-cbef-5415-c9ebc55d94d6@redhat.com>
X-ClientProxiedBy: FR3P281CA0137.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::11) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|PH8PR11MB6658:EE_
X-MS-Office365-Filtering-Correlation-Id: e79984cf-7111-4071-01d4-08db101a3a59
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: flO3KzR6km6FuQaoPf4zElGW4bGPEkX5HUzgXqcsPnP6pdqaUeBTGIzLn04fqzzAgFKwMm8eoIzWiR3P20pwxjG8xkUcb0IDIKGSE7+QXmDFypgdrRU8/0Wv/fD9L664T5GJgLrnVvTGWqGviI/YSpCXhWapbqhGydwOBqnrDwl+ORFujyRqhgYnxJxAj2ruJJmDJTTxY20Gn7BFn+6bnstYZ70Y4OldVPBpjVefUYofQVBpN47EeB+wnv9lowk0aq4yyoFuuP9cb38ccmKMkZ2KXQrnrMyLBYVqgVtXCjYlLj8h9n3jecqFSYWzP+kk5mZdi/Y257SZtxRDMwptD7WiAreWMa5CJtIqRIvI2ZcgZtlPQTMHzXzISerivlYA8Z9wnZ8YvhD1L1THn/DSZk43PfltEFk8j2A/eP5irosT3eBnhyCW2F3Rdc4imfermZI57+MXJMChocLTXg2cpA+tfO3W0bunPvkIvo09K4qeCzMq5ZyWH9soFB345f5ck5Lbf7ZS0mib5v/yl1mAM8axOyPeKJruVxpyQ7Y3vBgr5ucqEWmt9Pv4HR5IBjNHjaVNyGCKyMxnlFRo4ZXRklOS4DexziEW8iDKjyo6nXIMBYY+UHdypAbzC4uov0f5VVK7jcCLuDsUbVs/8QA3heBtw30c101jrZ9syjBfaQBFZc6Y94Ll7RRxWTWW1+P4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199018)(6916009)(4326008)(66556008)(66946007)(66476007)(8676002)(6512007)(9686003)(6666004)(186003)(26005)(6506007)(83380400001)(86362001)(33716001)(316002)(6486002)(478600001)(54906003)(38100700002)(82960400001)(44832011)(5660300002)(66899018)(2906002)(41300700001)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F8ypXfyq6aE5UJ+cU5LAgkqnTdmm0edjBTNGRxRL/pCM1H83xLidedNtMsuR?=
 =?us-ascii?Q?HWSsJlAWIG2ZRH2IWwEoe7+a55307vg0XYHAhf6MKR/mdK44pWNmfcq5D2SX?=
 =?us-ascii?Q?yDVOJR81D/h8Lwtv/fg8MIKLMW5QpuVzw0aHoMiSOS7DcnNv3QBHMnXdjCQh?=
 =?us-ascii?Q?G6VLruXr0t+v7Q5NmBlurMWBcnY2WCtpWqfd8kfUUWjVqU8lutglQOLdpY5k?=
 =?us-ascii?Q?kRcpVXY8awO9EkvbQoh9T1QufGLSDi9G9XjMZVQTkl1zZN70KJrjoPeI4D83?=
 =?us-ascii?Q?/ONH7UXvQAYrHfdmv5Blkor7Hl7EHwueYO8YupTri4obOIODTrnWCst5lXAw?=
 =?us-ascii?Q?3H7hb1A8Cp4+KQbYvbsC+BubayoNbL1pceR5Gg3E2yMdKHuqxynISKuG3mPj?=
 =?us-ascii?Q?a5u6Tu6GXaINXTt/Ovhzy3Oj9/3csUv1q+pYNppN5ZGSrRzi6O2B+QI2GIX1?=
 =?us-ascii?Q?42Uc6r+EMXN3yAEczKye4n96nNDW7pRTrmye2cVeF4oY7PtQT+dhcFy+M+zm?=
 =?us-ascii?Q?tn5qHRfX8XnvNVxFG3QYr1EVvc/WHO0AroRlcdNwVihKd6wt8eXrHCpK0zgX?=
 =?us-ascii?Q?FMER13zmY0Wr5wh753t/DOiPhhGpI0NR8TjMU+MtEDDL7szyru77xAzJ82mV?=
 =?us-ascii?Q?pHuS/USTLHSfE5/FsyC9MJsVhqV+2Xddjm9cIa5NgCRd+30yO77AyYUfkR1a?=
 =?us-ascii?Q?KLov3laBb0mW6qhHd/hDlhRyyZET5GgFPgTz7+dUweT5ajxdNCUR+N06wrE7?=
 =?us-ascii?Q?EssppFMOK1RfO7acrIbJLLhVx2RzuPXfaYn9ngWHdvRHAeNxEcwT8xabjYnv?=
 =?us-ascii?Q?K5wBUl4angwmT5gbm1S1kNfaQLHVKnnzH4fvb1J2FKZ1pc5WJDxdWkSnIzXN?=
 =?us-ascii?Q?lkmTPk17Z+VEhK/9Wt1SnCw6o0pVdGV7tyT/hKPF+FaSEIg+fFPJ2WVCHPjh?=
 =?us-ascii?Q?J/5llPfqYtFkvs0TZ5r08WRcbcfXulqI5Qvc20UeaVSb8pr0uV8xcB/Y1DRa?=
 =?us-ascii?Q?+zlhEUhiWRJ3cPHjDdcM+k/1yQkjtTw2RsZyyHctTBFbxxSJxzOO3EV1gsOU?=
 =?us-ascii?Q?/OvyeFtLT9pvj8e50mGsEq/4FoIyFnoF5mX0kGqxBkme89tgFIK6ErQm2XJT?=
 =?us-ascii?Q?C3R+gFQ+1grHV8JwUINbpgYXy7xHNfHJzgRydm4EVhdOjo5pmzKac+70/7I6?=
 =?us-ascii?Q?YPHvlXcrPZ23JnIhwmlr95s2fN7W+Wi/YW+7Rh3UtBES8SAjHhsiDzvsWFsC?=
 =?us-ascii?Q?Lz/HNfInltbRPY1GT02DPpq9OdMWSRVlqkw8sxR1s7Fd6ZHgA1U5kAMOO6/x?=
 =?us-ascii?Q?AdI6BNOWsBI8uwDQ1snkEak/6e9aTqiuLU5Uv6IsfF3xqK/L6oDAEH6gOzY2?=
 =?us-ascii?Q?Cu/Jpv3HLbBykiOc15dFlZS+P5RZ7wQcyxqY4Epdl+BleTlztoxdAu4fOq+4?=
 =?us-ascii?Q?Tu2KQAOcp7rydddKfrLXDX/9t/DyDLZWaj44ALei4Leo323Dvko5L6Wo7WCD?=
 =?us-ascii?Q?EC43apg7cJb8qzDzqI32sUZsVPdii6ZtT5v7Ro89CT+LZ4C/20lD8L8P94AM?=
 =?us-ascii?Q?iuQC+pwbiZsp1n1yNn2zGlYyyfA1+H39fCRTyfPWyjbAmJ4gaZ1VRJrEWzmg?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e79984cf-7111-4071-01d4-08db101a3a59
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 12:35:04.1359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgngFR085Nj516hWimo4yrzsbkhYbovuHzKvOtu2AUxYW9kR0v/y7K9c9IKBSUIq304RGxMlC1TWeyxTbQMpfoKuEnzhDmNzEiqQFdQIUhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6658
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

On Wed, Feb 15, 2023 at 06:50:10PM +0100, Jesper Dangaard Brouer wrote:
> 
> On 15/02/2023 18.11, Alexander Lobakin wrote:
> > From: Zaremba, Larysa <larysa.zaremba@intel.com>
> > Date: Wed, 15 Feb 2023 16:45:18 +0100
> > 
> > > On Wed, Feb 15, 2023 at 11:09:36AM +0100, Jesper Dangaard Brouer wrote:
> > > > With our XDP-hints kfunc approach, where individual drivers overload the
> > > > default implementation, it can be hard for API users to determine
> > > > whether or not the current device driver have this kfunc available.
> > > > 
> > > > Change the default implementations to use an errno (ENODEV), that
> > > > drivers shouldn't return, to make it possible for BPF runtime to
> > > > determine if bpf kfunc for xdp metadata isn't implemented by driver.
> > > 
> > > I think it diverts ENODEV usage from its original purpose too much.
> 
> Can you suggest a errno that is a better fit?

EOPNOTSUPP fits just fine.

> 
> > > Maybe providing information in dmesg would be a better solution?
> 
> IMHO we really don't want to print any information in this code path, as
> this is being executed as part of the BPF-prog. This will lead to
> unfortunate latency issues.  Also considering the packet rates this need
> to operate at.

I meant printing messages at bpf program load time...
When driver functions are patched-in, you have all the information you may need 
to inform user, if the default implementation for a particular function is used 
instead.

> 
> > 
> > +1, -%ENODEV shouldn't be used here. It stands for "no device", for
> > example the driver probing core doesn't treat it as an error or that
> > something is not supported (rather than there's no device installed
> > in a slot / on a bus etc.).
> > 
> 
> I wanted to choose something that isn't natural for a device driver
> developer to choose as a return code.  I choose the "no device", because
> the "device" driver doesn't implement this.
> 
> The important part is help ourselves (and support) to reliably determine
> if a device driver implements this kfunc or not. I'm not married to the
> specific errno.
> 
> I hit this issue myself, when developing these kfuncs for igc.  I was
> constantly loading and unloading the driver while developing this. And
> my kfunc would return -EOPNOTSUPP in some cases, and I couldn't
> understand why my code changes was not working, but in reality I was
> hitting the default kfunc implementation as it wasn't the correct
> version of the driver I had loaded.  It would in practice have save me
> time while developing...
> 
> Please suggest a better errno if the color is important to you.
> 
> > > 
> > > > 
> > > > This is intended to ease supporting and troubleshooting setups. E.g.
> > > > when users on mailing list report -19 (ENODEV) as an error, then we can
> > > > immediately tell them their kernel is too old.
> > > 
> > > Do you mean driver being too old, not kernel?
> 
> Sure I guess, I do mean the driver version.
> 
> I guess you are thinking in the lines of Intel customers compiling Intel
> out-of-tree kernel modules, this will also be practical and ease
> troubleshooting for Intel support teams.
> 
> > > > 
> > > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > > ---
> > [...]
> > 
> > Thanks,
> > Olek
> > 
> 
