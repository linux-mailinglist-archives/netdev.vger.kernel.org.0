Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EECA42A70E
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237176AbhJLOVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:21:18 -0400
Received: from mail-eastus2namln1000.outbound.protection.outlook.com ([40.93.3.0]:63010
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236943AbhJLOVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 10:21:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRAXNWTIXC39u+KtvWxE4kvEt1esWtum8o94HVy2IfVPc4fef8ADJluzt8JcLEMKLXXsFoKVrW9cilt6uJIvJOlq27OwhfIW8ggzdSWLDIU7vIQsAsh9C2+NdJpqXnx/K7BRpZT7/nAW/4Mk2u+Z0bEHkNiVRDHFjorWFBqVzjcQGrd90+JqWdMQmhcFq3n5i5uHlCsbbDICYxfhKWPRH2i89lbW7vxm3P5jlvcXe0XIf2YQobuH3rEYBZO+9qg/XAfN/ylka3HVvDCjTAbCb+UztNR+R+UmWfqolwGh+7palST8ozyCPlCeQ9mTF3zPTLeKKLk/VmJ0J7nMXzW0Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hw7TF5zNpyqdqounc7i1BQoYzWGNcmh1M8udvaQXsIg=;
 b=QlsKDZuiroKSENcXRVK92kCbqHVIOr3NpC+y3IKJfBIelUVj0WlbQHbJbwrq9XE5/wTlF5L/bgJxULJDf8f/D4wux5B+OeFDbj9O7QZz2fRpblVgpR1vioWriIcdX7P9w5siV8mpFSCIQTjN0uszwCTwFlZzF2fZuyeztSGLOo2QWEzd/E4CRUw+o8ZsRKnlY4bewNLAukmfEEzIt6QaLsmRUBBvBBF8IrQLxdFQ6N9iQx7nBa+C+M4FikGV3wTmoczxgJbIf/4Tr641UFQIGuOIeYZgTRrQwGDR84YqRPZ6U6KDhl2OZ4G7Eo+XWQQDPj60VHZveY6rSq/ea/IHzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hw7TF5zNpyqdqounc7i1BQoYzWGNcmh1M8udvaQXsIg=;
 b=WwDD/XaRDgfABA85mlcApEdX0IHzgPX3YhU7Jx9GIjEkLDGC4gta1JcJ/YwQlYn6mRQXGJDgzd1rAjj5Q7aXS337S7K5QlQfA+xeGh4OB7on3pMLN/ttipu1gBVUSMQQfzUX6wBrlJEL78F6bfSKHvzwmJITkq+1ob4NVRdiBsQ=
Received: from BN8PR21MB1284.namprd21.prod.outlook.com (2603:10b6:408:a2::22)
 by BN6PR21MB0849.namprd21.prod.outlook.com (2603:10b6:404:9e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.3; Tue, 12 Oct
 2021 14:19:09 +0000
Received: from BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::297f:262:dd3c:555]) by BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::297f:262:dd3c:555%5]) with mapi id 15.20.4628.006; Tue, 12 Oct 2021
 14:19:09 +0000
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
Subject: RE: [PATCH V3 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Thread-Topic: [PATCH V3 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Thread-Index: AQHXv297NGUrsq31AE6JiS7mJ5I42avPaKFw
Date:   Tue, 12 Oct 2021 14:19:09 +0000
Message-ID: <BN8PR21MB128403C0DBA02750C671E97DCAB69@BN8PR21MB1284.namprd21.prod.outlook.com>
References: <20211012134127.11761-1-huangguangbin2@huawei.com>
 <20211012134127.11761-5-huangguangbin2@huawei.com>
In-Reply-To: <20211012134127.11761-5-huangguangbin2@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=60e3f3f6-2a35-4015-bd5c-acbb066203f3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-12T14:16:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6ac2299-a60a-4834-80c8-08d98d8b4201
x-ms-traffictypediagnostic: BN6PR21MB0849:
x-microsoft-antispam-prvs: <BN6PR21MB0849F68B5975D9AF4B619B17CAB69@BN6PR21MB0849.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m8fy1biKYcKbnRSPKKVHVYxwU1pqc3ZY8c7VYVaX0QMrk2lrDxJP4PW2d2QDTSzX0L/nCl2k801CSbG5BYa3lvHW7896OWta/v/IrjrsrhU3zC/2u/hckFm7HX7oMUJdHV1srwHYZm/bFtKdUPvUAv1LcK0BKrV9fzL3gCtUxUBF0AfG1D3RXO9FwMdXTUzEIj+nvrCKuA86tF1/Knh9vW3yEtbNoq6YQTvburLf5dhcKiapbaycm/U27cjonrX9+j7M66rup0yhf+Vwi4lz7qtyDA3Wyp3QIFwacx6UchRpVN8Zr7AYOmQMe1wAut7dmfOgBT4YbLlJODCO5W7au7pMFodU3kSetEagvgrtYrGpP8qkAUzpuZa//vzhrtGBo7+U0ZhQJywM8Hi94Hc6+ZnYiMubIRmMSAywyTFVolX1wn0kEQI3UthdTe9M6TLQB4+VEcHiXw4aXcBosFvlBP9BkEScC90Y4Wxu9adrAbjfIEpKBdS6gaRuelCRb59Axdqruq4SCmEZMNES7dsS9yFBmGfDKzatRlx77xpSkGq3R4ZacNFWYUxevHGnHWclgO8E5Lg7Q+CCzrtC4cth0SCYnlxf8Wf+DOZqrlZdOyqHpERRdxTxLMqSQoXML8FY9h71yseHCkJ6gRzVDJ/vz52gr6pDo/4dNmv1yH/rBrUz3IBP8G8qxKNz/Fk9C00ov7WKSj4UtdQigLqBDJRx+oy6dUJVOM/c9M04P1Yq6tI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1284.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(8676002)(66946007)(186003)(64756008)(66556008)(66476007)(10290500003)(52536014)(8990500004)(7406005)(4326008)(38070700005)(8936002)(7416002)(508600001)(76116006)(921005)(122000001)(55016002)(83380400001)(86362001)(6506007)(53546011)(5660300002)(82950400001)(71200400001)(2906002)(33656002)(26005)(9686003)(316002)(110136005)(54906003)(82960400001)(7696005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7hhKRALINivINePML/Fygdg4n8nnz6JgYkMJLOhwqRvV2yHqvJpiqNA9dXwL?=
 =?us-ascii?Q?wbaqDhmCtU6jvjCKA6sOH+noY7Lxr2AbBotQu2DcHrMy+pUYjEl8g9N8UIFQ?=
 =?us-ascii?Q?U9mOaeU+Y1ZYmzHE35Co8qkOBNMIzvWOtQWLjzdbJPRGJTa2zf1lEAoUdbPd?=
 =?us-ascii?Q?Wro162Ua7DLDmG1mFmpCJrHT+7fTdXNqHh1+YWwm9TDw3IW8Btok9YAkDG6d?=
 =?us-ascii?Q?x5y8pICkSHUe0AzSJTkwJqKT1ifqwiqZnf0hoQu5h0NV2BJfJ2ASVyXuSSaO?=
 =?us-ascii?Q?sW8x6t0B8whspRdNHO7GksbqUhUTD+O5Ay5aM5xwsPqCF3LHBbWU0VAtRAr3?=
 =?us-ascii?Q?5FPDqwC2s71mgXeoClVuIWRjkMBiRXGOayc2uw3JONy/rCDYqpZDLpwXzgI/?=
 =?us-ascii?Q?jlan5s5h3VoIr7jfE1srxa99jG7x951cjAMkPFlK74pyIUnJRSI4f7j8vj35?=
 =?us-ascii?Q?rI1qjrVWSLxX1jVBubYFmud/YuTMWzXn5BLiHwowlHSfATNTi6Q2pOgwyH1E?=
 =?us-ascii?Q?T8GobWUXAI6/l9s1OoQTIw0Cy90ZH+TSz5y5cZzZunmDiZksJJfr4ZuDFLov?=
 =?us-ascii?Q?FECu4xTZnXwXIrtbAH3bhRkeBC/0Xzg5QOW9QeBvICZ5dQ8tfnwrM8zHdpGX?=
 =?us-ascii?Q?X7eTwo/y/Z2oFomiGWHGDGqiHTjazarsaV60IwPfJVpoSfNJXFykvxJ18w+b?=
 =?us-ascii?Q?vEqf31+Mzrm7LtHZ3/ihkerdNiKG98KBtUu2hWAaowF2AqjYdY81b8nYaOxx?=
 =?us-ascii?Q?3sIj3n2BkHEzpkvxkhOO5QKiB22bG5YDlDIm+cqBbnKlvJzRT1XQZUaG2cWK?=
 =?us-ascii?Q?ym/OuIui3hSU892l/ebtuDSybS14zwIkD2j5cSmtbfFf5IZjWq71Dn4HUI8h?=
 =?us-ascii?Q?V+z8QepXaCmjumunV3jWWSx4oMxleQdXTFpf/Wu1y5yhqpvQDndmyVNy+NWH?=
 =?us-ascii?Q?c747ffx+WxHR5EGOVOxhPkKzLpDK/rmVSwY7dMVWxa7a7qSkKxISttHVyoXk?=
 =?us-ascii?Q?zcsn0Pz0Woz4nA7sov0UPba+Q9upYfwSlUvYfHQb4p2l5tReF60WwRZbJYoj?=
 =?us-ascii?Q?lL4HO3bdJyKvtWkskxwqBg/1u+DDC1c282T7mLR2FnwQr+M3+lPAg9mqzU7U?=
 =?us-ascii?Q?hfa8NHFwWrpKjbZWQY1jKgWwXqgFTwwgpJw0AOZcBbAQF8oscYCa3YwWC0+V?=
 =?us-ascii?Q?7L4ItCLauz07snuv26/bieaxWquKSdj7UoavqDUpRt9KyDxYb+2gy99BegWj?=
 =?us-ascii?Q?Ld+LHyCGqU0biTZB4MIgWxSJjxY1iyvLmYsmmGHdjKdpMfd+sP+5v7C6Hqvl?=
 =?us-ascii?Q?xmBdI9a3BjMy654prodZl1DiNogVRMvDxEBxDeg5DxqGeuVJYpxgIe2mR58m?=
 =?us-ascii?Q?+Wn2AcgQZSyJK+UP9ASGzprw1zgUgnCH1s45VpjQDwXoXLa2gBHxMonxQjwQ?=
 =?us-ascii?Q?79JU8vcKAG3PG+Wuo/2kIDJcPobYPe6dez898OZEg0LVy24jKrNSlocGIyXc?=
 =?us-ascii?Q?SIvd52J5RfNHKCaAN83q8D3ztJeKrIpbaDyxoJSnOu1Zba01vdTUHPFT471N?=
 =?us-ascii?Q?cLJJsJBYwfg9oPKpp1svtQdibVnSyvY2gg0Izg8LIW9NNEghZvLhREmMIp6w?=
 =?us-ascii?Q?eQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1284.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ac2299-a60a-4834-80c8-08d98d8b4201
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 14:19:09.4752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HiykQt20OR8z5zws/uNJc0KBKzBoCD3DCpGLSdM7FgdeuyMRzwsc52u2De6HdURlVlsfEXuwyeEDXjGNMrQRDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0849
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Guangbin Huang <huangguangbin2@huawei.com>
> Sent: Tuesday, October 12, 2021 9:41 AM
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
> Subject: [PATCH V3 net-next 4/6] ethtool: extend ringparam setting uAPI
> with rx_buf_len
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
>  include/linux/ethtool.h                          |  8 ++++++--
>  net/ethtool/ioctl.c                              |  9 ++++++---
>  net/ethtool/rings.c                              | 15 +++++++++++----
>  net/mac80211/ethtool.c                           |  8 ++++++--
>  99 files changed, 568 insertions(+), 187 deletions(-)
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
> -				 struct ethtool_ringparam *ring)
> +				 struct ethtool_ringparam *ring,
> +				 struct ethtool_ringparam_ext *ring_ext,
> +				 struct netlink_ext_ack *extack)
>  {
>  	struct net_device_context *ndevctx =3D netdev_priv(ndev);
>  	struct netvsc_device *nvdev =3D rtnl_dereference(ndevctx->nvdev);
> @@ -1869,7 +1871,9 @@ static void netvsc_get_ringparam(struct net_device
> *ndev,
>  }
>=20
>  static int netvsc_set_ringparam(struct net_device *ndev,
> -				struct ethtool_ringparam *ring)
> +				struct ethtool_ringparam *ring,
> +				struct ethtool_ringparam_ext *ring_ext,
> +				struct netlink_ext_ack *extack)
>  {
>  	struct net_device_context *ndevctx =3D netdev_priv(ndev);
>  	struct netvsc_device *nvdev =3D rtnl_dereference(ndevctx->nvdev);

The changes to netvsc_drv.c look good. Thanks.

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>


