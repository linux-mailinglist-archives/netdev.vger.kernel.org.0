Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E72E2E1C17
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 13:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgLWMJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 07:09:56 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:18850
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726530AbgLWMJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 07:09:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXniekk8jPTtsb07OYLDc8WSKdyZ15PyC7X1LbMtHQg9gWRrOKaBNcOcs4U6GGnaNiIpI9D1zgYEnCEVTw2Bv+pwHW05Z70905rkmP7IoShNzeXhNWSvELC976wnVCL5AE3yD3vrc9y8rSjwkqyY4y83dshmlEtaCH0K3tdBpZnMIPG5C+l3PVUPREz2dJEd3a5QVDd9dxjoCiO6GJOvJUfdsh4j6gPnntplORDMypKjiU4rklImHkOQen3UADhdmnXRBa1Zbi/OSZJuYwdtUvtgZUDTdLwSWjoqHETLWCsVVoZUx6y2Ws2x1jYqzZUcXoyhDMplH0sPHCntXYfWQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2svG06xrb910Q2Jbpe3Z1w3GZjC9YjQYw1gqoDrVcis=;
 b=g9ZtZDKRTa4ivtivm+97gqqxiLK2LAXDc0E+WYZnVYeznUamU4LvHqW23+KcW27UHwcoZvH4/d/q5dui1weNNmjpOsTfy9Y39wpxA9IyfxapleyVcAG+dOeNjD4mvQhl0xn3JpytiUTAFeiV5FIPBcBTCg6JCEwDr7yI5hfVsxqT+OAH08mbKSJoREvXAIZit7SysRE1R93n3GFLVqKQLE6De4Yw14kwY7ul9wglRQWOxSvoCgRky9PICak31lMaurcuFBfYB8kFryLVu/Q3TNxcJX72h9t+jxO3VwfD9FLMVnoJPiJrSh5epPEPkG5ndANZoNLQ1TZVNwLKhKuncw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2svG06xrb910Q2Jbpe3Z1w3GZjC9YjQYw1gqoDrVcis=;
 b=iaRdw0QTiLWuEh7BFlrMf4hqqaCxR8V8i8kAwUETuJ3IARMpPi20vsrFKdCD3V98p6X+cEMt9wQ3BQN2BCxcJkd/k0ebyQZo1iEaH0dnoRfw262CvyUbL5ygiQIuQV61k1MRUWMbr9R+L2j3RSw467CxGq9gaCa6SvoYjO29Pls=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3408.namprd11.prod.outlook.com (2603:10b6:805:bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Wed, 23 Dec
 2020 12:09:06 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Wed, 23 Dec 2020
 12:09:06 +0000
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
Subject: Re: [PATCH v3 05/24] wfx: add main.c/main.h
Date:   Wed, 23 Dec 2020 13:09:01 +0100
Message-ID: <4307946.LvFx2qVVIh@pc-42>
Organization: Silicon Labs
In-Reply-To: <87a6u57smy.fsf@codeaurora.org>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com> <20201104155207.128076-6-Jerome.Pouiller@silabs.com> <87a6u57smy.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SN4PR0501CA0110.namprd05.prod.outlook.com
 (2603:10b6:803:42::27) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by SN4PR0501CA0110.namprd05.prod.outlook.com (2603:10b6:803:42::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.19 via Frontend Transport; Wed, 23 Dec 2020 12:09:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5f41423-ebd9-4834-03eb-08d8a73b8c1c
X-MS-TrafficTypeDiagnostic: SN6PR11MB3408:
X-Microsoft-Antispam-PRVS: <SN6PR11MB340832A65AE593E4BE33B51E93DE0@SN6PR11MB3408.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qbgm34KqCUfopWLFMxn/tGA8wuDxukU4df+fQO2mWZvwO8NIE8w/ZCHjltIiYuT4HjMp3nJkZDuitctL1JjgciCBti05xjbDqAG6OfWZ4iFNP9R6ZA0QUUPCHGL0yLKzsSWi2x0HX1Z45KBHG0ZsIShOeXn2RyP7VpqtJxkzNTuoHATkdjkqqxjSqJ7/EI0qLBhYIwSGNuKsm0gr0w1+tJMsUGuPnP4D8cZDnttGBF91TaeBVtuOJUDroaR1icjAGTwGNBhu/kUIG0k+bjWVVG6vppJUuxPA4RFbKLunOjtDtnKjO9PIP22ppA0hwBXAVBcE1naK4iG6kOGLrUJc9zlR+Xd9LkCQ3HZjBft7z1h0k9mj5207230DrivHTNdOGMyfkHtEcfp8WmnT2QOsEIes1H/WIthNtaxTRgjnThxEFIETtR3DPWkJ9lJpWXdJKQPe0zvQzMO5FNCZK0QKl1HkszPH20BHyIoLzdl8ZLK2dgGoJvcGG+GwHIo5iOrymZHSGNWKvB1Y8jDrpto8zQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39850400004)(366004)(136003)(396003)(36916002)(52116002)(6916009)(2906002)(26005)(4326008)(33716001)(186003)(16526019)(8676002)(7416002)(5660300002)(6506007)(66574015)(6512007)(54906003)(956004)(9686003)(6666004)(86362001)(66556008)(8936002)(66476007)(66946007)(316002)(478600001)(966005)(6486002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?tCScRIHVvJbZNrjLS9FszSTw2JAxuMBgRjAu6v7nluHfxYQX9QGo3F6M4D?=
 =?iso-8859-1?Q?ODusWZiArLwAMSA77rIvz4qzzcvTqjhLIVXCmdjfl0/kZWQlkzKpKTmJLZ?=
 =?iso-8859-1?Q?gfnbbnyApgFwGq3z6AhUss0G4DEr8qZDhIs2SMkYOY9l2YMob/PB/PXk4o?=
 =?iso-8859-1?Q?Ym67dqLvFczpx8UnxOfdIih/nH0/YqKCUgyxmRCPSPxvTBFkf40QmWBzXD?=
 =?iso-8859-1?Q?ejg+b9xowIAFfEozd6CLU/7XfxipZKUkUwtFFgQ0CGIcbzPVOMJt3xb5On?=
 =?iso-8859-1?Q?soNZHPUeXr+0ZQyun+fqbO7QdCJ2nKXLTWKbF5toV/BnDcn6WP9YZ8+9Gu?=
 =?iso-8859-1?Q?4AfRA8OB2VA4tgasHOmoKI1bufGONJ4qPSn88BFzP0/qJ9S457EzFdRo3j?=
 =?iso-8859-1?Q?+n7stgtXX0nXs2lax7W+C5mGcW1kmD36+tisgLcZ7AMqcBrmEZR1gltBL6?=
 =?iso-8859-1?Q?DW4i1LY9AWD1+m5RCdjHAwS4sWp7B71Fd/qkpjE3uH6/sUX60rBwzL5kr6?=
 =?iso-8859-1?Q?RwTNi+xiI3LzT9FGLeDKUFSMMU1KfpopHlLAsZLGnwq2JxW449kPels+7P?=
 =?iso-8859-1?Q?H+0gQZDtuHJ1SYDVSz3xOoTSbb4JONaMS8sFIfNZq0mbA3VTslZKLzQI31?=
 =?iso-8859-1?Q?r2GTtaemA3QZjFGCvCfBQWf9D8EAedIPwsz0UYH9NG+w7pNBqebGMaWcIK?=
 =?iso-8859-1?Q?je6HEbC6Nbw2vPXeAH6L9lAWLABdutj64nnBI7HmAp/ZppC9VikuHkpm3F?=
 =?iso-8859-1?Q?hlP6D9UNwQYKUxs9vguihMw02Coa4e6D/gLo8M1fx4uHa8HDpmuOy+ZguF?=
 =?iso-8859-1?Q?lLqk+m+uxvRfvMJVmW8VE0x3b6f9mh3mS7qUoFw/tigq+SDbdPRfrw2J8g?=
 =?iso-8859-1?Q?P4KKzUEsnL3cYVmd/wi1S1FicmBdLLgdOFvFi0hidsbSP20xpXd9VzLew8?=
 =?iso-8859-1?Q?jOugxWmwYRbZvwYuLbSjxLbXaerL79YKy7vecONUQ/c49WKtFL+7bLVHRH?=
 =?iso-8859-1?Q?17p32wiMAS00bZ0cs=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 12:09:06.7451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f41423-ebd9-4834-03eb-08d8a73b8c1c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dfYcw6rhgwSue5niOD6R3zZ73NCp2Ty4koRSSRC9M6WPT33UivQ7JnDGM720VSJLfShT7UxWWKXTIbvHMtsn8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 22 December 2020 16:44:05 CET Kalle Valo wrote:
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > +/* NOTE: wfx_send_pds() destroy buf */
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
> What does this function do? Looks very strange.

I am going to add this comment:

The device need data about the antenna configuration. This information in
provided by PDS (Platform Data Set, this is the wording used in WF200
documentation) files. For hardware integrators, the full process to create
PDS files is described here:
  https://github.com/SiliconLabs/wfx-firmware/blob/master/PDS/README.md

So this function aims to send PDS to the device. However, the PDS file is
often bigger than Rx buffers of the chip, so it has to be sent in multiple
parts.

In add, the PDS data cannot be split anywhere. The PDS files contains tree
structures. Braces are used to enter/leave a level of the tree (in a JSON
fashion). PDS files can only been split between root nodes.

--=20
J=E9r=F4me Pouiller



