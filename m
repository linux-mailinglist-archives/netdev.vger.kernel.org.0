Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465DC3CFD82
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbhGTOrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:47:04 -0400
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:14316
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239829AbhGTOVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:21:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rk5GCaX9YAgA043pU7VXfEKsmK/SCspzCHVeXuuonWtZDPVnoltf/HH7xCdLm0iWAjbK/4lCoiGQDyQjHVl7Asjk5kx2swnpGX79KtpotMbXDcNpjA1AsHwJtab+H9FvycJp6cefl5eO7t5Qz+MiTXvR7a37VqpDkoDq1YUZs5dCcCD1hMhTKWX1cJLq0uhpPxGBdBpyNT3P9AaiBXN33JmRMpjc7bd2geQEW6ct+5Zzq2fAFCILvRhzwG5WDUuLzrp+CFiy2b8lc1pTOyeyamrrkmy/OTnBeW21ymZQbM3ADvpQphBMg1Ids7cK4zlcsQFTF0jy1H0d73HrPajxBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnpcQ1pvINaBye+rVVK//nhqwlrHhjEmEDNVc2g0n9g=;
 b=iY28MosQQgUUYLirITGUr45cjqgYHwF8vMT0yhKtkBpSAAl/tQvjBvhvxiNZgQWgpBrAkeIUmxenwx3w3aP8giNIItRh7Yp/KIuXryBH9Dpy2VGB/3LXuLm0rb+sCXjHKPSjRLBlgmuBrCmdffujt+b2GJAITSP6/6m0O6sG8OEcmuR1XwSfCvNlOMZPIdJRU508Oofz9eT+ZZEouH/xOs7RqNWV+LkWCE78Hw9XJoE+I6IG+TB5AvLh7s29S4wYblGeSXLO23GCUf0YKROFQ8pVeJNWi6kdibXKUpVRENfEBnr2+97r28YTZOBJrkcCooGpDeGB2idWvN6k9VapWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnpcQ1pvINaBye+rVVK//nhqwlrHhjEmEDNVc2g0n9g=;
 b=HpVgc3zhfvWQHMh2+NzBKJlxOpge2j6lF9MjL4bKUt89hq1nAWZkoxgmyNA8eQsHvLEH517EnmxmDyhNSgz7FDhwttLl1lNUwUO9paqLx4QEV/eErSWABez1pV3j78mc+JqvBSNvt7aZuq5gpTxaumesQCQQvtkSscFB8GPL1vY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Tue, 20 Jul
 2021 14:46:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 14:46:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v5 net-next 00/10] Let switchdev drivers offload and
 unoffload bridge ports at their own convenience
Thread-Topic: [PATCH v5 net-next 00/10] Let switchdev drivers offload and
 unoffload bridge ports at their own convenience
Thread-Index: AQHXfW29xPYONAiJQkyZbYsuqj9IL6tL5LQAgAAC2QCAAAOsAIAABemA
Date:   Tue, 20 Jul 2021 14:46:18 +0000
Message-ID: <20210720144617.ptqt5mqlw5stidep@skbuf>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
 <YPbXTKj4teQZ1QRi@shredder> <20210720141200.xgk3mlipp2mzerjl@skbuf>
 <YPbcxPKjbDxChnlK@shredder>
In-Reply-To: <YPbcxPKjbDxChnlK@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53708f35-8303-41c9-6172-08d94b8d2209
x-ms-traffictypediagnostic: VI1PR04MB7104:
x-microsoft-antispam-prvs: <VI1PR04MB7104D098B0B897BD409C2EA2E0E29@VI1PR04MB7104.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XojD0On0uHhJeR7kF0bT3GAl+2huISYWGSdk45RpHbygS6jQx68Aw6XeGg3lZNCjNqi01f+Pcdk5rdsUINJj+cRKYmhMVLUQiV9BJ8yU5dC8T4Gf5wGrQ+Vkbi0Hw6/TvCmjRkQMYy8hXsIDNeHQbNhG5bWM0mS2jGYyPb8f4xvok7nl6uXWaebM5lF+V0IpLoOIVgwleBNR/+sWQz2RmTtlZshlaQXkwzQKKJeA2r8Wc1iT9DQNSti6HXwQIIbjt0Ga+slMFMNTuSpBhY0V+x7cHSnkKv7kFiUMuKhIKNq/Vm2LsSW7WGJViaYhSrZQQ5QLVHnrb7ewvCgGoZuS8jfLXDrz+VQsaj6W10mmv2Ju8jSURH/OMjAsDPifVx8lYbuwDBkKZFDU4xIcoEc/nO4IiBUUzmfpxhr5hoO0SNI6Kf1uWABbpK/BArehx1tNtDoXOxRHY9k0Hcy/krJcUDlDZYI4U50wuGf8VeviDNj3Jwj5RkXIkApXizC89mhWiKX3QUDHLnUG4FXXW+/HwhYs6cWBy0QLT2kbXE+WNWVN+bUrJXt067ik66Eo/r2NebkT0CArL01s2WhNTbGzAXVKhyT4rtGlHeSTkH8CAgGCE+yXZVxKJBBvJeLRdZOO+lSrxG1G/TjZEb7H7E67aMh3ueSK5ICL+FsanGlJd7Eg9ANyKc0bZwTxo+iXDm3l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(64756008)(6916009)(2906002)(66446008)(186003)(66946007)(66556008)(7416002)(66476007)(4744005)(38100700002)(4326008)(44832011)(316002)(6506007)(122000001)(5660300002)(26005)(54906003)(76116006)(71200400001)(1076003)(8936002)(86362001)(6512007)(9686003)(83380400001)(6486002)(91956017)(33716001)(508600001)(8676002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lvSaXjmZnLAxFX6PTtyaJH8L50tCJlGUrQkSa03tsNNXC8PYOHwpik+wtKr1?=
 =?us-ascii?Q?bM3Vt1J2opGHJjfltun/QmcGda0N3ZmjN+311wia/84HaB0QEVZ7vnRJrM6+?=
 =?us-ascii?Q?lAPJ3sDHJWf8BE2BIIa+Rx1C9Kol9zH6M0cD1x+pZOlsHDYtGzIWc2q8JGN5?=
 =?us-ascii?Q?G0vRli5ZnPAW8QuKnhJ6Nx/uurfYIA7dNNw5f6loiQl9mGch3ohvp3ssDsJ1?=
 =?us-ascii?Q?LBEf0hofQ+ZOiftz6M965OiuGTJIQQYmhi3jf2fpBblMtf24glAx4vajaPYU?=
 =?us-ascii?Q?KxDKRewd0RScnWW4zjzEoNG8XEoSGVSFU9FusvPYUSlE4hlIKSqVrTxh2++D?=
 =?us-ascii?Q?uj7BSC968GdjFNVt49qBMLHNx4Eb7G+7mspj7ZdI14IY0WIJ1XPxZoj7IGc0?=
 =?us-ascii?Q?Thczs2poivvqMxlGg9klkMWNOYpxMwc3Sfp1y3VrGHF48WeRe2Pj5QDJ3zGV?=
 =?us-ascii?Q?HIacFQ9wDWJydDUjIJIwtWZRs7D+qMtEnXkTnlhd18bIyFcm6gaq15blx/gc?=
 =?us-ascii?Q?nR6Es1U48BgDE7W6/rwneqaCocePI181CvQMOvfmOg/wQ5qG5XAns6jWQ0Ft?=
 =?us-ascii?Q?MVJPIAJLpbhSjCxMs+xIlO0MkISGOWTLtkBVOIKoIAWQWln6zgeEiqKGWpuQ?=
 =?us-ascii?Q?DMdXwXf24lBvHALMotol09CmTfSkjjdSxc+GyU4LY+g0C25MsohTR4C3HLfs?=
 =?us-ascii?Q?e4RpuEOEX6RGGB+7ZntVOJB4jz0SYCCu3u9s3uihau7Z0GQfsH5HkuVIlij1?=
 =?us-ascii?Q?HZKEWR50+U2ESGei0f9XudV52r5GlM6ofsTJhosyRvSiaap7ZuqEuuqDq2LW?=
 =?us-ascii?Q?2//OZPWF84ARl3F9RBVdofGuTfNkeOyJwHoOMm7jnt6T5XIXk9LNJRiIz7pW?=
 =?us-ascii?Q?aaKIhUnRlaaoxqaB5C105siCOKrNqGkfM5brs7cF7Qby7wVG0zjyOMvO8zTL?=
 =?us-ascii?Q?tSKPVz7fc1Zc44gz17aZkJD7yjBqp2nQpHRbQxIBAafYijQkUGN2Ygp64snb?=
 =?us-ascii?Q?Olp7tiwxBNy3hobcCSpOP+LrvIKJDXWfUzVhBWVqR5pCGjjw/AyzYytqootn?=
 =?us-ascii?Q?dcTmWktvoqVcWuiQMumRf+jt2ccFpRyswZBg8btlq0kJZY1UwUvd8iO8BiQc?=
 =?us-ascii?Q?W1wkqGtX4jT27sFF6hLv+nU0qxjbgVHEXmC5FYvp58TwZepGF+V/LrlJZBLH?=
 =?us-ascii?Q?/31jCwQEC4M+4GKtk07ikv1669Vo1+ILDhfq1yUOPOWcfPpiBNrJxOdM8CXU?=
 =?us-ascii?Q?7/PgEgCO+VZVP4Z49VQDoAwXHemz1mRCvPpqIQprlmiClJZHP6ZZAVp6XOnn?=
 =?us-ascii?Q?fu6ez3QWoGVQb8Smw9ezU+Dg?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E1FF4337113BC444A8384B060DAC2F3B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53708f35-8303-41c9-6172-08d94b8d2209
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2021 14:46:18.2538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G+mr7sja89kIQph1b0RiFNDFDXTpjM1OMRBPvC5vygdsCIBdDof/F+vtAWbbkg5C3SgSoPNH25DqZ0PBYjCh0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 05:25:08PM +0300, Ido Schimmel wrote:
> If you don't want to change the order, then at least make the
> replay/cleanup optional and set it to 'false' for mlxsw. This should
> mean that the only change in mlxsw should be adding calls to
> switchdev_bridge_port_offload() / switchdev_bridge_port_unoffload() in
> mlxsw_sp_bridge_port_create() / mlxsw_sp_bridge_port_destroy(),
> respectively.

I mean, I could guard br_{vlan,mdb,fdb}_replay() against NULL notifier
block pointers, and then make mlxsw pass NULL for both the atomic_nb and
blocking_nb.

But why? How do you deal with a host-joined mdb that was auto-installed
while there was no port under the bridge? How does anyone deal with
that? What's optional about it? Why would driver X opt out of it but Y
not (apart for the case where driver X does not offload MDBs at all,
that I can understand).=
