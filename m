Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90F33F6001
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 16:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbhHXOR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 10:17:26 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.34]:8548 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232311AbhHXORZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 10:17:25 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04lp2056.outbound.protection.outlook.com [104.47.13.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C16F67C0079;
        Tue, 24 Aug 2021 14:16:37 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4bfnBpnJiTY9XkdxAbQVPYHndv8rDy5U/cuZRxws4VIgfj0npOTRT9fESA0bzPtCGKPK541toizT29L/fjE8jFrtwnOw0Yj99vcdxqwbLiFCYtByioVMFafW3k2twdL+gMilHi2UxivnHIqDtjXsl//HT1c8wQdOBjwwBoc5C88g1VNNENfuhk7dGnzdL7JEfzg4cJ4RJ2buX1yU5wr0ORU1k5C0+k0wRrOxb4KOPbX3lD40CDj8UGoU8v3l2YEW29opNhOv+QWYw+yaFVn+0ZygXQA5NmWmgfJabsvJmtbbteSjDSOkxUZUdlNtnUPsYFOib67IYP0SaVJvlsrBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFKjbYwUpqnNXX94KcAEz4ZbzOMtotnkVaU0dLYzNlU=;
 b=Cm5Tm7+FYcxKmy5I9kcDAsAGnRWdFhjzJOi7tJisB+r+m4ezPrELC3PmIpd8/kxs+pmPdcdm/gBPswEAFX/z80OkCUzYJbANzmFHQjc6H07FUOw+P49WcvvOU2Jd4oGjzr/mNWy4OFqnak+wC5gfVOUJKjouk/58D3FTzVNyBbXWK9MBucKzk4twc87r+P2nsmHXsMuuZL5YdU0oZSQy6bUI/UtX7zj/VDJvyAi54HiMGa5t4Lbip8UPrkHMslzin1ZBXJFqt4OxZxZcofZm1lh5cwCdsouDTXydtarHYYgkY+aKdpzg0utmxo8rGqaYlSQOL9GEEdJ3Cdr+lLciQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFKjbYwUpqnNXX94KcAEz4ZbzOMtotnkVaU0dLYzNlU=;
 b=Co9RowRgJlYlGwIjXmAcAVIK08zFy+ms2vrS06sgYKUiuPX2w3dJuyhzCNxnDP1qwDdkwnwMXXF1TTjNNGCdoO/NrDD+2jFyqIszvkl88vFBqemjsv4ufeTIk5LawFZWyu9fUof3fScn2aehWwTxIJVp5PcrXUrJbvth5xvofhE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB4269.eurprd08.prod.outlook.com (2603:10a6:803:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 14:16:36 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b%6]) with mapi id 15.20.4457.017; Tue, 24 Aug 2021
 14:16:35 +0000
Date:   Tue, 24 Aug 2021 17:16:26 +0300
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
Subject: Re: [PATCH] ip: Support filter links/neighs with no master
Message-ID: <20210824141625.dtwnvpejidy64kye@kgollan-pc>
References: <20210819104522.6429-1-lschlesinger@drivenets.com>
 <8b8762b4-6675-6dbc-bfe5-ed9443c8d54f@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b8762b4-6675-6dbc-bfe5-ed9443c8d54f@gmail.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: PR0P264CA0054.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::18) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kgollan-pc (199.203.244.232) by PR0P264CA0054.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 14:16:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f75c3cba-928f-47a8-9bda-08d96709c7ee
X-MS-TrafficTypeDiagnostic: VI1PR08MB4269:
X-Microsoft-Antispam-PRVS: <VI1PR08MB426947EC7E292283BBC68AE6CCC59@VI1PR08MB4269.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xlyS1wtHbpFejP6IgyfHVEw/08M8jnRuC5NEnYYJj+Qbz7rXbQhyKWZaEYBquAFQookrZmcZgx2AU47iaqLXRVRsanWhlba07ExHhLyL3hpK8CwpJVvzdY7KX+ul7ND/3pfN4tf/Fvo8UcjPTDKjxmR9KIPUD6ajOHyx63Po0w/l7YqFGbIXWBrDAktcBttlJ6crWazbKiDiaFoqa3Ml7xIWVpBZyB2E1kJt27fodz4V+aNaVE9W8chRUEFPw95QX11Om1VqctpXsByxbKVJQJOlfixuGlJ5YwlXdb2aNwRdDbgl6nyDHQSscScI53p1fCsLNenUOCN+ywHhSb5yAQVZmJXmW7GBzajDIDKctW+qHbyfZWbk9Y0AWsXIiHPI/xAOHVTCAwZS56BkKWbGRAwl+KB8WqGGUBJVSaEDA8vAIe+jj4ZqKluntLZp37fhKem+87b3aGwtpgJMU/hzGslcpnvHLQn0M7Vt/7BJykzc7/IJXoh6BXh6JPDPUvO04Frpus1Qn3cIkMW/JQS6dpPmQ6qPIER+DV6ZvOB45WGcoGELvur6hFMimQsRS/NmhnQ+Q1XsHTXh0KP+AeTswsJq60KJAfj36Y861uM/U4S5UdslFPEbLxAHzbqUq2UE/XR2XJLWYEzbQ0TTigrHsv06VlbhmUEGL4Nzd70Yi8T7RHshqFpGTuv94YYCSudeGueUe3jvZ6hJpkTBtSiJFWpMl8dozec67xe2Is3vUUw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39830400003)(136003)(376002)(26005)(956004)(8676002)(186003)(316002)(6916009)(6496006)(33716001)(1076003)(5660300002)(52116002)(53546011)(8936002)(4326008)(6666004)(38100700002)(478600001)(55016002)(2906002)(66556008)(83380400001)(66476007)(66574015)(9686003)(38350700002)(66946007)(86362001)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jK649U10o26hrXgghilnbTf+iJvgMhALLbW/UYkZyhHHYkA00QJQdoFpETAo?=
 =?us-ascii?Q?9oFXI3cUhRdRO2Dbhw1y0gmlV1AGKjdbQJPAAGibDVINr3lnciQUZNFHIF0B?=
 =?us-ascii?Q?pi5RvF5IGu0tUIRi+pFooslU9kYpSfqu+fWgVwFzzpVnM26hhcYWkbdPC2Rp?=
 =?us-ascii?Q?XMClcOqP67YjHowrd0ryGOBYZZke1etcr2+yBorHaRGhUOBwA11pRuwgl/WS?=
 =?us-ascii?Q?Y9AtPtY+wXt4SlGzeBlAIVdSnsUXUmPvRvo2dgyr+dZy6aLaJ9z0QF3Uf4c5?=
 =?us-ascii?Q?aUt0OrUb1zloWNzPCIZ/eJiIKfByYtFd/ljS72/stWStJYw/a1ZX2x+eW0X5?=
 =?us-ascii?Q?vXlNmCyMUXgABMS4LolofPgEpyiLllHJF7hR6nMtsFqq/oZK9MB+W3gsPL9r?=
 =?us-ascii?Q?YkeXp0rijK1ubC1GFB4GUbnr+bwG2unrKfW7T0GYFEUzPkCR1LlWJoPCcWr7?=
 =?us-ascii?Q?UgBvXDw1fNYjzTNiengImoU+rW+4i229aprSISqbxK0KMEV6Fi0V8hHFMAMu?=
 =?us-ascii?Q?dpQwwNGUC4lsLzYFyvhkJKedJMJaPjQB1xBTiNLAOWw8YoeuuP30U1iJFW8s?=
 =?us-ascii?Q?8GjKfGvoCieYWscYgWwlU1paskara9gT2WMY4htTfa5DWUoJIT7gONGTZAHD?=
 =?us-ascii?Q?y2H0or0TEUDNdQ+fvT0mfwQH9eK4iUrlRmLkBgtsPZ+wZr3KafFCAZqkaKWB?=
 =?us-ascii?Q?7BHac1w8aOj+s3dIehhFkycp5OMPb+20ZjxWSCBYvLba7Pm5C77F8E5FU1AM?=
 =?us-ascii?Q?flUoFnX0w5bwmls5D5ewTcFuBqY/mEQbMAj2SPn/1buzP8MvrQrpLkiqohF+?=
 =?us-ascii?Q?jjO9SBQc07h24B4UhmZzQUHMaRZb5z+iIInrJKJ6+qSBpDn0ky6Mhe+ax6KX?=
 =?us-ascii?Q?clBlUPCaRtPKLAb4VNYczmdnJyLkzjM+Si/k44+lMhVsFO0VBtNma2THF5Wn?=
 =?us-ascii?Q?cQUdSDcblv96cHMwW3Ugr89vGdEy71Zu41Pt/3D3cze/2stN/ycTvUnMVKCy?=
 =?us-ascii?Q?WIJsSJ93aF4aG2g0rk7mnZemeEKL6npeMP5yFvRoAG+wid1VZQizJMu48/v2?=
 =?us-ascii?Q?SV/m3gOnK2EJnvU3ta/QMr4he98/ZePNAW4XSjdFs44/HyECocEHkK61xZk+?=
 =?us-ascii?Q?zeItoI2LJ9rEWUZN1D+n2sC3hAZxTX4ZXmsmC0WyS1GndjxNKfPt+zWH1ctI?=
 =?us-ascii?Q?I6Cr7ws5/xX5Iib46zL9kEdj3jv/FT4gCGwIFy5wF4vRby53ZLqWLn6jSzrm?=
 =?us-ascii?Q?2cVct0h9PvUUXyE1HbmG1tF+T7D0Zi1POTDN0aCh072oje4BY/CeJOrOkpLO?=
 =?us-ascii?Q?5BWFc84BMo9NcFz+XuAhmtYH?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f75c3cba-928f-47a8-9bda-08d96709c7ee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 14:16:35.7785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j0FbBRc35m0Bji2Cb8GBThXIGlIgKAO18AwWLxQ8ZFw2OxZoGI0PRzB34myMrEmo6R4suuupxVWkSkJmXE+qFgK2a3omjjifyftmFQipxNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4269
X-MDID: 1629814598-tMhsZmoph3_U
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 09:19:56PM -0700, David Ahern wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On 8/19/21 4:45 AM, Lahav Schlesinger wrote:
> > Commit d3432bf10f17 ("net: Support filtering interfaces on no master")
> > in the kernel added support for filtering interfaces/neighbours that
> > have no master interface.
> >
> > This patch completes it and adds this support to iproute2:
> > 1. ip link show nomaster
> > 2. ip address show nomaster
> > 3. ip neighbour {show | flush} nomaster
> >
> > Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> > ---
> >  ip/ipaddress.c           | 4 +++-
> >  ip/iplink.c              | 2 +-
> >  ip/ipneigh.c             | 4 +++-
> >  man/man8/ip-address.8.in | 7 ++++++-
> >  man/man8/ip-link.8.in    | 7 ++++++-
> >  man/man8/ip-neighbour.8  | 7 ++++++-
> >  6 files changed, 25 insertions(+), 6 deletions(-)
> >
> > diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> > index 85534aaf..a5b683f5 100644
> > --- a/ip/ipaddress.c
> > +++ b/ip/ipaddress.c
> > @@ -61,7 +61,7 @@ static void usage(void)
> >               "                            [ to PREFIX ] [ FLAG-LIST ] [ label LABEL ] [up]\n"
> >               "       ip address [ show [ dev IFNAME ] [ scope SCOPE-ID ] [ master DEVICE ]\n"
>
> move [ nomaster ] to here on a new line to keep the existing line
> length, and
>
> >               "                         [ type TYPE ] [ to PREFIX ] [ FLAG-LIST ]\n"
> > -             "                         [ label LABEL ] [up] [ vrf NAME ] ]\n"
> > +             "                         [ label LABEL ] [up] [ vrf NAME ] [ nomaster ] ]\n"
>
> make this 'novrf' for consistency with existing syntax.
>
> Similarly for the other 2 commands.

I think "nomaster" is more fitting here, because this option only affects
interfaces that have no master at all, so e.g. slaves of a bundle will
not be returned by the "nomaster" option, even if they are in the default VRF.

I'm planning next to add support for the "novrf" option which will indeed
only affect interfaces which are in the default VRF, even if they have a
master.
>
> >               "       ip address {showdump|restore}\n"
> >               "IFADDR := PREFIX | ADDR peer PREFIX\n"
> >               "          [ broadcast ADDR ] [ anycast ADDR ]\n"
> > @@ -2123,6 +2123,8 @@ static int ipaddr_list_flush_or_save(int argc, char **argv, int action)
> >                       if (!name_is_vrf(*argv))
> >                               invarg("Not a valid VRF name\n", *argv);
> >                       filter.master = ifindex;
> > +             } else if (strcmp(*argv, "nomaster") == 0) {
>
> and of course make this a compound check for novrf.
>
> > +                     filter.master = -1;
> >               } else if (strcmp(*argv, "type") == 0) {
> >                       int soff;
> >
> > diff --git a/ip/iplink.c b/ip/iplink.c
> > index 18b2ea25..f017f1f3 100644
> > --- a/ip/iplink.c
> > +++ b/ip/iplink.c
> > @@ -119,7 +119,7 @@ void iplink_usage(void)
> >               "               [ protodown_reason PREASON { on | off } ]\n"
> >               "               [ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
> >               "\n"
> > -             "       ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n"
> > +             "       ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE] [nomaster]\n"
>
> this line is already too long so add the new options on a new line.
>
> >               "\n"
> >               "       ip link xstats type TYPE [ ARGS ]\n"
> >               "\n"
> > diff --git a/ip/ipneigh.c b/ip/ipneigh.c
> > index 95bde520..b4a2f6df 100644
> > --- a/ip/ipneigh.c
> > +++ b/ip/ipneigh.c
> > @@ -54,7 +54,7 @@ static void usage(void)
> >               "               [ dev DEV ] [ router ] [ extern_learn ] [ protocol PROTO ]\n"
> >               "\n"
> >               "       ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n"
> > -             "                                 [ vrf NAME ]\n"
> > +             "                                 [ vrf NAME ] [ nomaster ]\n"
> >               "       ip neigh get { ADDR | proxy ADDR } dev DEV\n"
> >               "\n"
> >               "STATE := { delay | failed | incomplete | noarp | none |\n"
> > @@ -536,6 +536,8 @@ static int do_show_or_flush(int argc, char **argv, int flush)
> >                       if (!name_is_vrf(*argv))
> >                               invarg("Not a valid VRF name\n", *argv);
> >                       filter.master = ifindex;
> > +             } else if (strcmp(*argv, "nomaster") == 0) {
> > +                     filter.master = -1;
> >               } else if (strcmp(*argv, "unused") == 0) {
> >                       filter.unused_only = 1;
> >               } else if (strcmp(*argv, "nud") == 0) {
>
>
