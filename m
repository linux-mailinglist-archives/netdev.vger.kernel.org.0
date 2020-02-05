Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA3F1536C0
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 18:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgBERg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 12:36:29 -0500
Received: from mail-vi1eur05on2105.outbound.protection.outlook.com ([40.107.21.105]:3403
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726678AbgBERg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 12:36:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkRXircO1TGdWlcZnFuk5ZCBZrZ39IjuVJ3Ay3LUFPUpyQhiTV7ZX35cATwaZeAJG9/E8rba7guiLwuuc4TBe/XUmos15GKuRGPhDPL9Wnueehy2awVAQs0ugB+tHxcbEtmzSEegP0oTgtgwRspnNP+PQfOOvKOwJxK2Y9hju8YuvBIbShKtoQxs6DivcXvjAG5KZHjIjEEowG55vr739b+bSkLF7bvP18pFLTj+LxZDYp39aZNYHWFL/OVQWjUbOuRySZWWuLtaAv+P04N+Xys7KNQBfWJA9sOJfrhCCFcO32YGoJ+0Cl33LYBFvweMAci0icsIrP0Q7pbHB/Cimw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ve4PW5/0eSTSlK4sNFcvbaEmo/aftTE1sUluTgD1sCY=;
 b=K+QUaYW2BL+IVswUOF+w5s0KZnOvnycKqQoRYFzfnkgIB5vbRj5tdbF5rciLerTzANIley7PZMn8K2vt0+VfLuSt1y9RnjbjxZVT84TM/BxGLLtURJy5QA1gyGmr9Is+ZDrpS7vc/1G2u/65Y22mKmE/UopjEvDr81RUIOs5Wv8PbU1svis/KVVdFRFq+t3PF5TPiR6kUdeUOOB4q4PbtU1fz65gJOFATF2C0u5OpXD92uEzexoF60bhQmAHm/yMSwvQyJia7nObNwydFOuslLyVc/vwsJ9u61sehafEvGd1tEeimulQPCwlTOX+3+UmMaRr3Q20Sgcl4jWlZCX+jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ve4PW5/0eSTSlK4sNFcvbaEmo/aftTE1sUluTgD1sCY=;
 b=riaw01XX2O6sII+I7hSJ+3oyoVW3SlU8QaHkdQd9U1QXUM+9PDisit3CMWy0nD3iaJakD/jUNMGnk4S+HP4+ZM2DMKCoQBQDZexVvhJhnxc6wmx337cFCvLZVAWw/7zxywjOAvVELiWI2FD7hHCLRtiiGdk8YevZERr04BCcLyE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=w.dauchy@criteo.com; 
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com (52.134.71.157) by
 DB3PR0402MB3705.eurprd04.prod.outlook.com (52.134.70.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Wed, 5 Feb 2020 17:36:25 +0000
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b]) by DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b%3]) with mapi id 15.20.2686.035; Wed, 5 Feb 2020
 17:36:25 +0000
X-Gm-Message-State: APjAAAUWtm8GtBU/2UTaEFOLmgVy08ijeAEwj4LKC1N4SI7Cfv12j6RX
        i5KFOCAAHW37anyCc2U13liuS90zTuL8fDjQVlU=
X-Google-Smtp-Source: APXvYqyIHzVOw59zZJsBVLZRadUa/2TdbNl1SB2Xbch+9at6gd1ryizFPIVRmWG8vf4ENyCNyCzVsu+1Nzyt/NQO0zU=
X-Received: by 2002:a05:6512:1cc:: with SMTP id f12mr18930483lfp.128.1580924184056;
 Wed, 05 Feb 2020 09:36:24 -0800 (PST)
References: <563334a2-8b5d-a80b-30ef-085fdaa2d1a8@6wind.com>
 <20200205162934.220154-2-w.dauchy@criteo.com> <b3497834-1ab5-3315-bfbd-ac4f5236eee3@6wind.com>
In-Reply-To: <b3497834-1ab5-3315-bfbd-ac4f5236eee3@6wind.com>
From:   William Dauchy <w.dauchy@criteo.com>
Date:   Wed, 5 Feb 2020 18:36:11 +0100
X-Gmail-Original-Message-ID: <CAJ75kXbDL+vvC9UKWoM4_Zf59Ej8hEOOJT-92L_G9u-j9px1sQ@mail.gmail.com>
Message-ID: <CAJ75kXbDL+vvC9UKWoM4_Zf59Ej8hEOOJT-92L_G9u-j9px1sQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] net, ip6_tunnel: enhance tunnel locate with link check
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     William Dauchy <w.dauchy@criteo.com>,
        NETDEV <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: FR2P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::9) To DB3PR0402MB3914.eurprd04.prod.outlook.com
 (2603:10a6:8:f::29)
MIME-Version: 1.0
Received: from mail-lf1-f52.google.com (209.85.167.52) by FR2P281CA0022.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Wed, 5 Feb 2020 17:36:25 +0000
Received: by mail-lf1-f52.google.com with SMTP id b15so2088045lfc.4        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 09:36:25 -0800 (PST)
X-Gm-Message-State: APjAAAUWtm8GtBU/2UTaEFOLmgVy08ijeAEwj4LKC1N4SI7Cfv12j6RX
        i5KFOCAAHW37anyCc2U13liuS90zTuL8fDjQVlU=
X-Google-Smtp-Source: APXvYqyIHzVOw59zZJsBVLZRadUa/2TdbNl1SB2Xbch+9at6gd1ryizFPIVRmWG8vf4ENyCNyCzVsu+1Nzyt/NQO0zU=
X-Received: by 2002:a05:6512:1cc:: with SMTP id
 f12mr18930483lfp.128.1580924184056; Wed, 05 Feb 2020 09:36:24 -0800 (PST)
X-Gmail-Original-Message-ID: <CAJ75kXbDL+vvC9UKWoM4_Zf59Ej8hEOOJT-92L_G9u-j9px1sQ@mail.gmail.com>
X-Originating-IP: [209.85.167.52]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f84ec5f-a603-49b2-2ec4-08d7aa61ec6b
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3705:
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3705B0393ACDC8EE91117734E8020@DB3PR0402MB3705.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0304E36CA3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(199004)(189003)(498600001)(81156014)(81166006)(6666004)(8936002)(66574012)(86362001)(8676002)(4744005)(66946007)(4326008)(52116002)(6862004)(53546011)(5660300002)(66556008)(66476007)(9686003)(54906003)(42186006)(55446002)(26005)(2906002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR0402MB3705;H:DB3PR0402MB3914.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2xE1RmhyWDWpWTX3NNUSgB/nh3nJ3e0MbwA3NQNRlxfpOOFZSVU2kyLtVPOhJZusIw5Ui97JgdYq4iWpHbr415X136vYzVKEL7wK4CYbovsJJNO85hApAk/6E/IZPU4AhKYIyAXDrk76kyWYOOs78jzXrxWerp9TtkGkiT8PT7LaUPQ9U6pjBr15Nn0xR5iQSkNmI+0rxy9VjJthkUmbsEAik4bYANX+y3LzLexbKHKwGeJ32BHaJ97EmtcUHFYSeO5X5p9IKOm/AqynaLdXRJKoTZ5ROJSEp7ZZrl5s5rgIh2D11Jx30DTi6O2IAtcUikk6w1tH9p3GOAUEcW4ypMjpehV1HQQAn7wUWDCItwCV0+EJJfBd8t8CaUlIUFcHphvL4s+O4R4WTCGYwjWmrm3zH1Yf3fQVFcROuc58vB128iX/g4lIIBDCgOpyk8uj
X-MS-Exchange-AntiSpam-MessageData: nnnd/zrYkzk0Tu0SBqPSOxycgwzBXw+YIOI1AISX7oQUb6iGeM0KscCsuipimXLYYMOq5R1hxIyAxg2+lnEgZjYeIY/0p49IKCCE7TCfmez6L6mtMCm0sPp65d2eBdygsqdDslbOGS6C0q93XoiKQA==
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f84ec5f-a603-49b2-2ec4-08d7aa61ec6b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2020 17:36:25.2870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JqW9fr9yf/UhrGLFOrTTEa6glAe+Ni4ulfOfbHI/nUE3gwlZqEn9nifSld7y1oRvooxncdiz+zGzFDsRBdSbMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3705
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 5, 2020 at 5:55 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
> Le 05/02/2020 =C3=A0 17:29, William Dauchy a =C3=A9crit :
> [snip]
> > diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> > index b5dd20c4599b..053f44691cc6 100644
> > --- a/net/ipv6/ip6_tunnel.c
> > +++ b/net/ipv6/ip6_tunnel.c
> > @@ -351,7 +351,8 @@ static struct ip6_tnl *ip6_tnl_locate(struct net *n=
et,
> >            (t =3D rtnl_dereference(*tp)) !=3D NULL;
> >            tp =3D &t->next) {
> >               if (ipv6_addr_equal(local, &t->parms.laddr) &&
> > -                 ipv6_addr_equal(remote, &t->parms.raddr)) {
> > +                 ipv6_addr_equal(remote, &t->parms.raddr) &&
> > +                 p->link =3D=3D t->parms.link) {
> >                       if (create)
> >                               return ERR_PTR(-EEXIST);
> This is probably not so easy. If link becomes part of the key, at least
> ip6_tnl_lookup() should also be updated.
> You can also look at ip_tunnel_bind_dev() to check how the mtu is calcula=
ted.

indeed, I will update that.
--=20
William
