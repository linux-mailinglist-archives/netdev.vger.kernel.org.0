Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2154126F9A5
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 11:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgIRJyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 05:54:37 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:54502
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725882AbgIRJyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 05:54:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOUd1+4/PYUpSVsGarhPHqJG9Ubuv4nJ9F2k6r6DPvzEUf6CrnshrJjl5hyhzMrZAIEhUpP/RRLbCnOYydaTAh3TrXydlVpguzyeACovrxX3jjLdKHaxTgKziSkd81UZ8EOfT8AFxLeX6KIC5VGFnIBLnMINgPzXq60zhbuTUrss2OUnCIXQJPOphsyhCE1Q46xHg7c7dw9BRxBb/MvkEIbNONUc7D/Aq4clke8MwOW6rWNytu1qG1GCmAfJRO0n8kZweAAp1gLt77O814b1MXaCM3rhNryRxL9ICO3YEccKTwdIx9v3n0VVPguP0k/Q/Jns40Qn0kQKnyunoMjd7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wB85v2m/DXSckiRey+9n6LZ2oAqhkQkkGvHUsba+w+k=;
 b=cjh6HPkGsviv+8Kp1hDZEC2m4REcu7TPOnOlxHkNeZ6lV4lqn5S3ewxktYzcWEXQ/fs+X1pstxfqA0APUWnI30iAz/tbIbtuxeNewoWpY733NtDxsKG8qNgyy5cPER4U/sFFoqliaiPIpzH03k2c5JLj1WfRdSPWFlvTw9rO68Ns3Frlz7AYCDsKmbaHPYv6HgTbzjtBCPN2vhjjf47PFvJHLOPbStLeZivD9B/+j3X8fQtSIWS7NpAoDtp+RTJ0N/AjWFs1rrm/DHwHmmlZnv75Icc7j6ksbj7zOeDu5cxDIIXi/2RMqfM4q3w0JD0qx/GcUIzucu8bA3/0B1phFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wB85v2m/DXSckiRey+9n6LZ2oAqhkQkkGvHUsba+w+k=;
 b=jL+3ogYF59+P0Y4VmKXWObpPVmDzUYlnbLzHscAdXzNaq9wvPEHw1HbfqUYfGpyMMO48KMySlqAdL7EtClX9mgug4J49SxcQ7Pmpq5iyJjTMpF3tbriCeIo9wExlzXFPzxsnItW8G9l9Y+dKc3Td1A/UfWazzIsl6CB+AUecogE=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Fri, 18 Sep
 2020 09:54:33 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f431:1df6:f18b:ad99%7]) with mapi id 15.20.3391.019; Fri, 18 Sep 2020
 09:54:33 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: RE: [PATCH 2/2] ptp_qoriq: support FIPER3
Thread-Topic: [PATCH 2/2] ptp_qoriq: support FIPER3
Thread-Index: AQHWiLYnS60GwCLmLkeYj1HDTaCRqallVIqAgAjdKKA=
Date:   Fri, 18 Sep 2020 09:54:32 +0000
Message-ID: <AM7PR04MB6885E17BF90F4CB9F2E78583F83F0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200912033006.20771-1-yangbo.lu@nxp.com>
 <20200912033006.20771-3-yangbo.lu@nxp.com>
 <20200912183151.y5e4rjsfiiy57chm@skbuf>
In-Reply-To: <20200912183151.y5e4rjsfiiy57chm@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 73839ef5-14ab-462e-8eae-08d85bb8d818
x-ms-traffictypediagnostic: AM7PR04MB6885:
x-microsoft-antispam-prvs: <AM7PR04MB6885BB51D494C74FCEF5EE52F83F0@AM7PR04MB6885.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P4q/iqQJWXTCYcWqIRZKdpwSLsaEMbVxcC9NW6eookhvkVRPc1tLdL2Jsf4+el8IvaGHX6oEbW885jWN1ssLZWwh9xyDmLl7P2wDkF+SVjRDHUpyj61m0oVkrs5iGW1bqScQ+h/lhhiZMhWfIYJaMiDBu+LxfP+PWNUA6kNuKdVOlebPenvWw0UshHHj6aNsfq6ktsN9kTVkgEAak3E09sPWGkkZvAHSP+Uqh+51znSBZGFKXitXAjOplIUCjDCJo2qvYe4Mmc4BQOUzNFjWELooDNrYiTKYs7YwVaYdTebtBAJe+LLQ0tr5yL+rxnQ7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39850400004)(366004)(86362001)(478600001)(8676002)(4326008)(54906003)(186003)(26005)(7696005)(33656002)(83380400001)(6916009)(66446008)(66476007)(66556008)(64756008)(76116006)(8936002)(55016002)(66946007)(2906002)(4744005)(6506007)(53546011)(5660300002)(9686003)(52536014)(71200400001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TJ7jazfhc53KvcPK3Eb2hM8xifN7KNoDEq4jzUM2XviHuOj9RRx2rVRW2lOVrASRYZrSaEqx4Zx5pf+et1P/OYJinCRtT9USLLT/mxqqAnTYpiuQvrx6FI60WMgSji7sfJOkAjprHCRcve4mS5fzE+eqvkRI9dE+e7hb3rTBSPwYTVhsHzrQ9/rrj1yPAmm5qAr8SG09fkSOlJtptEpKZW7n7Vi/4UE8egdpj8Xf0RnJiwPfjHXZHrBD4XVFzVppIB8DeHFkqPYUGaW10dfGmxnu01K7boyz4LZw12o5L/w7n5K1lmMM1CbDZbAWVLXoFmBFiHRt8kYlJO6421nY/+4muCXcvRGNTt5ArTE0B/XdrjYYYeIcMoLMxjgfdpue9Wv0IV02Bnq0pX01eI7Zeme1MBHeRinqv1fbF2Pz83r97P2w+nuDtlR7i8Vsu3EiVbpvQB4LWdpjc2pQZWb6vlfx2TWhQ7v5Hzpb+DbflL53Poh7gCOmEWI6dx2fi8tfbe/Ac/NI6MDq0CYsfYuyoDPH3fMZhpoTK13um0giG2HBJGiUW864kXUY9pjuIHpbkgRBSF/minP2NYYO71l1g5Tqbr0SvUcwRqM2I1bdt0qM+p39EcirO/0ZwTtxpv67gMgCOeGi0yRadiMrE2bIig==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73839ef5-14ab-462e-8eae-08d85bb8d818
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 09:54:32.9796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7arKspGbZqSlMyKck3pLStTKmsq6DAtwaX7Tpud2as3KnhVAjzYBDRe/Mywqk8pQ5TgYkE/gonvoOi8MbKPMBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6885
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Sunday, September 13, 2020 2:32 AM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: netdev@vger.kernel.org; devicetree@vger.kernel.org; David S . Miller
> <davem@davemloft.net>; Richard Cochran <richardcochran@gmail.com>; Rob
> Herring <robh+dt@kernel.org>; Mark Rutland <mark.rutland@arm.com>
> Subject: Re: [PATCH 2/2] ptp_qoriq: support FIPER3
>=20
> On Sat, Sep 12, 2020 at 11:30:06AM +0800, Yangbo Lu wrote:
> > The FIPER3 (fixed interval period pulse generator) is supported on
> > DPAA2 and ENETC network controller hardware. This patch is to support
> > it in ptp_qoriq driver.
> >
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> > ---
>=20
> Would you also want to add the debugfs support for the 3rd FIPER
> loopback?

No. Because I didn't see loopback support on FIPER3 in RM register.

>=20
> Thanks,
> -Vladimir
