Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D726DC743
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 15:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjDJN2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 09:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjDJN2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 09:28:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02634C09;
        Mon, 10 Apr 2023 06:28:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5CMXYAahcmLtbGkN6NC68Kq2HWGz2mas1aKs2S0B761edGfvxcUZ6KXMMEja/it7ofWd/O6UbFldERuJHOt2VbAjeDTuYCY7ZkIZx/uR7LOa5jphMkO8fFaXzG/83CJicRoKQzF5Nq/XjT7uCKs/PBfR/9IaWuuD6dGN/rvQX1j/qnPd1rgYrqXUpZtXE7xa/BwanZ+VVG5zU0vK03B4eYbHWY1M4JXUcKGlZyVrWjOQU1G5xYgbwVeCJS7OCT/CY2H+KSmPPr+LQ/uMfPgnundOvm+yQE2TQFic75XP+ezkvdkb0Id1VXM5nlRhgg09hp+nfNiEcq1KPl8CLQsXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BTMhTtqnrah3DGOvecTgLGOovC4bMlSySs/iGtTLnIY=;
 b=biJKIOnC6JbIopC8H/wjAT5jG/mcF5LsCgGbvpHG1adGbz0FrY7FWZRtPwPDg0hO4ZvrUk/T26hZwzms/jISJdNATbrYM3w2QnfSFWnibBxSoKyqUdwl1g4gi1JjdKsId2qrcKNSjt2v7OBO/7w5EmGYgpxjfpK9dz61BLGsVtZv1ONq/aELpUYcjFO+xbhudkkPExp8H+/nkvtN7ZE+xlwlm/SvWPn544MyVvtXxDuK1e2a+U07RYRv18fjt2En0bauQY6rgdO64lpbnJdkWQC1WPlKvsXQSSbHmsuo8CwLe0L+FAkAT//jAeX0R7IFIVWOgDGywpM/zaDeni8xCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTMhTtqnrah3DGOvecTgLGOovC4bMlSySs/iGtTLnIY=;
 b=FVr/fx5fMYnChRtTLt/w+W2coXdn42RP1k/thPvBIEDNpPJC4LBEAplvZTSj5aYR65hjdnM4z3438GW7jLak+6YCcqVPkben2NGKrn1xnLUb6dTw4oZWCLEoqTmjUDO3W9yuzr/R8Ra9lLWdvf7sNTxnhCvSS9dXaSy3y6ZtuMs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4481.namprd13.prod.outlook.com (2603:10b6:208:1c9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 13:28:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 13:28:09 +0000
Date:   Mon, 10 Apr 2023 15:28:01 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvell.com,
        edumazet@google.com, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, maxtram95@gmail.com,
        corbet@lwn.net
Subject: Re: [net-next Patch v8 5/6] octeontx2-pf: Add support for HTB offload
Message-ID: <ZDQO4RhUmUC6w6Hr@corigine.com>
References: <20230410084223.5325-1-hkelam@marvell.com>
 <20230410084223.5325-6-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410084223.5325-6-hkelam@marvell.com>
X-ClientProxiedBy: AS4P189CA0023.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: d5624ab5-1e2c-48de-1aa9-08db39c76cde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QgHU8AguoAGmw5lTajMibOhVr8OhGS17p0sxBAhUNqu25ex4cM0r2zIm3wm8c1a7rFAaMqeLm56fsXIk8n8kcB0LPigBqvS2yR/tVr0fY+fwuEMv5VCbuoNJQovkZWQ2C+uwN3PiPvm3ivifU61G9vR34GG3/HnJzXCXbWab8Od3cCy/WQGvONaLvjhSTB1Bs7m+6jhRv8icNb6AlCZG2jvHLviNh7UQLtEkEjlrqeLMz0nvhrWLrY4ZrhvAMzui4OmJOop/phCGp30ByIucswZk0HT2020rV987IwB5Ipj69DEFk+6EEj5GlFAQqde2p7YxabgkBbqthCWMtCN+7t17gv3NKPlQA+PpOi2tNK2NOE0a6HbwU74bLIWLs0HYGJgcj3Wrow+K2m9S7D1Dsy6XuikpLPFv4Se6YOrB4u9IPZxguHXr1srJgfoFlPcmL+Vi4whPc8yNF21NarUE7pYpLhJ3R8xwb7AGxZb8/BGkx8pNT7teqBaO33pLbFVm9db/gzqeEdPZURQpK302nlNoRqZCLfiABzB0YVa9ItU65FP648HVdjBb52Ri0USh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(366004)(39830400003)(451199021)(86362001)(36756003)(316002)(41300700001)(8676002)(66556008)(6916009)(4326008)(6486002)(478600001)(66946007)(66476007)(5660300002)(7416002)(44832011)(2906002)(8936002)(38100700002)(186003)(6666004)(6506007)(6512007)(2616005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?myfgQYwSpiea6VfAuCxNxc8Uj4BUdaUKziHpFLrmAhKxxHB5wc79ljyl0/pV?=
 =?us-ascii?Q?LukowUN9Jm8r5dBOtg/Uc7OCfQ+HZPf+im/f/3MgGjgErYuIspnMp9zTpV3c?=
 =?us-ascii?Q?scABi+Ycwg6xWuc473BCkvXyqBb6YBx7JkrNuFhDPkjhUu9JMnxz3/boEY7C?=
 =?us-ascii?Q?Hmy7ovt/8gBGok9NIKfc54WIMUq49Pk5cGuiwoFMJMCJCSGKmbqBdTR7+SaE?=
 =?us-ascii?Q?UNuMADrKiYyeFkkin11O4nDXDFyGG8di+GH39rC5A6FjNnnRAkpVzd/8/2X3?=
 =?us-ascii?Q?vHC8AI+XYr5TsIKeozybWtsl2GDXl9ygHppfzP32j2lf7VLol2lq2xhQQGc+?=
 =?us-ascii?Q?q9lE5wbWjfBDMtySH1jDuTYf4NBYUhx/E6GNaACfhfzMNWkQz7iQgUONsAp9?=
 =?us-ascii?Q?PRzFBiG+p0Qx6TCGcxalwh4pTsp6YdzwLK0XgmeJlRkT45ujMIKXA6lm/Mt5?=
 =?us-ascii?Q?t1YurtTqnEVsH2ysFiZl4WOwfs6ir1EgRT/cQl/KWHkbdErUYjSb487FdLp8?=
 =?us-ascii?Q?Hr6Od9LbmTeP7wRWqlq440HZit5pZNKec4AbB3CWTYPDl1idjtDwaSuDQKqY?=
 =?us-ascii?Q?TCH6PFVg277XuDPmxH8gobyXuVstdVELz2/mYmFdaV1KP4MTplZEIeqs1hDl?=
 =?us-ascii?Q?pEQ3Q5/lnzz0cgGNUpEIDfIDQzv4T7z0qNL5zX1erheOkc2sYgLejc5noou7?=
 =?us-ascii?Q?wqirpPDd1DiPGbXnKwaTFRKZvuj+goDA/oZgqq/Z5cbGhKRfoXSV1yp2AkTl?=
 =?us-ascii?Q?cqmeVC8p/Rj7pBwmtvOZk7YdblFLh5QMt0ZEkABq1q8m00dZtk4A7RV39vhk?=
 =?us-ascii?Q?sywdB/yJV1FZJuao1BmM0h/w1Sqf/t856iwHYjE2i6TuiKYTo4uoU0qoRCVO?=
 =?us-ascii?Q?axnJ1DRRvRpbrPTKr77kjACJrsC7DprW1w+Qcjpau9C0UN89MKTkfP/JJdSF?=
 =?us-ascii?Q?LmTH3PdFHkxQcH7MBkqFVtMKtu3uwSE9a5BexBrk43J2gW9OZm4HReEmOM7r?=
 =?us-ascii?Q?mHOb+jnPXyXF0Imw9j8niTMBogT3NcaSUxBxPcUn8ISNjOWt/Hfwn/4GbW+z?=
 =?us-ascii?Q?uUeE11Fmp5tTVySqggDD6Xn0mr7lF0b2w/uekiAXJgMj1GiKDF4J9uN+4ADy?=
 =?us-ascii?Q?3c9Iscvplx2S2ErkUtwcfayYwEkVrIEiP+xynsALbL3gTLG6Wf2RdffuP+o5?=
 =?us-ascii?Q?XJotjXgDkW12j/t/ZfJG2tQhYcXHPbmDLsyfFh0Wn7ob8r04PJeQzMArqrV4?=
 =?us-ascii?Q?ZVBAsTswNVIX1wB49GRUdsvK5n+p3t/SLrOENmMV/kvOU5xQiZCgIZHMYRO+?=
 =?us-ascii?Q?ZB9m0rXtSLn069HEVOrXvHzbZ0kuaxWekYDhpdRk32cJP6asAOiwdazqkIrL?=
 =?us-ascii?Q?zBqd3PF0rVLEQ+UI7Mu1RthsHQyf/2G1IRrdvz3vhbcJVVzC3LI40JMjLTeU?=
 =?us-ascii?Q?cP8/RzJ+wEAgrcOf6kUGHLLpM3StjktFSIp7DOIFbAN70u0eBor2XNgAvXhT?=
 =?us-ascii?Q?6YBep10hdJcu9pHXkqcdZNYaOkSuUgtktwc7U3HQe8hKVGWvsJBcNJUptyYQ?=
 =?us-ascii?Q?qUDZK2RPwKRpsgyLOl/liVDWmteghF7Wxo7V2J6tpXTYzSUC5q8H69waiD9c?=
 =?us-ascii?Q?TIGiOlRRysgoQvzVpk/bhFLspmy02Ti/y4ae3jza2bRAaSXaQ9+Pc3pnHd1P?=
 =?us-ascii?Q?T/C2bg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5624ab5-1e2c-48de-1aa9-08db39c76cde
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 13:28:09.4168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JoDhcO3iKjUrhbdteujf5VEYT5VZPcif7GASC4NfFI3qWBuDjmtZMeYXo8S7LaKE6p8D1glaZJPzzEzcUdval3RxeBpQg1+gfUlCAEnN2tM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4481
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 02:12:22PM +0530, Hariprasad Kelam wrote:
> From: Naveen Mamindlapalli <naveenm@marvell.com>
> 
> This patch registers callbacks to support HTB offload.
> 
> Below are features supported,
> 
> - supports traffic shaping on the given class by honoring rate and ceil
> configuration.
> 
> - supports traffic scheduling,  which prioritizes different types of
> traffic based on strict priority values.
> 
> - supports the creation of leaf to inner classes such that parent node
> rate limits apply to all child nodes.
> 
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> +static int otx2_qos_txschq_alloc(struct otx2_nic *pfvf,
> +				 struct otx2_qos_cfg *cfg)
> +{
> +	struct nix_txsch_alloc_req *req;
> +	struct nix_txsch_alloc_rsp *rsp;
> +	struct mbox *mbox = &pfvf->mbox;
> +	int lvl, rc, schq;
> +
> +	mutex_lock(&mbox->lock);
> +	req = otx2_mbox_alloc_msg_nix_txsch_alloc(&pfvf->mbox);
> +	if (!req) {
> +		mutex_unlock(&mbox->lock);
> +		return -ENOMEM;
> +	}
> +
> +	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
> +		req->schq[lvl] = cfg->schq[lvl];
> +		req->schq_contig[lvl] = cfg->schq_contig[lvl];
> +	}
> +
> +	rc = otx2_sync_mbox_msg(&pfvf->mbox);
> +	if (rc) {
> +		mutex_unlock(&mbox->lock);
> +		return rc;
> +	}
> +
> +	rsp = (struct nix_txsch_alloc_rsp *)
> +	      otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);

I think you need to check if otx2_mbox_get_rsp returned an error here.

Smatch reported this as:

drivers/net/ethernet/marvell/octeontx2/nic/qos.c:719 otx2_qos_txschq_alloc() error: 'rsp' dereferencing possible ERR_PTR()


> +
> +	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
> +		for (schq = 0; schq < rsp->schq_contig[lvl]; schq++) {
> +			cfg->schq_contig_list[lvl][schq] =
> +				rsp->schq_contig_list[lvl][schq];
> +		}
> +	}
