Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7F895BB1
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbfHTJx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:53:29 -0400
Received: from mail-eopbgr140081.outbound.protection.outlook.com ([40.107.14.81]:5601
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729181AbfHTJx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 05:53:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXblW9b+A0qvGK9Oer3gqZna5b10Jq3Kklruo9cuS5v05sqt09EBduKYiS62k/zZlSU1Vi8zSz8rpZx3XCV/ug7YvJF3tGmr9wzM2IeNlVhlBrndzeHKkjzo8EO6VWdYsq65DrNAYmgo9Ra80D6jZD9KYpsd4PKhSlyVM+UpPrSgumBCa43ve3bhDEJIgIBrG2TQYC8tyfKTgucfWyFHlaS9F35yzxxIWvySZ/j8LEsWb6G/5S6+kQ3zbgzzfqpt49UPz0anE8mKMUcWNpUfLzlOEicJ8th5w8gm/kDmRAzfagRLi4f/Z6nUqvdiRrbzDD9XTN7770gPxUzsZnl6hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTPa/VFRL3Qnj50ILYI2XAHSQOjROPG6ACuOJZ2BXHo=;
 b=XiH+WtKDjhLm7C6ZN1T8SjBuxvcOq9VneLN9ZgjlaG6mGpd4hUqwCF6HfN6t2poy+W/gbwbQOMX6W98Sg3tqW8gt88uA6egfgxHRnqNZVI8UEujUPQ205alis82V73IUkWPEAeNHFqCA95lEMLEzczM0IQOgj2paGDDeHDm3g0KdJyAPHhrOJtPKeBJkLmqvUd/Ec8YP56QQSiubk8RYPpH1L+Yoy+6Z8gxe/XzHC5BgtevV+32hPrq69w3nWibAYN8HmzMtEatuIv04/slsdKg5Ihbmu+vQhceFaT4rHQdn8oIB2E/oJ85BtSg1S2WLXji00leUHH5jxXDXkfl9EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTPa/VFRL3Qnj50ILYI2XAHSQOjROPG6ACuOJZ2BXHo=;
 b=Dg3WOM9Vc88dS2556XCDPfhJbwNDHtx365r2Vsq2mFAnUMfSp20uJzpLsIxqr0xiJZvLz4jIA1a0pPKYp7pbtVb7QazFy8N718kpmnfn96trFBef7Jg1HasJu2h2ZFjH6QPOSzp+IzkeOihstNczdFztA6wpwHWY/5VCnK4KSrs=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB5212.eurprd04.prod.outlook.com (20.176.236.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 09:52:41 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250%4]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 09:52:41 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Help needed - Kernel lockup while running ipsec
Thread-Topic: Help needed - Kernel lockup while running ipsec
Thread-Index: AdVWjKmxsxThBk5DR52nDhmLe9COdgAKDSMAACB27LAAAIj+gAAABzZQAAB+dAAAAHQ0QA==
Date:   Tue, 20 Aug 2019 09:52:40 +0000
Message-ID: <DB7PR04MB46204E237BB1E495FC799E588BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190819173810.GK2588@breakpoint.cc>
 <DB7PR04MB4620C6E770C97AB14A04A1D98BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820092303.GM2588@breakpoint.cc>
 <DB7PR04MB4620487074796FBC015AFD098BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820093800.GN2588@breakpoint.cc>
In-Reply-To: <20190820093800.GN2588@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fc1dba7-25de-48be-5d29-08d725542439
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5212;
x-ms-traffictypediagnostic: DB7PR04MB5212:
x-microsoft-antispam-prvs: <DB7PR04MB5212B2D89B7449BC1AFD3B258BAB0@DB7PR04MB5212.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(13464003)(199004)(189003)(256004)(76176011)(2906002)(99286004)(26005)(7696005)(316002)(25786009)(53546011)(6506007)(6246003)(5660300002)(6916009)(102836004)(4326008)(33656002)(478600001)(14454004)(9686003)(6436002)(66066001)(6116002)(71190400001)(71200400001)(55016002)(8936002)(81166006)(8676002)(229853002)(53936002)(486006)(476003)(66446008)(64756008)(44832011)(7736002)(11346002)(66556008)(66476007)(76116006)(305945005)(66946007)(446003)(74316002)(3846002)(14444005)(86362001)(81156014)(186003)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5212;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /pGvhOoIlJeY84yngaR235ndKWeXRwGIo3EDPpigfddGs50RoQe3OeiJCD+nONGn/Mjka7TcscaS7qqy2HJmxH+oBzi1k6rewYaFcvsKDk+tmarQONwNrsKFsbNrQNyJyPoYtlbptpSdAYosLqhLAgXQ4irfWQ9Y84LcmXRKiI2qgE4I+Xoz6mlDPlx9OUCzyLLEhwMeZ/lBvr3KtyKKGFR9NVIfuJa5EuJzUqhmdsGFAM/JxuTOWbB7qwSdjJCly+5xvOctpnnVPovGh09EwJvaK1k6G0qreowGj4UEuJLkuUlpTXIjiyyF+V16pIsa018tdEuBn9EJHU+Z0tOW1YQxRiMdj4I0uaWLdPmUiXp4EUoo4chIMp5xojqpDdVjUKnwP4A8dpj6pmPXqOPT5NTbNt/rF0+B/y/YRYbDexA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc1dba7-25de-48be-5d29-08d725542439
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 09:52:40.9675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: awD45m0WxfRoJBzZbHDv5iL49F16hQiY080v23UtgwwVlBSHYXWRSnOeT/Sv6jclMI8Yzf/CzHN8oFkVz29SBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5212
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Florian Westphal <fw@strlen.de>
> Sent: Tuesday, August 20, 2019 3:08 PM
> To: Vakul Garg <vakul.garg@nxp.com>
> Cc: Florian Westphal <fw@strlen.de>; netdev@vger.kernel.org
> Subject: Re: Help needed - Kernel lockup while running ipsec
>=20
> Vakul Garg <vakul.garg@nxp.com> wrote:
> >
> >
> > > -----Original Message-----
> > > From: Florian Westphal <fw@strlen.de>
> > > Sent: Tuesday, August 20, 2019 2:53 PM
> > > To: Vakul Garg <vakul.garg@nxp.com>
> > > Cc: Florian Westphal <fw@strlen.de>; netdev@vger.kernel.org
> > > Subject: Re: Help needed - Kernel lockup while running ipsec
> > >
> > > Vakul Garg <vakul.garg@nxp.com> wrote:
> > > > > > With kernel 4.14.122, I am getting a kernel softlockup while
> > > > > > running single
> > > > > static ipsec tunnel.
> > > > > > The problem reproduces mostly after running 8-10 hours of
> > > > > > ipsec encap
> > > > > test (on my dual core arm board).
> > > > > >
> > > > > > I found that in function xfrm_policy_lookup_bytype(), the
> > > > > > policy in variable
> > > > > 'ret' shows refcnt=3D0 under problem situation.
> > > > > > This creates an infinite loop in  xfrm_policy_lookup_bytype()
> > > > > > and hence the
> > > > > lockup.
> > > > > >
> > > > > > Can some body please provide me pointers about 'refcnt'?
> > > > > > Is it legitimate for 'refcnt' to become '0'? Under what
> > > > > > condition can it
> > > > > become '0'?
> > > > >
> > > > > Yes, when policy is destroyed and the last user calls
> > > > > xfrm_pol_put() which will invoke call_rcu to free the structure.
> > > >
> > > > It seems that policy reference count never gets decremented during
> > > > packet
> > > ipsec encap.
> > > > It is getting incremented for every frame that hits the policy.
> > > > In setkey -DP output, I see refcnt to be wrapping around after '0'.
> > >
> > > Thats a bug.  Does this affect 4.14 only or does this happen on
> > > current tree as well?
> >
> > I am yet to try it on 4.19.
> > Can you help me with the right fix? Which part of code should it get
> decremented?
> > I am not conversant with xfrm code.
>=20
> Normally policy reference counts get decremented when the skb is free'd, =
via
> dst destruction (xfrm_dst_destroy()).
>=20
> Do you see a dst leak as well?

Can you please guide me how to detect it?

(I am checking refcount on recent kernel and will let you know.)
