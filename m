Return-Path: <netdev+bounces-9575-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E6E0729DE6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:10:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B35DC1C20FF4
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3685F18AEA;
	Fri,  9 Jun 2023 15:10:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22035256D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:10:50 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1620DB6;
	Fri,  9 Jun 2023 08:10:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwlqF+3WBfJ9370KnTE1SaB1+WRFTNTSAqqPfCkchDqy5vV+Hxj1nKNtoXv55AODwKN2FISEH537mqqyWIZpgsV6r4DLmy/zGAy3w6h0v7Rh0TgfHQVdEeEUQQDviW1Tn/8sK5VDccYM/sp8sFkXbS7usqb7CKCSY155Vh5nM4+aGGEQcXY5L8KmavavvVlF4NG6+1BsEwMyTJjY1j5bmdSbVCpMoBTqFRB79GXyZfM3xTDHn7649dG4YA3ZzpLOCahEerBGpQWQZR5QeJjXPhoWeH/3hPStGxUo9nLGgD+NdHh8dIrXhCrbL9ezqQFuE+2IFADSPCbtclBcH28tvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhY0AMMxbm3qeJiginSoqBWdwA2wSDalwRbRc98BkoI=;
 b=X06XKpshsxalbjEGZKDaJJnuAYs6wIgvcZ3P48zTuc5h4+qMA4MmfzuCvFOk3ijuvQe00czJTVDK1t4wxB5XsiR/7LmqXub/a3WpAv4sKyHEaFaV7KXXIluijvP42PZ9e2EFTiEwdoeyj6NwD01l6TD/B6LfxsA+lc1RfvoQkGj6xQSFzrg+fvhaHRXQJBeI0J+iCKnLBXUvlqzhGyr7nj2OQTt6v1SBC7x7ANP3zrIaQDF/75/us4yX2x4++5BZcg32zL9gE5ymOtUfTgqOmS6fsWT8JKIHM1JZnfsokqGMkz6m5SM+9DlXwmYVIuusV/72Ka/49AMbTWIzXudBrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhY0AMMxbm3qeJiginSoqBWdwA2wSDalwRbRc98BkoI=;
 b=Db4CVmA8ggkf2NsGrBYc7lLIuW/hPMWCApnRMgd1sfjiSb4Uhb3Qw2yAYvZBWrl8CgQZi0AeFd9gM76aJBnSyBa/Od34X9Wqab0hxLyCoTQzg74W/JKluP4XWiIvvao+Vr4HzamLdTCp/Y4nY5A1iujqxkhTZAXSQ/z0F90tcRg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) by
 SA1PR11MB5899.namprd11.prod.outlook.com (2603:10b6:806:22a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Fri, 9 Jun
 2023 15:10:42 +0000
Received: from DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::9d8:6538:9dc0:17f9]) by DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::9d8:6538:9dc0:17f9%4]) with mapi id 15.20.6477.016; Fri, 9 Jun 2023
 15:10:39 +0000
From: =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To: Kalle Valo <kvalo@kernel.org>,
 Ganapathi Kondraju <ganapathi.kondraju@silabs.com>,
 Marek Vasut <marex@denx.de>
Cc: linux-wireless@vger.kernel.org, Amitkumar Karwar <amitkarwar@gmail.com>,
 Amol Hanwate <amol.hanwate@silabs.com>, Angus Ainslie <angus@akkea.ca>,
 Jakub Kicinski <kuba@kernel.org>, Johannes Berg <johannes@sipsolutions.net>,
 Martin Fuzzey <martin.fuzzey@flowbird.group>,
 Martin Kepplinger <martink@posteo.de>,
 Narasimha Anumolu <narasimha.anumolu@silabs.com>,
 Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
 Shivanadam Gude <shivanadam.gude@silabs.com>,
 Siva Rebbagondla <siva8118@gmail.com>,
 Srinivas Chappidi <srinivas.chappidi@silabs.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3] MAINTAINERS: Add new maintainers to Redpine driver
Date: Fri, 09 Jun 2023 17:10:27 +0200
Message-ID: <3166282.5fSG56mABF@pc-42>
Organization: Silicon Labs
In-Reply-To: <dd9a86af-e41a-3450-5e52-6473561a3e18@denx.de>
References:
 <1675433281-6132-1-git-send-email-ganapathi.kondraju@silabs.com>
 <112376890.nniJfEyVGO@pc-42> <dd9a86af-e41a-3450-5e52-6473561a3e18@denx.de>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: MR1P264CA0090.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3f::14) To DS7PR11MB6038.namprd11.prod.outlook.com
 (2603:10b6:8:75::8)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6038:EE_|SA1PR11MB5899:EE_
X-MS-Office365-Filtering-Correlation-Id: cd69b98c-9067-4af6-3664-08db68fbaf74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QSuVirXuHAHBqbPvvDevqTqMDc38WWy8/eB53YWelG7TdBK4/WyN7d4IO+LK25kRe5T/pRg3HXL03sZIAYjnLQoNPZJx80P/3j+/AHKW3ZS4G0+AUldWONpA7a8KG0elNT4QIre2Vs2/MSYByhB0Ct8WEg0dp4M/32h52lKhC/tra74Q8Wyi3vCL3vb2Dpsf8c0OSuOghnnM8QQRnpEfvCpRIO7giUG+iSX2c9TlnujHIlI2wUukxptwtgRqVckiJhUE89o9+JfbuGyQ26MY6HoURVkTaGGgGUPT/bIY61W6Ks/tmkI4ZzBITzOip91HtcQYkLKpfiHKsDYZXVCsHr/c8w9rCkTsLVPHlrerFF9wWYO90pl1PHnVmAdG0AdQMCxgi7w3f0U+eAjKAIOC5L1Q/pyBBOwnBj2yLSf+Vn2ySHxizh9GX6dzvW2f2hQ69A4aXeV0qsZ7PRYnMO5dGocZtrGocjeeA28oEh4w8QEh/A+GtU1z3hzQjsozq6SC3zMa5DJK5kDg0iZr+mldJyhGWhjQSTRrD8em8YfX3TuqaBg1tGkzvb7PwjVKl0PV4dw4gIuHtN1Jnoqcu2gN80AwPBPB1I5BVrt9xjbtxqACpL3Idxsk1qDbgZRIKn2R
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6038.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39850400004)(376002)(346002)(136003)(396003)(366004)(451199021)(66946007)(66476007)(2906002)(478600001)(54906003)(4326008)(8936002)(8676002)(110136005)(316002)(41300700001)(5660300002)(36916002)(66556008)(6666004)(7416002)(6486002)(52116002)(6506007)(26005)(9686003)(53546011)(6512007)(966005)(186003)(38100700002)(33716001)(83380400001)(38350700002)(86362001)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?MOUzVe2+aR7wRN06mYf5Q2nrm0dtNTuDSuKrXetjNLlJEGJVM+qQ7ApoBj?=
 =?iso-8859-1?Q?Ms3QY11/SB2Gv4lQuRVRD7Pc2/Y3GEMfAySAoGEsoPqTjHxH9dS4oSmP40?=
 =?iso-8859-1?Q?SkIe7wSVY1ILlSPzXJNoUAAJjmcMPRa2wgXfdaIgLwi1L1YzjznNJSLgji?=
 =?iso-8859-1?Q?NifA9f8SxkNYGHLeu81r9BnJ4dlZst+cQLUB/BmpZVfAQqtyPNUrjZ3a0n?=
 =?iso-8859-1?Q?GthWFnQgUcoIL8aY3WpqytkhP7CGPyhbCi/bUt209SNcOoC2N9LbhQNB8M?=
 =?iso-8859-1?Q?XMfP0x/iDbxaWXl29Qs13khvBvyCOQzHa1Iy6A+yZEGC+8EjCJ0KbxR/31?=
 =?iso-8859-1?Q?TTjkNIG7tbF++EjKxHpFfxfgGfSb8kHajxsylP/0JUUnkq27levsqA9gsj?=
 =?iso-8859-1?Q?dfdGjHKtAqYYFqDXziTPhVpiPbJJ79DmC5bu6kTbKYiel11cHpUVVNbycE?=
 =?iso-8859-1?Q?EWv/Wb780uh/cUgwIIiCITQpHCcrUkR1CjOlNtlTLKF5t+GGisPTJegswW?=
 =?iso-8859-1?Q?LK78rriPBHEUDpQ+3Oz+5VzmPiTeRppUPFjYAxsoaGYvsZY+rIZtGQV2vb?=
 =?iso-8859-1?Q?C1yXuuR2wg4r33nSumuX6BnZWs1/PqBkwBVq6V7n7uRGqI/yUMKQKy+gYp?=
 =?iso-8859-1?Q?tQIkCEyeFnSoLL/ba2tCRUqFUsS1Tv3K/f9iR50unA4XJ7exqet4ZJsmf6?=
 =?iso-8859-1?Q?ICZ3ZGVqrnpxfGt9z3Dv6QYvjt7PSY/9/xOi12tO7+tnrNFxcI0Z00GKDi?=
 =?iso-8859-1?Q?PGHrond4LZwl0vegjP3jpR/NBMLnaIJR3bszz+7SEFChWi4Qfg4RYsel/B?=
 =?iso-8859-1?Q?HejUwEUnT6CyaO+FekLFRPyn1BdHyYRPy2WSiWotT8Cc9Wosi4Wbxm7JMs?=
 =?iso-8859-1?Q?y6brEbV0R7S9CewMP7DMVG/liJkVn5pNeWqTA/PIVjd1UfoVPEKKWGnOBC?=
 =?iso-8859-1?Q?kF9s/SLcrz16EIi3uzlUB3W19fscM7lgdtp4isY4UyWE+wpEA+mOw0kaMR?=
 =?iso-8859-1?Q?BFLjyFvKjkgbDCsWBC3wCp3qOFeKHEZ9FdPhZp3P16mfLaNBHAgAKFQT5X?=
 =?iso-8859-1?Q?gpe1gPjFkCJf3210L9619nG0jv/KMYZ1t4K4KtuTzOz55JL/QlmRi0cqsB?=
 =?iso-8859-1?Q?5Bt2kkEdC86lXntmxJipHbV5TKXgUwep4SH6Juq9/MJDHVQ0H29+yeOkNz?=
 =?iso-8859-1?Q?NN3FXotGyZ5u2qddzXOJsPe5pCGWrvR86mpLD2oaccIZmfUBZ3oJGi0aLo?=
 =?iso-8859-1?Q?0PUvTVW7oIIMTOrl6rGeZNQXPj8TqnIcK3Lq69AyM+LciS1KHlPAFP+jzu?=
 =?iso-8859-1?Q?zts4/ffwknZY+Cleh6OcG2i77tX9YYLA7rqW5P7x69WIU/XZRZCwiruEjz?=
 =?iso-8859-1?Q?z6IEzZxa71i05yGXpdzNN1iIQGLBuaotlrcoOIlLUYmnLu3gfdbPYtAdbd?=
 =?iso-8859-1?Q?kwTMqtPFx4V9m36k5xzaWK3RHdFITXNz7w+bcOyJ/0nKS00i/vzoA3Qxs1?=
 =?iso-8859-1?Q?tPVaHQjFObolMEh7tjtKrYU9nG7vZXs6tOQcvHtljKxb1W/7iqPeLIXcmG?=
 =?iso-8859-1?Q?JxfvAoy9OfC1I09hQDoOI2B+7gsJSN6Cel0kVqnzSpTZKC/0aPSh4eFK5P?=
 =?iso-8859-1?Q?ycGWpPqjX+aM8vqzb+IRZoQUyNyn9P7DyN?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd69b98c-9067-4af6-3664-08db68fbaf74
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6038.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 15:10:39.5194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M15T2t+HYsn6xUs/3UE55qSypzM8XiUR90J3udxdrWDd982UPz4rLP4ezijw9C4Iz28h4AkS5mNcRjrzMMTktA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5899
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Marek,

On Monday 5 June 2023 11:59:41 CEST Marek Vasut wrote:
> On 6/1/23 12:47, J=E9r=F4me Pouiller wrote:
> > On Saturday 27 May 2023 23:12:16 CEST Marek Vasut wrote:
> >> On 2/27/23 11:28, Kalle Valo wrote:
> >>> Ganapathi Kondraju <ganapathi.kondraju@silabs.com> writes:
[...]
> >> Has there been any progress on improving this driver maintainership
> >> since this patch ?
> >
> > Hello Marek,
> >
> > The situation is still blurry. There is a willing to maintain this driv=
er
> > (and several people would like I take care of that). However, the effor=
t
> > to properly support this driver is still unknown (in fact, I have not y=
et
> > started to really look at the situation).
>=20
> I have to admit, the aforementioned paragraph is quite disturbing,
> considering that this patch adds 6 maintainers, is already in V3, and so
> far it is not even clear to silabs how much effort it would be to
> maintain driver for their own hardware, worse, silabs didn't even check.
> What is the point of adding those maintainers then ?


I think Ganapathi just wanted to give a list of people to keep in Cc in
case there were some discussions about this driver. The status change was
probably not what he wanted to do.


> > Is this driver blocking some architectural changes? Kalle is talking ab=
out
> > patches to review. Can you point me on them?
>=20
> You can look up patches at patchwork.kernel.org or lore.kernel.org and
> search for "rsi:" or "wifi: rsi:" tags.
>=20
> This driver is basically unusable and I am tempted to send a patch to
> move it to staging and possibly remove it altogether.
>=20
> WiFi/BT coex is broken, WiFi stability is flaky at best, BT often
> crashes the firmware. There are very iffy design decisions in the driver
> and other weird defects I keep finding.
>=20
> Multiple people tried to fix at least a couple of basic problems, so the
> driver can be used at all, but there is no documentation and getting
> support regarding anything from RSI is a total waste of time. Sadly, the
> only reference material I could find and work with is some downstream
> goo, which is released in enormous single-commit code dumps with +/-
> thousands of lines of changes and with zero explanation what each change
> means.

You are talking about this driver[1] I assume?

[1]: https://github.com/SiliconLabs/RS911X-nLink-OSD

[...]
> In the meantime, since RSI neglected this driver for years, what would
> be the suggestion for people who are stuck with the RSI WiFi hardware?

Unfortunately, my only suggestion is to use the downstream driver we
mentioned above.


--=20
J=E9r=F4me Pouiller




