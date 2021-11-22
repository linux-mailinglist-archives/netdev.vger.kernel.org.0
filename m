Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5F54588C7
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 06:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhKVFVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 00:21:38 -0500
Received: from mail-dm3nam07on2065.outbound.protection.outlook.com ([40.107.95.65]:13153
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229505AbhKVFVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 00:21:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1auRPx39nQWvCCPJFvK9RuffnVkXa4Wc/yrtRzf8ehEgbKdGvHvAAG7FIsPtqV4kY4E04lLZgTRdv7l+o39YdmuDBzEB9PH974ioco0IMidd7siC8nZzgvtHRDoHcKrXVDSvx3TMcVYcI3JFc3dAOwOyDI3k61oCgBkHHwvS6Yx3OIUHzqO/z83kkYekgRH4qPl6piTPmRDwLfG51+nGcDVYBbnZORZF95gEmxhU7XlHFRB8NuQnD6iYZZyovoR1utWMZds4Tt2jlGniNbs9UFwSbrqyoOGUY8N9GQ0J/0Q1xaHE9sfqW0ZmfPiIrDJwq6wIDLdSzQN+WmimgX51Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1DhbUxa490+hheY1C2F5eDrECSFC1c0PIgC//vpdgLI=;
 b=NxEFpQ8K4SLEvOOclPrO5s1veajksYi9MyCDUbP/JiWfE5roNQf1KMkBf50bvuVm//FDeAdwns9fxh4zE2WrrZ6ZtXKQa6HM/k7Q1ULypQxGgl/gMKn9xseMsiouKA+SISZgKjvRQaAjL1cHbrFSmbHlMEWJYQLBAOvXScOjbKrYhvGyKeCc1aJsrkQ+XhdjwuQUx0miv5LXZ0+4wq0Lrb7yOTRtJnbYBwlu+U9vcmjZU8uzs8/tOk5g1ajXErAT0Se0CMWTHAMmd1e+ZyRszGX6QS3PlUPohhBbQ/atbosH4V04fGxdArFqRBLhRxxDx95IjV3y7rVhpqlRul2cIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DhbUxa490+hheY1C2F5eDrECSFC1c0PIgC//vpdgLI=;
 b=Uc8asu0zuBmQa1uHzLQg0CMB+opHwrcjDGPW3Q6OodaatAOPKE+kRdwOBjRmwfcbGxnU6GAu3Gy+II0T5dBbcdqxYwIfzY1fL3Ojcl3l3u/c6TBLzaPJbDoNGX+cCT95fsHfZKFJTUTn5f72vRHTRnP/liXH5dSIvTVCzZ2hvyQpRhyGVGpDL0AHvVYftgwZNmHuGjplYD3+9vo0Kv6mlABZpWMEb0mzbFchxzCCLr2nHCmGDYVzLXskEbJz7WTPsEkFp0TyRWstmSYzDZKn17AU2fdlLwoFiAQOa/XkfctzxPLIx1V+cBA4eCLVBD5m/zJxWTuhDQY7vWRDA5Ph0w==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5401.namprd12.prod.outlook.com (2603:10b6:510:d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 05:18:30 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a%3]) with mapi id 15.20.4713.022; Mon, 22 Nov 2021
 05:18:30 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH iproute2] vdpa: align uapi headers
Thread-Topic: [PATCH iproute2] vdpa: align uapi headers
Thread-Index: AQHX3KYeo+q44itHa0+iVFz0BpQheKwJlb0AgAVIghCAABZrgIAAEsHQ
Date:   Mon, 22 Nov 2021 05:18:29 +0000
Message-ID: <PH0PR12MB5481DFA1C8135CA639150F4DDC9F9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211118180000.30627-1-stephen@networkplumber.org>
        <163725900883.587.15945763914190641822.git-patchwork-notify@kernel.org>
        <PH0PR12MB54816468137C264E45CCE9C6DC9F9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20211121201111.043f8be9@hermes.local>
In-Reply-To: <20211121201111.043f8be9@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eec3d48c-b3f9-4e38-4a4c-08d9ad778573
x-ms-traffictypediagnostic: PH0PR12MB5401:
x-microsoft-antispam-prvs: <PH0PR12MB5401AA9F71A4910D37E68D87DC9F9@PH0PR12MB5401.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:78;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l6lK2M7ArGM9Z54jE3Oho8py7tGAejKLBbJCP4q6raTjDVApWvpnDIMni7JTdhpWWKxcCh9nr5KUwnyTEIP/AqZClmtm8UIOw/EIghJnOXGU3xwsHVtTMwljZa/Oz21PiA8oWS/q+ZVsciUD2UTIgMDdzDJ/pHYyfmkSY7pYf5YngH7dy0fQH5WBwdRrvm1oeASJ4VueiOKe9CHFOo3GMzE3FUjsfsdyJyTpWOAYWeCDNWKrSdQfdbyLQtmTxpUt0GAv2aUzkvyjeY05c2aaIFMTX9TYQcHWR6OPwX+Nmdf5icthM9vBFTOW8v3Y6s6uwKU1QnUdiUpbsEUxze9o/rP8Ti1Vo2Je1TVTk2D6uup3kRaHUwg5Ph967VHvSF3eBXFiBNxasmf8JMrAbb+BF060JTe/t+Lp2SafW4aKXlPARBCOSADXTql8Vtwjb9oWOgcLQofDxygMEJbXGeAx3f8Jdv2K3H11Y7do8EF1WWSIjTxmbPuk3smYIQ9WE8Ft0Wed9mbDC8/jxcaqNDiU6OWRB1fx9efqrbsjG8ynqZtMVVbWjewtkjZJ1DJmhkeM2+gx5CxRW5x6ioJnxaDGIUtj81WVGNCf35VZapT18wW53v+Io/E/eRwinOSxzisrdua8DZ1qhsEBgwSWtJ13JhqgWAtNqu6OnySLDtMbVbwDVMtnvpkH6QC8HXqzQN20rFjrx4AH8MpoG+3K7eJmFCwZH9ZS1S2sxC4Qjey03Ccys0X1qD2zOK6QkLI4bnT3pnRSYHYhCpkafL/fkQcdOTIl42Q+ebR8fJ/5pF8Gti4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(186003)(55016002)(76116006)(38070700005)(8676002)(66946007)(6916009)(8936002)(84970400001)(83380400001)(5660300002)(6506007)(55236004)(4326008)(26005)(38100700002)(7696005)(316002)(122000001)(52536014)(4744005)(33656002)(54906003)(2906002)(9686003)(66446008)(66476007)(64756008)(966005)(508600001)(66556008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hnmkM7O8REQkXDObfRn28hv+z1eN5ssTev9Sh8N38Ce5YAimo+oWlssTchms?=
 =?us-ascii?Q?0/1qZANQospJkI0A6RfpliIzq101rrK/MH+LSlRL+EsAt1MZ2kitj88OELrA?=
 =?us-ascii?Q?IutwTZPkxk0AdcrKxN+0RuD+KFldrwOOx+NZJFWwLMGFBpCKKVMkZiz2Ub6u?=
 =?us-ascii?Q?Nm4rTE/zTxIHz9yTrSrh4XBBQdjjP8HNE61/70IWmpsfsCboUjKtocUkyhUE?=
 =?us-ascii?Q?N9JgGl3Bni4GLMCTXjWwEkNBt45RekaMg6/BYbAnssHyp5ZJH5JqXJhxJqb5?=
 =?us-ascii?Q?YqxwCBkF2HxZHzUKHSPbDvnLgHDTW3onivHkwNPmlUZE0tbVKUHOLoadTFBk?=
 =?us-ascii?Q?nK1qpTGfOCF4o25kzTdwPePyQIk7i9+sfRf13YLAhNsoOiksSr6xfqBD9iPk?=
 =?us-ascii?Q?Lp1VSLkGPKnHe1qappq0kiEODcCMmkgJol3cuxKS/4IA1o5R0q5Tmnl64VVV?=
 =?us-ascii?Q?y34pOMMOGRHcH/f2CdPtI0N1ou2eIVzy/nD8bD6NFznO73+mXwasbx/gVWE1?=
 =?us-ascii?Q?XlamVfaia3zzjgVcJIj6sLG6xmugZ4+NG7ki0RFHbXbAtdjri1dmvx4T2oy5?=
 =?us-ascii?Q?LzcgTE6t4cn1D0tpXe+bSiyO5Yx9OxPDikADo840mOk72juG7nty+jh4uwYP?=
 =?us-ascii?Q?xUk2YkVcjQgzxMRhFjtQNIo9mDMLnmmLtAQ+CfIIzb1xfXMuv2SLLQfDW0eQ?=
 =?us-ascii?Q?zOSri8uPzix40Sm0gfz5LAwSlR+hM368VNlEdBljPxCWMKCDvGU5tI316qXc?=
 =?us-ascii?Q?1lSLxAV8ysqv2Rmum9Lg/e3s/dUrt5AKNHU9g/rB0TZ3zzpJQSyF8yFCeNUd?=
 =?us-ascii?Q?1LkemB7UWhI0BMohslO61L9j0BdWn/u+zSVxqFDfW53ayyUQGZeyaWjn49wC?=
 =?us-ascii?Q?i01NQWTx40IKPIDgbs+aGIbCia0LDVlGBV3nlyT07uJPa2+B3IjvcsQR+KtB?=
 =?us-ascii?Q?x0q66wp+RuTSUhss0UYzvU1QT739T13W0QT+BwWimfuBSEUYGn8EBjVNSZHX?=
 =?us-ascii?Q?Cw8V3dd9Hps2WaE+YjuMJ8TpWs6CdqW4wUugoJR/kIGIjUc59MDRFFzA09j7?=
 =?us-ascii?Q?nT8qmNfDgQMH8dGBUy11mmr0oAIBDSEZ1cq7RQiptcyUECrl3qI021PG692E?=
 =?us-ascii?Q?VA4PCF3U8bDS9JZrcWG9v9lGAjoBtCQqd+HeBPdvfQiU3UdrdjaTzGBchWSx?=
 =?us-ascii?Q?0nHTUPdE6H5KYQD4301QgQHwyw4oIAvwzqbDt9Z2V3YLA8vxIE2rrtJUvfqk?=
 =?us-ascii?Q?C03OaNnLjGi0J4L5R+89RAk6gRbTmYdCBDY83TOfYRMtUix3MQdKWJULBgqN?=
 =?us-ascii?Q?wmCTDcsut8jZ/FYaJw5zeTMldlRu49rGcj9JwSqfgZ6j0nmtpuZTbyynHNtx?=
 =?us-ascii?Q?Kfm6BrXZ5UVI4fPMBqsUIRO87zf5gNYC2BkosA0JHtt1hDuVOHDwchrteuCP?=
 =?us-ascii?Q?YKvMaksFjmdOPu97WLB0mqKJlqHoKoJx5Ly7iSnph1xHRYW2xpuopjP6egn/?=
 =?us-ascii?Q?oQTDeBGOV9NR2zad5rvQBmGhwswK1cBzLivNdADfOSx2HW4JVn4NhxJBli9P?=
 =?us-ascii?Q?WY5NSx2xFN4XtpIBo9fe9Ds+lMZW/L7lVOPNWWtZ2jfwrvU6ROturAXvIAvo?=
 =?us-ascii?Q?Dbuu1LEb2xR/R4V3KYh43TQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec3d48c-b3f9-4e38-4a4c-08d9ad778573
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2021 05:18:30.0518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pZnpjuQ+kdXuSvXoI/taq9rcU5OneXFmphHXM2dGp14N9gL3kDxwRcmqxDjc/jSSx3gvI/rwVB4t16ZghSQppw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5401
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Monday, November 22, 2021 9:41 AM
>=20
> On Mon, 22 Nov 2021 02:52:29 +0000
> Parav Pandit <parav@nvidia.com> wrote:
>=20
> > > From: patchwork-bot+netdevbpf@kernel.org <patchwork-
> > > bot+netdevbpf@kernel.org>
> > >
> > > Hello:
> > >
> > > This patch was applied to iproute2/iproute2.git (main) by Stephen
> Hemminger
> > > <stephen@networkplumber.org>:
> > >
> > > On Thu, 18 Nov 2021 10:00:00 -0800 you wrote:
> > > > Update vdpa headers based on 5.16.0-rc1 and remove redundant copy.
> > > >
> > > > Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> > > > ---
> > > >  include/uapi/linux/vdpa.h            | 47 ------------------------=
----
> >
> > This will conflict with commit [1] in iproute2-next branch.
> > [1] https://git.kernel.org/pub/scm/network/iproute2/iproute2-
> next.git/commit/?h=3Dmaster&id=3Da21458fc35336108acd4b75b4d8e1ef7f7e7d9a
> 1
>=20
> No worries, Dave will do a header merge.
Ok. thanks.
