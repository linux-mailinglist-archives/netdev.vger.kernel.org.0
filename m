Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B55444291
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhKCNlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:41:05 -0400
Received: from mail-dm6nam11on2115.outbound.protection.outlook.com ([40.107.223.115]:10784
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232058AbhKCNlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 09:41:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXFNIrKfBs62jF4Yc2EXEU3zLsvojD3ADuDm/Vo+Q2EysRqIcE2IJhXYVydZRDhPDUEZ1g2VuzwfgGrcsuJmrMD3w+NTDkdGyum1UvRUcix1QRHK9V4m/mojpWTRgqlChIYevGgDWy8/u7Q5AJ7F0I0zUBnvWBjHVyBnQgCJF7P6MkiO6esL32SSuxFyvRby+NaXdonfrVsLaqY2jmb1uw7fO4HNlPL2WRUhg95sKxpX6LZCfyOFd0cPlv5afGe77CB5/xd7yvY2JG0H6/HOMdar+PtaahC/qCYkg3w/MrPtgNpE8EM0RztRAO+MaAiI7qCwwBoF9QY4LgSM6f7ziQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBk13yK3xV5thK3Z1sjIFfGXVdLqs1iRYOtTRNo4h68=;
 b=XI9OCbalD3rQ5dfhntIoG840mW6HCx78X00IaHVRijHNzP8zKhhfoBpjigSfgfBAvNmepYQ+Kf7oeY+kOVH8NlrLdBiiRxHya94MMK/N7pCdysqYnjrRRXDc9f7DTgLUW7bmd9NybV/tbEs0LV0B3OkWOBxl0b4ba+jNpvRtSckxpAKgFioh5qmNp0UnWB3mmXJFClILuww9wGIemR6NUzpNfw/KdDlokHmJgGm9iKPUwPtuqXEY0nXo/mLrKSGPG8MNX13SxO8fSMAqgvbwa75sPv/uH0cOy0ViFBYHZdjJqszm/Euyo81KikVxaZ01H7j45lK7RDJRMBdpYBKfSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBk13yK3xV5thK3Z1sjIFfGXVdLqs1iRYOtTRNo4h68=;
 b=Vq7b09l0xS5ha0klB4tIxaxOm5/+ZAcIldOMHQ9c0cLsrhTnbhSuBNrcaAbymUC7moKewrmJteLQ6SlMw1unSHYmq9vN2CrRyWrKCi4qUT1WW16aDafSNYPYMrKKxzPpwXGvlRptNqbKt+1PKiJQc9uWMYPTy9hLAQsKmioNX/c=
Authentication-Results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5668.namprd13.prod.outlook.com (2603:10b6:510:113::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Wed, 3 Nov
 2021 13:38:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4690.005; Wed, 3 Nov 2021
 13:38:25 +0000
Date:   Wed, 3 Nov 2021 14:38:17 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Message-ID: <20211103133817.GB6555@corigine.com>
References: <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
 <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <ygnhcznk9vgl.fsf@nvidia.com>
 <20211102123957.GA7266@corigine.com>
 <DM5PR1301MB2172F4949E810BDE380AF800E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <428057ce-ccbc-3878-71aa-d5926f11248c@mojatatu.com>
 <DM5PR1301MB2172AD191B6A370C39641E3FE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <66f350c5-1fd7-6132-3791-390454c97256@mojatatu.com>
 <10dae364-b649-92f8-11b0-f3628a6f550a@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10dae364-b649-92f8-11b0-f3628a6f550a@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR06CA0083.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (80.113.23.202) by AM0PR06CA0083.eurprd06.prod.outlook.com (2603:10a6:208:fa::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Wed, 3 Nov 2021 13:38:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac15600f-3aaa-48f5-5adf-08d99ecf35ee
X-MS-TrafficTypeDiagnostic: PH0PR13MB5668:
X-Microsoft-Antispam-PRVS: <PH0PR13MB56681F8B1F1490E9FFB8A200E88C9@PH0PR13MB5668.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:411;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GWTUeqCbwVtWPiBOJGFNA2O31vXF4QGDTzZXmKNmN9PwyrLOaYtiIoeYa+Uj9dl5v5eSLwwkAB7ZxM1PEg8cDNUca6Z8I+kAMoLc5bvAmH4JY4BFigyxuaYJxym3E/netELYfBdncytXMZTg8kb4yiTLKLnOZpWsM9LrHr5RYNQ9AvCeQfyMjxBRig5KKgF77zyJ2kKGViPriK7QJSibD2K7HU6ptLc+zdY4gvIgib+jGagUqJe/+hc3xKawXXjFGsyT7gsSh3IWBr93D0sMexFjiQQhJmHXEt+nqbFYm3+Oq38D6n0msRJKNnEKBmPZAZJdeKjJMwpGrbLOoCKees5XxovKst/I713WZF+g4FlcPynUK29DECRAF0FHt7omncR0Yj9ww+ChNrHtdiVcHaPl7tvkrx8HJqNoS70z7pKNhuNV302QSvoGxPVJknEN3lbbuVSvZE0Ma54OfpPDJKBWgy/fdcl47Cg642IFQiDuvCx3H76TQeWt7Le0huOBxsWY5lSRl4eOi/3F1Bzzw91tvYE8T7B1imkaujuKNBMaKAr9Lf+hn/PVCQd/hzB7/05+oh7D/dZy4u1/NMeU+CYgTMUkqaoEvjnu8/NTYQLxxuBCXYAuPHuJsB5zPRShsjLgdeW7ogkjpERCZoUchwXCHrCmyjEO+XutIbRQh7Qvo3cZArhbIEAx9CVWIoPWpPKt0ergaQi0R9beuIiJaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39840400004)(396003)(376002)(346002)(5660300002)(6666004)(8936002)(26005)(2616005)(38100700002)(2906002)(38350700002)(8886007)(956004)(66476007)(86362001)(66556008)(316002)(1076003)(54906003)(33656002)(66946007)(8676002)(55016002)(53546011)(7696005)(186003)(52116002)(6916009)(36756003)(44832011)(508600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnFseC9JU1BjR0tlRE9pbVFTa1dnL0VibW9iNjUrZHNHSmM0V2ZhSjdTN0or?=
 =?utf-8?B?a29hQTZqUXRVVHYyV1JHQ1d5eGxUVVRTZUN5VlYySVNXVWp4S2xDdWpxcnJi?=
 =?utf-8?B?dFFDWUl3aDVsd1ZNNnkxOWhlcG11N291SkZPRWM5eVl0NFd1blYvRkxVTjJP?=
 =?utf-8?B?aTdTWjN0VGdhdGcwRVllNHk1bzg3dS96MUlRTVh5TjU3YzlySzhjUTVmWHZX?=
 =?utf-8?B?OVI5NGtsMjhzSWtoL2diek5scnc3cEVReGhhUUY3YWFLZUl2OXFPUTNsMWp2?=
 =?utf-8?B?R1dKakZHbnQ1UUN4UDR1SlBzL1IxbDVSWDAzS25WVG15cUZEMkhoWDl3bXBP?=
 =?utf-8?B?Z0dDYmxKemFlRkhBcjJKMTgzKzFRM2ZIdWZQN3FJd204QTdHSHRGcXdHZlV6?=
 =?utf-8?B?N1ZhV0VHQUxNYzYyL2twYnR0U2p6NFhaY0xndk9HUitYT25WWkZtQTZxMHNt?=
 =?utf-8?B?SUtHYTZUYjJUTVBORm1wS1JmcnE3SHI4dTFVQnRJZ3AxTGpNZkJLOXhxaHZR?=
 =?utf-8?B?UE4yY3dFT0FOZUJYa2FLTEozdjV3bm5WQmhmTWRYcU55MS9wa2hwMDZMM29N?=
 =?utf-8?B?U0ZUSmlGUThqMnBkM0JMVHBvd1NlVDk4elcycndZWTRob2FybHcyTGttYVg2?=
 =?utf-8?B?RUlycTN5QzlZd3RDc0JEMSsxcEQwNDdQWUp0OXJ6UlBOM1paNXVXcG5ya3FH?=
 =?utf-8?B?S0ZJRVNxRkQzUE9LN05WR0R1MTcwNm9LMmNVQjZqUTZESklDYjBCQUJrSm5L?=
 =?utf-8?B?VHVxL3FpUVg2dnhLbzRZanpGRDVaTEM5dWdZaEJWZTlRYkdiTVdQSXZMcDBS?=
 =?utf-8?B?TDNtWGhGL1MvTnNzY0QwVk5ya0RRRzhFWndseEZSWlRCRkFGMyt2dDFENEo1?=
 =?utf-8?B?Tld6ZldJeHpsZUtXbmhvSUs0ekdiUmFuQkFKNW5KZ0svcFBhcjdBM05zSVEv?=
 =?utf-8?B?QythWjdIQUxvdXl4eGRuSW1Kbng3K0FDcmhKWFI3L2xndGJLeEpwZ3A5ZUxo?=
 =?utf-8?B?SmdTNEFmQmorazc4bitjaS93SGk1YVZXaE5QQ0xPUmFrN016elhqcUExZnE5?=
 =?utf-8?B?U3RobHVnLzNYaEJkbDVMT2hvYjYwTnlmZ2ozd1Q5WmVOR3V4T3c2c1RFV25P?=
 =?utf-8?B?d09aaU5OWU5qamtCNlRGZ0hDRTNqNmZpWHA5MGZnUkQ4S1daSCsrQ0s5U2NF?=
 =?utf-8?B?NVlUdC9NdHN5R3R4WkIybnM4WTdpdE9ucjRzdCtzL1ZQa01XRk5LaDJtUjNz?=
 =?utf-8?B?OW5seHZ6bVhyTXVKZWNsOXNRRzk5VEZWUittUkhNTXR3eE9yQksvS1BZVzlR?=
 =?utf-8?B?bGRiWjdacHdrZ2s3YVJEL3FiM0llaFljZzVYZHRrNkF0a1BsKzNlU0Z2TXNm?=
 =?utf-8?B?d0tYV3A4bjlHamVzeGs1RFBFUDNjQ2d6Rk5QUTNlTkVSckttbThUcnVta1A1?=
 =?utf-8?B?VktLazB3cDlzdVVIdTk4YXNObFhtTUlLQVhBZEhGeloraFUxdnpYejVMcUs3?=
 =?utf-8?B?ek1UK1ZuQ2dDa1dZMjhYdWhGUmxJVFA0OGRPQ0k4VTJWOWlsZlZjTXF4VWhI?=
 =?utf-8?B?YVRub1V3MDh4bmoza2h6b05CK2w2dEhsY0xXekNhdTNHUG5aQUI0Q05Wd3g4?=
 =?utf-8?B?Q0JEbkkxNlFJTVBhajhmWXBYRTVCVnV4Mm1sQVdlUTloN1BrNHVZOVM4M1A3?=
 =?utf-8?B?YWx1MUg1TlpEcHBFNnNaWlMvcHJtaXlRL3FHeXNHOTA2YzdBZzh6RWRkVW9s?=
 =?utf-8?B?M1J5YkFCa3FDWGd4R2RHT1B5Zkt3R0V0MGNtZlpVQ3NyenphcDFpZTByb3B2?=
 =?utf-8?B?M3VNWW1rYXVIaFZ5YVhxcHl1aFYvVUZqVlFZM3pSQkZMZytCcmFKbkhHY25M?=
 =?utf-8?B?cFJNWkRBdktIaWdGSENYdmRsckk0SFAwZ1JyVFA4ajE0UVpUOGJIZm53NEl5?=
 =?utf-8?B?TFlIZUNhSzBrbjNGbVc0cDh1VHFaT1I4aXNUajdYSE5Rcm5uZnl1S01vZ2Rj?=
 =?utf-8?B?cXExTDJsYm8zZEZkU0QyRS84MFZLVmY3YmFRWnZEaXdYZFpscEM5S0kvcUIw?=
 =?utf-8?B?Y3V4bWN0MCtxaU5EaDgyUjU0K3FsQmRzOXdBeE9nS0YrUk81aiszSVJwcjVm?=
 =?utf-8?B?VURpQVZJZERTYlV3OUVKbS9GWGlDdnFVWnA5SWZBNlcxa1RlNWtPdEtXRzZI?=
 =?utf-8?B?S0VXWTNidXVUemdvZkdvQmFnbVc1aFBQaHN4bHNlb0l4WHhoakRwS0JUWnlw?=
 =?utf-8?Q?FDUMCpY/j46bQqOCU+8Lw2gkfvA6SS07Feo7kVciKU=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac15600f-3aaa-48f5-5adf-08d99ecf35ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 13:38:25.2416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5K0NZ10LuwzyThTjt8bo8y63EibsosbtV4AP8g7ythizGxxAk2uJxc9Oz7kIUGolm+x04sGg/2ug1afTOBUY1sG6YFPqK/HsWe5MzzBdkTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5668
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 09:33:52AM -0400, Jamal Hadi Salim wrote:
> On 2021-11-03 08:33, Jamal Hadi Salim wrote:
> > On 2021-11-03 07:30, Baowen Zheng wrote:
> > > On November 3, 2021 6:14 PM, Jamal Hadi Salim wrote:
> > > > On 2021-11-03 03:57, Baowen Zheng wrote:
> > > > > On November 2, 2021 8:40 PM, Simon Horman wrote:
> > > > > > On Mon, Nov 01, 2021 at 09:38:34AM +0200, Vlad Buslov wrote:
> > > > > > > On Mon 01 Nov 2021 at 05:29, Baowen Zheng
> > > > 
> > > > [..]
> > > > > > > 
> > > > > > > My suggestion was to forgo the skip_sw flag for shared action
> > > > > > > offload and, consecutively, remove the validation code, not to add
> > > > > > > even more checks. I still don't see a practical case where skip_sw
> > > > > > > shared action is useful. But I don't have any strong feelings about
> > > > > > > this flag, so if Jamal thinks it is necessary, then fine by me.
> > > > > > 
> > > > > > FWIIW, my feelings are the same as Vlad's.
> > > > > > 
> > > > > > I think these flags add complexity that would be nice to avoid.
> > > > > > But if Jamal thinks its necessary, then including the flags
> > > > > > implementation is fine by me.
> > > > > Thanks Simon. Jamal, do you think it is necessary to keep the skip_sw
> > > > > flag for user to specify the action should not run in software?
> > > > > 
> > > > 
> > > > Just catching up with discussion...
> > > > IMO, we need the flag. Oz indicated with requirement to be able
> > > > to identify
> > > > the action with an index. So if a specific action is added for
> > > > skip_sw (as
> > > > standalone or alongside a filter) then it cant be used for
> > > > skip_hw. To illustrate
> > > > using extended example:
> > > > 
> > > > #filter 1, skip_sw
> > > > tc filter add dev $DEV1 proto ip parent ffff: flower \
> > > >      skip_sw ip_proto tcp action police blah index 10
> > > > 
> > > > #filter 2, skip_hw
> > > > tc filter add dev $DEV1 proto ip parent ffff: flower \
> > > >      skip_hw ip_proto udp action police index 10
> > > > 
> > > > Filter2 should be illegal.
> > > > And when i dump the actions as so:
> > > > tc actions ls action police
> > > > 
> > > > For debugability, I should see index 10 clearly marked with the
> > > > flag as skip_sw
> > > > 
> > > > The other example i gave earlier which showed the sharing of actions:
> > > > 
> > > > #add a policer action and offload it
> > > > tc actions add action police skip_sw rate ... index 20 #now add
> > > > filter1 which is
> > > > offloaded using offloaded policer tc filter add dev $DEV1 proto
> > > > ip parent ffff:
> > > > flower \
> > > >      skip_sw ip_proto tcp action police index 20 #add filter2
> > > > likewise offloaded
> > > > tc filter add dev $DEV1 proto ip parent ffff: flower \
> > > >      skip_sw ip_proto udp action police index 20
> > > > 
> > > > All good and filter 1 and 2 are sharing policer instance with index 20.
> > > > 
> > > > #Now add a filter3 which is s/w only
> > > > tc filter add dev $DEV1 proto ip parent ffff: flower \
> > > >      skip_hw ip_proto icmp action police index 20
> > > > 
> > > > filter3 should not be allowed.
> > > I think the use cases you mentioned above are clear for us. For the case:
> > > 
> > > #add a policer action and offload it
> > > tc actions add action police skip_sw rate ... index 20
> > > #Now add a filter4 which has no flag
> > > tc filter add dev $DEV1 proto ip parent ffff: flower \
> > >       ip_proto icmp action police index 20
> > > 
> > > Is filter4 legal?
> > 
> > Yes it is _based on current semantics_.
> > The reason is when adding a filter and specifying neither
> > skip_sw nor skip_hw it defaults to allowing both.
> > i.e is the same as skip_sw|skip_hw. You will need to have
> > counters for both s/w and h/w (which i think is taken care of today).
> > 
> > 
> 
> Apologies, i will like to take this one back. Couldnt stop thinking
> about it while sipping coffee;->
> To be safe that should be illegal. The flags have to match _exactly_
> for both  action and filter to make any sense. i.e in the above case
> they are not.

I could be wrong, but I would have thought that in this case the flow
is legal but is only added to hw (because the action doesn't exist in sw).

But if you prefer to make it illegal I guess that is ok too.
