Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7224B7173
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238371AbiBOOto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:49:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239232AbiBOOth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:49:37 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50ED117CAD
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:46:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPXMaJX/gdQoFcrWvIynlkmuCfP4AvldJRrXeNVBg8SHp38zonM4j8eV3PnI/atbyaOGK/DxiWsz1gwEU54O74QR2jcrhhC0HN2iQOY9AyIoFFCYu7DmJ93ZihCe+a/DVX3cvWTCES+2jwozxLRclEAJ3fe7DQj7PMhNUjQQcllR9qgQUMsn/gKdSNaydPXvXmuQvmk9GRWAI7WNo0oJq3fs05NLRpEB28gfTIfWJHz/0b7oSpTIAEkxqHTvyQR0gJZM7wiJMru2mU7FmkzcHtW4o6DzTAiKZJDFM+ix73z3oNKCVRHK1lZNibD2oyKMrcXJJ37W56xWr0OB0+bbFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/hJ9z0SsAP+GhWeyYS9uh6BXTI9xw604v/QnryJtRs=;
 b=MsgcjPJIvTJPciJbPMTeXKmoO1IeYbMjCwld7V+UbMfW2OQOHlm8oAnyMDpddGzjks/glmZrxFckNpxC8xrqnwydSW0X40JzYdfu8CwziDtcAI2m4J7MHlNrwYPvXF319aOEJxwMHElQfAfPzVeZ9hPf3Lkk90KOF5oWRgMHBEWjsWTkU0KlmbQrrfYfe1sGAhyK1UARbL6DefZ05hNyVNx1dWhARU3wfmojUTGEPGiiNlI7bhrIZX8M973MEU1CJInTiv/OnzU5NQPfx40ctOnGtaiqcI6b9MtGtfqwSDZWmivU0i1UCarEDJu87FItRkI3yw353FAqZRspX4rt+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/hJ9z0SsAP+GhWeyYS9uh6BXTI9xw604v/QnryJtRs=;
 b=gQg1r4B7aIv1fXf3vFVmE9VBk3PXup/BLczn+2yFeQdwChdz5wYmyWwvmOOf817HuxNFVsTPl2RzqX3ji3A6X24RYP8DZ4P+uXzOhI5yLfPEqGaWLpk7WZQkw/i2NdAPeyuOWGl/Hk1NBzT0hY12zeJs3j4rUvtd8RsXGua1XpWHDR82nFiA/Nters+lbgngj1Dj28IITZVGE2Vhtf5JCIWE/P9RCzWQD2mUW+lJ2yPKRKsCAGezBqzTO5h3g1Ad73CAVBj+tgMxZV95CDuKUfj1zB684rtu85X8BJ0WF9Dzb82bM4z2mebm4yOk8Hg34XfwpN6L0NDoHehmMBjytA==
Received: from MW2PR16CA0061.namprd16.prod.outlook.com (2603:10b6:907:1::38)
 by BN8PR12MB3153.namprd12.prod.outlook.com (2603:10b6:408:69::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 15 Feb
 2022 14:46:49 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::7b) by MW2PR16CA0061.outlook.office365.com
 (2603:10b6:907:1::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18 via Frontend
 Transport; Tue, 15 Feb 2022 14:46:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Tue, 15 Feb 2022 14:46:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Feb
 2022 14:46:48 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 15 Feb 2022 06:46:46 -0800
Date:   Tue, 15 Feb 2022 16:46:42 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <jasowang@redhat.com>, <lulu@redhat.com>
Subject: Re: [PATCH v1 4/4] vdpa: Support reading device features
Message-ID: <20220215144642.GD229469@mtl-vdi-166.wap.labs.mlnx>
References: <20220210133115.115967-1-elic@nvidia.com>
 <20220210133115.115967-5-elic@nvidia.com>
 <efaed995-6f11-cd3b-8feb-ea92519c2141@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <efaed995-6f11-cd3b-8feb-ea92519c2141@oracle.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e513d9a-6d04-44d7-a914-08d9f091ff02
X-MS-TrafficTypeDiagnostic: BN8PR12MB3153:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB315338530137574CE22BFC64AB349@BN8PR12MB3153.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lBb/rDEXh2Tlj2ALI1JgVdCL61mo+wliMkOnovjfSzGX0Xh6TiM4cbAE/GTeW4FtBvt1pIxhD+lRxlDMPtetD8NJFl+fX9IUIS+Q0J/1X6kpmUhSsqgNFtIAbpicz4yv4VzTVoeuaFbHtcEcQaJXbk9uTELoOhvvXGel5+HeTgiM+FDVAKCZ42vejZtKA4e3yjuysRtBYcaR2rlKzUpAPpiQhBvO01XNWYeks7uiIvlBfMBbafYB4ZdAwE5hTjwAeFY3q0aOeCnApLESnCHZjgG/ufDbpi2x9mj/Qhxy155wLQH5pDB3ZMADgX2tBOuWcVzcW2tSUdQTmGPfp1nAg16+b7U/YzEx4L+jTVcWdD8e5WCyw3jkEN55Ngt+gczlc0fNWC6Rr67gQgvtwD9Ke44iIkQaXP/mqjBXQXflTnRWWKJo/7YN8NEu1hJB1BMKShoFhx0KqSgOAwQZaccYpisqw4X8uc+KgVm9e8LzPcXTmIP/4fkwwe8EbWASWnNKU6Ur5m+AxZqP+dffquoQKnnjhpfX/L3whtGJPMAwvwszy5sTIw2fmMkeAkTe+nyeCyxboY5z7qLybR8J1cfhx6QcS1VfMvZX8mXvtNlqetua2Pl/Lhk3FjEKOkIp4k2H/S9QyZRemqTpZ8Akmo54D2njUuEuk3QGxbBSB40VitXlGKKg4NZ1iDWypqav6vL4dNvGKaHlGe0C9JQ8CgjViQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(316002)(53546011)(8936002)(36860700001)(8676002)(86362001)(2906002)(4326008)(47076005)(83380400001)(6666004)(7696005)(356005)(70206006)(70586007)(16526019)(336012)(426003)(508600001)(55016003)(9686003)(1076003)(26005)(186003)(33656002)(6916009)(40460700003)(81166007)(5660300002)(54906003)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 14:46:48.7830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e513d9a-6d04-44d7-a914-08d9f091ff02
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3153
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 04:43:08PM -0800, Si-Wei Liu wrote:
> 
> 
> On 2/10/2022 5:31 AM, Eli Cohen wrote:
> > When showing the available management devices, check if
> > VDPA_ATTR_DEV_SUPPORTED_FEATURES feature is available and print the
> > supported features for a management device.
> > 
> > Example:
> > $ vdpa mgmtdev show
> > auxiliary/mlx5_core.sf.1:
> >    supported_classes net
> >    max_supported_vqs 257
> >    dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ MQ \
> >                 CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
> It'd be nice to add an example output for json pretty format.
> 
Will add

> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> 
> > 
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> >   vdpa/include/uapi/linux/vdpa.h |  1 +
> >   vdpa/vdpa.c                    | 11 +++++++++++
> >   2 files changed, 12 insertions(+)
> > 
> > diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> > index a3ebf4d4d9b8..96ccbf305d14 100644
> > --- a/vdpa/include/uapi/linux/vdpa.h
> > +++ b/vdpa/include/uapi/linux/vdpa.h
> > @@ -42,6 +42,7 @@ enum vdpa_attr {
> >   	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
> >   	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
> > +	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
> >   	/* new attributes must be added above here */
> >   	VDPA_ATTR_MAX,
> > diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> > index 99ee828630cc..44b2a3e9e78a 100644
> > --- a/vdpa/vdpa.c
> > +++ b/vdpa/vdpa.c
> > @@ -83,6 +83,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
> >   	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
> >   	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> >   	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
> > +	[VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
> >   };
> >   static int attr_cb(const struct nlattr *attr, void *data)
> > @@ -535,6 +536,16 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
> >   		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
> >   	}
> > +	if (tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]) {
> > +		uint64_t features;
> > +
> > +		features  = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]);
> > +		if (classes & BIT(VIRTIO_ID_NET))
> > +			print_net_features(vdpa, features, true);
> > +		else
> > +			print_generic_features(vdpa, features, true);
> > +	}
> > +
> >   	pr_out_handle_end(vdpa);
> >   }
> 
