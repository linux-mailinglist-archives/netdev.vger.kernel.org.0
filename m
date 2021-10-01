Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DEF41E9FD
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 11:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353180AbhJAJqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 05:46:12 -0400
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:24672
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352947AbhJAJqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 05:46:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHAsDsIUEvL0MI56CgjPrUJ4lPmLT3zW8JIiM2ooW4/571e2jci9WAVAzcpBGRDk7i7k1d6Yquo+vQOipWTqoX1gUWOZ0oceSCgCJjMzpVhwrcB1ivUvI2q/nhne43KVtzpNYuGp8G3qnhKqG/rtS9xiP/09WtypdsmU29CG7GvwvdhW6ksnB/hRLXhvk2JBwqgAWvGswMwvQn5LbDXlNevDomtZuKrhCMZqK/MWszfRu2VZFiZzOb5uKdbCNDYzhT+rSp0Xai6vJosNHL1oXdB23wjkuq2pU4OuU5ilZRFBQM7uJaiRgoOKLxZKhZ7xfvy8McrORyKPHcxvJRsn4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5iDsuN2tDbU0jGG+21A9YWZIq2CkKxMBl4KD6/+wTRg=;
 b=FCmmEOFyFdm/iGdZAXmN9F9LEq2Q+V1Vae7gX/IYQgzMTgmeNZF1e4qWj6DRvePTfO2SJ/p9qIHeJqUZKgqqGw97IamCrS3ntoI11jmrT2wVeGQJTWCIHW8O2TAU4L/wIUK7nTEzCTMlTqf0peb3J7k/sOXZDZaWhtgKX6a+3mOm7otwIYamDo/U/mN2hSfo1G2lRu2T/vbXBxOPBw5rcaYrCjl5wXyG1Y84cYG93Y1cX8ggt2YW8/mnanrpkBsWNSSOjcsIG0d6VvSg3+02yEL1tZ8hESD2XUZp+CpGufQUjAdd4STUmlFVko3szQjV6WTlOAe14Yh65yA0EvH83w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5iDsuN2tDbU0jGG+21A9YWZIq2CkKxMBl4KD6/+wTRg=;
 b=Yn4WCGjWSZ42QfK//SMEyKJ0VhKmQJBcJjxTou7tX6E2TFxTksa+oWAxveE33oUtRZwjJCZKo4cnDkPjU92IvbtrQNaza+J7oBj5W2g9hszYbzlD14k649kFMXTxu3BNH4Lc+5DYl1zjI6OIhSISOF7V33+xEayaB6aM3Z+iBgc=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5676.namprd11.prod.outlook.com (2603:10b6:510:ea::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Fri, 1 Oct
 2021 09:44:25 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 09:44:25 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 05/24] wfx: add main.c/main.h
Date:   Fri, 01 Oct 2021 11:44:17 +0200
Message-ID: <2723787.uDASXpoAWK@pc-42>
Organization: Silicon Labs
In-Reply-To: <87y27dkslb.fsf@codeaurora.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <20210920161136.2398632-6-Jerome.Pouiller@silabs.com> <87y27dkslb.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PAZP264CA0070.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::13) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PAZP264CA0070.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19 via Frontend Transport; Fri, 1 Oct 2021 09:44:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: feddbc41-e046-4d54-c4a8-08d984c00ded
X-MS-TrafficTypeDiagnostic: PH0PR11MB5676:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5676FDA385DAA3113147B05293AB9@PH0PR11MB5676.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HlbFQZ8WMzJ/8yK7uPFtZk2GDo+SdOB6AU1r9aId5DFdMRJJ654eUEq02H4beHkvZ9lWc+Af86QhaKWIzWZNN4GkrWv12yzkJiJQmFjeVV/o/LrbLkGn3GvQbb/hFO+mR54CoLPBP/HAOxJRHW8WS18UA8Mm9c48YCd6ZupxHkBLZSimEIsE6n2Cfn9jqblGz6WDVeWtiRx4hUPc4xZQdtStmCJ8x7F2xqowJG4n+Qy2P9MG6ZxlHoC5tassLUVpsUS1EVLj2XTRiMV1Jki+yNE6Jx43Fs416MzeA5idvomC6CTdda8T4hF9CW6v1hnBaXKwWvaK/fbNtPJ2yPBeshSijEm+v0trcycP6W4+CLRPARYBQP+B+fZwlLMSilZ9uj8JIjn/fjWXXXQG7xqBeGZFowuYoeGaPaFyL/Y3DQCehEm62lIADaI4CMOiYN03ZHOsmHHvAesvNen3NlAIvQ/S3kkYkqAQXwXCvTU295sWROvk4R3YiKYhBzgbnhEiIVKFbgaWZJlhWpuFrhncsI2pbW4s8ZHziyIE5dGA0go1Yplnp8eACCOarefg5VXhSwblrnltgCE1Xs+WX18Yd7lI3s41uoeK5XZRAQfN2mVFMY6rs8YoSxw9Y/lxzUd28M7AujlQUIPSpMzs5p+kcNPGo9NrFYzEzktErh1MfHIWA1woMlkGsvLWnb6TTtYO3ZF31q0w4CKi08ur7mhYDsAdrtBYK9Y+nHO6nJUNzvtCb+CmV06g6ZhLyXHNjnn41v42MB4e7axUknAg+NtYof869XB5cUm3IF1O0/kbjweOYsoSMlssb0Zvcx4DeAhHN7s4wmPJAGm54mW68DpXzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(66946007)(33716001)(86362001)(508600001)(2906002)(8676002)(316002)(8936002)(6486002)(966005)(66476007)(54906003)(7416002)(956004)(66556008)(186003)(6506007)(6666004)(6916009)(4326008)(5660300002)(36916002)(38350700002)(52116002)(66574015)(6512007)(9686003)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?N7++VQnNlUsB7PQRWG12eEI85sGOTyvEPcCGBzsZptLza8EjFP1yMycRxq?=
 =?iso-8859-1?Q?Zw5Ua3mUDZJF8gRs4ZkaKTl4v4Te0BkemKN2cv6cNzvCepEs11lY0M3SRY?=
 =?iso-8859-1?Q?jdzBonTWs4PpGeaPAKtE/yd+OHNjQ162KWmurzp6vfkudYnAfbu4QuUyZ+?=
 =?iso-8859-1?Q?hpdMwsjLpPKimcDz7UIlNCsRa+jcg6KVWPK6tVYupsoPRw/AF2ZFGutjlm?=
 =?iso-8859-1?Q?YAaas+GZs/hriFgSjCFkZFmFuzEznXG5bOwylCARZgMmBvoTWAueYEqVOQ?=
 =?iso-8859-1?Q?nTH8CysmH5NYZ6TfJi5moM8UotOq2Qq6CD8LLWFpGFOySiMCEBgd6MXIQ9?=
 =?iso-8859-1?Q?WPc0HxSjK1pOqvlZ1ay3unnVcKrjBKPeB8qxK+y3KESvfrXTVNaxtn8NJy?=
 =?iso-8859-1?Q?jLz2cZsnadVHuS7mYD6FApXi/t9ngywFR3WFhvVrctlBYJuZSbMt3ntnr4?=
 =?iso-8859-1?Q?2UxynlfFXNWKFrSCjkqX+8tyVB6Q95m2Qlxee7XzQnJMvkuWhEpdccZHDe?=
 =?iso-8859-1?Q?Ze+vazccbauaSQMRUBFFQaAJ87+zt2iJ/Y6aFtqkbvdmo+n7Y6h5XgEWrX?=
 =?iso-8859-1?Q?lGvNJUVC9C+3oi4QoVG6ogc8PPM4Uqx6EdNsSD5zppTXStokk4d+UlbtEy?=
 =?iso-8859-1?Q?xlNvYTTsrmOWnai/ICW0HAtfLG6I8308rvsAIs2AQySNKtllv8Pl+S9tGP?=
 =?iso-8859-1?Q?UgFS59/m0lWbQ7hdhe0RRgDmemgewfWxS13dLqp9NRD5SUJMrLd0JdAUHP?=
 =?iso-8859-1?Q?wn43S1ohHxpPkcyYsTVMz6YGzMnLWDeP8booan2Q6qcTTq46Kt0FfBy78e?=
 =?iso-8859-1?Q?3BhdugRZ77m2R7wTVZO6JSxMODvtG7ICGK3kWSrqM2odg7iyGkaBESxuVl?=
 =?iso-8859-1?Q?ut0u3u6xwTlCGjb8ZoZRRRljVn3CeVKrVVfVpflxcio7Om4+8p9q88tTJe?=
 =?iso-8859-1?Q?iIRvht0AB5OeuZlKMwLtUtOfpS/7BiNTDlM4ZWsXMooayJ7QWd9h7BiXiS?=
 =?iso-8859-1?Q?OxWuhYLB/hcrWpGTnBPo5LfDg7WyqEpUilo/nw/Tsx44YzZKj71DJsZZAK?=
 =?iso-8859-1?Q?RUasON9+hRwUlqXBHs0mTFLSl1GiiX/K4qfmswDOB8Y1yL7fZWOWgkH1KN?=
 =?iso-8859-1?Q?2vg+mRho6IEu/4KLuUbouFHQPkPjYeZ00wYb3JgGGKqd9cHdVCzH7GmOlI?=
 =?iso-8859-1?Q?s0m4MetdQeFmOrCZ4R+q5HNP6sWsI3fMGlkSRAWMeDp1kZKL1Iwxpk/oIo?=
 =?iso-8859-1?Q?B5Wl6I5ZFbzvgokxIIBK+L698EuA1cPAOqBdProJa0xvO61ada8tifold+?=
 =?iso-8859-1?Q?n5Kviy7jJoY3FNRSwKMRFcIak8Jw9dpXhE4eAQGLLq3vbTg9OUrj0HEKCa?=
 =?iso-8859-1?Q?V+UxUoWiMG?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feddbc41-e046-4d54-c4a8-08d984c00ded
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 09:44:25.3880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Bj2LFeh2rQ2oZ+zAsful4aoD1IntmRcUWMZriHTy+dVV5ZziwnQuKAxb0nkPitXozJ9SXJgDUY1qBqc0Io+6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5676
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 1 October 2021 11:22:08 CEST Kalle Valo wrote:
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
>=20
> [...]
>=20
> > +/* The device needs data about the antenna configuration. This informa=
tion in
> > + * provided by PDS (Platform Data Set, this is the wording used in WF2=
00
> > + * documentation) files. For hardware integrators, the full process to=
 create
> > + * PDS files is described here:
> > + *   https:github.com/SiliconLabs/wfx-firmware/blob/master/PDS/README.=
md
> > + *
> > + * So this function aims to send PDS to the device. However, the PDS f=
ile is
> > + * often bigger than Rx buffers of the chip, so it has to be sent in m=
ultiple
> > + * parts.
> > + *
> > + * In add, the PDS data cannot be split anywhere. The PDS files contai=
ns tree
> > + * structures. Braces are used to enter/leave a level of the tree (in =
a JSON
> > + * fashion). PDS files can only been split between root nodes.
> > + */
> > +int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t len)
> > +{
> > +     int ret;
> > +     int start, brace_level, i;
> > +
> > +     start =3D 0;
> > +     brace_level =3D 0;
> > +     if (buf[0] !=3D '{') {
> > + dev_err(wdev->dev, "valid PDS start with '{'. Did you forget to
> > compress it?\n");
> > +             return -EINVAL;
> > +     }
> > +     for (i =3D 1; i < len - 1; i++) {
> > +             if (buf[i] =3D=3D '{')
> > +                     brace_level++;
> > +             if (buf[i] =3D=3D '}')
> > +                     brace_level--;
> > +             if (buf[i] =3D=3D '}' && !brace_level) {
> > +                     i++;
> > +                     if (i - start + 1 > WFX_PDS_MAX_SIZE)
> > +                             return -EFBIG;
> > +                     buf[start] =3D '{';
> > +                     buf[i] =3D 0;
> > +                     dev_dbg(wdev->dev, "send PDS '%s}'\n", buf + star=
t);
> > +                     buf[i] =3D '}';
> > +                     ret =3D hif_configuration(wdev, buf + start,
> > +                                             i - start + 1);
> > +                     if (ret > 0) {
> > + dev_err(wdev->dev, "PDS bytes %d to %d: invalid data (unsupported
> > options?)\n",
> > +                                     start, i);
> > +                             return -EINVAL;
> > +                     }
> > +                     if (ret =3D=3D -ETIMEDOUT) {
> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip didn't reply (corrupted
> > file?)\n",
> > +                                     start, i);
> > +                             return ret;
> > +                     }
> > +                     if (ret) {
> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip returned an unknown
> > error\n",
> > +                                     start, i);
> > +                             return -EIO;
> > +                     }
> > +                     buf[i] =3D ',';
> > +                     start =3D i;
> > +             }
> > +     }
> > +     return 0;
> > +}
>=20
> I'm not really fond of having this kind of ASCII based parser in the
> kernel. Do you have an example compressed file somewhere?

An example of uncompressed configuration file can be found here[1]. Once
compressed with [2], you get:

    {a:{a:4,b:1},b:{a:{a:4,b:0,c:0,d:0,e:A},b:{a:4,b:0,c:0,d:0,e:B},c:{a:4,=
b:0,c:0,d:0,e:C},d:{a:4,b:0,c:0,d:0,e:D},e:{a:4,b:0,c:0,d:0,e:E},f:{a:4,b:0=
,c:0,d:0,e:F},g:{a:4,b:0,c:0,d:0,e:G},h:{a:4,b:0,c:0,d:0,e:H},i:{a:4,b:0,c:=
0,d:0,e:I},j:{a:4,b:0,c:0,d:0,e:J},k:{a:4,b:0,c:0,d:0,e:K},l:{a:4,b:0,c:0,d=
:1,e:L},m:{a:4,b:0,c:0,d:1,e:M}},c:{a:{a:4},b:{a:6},c:{a:6,c:0},d:{a:6},e:{=
a:6},f:{a:6}},e:{b:0,c:1},h:{e:0,a:50,b:0,d:0,c:[{a:1,b:[0,0,0,0,0,0]},{a:2=
,b:[0,0,0,0,0,0]},{a:[3,9],b:[0,0,0,0,0,0]},{a:A,b:[0,0,0,0,0,0]},{a:B,b:[0=
,0,0,0,0,0]},{a:[C,D],b:[0,0,0,0,0,0]},{a:E,b:[0,0,0,0,0,0]}]},j:{a:0,b:0}}


[1]: https://github.com/SiliconLabs/wfx-pds/blob/API4.1/BRD4001A_Rev_A01.pd=
s.in
[2]: https://github.com/SiliconLabs/wfx-linux-tools/blob/SD4/pds_compress

> Does the device still work without these PDS files? I ask because my
> suggestion is to remove this part altogether and revisit after the
> initial driver is moved to drivers/net/wireless. A lot simpler to review
> complex features separately.

I think we will be able to communicate with the chip. However, the chip won=
't
have any antenna parameters. Thus, I think the RF won't work properly.


--=20
J=E9r=F4me Pouiller


