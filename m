Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E6C522E10
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbiEKIRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiEKIRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:17:49 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2040.outbound.protection.outlook.com [40.107.21.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A9541603
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:17:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDF3HiQhdjQFrf7G8T++6bp97CQZPRpP4LPrhgfVZXawbUfv9DoZI2JMaPfynmEz4qkKFJf36lo0rUqZo4pG62jvk54o4QMNSe+wpg9IJlapw4oGcVY4eRxV3EfGWlaOl2/fuax7lShqsXjzMANgO2WtjVbtNuT9SkMyLLvnaQ12kbSAIuhw+/t1iNngv/f/1oY5rZ2pGuzd0t2oLz1YbBMlgX2SVV3u0zVlUoVlmann65I2Fta8tGPZ29vnCRQl6PWky6Ai0CgCFw2swFOePTwaO0q3xwmx99T5kLSCsZ2XfUR0F5ORy0XSWTLGv+M7jUfytAY/GK66YCldH4YUiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZcCfAGog6h1qXA+h4OkiFObvZCDaKX10mhzd4MJ6U4=;
 b=AImufLOpIiG81okeiwgBvpBBZhDxotluYEkpIM3qjvkuCGX79olFlQvBfEBy2MpvLj1jUP/SSJ8WZIaXJMSP4cr3bj+YYnRAN98v3XAL4VTUksz8Qi4eYvXlIvZrZMrzed5TGtS4it6pTcIkTa5Juhtxbsd4Hj30fex461QL9q+yqkBS03mhRFdaQ/Rrmanx4qsJZ+gaC9nVFLWEgX1BnK+BbO8QtwSjzIbIQja+cv96jf+04jo/oRCtrgFyjEK+OUoo1y5Dz2m5HGhAKq8nEzxjlPX1tHbfRv9qe49qqONI71DjGCr7ulsFu0BLhXWlPW+Zw6hB3WyYS+jGnckuMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZcCfAGog6h1qXA+h4OkiFObvZCDaKX10mhzd4MJ6U4=;
 b=SyfUNc4a97lgHgFxGBumcT92jRqWAhzSsOHmfCiqnkcT+rDo5VruIjmUga0cIlovWQPi0Il1EC4rbd0cf4kFpOZDnsz/4HGGqoxKLNhM0xskCXVLiUANultG8uil2ZJfGikJZzGQkGiYAqC49kxB1eXjM/IUjDmMBtluquB33HQ=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by PAXPR04MB9024.eurprd04.prod.outlook.com (2603:10a6:102:20f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 08:17:45 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::951b:fded:c6f6:c19d]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::951b:fded:c6f6:c19d%8]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 08:17:45 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: RE: [PATCH net-next 1/2] net: enetc: manage ENETC_F_QBV in
 priv->active_offloads only when enabled
Thread-Topic: [PATCH net-next 1/2] net: enetc: manage ENETC_F_QBV in
 priv->active_offloads only when enabled
Thread-Index: AQHYZIwYnzCbJ5P5oE2wKuOquoxhoK0ZU52w
Date:   Wed, 11 May 2022 08:17:45 +0000
Message-ID: <AM9PR04MB8397DBDAA510B947A4132D7D96C89@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220510163615.6096-1-vladimir.oltean@nxp.com>
 <20220510163615.6096-2-vladimir.oltean@nxp.com>
In-Reply-To: <20220510163615.6096-2-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2432ee1d-8193-4e59-cbc7-08da3326ba8f
x-ms-traffictypediagnostic: PAXPR04MB9024:EE_
x-microsoft-antispam-prvs: <PAXPR04MB9024965F83B1CA95654A729296C89@PAXPR04MB9024.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EQCtCvjkWa2aur57eaXerhCqrDx1aR6kv/n/vq4ATBCJ97QdVfbTF10YBaLC+qSYw2nujkJkmd4jXjoBKNn9wOGF6lN4oM39ffaEmnQy0iWzOt5jJkkniSYrk4/9DiEw6sEmGogYLsGmeOPp7+KuErImibpUD9tZeh0ZJftGcAyrZZexCuefyrVTCSzxlfA4Auz6G22B2mFuCSvjV48Ye+iTH48Lo5T3+yKcaGkcoq4eGVQGmY8FXewWdW0Mj4GhPTgBkbUs3pnJLLKNeBucOw41HFNGuW1ALGnM3wqyGF39f5+cDDwFhfBpcSxjsn7MoU4gvUjGiQf8g51j0NRc3ykXdsT+LCTcP0L3/9b8z5qkJ6+Dmv4twj0Qg30XF3TK3R1ieBch9f6obnqhNkecI4lMBNf2HyOL7lV1vHK7FH9fpNoGmIq7WHObjtqMQK/HriQ06ivP37XzbBHe28wzgkoqeYXDNgjMrWhlrgiFlttubCnWr5bXTzof0tATPUUNNqaJN9DaIhS7G17n8aLX+n6Pb5Z8TmfCPNTnkRCx0pyK4qkdardnZmOOx2BZXh9KBzPrsFMool3lvbWrCX8DyspLyhxwlVNTDYiGwZi+Hx1dWsnv4jfpM8N3NP3ADeNOaDVKtX9LM8YO9eiE1Zm4EVwQqdVvwhEqXkFavZwOkwKn7/vvFDLvoO3Kev/MWpReLFx4HFV+Wsaqbce3mWUYFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(7696005)(6506007)(53546011)(44832011)(9686003)(55236004)(83380400001)(26005)(33656002)(5660300002)(186003)(2906002)(316002)(122000001)(66556008)(38070700005)(38100700002)(508600001)(52536014)(55016003)(76116006)(8936002)(66476007)(66446008)(64756008)(8676002)(4326008)(86362001)(66946007)(54906003)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rRPXtKASgz/+At42tYuxZgsYY2cZcRXsmUbfHZ7COR0D2E2J2ebU+ImaVC3b?=
 =?us-ascii?Q?jpWSgwUl2PJJCuw8iSxnVubYIsfFgXQYb32uqer5eEBr5EHnlK7VtVrmckoa?=
 =?us-ascii?Q?11HQpiQEdzzOJ10vPrTmH4arWoJBISk6Cy2aCRFWHaWEhe3mw2EaeghBu5Yw?=
 =?us-ascii?Q?iN7bAp6kBs3pgMBpxbZl1Gp2K97THa1LDRyY6C6+hbWcR5c2AjpGkyUqjR+b?=
 =?us-ascii?Q?b8OsEusg1nBOnyi2a09711Q9MSYs5MOkwklzRyA17NQNtpTLcmIetnDyEumB?=
 =?us-ascii?Q?BVRxvT1DjXJpQ5HAilUsE48S49RBjlDczDFiWhqZt5QY4Y0kzZPVDueSWpt7?=
 =?us-ascii?Q?MlC0hfyjZzNG/zD9X2xWViEExePsU/0aauuCygGBtmf1D0v55Nqmb+eU7gDd?=
 =?us-ascii?Q?a2xS06r+a8F/S7UU9kgvHDOxxwZ4G11YleZUh1xUDpFg5uBtAhhPgOv/4O5h?=
 =?us-ascii?Q?zpzsYzW5MFNvlhv4xraIToekrkXLHfwL9r+c9CbFRhHPefX9Vbfp8EHtuzo8?=
 =?us-ascii?Q?r5tQGTa/nUUonLtqWjdedUb/cCPsSu6hQeIIrLPdCw3fi7mqBagFf6WsaGmf?=
 =?us-ascii?Q?TWqneAE8XNmmradtDHek/lU4W0EOguAeC+/4OibGO6H8mCC+cVHclTSJSPB5?=
 =?us-ascii?Q?Yvnb/mDul0ot0Xs8pNV3DogkvOiuco5Y3g9PqM06vvUXDgvW0IOafF5kHANw?=
 =?us-ascii?Q?9pF9CpjXVo3e7hyq7PfNMj3nV8vo1vJRznhIYRAQ0NH9J//lVoaPvD3GzF1I?=
 =?us-ascii?Q?WNnbv5J3MqyEhyVcSJaEHTpjyARhM9uhoUS6lwaLJJqe8HDCZ0WPRqbKrWn2?=
 =?us-ascii?Q?BJycBJ+57pT6LYnLSzxBwWByE+Tj5Gh/6HDtIJJeQ6inwSyz7GHoSpIrQE6W?=
 =?us-ascii?Q?Or9qUeT7b9Gpn8BlYGTR4+ujw+HD74OsWqD9JR06Wq/mh/B3I08XHdsb/tqM?=
 =?us-ascii?Q?x59VN3ID43rNZUSGA60DVDYZBbpwUUuHG1K7iMkZfSQdU9Kp7VkVXkpundlt?=
 =?us-ascii?Q?bsXsQIsFQFWgeZ0+SQCW1uGmcf+TooC4P21l8l9OtoiG+BKuzBuDbDb8RLNm?=
 =?us-ascii?Q?1Xx556+hmNP6h4FzFUFR29zmPkQ0GQ109+1Xtwng8IX+KDaSrlTQMlo+bU0A?=
 =?us-ascii?Q?TBF7AkdkiGuU/ksu5ew2lgUq+wOEQRoM5tYOEsLP3K+kChjm8dSZxrKOf9gh?=
 =?us-ascii?Q?EhFH5IaLyI8mo5H6mKT0sXCWbvwBHgQA5pNdJ6LmDn7sVq21xTkEDQ599Sx7?=
 =?us-ascii?Q?xbveSPC/lp3/bE64yObqm4p4UWBPOnVRHiOM+bG+It5gew91Ux+xfOJOZDV5?=
 =?us-ascii?Q?1iMUMXRYJ05R6o5OhTnuikX7l2cfZqsetJdw4+u43YWkMEUq0ie0vL4xVJew?=
 =?us-ascii?Q?2Iz7DizdhZq/G1GCkntQxJGwX6BaXGi7nrxh1wNcYLhnuLb70Fqg0t91mM/M?=
 =?us-ascii?Q?x/JoRgosWKJovDI/Pf/lZqwRiH1bKsXsuYhvQ+kRmdmEUGN1FFWlc33JCAc6?=
 =?us-ascii?Q?jIK6cEC1IbEr01B93uMDDt7Y3Ab2bz8Xv+/UCH8TU7f+YkeEo7qpC5pDTHD/?=
 =?us-ascii?Q?FMRlKUjYmYqlA2KrmxX6mTSW4XLOy73B46+wqa2INFICHHe1YR0oCX2kbcl4?=
 =?us-ascii?Q?ghLRYA3OAV3omeHBNQePS4qi1DdG8jDzDmdBycHk6eEzy62lJzNQeNta9mdx?=
 =?us-ascii?Q?P6qqnqZyET8VWJhwxcBuoZ8OlDBgj+TLOTrZVvlwmoSVea6lnuo3m+frabQK?=
 =?us-ascii?Q?UcWdjGAVl35fnj0FPhS9bXty+8WfcwQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2432ee1d-8193-4e59-cbc7-08da3326ba8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 08:17:45.7637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vKvhLfMJ8Mug1DFRL9W99zLZe8tDlgz3eNZA3ZFCvjOt6fuwjpKCmfcXJvOj57FI9esK9JxHUQsyNu6+8266dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9024
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Tuesday, May 10, 2022 7:36 PM
[...]
> Subject: [PATCH net-next 1/2] net: enetc: manage ENETC_F_QBV in priv-
> >active_offloads only when enabled
>=20
> Future work in this driver would like to look at priv->active_offloads &
> ENETC_F_QBV to determine whether a tc-taprio qdisc offload was
> installed, but this does not produce the intended effect.
>=20
> All the other flags in priv->active_offloads are managed dynamically,
> except ENETC_F_QBV which is set statically based on the probed SI capabil=
ity.
>=20
> This change makes priv->active_offloads & ENETC_F_QBV really track the
> presence of a tc-taprio schedule on the port.
>=20
> Some existing users, like the enetc_sched_speed_set() call from
> phylink_mac_link_up(), are best kept using the old logic: the tc-taprio
> offload does not re-trigger another link mode resolve, so the scheduler
> needs to be functional from the get go, as long as Qbv is supported at
> all on the port. So to preserve functionality there, look at the static
> station interface capability from pf->si->hw_features instead.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
