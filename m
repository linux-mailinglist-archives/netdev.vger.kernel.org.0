Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698B841772A
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 16:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346934AbhIXO7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 10:59:22 -0400
Received: from mail-oln040093003008.outbound.protection.outlook.com ([40.93.3.8]:2103
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346908AbhIXO7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 10:59:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BsRzDBssjmFjax/SIIBvq3mvI9+O77smANbO4ZC9p4qiK7QW69Azoy74s+rPCCAlkDxTlmd9C0dQQX2TIq07zo8uob/EYZdFFklAwh9KgMWppzn04LmC7fxEdVCwV0GPL/XvHdyL8Gt4a4PwT448IqJpH6evMxZ6S2h39V9zzHUP/bTdIXF2FigkdgLICez1LaetBKdPMt/FGxixdwFoECinGtigC2CITGzwU/rNNbzmj1+Wfj1yRXhgUqoeT+OhYBPb2LRUB8n/xca2loM6ksj1wxI4M6Gp/W5f+2lml8EfNe2+XzgpKnW5jbuuSKDubTjqpeXBwa8KUbTqZ7yKPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfdtYYrDIjcv4v4lvK3lyG3maUwqmIlZ7lF8ciwrPw4=;
 b=mc1vn2Etsq9W5prba/MEQwXO2fu3LPbVAizXOkF+cn8cgV3tw9MMg6KJBPdI4y8yQNIoQhLncFn4N2FEkxx9HbdEbHe++QQoVAr/bFxsG9hNi9khmi9/E+GIVzMDFkG4T32fOKVu+jWH57gJY2ZljyQ0W4A11egJfxEk1j1GMcniFn/1zu2cYWdYBaw7ki1eaWsDAVLTAhp20nnsKpxqWDqUd3eAvjuCrQ37G1xcY8JQxfocyg4SPyzJ+4ryARj4W8pGRy+WoRQKC5f/Zpqle/Xt9rsy446DVwYbkWFjIwR/wXICU1CnCtyakKBXO9traPNxXty6e2IAppAxn6Tbxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfdtYYrDIjcv4v4lvK3lyG3maUwqmIlZ7lF8ciwrPw4=;
 b=U8XpUYL4N2auhI0KzwtLXfxijviJMNR4ctjSE3zZWS9dm3Ra66Nvs5VghW1/0tn30OyxqyilzsdHlZA/3ZGt8ILzb3BtBNFAczbFqjWHKlTd/IUj9H8Fi0a8db1VQPALY+21wejWBN+p/+VHOT29TLKaC0OJ02ryUgKSvYlzwvQ=
Received: from MN2PR21MB1295.namprd21.prod.outlook.com (20.179.21.153) by
 MN2PR21MB1518.namprd21.prod.outlook.com (20.180.27.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.4; Fri, 24 Sep 2021 14:57:43 +0000
Received: from MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::9d2e:8888:5f6a:1aa9]) by MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::9d2e:8888:5f6a:1aa9%3]) with mapi id 15.20.4544.010; Fri, 24 Sep 2021
 14:57:43 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "amitc@mellanox.com" <amitc@mellanox.com>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "danieller@nvidia.com" <danieller@nvidia.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "jdike@addtoit.com" <jdike@addtoit.com>,
        "richard@nod.at" <richard@nod.at>,
        "anton.ivanov@cambridgegreys.com" <anton.ivanov@cambridgegreys.com>,
        "netanel@amazon.com" <netanel@amazon.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "saeedb@amazon.com" <saeedb@amazon.com>,
        "chris.snook@gmail.com" <chris.snook@gmail.com>,
        "ulli.kroll@googlemail.com" <ulli.kroll@googlemail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "jeroendb@google.com" <jeroendb@google.com>,
        "csully@google.com" <csully@google.com>,
        "awogbemila@google.com" <awogbemila@google.com>,
        "jdmason@kudzu.us" <jdmason@kudzu.us>,
        "rain.1986.08.12@gmail.com" <rain.1986.08.12@gmail.com>,
        "zyjzyj2000@gmail.com" <zyjzyj2000@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "doshir@vmware.com" <doshir@vmware.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "jwi@linux.ibm.com" <jwi@linux.ibm.com>,
        "kgraul@linux.ibm.com" <kgraul@linux.ibm.com>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "chenhao288@hisilicon.com" <chenhao288@hisilicon.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH V2 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Thread-Topic: [PATCH V2 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Thread-Index: AQHXsVFJ8XB6DG5a60SwRBG/Qs2GGKuzRcqA
Date:   Fri, 24 Sep 2021 14:57:43 +0000
Message-ID: <MN2PR21MB129587564763ADB67F8D0EF8CAA49@MN2PR21MB1295.namprd21.prod.outlook.com>
References: <20210924142959.7798-1-huangguangbin2@huawei.com>
 <20210924142959.7798-5-huangguangbin2@huawei.com>
In-Reply-To: <20210924142959.7798-5-huangguangbin2@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=79a8191a-777f-4997-80ee-d0614b140ca6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-24T14:55:28Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e310c4ba-3c85-400a-551e-08d97f6ba9ba
x-ms-traffictypediagnostic: MN2PR21MB1518:
x-microsoft-antispam-prvs: <MN2PR21MB1518D5E691CDCDBA8757CFA1CAA49@MN2PR21MB1518.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e959P/CddVNgh8Q1jbRwTlWk8aF/cz4JSLnrx4LLV4ix7zFeayEuaYkDsHJ/iCTaZw38MZgaZ4IoBt0mVr6UPWeoRRchadw9oFXgjbcB0oW5BRvcqeZdFH/B+zlJW/jKzt1HBBJjCbdK4wznnllYl8t3T76WUjWESmkYNG2aCn6Kk1SRjI3kNiteCJ6PvQuwP81YjsK4IQwu7nXIgEkL/oQRxOphur4V038HARZLnkt+nj3Zn24pFuYLm/hW18HSSXXjU0RV95RzMj3Q2X44eH70lNP1ZqmWY8JjULPxgQPZj3tLJBo2oRSLr8vFPGw4H8zWuMYX84AFgWR4q/5P6K+nsFyGozDU45PVMAMnqfZ4MwpX0uxtZvEahmrvowrBJx1Zl0lOiKmZ4bqdmsm3ivXmrniFx61cjBcKHUfQFuhyq2VQiq8OJ/84daMsZTc7A9Bx43s8ud5flWR05kzfQIYTnyQr9l+EVYkhduARzAJDlgl3U0a4eilcvZvlM0+/MO9dRbZ1C3DJnWI2WXLj1hlfmYzsNB1rv0c9/3YBLtRG++aG7p138K4pKnC+FSAwMHLfSxkT7zBEWmZGQNXRiQ04C2Lu5UYDKCYgFWmw3pz6TAVQ5LgvY4ot6nz2xmAq34p/TXe17B/F+VwmRIWxO0w6Bem6O/qSYthvGZW3Ab1/mpQ4iYSUhGAxLZ3gqS3zBH8wHm/OumDu4rGlmfVkVzTR4jLZDdTnichC42zzmgUUGBXEqCVnLXAxfbEIlZ1kte9HocUiRd/PmfrdwjvVdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1295.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(186003)(966005)(6506007)(82950400001)(8936002)(66476007)(86362001)(508600001)(10290500003)(9686003)(38100700002)(83380400001)(55016002)(82960400001)(122000001)(4326008)(8990500004)(7406005)(2906002)(76116006)(64756008)(316002)(54906003)(33656002)(30864003)(66556008)(66946007)(26005)(7416002)(71200400001)(66446008)(110136005)(7696005)(53546011)(52536014)(38070700005)(5660300002)(921005)(559001)(569008)(579004)(10090945008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jhNYa4QU6QzvrFPgninAjoUsJhVJLGy3mrLhzJzPw11FUZv6dXRSCiAb6gBC?=
 =?us-ascii?Q?kTff+axIp1zZabt51sVIHiKaceqMufZw/tJ5BYimr4PQ3cFOaCtH3Q+Z9/tU?=
 =?us-ascii?Q?XDW9uDnImr4tJKAYakHDrpKpJ51m7IQcVT5yHi2yoOL9EF+9pZyfdEbUSuk4?=
 =?us-ascii?Q?/KNvUZwiCDGMzA0IES0BuS0mqThbaW9zuQ+ulyHz++j8V/7HSGA5IEaaWtDq?=
 =?us-ascii?Q?Pg2qSg/lw9kWaljyX9t+CocNL2twBHJ4mr2sCjikE7snMSnzogwc9FiH96d/?=
 =?us-ascii?Q?lteqta+Nlhi1rX/0HnbxnidOzMmwBRo6DrzPmaFTuuv0iZ5sQNoMW30lsgne?=
 =?us-ascii?Q?tiVE95pzDvAzZfEb79IoBEb7hrozIs0rp3/FEwBr93tFym2whulYPqKIAhho?=
 =?us-ascii?Q?AkdOk42FFIxyGlLRnQDtD7AJVf6YSrIqIIKXlTIndLvxIsKOHt7MFs4ESENo?=
 =?us-ascii?Q?LCVZO7wNlHaSUBVz8POhMcpcKVWA4ueAO+WicSlORT52CztuSps9b2UXVChp?=
 =?us-ascii?Q?u1DAFSNknwKWkkSLx82OeQnGD7isu2Er/cArgVt3GIOplZDthx2gpjphmCbN?=
 =?us-ascii?Q?GjGMF7Zhl6d4/wAU0Vj3kJkiJdVL1WGbXs21BB9IpTOsLoeF/urcXnHQScWJ?=
 =?us-ascii?Q?u7Ex1nh/fGefigT1hx+M9t3ysOHhDYhZ+kVlB28TC8ePanqSCs1qOwNBFYS7?=
 =?us-ascii?Q?UhaDyRPd3SF6IBc0kkpyn1gmY+Rf2VluHeMrddwZQiP83vbmGmH+lEQxBASd?=
 =?us-ascii?Q?P0yzpYUDyqJOMF+xAj4AQQGdnpiuK4w9ZH+m0dX7UkwYGxcp6fCpgc2yeO4H?=
 =?us-ascii?Q?lasubqwNI8L6bOaegsu1gwysg9KjHCA3jkF38DwoH68hfKTHkPM6qU0xzJqD?=
 =?us-ascii?Q?nmR2+HiCXRuowcemOIzlev1aPHjdj2axWOK5S4GL5rSal8/UqTZskNHA1WEw?=
 =?us-ascii?Q?9HvOLua2cXo7XvC3YRyHubUWbDuDXIi0getnZ6Vrkgha5Wbg+Z5IHUrENxJx?=
 =?us-ascii?Q?9yIxY15r8Bwq4p0O7zxW93Ol09eOubxqdvV58GmcSlWUXvU7Z3J9MekAbyED?=
 =?us-ascii?Q?iwg5vEEydQB2bC5F+67bvL12idLSzQUbRUDZsut1AkAyANsd740dRw0Hi+oB?=
 =?us-ascii?Q?hEro5wARavcF/9LUXNbOSbCMKPhrPXaX1ApAXv8NPeS9HWWx8L1ITxaxbupn?=
 =?us-ascii?Q?7PiAFqO9OyXx/i19vlBmqE/ZAVpjTpOkO6He2MSU8+lTco8jp9KQoJboKwmg?=
 =?us-ascii?Q?YzY07ayqDesTzBZVFO0dad0c82wF7rdMT6w7NL0DR8YjIZefbUR8tBOCeaIR?=
 =?us-ascii?Q?HzLQoEs7dNHtKbCZwvDY7PUw?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1295.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e310c4ba-3c85-400a-551e-08d97f6ba9ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2021 14:57:43.3975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zW//caw92MtzaFlmNw+DTILvqyMDoZGcrM0yr9o5BjZBGHBPOG5pfDoSWz62oNoNJ6zAtOrqSL4uVOsrspz8MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1518
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Guangbin Huang <huangguangbin2@huawei.com>
> Sent: Friday, September 24, 2021 10:30 AM
> To: davem@davemloft.net; kuba@kernel.org; mkubecek@suse.cz;
> andrew@lunn.ch; amitc@mellanox.com; idosch@idosch.org;
> danieller@nvidia.com; jesse.brandeburg@intel.com;
> anthony.l.nguyen@intel.com; jdike@addtoit.com; richard@nod.at;
> anton.ivanov@cambridgegreys.com; netanel@amazon.com; akiyano@amazon.com;
> gtzalik@amazon.com; saeedb@amazon.com; chris.snook@gmail.com;
> ulli.kroll@googlemail.com; linus.walleij@linaro.org; jeroendb@google.com;
> csully@google.com; awogbemila@google.com; jdmason@kudzu.us;
> rain.1986.08.12@gmail.com; zyjzyj2000@gmail.com; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> mst@redhat.com; jasowang@redhat.com; doshir@vmware.com; pv-
> drivers@vmware.com; jwi@linux.ibm.com; kgraul@linux.ibm.com;
> hca@linux.ibm.com; gor@linux.ibm.com; johannes@sipsolutions.net
> Cc: netdev@vger.kernel.org; lipeng321@huawei.com;
> chenhao288@hisilicon.com; huangguangbin2@huawei.com; linux-
> s390@vger.kernel.org
> Subject: [PATCH V2 net-next 4/6] ethtool: extend ringparam setting uAPI
> with rx_buf_len
>=20
> [You don't often get email from huangguangbin2@huawei.com. Learn why
> this is important at http://aka.ms/LearnAboutSenderIdentification.]
>=20
> From: Hao Chen <chenhao288@hisilicon.com>
>=20
> Add two new parameters ringparam_ext and extack for
> .get_ringparam and .set_ringparam to extend more ring params
> through netlink.
>=20
> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  arch/um/drivers/vector_kern.c                    |  4 +++-
>  drivers/net/can/c_can/c_can_ethtool.c            |  4 +++-
>  drivers/net/ethernet/3com/typhoon.c              |  4 +++-
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c    |  8 ++++++--
>  drivers/net/ethernet/amd/pcnet32.c               |  8 ++++++--
>  drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c     |  8 ++++++--
>  .../net/ethernet/aquantia/atlantic/aq_ethtool.c  |  8 ++++++--
>  drivers/net/ethernet/atheros/atlx/atl1.c         |  8 ++++++--
>  drivers/net/ethernet/broadcom/b44.c              |  8 ++++++--
>  drivers/net/ethernet/broadcom/bcm63xx_enet.c     | 16 ++++++++++++----
>  drivers/net/ethernet/broadcom/bnx2.c             |  8 ++++++--
>  .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c  |  8 ++++++--
>  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c    |  8 ++++++--
>  drivers/net/ethernet/broadcom/tg3.c              | 10 ++++++++--
>  drivers/net/ethernet/brocade/bna/bnad_ethtool.c  |  8 ++++++--
>  drivers/net/ethernet/cadence/macb_main.c         |  8 ++++++--
>  .../net/ethernet/cavium/liquidio/lio_ethtool.c   |  8 ++++++--
>  .../net/ethernet/cavium/thunder/nicvf_ethtool.c  |  8 ++++++--
>  drivers/net/ethernet/chelsio/cxgb/cxgb2.c        |  8 ++++++--
>  drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c  |  8 ++++++--
>  .../net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c   |  8 ++++++--
>  .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c  |  8 ++++++--
>  drivers/net/ethernet/cisco/enic/enic_ethtool.c   |  8 ++++++--
>  drivers/net/ethernet/cortina/gemini.c            |  8 ++++++--
>  drivers/net/ethernet/emulex/benet/be_ethtool.c   |  4 +++-
>  drivers/net/ethernet/ethoc.c                     |  8 ++++++--
>  drivers/net/ethernet/faraday/ftgmac100.c         |  8 ++++++--
>  .../net/ethernet/freescale/enetc/enetc_ethtool.c |  4 +++-
>  drivers/net/ethernet/freescale/gianfar_ethtool.c |  8 ++++++--
>  .../net/ethernet/freescale/ucc_geth_ethtool.c    |  8 ++++++--
>  drivers/net/ethernet/google/gve/gve_ethtool.c    |  4 +++-
>  drivers/net/ethernet/hisilicon/hns/hns_ethtool.c |  6 +++++-
>  .../net/ethernet/hisilicon/hns3/hns3_ethtool.c   |  8 ++++++--
>  .../net/ethernet/huawei/hinic/hinic_ethtool.c    |  8 ++++++--
>  drivers/net/ethernet/ibm/emac/core.c             |  4 +++-
>  drivers/net/ethernet/ibm/ibmvnic.c               |  8 ++++++--
>  drivers/net/ethernet/intel/e100.c                |  8 ++++++--
>  drivers/net/ethernet/intel/e1000/e1000_ethtool.c |  8 ++++++--
>  drivers/net/ethernet/intel/e1000e/ethtool.c      |  8 ++++++--
>  drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c |  8 ++++++--
>  drivers/net/ethernet/intel/i40e/i40e_ethtool.c   |  8 ++++++--
>  drivers/net/ethernet/intel/iavf/iavf_ethtool.c   | 12 ++++++++++--
>  drivers/net/ethernet/intel/ice/ice_ethtool.c     |  8 ++++++--
>  drivers/net/ethernet/intel/igb/igb_ethtool.c     |  8 ++++++--
>  drivers/net/ethernet/intel/igbvf/ethtool.c       |  8 ++++++--
>  drivers/net/ethernet/intel/igc/igc_ethtool.c     |  8 ++++++--
>  drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c   |  8 ++++++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |  8 ++++++--
>  drivers/net/ethernet/intel/ixgbevf/ethtool.c     |  8 ++++++--
>  drivers/net/ethernet/marvell/mv643xx_eth.c       |  8 ++++++--
>  drivers/net/ethernet/marvell/mvneta.c            |  8 ++++++--
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c  |  8 ++++++--
>  .../marvell/octeontx2/nic/otx2_ethtool.c         |  8 ++++++--
>  drivers/net/ethernet/marvell/skge.c              |  8 ++++++--
>  drivers/net/ethernet/marvell/sky2.c              |  8 ++++++--
>  drivers/net/ethernet/mellanox/mlx4/en_ethtool.c  |  8 ++++++--
>  .../net/ethernet/mellanox/mlx5/core/en_ethtool.c |  8 ++++++--
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  8 ++++++--
>  .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c  |  8 ++++++--
>  .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c     |  4 +++-
>  drivers/net/ethernet/micrel/ksz884x.c            |  5 ++++-
>  drivers/net/ethernet/myricom/myri10ge/myri10ge.c |  4 +++-
>  drivers/net/ethernet/neterion/s2io.c             |  4 +++-
>  .../net/ethernet/netronome/nfp/nfp_net_ethtool.c |  8 ++++++--
>  drivers/net/ethernet/nvidia/forcedeth.c          | 10 ++++++++--
>  .../ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c  | 10 ++++++++--
>  drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c |  4 +++-
>  .../net/ethernet/pensando/ionic/ionic_ethtool.c  |  8 ++++++--
>  .../ethernet/qlogic/netxen/netxen_nic_ethtool.c  |  8 ++++++--
>  drivers/net/ethernet/qlogic/qede/qede_ethtool.c  |  8 ++++++--
>  .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c  |  8 ++++++--
>  .../net/ethernet/qualcomm/emac/emac-ethtool.c    |  8 ++++++--
>  drivers/net/ethernet/qualcomm/qca_debug.c        |  8 ++++++--
>  drivers/net/ethernet/realtek/8139cp.c            |  4 +++-
>  drivers/net/ethernet/realtek/r8169_main.c        |  4 +++-
>  drivers/net/ethernet/renesas/ravb_main.c         |  8 ++++++--
>  drivers/net/ethernet/renesas/sh_eth.c            |  8 ++++++--
>  drivers/net/ethernet/sfc/ef100_ethtool.c         |  4 +++-
>  drivers/net/ethernet/sfc/ethtool.c               |  8 ++++++--
>  drivers/net/ethernet/sfc/falcon/ethtool.c        |  8 ++++++--
>  .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c |  8 ++++++--
>  drivers/net/ethernet/tehuti/tehuti.c             | 10 ++++++++--
>  drivers/net/ethernet/ti/am65-cpsw-ethtool.c      |  4 +++-
>  drivers/net/ethernet/ti/cpmac.c                  |  8 ++++++--
>  drivers/net/ethernet/ti/cpsw_ethtool.c           |  8 ++++++--
>  drivers/net/ethernet/ti/cpsw_priv.h              |  8 ++++++--
>  .../net/ethernet/toshiba/spider_net_ethtool.c    |  4 +++-
>  drivers/net/ethernet/xilinx/ll_temac_main.c      | 14 ++++++++++----
>  .../net/ethernet/xilinx/xilinx_axienet_main.c    | 14 ++++++++++----
>  drivers/net/hyperv/netvsc_drv.c                  |  8 ++++++--
>  drivers/net/netdevsim/ethtool.c                  |  8 ++++++--
>  drivers/net/usb/r8152.c                          |  8 ++++++--
>  drivers/net/virtio_net.c                         |  4 +++-
>  drivers/net/vmxnet3/vmxnet3_ethtool.c            |  8 ++++++--
>  drivers/s390/net/qeth_ethtool.c                  |  4 +++-
>  net/ethtool/ioctl.c                              |  9 ++++++---
>  net/ethtool/rings.c                              | 15 +++++++++++----
>  net/mac80211/ethtool.c                           |  8 ++++++--
>  98 files changed, 562 insertions(+), 185 deletions(-)
>=20
> diff --git a/arch/um/drivers/vector_kern.c
> b/arch/um/drivers/vector_kern.c
> index cde6db184c26..22b59e262c1c 100644
> --- a/arch/um/drivers/vector_kern.c
> +++ b/arch/um/drivers/vector_kern.c
> @@ -1441,7 +1441,9 @@ static int vector_net_load_bpf_flash(struct
> net_device *dev,
>  }
>=20
>  static void vector_get_ringparam(struct net_device *netdev,
> -                               struct ethtool_ringparam *ring)
> +                                struct ethtool_ringparam *ring,
> +                                struct ethtool_ringparam_ext *ring_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct vector_private *vp =3D netdev_priv(netdev);
>=20
> diff --git a/drivers/net/can/c_can/c_can_ethtool.c
> b/drivers/net/can/c_can/c_can_ethtool.c
> index 377c7d2e7612..1d7eddfd09ec 100644
> --- a/drivers/net/can/c_can/c_can_ethtool.c
> +++ b/drivers/net/can/c_can/c_can_ethtool.c
> @@ -20,7 +20,9 @@ static void c_can_get_drvinfo(struct net_device
> *netdev,
>  }
>=20
>  static void c_can_get_ringparam(struct net_device *netdev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct c_can_priv *priv =3D netdev_priv(netdev);
>=20
> diff --git a/drivers/net/ethernet/3com/typhoon.c
> b/drivers/net/ethernet/3com/typhoon.c
> index 05e15b6e5e2c..dae332ab6626 100644
> --- a/drivers/net/ethernet/3com/typhoon.c
> +++ b/drivers/net/ethernet/3com/typhoon.c
> @@ -1138,7 +1138,9 @@ typhoon_set_wol(struct net_device *dev, struct
> ethtool_wolinfo *wol)
>  }
>=20
>  static void
> -typhoon_get_ringparam(struct net_device *dev, struct ethtool_ringparam
> *ering)
> +typhoon_get_ringparam(struct net_device *dev, struct ethtool_ringparam
> *ering,
> +                     struct ethtool_ringparam_ext *ering_ext,
> +                     struct netlink_ext_ack *extack)
>  {
>         ering->rx_max_pending =3D RXENT_ENTRIES;
>         ering->tx_max_pending =3D TXLO_ENTRIES - 1;
> diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> index 13e745cf3781..ea1af149d02f 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> @@ -465,7 +465,9 @@ static void ena_get_drvinfo(struct net_device *dev,
>  }
>=20
>  static void ena_get_ringparam(struct net_device *netdev,
> -                             struct ethtool_ringparam *ring)
> +                             struct ethtool_ringparam *ring,
> +                             struct ethtool_ringparam_ext *ring_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct ena_adapter *adapter =3D netdev_priv(netdev);
>=20
> @@ -476,7 +478,9 @@ static void ena_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int ena_set_ringparam(struct net_device *netdev,
> -                            struct ethtool_ringparam *ring)
> +                            struct ethtool_ringparam *ring,
> +                            struct ethtool_ringparam_ext *ring_ext,
> +                            struct netlink_ext_ack *extack)
>  {
>         struct ena_adapter *adapter =3D netdev_priv(netdev);
>         u32 new_tx_size, new_rx_size;
> diff --git a/drivers/net/ethernet/amd/pcnet32.c
> b/drivers/net/ethernet/amd/pcnet32.c
> index 70d76fdb9f56..e5708b312133 100644
> --- a/drivers/net/ethernet/amd/pcnet32.c
> +++ b/drivers/net/ethernet/amd/pcnet32.c
> @@ -860,7 +860,9 @@ static int pcnet32_nway_reset(struct net_device *dev)
>  }
>=20
>  static void pcnet32_get_ringparam(struct net_device *dev,
> -                                 struct ethtool_ringparam *ering)
> +                                 struct ethtool_ringparam *ering,
> +                                 struct ethtool_ringparam_ext
> *ering_ext,
> +                                 struct netlink_ext_ack *extack)
>  {
>         struct pcnet32_private *lp =3D netdev_priv(dev);
>=20
> @@ -871,7 +873,9 @@ static void pcnet32_get_ringparam(struct net_device
> *dev,
>  }
>=20
>  static int pcnet32_set_ringparam(struct net_device *dev,
> -                                struct ethtool_ringparam *ering)
> +                                struct ethtool_ringparam *ering,
> +                                struct ethtool_ringparam_ext *ering_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct pcnet32_private *lp =3D netdev_priv(dev);
>         unsigned long flags;
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> index bafc51c34e0b..08a52594cda0 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> @@ -622,7 +622,9 @@ static int xgbe_get_module_eeprom(struct net_device
> *netdev,
>  }
>=20
>  static void xgbe_get_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ringparam)
> +                              struct ethtool_ringparam *ringparam,
> +                              struct ethtool_ringparam_ext
> *ringparam_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct xgbe_prv_data *pdata =3D netdev_priv(netdev);
>=20
> @@ -633,7 +635,9 @@ static void xgbe_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int xgbe_set_ringparam(struct net_device *netdev,
> -                             struct ethtool_ringparam *ringparam)
> +                             struct ethtool_ringparam *ringparam,
> +                             struct ethtool_ringparam_ext
> *ringparam_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct xgbe_prv_data *pdata =3D netdev_priv(netdev);
>         unsigned int rx, tx;
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
> b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
> index a9ef0544e30f..6aacc0fe34fc 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
> @@ -812,7 +812,9 @@ static int aq_ethtool_set_pauseparam(struct
> net_device *ndev,
>  }
>=20
>  static void aq_get_ringparam(struct net_device *ndev,
> -                            struct ethtool_ringparam *ring)
> +                            struct ethtool_ringparam *ring,
> +                            struct ethtool_ringparam_ext *ring_ext,
> +                            struct netlink_ext_ack *extack)
>  {
>         struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
>         struct aq_nic_cfg_s *cfg;
> @@ -827,7 +829,9 @@ static void aq_get_ringparam(struct net_device *ndev,
>  }
>=20
>  static int aq_set_ringparam(struct net_device *ndev,
> -                           struct ethtool_ringparam *ring)
> +                           struct ethtool_ringparam *ring,
> +                           struct ethtool_ringparam_ext *ring_ext,
> +                           struct netlink_ext_ack *extack)
>  {
>         struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
>         const struct aq_hw_caps_s *hw_caps;
> diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c
> b/drivers/net/ethernet/atheros/atlx/atl1.c
> index 68f6c0bbd945..92ac2eba0b36 100644
> --- a/drivers/net/ethernet/atheros/atlx/atl1.c
> +++ b/drivers/net/ethernet/atheros/atlx/atl1.c
> @@ -3438,7 +3438,9 @@ static void atl1_get_regs(struct net_device
> *netdev, struct ethtool_regs *regs,
>  }
>=20
>  static void atl1_get_ringparam(struct net_device *netdev,
> -       struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct atl1_adapter *adapter =3D netdev_priv(netdev);
>         struct atl1_tpd_ring *txdr =3D &adapter->tpd_ring;
> @@ -3451,7 +3453,9 @@ static void atl1_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int atl1_set_ringparam(struct net_device *netdev,
> -       struct ethtool_ringparam *ring)
> +                             struct ethtool_ringparam *ring,
> +                             struct ethtool_ringparam_ext *ring_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct atl1_adapter *adapter =3D netdev_priv(netdev);
>         struct atl1_tpd_ring *tpdr =3D &adapter->tpd_ring;
> diff --git a/drivers/net/ethernet/broadcom/b44.c
> b/drivers/net/ethernet/broadcom/b44.c
> index fa784953c601..10fd625285f2 100644
> --- a/drivers/net/ethernet/broadcom/b44.c
> +++ b/drivers/net/ethernet/broadcom/b44.c
> @@ -1959,7 +1959,9 @@ static int b44_set_link_ksettings(struct
> net_device *dev,
>  }
>=20
>  static void b44_get_ringparam(struct net_device *dev,
> -                             struct ethtool_ringparam *ering)
> +                             struct ethtool_ringparam *ering,
> +                             struct ethtool_ringparam_ext *ering_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct b44 *bp =3D netdev_priv(dev);
>=20
> @@ -1970,7 +1972,9 @@ static void b44_get_ringparam(struct net_device
> *dev,
>  }
>=20
>  static int b44_set_ringparam(struct net_device *dev,
> -                            struct ethtool_ringparam *ering)
> +                            struct ethtool_ringparam *ering,
> +                            struct ethtool_ringparam_ext *ering_ext,
> +                            struct netlink_ext_ack *extack)
>  {
>         struct b44 *bp =3D netdev_priv(dev);
>=20
> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> index d56886300ecf..33c7c612c84f 100644
> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> @@ -1498,7 +1498,9 @@ static int bcm_enet_set_link_ksettings(struct
> net_device *dev,
>  }
>=20
>  static void bcm_enet_get_ringparam(struct net_device *dev,
> -                                  struct ethtool_ringparam *ering)
> +                                  struct ethtool_ringparam *ering,
> +                                  struct ethtool_ringparam_ext
> *ering_ext,
> +                                  struct netlink_ext_ack *extack)
>  {
>         struct bcm_enet_priv *priv;
>=20
> @@ -1512,7 +1514,9 @@ static void bcm_enet_get_ringparam(struct
> net_device *dev,
>  }
>=20
>  static int bcm_enet_set_ringparam(struct net_device *dev,
> -                                 struct ethtool_ringparam *ering)
> +                                 struct ethtool_ringparam *ering,
> +                                 struct ethtool_ringparam_ext
> *ering_ext,
> +                                 struct netlink_ext_ack *extack)
>  {
>         struct bcm_enet_priv *priv;
>         int was_running;
> @@ -2580,7 +2584,9 @@ static void bcm_enetsw_get_ethtool_stats(struct
> net_device *netdev,
>  }
>=20
>  static void bcm_enetsw_get_ringparam(struct net_device *dev,
> -                                    struct ethtool_ringparam *ering)
> +                                    struct ethtool_ringparam *ering,
> +                                    struct ethtool_ringparam_ext
> *ering_ext,
> +                                    struct netlink_ext_ack *extack)
>  {
>         struct bcm_enet_priv *priv;
>=20
> @@ -2596,7 +2602,9 @@ static void bcm_enetsw_get_ringparam(struct
> net_device *dev,
>  }
>=20
>  static int bcm_enetsw_set_ringparam(struct net_device *dev,
> -                                   struct ethtool_ringparam *ering)
> +                                   struct ethtool_ringparam *ering,
> +                                   struct ethtool_ringparam_ext
> *ering_ext,
> +                                   struct netlink_ext_ack *extack)
>  {
>         struct bcm_enet_priv *priv;
>         int was_running;
> diff --git a/drivers/net/ethernet/broadcom/bnx2.c
> b/drivers/net/ethernet/broadcom/bnx2.c
> index 8c83973adca5..a197736e806b 100644
> --- a/drivers/net/ethernet/broadcom/bnx2.c
> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -7318,7 +7318,9 @@ static int bnx2_set_coalesce(struct net_device
> *dev,
>  }
>=20
>  static void
> -bnx2_get_ringparam(struct net_device *dev, struct ethtool_ringparam
> *ering)
> +bnx2_get_ringparam(struct net_device *dev, struct ethtool_ringparam
> *ering,
> +                  struct ethtool_ringparam_ext *ering_ext,
> +                  struct netlink_ext_ack *extack)
>  {
>         struct bnx2 *bp =3D netdev_priv(dev);
>=20
> @@ -7389,7 +7391,9 @@ bnx2_change_ring_size(struct bnx2 *bp, u32 rx, u32
> tx, bool reset_irq)
>  }
>=20
>  static int
> -bnx2_set_ringparam(struct net_device *dev, struct ethtool_ringparam
> *ering)
> +bnx2_set_ringparam(struct net_device *dev, struct ethtool_ringparam
> *ering,
> +                  struct ethtool_ringparam_ext *ering_ext,
> +                  struct netlink_ext_ack *extack)
>  {
>         struct bnx2 *bp =3D netdev_priv(dev);
>         int rc;
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
> index 472a3a478038..f3c72597cf1e 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
> @@ -1914,7 +1914,9 @@ static int bnx2x_set_coalesce(struct net_device
> *dev,
>  }
>=20
>  static void bnx2x_get_ringparam(struct net_device *dev,
> -                               struct ethtool_ringparam *ering)
> +                               struct ethtool_ringparam *ering,
> +                               struct ethtool_ringparam_ext *ering_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct bnx2x *bp =3D netdev_priv(dev);
>=20
> @@ -1938,7 +1940,9 @@ static void bnx2x_get_ringparam(struct net_device
> *dev,
>  }
>=20
>  static int bnx2x_set_ringparam(struct net_device *dev,
> -                              struct ethtool_ringparam *ering)
> +                              struct ethtool_ringparam *ering,
> +                              struct ethtool_ringparam_ext *ering_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct bnx2x *bp =3D netdev_priv(dev);
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index 7260910e75fb..de35b51105dc 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -773,7 +773,9 @@ static void bnxt_get_strings(struct net_device *dev,
> u32 stringset, u8 *buf)
>  }
>=20
>  static void bnxt_get_ringparam(struct net_device *dev,
> -                              struct ethtool_ringparam *ering)
> +                              struct ethtool_ringparam *ering,
> +                              struct ethtool_ringparam_ext *ering_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct bnxt *bp =3D netdev_priv(dev);
>=20
> @@ -792,7 +794,9 @@ static void bnxt_get_ringparam(struct net_device
> *dev,
>  }
>=20
>  static int bnxt_set_ringparam(struct net_device *dev,
> -                             struct ethtool_ringparam *ering)
> +                             struct ethtool_ringparam *ering,
> +                             struct ethtool_ringparam_ext *ering_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct bnxt *bp =3D netdev_priv(dev);
>=20
> diff --git a/drivers/net/ethernet/broadcom/tg3.c
> b/drivers/net/ethernet/broadcom/tg3.c
> index 5e0e0e70d801..97604ccf6a6f 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -12396,7 +12396,10 @@ static int tg3_nway_reset(struct net_device
> *dev)
>         return r;
>  }
>=20
> -static void tg3_get_ringparam(struct net_device *dev, struct
> ethtool_ringparam *ering)
> +static void tg3_get_ringparam(struct net_device *dev,
> +                             struct ethtool_ringparam *ering,
> +                             struct ethtool_ringparam_ext *ering_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct tg3 *tp =3D netdev_priv(dev);
>=20
> @@ -12417,7 +12420,10 @@ static void tg3_get_ringparam(struct net_device
> *dev, struct ethtool_ringparam *
>         ering->tx_pending =3D tp->napi[0].tx_pending;
>  }
>=20
> -static int tg3_set_ringparam(struct net_device *dev, struct
> ethtool_ringparam *ering)
> +static int tg3_set_ringparam(struct net_device *dev,
> +                            struct ethtool_ringparam *ering,
> +                            struct ethtool_ringparam_ext *ering_ext,
> +                            struct netlink_ext_ack *extack)
>  {
>         struct tg3 *tp =3D netdev_priv(dev);
>         int i, irq_sync =3D 0, err =3D 0;
> diff --git a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
> b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
> index 391b85f25141..8eba325c9764 100644
> --- a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
> +++ b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
> @@ -405,7 +405,9 @@ static int bnad_set_coalesce(struct net_device
> *netdev,
>=20
>  static void
>  bnad_get_ringparam(struct net_device *netdev,
> -                  struct ethtool_ringparam *ringparam)
> +                  struct ethtool_ringparam *ringparam,
> +                  struct ethtool_ringparam_ext *ering_ext,
> +                  struct netlink_ext_ack *extack)
>  {
>         struct bnad *bnad =3D netdev_priv(netdev);
>=20
> @@ -418,7 +420,9 @@ bnad_get_ringparam(struct net_device *netdev,
>=20
>  static int
>  bnad_set_ringparam(struct net_device *netdev,
> -                  struct ethtool_ringparam *ringparam)
> +                  struct ethtool_ringparam *ringparam,
> +                  struct ethtool_ringparam_ext *ering_ext,
> +                  struct netlink_ext_ack *extack)
>  {
>         int i, current_err, err =3D 0;
>         struct bnad *bnad =3D netdev_priv(netdev);
> diff --git a/drivers/net/ethernet/cadence/macb_main.c
> b/drivers/net/ethernet/cadence/macb_main.c
> index e2730b3e1a57..5277ee50f597 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -3096,7 +3096,9 @@ static int macb_set_link_ksettings(struct
> net_device *netdev,
>  }
>=20
>  static void macb_get_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct macb *bp =3D netdev_priv(netdev);
>=20
> @@ -3108,7 +3110,9 @@ static void macb_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int macb_set_ringparam(struct net_device *netdev,
> -                             struct ethtool_ringparam *ring)
> +                             struct ethtool_ringparam *ring,
> +                             struct ethtool_ringparam_ext *ring_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct macb *bp =3D netdev_priv(netdev);
>         u32 new_rx_size, new_tx_size;
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
> b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
> index 2b9747867d4c..303c0472c93a 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
> @@ -947,7 +947,9 @@ static int lio_set_phys_id(struct net_device *netdev,
>=20
>  static void
>  lio_ethtool_get_ringparam(struct net_device *netdev,
> -                         struct ethtool_ringparam *ering)
> +                         struct ethtool_ringparam *ering,
> +                         struct ethtool_ringparam_ext *ering_ext,
> +                         struct netlink_ext_ack *extack)
>  {
>         struct lio *lio =3D GET_LIO(netdev);
>         struct octeon_device *oct =3D lio->oct_dev;
> @@ -1253,7 +1255,9 @@ static int lio_reset_queues(struct net_device
> *netdev, uint32_t num_qs)
>  }
>=20
>  static int lio_ethtool_set_ringparam(struct net_device *netdev,
> -                                    struct ethtool_ringparam *ering)
> +                                    struct ethtool_ringparam *ering,
> +                                    struct ethtool_ringparam_ext
> *ering_ext,
> +                                    struct netlink_ext_ack *extack)
>  {
>         u32 rx_count, tx_count, rx_count_old, tx_count_old;
>         struct lio *lio =3D GET_LIO(netdev);
> diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
> b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
> index 7f2882109b16..01aaa5a77c4b 100644
> --- a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
> +++ b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
> @@ -467,7 +467,9 @@ static int nicvf_get_coalesce(struct net_device
> *netdev,
>  }
>=20
>  static void nicvf_get_ringparam(struct net_device *netdev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct nicvf *nic =3D netdev_priv(netdev);
>         struct queue_set *qs =3D nic->qs;
> @@ -479,7 +481,9 @@ static void nicvf_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int nicvf_set_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct nicvf *nic =3D netdev_priv(netdev);
>         struct queue_set *qs =3D nic->qs;
> diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
> b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
> index d246eee4b6d5..8e72a7f95401 100644
> --- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
> +++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
> @@ -710,7 +710,9 @@ static int set_pauseparam(struct net_device *dev,
>         return 0;
>  }
>=20
> -static void get_sge_param(struct net_device *dev, struct
> ethtool_ringparam *e)
> +static void get_sge_param(struct net_device *dev, struct
> ethtool_ringparam *e,
> +                         struct ethtool_ringparam_ext *e_ext,
> +                         struct netlink_ext_ack *extack)
>  {
>         struct adapter *adapter =3D dev->ml_priv;
>         int jumbo_fl =3D t1_is_T1B(adapter) ? 1 : 0;
> @@ -724,7 +726,9 @@ static void get_sge_param(struct net_device *dev,
> struct ethtool_ringparam *e)
>         e->tx_pending =3D adapter->params.sge.cmdQ_size[0];
>  }
>=20
> -static int set_sge_param(struct net_device *dev, struct
> ethtool_ringparam *e)
> +static int set_sge_param(struct net_device *dev, struct
> ethtool_ringparam *e,
> +                        struct ethtool_ringparam_ext *e_ext,
> +                        struct netlink_ext_ack *extack)
>  {
>         struct adapter *adapter =3D dev->ml_priv;
>         int jumbo_fl =3D t1_is_T1B(adapter) ? 1 : 0;
> diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
> b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
> index 38e47703f9ab..5d40e19579e6 100644
> --- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
> +++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
> @@ -1948,7 +1948,9 @@ static int set_pauseparam(struct net_device *dev,
>         return 0;
>  }
>=20
> -static void get_sge_param(struct net_device *dev, struct
> ethtool_ringparam *e)
> +static void get_sge_param(struct net_device *dev, struct
> ethtool_ringparam *e,
> +                         struct ethtool_ringparam_ext *e_ext,
> +                         struct netlink_ext_ack *extack)
>  {
>         struct port_info *pi =3D netdev_priv(dev);
>         struct adapter *adapter =3D pi->adapter;
> @@ -1964,7 +1966,9 @@ static void get_sge_param(struct net_device *dev,
> struct ethtool_ringparam *e)
>         e->tx_pending =3D q->txq_size[0];
>  }
>=20
> -static int set_sge_param(struct net_device *dev, struct
> ethtool_ringparam *e)
> +static int set_sge_param(struct net_device *dev, struct
> ethtool_ringparam *e,
> +                        struct ethtool_ringparam_ext *e_ext,
> +                        struct netlink_ext_ack *extack)
>  {
>         struct port_info *pi =3D netdev_priv(dev);
>         struct adapter *adapter =3D pi->adapter;
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> index 5903bdb78916..675a27b167a0 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> @@ -890,7 +890,9 @@ static int set_pauseparam(struct net_device *dev,
>         return 0;
>  }
>=20
> -static void get_sge_param(struct net_device *dev, struct
> ethtool_ringparam *e)
> +static void get_sge_param(struct net_device *dev, struct
> ethtool_ringparam *e,
> +                         struct ethtool_ringparam_ext *e_ext,
> +                         struct netlink_ext_ack *extack)
>  {
>         const struct port_info *pi =3D netdev_priv(dev);
>         const struct sge *s =3D &pi->adapter->sge;
> @@ -906,7 +908,9 @@ static void get_sge_param(struct net_device *dev,
> struct ethtool_ringparam *e)
>         e->tx_pending =3D s->ethtxq[pi->first_qset].q.size;
>  }
>=20
> -static int set_sge_param(struct net_device *dev, struct
> ethtool_ringparam *e)
> +static int set_sge_param(struct net_device *dev, struct
> ethtool_ringparam *e,
> +                        struct ethtool_ringparam_ext *e_ext,
> +                        struct netlink_ext_ack *extack)
>  {
>         int i;
>         const struct port_info *pi =3D netdev_priv(dev);
> diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
> b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
> index 4920a80a0460..ade808daf16b 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
> @@ -1591,7 +1591,9 @@ static void cxgb4vf_set_msglevel(struct net_device
> *dev, u32 msglevel)
>   * first Queue Set.
>   */
>  static void cxgb4vf_get_ringparam(struct net_device *dev,
> -                                 struct ethtool_ringparam *rp)
> +                                 struct ethtool_ringparam *rp,
> +                                 struct ethtool_ringparam_ext *rp_ext,
> +                                 struct netlink_ext_ack *extack)
>  {
>         const struct port_info *pi =3D netdev_priv(dev);
>         const struct sge *s =3D &pi->adapter->sge;
> @@ -1614,7 +1616,9 @@ static void cxgb4vf_get_ringparam(struct
> net_device *dev,
>   * device -- after vetting them of course!
>   */
>  static int cxgb4vf_set_ringparam(struct net_device *dev,
> -                                struct ethtool_ringparam *rp)
> +                                struct ethtool_ringparam *rp,
> +                                struct ethtool_ringparam_ext *rp_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         const struct port_info *pi =3D netdev_priv(dev);
>         struct adapter *adapter =3D pi->adapter;
> diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
> b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
> index 12ffc14fbecd..89857c03375d 100644
> --- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
> +++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
> @@ -177,7 +177,9 @@ static void enic_get_strings(struct net_device
> *netdev, u32 stringset,
>  }
>=20
>  static void enic_get_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct enic *enic =3D netdev_priv(netdev);
>         struct vnic_enet_config *c =3D &enic->config;
> @@ -189,7 +191,9 @@ static void enic_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int enic_set_ringparam(struct net_device *netdev,
> -                             struct ethtool_ringparam *ring)
> +                             struct ethtool_ringparam *ring,
> +                             struct ethtool_ringparam_ext *ring_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct enic *enic =3D netdev_priv(netdev);
>         struct vnic_enet_config *c =3D &enic->config;
> diff --git a/drivers/net/ethernet/cortina/gemini.c
> b/drivers/net/ethernet/cortina/gemini.c
> index 6e745ca4c433..a8b9bcc50e02 100644
> --- a/drivers/net/ethernet/cortina/gemini.c
> +++ b/drivers/net/ethernet/cortina/gemini.c
> @@ -2105,7 +2105,9 @@ static void gmac_get_pauseparam(struct net_device
> *netdev,
>  }
>=20
>  static void gmac_get_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *rp)
> +                              struct ethtool_ringparam *rp,
> +                              struct ethtool_ringparam_ext *rp_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct gemini_ethernet_port *port =3D netdev_priv(netdev);
>=20
> @@ -2123,7 +2125,9 @@ static void gmac_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int gmac_set_ringparam(struct net_device *netdev,
> -                             struct ethtool_ringparam *rp)
> +                             struct ethtool_ringparam *rp,
> +                             struct ethtool_ringparam_ext *rp_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct gemini_ethernet_port *port =3D netdev_priv(netdev);
>         int err =3D 0;
> diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c
> b/drivers/net/ethernet/emulex/benet/be_ethtool.c
> index f9955308b93d..db1c8eef6091 100644
> --- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
> +++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
> @@ -683,7 +683,9 @@ static int be_get_link_ksettings(struct net_device
> *netdev,
>  }
>=20
>  static void be_get_ringparam(struct net_device *netdev,
> -                            struct ethtool_ringparam *ring)
> +                            struct ethtool_ringparam *ring,
> +                            struct ethtool_ringparam_ext *ring_ext,
> +                            struct netlink_ext_ack *extack)
>  {
>         struct be_adapter *adapter =3D netdev_priv(netdev);
>=20
> diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
> index 0064ebdaf4b4..efec86e49887 100644
> --- a/drivers/net/ethernet/ethoc.c
> +++ b/drivers/net/ethernet/ethoc.c
> @@ -945,7 +945,9 @@ static void ethoc_get_regs(struct net_device *dev,
> struct ethtool_regs *regs,
>  }
>=20
>  static void ethoc_get_ringparam(struct net_device *dev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct ethoc *priv =3D netdev_priv(dev);
>=20
> @@ -961,7 +963,9 @@ static void ethoc_get_ringparam(struct net_device
> *dev,
>  }
>=20
>  static int ethoc_set_ringparam(struct net_device *dev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct ethoc *priv =3D netdev_priv(dev);
>=20
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
> b/drivers/net/ethernet/faraday/ftgmac100.c
> index ff76e401a014..832da04ed257 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1182,7 +1182,9 @@ static void ftgmac100_get_drvinfo(struct
> net_device *netdev,
>  }
>=20
>  static void ftgmac100_get_ringparam(struct net_device *netdev,
> -                                   struct ethtool_ringparam *ering)
> +                                   struct ethtool_ringparam *ering,
> +                                   struct ethtool_ringparam_ext
> *ering_ext,
> +                                   struct netlink_ext_ack *extack)
>  {
>         struct ftgmac100 *priv =3D netdev_priv(netdev);
>=20
> @@ -1194,7 +1196,9 @@ static void ftgmac100_get_ringparam(struct
> net_device *netdev,
>  }
>=20
>  static int ftgmac100_set_ringparam(struct net_device *netdev,
> -                                  struct ethtool_ringparam *ering)
> +                                  struct ethtool_ringparam *ering,
> +                                  struct ethtool_ringparam_ext
> *ering_ext,
> +                                  struct netlink_ext_ack *extack)
>  {
>         struct ftgmac100 *priv =3D netdev_priv(netdev);
>=20
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> index 9690e36e9e85..1302d1ab1a17 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> @@ -562,7 +562,9 @@ static int enetc_set_rxfh(struct net_device *ndev,
> const u32 *indir,
>  }
>=20
>  static void enetc_get_ringparam(struct net_device *ndev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
>=20
> diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c
> b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> index 7b32ed29bf4c..0eec50eae4b0 100644
> --- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
> +++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> @@ -372,7 +372,9 @@ static int gfar_scoalesce(struct net_device *dev,
>   * rx, rx_mini, and rx_jumbo rings are the same size, as mini and
>   * jumbo are ignored by the driver */
>  static void gfar_gringparam(struct net_device *dev,
> -                           struct ethtool_ringparam *rvals)
> +                           struct ethtool_ringparam *rvals,
> +                           struct ethtool_ringparam_ext *rvals_ext,
> +                           struct netlink_ext_ack *extack)
>  {
>         struct gfar_private *priv =3D netdev_priv(dev);
>         struct gfar_priv_tx_q *tx_queue =3D NULL;
> @@ -399,7 +401,9 @@ static void gfar_gringparam(struct net_device *dev,
>   * necessary so that we don't mess things up while we're in motion.
>   */
>  static int gfar_sringparam(struct net_device *dev,
> -                          struct ethtool_ringparam *rvals)
> +                          struct ethtool_ringparam *rvals,
> +                          struct ethtool_ringparam_ext *rvals_ext,
> +                          struct netlink_ext_ack *extack)
>  {
>         struct gfar_private *priv =3D netdev_priv(dev);
>         int err =3D 0, i;
> diff --git a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
> b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
> index 14c08a868190..985f9cdb7e8a 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
> +++ b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
> @@ -207,7 +207,9 @@ uec_get_regs(struct net_device *netdev,
>=20
>  static void
>  uec_get_ringparam(struct net_device *netdev,
> -                    struct ethtool_ringparam *ring)
> +                 struct ethtool_ringparam *ring,
> +                 struct ethtool_ringparam_ext *ring_ext,
> +                 struct netlink_ext_ack *extack)
>  {
>         struct ucc_geth_private *ugeth =3D netdev_priv(netdev);
>         struct ucc_geth_info *ug_info =3D ugeth->ug_info;
> @@ -226,7 +228,9 @@ uec_get_ringparam(struct net_device *netdev,
>=20
>  static int
>  uec_set_ringparam(struct net_device *netdev,
> -                    struct ethtool_ringparam *ring)
> +                 struct ethtool_ringparam *ring,
> +                 struct ethtool_ringparam_ext *ring_ext,
> +                 struct netlink_ext_ack *extack)
>  {
>         struct ucc_geth_private *ugeth =3D netdev_priv(netdev);
>         struct ucc_geth_info *ug_info =3D ugeth->ug_info;
> diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c
> b/drivers/net/ethernet/google/gve/gve_ethtool.c
> index 716e6240305d..70b92022e46c 100644
> --- a/drivers/net/ethernet/google/gve/gve_ethtool.c
> +++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
> @@ -416,7 +416,9 @@ static int gve_set_channels(struct net_device
> *netdev,
>  }
>=20
>  static void gve_get_ringparam(struct net_device *netdev,
> -                             struct ethtool_ringparam *cmd)
> +                             struct ethtool_ringparam *cmd,
> +                             struct ethtool_ringparam_ext *ering_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct gve_priv *priv =3D netdev_priv(netdev);
>=20
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
> b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
> index ab7390225942..a2abd0f64e1a 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
> @@ -663,9 +663,13 @@ static void hns_nic_get_drvinfo(struct net_device
> *net_dev,
>   * hns_get_ringparam - get ring parameter
>   * @net_dev: net device
>   * @param: ethtool parameter
> + * @param_ext: ethtool external parameter
> + * @extack: netlink netlink extended ACK report struct
>   */
>  static void hns_get_ringparam(struct net_device *net_dev,
> -                             struct ethtool_ringparam *param)
> +                             struct ethtool_ringparam *param,
> +                             struct ethtool_ringparam_ext *param_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct hns_nic_priv *priv =3D netdev_priv(net_dev);
>         struct hnae_ae_ops *ops;
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> index c757e067f31f..ed50b3b7b9e8 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> @@ -639,7 +639,9 @@ static u32 hns3_get_link(struct net_device *netdev)
>  }
>=20
>  static void hns3_get_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *param)
> +                              struct ethtool_ringparam *param,
> +                              struct ethtool_ringparam_ext *param_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct hns3_nic_priv *priv =3D netdev_priv(netdev);
>         struct hnae3_handle *h =3D priv->ae_handle;
> @@ -1077,7 +1079,9 @@ static int hns3_check_ringparam(struct net_device
> *ndev,
>  }
>=20
>  static int hns3_set_ringparam(struct net_device *ndev,
> -                             struct ethtool_ringparam *param)
> +                             struct ethtool_ringparam *param,
> +                             struct ethtool_ringparam_ext *param_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct hns3_nic_priv *priv =3D netdev_priv(ndev);
>         struct hnae3_handle *h =3D priv->ae_handle;
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
> b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
> index b431c300ef1b..7a79bfb9e0ff 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
> @@ -549,7 +549,9 @@ static void hinic_get_drvinfo(struct net_device
> *netdev,
>  }
>=20
>  static void hinic_get_ringparam(struct net_device *netdev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct hinic_dev *nic_dev =3D netdev_priv(netdev);
>=20
> @@ -582,7 +584,9 @@ static int check_ringparam_valid(struct hinic_dev
> *nic_dev,
>  }
>=20
>  static int hinic_set_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct hinic_dev *nic_dev =3D netdev_priv(netdev);
>         u16 new_sq_depth, new_rq_depth;
> diff --git a/drivers/net/ethernet/ibm/emac/core.c
> b/drivers/net/ethernet/ibm/emac/core.c
> index 664a91af662d..134fa6c265ca 100644
> --- a/drivers/net/ethernet/ibm/emac/core.c
> +++ b/drivers/net/ethernet/ibm/emac/core.c
> @@ -2138,7 +2138,9 @@ emac_ethtool_set_link_ksettings(struct net_device
> *ndev,
>  }
>=20
>  static void emac_ethtool_get_ringparam(struct net_device *ndev,
> -                                      struct ethtool_ringparam *rp)
> +                                      struct ethtool_ringparam *rp,
> +                                      struct ethtool_ringparam_ext
> *rp_ext,
> +                                      struct netlink_ext_ack *extack)
>  {
>         rp->rx_max_pending =3D rp->rx_pending =3D NUM_RX_BUFF;
>         rp->tx_max_pending =3D rp->tx_pending =3D NUM_TX_BUFF;
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 8f17096e614d..fce169457828 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -3090,7 +3090,9 @@ static u32 ibmvnic_get_link(struct net_device
> *netdev)
>  }
>=20
>  static void ibmvnic_get_ringparam(struct net_device *netdev,
> -                                 struct ethtool_ringparam *ring)
> +                                 struct ethtool_ringparam *ring,
> +                                 struct ethtool_ringparam_ext *ring_ext,
> +                                 struct netlink_ext_ack *extack)
>  {
>         struct ibmvnic_adapter *adapter =3D netdev_priv(netdev);
>=20
> @@ -3110,7 +3112,9 @@ static void ibmvnic_get_ringparam(struct
> net_device *netdev,
>  }
>=20
>  static int ibmvnic_set_ringparam(struct net_device *netdev,
> -                                struct ethtool_ringparam *ring)
> +                                struct ethtool_ringparam *ring,
> +                                struct ethtool_ringparam_ext *ring_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct ibmvnic_adapter *adapter =3D netdev_priv(netdev);
>         int ret;
> diff --git a/drivers/net/ethernet/intel/e100.c
> b/drivers/net/ethernet/intel/e100.c
> index 373eb027b925..a103a3eaf74b 100644
> --- a/drivers/net/ethernet/intel/e100.c
> +++ b/drivers/net/ethernet/intel/e100.c
> @@ -2549,7 +2549,9 @@ static int e100_set_eeprom(struct net_device
> *netdev,
>  }
>=20
>  static void e100_get_ringparam(struct net_device *netdev,
> -       struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct nic *nic =3D netdev_priv(netdev);
>         struct param_range *rfds =3D &nic->params.rfds;
> @@ -2562,7 +2564,9 @@ static void e100_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int e100_set_ringparam(struct net_device *netdev,
> -       struct ethtool_ringparam *ring)
> +                             struct ethtool_ringparam *ring,
> +                             struct ethtool_ringparam_ext *ring_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct nic *nic =3D netdev_priv(netdev);
>         struct param_range *rfds =3D &nic->params.rfds;
> diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
> b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
> index 0a57172dfcbc..a96f4eb74a84 100644
> --- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
> +++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
> @@ -539,7 +539,9 @@ static void e1000_get_drvinfo(struct net_device
> *netdev,
>  }
>=20
>  static void e1000_get_ringparam(struct net_device *netdev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct e1000_adapter *adapter =3D netdev_priv(netdev);
>         struct e1000_hw *hw =3D &adapter->hw;
> @@ -556,7 +558,9 @@ static void e1000_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int e1000_set_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct e1000_adapter *adapter =3D netdev_priv(netdev);
>         struct e1000_hw *hw =3D &adapter->hw;
> diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c
> b/drivers/net/ethernet/intel/e1000e/ethtool.c
> index 8515e00d1b40..0fa5962639e1 100644
> --- a/drivers/net/ethernet/intel/e1000e/ethtool.c
> +++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
> @@ -655,7 +655,9 @@ static void e1000_get_drvinfo(struct net_device
> *netdev,
>  }
>=20
>  static void e1000_get_ringparam(struct net_device *netdev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct e1000_adapter *adapter =3D netdev_priv(netdev);
>=20
> @@ -666,7 +668,9 @@ static void e1000_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int e1000_set_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct e1000_adapter *adapter =3D netdev_priv(netdev);
>         struct e1000_ring *temp_tx =3D NULL, *temp_rx =3D NULL;
> diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
> b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
> index 0d37f011d0ce..1ae89e58de3d 100644
> --- a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
> +++ b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
> @@ -502,7 +502,9 @@ static void fm10k_set_msglevel(struct net_device
> *netdev, u32 data)
>  }
>=20
>  static void fm10k_get_ringparam(struct net_device *netdev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct fm10k_intfc *interface =3D netdev_priv(netdev);
>=20
> @@ -517,7 +519,9 @@ static void fm10k_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int fm10k_set_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct fm10k_intfc *interface =3D netdev_priv(netdev);
>         struct fm10k_ring *temp_ring;
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> index 513ba6974355..ca3a1e6b07e5 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> @@ -1916,7 +1916,9 @@ static void i40e_get_drvinfo(struct net_device
> *netdev,
>  }
>=20
>  static void i40e_get_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct i40e_netdev_priv *np =3D netdev_priv(netdev);
>         struct i40e_pf *pf =3D np->vsi->back;
> @@ -1944,7 +1946,9 @@ static bool i40e_active_tx_ring_index(struct
> i40e_vsi *vsi, u16 index)
>  }
>=20
>  static int i40e_set_ringparam(struct net_device *netdev,
> -                             struct ethtool_ringparam *ring)
> +                             struct ethtool_ringparam *ring,
> +                             struct ethtool_ringparam_ext *ring_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct i40e_ring *tx_rings =3D NULL, *rx_rings =3D NULL;
>         struct i40e_netdev_priv *np =3D netdev_priv(netdev);
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> index 5a359a0a20ec..f576324d025b 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> @@ -580,12 +580,16 @@ static void iavf_get_drvinfo(struct net_device
> *netdev,
>   * iavf_get_ringparam - Get ring parameters
>   * @netdev: network interface device structure
>   * @ring: ethtool ringparam structure
> + * @ring_ext: ethtool extenal ringparam structure
> + * @extack: netlink netlink extended ACK report struct
>   *
>   * Returns current ring parameters. TX and RX rings are reported
> separately,
>   * but the number of rings is not reported.
>   **/
>  static void iavf_get_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct iavf_adapter *adapter =3D netdev_priv(netdev);
>=20
> @@ -599,12 +603,16 @@ static void iavf_get_ringparam(struct net_device
> *netdev,
>   * iavf_set_ringparam - Set ring parameters
>   * @netdev: network interface device structure
>   * @ring: ethtool ringparam structure
> + * @ring_ext: ethtool external ringparam structure
> + * @extack: netlink netlink extended ACK report struct
>   *
>   * Sets ring parameters. TX and RX rings are controlled separately, but
> the
>   * number of rings is not specified, so all rings get the same settings.
>   **/
>  static int iavf_set_ringparam(struct net_device *netdev,
> -                             struct ethtool_ringparam *ring)
> +                             struct ethtool_ringparam *ring,
> +                             struct ethtool_ringparam_ext *ring_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct iavf_adapter *adapter =3D netdev_priv(netdev);
>         u32 new_rx_count, new_tx_count;
> diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> index c451cf401e63..596521f2792e 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> @@ -2647,7 +2647,9 @@ ice_get_rxnfc(struct net_device *netdev, struct
> ethtool_rxnfc *cmd,
>  }
>=20
>  static void
> -ice_get_ringparam(struct net_device *netdev, struct ethtool_ringparam
> *ring)
> +ice_get_ringparam(struct net_device *netdev, struct ethtool_ringparam
> *ring,
> +                 struct ethtool_ringparam_ext *ring_ext,
> +                 struct netlink_ext_ack *extack)
>  {
>         struct ice_netdev_priv *np =3D netdev_priv(netdev);
>         struct ice_vsi *vsi =3D np->vsi;
> @@ -2665,7 +2667,9 @@ ice_get_ringparam(struct net_device *netdev,
> struct ethtool_ringparam *ring)
>  }
>=20
>  static int
> -ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam
> *ring)
> +ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam
> *ring,
> +                 struct ethtool_ringparam_ext *ring_ext,
> +                 struct netlink_ext_ack *extack)
>  {
>         struct ice_ring *tx_rings =3D NULL, *rx_rings =3D NULL;
>         struct ice_netdev_priv *np =3D netdev_priv(netdev);
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index fb1029352c3e..9cd533604ada 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -864,7 +864,9 @@ static void igb_get_drvinfo(struct net_device
> *netdev,
>  }
>=20
>  static void igb_get_ringparam(struct net_device *netdev,
> -                             struct ethtool_ringparam *ring)
> +                             struct ethtool_ringparam *ring,
> +                             struct ethtool_ringparam_ext *ring_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct igb_adapter *adapter =3D netdev_priv(netdev);
>=20
> @@ -875,7 +877,9 @@ static void igb_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int igb_set_ringparam(struct net_device *netdev,
> -                            struct ethtool_ringparam *ring)
> +                            struct ethtool_ringparam *ring,
> +                            struct ethtool_ringparam_ext *ring_ext,
> +                            struct netlink_ext_ack *extack)
>  {
>         struct igb_adapter *adapter =3D netdev_priv(netdev);
>         struct igb_ring *temp_ring;
> diff --git a/drivers/net/ethernet/intel/igbvf/ethtool.c
> b/drivers/net/ethernet/intel/igbvf/ethtool.c
> index 06e5bd646a0e..764b37c4852f 100644
> --- a/drivers/net/ethernet/intel/igbvf/ethtool.c
> +++ b/drivers/net/ethernet/intel/igbvf/ethtool.c
> @@ -175,7 +175,9 @@ static void igbvf_get_drvinfo(struct net_device
> *netdev,
>  }
>=20
>  static void igbvf_get_ringparam(struct net_device *netdev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct igbvf_adapter *adapter =3D netdev_priv(netdev);
>         struct igbvf_ring *tx_ring =3D adapter->tx_ring;
> @@ -188,7 +190,9 @@ static void igbvf_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int igbvf_set_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct igbvf_adapter *adapter =3D netdev_priv(netdev);
>         struct igbvf_ring *temp_ring;
> diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c
> b/drivers/net/ethernet/intel/igc/igc_ethtool.c
> index e0a76ac1bbbc..8f2f282a7072 100644
> --- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
> +++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
> @@ -568,7 +568,9 @@ static int igc_ethtool_set_eeprom(struct net_device
> *netdev,
>  }
>=20
>  static void igc_ethtool_get_ringparam(struct net_device *netdev,
> -                                     struct ethtool_ringparam *ring)
> +                                     struct ethtool_ringparam *ring,
> +                                     struct ethtool_ringparam_ext
> *ring_ext,
> +                                     struct netlink_ext_ack *extack)
>  {
>         struct igc_adapter *adapter =3D netdev_priv(netdev);
>=20
> @@ -579,7 +581,9 @@ static void igc_ethtool_get_ringparam(struct
> net_device *netdev,
>  }
>=20
>  static int igc_ethtool_set_ringparam(struct net_device *netdev,
> -                                    struct ethtool_ringparam *ring)
> +                                    struct ethtool_ringparam *ring,
> +                                    struct ethtool_ringparam_ext
> *ring_ext,
> +                                    struct netlink_ext_ack *extack)
>  {
>         struct igc_adapter *adapter =3D netdev_priv(netdev);
>         struct igc_ring *temp_ring;
> diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
> b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
> index 582099a5ad41..0317f715e84d 100644
> --- a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
> +++ b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
> @@ -464,7 +464,9 @@ ixgb_get_drvinfo(struct net_device *netdev,
>=20
>  static void
>  ixgb_get_ringparam(struct net_device *netdev,
> -               struct ethtool_ringparam *ring)
> +                  struct ethtool_ringparam *ring,
> +                  struct ethtool_ringparam_ext *ring_ext,
> +                  struct netlink_ext_ack *extack)
>  {
>         struct ixgb_adapter *adapter =3D netdev_priv(netdev);
>         struct ixgb_desc_ring *txdr =3D &adapter->tx_ring;
> @@ -478,7 +480,9 @@ ixgb_get_ringparam(struct net_device *netdev,
>=20
>  static int
>  ixgb_set_ringparam(struct net_device *netdev,
> -               struct ethtool_ringparam *ring)
> +                  struct ethtool_ringparam *ring,
> +                  struct ethtool_ringparam_ext *ring_ext,
> +                  struct netlink_ext_ack *extack)
>  {
>         struct ixgb_adapter *adapter =3D netdev_priv(netdev);
>         struct ixgb_desc_ring *txdr =3D &adapter->tx_ring;
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> index fc26e4ddeb0d..ee7b8f04da59 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> @@ -1119,7 +1119,9 @@ static void ixgbe_get_drvinfo(struct net_device
> *netdev,
>  }
>=20
>  static void ixgbe_get_ringparam(struct net_device *netdev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct ixgbe_adapter *adapter =3D netdev_priv(netdev);
>         struct ixgbe_ring *tx_ring =3D adapter->tx_ring[0];
> @@ -1132,7 +1134,9 @@ static void ixgbe_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int ixgbe_set_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct ixgbe_adapter *adapter =3D netdev_priv(netdev);
>         struct ixgbe_ring *temp_ring;
> diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
> b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
> index 8380f905e708..0b9dd29b3cd2 100644
> --- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
> @@ -225,7 +225,9 @@ static void ixgbevf_get_drvinfo(struct net_device
> *netdev,
>  }
>=20
>  static void ixgbevf_get_ringparam(struct net_device *netdev,
> -                                 struct ethtool_ringparam *ring)
> +                                 struct ethtool_ringparam *ring,
> +                                 struct ethtool_ringparam_ext *ring_ext,
> +                                 struct netlink_ext_ack *extack)
>  {
>         struct ixgbevf_adapter *adapter =3D netdev_priv(netdev);
>=20
> @@ -236,7 +238,9 @@ static void ixgbevf_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int ixgbevf_set_ringparam(struct net_device *netdev,
> -                                struct ethtool_ringparam *ring)
> +                                struct ethtool_ringparam *ring,
> +                                struct ethtool_ringparam_ext *ring_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct ixgbevf_adapter *adapter =3D netdev_priv(netdev);
>         struct ixgbevf_ring *tx_ring =3D NULL, *rx_ring =3D NULL;
> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c
> b/drivers/net/ethernet/marvell/mv643xx_eth.c
> index 28d5ad296646..811da9acb464 100644
> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> @@ -1638,7 +1638,9 @@ static int mv643xx_eth_set_coalesce(struct
> net_device *dev,
>  }
>=20
>  static void
> -mv643xx_eth_get_ringparam(struct net_device *dev, struct
> ethtool_ringparam *er)
> +mv643xx_eth_get_ringparam(struct net_device *dev, struct
> ethtool_ringparam *er,
> +                         struct ethtool_ringparam_ext *er_ext,
> +                         struct netlink_ext_ack *extack)
>  {
>         struct mv643xx_eth_private *mp =3D netdev_priv(dev);
>=20
> @@ -1650,7 +1652,9 @@ mv643xx_eth_get_ringparam(struct net_device *dev,
> struct ethtool_ringparam *er)
>  }
>=20
>  static int
> -mv643xx_eth_set_ringparam(struct net_device *dev, struct
> ethtool_ringparam *er)
> +mv643xx_eth_set_ringparam(struct net_device *dev, struct
> ethtool_ringparam *er,
> +                         struct ethtool_ringparam_ext *er_ext,
> +                         struct netlink_ext_ack *extack)
>  {
>         struct mv643xx_eth_private *mp =3D netdev_priv(dev);
>=20
> diff --git a/drivers/net/ethernet/marvell/mvneta.c
> b/drivers/net/ethernet/marvell/mvneta.c
> index 9d460a270601..12d5b23f841a 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -4556,7 +4556,9 @@ static void mvneta_ethtool_get_drvinfo(struct
> net_device *dev,
>=20
>=20
>  static void mvneta_ethtool_get_ringparam(struct net_device *netdev,
> -                                        struct ethtool_ringparam *ring)
> +                                        struct ethtool_ringparam *ring,
> +                                        struct ethtool_ringparam_ext
> *ring_ext,
> +                                        struct netlink_ext_ack *extack)
>  {
>         struct mvneta_port *pp =3D netdev_priv(netdev);
>=20
> @@ -4567,7 +4569,9 @@ static void mvneta_ethtool_get_ringparam(struct
> net_device *netdev,
>  }
>=20
>  static int mvneta_ethtool_set_ringparam(struct net_device *dev,
> -                                       struct ethtool_ringparam *ring)
> +                                       struct ethtool_ringparam *ring,
> +                                       struct ethtool_ringparam_ext
> *ring_ext,
> +                                       struct netlink_ext_ack *extack)
>  {
>         struct mvneta_port *pp =3D netdev_priv(dev);
>=20
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index d5c92e43f89e..2bbab8f204b9 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -5430,7 +5430,9 @@ static void mvpp2_ethtool_get_drvinfo(struct
> net_device *dev,
>  }
>=20
>  static void mvpp2_ethtool_get_ringparam(struct net_device *dev,
> -                                       struct ethtool_ringparam *ring)
> +                                       struct ethtool_ringparam *ring,
> +                                       struct ethtool_ringparam_ext
> *ring_ext,
> +                                       struct netlink_ext_ack *extack)
>  {
>         struct mvpp2_port *port =3D netdev_priv(dev);
>=20
> @@ -5441,7 +5443,9 @@ static void mvpp2_ethtool_get_ringparam(struct
> net_device *dev,
>  }
>=20
>  static int mvpp2_ethtool_set_ringparam(struct net_device *dev,
> -                                      struct ethtool_ringparam *ring)
> +                                      struct ethtool_ringparam *ring,
> +                                      struct ethtool_ringparam_ext
> *ring_ext,
> +                                      struct netlink_ext_ack *extack)
>  {
>         struct mvpp2_port *port =3D netdev_priv(dev);
>         u16 prev_rx_ring_size =3D port->rx_ring_size;
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> index 38e5924ca8e9..f842c3f885d5 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -360,7 +360,9 @@ static int otx2_set_pauseparam(struct net_device
> *netdev,
>  }
>=20
>  static void otx2_get_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct otx2_nic *pfvf =3D netdev_priv(netdev);
>         struct otx2_qset *qs =3D &pfvf->qset;
> @@ -372,7 +374,9 @@ static void otx2_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int otx2_set_ringparam(struct net_device *netdev,
> -                             struct ethtool_ringparam *ring)
> +                             struct ethtool_ringparam *ring,
> +                             struct ethtool_ringparam_ext *ring_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct otx2_nic *pfvf =3D netdev_priv(netdev);
>         bool if_up =3D netif_running(netdev);
> diff --git a/drivers/net/ethernet/marvell/skge.c
> b/drivers/net/ethernet/marvell/skge.c
> index 051dd3fb5b03..1700479b2f68 100644
> --- a/drivers/net/ethernet/marvell/skge.c
> +++ b/drivers/net/ethernet/marvell/skge.c
> @@ -492,7 +492,9 @@ static void skge_get_strings(struct net_device *dev,
> u32 stringset, u8 *data)
>  }
>=20
>  static void skge_get_ring_param(struct net_device *dev,
> -                               struct ethtool_ringparam *p)
> +                               struct ethtool_ringparam *p,
> +                               struct ethtool_ringparam_ext *p_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct skge_port *skge =3D netdev_priv(dev);
>=20
> @@ -504,7 +506,9 @@ static void skge_get_ring_param(struct net_device
> *dev,
>  }
>=20
>  static int skge_set_ring_param(struct net_device *dev,
> -                              struct ethtool_ringparam *p)
> +                              struct ethtool_ringparam *p,
> +                              struct ethtool_ringparam_ext *p_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct skge_port *skge =3D netdev_priv(dev);
>         int err =3D 0;
> diff --git a/drivers/net/ethernet/marvell/sky2.c
> b/drivers/net/ethernet/marvell/sky2.c
> index 3cb9c1271328..0df186119d84 100644
> --- a/drivers/net/ethernet/marvell/sky2.c
> +++ b/drivers/net/ethernet/marvell/sky2.c
> @@ -4149,7 +4149,9 @@ static unsigned long roundup_ring_size(unsigned
> long pending)
>  }
>=20
>  static void sky2_get_ringparam(struct net_device *dev,
> -                              struct ethtool_ringparam *ering)
> +                              struct ethtool_ringparam *ering,
> +                              struct ethtool_ringparam_ext *ering_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct sky2_port *sky2 =3D netdev_priv(dev);
>=20
> @@ -4161,7 +4163,9 @@ static void sky2_get_ringparam(struct net_device
> *dev,
>  }
>=20
>  static int sky2_set_ringparam(struct net_device *dev,
> -                             struct ethtool_ringparam *ering)
> +                             struct ethtool_ringparam *ering,
> +                             struct ethtool_ringparam_ext *ering_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct sky2_port *sky2 =3D netdev_priv(dev);
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> index ef518b1040f7..de543e043ddf 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> @@ -1138,7 +1138,9 @@ static void mlx4_en_get_pauseparam(struct
> net_device *dev,
>  }
>=20
>  static int mlx4_en_set_ringparam(struct net_device *dev,
> -                                struct ethtool_ringparam *param)
> +                                struct ethtool_ringparam *param,
> +                                struct ethtool_ringparam_ext *param_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct mlx4_en_priv *priv =3D netdev_priv(dev);
>         struct mlx4_en_dev *mdev =3D priv->mdev;
> @@ -1205,7 +1207,9 @@ static int mlx4_en_set_ringparam(struct net_device
> *dev,
>  }
>=20
>  static void mlx4_en_get_ringparam(struct net_device *dev,
> -                                 struct ethtool_ringparam *param)
> +                                 struct ethtool_ringparam *param,
> +                                 struct ethtool_ringparam_ext
> *param_ext,
> +                                 struct netlink_ext_ack *extack)
>  {
>         struct mlx4_en_priv *priv =3D netdev_priv(dev);
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index 306fb5d6a36d..286b090273fd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> @@ -316,7 +316,9 @@ void mlx5e_ethtool_get_ringparam(struct mlx5e_priv
> *priv,
>  }
>=20
>  static void mlx5e_get_ringparam(struct net_device *dev,
> -                               struct ethtool_ringparam *param)
> +                               struct ethtool_ringparam *param,
> +                               struct ethtool_ringparam_ext *param_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct mlx5e_priv *priv =3D netdev_priv(dev);
>=20
> @@ -382,7 +384,9 @@ int mlx5e_ethtool_set_ringparam(struct mlx5e_priv
> *priv,
>  }
>=20
>  static int mlx5e_set_ringparam(struct net_device *dev,
> -                              struct ethtool_ringparam *param)
> +                              struct ethtool_ringparam *param,
> +                              struct ethtool_ringparam_ext *param_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct mlx5e_priv *priv =3D netdev_priv(dev);
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index ae71a17fdb27..7b86e9533817 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -219,7 +219,9 @@ static int mlx5e_rep_get_sset_count(struct
> net_device *dev, int sset)
>  }
>=20
>  static void mlx5e_rep_get_ringparam(struct net_device *dev,
> -                               struct ethtool_ringparam *param)
> +                                   struct ethtool_ringparam *param,
> +                                   struct ethtool_ringparam_ext
> *param_ext,
> +                                   struct netlink_ext_ack *extack)
>  {
>         struct mlx5e_priv *priv =3D netdev_priv(dev);
>=20
> @@ -227,7 +229,9 @@ static void mlx5e_rep_get_ringparam(struct
> net_device *dev,
>  }
>=20
>  static int mlx5e_rep_set_ringparam(struct net_device *dev,
> -                              struct ethtool_ringparam *param)
> +                                  struct ethtool_ringparam *param,
> +                                  struct ethtool_ringparam_ext
> *param_ext,
> +                                  struct netlink_ext_ack *extack)
>  {
>         struct mlx5e_priv *priv =3D netdev_priv(dev);
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
> b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
> index 0c8594c7df21..86c152298e43 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
> @@ -67,7 +67,9 @@ static void mlx5i_get_ethtool_stats(struct net_device
> *dev,
>  }
>=20
>  static int mlx5i_set_ringparam(struct net_device *dev,
> -                              struct ethtool_ringparam *param)
> +                              struct ethtool_ringparam *param,
> +                              struct ethtool_ringparam_ext *param_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct mlx5e_priv *priv =3D mlx5i_epriv(dev);
>=20
> @@ -75,7 +77,9 @@ static int mlx5i_set_ringparam(struct net_device *dev,
>  }
>=20
>  static void mlx5i_get_ringparam(struct net_device *dev,
> -                               struct ethtool_ringparam *param)
> +                               struct ethtool_ringparam *param,
> +                               struct ethtool_ringparam_ext *param_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct mlx5e_priv *priv =3D mlx5i_epriv(dev);
>=20
> diff --git
> a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
> b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
> index 92b798f8e73a..3c6674ea7241 100644
> --- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
> @@ -34,7 +34,9 @@ static void mlxbf_gige_get_regs(struct net_device
> *netdev,
>  }
>=20
>  static void mlxbf_gige_get_ringparam(struct net_device *netdev,
> -                                    struct ethtool_ringparam *ering)
> +                                    struct ethtool_ringparam *ering,
> +                                    struct ethtool_ringparam_ext
> *ering_ext,
> +                                    struct netlink_ext_ack *extack)
>  {
>         struct mlxbf_gige *priv =3D netdev_priv(netdev);
>=20
> diff --git a/drivers/net/ethernet/micrel/ksz884x.c
> b/drivers/net/ethernet/micrel/ksz884x.c
> index a0ee155f9f51..f7bc31651946 100644
> --- a/drivers/net/ethernet/micrel/ksz884x.c
> +++ b/drivers/net/ethernet/micrel/ksz884x.c
> @@ -6317,11 +6317,14 @@ static int netdev_set_pauseparam(struct
> net_device *dev,
>   * netdev_get_ringparam - get tx/rx ring parameters
>   * @dev:       Network device.
>   * @ring:      Ethtool RING settings data structure.
> + * @ring_ext:  Ethtool external RING settings data structure.
>   *
>   * This procedure returns the TX/RX ring settings.
>   */
>  static void netdev_get_ringparam(struct net_device *dev,
> -       struct ethtool_ringparam *ring)
> +                                struct ethtool_ringparam *ring,
> +                                struct ethtool_ringparam_ext *ring_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct dev_priv *priv =3D netdev_priv(dev);
>         struct dev_info *hw_priv =3D priv->adapter;
> diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
> b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
> index c1a75b08ced7..485b61e9ddef 100644
> --- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
> +++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
> @@ -1703,7 +1703,9 @@ myri10ge_set_pauseparam(struct net_device *netdev,
>=20
>  static void
>  myri10ge_get_ringparam(struct net_device *netdev,
> -                      struct ethtool_ringparam *ring)
> +                      struct ethtool_ringparam *ring,
> +                      struct ethtool_ringparam_ext *ring_ext,
> +                      struct netlink_ext_ack *extack)
>  {
>         struct myri10ge_priv *mgp =3D netdev_priv(netdev);
>=20
> diff --git a/drivers/net/ethernet/neterion/s2io.c
> b/drivers/net/ethernet/neterion/s2io.c
> index 09c0e839cca5..48edddf5929a 100644
> --- a/drivers/net/ethernet/neterion/s2io.c
> +++ b/drivers/net/ethernet/neterion/s2io.c
> @@ -5462,7 +5462,9 @@ static int s2io_ethtool_set_led(struct net_device
> *dev,
>  }
>=20
>  static void s2io_ethtool_gringparam(struct net_device *dev,
> -                                   struct ethtool_ringparam *ering)
> +                                   struct ethtool_ringparam *ering,
> +                                   struct ethtool_ringparam_ext
> *ering_ext,
> +                                   struct netlink_ext_ack *extack)
>  {
>         struct s2io_nic *sp =3D netdev_priv(dev);
>         int i, tx_desc_count =3D 0, rx_desc_count =3D 0;
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> index 0685ece1f155..21e58081872b 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> @@ -380,7 +380,9 @@ nfp_net_set_link_ksettings(struct net_device *netdev,
>  }
>=20
>  static void nfp_net_get_ringparam(struct net_device *netdev,
> -                                 struct ethtool_ringparam *ring)
> +                                 struct ethtool_ringparam *ring,
> +                                 struct ethtool_ringparam_ext *ring_ext,
> +                                 struct netlink_ext_ack *extack)
>  {
>         struct nfp_net *nn =3D netdev_priv(netdev);
>=20
> @@ -405,7 +407,9 @@ static int nfp_net_set_ring_size(struct nfp_net *nn,
> u32 rxd_cnt, u32 txd_cnt)
>  }
>=20
>  static int nfp_net_set_ringparam(struct net_device *netdev,
> -                                struct ethtool_ringparam *ring)
> +                                struct ethtool_ringparam *ring,
> +                                struct ethtool_ringparam_ext *ring_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct nfp_net *nn =3D netdev_priv(netdev);
>         u32 rxd_cnt, txd_cnt;
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c
> b/drivers/net/ethernet/nvidia/forcedeth.c
> index ef3fb4cc90af..805947dccbb2 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -4651,7 +4651,10 @@ static int nv_nway_reset(struct net_device *dev)
>         return ret;
>  }
>=20
> -static void nv_get_ringparam(struct net_device *dev, struct
> ethtool_ringparam* ring)
> +static void nv_get_ringparam(struct net_device *dev,
> +                            struct ethtool_ringparam *ring,
> +                            struct ethtool_ringparam_ext *ring_ext,
> +                            struct netlink_ext_ack *extack)
>  {
>         struct fe_priv *np =3D netdev_priv(dev);
>=20
> @@ -4662,7 +4665,10 @@ static void nv_get_ringparam(struct net_device
> *dev, struct ethtool_ringparam* r
>         ring->tx_pending =3D np->tx_ring_size;
>  }
>=20
> -static int nv_set_ringparam(struct net_device *dev, struct
> ethtool_ringparam* ring)
> +static int nv_set_ringparam(struct net_device *dev,
> +                           struct ethtool_ringparam *ring,
> +                           struct ethtool_ringparam_ext *ring_ext,
> +                           struct netlink_ext_ack *extack)
>  {
>         struct fe_priv *np =3D netdev_priv(dev);
>         u8 __iomem *base =3D get_hwbase(dev);
> diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
> b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
> index 660b07cb5b92..f4f4eaf8b66f 100644
> --- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
> +++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c
> @@ -270,9 +270,12 @@ static int pch_gbe_nway_reset(struct net_device
> *netdev)
>   * pch_gbe_get_ringparam - Report ring sizes
>   * @netdev:  Network interface device structure
>   * @ring:    Ring param structure
> + * @ring_ext:  Ring external param structure
>   */
>  static void pch_gbe_get_ringparam(struct net_device *netdev,
> -                                       struct ethtool_ringparam *ring)
> +                                 struct ethtool_ringparam *ring,
> +                                 struct ethtool_ringparam_ext *ring_ext,
> +                                 struct netlink_ext_ack *extack)
>  {
>         struct pch_gbe_adapter *adapter =3D netdev_priv(netdev);
>         struct pch_gbe_tx_ring *txdr =3D adapter->tx_ring;
> @@ -288,12 +291,15 @@ static void pch_gbe_get_ringparam(struct
> net_device *netdev,
>   * pch_gbe_set_ringparam - Set ring sizes
>   * @netdev:  Network interface device structure
>   * @ring:    Ring param structure
> + * @ring_ext:  Ring external param structure
>   * Returns
>   *     0:                      Successful.
>   *     Negative value:         Failed.
>   */
>  static int pch_gbe_set_ringparam(struct net_device *netdev,
> -                                       struct ethtool_ringparam *ring)
> +                                struct ethtool_ringparam *ring,
> +                                struct ethtool_ringparam_ext *ring_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct pch_gbe_adapter *adapter =3D netdev_priv(netdev);
>         struct pch_gbe_tx_ring *txdr, *tx_old;
> diff --git a/drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c
> b/drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c
> index e1a304886a3c..fd11307ea08a 100644
> --- a/drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c
> +++ b/drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c
> @@ -69,7 +69,9 @@ pasemi_mac_ethtool_set_msglevel(struct net_device
> *netdev,
>=20
>  static void
>  pasemi_mac_ethtool_get_ringparam(struct net_device *netdev,
> -                                struct ethtool_ringparam *ering)
> +                                struct ethtool_ringparam *ering,
> +                                struct ethtool_ringparam_ext *ering_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct pasemi_mac *mac =3D netdev_priv(netdev);
>=20
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> index 3de1a03839e2..c0b9814c0e7e 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> @@ -527,7 +527,9 @@ static int ionic_set_coalesce(struct net_device
> *netdev,
>  }
>=20
>  static void ionic_get_ringparam(struct net_device *netdev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct ionic_lif *lif =3D netdev_priv(netdev);
>=20
> @@ -538,7 +540,9 @@ static void ionic_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int ionic_set_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct ionic_lif *lif =3D netdev_priv(netdev);
>         struct ionic_queue_params qparam;
> diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
> b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
> index a075643f5826..a86efa1ef56a 100644
> --- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
> +++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
> @@ -392,7 +392,9 @@ netxen_nic_get_eeprom(struct net_device *dev, struct
> ethtool_eeprom *eeprom,
>=20
>  static void
>  netxen_nic_get_ringparam(struct net_device *dev,
> -               struct ethtool_ringparam *ring)
> +                        struct ethtool_ringparam *ring,
> +                        struct ethtool_ringparam_ext *ring_ext,
> +                        struct netlink_ext_ack *extack)
>  {
>         struct netxen_adapter *adapter =3D netdev_priv(dev);
>=20
> @@ -430,7 +432,9 @@ netxen_validate_ringparam(u32 val, u32 min, u32 max,
> char *r_name)
>=20
>  static int
>  netxen_nic_set_ringparam(struct net_device *dev,
> -               struct ethtool_ringparam *ring)
> +                        struct ethtool_ringparam *ring,
> +                        struct ethtool_ringparam_ext *ring_ext,
> +                        struct netlink_ext_ack *extack)
>  {
>         struct netxen_adapter *adapter =3D netdev_priv(dev);
>         u16 max_rcv_desc =3D MAX_RCV_DESCRIPTORS_10G;
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> index 8284c4c1528f..75daee33f0e7 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> @@ -888,7 +888,9 @@ int qede_set_coalesce(struct net_device *dev, struct
> ethtool_coalesce *coal,
>  }
>=20
>  static void qede_get_ringparam(struct net_device *dev,
> -                              struct ethtool_ringparam *ering)
> +                              struct ethtool_ringparam *ering,
> +                              struct ethtool_ringparam_ext *ering_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct qede_dev *edev =3D netdev_priv(dev);
>=20
> @@ -899,7 +901,9 @@ static void qede_get_ringparam(struct net_device
> *dev,
>  }
>=20
>  static int qede_set_ringparam(struct net_device *dev,
> -                             struct ethtool_ringparam *ering)
> +                             struct ethtool_ringparam *ering,
> +                             struct ethtool_ringparam_ext *ering_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct qede_dev *edev =3D netdev_priv(dev);
>=20
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
> b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
> index fc364b4ab6eb..516685ddd023 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
> @@ -632,7 +632,9 @@ qlcnic_get_eeprom(struct net_device *dev, struct
> ethtool_eeprom *eeprom,
>=20
>  static void
>  qlcnic_get_ringparam(struct net_device *dev,
> -               struct ethtool_ringparam *ring)
> +                    struct ethtool_ringparam *ring,
> +                    struct ethtool_ringparam_ext *ring_ext,
> +                    struct netlink_ext_ack *extack)
>  {
>         struct qlcnic_adapter *adapter =3D netdev_priv(dev);
>=20
> @@ -663,7 +665,9 @@ qlcnic_validate_ringparam(u32 val, u32 min, u32 max,
> char *r_name)
>=20
>  static int
>  qlcnic_set_ringparam(struct net_device *dev,
> -               struct ethtool_ringparam *ring)
> +                    struct ethtool_ringparam *ring,
> +                    struct ethtool_ringparam_ext *ring_ext,
> +                    struct netlink_ext_ack *extack)
>  {
>         struct qlcnic_adapter *adapter =3D netdev_priv(dev);
>         u16 num_rxd, num_jumbo_rxd, num_txd;
> diff --git a/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
> b/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
> index f72e13b83869..cf6ce09073f0 100644
> --- a/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
> +++ b/drivers/net/ethernet/qualcomm/emac/emac-ethtool.c
> @@ -133,7 +133,9 @@ static int emac_nway_reset(struct net_device *netdev)
>  }
>=20
>  static void emac_get_ringparam(struct net_device *netdev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct emac_adapter *adpt =3D netdev_priv(netdev);
>=20
> @@ -144,7 +146,9 @@ static void emac_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int emac_set_ringparam(struct net_device *netdev,
> -                             struct ethtool_ringparam *ring)
> +                             struct ethtool_ringparam *ring,
> +                             struct ethtool_ringparam_ext *ring_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct emac_adapter *adpt =3D netdev_priv(netdev);
>=20
> diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c
> b/drivers/net/ethernet/qualcomm/qca_debug.c
> index d59fff2fbcc6..33d0720c5745 100644
> --- a/drivers/net/ethernet/qualcomm/qca_debug.c
> +++ b/drivers/net/ethernet/qualcomm/qca_debug.c
> @@ -246,7 +246,9 @@ qcaspi_get_regs(struct net_device *dev, struct
> ethtool_regs *regs, void *p)
>  }
>=20
>  static void
> -qcaspi_get_ringparam(struct net_device *dev, struct ethtool_ringparam
> *ring)
> +qcaspi_get_ringparam(struct net_device *dev, struct ethtool_ringparam
> *ring,
> +                    struct ethtool_ringparam_ext *ring_ext,
> +                    struct netlink_ext_ack *extack)
>  {
>         struct qcaspi *qca =3D netdev_priv(dev);
>=20
> @@ -257,7 +259,9 @@ qcaspi_get_ringparam(struct net_device *dev, struct
> ethtool_ringparam *ring)
>  }
>=20
>  static int
> -qcaspi_set_ringparam(struct net_device *dev, struct ethtool_ringparam
> *ring)
> +qcaspi_set_ringparam(struct net_device *dev, struct ethtool_ringparam
> *ring,
> +                    struct ethtool_ringparam_ext *ring_ext,
> +                    struct netlink_ext_ack *extack)
>  {
>         const struct net_device_ops *ops =3D dev->netdev_ops;
>         struct qcaspi *qca =3D netdev_priv(dev);
> diff --git a/drivers/net/ethernet/realtek/8139cp.c
> b/drivers/net/ethernet/realtek/8139cp.c
> index 2b84b4565e64..4f9f97e2148d 100644
> --- a/drivers/net/ethernet/realtek/8139cp.c
> +++ b/drivers/net/ethernet/realtek/8139cp.c
> @@ -1388,7 +1388,9 @@ static void cp_get_drvinfo (struct net_device *dev,
> struct ethtool_drvinfo *info
>  }
>=20
>  static void cp_get_ringparam(struct net_device *dev,
> -                               struct ethtool_ringparam *ring)
> +                            struct ethtool_ringparam *ring,
> +                            struct ethtool_ringparam_ext *ring_ext,
> +                            struct netlink_ext_ack *extack)
>  {
>         ring->rx_max_pending =3D CP_RX_RING_SIZE;
>         ring->tx_max_pending =3D CP_TX_RING_SIZE;
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c
> b/drivers/net/ethernet/realtek/r8169_main.c
> index 0199914440ab..f0a42cf1b30c 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -1872,7 +1872,9 @@ static int rtl8169_set_eee(struct net_device *dev,
> struct ethtool_eee *data)
>  }
>=20
>  static void rtl8169_get_ringparam(struct net_device *dev,
> -                                 struct ethtool_ringparam *data)
> +                                 struct ethtool_ringparam *data,
> +                                 struct ethtool_ringparam_ext *data_ext,
> +                                 struct netlink_ext_ack *extack)
>  {
>         data->rx_max_pending =3D NUM_RX_DESC;
>         data->rx_pending =3D NUM_RX_DESC;
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
> b/drivers/net/ethernet/renesas/ravb_main.c
> index 0f85f2d97b18..ce1e5648029b 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1246,7 +1246,9 @@ static void ravb_get_strings(struct net_device
> *ndev, u32 stringset, u8 *data)
>  }
>=20
>  static void ravb_get_ringparam(struct net_device *ndev,
> -                              struct ethtool_ringparam *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct ravb_private *priv =3D netdev_priv(ndev);
>=20
> @@ -1257,7 +1259,9 @@ static void ravb_get_ringparam(struct net_device
> *ndev,
>  }
>=20
>  static int ravb_set_ringparam(struct net_device *ndev,
> -                             struct ethtool_ringparam *ring)
> +                             struct ethtool_ringparam *ring,
> +                             struct ethtool_ringparam_ext *ring_ext,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct ravb_private *priv =3D netdev_priv(ndev);
>         const struct ravb_hw_info *info =3D priv->info;
> diff --git a/drivers/net/ethernet/renesas/sh_eth.c
> b/drivers/net/ethernet/renesas/sh_eth.c
> index 1374faa229a2..086e4458b867 100644
> --- a/drivers/net/ethernet/renesas/sh_eth.c
> +++ b/drivers/net/ethernet/renesas/sh_eth.c
> @@ -2294,7 +2294,9 @@ static void sh_eth_get_strings(struct net_device
> *ndev, u32 stringset, u8 *data)
>  }
>=20
>  static void sh_eth_get_ringparam(struct net_device *ndev,
> -                                struct ethtool_ringparam *ring)
> +                                struct ethtool_ringparam *ring,
> +                                struct ethtool_ringparam_ext *ring_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct sh_eth_private *mdp =3D netdev_priv(ndev);
>=20
> @@ -2305,7 +2307,9 @@ static void sh_eth_get_ringparam(struct net_device
> *ndev,
>  }
>=20
>  static int sh_eth_set_ringparam(struct net_device *ndev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct sh_eth_private *mdp =3D netdev_priv(ndev);
>         int ret;
> diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.c
> b/drivers/net/ethernet/sfc/ef100_ethtool.c
> index 835c838b7dfa..f0bff0d668b2 100644
> --- a/drivers/net/ethernet/sfc/ef100_ethtool.c
> +++ b/drivers/net/ethernet/sfc/ef100_ethtool.c
> @@ -21,7 +21,9 @@
>  #define EFX_EF100_MAX_DMAQ_SIZE 16384UL
>=20
>  static void ef100_ethtool_get_ringparam(struct net_device *net_dev,
> -                                       struct ethtool_ringparam *ring)
> +                                       struct ethtool_ringparam *ring,
> +                                       struct ethtool_ringparam_ext
> *ring_ext,
> +                                       struct netlink_ext_ack *extack)
>  {
>         struct efx_nic *efx =3D netdev_priv(net_dev);
>=20
> diff --git a/drivers/net/ethernet/sfc/ethtool.c
> b/drivers/net/ethernet/sfc/ethtool.c
> index e002ce21788d..7eaa1a7c6521 100644
> --- a/drivers/net/ethernet/sfc/ethtool.c
> +++ b/drivers/net/ethernet/sfc/ethtool.c
> @@ -158,7 +158,9 @@ static int efx_ethtool_set_coalesce(struct
> net_device *net_dev,
>  }
>=20
>  static void efx_ethtool_get_ringparam(struct net_device *net_dev,
> -                                     struct ethtool_ringparam *ring)
> +                                     struct ethtool_ringparam *ring,
> +                                     struct ethtool_ringparam_ext
> *ring_ext,
> +                                     struct netlink_ext_ack *extack)
>  {
>         struct efx_nic *efx =3D netdev_priv(net_dev);
>=20
> @@ -169,7 +171,9 @@ static void efx_ethtool_get_ringparam(struct
> net_device *net_dev,
>  }
>=20
>  static int efx_ethtool_set_ringparam(struct net_device *net_dev,
> -                                    struct ethtool_ringparam *ring)
> +                                    struct ethtool_ringparam *ring,
> +                                    struct ethtool_ringparam_ext
> *ring_ext,
> +                                    struct netlink_ext_ack *extack)
>  {
>         struct efx_nic *efx =3D netdev_priv(net_dev);
>         u32 txq_entries;
> diff --git a/drivers/net/ethernet/sfc/falcon/ethtool.c
> b/drivers/net/ethernet/sfc/falcon/ethtool.c
> index 137e8a7aeaa1..89347774d954 100644
> --- a/drivers/net/ethernet/sfc/falcon/ethtool.c
> +++ b/drivers/net/ethernet/sfc/falcon/ethtool.c
> @@ -638,7 +638,9 @@ static int ef4_ethtool_set_coalesce(struct
> net_device *net_dev,
>  }
>=20
>  static void ef4_ethtool_get_ringparam(struct net_device *net_dev,
> -                                     struct ethtool_ringparam *ring)
> +                                     struct ethtool_ringparam *ring,
> +                                     struct ethtool_ringparam_ext
> *ring_ext,
> +                                     struct netlink_ext_ack *extack)
>  {
>         struct ef4_nic *efx =3D netdev_priv(net_dev);
>=20
> @@ -649,7 +651,9 @@ static void ef4_ethtool_get_ringparam(struct
> net_device *net_dev,
>  }
>=20
>  static int ef4_ethtool_set_ringparam(struct net_device *net_dev,
> -                                    struct ethtool_ringparam *ring)
> +                                    struct ethtool_ringparam *ring,
> +                                    struct ethtool_ringparam_ext
> *ring_ext,
> +                                    struct netlink_ext_ack *extack)
>  {
>         struct ef4_nic *efx =3D netdev_priv(net_dev);
>         u32 txq_entries;
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> index d89455803bed..d1096cf02722 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> @@ -463,7 +463,9 @@ static int stmmac_nway_reset(struct net_device *dev)
>  }
>=20
>  static void stmmac_get_ringparam(struct net_device *netdev,
> -                                struct ethtool_ringparam *ring)
> +                                struct ethtool_ringparam *ring,
> +                                struct ethtool_ringparam_ext *ring_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct stmmac_priv *priv =3D netdev_priv(netdev);
>=20
> @@ -474,7 +476,9 @@ static void stmmac_get_ringparam(struct net_device
> *netdev,
>  }
>=20
>  static int stmmac_set_ringparam(struct net_device *netdev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         if (ring->rx_mini_pending || ring->rx_jumbo_pending ||
>             ring->rx_pending < DMA_MIN_RX_SIZE ||
> diff --git a/drivers/net/ethernet/tehuti/tehuti.c
> b/drivers/net/ethernet/tehuti/tehuti.c
> index 6b409f9c5863..e7d0d8254030 100644
> --- a/drivers/net/ethernet/tehuti/tehuti.c
> +++ b/drivers/net/ethernet/tehuti/tehuti.c
> @@ -2243,9 +2243,12 @@ static inline int bdx_tx_fifo_size_to_packets(int
> tx_size)
>   * bdx_get_ringparam - report ring sizes
>   * @netdev
>   * @ring
> + * @ring_ext
>   */
>  static void
> -bdx_get_ringparam(struct net_device *netdev, struct ethtool_ringparam
> *ring)
> +bdx_get_ringparam(struct net_device *netdev, struct ethtool_ringparam
> *ring,
> +                 struct ethtool_ringparam_ext *ring_ext,
> +                 struct netlink_ext_ack *extack)
>  {
>         struct bdx_priv *priv =3D netdev_priv(netdev);
>=20
> @@ -2260,9 +2263,12 @@ bdx_get_ringparam(struct net_device *netdev,
> struct ethtool_ringparam *ring)
>   * bdx_set_ringparam - set ring sizes
>   * @netdev
>   * @ring
> + * @ring_ext
>   */
>  static int
> -bdx_set_ringparam(struct net_device *netdev, struct ethtool_ringparam
> *ring)
> +bdx_set_ringparam(struct net_device *netdev, struct ethtool_ringparam
> *ring,
> +                 struct ethtool_ringparam_ext *ring_ext,
> +                 struct netlink_ext_ack *extack)
>  {
>         struct bdx_priv *priv =3D netdev_priv(netdev);
>         int rx_size =3D 0;
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
> b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
> index 6e4d4f9e32e0..c3dd232286f2 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
> @@ -454,7 +454,9 @@ static int am65_cpsw_set_channels(struct net_device
> *ndev,
>  }
>=20
>  static void am65_cpsw_get_ringparam(struct net_device *ndev,
> -                                   struct ethtool_ringparam *ering)
> +                                   struct ethtool_ringparam *ering,
> +                                   struct ethtool_ringparam_ext
> *ering_ext,
> +                                   struct netlink_ext_ack *extack)
>  {
>         struct am65_cpsw_common *common =3D am65_ndev_to_common(ndev);
>=20
> diff --git a/drivers/net/ethernet/ti/cpmac.c
> b/drivers/net/ethernet/ti/cpmac.c
> index 02d4e51f7306..d9c843429fc3 100644
> --- a/drivers/net/ethernet/ti/cpmac.c
> +++ b/drivers/net/ethernet/ti/cpmac.c
> @@ -817,7 +817,9 @@ static void cpmac_tx_timeout(struct net_device *dev,
> unsigned int txqueue)
>  }
>=20
>  static void cpmac_get_ringparam(struct net_device *dev,
> -                                               struct ethtool_ringparam
> *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct cpmac_priv *priv =3D netdev_priv(dev);
>=20
> @@ -833,7 +835,9 @@ static void cpmac_get_ringparam(struct net_device
> *dev,
>  }
>=20
>  static int cpmac_set_ringparam(struct net_device *dev,
> -                                               struct ethtool_ringparam
> *ring)
> +                              struct ethtool_ringparam *ring,
> +                              struct ethtool_ringparam_ext *ring_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct cpmac_priv *priv =3D netdev_priv(dev);
>=20
> diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c
> b/drivers/net/ethernet/ti/cpsw_ethtool.c
> index 158c8d3793f4..24c2c6689105 100644
> --- a/drivers/net/ethernet/ti/cpsw_ethtool.c
> +++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
> @@ -658,7 +658,9 @@ int cpsw_set_channels_common(struct net_device *ndev,
>  }
>=20
>  void cpsw_get_ringparam(struct net_device *ndev,
> -                       struct ethtool_ringparam *ering)
> +                       struct ethtool_ringparam *ering,
> +                       struct ethtool_ringparam_ext *ring_ext,
> +                       struct netlink_ext_ack *extack)
>  {
>         struct cpsw_priv *priv =3D netdev_priv(ndev);
>         struct cpsw_common *cpsw =3D priv->cpsw;
> @@ -671,7 +673,9 @@ void cpsw_get_ringparam(struct net_device *ndev,
>  }
>=20
>  int cpsw_set_ringparam(struct net_device *ndev,
> -                      struct ethtool_ringparam *ering)
> +                      struct ethtool_ringparam *ering,
> +                      struct ethtool_ringparam_ext *ring_ext,
> +                      struct netlink_ext_ack *extack)
>  {
>         struct cpsw_common *cpsw =3D ndev_to_cpsw(ndev);
>         int descs_num, ret;
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.h
> b/drivers/net/ethernet/ti/cpsw_priv.h
> index 435668ee542d..9fb77b5e1316 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.h
> +++ b/drivers/net/ethernet/ti/cpsw_priv.h
> @@ -491,9 +491,13 @@ int cpsw_get_eee(struct net_device *ndev, struct
> ethtool_eee *edata);
>  int cpsw_set_eee(struct net_device *ndev, struct ethtool_eee *edata);
>  int cpsw_nway_reset(struct net_device *ndev);
>  void cpsw_get_ringparam(struct net_device *ndev,
> -                       struct ethtool_ringparam *ering);
> +                       struct ethtool_ringparam *ering,
> +                       struct ethtool_ringparam_ext *ring_ext,
> +                       struct netlink_ext_ack *extack);
>  int cpsw_set_ringparam(struct net_device *ndev,
> -                      struct ethtool_ringparam *ering);
> +                      struct ethtool_ringparam *ering,
> +                      struct ethtool_ringparam_ext *ring_ext,
> +                      struct netlink_ext_ack *extack);
>  int cpsw_set_channels_common(struct net_device *ndev,
>                              struct ethtool_channels *chs,
>                              cpdma_handler_fn rx_handler);
> diff --git a/drivers/net/ethernet/toshiba/spider_net_ethtool.c
> b/drivers/net/ethernet/toshiba/spider_net_ethtool.c
> index 54f655a68148..85cf022b15f1 100644
> --- a/drivers/net/ethernet/toshiba/spider_net_ethtool.c
> +++ b/drivers/net/ethernet/toshiba/spider_net_ethtool.c
> @@ -110,7 +110,9 @@ spider_net_ethtool_nway_reset(struct net_device
> *netdev)
>=20
>  static void
>  spider_net_ethtool_get_ringparam(struct net_device *netdev,
> -                                struct ethtool_ringparam *ering)
> +                                struct ethtool_ringparam *ering
> +                                struct ethtool_ringparam_ext *ering_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct spider_net_card *card =3D netdev_priv(netdev);
>=20
> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c
> b/drivers/net/ethernet/xilinx/ll_temac_main.c
> index 463094ced104..bff1387b6076 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -1276,8 +1276,11 @@ static const struct attribute_group
> temac_attr_group =3D {
>   * ethtool support
>   */
>=20
> -static void ll_temac_ethtools_get_ringparam(struct net_device *ndev,
> -                                           struct ethtool_ringparam
> *ering)
> +static void
> +ll_temac_ethtools_get_ringparam(struct net_device *ndev,
> +                               struct ethtool_ringparam *ering,
> +                               struct ethtool_ringparam_ext *ering_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct temac_local *lp =3D netdev_priv(ndev);
>=20
> @@ -1291,8 +1294,11 @@ static void
> ll_temac_ethtools_get_ringparam(struct net_device *ndev,
>         ering->tx_pending =3D lp->tx_bd_num;
>  }
>=20
> -static int ll_temac_ethtools_set_ringparam(struct net_device *ndev,
> -                                          struct ethtool_ringparam
> *ering)
> +static int
> +ll_temac_ethtools_set_ringparam(struct net_device *ndev,
> +                               struct ethtool_ringparam *ering,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct temac_local *lp =3D netdev_priv(ndev);
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 871b5ec3183d..c682843139de 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1323,8 +1323,11 @@ static void axienet_ethtools_get_regs(struct
> net_device *ndev,
>         data[39] =3D axienet_dma_in32(lp, XAXIDMA_RX_TDESC_OFFSET);
>  }
>=20
> -static void axienet_ethtools_get_ringparam(struct net_device *ndev,
> -                                          struct ethtool_ringparam
> *ering)
> +static void
> +axienet_ethtools_get_ringparam(struct net_device *ndev,
> +                              struct ethtool_ringparam *ering,
> +                              struct ethtool_ringparam_ext *ering_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct axienet_local *lp =3D netdev_priv(ndev);
>=20
> @@ -1338,8 +1341,11 @@ static void axienet_ethtools_get_ringparam(struct
> net_device *ndev,
>         ering->tx_pending =3D lp->tx_bd_num;
>  }
>=20
> -static int axienet_ethtools_set_ringparam(struct net_device *ndev,
> -                                         struct ethtool_ringparam
> *ering)
> +static int
> +axienet_ethtools_set_ringparam(struct net_device *ndev,
> +                              struct ethtool_ringparam *ering,
> +                              struct ethtool_ringparam_ext *ering_ext,
> +                              struct netlink_ext_ack *extack)
>  {
>         struct axienet_local *lp =3D netdev_priv(ndev);
>=20
> diff --git a/drivers/net/hyperv/netvsc_drv.c
> b/drivers/net/hyperv/netvsc_drv.c
> index 382bebc2420d..1a68301a9444 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -1857,7 +1857,9 @@ static void __netvsc_get_ringparam(struct
> netvsc_device *nvdev,
>  }
>=20
>  static void netvsc_get_ringparam(struct net_device *ndev,
> -                                struct ethtool_ringparam *ring)
> +                                struct ethtool_ringparam *ring,
> +                                struct ethtool_ringparam_ext *ring_ext,
> +                                struct netlink_ext_ack *extack)
>  {
>         struct net_device_context *ndevctx =3D netdev_priv(ndev);
>         struct netvsc_device *nvdev =3D rtnl_dereference(ndevctx->nvdev);
> @@ -1869,7 +1871,9 @@ static void netvsc_get_ringparam(struct net_device
> *ndev,
>  }
>=20
>  static int netvsc_set_ringparam(struct net_device *ndev,
> -                               struct ethtool_ringparam *ring)
> +                               struct ethtool_ringparam *ring,
> +                               struct ethtool_ringparam_ext *ring_ext,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct net_device_context *ndevctx =3D netdev_priv(ndev);
>         struct netvsc_device *nvdev =3D rtnl_dereference(ndevctx->nvdev);

The changes to drivers/net/hyperv/netvsc_drv.c look fine.

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>


