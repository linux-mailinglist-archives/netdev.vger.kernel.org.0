Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFA4534F18
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347177AbiEZM2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244259AbiEZM2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:28:05 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70089.outbound.protection.outlook.com [40.107.7.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078AD57105;
        Thu, 26 May 2022 05:28:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mClbF0Xwp6M4kYPw+YfqoVzoSKykKDjI3EYDH1FC6vY8El+lpHMfi+26k8mJ9feU5t5ENn4Wh7iEx/2XBbk7Wg2hoIHpM6r4B72bJL/bNOtgTGXqMg0EFOZcsh4w6HZqENVv0V6yGSi8q0mKHm7vNrdYOwv8cCbgnnNLMYahM7yUlEHO8n1vViEcc2y56LaQS9ItqRd6f9xgqN2powbIvZMAybn0igyhj42CFPvG1ltza3ts+GVDq/0+DivyBnHecX0La2akmTJ25Qi7IyZqm/IHHKH1kUScjwb+bBay0RqD6jYhZdcD3gJpQKZhvdEXNYfIN6PCH5ZChEhJPIH2SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMwrXs7UbAlQsuU7o03K0Cj8NxqmvE4xNl2PA8dREsU=;
 b=OVCKVBvOytSim/7yFhSru3DL0NqAL9BKEGXcSCzdf+QujHtxcUvHrfGfu1XGWxGhDOc8d6REG/FuHKSNCT3rzjl8sTonW6BJ0rPZVT8kxVbzg1RMCqDxgD9raqR3UiCQwQl+yFtzFhZhZDK03J52Fr57h7Z59ovBBHuxIN1w9iwbMtY2ZY9p1wUE/96PkHiGH5SAPvC770BbS+CkDRzZERo9FsmsheSxtXqEXXuN5DvwUeXBTG0Jtvt3Qs9x5pQLEBCAAM+IqjZSjTx0B8XLurU8fCCieRLRTLnyI2ybBw+Wz4zGzoQpjHTtPKZdpAOxAkUukSwdCUjzv7BsAxyegQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=technica-engineering.de; dmarc=pass action=none
 header.from=technica-engineering.de; dkim=pass
 header.d=technica-engineering.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=technica-engineering.de; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMwrXs7UbAlQsuU7o03K0Cj8NxqmvE4xNl2PA8dREsU=;
 b=RbbA5NB1AtLrDakEsGQ0pzMLm/30nGOhK61OHVPrElvLDDL+4NVvWX3NnIOc0UzQTJp5w+0tE4imaf4TWXzhzPxOKoLy4Mq08yzj4kpDzI2HKpt1oaPAtvCoOmkmj/OSzLQNkv2Prc2j4bjDV8zRNXBnMX+rZzIMlbLG0BqdMg4=
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com (2603:10a6:20b:30d::24)
 by DB9PR08MB6474.eurprd08.prod.outlook.com (2603:10a6:10:255::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 12:28:00 +0000
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::6496:573a:4140:b034]) by AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::6496:573a:4140:b034%6]) with mapi id 15.20.5273.023; Thu, 26 May 2022
 12:28:00 +0000
From:   Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Era Mayflower <mayflowerera@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Carlos Fernandez <carlos.fernandez@technica-engineering.de>
Subject: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before
 offloading
Thread-Topic: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before
 offloading
Thread-Index: AQHYcPvDPq6ydMqg2E2jgarNs1uvPg==
Date:   Thu, 26 May 2022 12:28:00 +0000
Message-ID: <AM9PR08MB67886ABF9BF353568A56B29BDBD99@AM9PR08MB6788.eurprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 9e0b92f1-d852-10a3-67d6-61c81f74e03c
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=technica-engineering.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2da94b90-3cb9-4ae4-3485-08da3f132c4c
x-ms-traffictypediagnostic: DB9PR08MB6474:EE_
x-microsoft-antispam-prvs: <DB9PR08MB6474BA7A1C88664C0124FBE8DBD99@DB9PR08MB6474.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kZv8uV7DEcUw7PG1PjuE9FOOIKPNisjKzOxe1Xg1u9avGvdjQy6qp0EBWA96DUX1tqSW71xiSr+enVKPhFmNLaqMzhXACGyrCcgdpZuAppaCh+tciM9ZHOehC1Gp3HcyW0JvJbwisqSzh8YeSsvYovPUzm2lCXjoDNZscVPK5EvjNR9Kkn9Npwh9a9nHnwHoOmLbDvfh9COLKNYO+bkTztvSc92WdrCrZMUAMH8smy1yh2FD8o3JBRCNf4xM1oHUxqkX4L0jnvo927quFTCajI3LNXGQF+hBx2VLVbdUs5YAOl3lAAN1yfCduyGgghvRRJc6kwcVwG631ufYvOqc/D+WzIbYgUI9UlsQq5Gq2xiD/PEblSU12wykYN1SO/rvGDFuGZdpgxqwLkr8UWK0Nqp5q25E0pA7QzVXccNejUQO1QR920ewPtOjTdK6WGAD11ohcND3neQ6TBXLKYBdEyTjoUBjj/yTPDOTDBvo6KAw5hRFFABBPbmHx/1C4pP7HtdUpAfGUaVyehhKV2cLWSRXt7wpqy5mmH32m/YX8Aftyb1SP+6mYDsl537/o5ltOxGNcXaT1HjCj/mTSXjDee6VVXx5O+VPWjwRfe7LgfTa2RMVnddFaPy3lVK8a25et83qnny3c4ukB5Avfg+VSqSGZkAnEy4DJBSwc5dW/pzMqG5qnlN2i7r29hfRzeOAMqXwoVkFxBoTJYQXovkK4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6788.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(52536014)(76116006)(44832011)(38100700002)(316002)(38070700005)(8936002)(7696005)(26005)(91956017)(107886003)(4326008)(8676002)(186003)(86362001)(53546011)(6506007)(122000001)(2906002)(55016003)(508600001)(5660300002)(64756008)(83380400001)(66556008)(9686003)(66446008)(66476007)(110136005)(66946007)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?2+fzTozm+PdF8P3Lk1dKRoEA/bdDhyEYDKjlvMtR/z0O+7UPX6IhrixLfb?=
 =?iso-8859-1?Q?BZaMzvvgUOvjs/79yAcsl71kWMQfDjH5xQHL6JUUUnV5/R+ryu7zbKXBBC?=
 =?iso-8859-1?Q?844FHnU2L9KrZbvZufzFzpWMJVo6EGeqg58Ww27+87aRJHH5T71z78IcTW?=
 =?iso-8859-1?Q?EIAxOZwMwkO2t9ApXGey5vNIsckvrSkW/rK4ao80gjocIAkfG7SQD2ngC0?=
 =?iso-8859-1?Q?tr+xypQbzFKa20xBYJaYK3pixrCYZvnjGOSiZO0cxm0FuoeTcncELZkL1S?=
 =?iso-8859-1?Q?u98XxKRQ1JZ+QZ3V7h/C0z4A15AY7BPxya+WIJtIcWygp0C/+J2kxasL4R?=
 =?iso-8859-1?Q?5Yc7Mx3g4wyULcMO+dqCqGNpTSdaKoKeEIuU0giqpxQmInCfW/Ch8ZTCRv?=
 =?iso-8859-1?Q?5Z4+MvW8dV5RLngVrKzoNTt16RmA2s/p2qssZhZvagad7iwmYeMHLfcuJP?=
 =?iso-8859-1?Q?+3M8C/c/7OFaqJNHdsvjsctxF+2VX78y45xaCV4L7m0/+bP81IHAytEEGj?=
 =?iso-8859-1?Q?qJH+iOGvZwpcJzNiCRZN42YjzdYWcYZLKrNJDHcRESEdvnmG4shLSpO+5Y?=
 =?iso-8859-1?Q?f13hUgWu+bDS/MfsSMsAtWKRyW+UlZVX99JmO396ZyEFdPWw/GLnJwMy3j?=
 =?iso-8859-1?Q?kxWhtYHsINHtZyWtJkIAhAv2XPM139ZxzYVXFezRew4Z+kUhEkx1diRqAi?=
 =?iso-8859-1?Q?2pNwtpOMbrASFEkhtAOF1yrhVV0pAPd4J/mVfuzMmP1On2Zi3wX8u541c1?=
 =?iso-8859-1?Q?WfaiaE3bLdJsU0Ep//NQzu9WvVKfnjan6G52l1BfLXUXTd7CCxhveJ1Pjg?=
 =?iso-8859-1?Q?l4K/IBD9RAOLm5Z4nIvdKSI+iLP6wvmzqSORsvk9AnKbreHcWuaMB4aNYo?=
 =?iso-8859-1?Q?9lgfL/Kda89bpSVv3aMkjZ/dYVX6bDGM8ijX2D4IsvxIk48G6DV1CAleRS?=
 =?iso-8859-1?Q?PANDh9UmzHp3QY1oyhPh2ZBQr6FFXQx92SvOEd01MlVtVC9Vay/XIEVV/4?=
 =?iso-8859-1?Q?0DaQqUb/Px8dO1LpXcTkEfg/IKb5lqP0L4Nvrlle912PZYvr9cUdlprauP?=
 =?iso-8859-1?Q?PPkzW/8DHfwKBs+gxidknSI6lcKJgpVRxXzfxaMYyGiHNf9dO1ADbSV3xo?=
 =?iso-8859-1?Q?1X7pqkd2kypQeqa55aeM5BXsge0wFFelbtVlMtyLo6ZoYZZsl2a3/TibUO?=
 =?iso-8859-1?Q?iORkE6ajiZny68FyaB2SYvxRd1GSj01ObFp4kTd6Ag7E0DExmBIbYaVCJ8?=
 =?iso-8859-1?Q?3EViD5HlYu/1bMefRXWblIpu8T+uuRFwT5PVI/NAyQ1wy9LYzbzJHMKnI5?=
 =?iso-8859-1?Q?BvREKwKLlO+x2Vddp6BjxQQ139sbqlYTQF2xqB8WdoTI0NC/Zy68C/pLU5?=
 =?iso-8859-1?Q?11evf9lYMA/U2J9td98KzAqLA/am/XINQZPr3rJlPM0+mCD8fFCNzvCswh?=
 =?iso-8859-1?Q?Cvi9R/Wpaht5mNTBrgpK6ZGYXARYkTFRrU6YUcSo6IkPQMZM6tZqt+whG5?=
 =?iso-8859-1?Q?eZO0/CcqT3r0WtOdLKX7P4otRlB4EWQDf9Deec/6fj/VoI3u1bZb7Qaun6?=
 =?iso-8859-1?Q?HyItwO1TPmuFmNDAZ0jq30l+nXEdwWE3npHt9v2dlJMpCM57Dbz7pqO7T+?=
 =?iso-8859-1?Q?+CGZ77IS1eJVBty9CkT+XfpYjEw6MokT2fKskAzWhkmAFkVlc9ESParNsD?=
 =?iso-8859-1?Q?9LPy2rkP+i2kKLdbjkwsh0cgrjNlMaR01cEZiRHQpTMh5h8Eyz/lNPJoXb?=
 =?iso-8859-1?Q?tTDb0kENQ9kFjenrgq1hGKvX2phnt9BH/enbFIqnec4Jjkuxcbe1FW9Jmt?=
 =?iso-8859-1?Q?h3BL2TYAQn8LIi4/Pwonn5kGYk8DCClxZqUuKo9PQ51QjRFDx1ZH?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: technica-engineering.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6788.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da94b90-3cb9-4ae4-3485-08da3f132c4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2022 12:28:00.6311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1f04372a-6892-44e3-8f58-03845e1a70c1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Mb0kEnqbU8cCDU9HdsDwgi+nmRV18wegmP0miUu0TcmU4RlphtxGIAzPHzXUZx/xRR4smMTjEOMzyyZsx4ZJTpKkYuXvgzZcE6Wo+HJTJsK64KQD1vk5Y66fTdQFXxEtWjug3doP2TZbeBFaQNpLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6474
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 149a8fbcf7a410ed6be0e660d5b83eb9f17decc6 Mon Sep 17 00:00:00 2001=0A=
From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>=0A=
Date: Tue, 24 May 2022 12:29:52 +0200=0A=
Subject: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before=0A=
 offloading=0A=
=0A=
When MACsec offloading is used with XPN, before mdo_add_rxsa=0A=
and mdo_add_txsa functions are called, the key salt is not=0A=
copied to the macsec context struct. Offloaded phys will need=0A=
this data when performing offloading.=0A=
=0A=
Fix by copying salt and id to context struct before calling the=0A=
offloading functions.=0A=
=0A=
Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")=0A=
Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>=
=0A=
---=0A=
 drivers/net/macsec.c | 30 ++++++++++++++++--------------=0A=
 1 file changed, 16 insertions(+), 14 deletions(-)=0A=
=0A=
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c=0A=
index 832f09ac075e..4f2bd3d722c3 100644=0A=
--- a/drivers/net/macsec.c=0A=
+++ b/drivers/net/macsec.c=0A=
@@ -1804,6 +1804,14 @@ static int macsec_add_rxsa(struct sk_buff *skb, stru=
ct genl_info *info)=0A=
=0A=
        rx_sa->sc =3D rx_sc;=0A=
=0A=
+       if (secy->xpn) {=0A=
+               rx_sa->ssci =3D nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);=
=0A=
+               nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT=
],=0A=
+                          MACSEC_SALT_LEN);=0A=
+       }=0A=
+=0A=
+       nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID=
_LEN);=0A=
+=0A=
        /* If h/w offloading is available, propagate to the device */=0A=
        if (macsec_is_offloaded(netdev_priv(dev))) {=0A=
                const struct macsec_ops *ops;=0A=
@@ -1826,13 +1834,6 @@ static int macsec_add_rxsa(struct sk_buff *skb, stru=
ct genl_info *info)=0A=
                        goto cleanup;=0A=
        }=0A=
=0A=
-       if (secy->xpn) {=0A=
-               rx_sa->ssci =3D nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);=
=0A=
-               nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT=
],=0A=
-                          MACSEC_SALT_LEN);=0A=
-       }=0A=
-=0A=
-       nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID=
_LEN);=0A=
        rcu_assign_pointer(rx_sc->sa[assoc_num], rx_sa);=0A=
