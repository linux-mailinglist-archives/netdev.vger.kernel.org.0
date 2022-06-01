Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3635F539AF0
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 03:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349028AbiFABsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 21:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiFABsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 21:48:35 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2138.outbound.protection.outlook.com [40.107.237.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496C1DF8D
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 18:48:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrHc5BZ6lk93ra8ItH+EFBPkmqdM4fTLWWSBIDrCeThpOREW9txZAS97xDzt/yVFunvsNB09ncf0ZznNRvbB5YR1M6yQD+QBelFUDF2bXOLwqWgHkwpahyTUASpA2b+vnz5A3I0Cnx5FHRz2itOCwO4J/4cRBEalpetFrBnMIpGGxVx6CpOrmR1+8yHPG2F6Y1Lkbxucy5BloTLEWM7Y+158k1EpTyriSAbhC482Ngg13h/+TriU+lFWCNxTFdJRt9/RhGSl9MoJAIUQiAEv5aYNfro8N66I6gaY5VQfaxKk2JMhNPbnuUmATmwl2zz7iEc068lOtaxkn9gxIRhrQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yW59vAM+5FhnE3gazuwfajauig5yg3mqfzXk5OinGYU=;
 b=XaEIOpslUm5xK3ZG8Ab7nivqE8e8KpKp1Wc5dAjNhwXR/icBDIvcBoajzROB5JFOTdipelJrpAFuRB7AAueN4VJn738oeYeQTRnRW0PRqjqjPciOvZ97krTut3ixNmjBUq0GNRueU1zZEx1fRZ8ofAXyYVvTTp73cG2YlLJ/yois5Lkn/K/JC2M/ah2+I0Xd3hcC/fSansQKyuHt/RsQtYL6zLVFMpjRLF7WYTNftLceWxSSkv/X0ASnSBjLv7fvScn2Wmnrwd/SaT80AGsLNFIeFOcyxJLRNhWABe66eiWR3Fq764mIGdOpXecV0jG7jEbPGbpVg+iGO3aPs7qFEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yW59vAM+5FhnE3gazuwfajauig5yg3mqfzXk5OinGYU=;
 b=juf0Ywc2dPKj1JsPK9rkZpmdaFkXP8xEptWm6PjdnjMDrpEKewGoSg83zV2xjs13TpduaetTAtxCH6l76WoxkQQw1QZ7kF68JGdeANUfMGwteAPDwg27w5+9TLSv6pUQ+FFJABgyjWEnUi2Purb9OBlnPYhWV7V8Dt1t7i5jbRc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by SJ0PR13MB5335.namprd13.prod.outlook.com (2603:10b6:a03:3d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.9; Wed, 1 Jun
 2022 01:48:32 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::51ba:4bbc:6170:1405]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::51ba:4bbc:6170:1405%5]) with mapi id 15.20.5314.012; Wed, 1 Jun 2022
 01:48:32 +0000
Date:   Wed, 1 Jun 2022 09:48:25 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net] nfp: correct the output of `ethtool --show-fec
 <intf>`
Message-ID: <20220601014825.GA10961@nj-rack01-04.nji.corigine.com>
References: <20220530084842.21258-1-simon.horman@corigine.com>
 <20220530213232.332b5dff@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530213232.332b5dff@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: HK0PR01CA0050.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::14) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1db7586-936d-49b4-747f-08da4370d51a
X-MS-TrafficTypeDiagnostic: SJ0PR13MB5335:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR13MB53351C00AFE01A8A5C9E096DFCDF9@SJ0PR13MB5335.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ic9prighf0skttzDJrDABlZbQ96uNGiksd2IqgkHMrEIFUD24tCoeguNf8r4gKSzNWDshiUlRv/dOnqIN9KUgjbPXHhyGg7jnYDScRhZJ1mNKvtikhNM7rf3ESfjNX+u2VnyuzgXgpoH8SHNkD1UfTlRDILwVfYokWqwuWCUdIXBDygzY8e+vlxN74gVz3dBsxqO5RLKIwunrDf3k9GAJEkzauO7NKx7eIiXK6ffKJUcfBbdjw364JKIW7JEvsbIUTlq7D6Yvm3aRD/tjLN+ySnVGz5BTqlzP7mwsWxxghovFj/HBXY9EICWyUdzfenYj7OKfwLAWFBbLSfa9AmyVImzyf+2EUJQZeRO7aQ4KVbk+bypgZAOi+xP2ELsOnGkiuvbDzB3q0qJLYpdgmxByEzNFApVjb1+Pm1OXM/pUYufjibpf4uCezt5qoN2bBPQ1/d362kjrlapSMpPzKT7vFXLLb2ZO82NQi89MiGcp1ZEoZea6UrHblY5ZErOh8uSrBxKtFLPp+JUtDiAeMlXVOsfByhSN6kTH+INLl1B8wVMga/1Etv9LOPmlBBKt2y28s0pRgVnfm6k9njDDLNdM2KPL+IPnellXvly87GI3SFjOcFf7wjsdwgLzz2jMHlltmLUtTx/nxM+6leP4K/kgTDsDzASqhpGhGq6srsC5UzkXLFrSYclFzM5aBFEF1APnfV6KJ1WCIy03uvUTw5MAeLgW/ONOWnGZelmg6js5fo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(396003)(346002)(39830400003)(366004)(376002)(54906003)(6916009)(316002)(33656002)(4326008)(6506007)(41300700001)(8676002)(186003)(38350700002)(38100700002)(66476007)(66946007)(26005)(6486002)(2906002)(66556008)(6512007)(83380400001)(6666004)(107886003)(5660300002)(8936002)(508600001)(1076003)(52116002)(86362001)(44832011)(81973001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LPrL8EzvMLXQ5RtNPx38YJDVY1RDvLM53rB9o4wq1riiklWTTjkhK8rJrtmQ?=
 =?us-ascii?Q?Jw0caK/sfcxqGnbxFE+m/HClGwapKoxoMYnCfI382yxa+5JKMvRXWWxWx2KP?=
 =?us-ascii?Q?D/R86/3BQtyBzohZXCfqZlLE9aNL1iBdqQdgTIzpydvi9FFjWDpMT7DnkdcZ?=
 =?us-ascii?Q?hFxWjdahtXlhvSL4iwlNwfWwLV2MOHHNaT3+bCClt57tY8iMvEIudl0uxSvm?=
 =?us-ascii?Q?haGuB2WHjA0MfFi5ZY2+r1VLKfQImjnYRGPEVJmqEOBK2PFXmEG30VIYzPnZ?=
 =?us-ascii?Q?e550jXGjSw9HG3dxqOsnv5SOFResMq3Ug2c6+h/gUO4uzpT9IFBvgfbwMm8a?=
 =?us-ascii?Q?5lInG9e5jWda1gtOZ+Wx/garapHLOXsATM+QDQIICR4TaDhOsqXSEzRTCnS2?=
 =?us-ascii?Q?yUEe3wfj2ws/7uT50XINd9rYeXPOQBQkYAQSywFVJQ3lc0a84S1vRHv4RYVd?=
 =?us-ascii?Q?GUNZ40KbtJXZmdph8TaMbIE3x9sNkqH8nTA1KqtQdTeZl3djyvRqNqBccj+l?=
 =?us-ascii?Q?BXXEhQsGeSnT61z+tGZQ2bjr/hp2vOeB4q4/+b9H7S0sqL1r3IzHk5LjfJSy?=
 =?us-ascii?Q?zp/k8J+E9ZPVs1no+R9uR8Zp36krY7SwTfWBE913GvMe4pIFumnY5fI4fJgq?=
 =?us-ascii?Q?P7QXiskzs5yAv3UCnu5qgFK5Ah+zS4SlUXSAjX+H5BIQPuN5qzaKW/p8Wqi6?=
 =?us-ascii?Q?Ww0ObdBauPq2ZL7n/6H9rZUG2n007uSH0ICumFrneGipGh1aTua7Kyr7ZUbV?=
 =?us-ascii?Q?Kkw7tNNi4DorjCbdWWhdN64QIxFrdvVs3MjwMun+X4kqOVIBGwFvCBH1mSBy?=
 =?us-ascii?Q?r2wPljX7HDb30pqSfnWng3XrUC0Y1lSYJnTXuILjFOehUKa71dWOa4D9/ryr?=
 =?us-ascii?Q?9qSzH79pzFqaolhO/lm3Umm/vYKwHBfXhN+o4nLxwz32T990fmZlBVwM9QcA?=
 =?us-ascii?Q?E64prwRHlru0tk/BpdmeprjLBdLk860UdeqhCOfF+bDLER3f3xI183IMnzIT?=
 =?us-ascii?Q?3ejUoTZLuO60P3VvZohFucOtg+6y1feu8O0q1P4anSJPeKwl4kStnTUF4Pyy?=
 =?us-ascii?Q?oU7yRxC++mp2a+4kbRJDhYq6WEzrIdpXZKgGXgO+WGxwnoeeQzGMAEowLzzl?=
 =?us-ascii?Q?N9gNVXKZ7/Q3Cf7aFCOp3CjF/O7PymUUwV8ANLHkP1kAZFFo4PIvWzrNMEoB?=
 =?us-ascii?Q?x1n54SMYgUSfVCs1PTsegxQzcobP3gmuwsdN9ndk6nym4JMgBVRKojP//8rx?=
 =?us-ascii?Q?4d81pc6kCjgerXF/r4/tW+U05xQ9rgUvghhzXUHvuWjjsYT39CwNMgqlonvc?=
 =?us-ascii?Q?7Iw9GKicr68PSqRUwOnHtW5nAEH8g0UrXAwQT8/V0QLu4b/AQ1/Wdpn8r9rA?=
 =?us-ascii?Q?l0RoEaBM8aelYxKONQ8ztNh/0io5VHxkh5W+I1c4juRksGj37vQzRqka29XP?=
 =?us-ascii?Q?6sUF7fXdyvM5YisACM24bA6GPq0M9DQDV2mcetHbxysqIZ86RqavdkiKGuLT?=
 =?us-ascii?Q?IJ9MoDstiIzPMrEVP+a55E4ALvxx6p/Xrl1XsYDY1ddf+8P2hzTBLoKZ9HSj?=
 =?us-ascii?Q?B0ubX98Kp9qxhOvOU3CGE04xWjDyMO4dzXiVvhIxWsvZIaLNDMVmayaTMATP?=
 =?us-ascii?Q?REp9lLrDBb38KhjKdPhi9yzRyHoeF1jdItbFhWLv7UU4EM0sgBvTdec9rKtm?=
 =?us-ascii?Q?k1YX7MR58jHNDXMHhhT1JJpxf87tJ1wm2CwfNTGieg1ot82Qwk3VAuXqIqMp?=
 =?us-ascii?Q?ZuaERznxWO8otESHKYozxNY43eSBtgg=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1db7586-936d-49b4-747f-08da4370d51a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 01:48:31.8431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wvuBCKiVCDLKhO3Iz0G7HOh3/KdV+pdRh8mFrk5xrAtjMuzcORkNYplMCvuY4VaBWDjSF/oCGljPVM3plUU5qDNlTpXOZcRUBoeEnaeA9Tg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5335
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 09:32:32PM -0700, Jakub Kicinski wrote:
> On Mon, 30 May 2022 10:48:42 +0200 Simon Horman wrote:
> > The output  of `Configured FEC encodings` should display user
> > configured/requested value,
> 
> That stands to reason, but when I checked what all drivers do 7 out 
> of 10 upstream drivers at the time used it to report supported modes.

It seems you're right. I agree it's OK that nfp driver keep the same with
majority drivers' implementations.

> At which point it may be better to change the text in ethtool user
> space that try to change the meaning of the field..

To adapt to both implementations, "Supported/Configured FEC encodings"
would be a compromise I think.

> 
> > rather than the NIC supported modes list.
> > 
> > Before this patch, the output is:
> >  # ethtool --show-fec <intf>
> >  FEC parameters for <intf>:
> >  Configured FEC encodings: Auto Off RS BaseR
> >  Active FEC encoding: None
> > 
> > With this patch, the corrected output is:
> >  # ethtool --show-fec <intf>
> >  FEC parameters for <intf>:
> >  Configured FEC encodings: Auto
> >  Active FEC encoding: None
> 
