Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B1E473DD5
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 08:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhLNH4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 02:56:08 -0500
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com ([104.47.70.103]:6069
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231611AbhLNH4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 02:56:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8nN4X8xDe3zPLuErZO1/aFM2hv/NX5zjz3JRUwAAHRLnEadRzoMyzVHkWHeAmRETH43FpS/Nbzw/yH57Yuvh+q9fl4YqPjaMhpbZ2M0zs7bGaLx7YZYqCGRCJXaAtM0tcCK8UmQQ+74A4b05IWrUe6uz+0WrryDIAlYwuZJSYLF9wgfHiG20NUXAUngpnQN9yhyGoHPftSCGIRk8crmO8pHMw3P5e3R/lzswGO7rJg3VLAZ1s8T4EnUOYjEMhIq26Isoar6sV0lCxzQ5ve2P2kNLTooRSIxUB585PHARh8Pio/wLoFRebysSKInwOY8wUEgxDG0vsbjrx9X9GQGVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5D5y/Z2IPm7Jo0xJaZ5ubr4gTEQ/hVnMVUZwmM9V68s=;
 b=kvfz0NoAn1RP69YMknyeamV9iSfYRAZ2gndWnYPsLfKl+tw20A3Sbz+hXOLbPrsIgzcnSXP+w+kb6Xrd8IHSawlC3px/4jvSU2o20wnIil5ZOfjHdb+bMDoo2ZMeAhlZqJMnctKKzr2EDe6PLer9NbTRcDvJdV46oESDb0KdyWIu0l0OmjT5aMhXkKF7LD3DRG5+DrfQDOhJtnJR7xOLPBRuyRSkqQaXn56FGMeAwtDPq0GIdJW/Cnq3aCctAyGK7d7C3mTqBR7SLTVSagQZP7lTF5a4ekbOQOVMTN8lwSd2kUtkCs/oTMCENR4N5NnvWotQHgoisSHvAJ9Mk3l9ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5D5y/Z2IPm7Jo0xJaZ5ubr4gTEQ/hVnMVUZwmM9V68s=;
 b=uWEYVJ7s7IrLG0V7ruWt3k+DtW6+h4amZrEQBY6EddHoYlOO61yBoDk0F6/YpRGDXFdeUnzP5LiFjntXlfJHIhQfyeTFfq/5QTKXI+p8JCn87v4QaOwDaHyRjAwv/NTcBLn4hsH0MUst27551mSImKUU7rOePXP5R5O2w2sowjI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5574.namprd13.prod.outlook.com (2603:10b6:510:130::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 14 Dec
 2021 07:56:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Tue, 14 Dec 2021
 07:56:02 +0000
Date:   Tue, 14 Dec 2021 08:55:55 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: Re: [PATCH v6 net-next 00/12] allow user to offload tc action to net
 device
Message-ID: <20211214075554.GA31530@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <ygnhzgp4nwdp.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnhzgp4nwdp.fsf@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR02CA0075.eurprd02.prod.outlook.com
 (2603:10a6:208:154::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbe278ba-b649-4534-e632-08d9bed72c6b
X-MS-TrafficTypeDiagnostic: PH7PR13MB5574:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB55746F111EFF4B0CB83FAC1CE8759@PH7PR13MB5574.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IJzurVFJ6gDJ0coyxKcbdly/+aE76VX81jJO9KIeas/QJ3PaMIq1W/RqtUeGqybw2llfKLeVDNQI+ZQjQja3NtKJNE3RW8JA/NBu5zU/n6H8usqIFXzHwCYDY5IM4iSsw3uSFgoYbJw96f1IWvgVlYWUPZpFdIvFFC8Ppg91Ckumb5XFxYBFVqaesEvjyF7G9GFzbrojATeieUWzd5TNZELhvMdKvhGWJjaHuYnxfzAyfSgSH+otIiNWyO/XFrHcr93fII5iR/8mRRjCp6X8mdaQKamsbLKEVBkk+ID7HFS8RfwxbpLSWvlkrupYYmXCnR1fJp/ma8zNf07vr+i0CI2NK3t632xMBllJO5tEQOe+MiiiQC+pGS0S1B4BPB7POTRSMJtmFmSTxuUXV7CUnFZmCuJzfeW1Tki3w8yslGRp0WbnSbJb1kv0MhUJIcH5wXPisQewTvHdK7fGJgb2dS6CkvBIJqf8TDOoGdWPhp+MDiTcwpslhX0UPEvY539QRW6fLUrrOQcJIhAuo4Lygi4pBQDXiFfYh+/ciSNbH0mTwCiVqIpVSbifH8BpEvKi1oDGuTkN8CDnzPSV2J+cm+wBoS+ApWuuDpw26f0wls5Jo0Z/KZvOoWhpfyPxnw3lwCVpdcszeYiocY3judKbrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(346002)(39830400003)(396003)(366004)(376002)(107886003)(186003)(2616005)(6666004)(1076003)(6512007)(508600001)(6506007)(33656002)(52116002)(6486002)(86362001)(44832011)(36756003)(316002)(4326008)(66556008)(66476007)(5660300002)(2906002)(54906003)(66946007)(8676002)(38100700002)(6916009)(83380400001)(8936002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/MQWD5q8L1dF2e13eIts8nu8tw0Q/IAwxdWjaJTLMAYjMwUai4df04z6Ahgu?=
 =?us-ascii?Q?YKItLO8RF4VA8mguj2GFfq7K8Lw6fy054RbBaGkRQuIN2fNKrYG7kKrGd/2c?=
 =?us-ascii?Q?YCkf3MyWppqh5ubTSrgbo0dyOIct1Vhl6qxpcly1+92sTVoxlI88+jwCEp3F?=
 =?us-ascii?Q?HuJ1Yzbl6GoypVXDiR9ixzGLSWM3t88XrBR7KAC+6eZDqpvqI9r7bQlQWBRL?=
 =?us-ascii?Q?KM6dPL2fx9mYbJh8wI5UFyoGqWc0Qyj0AHIMEIouWlJ9dglwdT0n839TLfCT?=
 =?us-ascii?Q?60Jq3HDXVxzcNURXQZzbmXIi7PSUYfWV5G+JdtqjMdKqun0/qdqHJTqu7tCU?=
 =?us-ascii?Q?S0rKEbP9KiVTjAGhHvKS8MoytkSGQ5+Rurxdx5fYC6ZwD1tMuywO1Hj4yFi8?=
 =?us-ascii?Q?5PW21sP6B0Z65qFPHoQjnYtJZs6VEWmKvQeW8PJuZHCFG12KP0xAFoTj1sJX?=
 =?us-ascii?Q?OfrHdrUQTqaTvQVGXCD0v4EDEU59SGFuYLLv6wS14nEM5KNiEOtGeUAJydBs?=
 =?us-ascii?Q?DLArTZNoJR1MVqj4lKockQoBmvBs40i3hOw0RE064cdT9mRTQZP9fXa+xcZE?=
 =?us-ascii?Q?JAVv9xpBsSgN2FwkD22f08rm6JAb5mQGDNLDOkvJaI2WPtbePyMeYDeUYJ75?=
 =?us-ascii?Q?FdrzoQpMpwOIhGc0TOfifxKiUJf3w+i9GMAKlzjM+xQxDuYBNlevfGZuvLsI?=
 =?us-ascii?Q?frYfXjrw9KJMbK6rEJRaycUjYsetgtt/wH73uqAO3+zPOmMWTkhUGL2YlcyI?=
 =?us-ascii?Q?5szin1KGojTTPqcKvW+dBO9O6/5SlsanEtUNSITRPXqVrpRp8t56LcJR2kVW?=
 =?us-ascii?Q?n5olQAHfZV3T0r7qxygX3y0CpxcOCJDdF2C4OaO2lLseq3d8MMW0jo887sie?=
 =?us-ascii?Q?AmuJZ7WKqCXUo5nas1BXInBraABnQuMHYQ9rGfwnnfaLujGFq4+ESA1IOwCR?=
 =?us-ascii?Q?H+dLGirMqQN9zUG74/nrUeR3ofck+9zqdHtcCrFLCdlHK6n9doy+0MngoY8y?=
 =?us-ascii?Q?mwLKcEKJeMMfcCKHsMAaJfiINNvJ7IcZOVrNmRss0LXHfDkBkqcQZAuja1fO?=
 =?us-ascii?Q?4srAkSiV+sk08YVEElrhSm0QbvJs7rPz1njItDXNZGiVIUH7fh2D7qIWzRon?=
 =?us-ascii?Q?8NSUXl1eWHGyUYBKBQfQ/N79scwfIk5YZjyP7ktvtXlNYrIMQaX6BEzNY8Uk?=
 =?us-ascii?Q?Q08JeManY0aLL/tcgDn87mBBq7udocveruVhip3n1TaePUP6fYZrsk6Khhjg?=
 =?us-ascii?Q?Olmy8d319QKsa03SvbdTDG0as3HtUyarkfHvygGymREYnNNtfDj+7mtlq8gA?=
 =?us-ascii?Q?6zo4wKnZx9JmSjSnBStU+V4G3sPd92pN5LcgAH0mf1gw4KAJ0mSIEecArgBF?=
 =?us-ascii?Q?rYonlBu9nBosP1kmhNRWPDGwvyVN31XrVaN0fQfhZEkNSkRKhETh15Hqm6va?=
 =?us-ascii?Q?+qgE2saP9s4yATE72G/SdrdGDKRDdDn7YU/Uw3oKo10DvDbIDffPcAmQAYuF?=
 =?us-ascii?Q?irrb476qSj/2IGFGDq1UTfGK8zsTrXrBoIMyv+oKwtLRpxmHkRBhnNTm8gu6?=
 =?us-ascii?Q?rozZ+fBZlSOjc6DmI22FzawpJQfyhk5gQl6J4e6Gu541UQql4QlSEiBs9MRT?=
 =?us-ascii?Q?hapVEqPaPT2K0LmWp7fD6sVPYwjVh81wxjrAahbOVsWiBKPFGZ8qokEkObCX?=
 =?us-ascii?Q?xneiCddgzsss3fwYhqO6mMHD604MaHBhPsQIC1X0C4VAaX4SHtDPpnvGn1GP?=
 =?us-ascii?Q?QWsRSAkWZg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe278ba-b649-4534-e632-08d9bed72c6b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 07:56:02.3574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwH7CdpupDsjC4JsfaxRs5GtWAOg/+CqD1lkk6yUDLW0xjCjq/HQsmp2YJ722avzuE7Zx/r/8wilpuY53UB52K7O54VBrLczoS/l5FlYgew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5574
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 09:21:54PM +0200, Vlad Buslov wrote:
> On Thu 09 Dec 2021 at 11:27, Simon Horman <simon.horman@corigine.com> wrote:
> > Baowen Zheng says:
> >
> > Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
> > tc actions independent of flows.
> >
> > The motivation for this work is to prepare for using TC police action
> > instances to provide hardware offload of OVS metering feature - which calls
> > for policers that may be used by multiple flows and whose lifecycle is
> > independent of any flows that use them.
> >
> > This patch includes basic changes to offload drivers to return EOPNOTSUPP
> > if this feature is used - it is not yet supported by any driver.
> >
> > Tc cli command to offload and quote an action:
> >
> >  # tc qdisc del dev $DEV ingress && sleep 1 || true
> >  # tc actions delete action police index 200 || true
> >
> >  # tc qdisc add dev $DEV ingress
> >  # tc qdisc show dev $DEV ingress
> >
> >  # tc actions add action police rate 100mbit burst 10000k index 200 skip_sw
> >  # tc -s -d actions list action police
> >  total acts 1
> >
> >          action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify 
> >          overhead 0b linklayer ethernet
> >          ref 1 bind 0  installed 142 sec used 0 sec
> >          Action statistics:
> >          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >          backlog 0b 0p requeues 0
> >          skip_sw in_hw in_hw_count 1
> >          used_hw_stats delayed
> >
> >  # tc filter add dev $DEV protocol ip parent ffff: \
> >          flower skip_sw ip_proto tcp action police index 200
> >  # tc -s -d filter show dev $DEV protocol ip parent ffff:
> >  filter pref 49152 flower chain 0
> >  filter pref 49152 flower chain 0 handle 0x1
> >    eth_type ipv4
> >    ip_proto tcp
> >    skip_sw
> >    in_hw in_hw_count 1
> >          action order 1:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action 
> >          reclassify overhead 0b linklayer ethernet
> >          ref 2 bind 1  installed 300 sec used 0 sec
> >          Action statistics:
> >          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >          backlog 0b 0p requeues 0
> >          skip_sw in_hw in_hw_count 1
> >          used_hw_stats delayed
> >
> >  # tc filter add dev $DEV protocol ipv6 parent ffff: \
> >          flower skip_sw ip_proto tcp action police index 200
> >  # tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
> >    filter pref 49151 flower chain 0
> >    filter pref 49151 flower chain 0 handle 0x1
> >    eth_type ipv6
> >    ip_proto tcp
> >    skip_sw
> >    in_hw in_hw_count 1
> >          action order 1:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action 
> >          reclassify overhead 0b linklayer ethernet
> >          ref 3 bind 2  installed 761 sec used 0 sec
> >          Action statistics:
> >          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >          backlog 0b 0p requeues 0
> >          skip_sw in_hw in_hw_count 1
> >          used_hw_stats delayed
> >
> >  # tc -s -d actions list action police
> >  total acts 1
> >
> >           action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify overhead 0b linklayer ethernet
> >           ref 3 bind 2  installed 917 sec used 0 sec
> >           Action statistics:
> >           Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >           backlog 0b 0p requeues 0
> >           skip_sw in_hw in_hw_count 1
> >          used_hw_stats delayed
> >
> > Changes compared to v5 patches:
> > * Fix issue reported by Dan Carpenter found using Smatch.
> 
> Hi,
> 
> Sorry for late response to this and previous version. From my side
> series LGTM besides points raised by Jamal and Roi.

Thanks Vlad,

we appreciate your reviews.  We'll work on addressing the points made by
Jamal and Roi and repost accordingly.
