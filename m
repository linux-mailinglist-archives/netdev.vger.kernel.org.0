Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D1E442E5A
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 13:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhKBMmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 08:42:44 -0400
Received: from mail-dm6nam12on2124.outbound.protection.outlook.com ([40.107.243.124]:40928
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231366AbhKBMmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 08:42:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ociel2aTsDmsgQoYIxEHkOO0rhUGvAC0T//C8gg7p7URVoA17qRS0tJEuqslj3Kori8hcEBRyXtLV5BWYc5Z+A1mHNfGxp/4Mz6HP4nrZHjLrPYGUC3YAaYZyCbmfaPolJi3xSk8c6vcx9z3N02qsFdWf54m23lF7Kkh+eSTH/y5CdKBphVev8BAQeAZID+dPct08rJpHV/ruOxj2580zx/vKutdv4bdRsmWL5bZG6aSPD7iTdvAUy1gWtBm4DdDSSVs9vA2/jHXRg1J35Uw2TfHa+Wh2Xv56kfe65xwoshrdQ24B3d4wMFVcMitqLeAYr2O4ooHxI4U73zUtPvz9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGEwmyKa1Jzzl/Op3sElV3sp/z1klqu+HLZZrWitvYo=;
 b=jJndl87qGPuR1iE8k+IfJLyc7R3q29vUEBwsynfZwNLk9QJ/DAmpyuURtLjM6Sbc+7habShpR8Nd+e27EBdAHNZzCjqVR0HXqTp/ywjmCdODsD+K+40+/oe1Qkij3idG54dWmDN6GzRwwe+Yz4oPHzHzqjB3I/x9bAjEWmJ7pB5KI2LBw6/mn+Xd3Ib6QS6ngQZPSIqAqLwEZ9GbMv/cU++811R0JGl5WUgivUXIZjbJn+8ZxpepfN3t6b5cYBezQ0n9F/904J2vm2qS2fsTWsQSO4IjA7KLE+qAbw46rPI+ImDj3e7I8w88ZZmyGuJzRNdludxzumYfNsVu2Ji7kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGEwmyKa1Jzzl/Op3sElV3sp/z1klqu+HLZZrWitvYo=;
 b=L/0ROIccXdtl+O1BytnA8Q0IdUkrYeux1tJkIlkC5bfAgJYxIAhm/UQtIRccnfzXk2Xq77sBjNRQ6mE/qfPFfdCfGOWqi2x1kTHRmlsnU+IQvKNjEdo7ArY29h92/eilY+L3u9x34Jb6oQkGPxBA9ZnkAQbx5K7UXNbP5+Uv6sg=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5616.namprd13.prod.outlook.com (2603:10b6:510:12b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.8; Tue, 2 Nov
 2021 12:40:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.010; Tue, 2 Nov 2021
 12:40:06 +0000
Date:   Tue, 2 Nov 2021 13:39:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Message-ID: <20211102123957.GA7266@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
 <ygnhfssia7vd.fsf@nvidia.com>
 <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
 <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <ygnhcznk9vgl.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnhcznk9vgl.fsf@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM3PR03CA0053.eurprd03.prod.outlook.com
 (2603:10a6:207:5::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (80.113.23.202) by AM3PR03CA0053.eurprd03.prod.outlook.com (2603:10a6:207:5::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Tue, 2 Nov 2021 12:40:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f504305c-5892-49ab-92e2-08d99dfde5b3
X-MS-TrafficTypeDiagnostic: PH0PR13MB5616:
X-Microsoft-Antispam-PRVS: <PH0PR13MB56169D8CE238DF6A392AD130E88B9@PH0PR13MB5616.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hdN4q58FOB6oJBDZWu03flxg53PD5S6prZPXcglw+lgfvRZHBBi4TOcbpc26JKUYVlQpbhrMmAjGITfk+gWkQeV7YtFGZY60tdrOlHXK3pUjpGsMIQn87VxrBMpwfATviLZhnbicJlVgZ1le6aP4srwDrwe5c7NQblSQd/yCLMiBY3AyROCNQxeMFu9hUA5gSGlMAxHm2OX5k/cXzipsyzUHwKjQgUl4qwG1Eg756OU7qUSIb4z8Kz+6jUEHNEO8Wk0+wTNw1Ia4SjEueOBNxH5/hawSGjShWjdlF0wJU6idzay/bJyyCqt/QLslLQm3rK+MMckrYCt8FB4DVzDtYSqKirN2ci9ra5SOpxLyA6PGJONDS/nIPSATmI5zIeYsFIsy6uCv/mTcZsi7hIJil42gFjVaR38K3578fBMWf0mMW61fvKS+ss7Ado+JurHqQ4MP9GhDx6s7StbZYek0yu1mDKhV6Jlt7VcYk0kiyRbCaH7p3NwdMalTmMNRJ8pWRdc0N3NCGP+7dMhsz7guopUcbOKNwlM8jhRCsvZcvOugMG5N+29jxnPy7LVObZajOafpU4zq5tuyXQXhoZmAMV8nfjaNeHdVau2HZWo8yH7wOJyBwsV0oAQ6wFh17XfWamlCASKhdHwkcHxsAfvh19c6DDz6Guxgy1f6ZIvjhYPiDCH/Noe2YG2sdh/HXU6rMBszp/BLv/GdmwyBgCvpkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(39840400004)(396003)(7696005)(33656002)(8936002)(8676002)(52116002)(6916009)(6666004)(186003)(55016002)(4001150100001)(316002)(53546011)(26005)(5660300002)(36756003)(2906002)(86362001)(83380400001)(8886007)(508600001)(15650500001)(38100700002)(38350700002)(107886003)(4326008)(956004)(66556008)(44832011)(66476007)(54906003)(66946007)(1076003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hauSKh6Qcf7zhEXs4E9olMQt1Uf13jdc8u2q/abShuCdVk79S86s5gbl1/+W?=
 =?us-ascii?Q?PkLX0gHiK4BdvF6wMGkXgmitFRTBbGQzV2ktvKycj1cJzATTnZno7Xvt98RX?=
 =?us-ascii?Q?ZN9obJjvZC3HAPT+A30ZsGz/662JJ56g39oHfdJ+dqu1C7MBRjy1LXGsx0XV?=
 =?us-ascii?Q?uHAJHwhveoOSWQuzM6KYc+GZGxNcsQkpbBoWUq5ADgG0hnbwCsYOXCo0ibW+?=
 =?us-ascii?Q?ThGjk/z9NPyIxvXbSbQ4Fe6sHCXekhg9pCr3vS5A8ds9EGXJWuoGoJTFVuRN?=
 =?us-ascii?Q?+vvjoSAW96IxNlWCj+yAi7gB8UmlitEiiB2Ssd6eq6hPT7359Q+Jz9iuus79?=
 =?us-ascii?Q?i4mgsubRAZHFY5fgmd0To9PioixJeajxHpAWnmYkX5hfWqmeHCHx76pR8aIW?=
 =?us-ascii?Q?+WNdgTafTZ7tH+1j0MZn8iZPLd9kLfaimeAJFnwLvy3/KRaZP7c/RiQttPDy?=
 =?us-ascii?Q?MJZsJj3ym52CERuH37yQ+5eZXhBwPFq5e6cjEefJYdYEopmNZpG+4vL6g1ce?=
 =?us-ascii?Q?ju3lRBIzn51Oqpe80ENZk0d2HoCALeEfVtzqewe6gLbEyk5RuGUKlDuP/FWS?=
 =?us-ascii?Q?/l7ZgkavFoNYR3sJ3hnGsJN7nhw296gE7cru7l1a2f/h7CiFpfUs39kES+aD?=
 =?us-ascii?Q?sjxgb+K3cqQpDCfeT2lyZJzRej0vYd96G+mjoxT3w7AHUExgNLFFL6kXD1JI?=
 =?us-ascii?Q?UHkoC5xC9DAvvdyRW/UZ5cXEizrowSdoru1BOYpT4jnBnL8Z7C4fXAvZiWng?=
 =?us-ascii?Q?fswvmeK1GWTuufaX55e0NIR4SjlzEJX0PX1Szi5XFC8jeXfQbH6NyfkxfORS?=
 =?us-ascii?Q?1ACXfOEYitsUi30o5aptzS0243HUC6snnX/wIWfWTirXXg3yCR0hZuG90RQ2?=
 =?us-ascii?Q?dSWNZZjr5qnLWVvXjWRo9ZS+xah9HPv8F3uXesILHOWEg5o5ojxDIFh7Emwk?=
 =?us-ascii?Q?CjHx9DsPBUn3Ap6gwFBNLKqStTGnyjGd/TgmXhlPsyU61ZLPkHvEjFQuv3eF?=
 =?us-ascii?Q?XYte6ykoix6FhkbE7C7fS1dId9DkZ8TBbGAtkYHdii0JHYoyw3X0PkDWicUs?=
 =?us-ascii?Q?XuBlIXnRUrXA3u+9cbJHC1BMRK+O4AEjS7Y8GY+v9w16TOEAkZ3qztOHhtaN?=
 =?us-ascii?Q?VmDQ+rbUkmmAhhiGYlYvjr22oiguYiFuXuw1JYU8cPrUBXSJsmY6Krefvb0r?=
 =?us-ascii?Q?ppi1jENUg3UTGTc64vdEMHhm3SSI+zh1wr0K7fXwzVcXQvNWHy7nrGnrecmo?=
 =?us-ascii?Q?dK9mMIADHJnF/h3pxc67uZ7wgist0OXNvfZzfmKOPRlCzhilLbAcysy5MM5m?=
 =?us-ascii?Q?asnN41Klls9f7Yhit0KLysY3ightA9OElPDcbw7XMo39+a+qd4qmU27fuS5B?=
 =?us-ascii?Q?EpKusn3KQ2kFfrqf3PYi2xXNP6EKkU2lw4BM4Apf9a4KiMBu4Sm/WyJwFPi+?=
 =?us-ascii?Q?uXLV5ekXk/lQJ1Iwmjk3WlLBwthW6QnbF3DnAkXJKuWw7Dzo6f2/ZnyFz1Hg?=
 =?us-ascii?Q?ljic6a/GWjCL8ujNiz3jJ/oRR86ycOZ0Ecdyzro/JRkg/sMONBs+QMXimnnY?=
 =?us-ascii?Q?eSJhaIG4+IA4YV/eWsgrwrH/CeZQpgFA3tR8n361zw5wzhgC46ljRJpz7BCb?=
 =?us-ascii?Q?FLjPnhwNib0b2X7uq4vJ5iq5gSLjidDWdhQf/FDBpf44GvX2qc7rnlG3NecW?=
 =?us-ascii?Q?4+K8RQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f504305c-5892-49ab-92e2-08d99dfde5b3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 12:40:05.8540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QmfKMqHRAxFRwuwmLap/o5q3uMeVdnLHwfgN610xKaC4TDXLgl0GvNycv4oQGT1bTFH7fe2MUUs9prYapwZxs5AHBxaCXSqchpZqDQX30R4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 09:38:34AM +0200, Vlad Buslov wrote:
> On Mon 01 Nov 2021 at 05:29, Baowen Zheng <baowen.zheng@corigine.com> wrote:
> > On 2021-10-31 9:31 PM, Jamal Hadi Salim wrote:
> >>On 2021-10-30 22:27, Baowen Zheng wrote:
> >>> Thanks for your review, after some considerarion, I think I understand what

..

> >>Let me use an example to illustrate my concern:
> >>
> >>#add a policer offload it
> >>tc actions add action police skip_sw rate ... index 20 #now add filter1 which is
> >>offloaded tc filter add dev $DEV1 proto ip parent ffff: flower \
> >>     skip_sw ip_proto tcp action police index 20 #add filter2 likewise offloaded
> >>tc filter add dev $DEV1 proto ip parent ffff: flower \
> >>     skip_sw ip_proto udp action police index 20
> >>
> >>All good so far...
> >>#Now add a filter3 which is s/w only
> >>tc filter add dev $DEV1 proto ip parent ffff: flower \
> >>     skip_hw ip_proto icmp action police index 20
> >>
> >>filter3 should not be allowed.
> >>
> >>If we had added the policer without skip_sw and without skip_hw then i think
> >>filter3 should have been legal (we just need to account for stats in_hw vs
> >>in_sw).
> >>
> >>Not sure if that makes sense (and addresses Vlad's earlier comment).
> >>
> > I think the cases you mentioned make sense to us. But what Vlad concerns is the use
> > case as: 
> > #add a policer offload it
> > tc actions add action police skip_sw rate ... index 20
> > #now add filter4 which can't be  offloaded
> > tc filter add dev $DEV1 proto ip parent ffff: flower \
> > ip_proto tcp action police index 20
> > it is possible the filter4 can't be offloaded, then filter4 will run in software,
> > should this be legal? 
> > Originally I think this is legal, but as comments of Vlad, this should not be legal, since the action
> > will not be executed in software. I think what Vlad concerns is do we really need skip_sw flag for
> > an action? If a packet matches the filter in software, the action should not be skip_sw. 
> > If we choose to omit the skip_sw flag and just keep skip_hw, it will simplify our work. 
> > Of course, we can also keep skip_sw by adding more check to avoid the above case. 
> >
> > Vlad, I am not sure if I understand your idea correctly. 
> 
> My suggestion was to forgo the skip_sw flag for shared action offload
> and, consecutively, remove the validation code, not to add even more
> checks. I still don't see a practical case where skip_sw shared action
> is useful. But I don't have any strong feelings about this flag, so if
> Jamal thinks it is necessary, then fine by me.

FWIIW, my feelings are the same as Vlad's.

I think these flags add complexity that would be nice to avoid.
But if Jamal thinks its necessary, then including the flags implementation
is fine by me.
