Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683DA48C109
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 10:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352070AbiALJc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 04:32:59 -0500
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:61545
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238079AbiALJc5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 04:32:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndgEfX4B8/h8fBqOH6vftkHxjIuuNxihHzxH4ul0YL/fHwJ3fRi3+z1jhpu/sbguBEwwuknP8G5bx2P7yi8AYhypYvtQ+BIgzWJon3udt2MgBQ8vI7ADu04ldHmWzmeucyd4uhvPnd93eDR3QZSDmKE4inmtA6zlxF2Dxu2rPPDS4Aig+DIowXXGTs0/Wg0miYr+AwbwSkYyrEJZN4Yo8pEi/4dJoauULWKMsq1MJG29lSEVrb9V3Va1fc7rtrDKqaKurGYib04+EfOMKI2D9z4o7pnc4aPBrymD5IZLEwPq3gENsArPexBPwn3KEtNY+0CXf6297Vwzf35y7BRGfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdYfW70J0kQKjUhVSeg+NOH7s+EzkLGichRdwoCbEUc=;
 b=FN+H5vwstqR0RJE81+06a79u+eeFlKOdQkP/QEYSoof5SgHMtZx61yQ+BEYmDwlRz6QkixDE/UYsDYWlJYAJCOQPW73CVKgLFjSuALlGFfhMPN4YaM7xV00hahYjjNDZm8mDF0eCUdmvLzcTYrmqokm/eiFFB0wM/aD+1fva9oq6E8lL/8ZxGR/UGfJz+I+by+zALlW1EsjK6dryofTuGLyq9lOzPs2jdF+Qzdl4v7nzsCGPt2DUhLUCkyRU/D58V6ARrjiMmTeOW6IuRPMfYxMMi+D2TQKoKXigZYnPPp53H5CUc33TRTo60fWKsSgUnKnC2unPdcqZjdqIS1Mqdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdYfW70J0kQKjUhVSeg+NOH7s+EzkLGichRdwoCbEUc=;
 b=ksZBOsu1hW0xxvZ9j4xzlaBdNSYYBUJOYKLdh7Be8d2+KFnlLfRa6hSkE1m0yakzeIz3Mz7FyF+NVB+Z8mk482vwTTpATi3lL3aZHpVRh4QYVMiK0nheuFMBMZAQKpQM+3mgCqCA+JxDxaFhjtmWRz9FSXqkG/LYbyVwkuqWP18=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5577.namprd11.prod.outlook.com (2603:10b6:510:eb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 12 Jan
 2022 09:32:52 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%6]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 09:32:52 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 23/24] wfx: remove from the staging area
Date:   Wed, 12 Jan 2022 10:32:41 +0100
Message-ID: <65681266.04G08nq4u0@pc-42>
Organization: Silicon Labs
In-Reply-To: <874k69jsv1.fsf@tynnyri.adurom.net>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com> <20220111171424.862764-24-Jerome.Pouiller@silabs.com> <874k69jsv1.fsf@tynnyri.adurom.net>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR3P195CA0004.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::9) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 568646f1-afa6-4286-5d6b-08d9d5ae8110
X-MS-TrafficTypeDiagnostic: PH0PR11MB5577:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB557735AEC0D7454E5B3257E193529@PH0PR11MB5577.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJrVeRdc22Qg0Wq9u/HC0TAxjTakj+liAHSv6bbGoOWOYZj4ZCueOZFT2pzDCAUXYvCwZvDKGbWE+pMZa7kVY5xZvI47dh9Lup+Rgi0hNRYZ2whRnkQliLtThIRYYjeHnlwr3uaA4R1y0jGJlF6V6Bx0WSMfgUMCvkPTEl9/x2kQZVSwznrnNHBq8g16+weBysDRQy0THHoi3VGWnipjmAr6vvWXHAal0X5h0S0STNoGO7OROsZB/8x79fq+G9uTto+J1ATSmRQv88Uss7F52aqKrVMfdUSYOgWZH3ZYbKbfs82VS1B15bEzhBbo0KsPiigUYn2vdwvWbjVMqzUyZpPNpxeiIEghUFG4fEO8lWKCsjRRuKpTLNHAua919Oh7/6q+UKD+lk0UYtSQwtLBwNKHu7hX5HGiHyd3OlJ71/jBpZ/JjBbFQquPyBbBGc1+tbr5HvZtDEBiooelVxkFVWuXTkrsXAfoaAOQCA/vRcTiuN2uIFD4zpkBrgD2/3rWWmrSET5lsgpYK7osl1mFd5zdcpPlnqL6NnR2TYoeqvEs4N5BlhfYLlb8DWfkKZassUIJ25D7CklzXAA1e6KiayBEzX67WqLvSsFltFdR6raMYqxZUk2LKpVbPM+73NDvKDAg5fDJCpYMoUqw0QFpYBwZg8xOsCG0+gibUsAHUMjxI8XAQPBTKYc6Tf2V7X2UCLSKDkixb2CmwFgw2pPUvKhmTE7tJrvhNiURccPwJT4BdQoYGd8ksbTSTPbElfTxL6k6X7RVJVR0zoiYi1hb2vKgpqlPV1ayxTvT98npock=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(186003)(7416002)(38100700002)(66556008)(2906002)(508600001)(9686003)(36916002)(5660300002)(8936002)(66476007)(6666004)(86362001)(54906003)(66574015)(83380400001)(33716001)(66946007)(6506007)(52116002)(8676002)(966005)(6512007)(4326008)(6916009)(316002)(6486002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?g88XobbKW64fWCE9AQsJ8bYt5H+c3tgi1uUbcso84jvdsHbpSSWxPe/7mT?=
 =?iso-8859-1?Q?MFxf+RJ+usFlZcGQqR2rWxALwpjz8IyKGx8BkQRbF0q7XAFDWFG5tVpVsK?=
 =?iso-8859-1?Q?JiWwpINlRGeJQVcl++fmgtmcYv+hT70Y25m27OSy+INkkARftqHKxrIzT6?=
 =?iso-8859-1?Q?NqBA3s0W3cot85z/AV8l4RMlYd8CXopVDc/TdA0xHqiqOgbytQSnDvS+GZ?=
 =?iso-8859-1?Q?gV2K6c9+mtclJIyScsuSUbxp72WV8ly4FOzl0BnV5r2yIC5cgiIHHXGdc4?=
 =?iso-8859-1?Q?eTLZZVeiyYcg1E3eyXjtx54M4GJ1AOBY2iHt0JTD05Hd3bgY9xLgBOqUFD?=
 =?iso-8859-1?Q?oghSO9UdZt7U9NsK9o6ig+7c6RXYKggk2GdRrfpD8ZtCzZl2kCenwmsdVX?=
 =?iso-8859-1?Q?GfQRRZ+QbuBgmztyqv+6HpDhtHmVpdm2rELtwydoDOxdI1vgUXsIsJ+iMA?=
 =?iso-8859-1?Q?gKeQyIXImsblHixra8Juvz2qwKoGGsJB37zE4Ft+R55FP/fg9a1c3Dohy6?=
 =?iso-8859-1?Q?FacvU2BqbehkikvMGJFkgt/HGYrAbm+Fs//uxNhGDMZmutrGhk+ZPMUWOP?=
 =?iso-8859-1?Q?dg+YHTlk43LzlJZXI5/x0gTIt5R59OTGrSOwRwAGWnipwauNgSMKWO+snA?=
 =?iso-8859-1?Q?Gute8UXEU2+ugdOdMhE2ea6EDw3X8qoxk0Wo+3UB5Cv3oQWiAOp5ofqSfF?=
 =?iso-8859-1?Q?4kDXirscoXNFrCc/Rtb2Flf1wuRc11/2pmzaAL9miwWGHuHfxmiA+1hFjH?=
 =?iso-8859-1?Q?xXbGFPTD8NZMyk4B01dI0v5TkGOiF/FePTIws607vhltXG9L4yv1BIkjjj?=
 =?iso-8859-1?Q?4QlhNjCFWk7OoNz1euY9amalu7k6yfA6bKkE25XQz6u8GanufmfZ7ouKV+?=
 =?iso-8859-1?Q?AWdMCKr1Qqhygz+yybyPxxMiasEipBsZvvUo7kAMm0K12hyGQjGJQfzrIb?=
 =?iso-8859-1?Q?W12JP1EkcOgyypl6GIw4HWyPTCLYq0jRL31EV79gngq18L9NvF0Echv3it?=
 =?iso-8859-1?Q?EnOxiknumFJFdqJ34qpEhJZq7+VNlxRh/kQL9e2b8eFCPxDIsaCvT6Q3D5?=
 =?iso-8859-1?Q?2AVZ4AQJCg19TTxBNuwon237ydlbvZG0JvbNnqtA9aIGepmEiEoZbsoN55?=
 =?iso-8859-1?Q?jQD1T11WpHcs3f7SOta3eK2DlXvF7a2hdOzGcmyPdCCDG6MjnMv1s8Fp6K?=
 =?iso-8859-1?Q?rjvJKBs1JCZV6vcSdvbXX368VpFaejbAdUOcH8H5GdTnodVuMxeySR2OdL?=
 =?iso-8859-1?Q?kGJREb396zP8K6uTJh2obKk2dZJWYtbrmk923YSNT6chUSLX0g7FxP2Kl5?=
 =?iso-8859-1?Q?+F8IXIJGrLAnNafe4rFLUHi9GMBFSE62SDnf+6Gij23gIefTpZoqFeL01A?=
 =?iso-8859-1?Q?Wtc3tc9quELA9e8JtmUPV3T5PxMa1TC1gp9YVdCbqjrBJYLdPnzM1R1QNy?=
 =?iso-8859-1?Q?KfvPWt+lHi0h7qtCJz7qEKHKmWPjpTEBQxfT6CQIWb8QcfDICgDlmH/XsC?=
 =?iso-8859-1?Q?54EyQkUn3syAr0tBrolggIkzAt/VORtCsRCxcjmOETRjtO+eQ96M1Iip2l?=
 =?iso-8859-1?Q?gKYbnVNTEh4X4bNfcUUruTDMnnXfy/PKECudGtNHM3NAfJq36dR+yUgsNr?=
 =?iso-8859-1?Q?ltTKq0l2rzYK9pWXjHTRTbObRQ9K+70RDoWkG/pgw/PBE3V1jPhpyHIjM8?=
 =?iso-8859-1?Q?kBYixo3YJUoPPJDL0r/x2pg3sVe7w5RAlZ9e3KEPKUR779M8phfdjWAy/2?=
 =?iso-8859-1?Q?184dAqMCXtYQdGhozLDYyneok=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 568646f1-afa6-4286-5d6b-08d9d5ae8110
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 09:32:52.0226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ASOYozi2ldoQuKKnja+CARYpZLmgtt7iOjOQz+8KfDgoAb9a3R/IxurTr6kJO3zihHA10So6Lj24jQj3SIOMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5577
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 12 January 2022 08:49:54 CET Kalle Valo wrote:
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  .../bindings/net/wireless/silabs,wfx.yaml     | 125 ---
> >  drivers/staging/wfx/Kconfig                   |   8 -
> >  drivers/staging/wfx/Makefile                  |  25 -
> >  drivers/staging/wfx/bh.c                      | 330 -------
> >  drivers/staging/wfx/bh.h                      |  33 -
> >  drivers/staging/wfx/bus.h                     |  38 -
> >  drivers/staging/wfx/bus_sdio.c                | 272 ------
> >  drivers/staging/wfx/bus_spi.c                 | 271 ------
> >  drivers/staging/wfx/data_rx.c                 |  94 --
> >  drivers/staging/wfx/data_rx.h                 |  18 -
> >  drivers/staging/wfx/data_tx.c                 | 596 -------------
> >  drivers/staging/wfx/data_tx.h                 |  68 --
> >  drivers/staging/wfx/debug.c                   | 365 --------
> >  drivers/staging/wfx/debug.h                   |  19 -
> >  drivers/staging/wfx/fwio.c                    | 405 ---------
> >  drivers/staging/wfx/fwio.h                    |  15 -
> >  drivers/staging/wfx/hif_api_cmd.h             | 555 ------------
> >  drivers/staging/wfx/hif_api_general.h         | 262 ------
> >  drivers/staging/wfx/hif_api_mib.h             | 346 --------
> >  drivers/staging/wfx/hif_rx.c                  | 416 ---------
> >  drivers/staging/wfx/hif_rx.h                  |  17 -
> >  drivers/staging/wfx/hif_tx.c                  | 513 -----------
> >  drivers/staging/wfx/hif_tx.h                  |  60 --
> >  drivers/staging/wfx/hif_tx_mib.c              | 324 -------
> >  drivers/staging/wfx/hif_tx_mib.h              |  49 --
> >  drivers/staging/wfx/hwio.c                    | 352 --------
> >  drivers/staging/wfx/hwio.h                    |  75 --
> >  drivers/staging/wfx/key.c                     | 241 -----
> >  drivers/staging/wfx/key.h                     |  20 -
> >  drivers/staging/wfx/main.c                    | 506 -----------
> >  drivers/staging/wfx/main.h                    |  43 -
> >  drivers/staging/wfx/queue.c                   | 307 -------
> >  drivers/staging/wfx/queue.h                   |  45 -
> >  drivers/staging/wfx/scan.c                    | 149 ----
> >  drivers/staging/wfx/scan.h                    |  22 -
> >  drivers/staging/wfx/sta.c                     | 833=20
------------------
> >  drivers/staging/wfx/sta.h                     |  73 --
> >  drivers/staging/wfx/traces.h                  | 501 -----------
> >  drivers/staging/wfx/wfx.h                     | 164 ----
> >  39 files changed, 8555 deletions(-)
> >  delete mode 100644 drivers/staging/wfx/Documentation/devicetree/
bindings/net/wireless/silabs,wfx.yaml
> >  delete mode 100644 drivers/staging/wfx/Kconfig
> >  delete mode 100644 drivers/staging/wfx/Makefile
> >  delete mode 100644 drivers/staging/wfx/bh.c
> >  delete mode 100644 drivers/staging/wfx/bh.h
> >  delete mode 100644 drivers/staging/wfx/bus.h
> >  delete mode 100644 drivers/staging/wfx/bus_sdio.c
> >  delete mode 100644 drivers/staging/wfx/bus_spi.c
> >  delete mode 100644 drivers/staging/wfx/data_rx.c
> >  delete mode 100644 drivers/staging/wfx/data_rx.h
> >  delete mode 100644 drivers/staging/wfx/data_tx.c
> >  delete mode 100644 drivers/staging/wfx/data_tx.h
> >  delete mode 100644 drivers/staging/wfx/debug.c
> >  delete mode 100644 drivers/staging/wfx/debug.h
> >  delete mode 100644 drivers/staging/wfx/fwio.c
> >  delete mode 100644 drivers/staging/wfx/fwio.h
> >  delete mode 100644 drivers/staging/wfx/hif_api_cmd.h
> >  delete mode 100644 drivers/staging/wfx/hif_api_general.h
> >  delete mode 100644 drivers/staging/wfx/hif_api_mib.h
> >  delete mode 100644 drivers/staging/wfx/hif_rx.c
> >  delete mode 100644 drivers/staging/wfx/hif_rx.h
> >  delete mode 100644 drivers/staging/wfx/hif_tx.c
> >  delete mode 100644 drivers/staging/wfx/hif_tx.h
> >  delete mode 100644 drivers/staging/wfx/hif_tx_mib.c
> >  delete mode 100644 drivers/staging/wfx/hif_tx_mib.h
> >  delete mode 100644 drivers/staging/wfx/hwio.c
> >  delete mode 100644 drivers/staging/wfx/hwio.h
> >  delete mode 100644 drivers/staging/wfx/key.c
> >  delete mode 100644 drivers/staging/wfx/key.h
> >  delete mode 100644 drivers/staging/wfx/main.c
> >  delete mode 100644 drivers/staging/wfx/main.h
> >  delete mode 100644 drivers/staging/wfx/queue.c
> >  delete mode 100644 drivers/staging/wfx/queue.h
> >  delete mode 100644 drivers/staging/wfx/scan.c
> >  delete mode 100644 drivers/staging/wfx/scan.h
> >  delete mode 100644 drivers/staging/wfx/sta.c
> >  delete mode 100644 drivers/staging/wfx/sta.h
> >  delete mode 100644 drivers/staging/wfx/traces.h
> >  delete mode 100644 drivers/staging/wfx/wfx.h
>=20
> I'm not sure what's your plan here, but with staging wireless drivers
> there's usually a simple simple move (git mv) of the driver from
> drivers/staging to drivers/net/wireless. An example here:
>=20
> https://git.kernel.org/linus/5625f965d764
>=20
> What you seem to do here is that you add a new driver to
> drivers/net/wireless and then remove the old driver from
> drivers/staging. And I'm guessing these two drivers are not identical
> and have differences?

Until v7, I have more or less kept in sync this PR and the staging tree.=20
I have been a bit lazy from the v8.

However, I still have the patches in my local tree. I am going to
clean-up them and send them to staging.

--=20
J=E9r=F4me Pouiller


