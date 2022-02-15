Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC624B737F
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbiBOPQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:16:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236310AbiBOPQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:16:47 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2077.outbound.protection.outlook.com [40.107.101.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470712A73A
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:16:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYA1JjqOdkNGWuLvEt2R6OqqjSCjC8evgL5AtkbwfK3ZCAaOVRs/5Euj1ms433u1eiRIKaPO8njO7F/YlxdydQPmKQJzl1dH6kw4wqggVnyZtL5xkXE02aGrTr7tdM1m1q34WaHW+jgeMl5uD5++w2YmvQmkFZRxwfpynqpLfrCoocla49XKe1ADK+2CqybdUcSsyVhVi7MfuYqatQU24PVajlmf+TZ+LoTL4BdZznXzidxKYflqH/yidq2IlNuCMD+qHwfnhhOcL4CwT1MexaKX23P1euohvScaKoZ2f+fAU3d0tLjrP7YycnW7toM+q3B006yeqBuKmf6lsX5qUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwLUo8+SXuf1Lcv9xRxF2Cx4/RQZV0tUZxrKTHG2/+M=;
 b=FUnEa3anQ+PCmA/gk9cEbpZ3FK3y9zwChBlsP3jUeyNBO5lxbsWOgqKLMYe/vikXU4Gwr9LtP/oK0RUya1LP3+mbTNdwUzcAz0wOdNxxxcswubTx8LEBQ7HNAJ00xFGgU3ZexN3ZDAkw2dtrAQpLx6um15utWs/yVN+4Ub/OlIRg1Eg3fZUSp+exo+BH8HeY+AwvEbKTYiEeV4DbVMLUVlUTGno9vl+eeq3v7j3H19jRhkwSMaxxqHPqNZmKH3Vbf8uvhT4mfFiVceUjd/y9MndHXLh+N7aHTYeneeA0bVrclewW+RDC6ZGsyRBV5zsaYdteMxWzrZx/XDcAceyXOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwLUo8+SXuf1Lcv9xRxF2Cx4/RQZV0tUZxrKTHG2/+M=;
 b=QV+JpCjKc9BKkgf8/HbMSBT0fk2If71vy0YuQd+TK1IG3qt+gboHNZBq4aYlO97E5gmmM7OjYahPfDv/Bk97+/Jhd/w2X2fxd6GZ4BNu09HCA3BNw3u4UlnwIz6DDq1nFopFhsXSoRdvk7uEZycDPrdOsKz1dbV9bxA5TNsNgrEdXeKscUnrn2rLFXVpqEJjuboH86eR9eWNe70CtG9yKBTd4f/WAPJ5Cs5yaKFfWZIggLS7FiV1pK2EpS3oy6mLODq4bnBexX25OuHG7nbovtdiZ9uyCbQcQRxYD3L8uYaQEzVcQhbxyWC8zfJHT/XOUuxysjYAlO3bqxJ55l99Tg==
Received: from MWHPR2201CA0051.namprd22.prod.outlook.com
 (2603:10b6:301:16::25) by BN6PR12MB1538.namprd12.prod.outlook.com
 (2603:10b6:405:4::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 15 Feb
 2022 15:16:34 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:16:cafe::bc) by MWHPR2201CA0051.outlook.office365.com
 (2603:10b6:301:16::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Tue, 15 Feb 2022 15:16:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Tue, 15 Feb 2022 15:16:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Feb
 2022 15:16:33 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 15 Feb 2022 07:16:31 -0800
Date:   Tue, 15 Feb 2022 17:16:27 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <jasowang@redhat.com>, <lulu@redhat.com>
Subject: Re: [PATCH v1 2/4] vdpa: Allow for printing negotiated features of a
 device
Message-ID: <20220215151627.GA2109@mtl-vdi-166.wap.labs.mlnx>
References: <20220210133115.115967-1-elic@nvidia.com>
 <20220210133115.115967-3-elic@nvidia.com>
 <51789e9b-4080-acb1-8b8b-2cf3f5d6a0f9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51789e9b-4080-acb1-8b8b-2cf3f5d6a0f9@oracle.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5698e42-90b2-46f3-b48f-08d9f09626f6
X-MS-TrafficTypeDiagnostic: BN6PR12MB1538:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB15380DBB386EB309E299D663AB349@BN6PR12MB1538.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 68YSpCc1H5KxCotNv3/BA9yYZUdaVwOVpjZLptLSIqBTjwT0hkBFIlKG3DLJK/CxsjgXHvvu6dfT7Ocs4MJLy63cq0gyyF34KymN3/meiLRcAGljEZGsSI4DhM6iEDZ73eHnbuTgGW2PIe96UrzXf+PB9Glc1j0dVMaKxSsVEvoW9N+qBO7728Qw10o+D1NlNNJdfUnDZAes85H3IGmGZIrtKUeQiAv2svNqBK0iQI812Q/oQIQtC3DgnsBdICb2iaZ9NjBYy5nPa9fTRYbdXZPhRtZqOYCYDjv07om8+DrAaH//FXnn1LsKt8zBHwukOEvpjMkBYVvidLPQaCYRIJgTkU5eAj4iO4DakS/wnSryokAHFtqbhHOM6sq8Xs79f7KzeckVmhAc04MN2QBOmaygxa86NzQNA/vzU4QunOc9w/KR8UEBrK4HrxIfnYlxx4tXV0d7s/onBtTv0VSntYxOYInexOA8d9NrBSJFdXNvSCHIWz43r8h9dwXPloYjGxcJPm4meStgfQ6gRtUoSqT1x2Q1N2tetzqMgaY8IOj1wTMyx24P+lZyoB7DIqDzMIZ+dl7YUiAjcsAXxSGoCh2UOMCD83e1rSvqeI3Ds2VFaZ5NihY5EKAy47krc6EbG3NICtNmfxgpOL5wV5O9xR3Bfy3182Gsq3LLMbZlkHmuEPFgryiNpIR4cJTlVd+8+cyfNRklZe0dV/XlloIPmQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(336012)(426003)(186003)(26005)(33656002)(16526019)(316002)(7696005)(55016003)(2906002)(9686003)(53546011)(6666004)(1076003)(508600001)(83380400001)(40460700003)(8676002)(36860700001)(70586007)(70206006)(86362001)(5660300002)(4326008)(8936002)(54906003)(6916009)(82310400004)(47076005)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 15:16:33.7692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5698e42-90b2-46f3-b48f-08d9f09626f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1538
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 05:15:51PM -0800, Si-Wei Liu wrote:
> 
> 
> On 2/10/2022 5:31 AM, Eli Cohen wrote:
> > When reading the configuration of a vdpa device, check if the
> > VDPA_ATTR_DEV_NEGOTIATED_FEATURES is available. If it is, parse the
> > feature bits and print a string representation of each of the feature
> > bits.
> > 
> > We keep the strings in two different arrays. One for net device related
> > devices and one for generic feature bits.
> > 
> > In this patch we parse only net device specific features. Support for
> > other devices can be added later. If the device queried is not a net
> > device, we print its bit number only.
> > 
> > Examples:
> > 1.
> > $ vdpa dev config show vdpa-a
> > vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 3 \
> >          mtu 1500
> >    negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
> >                        CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
> > 
> > 2. json output
> > $ vdpa -j dev config show vdpa-a
> > {"config":{"vdpa-a":{"mac":"00:00:00:00:88:88","link":"up","link_announce":false, \
> >    "max_vq_pairs":3,"mtu":1500,"negotiated_features":["CSUM","GUEST_CSUM","MTU", \
> >    "MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ","MQ","CTRL_MAC_ADDR", \
> >    "VERSION_1","ACCESS_PLATFORM"]}}}
> > 
> > 3. pretty json
> > $ vdpa -jp dev config show vdpa-a
> > {
> >      "config": {
> >          "vdpa-a": {
> >              "mac": "00:00:00:00:88:88",
> >              "link ": "up",
> >              "link_announce ": false,
> >              "max_vq_pairs": 3,
> >              "mtu": 1500,
> >              "negotiated_features": [
> > "CSUM","GUEST_CSUM","MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ", \
> > "MQ","CTRL_MAC_ADDR","VERSION_1","ACCESS_PLATFORM" ]
> >          }
> >      }
> > }
> > 
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> >   vdpa/include/uapi/linux/vdpa.h |   2 +
> >   vdpa/vdpa.c                    | 126 +++++++++++++++++++++++++++++++--
> >   2 files changed, 124 insertions(+), 4 deletions(-)
> > 
> > diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> > index b7eab069988a..748c350450b2 100644
> > --- a/vdpa/include/uapi/linux/vdpa.h
> > +++ b/vdpa/include/uapi/linux/vdpa.h
> > @@ -40,6 +40,8 @@ enum vdpa_attr {
> >   	VDPA_ATTR_DEV_NET_CFG_MAX_VQP,		/* u16 */
> >   	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
> > +	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
> > +
> >   	/* new attributes must be added above here */
> >   	VDPA_ATTR_MAX,
> >   };
> > diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> > index 4ccb564872a0..7deab710913d 100644
> > --- a/vdpa/vdpa.c
> > +++ b/vdpa/vdpa.c
> > @@ -10,6 +10,7 @@
> >   #include <linux/virtio_net.h>
> >   #include <linux/netlink.h>
> >   #include <libmnl/libmnl.h>
> > +#include <linux/virtio_ring.h>
> >   #include "mnl_utils.h"
> >   #include <rt_names.h>
> > @@ -78,6 +79,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
> >   	[VDPA_ATTR_DEV_VENDOR_ID] = MNL_TYPE_U32,
> >   	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
> >   	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
> > +	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> >   };
> >   static int attr_cb(const struct nlattr *attr, void *data)
> > @@ -385,17 +387,120 @@ static const char *parse_class(int num)
> >   	return class ? class : "< unknown class >";
> >   }
> > +static const char * const net_feature_strs[64] = {
> > +	[VIRTIO_NET_F_CSUM] = "CSUM",
> > +	[VIRTIO_NET_F_GUEST_CSUM] = "GUEST_CSUM",
> > +	[VIRTIO_NET_F_CTRL_GUEST_OFFLOADS] = "CTRL_GUEST_OFFLOADS",
> > +	[VIRTIO_NET_F_MTU] = "MTU",
> > +	[VIRTIO_NET_F_MAC] = "MAC",
> > +	[VIRTIO_NET_F_GUEST_TSO4] = "GUEST_TSO4",
> > +	[VIRTIO_NET_F_GUEST_TSO6] = "GUEST_TSO6",
> > +	[VIRTIO_NET_F_GUEST_ECN] = "GUEST_ECN",
> > +	[VIRTIO_NET_F_GUEST_UFO] = "GUEST_UFO",
> > +	[VIRTIO_NET_F_HOST_TSO4] = "HOST_TSO4",
> > +	[VIRTIO_NET_F_HOST_TSO6] = "HOST_TSO6",
> > +	[VIRTIO_NET_F_HOST_ECN] = "HOST_ECN",
> > +	[VIRTIO_NET_F_HOST_UFO] = "HOST_UFO",
> > +	[VIRTIO_NET_F_MRG_RXBUF] = "MRG_RXBUF",
> > +	[VIRTIO_NET_F_STATUS] = "STATUS",
> > +	[VIRTIO_NET_F_CTRL_VQ] = "CTRL_VQ",
> > +	[VIRTIO_NET_F_CTRL_RX] = "CTRL_RX",
> > +	[VIRTIO_NET_F_CTRL_VLAN] = "CTRL_VLAN",
> > +	[VIRTIO_NET_F_CTRL_RX_EXTRA] = "CTRL_RX_EXTRA",
> > +	[VIRTIO_NET_F_GUEST_ANNOUNCE] = "GUEST_ANNOUNCE",
> > +	[VIRTIO_NET_F_MQ] = "MQ",
> > +	[VIRTIO_F_NOTIFY_ON_EMPTY] = "NOTIFY_ON_EMPTY",
> > +	[VIRTIO_NET_F_CTRL_MAC_ADDR] = "CTRL_MAC_ADDR",
> > +	[VIRTIO_F_ANY_LAYOUT] = "ANY_LAYOUT",
> > +	[VIRTIO_NET_F_RSC_EXT] = "RSC_EXT",
> > +	[VIRTIO_NET_F_HASH_REPORT] = "HASH_REPORT",
> > +	[VIRTIO_NET_F_RSS] = "RSS",
> > +	[VIRTIO_NET_F_STANDBY] = "STANDBY",
> > +	[VIRTIO_NET_F_SPEED_DUPLEX] = "SPEED_DUPLEX",
> > +};
> > +
> > +#define VIRTIO_F_IN_ORDER 35
> > +#define VIRTIO_F_NOTIFICATION_DATA 38
> > +#define VDPA_EXT_FEATURES_SZ (VIRTIO_TRANSPORT_F_END - \
> > +			      VIRTIO_TRANSPORT_F_START + 1)
> > +
> > +static const char * const ext_feature_strs[VDPA_EXT_FEATURES_SZ] = {
> > +	[VIRTIO_RING_F_INDIRECT_DESC - VIRTIO_TRANSPORT_F_START] = "RING_INDIRECT_DESC",
> > +	[VIRTIO_RING_F_EVENT_IDX - VIRTIO_TRANSPORT_F_START] = "RING_EVENT_IDX",
> > +	[VIRTIO_F_VERSION_1 - VIRTIO_TRANSPORT_F_START] = "VERSION_1",
> > +	[VIRTIO_F_ACCESS_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ACCESS_PLATFORM",
> > +	[VIRTIO_F_RING_PACKED - VIRTIO_TRANSPORT_F_START] = "RING_PACKED",
> > +	[VIRTIO_F_IN_ORDER - VIRTIO_TRANSPORT_F_START] = "IN_ORDER",
> > +	[VIRTIO_F_ORDER_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ORDER_PLATFORM",
> > +	[VIRTIO_F_SR_IOV - VIRTIO_TRANSPORT_F_START] = "SR_IOV",
> > +	[VIRTIO_F_NOTIFICATION_DATA - VIRTIO_TRANSPORT_F_START] = "NOTIFICATION_DATA",
> > +};
> > +
> > +static void print_net_features(struct vdpa *vdpa, uint64_t features, bool maxf)
> > +{
> > +	const char *s;
> > +	int i;
> > +
> > +	if (maxf)
> This could use a better name. mgmtdevf maybe?

Will change.

> > +		pr_out_array_start(vdpa, "dev_features");
> > +	else
> > +		pr_out_array_start(vdpa, "negotiated_features");
> > +
> > +	for (i = 0; i < 64; i++) {
> > +		if (!(features & (1ULL << i)))
> > +			continue;
> > +
> > +		if (i >= VIRTIO_TRANSPORT_F_START && i <= VIRTIO_TRANSPORT_F_END)
> > +			s = ext_feature_strs[i - VIRTIO_TRANSPORT_F_START];
> > +		else
> > +			s = net_feature_strs[i];
> > +
> > +		if (!s)
> > +			print_uint(PRINT_ANY, NULL, " unrecognized_bit_%d", i);
> > +		else
> > +			print_string(PRINT_ANY, NULL, " %s", s);
> > +	}
> > +	pr_out_array_end(vdpa);
> > +}
> > +
> > +static void print_generic_features(struct vdpa *vdpa, uint64_t features, bool maxf)
> > +{
> > +	const char *s;
> > +	int i;
> > +
> > +	if (maxf)
> > +		pr_out_array_start(vdpa, "dev_features");
> > +	else
> > +		pr_out_array_start(vdpa, "negotiated_features");
> > +
> > +	for (i = 0; i < 64; i++) {
> > +		if (!(features & (1ULL << i)))
> > +			continue;
> > +
> > +		if (i >= VIRTIO_TRANSPORT_F_START && i <= VIRTIO_TRANSPORT_F_END)
> > +			s = ext_feature_strs[i - VIRTIO_TRANSPORT_F_START];
> > +		else
> > +			s = NULL;
> > +
> > +		if (!s)
> > +			print_uint(PRINT_ANY, NULL, " bit_%d", i);
> > +		else
> > +			print_string(PRINT_ANY, NULL, " %s", s);
> > +	}
> > +	pr_out_array_end(vdpa);
> > +}
> > +
> It looks like most of the implantation in the above two functions are the
> same and the rest are similar. I wonder if can consolidate into one by
> adding a virtio type (dev_id) argument? You may create another global static
> array that helps mapping VIRTIO_ID_NET to net_feature_strs?
> 

So maybe just create multidimensional array of to find the string for a
device_id/bit number combination and simplify the code above. And for
now just populate it for net devices. For undefined just print "bit_n".

> >   static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
> >   				struct nlattr **tb)
> >   {
> > +	uint64_t classes = 0;
> >   	const char *class;
> >   	unsigned int i;
> >   	pr_out_handle_start(vdpa, tb);
> >   	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
> > -		uint64_t classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
> > -
> > +		classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
> >   		pr_out_array_start(vdpa, "supported_classes");
> This looks like a minor adjustment to the existing code? Not sure if worth
> another patch though.

I will remove it from this patch.
> 
> >   		for (i = 1; i < 64; i++) {
> > @@ -579,9 +684,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
> >   	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
> >   }
> > -static void pr_out_dev_net_config(struct nlattr **tb)
> > +static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
> >   {
> >   	SPRINT_BUF(macaddr);
> > +	uint64_t val_u64;
> >   	uint16_t val_u16;
> >   	if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
> > @@ -610,6 +716,18 @@ static void pr_out_dev_net_config(struct nlattr **tb)
> >   		val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MTU]);
> >   		print_uint(PRINT_ANY, "mtu", "mtu %d ", val_u16);
> >   	}
> > +	if (tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]) {
> > +		uint16_t dev_id = 0;
> > +
> > +		if (tb[VDPA_ATTR_DEV_ID])
> > +			dev_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
> > +
> > +		val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
> > +		if (tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] && dev_id == VIRTIO_ID_NET)
> > +			print_net_features(vdpa, val_u64, false);
> > +		else
> > +			print_generic_features(vdpa, val_u64, true);
> Why the last arg is true? That would output the dev_features line instead.
> 
Will fix.

> -Siwei
> 
> > +	}
> >   }
> >   static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> > @@ -619,7 +737,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> >   	pr_out_vdev_handle_start(vdpa, tb);
> >   	switch (device_id) {
> >   	case VIRTIO_ID_NET:
> > -		pr_out_dev_net_config(tb);
> > +		pr_out_dev_net_config(vdpa, tb);
> >   		break;
> >   	default:
> >   		break;
> 
