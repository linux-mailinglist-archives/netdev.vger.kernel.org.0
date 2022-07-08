Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A19456B37B
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237554AbiGHH1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237467AbiGHH1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:27:16 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2053.outbound.protection.outlook.com [40.107.100.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CB67C190;
        Fri,  8 Jul 2022 00:27:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MR6M3iobzJT4Zk5CxxJDiLs8Y1kitFfY3Ummb21qUP/Dx6D1DsDmslel9DF0FN6/3qn1dVh3VoqsYLuHmqJQY6bfgVu3hDu+afKxe3Z2rC5K0NHrYNAtvmaIzeJc8zjdQarOYPZUwWD7XNKRjse1FeYPE6OPdxh7ySSy1A+BYDI+P+8HT1/LxpOdm4ANNvwRQKAKMVD6t0KC56Hprk9D5XRHea8qr7opXY9ZIAViR2BZ5ykoOjc4uDboYJqmKgZnyt0R9P3z0NDJ9DPhyXqWb8PrQRxrfPTS1pl3BVjtjiPNpkzJOANN6PfLGilB7qwcWRX+1BawkKI7XYSQMLpsgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWZfIcg4UCoIjhQBdeyckztZLrbOYF7f6atg+EZZYiE=;
 b=hE6jjLC+zL1XEVjf0bT0rDw+asoEj93NbfP1Y3g9GS2/6fFx6JqSERQYjNhC8o4HKVuTkWX6tA/tiESsu84TP3bHalciXob/HObYa3vCVUDbTCiKorGpDxB+wLa9E235Lyt7SldlzfMeVEIZTZTp9IHDxyygdQoz1knBzZS6Q9+3jQuXvrXljWsgQuZYB/gOWRNq6kE95cE/SDWvklaCKgTuxzjZUNhlaA36hr5GGFhnPDOVUsjd9cI2Z4TRySzZFX1DNUQjOJTsxrsg/YSX2yhi8l2TMgXs9w16cS7Yd0bAlTXNkAcaz/UP58qv3vIDu+AoLC8pCk20Dv+B1C9jIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWZfIcg4UCoIjhQBdeyckztZLrbOYF7f6atg+EZZYiE=;
 b=DLlb3+T/UeFXiQ875QKP6K1N99TuWDcgd+4N89MUqPNP4qazEAuGPUMMrcTmndtHtIQCSJtBl2YUc0YlEypLOa6GFMILBGPqH09wr49nMjcVO9gilz2+UByNhOT1HoB4Z3kJQKxeWqJdUKOVMpfcTaVRyoLvpLNEheoAcLtdhOE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) by
 SJ0PR11MB4991.namprd11.prod.outlook.com (2603:10b6:a03:2df::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.20; Fri, 8 Jul 2022 07:27:13 +0000
Received: from DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::2045:bd0a:d570:8ccb]) by DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::2045:bd0a:d570:8ccb%4]) with mapi id 15.20.5395.021; Fri, 8 Jul 2022
 07:27:13 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     ben@demerara.io, Josh Boyer <jwboyer@kernel.org>
Cc:     Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Firmware <linux-firmware@kernel.org>,
        devel@driverdev.osuosl.org, netdev <netdev@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/3] wfx: add antenna configuration files
Date:   Fri, 08 Jul 2022 09:27:06 +0200
Message-ID: <3938237.uBZYkAkHzk@pc-42>
Organization: Silicon Labs
In-Reply-To: <CA+5PVA7F7-5GY=YE9rSL0ZYkAtiG+mi-gGyq6=65fpvBiqpe6Q@mail.gmail.com>
References: <20220221163754.150011-1-Jerome.Pouiller@silabs.com> <cb49da01-584a-bb71-eecb-c54e40bce062@demerara.io> <CA+5PVA7F7-5GY=YE9rSL0ZYkAtiG+mi-gGyq6=65fpvBiqpe6Q@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR3P251CA0009.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:b5::31) To DS7PR11MB6038.namprd11.prod.outlook.com
 (2603:10b6:8:75::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b523af7c-b96c-4f16-5bb0-08da60b346d5
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4991:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KgjzUBuKcVgqy+56mdtSGJWiUaELUpxim/zqvsoltCjfRE4E/rM4tmMD5Wb1FhQolktLe7dBrR9dieUfFz2fnLk7SQiaX26VFHx/GBcYAMG2v1ERLB7l7yvxTmiRFbquHMvUkQhkDgeqGrSRbaulC6+ZRKrxgNQIdvTDonNSMuU2xQiTOlkSSNrCShrrh254oBRRIKCWK9rdHzPJmMxJb/1k/an2KkCNbCW8U+nufu8xGUM3sKvgnZMN84zb0hW7xEx5zhAzvgqCZBg2r+vNRuquQT0QdIf/ajeRkJY5Qtd3ERduIy9I3wq/5RDJQwhfxgkzqUeifT85sC+8/ejMOHGjRQpQqYUOes+gcpCWiENpYO0jPDFE+TG8dt4M0nEfs7p48xwbe9JYo7Wn9FuBx8n2jYwpvUDntEHbTDogLZBnsPWvr26qKytG9JoygrUY4NiuRXye1c2a4uCBoiwV1X2mNSSKGe6I3/g8L+0HsjWyDm319bM6YGJMHgdkXLjq6Tpl10zsHVgxLNA15djRqWpMCVTG9QGcIYZtZJLZH669IdNC0c+fUPBpsLhtrn2n9dZ/5LSxzeF63QvPZiVOFduIm6RtmN/+gIa6+ncwXNA6n0NHZrXrR22BzFh5Ig21sQiuSuFg/GEbk5mIfznVBqoIxjdcv9s2k+6se62Q32LhbLyOnRCGKjzkcF02a1pMn8MOfkF1lsV5Tg2ma2JikpBLqcbodTuD39TT7oswHLh4rW+9cJs7IM//lZ4DzS4f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6038.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39850400004)(136003)(376002)(366004)(396003)(346002)(2906002)(52116002)(478600001)(6486002)(53546011)(33716001)(66476007)(54906003)(316002)(6916009)(86362001)(6506007)(6512007)(9686003)(41300700001)(6666004)(36916002)(8676002)(66556008)(4326008)(66946007)(38100700002)(186003)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?D+gEWu2zaPMnrhHlnz1Gp2vViRgBfWFAfy67KlsQ2vZxttZhryaDEnQOqx?=
 =?iso-8859-1?Q?o/XPnlLQqxa5p3TnQV8ikaRKT/NYnIZhmiA1OnyHeWInCxxiU6T9B7nSJb?=
 =?iso-8859-1?Q?Ryx1isKxu32/rY7Uwwb+kDp+Z4U27qLX+sWe11BHqfXOwbvSYywwXQy16N?=
 =?iso-8859-1?Q?gS7Mb3pTeeF+DcSd3bI/RGLBqDIIsbxklVoIIZsG+ILAlX1rE6Cd7yi/gp?=
 =?iso-8859-1?Q?Ck1JDGsMPmv8JdvDknp4zHDD1Ix5gZxwib8w1BbrGL377J04UyrMeN/Z4u?=
 =?iso-8859-1?Q?W4PCdBcTdcflPXlaoxpBaovIUZRGRqzWsmw+o+jR4UHdwfcHIo68OYuKgo?=
 =?iso-8859-1?Q?VIVATUO0kcyyD6Q74nQbvt5o/VS2WdgXqzGGp6zaadyEGFteVwVW4TFfvZ?=
 =?iso-8859-1?Q?qNf65PgE4LkfYr2ETdIQ0RcKMpIVk47wc5HQw5goHbNsUYTxNRimSAugXY?=
 =?iso-8859-1?Q?ebX7Jb4UK7+eRxsDqRPJtLxthbi98Nx8+l1R1JxUiab/vgEYxgc7Ytc7aC?=
 =?iso-8859-1?Q?j04DLaJaqyf7r1628xUgyPq/ai9iJmjZ9wtLHtzqxc5Go2vPXrYp0h2TGG?=
 =?iso-8859-1?Q?+F0xuYnPn34je9mwf1D2yUxvC221mDj0bOSQXMmxo8Nn2YKRnXXJnSMB8h?=
 =?iso-8859-1?Q?SCNOyqIM30ZoyH0tX7y0w4WCQtpl4n0ACIxkySkvDptiO7cZi/Ic0BBegM?=
 =?iso-8859-1?Q?gBE9jMBE7b61OxUPsIrNF99EESLYey4q6nXGGG50HKzrY4NWatTkOLwX/K?=
 =?iso-8859-1?Q?0yZtF5+9gAne/CuZSmOPlgu1AUNxCOe7WPyO7cTyW4gxKby0+UbQ/sIE1l?=
 =?iso-8859-1?Q?vP3qfRiM/82dHgTY1zWvYECX6LtJbdkP4ZNDordkqWVlVuUw9GB3O5WGGq?=
 =?iso-8859-1?Q?SpNek5MTYtKAEr6xbiZo78gtxnqso2SN4Lb1WDIeiNnq308UZzjDxOpvP7?=
 =?iso-8859-1?Q?DdsdzZ3HQU7jLHABU2E+WZcYzi0NN3Vi7bve3CJXJZPwZ4KgAGQXikJ9Aw?=
 =?iso-8859-1?Q?I/8+bDOy+enkScrctfhzVpajKb5p1dSk9MYO5oPJMT1zt+mMD+pXx/R7xE?=
 =?iso-8859-1?Q?fPVfMeNlO99wIeDF0gU8jYnG0u+970JMpmohHx+NraFasvEBE3NnPV+iv/?=
 =?iso-8859-1?Q?xb944WrgZ/O97IA0v36HMfxznuvPaEjZSakma1Fa9DHn/hCoJgsuJM7H/w?=
 =?iso-8859-1?Q?ubcZr7QUtdZNXISm2njGWogrMB67JwZawHpO4njPkAsQVyfRmnEybgB3dX?=
 =?iso-8859-1?Q?B7YtHL5S4LeMYTbspf7ziKg5iG5aBu42vsXAAZwidQBFIX4GNlmFZytUHt?=
 =?iso-8859-1?Q?6AvvGYkt/VmWJBK/D+/eGcY2TEjjbioFapMFU0IssKpDgylVh12bC2DTYn?=
 =?iso-8859-1?Q?NOrvojvui+Mbz3JbtWlLoQ3HXy/7UnWM9JfXtPbwHATbsNGTtTnONb8aft?=
 =?iso-8859-1?Q?cs0IC1Y8/5nL6m6+UA4aewah87aB+486e30jP95LaCI34XjNlZL8g+oPun?=
 =?iso-8859-1?Q?wsjk773bMspMo44iWfz+zfjV6y+b/fmC7uksq5NbxRHjtIyLs7Jc8HH5w4?=
 =?iso-8859-1?Q?RyOZr4ec1KF1AT59rm4WUJ1BJN3QrvSXcGKSl0LJFCi167wyPFt5WvZCsN?=
 =?iso-8859-1?Q?z+/UDnFxlm3Ab9f5vlyG/osCBv/BYTbilRmMNIAcumr2BePRXzK7e4h18q?=
 =?iso-8859-1?Q?DIH4gy2TwOlV9E9FTFQZ2P4OlCjQxnQzO5/lt8F0?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b523af7c-b96c-4f16-5bb0-08da60b346d5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6038.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 07:27:13.2177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HA00u6heLm4OzZawSHnlkTSyPeV7Jnsn0aHjvirJ8IV+jHEJ5UjfxVDcmLefsuuCIz2SSzgy+FYTeCwTvBAVJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4991
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 7 July 2022 19:40:27 CEST Josh Boyer wrote:
> On Thu, Jul 7, 2022 at 1:04 PM Ben Brown <ben@demerara.io> wrote:
> > On 21/02/2022 16:37, Jerome Pouiller wrote:
> > > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > <snip>
> > > diff --git a/WHENCE b/WHENCE
> > > index 0a6cb15..96f67f7 100644
> > > --- a/WHENCE
> > > +++ b/WHENCE
> > > @@ -5845,8 +5845,18 @@ Driver: wfx - Silicon Labs Wi-Fi Transceiver
> > >  File: wfx/wfm_wf200_C0.sec
> > >  Version: 3.12.1
> > >
> > > +File: wfx/brd4001a.pds not listed in WHENCE
> > > +File: wfx/brd8022a.pds not listed in WHENCE
> > > +File: wfx/brd8023a.pds not listed in WHENCE
> >
> > This format does not appear to be correct. While this will seemingly
> > pass the `check_whence.py` check, it will be completely ignored by
> > `copy-firmware.sh`, as that takes the full line after 'File: ' (e.g.
> > 'wfx/brd4001a.pds not listed in WHENCE', which of course does not exist=
).
>=20
> Oh, indeed.
>=20
> > I'm assuming the trailing ' not listed in WHENCE' needs to be removed
> > from each of these lines. Otherwise these are likely not being picked u=
p
> > by distros (they are missing from Arch, for example). This may have bee=
n
> > the intention, but that seems odd (and unclear if so).
>=20
> I doubt that was the intention.  I'll correct WHENCE in a separate
> commit.  Thank you for reporting the issue.

It seems I had copy-pasted the output of check_whence.py. I was probably no=
t
very awake. Sorry for the disturb.

Do you think the change below could be useful?

---------8<-------------8<----------------

diff --git i/check_whence.py w/check_whence.py
index 8805e99..8244288 100755
--- i/check_whence.py
+++ w/check_whence.py
@@ -6,11 +6,11 @@
 def list_whence():
     with open('WHENCE', encoding=3D'utf-8') as whence:
         for line in whence:
-            match =3D re.match(r'(?:File|Source):\s*"(.*)"', line)
+            match =3D re.match(r'(?:File|Source):\s*"(.*)"\s*$', line)
             if match:
                 yield match.group(1)
                 continue
-            match =3D re.match(r'(?:File|Source):\s*(\S*)', line)
+            match =3D re.match(r'(?:File|Source):\s*(\S*)\s*$', line)
             if match:
                 yield match.group(1)
                 continue



--=20
J=E9r=F4me Pouiller


