Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2F36734F8
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjASKB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjASKBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:01:02 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736446B9A9;
        Thu, 19 Jan 2023 02:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674122460; x=1705658460;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=49JlFkWNesTfP7tXmnNSof5BrQAxRITQj4Sluhdh8B0=;
  b=VBrqtWqwvkLmPhSg7GznIKvE1CKmnpIM5Uj/YaLfkRoSwNqFcEXAtHeu
   tlc6AQG78EeDqRYy/Ap08/sbRdyJXy6Q2koV87v16WssqWvBCLThO9nWZ
   OYTXLGgY0x6/T3UkUBeR/szZYJORkOO4jv5bsS5QAxRq1UDyh5N723Prw
   G83mKEMZHCYzJAwmeQHscguEhBbEtqL3Usa5AkGuqNfzKGQTLH9cG9KpN
   al2bSLR/Fy7KsUnYSXbHgC+nGOiDOpkm2XjIxeX2GqfOxpQd4KwKH2SM7
   Qjl4dEWKsRkCY+6z8H6E3/t2x+iVS3loXoDsIOBXFRMT9VnGW2E8JoZEX
   A==;
X-IronPort-AV: E=Sophos;i="5.97,228,1669046400"; 
   d="scan'208";a="221347239"
Received: from mail-mw2nam04lp2168.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.168])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2023 18:00:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPkAuoFCeELHenCFcpEOWiU0QCBoLazIyUo/crnNxb6/XvLzzTy88XimqJ9GsqAGRf4WXt+nWFMuYB+8cZmITa5BG/cE/eFPe/SfdYwXrq3raL2N8jrJnCRoQCkba9DTXOeoxrN5FyDXcSu0IsMddfLkvHC5svsp+iLnKgFJvByroiBk4VLTqVnDKlBaWYGpWcBXAlkt+QBX7oYkmp4fW/oJeYmEzQNm/izfWMttOOGmKPgnE/gY1IJHT0ntjsILT5uyG7jbOOQniZ09Ljcl441yHylPeKarw4/q7h+Exmll634uqKG/ty1fQ86aE31UpuSST2PGn6DqJajglvkEkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l8ARi2U+iuki8H871UKig/rfUF48iWbkCbL60J0q8u4=;
 b=GFsj0oRtxzlzGBvfbhCCQKtI1n1dUgJyJFbWVMzNM3hJqpV3Q+WvCUWFd407+rOLmDPJUZKDSlzumGoJYiovPJQ0fthQRD3T4qi+hRepgO+djNb4kMXFWko/DPuNNbsno+wYbztHXtNyRxL2G1w22saxmsddmCHmvqnWTtAiLj5m9+QsFBLrtw+iUNeM1Rc+pTf1G2iICluMuNiK1SYjbXjBk9c8n42fSGhCufEhMG6MRiD0uAL4zb4voBqJ5XHsHMhtyaZ15RDAhxp6SJBHqo/2gd5Po216xMMMectHzyLG9DJAl+d9NjCAJ02JkXG+PvEujBoBTjMiTKkcFYPxSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8ARi2U+iuki8H871UKig/rfUF48iWbkCbL60J0q8u4=;
 b=jM8QXC9sDl6wdwG7eWIKh7BIC7FF1953Fv/6vipS2H3ufj0hlvUayqIcrK96dD+3Wi5rKatgFt04aUT2YJJ8ijUmWLzY12nLLP7SXZ3QrCvNX7u27oi5pnUNvT1WV/EsLssG/XLp61NKYdyKrtut4Y2tNCUprsHNvsP2M3nQbDw=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB7107.namprd04.prod.outlook.com (2603:10b6:a03:22f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 10:00:55 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164%4]) with mapi id 15.20.5986.023; Thu, 19 Jan 2023
 10:00:55 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Kees Cook <keescook@chromium.org>
CC:     Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH] bnxt: Do not read past the end of test names
Thread-Topic: [PATCH] bnxt: Do not read past the end of test names
Thread-Index: AQHZK3xf3I4ofI1/RUqV8GdOVJqInq6lgt6A
Date:   Thu, 19 Jan 2023 10:00:55 +0000
Message-ID: <Y8kU10ZFNHJ2Q1IR@x1-carbon>
References: <20230118203457.never.612-kees@kernel.org>
In-Reply-To: <20230118203457.never.612-kees@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB7107:EE_
x-ms-office365-filtering-correlation-id: 4c8991cb-8e91-47d7-cf26-08dafa040e98
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IqcggM8hc6KLCjNeZmWc2a1TS2x1cDcDbwHkBeyKI5nexaGRseIKjv1UXgZTT1kMTkYa/1qlOWdeWHheYvqHVERSi2Iplp8nC5IVWyma6qkrZyfhHXlsikkEdZht+RRdYuqgD/3ZcS4irwSTn3/knZM9flCM0YFPc9gF0w7MSi0eex3ZpxuYszNs4GK07QhFPdKi1oR2dizGW3Kd9lIvGXQqnqTjezlDmb7h71Svj7U4KaZNrMhtVeaqBg52m0XGqbFX5F7UTLiU77fhdMzVldkt1H8L7QAOsA4OPfT0AkHabVt5KcwGRoHUbov3pLH6crajm/oNE47v9jRoYyMSnuoa/7Z8PpjcqFMKB8glZvfPF9nRTDx6bLJclZfDADqo3XOILnJw63dkJJM84LtT9+FDbe6WoBUGa0rax6JZnzd6Ygp/XYbGSjNwd8ajFGkKpgnBbft6yTlnnYtwcUF5KsBWKQrHacF0m0vzb9FnKtSB9IW2HQZqFFT3/VpscQfTKbS88xGDJVj9WL+xhfBYi5F2PuU7W7zVbnE6b9p6Xj0awOLA0WZuzJAbWY//CsPHEBZtDIOjl4Mwcbm852RC+H8ZTdg+Sz/82vgEJr2C+Jygik2AZS31bMwwyRc4XNB8p2wYckpcik3Heopv7/iWMim13EKL1f6HQR+jI/jUe0m6H/VLRrvqROFLT5Y+bET8vWYISEJ6oiiEC+D1a7mIyNZlsVmywI8B80UO7Uj5rNo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199015)(91956017)(86362001)(9686003)(4326008)(66476007)(66946007)(6512007)(64756008)(6916009)(41300700001)(66556008)(76116006)(66446008)(26005)(8676002)(186003)(71200400001)(2906002)(316002)(6506007)(478600001)(54906003)(966005)(38070700005)(122000001)(6486002)(82960400001)(38100700002)(83380400001)(5660300002)(8936002)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j9aok6c1Jz5O53v0deeOWq3+1vjs+gzW7a68xGJHPEgO1KGs4rh6wCB9WOtf?=
 =?us-ascii?Q?7Db+T1MpgUTBiACZqW7NiXEBI0m86UK0FVCTzpnBFHm8AANHJAiy8HG8TlX/?=
 =?us-ascii?Q?WK6A1XGO/GPigog+MqO81vESy6KY1ZCevby8g2QF7DhQ3D8huxDSq30drUpC?=
 =?us-ascii?Q?eLp1J+Af3PAR4ZgL/7zjyNPkQEM2+b1nxXUeT6KfOh+3uqOYMBlZ98e2mD66?=
 =?us-ascii?Q?wNGldvoGYfEzOSBSehnyJqxSNHetE29fQm/Cyg+AwlhD38yJj9RBprhvTkEA?=
 =?us-ascii?Q?TuiYW/xi3tbOeAn+xRc+r/42a4ZmlW4j9Sw/JgGPeNsLlrCosr0Wbx0/nOEd?=
 =?us-ascii?Q?RZATpbnusYnSoPbIZByFJ0+BrdFNSGYZvc+wyC20IW3ggKf4Vc/Lfc5QNS2X?=
 =?us-ascii?Q?5sl9KjdTuuF6N3wZqBxjHfvQ+rZiYEn7hGOORLmLhU+tdlrsZU/fTBLxCQ3S?=
 =?us-ascii?Q?pIGALxHrOYmfDyGgp+B40NlwmgVjXsoz9vOsw0srSVfskFP444sc3OHgdjNz?=
 =?us-ascii?Q?6LMSsGNGkZS+DmjqDA4XVnTLezaVXr1sZcAtbzBAoFi8qEskLmlPbcMEsLYA?=
 =?us-ascii?Q?pd07FMLUAB8qjh+5UvrIiILnipz2o5M5QYenPcciTo2pyeu/34WB6QdNZ0+Z?=
 =?us-ascii?Q?WRLzmbPr7rIIsQcnHKitzQDSaqk5A9b6vr2u0+hYaoR4lWHLvoE1fxynKSG9?=
 =?us-ascii?Q?WGvZ53eUc31tU6slfMHkf5fDNkaKvm8NylQoiyl+aO3Daq4FbzyGbgPLejKG?=
 =?us-ascii?Q?/gPi6Aoz3Bg9H20ixGgRRbWHZ0WMbeIonaQiYA5igqTjLhmmmZjSQ2zxEtx3?=
 =?us-ascii?Q?eUTfWdxSy3G9HL0M8OMYjV6NC564aNb8D7QRgECBq1i6aAONz2mwUyJCCXzb?=
 =?us-ascii?Q?2f+6MvnSz8vBqe1MgCelRJGbN4OjYWHtXeXw/rQtGTea1fOmta0QE4FaPY/L?=
 =?us-ascii?Q?Hty3Ay+GMHhXzNE+X1RgdmmZMYsPYYEFUJ1t+oHTrM2cKZcU/N+ydDH2XOOT?=
 =?us-ascii?Q?Vlg7kF45zZBpXeLijMdBGesLjF1WZwPooYTA+ryZeamHYWjR6Or/VrdUl9LZ?=
 =?us-ascii?Q?ByEslJ3i1xsDEjJ02agwmfm6+3YA8jbF7OU16phPI9Fakt2DG6GyNCZ3uIH5?=
 =?us-ascii?Q?cDRCoFn4NFvTSgBq11Ui8f1AETiqJ3hxwoce7H3YxqOcvgBmxBOsK74l4lHa?=
 =?us-ascii?Q?rplQLiOwu3a+/PoczQ49p6HT+cYcD94M8G2pTU/z95dgsanciMSi47+QSj9J?=
 =?us-ascii?Q?0cN6uO81kHfbaj6HK5x8adgAILztDDYnLVMosaKkQZvLsTTECs26WdsxarWF?=
 =?us-ascii?Q?4LI/2hbCZT/omvsJNAuCo1kf2R5azZaHfFY7Zx2mgYeew69Be4SVoU6xpDRU?=
 =?us-ascii?Q?YqLL5mraPv8aUt2fUy2ZV+qb8KbspJbqEzq9IFyxFpIRVP0mRo0jJDCRdzHx?=
 =?us-ascii?Q?InfMzv3lJ3R3Sj70uSBojAHLEGK1IthnRJijzUu8wg+yu8KsPhbmm+GI9/yh?=
 =?us-ascii?Q?DNCtDHe3JGkLvCUCQlsqlD1dS247omFOlEmtIuHO16x7PDw2c+dCkR2KtlLE?=
 =?us-ascii?Q?32SOctkD5NAFJDojP6MLUWzLyNu75nbJQHB0iVJU8hse0aaa2n6SgH0fdIEn?=
 =?us-ascii?Q?wQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AE6F665CDD8F6743AFD119C6F93106A4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?EvYr37Q7XAaVV/IyLsRRrsmttmlfmytsXtFSvDtbpjavq7znMkR25OPldssi?=
 =?us-ascii?Q?mQrwbogBa/o+MUuXGjkF/Ms9H1JZRGQQ/B/JBfOedq7EcHG+uU/oUWOs3NQU?=
 =?us-ascii?Q?ZGxyjDfuOhnXHu+1pa1CFmr3c7wBxVTqf2NvXgaFMkd7oB9Cm6SeA476Yyq3?=
 =?us-ascii?Q?lBeVGjEkR0tSgHIy/yrYQaA3TiiW5qW2xkSOY44l7UrIHPb355OYuf16Wb7r?=
 =?us-ascii?Q?2DovHQsmuW/bddvmVgkdqLB2o0r/ryUvMRU7UeGHS+cEgNk4lALqOZJXesUk?=
 =?us-ascii?Q?zPbrBLBt8SDWyhb+b7lHFwHlbNTf/I/SZz0XJptsLfazdcQNJRBq36B2Gg8v?=
 =?us-ascii?Q?COuEDEQlhciv+kS6OSb0D0rxKoBAq4D0cC57G/JAKOmGblq8c8zaYjLyFnSY?=
 =?us-ascii?Q?zOkFkLVbZo2UPys7hQvqGSbV7ZMZnM1Q9jQnSniBBAinPOe2umOcJxLFJIOC?=
 =?us-ascii?Q?a2f+hP6HyCq7TA9L0XPWUyxbMk5ZOW+JW3cXRzV8KYGQqaqAHiZVfV+xiYzY?=
 =?us-ascii?Q?zzWAySZVCZhiPFw/g5pBrX4RRgLFVTzxIez9IgZ4i9UNJtjsp7MFuDaZ0tCs?=
 =?us-ascii?Q?92tV0oykDWvucbrQoDyKBIv32mvEN392oEqEHrwbm+7tWpUKsJwCIRhxe3Vz?=
 =?us-ascii?Q?5vOFxstJjc0SKJDe93dnMtbQye74TtXRKuGiJ5Do4Aq7IBjU6kyxejQqkFOi?=
 =?us-ascii?Q?hCgmvQUmv+I3h0zo3nGg8VzbF4APboJ94fii9bPUJOvpUTt//3t0mXhIPpws?=
 =?us-ascii?Q?nzKIyuLPHUZxEtlPy7UUVFiyBVL4b3XXakKOVfJ00/G/5+vcyQFnTN/1tLon?=
 =?us-ascii?Q?YY3BAMeHY0rPdkMMVIlAxT+6Sx20kRZ/qKMJPM6HDS0xrIwREiC49QKnFQTC?=
 =?us-ascii?Q?pT9HCgOzyW4jm7ZHwhj50pAUK4VpVYI7k1HQbG9FRHWDOy621UH+KaoTFMvF?=
 =?us-ascii?Q?H5n20I8z2CeeLQf3UBlpZnyky+s3xb7JbkDMrJrCvHQ=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8991cb-8e91-47d7-cf26-08dafa040e98
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 10:00:55.7742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pwhdIpxHYPtLROWwjcy0nuF3BciO6gJlJ0dC8dM0fV2CT2Ns2enAFX/oE9doRKCS81YJIuZS7PO9VS6r/OA+lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7107
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 12:35:01PM -0800, Kees Cook wrote:
> Test names were being concatenated based on a offset beyond the end of
> the first name, which tripped the buffer overflow detection logic:
>=20
>  detected buffer overflow in strnlen
>  [...]
>  Call Trace:
>  bnxt_ethtool_init.cold+0x18/0x18
>=20
> Refactor struct hwrm_selftest_qlist_output to use an actual array,
> and adjust the concatenation to use snprintf() rather than a series of
> strncat() calls.
>=20
> Reported-by: Niklas Cassel <Niklas.Cassel@wdc.com>
> Link: https://lore.kernel.org/lkml/Y8F%2F1w1AZTvLglFX@x1-carbon/
> Tested-by: Niklas Cassel <Niklas.Cassel@wdc.com>
> Fixes: eb51365846bc ("bnxt_en: Add basic ethtool -t selftest support.")
> Cc: Michael Chan <michael.chan@broadcom.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 13 ++++---------
>  drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h     |  9 +--------
>  2 files changed, 5 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/=
net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index cbf17fcfb7ab..ec573127b707 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -3969,7 +3969,7 @@ void bnxt_ethtool_init(struct bnxt *bp)
>  		test_info->timeout =3D HWRM_CMD_TIMEOUT;
>  	for (i =3D 0; i < bp->num_tests; i++) {
>  		char *str =3D test_info->string[i];
> -		char *fw_str =3D resp->test0_name + i * 32;
> +		char *fw_str =3D resp->test_name[i];
> =20
>  		if (i =3D=3D BNXT_MACLPBK_TEST_IDX) {
>  			strcpy(str, "Mac loopback test (offline)");
> @@ -3980,14 +3980,9 @@ void bnxt_ethtool_init(struct bnxt *bp)
>  		} else if (i =3D=3D BNXT_IRQ_TEST_IDX) {
>  			strcpy(str, "Interrupt_test (offline)");
>  		} else {
> -			strscpy(str, fw_str, ETH_GSTRING_LEN);
> -			strncat(str, " test", ETH_GSTRING_LEN - strlen(str));
> -			if (test_info->offline_mask & (1 << i))
> -				strncat(str, " (offline)",
> -					ETH_GSTRING_LEN - strlen(str));
> -			else
> -				strncat(str, " (online)",
> -					ETH_GSTRING_LEN - strlen(str));
> +			snprintf(str, ETH_GSTRING_LEN, "%s test (%s)",
> +				 fw_str, test_info->offline_mask & (1 << i) ?
> +					"offline" : "online");
>  		}
>  	}
> =20
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_hsi.h
> index 2686a714a59f..a5408879e077 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
> @@ -10249,14 +10249,7 @@ struct hwrm_selftest_qlist_output {
>  	u8	unused_0;
>  	__le16	test_timeout;
>  	u8	unused_1[2];
> -	char	test0_name[32];
> -	char	test1_name[32];
> -	char	test2_name[32];
> -	char	test3_name[32];
> -	char	test4_name[32];
> -	char	test5_name[32];
> -	char	test6_name[32];
> -	char	test7_name[32];
> +	char	test_name[8][32];
>  	u8	eyescope_target_BER_support;
>  	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E8_SUPPORT=
ED  0x0UL
>  	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E9_SUPPORT=
ED  0x1UL
> --=20
> 2.34.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
