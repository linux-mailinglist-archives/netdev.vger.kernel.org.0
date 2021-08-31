Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6883FC4D0
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbhHaJIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 05:08:53 -0400
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:18528
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240370AbhHaJIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 05:08:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZMXwBS1D39+5lx0ePqiFwXoNn/CLAwfgiS3uuAjTLW+yVLfIn/jlN3I7+56pwPQ9KbC5PttKD2j42UXSi+4cjnir5a14C09h3UeHq49/tpyIs+Mv5BqyoV0tQZnEDfUMwuJf7mz+EULtrqBptysPZhIHf7l+CSq0FjrXsbUbtY3r0e7Gk+Sem97TaQ09+LwPmBEXWm4xBu4KR4cr3t11GL/sQADeX54trJRUYsm2ULcu/fPTJrYAEW3VOLZgHXQU6UH8xu93xjcX9XecNVMpN9/CMx5NjtNsjW7aTNjB8DVp1/VM7WxYKuONBMkxDhDzU830hJDo3lshqW30iFmuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCtOk83aIHrVKMzoEXLAtxfpmb4Gm8l8aIUDnYEgMvw=;
 b=Ck9BP4ab53OF0wTsG+14CWASCMR4QyPO4//3cB5bWAlWG3Dd9Pp2fXVVFx3GmR8CE5ThJXkmerSrL5dWgGN6urxmOPSsAqqJ3YhV2IXqT1nIQciNhnJ3Tx06AS69mYJ3dcZe/aCHjQj+ZodBegDoqS1d+NAHhhXAAIskprmiDWSThee9KDcd5ufmZD/7F65LgmzeWkixLXQlVch2d7J+sHRKYlmgU/b6mkPMKcq4Hmn8co//SIkZtsA38beJxn+PSQWey8bq9ciubOc4py37ZsOtq679GFtEvqh7SwwlAiDaes4DqEv8xqgLn1PTz2hEYB2XKKgdFlQklMI46apVYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCtOk83aIHrVKMzoEXLAtxfpmb4Gm8l8aIUDnYEgMvw=;
 b=X4spzLDX1zhyedsvhD1KbHJcvQJcii1QnsDv5aRtLZKbH+LmHb3IaWLiYRWXsoP0ScAKg0SPkgBwY/mH+NxOdjqeAWcONFBI7WVaqEAxXH4M35jCM+kCFHESOgis+tORQZd8hdyYdz52uDaxvok94flW1uhcQ8r3otVcjUUCVow=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7374.eurprd04.prod.outlook.com (2603:10a6:800:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Tue, 31 Aug
 2021 09:07:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Tue, 31 Aug 2021
 09:07:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXnhk3bR+2BJOkCk2OO1PW76puEquNPsAAgAANEQCAAAFHAIAAA9qAgAACOAA=
Date:   Tue, 31 Aug 2021 09:07:55 +0000
Message-ID: <20210831090754.3z7ihy3iqn6ixyhh@skbuf>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
 <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
 <20210831075450.u7smg5bibz3vvw4q@skbuf>
 <DB8PR04MB5785D9E678164B7CFE2A38CCF0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831084610.gadyyrkm4fwzf6hp@skbuf>
 <DB8PR04MB5785E37A5054FC94E4D6E7B5F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB5785E37A5054FC94E4D6E7B5F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c06b7b2-a1c3-48f6-30f3-08d96c5ed1fc
x-ms-traffictypediagnostic: VE1PR04MB7374:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB73748407638C3113C5533AB0E0CC9@VE1PR04MB7374.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XYmv5Piixf+jikDkn+JAvmU+eI84XNtqtwv52OG0u62XRtWTKAaUY3HHGyX0qA1vI0aYFxc6yCZDEX9CIfna/a9R4Hln5PACh1X/GaDVcAmwQAHT7Z6MfXrdSWLrbfhnmUfW545DxxoFzTtGGx6cpvrq7ggOsit++XuMBcGIirW9pzbdnJkItKWNXDOt60HZ3e1Z5J8cf9rEAbpRMGGHMeDvOjfErhfG53C+YjbQdrLplxlZrXKQz892ZTcWFd89Ewj0H6p0ab5AUwM+Hf3/GdbAU5kIvR+kQGcWKJIeYTBRA9IRd1Bvw9eT2Ryr/Gte+W9Luw9HIvpZSg3qITFUe9Jh4F0FARp4ab1Pu+cl2WtqTRd4u9vIpsCJ0+mFcpAvqP2hNHMlMIixqqOf31qoKeEXvL1E4wZkauYpIhinKe7a/wazJy7SXpmvHCcTrC6aG9NpoB6cOtG5/PhiWXPvMLqc7MzNyUItQcFoVtbUUCK8cBciPiwjFGQJVR32WTE5Hqs+qObDP3huERwa9fipB4WsYeTOZn/SdkdgXGvjivydfDbiuYfiPsF8p1+RO6iRSNwlLqDwrNa+uwhp7Co/rAxTRbaWzTSzJ7u9AKc5JK7UER6Z4zsod8v92wcvysyKNZWfVJ3O/d6bJFrfrXlGr2+C9avoT6pO2qI3X2SavmTPRaspPQiHC5nwsCdC2ojoTL9y3sh3xIbRbwkfmB1odQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(66476007)(76116006)(33716001)(2906002)(6486002)(8676002)(64756008)(66946007)(6636002)(66446008)(66556008)(4326008)(8936002)(6506007)(478600001)(316002)(91956017)(54906003)(38100700002)(26005)(44832011)(86362001)(6862004)(186003)(38070700005)(122000001)(9686003)(6512007)(71200400001)(5660300002)(7416002)(1076003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2QoYakKtOEHYwmNTLqGhxmmqSpvt/J0bX9q4G8+5Wn0QCTK1JH26L7ru9R0Q?=
 =?us-ascii?Q?lpmM89lpANz9Meb1viUT2n8Q+EAUfgl6bbsd5OPANHZAimf/eQGyuaugopfm?=
 =?us-ascii?Q?JHooJnxdyizCpNmXp7VU/RQBemPhpQB+S6z0CeWbFDp/4iFtJAZC4YA81ci+?=
 =?us-ascii?Q?AymsdyYZJxTshWjfYYhD1uixEdudkteOU0QferkLpMpvlkRyqDZCwCKTGi9h?=
 =?us-ascii?Q?+ycMFhe0QFnwB6yxRv5/pKdkin9lkLj3BJJvjmgz2AZMqJTRghnpdNrqenN3?=
 =?us-ascii?Q?88OYWpgonTHDoAWPun06pn2WiWt1+Uy8DJLrdt73i+w17+2SaiUuxqNXV9zr?=
 =?us-ascii?Q?TQpPSpnG9WiTEhLmO4zYGwXy0ZhGWw456xFPJr2gZNPNcrNWMqijAdHptpiP?=
 =?us-ascii?Q?zAV+894fpebtjpJiR3YLctN231TUYSd7cOwMbNhsNf4BQZbRaNu1Qr/Cqjcr?=
 =?us-ascii?Q?hkhW7nxGzP1Rljg5g4Jio2lSjKUjNo2k8EvTYJlsK9bY8K4UsJMcmWvA5RNl?=
 =?us-ascii?Q?MK2ub4WtWMWJwVHi1lFghmMkcuGbIQQ5jQ/I+7qyWtNp1vi9S81XqSU3WgSv?=
 =?us-ascii?Q?Xj53m4qM+VTM7dgKwFNHd3bZXnCp4tudJzdi7fBWSvt/2hcabuMXXwB9sa4L?=
 =?us-ascii?Q?xjLZmnIdnVKLlhgYdUO9DxgaNQiJbSis1OjTWqLU5B9en0skEUVMoA7RfHVE?=
 =?us-ascii?Q?XjNscdxHUgvDfDIr5I8ue0kxmfWuulwqGjWR+fDFmEQVOP6G9WHZagKSmwPG?=
 =?us-ascii?Q?5vVfpMqC1KHN5BmCCzR/H4MXTTcGOcxDUMfotV1dZR5J+tk+DwfGTNj5QNr+?=
 =?us-ascii?Q?HxigEMCthf25Foxah5lZhfeQuXREn3s5uPnI+07RPYiQVEBrQGHCKhwnjJ3v?=
 =?us-ascii?Q?WTjS1t0yBNI/Lmy9CqB3Nks6zFOGxuzePbVyZVpwqgYomW8NK61uQoTwXp0m?=
 =?us-ascii?Q?Zbvw+95j+i4W+fmcEt4jncD9FCBiRDkm3GEPOilyqehuIWHWOppC0hJfbPU+?=
 =?us-ascii?Q?ErkBy1bMjaS4GcmnURnmlX47V42hG1qEhanpGDOTzRUI4ukVvIJc7nogRRpT?=
 =?us-ascii?Q?nj5XvKZ5vVRqUxpHugE9yuIpLUaYeUZmyUC7upsK1sjb6TfLdo/2AqpYpnjP?=
 =?us-ascii?Q?exXZGtSKcgGQ22Oh7+phNof+5MFcVyxZahukcf+PMUrioLRznCtJkik2Fnip?=
 =?us-ascii?Q?d09nQpDAnLDpugQH3a/X2USWucOC2rMxKunZVXJcAQULQ8Yq2Iyw4zQFMZEl?=
 =?us-ascii?Q?4cnS97B5fdP7MZqPU89ixDjycE7R77z6NZ4hJ9Z+Wi7HFMTUYG1mFbB9R6VY?=
 =?us-ascii?Q?KNwLYViyHR+PJGsFPTW+NOaZ9XFFj+MwAjqhEh8zZZvT3A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <48A4B01D60B40A4083A7C23EA27C80CA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c06b7b2-a1c3-48f6-30f3-08d96c5ed1fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 09:07:55.4337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9wV0ACUjOBrACcX2MYuzxlrq2i4FxJ27eYfrkwrvyOdyn28I2nf4MuTlR7/0PgZKd/qK6GQe3INQmfV25Nm/rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 08:59:57AM +0000, Xiaoliang Yang wrote:
> > I think in previous versions you were automatically installing a static=
 MAC table
> > entry when one was not present (either it was absent, or the entry was
> > dynamically learned). Why did that change?
>=20
> The PSFP gate and police action are set on ingress port, and "
> tc-filter" has no parameter to set the forward port for the filtered
> stream. And I also think that adding a FDB mac entry in tc-filter
> command is not good.

Fair enough, but if that's what you want, we'll need to think a lot
harder about how this needs to be modeled.

Would you not have to protect against a 'bridge fdb del' erasing your
MAC table entry after you've set up the TSN stream on it?

Right now, DSA does not even call the driver's .port_fdb_del method from
atomic context, just from deferred work context. So even if you wanted
to complain and say "cannot remove FDB entry until SFID stops pointing
at it", that would not be possible with today's code structure.

And what would you do if the bridge wants to delete the FDB entry
irrevocably, like when the user wants to delete the bridge in its
entirety? You would still remain with filters in tc which are not backed
by any MAC table entry.

Hmm..
Either the TSN standards for PSFP and FRER are meant to be implemented
within the bridge driver itself, and not as part of tc, or the Microchip
implementation is very weird for wiring them into the bridge MAC table.

Microchip people, any comments?=
