Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C4842509B
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 12:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240610AbhJGKC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 06:02:27 -0400
Received: from mail-dm6nam10on2081.outbound.protection.outlook.com ([40.107.93.81]:4512
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232699AbhJGKCW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 06:02:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JjnBRvtCbjsfikNdDXrbmPjYqvIXIZHx0L+N/tdZgpFuLnGL0lxLsgpAUgyObTouxuGntIPMqibhTxzdkXeyIDf89hdkpEzs/rlb/++iAli+GR8bo7MghJZKY9hFb2Mcfb3yUkcQeZ0WQt1Q0EB8+hjpyVMOu8R5Trj5FUgKyRnMOkpddWdnCHkWk3w5MobYCXh92Dc2gi6qRv0yQJWn9dLZjXnrOhqxLwuWnqgbF8ofDeX7uxkffY5a36wiGRoL6aoVoHZL3SXWvRXDzu4UVbfbkib7p11GPxWw3GoYzDHDMaa2M1j3Om+UejftCyvFyLRmRljrNwIIkv7OgHB6AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11WL8+YEQwxM1jcp9T1fZ6ifKd7bF/pv0niOZq0mKTE=;
 b=W9gqzF61XsnByUaxABrZgKhAToVo618sU+EYEkEyTK5v1W4ZswLb1GrHSGWaDY1nfwc8ql1O2KtqBMz1DYdmfMjHPqNGCg41B01LjpY9taei0IpFcr9vDA71kQjjqNm0XtLlP3y7iNgs7+HLGkLjFb7eSHUB/Caq/ERiSJjoqqFwvtjzkCxWUWTnQWtxtzsJHcWDuzfCHDhBuwGtp0jT8eAu8KfD0gBfKlmRxK1hyfIO52sNnJbVU/aMTeZ/V8TcV3qm2b4ElNUSztPKPBdEfFQyOj02LCnkiCM9gY4COuHBFb+dRh9cC1NL312fPPno5Ftxmog30cvZ4HiTxNG9Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11WL8+YEQwxM1jcp9T1fZ6ifKd7bF/pv0niOZq0mKTE=;
 b=HwfVTy7CYh2QvSSqXMaLXYA67DmJtEhlLjtcrOTwgbcVTEsiODDHy4U1psOrt8vjO6GtYJpiqtSK8pWQGBZivQJ9Qk5YvgEifgeMIDZtNU+VIjelOWg6+fKBSAJ3aUsVoldCALqND9EpQ9/6aS5o/qu0iIfgAbRKBeXJ6i2fiMc=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5595.namprd11.prod.outlook.com (2603:10b6:510:e5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 7 Oct
 2021 10:00:27 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4587.019; Thu, 7 Oct 2021
 10:00:26 +0000
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
Date:   Thu, 07 Oct 2021 12:00:18 +0200
Message-ID: <2672405.M38RcEoSet@pc-42>
Organization: Silicon Labs
In-Reply-To: <875yu9cjvk.fsf@codeaurora.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <3570035.Z1gqkuQO5x@pc-42> <875yu9cjvk.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR3P192CA0010.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::15) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PR3P192CA0010.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Thu, 7 Oct 2021 10:00:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab6b4bc9-6d76-4b14-9c91-08d989794964
X-MS-TrafficTypeDiagnostic: PH0PR11MB5595:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5595E414FDA8FACCCEDF96F293B19@PH0PR11MB5595.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ntGzNTQuNkUlsKDjlXI9CaJkUCIGvvFrr5UAudHTqvI+Ik+S0BIUNew9C5FySdRgBMOGgyT4LbylbINjDUGAoNTsJHdSq9/iFtcptv+0GL4AzQ0Ua9QD4LRmdZ1eAIsRDDcj8WbTJv6Q+rY5Copaoi6vVzxTKDTVo0DGeSBtJEjaF7fUeHOYhYxJadofqECJNKc0xpmzc33BHdSE/v8SH+mP77wo3cosHVSKXSJLD487wslSV+zw7X9zUpuW5lCfPgtabwPqaxwURQ2op46ye33/uB+qHyaQkZMXM7jK6WQUAxEPXyScAIqyiO0oRnCRbBveqYseWa8IzWTm9RWf0+O/t3lA41HnqrGrTJlHknUymB+wAjSuiNOajhdIUFaK9WrmoOMiDuqZipeaWO42SUNsGjyrbJ/U0X8iVBzlK60wS2qpBlATPaR/FJC7Di3CQPBtE1bPzT+xzhWxF0P1KcIBkFay3cf/C1hyNHFw8WInLgZSXCYN0BZ6fGkonX10NCenaRamQypdj/mTfWeQ1n1/0VsrV2ewe3Qr9j2PgCZdOpEBNqoVWhobTJ0BEQNGD62wEVNaCjEOGOIS8E7H68G9dxFfnAQAaU70LeTsADzuQDeRbVBZwfoUu+8rT0u9RSH4sH0n/h8fDTQ003AhHTukKUzHuIM3l27qf1y7WPT9xGMHsEINQRoFyq3yLknj/22F+2gCdpqOo3B+X1x5R7bjGSD5S+cMiDhfWXy74Aw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(508600001)(6512007)(86362001)(66476007)(26005)(6666004)(66574015)(83380400001)(2906002)(186003)(38350700002)(7416002)(5660300002)(38100700002)(8676002)(316002)(33716001)(6916009)(36916002)(6506007)(52116002)(66946007)(956004)(8936002)(66556008)(54906003)(4326008)(6486002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Sjs48w6p6mouJyhi6voHVn4UYHDK0MQdDOUgvUqS0SpNWHMLEWl70LIA6w?=
 =?iso-8859-1?Q?ejb+OqtKU+ZIF/n8R8rrPpimSqxMw9avvlbP5+fNe9vQYPRlHtHUX1e+ks?=
 =?iso-8859-1?Q?n4vYehtc+uL02fYjwhiQICiSlFnKZ7lop29x9qtzpjorWLPxvLQhtKT5zE?=
 =?iso-8859-1?Q?fIFztGRfsuwz6GS3HnX64h9sCUNTJ8X7BzQzyPWEf/DYWgMXf+pD8P6QAP?=
 =?iso-8859-1?Q?V0qHpddg62wEJjCzgbDwwHSIt24xoRvMvO8OAtvxBdiUqlNZvVPcIoURIq?=
 =?iso-8859-1?Q?kwI2azVrmWtry01+q+gO5fGKEKTe1PRcRe9tPoVtniK4aOIGWGcsktAUuK?=
 =?iso-8859-1?Q?lqzkvtF+tkAHYGkoQIa9G9+jydkJni6XcTSOxJjaaPbPN850e4plbr+Bbs?=
 =?iso-8859-1?Q?3s8gm/uIK4fED8mCSHyPk/n3Na5AxuKJGEmqIwjh2qlYbQsNh1PzfW/mbc?=
 =?iso-8859-1?Q?0ciEh+BtBCMqXvveuFyx9opi+Tf2Jk7QisNVsVRrs2q4fXc8AvBDkeMCTn?=
 =?iso-8859-1?Q?oRnp0bO1CNxvmFy6o5BAo7MCSNMP6Jwwf6iG1HfgNSpZWIsESgjlX9/f5z?=
 =?iso-8859-1?Q?1+rGo8xe5jqlwN4LM7fpyp5oGDB3kuWdFFq3Ryx7a4XdyJJVDFCOMKuGAV?=
 =?iso-8859-1?Q?FmQKamUNIp+ReyBrp4HpWsNLeauSU3A2YBSiPteYctuFHlLbDGHnYYm9tJ?=
 =?iso-8859-1?Q?TRILIFbHnmWK3rxri0HgM2cnnV73PxW8oUEs6WnNp8ikSlKCyEOGJi8flD?=
 =?iso-8859-1?Q?6oMgHeds+X9X9E9popClGSTIG+MEOt00sMmLfqwndzMfN2G3No68R0MrRq?=
 =?iso-8859-1?Q?OGrdlXwaDQd7jsIspaJt1F/7tn1P+oPKcXNqG1NUmsrtg6xUlFfmTCvjkg?=
 =?iso-8859-1?Q?t/Gzi25HFmvIQWAO/tszaI994EFvntEoV0dO0gtm49hhCErpNl/YVGTGRY?=
 =?iso-8859-1?Q?oPq/av4MH8ny92pPeGC5DmkbaNXGqfVkv55prt77CvcXZBRj+1YZsvnbaE?=
 =?iso-8859-1?Q?js+G+IpulRoYyl1kA0IMZhxsjf7PsHeZsrdDWipObaXpDVr6UPV0Fx6nuX?=
 =?iso-8859-1?Q?48N18FUo0hT06e1B7ZBHfsN8equA9pcIhTMXOtnnE/TUclCYYRJbBWsQAX?=
 =?iso-8859-1?Q?jKNdbvNn1PQwhKNprgkFBng8zZQCXMXBo+5FjTcS1o117JnOBw3x+ohKvX?=
 =?iso-8859-1?Q?PaBHzMuS6TSt6QHJTwdvZ9zvNQ8p+YGajLUjnxewJ8vBFbzN1vSXkTJH7O?=
 =?iso-8859-1?Q?M/CJomqKW+uwkuuTYoixer5QodAQ6oUFcwjpkluj6RQFMQuhSPFJJyuNcr?=
 =?iso-8859-1?Q?pQI7W92C1Wq3nLGKcjPjut3TeYMpUGQSXrMRHGQ0a2wz1bnj3ZWHKYz4eO?=
 =?iso-8859-1?Q?ON1tCakNon?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab6b4bc9-6d76-4b14-9c91-08d989794964
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 10:00:26.6448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YplJluwlq/KTWSR4jfK6HvQQbEVyBpubmUn3wvMimHZTfzu/gkNR0dWis+4tnWxYEw/jSFhf26Sl0SrMnfhf3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5595
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 7 October 2021 10:35:43 CEST Kalle Valo wrote:
> J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
> > On Friday 1 October 2021 14:18:04 CEST Kalle Valo wrote:
> >> J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
> >> > On Friday 1 October 2021 11:22:08 CEST Kalle Valo wrote:
> >> >> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> >> >>
> >> >> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >> >> >
> >> >> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >> >>
> >> >> [...]
> >> >>
> >> >> > +/* The device needs data about the antenna configuration. This i=
nformation in
> >> >> > + * provided by PDS (Platform Data Set, this is the wording used =
in WF200
> >> >> > + * documentation) files. For hardware integrators, the full proc=
ess to create
> >> >> > + * PDS files is described here:
> >> >> > + *   https:github.com/SiliconLabs/wfx-firmware/blob/master/PDS/R=
EADME.md
> >> >> > + *
> >> >> > + * So this function aims to send PDS to the device. However, the=
 PDS file is
> >> >> > + * often bigger than Rx buffers of the chip, so it has to be sen=
t in multiple
> >> >> > + * parts.
> >> >> > + *
> >> >> > + * In add, the PDS data cannot be split anywhere. The PDS files =
contains tree
> >> >> > + * structures. Braces are used to enter/leave a level of the tre=
e (in a JSON
> >> >> > + * fashion). PDS files can only been split between root nodes.
> >> >> > + */
> >> >> > +int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t len)
> >> >> > +{
> >> >> > +     int ret;
> >> >> > +     int start, brace_level, i;
> >> >> > +
> >> >> > +     start =3D 0;
> >> >> > +     brace_level =3D 0;
> >> >> > +     if (buf[0] !=3D '{') {
> >> >> > + dev_err(wdev->dev, "valid PDS start with '{'. Did you forget to
> >> >> > compress it?\n");
> >> >> > +             return -EINVAL;
> >> >> > +     }
> >> >> > +     for (i =3D 1; i < len - 1; i++) {
> >> >> > +             if (buf[i] =3D=3D '{')
> >> >> > +                     brace_level++;
> >> >> > +             if (buf[i] =3D=3D '}')
> >> >> > +                     brace_level--;
> >> >> > +             if (buf[i] =3D=3D '}' && !brace_level) {
> >> >> > +                     i++;
> >> >> > +                     if (i - start + 1 > WFX_PDS_MAX_SIZE)
> >> >> > +                             return -EFBIG;
> >> >> > +                     buf[start] =3D '{';
> >> >> > +                     buf[i] =3D 0;
> >> >> > +                     dev_dbg(wdev->dev, "send PDS '%s}'\n", buf =
+ start);
> >> >> > +                     buf[i] =3D '}';
> >> >> > +                     ret =3D hif_configuration(wdev, buf + start=
,
> >> >> > +                                             i - start + 1);
> >> >> > +                     if (ret > 0) {
> >> >> > + dev_err(wdev->dev, "PDS bytes %d to %d: invalid data (unsupport=
ed
> >> >> > options?)\n",
> >> >> > +                                     start, i);
> >> >> > +                             return -EINVAL;
> >> >> > +                     }
> >> >> > +                     if (ret =3D=3D -ETIMEDOUT) {
> >> >> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip didn't reply (corr=
upted
> >> >> > file?)\n",
> >> >> > +                                     start, i);
> >> >> > +                             return ret;
> >> >> > +                     }
> >> >> > +                     if (ret) {
> >> >> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip returned an unknow=
n
> >> >> > error\n",
> >> >> > +                                     start, i);
> >> >> > +                             return -EIO;
> >> >> > +                     }
> >> >> > +                     buf[i] =3D ',';
> >> >> > +                     start =3D i;
> >> >> > +             }
> >> >> > +     }
> >> >> > +     return 0;
> >> >> > +}
> >> >>
> >> >> I'm not really fond of having this kind of ASCII based parser in th=
e
> >> >> kernel. Do you have an example compressed file somewhere?
> >> >
> >> > An example of uncompressed configuration file can be found here[1]. =
Once
> >> > compressed with [2], you get:
> >> >
> >> >     {a:{a:4,b:1},b:{a:{a:4,b:0,c:0,d:0,e:A},b:{a:4,b:0,c:0,d:0,e:B},=
c:{a:4,b:0,c:0,d:0,e:C},d:{a:4,b:0,c:0,d:0,e:D},e:{a:4,b:0,c:0,d:0,e:E},f:{=
a:4,b:0,c:0,d:0,e:F},g:{a:4,b:0,c:0,d:0,e:G},h:{a:4,b:0,c:0,d:0,e:H},i:{a:4=
,b:0,c:0,d:0,e:I},j:{a:4,b:0,c:0,d:0,e:J},k:{a:4,b:0,c:0,d:0,e:K},l:{a:4,b:=
0,c:0,d:1,e:L},m:{a:4,b:0,c:0,d:1,e:M}},c:{a:{a:4},b:{a:6},c:{a:6,c:0},d:{a=
:6},e:{a:6},f:{a:6}},e:{b:0,c:1},h:{e:0,a:50,b:0,d:0,c:[{a:1,b:[0,0,0,0,0,0=
]},{a:2,b:[0,0,0,0,0,0]},{a:[3,9],b:[0,0,0,0,0,0]},{a:A,b:[0,0,0,0,0,0]},{a=
:B,b:[0,0,0,0,0,0]},{a:[C,D],b:[0,0,0,0,0,0]},{a:E,b:[0,0,0,0,0,0]}]},j:{a:=
0,b:0}}
> >>
> >> So what's the grand idea with this braces format? I'm not getting it.
> >
> >   - It allows to describe a tree structure
> >   - It is ascii (easy to dump, easy to copy-paste)
> >   - It is small (as I explain below, size matters)
> >   - Since it is similar to JSON, the structure is obvious to many peopl=
e
> >
> > Anyway, I am not the author of that and I have to deal with it.
>=20
> I'm a supported for JSON like formats, flexibility and all that. But
> they belong to user space, not kernel.
>=20
> >> Usually the drivers just consider this kind of firmware configuration
> >> data as a binary blob and dump it to the firmware, without knowing wha=
t
> >> the data contains. Can't you do the same?
> >
> > [I didn't had received this mail :( ]
> >
> > The idea was also to send it as a binary blob. However, the firmware us=
e
> > a limited buffer (1500 bytes) to parse it. In most of case the PDS exce=
eds
> > this size. So, we have to split the PDS before to send it.
> >
> > Unfortunately, we can't split it anywhere. The PDS is a tree structure =
and
> > the firmware expects to receive a well formatted tree.
> >
> > So, the easiest way to send it to the firmware is to split the tree
> > between each root nodes and send each subtree separately (see also the
> > comment above wfx_send_pds()).
> >
> > Anyway, someone has to cook this configuration before to send it to the
> > firmware. This could be done by a script outside of the kernel. Then we
> > could change the input format to simplify a bit the processing in the
> > kernel.
>=20
> I think a binary file with TLV format would be much better, but I'm sure
> there also other good choises.
>=20
> > However, the driver has already some users and I worry that changing
> > the input format would lead to a mess.
>=20
> You can implement a script which converts the old format to the new
> format. And you can use different naming scheme in the new format so
> that we don't accidentally load the old format. And even better if you
> add a some kind of signature in the new format and give a proper error
> from the driver if it doesn't match.

Ok. I am going to change the input format. I think the new function is
going to look like:

int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t buf_len)
{
	int ret;
	int start =3D 0;

	if (buf[start] !=3D '{') {
		dev_err(wdev->dev, "valid PDS start with '{'. Did you forget to compress =
it?\n");
		return -EINVAL;
	}
	while (start < buf_len) {
		len =3D strnlen(buf + start, buf_len - start);
		if (len > WFX_PDS_MAX_SIZE) {
			dev_err(wdev->dev, "PDS chunk is too big (legacy format?)\n");
			return -EINVAL;
		}
		dev_dbg(wdev->dev, "send PDS '%s'\n", buf + start);
		ret =3D wfx_hif_configuration(wdev, buf + start, len);
		/* FIXME: Add error handling here */
		start +=3D len;
	}
	return 0;
}

--=20
J=E9r=F4me Pouiller


