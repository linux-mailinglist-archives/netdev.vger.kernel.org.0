Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CF54BD7EB
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 09:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245401AbiBUI3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 03:29:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiBUI3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 03:29:34 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2076.outbound.protection.outlook.com [40.107.212.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5E5BC
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 00:29:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apAYieZFrHIF4U53vNIPiH7FcQ6LNhGptFB96RFhR/sHsHM5DzDxpO2GH97FdKx8MvSM7YrNHnWWDDeFXeylHh12+8CtWUksXQH7eqjA3WU6l5XZDb01JtGo4adgHHKVQXqgAZ2PgE1xacBagWbzuN/273RksD4xTr+W/2tqDoKcnS6DpFUrbyuWBgKZr7RHfUNKiVZasbx+5ZEtbBPTzy0KOLSuBb69Hsr/N7tQhMfJoa1HhDWZIJJmJedylyXEm4VLTqHnD0XhGmbXDg5X/gptKTYLDynYafdGV2/PVPCkikipb4c8RmXIel6hcNrwICDqfAdCXmiwAxIC14WLXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYfp5a4DremCm8mR8S2GNGbrILjFEnrEcxD64NA0Yjg=;
 b=Ze8XKAR1P+4lIc0pxHj4F9T8xfA0+Nlti1VFArUHuOtObgGpgTeKdjDPjZpbu6VX9vba9GhxMsx5OJiP2EEx9EBfpDqheJB2P+rrGo4l1EoY/iHtGfefNf0Ip5J0FylDmwc/LMkXHbN9H30XjYCEaZwFV9dM/7jSmKK/417wdeHVknXkpbCkXfBU0DdrvyuW5EzhvFjgUFBuQqr4kq3wSN6XwOqRJx5YiO6jzFZGCB5DsAfSyQBiiD9iaWO5Kxp0c1mggrXoUVEbQh9n3Rl+bUkyVfK7y4Wcxdwh+YgytWFzRyVyVzwaF82xkwwUT75o2nWQ0wj4uYKtCygaXFQ4Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYfp5a4DremCm8mR8S2GNGbrILjFEnrEcxD64NA0Yjg=;
 b=WU4PzHGoVRHG6o1rcxkZi9iqOiTGXiVg/O9xLXMzfEbNX51JrIHS8qMOFYUvBNYi7L510nABpyo8pE3zHIqq4qx5u5fOx6qU8Pq02BkPRSzmRmNLiIWx5YogxdsQucGrmqTRLdK4/mSxmTz3FRsHX2H0w5EL7msZTbFzidqxQxLQz4ei41BbkzmUQinScoMbB2KoqEpQyYZV5uxsZxVWVmpKzZ7slUbwU0aT0GpgQpowNaobsfjfK8b/6lYZGXPcb63TrJboYFm9OdmqEKL23b1pR6f4mXkLQLCX/EpzEgN83BK6zDl0XFJaAnMDqiZdWNTOFz5uGszCtNAyEq05pA==
Received: from MWHPR17CA0055.namprd17.prod.outlook.com (2603:10b6:300:93::17)
 by BY5PR12MB3956.namprd12.prod.outlook.com (2603:10b6:a03:1ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Mon, 21 Feb
 2022 08:29:09 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:93:cafe::d5) by MWHPR17CA0055.outlook.office365.com
 (2603:10b6:300:93::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.26 via Frontend
 Transport; Mon, 21 Feb 2022 08:29:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 08:29:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 21 Feb
 2022 08:28:58 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 21 Feb 2022 00:28:56 -0800
Date:   Mon, 21 Feb 2022 10:28:52 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <lulu@redhat.com>, <si-wei.liu@oracle.com>
Subject: Re: [PATCH v2 4/4] vdpa: Support reading device features
Message-ID: <20220221070416.GB45328@mtl-vdi-166.wap.labs.mlnx>
References: <20220217123024.33201-1-elic@nvidia.com>
 <20220217123024.33201-5-elic@nvidia.com>
 <b36e4a63-7fac-212a-2d6b-e267d49c5e72@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b36e4a63-7fac-212a-2d6b-e267d49c5e72@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20766ff0-953e-43f6-b5ec-08d9f5143b60
X-MS-TrafficTypeDiagnostic: BY5PR12MB3956:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3956DA96CAF373717B84CC15AB3A9@BY5PR12MB3956.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: scvFsOtAT8IcMhmkhs9sOdXMqjGpzyZjkLB9EHIOhSRVw8Jfw/Q03dS96dgP0Mp3jwEswgmW875/pI8sTAedw1xKUsPu0k1ViO4BzO753tYzrIjNWA4+U6P7bCZ0ycmt9kcELC8Gak/p75Y+qJurtEMW717JwHDVjL1Y0Pm3WT9a05XTu442BL49TbTNoAfegbvivqzZuv8CuarL1nFrbVG6e/31b+y+TmCS/l2NWDcM3FuGST6O/FA1Bzcd1QI8+lwZJrdzM/JD2uWhRFl46Dbteiyv9V48XWiOnSXBCMuZnL2ZIQ17dZL7XRKXQRcJvUzQLKWUmePK4uCyuLe7lkE8CzyhIBMqq+kAwrIsTc7npFsWrQOND3nwq36+oQzMB8zoUx4nbSrhup3mgU8Kv//xT/GIKZOq4eahfX+Iwu9m1jVMXLfKNb+1Cwr4uh4TgbNjeRaU9d/2Xbc9WyUhZ31CUhJDbjzhBMZ0DmtLs8HPpeF3UbrXOzIRa80m5aZp5NOxhDHT8+5xVmyi4/QXDbLoMoui3pEZT9AXfx7IfnXrDFnew5yNXYsxlyNv37HYNbCg+OQ2L0q4MiQQV9VUgsayX/iXZF2sVKML0icssHC8H4KnEWkwOu/mI2AKWFWAN1sBgl/ndBSez4KAINcWHDqks0z4lInu7b2fS1nb71aWjz8vzf52TL8u1GJlrDOlqNqNl4HKBqpNbclcL7JyFQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(356005)(81166007)(86362001)(40460700003)(70586007)(70206006)(4326008)(8676002)(54906003)(6916009)(55016003)(316002)(47076005)(26005)(5660300002)(2906002)(8936002)(16526019)(1076003)(426003)(336012)(186003)(83380400001)(508600001)(82310400004)(6666004)(9686003)(33656002)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 08:29:09.3043
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20766ff0-953e-43f6-b5ec-08d9f5143b60
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3956
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 12:18:03PM +0800, Jason Wang wrote:
> 
> 在 2022/2/17 下午8:30, Eli Cohen 写道:
> > When showing the available management devices, check if
> > VDPA_ATTR_DEV_SUPPORTED_FEATURES feature is available and print the
> > supported features for a management device.
> > 
> > Examples:
> > $ vdpa mgmtdev show
> > auxiliary/mlx5_core.sf.1:
> >    supported_classes net
> >    max_supported_vqs 257
> >    dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ MQ \
> >                 CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
> > 
> > $ vdpa -jp mgmtdev show
> > {
> >      "mgmtdev": {
> >          "auxiliary/mlx5_core.sf.1": {
> >              "supported_classes": [ "net" ],
> >              "max_supported_vqs": 257,
> >              "dev_features": [
> > "CSUM","GUEST_CSUM","MTU","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ","MQ",\
> > "CTRL_MAC_ADDR","VERSION_1","ACCESS_PLATFORM" ]
> >          }
> >      }
> > }
> > 
> > Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> >   vdpa/include/uapi/linux/vdpa.h |  1 +
> >   vdpa/vdpa.c                    | 14 +++++++++++++-
> >   2 files changed, 14 insertions(+), 1 deletion(-)
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
> > index 78736b1422b6..bdc366880ab9 100644
> > --- a/vdpa/vdpa.c
> > +++ b/vdpa/vdpa.c
> > @@ -84,6 +84,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
> >   	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
> >   	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> >   	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
> > +	[VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
> >   };
> >   static int attr_cb(const struct nlattr *attr, void *data)
> > @@ -494,13 +495,14 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
> >   static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
> >   				struct nlattr **tb)
> >   {
> > +	uint64_t classes = 0;
> >   	const char *class;
> >   	unsigned int i;
> >   	pr_out_handle_start(vdpa, tb);
> >   	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
> > -		uint64_t classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
> > +		classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
> >   		pr_out_array_start(vdpa, "supported_classes");
> >   		for (i = 1; i < 64; i++) {
> > @@ -522,6 +524,16 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
> >   		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
> >   	}
> > +	if (tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]) {
> > +		uint64_t features;
> > +
> > +		features  = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]);
> > +		if (classes & BIT(VIRTIO_ID_NET))
> > +			print_features(vdpa, features, true, VIRTIO_ID_NET);
> > +		else
> > +			print_features(vdpa, features, true, 0);
> 
> 
> I wonder what happens if we try to read a virtio_blk device consider:
> 
> static const char * const *dev_to_feature_str[] = {
>         [VIRTIO_ID_NET] = net_feature_strs,
> };

In that case we will print bit_xx for each non general bit.

> 
> Thanks
> 
> 
> > +	}
> > +
> >   	pr_out_handle_end(vdpa);
> >   }
> 
