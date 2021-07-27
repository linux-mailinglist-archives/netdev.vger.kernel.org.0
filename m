Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920A23D7584
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhG0NEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:04:35 -0400
Received: from mail-mw2nam12on2122.outbound.protection.outlook.com ([40.107.244.122]:63584
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232067AbhG0NEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:04:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKyFfriMVzga1J0Pg3GYFaKzPz5kRJh04Bk7QV3ASjYaqtnGTYqyiFBfWLLlsUAma44ETmdMZxaFTcx0fi3GKHHUMY9TiIeBzJALmV/+mQcRY4uXHEQPQY6kIMViDld8b0BvXVigeEgQkrU77qJytHzOxyXpfEqMFp69qT+B7xfg2l63sigSMVD/2o3dancBkd8XopuxGQmcX44pt3pwdsB/zsAc/4xKauuvt2bEbAzm8cUkgglZiBgbmlkifnapOT+kdKeSl5P6ps8fvMXc7IMER82CCBBH60tNCFjHORxEOOshilPKZBe9ZXdIMlxSU3SFyVRDvZwfNgAvp32aIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWK2wOcF2vGWjK1/Anp+2JYU2/XUd+sinhMe+Y/ulwg=;
 b=aWJIvpbQmfhI1pAND3KXkrhjxFfwqMYs8VrBy+mnokouN5VVb/Lo7C1taKEcxkh37e4B7SkDhlJPzuyJBWIambnq5jW5PGi0Mgf/zc426Nf3j94JTITewJPv0XKOrDB8HUFSjSzbSIdyZ2upgoSs629n6SmsTxblR59nt+C5AxmvlMRlV+4EXsZSeIixGQiGLfQoqirxtZb7PU6+6kGtvljNC3vHEgIxNuAj6s4+FNI8rHh0c83H9JzkybcxN5G/0saKozdt5YxeikyDp+edK79h3nY8Vu9KhY5gsxxDb4mviNmQmAN37f22Dry6VriqmOX86JqcbCpDN50ct+rqvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWK2wOcF2vGWjK1/Anp+2JYU2/XUd+sinhMe+Y/ulwg=;
 b=j6YgRQpXrbu2SLwjsDpqiT2NW5Uv2cgrtp9Od9xRO3OBBLmfjCgQezEEvWpOOojIyqtreWj9D29B1cLAz5EHzJwk9FgagaFbIgyPdGDDqJcldG51uor/PifnHeOn4F+PngAUfo+Fc1qHnri/XLW+D2hfVCWELBxVMaASo/OjGn0=
Authentication-Results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4825.namprd13.prod.outlook.com (2603:10b6:510:99::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9; Tue, 27 Jul
 2021 13:04:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.018; Tue, 27 Jul 2021
 13:04:30 +0000
Date:   Tue, 27 Jul 2021 15:04:23 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
Message-ID: <20210727130419.GA6665@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR04CA0139.eurprd04.prod.outlook.com
 (2603:10a6:208:55::44) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR04CA0139.eurprd04.prod.outlook.com (2603:10a6:208:55::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Tue, 27 Jul 2021 13:04:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f099b62-0582-4180-cadc-08d950ff1237
X-MS-TrafficTypeDiagnostic: PH0PR13MB4825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48257D39B6B2F72330CB4656E8E99@PH0PR13MB4825.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBMq16BxqiRorNEhzam/+RMopGT817nAiUNdDHCh/Vd8XlKkjm54TYbW+K94uT1LGL6L3YGBBxWON1cIN0CkCNhcPvhdvmu4BhyLW3VYrqh+3BiMCsN5jMXV4LtxYAuwh8TqkK6RmLWVp7Kb0LAZfeoERgJ1oCWA3kwe2ha5IpoSAqoLF/h7I+abKcKkjqmBLwyoS+JgUZSwC9dmVIw0lAORRg9jj974YQkq2KCPLDI5vVlplsUi3KZUxGbCArmefS0F49NJChFDCfB19Q3XOEgN98B6MTs6xAXCxp0qAvccM/o4BgigxM8OQi0vUi/Z/JShk9+nZHNVojUOZbZnlpeJPzK6/y/AoVmrBh/jIq/27Dzrh4XEoI0CPAjIg/IzZ/m71MNqeNK+S6hifo/e244+CoirJ/vJsNl0DPqIde4te3tx9wffsuL+LGd7HdvOfMEky+ZAikD0Y3E7Wv51m9mMsggXKF7RwY8U+W65ovNpd/1cta27yLF59pAbu9yO8Nz1SsUK/OikpuG0NCq2zgZyJyxGItYXQphU+sN37eaamtKLn0G4vLYj3RNZgMN8Kdkw6bHzVTQEaokiTumS4vnm8FddaipBLRTTYgbesGQzGOsTauDsph6GQd+j8ms3tWRiO60S3FJ+Iyi3RJGckg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(136003)(376002)(396003)(346002)(366004)(83380400001)(53546011)(7696005)(52116002)(8936002)(54906003)(36756003)(6666004)(186003)(55016002)(1076003)(33656002)(8676002)(8886007)(478600001)(6916009)(107886003)(86362001)(5660300002)(44832011)(2616005)(4326008)(66556008)(66476007)(66946007)(2906002)(38100700002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QVyefDHNhE0D5iPDV6+zoPVBW2Fl+JsjQcG18mFi1fHwt/jQ/NMxLCHCWNrY?=
 =?us-ascii?Q?KV+hCmljUoR+cBP0sIL9jtbYwisVxzz+sCBTKBOiceElIUz1nDpTBiulmebd?=
 =?us-ascii?Q?bVOcr3gSr8mEuJkDwB1qXebBgUs3i+Y+S94XycnJVCntnecg2SEzpk9dL5rW?=
 =?us-ascii?Q?E/b7pO1Ai/NMC81p0QIuPEnrRFTm/IZo5U4k3GsAJ8pudxqjImC/ZlcyL8xu?=
 =?us-ascii?Q?Sabjx7DEdi+3DHkxn6NYrLgPVJs6C1RKuAcWFaP1TSc9XZ6aHrkZwkuwKw7/?=
 =?us-ascii?Q?Wi/WoA/kGGsa8sJPfKTP3lZ5ncT2Y68H1kXoiu/9dt5Rfox6iyVo3T5urnfE?=
 =?us-ascii?Q?73oQdjRV+CQxR5WzXWk9QtBQFVxBe4ZQZYWPFXMv7eK2nvNKv+CjN7s81wOB?=
 =?us-ascii?Q?LWWZX28Im4EMF4HL2F4Agn3mi9N6WMDQGy0oRoPYD/fO+oUlANkk7bZWdT6a?=
 =?us-ascii?Q?a43WQfhtj+1KVK1Ts+/5i5ukT1NKYvSXyCsdwlXqNPwFe8cLTsIDwfsrvofK?=
 =?us-ascii?Q?BQ7+DjPNI85qB0hjC+eyINJRIbEyoorS2nXYMPJ3oSHmVUgaHxXrStu9an2y?=
 =?us-ascii?Q?+kmEJZQ9vGcmNvusG66u+hAKDMQHPN21g1fuQw7okuI1HeLHoqdQMgjnPw93?=
 =?us-ascii?Q?kTTpoRx0R6jNzwtkcrtz2F8Q7CtIXrfgpziwrks08+UBW1PHYKAP07E/IHho?=
 =?us-ascii?Q?JVaJEWw00hFTp0vySVv+5XL1W9KNVuqlvPlgDQO5BqjnWSwv2sQDgP/F/wRo?=
 =?us-ascii?Q?7eyX70g0UzuTzCYXHWBnDylW6lE8O6xLnaBabOzrwnrlta1fADMiI6NpKCb5?=
 =?us-ascii?Q?uCYMBm8Zzpbk4nnIrWVHTgRe2Qwnx7ewD5gqpgs9F8xG7dDsDJKNuTszrbD5?=
 =?us-ascii?Q?ifJLQaMeuvkvKosbattK2eZXWxns0qPr7wydhBQAvZbRDTpxEj72awy90X3/?=
 =?us-ascii?Q?y2pZmqawI8RoKKovu+ROa5hnzFX2XzK0gw9tFEWMfyPStePXPcBqLPb3Go+z?=
 =?us-ascii?Q?FQzX6b7xnjT3hX274DncUH2x3Qi7r69IMSg42RS1S+LouAk7NHvkkYAqxH7y?=
 =?us-ascii?Q?txFXxpQF1w6+Pw3cm63xg9H7yB1S6J2HNDpr5hpqPIPWYYptJOuDnpV0ehN5?=
 =?us-ascii?Q?+3cTUmhEErWoG4N4O1zMlkYjXr0Xo1u3nPLutw22CXfosaELOKv56w9RhhuA?=
 =?us-ascii?Q?CpFq/BRywZuoYC/k1RbF7MlSACqIMpYZMghrD0UWZ0ydaEX1TpqIqaS3LA2S?=
 =?us-ascii?Q?nZvYu86h0LxZY7dyRhlMSzeQMjy/y1re9xqFWMQJJvndD8xB7KXydHam2nCP?=
 =?us-ascii?Q?d9dzjDOOmBDcY9UemZwZUEYEqLfGTi97MDpwn+nDtx2TjAU/arzdBlz6yXbB?=
 =?us-ascii?Q?uBmfFZ9Y+PeX1Fj8AoPf4PckgIgx?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f099b62-0582-4180-cadc-08d950ff1237
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 13:04:30.3727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aLPSCiK1MXnim0jY+tOUm9KmTRfpAMXhH9EhsE5ptfI2shqAuqHWNQost4s8JwHSx+5ABGv4ueaTNh4gqGFktwQNTFd2fEzw2UYF47YcEL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 09:33:09AM -0400, Jamal Hadi Salim wrote:
> On 2021-07-22 9:29 a.m., Vlad Buslov wrote:
> > On Thu 22 Jul 2021 at 12:19, Simon Horman <simon.horman@corigine.com> wrote:
> > > From: Baowen Zheng <baowen.zheng@corigine.com>
> > > 
> > > Use flow_indr_dev_register/flow_indr_dev_setup_offload to
> > > offload tc action.
> > > 
> > > We offload the tc action mainly for ovs meter configuration.
> > > Make some basic changes for different vendors to return EOPNOTSUPP.
> > > 
> > > We need to call tc_cleanup_flow_action to clean up tc action entry since
> > > in tc_setup_action, some actions may hold dev refcnt, especially the mirror
> > > action.
> > > 
> > > As per review from the RFC, the kernel test robot will fail to run, so
> > > we add CONFIG_NET_CLS_ACT control for the action offload.
> > > 
> > > Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> > > Signed-off-by: Louis Peens <louis.peens@corigine.com>
> > > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > > ---
> > >   drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
> > >   .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  3 ++
> 
> > >   			    void *data,
> > >   			    void (*cleanup)(struct flow_block_cb *block_cb))
> > >   {
> > > +	if (!netdev)
> > > +		return -EOPNOTSUPP;
> > > +
> > >   	switch (type) {
> > >   	case TC_SETUP_BLOCK:
> > >   		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
> > > diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> 
> [..]
> 
> > > +	/* offload actions to hardware if possible */
> > > +	tcf_action_offload_cmd(actions, extack);
> > > +
> > 
> > I think this has already been suggested for RFC, but some sort of
> > visibility for offload status of action would be extremely welcome.
> > Perhaps "IN_HW" flag and counter, similar to what we have for offloaded
> > filters.
> > 
> 
> Also showing a tc command line in the cover letter on how one would
> ask for a specific action to be offloaded.

In practice actions are offloaded when a flow using them is offloaded.
So I think we need to consider what the meaning of IN_HW is.

Is it that:

* The driver (and potentially hardware, though not in our current
  implementation) has accepted the action for offload;
* That a classifier that uses the action has bee offloaded;
* Or something else?

With regards to a counter, I'm not quite sure what this would be:

* The number of devices where the action has been offloaded (which ties
  into the question of what we mean by IN_HW)
* The number of offloaded classifier instances using the action
* Something else

Regarding a flag to control offload:

* For classifiers (at least the flower classifier) there is the skip_sw and
  skip_hw flags, which allow control of placement of a classifier in SW and
  HW.
* We could add similar flags for actions, which at least in my
  world view would have the net-effect of controlling which classifiers can
  be added to sw and hw - f.e. a classifier that uses an action marked
  skip_hw could not be added to HW.
* Doing so would add some extra complexity and its not immediately apparent
  to me what the use-case would be given that there are already flags for
  classifiers.
