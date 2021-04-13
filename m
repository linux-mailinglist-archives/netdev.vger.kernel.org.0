Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6171A35E731
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344639AbhDMTlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:41:13 -0400
Received: from mail-bn8nam11on2129.outbound.protection.outlook.com ([40.107.236.129]:53728
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232316AbhDMTlJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:41:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWfUinggU6pXRTIvwEC8R3gjKRCpSYxW/u2w198FGzzFUVOp767bFRoG0zfdEAsooPdRXWDoq2WYfwMJjlT+1e68i0HXFyaHcREQzd7GQQe26eXi4GAbMfqnNZaEYB6oLhfkYOCCM2+PfCs5ixswVQi20TTBzHs9FcTw3eJ766BUff7djMUxLzrCfT3Z5pde7dsSgL9AeEszWIMw436wBPyQAb5FbDXsKsucjt4RJuQ9Z+ot+TpS6DVGwIGkbAmZAuB+dyeCwJ7bGb7JAg9nES4JOMC8obv14S7uAx4z2JfHdQd5NfZgPJgPsyeEP8mZegVKiTwQAPPwXhr0ZGSA9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqdFVj4jL9v9wPHp98wUxI+n0qf09oj7aRL2er4Wdc0=;
 b=SAey9S2S+iHrJaFn4H/QoU9lWNZf+VKCuXcyvFJooQEcJTOTt937ZQRceePxxxr0loe80jL7R2qJwZiJcHWI9RbOsRgjJRjM+hYgCywnCwn4tvZd5e1H44julbQwdeZ0167XJEXL7/LmBaH4N+bHXSf6SH3yqbiHe6mFcOGBy1ZezjodtbYiO5OfeVkK0Y797JjwbFBkD/ho57UeL4kyUMXaT3D/uq2MoS/Y6JxAG+kllq3TdpVKlHQJMCgxv9Rrr9Cjy50VLWgBCus8+xrc2wmvLWjsKt5ARZyMsElCj3ZOsbCJiBcIalB1HjhS1LiMzhRVM+UmEM4eI1Cz/wUiXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqdFVj4jL9v9wPHp98wUxI+n0qf09oj7aRL2er4Wdc0=;
 b=A1/dQgxvTFA7OtnyUOlV91n9pXCgKkHzvCMJzKsMuSgHofyD1OS5yuZogXxUq6CRJUrHnm7hw+1Vi0XY3ENvb7ssemcZi4sSIBxexkHgKU4wjelY2IIvUNaiDgnZf61ILLfMpkabHZV2Xm3WrXhLX+uSDo2IqwDub3FsMSBfnjs=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MW4PR21MB1905.namprd21.prod.outlook.com
 (2603:10b6:303:7e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.1; Tue, 13 Apr
 2021 19:40:45 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4065.005; Tue, 13 Apr 2021
 19:40:45 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v5 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v5 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXMJexKRDubbeF0E2Lte4tPYOmB6qy1y9A
Date:   Tue, 13 Apr 2021 19:40:45 +0000
Message-ID: <MW2PR2101MB089261344E20347A4824C7C8BF4F9@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210413023509.51952-1-decui@microsoft.com>
 <20210413120324.18983187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210413120324.18983187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=10f7aa35-1d16-4b85-890f-2bfd762f326e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-13T19:35:39Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:3974:27a9:b6a0:1342]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62c68201-c20c-4eed-3b8e-08d8feb407e8
x-ms-traffictypediagnostic: MW4PR21MB1905:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB19051FE284848266455FA7C1BF4F9@MW4PR21MB1905.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i4HTNOGZ5u2UPsTCsZYHbwrL/Q5I09hkb70ss/PHoNrJYPn+IfA3T+ACHjc4CyLgR5SqaiyQCnhsB+AtznzFU6Qf+azzbO2vkbXvpo3l9XCShI3hxXJC76L5cOVBz0RzFNExA52s5/N0FJgF0m9I4gCxGNlYpVTXn23DPGArqY3cwzfyGkDKhlSAybPjqwnBdXlSi2emXnilLmy1BkQEu4JjB0RuAUj4SNnxD+hvrYqwxr7dlNmqLE8WgSgUkcU+QCSYIyuP1XMURXatH2x8mJ0AScq4n+sSitLxDLR7OnGPSifaMZD+HvcXFtIk7CDJoNhqLYWIQ6Wf1c2vdZGWKDyxYfcWBD/NTwhv3FPniRIJg8SduKZw7waAL1EwkUoOvlra5838vqrBj21rbRkNuAeJGX/pJGQYJb8NNqZAg6X7Wx8ee/j/DhGkUZK3nCt95/Hml2UywM6uxDSt+7o1Sy1cKk2cHOQqufQBHr3NHeJgJjAh7mW1t02ZhUQZixzZ+e90jRS5YpxYsJfmZTj1g89EbbVcySpIw83R9eRRj2ISzoz0Smy7MF5hYAIT6M5yqBq0YSvEyU61Gn2dZ9dHtKhRYLqHHtJF1fGgc8osWcE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(47530400004)(316002)(6916009)(83380400001)(82950400001)(8990500004)(71200400001)(8936002)(82960400001)(86362001)(7416002)(7696005)(8676002)(4326008)(478600001)(122000001)(6506007)(5660300002)(66556008)(76116006)(66476007)(52536014)(9686003)(10290500003)(66946007)(186003)(55016002)(64756008)(54906003)(2906002)(38100700002)(33656002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?AtFEWK0UFmD8yOEc12EMBlMAg2imw2cy6BKpj7w4j1FlAh+mzYnXt590JnMR?=
 =?us-ascii?Q?L+wqka+pQjYrhIa7xklTVjkMKonQWZBQ3Qbzm1DIIK4t+yNmd8AEplSi6WOy?=
 =?us-ascii?Q?vVma6SWqc0JSk8B5cRzXWIh6688uv1Mk3w9yj9Gwtwa3634Iy3qPQHzYptH2?=
 =?us-ascii?Q?d1qNPp0VAXgzzi5yOT2MQFeiEcpCA6fxw7dcMZFZF8s8vppUmxR2TNXDOGqC?=
 =?us-ascii?Q?bzK93uiVEFLNTobkc/enMvWg1oH2zMt0GCO7RkkO6PJP/f+0QZf9pW61b7ho?=
 =?us-ascii?Q?jQrn3agYxWwih04Pww4+GWSgny11G2eIWBJemlJP7qhyj75uIgsxYoOnMzkM?=
 =?us-ascii?Q?kExuTRaS5cchEiaiEdMRCe/Sk9Yulf4CVyt3FLXyEWBafGrW0H9dLtux5Vm7?=
 =?us-ascii?Q?bqCo3QWZHPSq63HxhQ5OJRnE5CNLX0xG5/sy0EDGEkpy9wvJaHRfUAhjjvrl?=
 =?us-ascii?Q?D91TpVFwvHffdGqeRS7UguNw8ke8R/UeKJa2vdT4x9F147NWu5N96agGmqeN?=
 =?us-ascii?Q?VZOd+/AtNP+N+yjDI5ZIdV/jrG6TUDwF4pRne1m6+2M/8zi1ItquZqs86ntj?=
 =?us-ascii?Q?qb18ub+x5jdACTD4SpOvrejVz8r55oVWwFfgO/3JngMXcdvEsEoiW7GopEx/?=
 =?us-ascii?Q?/q4UGMCa7YQK3TrLBqdE72KvwPPT5VlcAWZF2IVq1RmGnHBBfqmlS1PJhvcA?=
 =?us-ascii?Q?7oSap8psgIGsTC/hivdDQbsI4oKlYhy6ErmzdH5svn3wkRWuAXHWBCikRwrA?=
 =?us-ascii?Q?GlZWPnnOQGTaCfc0Wc6KZQWCbLFSVMLgKYl+oed607mRfqJWtNOS74O6+NbA?=
 =?us-ascii?Q?2HGPMb8QE2kkHMt1OBdzLG8LHNzqaeoa/PklYZIopQBmykpA0YIrdVKih78D?=
 =?us-ascii?Q?RMoI9zeWd0nzCirtI004I/WTTm7spVMl5rdXJXqLAlxvckQBHh56QjGWAZYx?=
 =?us-ascii?Q?dEPC6cBPriT0tht89DZYGrm/1th4+2gNdOsLGpt8REIThtsG3WmiJHUkPJ26?=
 =?us-ascii?Q?Jgd4ud7iXkSHZj3oxyxY/ikILQDhDU+yfwE2yOqhwd+eCgUGMzJ0xpOHiS2+?=
 =?us-ascii?Q?7yG1/8+5uoJ7MBvUEWQn3oedaKU1LrFvONJwNKgPr4yDjbbTBWSZc4XCZAye?=
 =?us-ascii?Q?n5cRjz8PqKIlFLxaYXw1tcOpiY5J76isRuKvys1DLmVef5ZU7i/MeX2sl7KW?=
 =?us-ascii?Q?2quZK7euNimQEYMfYG/JFQuv3Yk6LXIdyTJvt5zZh7rwNOykwUjKGNWHZ02Q?=
 =?us-ascii?Q?axikJ8qi3jDJdH9SFsCfLccdLARY6+sjHL0sk+Nq1W8+irSCHn8I8PZlVusa?=
 =?us-ascii?Q?zkKY5pq/75FycXnQmJXYWH4Cza8lp5nE9snX+Z4Gil4e+Rj/2PK06XkxhgbP?=
 =?us-ascii?Q?k42RivzAYwB7USDOYylmktxQ0sd7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c68201-c20c-4eed-3b8e-08d8feb407e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 19:40:45.1654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V4cetWuZF/DeZ58kcsbQ0Nb8iDD8xJkYHbI0etb9BEMJ3T3AQo8DVwEQ3Ao/p9QmI2Q+cPzwrPf5wH8m5nG8wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1905
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, April 13, 2021 12:03 PM
>=20
> On Mon, 12 Apr 2021 19:35:09 -0700 Dexuan Cui wrote:
> > +	apc->port_st_save =3D apc->port_is_up;
> > +	apc->port_is_up =3D false;
> > +	apc->start_remove =3D true;
> > +
> > +	/* Ensure port state updated before txq state */
> > +	smp_wmb();
> > +
> > +	netif_tx_disable(ndev);
>=20
> In your napi poll method there is no barrier between port_is_up check
> and netif_tx_queue_stopped().

Thanks for spotting this! We'll make the below change:

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -938,16 +938,19 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
        avail_space =3D mana_gd_wq_avail_space(gdma_wq);

        /* Ensure tail updated before checking q stop */
        smp_mb();

        net_txq =3D txq->net_txq;
        txq_stopped =3D netif_tx_queue_stopped(net_txq);

+       /* Ensure checking txq_stopped before apc->port_is_up. */
+       smp_rmb();
+
        if (txq_stopped && apc->port_is_up && avail_space >=3D MAX_TX_WQE_S=
IZE) {
                netif_tx_wake_queue(net_txq);
                apc->eth_stats.wake_queue++;
        }

        if (atomic_sub_return(pkt_transmitted, &txq->pending_sends) < 0)
                WARN_ON_ONCE(1);
 }

> > +	netif_carrier_off(ndev);
> > +
> > +	/* No packet can be transmitted now since apc->port_is_up is false.
> > +	 * There is still a tiny chance that mana_poll_tx_cq() can re-enable
> > +	 * a txq because it may not timely see apc->port_is_up being cleared
> > +	 * to false, but it doesn't matter since mana_start_xmit() drops any
> > +	 * new packets due to apc->port_is_up being false.
> > +	 *
> > +	 * Drain all the in-flight TX packets
> > +	 */
> > +	for (i =3D 0; i < apc->num_queues; i++) {
> > +		txq =3D &apc->tx_qp[i].txq;
> > +
> > +		while (atomic_read(&txq->pending_sends) > 0)
> > +			usleep_range(1000, 2000);
> > +	}
>=20
> > +		/* All cleanup actions should stay after rtnl_lock(), otherwise
> > +		 * other functions may access partially cleaned up data.
> > +		 */
> > +		rtnl_lock();
> > +
> > +		mana_detach(ndev);
> > +
> > +		unregister_netdevice(ndev);
> > +
> > +		rtnl_unlock();
>=20
> I find the resource management somewhat strange. Why is mana_attach()
> and mana_detach() called at probe/remove time, and not when the
> interface is brought up? Presumably when the user ifdowns the interface
> there is no point holding the resources? Your open/close methods are
> rather empty.

Thanks for the suggestion! Will move the functions to open/close().

> > +	if ((eq_addr & PAGE_MASK) !=3D eq_addr)
> > +		return -EINVAL;
> > +
> > +	if ((cq_addr & PAGE_MASK) !=3D cq_addr)
> > +		return -EINVAL;
> > +
> > +	if ((rq_addr & PAGE_MASK) !=3D rq_addr)
> > +		return -EINVAL;
> > +
> > +	if ((sq_addr & PAGE_MASK) !=3D sq_addr)
> > +		return -EINVAL;

Will change to PAGE_ALIGNED().=20

Thanks,
Dexuan
