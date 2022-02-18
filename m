Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9660A4BB7A7
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbiBRLGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:06:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbiBRLGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:06:30 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2128.outbound.protection.outlook.com [40.107.236.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778ED2944C3;
        Fri, 18 Feb 2022 03:06:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OR0E/mbywTGPjm+p5ePON/rmg6O78ZVUYfv1uH2lwEQcmNyESyRm9Su5fLh8L0PsaHDCSOnBm9xxEHBo/qQQKL1gGSN8VlPwmCfZgKaM5kJGDGgqZxbI98842WerVIuEwMu9S5/z2nN7SuN+O4ZofyLiWjiGqw87gOtrmF7N3aYqnR0MWBPUYXqFhlYdd8nKnlR1NPzqObquwFBaEbl6bsTIDDHDGIsgCylJhhq8VzA0kqtxkqRx2S8K7HptS+oG02w9vNOn9w0DI/MWJi8KIb0AMTVTLLzzHRg/mPnrAQotjSasOsIua3+aG7rMtK79LVBDCn5EYj4j+kPx5en51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=66/tlBI3aCMI1kp69LuF5mR8A/4A9CcLrPauqJWNts0=;
 b=IfU5cSz3jI2Vum0uAXSPemk97oXkuowg3u6LhG87WvhLGMFIS8evCfQfDvPxojnoRo5sLbjVlFyoWcNDmQcM5g6Kzk7cgRjaDwOv8xQbvKFPI1p82qYnLa2EOMrqgGPDtUNlQojemxl9MNsx4LNBF9ZbkNTcdXvyjvjJwreZOAp8OxMDoh/6+mizchYWpwswZT4K2xrUBE4RX1E05hCKiV8nfiaW6Mf7kymViJKuZgVJNtxXbW8sRBk1J63BlUGx3hzYO4R1TPGJBZVuAbVRFNE+LSL5cuyudXJgMoTmlpVDvcFZtWjmGzfryke84SaLfVNOqtGH0yC+nW4IYiMKAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66/tlBI3aCMI1kp69LuF5mR8A/4A9CcLrPauqJWNts0=;
 b=bPN1oeT5OIBFN3MdSMu9pKYNmoloPGhW4m18jhV7v9XJZD5scIaXdbm9OdZOS95LCpBgoDPV3zLxliUs/Smy2fyEK26vks96hTHZywS/Lrc4WQOEV7aK73VfaDaG+FL2uWu7PHymfgPmnm5D8L2e0BsFtWIq/dczRoM+X32N56k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5232.namprd13.prod.outlook.com (2603:10b6:408:15b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.6; Fri, 18 Feb
 2022 11:06:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 11:06:10 +0000
Date:   Fri, 18 Feb 2022 12:06:03 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] nfp: flower: Fix a potential leak in
 nfp_tunnel_add_shared_mac()
Message-ID: <20220218110603.GB29654@corigine.com>
References: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
 <20220211165356.1927a81b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220217075940.GA4665@corigine.com>
 <01035905-61f5-da02-36d5-92831e1da184@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <01035905-61f5-da02-36d5-92831e1da184@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR06CA0118.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c6f16fe-f99c-4b48-ba15-08d9f2ceab30
X-MS-TrafficTypeDiagnostic: BN0PR13MB5232:EE_
X-Microsoft-Antispam-PRVS: <BN0PR13MB5232D5E398F151B1B3A525FAE8379@BN0PR13MB5232.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+9hiyGFWIGJMMW8A0XnN9NsLvKfoW41o6eQO/1A4DMJmirXpivk7c+9GKb1Tbo4fZ2qFDvQRpiK/GsF3+GRACoZIOQAmycZEXAt8mgCoJYsXhkpl1O7R0A49V8Zf82y24bn2vGkFIGTKm3UJ1TTADQGlWIpDN5e9rNcdgXebPxKzY7uPqXsfZqZln1B8xt5wUBUuYwsokqzWNPTR6SKXiBVBiePMitdpuLyTa+SSHFkhMMoI6fBtb/U6SRZ1ZclW87YmV4jqUXHaWiVmjtiJVAWZXDrFmcfeNxpPuW/c5XOlXYY5BhRGYBPz6yEXn6sPwFgNm+cPldcnvyY006s/WxFbaZ0lL9QGELZ6VUP35DrLRLm65PbybZl4uS0OLpJuYRSvbWzfDFnGkgAvTP0Df64ETN9EFklX/6TuExvldN1OuhG12sp42PFllBtnnsjCxLVzpH7qE+mwIcRzQH/DKymxsELjrK0FRQe6/Tx+/nBzShK+8fs0Q3T7av/Sf8vtiamKpi0zWeNU6lk7rArHj/ruJlb3ocy3z6hJT5qXoKDNXzaRNocI1pADrCqMV1QFURysvmZoZpikGmOx60LKC9G4v3LhMCLva3q/25uDyADK9qGcZkYjLPk5igBJSWC2rRE9GYHLeaDMTxjrsL/Hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(136003)(376002)(396003)(39830400003)(66574015)(6486002)(33656002)(66476007)(6666004)(6506007)(6512007)(52116002)(2906002)(83380400001)(1076003)(2616005)(316002)(508600001)(186003)(6916009)(5660300002)(66556008)(66946007)(86362001)(8676002)(8936002)(4326008)(38100700002)(54906003)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2xYL3Fja3BhbUhGWXlQMjZuWGd4Qk9keThacWo3d2lLTmo2NGhSaExUTlN0?=
 =?utf-8?B?U2lpdTVZSmVYempNemw5TERiUjhTenFsZ056OC9ZOGVhOUkxQjRCczVIaFR5?=
 =?utf-8?B?UTVrbG8wQ2xsb3hNeW15V3FoRWt6TFRzMEtuNmRscFdHNHdTN3NHWG03bTdJ?=
 =?utf-8?B?T29NdW13VUNXalE2bGExejY5UGhDNkEwYzNWZldiRFpQNW5FbENlUWlGZjVX?=
 =?utf-8?B?TE9xT0Iyc0s1RFZ5UUEveUZKbkdCc3FabCt2b2xtTUlVREVrMnlXT1dJbEN3?=
 =?utf-8?B?NGd2dXFHQkdFMzAyN2VuSW41cnRYcDAvcWNpbjRBbWwvNFBPWTZOSG5PVkxJ?=
 =?utf-8?B?eUhVdmJWOUY4Rm05ZmZYU3N6YmQzaTZuQmFQa1drNnIxSUpnMmNuRUczVjcx?=
 =?utf-8?B?Z0RUOXNUSTR0U3NXbWlSNlgxVmF6NzJVQThXR1hIS2llbXlyUUZMNTkzOHpp?=
 =?utf-8?B?bUJmblBUVStXZUZQWUtNajhZSXpxa2hYNCsxSllURVF2UVAyc2JHOHZ4ZGFp?=
 =?utf-8?B?VmVGNTYzNE1IZS8xOHdQbEVPd0wyUWI1Q2NBU1hhcFFFSGZ0UEQraU85WXFY?=
 =?utf-8?B?M08xWlBQdnlqMGhlMFc1dVRJbDdDaUwxdU9Hc095amw1NnVEc3NYcVpkVmhn?=
 =?utf-8?B?c1RiMDE2TXFQRSs2dXduZms2ekhsME94ZnRheFBlVHBUYjhlL2RVeTRmZllm?=
 =?utf-8?B?TWdUYkw5Z3U5UHhQVXhLaGR2bk5VcXFzOEMwMEd4Q0RGTzg2MFV3dUxQNGxj?=
 =?utf-8?B?c2hZekY0N3RhWUc1elA2L0tUeG14bjd3enRXVmZlRHNJZlZtSExHcTljbHhR?=
 =?utf-8?B?M0RTbWhFOVRUbWVldE9RNmYxZmpmUVNvRnhmUlJOTGNleCtQZWxxcGlDSFVm?=
 =?utf-8?B?elQwMDRITFpRYWxDSTFwRGE3eTRrY0hOdTFZSlk4amUrNGhQa0pTd1lScTU5?=
 =?utf-8?B?V2JRQ1B5MmRzMUNjaUZNUXkrNWYxSm8yVE1HckFUcUtic1FaOE4zUlRNTzRx?=
 =?utf-8?B?NWpGOFh3Vkxka0pwYmJmQUtyQmNRVjJMNWJEUXdNVWlnVzZDOXdUb1ZmeWdM?=
 =?utf-8?B?cFpCZjhuOVMwUTdwNW9qeUlwQ3dhUjVxc29OY25wQTRZOEd2bHhveklkR050?=
 =?utf-8?B?anB5VUR1c1RaY3NjWDNBcVVRWGRGcXdSMU9yZGFac2JuWGlCWi9ZTnVkcEZW?=
 =?utf-8?B?aFdyVGkraE40LzVkUFVuZC9MVkdUbHlRZzFXNHQ4V0VhTk8wMXdRU1g1cm5I?=
 =?utf-8?B?VEtlcGJBRWtRaG5MeXVOd1ZyNHhnZ0ZBTXBtTTExM0ZxRG95MGF2UUxwbmVn?=
 =?utf-8?B?c2hKeUxtakdPNlFqRTNLanBpTU5MOFFTN1RnbnVsaU1rNU1naml5UmJwakp1?=
 =?utf-8?B?QnVOZkVXQU5IWHdrVlBldllTcHR5RVRMRmRXdkd5cGhCU2JoTWx0dE1BR3Fl?=
 =?utf-8?B?Tjl1WjFlZmUrVG8vMGJhV0dQT1luaVpUQXFhRmwzclUycEY2UEF2Ry9rQktY?=
 =?utf-8?B?M2NsbzNvVHJodytkVlk5ZVMvT002VUc3V2FqQnFPdHE3elF1MHBIWU4waDZx?=
 =?utf-8?B?Y00zK3dDZXc3QjJCSU1oL0RyZ1lETG4zVGhoUVBPZ3ExREs0aWVDNlRHM0E1?=
 =?utf-8?B?dG1DLzNTT2N1ZFlZcGNtcUhvWWVRaGF5eGtqK2NZRUtsVHBrOExwdDltalZ6?=
 =?utf-8?B?UGcyb0Q2bmlzVVpxZVBPUlltUHRoTmhvc21XcUJCQ293YjdQYmRZMGNoL1ZR?=
 =?utf-8?B?Q1Q5N053WHpiUWpLTzdYcVNVY2hjTVRZY3RIa2NCWW12a0FHY2FMTFRWcy83?=
 =?utf-8?B?ZXh4ZXNzRTV1a1Z1dlRGNzJzS0xLeU9PTHdvOVF2OER6TmZlVnVoSXhVUEJN?=
 =?utf-8?B?ZnE5U09OREFKVWczNXduQmJ5eVFwM0xhUFdQcHpOWWVuU3NBejZkcURQSXU0?=
 =?utf-8?B?UVVtbnRpa2VLc0NzdUM4MllQYUswV2dRekVNTUdHY2pTZ3pDZThhdE5rRXhM?=
 =?utf-8?B?MjVNWlJuSVZrQTllNTBaSkx5VEoxb1VEQytBa0pzUzN1ZFpMU1VCOUJrZXdZ?=
 =?utf-8?B?R2J4MWRQRGFxdDhxaFcrY2V4Sy9HNlR1cjVqUnNXSlo0VDM1OElyd2k5OFZL?=
 =?utf-8?B?azRLam1FeVVNbi9zZWdKWXRUY1hvSU5TbUM2Y2loejAvLzl2ck9CZ1hYNXJt?=
 =?utf-8?B?K2trZW04dlJPK3NQUUdvNEZwckhQVlBHOHJOQlFoM1cyNXZ5WnV3OWpvNUVs?=
 =?utf-8?B?a04zWFNScHlvMWlzY0hFZG9XUTFOd1ZtSjNWNE5CSTNvLzVtYzhIcVpuUVYx?=
 =?utf-8?B?RGdRSkZuN3FEeHRIRWRGRnZRRVVuWXBaSEpSNnZQSGNWa3J4d0R5Zz09?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c6f16fe-f99c-4b48-ba15-08d9f2ceab30
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 11:06:10.0167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dOEftZzoghK7KQvzh8/fKojvLRN6+ExYgPXJPtDL5rNGGoLHBvXldm7DaNwXD8Ml3q+DFC/9+I9OwT226NzCMRd9wJFWaVSGJdEmQHxD1rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5232
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 07:20:30PM +0100, Christophe JAILLET wrote:
> Le 17/02/2022 à 08:59, Simon Horman a écrit :
> > On Fri, Feb 11, 2022 at 04:53:56PM -0800, Jakub Kicinski wrote:
> > > On Thu, 10 Feb 2022 23:34:52 +0100 Christophe JAILLET wrote:
> > > > ida_simple_get() returns an id between min (0) and max (NFP_MAX_MAC_INDEX)
> > > > inclusive.
> > > > So NFP_MAX_MAC_INDEX (0xff) is a valid id.
> > > > 
> > > > In order for the error handling path to work correctly, the 'invalid'
> > > > value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
> > > > inclusive.
> > > > 
> > > > So set it to -1.
> > > > 
> > > > Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
> > > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > > 
> > > This patch is a fix and the other one is refactoring. They can't be
> > > in the same series because they need to go to different trees. Please
> > > repost the former with [PATCH net] and ~one week later the latter with
> > > [PATCH net-next].
> > 
> > Thanks Jakub.
> > 
> > Christophe, please let me know if you'd like me to handle reposting
> > the patches as described by Jakub.
> > 
> Hi,
> 
> If you can, it's fine for me.
> 
> I must admit that what I consider, as an hobbyist, too much bureaucracy is
> sometimes discouraging.
> 
> I do understand the need for maintainers to have things the way they need,
> but, well, maybe sometimes it is too much.
> 
> In this particular case, maybe patch 1/2 could be applied to net as-is, and
> 2/2 just dropped because not really useful.
> 
> 
> (Just the thoughts of a tired man after a long day at work, don't worry,
> tomorrow, I'll be in a better mood)

Thanks Christophe,

I appreciate your frustration and apologise for my part in it.

I'll work on getting this short series accepted upstream.
