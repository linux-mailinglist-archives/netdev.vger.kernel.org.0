Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726FE2ADA9B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbgKJPkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:40:04 -0500
Received: from mail-vi1eur05on2088.outbound.protection.outlook.com ([40.107.21.88]:18913
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730432AbgKJPkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 10:40:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEXizu+3S8qrBcBdU9UjJejliNHuOZiluQEndn5++UE2ExozR1e+xMzgaUJVTFJoK8mn/wOlIqUTxxUmpPfGOM2IvzxczM71OdJZVHt0s/O+Qcv1Cmhs92dSmdLIzuhlNIkfqzHy+QcZMuSfBgn2ZXXceLe2ivza2zgWQFEny6sUPOExqIbPJ5NBSatZshlv7umDs/+oU9G7DYbUClwAo+JUKSV/rIBkTU9lWZjh3iaFw0xLQ7ah74fqpLLx6zW/sHyrGRTlRNYO37jVzke2rz9OSLl2xFJ8Okm0hcIpuZGZhEJu+o0QdJ5h9w0iH5FmsZw4I7GD6c4F5i6ZGJ/Jcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4pmNW9JeDnANViQQK+R4mxgYfb1HLNufLFYnnAZTD0=;
 b=f7HaaHjOpY3VJN2nYLb41zvcJ08l4PRerMv7EdHKUgzgEWUb7VUrfz/rSfHErntjICBQBM+6ZcpHwyMX52u+oLh2QVYJS+8MMpiaMj3Xpk0YuG+bIos7vchQTqXcp9mykJY/rEuRCMsBrzlJi0WxZEWLVOUOb8T7+8zoKmrn+u6oGmXuGt3gG7ck107x1RN3YOfeMtI725cXAPXoPEO9jf3R4Nwk+RgsmPRKRnzSeHvxvHKDN1qkSfpOyMMP1RsJ14+HWH8gRhbXxPquJhl3S2fk1tCY4Y2ULDhTHnsYAJJD2DfVA4zCgPaT/TXDHI8Qi/5V83RvcqY3he7BVlHKgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ipetronik.com; dmarc=pass action=none
 header.from=ipetronik.com; dkim=pass header.d=ipetronik.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ipetronik.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4pmNW9JeDnANViQQK+R4mxgYfb1HLNufLFYnnAZTD0=;
 b=hoKKxPmb37FzOnEFYRMi9dw9gYHGmDY+P9Nx+iQreNW+77HT7Cl0xi2D6y82pAbsqoZks3/94Wjr6aAklb0vsQndDq3dERw7VP/n/E/NxAa5Yily+zldohxL5P+Mk8cEbLB7ur47LGnoLSEb/Bj5kRtiO7SuUyxBG4qFZNhJE4g8egM05rh3N4kfH+Jngm4HgFp81FTGX5kzo3U4YoX1D9bnRjMCJcxYCrfygIeVqEPlYHOqUQxXB8O6VFBS6p9/8NsU8azo05M4qHWZ5yHyzrRkwS5RunHVc2RN5CM0yOn7yq+CKRQE8tkYAZBX0lQUWE8mw5Rd1+1ngUEedDCdmw==
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=ipetronik.com;
Received: from AM0P193MB0531.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:16d::10)
 by AM9P193MB1096.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:1cf::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Tue, 10 Nov
 2020 15:40:00 +0000
Received: from AM0P193MB0531.EURP193.PROD.OUTLOOK.COM
 ([fe80::9d9a:174:f57d:abe1]) by AM0P193MB0531.EURP193.PROD.OUTLOOK.COM
 ([fe80::9d9a:174:f57d:abe1%6]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 15:40:00 +0000
Date:   Tue, 10 Nov 2020 16:39:58 +0100
From:   Markus =?utf-8?Q?Bl=C3=B6chl?= <markus.bloechl@ipetronik.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
Subject: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
Message-ID: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2001:16b8:2d4a:d400:228:f8ff:feed:2952]
X-ClientProxiedBy: AM0PR07CA0017.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::30) To AM0P193MB0531.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:16d::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ipetronik.com (2001:16b8:2d4a:d400:228:f8ff:feed:2952) by AM0PR07CA0017.eurprd07.prod.outlook.com (2603:10a6:208:ac::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13 via Frontend Transport; Tue, 10 Nov 2020 15:39:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afb46aef-0a53-48bf-6e0e-08d8858ee24a
X-MS-TrafficTypeDiagnostic: AM9P193MB1096:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P193MB1096D3BA4ADAC388BBC6C30192E90@AM9P193MB1096.EURP193.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lWyT1S8GNS2uKenM+MfMmpN7Z7v3vHwvEjH4TjmM0zEl2sd4BdvnoGczaGA6spRR4nYJVyzxPrCcalbESF+5CROpn3jlVO85cYGQswIFioMHU3G4eB/kPSWQ4EUaJR+jTK9sgpRBhqmoz2rqHMbmol8uexyKqfiMOwOlLzfD2D8AZWIBTtraqNp4qNjFRwlyMPTSGtwpvbdoTaeOmUIGgB8DmLny1WEfv8G8NeoM+Tw6ymrwVbTbc03HLfZds72sHTjfSqsVYwJ5tswp/uOC/Q8QWvy2khBVyG2ySVqc+rQgoDUh6IPYX+unYVuifU1ySlfDMnWo4iJ6/FWEeUYPqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P193MB0531.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(66476007)(55016002)(66556008)(66946007)(5660300002)(498600001)(66574015)(186003)(1076003)(8886007)(4326008)(86362001)(110136005)(83380400001)(2906002)(36756003)(8676002)(7696005)(52116002)(966005)(8936002)(2616005)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VqyyMYFKrlxK9sB4JuO7/vBJ4GaSJPGkrx/tf/539qOqYDFvb9966RxY+etYVgjBC5KWay0cbeDUOM48u72Wf3AO6JTEiYbOlOIuimVOcJFu9eNMEZr3Ti+aM6KmuV2vZndwWACzF0tcT2pm1+qF12d7Mqoujm61ujfC0Oea/GLfiXJmSqCLR0T4thcEh3ExRIybS4hOia8/j67RHRhPaiWlDkseIWooNoqOi/dteBi5GxBSBMJFgowMyjAzKWY1mNk7xBwd4RkH+CbWUcBaGBXSJkJapjqbhS+aHzFC+7kWyppurOkuooE2Hibg1OwZISX6euCrP1xvStMWurLPl4N/oy/k+p+kOc+ITEPMvCSNwvy6MS4QTs3Ww7r9+7UWDGkb9QqTrgPeIv25Y5uNP94beCvTaX7MlbRLeQUez0pj500W/D0xOQJogH3a8jNg99hYmvqYxb6STzoqV1i+radtH9KSqfx/HyD132Tp6FzYFhEctBo66tgWHf4UGoRJs+pjy7yO8T/n43lYkcQc64qmSDT5QDaOm+j0zQzIm2HVwK/Fk2t4oBHu+Qx0m1LOhWBdZ17husL/iE8fecv+K/MHEEYfUWqPrbUrVqGapFuLqq7UqtF5QnEFTMcWO7lDxIXWHVN7rQ8cM9i5arZqvq8vJshguY4cnUVE4yMuucRuLcRq1sh9WGWAaiITIoxCQ9A1Nn3nTH5tRLN8G9ENSA==
X-OriginatorOrg: ipetronik.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afb46aef-0a53-48bf-6e0e-08d8858ee24a
X-MS-Exchange-CrossTenant-AuthSource: AM0P193MB0531.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2020 15:40:00.2807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 982fe058-7d80-4936-bdfa-9bed4f9ae127
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0NqNA2uj42YGjgZfl+M71JfmKQ0u99LC999hWfFAFyoXDweqJFW8L1WlPHoOAX/uj5uYzVIuMzqpEPr3e1iN7SKZSOMGfPa+mTiyzP+xweg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P193MB1096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rx-vlan-filter feature flag prevents unexpected tagged frames on
the wire from reaching the kernel in promiscuous mode.
Disable this offloading feature in the lan7800 controller whenever
IFF_PROMISC is set and make sure that the hardware features
are updated when IFF_PROMISC changes.

Signed-off-by: Markus Bl=C3=B6chl <markus.bloechl@ipetronik.com>
---

Notes:
    When sniffing ethernet using a LAN7800 ethernet controller, vlan-tagged
    frames are silently dropped by the controller due to the
    RFE_CTL_VLAN_FILTER flag being set by default since commit
    4a27327b156e("net: lan78xx: Add support for VLAN filtering.").

    In order to receive those tagged frames it is necessary to manually dis=
able
    rx vlan filtering using ethtool ( `ethtool -K ethX rx-vlan-filter off` =
or
    corresponding ioctls ). Setting all bits in the vlan filter table to 1 =
is
    an even worse approach, imho.

    As a user I would probably expect that setting IFF_PROMISC should be en=
ough
    in all cases to receive all valid traffic.
    Therefore I think this behaviour is a bug in the driver, since other
    drivers (notably ixgbe) automatically disable rx-vlan-filter when
    IFF_PROMISC is set. Please correct me if I am wrong here.

 drivers/net/usb/lan78xx.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 65b315bc60ab..ac6c0beeac21 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2324,13 +2324,15 @@ static int lan78xx_set_mac_addr(struct net_device *=
netdev, void *p)
 }

 /* Enable or disable Rx checksum offload engine */
-static int lan78xx_set_features(struct net_device *netdev,
-                               netdev_features_t features)
+static void lan78xx_update_features(struct net_device *netdev,
+                                   netdev_features_t features)
 {
        struct lan78xx_net *dev =3D netdev_priv(netdev);
        struct lan78xx_priv *pdata =3D (struct lan78xx_priv *)(dev->data[0]=
);
        unsigned long flags;
-       int ret;
+
+       if (netdev->flags & IFF_PROMISC)
+               features &=3D ~NETIF_F_HW_VLAN_CTAG_FILTER;

        spin_lock_irqsave(&pdata->rfe_ctl_lock, flags);

@@ -2353,12 +2355,30 @@ static int lan78xx_set_features(struct net_device *=
netdev,
                pdata->rfe_ctl &=3D ~RFE_CTL_VLAN_FILTER_;

        spin_unlock_irqrestore(&pdata->rfe_ctl_lock, flags);
+}
+
+static int lan78xx_set_features(struct net_device *netdev,
+                               netdev_features_t features)
+{
+       struct lan78xx_net *dev =3D netdev_priv(netdev);
+       struct lan78xx_priv *pdata =3D (struct lan78xx_priv *)(dev->data[0]=
);
+       int ret;
+
+       lan78xx_update_features(netdev, features);

        ret =3D lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);

        return 0;
 }

+static void lan78xx_set_rx_mode(struct net_device *netdev)
+{
+       /* Enable or disable checksum offload engines */
+       lan78xx_update_features(netdev, netdev->features);
+
+       lan78xx_set_multicast(netdev);
+}
+
 static void lan78xx_deferred_vlan_write(struct work_struct *param)
 {
        struct lan78xx_priv *pdata =3D
@@ -2528,10 +2548,7 @@ static int lan78xx_reset(struct lan78xx_net *dev)
        pdata->rfe_ctl |=3D RFE_CTL_BCAST_EN_ | RFE_CTL_DA_PERFECT_;
        ret =3D lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);

-       /* Enable or disable checksum offload engines */
-       lan78xx_set_features(dev->net, dev->net->features);
-
-       lan78xx_set_multicast(dev->net);
+       lan78xx_set_rx_mode(dev->net);

        /* reset PHY */
        ret =3D lan78xx_read_reg(dev, PMT_CTL, &buf);
@@ -3613,7 +3630,7 @@ static const struct net_device_ops lan78xx_netdev_ops=
 =3D {
        .ndo_set_mac_address    =3D lan78xx_set_mac_addr,
        .ndo_validate_addr      =3D eth_validate_addr,
        .ndo_do_ioctl           =3D phy_do_ioctl_running,
-       .ndo_set_rx_mode        =3D lan78xx_set_multicast,
+       .ndo_set_rx_mode        =3D lan78xx_set_rx_mode,
        .ndo_set_features       =3D lan78xx_set_features,
        .ndo_vlan_rx_add_vid    =3D lan78xx_vlan_rx_add_vid,
        .ndo_vlan_rx_kill_vid   =3D lan78xx_vlan_rx_kill_vid,

base-commit: 4e0396c59559264442963b349ab71f66e471f84d
--
2.29.2


Impressum/Imprint: https://www.ipetronik.com/impressum
