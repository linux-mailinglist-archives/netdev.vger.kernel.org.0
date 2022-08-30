Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC745A6B1A
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 19:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiH3Rqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 13:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiH3RqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 13:46:14 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20631.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66DF1123B5
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 10:42:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNi2qSNYDqSGWu8BfdPYvSXIGlKcNQLBhGOI0rT7dh1sWPYlzyxngh9c/bRQISp8tfGaRgg+GPmWwF5lb7gSKiu+jBRfPRqAQe67XF8PWpPbK0/BYdz+qbRqsmpoLZphM/WgCuGQQTAexxTVOXeW9G5HbTyqgzKhk/6ID/e/Ca2m+nVZPAkow2rCPUjFj5f57Vycki7eIEjO1m3x+jhHv7tu6OiGabq2Pmoe8O1hvX3PpbMKWOc4jUNc3VRaa6SFW6vGhPP86VTD4H3E0/MY69h3Hn6/ABfeB53JM/EaNxCgjB8vMLZDJZXkQgt1x+zIioc/L5EK4/qKQCRCXTLEig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDaRwUUVDDjIR7SybbDYqRdqs4VWXlhSgAxEpjv/ZTU=;
 b=WF+utVcfSmzw8MhrlIpUAbYp0Dm5jVwmNWWM0j0/5RGVI/nVTwb6RIZbDL9E7tEp0W0WIU7vW+9hnVUjJRql2ZfpHnChO2TKLBRuOBsE/kXzZG7ejrh1w2msX0EYSzhVAevO3EUXofUmQIY4M4XpF/tlPzDICuO4MnVqlSzkDAeHSn8GVDY6Q0eq6+CArIeT3iE4wIkCnjtzU/IAVTtdKSSOUwE84dOEU+4Qi6g9lSosAzwHBjIs07g//Imcd1tV4HIQpPNZ/p3uoeFOVgbW6MI/tiOTvrztzqCHW+e9Itaw1q1vR+EJs8BMf2fu9RitN3F5s1CSX666TWbCwwdGZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDaRwUUVDDjIR7SybbDYqRdqs4VWXlhSgAxEpjv/ZTU=;
 b=KATA9DvNAEGjCXMck9Gc7jXGBUFdeIB5TTPnEVgFmWwwDvSx23uYcBRFGo+38kMLMfchWAnBaRIuJa0WU6jT0ZMQ+PQOKvHWz7XnpNRpKI/Q5h4sEdRIJ+vln8JVLxGaL4h8MOA8+RW/OgtkEhGl6uO3Wb2SxY8tJIhXkHTAE/nMk0sIMc9oXg/CxmyA5wwfzj6pv9SMOB4qM/zWoQ4HPpD5uUSswA/ccCR+YGnYW8OKfeJt8Pz7k6FTu2b4+OAp7dY4TwkV/j26SeemBiZNlbzTZa5iQegjJqIE0JeK4BttLJ8rmS052t2YlWv/oFZ2VLph9Xr6XoUjyZzdX/3/3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5475.namprd12.prod.outlook.com (2603:10b6:5:354::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 30 Aug
 2022 17:36:53 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 17:36:53 +0000
Date:   Tue, 30 Aug 2022 14:36:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next v3 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <Yw5KtJ+vOoi+qSM6@nvidia.com>
References: <cover.1661260787.git.leonro@nvidia.com>
 <20220825143610.4f13f730@kernel.org>
 <YwhnsWtzwC/wLq1i@unreal>
 <20220826164522.33bfe68c@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826164522.33bfe68c@kernel.org>
X-ClientProxiedBy: MN2PR22CA0004.namprd22.prod.outlook.com
 (2603:10b6:208:238::9) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0586477-33a0-4beb-dda8-08da8aae3a1c
X-MS-TrafficTypeDiagnostic: CO6PR12MB5475:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OC6nMkYSyGr96ky9VLoHTDHotda6Y0DefVl/cninq/rDN9Z6PVZ7WWmS7E+U5zvLCHpyG+6i1Te2+7ULrG1y50m2iLrJS/YCb6yGRMzZ7GVvidpjAnac5oTgPKOJNrOHJlt9Y0tI11VXENZ94GoQZ4Nursy/JZ19y9bqMPLLFXNaQEyUm++KTyWZlxo3kr6YBuoAMaOtAj/pObIUck4ktXBluMP5Iotx7lnwvASviUHjSbcjnCOHB2znbdls0NEDtkhxmjQFc8mm3v9Fx5SD1UPgNX2hVvM0NCDftQNmc3FYAMqJxXrHZYA/oBOvDHm5UqVDKe4/MO9oqUeOrxHTXazCVAUp7cqqs8KM45pPSDzRLybkMrhQiWer5OpLN5aM9z7Z/uCsgTRmup1kIKY1JaYvoEMDZlB6XBCKJ6R7OYQa2U9AaVmfL4zizDixrDZ2k/bOdSRoQ+SKUeEyCgm9x3LMaZrQ23N6EQT+hMfhZX63gUnTYEy11+wuy4heRwjEmKGrTuQpVE0L44fG6ol9lWo0+F1ElRENehdZKKLilC6SzaXYn6MzNr8xSC9AeuXfwUpsoLDqmMRpC5MbIfwEyv88y998tGI8w3nY5l0he2ZDUq3j7Wuh3NNSkR+1+cYzYjdrU93hDqnJCOBm4Yxh9/3MpcJn68WyIOLE20jSTyRgXfrqlcXGj2DVUAlZL7Hr+1UP3GuKol8aMmlHl/ZY1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(66556008)(66476007)(8676002)(4326008)(66946007)(478600001)(186003)(41300700001)(5660300002)(6506007)(107886003)(2906002)(6512007)(2616005)(26005)(8936002)(86362001)(36756003)(6486002)(316002)(54906003)(6916009)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d/6h/XCEUujE2guEASiJpIhX+Nemq5+YpoeF6uwveNixDMmQZYJ93e4bxQxn?=
 =?us-ascii?Q?pSUOrWjhL6w7NSbNFsAyHvEBkoEtyYH5qabXbc6P/D0i179JspFZrWkxvTFh?=
 =?us-ascii?Q?x0OJku+Sgo4EKDGcMwuR+aZ77YsYGOGdPLVXOLBWuIWfyOwmJ7Qg+GhS+kM6?=
 =?us-ascii?Q?OCBrpSCWdwhxAPagdThttKCW3c+jd8hE7OJY8NFiz97xNmmV3+zrrr3562mO?=
 =?us-ascii?Q?uLuzJ1gfrUvMDcFy/4uivBj6xFsM6Mnk2i0MNJ3bX/TBJnQeX7ruEuRfkXAA?=
 =?us-ascii?Q?MCArGKQIHQClrTYh/lCaRIzkGoM1Bk1n/9RNftGJspwS8reBUflxCPlOpIW7?=
 =?us-ascii?Q?t3G0SUesF8sGewYLxENfpFA0Mzh5nx0rkeVXSZaXr3FWHj4t/eSgNwMtrkHF?=
 =?us-ascii?Q?hZKAJ33PSrVPVzw5daLTMp8TksM1Fqmaye3/yPaKNpZZvQLYqpMhgZr12WQF?=
 =?us-ascii?Q?ekzAX534V0JpZHc/fECjtMp3ywVChYBt6AdTbz22yPBtugALgMstun6dbUY8?=
 =?us-ascii?Q?MIWwUFj0DtYsytBU9q0+SoVKbZFuBqU9aKmM9zsoOdEOX/SPJCNOMoLlm2HY?=
 =?us-ascii?Q?1t7zfXF6NfoRC/VcIxKd1apVm7IwNQjH15t6YIs82UhVnRxMFG11le4y0OM2?=
 =?us-ascii?Q?hYFEvFCsEYovASerwOf6TfLqKuh6reIa1p6FWDCULLGzjD4FJAKHg/ccLMcM?=
 =?us-ascii?Q?j/Pv0G/zFFyTgBlqOSdqzDNev0q7oYhpQlUhvPEND0oR6tmgLQFeAwnLZ/zy?=
 =?us-ascii?Q?GkYzIpikQULCjg5OkfK48pmbmJgZTUIxdUg3iwR9S7C8Y7l5joX7Qi/1WQHY?=
 =?us-ascii?Q?mtbXrDNCfknOqiDEi3YnjCpUzLs+NXOdLu/BZ9x8a6GfAeyC51ZygrjA1jzH?=
 =?us-ascii?Q?ffotQw6ShlnieDIckGG0N7BOyRBpn0iKgVVzWZnPjZEJWwyaLlNy1OfPp0Nh?=
 =?us-ascii?Q?1F3GurEgBxzRqG5lIm/MbpFyeDdgoCoWI6npIoFbNBmmp5wcwQOrWwNrRF8f?=
 =?us-ascii?Q?2YWCqGhG03NU2WDACzYLBbicAkhBkE98ggeiuZVcTK6yQLEQuded5kkiopuV?=
 =?us-ascii?Q?bmz12UGQSpXPnULaXwQdCpVXBi66Fv99Vfxa9yuBjwIWtvOAE1QTMWoTLrC/?=
 =?us-ascii?Q?+WlCIh3GP95qyMygZ/fBDD2iIs1sFXujaq6L2XxUQ1fSWGlvXiOAK4kYzOwI?=
 =?us-ascii?Q?0CQRVujdlGLqcs2nu/v4x35VG8UHGTuz9rOYom6CBKfMfC48nY0nO3Ld8ZnM?=
 =?us-ascii?Q?VmzY/d/jCYlAqetHMG8DY8lnzKX9ZGDZ+u1hZ53j8T6DIis8hGGEE5sFqMw0?=
 =?us-ascii?Q?SLO0pA29/aB//GRYknP/EpFVBrL9qAD6J9NwOTEGH9s5JIAxo9kI40vzdzUO?=
 =?us-ascii?Q?FFa3WbCGsEWu10JYWPD56s+52JJ7Xb4AfvBRh2bwA4Ao8LD/0tze9UY7cuiM?=
 =?us-ascii?Q?Y9gcxu8/K2Z77kClnUs0QQLw0ZKJcablqEZM3jdila965MLfrci1KWq0WJlB?=
 =?us-ascii?Q?Htvgs4996DNJAZp5dclWSl9L7KcvJ0HeNanM/0rkccr99Wg+6q+g7P4Ree9Q?=
 =?us-ascii?Q?GaZz+lOkFs/4JAdgEljDIiMzkMkYCOCTTdN6qIcV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0586477-33a0-4beb-dda8-08da8aae3a1c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 17:36:53.2758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0j9VD4zPP+xwpbuC5o9aPhB3YXVb6ux8g/jANQGvv1twrVgqxdScDu943tSYlmSk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5475
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 04:45:22PM -0700, Jakub Kicinski wrote:

> > # Add TC rules
> > tc filter add dev $PF0 parent ffff: protocol 802.1q chain 0 flower vlan_id 10 vlan_ethtype 802.1q cvlan_id 5 action vlan pop action vlan pop  action mirred egress redirect dev $VF0_REP
> > tc filter add dev $VF0_REP parent ffff: protocol all chain 0 flower action vlan push protocol 802.1q id 5 action vlan push protocol 802.1q id 10 action mirred egress redirect dev $PF0
> > tc filter show dev $PF0 ingress
> > ----------------------------------------------------------------------------------------------------
> > 
> > We also don't offload anything related to routing as we can't
> > differentiate between local traffic.
> 
> Yeah, nah, that's not what I'm asking for.
> I said forwarding, not sending traffic thru a different virtual
> interface. The TC rules must forward from or two the IPSec ifc.
> 
> That was the use case Jason mentioned.

I was meaning rather generically handling the packets in the
hypervisor side without involving the CPU. 

We have customers deploying many different models for this in their
hypervisor, including a significant deployment using a model like the
above. 

It achieves a kind of connectivity to a VM with 0 hypervisor CPU
involvement with the vlan push/pop done in HW.

We other use-models, like the offloaded OVS switching model you are
alluding to, that is Leon has as a followup.

Jason
