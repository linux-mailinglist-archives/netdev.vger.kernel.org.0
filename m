Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AEC44BFE7
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 12:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhKJLNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 06:13:32 -0500
Received: from mail-dm6nam08on2084.outbound.protection.outlook.com ([40.107.102.84]:2529
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231395AbhKJLNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 06:13:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kqr3HPMxQKAI9b8OS8LDtq1+HoZk/OkCBfO9igHjMiEhwCheTbV/7QE0ek6O9pQo8+JX4knGb84tcmzB5A3MdWmNuJ9BonP5++o1RtH4gAniLjWD6eexhabbrpCqcv6pN3v9m6R7nxgk+rXQ5AMIM0/2RkMkq0F1DGNZ0Cd2SNcHw6rXQJdCNeNSzruEBRBiP9Q3TB397R5N3I5TFTiwPgYIn8ZgRgWfBrN2JEyx9nT4uRnH4YvNU7BmGk3gkkLONVBtfG874q5k1LMaOl65c+msFFVSBH8yMnIYJJYyu81L1ELLSvWch8RmfrKNOREK7n7cl+b7PzfInUcDixRhaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+Qm70mudPZIPVRlsrmc0aEneFlIn3ESiT+peVp+h4Y=;
 b=fBAO/iKN+pZg+teGa2F4Pmhn/ZSwTyPXAXwCDa7HIylp0hIO1MgflU8RLdTp6rOy8dTJo2GGGM0yKi2XeHH/C0hqjiQUYSmAzIGj4AO471UzlBW/jym00pr6jl6lU8osyD0luaX0IYJ7OnQXO5gW3A3eAfxu/SvVUI1xm7699IebXLhdN7MdCrgiADOasVnsc+Lo+dcNJ7bTjSZcEx1BnT6wG2kKYYcKeTwKgmUsWQ11tHkkufyjRearEGcOQG1OxmIQvpeaL6pdtCr0wQjW9BZQJT6VVUlI636CYvF4CIlmh4EiXA4TIcQ9BvqetG6KYTN726JoRuyPPjMyEMEA3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+Qm70mudPZIPVRlsrmc0aEneFlIn3ESiT+peVp+h4Y=;
 b=JgmRpWsMqWgf3DQW6kz1wzEJ+o+BKKt99ihsQIVj3xVSfUcfureRvjEbSnHi02dvmnYaRM3vdPldO5GyZTieOKlSkAiHIhIOM/u+Bkgx8FpRDRbf/Q7pb+ilNPlAkUo58vEzKZM1B7Wi4jMt7vxYHGxUsGU0fvLbFXaRzOz3Sq8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5625.namprd11.prod.outlook.com (2603:10b6:510:ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Wed, 10 Nov
 2021 11:10:25 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::999f:88c6:d2d5:f950]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::999f:88c6:d2d5:f950%4]) with mapi id 15.20.4649.020; Wed, 10 Nov 2021
 11:10:24 +0000
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
Date:   Wed, 10 Nov 2021 12:10:16 +0100
Message-ID: <1948585.sCnHgVVQio@pc-42>
Organization: Silicon Labs
In-Reply-To: <87lf1wnxgu.fsf@codeaurora.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <6117440.dvjIZRh6BQ@pc-42> <87lf1wnxgu.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR0P264CA0284.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PR0P264CA0284.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16 via Frontend Transport; Wed, 10 Nov 2021 11:10:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6147043b-6d67-4100-536f-08d9a43ab1bf
X-MS-TrafficTypeDiagnostic: PH0PR11MB5625:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5625150D37A6EDF40798E7C093939@PH0PR11MB5625.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IYMi9kajrbBH3MQ1JAkbeVlf2Uj6AJ8UQdtqkceXwOK2U4IKJ7YKEA0nndfXZK2qWkBGeLYKFHT54i8NXZRIlGsZFq3l6tppVpriok9l9UPZJQ++euWcaWSaHPmBQqWWh0wF4nG6eN+w/3YFzFZM8odreoeceJFaabapBGDE8/lgUSL64MBli8kXNwsGjMVfiqXcmMZYbx0Gxq7b8kYaNrG/p5zkDNp3ERPR8FXAtfshBTWsG+NS1MKDzUUir21IBUWIRXDi7uX1J8x0CK96y7osJNxX0tw0lRSE2JBTSiEVI+gGKiZXGoubaeJ2xMA5WF2EjtSiOnHhA8HSZMdbM+dp09iDHBJM1NHzijKPoYUyvZlgawuMkvBZMBvfZfFsEyNf/3Nzukms1B6XfSRkrJ2GeyMOx7liv/mKxFdNAYMMWkRvj5m2BEq7Fd7a3mzWIlNfFWrqBUnWB6tOmApeXKJC3nGApVIPnw1LIe6g0ZgogfY3VzLjlbzNXIVLM28fp70b+tubrOZPEFhrxZgVEDM8nQjGtJ8o0Y5RkfN077mungdRiw0q+OQalCPp8DaOTSh4jqyNEy4ILxaVXA1SQlpGVtwKoJEkadWs6s3a8WvpTuWom6maCGrczyMwM4mAoBTsKkcC9TEbWcdjwntyGKTQKx2aCxgfMYN8z9CF89wfG5yFpNcTfnOvWZ3uxVjeOoauxtcbaV76QQuClJMJcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(956004)(6512007)(66556008)(54906003)(66574015)(33716001)(186003)(86362001)(4326008)(8676002)(6666004)(8936002)(66476007)(5660300002)(2906002)(6506007)(26005)(66946007)(83380400001)(36916002)(7416002)(38350700002)(52116002)(38100700002)(508600001)(6486002)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?wmaR3hdiAAzR4YJmDqOT2ZYhVIBAh7aQfyAnDYuShogICK4YYzsYcv6BzD?=
 =?iso-8859-1?Q?vxZP064Aw+5OYOp/OL0gzYGxUyT9sZLjz+cfSQiu+xE0wRE4B3dZdLRgLX?=
 =?iso-8859-1?Q?TA21NE+uLCl/gmFBrlQ2kIMAlrGxUkOvSnlv2AqIjeAqPsnYzwNihgP9ra?=
 =?iso-8859-1?Q?b2+upL8iJ/Alfh8H5G/GnyKLbP3Br7JNY6CwdvPeYo51VJeEAhOu5IrGFD?=
 =?iso-8859-1?Q?5z+/1nN29xnNCfSu2xPMpm4GDu4jynYaPlSlkqmj//c18Z6IAmW7qxQAg6?=
 =?iso-8859-1?Q?zCdp93UotyMBr7qqc7CAxf9YlzTOw6S08uApOPB/iBFuxpCz6YoLuxcY/F?=
 =?iso-8859-1?Q?yqaVKz4waMNVqMVXvkjXlC5/oDAdUkASqJrSUzNzQDetJZj1gf147YN28q?=
 =?iso-8859-1?Q?GHQtX+atFpUGB9P7fF5/xT9qRVWtkROylgmH/toclqrK1sjeSrT63v6S5c?=
 =?iso-8859-1?Q?hemOmPPZ5wbrjiK4n/QV9/CThIrLlJey9kWNEOPi0jUS4+QuqWUvjLpaL7?=
 =?iso-8859-1?Q?5lg2uOxbrOdRE9GNd9GByLt38T50DB4l+ec7rTm0xVNsfBH1tm7tKNiXPH?=
 =?iso-8859-1?Q?l10d++C7/GZczxcpKr19uuCCuhtJtjmlth0tUWyCwJ8ISu2HCMdGIV7Qd6?=
 =?iso-8859-1?Q?Q4lA/TG9ZTlIn9hq54WS1AtARDMoGVS1YirzfOd11XcDX5uiEQRlGcD3k2?=
 =?iso-8859-1?Q?WJ9x3aSmVVzMdpEkc9azmhmauBmCGvhTI7ME0ew0K2DZk3SYPtVGZSYCxw?=
 =?iso-8859-1?Q?xIvg/nDWAuYVAWdJDFhBtz7etBPMqY42MJ04olSgv3HUBfqHG5htlGIhu+?=
 =?iso-8859-1?Q?3kXwexpCgBLuaXK6IOvBRywTktdTBfabBktC8LhBuh9/e+ISOXU4lStwc6?=
 =?iso-8859-1?Q?yiO+HOCDsTN9iG4LbObLL7i42wR2U3DNsyAI3+vFaTY26pAd6eX+jx70g0?=
 =?iso-8859-1?Q?oz3XNaggF8A/5rhRIN2R5JbO4Zvvfr1kSw+wF4NsgznsBwFDl+feERHnGI?=
 =?iso-8859-1?Q?dAzF+BZjgxsZcHZRyR7MYhIjStmc8OpR9gGucgsnVUtJV8Me8trCGAzKfg?=
 =?iso-8859-1?Q?ZUUwhW76w3k8nASsaJZ1qsujIrI1l5M2RYhhNWnJKCEAWlMSxd+xArN0IU?=
 =?iso-8859-1?Q?UMzo203jj765P+V4q7U2QbqFNB9KAoWUQChxfDcW9zWKQ/L2XMm0/PXNot?=
 =?iso-8859-1?Q?hwTqWqBNOlP+CZd0HwKe2fxKp5IUmKrtHNMRuwx4cn8cEeJfbkd5f0Kn9Q?=
 =?iso-8859-1?Q?ANBlUs8tsH8jJPdRzafSoidsgY1TFVuMAuaJwLT6M/8gQ+zZ0LJ+CGmBW6?=
 =?iso-8859-1?Q?jg6gOBkR9h9BUnNgtpgyV74LygonfK/Fz47slo0rVvWgzN8dNgjNUUOPBj?=
 =?iso-8859-1?Q?MP/F8LheGZnHVVqIRLi2uDORDRAtSVpluMFV6DQBPZsgrBphjP/WbdKDPM?=
 =?iso-8859-1?Q?BlR2IrTknsOwyXpFzJEjFk88h2QqkM+QxUYqWYG9Kxlfl48I0QYG8oEZ0P?=
 =?iso-8859-1?Q?FHE/+9uTUm3CPiXOYGQO5qEEcjMfaYNeQqSx+wNdd6JCEQ7Dj37YHDPtVL?=
 =?iso-8859-1?Q?JCoT77de5nQd/zIa+Pg8YuyIDKWJprCfBlOLJYEEN4osCqRLlHi60HfvvQ?=
 =?iso-8859-1?Q?J3CU5UU647QaemRmoiJ8uHfG2sfd4S8WUSqziXw5WtsixsdzaZ69dqB12f?=
 =?iso-8859-1?Q?LyCkjLWCUFQiCqPpx5U=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6147043b-6d67-4100-536f-08d9a43ab1bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 11:10:24.8373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SPOBMJG3ZHObYGGGPTi4SxDl/khu0KUdva6Z/UGFC5cxz5xlz70W/qJF/PK5livBDzz4ByP4wSZux8uKQIuC/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5625
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 10 November 2021 10:58:41 CET Kalle Valo wrote:
> J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
> > On Thursday 7 October 2021 12:49:47 CEST Kalle Valo wrote:
> >> Kalle Valo <kvalo@codeaurora.org> writes:
> >> > J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
> >> >>> >> >> I'm not really fond of having this kind of ASCII based parse=
r in the
> >> >>> >> >> kernel. Do you have an example compressed file somewhere?
> >> >>> >> >
> >> >>> >> > An example of uncompressed configuration file can be found he=
re[1]. Once
> >> >>> >> > compressed with [2], you get:
> >> >>> >> >
> >> >>> >> >     {a:{a:4,b:1},b:{a:{a:4,b:0,c:0,d:0,e:A},b:{a:4,b:0,c:0,d:=
0,e:B},c:{a:4,b:0,c:0,d:0,e:C},d:{a:4,b:0,c:0,d:0,e:D},e:{a:4,b:0,c:0,d:0,e=
:E},f:{a:4,b:0,c:0,d:0,e:F},g:{a:4,b:0,c:0,d:0,e:G},h:{a:4,b:0,c:0,d:0,e:H}=
,i:{a:4,b:0,c:0,d:0,e:I},j:{a:4,b:0,c:0,d:0,e:J},k:{a:4,b:0,c:0,d:0,e:K},l:=
{a:4,b:0,c:0,d:1,e:L},m:{a:4,b:0,c:0,d:1,e:M}},c:{a:{a:4},b:{a:6},c:{a:6,c:=
0},d:{a:6},e:{a:6},f:{a:6}},e:{b:0,c:1},h:{e:0,a:50,b:0,d:0,c:[{a:1,b:[0,0,=
0,0,0,0]},{a:2,b:[0,0,0,0,0,0]},{a:[3,9],b:[0,0,0,0,0,0]},{a:A,b:[0,0,0,0,0=
,0]},{a:B,b:[0,0,0,0,0,0]},{a:[C,D],b:[0,0,0,0,0,0]},{a:E,b:[0,0,0,0,0,0]}]=
},j:{a:0,b:0}}
> >> >>> >>
> >> >>> >> So what's the grand idea with this braces format? I'm not getti=
ng it.
> >> >>> >
> >> >>> >   - It allows to describe a tree structure
> >> >>> >   - It is ascii (easy to dump, easy to copy-paste)
> >> >>> >   - It is small (as I explain below, size matters)
> >> >>> >   - Since it is similar to JSON, the structure is obvious to man=
y people
> >> >>> >
> >> >>> > Anyway, I am not the author of that and I have to deal with it.
> >> >>>
> >> >>> I'm a supported for JSON like formats, flexibility and all that. B=
ut
> >> >>> they belong to user space, not kernel.
> >> >>>
> >> >>> >> Usually the drivers just consider this kind of firmware configu=
ration
> >> >>> >> data as a binary blob and dump it to the firmware, without know=
ing what
> >> >>> >> the data contains. Can't you do the same?
> >> >>> >
> >> >>> > [I didn't had received this mail :( ]
> >> >>> >
> >> >>> > The idea was also to send it as a binary blob. However, the firm=
ware use
> >> >>> > a limited buffer (1500 bytes) to parse it. In most of case the P=
DS exceeds
> >> >>> > this size. So, we have to split the PDS before to send it.
> >> >>> >
> >> >>> > Unfortunately, we can't split it anywhere. The PDS is a tree str=
ucture and
> >> >>> > the firmware expects to receive a well formatted tree.
> >> >>> >
> >> >>> > So, the easiest way to send it to the firmware is to split the t=
ree
> >> >>> > between each root nodes and send each subtree separately (see al=
so the
> >> >>> > comment above wfx_send_pds()).
> >> >>> >
> >> >>> > Anyway, someone has to cook this configuration before to send it=
 to the
> >> >>> > firmware. This could be done by a script outside of the kernel. =
Then we
> >> >>> > could change the input format to simplify a bit the processing i=
n the
> >> >>> > kernel.
> >> >>>
> >> >>> I think a binary file with TLV format would be much better, but I'=
m sure
> >> >>> there also other good choises.
> >> >>>
> >> >>> > However, the driver has already some users and I worry that chan=
ging
> >> >>> > the input format would lead to a mess.
> >> >>>
> >> >>> You can implement a script which converts the old format to the ne=
w
> >> >>> format. And you can use different naming scheme in the new format =
so
> >> >>> that we don't accidentally load the old format. And even better if=
 you
> >> >>> add a some kind of signature in the new format and give a proper e=
rror
> >> >>> from the driver if it doesn't match.
> >> >>
> >> >> Ok. I am going to change the input format. I think the new function=
 is
> >> >> going to look like:
> >> >>
> >> >> int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t buf_len)
> >> >> {
> >> >>      int ret;
> >> >>      int start =3D 0;
> >> >>
> >> >>      if (buf[start] !=3D '{') {
> >> >>              dev_err(wdev->dev, "valid PDS start with '{'. Did you =
forget to compress it?\n");
> >> >>              return -EINVAL;
> >> >>      }
> >> >>      while (start < buf_len) {
> >> >>              len =3D strnlen(buf + start, buf_len - start);
> >> >>              if (len > WFX_PDS_MAX_SIZE) {
> >> >>                      dev_err(wdev->dev, "PDS chunk is too big (lega=
cy format?)\n");
> >> >>                      return -EINVAL;
> >> >>              }
> >> >>              dev_dbg(wdev->dev, "send PDS '%s'\n", buf + start);
> >> >>              ret =3D wfx_hif_configuration(wdev, buf + start, len);
> >> >>              /* FIXME: Add error handling here */
> >> >>              start +=3D len;
> >> >>      }
> >> >>      return 0;
> >> >
> >> > Did you read at all what I wrote above? Please ditch the ASCII forma=
t
> >> > completely.
> >>
> >> Sorry, I read this too hastily. I just saw "buf[start] !=3D '{'" and
> >> assumed this is the same ASCII format, but not sure anymore. Can you
> >> explain what changes you made now?
> >
> > The script I am going to write will compute where the PDS have to be sp=
lit
> > (this work is currently done by the driver). The script will add a
> > separating character (let's say '\0') between each chunk.
> >
> > The driver will just have to find the separating character, send the
> > chunk and repeat.
>=20
> I would forget ASCII altogether and implement a proper binary format
> like TLV. For example, ath10k uses TLV with board-2.bin files (grep for
> enum ath10k_bd_ie_type).

Maybe you plan to have common functions to parse TLV files? Without that,
I do not see so much benefits to TLV. However, it does not cost me so
much. So all right, I'll do.

> Also I recommend changing the file "signature" ('{') to something else
> so that the driver detects incorrect formats. And maybe even use suffix
> .pds2 or something like that to make it more obvious and avoid
> confusion?

Maybe I could replace '{' by '\x7b'? :)

More seriously, this value is enforced by the device. However, with the
introduction of TLV, I will already test the value of the Type field, so
I think this test will be less important and I could remove it.


--=20
J=E9r=F4me Pouiller


