Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F03EC19028D
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 01:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgCXALv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 20:11:51 -0400
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:36067
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727299AbgCXALv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 20:11:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DY6FG4aIv1Uu+jImDQSqGkrxNXJ0u5jwAP+BLZEGEySbpIleb+OLhj60T+aP5z6GkhyFK2MBgOZPD0ZDFJ0fhFpydnSxHvzyxNoQUPvPHRKAi/tEyu+deocz5zSxzCNl77EkxYb+OuokJ0edv+8ia7p7OR5AbgQJssgCuIsPHB1vCjaJ8DQjwzV8oqoKeoE0mB5dqeNe+fP1fYoqpXhg4ADCUV0LEyNvfdsCatUGYW9WmjNqN2ceZXe/5Eef5KAk9oNS4Uy2E5zVUTYM1AOaPGqCawtAAe0y6DB/ZX+a2QQ5Ejd3Zats/rv7YgOI+IZFWK3EfOoTqWAaiPE1Kxd21A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVpa+nNUa3wqoYPktPe/0ot2xql0mKMvBGcA+UzjOMU=;
 b=mWMrdh0jGNvXF0aUdOdAoV2/Zx9g3l8J1sg0DeyUatlUGVTG6LQj1bbcuQMlUZPNNOIcd53st4yYKLOUaDW1nluZ34ZDkpnN5HQpuQKlG3Hnsv4Gw+2gtSSNYPk251zfeCZ6tA08RZ6DiipuUy+lHvvudOMg1Ke7oonkVWKmC6wsMFgZe2DNc4tnG6pombR33cVWYs09ymVXK77YwauyQ8YROFSlygopFfrR45RkGGcqnZj5eKD97IH7gecZRXKq6cdiR0VMfucYLBNLhK9wqFnKF5oqZdGcCOLzmN74gVzQE2lnEsoBgp/4J90ruIgr4YkiDZjXbQfztac4YwMaCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVpa+nNUa3wqoYPktPe/0ot2xql0mKMvBGcA+UzjOMU=;
 b=oK1WzpNpEBAIppdIt5ngGn5+98IGJlQEFgpzCEBW4we6wJ97xW8RxPiCG2bIwDLbYafb2O7U97LSqAtL9Pryt4lJp4zk2sbBXgxIpYmHq+ZESQC8XMgDLiBb11rM1ALVIa1Ozkkys/MSAkz57DOya4GkIODLqq+nzfofn18QpjU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB3166.eurprd05.prod.outlook.com (10.170.237.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Tue, 24 Mar 2020 00:11:47 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3%7]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 00:11:47 +0000
Date:   Mon, 23 Mar 2020 21:11:43 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Andy Gospodarek <andy@greyhouse.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net, parav@mellanox.com,
        yuvalav@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        moshe@mellanox.com, ayal@mellanox.com, eranbe@mellanox.com,
        vladbu@mellanox.com, kliteyn@mellanox.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, tariqt@mellanox.com,
        oss-drivers@netronome.com, snelson@pensando.io,
        drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, magnus.karlsson@intel.com
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200324001143.GG20941@ziepe.ca>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323233200.GD21532@C02YVCJELVCG.greyhouse.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323233200.GD21532@C02YVCJELVCG.greyhouse.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0030.namprd02.prod.outlook.com
 (2603:10b6:207:3c::43) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0030.namprd02.prod.outlook.com (2603:10b6:207:3c::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Tue, 24 Mar 2020 00:11:46 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jGXAV-0001rS-1V; Mon, 23 Mar 2020 21:11:43 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 604a018d-7b2c-4ce5-7400-08d7cf87f0d6
X-MS-TrafficTypeDiagnostic: VI1PR05MB3166:|VI1PR05MB3166:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3166F856ED8AB41F4DDC20D5CFF10@VI1PR05MB3166.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(4744005)(2906002)(1076003)(4326008)(7416002)(33656002)(86362001)(6916009)(316002)(186003)(36756003)(478600001)(54906003)(9786002)(66946007)(66556008)(66476007)(9746002)(9686003)(8936002)(81156014)(81166006)(8676002)(5660300002)(52116002)(26005)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3166;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eQLehE2JFsi+ErrDZ9uwEfQ2FlnFgs/yVK1nWKFrSFFWa+t5aSQq1aZPZWKf3Wj/VgN5U1WfuGkKtHxCr1NZXtC5MVHPWk1ZlRyHwHphLexKsuBTDjssaunlp4genId1uTANAyhXpcNQ03m3pNvQ9tk2Okb8D6fImNIEZMbaAkd7M2R+e1XjExFEtnm5pFYY8A/z35cLMtNgBKtjymHObA3RBIzGEZ7VslfMHqSne6f43toL1E2hLuAyEiCTCF++8P7yGmMPRFg9hTTp6ALNF9HayeQWGslJXweGNp6X8OKo8a1Q+Iz1ma/5iAbLY5vOL7G71L7BVwpgEkqNpAe+XgkSQpPKwkA/2mbCgtR7o0YS2g84CQsmRF562iXxFrK1J7CBspF/+XtkZHWs6YSZNhkjVyQ+TBEfwF5nw8BBTYbD6pAXCeGXLR5SkvFs+eXPgv1XPGcAizQFUtC3Y5dOOR3pyc5yliRYKCPG2XNF9LTf3mPHR5j4iV4wlMNQV+9Q
X-MS-Exchange-AntiSpam-MessageData: ILFkF7lHqTX65apy0QfQJgpNLbqbtXc0vLRwlGFaICA5e/FbMuw79ktBlwqk8jE7N2eCNHYyHMH2reDgwyZ4gk3MoDJuGgLB4dIdg9skDGgs1A8k3Oa7LrELE858XStuHrPs7N9beGb+zv8i3980zg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 604a018d-7b2c-4ce5-7400-08d7cf87f0d6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 00:11:47.2700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0GkdIPmlwZbun0sg8HVNs7/WD712a24ScgvB42QwcuPksLsSs2cS/mComowi4dT8tryi0mPVCwhcGaSuzUZ7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 07:32:00PM -0400, Andy Gospodarek wrote:

> If a smartnic wants to give control of flows to the host
> then it makes more sense to allow some communication at a higher layer
> so that requests for hardware offload can be easily validated against
> some sort of policy set forth by the admin of the smartnic.

The important rule is that a PF/VF/SF is always constrained by its
representor. It doesn't matter how it handles the packets internally,
via a tx/rx ring, via an eswitch offload, RDMA, iscsi, etc, it is all
the same as far as the representor is concerned..

Since eswitch is a powerful offload capability it makes sense to
directly nest it.

Jason

