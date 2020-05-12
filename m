Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974D21CF18A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 11:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgELJZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 05:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725889AbgELJZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 05:25:55 -0400
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (mail-co1nam04on0609.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe4d::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F2FC061A0C;
        Tue, 12 May 2020 02:25:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYLvSvlzwEi9UMOcysLclRnx9lFMU6V9fBBWo2OFBR7TtVDnFbmhqcNp+IJfkG/eFVyuVjr33RCHq58MJQnENC0rxAtn3mfPlHjvdo0j7FxdpxSqREkRhrqtqo21sePcALePgcGsg1CppGLo4S6wauZP8Ohcgz39+kAf+001QnJTnK6FJKXa9ld4GRrCbsG5bxLtI2IY+m/nIQyrG/MNW6xcwLjxpJ3IcvQ5SXT2meyYAC34JI1ISXh3EQ7jljn8vBx9LgdMn/RJtjcEBMVrDIuli51piZUiVITNuKXlz5cJ4RVe+bE7nm1zXQZlY5B89pWm2eNd7fYO/cZdtlz14Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01UvB6CW1bdXaFwpVorQ9f2Th8Wvlqb/yzqgTvj/zyY=;
 b=hhElAsBblfQ96C+D7AliSEY5GWZkABwMWvt/sHIYkIik+scHZ110gR5OaYBk/4V5IgkXTE/ictPkrPCAiSlyVpOWVpYZ47X51txzBgwzpwenICf8nlrxW+RAWaOIQH3SgeHxTNYXNoDeUSwSDcxd3zXK+cMXIPhS4rG7KIjSTMAl4Ae/qphrPRN2ZrL942yCTsr4E+vp3sv2eA3cJXXdtJgjNAwfwCU2mkp85V+HcwhbGoZebLGoTPte9urkFUtE09HveGuU4AzzQlMjsBZczlGhipRpO3EgKBAgjCw5OJGc+pq56nVewyLSe4Lm5/7WPPPxW21DfT13MInAyexyEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01UvB6CW1bdXaFwpVorQ9f2Th8Wvlqb/yzqgTvj/zyY=;
 b=GsjAxzT5X7k3hSub70ElHhOqEOzYS179A/oUGTL3S5uczpusi+LUHLN6qaeX6mw99OHEzSaoOnZIIheydFHGJCfg+/jtaViBXtN21CmT4x67TfoY87yGTz7Nd2j0ze48Y+g4ih6GBiFDfpz3nn3XR7ekplM+AbjpQhOcia5ou50=
Authentication-Results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1789.namprd11.prod.outlook.com (2603:10b6:300:108::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 09:25:53 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 09:25:53 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     driverdevel <devel@driverdev.osuosl.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 13/17] staging: wfx: fix endianness of the field 'len'
Date:   Tue, 12 May 2020 11:25:47 +0200
Message-ID: <1922297.S9MP3OIeVN@pc-42>
Organization: Silicon Labs
In-Reply-To: <CAMuHMdVZxy+FZGPhDxotCBeEX3O4ZMkmGAwmVFXQE9ZoijDN5g@mail.gmail.com>
References: <20200511154930.190212-1-Jerome.Pouiller@silabs.com> <20200511154930.190212-14-Jerome.Pouiller@silabs.com> <CAMuHMdVZxy+FZGPhDxotCBeEX3O4ZMkmGAwmVFXQE9ZoijDN5g@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SN4PR0501CA0104.namprd05.prod.outlook.com
 (2603:10b6:803:42::21) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by SN4PR0501CA0104.namprd05.prod.outlook.com (2603:10b6:803:42::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Tue, 12 May 2020 09:25:51 +0000
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d99f611-521b-4f77-986b-08d7f6567772
X-MS-TrafficTypeDiagnostic: MWHPR11MB1789:
X-Microsoft-Antispam-PRVS: <MWHPR11MB1789CF3E40D6118389D6811D93BE0@MWHPR11MB1789.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:449;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IUdQEJat0l2T3xBbhwAAINs4Yp4KhMZj6qgdh5OzHLREMGHNJsE/pm/uqyCYZS5Nb0ITGcUrIdC6VeoBkP32RlkyD0ehk/xfU/AFjjMVPVtucpzV/A/gWcJCgvd/naubh335CpKSikn79Fbvd8mtuPu/00g2NW432qaFzlIZDc8UgnkEjpdC12loxBz4gzWO2XDueMomY5JAk/70/qB3mSzILkmlEKVjNGp2zU+1OQtN8HcCOLENgFTvCExGGBwSUY9xkglfuGIkF6vlZVUY282ALq5prJor7WtvReLgtuIDcBQI2fOJTLvXHKAH8XXDnYQxVgQhJeHBnICW9TGvpjYb6rB9qExQrALhojdWUkNNiuiNo+XBQ5kbTQVgq5yOJ6M8hug3bMjZUoIt8qqDpf0bi9d8vE00Eh8ie8L5nLTSb7PUHH+qSn9mh3+GEWcVtOTW/91TOpIqAvFI5d+PKwNMGeQCRfPEkRkXRki/cHIpza1CvcMNSVTMMWe6fH0GaYUFSEVuZs+ftBVKiDJSrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(39850400004)(366004)(376002)(346002)(33430700001)(186003)(9686003)(316002)(53546011)(8676002)(86362001)(6916009)(33716001)(6506007)(33440700001)(6486002)(478600001)(54906003)(66476007)(4326008)(66946007)(5660300002)(66556008)(2906002)(52116002)(16526019)(66574014)(956004)(36916002)(26005)(6512007)(6666004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0q6npRwJDzIUMbS3I/O49wLvLSR+CSEsyXRFKl7wsf8xoo2DWrswOr7bwg+/dDUfvtxTBGtDkP2tLw+4FTLw7N9T8+mRm69IK4pqgoPsX37iXk5QKWhuLViZjKNqxQQ5acfpar73900O6oUfR3t5g2wYxqsBgCqWlAp0l2kWxFZkoR/u0+Uta0pQza2uStAWZQG1Jpg6MYzNWfsmyv/9muwgmGZZ3tt040cyilGiYsVAmOnjpl39gdugplxhWjq4LORIs9fK0Lzq4eZ//Ur9Cnzd6SdpSZteEXMux0BDnZQUF5bg2aScGv5S1fb1l3WjINoBCXNh3K+1pylZQuEksHHbUDAi3E5GmDl7THCJ2quZ5AExs0AsmEXlxTHHTUEkh8jZ3p7B750nCKHvKGABcx2F989iV+viheSFO1PDRlEwBLUzu7SAisg2TGB/822t0Fy/ltXBeNLTGXTCEUGKw83opNsQkoNKk0f3p45slCo=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d99f611-521b-4f77-986b-08d7f6567772
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 09:25:52.9642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vIGPpjfocmR5zBKYIn8vGklXGx3T2sDnnJB2+TzrWgb0cKmqmzNixMtUdp7QZJkhmH6IIyakSkaCFSykX89/5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1789
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 12 May 2020 09:43:34 CEST Geert Uytterhoeven wrote:
> Hi Jerome,
>=20
> On Mon, May 11, 2020 at 5:53 PM Jerome Pouiller
> <Jerome.Pouiller@silabs.com> wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > The struct hif_msg is received from the hardware. So, it declared as
> > little endian. However, it is also accessed from many places in the
> > driver. Sparse complains about that:
> >
> >     drivers/staging/wfx/bh.c:88:32: warning: restricted __le16 degrades=
 to integer
> >     drivers/staging/wfx/bh.c:88:32: warning: restricted __le16 degrades=
 to integer
> >     drivers/staging/wfx/bh.c:93:32: warning: restricted __le16 degrades=
 to integer
> >     drivers/staging/wfx/bh.c:93:32: warning: cast to restricted __le16
> >     drivers/staging/wfx/bh.c:93:32: warning: restricted __le16 degrades=
 to integer
> >     drivers/staging/wfx/bh.c:121:25: warning: incorrect type in argumen=
t 2 (different base types)
> >     drivers/staging/wfx/bh.c:121:25:    expected unsigned int len
> >     drivers/staging/wfx/bh.c:121:25:    got restricted __le16 [usertype=
] len
> >     drivers/staging/wfx/hif_rx.c:27:22: warning: restricted __le16 degr=
ades to integer
> >     drivers/staging/wfx/hif_rx.c:347:39: warning: incorrect type in arg=
ument 7 (different base types)
> >     drivers/staging/wfx/hif_rx.c:347:39:    expected unsigned int [user=
type] len
> >     drivers/staging/wfx/hif_rx.c:347:39:    got restricted __le16 const=
 [usertype] len
> >     drivers/staging/wfx/hif_rx.c:365:39: warning: incorrect type in arg=
ument 7 (different base types)
> >     drivers/staging/wfx/hif_rx.c:365:39:    expected unsigned int [user=
type] len
> >     drivers/staging/wfx/hif_rx.c:365:39:    got restricted __le16 const=
 [usertype] len
> >     drivers/staging/wfx/./traces.h:195:1: warning: incorrect type in as=
signment (different base types)
> >     drivers/staging/wfx/./traces.h:195:1:    expected int msg_len
> >     drivers/staging/wfx/./traces.h:195:1:    got restricted __le16 cons=
t [usertype] len
> >     drivers/staging/wfx/./traces.h:195:1: warning: incorrect type in as=
signment (different base types)
> >     drivers/staging/wfx/./traces.h:195:1:    expected int msg_len
> >     drivers/staging/wfx/./traces.h:195:1:    got restricted __le16 cons=
t [usertype] len
> >     drivers/staging/wfx/debug.c:319:20: warning: restricted __le16 degr=
ades to integer
> >     drivers/staging/wfx/secure_link.c:85:27: warning: restricted __le16=
 degrades to integer
> >     drivers/staging/wfx/secure_link.c:85:27: warning: restricted __le16=
 degrades to integer
>=20
> Thanks for your patch!
>=20
> > In order to make Sparse happy and to keep access from the driver easy,
> > this patch declare 'len' with native endianness.
> >
> > On reception of hardware data, this patch takes care to do byte-swap an=
d
> > keep Sparse happy.
>=20
> Which means sparse can no longer do any checking on the field,
> and new bugs may/will creep in in the future, unnoticed.
>=20
> > --- a/drivers/staging/wfx/hif_api_general.h
> > +++ b/drivers/staging/wfx/hif_api_general.h
> > @@ -23,7 +23,10 @@
> >  #define HIF_COUNTER_MAX           7
> >
> >  struct hif_msg {
> > -       __le16 len;
> > +       // len is in fact little endian. However, it is widely used in =
the
> > +       // driver, so we declare it in native byte order and we reorder=
 just
> > +       // before/after send/receive it (see bh.c).
> > +       u16    len;
>=20
> While there's a small penalty associated with always doing the conversion
> on big-endian platforms, it will probably be lost in the noise anyway.

I have made the changes to show you that the code is far more complicated
with a le16... and the result was not as complicated as I expected...

I am going to post a v2.


--=20
J=E9r=F4me Pouiller


