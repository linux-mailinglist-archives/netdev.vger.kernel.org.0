Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECA74251E9
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 13:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240902AbhJGLYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 07:24:21 -0400
Received: from mail-dm6nam11on2062.outbound.protection.outlook.com ([40.107.223.62]:22496
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231366AbhJGLYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 07:24:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SimRYGw2sUCvuHrDwI0/vB+SyoTJZNQwsmcjDT31zSxYaCkEa4cKRugEEoDeBEGCrKyOiOjDzulvy/K90n0wXR9FGK5/foV4aGE5r0rckzZgsu8RjWPy8hhz2a8K6ouqE8VP+zxNToao//yZe7ioc3IaZNrJsxf9j1zRRAqxFgkZNGX6PngeKYXvFoAQqkxz9T9JcEMD8sQUOiGJlkLyWHad6Z7q2NSoFTKHCK33D7H1hLGzMaNnMIoY39W5ZbDOL/uHrECg7kNh7kKJOj3iAZpN4ZiIiwoJl6tWQ1BVF3AapN9Xzl2Rvu1aKJZfYH5RCvTtHvRi7efnJAOV8Dmkxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5chmTOxzBCA+P98paXaTjbgLJgWsTlKTnnDpaMNl0w=;
 b=fr0cyeEmpw0jtvoNq0P1zGHRmiV8T3hll6IPaOeBK781SZfpqGh1251AyOPKtsbAAWCMu3BkFc4/XP8OLcUnypki5Fcpjs7pb9lYsn9cdmF9UEnZBQ0W1PWyRiihDa2DB2E22zx3I+LziVR6jMFUhYCYvfz/xH+xyEzj5v6iol1ZBEoMLU+qBY49Hpmwev3U+pmT0cg51DQ5UNk7ScM6m/MlCnlk4Q7MJ/H+2o6HBc6cMsyBSz8ZX2sNa1UO4pLaKIv2Ka+z6SCvziDiXfZdwp5DlZc/PFtkj1LAP3rEqjWCSYKJH2GSrLcjs2iphaQMMUUIfXFY1lOu4l++lUqngg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5chmTOxzBCA+P98paXaTjbgLJgWsTlKTnnDpaMNl0w=;
 b=KKZbvQBh0qtXviZvH7KcgmexUVZX26eF9RCWf2nC1XDzL3qMDDNvQv8u0E9Gqxfn674K62HfZcfy2iutkVxDEOe4RXHwy4CBcxPXibnw4UjHsI+FTOEaZlj25qEQWEkxswLXbu/D+thlHZi7/NSE8YqJS/1vbxTgbgZX9sOjGFg=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5674.namprd11.prod.outlook.com (2603:10b6:510:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 7 Oct
 2021 11:22:24 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4587.019; Thu, 7 Oct 2021
 11:22:24 +0000
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
Date:   Thu, 07 Oct 2021 13:22:14 +0200
Message-ID: <6117440.dvjIZRh6BQ@pc-42>
Organization: Silicon Labs
In-Reply-To: <87v92985ys.fsf@codeaurora.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <87zgrl86cx.fsf@codeaurora.org> <87v92985ys.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR0P264CA0254.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::26)
 To PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PR0P264CA0254.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19 via Frontend Transport; Thu, 7 Oct 2021 11:22:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f18e3632-2fdb-40f4-3544-08d98984bc45
X-MS-TrafficTypeDiagnostic: PH0PR11MB5674:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5674A2FF7156796645B6061E93B19@PH0PR11MB5674.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4IWbvztR3B/hIFPluFK1Yx4tEnrDG2CyH9tA9vLbyx7LAsBIneq6NgaDKaAIwT2ZJUcTb/19FjyWTQhjoISr8zoMzmVoGIA3anNgGhwb/zsM0xnEYHtqNrkSKBloAlOVbNfTzsn34sfFN9gPFX87jLFCxbZKE04IYZg7NGNDPVN1A+xXz5MK2VvoZzdMfEc+91L1/l178L2lWVF+G2/fcbfbgjGFHG3JcJcxZpzQYJb/j6qp09RNsOiQUO4SZqU4xkNe314a5NK2etOF3n4i/mXJhVdPZXgoNKlvaMJ0KzCSPeroAXK4FI6y/WG1eZjg3RtmUT+OBiNCY+wRYoqOZBQThh0R/ZQ0SlAWsHmgCXtWRt6v/KAthEFQIfrcCODxIWpVbPU2JtnWKBVA5OADibuLVJ3l9dIUmemO9Ol3opZEke5fTJhN4T4Vct+9Zu3ORksK3lUgTV982tc9R5VLkuuZ8dZSRRRYdSu3juni9XVpM9ZOliT/qHDpZvpxaNyUQn+eciQtEq3TNLsBeaL7lktYlVsLT2iJmPIAMcZCwlrO0l6dhv4PI2GqKUuB1M5MYYfmN33hz3GVikn+xSFGKAgVU9iol5Dok1q6GKyP6vBg5k6loJguKrraVOgYuK7FyBxvl/GWWVzTz1ot6oe60ASNkie69OPpUJEN7Dkn8Qh+TQmgkTOeIabwrVaqaomrYD96n33D+9O3hb0H0aNLAkOR9pMifZnm3hhFbIu/u+Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(66556008)(8936002)(66476007)(26005)(36916002)(66574015)(6506007)(52116002)(186003)(38350700002)(4326008)(38100700002)(86362001)(6916009)(6486002)(7416002)(66946007)(2906002)(508600001)(956004)(33716001)(5660300002)(9686003)(6512007)(8676002)(6666004)(83380400001)(54906003)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Lnxias8DPML84xeYGZTNhKyKUTpU2O/F1B56qmVR8VJ8DypsDq8soAcsBe?=
 =?iso-8859-1?Q?M6LtDyEJHq/xOfq+T4pdUuuTPt+RzwKq0KE2KFVxRbjUVnyVl5R7w28xr+?=
 =?iso-8859-1?Q?sHiiK29Qf5OXzsklHP/PfqXDpFa2EjHG2FR2qOKeHnSY5evpwTpdhgBtgJ?=
 =?iso-8859-1?Q?ly+jgSCx9F9VN0vYXaQDSnmqqFG9K66WmKU1Jk+8HdZUC4itMps9HIpJ2a?=
 =?iso-8859-1?Q?FxJfdSAEYLPwtWpk/DA9nWrUsccWhRB1koHMmVOFmAZ0HMS3cDXLdzt6WJ?=
 =?iso-8859-1?Q?9dKbisF3/kngQiYTufHHdbw3eoh1eopMjUYV7qor2e5lSSKdlouHuE0v+h?=
 =?iso-8859-1?Q?FzTyZ0+4NNP3z10d8ZGLNfd/XDg2XghyCKqGCbzFKECxeYtOOUPNFyPIo4?=
 =?iso-8859-1?Q?4akibGKqgUb3W3SspxX2inL9RsXvhBXGwbBeLZld6stAlMHYPbXrrIXMuS?=
 =?iso-8859-1?Q?H1ZyScQBG6uvLZWwtlB+Y7ICE6psTHh3f436vQDaX65Gim0AVY7sy/kttt?=
 =?iso-8859-1?Q?w5fP5SOMOFZgs35KEZppgjGSsuAPwU9ixc5+ZjnpZHeXdpEsj9W0wFxiXz?=
 =?iso-8859-1?Q?3AK0a73iBNxb64moE/AyUqgD194HEU/Yu4ZVCzetUfgb3GFRf3qZMwBrce?=
 =?iso-8859-1?Q?cwcqGXKbhJKgjqAdrXxMVaZczmO9xn31BReky+5Ijdbcy2OmcvRqbE9GHA?=
 =?iso-8859-1?Q?byDvu0CSIDAYLOXdu7WHubOkM5mTYe4kEwwZtSg27lAyS60FFXTOVmrCij?=
 =?iso-8859-1?Q?mG+mkDg6uvNTi7KiTBS4h1kNWgMUwNziOyqnClkxZ7Rpck1FHJvj2MUsPD?=
 =?iso-8859-1?Q?IANs1ISxGjwuWjeGW/MSZfR0vkWQa/aVVrKLaSFVHgkrXuiIW/e9dRCiq7?=
 =?iso-8859-1?Q?A70eGrmUSuRensTrjNp+CCuqwZOvhtgnlD0vFWLyOhziPrQ44nmXbI/kSI?=
 =?iso-8859-1?Q?KbmJDuDg4gh6bbMCBcSwsDXia8YloXZcxWWHJz5qWv7KC6EAzzBIaGiWEl?=
 =?iso-8859-1?Q?iARAGkO/lsopCcU7D4wEwbfGadfibPgdTiTWN7EHSczMKotx1T1zZEmxcu?=
 =?iso-8859-1?Q?XMICrZd22VDl01ggMxOW3KJPj72ayOvqvcswzlWUbCo23ecfy1aazSv4DJ?=
 =?iso-8859-1?Q?yQHnrhFP8yCqBKMVKV77ocS6G/nSJVrutjXfO0ySMqI5wX5xDTtII+JYrx?=
 =?iso-8859-1?Q?TX69CKy59/aYdIGQJPbCgP/O2GgdvSXEfGUwv6HwypIaAfvhslKIqMTy7k?=
 =?iso-8859-1?Q?DpWuwJ4Q8ieOfGxbrKmH0t0uj5/2w9yyyM2GXuqjMX13vqAqvexvcfBbRJ?=
 =?iso-8859-1?Q?awDobO3NA8LvMd1ZKR8Xyx/6nr3KISir7NqkkNhXVV1pRKaPx5zT0/pyYx?=
 =?iso-8859-1?Q?cm2U0dR7tf?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f18e3632-2fdb-40f4-3544-08d98984bc45
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 11:22:23.9256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0q2Mds0fya+Ep8DTCmUN64fPbrPftACt6TYJIjXQXXHfnhLfHRmcr57Lwe8VrXZLMB+Xk3jKhmRHIzbmPvb/YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 7 October 2021 12:49:47 CEST Kalle Valo wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.
>=20
>=20
> Kalle Valo <kvalo@codeaurora.org> writes:
>=20
> > J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
> >
> >>> >> >> I'm not really fond of having this kind of ASCII based parser i=
n the
> >>> >> >> kernel. Do you have an example compressed file somewhere?
> >>> >> >
> >>> >> > An example of uncompressed configuration file can be found here[=
1]. Once
> >>> >> > compressed with [2], you get:
> >>> >> >
> >>> >> >     {a:{a:4,b:1},b:{a:{a:4,b:0,c:0,d:0,e:A},b:{a:4,b:0,c:0,d:0,e=
:B},c:{a:4,b:0,c:0,d:0,e:C},d:{a:4,b:0,c:0,d:0,e:D},e:{a:4,b:0,c:0,d:0,e:E}=
,f:{a:4,b:0,c:0,d:0,e:F},g:{a:4,b:0,c:0,d:0,e:G},h:{a:4,b:0,c:0,d:0,e:H},i:=
{a:4,b:0,c:0,d:0,e:I},j:{a:4,b:0,c:0,d:0,e:J},k:{a:4,b:0,c:0,d:0,e:K},l:{a:=
4,b:0,c:0,d:1,e:L},m:{a:4,b:0,c:0,d:1,e:M}},c:{a:{a:4},b:{a:6},c:{a:6,c:0},=
d:{a:6},e:{a:6},f:{a:6}},e:{b:0,c:1},h:{e:0,a:50,b:0,d:0,c:[{a:1,b:[0,0,0,0=
,0,0]},{a:2,b:[0,0,0,0,0,0]},{a:[3,9],b:[0,0,0,0,0,0]},{a:A,b:[0,0,0,0,0,0]=
},{a:B,b:[0,0,0,0,0,0]},{a:[C,D],b:[0,0,0,0,0,0]},{a:E,b:[0,0,0,0,0,0]}]},j=
:{a:0,b:0}}
> >>> >>
> >>> >> So what's the grand idea with this braces format? I'm not getting =
it.
> >>> >
> >>> >   - It allows to describe a tree structure
> >>> >   - It is ascii (easy to dump, easy to copy-paste)
> >>> >   - It is small (as I explain below, size matters)
> >>> >   - Since it is similar to JSON, the structure is obvious to many p=
eople
> >>> >
> >>> > Anyway, I am not the author of that and I have to deal with it.
> >>>
> >>> I'm a supported for JSON like formats, flexibility and all that. But
> >>> they belong to user space, not kernel.
> >>>
> >>> >> Usually the drivers just consider this kind of firmware configurat=
ion
> >>> >> data as a binary blob and dump it to the firmware, without knowing=
 what
> >>> >> the data contains. Can't you do the same?
> >>> >
> >>> > [I didn't had received this mail :( ]
> >>> >
> >>> > The idea was also to send it as a binary blob. However, the firmwar=
e use
> >>> > a limited buffer (1500 bytes) to parse it. In most of case the PDS =
exceeds
> >>> > this size. So, we have to split the PDS before to send it.
> >>> >
> >>> > Unfortunately, we can't split it anywhere. The PDS is a tree struct=
ure and
> >>> > the firmware expects to receive a well formatted tree.
> >>> >
> >>> > So, the easiest way to send it to the firmware is to split the tree
> >>> > between each root nodes and send each subtree separately (see also =
the
> >>> > comment above wfx_send_pds()).
> >>> >
> >>> > Anyway, someone has to cook this configuration before to send it to=
 the
> >>> > firmware. This could be done by a script outside of the kernel. The=
n we
> >>> > could change the input format to simplify a bit the processing in t=
he
> >>> > kernel.
> >>>
> >>> I think a binary file with TLV format would be much better, but I'm s=
ure
> >>> there also other good choises.
> >>>
> >>> > However, the driver has already some users and I worry that changin=
g
> >>> > the input format would lead to a mess.
> >>>
> >>> You can implement a script which converts the old format to the new
> >>> format. And you can use different naming scheme in the new format so
> >>> that we don't accidentally load the old format. And even better if yo=
u
> >>> add a some kind of signature in the new format and give a proper erro=
r
> >>> from the driver if it doesn't match.
> >>
> >> Ok. I am going to change the input format. I think the new function is
> >> going to look like:
> >>
> >> int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t buf_len)
> >> {
> >>      int ret;
> >>      int start =3D 0;
> >>
> >>      if (buf[start] !=3D '{') {
> >>              dev_err(wdev->dev, "valid PDS start with '{'. Did you for=
get to compress it?\n");
> >>              return -EINVAL;
> >>      }
> >>      while (start < buf_len) {
> >>              len =3D strnlen(buf + start, buf_len - start);
> >>              if (len > WFX_PDS_MAX_SIZE) {
> >>                      dev_err(wdev->dev, "PDS chunk is too big (legacy =
format?)\n");
> >>                      return -EINVAL;
> >>              }
> >>              dev_dbg(wdev->dev, "send PDS '%s'\n", buf + start);
> >>              ret =3D wfx_hif_configuration(wdev, buf + start, len);
> >>              /* FIXME: Add error handling here */
> >>              start +=3D len;
> >>      }
> >>      return 0;
> >
> > Did you read at all what I wrote above? Please ditch the ASCII format
> > completely.
>=20
> Sorry, I read this too hastily. I just saw "buf[start] !=3D '{'" and
> assumed this is the same ASCII format, but not sure anymore. Can you
> explain what changes you made now?

The script I am going to write will compute where the PDS have to be split
(this work is currently done by the driver). The script will add a
separating character (let's say '\0') between each chunk.

The driver will just have to find the separating character, send the
chunk and repeat.

--=20
J=E9r=F4me Pouiller


