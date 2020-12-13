Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA8D2D90C9
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 22:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406647AbgLMVcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 16:32:16 -0500
Received: from mail-bn8nam12on2135.outbound.protection.outlook.com ([40.107.237.135]:64430
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406618AbgLMVcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 16:32:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTxqjLWHMR0E4stPuMssI4jK/pUXd4WX0l/65CRYBFC+/eeXJYiSvbWHB6pNGymz1Nu/sILqFxem4b3dH8skbsmf/T5/jYlvfvj+zk8SvkeZSbI2Kcus4uVZ6MTwq91nsGT0xfTRdnrNchgkI4/gB85KS/8WAymegR3vVU6MX3E8hkZjUMHknhzkiq0hIoDpQkuKlLnERBVwUmG8D32IrFoDuJ3L0PSdrGX/gPR3aUbM3efRHNfgQsDvSHIxZqarVgepg9xJM3MALqAsmc2u/8NqKq0rZdM/gLDt7URnbGjcxlo5pySk96LtnLtOetQSls/jF+WDbirP6q5ISMm8nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmfvUAi+gy2400B/UumrBdjAP/FYH//ZPsvHNpYiAMs=;
 b=V7pf+6XNAaGW05HAxnlZMdoolnp7wRgDEpuW3SzP7a57wIvVxJ6Llbi0BGnpG9vr7XciaN2OXkSkaNUa62z1oNU1a/9KXu9o00FSPiduzFC6Co1LctD8h2wWoRKtg93cui+BycFuSNdyj6ugdGZ5hUfIUUmXQR58n5UltHyh+VljCmrPG6qkjTDjbfFMawNHCYX+j6nw+CKU9Iji8XHW0nxRjmB2WRPXDATEI1QrCS/BY+QUbDn+hSSh7hhG3l2fVeSkyaMUq+oH/zXTicqzu04vkv9BavbQJzuiHG4RS+5jsDQfwiEMamElv7jLi6jZz4WsKNkg6z9rKYJoQ12g/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmfvUAi+gy2400B/UumrBdjAP/FYH//ZPsvHNpYiAMs=;
 b=NoN95MdgdZmyCgvVeZSb7fIcL+6ay6u83jl2eIttnMV/s5yBIGkviQWFY0pv7axdCpzI84pSYcBi//CBtLh8h5hgIcU7dYCgZSi4sL2Hxy7EKvwi6rmbKU8fBWHQGxOUlY3GseIHT328W2RheGrOFbZQvGWimtidbFu641D/D/A=
Received: from (2603:10b6:302:a::16) by
 MW4PR21MB1908.namprd21.prod.outlook.com (2603:10b6:303:7b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3676.5; Sun, 13 Dec 2020 21:31:13 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::b8f6:e748:cdf2:1922]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::b8f6:e748:cdf2:1922%8]) with mapi id 15.20.3700.004; Sun, 13 Dec 2020
 21:31:13 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Juan Vazquez <juvazq@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] hv_netvsc: Validate number of allocated sub-channels
Thread-Topic: [PATCH] hv_netvsc: Validate number of allocated sub-channels
Thread-Index: AQHWvcArHKNiz0JRYEOFtu/aejjXH6n1sp+w
Date:   Sun, 13 Dec 2020 21:31:13 +0000
Message-ID: <MW2PR2101MB10528F523D391FC902C284EAD7C89@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20201118153310.112404-1-parri.andrea@gmail.com>
In-Reply-To: <20201118153310.112404-1-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-12-13T21:31:11Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=129927ae-4213-4d40-acd0-761d39ad6b6d;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bea10611-901b-40f9-d42a-08d89fae6a98
x-ms-traffictypediagnostic: MW4PR21MB1908:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB19084CD7351BE93E516C3B02D7C81@MW4PR21MB1908.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:862;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ISbpP8PUPvwieThZyW+d0fblvufqDXv0z368OdXW5Z3B32xuO36Gazk6m0VRbTrSo+c+vHO//FXvkRuiFVnWd5qtU9HfEdFFZNzpbYQnoO8wQja8+konYSQ+c0pk/cQ1z+CpLKKPknUXVKBy37ZH7bqcIh/IaO3KMitH6LB05qXNttuYKtmt6FAwWX6Crc4sM7Y9aAtVq2qPv22ctNwGMvBB85gEAI3N+jychLgF6bPxrEXWV1uKLpKZ/kvuM0T+C9yfrxhNl+cByxG1gWHDjQi5HB4dkKlk81+gma3ge8XFvrofU24HzfBy7fzVUkCAOnkCdybnYuJIM+y0ObB33cEtN+qOFBcLuRbVmq9HKcntEnAqiT9QCzDG/a9ZEY9ykEdzr1lOqCTZK2OuKcbV4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(66446008)(82960400001)(82950400001)(508600001)(76116006)(10290500003)(8990500004)(52536014)(71200400001)(26005)(186003)(4326008)(86362001)(33656002)(5660300002)(7696005)(6506007)(54906003)(8676002)(55016002)(8936002)(2906002)(9686003)(66556008)(66946007)(64756008)(66476007)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HhfDV7SDSUs7s4FkE/ph4CJudd4X7MKL+mIrgLILAML2fbR1ZfxVnQlJPTJs?=
 =?us-ascii?Q?7otv47dciD1L5E4eYi9z93YS1Fk2OW6wDSSnuX9CT0dRF6MZpvQS3LFN3xGB?=
 =?us-ascii?Q?jhgk0ZhP39bvZc3g6oR7QKFwUAIFGglQa7o+SstkR1jYj1tEbPZFZ3rmzDK3?=
 =?us-ascii?Q?dA1oDSYOAjkvBvZASlLN9g60D+5m225xR81DVlgMVYP9u4J2mumQ8fzG1PnW?=
 =?us-ascii?Q?rc56VxOLilrkB5rhR7aGqPKI+fp22Q84Zs7s0Lsf5iYv0a+dRfegcSB2BUGo?=
 =?us-ascii?Q?21PgHzJA+xhf44i6fI5z6u5/2Cf0GHc+aVu4PluGz+iqGNfB1+grYB0kIPky?=
 =?us-ascii?Q?jFW4OYiWpdQniycixN34s3ukQbD019hm8oZJWv+ilJaxs95f/i4BcwWxV3Uq?=
 =?us-ascii?Q?/aS2cpfIhPGtZEXPC1efx5aLq3sKgr78tsJg3qbCIp5fWaVmRv4+cfVWZQs7?=
 =?us-ascii?Q?r7J/DNce9bjLWppz4VsIV7iSIo8J+l39M77CBcUnPqozh4pYkazcOK1KrSwG?=
 =?us-ascii?Q?XBoWFH9FGbgP+P4sHGOH9o74D3wzM+gu1tCyr8UflkyzPjmG/lDy7YKHPo6y?=
 =?us-ascii?Q?SEARRy7tJdhOQM6OtKv2BdyFBkxI2I+r+/iSPAaI55V6lM7JuLCAwuta66Fy?=
 =?us-ascii?Q?cZR9H5yiY/hBhLtVuPRq3M05Aps1K2fOwMEQ0AQsUv/3t/wpUeWcV73s4SYn?=
 =?us-ascii?Q?BlESezL3sg8jhHbCZdVGb1XABQrTBC+CAREMqXmjBryQYghTENBtGUkVro9g?=
 =?us-ascii?Q?aGJo0w6wUNSCC+z3Y/z0Sc6DM6EW8WfdIiger41jL4OVE2hGfwt7cJSmddWr?=
 =?us-ascii?Q?R+J6RUGD7+02e2QBa3qH+rexvY9Q7nLU2jHpto6g7q2YZZi60TBWy66enKwC?=
 =?us-ascii?Q?4qFGew0Pv7pjmbuTVzVhz9DFz6dQq1wc09kGJpbyLJqcN9xJLVnwut7aqKSQ?=
 =?us-ascii?Q?M1wC/7BTG7Nngmw5MiwtZrXiaft/vXbdP/JF6SIbn+o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bea10611-901b-40f9-d42a-08d89fae6a98
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2020 21:31:13.3262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xt06KoSjFrDdR8ETPROYkpfigKifpChAKqwDUXdNgDEuTQmCdvCubg+f9YHwD5KiSc3JDfv9TdhGTMPoK/xvXaGBHeZN6XxqRkFSvDrl7SM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1908
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Wednesday, No=
vember 18, 2020 7:33 AM
>=20
> Lack of validation could lead to out-of-bound reads and information
> leaks (cf. usage of nvdev->chan_table[]).  Check that the number of
> allocated sub-channels fits into the expected range.
>=20
> Suggested-by: Saruhan Karademir <skarade@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
> Based on hyperv-next.
>=20
>  drivers/net/hyperv/rndis_filter.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis=
_filter.c
> index 3835d9bea1005..c5a709f67870f 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -1226,6 +1226,11 @@ int rndis_set_subchannel(struct net_device *ndev,
>  		return -EIO;
>  	}
>=20
> +	/* Check that number of allocated sub channel is within the expected ra=
nge */
> +	if (init_packet->msg.v5_msg.subchn_comp.num_subchannels > nvdev->num_ch=
n - 1) {
> +		netdev_err(ndev, "invalid number of allocated sub channel\n");
> +		return -EINVAL;
> +	}
>  	nvdev->num_chn =3D 1 +
>  		init_packet->msg.v5_msg.subchn_comp.num_subchannels;
>=20
> --
> 2.25.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
