Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6868663776
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 03:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjAJCpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 21:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjAJCpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 21:45:12 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2062.outbound.protection.outlook.com [40.107.255.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DABD1EAD2;
        Mon,  9 Jan 2023 18:45:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyGREXf0GqwfMzxlQU6SjPfZgxRaKj5pctFBXJSFo+A/vjf+4nRGpf8QufWolRpr0xiO+U8GTWM6duREwWJPh8OzgDOcEFJ3qu/WfmHJEJmEPj8OJgORJkCnmNYCdZoEm1uJAY9KjrZ9cVREWGo6m6F3hxHrh2mTWwyo7XddkH6kRJAMuOphCm//hoOS7s+Tpitk+z2kEJ/gRerd142xuoqpn9mYQ+zzA983dg1Dr1s/gSkWuOFkzBB7EpboEVHVKd7/Aa28BVQVLWauDLYhLc5Jg945GZq3iVSIfAhNbgMPbE9LPBJtlkM9/bWcr+V7RqAQvOfVJARmzvWL4THLnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrxwP0tCzgQHM/BL1ibu0STqTeGcv0u9WwPSLIKXMP4=;
 b=awB3Wgf421H08fTZPNINTKWdK3DTU5HxvIcnple629udkfbXsKBC2OFcmeKcP52TnEy9oQSpYaozTd+oX7qQHBeNM5rfgjWc1VR7O7+Hz/qcRm1w/OSPB/V6OeN6pr3HI4a5ZTSm2k6iJX62dwFZm0OOHMJPtPb0G8sImQ4Z7GXbdguCQkGquSosLssvm4APmRFIRqmHLiW5F7LAJmxV1xy+Hpk8403ZSMyxtkLAARqJr3ncJq/9vWj1qYaRyPl8CQ9iSTNQYAcWMuOb6V3lge/M7AE9BHhZeIRiFcYaChndE7AxiiojI59c7boflolyGgfPDfn6+AwtrDnBHR98tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrxwP0tCzgQHM/BL1ibu0STqTeGcv0u9WwPSLIKXMP4=;
 b=UsL32iWLIq11RPX50rYz2WdJWSpH6I4ELAQ94Og0XE2jhQuB7hSR53hXj2yGiKhQ/i8tAmDSyy1rT1qkG+Xcavb4ULoSOSpuUy5fdwmwpppMUwQ1KPf0MxRaQb9HT/KMdVW3sBDFA6NOlWIDetK8dfEYNB5EJbnohgPs58Lof5xV7tTZLfli4gxD4Gm6PsyHD7shRyj2Yt4VAmT4E8j2vmJZuHu1o/ojEsyHVwsa9z008gF0dNF7RmzB0GJdBdZuAH7LRRnKd5wGdZYtvKh4KGDVnkg466zkNQsWGs4ItDGrzHpo9x00xOQeBG/McmKgpTPi31++rGpqjjz5vjXHqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by TYZPR06MB4046.apcprd06.prod.outlook.com (2603:1096:400:26::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.11; Tue, 10 Jan
 2023 02:45:08 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::dbda:208a:7bdb:4edf]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::dbda:208a:7bdb:4edf%6]) with mapi id 15.20.6002.012; Tue, 10 Jan 2023
 02:45:08 +0000
From:   liming.wu@jaguarmicro.com
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        398776277@qq.com, Liming Wu <liming.wu@jaguarmicro.com>
Subject: [PATCH] vhost: remove unused paramete
Date:   Tue, 10 Jan 2023 10:44:45 +0800
Message-Id: <20230110024445.303-1-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.34.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0023.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::17) To PSAPR06MB3942.apcprd06.prod.outlook.com
 (2603:1096:301:2b::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|TYZPR06MB4046:EE_
X-MS-Office365-Filtering-Correlation-Id: 11c3b926-3896-4768-4c2b-08daf2b4af78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dhGXBBIhJvEYNAXDukKrvk6xm6YNr1tnMvrlQd8X8aX8EDixwJPbrco4p91G8ymIlyh7GbO0PU9zJ61vN0h7528QwTrJHWDCfsDYSe7ySmEGSG6oIrxdhNpMuSN5XypyWeQ1T22xhxrVY2yyo8QvLqUhGJC5S5ScHqhIZOMSxNakbZzRtOtPkwWhcAoHLtwqUP6z7ubxgajQQ7F2xARM2qJmhv+9CzVcP42ZPRrxogCt4d2OPRg7/XOvSjhhQu8vzZhjrsYvDt4/VY2cRXFqBl0d88uX5L8aQBpOwBD7HZYCXe6vf41izKd6uYK5BohEXMZdPRSHaycJP1Yiby3lBUXb0qxureko2CG1hnwUgIkyTOQZuhIqwmoYzxknyS/H4wfdeiX5qBz7+/BRF9AAWKhtdj9L8iXufJb/MdKkxcBhGcyE83E6EeNmMwuRKoVlilwpdlhMGEuDEIhin1U4KW+05H0FV8+RueS2Zg5UhXUapHHFtPqrEwtdOnIVUekkXvzyBQQJNqKPBvT1/UV2rf9rHDMGjP7z36VrC/gdYOR55qZIihuhQWHJ/SD0nT/ic2W5xsZeR6BMg8+pDErpbkW1yKvJ+n4WNT4Oj1JB45y1K9U8Igx3xsAo/ZxZseNAFXUZiJVK9r/C6TKgWgukN3cxLiJyDZQPNEjoTKXkwbiSaZKI7h9tjDLFV2xG9qp5DJPsgKkXy0LmgUDd+lLW+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(39830400003)(396003)(376002)(451199015)(86362001)(6666004)(107886003)(41300700001)(6506007)(5660300002)(83380400001)(8936002)(66946007)(66556008)(478600001)(4326008)(66476007)(316002)(6486002)(8676002)(2616005)(186003)(26005)(110136005)(1076003)(9686003)(6512007)(2906002)(52116002)(6636002)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cXxKXQfryOkdxlj0QX8fWYQ36sHM4ERDIdO207Q2l3t3k6PEVIJJzaSPvToB?=
 =?us-ascii?Q?eaA9Sd3yCSkIxeJHLyaDLuRIzWdlvZQfuTfrTqgIZvUFMhZtFEDE4LpnFCT2?=
 =?us-ascii?Q?tLbz1b47+GKPMRLixeQL8cuVVB6lQn9XsrBG0+m8vUvorrdZsyItRLxyJYER?=
 =?us-ascii?Q?Lv3I3Afq3P4OvmOPV9DqIqqAe3ddRd0Y5q/UVb4Ub9EDwNH49OR32SkCUZa0?=
 =?us-ascii?Q?a7neErKCACy2z/pZNAIEar9skwhfVVhtqF+Llmd1xrLpEyOFyl2MpepT+St3?=
 =?us-ascii?Q?0tfXogER9N6Qyl8YO+oi5cjb8a3LY4MGr/SKn+nfXhjUGdSSSApgbb+bpT0X?=
 =?us-ascii?Q?tNk1DJWm0rfuIAr8vW50j7/Ul+FAK04Spo1mr37oBI/ylyEwjDj5NsD9jnCr?=
 =?us-ascii?Q?SFiNTuOtUM4TxDz08HfktlK6poXK/D6HSwK4gQVtCBuLcZ8Cm2jNsVe+7V4o?=
 =?us-ascii?Q?N70O2Rm4aLd05oC+5VkzliObwgnAYz78O3aQmfjZtwzbLP4EaapFSN2O8XDl?=
 =?us-ascii?Q?8sRz6iAA0W0j02BF8WeeSxun7kgiUNd+MvI5tVZUm2iiGMlDmAVucGxt1SMF?=
 =?us-ascii?Q?EL77JrYStS0ut3gw0LQ61uHCDuK9nGZaMCEFto4wRyZJ08cMsdRBXvybtv5Z?=
 =?us-ascii?Q?RlFx/XxfJaA6mZA0OOCFJYlSwaDybcyc7Ro9WmgqxAydUUBu6B6PFdZGx3ZH?=
 =?us-ascii?Q?2NBcuMt16NhcUdR+8D5HjTomuTjAbyZ0bLOHH/HArZ+Kr0cWXzzepaAP87ub?=
 =?us-ascii?Q?1rRavlh298aESm2oSrZK/rSBG7rFf2RYcbR+kimR0GzUMl3eYndU7Ng1UvmZ?=
 =?us-ascii?Q?YL9U7ZMr62EjYO2/4ras/Z2CVJLcgDejOOBVDqQ362pwqE3y9mOm4/kdfT50?=
 =?us-ascii?Q?Sjgs+P8RcI+4WedORfpQqtK5VkcEX+VOju/YvLBnMan6nr5JZ0uGc59CGFcS?=
 =?us-ascii?Q?5mPfWsCjAddy6YEa7vsbHLKUNT88SwE1LGQi7nPaiStimAAD3BzNZzPNJ9xp?=
 =?us-ascii?Q?5fHBCqHznPZ1dlIn1bAqGUZ9LMHSqdbE0dMGLvbCXx4am4If5GdapZwKlhu3?=
 =?us-ascii?Q?oySLgpeyYECZQalP29mNsgB+mDmBgM21bnADcta9e3vcx7kbb0/0W1L/UVYd?=
 =?us-ascii?Q?JGxgq/GzJzR7dC9yAZ0WDM8wCmKUvKfzkvV9L+Ftma8ejM0OmJXcDLji5UtK?=
 =?us-ascii?Q?NuQk4RPVmDBg78cHtOrE7hgatzhcmuZzDhBj+sos1CVpoEDBo9p3sSOgn0R6?=
 =?us-ascii?Q?fREtUnTHcf05S3R3ygfFoa7aYasmG4xlDgaBY3g+ZX5vOroOaGwlhOPuTt8D?=
 =?us-ascii?Q?H+D7q3BLpihLucJAQpiRNNzV2ksfJA75AbFiZm87PPInjf2f1sqqunmY9UEy?=
 =?us-ascii?Q?8qp2ybmSLB/rR7QeHIscGeijSCquaKKSFwoVaLb3ihawM/EDL0Q4A0PF6ZiO?=
 =?us-ascii?Q?3VFHp2JsBygYWSVm0mXWorNcrElnYMJ3rrv9S7cyY5q+EEueODSDaBnfbHFU?=
 =?us-ascii?Q?oHM3Z/abBZnu/EThmfFYHO32iioQigVt5rtRb5MUrUz/uaXl5Bb5CLNFIEDr?=
 =?us-ascii?Q?HWt1ZuEOFAT83fv38tHsUJUbBehEPHn7YxaOyfQEopzefkVXkGbr2wj971j6?=
 =?us-ascii?Q?ew=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c3b926-3896-4768-4c2b-08daf2b4af78
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 02:45:08.1558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 67hXgyW/dStSVizMGdqxfbkBPaT31bsmwaq/H7b+MZq50iteoOF25RrxemXghZcBU0qx4oMyEdg7arRLAgJ3rnJ8OLnH7/Amd0KUtxoUhy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB4046
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liming Wu <liming.wu@jaguarmicro.com>

"enabled" is defined in vhost_init_device_iotlb,
but it is never used. Let's remove it.

Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
---
 drivers/vhost/net.c   | 2 +-
 drivers/vhost/vhost.c | 2 +-
 drivers/vhost/vhost.h | 2 +-
 drivers/vhost/vsock.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 9af19b0cf3b7..135e23254a26 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1642,7 +1642,7 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
 		goto out_unlock;
 
 	if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
-		if (vhost_init_device_iotlb(&n->dev, true))
+		if (vhost_init_device_iotlb(&n->dev))
 			goto out_unlock;
 	}
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index cbe72bfd2f1f..34458e203716 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1729,7 +1729,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 }
 EXPORT_SYMBOL_GPL(vhost_vring_ioctl);
 
-int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled)
+int vhost_init_device_iotlb(struct vhost_dev *d)
 {
 	struct vhost_iotlb *niotlb, *oiotlb;
 	int i;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d9109107af08..4bfa10e52297 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -221,7 +221,7 @@ ssize_t vhost_chr_read_iter(struct vhost_dev *dev, struct iov_iter *to,
 			    int noblock);
 ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 			     struct iov_iter *from);
-int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
+int vhost_init_device_iotlb(struct vhost_dev *d);
 
 void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
 			  struct vhost_iotlb_map *map);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index a2b374372363..1ffa36eb3efb 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -829,7 +829,7 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
 	}
 
 	if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
-		if (vhost_init_device_iotlb(&vsock->dev, true))
+		if (vhost_init_device_iotlb(&vsock->dev))
 			goto err;
 	}
 
-- 
2.25.1

