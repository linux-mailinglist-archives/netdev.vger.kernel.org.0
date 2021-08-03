Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC583DEC2B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhHCLhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:37:19 -0400
Received: from mail-dm6nam12on2109.outbound.protection.outlook.com ([40.107.243.109]:18528
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235907AbhHCLhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:37:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jr6Crt5EslP+tLI9OyjxN5XAf3L2InL/xTqdpXFea54H8hpnjxJ7hOObrnsHTMeW8pPVMn/Rsy7Nt7u9YQyxq181+TUxR2Q4T7s8PIoijrIGdZGqArBKDcuf1/1BRhYAvP+cImlVrbQLaZ7ySpJeSmru989SwDV4w8j/5o/jP0DvI3IRLUCtBMWEnpDDgLXnWxh7cKaIQ9FapFFuQPd4P7zRNb/fqzgVfrS21emPk4AvlVmwNbtScPO/Luaw+KficIVTvzcyuFr4dzQlcUcVzDzgLe4BU723gzkkOClrhlBYiw+dKMKMNC8jbA2C4oVILTgLGgMDUatKyevZMBPSkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRPbo78WRY9onSULSK0PxO4Mwa/6dHghRhlFZTTOkuE=;
 b=R8xUExttEUcuXVloaGroNeW3CAPomZ4l5lKScTKh7HEI1LdNiC/ChUfKXveL0utjzPT/IJ/FHdb/IQY+R4xynyDgjkF6BL7v9x5d6rgrIaQagrx5m7ySSxbTJf/KGxWTvf5hjt+9ESEomIop0NaloDLKZp1GkaNbPG/3OiweMrfyZ7oo91EJjFhoSow/KfECr9u9hEpNSgVU0BnSH7PdX4H5bzqpej5TXAroDkggPYYU0nHaCjweqIM36GVI1qS2UZ6OQ/ZpVvmBYxRB2bX1tlO4YwvEbTK1Oid1bnRMlFSv6HOt96sh+zKUcFFX3M9qK09kxVhmD5LuPjqcNEQRVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRPbo78WRY9onSULSK0PxO4Mwa/6dHghRhlFZTTOkuE=;
 b=vxmMyoRbxjiqlBhky6pKkztKScBWO/2tEB2g0KSHqtJS+eSt88xl98Evzn2yy2YA3QvQYplQxtOmIbGdLbnAfPjliLkvZBMGwnd5oLUD9ndXyKCz/60cTpkqIqes+V/2BwR7J0DBoK+UFG/Q0dkDSBPHM5XuXOsRFX+XjeuOCfE=
Authentication-Results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4891.namprd13.prod.outlook.com (2603:10b6:510:96::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.12; Tue, 3 Aug
 2021 11:37:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Tue, 3 Aug 2021
 11:37:02 +0000
Date:   Tue, 3 Aug 2021 13:36:55 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
Message-ID: <20210803113655.GC23765@corigine.com>
References: <20210727130419.GA6665@corigine.com>
 <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com>
 <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
 <20210730132002.GA31790@corigine.com>
 <a91ab46a-4325-bd98-47db-cb93989cf3c4@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a91ab46a-4325-bd98-47db-cb93989cf3c4@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR03CA0107.eurprd03.prod.outlook.com
 (2603:10a6:208:69::48) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR03CA0107.eurprd03.prod.outlook.com (2603:10a6:208:69::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Tue, 3 Aug 2021 11:36:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e001c7c7-e750-4424-dd76-08d9567302f4
X-MS-TrafficTypeDiagnostic: PH0PR13MB4891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB489115E5DFE2D391BB7AE7CFE8F09@PH0PR13MB4891.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s14kqughT0xGi59o22N4DC/8GQGoQ2+s6xmBGph5x9eka9mWfOoo37dwbUbBv0yvwgxSQIf8fwX6hiHuPoLpigdhq/yET0P0PL/vP0xL6wEbrl3mfkmL5a2TYuJGs4HcG2WmwfDClZVDj2DWz2O68RxukG1+LnSLERvXbNzDZEPAj4e1ipQkePWHzn/kAbbKoB2YQfgplPAtA6M78B8jgiXJ/GsAog9eSYSc3HFV1+Cs/w39Mf/qLN3vGpDIf6Khm6bNT8xjn1iFPpc9ow8YN7aZLZxvLnZJaFHHPAGiykv77JeR+s7/NuNGh3RyvYx7hQy+L2JDlMHbPhIJ+6keB1HKyd7mVMWq5xIVpMvFgKDRIlAWU4G3HUO4C/t3AiP0MjRo4qbhCc+BbOAjD7OS97RJNxToDYkTU6YsMjvFLyveJIyd8hhgjjW3wrBFAB5/tbIWQRiCIHWQD1qOp7QkBEuwfjclq8/GH9al2D7TazYEihBq7Ga4pURzXZrAzeJwbwwCMQQh2jv2Y8IcGygs8AL0K3tPjklYorf8PV61JKhcYxoClda/F87C9LhmL5FKb+N63vQWEJtLsPRE9hm57jnsalSculx6UZesz2iaBFOBWMhhNVlaMh0wm6yjB16tm3T4rZMEJUfogtzRh04Uow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(136003)(39830400003)(346002)(53546011)(83380400001)(2616005)(7696005)(44832011)(52116002)(36756003)(186003)(86362001)(478600001)(33656002)(66946007)(38100700002)(66556008)(4326008)(316002)(6666004)(6916009)(1076003)(55016002)(8936002)(66476007)(8886007)(54906003)(5660300002)(8676002)(7416002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PBg43BEy3Ib6BuYYj54UJqpsad+Eyh42qe2J2GhhVNaYFe12eC5DXCntFdN2?=
 =?us-ascii?Q?hYg4dlwhoeTW3+h4WmVxK1EgyYkTWpa+7q8jIZYyx3r2fu8nKw+Aeuhw2c77?=
 =?us-ascii?Q?xSSrIS2mbcSfGQoFRoI8eUGw16MIPRhZB6VbYp39HC9yYtOGBjJwvRzRrgIq?=
 =?us-ascii?Q?3sxlAnCkJ5tmEaB0gmgjvFVi7mim4jUsWZ6d0SdysF/4DJvf0HvyZ0BnRc28?=
 =?us-ascii?Q?D/UcXJWsOh/liD+IscKRRo6/LXQXwHwfq/HLUtVnZZ4E1rzWYWTJ1SLABl+n?=
 =?us-ascii?Q?695PtjFjQcxBuD/iYZo4XDnj8uopgIrRnK56g8Ntl8zfb+2qa6mLEu0AwsOk?=
 =?us-ascii?Q?mx5ywjXiB+XStCe4GmztcPFR3ja3Z11wmWusF49dtFn7/g4tmppX3ZI9n3j+?=
 =?us-ascii?Q?pHGJGRq5K29gvq+XF5a9kxTqJFYTiSYVqjFKqZaQ37DkE0A5nqUgmK8aFFuJ?=
 =?us-ascii?Q?Jbq5R/htt75Y0kxMEulYnMutCLZGWq+h6Ld/+/BfGQR36voc5GTM2JIioMp0?=
 =?us-ascii?Q?QOt828TNBbVQiCswWVZln8Lx8n8FI/qAtR8RcO+JP2hCGV6JBwmxUMY9mXE+?=
 =?us-ascii?Q?XtK1F6Yy+3r+WuiRraOPsmZM3OWRQIrkKgCAXuR+Ex6pR850/9gCY2/Y1TO3?=
 =?us-ascii?Q?G8XEOWr/H+D7hR/p1s5ZFQjyVA93KFvDWURqOiAyA3pxfCmwf7t0dkg4kEoW?=
 =?us-ascii?Q?VGHelVpDCAYPG+NPLDXTDATJGYbMlC+9eEc/3i/mk6phSqm3g0fJOCEpvwhx?=
 =?us-ascii?Q?O9OGKXerjeIYSgnZDthIFjYztTHDIvjpU1O6RuZ37i2zo55OCyBS7dV3AgBy?=
 =?us-ascii?Q?WOJpqeXbasA+0MU6JfTocoH+RVZHZhTnngwFuDz/2tlk97M7Oi6gIOTIoPb2?=
 =?us-ascii?Q?DEeEZIsmyoDigX3IlWVJwHm2iq1ZV5P9GSeWddScuXmQVQRGr/t32P2lZTS5?=
 =?us-ascii?Q?5Ea9Ot/zf2balfRBB+wkbHIfoBrTi/VXmbUoTKapqIhHnmgFcHlcnyJw8Vph?=
 =?us-ascii?Q?QG3yNn554iXv7c/9Z+veHcWox8URWchWXy9s3ul6V5H+Rb7lGOyvxmPcdTnz?=
 =?us-ascii?Q?4qjJaXOS6fKjtgdo7sGzNiGxHKERDSeTPryOm+urnxSNmHOSSDTTiw72scLP?=
 =?us-ascii?Q?27lNEeuM+LU3NQ5K/iJ5nxi1wiBjfeY19jOLPTzdrGN2R76syb34xt6a7kpx?=
 =?us-ascii?Q?ZgWq32A/8BPhs6RTb8Hgs6Dp2RHvSYwrUeHtQV/1Yho79e5yh3M3DH5Zr1Hf?=
 =?us-ascii?Q?uSkVd/RYwUekDTIRwiy3/bBf8WYW3x5h9uL1HsWRbzgRg/Xk2158I/pS9vEZ?=
 =?us-ascii?Q?U9+k8p0knCbkSg2mH75RRAxFhiN7aglzlQdwGXYfP/54h2+OLgC1WQORmLCd?=
 =?us-ascii?Q?ySyQ9ThzXQioNl5/D6JSS6uRjm5Q?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e001c7c7-e750-4424-dd76-08d9567302f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 11:37:02.1560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LqgAKV5O6I+8hjq4ALywgHmliEVMKTM+9UW72TsYlI4qIJ7FFeL6pauYf+Xe6vI8xNweB9lgcxLr6Ajy3BImP6LDmclqNB8oKTtGHe7SeRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4891
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 06:14:08AM -0400, Jamal Hadi Salim wrote:
> On 2021-07-30 9:20 a.m., Simon Horman wrote:
> > On Fri, Jul 30, 2021 at 06:17:18AM -0400, Jamal Hadi Salim wrote:
> > > On 2021-07-28 10:46 a.m., Simon Horman wrote:
> 
> [..]
> 
> > > It still not clear to me what it means from a command line pov.
> > > How do i add a rule and when i dump it what does it show?
> > 
> > How about we confirm that once we've implemented the feature.
> > 
> > But I would assume that:
> > 
> > * Existing methods for adding rules work as before
> > * When one dumps an action (in a sufficiently verbose
> >    way) the in_hw and in_hw_counter fields are displayed as they are for
> >    filters.
> > 
> > Does that help?
> > 
> 
> I think it would help a lot more to say explicitly what it actually
> means in the cover letter from a tc cli pov since the subject
> is about offloading actions _independently_ of filters.
> I am assuming you have some more patches on top of these that
> actually will actually work for that.
> 
> Example of something you could show was adding a policer,
> like so:
> 
> tc actions add action ... skip_sw...
> 
> then show get or dump showing things in h/w.
> And del..
> 
> And i certainly hope that the above works and it is
> not meant just for the consumption of some OVS use
> case.

I agree it would be useful to include a tc cli example in the cover letter.
I'll see about making that so in v2.
