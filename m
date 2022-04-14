Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431FA500E34
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243670AbiDNNBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 09:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243666AbiDNNBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 09:01:19 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60047.outbound.protection.outlook.com [40.107.6.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6130C92865;
        Thu, 14 Apr 2022 05:58:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCVcFcVqUXr9IXXlh4x5/yAlYzLNNcCW9/qTgezB69D9XMTi3VbwM+7R5YlK4MekuV0Pks+IU40mrz6jGC6bh8GRXwi4/lKQ+zWJSE7SNjLgNlyL6WvJ00Gy0bnWUPnN6wY5+V39UA7yOLW/HCHlpCVu5GX7LqCPOPAEesdL9saJMWWVjJCH6IwLClSNtiTugZevrsYVlmOHd6+8OnI88ud5SoC9GbelD9hgBiPyx63ijzVj8OavyF46QFrNuwiX/FQT79Z1EqSK7VBFAyMdL+o7UHUK30gEupcvNpF6JdpUjH52wIa1z9+IA8akoOO59qkiVx0WX2QjvUzIle1zTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CihIIC09A2jydUQI8mKfnMp4am53strjCDkExKUhE0Q=;
 b=LxQIwp9/lM6nYBX9ZFqrRmtXvg7F5iENthNGnXjpsYWlC15Qd1ryJQbJrnPq8pSgrm9wUMF0RUbFHWAEOwUQtGl7u9MfAJFupCLZZPqcHTmKqAcy7Dpk/OiQp7cPFZkz7OHQFNfBqfJqFstVhgt8oxju+X9wueMZiBS1nn/7dkSjS3l9+1zSBIxH1jfSTZnVkMbKxwBbTYNiMabowyRjoPyCfT829kR0MeVf1SgAIqud4CGRqVg27it/HEFMoVCkkMAiStRvGkLTFzfmVDZCBbDqSnPnfQUHn290w6iAlsF2BpqyWXtry9N7Th7vGHT713Oa0vOr7qz/EZn5/mlo5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CihIIC09A2jydUQI8mKfnMp4am53strjCDkExKUhE0Q=;
 b=sQDvnKS1oEf4scgdfyl8aC5Y+J5NsvZqzKMRvJX35QXUf/FoZBg+1zXzkISJ3R0M8Oq2n9gg1d6hsJyaTwuWmfN+uXRE2lk1pUPrhOxPp7DMrmio2Ud26ZQ+/qKZQV6QPu3l8Y7cI6DlkIBKci0JdJfkKyVEMU1wTvqIYeNjyT4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4829.eurprd04.prod.outlook.com (2603:10a6:803:5f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 12:58:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 12:58:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Kurt Kanzenbach <kurt@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2] docs: net: dsa: describe issues with checksum
 offload
Thread-Topic: [PATCH net-next v2] docs: net: dsa: describe issues with
 checksum offload
Thread-Index: AQHYTfheCzBrufjauEu7NwJglkZ/ZKzuSJmAgAALg4CAAAEaAIAAARUAgAAAwwCAAGFTAIAAqnKA
Date:   Thu, 14 Apr 2022 12:58:50 +0000
Message-ID: <20220414125849.hinuxwesqrwumpd2@skbuf>
References: <20220411230305.28951-1-luizluca@gmail.com>
 <20220413200841.4nmnv2qgapqhfnx3@skbuf> <Ylc3ca1k1IZUhFxZ@lunn.ch>
 <20220413205350.3jhtm7u6cusc7kh3@skbuf> <Ylc5RhzehbIuLswA@lunn.ch>
 <20220413210026.pe4jpq7jjefcuypo@skbuf>
 <CAJq09z7h_M9u=7jC3i3xEXCt+8wjkV9PfD4iVdje_jZ=9NZNKA@mail.gmail.com>
In-Reply-To: <CAJq09z7h_M9u=7jC3i3xEXCt+8wjkV9PfD4iVdje_jZ=9NZNKA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3716b76c-fa59-4bca-f96e-08da1e1685d9
x-ms-traffictypediagnostic: VI1PR04MB4829:EE_
x-microsoft-antispam-prvs: <VI1PR04MB482959EEA51CCF60C3DFEC74E0EF9@VI1PR04MB4829.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rkWP/7WOLhPC5tSYcfiiVV4msbyg6VL/BkBsnKnELuacYyY1p2f6WrNv/ItLQCb2e652r8MX2slRtwv+jdNh/RsEt1zPAK1G9R8fkCp0sWMar2PfbLkkcqY3L0mUry4J8K40IY37BX9oH8/+Umwqr1Z2ZlEijS2+PyAvlLHv2ljEV4tmQLA7rJ1PWsTsOu3CAc6xtcQLJxjkZfLhVY3zcZShAYfRoJl0GHBjyZpTh31+KxmJc20WqAV2fMH62F7XrTxVYJo3aph/kLuh52KMdum8ADJvEFXeb4jkfO8HyFql1fgqLav4S8BqpOjNI2KRTV17gXqvgGwR+EogGrNZsOJoxm4PVdRsKj7ePY0Io/JJlpGeyhhzReagXX9tDzSVHqgPj3Hw9qFp+WnjGXJutst4TMwyJnfIh9P17oSIfYs4K5SkMFTY7QhEHeIvwiXe25UEeBfcsKHbE6QcDoWZftMH8N+wzHIbJ8OgXrvCMXMLbyMjtr3IaPoWABGZWkMbnh3EJMU6wqaDT8lY/3pn0KZd3m877jbBJ8gZ9jwmzCMMQDIvIXFaCmnOnihvMzr/ZwG8ItOxYZJCSHRyqVRSGMj2VNle3c7noE9SCZlJ7shI2ITZfc64M5tVhXRCgozqcpGi85ak+7yEwMEyAkZ+gwY4anEVs7Yt8z48KFvqO0LJMSPGOfZ8ivRIdIsbhF7Hl+vyIxpBmPRjJ02AijBKHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(122000001)(7416002)(5660300002)(6506007)(9686003)(38100700002)(1076003)(44832011)(6512007)(508600001)(316002)(86362001)(71200400001)(6486002)(54906003)(6916009)(38070700005)(2906002)(8676002)(26005)(186003)(33716001)(4326008)(91956017)(66556008)(66946007)(66476007)(66446008)(76116006)(64756008)(83380400001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ShN5B2C7Fs5g2gOV6MgZbXI/XIg9Jo8jSe6T/ikplAcTKcE1J1sg+Ym6Yh2E?=
 =?us-ascii?Q?LH1sNYxNT+RrcHaGGCioDONnhV0Z8RPZ2YKH4PczS6jSELLqaodzM2rGX8nT?=
 =?us-ascii?Q?VCaaWc6UOeWG4guDBNAnaDECmmUeGfhwv4gb5rbRMLJOmKvfppBkyGC8rmQy?=
 =?us-ascii?Q?vULR9faFkaXUY3CzGnkptPyJvC75NA98Rs5Hxc7tS9IKgH9nRuGsvSJHtq01?=
 =?us-ascii?Q?8ldYJ1zESTMP7Rq+fD2o1RCta+uzviRseorvkZJX118AJQNhRkZoCLtGIhL5?=
 =?us-ascii?Q?UKkJeg94STERwdvbPnp92OVmGodjFI9QIXtErwJWKEIuxldciS3Xm8M7IJix?=
 =?us-ascii?Q?6RwrDTeDYQrNDb88DnulEUsaBY7zCAmHPwAF4YEtVbgJQwVVhBIai18nOOYT?=
 =?us-ascii?Q?QiDaKRmpy19MdvMGUGRtVFooB/BZPTcFDfqBd8/RUA93xOYCUrbD66R9eufK?=
 =?us-ascii?Q?IneDVxlC35iYSC37d7IuRdUB2wf3nKpeaV8T4WuG0JO48sirAPUAlVxHNOnh?=
 =?us-ascii?Q?X3rmX/JrB98QYXFTjMLbr4Vmn1PvUcr6KCQcA4NTyLv02p9DVJE3MQj99Owe?=
 =?us-ascii?Q?W/u+70mMJchfJ8rbupMGzZAJ4O0KL2qYRQp4wj48i8obv7OMREMsJFVidN25?=
 =?us-ascii?Q?EeVKsqbmfRQgYtjjlS+sO5mWMh7liADymgU6AkZKOCxPtYhu8KYQwVAsTg0i?=
 =?us-ascii?Q?Pv/OoT+CmFQZ0Sgw5fNcJUpc7aTEq3IP4jv68ewFrfTYECcWo8hx/Q6R63os?=
 =?us-ascii?Q?DooIBlMV5QuRb+UPTYZNU0Rz8IFMAiYdN1fcODp0ZitgX37RcGccZIcrVRcH?=
 =?us-ascii?Q?vZUp/GKSsJRvYOzltPerZaYqH0DD8hN7L/y6ok2eVBpflJolKuWAAjwpl0Kw?=
 =?us-ascii?Q?KCfiZ6t7mRMv8MbnNyNmdHRRPgFoUJY1q0w5G4lZgiGh8RL/DReMEGjBktfW?=
 =?us-ascii?Q?9o97urTIsEZbF0r46xKdfljJiV1/uwa5/XM5wFds7JaD9M74mCunOlVBlMcC?=
 =?us-ascii?Q?lpuPtYScnLCOPtGVKGJ8wufIlltVe2f+uGdnPKHSex8vVRk9oHF8eM9RkKlO?=
 =?us-ascii?Q?kToN2uPR9Lct7hHqVpr866GpFX0bCCdem0xhDS9nyvj80XkKViA8BXnCVj5U?=
 =?us-ascii?Q?W8qAGeuTYS8kYE3zyD/eDPoGPZmA/vOBRNox1tSLCMCb3wdz8JsfRG8qzFtO?=
 =?us-ascii?Q?L60QGeq/UwT6hxn1nXHTZ6xogRP3Sl3fOUB/ATf5MP9E3eF72yhxIsJKLMcV?=
 =?us-ascii?Q?zR2JEWiZPYgVUnCj5q2hjwcFUEEg5zwYwqErI76Ey/PvB8qcnqr0GQ86pnR+?=
 =?us-ascii?Q?/MKPi2MtPkDO2X+KZYUUi6nqrTZAnrQjIi7QUe8r2SP42+B/zfGES9/w+aY5?=
 =?us-ascii?Q?FZITw5fGKBkPm9uFjPcTSQGDVyRp/ng4x5dBX0B6AkE5QSabTiZbvKAwahve?=
 =?us-ascii?Q?yNZT0p4JHdD57ji0i8+XB1M7UgG59Cb79GoYn+Rm3z/msXVOScUUwNGC4/2i?=
 =?us-ascii?Q?SnctoZcWV+W4zHaAOKFzmIOm42OEX9WMCWqN4iQseFhRo6/5788RxZHD7tZO?=
 =?us-ascii?Q?D8bzKaaJORVkMXdmrcJvlHOmoIjghr4igjY1/WwDs0jmxDZc4e3n9F031buP?=
 =?us-ascii?Q?ZQI/+mkSM3ZCC4KlcvQGdraDrERRVisWGtCIJwHkyC34X/BwOFtHOsQ2OOmJ?=
 =?us-ascii?Q?eDCbndcc589UnEQxivmbZJ7e8Vr7NoBuQodfBiDwlAQhFla/5lOCyBnPJX4C?=
 =?us-ascii?Q?8Bw3xGrEqJyuo1Gh6AXe4oTtJIxU4Gs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B87B825D991DE2499735322B12FA6186@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3716b76c-fa59-4bca-f96e-08da1e1685d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 12:58:50.9490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /+RUdxjCPCAM1O86559VOUJM+ZvFKZ7wsguwSDhT6GBrfNF4W6Vuw+tm61MtL3/RTFBwJzkUUYhSHVwiUPKm7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4829
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 11:48:46PM -0300, Luiz Angelo Daros de Luca wrote:
> > Ok, I'll go with "no checksum offload for its trailer tag, and bugs
> > never fixed because no one uses it", in any case no Sasquatch. Thanks.
>=20
> Vladimir, so the DSA switch will not copy the offload flags when a tag
> requests tail room? At least it will work.
>=20
> Now, if the offload HW does support that tag, what would be the
> options? Set the slave port checksum flag from userland?
> It would be nice to have some type of "magic trick" to have it enabled
> by default. I'm already expecting a no, but wouldn't it be a nice case
> for a DSA property in the device tree?
>=20
> Regards,
>=20
> Luiz

DSA calls netdev_upper_dev_link(master, slave_dev, NULL) to establish a
relationship with its master and the master driver can detect this by
monitoring NETDEV_CHANGEUPPER.

If we look a bit closer at the implementation of netdev_upper_dev_link
we see it calls __netdev_upper_dev_link() which contains an interesting
pair of arguments "void *upper_priv, void *upper_info". These are
accessible to netdev_master_upper_dev_link(), and the bonding driver
(for example) makes use of them, see bond_master_upper_dev_link().

I'm thinking DSA could create a struct netdev_dsa_upper_info too, and
certain DSA masters could populate things in it. Then DSA could look at
what the DSA master has said (or not said) and fix up features
accordingly.

One information that could get populated by the master is a bit field of
whether checksumming is supported for a certain tagging protocol.
I'd rather pass a full bit field of all tagging protocols, rather than
just the protocol in current use by the slave, because:
(a) it's less gory compared to having the master look at
    dsa_port_from_netdev(info->upper_dev)->cpu_dp->tag_ops->proto
(b) the DSA tagging protocol can change at runtime, and when it does, no
    NETDEV_CHANGEUPPER will be emitted, so the master won't have a
    chance to inform us whether it can offload checksumming for the new
    protocol. So it's better to have this information from the get go.

We'd also need the DSA master to populate a "bool acked=3Dtrue" from this
new struct netdev_dsa_upper_info. The reason is to be able to
distinguish between an empty bit mask that means "yup, I really can't
offload checksumming for anything", and a bit mask that means "DSA who?"
(where checksum offloading is expected to work under the normal
circumstances described by you, no special code required).=
