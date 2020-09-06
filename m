Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FA525EC40
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 05:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgIFDIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 23:08:51 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4708 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbgIFDIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 23:08:49 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5452900000>; Sat, 05 Sep 2020 20:08:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Sat, 05 Sep 2020 20:08:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Sat, 05 Sep 2020 20:08:48 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 6 Sep
 2020 03:08:48 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sun, 6 Sep 2020 03:08:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dp8MZsZjRxsQV2k72mAJ0arNXGrklBS379LPPPBPp5UWhcdmAPNzxdNaGrFZTW/FuH3Jjep3JtetGb1sYhVZt41znPypiGvcoh8NrDIixYZz9GGNFTkQmM6upIkWWTlTneyppVKu7wr94C5l2sap+NJWDzix5d68cZcOVQ/2FNILjIMPmKA6LeqNR0ZSIHNGLrM39bMnFeXex3le6VaZP6HMqJukjiyAiNVZ6FLID2xdaAYFKsSEOhJHwZezVCwKPILn69bf1uxKGQ26vANLFs+JPngFu3W9fCwxM+BvjhO9Pz91JTvc//JwUlv5oc3s+P8+UAOdHNDIxlzp+WHBpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzJqAQ6fRVdmkHsb0kWKW5qKUylvDuOWekI6MegxpRQ=;
 b=MTk13sWatUem7cQFWxBo7FtPCjJJPV2m8Z44nhA3vjsYPTqtg/LqAg/Pbs2kHgCxAxX+LctFofq+7ZppbD3FUMqD0Z25knJMQtyiiXvvLPBn+nr+YJxwL7ikScUf1cez0QrSudohP+G4lPunpZ7qkoHah/GigyL5bnbrFntOcVv3INNlQR4L7B/7AfuGrPx20V3KSANzJW2GjkaCcDF85EMZE1riNb5hXal5ivCsdZAJ9wsn7bTziKaLCXkEogZW8oU3F9E+Ta7tJ7V79O7caorz3zTkNl76WHEsj6kIGakDpmi8CosExuUH5NOYycYDvtqryA041gkNKyo6A+3A3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2646.namprd12.prod.outlook.com (2603:10b6:a03:65::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.19; Sun, 6 Sep
 2020 03:08:45 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3348.019; Sun, 6 Sep 2020
 03:08:45 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Topic: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Index: AQHWeugVEZjy8+Bcu0qKDL1vbGgf/KlJitKAgABAGdCAAQhmgIAAinbQgADtLwCAABeykIAAHVgAgABmzECAANgrgIAAsB0AgAUMOQCAAAZkMIAACfwAgADMOwCAAHEaAIAAP1eAgAB7/gCAAPNEgIAA5DGAgADdRoCAAsRjkA==
Date:   Sun, 6 Sep 2020 03:08:45 +0000
Message-ID: <BY5PR12MB43229A748C15AB08C233A792DC2B0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200901081906.GE3794@nanopsycho.orion>
 <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200901091742.GF3794@nanopsycho.orion>
 <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200902080011.GI3794@nanopsycho.orion>
 <20200902082358.6b0c69b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200903055439.GA2997@nanopsycho.orion>
 <20200903123123.7e6025ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200904084321.GG2997@nanopsycho.orion>
In-Reply-To: <20200904084321.GG2997@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3907a57e-1836-4fda-51bb-08d852122af8
x-ms-traffictypediagnostic: BYAPR12MB2646:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2646278CEAB07CDABB74FD6EDC2B0@BYAPR12MB2646.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ofdHtmUBh1YSqBrPIDHljJ6UOz+ccAJxZxl33aBDtP7/nhQ+I4C0gBX9q3vtb3nS8yCjUl/nP5sX6PrgbUvBR6gNEQ2nk/wrb0ryBnbZYQwKUm3jokiY74o2YFBa2TMVbRzDtZxAfZhGJNf0LwqBzpvIVc6tCgtsLoI9ABeShqzn062j7Dz7vsy7jcKHHPKc8kahcpj+WOAtoSoMFxFE2h67CfRbU/04r/dLiaVzih6ne1oVPfwj/f5Y8sHvE8WHW73nD6ZhVE1XqFoKFoPUUVlQspPg+o9D1CzKy+OuPRNoTlV/8AvCQIJrR6/M/1JyY2kR65UKJezISgHJP8I5wQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39850400004)(33656002)(7696005)(83380400001)(4326008)(86362001)(9686003)(6506007)(107886003)(110136005)(54906003)(71200400001)(55016002)(2906002)(5660300002)(186003)(66946007)(66446008)(64756008)(66556008)(66476007)(26005)(76116006)(52536014)(8676002)(8936002)(478600001)(55236004)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Ita9QTE8EtPH/DZksXN9ZR88Yrx8ZuBBLmm3VNMTCHu1XEE4G+HcQNC0GiqQ3qW6HcIzsLjQMJDFMKXlJ+N6FP+hUjuBa+D+2VINQubv0NH0HGB8r3S+PryJT32xD8ANlwHci2dmZJuKcjLHxmjXhJfnKTfVczX+W8/cykSJ9TjdiPSk9lDok17kGom7ay0nTbsHC74T2wCji3YMc9zV526S0FCu1TinBntfJ/m+w4I78+FXdQ68/Plf8l8eLeKtSYhFuKIybPi5aUjt3+kzoS01iBi+xGjTSGf8fm2AZ35liBtO7tTSTTcC9HlXDm2d2sXsKCUoX1j5KP2sRKMVJYuyaIPzQtR73Jh8sJvABv2AqzeeT0WhScgpiCTwzlPJLDuKy68JmF/9yoMUW9tqzZsYbjEyQLgl3qqnyzD+igJkjbYaLoRwGS5z+Mha48TqrQoyOm3ThhwR5YQwZ14LBHWKQgyrQGg1+W33XkMM2hnlnxhHUN8U1M4HA9dvteaVQ3Kbc/sD4hLguaIEWwoc43lMQvYvcmoUUkwFPR/TFKQ1SH9ZZb6DO2r99Qel13VzV1qCXZEINOJkWvXInKJNAAtH5X6ViLZr8xAjk0XqA99HatqjHH/oxqKZJox5l357dTqVBl+4+0xQkfLJCE0spQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3907a57e-1836-4fda-51bb-08d852122af8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2020 03:08:45.4739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YWCT5Rt9I7w8COq490USvK+4cIoLLP1AU58ApaKpBYpSuBrz5lhyI9kGbPzYbRaiGycYH86zeNG5WzprvVLTnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2646
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599361680; bh=pzJqAQ6fRVdmkHsb0kWKW5qKUylvDuOWekI6MegxpRQ=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=bzO5FZczFkNT/PBGBwZo/d1Kc+FpvEkNcEptvFmpc1pEdQfa3HLo/XrCWeCoSnrf5
         Lil54qhvlKFq3diHbIsHES7KKpyePSfMbJhimE3Saof9MfRpbIciuZeIgEUzEe5lof
         IwvXebTmkhGNKToV1vspcX5gkB5HkJMzPzf3ePsoMUrZiv1okVpETWsX56m3ghWpoS
         7Q+wLU7qbYK/t8hDPkB2mdKm7OTcpTnBDjZXYH61rDAdTLKwfo7AZx2MpC6qrVxqUA
         qPG2qVTfpT7VEtn3IvV+4bf+JiFO8XPpsYZfXbndO9SXx9YHZlL4WyNfYcXqVd0exm
         KFDGkHpVYA8ig==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, September 4, 2020 2:13 PM
>=20
> Thu, Sep 03, 2020 at 09:31:23PM CEST, kuba@kernel.org wrote:
> >On Thu, 3 Sep 2020 07:54:39 +0200 Jiri Pirko wrote:
> >> Wed, Sep 02, 2020 at 05:23:58PM CEST, kuba@kernel.org wrote:
> >> >On Wed, 2 Sep 2020 10:00:11 +0200 Jiri Pirko wrote:
> >> >>>> I didn't quite get the fact that you want to not show controller =
ID on the
> local
> >> >>>> port, initially.
> >> >>> Mainly to not_break current users.
> >> >>
> >> >> You don't have to take it to the name, unless "external" flag is se=
t.
> >> >>
> >> >> But I don't really see the point of showing !external, cause such
> >> >> controller number would be always 0. Jakub, why do you think it is
> >> >> needed?
> >> >
> >> >It may seem reasonable for a smartNIC where there are only two
> >> >controllers, and all you really need is that external flag.
> >> >
> >> >In a general case when users are trying to figure out the topology
> >> >not knowing which controller they are sitting at looks like a
> >> >serious limitation.
> >>
> >> I think we misunderstood each other. I never proposed just "external"
> >> flag.
> >
> >Sorry, I was just saying that assuming a single host SmartNIC the
> >controller ID is not necessary at all. You never suggested that, I did.
> >Looks like I just confused everyone with that comment :(
> >
> >Different controller ID for different PFs but the same PCIe link would
> >be very wrong. So please clarify - if I have a 2 port smartNIC, with on
> >PCIe link to the host, and the embedded controller - what would I see?
>=20
> Parav?
>
One controller id for both such PFs.
I liked the idea of putting controller number for all the ports but not emb=
edded for local ports.

>=20
> >
> >> What I propose is either:
> >> 1) ecnum attribute absent for local
> >>    ecnum attribute absent set to 0 for external controller X
> >>    ecnum attribute absent set to 1 for external controller Y
> >>    ...
> >>
> >> or:
> >> 2) ecnum attribute absent for local, external flag set to false
> >>    ecnum attribute absent set to 0 for external controller X, external=
 flag set
> to true
> >>    ecnum attribute absent set to 1 for external controller Y,
> >> external flag set to true
> >
> >I'm saying that I do want to see the the controller ID for all ports.
> >
> >So:
> >
> >3) local:   { "controller ID": x }
> >   remote1: { "controller ID": y, "external": true }
> >   remote1: { "controller ID": z, "external": true }
> >
> >We don't have to put the controller ID in the name for local ports, but
> >the attribute should be reported. AFAIU name was your main concern, no?
>=20
> Okay. Sounds fine. Let's put the controller number there for all ports.
> ctrlnum X external true
> ctrlnum Y external false
>=20
> if (!external)
> 	ignore the ctrlnum when generating the name
>=20

Putting little more realistic example for Jakub's and your suggestion below=
.

Below is the output for 3 controllers. ( 2 external + 1 local )
Each external controller consist of 2 PCI PFs for a external host via singl=
e PCIe cable.
Each local controller consist of 1 PCI PF.

$ devlink port show
pci/0000:00:08.0/0: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0 cnum=
 0 external false
pci/0000:00:08.0/1: type eth netdev enp0s8f0_c1pf0 flavour pcipf pfnum 0 cn=
um 1 external true
pci/0000:00:08.1/1: type eth netdev enp0s8f1_c1pf1 flavour pcipf pfnum 1 cn=
um 1 external true

Looks ok?

>=20
> >
> >> >Example - multi-host system and you want to know which controller
> >> >you are to run power cycle from the BMC side.
> >> >
> >> >We won't be able to change that because it'd change the names for you=
.
