Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE162A99B0
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 17:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgKFQn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 11:43:57 -0500
Received: from mail-bn7nam10on2068.outbound.protection.outlook.com ([40.107.92.68]:31456
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726867AbgKFQnz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 11:43:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Slxl8l++G/OGuwNPkWlKr0dxxEd+7O1t60VhXzCqvVUD4uarNuH1YjbWE/Jhi4J24yz4peJfw3wZollxIsoDn/wU9PtK5x2HpPIyYCchO2at0DELZ8fEMYwt1xzvpSEu/mD6ggBKL6O+GwwY6KpkiiG0uOdNwk1eDJw8jX1gr/MsI3Sqq/9FsyQ1D+4w4bt/1O2RdHwAZfGWjcsqtxFPPOLoNW15FDqEhnB3uyCUjpdtghQsFJqFCZdX3b1TmsJaH/HVh7fobl0GviGsd4yNdQZFw+nNVP67fvMkISqA1NxXSew/cuRzBS+1lrUrdMgnabdR2ZX4OqupaKUYWv1sFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn0DkCT1+fyVMdV+/liiuE177Ba5DLLcEWYElxtGbA0=;
 b=AqCAyMtdvTTDjS518PM5/t4inPn/tMkQ4hgkZvfDssQpp6WzCvQ1j0bD0k0hVpdiCXZpnaQk7uEW6xdmvTmOSLfUpqsO4zT8OV5w5DStqhFk7MK3CxFXQk8UV6FOWcW/qhMRuYSNOgM9kZmIEjEjThbFEOrUnb/t9lyAYnOpLTMYb9WuyefUJY96VLrWBE7jMRG7jPzWmM2t7GRm6gS0nbgUS9k+sg+DzJnoP6YrCa2rb4n7odkWx7cFO3swP3EV8dsJoGBRkKgTZERMjIRogb6vgIZlVT9YyPsG8uA8IQD10qVZ+wkSOctevwdRImcC8038xZGU2ncEtYw+0gFcPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn0DkCT1+fyVMdV+/liiuE177Ba5DLLcEWYElxtGbA0=;
 b=Uxw5FkeAgggNXJ2pnOjck99Vj9SsvuKd0i31FEW1Bfj4Thsa3kNSuqubjZ9BeMD4SNRr1V/PaQ7KL2z0f1QjWqRV9/cCqXBjKZKuZ9pxzJD5MSnmtVFm1cUppLcqwgyjsJ/+sDhbQIw/uJJGBk32dsfKcWbZZlWw+mR1fhVvAYU=
Received: from BYAPR02MB5638.namprd02.prod.outlook.com (2603:10b6:a03:9f::18)
 by BY5PR02MB6404.namprd02.prod.outlook.com (2603:10b6:a03:1f8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 6 Nov
 2020 16:43:51 +0000
Received: from BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::c04a:e001:49fc:9780]) by BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::c04a:e001:49fc:9780%4]) with mapi id 15.20.3541.021; Fri, 6 Nov 2020
 16:43:50 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Michal Simek <michals@xilinx.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/3] drivers: net: xilinx_emaclite: Fix
 -Wpointer-to-int-cast warnings with W=1
Thread-Topic: [PATCH net-next 2/3] drivers: net: xilinx_emaclite: Fix
 -Wpointer-to-int-cast warnings with W=1
Thread-Index: AQHWr63uS/hX4KZfZEO8S/T67co/NKm0cgKAgAACKYCAAp5vAIAERaIw
Date:   Fri, 6 Nov 2020 16:43:50 +0000
Message-ID: <BYAPR02MB5638FFA54D46ACED52AB1A52C7ED0@BYAPR02MB5638.namprd02.prod.outlook.com>
References: <20201031174721.1080756-1-andrew@lunn.ch>
 <20201031174721.1080756-3-andrew@lunn.ch>
 <c0553efe-73a1-9e13-21e9-71c15d5099b9@xilinx.com>
 <BYAPR02MB56388293FE47BE39604EB115C7100@BYAPR02MB5638.namprd02.prod.outlook.com>
 <20201103232806.GL1109407@lunn.ch>
In-Reply-To: <20201103232806.GL1109407@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=xilinx.com;
x-originating-ip: [47.9.173.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 783cfc51-61b0-4432-1a08-08d882732406
x-ms-traffictypediagnostic: BY5PR02MB6404:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR02MB64046BBF55A8D5F537259F7CC7ED0@BY5PR02MB6404.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wb/FNxQhScTiivorEfXA6D6iX8OiJN5UvSVKbsBSXK3LGLgAaRRhHQlaBJnrYH99auwAmJhbzlk5kMvw7rUbMoQ8CX8cjugFf+/eORu3qdGEsxcIIb57g2yjC8twDFx/zN50e0lJ9Wp2gnStnFCDg9a3muyCZSbpmHwSIIeaHkDn0IkkDOytrAvbvm5tgXdoxu5/+Jdomy0eS4meFft8rKshDNx7sq/OKJhjE3pLAhw0qkckOYk2UtqBsiUsR/sjkZptCmj1AV6NM9A9LAEUuxeYYPNLzXycKHnsQRvKqNdOdomE2t2Q4EmJRm+ovbjvDdbLJsuuKdb6lzq7TFiXtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5638.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(8936002)(2906002)(33656002)(5660300002)(316002)(186003)(83380400001)(4326008)(64756008)(53546011)(6506007)(26005)(8676002)(55016002)(54906003)(52536014)(9686003)(66446008)(76116006)(66946007)(86362001)(71200400001)(6916009)(7696005)(478600001)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: E8CS0yupv8F+og2wGI50KhCm/AitFqTtAijtUuy/k08mlD8U+0Ptetrf+eWv+J9ahwKhLYP1152B9fJU6vnStD/ubzmZPJFJK/V4AeyeP0SMS5DzN90ovqM1pUbdzwf1bbTyfpDlCkzNzPxgTWAtWrnM9oMA2IoUZumuMiWTE69vlmJgUWsXLN4ZUZBTU39kMKeLl3kBS1Nkyp6ji079xXznMM7sQoR1iUoFWhs8E8DwgWCzRwiBhSHKx7CNWcYpx1mf5i4HQP70j3mh/9J+L9fA7ojy30tp+rB5a/sup1rIDHFAuPiioJuOkW3Og9mkjeKlqDGhrwXL+R/13U/sZrlTajWp8/9+97cWYSt9gUgPxx6/rbxwWUzAQpWH/dPVwQag0jk4JoR+bE/4s1gj88e2CgUmuPQfC47taeLt7iW5udGF5eIvpEDNyeP9sCHyVWb3qvkSMyo2Z/4HapYmWpFjzKjUgrA5tdPzOpjNaiUwoWPFXKFivm1xD4mn2vL04CymsoZHQQJ4p0j9lWKjHj/nf3oraoA6ski/cw1n07zjRjQaU3vcJ1r/kEDJ+70RUg25LB+7/3mK42xdGUf3Q1eahtTaLXyebzOzK/p9UEJX5P7s1D2aBeFf4hmuEWpnnIOZilZz9K9XFcW81H0bqw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5638.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 783cfc51-61b0-4432-1a08-08d882732406
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2020 16:43:50.7759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tttaJ43F14ag19UN1DgkEjkHGm+rQpLCP4Qn4Q5l4FxuP0OdJjjhvOqcxTE/HJuxbrO206pE8b+CEYo8kQRgoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6404
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, November 4, 2020 4:58 AM
> To: Radhey Shyam Pandey <radheys@xilinx.com>
> Cc: Michal Simek <michals@xilinx.com>; Jakub Kicinski <kuba@kernel.org>;
> netdev <netdev@vger.kernel.org>
> Subject: Re: [PATCH net-next 2/3] drivers: net: xilinx_emaclite: Fix -Wpo=
inter-
> to-int-cast warnings with W=3D1
>=20
> > > >  /* BUFFER_ALIGN(adr) calculates the number of bytes to the next
> > > > alignment. */ -#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((u32)adr))
> %
> > > > ALIGNMENT)
> > > > +#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((long)adr)) %
> ALIGNMENT)
> > >
> > > I can't see any reason to change unsigned type to signed one.
>=20
> > Agree. Also, I think we can get rid of this custom BUFFER_ALIGN
> > macro and simply calling skb_reserve(skb, NET_IP_ALIGN)
> > will make the protocol header to be aligned on at
> > least a 4-byte boundary?
>=20
> Hi Radhey
>=20
> I'm just going to replace the long with a uintptr_t. That will fix the
> warnings. I don't have this hardware, so don't want to risk anything
> more invasive which i cannot test.
>=20
> Please feel free to add a follow up patch replacing this with
> skb_reserve(skb, NET_IP_ALIGN).

Ok, thanks. I will send out a patch to remove this buffer align macro.
>=20
> 	 Andrew
