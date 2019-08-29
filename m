Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD513A2075
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 18:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfH2QOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 12:14:02 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:31889
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727426AbfH2QOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 12:14:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQh2EhflGVUfOr0Wk8519CLjabawvKc//C+G3LHJuErptqIdzZz1iuNnXMQhLeQtKlKqqyiMmJwMFT4AC3OuACBSo4uhMQJ8tja0JNrqs93nvL/zhYOiGfEENwsWAkfnO6eHCMJ3loA1oSroBukn0C7OEYbvriGiHZvTWnzYott74CrFtmzifR4qzd/fzlUDASSrLCC8WrhGGmEctfsr0rSx2fF5RCYZInbPyKSvkaPlwovLfQrSk2uMn3zn8GmmC5r8dZ3sAXJql0ne3mKgYuCTifbSx7gXbLhqi6Z4XwXvP+tbfxai8Ns8Ao8+UAeRklRQHGsh0LG0RwdfMCb9Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99diMiIPbS3lprvPG2m79MCJr4TXA9/PgnaZ3VpbMy4=;
 b=IB+w7+i0Opq6PCtT/Z/HCXDzjphni0UfhuaYugQW892yrXuHkeagJjm14j0SLmkBHYn3LpSCW4kuCW3Yr7CXoL29eed0AmgHjQzZs+iqKRdNHZlJBDAQYue9MyfL7/JTfobneBfuU27dpg1Zoci/y1tcsuSaoNRyNfJ900kVr4izkrc8MO5wT+4L5FBB1yM94ThWJZEwPU84V+Um1Jzek9xBV7xeS1U8JXofJSDlDAsGUsB26I80Y41sOjruIg8E9+PSJQ/Er4hjasX0S+/F2CCTzuhWi63dvZjJWAgsNNO4o4mXIUbC/htZXK2LrbvMLJ1h5kECWKj4Vv7hA556tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99diMiIPbS3lprvPG2m79MCJr4TXA9/PgnaZ3VpbMy4=;
 b=AYJuNEz5g/9ucyM45nVbS3/Ryb2tQSlT31dqj4M4R6gt6D6qrwBKBvXkaSx6BUYGTpggjd6JiI7mAeKP85Mn4BOtKmSCh0yP9NPvWSGTmxXm/LToX2NkCvYQrC6gv6MiaNSXYOij7/34a+CDgWIn984KrODzNxY+arkQxHY3a0s=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5310.eurprd05.prod.outlook.com (20.178.8.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Thu, 29 Aug 2019 16:13:56 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d%6]) with mapi id 15.20.2220.013; Thu, 29 Aug 2019
 16:13:56 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        tanhuazhong <tanhuazhong@huawei.com>
Subject: Re: [PATCH net-next 2/2] net/mlx5e: Move local var definition into
 ifdef block
Thread-Topic: [PATCH net-next 2/2] net/mlx5e: Move local var definition into
 ifdef block
Thread-Index: AQHVXb+A5MC8/lvtfUyWJmfHAbnHWKcR3QcAgABw84A=
Date:   Thu, 29 Aug 2019 16:13:56 +0000
Message-ID: <vbfo908ne4k.fsf@mellanox.com>
References: <20190828164104.6020-1-vladbu@mellanox.com>
 <20190828164104.6020-3-vladbu@mellanox.com>
 <365fea71-4f35-188d-89e1-d8b97e3df141@cogentembedded.com>
In-Reply-To: <365fea71-4f35-188d-89e1-d8b97e3df141@cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0343.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::19) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca9a13e1-a8af-4975-c88d-08d72c9be475
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5310;
x-ms-traffictypediagnostic: VI1PR05MB5310:|VI1PR05MB5310:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5310FD6050F36372150AD1BCADA20@VI1PR05MB5310.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(199004)(189003)(6436002)(36756003)(66946007)(26005)(64756008)(66066001)(66556008)(71200400001)(25786009)(6486002)(229853002)(8676002)(2906002)(7736002)(486006)(186003)(4326008)(4744005)(6116002)(6916009)(81156014)(5660300002)(66476007)(316002)(81166006)(102836004)(66446008)(71190400001)(52116002)(86362001)(6246003)(6512007)(6506007)(386003)(8936002)(54906003)(53936002)(3846002)(478600001)(11346002)(2616005)(476003)(446003)(305945005)(14444005)(76176011)(14454004)(53546011)(256004)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5310;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2LjIY3zfMNHnGprQNzFBgxbZ4+RNCY5qOeltjdX7fJUhwBtwrkvZgbpZTmADANSXVygxgiW++8wfLN/1IUXmcznoxX88CzOY7IpWMEGMUKTV4zQ/mwzY9cy8GeuDRosw2IChWv2S4xq2FSDZHC33ZfflEaL/ih69DlgGJcLbNlhwbLyXHhfE2sZReisHJ7jDTQqAZdGLk7xF4qCQ+M5TUDit594PlesvOlDu0Nm0/fnGtqwT6XrhVXVZHCkOIkcN/yO3JJMUUKjgU3ynkQoCKqM51eQuNjvwazmN+8ntOwWiuEvh3yASefWdtXAo/GDyDot+TNCaktDBdBUV/1NqmZTu09BZZqw7bQ1MhMkqXxpHLt//917Sm//lCmWzSkZ4P2EzbVBDGUBfBA6v2Q1InLvXiJtHsCOttVjv4OIUbYk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca9a13e1-a8af-4975-c88d-08d72c9be475
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 16:13:56.2850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QxxogH5hP+apYBVmDVtPaLDx2wJC9ltWLkhOeni71aCE8MK1ghkVuTYGJErNYZVv7t/iEl8irYtu+vLvRcmdRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 29 Aug 2019 at 12:29, Sergei Shtylyov <sergei.shtylyov@cogentembedde=
d.com> wrote:
> Hello!
>
> On 28.08.2019 19:41, Vlad Buslov wrote:
>
>> New local variable "struct flow_block_offload *f" was added to
>> mlx5e_setup_tc() in recent rtnl lock removal patches. The variable is us=
ed
>> in code that is only compiled when CONFIG_MLX5_ESWITCH is enabled. This
>> results compilation warning about unused variable when CONFIG_MLX5_ESWIT=
CH
>> is not set. Move the variable definition into eswitch-specific code bloc=
k
>> from the begging of mlx5e_setup_tc() function.
>
>    Beginning?

Yep. Thanks for spotting it!

>
>> Fixes: c9f14470d048 ("net: sched: add API for registering unlocked offlo=
ad block callbacks")
>> Reported-by: tanhuazhong <tanhuazhong@huawei.com>
>> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> [...]
>
> MBR, Sergei

