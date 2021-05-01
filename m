Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100523707F8
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhEAQyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:54:52 -0400
Received: from mail-eopbgr50104.outbound.protection.outlook.com ([40.107.5.104]:59813
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230195AbhEAQyw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 12:54:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7vL7wFqVWTqd6MzWjIXa/v4JUhog6s9CxwWjRQpN6rY+UsNdqu7GN0DYj5EShFi2eyuQVhMR58Z+oNSputGOSqUwySiLsylMq6v4/FD3HboS6MHRAUOUcBU1K3riwhiX1wWOxoloXy39UX2sbkfCZUcOG3w7Se/S2T2EMMJrBeZuhX/oEr+cNLW8V49myvvbjh9F43LsS77n79+T2xfyUO/2cpytTcVCs/aNhpNEpwKZV+NAhS7rYTETuTYDPwklFvBxhAvcWGraS8NxGyfZi/kjfH+KQ43N7uCwIYdBDfcHL1SA1jn6GbKcNb2K3YOtAoF+8RSIIpK6MzQkSNI9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BawJyH1vSGd+B+ZyFlf5bFyEm8zU/QBrwzE1/RYfjUM=;
 b=SznGB395phHeYgIJi3RBD88KuMLwwxOuJd9DDRBnOOycWTG1oq8uUDmehCsYhmgKh0U3v3JRodVD71ccqE7QX2FWWIwL4/3FovIoTP2HT36Ot1Du0V5Eb5Kn0sUpdZ0hugyBNJ3/IZxLiVVDijk5a5UGCmC5TlLdlWQAkiCEDc2+VA92dYtCKE0aLcwoNs6RtNzJc4Sijh4jio07IP7YgaauULB9PMrWkvp5OsabZNm3eDJCfhOo+cs+EDlIlfJgYJLRSeLUukLJ3RcN3Fg0ThGrtkB4vVrHedX2MT44/HRX2eAinEzXUf9qmBmoTmlutli0Mol6nc7wiJl2Qpd3uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BawJyH1vSGd+B+ZyFlf5bFyEm8zU/QBrwzE1/RYfjUM=;
 b=sV+fXHL3Anx+wKqEQVVGdpQk871Srg34Nlo28HhD7gZxlbWoMuUeWcQbjeNiPjmJ+N6RXIp8QyVxfUy7o/qsl1zsnmserFFNSy8VFbvzYQAIYqt12LfN8ZCxvOu7NEqYsswC9+n0ogC2N2pfmX5AVn7+JQ0nhmoGkd5BIBmNjF4=
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com (2603:10a6:7:8c::18)
 by HE1PR0702MB3658.eurprd07.prod.outlook.com (2603:10a6:7:8e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.22; Sat, 1 May
 2021 16:53:59 +0000
Received: from HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::9164:3400:6c01:be45]) by HE1PR0702MB3818.eurprd07.prod.outlook.com
 ([fe80::9164:3400:6c01:be45%5]) with mapi id 15.20.4108.019; Sat, 1 May 2021
 16:53:58 +0000
From:   "Leppanen, Jere (Nokia - FI/Espoo)" <jere.leppanen@nokia.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
Subject: Re: [PATCHv2 net 0/3] sctp: always send a chunk with the asoc that it
 belongs to
Thread-Topic: [PATCHv2 net 0/3] sctp: always send a chunk with the asoc that
 it belongs to
Thread-Index: AQHXPfvZJ8totFyIakKai/ytWIHST6rOrfDM
Date:   Sat, 1 May 2021 16:53:58 +0000
Message-ID: <HE1PR0702MB38188BD50D8091BC350114EFEC5D9@HE1PR0702MB3818.eurprd07.prod.outlook.com>
References: <cover.1619812899.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619812899.git.lucien.xin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nokia.com;
x-originating-ip: [91.153.156.237]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 860187c5-d41b-4337-9555-08d90cc1b70e
x-ms-traffictypediagnostic: HE1PR0702MB3658:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0702MB3658F3EA1E52ABF5F1963EF2EC5D9@HE1PR0702MB3658.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f/taCFZOLQc8YIk9PsMlijpJZyghx3aQNmAK4wQpQuZPeA4xdZeEXz4Pbuza7i/aWvCI197kic9s02Um5GjR0gdXid3VdsazZxi7oYCKgSxpU9EKgTEVt6WB26IhC5V4vYC7CnAnptB8lChEXIFOUM7tPAsIW5LQhT/mn9J5S3ZDCCds7UAm0dKA3MkbKTXcONibzlhA7tc988vu4aF6JaydrurqJCapfDFjP0rUVDQlQ5665F5fzY4r/wkUBazZDkym5SNUhWdK1s+hRqYo8kXIFBFRbtOoiZlxdEhpL0pAaV9s7PrvVufkUZDkt//Cp7g0TaI3SZ4xBoox3i8XaWtwvA+viMsKam+iVtCgoPi6kfJGgoDEREt2ENI7uZ+qNfgZDLWRhZMf2dvEEOHOZ8NEg2O+coodTcZyuMIwrEgOGqH+5LI8Mhie3pnamxjJyLkk9i7CBRstJU8ZFXfTen02eJQzBhvEKOH3mZkcywaAEaItNQyjfAklftA5mXKzZh+pD3fhtsAH9C1zsWUC6iipEkiwwRY5PR3HblGGbie4dgnhZiTXxwsSCqMPe96/32KxevaJNOB6GryheUlF7wlnwJMu4dYkyQXUCKh2O/I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0702MB3818.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(6506007)(71200400001)(2906002)(55016002)(7696005)(9686003)(86362001)(107886003)(316002)(26005)(186003)(54906003)(4326008)(5660300002)(110136005)(8676002)(83380400001)(33656002)(122000001)(8936002)(52536014)(38100700002)(66946007)(76116006)(64756008)(66556008)(478600001)(66476007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?BB/XdcxOJV/nUhaTwXWkfzdo/DfJVGfg0J15z9K3hhv6lbU/4vrfdGGMPU?=
 =?iso-8859-1?Q?xheAJ3XmPnRz+pFJixjfMlExfdc7kgVRqx8LkMH8nxTd5vh6cVNjoGeBmj?=
 =?iso-8859-1?Q?/rlvT/3B4n1PMSpIKMTkqyeDuLX/vh7e5vX2TU8xusRWGQ1sBvJUs3XGda?=
 =?iso-8859-1?Q?rFNsNiCdDipjHxBT/dR83VZCTuI4qyIZbk3ESgGqBWqo9DRywIb6IiimX3?=
 =?iso-8859-1?Q?1yOZ1kBqMg/KIR8YrAyNbZxW2tQ7Wz6/CbB+FKVEaC6FsZFT/yjqxi5qIm?=
 =?iso-8859-1?Q?ymCOGOuYA4SkZf1EuE481Y7OajLNiOOHhURazr49Uwre4MAc6EnTP5Bh/g?=
 =?iso-8859-1?Q?e4ChO2N+aDYik6L0DTs4Y7x3/p0uM8s7QGpNok9tHJwQvvuZhYOwXGvt1S?=
 =?iso-8859-1?Q?/OY0kud+u+qpVlmLMTBmBfL/AMo5uqsbPYqAojjNKaupe73GWm8ddyIUFQ?=
 =?iso-8859-1?Q?NHWmDFCt5zFeitgU52dr36YIsc8D58O0E3SxJM3m/maaxseOCNcBEAz+oT?=
 =?iso-8859-1?Q?wdrxymYKhdF/Xhrc/fqt4TMHWrPl0iCVxfRNuF/sJArLWA08XdUw2nZ2R/?=
 =?iso-8859-1?Q?D9U78mb8k9jaMzK2a9kuD1iFOXkfatdZJqjOUcEfFt5LrmDr/aok3mJgq9?=
 =?iso-8859-1?Q?ogRl1XPhuulLNvSRV7MCyM3c/RwH528OHJyNng2IK5mp0xRYe/40YBkc9B?=
 =?iso-8859-1?Q?w6Hfm8CpuoF40MJ9hsUWA8BgwUHWrMQxgJ3mgxqCLNzkgimo0auaGnpWKB?=
 =?iso-8859-1?Q?rBDimvdKmoquqUg+qECOk19CjVGVXJR+8WwEtpnsxSgKp4FBurfHBywQ4d?=
 =?iso-8859-1?Q?qF1Sj9yUnRHEioEfwnXpy5PikNgP5mVxqFt8jn1Z2B5nRARuNt2oqidRx7?=
 =?iso-8859-1?Q?Q87JlEbjO00lWECxPZQUXmmF3s5fpmXtmq6tskohvSsNaFC6+hRCtkbnnW?=
 =?iso-8859-1?Q?S/TOrKxIPLPRiRk9eZSAS1fCaHDLcZ+EACLY8hW+BHh5031hCi4P9nNFit?=
 =?iso-8859-1?Q?ks6lKCmQ6Gd131oyLW1kRD7IiWkSsm6j2AH7TpYQ7TNn+znON3z4hnvnvS?=
 =?iso-8859-1?Q?QvbbhuBM7T4Fgj8f7N4ieUUTnPruv817c7sa95ND/b5E0kt1x3/4WcoCeq?=
 =?iso-8859-1?Q?FFEbXO2ZVk6kO74drQgZRDLHgdCp5KNKVTFvetbJnSGioAdhKZGiCGPIR1?=
 =?iso-8859-1?Q?ybNO4fs8jXVwh1pSkhcRKKGFHzR4PNN1IyPQl1Ekhvi1eJNxt77KbLfi4R?=
 =?iso-8859-1?Q?qH3+tWg4RN/2AfNdM9B3hTRCqHwN+PDfJhFgaL86vE5wMlb4VHWCYJ6uGy?=
 =?iso-8859-1?Q?HGsuDOvXysQSYm/NQJzQ+c+5VfKDn1CqLFbEv0Lb9j5F7RY=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0702MB3818.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 860187c5-d41b-4337-9555-08d90cc1b70e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2021 16:53:58.5705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7rWs4UdmDaiw3E7GWH4N4GltOuUTEC8sUXSgVG79LVsIhy/qKByj/e+7oZ97e51AYT5HN6r0VfKGr2zGEPzCiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3658
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Apr 2021, Xin Long wrote:=0A=
=0A=
> Currently when processing a duplicate COOKIE-ECHO chunk, a new temp=0A=
> asoc would be created, then it creates the chunks with the new asoc.=0A=
> However, later on it uses the old asoc to send these chunks, which=0A=
> has caused quite a few issues.=0A=
>=0A=
> This patchset is to fix this and make sure that the COOKIE-ACK and=0A=
> SHUTDOWN chunks are created with the same asoc that will be used to=0A=
> send them out.=0A=
=0A=
Again, much thanks for looking into this. Patches 1 and 3 are=0A=
almost the same as my patch, which as I mentioned I've been=0A=
testing on and off for the past couple of weeks, and haven't=0A=
found any problems. (Then again, I didn't find any problems last=0A=
time either.)=0A=
=0A=
I think 145cb2f7177d ("sctp: Fix bundling of SHUTDOWN with=0A=
COOKIE-ACK") should not be reverted (I'll reply to the patch).=0A=
=0A=
12dfd78e3a74 ("sctp: Fix SHUTDOWN CTSN Ack in the peer restart=0A=
case") should be reverted. With association update no longer a=0A=
side effect, we can get CTSN normally from current assoc, since=0A=
it has been updated before sctp_make_shutdown().=0A=
=0A=
>=0A=
> v1->v2:=0A=
>  - see Patch 3/3.=0A=
>=0A=
> Xin Long (3):=0A=
>  sctp: do asoc update earlier in sctp_sf_do_dupcook_a=0A=
>  Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK"=0A=
>  sctp: do asoc update earlier in sctp_sf_do_dupcook_b=0A=
>=0A=
> include/net/sctp/command.h |  1 -=0A=
> net/sctp/sm_sideeffect.c   | 26 ------------------------=0A=
> net/sctp/sm_statefuns.c    | 50 ++++++++++++++++++++++++++++++++++++-----=
-----=0A=
> 3 files changed, 39 insertions(+), 38 deletions(-)=0A=
>=0A=
> --=0A=
> 2.1.0=0A=
