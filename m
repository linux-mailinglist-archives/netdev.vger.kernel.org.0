Return-Path: <netdev+bounces-7674-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B815B721080
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 16:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EF0B281A48
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DBE9C8E8;
	Sat,  3 Jun 2023 14:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA2F8BE8
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 14:40:22 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2131.outbound.protection.outlook.com [40.107.92.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B33C2;
	Sat,  3 Jun 2023 07:40:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgO19ARO/lB94TUk3JD+r5WhwBDO9bnPTy+78mS9veqPSZO7U/h2rbNZzqbfRwmo/PuHkhTDBvJaoxGHPOQi9iBMC3yqIKGs9lWyPf42+1Nb/B0L1kmC5xhOmzoFgs+CUROYVMzX3MWoONeoFXcXQu+2eBiMfasiiNDbP7Zm+YW5IC8FI34gsIP3xsjOjiTF3tM63KVbLi8qhRNQ/vldrtHjQhB5JaKceZI0PSeJGDkWbNBNrrvMEyaC89I8NLaEinn3ef4c9dN9U+mRstsqumzX2VLAQZIFZCePzIfaDY12FMVBDyxlAIAUG8xwj57dWC9i1weYTSb3jKsDDJyiEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ajpH01pX79bEUq2zML0J8hGW1aQ3VJm5ZitYZQAqPR4=;
 b=lAqTmV8t1zmf4xewGq1IvojJz549ufllaqAYAmAariTYKTU2NYe5xrzk70wmgyxttgJIBOFKJFVLc6P1KcEPRunOGDD29OIy6sd12eTI1XSNvfYcMNeMxbPefOB3v5MDu7FQOPim6oxfgA19ATEjoUYIMBZeTNGIgNLPSUB8qncsHtBpEA8JWPNAPev+HDh3003E97ygj1JTCEZ1ChEAUMSlkxVDgnFn7oExI5yjlniT9fnBl96BRcbzjQAsAAPbR4XNpvCsd4zjc/+EfaJda1GbNDceVe2YwVejAXftDOGeCc+77pQLEoMrL1FVgFEhf0uFxE/rDt5zpMW22nJDIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ajpH01pX79bEUq2zML0J8hGW1aQ3VJm5ZitYZQAqPR4=;
 b=cF5u460/vSskrlk/M3ckBWUKn51yAttYOW8vr6RXIyVQaUHJgslExLhZdLKS0KzKFoPdlIGxWCAzUJfsPxLyp2ln5WFYZ0re519yJkGDmt6/BuzVtTrbySD3KE2po50AK9cP7V2rMfcbk2FKEq2i1qqoqWWH/jNZjx5/4YZJjqQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5660.namprd13.prod.outlook.com (2603:10b6:a03:403::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 14:40:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 14:40:16 +0000
Date: Sat, 3 Jun 2023 16:40:09 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shunsuke Mie <mie@igel.co.jp>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/1] vringh: IOMEM support
Message-ID: <ZHtQybyy3qg+xw10@corigine.com>
References: <20230602055211.309960-1-mie@igel.co.jp>
 <20230602055211.309960-2-mie@igel.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602055211.309960-2-mie@igel.co.jp>
X-ClientProxiedBy: AM3PR03CA0063.eurprd03.prod.outlook.com
 (2603:10a6:207:5::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5660:EE_
X-MS-Office365-Filtering-Correlation-Id: 85caa1e9-7654-4c11-9acd-08db64407255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	flwus+b3ysU+YVgkG1XjCiC2NVdjSezG/cgHBjUxkTyQa532CE7W1COmpFXOFiF7uUtUswYzjehBzdm6NEvimHq9mfeYayGJHZq6j6tW277m39MdrWR7BXUf6L2TAFXue5QojyndsMfuKbgS1sJXQXFvO193KS+vjLAMvgMoVaHtTQ/MCFH0oQnjE886NDmLJvXeO8ckN6uZDd7ZKgvUE9lZV6BaffipUCEX3lemQHuZZzb7hYyDgeprRk6U5RKeQFNIo8V2gmhBE+8n+FXB0MLUpFfD2XDOJjpUrfTndNqzljIWbaO4NQt24Rn5HsHlwV881iqmMpVKOL4LM/yowMZDND1oXu7++fp7GfL8wLqSzXerg0zUexRltatmv8BGXl8EAaGutIejRJPzPfsw0WygoKEEBDOurDMRBqjIqJKW6MNHSU8nAk/qU0omnEhmdf/OKhYz6S/ue2wnQRxhNS6SMl4etVg4eA81fbE7rbyxfZ++WBuEkyq1fCU2UVdnzK/z4q242n842S7wWLW3ar1ZSjkqKn0YHp3t9gv2BgWK93TjXy0GfEXd0dJ4A6ymQneBxy57RFLULkKUED0mDmPVnh9GLMywpKkr3J1nPp3RkhJ/W1DDuhqf7lUv50+cuRU9AaFGGyn44E9pu1G9g/ToPF/J0Wq8FWyNdgos7rc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(39830400003)(346002)(136003)(451199021)(41300700001)(316002)(54906003)(44832011)(5660300002)(478600001)(2906002)(66476007)(66556008)(6916009)(66946007)(4326008)(8936002)(8676002)(6666004)(6486002)(86362001)(186003)(36756003)(2616005)(38100700002)(6506007)(6512007)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uOiOhkuROwa2a8ck8yp7C1be1vjN2bjtbhfWLy1Z4XFgtTsMk7CXxrB6CrFY?=
 =?us-ascii?Q?DyFRR6RKsCCo1EDWpobkHOPhMpndwbuoZs1gYedvINquoll2V5ecrVTZlDBf?=
 =?us-ascii?Q?bqXkrBj55xYMd0PC71vBuMOGzX21e20z8Hf3MYvTv2ubMPLjk+RJm9BFswug?=
 =?us-ascii?Q?7MTBBrNnAPoanWPb/SCx0zH5+8ZsWJU6pHV/DkhyRT6pKicXp7sBBqCFzXlx?=
 =?us-ascii?Q?p1jUViVU8D0NUTNXZidYAE8rIfialcrL/OZ0DIBa+GKOKqzdEfAQZTDxR/gn?=
 =?us-ascii?Q?qtCJqhzinw1rG6CnQH2WBs4CqsjOgspSLDT/2RfgokqjrR0Xg+GJ4HQOyUkW?=
 =?us-ascii?Q?oMQSn+FS5ORGeBHZdT8i6fWuIlUsWJerTs7Gh8N2gfgEUKVPeHYMCQFe8A0p?=
 =?us-ascii?Q?U0+Iu3qsvHFH0Kbw4dWgxE/CL5yWY2S3qm38Frr28CQeszIauWCDS9z79M+T?=
 =?us-ascii?Q?foFW1HJt1FC+rk3fwDJzHZQri0Ag76mFgtWcx6vciZ3b0szSlVSrhjhIFCH2?=
 =?us-ascii?Q?sbs+rCrhfIPp8Z1HE/o8ExVlzrmafqVphySfqNfoNqP5TLW0flQF6AtLcYjw?=
 =?us-ascii?Q?RdwCoSdCrlBGIh/YHrf9NeuPZxiQjJkcxaL3MNPWCWQzHCcO1iWI87MQgoR0?=
 =?us-ascii?Q?okbZqzFjJpXHM8XRr+cxklboZciVrWv6qZwAFIyd2PB0oS+W8nInWTfi0Csk?=
 =?us-ascii?Q?/QXSwIEpOIDY3t0qfMj1Ff71Nq51pAWkE0o8Ju2OEV0ZBctoaNddXdw3HAVe?=
 =?us-ascii?Q?pB0FS0T4PkJqMgHzKryGq3hHFpYwZooYnRbk6bGoljmblf7oc6uOA5lNXRdb?=
 =?us-ascii?Q?p103sFyUhPZrmBpHBDP+YAXple5trIMHf2USplg5E+meU2fi4Pur6ZpZeyf3?=
 =?us-ascii?Q?dvJ7XVG4y5uim/OgzmFqnfGQQ3LNm8WUtxhcuBF5K10em2Us2cwY7r6pF5NW?=
 =?us-ascii?Q?AQ3oJ3cPOD+VEa1Cl7iDK3YmKV4SDpwer4hi6fr7LKZKPcrqbW1zZ3/THXU1?=
 =?us-ascii?Q?JnvhRLAsShh3cY4mUg1mg2J8ESx4U9DyBEV8hV9tSDKQbAVl6AIil9yQZV7L?=
 =?us-ascii?Q?/r7vGSP0T1c2CwY3+Ukc0PN8tWah15/5Lc11w8wsMOheaQT/coPyl/bzCkaw?=
 =?us-ascii?Q?0IYSNojbBcQIvAUlic7spckmMfcfrZkcjlEKqzTrbt6zwX9o27P39fbgm85e?=
 =?us-ascii?Q?IXGrN44zXg+RA0Ijgao7TQoHZSX/yLIRBymQNhcfUGBFBe82EFpw6vBTLp7f?=
 =?us-ascii?Q?MXBbRYdij/6+JUm9UtTf7CMoN+Ve6+UPlgVmD/UQ/VsBC+VpQIhI8+LwrL+y?=
 =?us-ascii?Q?Pl+erRDFatZ+HP1nkAIQ1UqJCJcDJpmEVvohwUvi05e4h734jUcRmqAmzr4P?=
 =?us-ascii?Q?zLWSvLriTSYjlFmpc1coVeLdJSf0toW4AYnt/UviYZLRW//ADlQ49Acwe1Pw?=
 =?us-ascii?Q?20w4xX+0tK7rx1nFnvW4w30GhCHI7IFNPn8W9jp9zHcEkBlekZd0hOgZSNa2?=
 =?us-ascii?Q?8YZ0udpYXiWwYTix7gnHjjin6yNDv5knE4xgOhoKSMkj8gN+60nDWS0cZa8b?=
 =?us-ascii?Q?m0uScfYc3aNICWi/jf8b149s2bX+w+ToV4cesJdFT4X1yos0LP8V1vHzQqyR?=
 =?us-ascii?Q?WLu33P4vthbqjJHjmvjMZVZM24V+3r4qJwfXT7OyEhwLSBFOBkVSRfhCWIT3?=
 =?us-ascii?Q?ojze5A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85caa1e9-7654-4c11-9acd-08db64407255
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2023 14:40:16.5005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ErBE/QP3vkZ5UZLscrNSUXnbA/2t8HkNv1Uyuh0iKwop8Jkrf4ui8vOvcsXFpWGhrtaSz+tVYDGHtk1AWkMl0Wx57K8QOhvgfV1j/jM51k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5660
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 02:52:11PM +0900, Shunsuke Mie wrote:
> Introduce a new memory accessor for vringh. It is able to use vringh to
> virtio rings located on io-memory region.
> 
> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>

...

> +/**
> + * vringh_iov_pull_iomem - copy bytes from vring_iov.

Hi Mie-san,

as it looks like there will be a v2,
please consider documenting the vrh parameter here.

> + * @riov: the riov as passed to vringh_getdesc_iomem() (updated as we consume)
> + * @dst: the place to copy.
> + * @len: the maximum length to copy.
> + *
> + * Returns the bytes copied <= len or a negative errno.
> + */
> +ssize_t vringh_iov_pull_iomem(struct vringh *vrh, struct vringh_kiov *riov,
> +			      void *dst, size_t len)
> +{
> +	return vringh_iov_xfer(vrh, riov, dst, len, xfer_from_iomem);
> +}
> +EXPORT_SYMBOL(vringh_iov_pull_iomem);
> +
> +/**
> + * vringh_iov_push_iomem - copy bytes into vring_iov.

And here.

> + * @wiov: the wiov as passed to vringh_getdesc_iomem() (updated as we consume)
> + * @src: the place to copy from.
> + * @len: the maximum length to copy.
> + *
> + * Returns the bytes copied <= len or a negative errno.
> + */
> +ssize_t vringh_iov_push_iomem(struct vringh *vrh, struct vringh_kiov *wiov,
> +			      const void *src, size_t len)
> +{
> +	return vringh_iov_xfer(vrh, wiov, (void *)src, len, xfer_to_iomem);
> +}
> +EXPORT_SYMBOL(vringh_iov_push_iomem);

...

