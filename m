Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54795D502A
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 15:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbfJLNru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 09:47:50 -0400
Received: from mail-eopbgr690134.outbound.protection.outlook.com ([40.107.69.134]:51360
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727115AbfJLNrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 09:47:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcaVPgZid9f49/jJJ0vri7FJuH1H2XPkh2BDLOrjZur8c2BNoCbA9a+OAqa8qvE2XN1I0zHoftSUgQ3Jj+bXyWCz4K2JQhHzcLG4TpjWJei+puzDFv1yr1iPjV6SlxPuPJ2CO4UHnnQfPMPLDfP4xixXYpPrGtkQp/zlVYT9a3Q3NWUeZ5hXNzBPHt/w5xUd8MT1Ui9xxTfTz5OvqHBWdXnX3z6GhE1mjwtKDrPfyku43hGXQoSPdlHaW9KFP7DNBRIVe5J30hGXUBbtbvRdWROgUKZW40XI1FMsSYBxyMTWW0hYgOFtE7sHPCaF0MxOqZBRCfqoD0loqbXD68fbpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klEGAeZOuCgnZ26joLgkBsAeo/3i/DL8hZ8sl5DK58w=;
 b=TakQuJtZBp+3XOi6CD/wOWYvNgeDPZCPQppyURmTjxpBBitcp7m4qQoXHFNTgdcdxLuuzlinHXfD08WHZN8uuyKomfUf3w7DpQ0eCdZvJKUEw/Mx1THuBXYAW6L0+AWVdBJoeze604XNXteh9EwwSPra4eh1ZnJ5IIBv8LcqOi1XKtov1eWPKsdA+hpBWogL4oVC2bd/xhXUNAxZOLuxc0vEBC3SGG4r6FV0MR88QxhlL9SeC7Twkv1x6a2k0Tre84vOPlu6mE4vs4oSfTs6IZ6MLjg/UI5Ur6B0MF81VTZVPN/BzpqDn4V3J1HJr+AsYb747sAYri0rEGCwdvSuig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klEGAeZOuCgnZ26joLgkBsAeo/3i/DL8hZ8sl5DK58w=;
 b=b+gv+pVNCX6WigCKI4E/BqiJd1pnSlGl6pzIl9rO+sjc1hIFH98KwHMcEXtCTZcm291s4n+qiENHlDPj18d3ILqTM0q71FNJJTYJuezlre8vf4bbCW8YBnCtQLfXm3/cPQlC+IQrOw7WWrnihtksSeH/C70/KHstawa8t3OC9x8=
Received: from DM5PR21MB0137.namprd21.prod.outlook.com (10.173.173.12) by
 DM5PR21MB0170.namprd21.prod.outlook.com (10.173.173.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.2; Sat, 12 Oct 2019 13:47:45 +0000
Received: from DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::a50f:aa3c:c7d6:f05e]) by DM5PR21MB0137.namprd21.prod.outlook.com
 ([fe80::a50f:aa3c:c7d6:f05e%11]) with mapi id 15.20.2347.021; Sat, 12 Oct
 2019 13:47:45 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Andrea Parri <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        vkuznets <vkuznets@redhat.com>, Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH v2 1/3] Drivers: hv: vmbus: Introduce table of VMBus
 protocol versions
Thread-Topic: [PATCH v2 1/3] Drivers: hv: vmbus: Introduce table of VMBus
 protocol versions
Thread-Index: AQHVf4Hg40bNBUJlOE6Y2bup7gaANadXBJtA
Date:   Sat, 12 Oct 2019 13:47:45 +0000
Message-ID: <DM5PR21MB013798776480FFA5DCD22442D7960@DM5PR21MB0137.namprd21.prod.outlook.com>
References: <20191010154600.23875-1-parri.andrea@gmail.com>
 <20191010154600.23875-2-parri.andrea@gmail.com>
In-Reply-To: <20191010154600.23875-2-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-12T13:47:42.9929354Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7b229e38-2479-4489-aa72-6716b77a7d61;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf855a0b-116d-4271-33db-08d74f1ac2df
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR21MB0170:|DM5PR21MB0170:|DM5PR21MB0170:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR21MB017025AF787F82D8F40F26E3D7960@DM5PR21MB0170.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0188D66E61
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(189003)(199004)(26005)(99286004)(8936002)(256004)(2501003)(4326008)(9686003)(52536014)(14444005)(22452003)(14454004)(33656002)(55016002)(316002)(10290500003)(486006)(71200400001)(71190400001)(478600001)(186003)(446003)(11346002)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(476003)(81166006)(81156014)(7696005)(6246003)(76176011)(6506007)(8676002)(107886003)(5660300002)(2906002)(305945005)(102836004)(66066001)(2201001)(3846002)(10090500001)(8990500004)(229853002)(6116002)(74316002)(6436002)(54906003)(7736002)(110136005)(25786009)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0170;H:DM5PR21MB0137.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aXqj7ad1qJ/KFlb8pSHvbbX7CKhD/NVq2lrM4Y4hhWaUjOOsbTFn2ug/Wq+7cBdXB2XlIWoXGpce++YUFx5DrNb+UsH+Y+olFG1C/zZT+J7o1Id3gG3SSS/g5mlpFSCxcysdhmvaht/vHFYlVG/P0X9jwWDeyls3xjmLCjvy9KJCY72eXOdpo+evhEFMxPwAj3URcQhH6bAoNQenBYtodiqK+aNfpvpex9HvBmq9fYGJy3a2KidXRvrVKZ23MOeboIJmPgkFxU04cutckz0SAgMaEmKBw5OW8KPyY9tehfRb63Np9b4ugLk6gnArKPn/GcO6U7p6vSaMKy+aryv/0U1Fbc1GpcyUZpfqtdbxsnHROVNI/VXgLy3aCvqLEpE6Oha1J7R9GekMC8aynNGHtmCPy4EAMp7fMzr2trjM08k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf855a0b-116d-4271-33db-08d74f1ac2df
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2019 13:47:45.2526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9D1jlBvfV3zqXufaum9Rocd15HQJGotiOqsWxdWlxo0rVD0wZUg3OmuAnelAyYiJf2gkAhhaBl0FFHinWsyukMR05J/6Jq3fWr8E+7n97dY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0170
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri <parri.andrea@gmail.com> Sent: Thursday, October 10, 201=
9 8:46 AM
>=20
> The technique used to get the next VMBus version seems increasisly
> clumsy as the number of VMBus versions increases.  Performance is
> not a concern since this is only done once during system boot; it's
> just that we'll end up with more lines of code than is really needed.
>=20
> As an alternative, introduce a table with the version numbers listed
> in order (from the most recent to the oldest).  vmbus_connect() loops
> through the versions listed in the table until it gets an accepted
> connection or gets to the end of the table (invalid version).
>=20
> Suggested-by: Michael Kelley <mikelley@microsoft.com>
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> ---
>  drivers/hv/connection.c | 46 ++++++++++++++---------------------------
>  drivers/hv/vmbus_drv.c  |  3 +--
>  include/linux/hyperv.h  |  4 ----
>  3 files changed, 17 insertions(+), 36 deletions(-)
>=20
> @@ -244,20 +232,18 @@ int vmbus_connect(void)
>  	 * version.
>  	 */
>=20
> -	version =3D VERSION_CURRENT;
> +	for (i =3D 0; i < ARRAY_SIZE(vmbus_versions); i++) {
> +		version =3D vmbus_versions[i];
>=20
> -	do {
>  		ret =3D vmbus_negotiate_version(msginfo, version);
>  		if (ret =3D=3D -ETIMEDOUT)
>  			goto cleanup;
>=20
>  		if (vmbus_connection.conn_state =3D=3D CONNECTED)
>  			break;
> +	}
>=20
> -		version =3D vmbus_get_next_version(version);
> -	} while (version !=3D VERSION_INVAL);
> -
> -	if (version =3D=3D VERSION_INVAL)
> +	if (vmbus_connection.conn_state !=3D CONNECTED)
>  		goto cleanup;
>=20

This is a nit, but the loop exit path bugs me.  When a connection
is established, the loop is exited by the "break", and then
conn_state has to be tested again to decide whether the loop
exited due to getting a connection vs. hitting the end of the list.
Slightly cleaner in my mind would be:

	for (i=3D0; ; i++) {
		if (i =3D=3D ARRAY_SIZE(vmbus_versions))
			goto cleanup;

		version  =3D vmbus_versions[i];
		ret =3D vmbus_negotiate_version(msginfo, version);
		if (ret =3D=3D -ETIMEDOUT)
			goto cleanup;

		if (vmbus_connection.conn_state =3D=3D CONNECTED)
			break;
	}

Michael
