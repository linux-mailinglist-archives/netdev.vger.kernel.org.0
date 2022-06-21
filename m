Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74145536DA
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 17:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353412AbiFUPww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 11:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353296AbiFUPwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 11:52:21 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2132.outbound.protection.outlook.com [40.107.104.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1DB2DAAC;
        Tue, 21 Jun 2022 08:52:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2C86r06DXLlLwsrhnqx34HFn1vJ6nfogzPtmAmTx0TbGMurrX6D6neJX8lEMXNKH0Gm3fONkHssaNh0idxmIfqgCl02v8naLxgsW5kqq4n6XOVhhBaH0TTCF7VzlP2ia++9rdDiNDxdPwSbkESqXhZbc54Xge6/5+bTWzUdjvDvsUKa06lvgn3uxkq7rGtxy6M3kRkBDWxvtU3FuighMRfyzGa4HCkHtDDwxjsSux/BwU3+g8ujJaVFevEolO27sBLEkvI0aGnf+4ImSzCHZwApgzzFMSEhZm8kJrn06wgErOxZ1wS5VUbk9KU6h4Ma+2eqj3qKuG7t3yIOwQ829A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oz8/K3b7lMRzN36hDal9e9zqNn+6fdQT/qGG2kg4jKs=;
 b=njDp3SglpIH+XEjNhFMpuXqX07y2/+H97KnTodQCqGmHsd2NGSvoQfZfx8aOw3Hh6rlhxQaTMpYby5cDS+eMtDiaF0NRKBwZ532ah6BDXQK2taoH7c5LOoSL7pNjTCoe6T4MKms7vmREyk13kBOgtn2WzuB6o1c3nAiEa6Ab718jnLiE6RT3Gu0EAI1mONpCrdWMRTEyNLqoHaYoptILS8SbBY4ktzATypW3x/XtjfdfWUe9ZJ449Rbnkt9zwZOw4ZH6w38A+wh+MeGZ9MuFo+ysRfrR1tlz5wlrAhQULhLU3kj92bXizzJOLtA+iBnlmUMBdNG87HRULKvQuOn1Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oz8/K3b7lMRzN36hDal9e9zqNn+6fdQT/qGG2kg4jKs=;
 b=F/zGm3icddiw2XNWudUfyr/tuZmNW0f+KYyu5Mr3W9D5q9D7LVymHBT+Q5UfHMTJp/8cdK+w7qYW1yPNpILIh9VI+7Efk5+2EygNYwR/bXDC47JyR2eMsCkGV/x9lWeMNNe9WwJlTAT5O2RegVUfE+dcFWAAyfFfzQNXE1JtSLU=
Received: from AS4PR03MB8436.eurprd03.prod.outlook.com (2603:10a6:20b:51b::5)
 by AM6PR03MB4422.eurprd03.prod.outlook.com (2603:10a6:20b:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Tue, 21 Jun
 2022 15:52:11 +0000
Received: from AS4PR03MB8436.eurprd03.prod.outlook.com
 ([fe80::8858:49c4:6976:51c9]) by AS4PR03MB8436.eurprd03.prod.outlook.com
 ([fe80::8858:49c4:6976:51c9%7]) with mapi id 15.20.5353.016; Tue, 21 Jun 2022
 15:52:11 +0000
From:   Frank Jungclaus <Frank.Jungclaus@esd.eu>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     =?iso-8859-15?Q?Stefan_M=E4tje?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH 0/1] can/esd_usb2: Added support for esd CAN-USB/3
Thread-Topic: [PATCH 0/1] can/esd_usb2: Added support for esd CAN-USB/3
Thread-Index: AQHYhOP3yq7RQNsW6EGORRWfCWoTWa1ZaEmAgACbqgA=
Date:   Tue, 21 Jun 2022 15:52:11 +0000
Message-ID: <6dc713b8f502857388e411103bf0d31e4c15dd65.camel@esd.eu>
References: <20220620202603.2069841-1-frank.jungclaus@esd.eu>
         <20220621063501.wxxpotw6vck42gsn@pengutronix.de>
In-Reply-To: <20220621063501.wxxpotw6vck42gsn@pengutronix.de>
Accept-Language: en-001, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ef46267-1402-497b-109d-08da539e0123
x-ms-traffictypediagnostic: AM6PR03MB4422:EE_
x-microsoft-antispam-prvs: <AM6PR03MB44226642EA71424F692F491F96B39@AM6PR03MB4422.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +cZLO0Gxmc4Lkd7P9QbgF7yGXl0NLep5NkkA3ZSHgb2VcowZ0+Y9j60rfam7tWZIw2ZaHcqhBjR4S3AeV70UPKXs/rIDA0/nZeFQ+MVPRnnz78wtMqKBG5Wxdx/6ylKaOWxLH1Cbujo2HuKlMS7IDv518pMyH1LR+KVYhfDkPvZZye9aJnCcnzPn1tGoc/mN8PG4AvS1Mtmy+oVainUPbrf+jlghXrbjfU96isvmxWK+VsmvLkVRco6gOwdIFbU9h9rOoprq8VnoVp3m6R3jc0laWt91Dl/R6Z0XGbapPpZcUEjGjb7MnSsYjCJKNYTn+gnOZbtHeexWW6weck+GR34uRklNPkBkhzxuD0V2fo9YAI60rpWF6wJKAy9qyHpVIf33vE0W/fjN3qtxAt3ARvETcWFcrERehlXoL8/I8oJP5YMLtRXk7+Vpmt25mDi1L9MjGZ6bco9vYVQ4zYPX7l3qM/jqJ3CVyCjp5RHyd9uYfrNGReu5II6gRXBIUP1OsJyfCeWZwODthGuNTnsG/9XNqOhSEOBfOW1QkZ/hycEXNLYfBnKMs3fUrf+Q/7qr9ZUG4dS6RxrkTm4IKEi3CbQ7VkaXdKzGlC74Z3CvTSy35hmgGmNw47AAu1F35ArrrbajLY+0zfjvSw3hzCy3zID0zDu/2uIce2Pas0di8CkpDcNf2woZ+9PxuF6JhT8PvQJPYgoTiW/3dfEFSr4liw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR03MB8436.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(376002)(346002)(366004)(396003)(136003)(6486002)(66476007)(6512007)(6916009)(71200400001)(2906002)(54906003)(53546011)(86362001)(8936002)(5660300002)(478600001)(8676002)(76116006)(316002)(4326008)(66556008)(66946007)(91956017)(26005)(2616005)(41300700001)(66446008)(64756008)(122000001)(83380400001)(186003)(38100700002)(36756003)(38070700005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?KS58TmqbJD4Qx4FBQk7Q7O7qZZVw+82nn+pye9UEirwOKVcklzgAS75N8?=
 =?iso-8859-15?Q?bSxnjxirg0gbXgKUy51liQV1OX2snUEPPfpiWOPMhcXrzOFceEhwgEO7H?=
 =?iso-8859-15?Q?LKTHXZsSmoAnM+cOEsJRZgUvTD8hcWULN1t7VP/7a5MGASJP49i1QfjcV?=
 =?iso-8859-15?Q?xUZzwFFLmH4LlNmw2Gp3YtoLrZ3O6gP0h/Cu5+7QkhPZ+rYCR7OP9pObK?=
 =?iso-8859-15?Q?3PnRuAVnyFDoWWX2MF52IMA7OlQNlb5VALQR0T2G/UczPV8g4G1vUxgU2?=
 =?iso-8859-15?Q?qOUl1RpAkqM4fuDtgSrogpuShzOXIGopIg/3clXuUNTfUmR8EfexGoFOi?=
 =?iso-8859-15?Q?V6BkPg92qziPWqgOo/XAzr6Sn5BFeEoEMxVfk486RMjOyGj1HqqCNvYfd?=
 =?iso-8859-15?Q?ZVe8vuwn33+K/JvdygAhRlxJO1MDayCGyAfq0m7yPi+upSDed1qiHbE27?=
 =?iso-8859-15?Q?X7IiTHkcxHVCQ+xZVPlE39cgOSU85WdbCoZV5cw3tKI36rDh4CK1sTj/F?=
 =?iso-8859-15?Q?p/WU3UeSlRDBf4vPXCdSw7I9rup4jD+ABW+8vaDmyr6XRKrdVqaJB2i+q?=
 =?iso-8859-15?Q?L4Jr4jscrNES4UViaDimZDhlLBK6QZUWFLl0pR/G4k2fHJ2xSKD5bEGBi?=
 =?iso-8859-15?Q?nOfV7DBmNsp9UATVssFid24HW25O9sJWMMJsb3uHqsiKCt99eHspsm4n6?=
 =?iso-8859-15?Q?sOO2wPPB+qAWz5UoRHg69cfFrVlTKk5SqteTJvYkhDIFh8oEdoaSHcHHa?=
 =?iso-8859-15?Q?h7H19CUddAhiDtX3glrzmGxsZF9Kde9F/lZkRWkbGnPFB4U6bPfc7l66y?=
 =?iso-8859-15?Q?QmmQG82ChkSnkX1Nq7g6f7OCgsegidpPqYy0U/9rV9rSdjSaij+lB3c2h?=
 =?iso-8859-15?Q?bnsLp/TDvCgzr6ddN9cH/Qi/J36om45t7RplgGdVDbv9SVtlRuMz8vFij?=
 =?iso-8859-15?Q?yonJnqLD1KwOg5Qz487Ipc53pFtW8txPQjbcHlG0PkfC0PPBGkcCNuPLy?=
 =?iso-8859-15?Q?wUzzcGGy3TCGqWITZrcHOiJsFS9rKITubM1HpdMIhN+SYXs8q4Fa/TPwx?=
 =?iso-8859-15?Q?wLwOy6Z2UXj+VY5OSOUyTdqpfR81P/Xf1+c8Zjqk4PPTv6an2kkhaSBwE?=
 =?iso-8859-15?Q?yFC/yGQXaJyBvPfNREgMu34S2D8SOvARC3dx5Mgv7vxaA2shGBcLG06B2?=
 =?iso-8859-15?Q?ruQ4hD6w24Zo+PJKZeQlyNJdbuHMlXYYpuZZXhziOjfhzQ6qAsboTxS6u?=
 =?iso-8859-15?Q?6u3gogL7a4cRL4wmVh2I/3m/F0Xuwc/EQSb2hRrvmwxjN5uPU45fbklNH?=
 =?iso-8859-15?Q?YSRQAU2Jqx5ZmmiMc9fBNiy/onmew8kqerZ0PpZMtLZ2MjQ673oEB+msG?=
 =?iso-8859-15?Q?BtOlsM45cHHt3J3A+e5W/DNoG23P/f90Xe56X8J996o4nSMH0FuS+t+q7?=
 =?iso-8859-15?Q?zOXESv9KHP7zIL9FeA86DFJtkng7PkNlAh2o960xdS4xK7LGVl/39mxw+?=
 =?iso-8859-15?Q?IbKlaKVgfBKZFCxcUJJfWRZZPXNwQ+pjF0bj4PTWnL6iPLbti2dh+zEui?=
 =?iso-8859-15?Q?mnyXNFOFSwE7C2+TSFE5APKD1ZX12AKcVHVwW3VAHAgJ9jGPQIXC/A68T?=
 =?iso-8859-15?Q?MrupPX0mgXkWEsPxyEcEvZ0rjGHha9bGduycWRC/SiUPfBvL5a2kP4lLB?=
 =?iso-8859-15?Q?YOLl0CPSFu+nvNBq7pLcmiuHP8EvaRnS/gHQ+inIs5EuDzFVB3F4Lf+vM?=
 =?iso-8859-15?Q?VxNY2XeLD3JLfiJfgG9iHR27xdymm72f/GFToWqbGcLaqbmD3ah5JM9e3?=
 =?iso-8859-15?Q?UBjX8CVo5STOYD/cNlFn9e8PLhmX3yuByI5o22qYwK3J3n+wUK2ZpBzuq?=
 =?iso-8859-15?Q?FnPc=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <BECA7D16E6E99246AFAFE9202D22D02A@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS4PR03MB8436.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef46267-1402-497b-109d-08da539e0123
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 15:52:11.5203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zDaTAYFwur9uWVZ94ZUdkyH58jFz8u9tsB8P6T7+EFI/BTMDFFghOBZSZSOYm0zSTujfw1288RLDY52a+YFN/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4422
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-06-21 at 08:35 +0200, Marc Kleine-Budde wrote:
> Hello Frank,
>=20
> thanks for your patch!
>=20
> On 20.06.2022 22:26:02, Frank Jungclaus wrote:
> > This patch adds support for the newly available esd CAN-USB/3.
> >=20
> > The USB protocol for the CAN-USB/3 is similar to the protocol used
> > for the CAN-USB/2 and the CAN-USB/Micro, so most of the code can be
> > shared for all three platforms.
> > Due to the fact that the CAN-USB/3 additionally supports CAN FD
> > some new functionality / functions are introduced.
> > Each occurrence of the term "usb2" within variables, function names,
> > etc. is changed to "usb" where it is shared for all three platforms.
>=20
> Can you split the patch into several ones. Please do the renaming first.
> There's some seemingly unrelated reformatting, this could be a separate
> patch, too. If this is too much work, you might take this into the
> renaming patch. Then add the new device. This makes reviewing a lot
> easier.
>=20
> > The patch has been tested against / should apply to Marc's=20
> > current testing branch:
> > commit 934135149578 ("Merge branch 'document-polarfire-soc-can-controll=
er'")
>=20
> Note: Better use the linux-can-next/master branch as a base, it will be
> only fast forwarded. The testing branch will be rebased. As you don't
> depend on any new features, it doesn't make any difference for you.
>=20
> regards,
> Marc
>=20
Hello Marc, hello Vincent,

I did not expect to get a response that fast ;)

Thanks a lot for all your annotation work, suggestions and remarks.
I'll try to take them all into account. Than I'll send a series of
separate and much smaller and easier to handle patches.

Regards, Frank

