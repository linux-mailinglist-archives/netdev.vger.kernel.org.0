Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE235496DAE
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 20:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiAVTq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 14:46:27 -0500
Received: from mail-dm6nam11on2131.outbound.protection.outlook.com ([40.107.223.131]:23585
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229534AbiAVTq0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jan 2022 14:46:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIbyabuDJQOzE6hq244K3Yw+hLwHCrIag1Nz9xcfKgjqq2N3ID8FORTSYvilvRU0Dtqf7atCdBz6s3aq2dQQuUkJJB51qZH1cdjU+W8tQvOPkelg4tAlaCCRezgpz6wmLtZW+tMXYK1oaSNhFBAYjffLGbZvH7BFjy5nKas9ETLARriSb8MXDNDvRhsznEJQGpPrYKNguM5KGovg4HvwWgQg7KXOQruFrxjLoDpPR31YsuxEtD4LkA2jISRX/uLotCW4/MbmMKmEMpzWvKIpeVOVKkBJI8Oc1GZMWEPEbeAdOcnqiBvsxMBhp6BfqxaswsgN8J3DIAp0GvfpyKOnDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+A8I0IGmsqYJ8c2Hy1RY7N1zsNxbKFBser6ZyliCTg=;
 b=aLAhzFfFUjWnQo8CCQ0xb2UcaewWx2J/T00y+QWQi91MZOWi+GcJtjOI5X6iRe0rPWInocxD6doyJKtgO1tzKq7DPE+rRBvugkYSoOfzkE720VvGKc+5l/8MM3AQcXRc52d7AwTgCwexpr7vVPa8+ObnwCqO39d4SHLiLRexNa6YK198r7rdiP75xOUBGsmV4dO6VBPrtgJJhGt6YcOqKqic5JC2zpCNdtKoAXOdOa/NSJXh8AjnKuooEhin6xuqWzold0YToHcEJci9F58ULqtZAXug37T0GuyPr579X1+2/MBLM/MOHLkS7uU02ADWcqm0b7PjlRylkH5XrjbAXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+A8I0IGmsqYJ8c2Hy1RY7N1zsNxbKFBser6ZyliCTg=;
 b=EMDAgTETH+0GOnYTxMVOSAwxA1Yt8yZWpD5fzFvclFjCmbvG5tjZWLvNhFqeah85C2bIe5nAiyhF2s7r6cn+2FqVRRE0teD7qTgve3AJ84k48str18fzAy55cpyufFAFqKeIS0Mtd43CAljLtjcDgcLhtRSJXJZQ1BTjABmSfLA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB2045.namprd10.prod.outlook.com
 (2603:10b6:300:109::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Sat, 22 Jan
 2022 19:46:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4888.014; Sat, 22 Jan 2022
 19:46:22 +0000
Date:   Sat, 22 Jan 2022 11:46:15 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        brouer@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [net RFC v1 1/1] page_pool: fix NULL dereference crash
Message-ID: <20220122194615.GA914030@euler>
References: <20220122005644.802352-1-colin.foster@in-advantage.com>
 <20220122005644.802352-2-colin.foster@in-advantage.com>
 <CAADnVQK8xrQ92+=wm8AoDkC93SEKz3G=CoOnkPgvs=spJk5UZA@mail.gmail.com>
 <20220122024051.GA905413@euler>
 <5bd8f1bd-1a21-df1b-6d6f-9fe5657fdd7c@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bd8f1bd-1a21-df1b-6d6f-9fe5657fdd7c@redhat.com>
X-ClientProxiedBy: CO2PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:102:2::19) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0dbb78b4-6c39-4bfe-0f04-08d9dddfde29
X-MS-TrafficTypeDiagnostic: MWHPR10MB2045:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB2045FB3E61F1ED7CBF4EB3BFA45C9@MWHPR10MB2045.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CMXtSE31axv2igiPOCZmAcTZsefoxCwewbDBgl47QN0gAF0Hwvyd4ZkFSqRixd993z1bA59TWOWOhM6MfPM27ZyqCZxn8/+qBG1CuRnbgeyBx0856p7Vqh56V7xIMtwz+77M6xRqKr6rn37FKcWo0u32ZNxoFanWYl86RjalyM4MsLMc28vCrsYYJRqeA+L0HcB9n1gpFXi624Lfw8R7lXKR9ObrARnV5C4vnCZonW08ds7ao5s3aRWHLh8ogo5vz2m6kHvZZZcs2hgWzsHr+26Q3/fl5dVFH2YZ5LwJUeuUjfzSzip/Z7Im1oIW9GmyOGv+7TEh6JZZWFO83Bu/4TPpCsvaX4mMZyHvL1ImCu9VXk7jV31ugs6IhBP9GbJQhqux7poxs/HU3a9wr+2nXtPW6ttWf5T/F4QgeWYPfcN/nFHB3SIHQJ4ifnyRP4M4gntlvGO6XrWBZVoz99RwyGRMixbqhfYe2PZPMI/xf2lt/zFeFzvpgb+fEnR8cYbl0nz2IDVofa6maCIsJfU/U5I2MqFO/SbkdH9r7WJQCVTfaKwuYTx2ISTlAUkDft8NFoBvcBkRuYpY/dhi8hGIUuXqT3i4c910x+HhV/7wzD0JU2WPKJGluKwALFCjrPUTtG0ktoyxDH9VHesiU8w1d9X+pdsZiZiCVgTpHMButujgU+6gSDVX4bHvBWY7HSgMsiNft/tFcesGzYIgMv689w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(346002)(376002)(42606007)(136003)(39830400003)(366004)(396003)(66556008)(186003)(38350700002)(6916009)(54906003)(6666004)(508600001)(5660300002)(26005)(7416002)(38100700002)(52116002)(66476007)(316002)(2906002)(4326008)(86362001)(6512007)(33656002)(33716001)(53546011)(1076003)(8676002)(66946007)(44832011)(9686003)(83380400001)(6486002)(6506007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g37wnPWBzgnlt0gKipfxvkxOrng65aP28eRftOCIQhtItSSaE/hs483unb/A?=
 =?us-ascii?Q?Hk4Yf/KS99JYBhCrfz9bWM9L7AMxK9oKeTV8lvBEgGwA/ArEYp4wC6t1n/Bd?=
 =?us-ascii?Q?1pB0AewCMcShR7820L4DibTLyINabR1QKmoRkkO15/sgLkIfQwy2eM/RaoQh?=
 =?us-ascii?Q?UAOUqUPUM6/2ruUDTncRQ6USnwWi5EhD8E3PG38y2HOBbBYKgl4tDOJG7WbU?=
 =?us-ascii?Q?7eUuAY3ksmcbMG5Z/EYOxesLVhpaYfPORKtQ985Wzc1kHRioDgyg0l8mDLry?=
 =?us-ascii?Q?0EIUb7qdW8piVzFz4CgTsLI8rlPst9u4mfF5ImiS1F8CeHs5XE3UxlRvP9Dy?=
 =?us-ascii?Q?xf4gQIUNW5L8rgQU/szJmiBKar0VU2GmPDJtO6349T1zEu6K5/amSCdNfPXa?=
 =?us-ascii?Q?dd/+pQ4k99b/sA0CoTDuu4s8pbBxVjsGBqFgGWbivqoobe80Derb3f/IJMmN?=
 =?us-ascii?Q?mgRfpbCm/YV9Y2EYGdWqdFmHkw+Fotm/E91bCSkDiTPs7M9HHddVlySBLJQY?=
 =?us-ascii?Q?69X76b5NpzQpyKc+2g5fcHSBLE218qe+kbf2Oz7dN8GAHmMsl7klPcIRDO/9?=
 =?us-ascii?Q?nNE647DmeB0WDZQ6GNNyZAXurLvwOSwBslwpacq1klOMPm9dnkVmaBf/lbBt?=
 =?us-ascii?Q?qkDRO+UbqjEL6mb1bj5aAG0WWq5JT+9brR4rU7nMzKPbJ+6FIB2I1V/W4L6L?=
 =?us-ascii?Q?G+MmITqXbTVO6a+wWvWVdufxpAjUY5+/sfssps0MZ2V6RWw6tD//Jt1yGTuJ?=
 =?us-ascii?Q?Y/yRNtI/QS2dY7tBbQlLuKD99O73TJZman+9RJwNDtPrf7YwMln7o/JYhZ3r?=
 =?us-ascii?Q?NFHBHjrhEuqp7O2G+mMYZ+xgU9GLT2J3FQbAfcMrwaKzuGSsYGdtZgrLvVj+?=
 =?us-ascii?Q?bkRwmaveUE76yZwiKVvLDYKsp1PMtV6KVabl+l0tM1V3y+VSo5q4VHkaJJFB?=
 =?us-ascii?Q?MBJ4Ps1XKVON6uOOVgfmHiO74+62amoau88DkxwVJiP4V+kHpRWGNTRy4f+S?=
 =?us-ascii?Q?1HtswftGxdaGzf3MDlmxPgBTuPfEOEmcwwYjE7tXECkOGAGDDrMhsCNh0l4L?=
 =?us-ascii?Q?3LnXVdcT90M9zkYLEeFNYje1ELgEwquRqP4DlE0c+LkaEug/ZRadgcziX3qX?=
 =?us-ascii?Q?JMUnXzmSldjbu6m31rjMkW4w9QsQ7StR3tU33F9MfULY/pWJ9OJalXUMce7W?=
 =?us-ascii?Q?l7H2Ft20TPL7FxymnYsJlPY7F4urZTIcIlE5jSDJ0NVIx+mG5a6srjBAUToA?=
 =?us-ascii?Q?g1psbafvp+9KP2b1rYDsMJOJXButzjQRHsR15FspcdogAKENC8KNJ5wu8C1V?=
 =?us-ascii?Q?nWRpFTQErwvfs0GnLruAWqso8hkptHZuxI6fvweu/YnKk37bvSdPNu+UmB6k?=
 =?us-ascii?Q?k6BWu3ztDg8QxlK5mDU1KT4tLL3a0g9JqZJPwiu2g8bpCPZ/cDkDvjbKKqXZ?=
 =?us-ascii?Q?jwtAX0hCzwBS8/DbAZD4oa+f3QnbuNNkdD5FMjIhmQMZEtD/6NUNjExBWrfi?=
 =?us-ascii?Q?cxLBVvfSLrB8lronWAvWBYdMApsyPtX5F2aNSwoBoFUxVlkVgBKO6/L+Y/IV?=
 =?us-ascii?Q?qWQDOgoa6Auo+/eSY1xhf25WLyFaBayLzTEf4L2mlQJ1HdNLQh2+W1scdTfW?=
 =?us-ascii?Q?S6Bi3tpToBvp21nmfITdf2HDbGYaHuBP3tTifIdqmPXps62uge3a794NrRBu?=
 =?us-ascii?Q?ItzeDg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbb78b4-6c39-4bfe-0f04-08d9dddfde29
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2022 19:46:22.8063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ca2aztkyd+0WzWlb2TlfL4H7yKvLXj+GKnW74P+yMOw5zx/6jQTxxRtsP05qn+uCCf7nRoNA6SRSlpnP8y7Nx5xsENU2VzmhJBHdbZxH748=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2045
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 22, 2022 at 09:31:17AM +0100, Jesper Dangaard Brouer wrote:
> 
> 
> On 22/01/2022 03.40, Colin Foster wrote:
> > On Fri, Jan 21, 2022 at 05:13:28PM -0800, Alexei Starovoitov wrote:
> > > On Fri, Jan 21, 2022 at 4:57 PM Colin Foster
> > > <colin.foster@in-advantage.com> wrote:
> > > > 
> > > > Check for the existence of page pool params before dereferencing. This can
> > > > cause crashes in certain conditions.
> > > 
> > > In what conditions?
> > > Out of tree driver?
> > > 
> > > > Fixes: 35b2e549894b ("page_pool: Add callback to init pages when they are
> > > > allocated")
> > > > 
> > > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > > ---
> > > >   net/core/page_pool.c | 2 +-
> > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > > > index bd62c01a2ec3..641f849c95e7 100644
> > > > --- a/net/core/page_pool.c
> > > > +++ b/net/core/page_pool.c
> > > > @@ -213,7 +213,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
> > > >   {
> > > >          page->pp = pool;
> > > >          page->pp_magic |= PP_SIGNATURE;
> > > > -       if (pool->p.init_callback)
> > > > +       if (pool->p && pool->p.init_callback)
> > 
> > And my apologies - this should be if (pool... not if (pool->p. kernelbot
> > will be sure to tell me of this blunder soon
> 
> Can you confirm if your crash is fixed by this change?

Yes, this is confirmed. I'd obviously like to make a more comprehensive
commit message - my main question is "is this an issue for all DSA
configurations?" Seemingly that is the case, but like I said, I'm
unfamiliar with this code. I'll see if I can get a better understanding
before sending the real patch early next week.

> 
> 
> > > >                  pool->p.init_callback(page, pool->p.init_arg);
> > > >   }
> 
