Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936754238F2
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbhJFHey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 03:34:54 -0400
Received: from mail-dm6nam10on2054.outbound.protection.outlook.com ([40.107.93.54]:26081
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237448AbhJFHew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 03:34:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRxRZ0dwyrh8/ZegOB9z3iZ23BsmB921g5fcF6N3Fc/GjyiWGyTyEpgD48GTy8+uJLlbegBvueXLe8ApqfHQmZrUGsDywJF0I3gUZTWtDnjTKh025QIIp9sSp2wN3MKMMZxsUylD0EIpLiHPUwIBR7hPZiCLeOCthWD/XiV1KYBwdZYTC6CUGmuNQ64LKbx9iDMzrwUp5U1C2XRG7xGoiWxsDVhp6O5v4GSrKC7zRuPKDNGaKlCQOdgQSi3W3vT2ST8c+svxW03KmoSKtUWYqDg0BJX7x4CsWOtrJi34umAQkjrOJ6rN9Yoi7Bs7uIPYSA6m70L26T5OwxWg7e4XEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CI3EkQPeflAF0v+8HIzRDHbCAyDTsxANKsxloD1B9tk=;
 b=MUoNhc9GVu35JPYUyZcfKv1+Fb/w86m7RuPr/iYQPSANmS4GUFsgLIpNQsra8AKSDoEsNjXMWO3Oteo1yws0LTvhAqGQbMFVeKBYMoWP9a+DJnL9atk1wbA3Ra0H9n/uxSvbwjfMkyTXnWcKGUMjBnrBA+OXcSGMJNq33GZGFOvSgfpfsCvFcUXnkhEr8Di4slonNyHk6Em2oLBhWObJVarQUI+8iZsqG0qqhdtCSKdEmyziTzKWWEs+nxHwS1qE2QlwlEu8B5lYfpmIBMi4H42m9HWjjzXexwRNi1fstgaeKRXEnG2Dw0emfOj+0DrkgP0heEMl2Rw7pgDv8jfrKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CI3EkQPeflAF0v+8HIzRDHbCAyDTsxANKsxloD1B9tk=;
 b=C0F96TsLnUUK1mI0MVa/dwWnGA3oyyffJy0CZ8ZG/+dd6RuaeNiI+NwURlDptkKZWSYOBd0PHVVz7g9craUJarx4J4j4qmRUq5bwyCpj7o9bCxYou6J2x5DDxRH/8n7NxiAYBK+OJJDYmxhJePhbbAFJZzyfjvPenOEwzQL7AVw=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Wed, 6 Oct
 2021 07:32:58 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.023; Wed, 6 Oct 2021
 07:32:58 +0000
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
Date:   Wed, 06 Oct 2021 09:32:49 +0200
Message-ID: <3570035.Z1gqkuQO5x@pc-42>
Organization: Silicon Labs
In-Reply-To: <87k0ixj5vn.fsf@codeaurora.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <2723787.uDASXpoAWK@pc-42> <87k0ixj5vn.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR3P189CA0031.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::6) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PR3P189CA0031.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 6 Oct 2021 07:32:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 540fd5ac-e407-442f-5ad9-08d9889b84cf
X-MS-TrafficTypeDiagnostic: PH0PR11MB5580:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5580E54D8F7D0FBC6D46CBE493B09@PH0PR11MB5580.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XHaxFnxC0VYcyNfilhw8osTedQp2tTjPObPrXg2P9kE2TJQdxX/oYaWQzfN7nceJJc/Dqv5HBEx6V0qSDFZNOitPp3Hpo4Gd2WvrWoFfuw8SPCX2y3i76BkvVedNLiEBqG7ez46R7P6HxSvxGxIIh0TEg51XwKERKVU75+nDxGh1gsEmWzz4QrDJQyx1eRMcWJdB6lYiCR+2SyUkSj3a1bzq4JIRin7BTr02Ec5kc0eT+TjcAYnszPyLzaWTA82oQ68QFCl9wYXJ0c950KLLGib2WHl6kWoL/b4GYX00dx4wUvnHfiwy7zK6QZoOo9tWgk8n4GaaZ/7emmSkJlumltEPG52TO2iVWmcoUtGOjXl3wllrpEpF7t+ypZw2pAWfQcYIfU3cWAosRd8EhFMWX24jhSwSE3MyV1tHtPjyqNJ85yk7XhuvaTDEMr6C83jX8GhSbNhy+oUQEWA65EbPAixZAvzIDpVSGPErHBXEY4b4Q7zyLOzvQVXL6aKU2krP27QW3zuJ7Z4eMqdsoog+5vLxu+MRQLOJDfSdiZ1dvReqk65YWNVGw1axP88pLQ75TG5DiK8WPnZEOOFqitXAt6kw+NwU7MyTojNAPcQSxnzf4lrXCqz6FfD8imnGuhifiC9kxUE4lqi9zXkRkEPncMWP4uWPSlEq7JT+EpNOsqb0XZho/EQ8Ak70/VTTsVsrnhe18c9Xoyffsxs27CTMItuA9ejXFW/93Evo0RsF/tM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(186003)(36916002)(38100700002)(2906002)(7416002)(316002)(26005)(38350700002)(956004)(66556008)(66476007)(54906003)(8676002)(66946007)(52116002)(33716001)(6512007)(6666004)(6916009)(6506007)(9686003)(86362001)(4326008)(508600001)(83380400001)(66574015)(5660300002)(8936002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?y+vgkbNMKFALkqOn2Kv0C1i5dDSlO1i1bCkblVuPTivTzygrvT0FGjbF5/?=
 =?iso-8859-1?Q?lyVn0fGBro2YE9ew4RmFobo0UQib21w8xlXf7EoqaCbsyK5KDlVaN2Bb1l?=
 =?iso-8859-1?Q?qNjPtOk2i921Q+oEU8aiSi7bFL55CgtynTeApsAPzcT0PewkNom5FmZDnV?=
 =?iso-8859-1?Q?oYfny4ltA2jdsnYAS8hYNT1L39bgSOwwevGUwvp/rJhQBimgoz51i8dJOj?=
 =?iso-8859-1?Q?EBJM2WdymCD1gtsPjHO1BrIeNAaW2J1KHWqUqW+oMGv0fSTJF0Vsvh90CT?=
 =?iso-8859-1?Q?/OeprBi5LLaHG9qL3b3px/HXmlMW9C1CGCHioi9m4sSSPm3QBjjEcrOnzs?=
 =?iso-8859-1?Q?udtBg2C62J6d8wwUuLmhRmr5yK5bvrgffnk8ht/ISTPQMI8UxK9RPv2Ut+?=
 =?iso-8859-1?Q?LJbMUKss973/sv3J2kpJPp8hZ/wNrHAlpU+3QOlzsbYTqcKsmUZOu9A7m4?=
 =?iso-8859-1?Q?qWV+JwoicQZ0zk4cEHpkwRKU7dZ8zJ3DVdDgB1CVFcpNYPQDdax5JqH/Lx?=
 =?iso-8859-1?Q?wi1mnOCuQXCpmEejOuRFA5rBN+quE85uX62143HatJ2EG7TmVteQTjmvvq?=
 =?iso-8859-1?Q?c7tAhcwfxi0/5y3sa108V85oWHVUq1SIXq/6PQBNljx8LMoKRlcNxqSAfP?=
 =?iso-8859-1?Q?DSe8bvvuZdHzcvjeta/iBFDLvQptTVh1bi+dgANeK8RrOgn8kOojPJ7suk?=
 =?iso-8859-1?Q?HEYXPvOZnM3svurYJuMRSGhpGMyAJzS6BKia5dA1fK6HDumX4pgqxz3EDe?=
 =?iso-8859-1?Q?PsvoLhGQ6FrUqVt24iyzHNjRwEcOAUElyYUT+MG2x0TGT54zHmgzb+uln8?=
 =?iso-8859-1?Q?tSW4sZEHMFQSJB9tTRlvHniAeFzXnlnyVjNVk8RA8g+gi7cCMHAo6ZWdTP?=
 =?iso-8859-1?Q?ftdKiebePikn46LX9oZQ4IoWqk/sMoZjgXNUxWaAlgcxQqvxyUgZusl1XI?=
 =?iso-8859-1?Q?f1bbNKrZzANXa5UGqnzJN8L6TrqxruqYkyVfEqBq75xntqPhUMVmd6jyLi?=
 =?iso-8859-1?Q?93MRJLwIXddgKUZx/YLl55IJuXggCgY814/NLHiyKMVmGqkMj3avpaFtKu?=
 =?iso-8859-1?Q?G2kYLJQXSCBWncTXPzSz26Nc0rxTH+1G3XNxlfHsrtYdM5hRWRoKTyRHjX?=
 =?iso-8859-1?Q?mk6ONnfUS9EBbVo/u7iMSpbltu5aCjABgQud6hngEV6uEm2skXSvFO52eG?=
 =?iso-8859-1?Q?LFHMupZiyP4WpArg7cOEdXhtz8KBnjLyCRi+O3wB+BMCIT4NttMDT+7sNd?=
 =?iso-8859-1?Q?28eL+xvjehWOgMGGF0Kn+oLJaa9rdZT2Xtots44/71FXdDrTpp9EipZrqD?=
 =?iso-8859-1?Q?yYK/WN1IlmzJ1nxnmsHrI2rvIXkFxcTG2lHbJBvInQuDaIfkivCsrBlgUs?=
 =?iso-8859-1?Q?ypP/TrecU2?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 540fd5ac-e407-442f-5ad9-08d9889b84cf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 07:32:58.2152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KqGG3eY+QNHkMoy98/bny2IcXRYo+hrGCjBemu88iqEY/I3RnJLbGQ4pBPuzcD+05wK9ZV16oHFpWeUqBfAYwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5580
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On Friday 1 October 2021 14:18:04 CEST Kalle Valo wrote:
> J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
>=20
> > On Friday 1 October 2021 11:22:08 CEST Kalle Valo wrote:
> >> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> >>=20
> >> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >> >
> >> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >>=20
> >> [...]
> >>=20
> >> > +/* The device needs data about the antenna configuration. This info=
rmation in
> >> > + * provided by PDS (Platform Data Set, this is the wording used in =
WF200
> >> > + * documentation) files. For hardware integrators, the full process=
 to create
> >> > + * PDS files is described here:
> >> > + *   https:github.com/SiliconLabs/wfx-firmware/blob/master/PDS/READ=
ME.md
> >> > + *
> >> > + * So this function aims to send PDS to the device. However, the PD=
S file is
> >> > + * often bigger than Rx buffers of the chip, so it has to be sent i=
n multiple
> >> > + * parts.
> >> > + *
> >> > + * In add, the PDS data cannot be split anywhere. The PDS files con=
tains tree
> >> > + * structures. Braces are used to enter/leave a level of the tree (=
in a JSON
> >> > + * fashion). PDS files can only been split between root nodes.
> >> > + */
> >> > +int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t len)
> >> > +{
> >> > +     int ret;
> >> > +     int start, brace_level, i;
> >> > +
> >> > +     start =3D 0;
> >> > +     brace_level =3D 0;
> >> > +     if (buf[0] !=3D '{') {
> >> > + dev_err(wdev->dev, "valid PDS start with '{'. Did you forget to
> >> > compress it?\n");
> >> > +             return -EINVAL;
> >> > +     }
> >> > +     for (i =3D 1; i < len - 1; i++) {
> >> > +             if (buf[i] =3D=3D '{')
> >> > +                     brace_level++;
> >> > +             if (buf[i] =3D=3D '}')
> >> > +                     brace_level--;
> >> > +             if (buf[i] =3D=3D '}' && !brace_level) {
> >> > +                     i++;
> >> > +                     if (i - start + 1 > WFX_PDS_MAX_SIZE)
> >> > +                             return -EFBIG;
> >> > +                     buf[start] =3D '{';
> >> > +                     buf[i] =3D 0;
> >> > +                     dev_dbg(wdev->dev, "send PDS '%s}'\n", buf + s=
tart);
> >> > +                     buf[i] =3D '}';
> >> > +                     ret =3D hif_configuration(wdev, buf + start,
> >> > +                                             i - start + 1);
> >> > +                     if (ret > 0) {
> >> > + dev_err(wdev->dev, "PDS bytes %d to %d: invalid data (unsupported
> >> > options?)\n",
> >> > +                                     start, i);
> >> > +                             return -EINVAL;
> >> > +                     }
> >> > +                     if (ret =3D=3D -ETIMEDOUT) {
> >> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip didn't reply (corrupt=
ed
> >> > file?)\n",
> >> > +                                     start, i);
> >> > +                             return ret;
> >> > +                     }
> >> > +                     if (ret) {
> >> > + dev_err(wdev->dev, "PDS bytes %d to %d: chip returned an unknown
> >> > error\n",
> >> > +                                     start, i);
> >> > +                             return -EIO;
> >> > +                     }
> >> > +                     buf[i] =3D ',';
> >> > +                     start =3D i;
> >> > +             }
> >> > +     }
> >> > +     return 0;
> >> > +}
> >>=20
> >> I'm not really fond of having this kind of ASCII based parser in the
> >> kernel. Do you have an example compressed file somewhere?
> >
> > An example of uncompressed configuration file can be found here[1]. Onc=
e
> > compressed with [2], you get:
> >
> >     {a:{a:4,b:1},b:{a:{a:4,b:0,c:0,d:0,e:A},b:{a:4,b:0,c:0,d:0,e:B},c:{=
a:4,b:0,c:0,d:0,e:C},d:{a:4,b:0,c:0,d:0,e:D},e:{a:4,b:0,c:0,d:0,e:E},f:{a:4=
,b:0,c:0,d:0,e:F},g:{a:4,b:0,c:0,d:0,e:G},h:{a:4,b:0,c:0,d:0,e:H},i:{a:4,b:=
0,c:0,d:0,e:I},j:{a:4,b:0,c:0,d:0,e:J},k:{a:4,b:0,c:0,d:0,e:K},l:{a:4,b:0,c=
:0,d:1,e:L},m:{a:4,b:0,c:0,d:1,e:M}},c:{a:{a:4},b:{a:6},c:{a:6,c:0},d:{a:6}=
,e:{a:6},f:{a:6}},e:{b:0,c:1},h:{e:0,a:50,b:0,d:0,c:[{a:1,b:[0,0,0,0,0,0]},=
{a:2,b:[0,0,0,0,0,0]},{a:[3,9],b:[0,0,0,0,0,0]},{a:A,b:[0,0,0,0,0,0]},{a:B,=
b:[0,0,0,0,0,0]},{a:[C,D],b:[0,0,0,0,0,0]},{a:E,b:[0,0,0,0,0,0]}]},j:{a:0,b=
:0}}
>=20
> So what's the grand idea with this braces format? I'm not getting it.

  - It allows to describe a tree structure
  - It is ascii (easy to dump, easy to copy-paste)
  - It is small (as I explain below, size matters)
  - Since it is similar to JSON, the structure is obvious to many people

Anyway, I am not the author of that and I have to deal with it.

> Usually the drivers just consider this kind of firmware configuration
> data as a binary blob and dump it to the firmware, without knowing what
> the data contains. Can't you do the same?

[I didn't had received this mail :( ]

The idea was also to send it as a binary blob. However, the firmware use
a limited buffer (1500 bytes) to parse it. In most of case the PDS exceeds
this size. So, we have to split the PDS before to send it.

Unfortunately, we can't split it anywhere. The PDS is a tree structure and
the firmware expects to receive a well formatted tree.

So, the easiest way to send it to the firmware is to split the tree
between each root nodes and send each subtree separately (see also the
comment above wfx_send_pds()).

Anyway, someone has to cook this configuration before to send it to the
firmware. This could be done by a script outside of the kernel. Then we
could change the input format to simplify a bit the processing in the
kernel. However, the driver has already some users and I worry that
changing the input format would lead to a mess.


--=20
J=E9r=F4me Pouiller


