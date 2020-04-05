Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4042119ECA4
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 18:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgDEQdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 12:33:24 -0400
Received: from mail-eopbgr1300135.outbound.protection.outlook.com ([40.107.130.135]:30944
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726667AbgDEQdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Apr 2020 12:33:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9PnwTpmukZiE7Ywh0oc7aUOLjoTFL5u3mRWN4B8hJh30H1njBut0vOabrYEilho/Oq6IN/kXZVbPoklauLz6zCyyLHZurCiGaPAA3l6Xr+6AMqRKebog1gVeCOee7RcsTBZ9kESJ6/fj3u0pfoPBgIuPktUk4oENqy6xV9/k4QW5KzSLEwRk4BS48DSecut0UBczMhkxFzASCVXolFQ9k8samFYWqnuXBljPEX5DbeozYblBDkxoXnGiFsqfFD22BFjMJ9EAWIDe/m2P9wx4rgTMPODauB792JatSuPr0+ANfTsd4OMgV5STyFa1+0nE8BdLrsPEkjXAT6RJEYbVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXcyki0we1zYjH2MyiDjQmX7icp8sPnRpeidT24c5k8=;
 b=fEQV/Q6XPcegQAdqapAIJXVFoVouTR5l2CmhpUjZ2n/u1ScqU0KlFzMzotbxV2hSCHROj1MONi41rzbhq13sUqJzhszFZA8KwnI9s3hGRK9D6zp9SMfZs0uin3CmQSUEArSMYjFohOgaEdI3ueB2/6ZPomoOXmH8hBhOsJcwNu3QVlfvUzmsdqHlYraP53cI8dZLtcJ0Q1NtiQXrUYlGze3n9Lgoq2XfnamN53fVWQ9ZAfEEvrcNaCmxrKY1NPtG3bgExQfioFAPTIhagnOUe8khtcsJMEJpwGHLi7hcf2j+rjJ3Yr1w8LoRFVRkFHjZB0BtevNnPhwNN+q639oWvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXcyki0we1zYjH2MyiDjQmX7icp8sPnRpeidT24c5k8=;
 b=Qtfpu4uUkDDl1P1GyTwSGdtPLvBBl9Zh1a2UtJ3pdSdRDB6vCYzKdkMJCYEr4hgbnwD22D6p/e+0o2iLY81WIUfpkRasg9CO9Hx3ttGtb1PqlSewRrg2GNbLAVqCcE6lWt3s9DYHUKbnSsXDHVZVKVgVUTwLy/JzEi+lxKUCRv0=
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM (52.132.236.76) by
 HK0P153MB0194.APCP153.PROD.OUTLOOK.COM (52.133.212.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.4; Sun, 5 Apr 2020 16:33:18 +0000
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a]) by HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a%2]) with mapi id 15.20.2900.012; Sun, 5 Apr 2020
 16:33:18 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemb@google.com" <willemb@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "sdf@google.com" <sdf@google.com>,
        "john.hurley@netronome.com" <john.hurley@netronome.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "fw@strlen.de" <fw@strlen.de>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "jeremy@azazel.net" <jeremy@azazel.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] skbuff.h: Improve the checksum related comments
Thread-Topic: [PATCH net] skbuff.h: Improve the checksum related comments
Thread-Index: AQHWCzYPXZ/PsAZ8AU+mHH+wagcwgqhqsF3g
Date:   Sun, 5 Apr 2020 16:33:17 +0000
Message-ID: <HK0P153MB027363A6F5A5AACC366B11A3BFC50@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
References: <1586071063-51656-1-git-send-email-decui@microsoft.com>
 <20200405103618.GV21484@bombadil.infradead.org>
In-Reply-To: <20200405103618.GV21484@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-05T16:33:14.8895074Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b7faa033-d2e7-47db-976c-b49d93b4820d;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:ac71:2d80:3165:3247]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5f24d68c-ab03-4639-42fd-08d7d97f0c0a
x-ms-traffictypediagnostic: HK0P153MB0194:
x-microsoft-antispam-prvs: <HK0P153MB0194F6805E393C4AEA6AEF34BFC50@HK0P153MB0194.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03648EFF89
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0273.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(186003)(8936002)(6916009)(53546011)(7416002)(86362001)(2906002)(82950400001)(82960400001)(6506007)(7696005)(9686003)(55016002)(10290500003)(5660300002)(316002)(33656002)(478600001)(71200400001)(54906003)(8990500004)(4326008)(76116006)(66476007)(66556008)(64756008)(66446008)(52536014)(81156014)(66946007)(81166006)(8676002);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JDpHxRuaRlEpwbhyGuSnazbR7OEIvf1QcRDRXtwjZsUSlnf+tkh9Lh6UmBdjLOMvIi5Dp417IxvVklTJciSXFHWQ7M+56XWJ8mxQiX1CJc6HZt5i/8wiPyYl+H4aUfpTMyzAAJ0aQ208+++/Gsp7hrdZHbXr/oUlL+EAlQ8vcx1MBikcxt5krvlnw83YD3TxTI5Igj4C4ISbl+A+8JJJmaRw6NB6qC6bEg4/n+b9ExLCmllbunHFtaTgXe8VDZSpEZfN2K27bBTxDvnui+PTRJYGWP9jDHTu16Pwy9ybhLqSSTmAA4asxj8XySnRflkxH5DYtLWHHPg5PBX3Bf7BB7pYAPl3cDn60PwB5WQ+eFjpfEe/07OhhhYesg8w2dDY+flHOViJVyG7QU7nVd+anBrJ6xecHcnhd+rl8LMIeFg1DqF/8579sCFKinoikITG
x-ms-exchange-antispam-messagedata: w3hmYeDivYvVsPbcqmrNGf9h4cDa3YZTls69A1XGomVOBNt4PDsHQ/V8a0AnBLSZig3rSdVsOfakvuAtn+WNCGsLHm3BYfMwozvwg5GOvxstJgA9gglqw844XMwP4xibGc6AYeCDwWiwJwN80caml5DzVnO1uhwjsa0sBHqZmttLT7/f/heeBdAb5TvaGyUM7H82qguCboQcWrajB9tM6w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f24d68c-ab03-4639-42fd-08d7d97f0c0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2020 16:33:17.8399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ix0J8s17/wElzYsl+RFoWBuWvHq7BLpzCTtAE/1N1mb5LHIqk6L3/uRtaGVjWyMDjhnyeFca9tkd/XagOqKAHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0194
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Matthew Wilcox <willy@infradead.org>
> Sent: Sunday, April 5, 2020 3:36 AM
> To: Dexuan Cui <decui@microsoft.com>
>=20
> On Sun, Apr 05, 2020 at 12:17:43AM -0700, Dexuan Cui wrote:
> >   * CHECKSUM_COMPLETE:
> >   *
> > - *   This is the most generic way. The device supplied checksum of the
> _whole_
> > - *   packet as seen by netif_rx() and fills out in skb->csum. Meaning,=
 the
> > + *   This is the most generic way. The device supplies checksum of the
> _whole_
> > + *   packet as seen by netif_rx() and fills out in skb->csum. This mea=
ns the
>=20
> I think both 'supplies' and 'supplied' are correct in this sentence.  The
> nuances are slightly different, but the meaning is the same in this insta=
nce.

I see. So let me rever back to "supplied".
=20
> You missed a mistake in the second line though, it should be either 'fill=
s
> out' or 'fills in'.  I think we tend to prefer 'fills in'.

Thanks! Will use "fills in" in v2.

> >   * CHECKSUM_COMPLETE:
> >   *   Not used in checksum output. If a driver observes a packet with t=
his
> value
> > - *   set in skbuff, if should treat as CHECKSUM_NONE being set.
> > + *   set in skbuff, the driver should treat it as CHECKSUM_NONE being =
set.
>=20
> I would go with "it should treat the packet as if CHECKSUM_NONE were set.=
"

Thanks. Will use this version.
=20
> > @@ -211,7 +211,7 @@
> >   * is implied by the SKB_GSO_* flags in gso_type. Most obviously, if t=
he
> >   * gso_type is SKB_GSO_TCPV4 or SKB_GSO_TCPV6, TCP checksum offload
> as
> >   * part of the GSO operation is implied. If a checksum is being offloa=
ded
> > - * with GSO then ip_summed is CHECKSUM_PARTIAL, csum_start and
> csum_offset
> > + * with GSO then ip_summed is CHECKSUM_PARTIAL AND csum_start and
> csum_offset
> >   * are set to refer to the outermost checksum being offload (two offlo=
aded
> >   * checksums are possible with UDP encapsulation).
>=20
> Why the capitalisation of 'AND'?

The current text without the patch is:
 * part of the GSO operation is implied. If a checksum is being offloaded
 * with GSO then ip_summed is CHECKSUM_PARTIAL, csum_start and csum_offset
 * are set to refer to the outermost checksum being offload (two offloaded
 * checksums are possible with UDP encapsulation).

The comma after the "CHECKSUM_PARTIAL" seems suspicious to me. I feel we
should add an "and" after the comma, or replace the comma with "and", but
either way we'll have "... and csum_start and csum_offset...", which seems =
a little
unnatural to me since we have 2 'and's here... So I tried to make it a litt=
le natural
by replacing the first 'and' with 'AND', which obviously causes confusion t=
o you.

Please suggest the best change here. Thanks!
=20
> Thanks for the improvements,
>=20
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Thanks for the comments! I'll wait for your suggestion on the 'AND' and pos=
t
a v2.

Thanks,
-- Dexuan
