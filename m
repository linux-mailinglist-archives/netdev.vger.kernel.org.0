Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B1E4BE778
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356212AbiBUL1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 06:27:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356216AbiBUL0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 06:26:50 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2059.outbound.protection.outlook.com [40.107.101.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B473312B
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 03:24:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpvXUntSEoVN42L7Pkqa7ELAS8TUMEcywN1rxKqOJSOC4uPj12O2eOTM1eRvM3FFzkSNK4kj1VyUqZoSpI0Sft7W2oURMwOCNrN+adegP2wJTAAbgdO9w3OI/Z2o+2/hHAVlDfxAUbG8JRh5r8XRzwVGq3F/MgpDuBTs4mRTh7P2DALUAoCAlW0PzYe1q/LGGt4I3L5MsMb+y+QPEf8hiaCH4gbOSrR536DmlAHMHcb5Sa/4W3ZNBoG8HHd9EiHrfatRXQTfsjgYEJamLK8juW79c6GrWofsIW5dLMU1zxmPFuHSsl6H1xjoLlvhOvTVkgr0UXGEqPMAhCTNt2LQKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSGQfNhbVGjeB+GASz/ZcPlGt6LuaxY8Fs+hTyrLWlo=;
 b=OAcLUdyv0XyuWf72gcehsjXA7gvcRksc9hF0Th1d/yQJm9vvNLO/xwInT8jJPRzwXZ/s3lKnz3/uTcF94Y1TPpjrJP7oLJS6BQ822trTDmOtQWrdc5jKIKHAOUoGsQwIFFb1EU9kiWl9KVmokll3rQmFHeVKCUS/Jr5yIl190ACAq4EW1oMTBUdkFZ+NPjpDBBpvilSTNWjIH7l3aHzoe2t9XbIuR63xgp81mi7szQZOSaYroP66nyA5wo9ZewWWpE1aDRy9SsF3flwTuxHFZY39p6zQWN06mlfS+U3BoG4zj7futy0nvp1pf9YazR5s8nGasVFsp6IJkQxHesynLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSGQfNhbVGjeB+GASz/ZcPlGt6LuaxY8Fs+hTyrLWlo=;
 b=FimSbNWArwhEuvnr3r7Nhv/hCHJI5vu+tjdDHFeiwzSlpi5fCYG+BEYNPHB9Nv/PY4Jo7Hk94Jv576Ipr/H9vaaQ7QSAgyQsCej1EY+QE4r5r2APiWktFS3Ycj5uYA1uLfLiinCF07unHMruJa7warUj4zEE8T1V9zOzLRvB+wXARefkvYjn0Fz+Poyiec15HaC+VmWFyfgzYz9xE8lOynuOxehJM/LUMktwsU8ToUKSiXhQckZ5JIm7EddS3C9Js05CxfN9MnO6LAFdaJZZKVDPFEwEmCi1nSrxvV0CuL0RSM2inN3SSHgV5/6TscFs4oDR2GB+ucvDhJStqzZUOQ==
Received: from DS7PR03CA0309.namprd03.prod.outlook.com (2603:10b6:8:2b::7) by
 SN1PR12MB2351.namprd12.prod.outlook.com (2603:10b6:802:2b::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.24; Mon, 21 Feb 2022 11:24:56 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::33) by DS7PR03CA0309.outlook.office365.com
 (2603:10b6:8:2b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Mon, 21 Feb 2022 11:24:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 11:24:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 21 Feb
 2022 11:24:54 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 21 Feb 2022 03:24:51 -0800
Date:   Mon, 21 Feb 2022 13:24:48 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <lulu@redhat.com>, <si-wei.liu@oracle.com>
Subject: Re: [PATCH v2 2/4] vdpa: Allow for printing negotiated features of a
 device
Message-ID: <20220221112448.GC45328@mtl-vdi-166.wap.labs.mlnx>
References: <20220217123024.33201-1-elic@nvidia.com>
 <20220217123024.33201-3-elic@nvidia.com>
 <986a234d-098b-2577-be2f-7c6853e73ee6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <986a234d-098b-2577-be2f-7c6853e73ee6@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd5edcf4-c72b-4b36-b17f-08d9f52cc97e
X-MS-TrafficTypeDiagnostic: SN1PR12MB2351:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB23513F95C6E7EF1552E291D6AB3A9@SN1PR12MB2351.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Q9BUechaqD/fzSPho+f4V7DDibFgLaBK6NX26OQRQFAFw0iHhiyNpZvDYQE1IXSjGJCFmmFvLVJyeaMAlFoT0wgCAb8dqaNU9P9nMfXZX/pDgY0D8JQBB3CVSmI74Ggp77cMLC3AEjqttCZNmk3WxwKu19NCfKr84pDMiKTnXcpCNaIncS+tRZ37mzSBjqNOb5AeqOD9c0jLWWd0JoTlWf+2R9puSM7pEhTxIgQfSjmiWK/huZyKGzv3B3QpEkxSItR+DjtsLsax2y3VAoYbHhFI8DWw3/Tt7NujvdOVq/HmrPCya5vNIFLvfy8JJbaqxegP1rZS0KGNQo/cjIn58cFqGMZ0T/Y7hIUNu2t30ukDvwJdGpN3efaWSYvwuYoIL3oTuHPCQf9EWTiITlc+4mZPpdivbDTTIKmzu5ADlLAeAEd8mx8CCnOE45fm942wn64xl0iA3/W5GxteHM5cNYx1qoYmKIGbG51Gpd7OxMgqCUJUxpdgM23D2QnFuRzdF4fO2J25AlxOZxlXL+ApfHYHvdGgRvkyo1LUUOtwu7zOENZaR7YMwNw35jnQQuECakQCCyRLUfATrkD/ADyQBsMGp/Iz4zBw1wnav+kaiX40VWemnN84DSqE8cqfr3gYB6KOyq7h4uMF7eYyN3jilkqa45S2uD2Gyjv5WTLT6BhYTFr38yDLl/BaLw+IU105Njuwdlp6a75vLaqWtrStQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(508600001)(8936002)(26005)(316002)(2906002)(1076003)(356005)(6916009)(16526019)(5660300002)(54906003)(7696005)(186003)(81166007)(82310400004)(70206006)(36860700001)(8676002)(4326008)(47076005)(83380400001)(55016003)(33656002)(336012)(70586007)(426003)(86362001)(6666004)(9686003)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 11:24:55.5962
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5edcf4-c72b-4b36-b17f-08d9f52cc97e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2351
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 11:57:02AM +0800, Jason Wang wrote:
> 
> 在 2022/2/17 下午8:30, Eli Cohen 写道:
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
> > 1. Standard presentation
> > $ vdpa dev config show vdpa-a
> > vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 2 mtu 9000
> >    negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
> > CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
> > 
> > 2. json output
> > $ vdpa -j dev config show vdpa-a
> > {"config":{"vdpa-a":{"mac":"00:00:00:00:88:88","link":"up","link_announce":false,\
> > "max_vq_pairs":2,"mtu":9000,"negotiated_features":["CSUM","GUEST_CSUM",\
> > "MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ","MQ","CTRL_MAC_ADDR",\
> > "VERSION_1","ACCESS_PLATFORM"]}}}
> > 
> > 3. Pretty json
> > $ vdpa -jp dev config show vdpa-a
> > {
> >      "config": {
> >          "vdpa-a": {
> >              "mac": "00:00:00:00:88:88",
> >              "link ": "up",
> >              "link_announce ": false,
> >              "max_vq_pairs": 2,
> >              "mtu": 9000,
> >              "negotiated_features": [
> > "CSUM","GUEST_CSUM","MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ",\
> > "MQ","CTRL_MAC_ADDR","VERSION_1","ACCESS_PLATFORM" ]
> >          }
> >      }
> > }
> > 
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> >   vdpa/include/uapi/linux/vdpa.h |   2 +
> >   vdpa/vdpa.c                    | 108 ++++++++++++++++++++++++++++++++-
> >   2 files changed, 107 insertions(+), 3 deletions(-)
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
> > index 4ccb564872a0..f60e647b8cf8 100644
> > --- a/vdpa/vdpa.c
> > +++ b/vdpa/vdpa.c
> > @@ -10,6 +10,8 @@
> >   #include <linux/virtio_net.h>
> >   #include <linux/netlink.h>
> >   #include <libmnl/libmnl.h>
> > +#include <linux/virtio_ring.h>
> > +#include <linux/virtio_config.h>
> >   #include "mnl_utils.h"
> >   #include <rt_names.h>
> > @@ -78,6 +80,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
> >   	[VDPA_ATTR_DEV_VENDOR_ID] = MNL_TYPE_U32,
> >   	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
> >   	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
> > +	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> >   };
> >   static int attr_cb(const struct nlattr *attr, void *data)
> > @@ -385,6 +388,96 @@ static const char *parse_class(int num)
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
> > +static const char * const *dev_to_feature_str[] = {
> > +	[VIRTIO_ID_NET] = net_feature_strs,
> > +};
> > +
> > +static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
> > +			   uint16_t dev_id)
> > +{
> > +	const char * const *feature_strs = NULL;
> > +	const char *s;
> > +	int i;
> > +
> > +	if (dev_id < ARRAY_SIZE(dev_to_feature_str))
> > +		feature_strs = dev_to_feature_str[dev_id];
> > +
> > +	if (mgmtdevf)
> > +		pr_out_array_start(vdpa, "dev_features");
> > +	else
> > +		pr_out_array_start(vdpa, "negotiated_features");
> > +
> > +	for (i = 0; i < 64; i++) {
> > +		if (!(features & (1ULL << i)))
> > +			continue;
> > +
> > +		if (i < VIRTIO_TRANSPORT_F_START || i > VIRTIO_TRANSPORT_F_END) {
> > +			if (feature_strs) {
> > +				s = feature_strs[i];
> > +			} else {
> > +				s = NULL;
> > +			}
> > +		} else {
> > +			s = ext_feature_strs[i - VIRTIO_TRANSPORT_F_START];
> > +		}
> > +		if (!s)
> > +			print_uint(PRINT_ANY, NULL, " bit_%d", i);
> > +		else
> > +			print_string(PRINT_ANY, NULL, " %s", s);
> > +	}
> > +
> > +	pr_out_array_end(vdpa);
> > +}
> > +
> >   static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
> >   				struct nlattr **tb)
> >   {
> > @@ -395,7 +488,6 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
> >   	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
> >   		uint64_t classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
> > -
> 
> 
> Unnecessary changes.

Will fix.

> 
> 
> >   		pr_out_array_start(vdpa, "supported_classes");
> >   		for (i = 1; i < 64; i++) {
> > @@ -579,9 +671,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
> >   	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
> >   }
> > -static void pr_out_dev_net_config(struct nlattr **tb)
> > +static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
> >   {
> >   	SPRINT_BUF(macaddr);
> > +	uint64_t val_u64;
> >   	uint16_t val_u16;
> >   	if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
> > @@ -610,6 +703,15 @@ static void pr_out_dev_net_config(struct nlattr **tb)
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
> > +		print_features(vdpa, val_u64, false, dev_id);
> > +	}
> >   }
> >   static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> > @@ -619,7 +721,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> >   	pr_out_vdev_handle_start(vdpa, tb);
> >   	switch (device_id) {
> >   	case VIRTIO_ID_NET:
> > -		pr_out_dev_net_config(tb);
> > +		pr_out_dev_net_config(vdpa, tb);
> >   		break;
> >   	default:
> 
> 
> I wonder if we need a warning here.

I don't think. You will see the bit_xx printed instead of getting string
representation of the feature.

> 
> Otherwise looks good to me.
> 
> Thanks
> 
> 
> >   		break;
> 
