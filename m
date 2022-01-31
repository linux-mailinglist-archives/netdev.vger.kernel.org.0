Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56794A4C63
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380574AbiAaQq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:46:27 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:46764 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243200AbiAaQqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 11:46:22 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04lp2052.outbound.protection.outlook.com [104.47.12.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 72C74740081;
        Mon, 31 Jan 2022 16:46:20 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diIz/qcdnlQO290Au8BbpTYdCPiQiE7TXPXOcg0ucgXD//FbKTO1kjyj4SGekwBBZvrksvVVKCCE+mkkg3ccw0nEZ13l7VOSsXVDoLfmYFDWD8Bf++T/dUymoYvH5ExRhEh+LT4762D8EcQZ7CgxXrry6+aYpdY+VymxYYlQCGHKqHO7Ovg9zaLxm/hpMpydYTY+D1+Ek1GUXajFExVy6Py5imToLpwg0qfPKYfpqichBXh2jOLKll6oybTS+SwynoHMvcNbFzbHCWgWa+4hji84oXdFif7oI2xjC76fYpFAOcjm77FzVLFfNABecoIfmFuqyx56kZ2babqyZtvXwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gRM8E4OrdvdAd6eZXpERlvSYY962KYst4S8kjVWs5+k=;
 b=INfXzNjusd4gmf6bD7z7aZnAT7yvbdja/IGnktivQY2kUkm9emfZZjAkWfU41K/HhMewKG8XrsoEzUcERea2raEjLYLEfxLiSswhwy/Xsjs7ZgBBd9pR8WQnuKyw/noRmFdG4Wdn27e+cRH5wvz3rZBm+lAJotc5F5q5yqUO+fzHrIj5uJzogq7bWR8x1TOQQ9QG9Tldc+3OdQQtoiLQkWu6+mI0Kdk6Y0vd1BC7WwU/ZPp8OXaLUFcXZbRlrHgif+enemWEBZvmG3a9w24P6XgxBoVAsLFE+bvLsDyKkx5NCnm2MfKEH1myi4iUBf8MmjmbUaUTHGlBHjmGSBNrHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ellipsbv.onmicrosoft.com; s=selector2-ellipsbv-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRM8E4OrdvdAd6eZXpERlvSYY962KYst4S8kjVWs5+k=;
 b=Dk/NrHqm6gBREX5vCACuLmFSRLJWqFhtur3AxNj0hC7HjRdKdExS9TCyam3GzKw4ExThStzN34wP4ofNkK846ObNdBi481c9sIyyaYvBw6DsI7PX7tkvNxv+uGoar7K8TDUAzgui14kemWu+W3/mYJdYNhkn5Dv7xMa8/vzX35k=
Received: from VI1PR02MB4142.eurprd02.prod.outlook.com (2603:10a6:803:85::27)
 by AM0PR02MB5938.eurprd02.prod.outlook.com (2603:10a6:208:18b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21; Mon, 31 Jan
 2022 16:46:19 +0000
Received: from VI1PR02MB4142.eurprd02.prod.outlook.com
 ([fe80::1515:7600:ca29:d90c]) by VI1PR02MB4142.eurprd02.prod.outlook.com
 ([fe80::1515:7600:ca29:d90c%4]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 16:46:18 +0000
From:   "Maurice Baijens (Ellips B.V.)" <maurice.baijens@ellips.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE:  [External] ixgbe driver link down causes 100% load in
 ksoftirqd/x
Thread-Topic: [External] ixgbe driver link down causes 100% load in
 ksoftirqd/x
Thread-Index: AdgN3k7I7vjd3hpWRMu+eZtY4Feu8gGfcZCAAAB+5EAAkOfqgAAH4Afg
Date:   Mon, 31 Jan 2022 16:46:18 +0000
Message-ID: <VI1PR02MB4142FB875F3C3D5714DB988188259@VI1PR02MB4142.eurprd02.prod.outlook.com>
References: <VI1PR02MB4142A638EC38107B262DB32F885A9@VI1PR02MB4142.eurprd02.prod.outlook.com>
 <YfQMQWsFqCIPBBqO@boxer>
 <VI1PR02MB41424341E3E7BA3166E043BD88229@VI1PR02MB4142.eurprd02.prod.outlook.com>
 <YffcB2YZ1h5SRyEP@boxer>
In-Reply-To: <YffcB2YZ1h5SRyEP@boxer>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ellips.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afd398ba-776b-43eb-1efe-08d9e4d9347c
x-ms-traffictypediagnostic: AM0PR02MB5938:EE_
x-microsoft-antispam-prvs: <AM0PR02MB59386DCDB72DCFBE5FAB89F588259@AM0PR02MB5938.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:40;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IYIzjqJixAi1QXzd1O5SIqaDINMItnsAdAvfl+rPuumzS4szHEtjhrkGVhPKYM6rPSwUyY+xzahDvYj1p9zN7M+/43bRHPoOTAibRV3r5jP2aBvR27dk3t1P8N941OTihkQORY/5SVFf2Ld1xRY+Bc+crX9jeUOKIJyUCYZmKI4naWL03x0scDi5c90z/k5btfyJyU0ueAZLgQP33SSjo9MgFh2T3TDN1Rvj+HIphIPnH36EmBpBAl9tVjh1FUP+F6wKaaqgYPDAp6YmSp4cxOfR3xPHD0Baa9Mt1oMIzuVSkcoDpe7xpS3vew9NfBynPlSGLI++UVT3NQ3QUobBrdaUfVPvCBFO+7diGmjnGfRdxzERHFPTg67ljk57soyhdrngFZB8w3hD64kLixNaL8TUciOPDn2UoWK6lvSwFecbdy5AmcZNYkUCbD2RUAziOjKZc8YqCHO+K/5PzpeAOSoZHCjCgJVzNAfFBADovkrjFUr3buxkBXT++vLLARaUhJ//OzM6E42pRSPTzTbrdc4JYaRaSDiSWyG1cUILiNeqriW/dYJFLq+IowiMtzdr0H2gMqSoeb4uYUr1V5qHrSfqIO3fNVAIOlWp3BQgIFIZ/zx3MwN3q3Qb1lXYnHYgPWszvum/sXJn8I/VZZGDrspxRdyzP3R734GLAtbTw5DJjUlzoZpPZoGXVm1fGNV6eZPJaLxtcWRIsGSmlfEsI14uHi+tYGAPJKE7oMh4x8QwZ9+UBK4RCBCe+Jm5FshFZ656LhHpQ1Unebp96T3PbB7uiXcqi12eI4TWOC5/cYI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4142.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(39830400003)(396003)(366004)(376002)(346002)(6506007)(186003)(9686003)(7696005)(38100700002)(71200400001)(6916009)(54906003)(53546011)(508600001)(122000001)(83380400001)(33656002)(26005)(316002)(19627235002)(66556008)(76116006)(66946007)(64756008)(66446008)(55016003)(2906002)(8936002)(8676002)(52536014)(5660300002)(66476007)(86362001)(4326008)(38070700005)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?41yXyU8qdpmXaVZjW8Li7uR1/9/7ZR5w9VFL9pwjLAfq6nrUN5zMWhxqtOZh?=
 =?us-ascii?Q?pxup3vxV+ET4/loyURyOo4YwpcMZliLIXLdABYrQMqnWz61ysb6hsTm7aXO+?=
 =?us-ascii?Q?jmX4s8/AEfOIBgUTVrfN1zTkrJE7S5izSNwU5v0reWIYCizxQm7ZuDGJLOFM?=
 =?us-ascii?Q?rlS1CPZ2QGfPfUU6OPEj7rfKct1WfOgs+5CxT7hWFaDAMdGRUelpsVv/RB57?=
 =?us-ascii?Q?mKKraVi+zeyYVmXOPGTHOj2S8S6VDIM+Gl8yhDS0+sqtXxdtbfBp+xW4QpWm?=
 =?us-ascii?Q?Cv1z6ULVhJgA7dY/k4/sqq1dVpHBwPuyMAJnGEUN+hz91bA2sCOCEy8ZL6KM?=
 =?us-ascii?Q?mg4j6VXQmyPMOR6VXIweN5yklTawJ1YPg2km9WsTO9cnLJL45tLK0dwSK25h?=
 =?us-ascii?Q?8f2CArWKowJEiT/7jCtxC+4LHylMwoL3nJicQcd+J/h+X/6MIuJswD4MEvL4?=
 =?us-ascii?Q?4RFFU3Ev8K77GAjoL2GXxvxwJ71O0Ylqbsn/naKUxA5t1KvY0LTclXlu0Qrj?=
 =?us-ascii?Q?mfPxtSgIEPShexug+XHJTlBThNoWwOV3V2ObSrmoT4nkmfnBgCxmZu9yDrxX?=
 =?us-ascii?Q?Ux9AzEOM5uZ5lpz2h42K4wQvbnIX8woV7AUg1LfzGC3Ccg/HKm9CwuTj7/Vx?=
 =?us-ascii?Q?CLR/k8Geu7xHqG+UiZdsRmzopxzGlZ1ScHuqu0mIk8k/Y07gxlNwuSWWCof1?=
 =?us-ascii?Q?PQ6owlLpJjNi4HXLO3RLtXQMjKa2y31mKSD1ImWS/cHwu9rX7yl+IH9YnSD6?=
 =?us-ascii?Q?wLK5XH7YGE8Xs2UEY84m5eVtUshGDASfNvzZh2nGx7dWBJfuC7fuDLh2dCks?=
 =?us-ascii?Q?XgNV7PDoNhbiSRpr0dmC4cggw8a2L9rM/4FTiDPmWEWdP0S7Bv6sTjiRclnM?=
 =?us-ascii?Q?R3yNv4TXhCFdcS7VboQ6fFu3zujjaQ/ZS8BcCCKLdvA3LxYo8STbKnEt5y0p?=
 =?us-ascii?Q?IY8g57vqslZ4zdw9B/xjKSEOYUT0dZqWHe/CE9SjM9Pn5GPcAZWfVwUtxIOo?=
 =?us-ascii?Q?64uYcdnpeVy4ov0Y3y6rAljDVDGmnYSWyaIEfVxLXri8DS9YtFFZY9rHKPeH?=
 =?us-ascii?Q?fAS4njeUroz4lPN6N/LcX121/HFwq/If7woWqZwG38csShAMuhg20kUrln9e?=
 =?us-ascii?Q?OhPqdd7nm0IilHwN17ImjLZB77jYFf54vn4ViehKE0ERTuFmo7v3iLtuHV70?=
 =?us-ascii?Q?CFtSwPyQp7c7Ncwwtha6Uwo7VkDcJiX5xd2Rc6Kjvb4uLHNXcmcxd5aAmJK7?=
 =?us-ascii?Q?WSLH8CZgusV5Tuk/N/I4kXJEsLBmucM6b+OC1DziW7XMImLaaV636020tXZA?=
 =?us-ascii?Q?cVwGG5Nbt4p8qOKb4Jo8NDIHcJcazCU+8DluzyW9B862+OHmGYUvYbYoynTy?=
 =?us-ascii?Q?KnFZR/Grho6yjhz5TYQuEnDYL1C37ADtGKKICCuJk0dZ0duyPsQoS6aqUepj?=
 =?us-ascii?Q?UccSBw3cZ+slpYdsssUzjTG7C2CQb9Mp2hS0GBjAv67+RgaH8t/2jlrEEZ4r?=
 =?us-ascii?Q?v2QYpWCZGnDFwWJBSnMHODOHlD55mdCfOL+RScNTmQJBs0HR7ug7Wlz1YyQs?=
 =?us-ascii?Q?mza/NwXuEv2CHGnslxlSGGeCJGMSZ573TCgAE33S8g2jRHUM0I7QCp2/iA3w?=
 =?us-ascii?Q?0RHLPXTqh8zVVo7n0DO77ys=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ellips.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4142.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afd398ba-776b-43eb-1efe-08d9e4d9347c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 16:46:18.7971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53a902d4-22e7-42c6-a1ea-5776f15ccd54
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cNCZQEvXft4VcyqWgbJHbqGetIKSgb1kGY+zIrNe/C76b0gf2C+ROrNAYVeFL0X+2eQB/OZssNe7ZqN4iUuf4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR02MB5938
X-MDID: 1643647581-MNljtv4Gw8vd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Monday, January 31, 2022 1:55 PM
> To: Maurice Baijens (Ellips B.V.) <maurice.baijens@ellips.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org
> Subject: Re: [External] ixgbe driver link down causes 100% load in ksofti=
rqd/x
>=20
> On Fri, Jan 28, 2022 at 03:53:25PM +0000, Maurice Baijens (Ellips B.V.) w=
rote:
> > Hello,
> >
> >
> > > -----Original Message-----
> > > From: Maciej Fijalkowski <https://urldefense.proofpoint.com/v2/url?u=
=3Dhttp-
> 3A__maciej.fijalkowski-
> 40intel.com&d=3DDwICAg&c=3DeuGZstcaTDllvimEN8b7jXrwqOf-
> v5A_CdpgnVfiiMM&r=3DNxLR614ZckGV5qreAH7T-
> KBzf9aH_cn2IL_xVeWucP8&m=3DPDk-
> KhtpjXSlUONxhTse4JFtYC9S6TMfLfPVM4OnaAw&s=3DXqggXdJZq9zUpID-
> n7f0x7GlFkQ3g1pw5Tnj5-12K6U&e=3D>
> > > Sent: Friday, January 28, 2022 4:31 PM
> > > To: Maurice Baijens (Ellips B.V.)
> <https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__maurice.baijens-
> 40ellips.com&d=3DDwICAg&c=3DeuGZstcaTDllvimEN8b7jXrwqOf-
> v5A_CdpgnVfiiMM&r=3DNxLR614ZckGV5qreAH7T-
> KBzf9aH_cn2IL_xVeWucP8&m=3DPDk-
> KhtpjXSlUONxhTse4JFtYC9S6TMfLfPVM4OnaAw&s=3Dx60OZ4vNqH_9ek3VtAj2kivB
> bhhEHHk2LbxW5Kf4Ngs&e=3D>
> > > Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org
> > > Subject: Re: [External] ixgbe driver link down causes 100% load in ks=
oftirqd/x
> > >
> > > On Thu, Jan 20, 2022 at 09:23:06AM +0000, Maurice Baijens (Ellips B.V=
.)
> wrote:
> > > > Hello,
> > > >
> > > >
> > > > I have an issue with the ixgbe driver and X550Tx network adapter.
> > > > When I disconnect the network cable I end up with 100% load in
> ksoftirqd/x. I am running the adapter in
> > > > xdp mode (XDP_FLAGS_DRV_MODE). Problem seen in linux kernel 5.15.x
> and also 5.16.0+ (head).
> > >
> > > Hello,
> > >
> > > a stupid question - why do you disconnect the cable when running traf=
fic? :)
> >
> > The answer is even more stupid. Due to supply problems we sometimes hav=
e
> to use
> > dual adapters instead of single once, and if one by accident enables th=
e wrong
> port,
> > the bug is triggered.
> >
> > > If you plug this back in then what happens?
> >
> > Then everything works normal again.
> >
> > >
> > > >
> > > > I traced the problem down to function ixgbe_xmit_zc in ixgbe_xsk.c:
> > > >
> > > > if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
> > > >     !netif_carrier_ok(xdp_ring->netdev)) {
> > > >             work_done =3D false;
> > > >             break;
> > > > }
> > >
> > > This was done in commit c685c69fba71 ("ixgbe: don't do any AF_XDP
> > > zero-copy transmit if netif is not OK") - it was addressing the trans=
ient
> > > state when configuring the xsk pool on particular queue pair.
> > >
> > > >
> > > > This function is called from ixgbe_poll() function via
> ixgbe_clean_xdp_tx_irq(). It sets
> > > > work_done to false if netif_carrier_ok() returns false (so if link =
is down).
> Because work_done
> > > > is always false, ixgbe_poll keeps on polling forever.
> > > >
> > > > I made a fix by checking link in ixgbe_poll() function and if no li=
nk exiting
> polling mode:
> > > >
> > > > /* If all work not completed, return budget and keep polling */
> > > > if ((!clean_complete) && netif_carrier_ok(adapter->netdev))
> > > >             return budget;
> > >
> > > Not sure about the correctness of this. Question is how should we act=
 for
> > > link down - should we say that we are done with processing or should =
we
> > > wait until the link gets back?
> > >
> > > Instead of setting the work_done to false immediately for
> > >!netif_carrier_ok(), I'd rather break out the checks that are currentl=
y
> > > combined into the single statement, something like this:
> > >
> > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> > > index b3fd8e5cd85b..6a5e9cf6b5da 100644
> > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> > > @@ -390,12 +390,14 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring
> *xdp_ring, unsigned int budget)
> > >  	u32 cmd_type;
> > >
> > >  	while (budget-- > 0) {
> > > -		if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
> > > -		    !netif_carrier_ok(xdp_ring->netdev)) {
> > > +		if (unlikely(!ixgbe_desc_unused(xdp_ring))) {
> > >  			work_done =3D false;
> > >  			break;
> > >  		}
> > >
> > > +		if (!netif_carrier_ok(xdp_ring->netdev))
> > > +			break;
> > > +
> > >  		if (!xsk_tx_peek_desc(pool, &desc))
> > >  			break;
> > >
> > >
> > > >
> > > > This is probably fine for our application as we only run in xdpdrv =
mode,
> however I am not sure this
> > >
> > > By xdpdrv I would understand that you're running XDP in standard nati=
ve
> > > mode, however you refer to the AF_XDP Zero Copy implementation in the
> > > driver. But I don't think it changes anything in this thread.
> > >
> > > In the end I see some outstanding issues with ixgbe_xmit_zc(), so thi=
s
> > > probably might need some attention.
> > >
> > > Thanks!
> > > Maciej
> >
> > Your suggestion for a fix sounds ok. (I have not tested it). Is someone=
 going to
> fix it in the next version of the kernel,
> > so we don't have to apply a patch here forever? Or how should we procee=
d to
> get it fixed in the kernel?
>=20
> Could you test it then? If it's fine then I'll send it as a fix. I just
> don't currently have ixgbe HW around me.

Tested it and seems to work fine, so please send it as a fix.

Thanks,
	Maurice


P.S. I used following patch as you suggested:

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/eth=
ernet/intel/ixgbe/ixgbe_xsk.c
index b3fd8e5cd85b..6a5e9cf6b5da 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -390,12 +390,14 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring=
, unsigned int budget)
 	u32 cmd_type;
=20
 	while (budget-- > 0) {
-		if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
-		    !netif_carrier_ok(xdp_ring->netdev)) {
+		if (unlikely(!ixgbe_desc_unused(xdp_ring))) {
 			work_done =3D false;
 			break;
 		}
=20
+		if (!netif_carrier_ok(xdp_ring->netdev))
+			break;
+
 		if (!xsk_tx_peek_desc(pool, &desc))
 			break;


