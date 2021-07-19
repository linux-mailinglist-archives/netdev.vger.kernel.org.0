Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE203CD06D
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbhGSIg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:36:27 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:59040
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235952AbhGSIgW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 04:36:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbkyZb4q8w08TFbLpViiZfJtO/yo1Try1wURTzwzrc5h7oI6YKECVaD4zKwj6sKWhXLbwf7uNUyGFR9cjUDZeQobvT9qrbzAcfLDnKJs9zkJnoJIl/qQ6AYZw+7yzGx6y8G0Qd9ZxkzmQg1Xs7I6RSb/THC5j2PbQtmgTAim/4RQJALcPJUuy3Sft2V0wS97PTQ67tRFX1MvwlWRsWvbFFdWpRBPuKB4GiDMenTMREbaqLKfJk0mAUZ9oSyHBC7PJdXwEiPI5pPxEgREUJ9D4xUByb10hmeseFstJxE8gKtnJvXt03/Op4z/NrhiiSo0MA/e35wE1nzgx1ddJdX40Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGc3gl8RjegVmXP7SKg8cy3ohNLVad0xr3bfCMugcxA=;
 b=jb0McgVvCp+YmeJlPU5fUvjJs6jG9jdhMD12pag1Il2saC2kkvjhyBxjvRACa7gV5nH7HE3MleSSUK8u22AuHyLHQV4ozbJW7eQ3ITTkt+lK4F6SAoZd7ihANxrOy7KMP3IVY+EAGFyn2KlpZTssJEiQuIVuQQ7Lq4LSnVoUmYD0eZwOnqFlAZ7ezONdwbUES267iirv3sxEFtf/gy0MJGlN4dFGPMJyR4pgCBa3m3NYcjmp77KY4nETTPck2ZYVjTxZ/Y0WbIe1lB5+MtRa6gAH61nMbwNalAsqU8uAp0j6IdqnZtL9AiiF+fo+xdAmytnjaBykMiRIS/BEKwNymQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGc3gl8RjegVmXP7SKg8cy3ohNLVad0xr3bfCMugcxA=;
 b=lkm1wljBmIDXDMk53PCwvet1IRmyaEMxT4Q9Nb800iX9Z5NauQ02DFd50OR2uewrMx8ivcbsOiDNVAyZb93U1tAKvfvJB+yW+4qBwyFCLZmP0/EpTTLu5tHBwjQlMfObIofFqjUinncfbbXKbmdLGD/k8VeXiRVtgY+RBftyUEA=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM9PR04MB8211.eurprd04.prod.outlook.com
 (2603:10a6:20b:3ea::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 09:17:00 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601%3]) with mapi id 15.20.4308.027; Mon, 19 Jul 2021
 09:17:00 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v4 net-next 01/15] net: dpaa2-switch: use extack in
 dpaa2_switch_port_bridge_join
Thread-Topic: [PATCH v4 net-next 01/15] net: dpaa2-switch: use extack in
 dpaa2_switch_port_bridge_join
Thread-Index: AQHXfB5TtLxvJZVT7UWsnu7dwycyoqtKBWkA
Date:   Mon, 19 Jul 2021 09:17:00 +0000
Message-ID: <20210719091658.lqczq4w3icqvuhj4@skbuf>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-2-vladimir.oltean@nxp.com>
In-Reply-To: <20210718214434.3938850-2-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdad7264-f8dc-4fbf-4f90-08d94a95f705
x-ms-traffictypediagnostic: AM9PR04MB8211:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM9PR04MB8211975D9F598087CA4FC25FE0E19@AM9PR04MB8211.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +xsQ6O+aQAuuqMPX6z15peKAYHM0Z0D7rQrX8rpvQwZ5Qh2dShVZ76ROfU2gjMJbrZIXzBSvWcxJgwcP0CyyqGLCfCYavLOpApSpM+37w88cMNNWK9i1rzVHDGj3U/Kowjjh+NKFW0wzRsGc/ku7l2baga6TfzeEcgZrQ8PIogzMVjbCB1bkDzd6AjJBGnOlUohnBnPJi/AaO+SztBh1nSQoh6QbJmNFdHD9jtWV7yecrjqNBv0btyHyckqWIVQB1pVnklG8mNfnKkJskHYBUHx5Nfin586Ip3+GgSLE1jy4uMLqqk2ACcTblppgXeMINQO7Lr5oPATgO7TXEh1C7C5ylL/65wd8iziPC8QwTRsXMLZBbeuYF/Swa6+XpdVKMi9y7CktCBR4d61eYqJzTqcxwdTJ89DWWpYkLzNpi+D40+GZhb9KEyQ5FUCnERpmItHO+0NZbJgM7ESGwI6gjk59CnsXcBeuJfgtJBuu90m3Psp0hnukMpTeN/roIzSP941e+mesi5KVHyAisa1TQYp+76z3q/Bys24MAf8pkErF6n7ZezH5TmcOY+lRYJZUftCG/6ZV6T861a9UEwpjECi0IhN/bkJ/jax/O7SQcig3ySCV6yoQ+7wk4HMTs/kE+/r52gKAsmLaBQ4oXoqBbB2EKkyGRLWeRU5GCa2zx+ghOZZ7zulJWmdMLUQaiB8FXpT3dGprDQzjE3ceCMcnpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(6636002)(4744005)(33716001)(83380400001)(6506007)(2906002)(4326008)(122000001)(6862004)(86362001)(38100700002)(71200400001)(186003)(6486002)(5660300002)(316002)(76116006)(64756008)(66476007)(478600001)(54906003)(7416002)(8936002)(6512007)(9686003)(1076003)(44832011)(8676002)(66446008)(66556008)(26005)(66946007)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?orNkc+mJ20+q2DUarQkUTRDUx2Je4pMp52qiMTHe1m+O8ehaYO7hKDaO+tf0?=
 =?us-ascii?Q?qZch1pj251l1H1/PNq/1pv1RDGuMX7ZD9PznWvbQbNKONyut989U39hDrWXE?=
 =?us-ascii?Q?WncIvWncwr1catOPey3oG7hMk2n2i0ETPupV0BAeJ0yIqc0NvRT1kt+MKlHa?=
 =?us-ascii?Q?oRk4UJSv7wIMMP6J6P8gRKpmRUocCQOQHJE5xmtnMBf68ulUy0FtkCk9DbHv?=
 =?us-ascii?Q?8BJiSsDqrNQm9ShJtObPY8v7GocJDwKuzNmbv8TMqDgi4w7X7zyIloj/k/7j?=
 =?us-ascii?Q?vVBClgbMStrPDoBwvgbmf0pejKu2UTmuiGMpbs9rDFIFDudsDFIJsXAw6ouG?=
 =?us-ascii?Q?Z55vzjccjeG5eJ1Mne/eIIA2H66ia5drQq0skkJl5rdxIyyhkTFXd2GwHBFY?=
 =?us-ascii?Q?zlfQVnKM6N0W5aq0BTG/wkoobcU2RdowNUXctochdeladNtk2xMbFw36gy36?=
 =?us-ascii?Q?xzaU5hMuwv3LK7GgOd41iZBUg07yPwaXITl1WONt6c3VvMvlKRveLK9AZClZ?=
 =?us-ascii?Q?WcUiJ758mXUZ3G4vvvX9vR/4uBqkh1M7bRgfm59uTBU/5VGrQZkxZRgpZGzq?=
 =?us-ascii?Q?CjLr728mS6Aa8DgbP9LF50g59jHWV7LvAonnsy/+PrHLLeLPfMt/1qacEKaL?=
 =?us-ascii?Q?Eruahu80NHg3irmAt1x9THBKBHMR+EIUSdXmjX6VOktFBzvFDE+o5M4jsRKi?=
 =?us-ascii?Q?3Yrg+t/hqpE2aICxUqw0Qc9Pg9qpgBlq8rwoVFg50zD0co8jsVexOFUwIQgQ?=
 =?us-ascii?Q?iC+KzU58oQXtEe+3brtjprNKYBIlCEw7hIjnrS9W0ZjDRoI6uT9y69hRirDJ?=
 =?us-ascii?Q?8+YXl2jHPXr+F9IFLLisBO7e8htkG6hzrV92g0riSa3h6Khq5bHVajKJeVQL?=
 =?us-ascii?Q?wtoIXgPzq3u1rheUXQyO0Q6VKlIMnrgQEJqVUWv9av8Y+eej2TaVV+GOxH/O?=
 =?us-ascii?Q?e/qIg48/uauMhGglmeQaaqpwbXQzlbpnm9tmkwcdie1pzEMqMbdjBn18FHU7?=
 =?us-ascii?Q?jnFq5AD2gH0xhCvcJAWb/IYBZ8/wdsGZq/7UMs6/3xqqnXz13pq1lHgndMW8?=
 =?us-ascii?Q?yaZwHBcOuzn9wYR+gUrOvrjAW5j9FQCT5lG2n6RAnrbvqAOGBFwvO3yFWINP?=
 =?us-ascii?Q?WcAlVkqQO9TuxUx+fISJdJv7EzA3FadOYpoOPAtqGbXTD4YlIfWjsGXAEy8W?=
 =?us-ascii?Q?sJaIwNFJTiOjDAsLaIc8hY1z/XNs5DrmBrtKu69mBydXUWTthMl7r46EGJSk?=
 =?us-ascii?Q?sujtTHPKiWl0geQVirt3Jy7p9cvv9BW2e3g15yCT+kLnYWbhRNXhNA/spHH1?=
 =?us-ascii?Q?c72szUvyjHtrl8Q3B0SSgXxH?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <828456CF8CC1924BB34F2EA70D4E0831@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdad7264-f8dc-4fbf-4f90-08d94a95f705
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2021 09:17:00.3629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tvqRAKifrA0Xe4mQqmrLQjWok8z5dFKW9rdmA7BLRtw1aWZ4/RdI1C81V6HcxNmjnXWvFiHjlib4UeykQtXFiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8211
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 12:44:20AM +0300, Vladimir Oltean wrote:
> We need to propagate the extack argument for
> dpaa2_switch_port_bridge_join to use it in a future patch, and it looks
> like there is already an error message there which is currently printed
> to the console. Move it over netlink so it is properly transmitted to
> user space.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>=
