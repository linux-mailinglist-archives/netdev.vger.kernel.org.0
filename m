Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D44B507B37
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 22:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357731AbiDSUwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 16:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbiDSUwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 16:52:25 -0400
Received: from CAN01-QB1-obe.outbound.protection.outlook.com (mail-qb1can01on2060.outbound.protection.outlook.com [40.107.66.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BAE41605;
        Tue, 19 Apr 2022 13:49:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dA4dT+feqxNPPdYM4Vr5Oz7+MSJQWeylG/qnpLVcwTt0uBZ3oLJsLfGSS3FLMvOsd5PvL8nsPZLCTA2kYsl5/d4cJPdlGcuesFXUhJknOyBbiE9OiT6AvM2jT5uAmDrS82WqwIgcvQhXe2Q/KSO8lgZsqphh66U7kaTBOmUQf8vzUKnvuqWINtxTIoQv9BDFc5jDGAKc3AnecN+uOnz1galtY/cMdYQgGiR64tIIVizorWA6Zl7UX2CcSKerim84csaxI6ABUnYFxwXmmQ2By9jCxU4hPreWju7PB5II6OLtrlQmgLPLbjRPxPSpaN3FLTma0+b1JjCpxlD7b994dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6g9zKzZm8w/TpMVcD+gcqgCeEyqQxV2OVez7kTI48co=;
 b=D68mvR0N4UJV5zB6FUBcoSPX0zmjE1kvGZ7s18u7ZSncBu3hhP1XIEbncr/NJStYPGallltqxSjAEPPIDC2PG2/W4s+9loptpcxnffjk81JN3xOGoJbvpnrSMM/K+8n4gKPtAwhVDt0Euuww5hs74HNpzeYcqy9t8jqReeEJxg16pgZzuMQ4r5RwI4+DMtvZ1egkLFL7Vf71NfDCBsOC1JK4dcinQ4PDnjrf02+HyO62d6sf+GaZv/HB/XJxAqMhL7IcPh3VGnMLdYH0CDbrZJTZ9dwq5y5sEJVpxr9dWoLeK30RUue2Q659O9CAqLvqHnuQ/WGibptM5OOnnB7GDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uoguelph.ca; dmarc=pass action=none header.from=uoguelph.ca;
 dkim=pass header.d=uoguelph.ca; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uoguelph.ca;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6g9zKzZm8w/TpMVcD+gcqgCeEyqQxV2OVez7kTI48co=;
 b=f8bd5eX3qEHFrXZA5mSIyYifEdwRNQciwW3X31Q8cZVQRSXXuDcy585bkWjbYV930SSlSp2GqqFfdaZIZEeXBVr9hu5muIbVHHjP2cudYLVM1MJDCVyS9X9AKGb0J/xgsElvs6n6qY/4JSftVlrAwLD+I/z4SHrtayWF+ofv0kgKXv+uxU8xuAP45YUC7uEQMUNax2kKwNgmrKzixIa0pz7xKJ1/tBHIqi8KKpOq8k+CqBKHIirBrYiIHuRYq0PstXHBxJiBy5qDL39VJJcpQEogmahUYQxpjJWrPVvqAbvNV0ePBuY952O+sxHO2cMj9Vn1MUsKbiEOEAYDKlcJuw==
Received: from YT2PR01MB9730.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:de::14)
 by YT1PR01MB9499.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 20:49:33 +0000
Received: from YT2PR01MB9730.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::fdb1:ada8:7af0:3003]) by YT2PR01MB9730.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::fdb1:ada8:7af0:3003%6]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 20:49:33 +0000
From:   Rick Macklem <rmacklem@uoguelph.ca>
To:     Chuck Lever III <chuck.lever@oracle.com>,
        Trond Myklebust <trondmy@hammerspace.com>
CC:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simo@redhat.com" <simo@redhat.com>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "borisp@nvidia.com" <borisp@nvidia.com>
Subject: Re: [PATCH RFC 00/15] Prototype implementation of RPC-with-TLS
Thread-Topic: [PATCH RFC 00/15] Prototype implementation of RPC-with-TLS
Thread-Index: AQHYU0SpuI21otIlHEi6aMaWB1g+e6z2lWsAgADRRwCAAC7JgIAAAZCAgAAZbho=
Date:   Tue, 19 Apr 2022 20:49:33 +0000
Message-ID: <YT2PR01MB9730AC9AC94C88D7354E230ADDF29@YT2PR01MB9730.CANPRD01.PROD.OUTLOOK.COM>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
 <962bbdf09f6f446f26ea9b418ddfec60a23aed8d.camel@hammerspace.com>
 <06AB6768-AA74-43AF-9B9A-D6580EA0AE86@oracle.com>
 <8597368113bcc38e605e9bbd11916a0ac8b7852d.camel@hammerspace.com>
 <E7B440A0-FD0A-4F67-8238-CAE9A6882F10@oracle.com>
In-Reply-To: <E7B440A0-FD0A-4F67-8238-CAE9A6882F10@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: b8bb2c91-7a70-6c79-a140-01f9c59e0325
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uoguelph.ca;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03436128-cf7b-4402-b447-08da22461bb1
x-ms-traffictypediagnostic: YT1PR01MB9499:EE_
x-microsoft-antispam-prvs: <YT1PR01MB94996D55CB78D84D5D6B787ADDF29@YT1PR01MB9499.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xm8pqwhmhPlquhcdZ+wAbhJ+yAWutUou3xMYvia5gBSyDlNbAM0w1fLpMNjds9vc20xGIYwGNB/H2vdFsl45yFvaijTPG1kVujWIQJnuveS+YhVXdkrRakeDIhg+bqJaAW1i4hAqt3/DuF1zK7RuK/6T2BkgkKuztWUd3yr9H+QSd2RgjfvHHnx+B5AEKV1fVEHa50zgoWfCx+gMLxXZZX0OVdad/wpEZ65yZxOX0oiFTkrwtwCRlk5Ru8LDk8XyLmPUsgVrwhV2duBCWFHVXN/Wvod8mnUAOzjS4mJ5y0T9VboQ6fMzSIyoV7UJ6WnzTiT5UFzSijfQYCNcPoI4SmFkCIEVa+mwhqyHMyYJsm0DwXAKCw1VGoB5MPpa76+OgJ7WV6CuUoQFZ9o0Czpe3GgRVzTgl3VJWSYJNk/H9F37XWQDxtXCVioHqRvl/Jbb+N5s+woUtwN3zyfMKUWBNWpfCvv1MOLGEaEBxl0gYrEkU2nY9y5D/OoyoZtuR8ulF1W0yOjZ4XG/YGqXVa66cyJqTEmbMfMIunyct3SnWytKCg56rFUv13IfAiOU+tuvoxrY+VPWioN7tXAZVD8WKB430+2NJpkRIvdRkze9YWNsBz0XyCP5NfCjqGu/4CWVpi7ETKtiOQawvGt72RPD6+K+5VKzIM6MnvXeFMtAPSQK3EG9BNIQGzO5eiYuVs4lXng4ek7r9WQctlAb/td3sIHyBVhxlH2OZIHfVjEjOl8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9730.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52536014)(38100700002)(5660300002)(38070700005)(122000001)(71200400001)(2906002)(33656002)(7416002)(8936002)(86362001)(316002)(786003)(83380400001)(54906003)(110136005)(66556008)(186003)(66446008)(64756008)(76116006)(508600001)(91956017)(53546011)(9686003)(6506007)(7696005)(66476007)(66946007)(4326008)(8676002)(55016003)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gHY7vRWHTEIsryI2jvEjO2t5s9ZlKR2l3G59weejP9Pe3QD/1vcHMFeaEv?=
 =?iso-8859-1?Q?78VlghwNWEPk3AmlMHULqXQXDHQ2xig0VpHsHbsaMNVy7eJhYoJm3UZmnP?=
 =?iso-8859-1?Q?3hUiBFhSAzLwrBcTgCHQq1SgiZPO8a6oI6m8bkAitjzJHYQ+mH9NbgUcJD?=
 =?iso-8859-1?Q?vtRXngcyWvpIP51/cifXp6aPkyy8pdw9XXTy/YADMKJdOeDjqjQN4TfVJX?=
 =?iso-8859-1?Q?euRUyqZpqAx2nBPPRkvvBcR7JqGE04v9Kdmb8D+YHKKlR+EI90B2F7XH1m?=
 =?iso-8859-1?Q?Z3wZEhTeK/wl6peik6q8ALlDQZJ+eP+JfYlZAUimjnRhQMdkt9v7iS/qJW?=
 =?iso-8859-1?Q?WNS5yFOwGwog1iz9fD61HV02pmtSfAI6xYCmbvgBFhvXWH2x+SPCzlVWKi?=
 =?iso-8859-1?Q?/Rv+RSKqiBQQXkc1KPxFTXVnRMU/5aKYTkx4LwRxwQEao4IYOh84+1VBnS?=
 =?iso-8859-1?Q?u1aLIa03V6deHTeJtSyHPzUve5MoNd5WhijrRpKVfvZfWsL9LowTQNARbJ?=
 =?iso-8859-1?Q?bUp6KpsC9wjDRJ5WNw50OZ0jQtu0LnffH6/H2Ax4MnADmaQXF1qVMEtSYH?=
 =?iso-8859-1?Q?gGoyNPbAmEkLY+FeZE6t2EXHO+9g128e62jfi16RzOizqm6CsVQF0QnCVS?=
 =?iso-8859-1?Q?lrZtGrMrB4gcL6PEtzz3q+OCb3hWWrI/affQpA20rLr6fPRfpJKj7UDsNh?=
 =?iso-8859-1?Q?qACqEfMIzG9jdGZGCqPxu4KeDe+suJLbvIMjNfp1yYMpjnkwWFsUf7dzmq?=
 =?iso-8859-1?Q?plsba9VCrpjx20gjBZn7fdUGqjDd5QZpADYHgBkPdIHz5zk0kINR8wlvO+?=
 =?iso-8859-1?Q?pi/T2Z032aeir6Co6XCwnS2AOkWFvGdtNdLpaIz/SGiUrNYYQuIsEbGe+M?=
 =?iso-8859-1?Q?GjqRgXl7SQFRn41fCE71m69C57vyjHownBw1jC9qBFXHHFfX+PTds0o9k3?=
 =?iso-8859-1?Q?QnGxZgxut/ZNyaMzsGBFXu/BbIH0B1pEn64ldFETi2wNdCjNQrMn76XaKC?=
 =?iso-8859-1?Q?QJEYLmy5E3+pNoFNgcTzKkoAX/D5mYrM7k3V2ygl/E7ShCs6MigWisC4sp?=
 =?iso-8859-1?Q?+8zRxOAUV79+E1WOxo2fKip9iSjVynvnOORCwOlhlkAwDpE+fpr1thNKoG?=
 =?iso-8859-1?Q?zeAQ9/74JrpXethx8hzcYdbw2bajYIwR7hPRYTowDueDPOUSH/rcsS47tC?=
 =?iso-8859-1?Q?Ez65aKGNko8R/lxfxp++tTNzuOJBJLxLF2bz0scVwupVFhaOG8WeHJQeZi?=
 =?iso-8859-1?Q?A2B1ZlUtXE24dyU1veh7N8k/GRlgA2VBP1KqtEdJzHoDOXnL087yJwI641?=
 =?iso-8859-1?Q?RViSETZMI71V7pujhXwaR//pdEXf4+tLPpamicC5st/UK0S81LtBmlPUoD?=
 =?iso-8859-1?Q?C6r6dpaCU4wKvXy5OV0AD8kXvjs+aa8RSdiLmVqZxjMEc1Js9kyixBhOu6?=
 =?iso-8859-1?Q?LHhw+Ba116KsOJGOCM57yADkqSwLkgpGdR12nkhxic35ZgPdbVGeLbin+R?=
 =?iso-8859-1?Q?tJ04q3Cxs/aLkADMmS0gJf7Px/BaeZaxLO1d7abkBBgNFenX/j2sv8jIr7?=
 =?iso-8859-1?Q?UGbklpvZbt5Gu6ElbpcyKFJ9GJrmavNiPCFzIvQtE+Ud1306Yr0bn8MDdd?=
 =?iso-8859-1?Q?j7aKhczg3OgVtxCmWGwSCM3M7fD1zDFb4pkLPqxS4xF9binm0U/g7c1OmI?=
 =?iso-8859-1?Q?an+vaCHYl/c1Duo/tLWFlrZGbYi+cfXSrm+y+O2wJycEv4JbQ2E7rl3DBc?=
 =?iso-8859-1?Q?62aLfWZzrk/tG1gb6HGkU3Y4VVdno3u6IH9N45IWwulKXGD+pYPsjn6ePE?=
 =?iso-8859-1?Q?JqEEjK2RA/5anUc2ckZA2TzdDo0gocctLOYy8lDbiVOFmoNwop69mBJOsG?=
 =?iso-8859-1?Q?WM?=
x-ms-exchange-antispam-messagedata-1: 3m9G9+SdWf57yw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: uoguelph.ca
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9730.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 03436128-cf7b-4402-b447-08da22461bb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 20:49:33.3407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: be62a12b-2cad-49a1-a5fa-85f4f3156a7d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aG3peXq8p7cOnRmLJnn3DOli0U6HYF7CBKcrpZI3sQhsa0BzigMwyA2uVJXTfdKH+RMe6fWaZnD3xMAVL9N/Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB9499
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Chuck Lever III <chuck.lever@oracle.com> wrote:=0A=
> > On Apr 19, 2022, at 2:48 PM, Trond Myklebust <trondmy@hammerspace.com> =
wrote:=0A=
> >=0A=
> > On Tue, 2022-04-19 at 16:00 +0000, Chuck Lever III wrote:=0A=
> >> Hi Trond-=0A=
> >>=0A=
> >> Thanks for the early review!=0A=
>>=0A=
[good stuff snipped]=0A=
> >>=0A=
> >> However, one of Rick's preferences is that "auto" not use=0A=
> >> transport-layer security unless the server requires it via=0A=
> >> a SECINFO/MNT pseudoflavor, which only the kernel would be=0A=
> >> privy to. I'll have to think about whether we want to make=0A=
> >> that happen.=0A=
Just fyi, the above was not exactly what I thought.=0A=
=0A=
My concern with "xprtsec=3Dauto" was that the client (user/admin doing the=
=0A=
mount) would not know if on the wire encryption was happening or not.=0A=
As such, this case in not implemented in the FreeBSD client at this time.=
=0A=
(I may do so in order to ne Linux compatible, but I doubt it will be the=0A=
 default. Of course, it is really up to the "FreeBSD collective" and not=0A=
 just me.)=0A=
=0A=
For the "xprtsec=3Dauto" case, I am fine with the client attempting the=0A=
NULL AUTH_TLS RPC probe as soon as a connection is established,=0A=
followed by a TLS handshake, if the NULL AUTH_TLS RPC probe succeeds.=0A=
=0A=
At this time, the FreeBSD client does not use indications from the server,=
=0A=
such as SECINFO to decide to do the NULL AUTH_TLS RPC. The current=0A=
implementation does it optionally (just called "tls", which is the=0A=
equivalent of "xprtsec=3Dtls"), as soon as a connection is established.=0A=
=0A=
> >=0A=
> > That sounds like a terrible protocol hack. TLS is not an authentication=
=0A=
> > flavour but a transport level protection.=0A=
Not sure if I lost the "context" w.r.t. this comment, but I argued that thi=
s=0A=
should not be more "sec=3DXXX" options, since it was related to the transpo=
rt=0A=
and not user authentication.=0A=
=0A=
> Fair enough. We've been discussing this on nfsv4@ietf.org, and=0A=
> it's certainly not written in stone yet.=0A=
Yes. I cannot guarantee FreeBSD will become Linux compatible, but what=0A=
Linux chooses is certainly up to the Linux community. Since Linux is the=0A=
"big player", I do attempt to keep FreeBSD's mount options compatible,=0A=
whenever practical.=0A=
=0A=
> I invite you to join the conversation and share your concerns=0A=
> (and possibly any alternative solutions you might have).=0A=
>=0A=
>=0A=
> > That said, I don't see how this invalidates my argument. When told to=
=0A=
> > use TLS, the kernel client can still return a mount time error if the=
=0A=
> > server fails to advertise support through this pseudoflavour and leave=
=0A=
> > it up to userspace to decide how to deal with that.=0A=
>=0A=
> Sure. I'm just saying I haven't thought it through yet. I don't=0A=
> think it will be a problem to move more (or all) of the transport=0A=
> security policy to mount.nfs.=0A=
It happens to be implemented in the kernel for FreeBSD, but that=0A=
was just what was convenient for FreeBSD. (New TCP connections=0A=
for RPCs, including reconnects, are done in the krpc for FreeBSD,=0A=
so that is where it needed to know whether or not to do the=0A=
NULL AUTH_TLS RPC probe.)=0A=
=0A=
rick=0A=
=0A=
--=0A=
Chuck Lever=0A=
=0A=
=0A=
=0A=
=0A=
