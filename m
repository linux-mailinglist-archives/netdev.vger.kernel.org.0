Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB6C577156
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 22:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbiGPUKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 16:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiGPUKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 16:10:50 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7571C912;
        Sat, 16 Jul 2022 13:10:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHgDwfZi646JpIs+1jzsbbt/8cE/VLr/rHGoBEOfYu/VOCCvb5YyEqHfSihrIizJA7+hX1DKhLt5mSajQgRpzeDc1OH0NvLaXcpNDXOgp0zjqgO+yNyiOEvVFve5+SnYCC0rQmFn7k9LZSxQHN8FcTzWDKHRshbfM7v3P1mVXKPMlT6rlcAeFDNigyzRtsQpqgGtrQbc9WeBHzPFL1qwhagTX2PvL8qWCo3oX+k+SChttxB7l7RWEusg/GSnKhhK1sQxj8MVLGYZJnIXEWCGXfw2wBrHMmqTwWzzLgMfzSZBzJwz1mL9+CLzg8a+IfzY30HkjUT3XRmYo2S3ChGUmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0G6fzas0ErOqL8Ex7Rwz2cPK+2bAJeX+WUFeEBG6UY=;
 b=ZHo4mWiLGe4hrjCNHvx99Uw8Y/SJRpajOOQep0alQ0O+u/+TfGzyGXmm2Kf3j962loNDUdVrhu14jlmpJp/G+mXzBI6g6ztFIgW92PlpyfhXZWeIlBb3dIYGkveZ9Px5ZnPJAi0qbypIIcfY64vSQ8iLp0FjY3p9DiYJw32l6zdLPTZLGBr7diZPIDwtVNyHoOfHRB4LaJCtvlLS02mtmQziCI3Fr2II+bPmLnNgpTS9Y7vx+G7MNXdeYrKWMfO3dplieQidCTdbkebVjAEfJv/s8GkoKI0ATP5QGskhYrVWdoCSiumo5x8YZm339gPsBiHWHm3hFrdLCdLreq054w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0G6fzas0ErOqL8Ex7Rwz2cPK+2bAJeX+WUFeEBG6UY=;
 b=OSir3+f+EgZ3c2LUsaV/hF7Caxk6ZiYV1eKWCAusSpg6ctPx/Vh3icv4kPmbkkCgoAuKfDPQDEiDVLbIVjgWrCDVq36cnh7pL0TiMs+nJKzy13bhjOWoMe7YhdLzs4fbwnogGKQjb8nWkKB4aYKzLiqxlyKHMQlWiIf7eNmNcJk=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB5298.eurprd04.prod.outlook.com (2603:10a6:208:c3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Sat, 16 Jul
 2022 20:10:46 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 20:10:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net 0/5] net: lan966x: Fix issues with MAC table
Thread-Topic: [PATCH net 0/5] net: lan966x: Fix issues with MAC table
Thread-Index: AQHYl7kVzGUrNDShFEaiO4kUzeNKoa2BcM6A
Date:   Sat, 16 Jul 2022 20:10:45 +0000
Message-ID: <20220716201043.ps6z4mxlagluwtyw@skbuf>
References: <20220714194040.231651-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220714194040.231651-1-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a6aab58-f15c-4460-72f5-08da676744f2
x-ms-traffictypediagnostic: AM0PR04MB5298:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AI2Kok30k1VT61k8GOQMuFRBpNNGEQR5YeplDHH+uNjqDbh6KPyvnDAReUcj1PY0wgvwAXe5QGorHLAh6nhdzrbA7eCUjJe9d+nTg5J+uqCNpvmqYMvpMlSCPivjNfcqP5y+a7QgkFNyfL5QQNnoosvnDhTMUzbRe8C5W9Od/2ktmZwqELRFLCA8LUH3yJV6UpHzcvV3EeoS86tKBiw9y406IEs/tKQ4ccdxkllU7k6vtGe7I+yuvb8UqaefWWiy2Tu5UlJvFnwRcnrll85b9Eee9RAcHxcLCjxXPec9lGXPt88+MGCpuftaycCVbovmIQ10rVWT7zeNWtE5BbRiM33iFylLG1R0mTAXZ6Bp2OnXC+NZgkpAkyEK852uNh2JxDRP/2KrkvW/hVaMM/fv/Wh+UWtpnQ6wsrR6HmHjYSQV6eAsbb1clvljr39YUwYpKTYYeeq1j2uij3ElxHtxv1hFgOGvs+s4nuB5Vmq1vsJm4q1Kxg4+RyLDy9qAapsBs0WkViq2hvxU12sxxCGiGKgRcB5l0WxTmtQdAR+pKsPbqSx2jWrkJHqyZRT5BoWFGw8MEMHGji9nx04DrmHt13KOQPzsEB0t5y4kiiXPcBZduKqGMSHnWybTFiRiQjeyCoJahXosqfySeInp1qJFwv7V1/UATpX2rDhPUWhtMY8ok24CzFENnFYkWlZo8Tdvm8LM7wNm4HVmmjYslVVZi1Pn54DAlf/Susr5jEi4fcGme9RqpMEzODVbVdDnYqGoZ6lhDZ67B3Az4pPqzc6PwFdsBvCxj7VY58Qulrnx7ms7kOWXw9JotN5C5oG/B2y9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(346002)(396003)(136003)(376002)(366004)(83380400001)(4744005)(5660300002)(41300700001)(8936002)(66556008)(4326008)(91956017)(8676002)(66946007)(64756008)(66476007)(2906002)(76116006)(66446008)(54906003)(6512007)(316002)(9686003)(26005)(1076003)(86362001)(6506007)(186003)(71200400001)(6916009)(478600001)(38070700005)(33716001)(6486002)(44832011)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n5h4PL2J1CVMHhZYp+sPAlEp5XKovqs216F6eq2T7wR1FoOlq8fMWe9jjARd?=
 =?us-ascii?Q?ZHyIoYtROYkvqgHAu3popFmfOlyKh1WoG+DBT65mVLgNezNLa8ivf2q1XXdK?=
 =?us-ascii?Q?B3FZ/iU5woP98uI2O3wLZnwQRAb5kBqJKWPQO1gS1Nu/sGFaFD51g0uLc1u9?=
 =?us-ascii?Q?muy/VQzirwdaS9b22VnsSL0Xq0X9ETFf5Pnif2kUVO1acG4Nzb+wUYY8FwVB?=
 =?us-ascii?Q?lj6c/MjwevSI6F8FvFvhmsf9TRFCDpNqWikHe6bJKN9LdKMPyIkAex4mSMO3?=
 =?us-ascii?Q?frGGfk3XSrEG7/Zllsdpg7CXsP7W7hwfL03RCn5+CkWvxTZ5IS8n89cY0mcJ?=
 =?us-ascii?Q?iCsc6B/NMhW+jiTCpm8KDDXah2kLyCLfz5YWqKACCosAZhreme+wlXRbxQ2b?=
 =?us-ascii?Q?Kg5JeayyLVXEzS6wI4kfqSF7+Nsjc3HD0MK/+Y/DtXkJ5wguCC7PhrrJqJww?=
 =?us-ascii?Q?EVHa2RwImO8ztn9lo9Xp4Yv5jPWu5srTwQBaQChXfNCrtaMLqa5Eeavmj6jH?=
 =?us-ascii?Q?9NinK5qJPhzdJYGSj3f6nXUOdjABrr5hWMlk6wMhCyoZ3vzgMck631t/2a3y?=
 =?us-ascii?Q?kBGf9TsMdpc5tjsmlAbY+x2fTvhrkxoSKRfz9gAZAkqNklU37/PCu/LB64EC?=
 =?us-ascii?Q?L4coXa3PiQZYwcRWwxAY1NR/lV0yYyoh+XPCrD1NSXTtVRLjHDjsYwrlhFin?=
 =?us-ascii?Q?rPmv4x0bkCpv/1ZaS2hkbRry8Dfd5I1x0yl59Xwkv1lVynrwzTF94HiFwMG0?=
 =?us-ascii?Q?ICnQ5CQ3qLlqqtakc/8DVWl0KR002OEWtZHKkJxMQ4rnz6YU9bJ1+mamewGF?=
 =?us-ascii?Q?31DbrB7ZKzjkN0sqBB99SrTK6+g79fuoSxawkN3e6cWeZ4StmuM5bcJmzqYf?=
 =?us-ascii?Q?iZQYnDeH7LRXUwNRiSDtbxOz5j+hoCkIICSKaguyOM2k/5417PmR53pB0SRu?=
 =?us-ascii?Q?d60U87jaPNxGK/IIPZhwyzQgg8o4Jk0pYh7AG4bWTkFmCs86G0a8LTqh3QoY?=
 =?us-ascii?Q?YsXiR6yx+hFjLaKoSSPjtGMfPKtnkhhOav4slMBqIrG6ZmT3K/MNyTKAQCFf?=
 =?us-ascii?Q?Q2g2XrAJGt+us/ZAN7sDF5yeuS0BDDcQJbEfyrhHiLATtXbp6gEyjr98ibgX?=
 =?us-ascii?Q?Bj9TExWlFBrnUYp87sk/npQ4Zi/x1ogYgzAu2rRbBFTAskIUI/5znkOKWrVg?=
 =?us-ascii?Q?qqI9YUNbFG6Fy+ZMQyBanXOe0Ow6JofgZtLAT+7DU02l3R7TZZSiCMF+DEYc?=
 =?us-ascii?Q?X/UW7svhNjQCh/aJTpr8kFY9r+D8tIUEujhnNTR0z/tsJM9cMLdaWoyl0wzn?=
 =?us-ascii?Q?MApihCr1rwSFNvEYnS6WVjX4mdD3MJbMSUa8KX5uCqnVI4duJwFUOQZKfw81?=
 =?us-ascii?Q?3Dcr7wUYb2JYqsow9WvwNBDuHx4hIyyR+vCJN9iWLKMZvj3QgF5C2QMmKDN6?=
 =?us-ascii?Q?KBnGZOmblHKG1vHhzcc4m9yG6+coqonIEj+jacaX1HOoJ+fimA4wS9ZCX45a?=
 =?us-ascii?Q?H+sOp8aM1sLST7oNKiGXJS+tY1SEo562sEJIJYJDRnnQxjamUNNfDLBm2y7p?=
 =?us-ascii?Q?6bZBpxZZst+aV8FVrUueHK88uLB/DTMkpBIbNMWGvvW4xJ7n2l6gYhEA/mcY?=
 =?us-ascii?Q?gw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8E43A80FF3C0A743A89D61ACC2E6A47C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a6aab58-f15c-4460-72f5-08da676744f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2022 20:10:46.1753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gWuEXCAr5FgSTPhAWeA1ge4GqHzgqzehnnqy9ElmVG7MEpADTbuV1E5gsFhYDP1MRxQRM12cdY9h5lUM0pVKCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5298
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 09:40:35PM +0200, Horatiu Vultur wrote:
> The patch series fixes 2 issues:
> - when an entry was forgotten the irq thread was holding a spin lock and =
then
>   was talking also rtnl_lock.
> - the access to the HW MAC table is indirect, so the access to the HW MAC
>   table was not synchronized, which means that there could be race condit=
ions.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
