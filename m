Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513B24B735A
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239046AbiBOOtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:49:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239114AbiBOOrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:47:48 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED76105A97
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:46:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8RqSon/3p+X3iq87JvghCsp6z2p27PGXA0pDhSc/v3IHMkU5ozt3YSSB8efyl0uiefVOA8m1Ox2hWCELDwvU6h06t8+6IibbN3mTEWxpOhPYQjfuf6zYolFu1SBRB0Ep33k97y4/bUB8R40PyJK83ZxgreaR2zSH/lf84EAesOkIEV/qK57j88YhAbj3MaX99jgXVD6BHCWqp8F9WremW0yPskx7NC+KlFxqBD59kE9DZQ72S288EiFPPCR3uOkEM8X+VSTTG30/YHz/ka/mHkt/3kJXU2ID2z9E/wMI5zYh8VBpB83oL7j7uA6XC8fuFDeYQamHxQkLEcVfaXUqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1KTxBYLan46OgKpwFXNGKN+4kKN2iCt051+dlYiYtc=;
 b=ZweWIInjb5hMoucElJmo182ZVpCi2KGVZ0RTHNZVTxIpvS0x0Oz/Bii0Yrv50VZU5tN4yMDm3/jBAJODTaFSqngGkY/lhjLW7VTKZiR9UxhweAb2w7rYk4OhHohiM0Exl5Shz40mXX2mwfan6kTIfw4mXhNew5IRMb2UwIaSHKvKeZyx22XsSs07/9XbrJnBXuw9DELHxRJ0SiXLgRvRDN+d1Ed9SUuf10RflB4vt7dPfzMZKw95u5i1/Tk0/1UOigQwxVmvZZmDNbPzyZos/p+L0nCDXwKACzp9PzPJ9+lUxA3WJXTm1+yYVn3UVFW3d6o+1XBZxw7XggtkOODgKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1KTxBYLan46OgKpwFXNGKN+4kKN2iCt051+dlYiYtc=;
 b=Ux+c45eozjqirR8J6JulDBAODjsRyLgIRaTeN3kJP9F5CMeq7KASotYfX9iePPixpXc7Hhn8VBKnptGgi/lCGhbKtWZH9xozJkqivYrDdKlqLu+LEXLASMnnjrwCIB2mM80rEW3P/r9ku6ZvUuZyU91Vp4lpBoDR+g73ScupybqKXJVSTw6c/JkMsLJT6tsRBV+frfSxRG3Eek0SD5F1UrWUKF+kXU1J65gXKOd+XdLif6uxHlzR/aWKWvclHIWYV9XI5J6jGg//9fWVktR2/ozC6QaYxsgnBlj2HnywOezzusuwTIZG8EfjK+tyogAbvyd57fIbi4lEycOiZpeoCg==
Received: from MWHPR18CA0047.namprd18.prod.outlook.com (2603:10b6:320:31::33)
 by BN6PR1201MB2513.namprd12.prod.outlook.com (2603:10b6:404:ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Tue, 15 Feb
 2022 14:46:01 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::48) by MWHPR18CA0047.outlook.office365.com
 (2603:10b6:320:31::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17 via Frontend
 Transport; Tue, 15 Feb 2022 14:46:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Tue, 15 Feb 2022 14:46:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Feb
 2022 14:46:00 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 15 Feb 2022 06:45:58 -0800
Date:   Tue, 15 Feb 2022 16:45:54 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <jasowang@redhat.com>, <lulu@redhat.com>
Subject: Re: [PATCH v1 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Message-ID: <20220215144554.GC229469@mtl-vdi-166.wap.labs.mlnx>
References: <20220210133115.115967-1-elic@nvidia.com>
 <20220210133115.115967-4-elic@nvidia.com>
 <321ab6dd-e866-635d-b9b0-03abeb5eb7d6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <321ab6dd-e866-635d-b9b0-03abeb5eb7d6@oracle.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1bb8315-deed-4bdf-d53c-08d9f091e247
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2513:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB251364A8C3E07D47337452D7AB349@BN6PR1201MB2513.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L7cddVIQ5LQ+49YnqaqGpGTpnS9FfDgLShppcGNPdCSC1HirdFSovUW9d6onf2USGYGR0DVnynuaIdJ1KtH8JYpQzi3bkOM5n8fWUGPROuo8ytFTHWCop2vEb+RsIdQVVFLRI+/jl6mazTPOSpdybuRDobIsiaHEDWAHVkKDo2hGE7OY7LjX4UAqSQQ7f0oJ6lsihBlJjhfmb3/xFik/lBKW4bpvtqwuIOeiqIMemdJv1+8HSiPBqxJZoHe/tlLxgclmnypKchkydFCm+APEOqRpMJOHYiCRgF3bMIntOZDg0S2YYJj1MTOpKYYjPZPdK6LTqNwJYzRTZqAYQduy8ULhNbIwxhgQkf8Mg5SUxgldl2e4IOoj9rHgfzXJar3nmkOFMUFYYAtl/Ltk1i/rdVgaxRM4O+SkAfVU9IqihoW8gB4XFTUunLZsDRE4bmcMPVcOKd7UQa3fj4BP8egTS9qsScVFfiNKuUN1YItQeySBdUefmMgH4rxnQzsyPDd39Vm6Hm3ejPBe0EkxTmXWOThysbw9yzzL6irj88dA5P6WlqEcDeKgjm8NypikOnwnfhqQvu0lLMrAPjOhpkT1ZffIKNtrH9vmHJdLiVpVBy98sPdGNiq9LLhn1Y/kvRGZVTmsBZh2UOBocwkMY2NEzkVf5PRdRXMXJoEfhoUL2ViCas/zoDHOiq5e4lo0P08wxmgEXj2Ygt1zBOUARK+c5w==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(508600001)(54906003)(8936002)(2906002)(6666004)(316002)(33656002)(6916009)(7696005)(55016003)(5660300002)(53546011)(9686003)(1076003)(82310400004)(4326008)(336012)(16526019)(47076005)(356005)(70206006)(83380400001)(26005)(36860700001)(40460700003)(70586007)(8676002)(86362001)(426003)(81166007)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 14:46:00.5824
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1bb8315-deed-4bdf-d53c-08d9f091e247
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2513
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 04:37:02PM -0800, Si-Wei Liu wrote:
> 
> 
> On 2/10/2022 5:31 AM, Eli Cohen wrote:
> > Use VDPA_ATTR_DEV_MGMTDEV_MAX_VQS to specify max number of virtqueue
> > pairs to configure for a vdpa device when adding a device.
> > 
> > Examples:
> > 1. Create a device with 3 virtqueue pairs:
> > $ vdpa dev add name vdpa-a mgmtdev auxiliary/mlx5_core.sf.1 max_vqp 3
> > 
> > 2. Read the configuration of a vdpa device
> > $ vdpa dev config show vdpa-a
> >    vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 3 \
> >            mtu 1500
> >    negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
> >                        CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
> > 
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> >   vdpa/include/uapi/linux/vdpa.h |  1 +
> >   vdpa/vdpa.c                    | 25 ++++++++++++++++++++++++-
> >   2 files changed, 25 insertions(+), 1 deletion(-)
> > 
> > diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> > index 748c350450b2..a3ebf4d4d9b8 100644
> > --- a/vdpa/include/uapi/linux/vdpa.h
> > +++ b/vdpa/include/uapi/linux/vdpa.h
> > @@ -41,6 +41,7 @@ enum vdpa_attr {
> >   	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
> >   	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
> > +	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
> >   	/* new attributes must be added above here */
> >   	VDPA_ATTR_MAX,
> > diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> > index 7deab710913d..99ee828630cc 100644
> > --- a/vdpa/vdpa.c
> > +++ b/vdpa/vdpa.c
> > @@ -24,6 +24,7 @@
> >   #define VDPA_OPT_VDEV_HANDLE		BIT(3)
> >   #define VDPA_OPT_VDEV_MAC		BIT(4)
> >   #define VDPA_OPT_VDEV_MTU		BIT(5)
> > +#define VDPA_OPT_MAX_VQP		BIT(6)
> >   struct vdpa_opts {
> >   	uint64_t present; /* flags of present items */
> > @@ -33,6 +34,7 @@ struct vdpa_opts {
> >   	unsigned int device_id;
> >   	char mac[ETH_ALEN];
> >   	uint16_t mtu;
> > +	uint16_t max_vqp;
> >   };
> >   struct vdpa {
> > @@ -80,6 +82,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
> >   	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
> >   	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
> >   	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> > +	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
> >   };
> >   static int attr_cb(const struct nlattr *attr, void *data)
> > @@ -221,6 +224,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
> >   			     sizeof(opts->mac), opts->mac);
> >   	if (opts->present & VDPA_OPT_VDEV_MTU)
> >   		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
> > +	if (opts->present & VDPA_OPT_MAX_VQP)
> > +		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
> >   }
> >   static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> > @@ -289,6 +294,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> >   			NEXT_ARG_FWD();
> >   			o_found |= VDPA_OPT_VDEV_MTU;
> > +		} else if ((matches(*argv, "max_vqp")  == 0) && (o_optional & VDPA_OPT_MAX_VQP)) {
> > +			NEXT_ARG_FWD();
> > +			err = vdpa_argv_u16(vdpa, argc, argv, &opts->max_vqp);
> > +			if (err)
> > +				return err;
> > +
> > +			NEXT_ARG_FWD();
> > +			o_found |= VDPA_OPT_MAX_VQP;
> It'd be nice to update cmd_dev_help() to include the max_vqp option as well.
> 

Will do.

> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> 
> >   		} else {
> >   			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
> >   			return -EINVAL;
> > @@ -513,6 +526,15 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
> >   		pr_out_array_end(vdpa);
> >   	}
> > +	if (tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]) {
> > +		uint16_t num_vqs;
> > +
> > +		if (!vdpa->json_output)
> > +			printf("\n");
> > +		num_vqs = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]);
> > +		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
> > +	}
> > +
> >   	pr_out_handle_end(vdpa);
> >   }
> > @@ -662,7 +684,8 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
> >   					  NLM_F_REQUEST | NLM_F_ACK);
> >   	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
> >   				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
> > -				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU);
> > +				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
> > +				  VDPA_OPT_MAX_VQP);
> >   	if (err)
> >   		return err;
> 
