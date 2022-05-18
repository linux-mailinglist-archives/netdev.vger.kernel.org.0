Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58ED552C2EB
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 21:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241811AbiERS6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 14:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241809AbiERS6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 14:58:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2131.outbound.protection.outlook.com [40.107.92.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C76E218FF8
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 11:58:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhoGfJdVoviY5Oru2M1M5s44lih9u4r2fJQMFxoICboGkKC2J1DIWNagw3Ri4R8niVlB4iV5Hc3nHluQn1xj5toRU/5Sif6Mrm0asHprdYYs2XKBRDKBGwDiOodsbqbHF3YyE/CqI224RRdRsqeQHC0cRZWpEgQuYfZ/qhjgXGbTy7t0EjdYdwLh3mRwOZmlO3BUaQaeEqD1biXCwxAIq6FiqIkbFa7C9i29M+NoqRg8+T8iHfyz5ksM6JY0r+f3T5hql2RBbfDHwYUYY0B9Z6go71Kl9KXkzXnMPTnF02j3sEUQ/Vlctum0Ejkb7kbU3KDkkjttPwzob3bIrMM0mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FoIwnOcN0XBSbhXelpoa6hLhymtsgdGAFXUuLBPCkiw=;
 b=lHBPBWF0ix2N+Me5XDM626/S78hoZjENs2F1V4KzFgTVcXCPWogOAcV7P+Fg8i22oH/OhIg1fW+EUDSvnY0GgAc5yEVoxh4kpKvIR6JA/eoV1NH28oYWfzID2328DEq7W2M8jWMGTi/O8DoNyRnr4Cm2s+HMATJknSzCjLKydhSlQR3yvuKFscOdaAjGCl4+lJGbyNv2bMXjCdCYj9uTlwX0bd5FqEFgBbtvR+imCcPa5hF2WqvgOd1WslzBzxztAf/+knlBaNNxYc7QITY45YMwaJ2aG1ITwjhb+x9QqmrvxcqyNksNNzUgekzWxTt/xnJ/d0foRV2cRwW5dyRYFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FoIwnOcN0XBSbhXelpoa6hLhymtsgdGAFXUuLBPCkiw=;
 b=SUmb7n20UTZWzburCME++d48fLrezQAH/Gbo/WTknzIbxSAAUQd1/4UID7QY3G8vcgD48T9vyzD0iVNpzD/Qzu9ilhnpPzlHumnnG7tyNEN9MguLR703xHQamVEO073lCrmre9/ZLU+ihgz9FrtaFW6GXHut5DPstqid+BLeFHQ=
Received: from BN0PR08MB6951.namprd08.prod.outlook.com (2603:10b6:408:128::14)
 by CY4PR08MB2886.namprd08.prod.outlook.com (2603:10b6:903:144::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 18:58:31 +0000
Received: from BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::a405:a624:766d:ac03]) by BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::a405:a624:766d:ac03%9]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 18:58:31 +0000
From:   "Pighin, Anthony (Nokia - CA/Ottawa)" <anthony.pighin@nokia.com>
To:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: PROBLEM: XGBE unable to autoneg when advertising only 1GbE KX mode
Thread-Topic: PROBLEM: XGBE unable to autoneg when advertising only 1GbE KX
 mode
Thread-Index: Adhq6SOY1KmnMJK/RB+qkdHbxB46Qw==
Date:   Wed, 18 May 2022 18:58:31 +0000
Message-ID: <BN0PR08MB6951015C28F25C9B7E011ADA83D19@BN0PR08MB6951.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd70f34c-ddaa-43ce-eb4e-08da390066c4
x-ms-traffictypediagnostic: CY4PR08MB2886:EE_
x-microsoft-antispam-prvs: <CY4PR08MB288652CF3DE379349BE71C5E83D19@CY4PR08MB2886.namprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t+O7Is8CK1vVIFm7jxlT4FsCayFnQB7waZt11qwMsBeQAEZ7Tg6Ln1e0RFaJILN/LvYNMPV04gYKrPVjc/WlfGTihiV/KLcV4Xo2NW+gsPdlYUFnHZFKUv96r3jeymSpbA3WyusbqS2XIORw5n5ITBfbzyVZm70J2CuFJd7tiVTMl5vT3Bd7G/8LgohykkMiik9kttG0p0Eqj7vJ2Zx4PTjQTOFsH6VVi+GfEqtRmhgztlE8R04jXkzhtJ+OCppTVaQxmBpGXOxS6k/mCyJDLXF4dp+G0/qvmvdsRWgbga3MU1mW12Yc2iY+5PJH24fNbgv26NPZMKyd0U6QoaT8j1zYTYCbr1/OTKDpxoE/oA8Vg+U6Iaa5EMu2OrONCXXQlmKgNHJoCAe1U+g2cx840MWd6w7JjbXh/QS9mkNxQSVDazqBpRZJjtxoWa0dTx0cGRsfgkKo5VX35S1ICeWXjUuM9JbZ2xGunrCI4ihbAP6NQMdllWqo4O8ShrKCTtl1414RE/EQujt9fr4IVYIIPoQUJzY/GeCRAJRhESGuH/y9jzbB7kp0OjEGUY5FDGuP7bg84AGCltwxchhphrhkVafm6a093uIsqxyUn6SGb8H5Iz3bvGUfXoTWhHA9cg35t2zvd15XL20mA7YsJ+CJ6W01TgsjFIUVY9D1cBSxf5OqdspTMf/+9dOa6GzODA7u6Qi2gUjYLyhMCgBEn6WXMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR08MB6951.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66446008)(122000001)(83380400001)(8676002)(316002)(6916009)(38070700005)(186003)(9686003)(76116006)(64756008)(7696005)(4326008)(66556008)(82960400001)(66946007)(86362001)(33656002)(71200400001)(8936002)(52536014)(508600001)(55016003)(2906002)(26005)(38100700002)(66476007)(6506007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pYbmLAjPP35ZzyLK/sVLymF47rLy6VsVG6pjYPYfYbBgMDdQGNC72vW+KD6o?=
 =?us-ascii?Q?N8FTwI5LsX11aeGUpST7hCUMWc1NoSPtVPaqCBDZvHGZ67I/xdUE57B5f5t8?=
 =?us-ascii?Q?iZvcCfvwP3YKLkXW0fX9kkZ5EB5+6HFq4sFQm3P0lNbZ6rk7RhqLHGvg+O7L?=
 =?us-ascii?Q?8036PRMqy+5G+neaKYEfIVPRzv+ZT8M4XgOJm8NBJTMW+/Qvd/ECZ82ZvIRv?=
 =?us-ascii?Q?cwYj4O60JFocM7RblD2QwIGS21kkpRGxlZPY49uPiYRXk/X7s5kLaBlh2kQT?=
 =?us-ascii?Q?soQpfN1TJ3MSeGPOJzZtDzx0a1XyUsQrMRNs+xdN31z8EXt+65RdIUxIH8BK?=
 =?us-ascii?Q?tacoC6xjAwwJNdIq22G74eRuAQ88M1p26CsqP5NI+y2tnm8YsKc1tkP69rCE?=
 =?us-ascii?Q?28IRMDMojJkvtuKA9zJpb1GHt7aMbrVtqzLVHX1BsDTwCukVVGi+lTU6rhhx?=
 =?us-ascii?Q?2utr/8yr0oSiaMnBGsKY3HaDpY0p/X3oBD0jn4cvy7jacAVVqMCapOHk0hSj?=
 =?us-ascii?Q?36MI9rEBfMNK0Q3SL7hHmldvtsN+M00tdbViifV64OqmLRBtglPkRCS0GH2z?=
 =?us-ascii?Q?bbGf0xZ/jiBiZUwQc8x7kf9VlqJLj4R2AEU8bWV5e47p6+G4hBT2QL8dxxOp?=
 =?us-ascii?Q?ACQhBpQC+nk5mIRsKs77cBkaQFtkliYS2cGePlCnbl7aegJ/cU8jvpjbMbTw?=
 =?us-ascii?Q?7d2yotgyVrP5P6nsw2gH1Jy4gNTXdngdG0HYF5ZQuXZfYoDgQ5VWOVcHSItG?=
 =?us-ascii?Q?KDBzDwcz30olxmWOa90RPRujJlYO5F9H7ag5QrHfYLOXld/6mlYxbMpAMCOv?=
 =?us-ascii?Q?TyKwXwhA6aQ2gBqJDxJ1kNJ8fNKmGvjEk8sT4TYANuyDrTCx88YS9gcocz9G?=
 =?us-ascii?Q?nxp9sleY/XSgbscPvvZICPyOhgF4flI6UIrjr07x0AtUfuFzlnwqu2DPuqW5?=
 =?us-ascii?Q?IGNDU4UqWZzlDvCiF8Cu6niT7vXdT+i3jKuBZbSZOMO2Zg0CPkoFN5+3v2/D?=
 =?us-ascii?Q?5ZEaIol33UrIBK6XmWWbWQWMhHFL1+nW3/NDERUnTXMDuZbqlnnlmH3l5a3O?=
 =?us-ascii?Q?dWOG+8ITr7vEdWpeTRqDQMBPiedE1crIlOCoqo4adcuVJ5v0lOjDNiLKxn+n?=
 =?us-ascii?Q?n+DZkAXwIzN/PBWnAptEqW2NmiH5D+uUZ4+c6GykJJcL5vcg3zrhLzhk97zY?=
 =?us-ascii?Q?M7hdqFVJcFacv4hLIkRGQPxL/Wf8RUiYra2h6m45mVZpoh25v+V79xXf3i/5?=
 =?us-ascii?Q?Gyvxaqx6yA8+gbLMZ26C8QjR36o27Dflea0Eumg1Hd4j12mu1HEmvFeRGNBl?=
 =?us-ascii?Q?vv+/cbqxfmlVFuVNNh9jMVcZewX4K/foQ1DKZHsvRv6B+G594Py9IH99Gl9B?=
 =?us-ascii?Q?j8sRcka/0ey6ALD5dDs7CLpd9WMU7jk76J2PpwFPaUfOlNvI66hcIk/VcIcF?=
 =?us-ascii?Q?hzRBoT1Xu4IibdiCHv2Fge4EUG1hbazEPSEOPoYNXA3hSlCU79I+aMmoPPq7?=
 =?us-ascii?Q?BFV6e65fSe0S7v/kX1MUOnEOIJSNNXhkFZlwIIQrz1EbSgoGhMesbp8n/926?=
 =?us-ascii?Q?rYCvwcj/cMCrEcAaLH/crHZSvldU5PB/rykhrHuLB3sUYj5lXq8+sPNz9MHY?=
 =?us-ascii?Q?kBiq3gSVeWC9EGhNUmxlszXzPvByVIEtkM3Saf+RUE+bd0uurAk9fotRNDbX?=
 =?us-ascii?Q?cnQwKBf7BXAMLKxt/OpsFuN68ABpwl3owFNIagAMTmas5P3RbgSfywTdY3f5?=
 =?us-ascii?Q?u5heL76QLwjlsd5ToECTJCtrgXhDsj8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR08MB6951.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd70f34c-ddaa-43ce-eb4e-08da390066c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 18:58:31.3154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s7uT/JJ22sbkmYE9nDlXQn7BPMLJSWn5U6PMbjCnrJPLLJqBZ+klNgTIPql9XG/MxCf5xZ+L1qN2TSmGcHEG59MoqaCPDYGshohnhDYqemo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR08MB2886
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested on Linux 5.15.22.

Step 1. Force (both sides) of the Link to advertise 1000baseKX/Full only
root@localhost:~# ethtool --change bp3 advertise 0x20000
root@localhost:~# ethtool bp3
Settings for bp3:
        Supported ports: [ Backplane ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseKX/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: Unknown!
        Duplex: Unknown! (255)
        Port: None
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Current message level: 0x00000034 (52)
                               link ifdown ifup
        Link detected: no

Step 2. Bring Up both sides of the Link:
root@localhost:~# ip link set bp3 up

Result. Link stays Down:
root@localhost:~# ethtool bp3
Settings for bp3:
        Supported ports: [ Backplane ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseKX/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  Not reported
        Link partner advertised pause frame use: No
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: Unknown!
        Duplex: Full
        Port: None
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Current message level: 0x00000034 (52)
                               link ifdown ifup
        Link detected: no

Step 3. Change one side of the Link to advertise 1000baseKX/Full and 10000b=
aseKR/Full:
root@localhost:~# ethtool --change bp3 advertise 0xa000

Result: Link comes Up at 1000baseKX/Full:
root@localhost:~# ethtool bp3
Settings for bp3:
        Supported ports: [ Backplane ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseKX/Full
                                10000baseKR/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  1000baseKX/Full
        Link partner advertised pause frame use: No
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Port: None
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Current message level: 0x00000034 (52)
                               link ifdown ifup
        Link detected: yes


Logs during initial Link up failures (when only advertising 1000baseKX/Full=
):

[  581.429431] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=3D0x00=
020000
[  581.429437] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=3D0x03=
000001
[  581.429722] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=3D0x00=
020000
[  581.429724] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=3D0x02=
000001
[  581.542950] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=3D0x00=
020000
[  581.542954] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=3D0x00=
000001
[  581.661399] xgbe_check_link_timeout:1292: amd-xgbe 0000:0d:00.7 bp3: AN =
link timeout
[  581.661403] __xgbe_phy_config_aneg:1214: amd-xgbe 0000:0d:00.7 bp3: AN P=
HY configuration
[  581.663591] xgbe_phy_kx_1000_mode:2160: amd-xgbe 0000:0d:00.7 bp3: 1GbE =
KX mode set
[  581.663602] xgbe_an73_disable:422: amd-xgbe 0000:0d:00.7 bp3: CL73 AN di=
sabled
[  581.663618] xgbe_an37_disable:381: amd-xgbe 0000:0d:00.7 bp3: CL37 AN di=
sabled
[  581.663639] xgbe_an73_init:1051: amd-xgbe 0000:0d:00.7 bp3: CL73 AN init=
ialized
[  581.663650] xgbe_an73_restart:412: amd-xgbe 0000:0d:00.7 bp3: CL73 AN en=
abled/restarted
[  581.763656] xgbe_an_isr_task:695: amd-xgbe 0000:0d:00.7 bp3: AN interrup=
t received
[  581.763672] xgbe_an73_state_machine:847: amd-xgbe 0000:0d:00.7 bp3: CL73=
 AN Incompatible-Link
[  581.763676] xgbe_an73_state_machine:907: amd-xgbe 0000:0d:00.7 bp3: CL73=
 AN result: No-Link
[  581.763682] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=3D0x00=
020000
[  581.763685] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=3D0x02=
000001
[  581.764848] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=3D0x00=
020000
[  581.764851] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=3D0x03=
000001
[  581.765865] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=3D0x00=
020000
[  581.765867] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=3D0x02=
000001
[  581.766258] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=3D0x00=
020000
[  581.766260] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=3D0x03=
000001
[  581.767364] xgbe_phy_kr_mode:2132: amd-xgbe 0000:0d:00.7 bp3: 10GbE KR m=
ode set
[  581.767593] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=3D0x00=
020000
[  581.767596] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=3D0x02=
000001
[  581.769699] xgbe_phy_power_off:2053: amd-xgbe 0000:0d:00.7 bp3: phy powe=
red off
[  581.772065] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=3D0x00=
020000
[  581.772068] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=3D0x03=
000001
[  581.773534] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=3D0x00=
020000
[  581.773537] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=3D0x02=
000001
[  581.773593] xgbe_phy_kr_mode:2132: amd-xgbe 0000:0d:00.7 bp3: 10GbE KR m=
ode set
[  581.773604] xgbe_an73_disable:422: amd-xgbe 0000:0d:00.7 bp3: CL73 AN di=
sabled
[  581.773619] xgbe_an37_disable:381: amd-xgbe 0000:0d:00.7 bp3: CL37 AN di=
sabled
[  581.773626] xgbe_an73_state_machine:913: amd-xgbe 0000:0d:00.7 bp3:  PHY=
 Reset
[  581.773628] xgbe_an73_state_machine:847: amd-xgbe 0000:0d:00.7 bp3: CL73=
 AN Ready
[  581.773723] xgbe_isr_task:493: amd-xgbe 0000:0d:00.7 bp3: DMA_ISR=3D0x00=
020000
[  581.773726] xgbe_isr_task:542: amd-xgbe 0000:0d:00.7 bp3: MAC_ISR=3D0x00=
000001

Anthony
