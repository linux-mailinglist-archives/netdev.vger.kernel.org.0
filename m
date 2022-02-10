Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1604B08B6
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbiBJIov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:44:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbiBJIou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:44:50 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B52B206
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:44:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEnWs+oCpHrDRWbyfmJPaUVZCKKVq4IdQhsEdhL0nTEkbBzHme/VU7LvsvJ+ONBbM81nIk65ntenNnEkjI/V3DVlwvN9GS88IBNl+dTmTJo3xtn8yRXmlaTWngN9vUePPrDDSSRe9TNjR+hDCDhvt9CC55ngIbXu49bu/Elch9fycXbD3QkfjUtfu2I42NkUPP9GwnXYxghNmyi+ma0aloA8mhuQoRp7LOqEgMUc6k4C7I7ozM5owOsVi0dV09+/C7yKnbQ0jWP+BNaUMWKj+EHW6WTn7G3KcvXozytuy5XfJByP9e1LHqNq+ht3p1Q6E76VP9vvCDKiCisDEQavRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0niGMB0EAd/Lk5JOZ/ImVyNlWhIsM+9QoUIZom9MVU=;
 b=dSG5DSuUUqjiBypjoGtyQ6mesSxq4D1uK2LU21PclYZADrDeNzbqCq3LnXRZ0URuo8du4CBsj0hVC0QV6x63c4iJ2cbGZ46GU3PDfoF8wa8Xvfe8kWt7IpIYRajVU5s+C77FApnIDVPGl94SGPchEvQfMT2Im4j+jrRW8Vr3sQuaW768/bFH/xFEfZaDs1xFJnrmJSiGStn7NGEm55uwEX2wssIJL+9tYu7WT+qhaGRkLR/9s4ZMLP+2NJJ4AEnSgSio9kUvb7xeHCOiZcvU/E20//8u5AFursQoJXSWovwi+L/ltUTitcX0HiXce9lc6CLTJw7L6N8zPS0WYqOAVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0niGMB0EAd/Lk5JOZ/ImVyNlWhIsM+9QoUIZom9MVU=;
 b=C87bix91bl7NmK6uUbkX8jP/h8KzSEMlnWnX+A+TdMZAlPIgxAelZy7Tm27CH+88SvWbDXaon89khjdh5fsv60XgpjaEf5+k0n3GlE0ayqAjU1Z93JJQjAazQy8Ujknwi7NEkZdUGTWqEjL6FQtqxKc9iuDhb/hEGAUQpNFDI5Rl8Ss5J4t41lVIVLr5LYvVOvQ/BjW+3XUA9wRZfXJHlK3PTCPV2xdbWUt6dacrNViURBRpxRGWjKzNN3ZOkiBsJP3XJTC7XYqUTosu26u2GEICZ76N9VsKTe7dXSRLK0jx9SNs8RaDo5bK2x2ZiGi5Jxep4L9Qa+m20YDatySyXA==
Received: from DM6PR07CA0114.namprd07.prod.outlook.com (2603:10b6:5:330::29)
 by BN6PR12MB1811.namprd12.prod.outlook.com (2603:10b6:404:fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 08:44:48 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::b2) by DM6PR07CA0114.outlook.office365.com
 (2603:10b6:5:330::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Thu, 10 Feb 2022 08:44:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 08:44:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 08:44:47 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Thu, 10 Feb 2022 00:44:45 -0800
Date:   Thu, 10 Feb 2022 10:44:41 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Hemminger, Stephen" <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: Re: [PATCH 3/3] vdpa: Add support to configure max number of VQs
Message-ID: <20220210084441.GB224722@mtl-vdi-166.wap.labs.mlnx>
References: <20220207125537.174619-1-elic@nvidia.com>
 <20220207125537.174619-4-elic@nvidia.com>
 <CACGkMEsyPHKPm1mH+O9jD2uLMGTJrgRF=8h=9O00JiEXeYNEvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACGkMEsyPHKPm1mH+O9jD2uLMGTJrgRF=8h=9O00JiEXeYNEvg@mail.gmail.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 546701e0-5aed-41f5-9be3-08d9ec71989a
X-MS-TrafficTypeDiagnostic: BN6PR12MB1811:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1811260BBC77A33FBA2D53C4AB2F9@BN6PR12MB1811.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QMF1Z7+c6ZwqO/C9y7loB90WwYyHwRNL7e1xDdNmafcl4dyAE1Y7R8T/w9JBlbAFXHis4EqS9jEQASWuZsUmeqYhEWzHiWW09JoaK3jNhz0mreFNaBqPuLjv7Z99bx9PKUpFepSgnKqN/gqm26xytosQAJLZfNI2J9nJGucLN0dKd4zEJdWZ6nFC/1HBAiSbBdMBZlgjyMRYgmVVIoORhn8LUvGwLvB7hw6/ZFEyWf8lWdHrbaN2t6oq3GBvMtRDZz10lhkCD3DzYtQwXOJw2fCU5GcMh4GnMOh4sNwDyfAWxkz7KJgVfOGbqL/3aeRaYhjJbzX3xNnfmhJroHGaFToVpYRB+4mahW2sD3SJ9bP++o9b7Efj+bUjrAXZ7mOE1o0rC69Y/4wOB3xceACcZ79iZqMRGo7rEYFcyGmnRkCEGTCm36J3fz/U4ZadHxetaFJZSjVqT0ceEZ7aMXkQUOmhttK2MbEcPSQK4tI7GLalxKH2Dgb4EhY3EFnQq7R2t2CelWHXuP8jRySqP8TAKBD50SGRaJaCcS/atzQjL47gx+4UtQcRTBmtoljLqHCIx6noXrHfZi/gKQCOyY6mny/+wasa+3QUw6uu3MHxJCVIYNkmmSDxGlsquDPoWh6Z8x/uR91xqzRmQA4QY4Yi9dDW0fF9mgidfuyrPQmbXaoaDbrUIsokEB1it9+/GaV1DCmCaZQ7ogJpORVj+9izLQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(8676002)(4326008)(53546011)(1076003)(356005)(8936002)(6666004)(82310400004)(70206006)(30864003)(36860700001)(70586007)(81166007)(7696005)(107886003)(16526019)(186003)(47076005)(26005)(5660300002)(33656002)(508600001)(54906003)(6916009)(316002)(336012)(55016003)(40460700003)(426003)(9686003)(2906002)(83380400001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 08:44:48.4271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 546701e0-5aed-41f5-9be3-08d9ec71989a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1811
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 04:07:24PM +0800, Jason Wang wrote:
> On Mon, Feb 7, 2022 at 8:56 PM Eli Cohen <elic@nvidia.com> wrote:
> >
> > Add support to configure max supported virtqueue pairs for a vdpa
> > device. For this to be possible, add support for reading management
> > device's capabilities. Management device capabilities give the user a
> > hint as to how many virtqueue pairs at most he can ask for. Using this
> > information the user can choose a valid number of virtqueue pairs when
> > creating the device.
> >
> > Examples:
> > - Show management device capabiliteis:
> > $ vdpa mgmtdev show
> > auxiliary/mlx5_core.sf.1:
> >   supported_classes net
> >   max_supported_vqs 257
> >   dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ \
> >                MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
> >
> > A user can now create a device based on the above information. In the
> > above case 128 virtqueue pairs at most. The other VQ being for the
> > control virtqueue.
> >
> > - Add a vdpa device with 16 data virtqueue pairs
> > $ vdpa dev add name vdpa-a mgmtdev auxiliary/mlx5_core.sf.1 max_vqp 16
> >
> > After feature negotiation has been completed, one can read the vdpa
> > configuration using:
> > $ vdpa dev config show
> > vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 16 mtu 1500
> >   negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS
> >                       CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
> 
> I wonder if lower case is better.
> 

I thought the capital letters will emphasize the fact that these are
flag bits. Also, note the matching kernel patches have this documented
in the change log with capital letters.

> >
> > Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> >  vdpa/include/uapi/linux/vdpa.h |   4 ++
> >  vdpa/vdpa.c                    | 113 ++++++++++++++++++++++++++++++++-
> >  2 files changed, 114 insertions(+), 3 deletions(-)
> >
> > diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> > index b7eab069988a..171122dd03c9 100644
> > --- a/vdpa/include/uapi/linux/vdpa.h
> > +++ b/vdpa/include/uapi/linux/vdpa.h
> > @@ -40,6 +40,10 @@ enum vdpa_attr {
> >         VDPA_ATTR_DEV_NET_CFG_MAX_VQP,          /* u16 */
> >         VDPA_ATTR_DEV_NET_CFG_MTU,              /* u16 */
> >
> > +       VDPA_ATTR_DEV_NEGOTIATED_FEATURES,      /* u64 */
> > +       VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
> > +       VDPA_ATTR_DEV_SUPPORTED_FEATURES,       /* u64 */
> 
> I wonder if it's better to split the patches into three where the
> above command could be implemented separately.

I already sent three. You mean split the third patch into three?

> 
> > +
> >         /* new attributes must be added above here */
> >         VDPA_ATTR_MAX,
> >  };
> > diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> > index 4ccb564872a0..d0dd4196610f 100644
> > --- a/vdpa/vdpa.c
> > +++ b/vdpa/vdpa.c
> > @@ -23,6 +23,7 @@
> >  #define VDPA_OPT_VDEV_HANDLE           BIT(3)
> >  #define VDPA_OPT_VDEV_MAC              BIT(4)
> >  #define VDPA_OPT_VDEV_MTU              BIT(5)
> > +#define VDPA_OPT_MAX_VQP               BIT(6)
> >
> >  struct vdpa_opts {
> >         uint64_t present; /* flags of present items */
> > @@ -32,6 +33,7 @@ struct vdpa_opts {
> >         unsigned int device_id;
> >         char mac[ETH_ALEN];
> >         uint16_t mtu;
> > +       uint16_t max_vqp;
> >  };
> >
> >  struct vdpa {
> > @@ -78,6 +80,9 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
> >         [VDPA_ATTR_DEV_VENDOR_ID] = MNL_TYPE_U32,
> >         [VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
> >         [VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
> > +       [VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> > +       [VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
> > +       [VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
> >  };
> >
> >  static int attr_cb(const struct nlattr *attr, void *data)
> > @@ -219,6 +224,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
> >                              sizeof(opts->mac), opts->mac);
> >         if (opts->present & VDPA_OPT_VDEV_MTU)
> >                 mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
> > +       if (opts->present & VDPA_OPT_MAX_VQP)
> > +               mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
> >  }
> >
> >  static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> > @@ -287,6 +294,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> >
> >                         NEXT_ARG_FWD();
> >                         o_found |= VDPA_OPT_VDEV_MTU;
> > +               } else if ((matches(*argv, "max_vqp")  == 0) && (o_optional & VDPA_OPT_MAX_VQP)) {
> > +                       NEXT_ARG_FWD();
> > +                       err = vdpa_argv_u16(vdpa, argc, argv, &opts->max_vqp);
> > +                       if (err)
> > +                               return err;
> > +
> > +                       NEXT_ARG_FWD();
> > +                       o_found |= VDPA_OPT_MAX_VQP;
> >                 } else {
> >                         fprintf(stderr, "Unknown option \"%s\"\n", *argv);
> >                         return -EINVAL;
> > @@ -385,6 +400,77 @@ static const char *parse_class(int num)
> >         return class ? class : "< unknown class >";
> >  }
> >
> > +static const char * const net_feature_strs[64] = {
> > +       [VIRTIO_NET_F_CSUM] = "CSUM",
> > +       [VIRTIO_NET_F_GUEST_CSUM] = "GUEST_CSUM",
> > +       [VIRTIO_NET_F_CTRL_GUEST_OFFLOADS] = "CTRL_GUEST_OFFLOADS",
> > +       [VIRTIO_NET_F_MTU] = "MTU",
> > +       [VIRTIO_NET_F_MAC] = "MAC",
> > +       [VIRTIO_NET_F_GUEST_TSO4] = "GUEST_TSO4",
> > +       [VIRTIO_NET_F_GUEST_TSO6] = "GUEST_TSO6",
> > +       [VIRTIO_NET_F_GUEST_ECN] = "GUEST_ECN",
> > +       [VIRTIO_NET_F_GUEST_UFO] = "GUEST_UFO",
> > +       [VIRTIO_NET_F_HOST_TSO4] = "HOST_TSO4",
> > +       [VIRTIO_NET_F_HOST_TSO6] = "HOST_TSO6",
> > +       [VIRTIO_NET_F_HOST_ECN] = "HOST_ECN",
> > +       [VIRTIO_NET_F_HOST_UFO] = "HOST_UFO",
> > +       [VIRTIO_NET_F_MRG_RXBUF] = "MRG_RXBUF",
> > +       [VIRTIO_NET_F_STATUS] = "STATUS",
> > +       [VIRTIO_NET_F_CTRL_VQ] = "CTRL_VQ",
> > +       [VIRTIO_NET_F_CTRL_RX] = "CTRL_RX",
> > +       [VIRTIO_NET_F_CTRL_VLAN] = "CTRL_VLAN",
> > +       [VIRTIO_NET_F_CTRL_RX_EXTRA] = "CTRL_RX_EXTRA",
> > +       [VIRTIO_NET_F_GUEST_ANNOUNCE] = "GUEST_ANNOUNCE",
> > +       [VIRTIO_NET_F_MQ] = "MQ",
> > +       [VIRTIO_F_NOTIFY_ON_EMPTY] = "NOTIFY_ON_EMPTY",
> > +       [VIRTIO_NET_F_CTRL_MAC_ADDR] = "CTRL_MAC_ADDR",
> > +       [VIRTIO_F_ANY_LAYOUT] = "ANY_LAYOUT",
> > +       [VIRTIO_NET_F_RSC_EXT] = "RSC_EXT",
> > +       [VIRTIO_NET_F_STANDBY] = "STANDBY",
> > +};
> 
> It seems we are still missing things that are already supported in the
> Linux uapi. I think it's better to support them. E.g the RSS and
> SPEED_DUPLEX etc.
> 

Will do.

> > +
> > +#define VDPA_EXT_FEATURES_SZ (VIRTIO_DEV_INDEPENDENT_F_END - \
> > +                             VIRTIO_DEV_INDEPENDENT_F_START + 1)
> > +
> > +static const char * const ext_feature_strs[VDPA_EXT_FEATURES_SZ] = {
> > +       [VIRTIO_F_RING_INDIRECT_DESC - VIRTIO_DEV_INDEPENDENT_F_START] = "RING_INDIRECT_DESC",
> > +       [VIRTIO_F_RING_EVENT_IDX - VIRTIO_DEV_INDEPENDENT_F_START] = "RING_EVENT_IDX",
> > +       [VIRTIO_F_VERSION_1 - VIRTIO_DEV_INDEPENDENT_F_START] = "VERSION_1",
> > +       [VIRTIO_F_ACCESS_PLATFORM - VIRTIO_DEV_INDEPENDENT_F_START] = "ACCESS_PLATFORM",
> > +       [VIRTIO_F_RING_PACKED - VIRTIO_DEV_INDEPENDENT_F_START] = "RING_PACKED",
> > +       [VIRTIO_F_IN_ORDER - VIRTIO_DEV_INDEPENDENT_F_START] = "IN_ORDER",
> > +       [VIRTIO_F_ORDER_PLATFORM - VIRTIO_DEV_INDEPENDENT_F_START] = "ORDER_PLATFORM",
> > +       [VIRTIO_F_SR_IOV - VIRTIO_DEV_INDEPENDENT_F_START] = "SR_IOV",
> > +       [VIRTIO_F_NOTIFICATION_DATA - VIRTIO_DEV_INDEPENDENT_F_START] = "NOTIFICATION_DATA",
> > +};
> > +
> > +static void print_net_features(struct vdpa *vdpa, uint64_t features, bool maxf)
> > +{
> > +       const char *s;
> > +       int i;
> > +
> > +       if (maxf)
> > +               pr_out_array_start(vdpa, "dev_features");
> > +       else
> > +               pr_out_array_start(vdpa, "negotiated_features");
> > +
> > +       for (i = 0; i < 64; i++) {
> > +               if (!(features & (1ULL << i)))
> > +                       continue;
> > +
> > +               if (i >= VIRTIO_DEV_INDEPENDENT_F_START && i <= VIRTIO_DEV_INDEPENDENT_F_END)
> 
> I don't see any issue that just use VIRTIO_TRANSPORT_F_START and
> VIRTIO_TRANSPORT_F_END (even if END can change).

I don't get you

> 
> > +                       s = ext_feature_strs[i - VIRTIO_DEV_INDEPENDENT_F_START];
> > +               else
> > +                       s = net_feature_strs[i];
> > +
> > +               if (!s)
> > +                       print_uint(PRINT_ANY, NULL, " unrecognized_bit_%d", i);
> > +               else
> > +                       print_string(PRINT_ANY, NULL, " %s", s);
> > +       }
> > +       pr_out_array_end(vdpa);
> > +}
> > +
> >  static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
> >                                 struct nlattr **tb)
> >  {
> > @@ -408,6 +494,22 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
> >                 pr_out_array_end(vdpa);
> >         }
> >
> > +       if (tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]) {
> > +               uint16_t num_vqs;
> > +
> > +               if (!vdpa->json_output)
> > +                       printf("\n");
> > +               num_vqs = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]);
> > +               print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
> > +       }
> > +
> > +       if (tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]) {
> > +               uint64_t features;
> > +
> > +               features  = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]);
> > +               print_net_features(vdpa, features, true);
> 
> Do we need to check whether it's a networking device before trying to
> print the feature

Yes, will fix

> and for other type devices we can simply print the
> bit number as a startup?
> 

Why not add proper support (e.g. strings) for other types of devices when intoduced?

> Thanks
> 
> > +       }
> > +
> >         pr_out_handle_end(vdpa);
> >  }
> >
> > @@ -557,7 +659,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
> >                                           NLM_F_REQUEST | NLM_F_ACK);
> >         err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
> >                                   VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
> > -                                 VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU);
> > +                                 VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU | VDPA_OPT_MAX_VQP);
> >         if (err)
> >                 return err;
> >
> > @@ -579,9 +681,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
> >         return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
> >  }
> >
> > -static void pr_out_dev_net_config(struct nlattr **tb)
> > +static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
> >  {
> >         SPRINT_BUF(macaddr);
> > +       uint64_t val_u64;
> >         uint16_t val_u16;
> >
> >         if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
> > @@ -610,6 +713,10 @@ static void pr_out_dev_net_config(struct nlattr **tb)
> >                 val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MTU]);
> >                 print_uint(PRINT_ANY, "mtu", "mtu %d ", val_u16);
> >         }
> > +       if (tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]) {
> > +               val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
> > +               print_net_features(vdpa, val_u64, false);
> > +       }
> >  }
> >
> >  static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> > @@ -619,7 +726,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> >         pr_out_vdev_handle_start(vdpa, tb);
> >         switch (device_id) {
> >         case VIRTIO_ID_NET:
> > -               pr_out_dev_net_config(tb);
> > +               pr_out_dev_net_config(vdpa, tb);
> >                 break;
> >         default:
> >                 break;
> > --
> > 2.34.1
> >
> 
