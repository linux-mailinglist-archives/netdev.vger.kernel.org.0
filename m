Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB87251BF74
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377262AbiEEMgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376940AbiEEMgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:36:40 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2083.outbound.protection.outlook.com [40.107.22.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A2556236;
        Thu,  5 May 2022 05:32:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEIaqNHrfksS7gLoqE69XGqB84dFWu1gpi3dTGh5uaaHiCmy0Wk8hGEgW036CB3xsilK9ll/TKn1XlUEdpXM+hgouWKyeVLAwEX+CUQGgc3+Xve1c7oY91ag06FjiO5mfCNFxG8eMzAA+TwZZNi9gRrtbYjl2gvgI+Fp8JRmbDzWTZYoeJJY8bZusfOcCmn1G7mS7+IHW3egfptFYLGKU7NnKfzmgbGSLzGqYKNZlS1wHlUqta5cJrQzkBg8uBPqV5LB1lbt9Yr2iH5yI8qpoffUKgaXzhHUPbKxODaP3nCCPSFn4O04fbkIvDXHm1viRCV4CqmtoMav9RuEdOFUdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Qv2aSc5lu436YkE3sNtA97CES37rOdmlOLLsoQdnZs=;
 b=ApgOIMbLM5NsR53Rgb0vGWzCl4vnyToo7aC567rWWPN2ggG5O1+S8DBpRUYZJd89iSq9QS7dRxnhBo5S8q6LY5kvyjxFmx+5Ai7YHc5IWDM3qWDsSaT5gQuN5x72hHa1AudCAQJSCmm69e28X/hyBnfv8lEez/hZqgorU9n1zDO7ApQKkSyWNVUYWfJiGxW2LVAcQ3ncfvKY3nxi6EmSSKNTbLF3LuLr69kGPY90/Ipb2MxFlOw2Rjllybj1YTjLODP+xeYCZr/PIV4MbFGg642vD6Ve0dGc9HHrNaccw+c5qcd0zupe+WEz3V+01lxhzP2cFtgN0t/8s+sL6pAorw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=technica-engineering.de; dmarc=pass action=none
 header.from=technica-engineering.de; dkim=pass
 header.d=technica-engineering.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=technica-engineering.de; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Qv2aSc5lu436YkE3sNtA97CES37rOdmlOLLsoQdnZs=;
 b=hHXvvkPQ0//yFw3/a/OsQy4Lu50gcWu8kpSx70MVfiZgVdkSV5DYPLKtueA8sI9bsf06xVPAJi4gqJJEKnXFEw5zhL2XJ8hOghfhsWL5f8hw/dJrtIASryURXwRiY/YHpFPqBXvNL5TfdO5KaDWUsTwzdoAU6d6ylE3nU/HzIiY=
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com (2603:10a6:20b:30d::24)
 by PAXPR08MB6368.eurprd08.prod.outlook.com (2603:10a6:102:159::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 12:32:33 +0000
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::8443:249b:921d:345a]) by AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::8443:249b:921d:345a%4]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 12:32:33 +0000
From:   Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To:     Paolo Abeni <pabeni@redhat.com>,
        Carlos Fernansez <carlos.escuin@gmail.com>
CC:     "carlos.fernandez@technica-enineering.de" 
        <carlos.fernandez@technica-enineering.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/macsec copy salt to MACSec ctx for XPN
Thread-Topic: [PATCH] net/macsec copy salt to MACSec ctx for XPN
Thread-Index: AQHYXh7FrCHDrNQm30CdmaZlLiGY560NCZ4AgAMxHoY=
Date:   Thu, 5 May 2022 12:32:33 +0000
Message-ID: <AM9PR08MB6788E94C6961047699B20871DBC29@AM9PR08MB6788.eurprd08.prod.outlook.com>
References: <XPN copy to MACSec context>
         <20220502121837.22794-1-carlos.escuin@gmail.com>
 <f277699b10b28b0553c8bbfc296e14096b9f402a.camel@redhat.com>
In-Reply-To: <f277699b10b28b0553c8bbfc296e14096b9f402a.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 6ae29eb2-f99e-e92d-677c-fa0a9dfb4aae
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=technica-engineering.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8221f9fc-5373-4de0-ce18-08da2e93542f
x-ms-traffictypediagnostic: PAXPR08MB6368:EE_
x-microsoft-antispam-prvs: <PAXPR08MB636831BDC9BBC24648E11BE0DBC29@PAXPR08MB6368.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2SKbDVPDPtprYYXQnAxTJNHJbbw+lf54R/J9hkFRM+2UGK9TZkZ0CPsGOufhQKXIOoLwi8KUKepYmgORpIZdfbZNQf20fhyKs1hikxz0MgBgMJz9HIOiStDHB1MYjldhNaEhgVQayJxIddHAvLDUNIKRY3DJvH5AdpU4mzuBheoRDDs9QCSOH+t2pZmMJqnY2NRSYe3dWBMN3RvPIyWfop6WoXSyIJeoQ11Y/qMSArsWlBh7PjXqVVZu/JttzhSsTxo6ll4Tbuoc+mCo8QS7xUlkyTIH4EbSGtQt3a2fzJsoHglaQsTrXN9MLRZeA2//JEUlAnDv1G147nmUt2/BkfRE5lBI6GT+osVelHA+C1bieS/Fhr34nb6pDj/t6c70uPDslPU+Pm0yvVL+8uWv3+Un74QMZfieC8mb4czSQIomX1pJLou8hPtv3YKIgNywAWDODtn/GvnBPeyyfykXFzX4ojdURD2tpx5DQp/e81rG5hpNLxXGXcUgOXbpSfovjg87qzyi3Ta8xlvQz/er8MCEtKroQYOfWF46fGm1c1FHb/kNjklMepwpi6w1rOGAY/axpdV3pxQYYgWAsIbliJuf51MF7r6a9xUtopMuaDs/8wjqqXWwj0rMuY9oqOY06CVzJXuYFTaHIPL75XA/Kw6hYz4Cv5yOOV0JRuYBLUWqJ/QtOPFwz+9BKx9+0nPIs3j2yTw803DaFd6IPxad0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6788.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(91956017)(52536014)(8936002)(33656002)(86362001)(66556008)(64756008)(8676002)(66476007)(66446008)(316002)(71200400001)(66946007)(508600001)(55016003)(76116006)(4326008)(53546011)(2906002)(26005)(5660300002)(38100700002)(186003)(38070700005)(9686003)(83380400001)(44832011)(6506007)(7696005)(110136005)(54906003)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RTe7NUIahy8ZOxaJA5rekl1HguwAwfxHmPmjVEtn8tmCnMCDk4nSkbwHoWLy?=
 =?us-ascii?Q?75YZIfrU4k33e2tOJye+/I5DQS621abpP6zHhb9nduW4wvAizgaLwa517YTQ?=
 =?us-ascii?Q?yHNgBiXMJlGiM0AXqHwbFQtrCOG3Ukb/ksNMkOXkB4/UTjyibEL/I0lsFCBO?=
 =?us-ascii?Q?b0adtuSAXXsC8Mk572VDYAuU5G0qlbUb39kr+4fg+Jl+EA7BeJTsZs4yeh62?=
 =?us-ascii?Q?VGdZOcwOn8k6wSNWLgxpl8Rv9n8/dweozOz65KrTpAKlKIRJy84ZWPxj77e/?=
 =?us-ascii?Q?vSJIrWLSC+u/zcIxc0itfImCU7nIxfAZyJuvABICgxV/B0KH1p5bfD6p+rLK?=
 =?us-ascii?Q?TkklzUQs6Gm0T1uTjLGSpYiJkhZncHlS5+o2pxNiN/F9BN+WflIeuzrgT1uM?=
 =?us-ascii?Q?QD4jLazC4zpq5vRzbO2qpSfAnIm8UU2dyCb+J96PDpxVjK2juTg3RY1/lgRk?=
 =?us-ascii?Q?/T8qlCs4cnRwntl+FTalmtdIoxy0SUktM8lzbpeMBAejhW9gQlREC9AOW3V9?=
 =?us-ascii?Q?eUxD5Rhv8fiIZDb11yPEo0imO5cTprzpyin5LZ/XzMSQFlOzYPMz9ZRGy8Ji?=
 =?us-ascii?Q?XNSONBMLoMqDBPfflH2wGV+pFv87bqtPU61cFmsLFt7q+IyV/yLZRvLjp7ZI?=
 =?us-ascii?Q?F9tWw3iVzCczbGtL/L20KCMkGzvkArf5CdNBntOmOAWZ83jS+SF1uAXHot0H?=
 =?us-ascii?Q?u3nTlnHwuUzjY2FXJfsnO0BEA96xxpyBioif4oOrkm8Fq3j4gIEJkpT5gduK?=
 =?us-ascii?Q?to8XK5kPvwI7ycxsEx9VBgVaSxb9Z8U7LHmfm3C+PgbtMPkKDFDXGN4dy3VD?=
 =?us-ascii?Q?Tj37Qv7dh3PVL8kzjnPUcdV70IBgUdagj4LjAgHVQEThaAy0rRfW/UisbuQO?=
 =?us-ascii?Q?x2CRDRZAS0JfBeDbYQc7gKyIq4+kGn5zBFBhtdIOYuf3Cp4XVTytDrokEoVO?=
 =?us-ascii?Q?zMIUER34CSbp6MdvHqVCITmAOTi4lrpdMr5T6JmnHckM/nX22IhoUtlgdB4t?=
 =?us-ascii?Q?HzM8nG47ZqNZYCYteriknraoNe9gKKwsiVGxwQji1SuFhHdyl4CCU3P/h/mg?=
 =?us-ascii?Q?uLoOhGKdNSJ6bmQVi/+tjIIKjXYGpQcbKbuWlE2NQfAHYXZN7TvtfJAViKjX?=
 =?us-ascii?Q?c784s07EEt/lfFqWP/aKivzeLVSfgMqi4fpoj21ZVaPZ0pRc7pfZ/T1G3GpM?=
 =?us-ascii?Q?ysCrdMdz7YchW0Z6EvkvxjbHl/fbDk0Dvy3kVbGN382KpTPedBKpA1K+Wq57?=
 =?us-ascii?Q?vhb5tP0psxPSTEkAyVVs8+2TVzrLmINE5dU2kfI4TjK196poLaHotU+JTiE6?=
 =?us-ascii?Q?KRXt0Y7l6vshxo0WKgT2bDPIwlhLywARs8K8Dkv1LlxFwFSbUkJbVfsyOH30?=
 =?us-ascii?Q?2JdDJCLzkyBrfDEoPwKJmsd9fwWrqJxshv1E1UdbWYMBR0A+2kwB+UC3irzH?=
 =?us-ascii?Q?5nRpWUvg+yUwXDz3mrcHeR2BXlzNO/5/rT8XOM8fmk62MgPhJ/2vuXnnkcEY?=
 =?us-ascii?Q?ez4NOnGzJ9Hc7iV9pAfjEQ1wWUHNx0PoWZ3ZPlMuM1GhZfEJuA/f7K33Jszq?=
 =?us-ascii?Q?PP1/v4pnf+QMbIe0wF9CLmFFmNTPs5S899akFA6BLz9OzGbuqJmNLW+4K/7v?=
 =?us-ascii?Q?/T2r+XcgrvA5g75Gpqf+Ts6GFslnvBRyIX93n1Q60YbW285JkWbLTsIA/dAH?=
 =?us-ascii?Q?oFbF+6MN8jZdMi2caQwAF9SVyBBPccbd2Wy3bhBQ/SmPvQ/tWgIHTo8dvZmN?=
 =?us-ascii?Q?qLeqlDQ39dx2u6XGO3qhH5cLseOoHuGIZF98LQa1QAymshS79+03?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: technica-engineering.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6788.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8221f9fc-5373-4de0-ce18-08da2e93542f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 12:32:33.3210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1f04372a-6892-44e3-8f58-03845e1a70c1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MU4vi6AiAMTdMcq0dYJQZHZAEWp2zC/IRqraYFBSK6FK3HKXem5EUUr7enLE7Qio3SDrdVlBMzblceTNwRcc8r6oeMAAnk5EFBYF5EYnVMAURiUqw3pXVbWcaPVDPI40sQdqhn7dnHM3BjbEIh2loA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6368
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When macsec offloading is used with XPN, before mdo_add_rxsa
and mdo_add_txsa functions are called, the key salt is not
copied to the macsec context struct.

Fix by copying salt to context struct before calling the
offloading functions.

Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
---
 drivers/net/macsec.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 832f09ac075e..4f2bd3d722c3 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1804,6 +1804,14 @@ static int macsec_add_rxsa(struct sk_buff *skb, stru=
ct genl_info *info)

        rx_sa->sc =3D rx_sc;

+       if (secy->xpn) {
+               rx_sa->ssci =3D nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
+               nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT=
],
+                          MACSEC_SALT_LEN);
+       }
+
+       nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID=
_LEN);
+
        /* If h/w offloading is available, propagate to the device */
        if (macsec_is_offloaded(netdev_priv(dev))) {
                const struct macsec_ops *ops;
@@ -1826,13 +1834,6 @@ static int macsec_add_rxsa(struct sk_buff *skb, stru=
ct genl_info *info)
                        goto cleanup;
        }

-       if (secy->xpn) {
-               rx_sa->ssci =3D nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
-               nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT=
],
-                          MACSEC_SALT_LEN);
-       }
-
-       nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID=
_LEN);
        rcu_assign_pointer(rx_sc->sa[assoc_num], rx_sa);

        rtnl_unlock();
@@ -2046,6 +2047,14 @@ static int macsec_add_txsa(struct sk_buff *skb, stru=
ct genl_info *info)
        if (assoc_num =3D=3D tx_sc->encoding_sa && tx_sa->active)
                secy->operational =3D true;

+       if (secy->xpn) {
+               tx_sa->ssci =3D nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
+               nla_memcpy(tx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT=
],
+                          MACSEC_SALT_LEN);
+       }
+
+       nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID=
_LEN);
+
        /* If h/w offloading is available, propagate to the device */
        if (macsec_is_offloaded(netdev_priv(dev))) {
                const struct macsec_ops *ops;
@@ -2068,13 +2077,6 @@ static int macsec_add_txsa(struct sk_buff *skb, stru=
ct genl_info *info)
                        goto cleanup;
        }

-       if (secy->xpn) {
-               tx_sa->ssci =3D nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
-               nla_memcpy(tx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT=
],
-                          MACSEC_SALT_LEN);
-       }
-
-       nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID=
_LEN);
        rcu_assign_pointer(tx_sc->sa[assoc_num], tx_sa);

        rtnl_unlock();
--
2.25.1

________________________________________
From: Paolo Abeni <pabeni@redhat.com>
Sent: Tuesday, May 3, 2022 1:42 PM
To: Carlos Fernansez
Cc: carlos.fernandez@technica-enineering.de; Carlos Fernandez; David S. Mil=
ler; Eric Dumazet; Jakub Kicinski; netdev@vger.kernel.org; linux-kernel@vge=
r.kernel.org
Subject: Re: [PATCH] net/macsec copy salt to MACSec ctx for XPN

CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you recognize the sender and know the c=
ontent is safe.

Hello,

On Mon, 2022-05-02 at 14:18 +0200, Carlos Fernansez wrote:
> From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
>
> Salt and KeyId copied to offloading context.
>
> If not, offloaded phys cannot work with XPN
>
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de=
>

This looks like a bugfix, could you please provide a relevant 'Fixes'
tag? (in a v2).

Additionally could you please expand the commit message a bit?

Thanks!

Paolo


