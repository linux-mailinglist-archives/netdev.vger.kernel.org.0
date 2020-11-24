Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B8D2C3243
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 22:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgKXVAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 16:00:11 -0500
Received: from mail-am6eur05on2070.outbound.protection.outlook.com ([40.107.22.70]:15200
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729193AbgKXVAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 16:00:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9BdFVPSOvzqwsOuXPx1+/uKVGXsIqlLq3MLjwhE269C52DhvZ6nRJf+L7JZLErqfz/NUx4oVDOX5BI9gy8/fHtE6ny+t4VwgUZR7WD2Y55hfoZmkk0wMqw1eLeolGP2LaqqcUI3zuGT9DorIdFOD862MbVBY3pLnWJL/PSU5War86eAyID7Cnf1K5b4fnCroYqoFTpoOHJJnJlztNZAtTdFJlu68yb8eyHEU7ujnYiqJ0vtxikWDFDIM8FyGH/XOqQTwXP5pvRwthTr/79/vlve4zcfhelE4CV+MAjIqS8k0Wm+cOw0o4RJ5KmxxovZLEHGV8KLMy7qFY2lIi9S8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mkn2dbIpsiSURJUGtDCbQRub/yRJe1CJcdCY/X6y1nk=;
 b=C+NnPlb5valTSJvSZTPKtpNvFjIPLtv4wr2XecKInJLnsMkKZ92lDtYCJqVlJQQh+cPF+CQ1XbKuOiEASZYrvQzQLL+zwj+7aatK7v6X7tiqH4mTqXwuoYoC+uBzRrmf0ZOFUQsMsfKPQf2x5BsJAD+vAOKouJn5+kLku9uXqRtdv2kCJ7uderym7MzQ150A+ARu4FZUM6zrLUA7ksdmEpzqRC92TfCvBgEvzSSHYLB2V2RxZZH7oeLS/gUdAxQAdZBGBo2fx9FWYNllTT8K7WtZd+eyug3qCguaTka1dMWt/tBFhzTSsePFyPc+3OVsWL17nthCjEOKmbAtUWoLNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mkn2dbIpsiSURJUGtDCbQRub/yRJe1CJcdCY/X6y1nk=;
 b=jHPkB+8SDNjUW4oXUUnlyDPRGWBByeFa8i8ZCSzF0Z13NqrLzFXmKHYFISnivUP2ix2K3EXs+VEL9/JSCCUNJ1MaQkAmts7vaX301S5nOfVfreG5Hib3wjEsfFcTNsr4Rn8EG7VilaUxxB/1zJIM9D/AgEyKNi+poAW7YSgH0Pg=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3072.eurprd04.prod.outlook.com (2603:10a6:802:b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Tue, 24 Nov
 2020 21:00:05 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3589.030; Tue, 24 Nov 2020
 21:00:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Po Liu <po.liu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH net] enetc: Advance the taprio base time in the future
Thread-Topic: [PATCH net] enetc: Advance the taprio base time in the future
Thread-Index: AQHWwf/7cQfKgF/WiEqyu14LsEBgN6nWkleAgAEAaACAADLPgA==
Date:   Tue, 24 Nov 2020 21:00:04 +0000
Message-ID: <20201124210003.kyzqkaudfjl7q3dw@skbuf>
References: <20201124012005.2442293-1-vladimir.oltean@nxp.com>
 <VE1PR04MB64967D95BBDB594A286C139A92FB0@VE1PR04MB6496.eurprd04.prod.outlook.com>
 <20201124095812.539b9d1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124095812.539b9d1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9d8d2a5d-0550-46b1-6e45-08d890bbeb7e
x-ms-traffictypediagnostic: VI1PR04MB3072:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB3072B0E08C99DC2D1B38B0A9E0FB0@VI1PR04MB3072.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rvFPST48QQ5nKbCw9JbNaopK9fRMmQLs/IDQib5i83SH8HL6qfuN2k2eFfZTRnL91BN9HRjZnv9cXMRIwg34hRdoenVHkYct/ibrksNiRm76+yTdqHgT8X0wACo/h6b/rpNWaJVxVjzqivfSCYipDW6Tp6y7cfg0H63/7kCqohdNoJCSEqOxe9XYSD95KyEUBVtv1XJYl4gDgOn5Mrd4Diqf/Mi+r13hOxA0K/iTUmukypofRp1QTm8GU5wc+dUDKwjHbd2HkOAzIjZQqb6DZR7bRBz6dbRyVlZDE8/36JPGxUyPC+xu32oX6mDzouWkZc33gHmGuig4f8QhzYTNcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39840400004)(136003)(396003)(376002)(366004)(346002)(478600001)(64756008)(76116006)(66446008)(9686003)(186003)(316002)(54906003)(66476007)(66556008)(2906002)(91956017)(5660300002)(66946007)(6486002)(6916009)(8936002)(83380400001)(26005)(6506007)(6512007)(1076003)(44832011)(8676002)(4326008)(71200400001)(33716001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: olnh+x71pwN7URS18v+ZHNtktmc2fNyEZFvno8OA06fQ+iGANqk19VC0LUf0/G4SpP8vlgnWzXByM7A0nmNDmRYrT76ik4QwaoicoDGL1leqCq791FGchMhkd9SkWIWcIXBFTksNOgZKz3SrZisJI9oKxC2gHh8RCcm+4jDq77vLPLUiOoFnQ4fVssRreT7grKTuPp1TFwN8EDjdJAv9cN0RFsRLECB2ruZ7H5vjJkEFteMIt56Caj9fh+joGBp2oyq7dW5Y0M6oKOFzJu5U8pMgjfjZVz+rbMWyCM/y0LDwPIRmKK+/FFeGo/DGzQpkUyuCaCKXzwmvXiWn4Uk65AFqhZ5av8JXMvXBxa+7Zy9IiDikBQdWjkz2ymEz4UINSMMSt24+TXzo99bmUm2Tg/la3qBFJaj71SdMT9ETj0pGJRfXUdlRcbCNMW8Mz3aXdu+KLrujoUrKpqmTWAcXCdoVEq0HzfYT9hKNxX7Ykd065Gwt91SAqzdpcmI63L8ifZdghI84njep9nRA9kQL4sfPPpRVN3GP/xhzDrc5VcZVdHDkVN2AZzvwMy0s6dSiovf60+v9mzXTUSnr/DmpVwkuOps/HZT84X+vo47OmoyR2AH25qOQ8qEWaHo/rbUloopY7czJ9/chuAuPeLQGJQqY+yZFaQ/NjiOyvspt7fesK6h3D+rpoHAtitS682Gj1SdnIjaA1BdgXrQsz8IpO3wXIBvp8OqFMAZQcAk9o7h9BGB3w4Kt4EACcpDvDX6kZAXeztTIP5lHlSwL7Wm4ftoaHZq9792y7lINK0614Rs4xtPeVFXlloIpYDu0/uTkFPwpt3mnlHpPjGyrXPCi2HK7jBKhFT9aU2y1kJnqESHOVfUwK7Utyv+CezG3vKZpyen95s+0fCtqsQEr+6JNLA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <136314AA3045A7489185E5A2E8479A31@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8d2a5d-0550-46b1-6e45-08d890bbeb7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2020 21:00:05.6371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ujYPAvvn5n3CZxShf6AZv2jne55hapLHP80YiEpFYut+oVAmwcDUlxI4xjdhDzecbE40HLV3DgDnzbkgjQZw+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3072
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 09:58:12AM -0800, Jakub Kicinski wrote:
> > This is the right way for calculation. For the ENETC,  hardware also
> > do the same calculation before send to Operation State Machine.
> > For some TSN IP, like Felix and DesignWare TSN in RT1170 and IMX8MP
> > require the basetime limite the range not less than the current time
> > 8 cycles, software may do calculation before setting to the
> > hardware.
> > Actually, I do suggest this calculation to sch_taprio.c, but I found
> > same calculation only for the TXTIME by taprio_get_start_time().
> > Which means:
> > If (currenttime < basetime)
> >        Admin_basetime =3D basetime;
> > Else
> >        Admin_basetime =3D  basetime + (n+1)* cycletime;
> > N is the minimal value which make Admin_basetime is larger than the
> > currenttime.
> >
> > User space never to get the current time. Just set a value as offset
> > OR future time user want.
> > For example: set basetime =3D 1000000ns, means he want time align to
> > 1000000ns, and on the other device, also set the basetime =3D
> > 1000000ns, then the two devices are aligned cycle.
> > If user want all the devices start at 11.24.2020 11:00 then set
> > basetime =3D 1606273200.0 s.
> >
> > > - the sja1105 offload does it via future_base_time()
> > > - the ocelot/felix offload does it via vsc9959_new_base_time()
> > >
> > > As for the obvious question: doesn't the hardware just "do the right =
thing"
> > > if passed a time in the past? I've tested and it doesn't look like it=
. I cannot
> >
> > So hardware already do calculation same way.
>
> So the patch is unnecessary? Or correct? Not sure what you're saying..

He's not saying the patch is unnecessary. What the enetc driver
currently does for the case where the base_time is zero is bogus anyway.

What Po is saying is that calling future_base_time() should not be
needed. Instead, he is suggesting we could program directly the
admin_conf->base_time into the hardware, which will do the right thing
as long as the driver doesn't mangle it in various ways, such as replace
the base_time with the current time.

And what I said in the commit message is that I've been there before and
there were some still apparent issues with the schedule's phase. I had
some issues at the application layer as well. In the meantime I sorted
those out, and after re-applying the simple kernel change and giving the
system some thorough testing, it looks like Po is right.=
