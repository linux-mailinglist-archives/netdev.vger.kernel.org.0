Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE1F227A0C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 10:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgGUIAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 04:00:54 -0400
Received: from mail-eopbgr60073.outbound.protection.outlook.com ([40.107.6.73]:63982
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726607AbgGUIAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 04:00:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZyLcihTesOZUL3E1bgTMxMlSRfyDx1Iq+kBHqnnT3gUQVIFElLlDrPZPLsubXVU6trH9h4ej30jUmOPWxU+Shcm0O5gQ/XrTV3T/e2fLnAhr9NKHbFuZyzhWEqOlq+vxPInFIheM4Alqj7wWgInBnBro/Zn9uG0BrY+EQDGmSj7M8W9aqPYP8WIwvnTa1GRd3vsSPv9EL36K7se2AC/jUOgUHGIv0PD2nYlTLLT7vNwUOM62hlAUNZVW5/Ts8HEeVqzqIgbEC6wwxi3+LoW8cJlaDZUFNkG+Sn/prenHVTSqA+La+XtZfUuqGbVf3XE96/oJlp7hTrdA3S3nszZsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGca07+PNNjluzouHu/S+pTvNdno0x/kDMa20pu8XjQ=;
 b=F7AmLiklC4iAIfiyFSC/V5urYz431+MyHfuREfHTRk02lc0GziEEWk6yBtbG4emsyzFMKAuJ9asMPSRJpXrE0S1vJE20l00+imITEo3BuFk3CKeHlLzztYKnTaNbSrSHuq9iu83r+22SUjrouDi6XVDCBrdjMy3fvXAV1t9yj41DOuBrMOyHVDncAfbuDys94sZ2TVXM+1vBr7XxpbtGUXc2sppj46OBDYxCmXL2tWJ02slqVMhzCW5YOkyTXXOsjWnGEz7B2XafSywvpyxQXHHn7s3y1BFhF8dFSF2DrUqxOwNo187eRyebYX8MWG4BYPA2RL42HOf1L4isjAesCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGca07+PNNjluzouHu/S+pTvNdno0x/kDMa20pu8XjQ=;
 b=nsfK0IQmvtCTdWA6Gen+hLFrRNSoq8tsbMdhFI5kEZCO/5ogxrdooBoQHGnkWKWTyn89Jak3b/QvV8+6/0lZlO1VyCcBXtUGQYTgkw9Zx9kJlNm9ycaSGrgPymQPKqIJrdNneBhkK2l0u2AIMmeiK8uFtFnSTKjjksLNZJgvcUA=
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com (2603:10a6:10:10d::31)
 by DB8PR04MB6539.eurprd04.prod.outlook.com (2603:10a6:10:105::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 08:00:47 +0000
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::b05c:ed83:20b9:b2f9]) by DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::b05c:ed83:20b9:b2f9%6]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 08:00:46 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2 5/6] enetc: Add interrupt coalescing support
Thread-Topic: [PATCH net-next v2 5/6] enetc: Add interrupt coalescing support
Thread-Index: AQHWXFAl/UpaXYhHeU+sSQSdaFN1PqkMKW+AgAFtUQCAAx6vAIAA+zpQ
Date:   Tue, 21 Jul 2020 08:00:46 +0000
Message-ID: <DB8PR04MB67644D35E9D45F757CB4F76396780@DB8PR04MB6764.eurprd04.prod.outlook.com>
References: <1595000224-6883-1-git-send-email-claudiu.manoil@nxp.com>
        <1595000224-6883-6-git-send-email-claudiu.manoil@nxp.com>
        <20200717123239.1ffb5966@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3852bad5-76ca-170c-0bd5-b2cc2156bfea@gmail.com>
 <20200720095846.18a1ea73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200720095846.18a1ea73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.66.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 48138ce0-8fce-4b07-3dba-08d82d4c2d0d
x-ms-traffictypediagnostic: DB8PR04MB6539:
x-microsoft-antispam-prvs: <DB8PR04MB65390119C583A0D9B66B9DDF96780@DB8PR04MB6539.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 44ZsYBuu6cP/VPZ5TT8VGSmaA5c+deQHYlj5YJHUgKmR/kawSkFmbCq6cXQcP+dVK+cAWZNPPs08wEbUNt69muwi8abEWpksSHsqtzDnBMg8uBUI41KD9mae7JHXcZ/rv4AiEHUx6BhGEsnga8ftEN7nd4JY1ROhq6yOZ/AIfG5GznIiWHX7TqnX2+/2bGUVVGoP5i5/cdDx3qk4NZy0Axz6GUlKcNB9Yh6pv2qUTBhTFcvzjeX8DxRzvDP1rfbJI49lBmzpf06yKWfAGdXeZ2WSJrnsjmJI28xcvc7LSIuQhp4gljN6t8KpC4riIowLJOtFcSM6S+pxw0YCktFbyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6764.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(76116006)(71200400001)(316002)(8936002)(6916009)(9686003)(55016002)(86362001)(52536014)(83380400001)(5660300002)(8676002)(54906003)(26005)(186003)(53546011)(6506007)(7696005)(4326008)(33656002)(44832011)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: g3ung+4THi9c1z8+7EHgCDe5TFGe56wRCML+W3WzikmDZesG5cDoIFVYQdYCDvMwk8mYnQNly/KcQkTjd4mDaLcAycSh+PQgUOKYK/zzJlK3AAdhNkpH1M8jp/ghngJwinY9tq/rzJ0oq1AkEvcmJHAU9679k00kpffGv20hwDqv3PsOxZRARqdz74KZhLBZjS518zCJSIEcvPB9rVBMqzjQJzEDw9GHVHgGv+0/O2PGIUA6UHDbUOcIuE8UjTynvys/tF4JqwX9ZWjzorSe6tpZygluyulFdd/8oy29QC8DtkH6PCcPGsgzMZp2p/HftjrwXubOLEZD7hGXGdtz2CGSr3Vq7zyiIY0VlB6ySAMcPpODGcYZApi9MJA/qIXvTGylJYdY70zVEHsGjNI6ALrPxlbz2mCJW1rdvjLMDGAQksOrKv6aboo6V2PmJH+J9oJrsHlOdnewidn4DmGqS8zWILJafsVARxJMY3aRdak=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6764.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48138ce0-8fce-4b07-3dba-08d82d4c2d0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 08:00:46.8342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U/2ue1PSclsQX3XYKPMeZUrVemaAjMYvxiLS1ZYyOn5Itk7L6KAaain7L7M0yk/uQMIj3YlMOVzIcAsPdvvGeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6539
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Monday, July 20, 2020 7:59 PM
[...]
>Subject: Re: [PATCH net-next v2 5/6] enetc: Add interrupt coalescing suppo=
rt
>
>On Sat, 18 Jul 2020 20:20:10 +0300 Claudiu Manoil wrote:
>> On 17.07.2020 22:32, Jakub Kicinski wrote:
>> > On Fri, 17 Jul 2020 18:37:03 +0300 Claudiu Manoil wrote:
>> >> +	if (ic->rx_max_coalesced_frames !=3D ENETC_RXIC_PKTTHR)
>> >> +		netif_warn(priv, hw, ndev, "rx-frames fixed to %d\n",
>> >> +			   ENETC_RXIC_PKTTHR);
>> >> +
>> >> +	if (ic->tx_max_coalesced_frames !=3D ENETC_TXIC_PKTTHR)
>> >> +		netif_warn(priv, hw, ndev, "tx-frames fixed to %d\n",
>> >> +			   ENETC_TXIC_PKTTHR);
>> >
>> > On second thought - why not return an error here? Since only one value
>> > is supported seems like the right way to communicate to the users that
>> > they can't change this.
>>
>> Do you mean to return -EOPNOTSUPP without any error message instead?
>
>Yes.
>
>> If so, I think it's less punishing not to return an error code and
>> invalidate the rest of the ethtool -C parameters that might have been
>> correct if the user forgets that rx/tx-frames cannot be changed.
>
>IMHO if configuring manually - user can correct the params on the CLI.
>If there's an orchestration system trying to configure those - it's
>better to return an error and alert the administrator than confuse
>the orchestration by allowing a write which is then not reflected
>on read.
>

Good point, ok.  Updated accordingly in v3.
Thanks.
