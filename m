Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BAA63636E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbiKWP0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237811AbiKWPZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:25:51 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2047.outbound.protection.outlook.com [40.107.249.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AC982235
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:25:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQHyDKACRD6YELr2ZB5o/4hrkp+Rd6g/H0sVd+cwd3KfrD2hJFA9/NHUM1jyNqQ0F/lf4u8T2P9NPqC2JDJpwWbfRF3PkNK82Vkt4NoOnmPEyaXZeyIgjfjTk5I3oj3v+DdFh2+CpNhw4G8AkJV9ViywQgrmcrh8V4jn1PijnT2cVox+M4XphJXl8OjRxa2dDlvSlc7WgPeePv1hPjhn0fV0H6eGgPZIgx8Ia23sCltvFMOBg6v2+Wz2EVK8a9J9QB0OvAMKe3M5AU/TeSzpC2HQzMrQZPEYe2QJluZ/ZqWryZsuc4k0x48TKcSCW2mHumHlCgxwiL09UdPH+SQoXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcQeCPItiN5k/nREidmDAXUFrA0qXeYI5Q710Lz2ctQ=;
 b=lL5klPcQbOR3wNCU5Z0b5WMLdJN5HRPY/X9vGyy94bN2YZB4R12VXIDSH5MQTexum+C3Kw3caWZsICpqqYX63K1hAn85lmrI7DzKRLogkLAIUw0IVpSxFRg1Ll+Lh1KFMfWkbcd1z9ytVGjayWrioolIpfYtgS52uP/5aieVDvGgIhwYPakuvcZjrdEalEWDHPa2AdgGS4THhbiARPWdJ9/QE6tXWINowdp7k2aAZ+eAObyNrEJdq0c7vQq6E63h5T07FU/6KHVNJcZXM/rZ6YaIok9lvu5GIuv33K4t6jYDnrhVCgCCveu9FTrn9tKtrk6g43tpZ6BxT4VyXMzXLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcQeCPItiN5k/nREidmDAXUFrA0qXeYI5Q710Lz2ctQ=;
 b=kKfYIqhCihFBP6wIkFIovuqUIQJHjadzXMcqExe0T+K0MmCmtRnXaCc4Y8up/Kq6ovG7aEAqlHGceCAU7KIEf8wXDyCCIA98V9FYjbZX/ZunHhQ0cXJJV86OLSlTQYmnwnR84C9OCi8iGAW3V1+KZ1tRLnR3XmXsrHRWExMeoCs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6921.eurprd04.prod.outlook.com (2603:10a6:10:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Wed, 23 Nov
 2022 15:25:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 15:25:46 +0000
Date:   Wed, 23 Nov 2022 17:25:43 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Steve Williams <steve.williams@getcruise.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [EXT] Re: [PATCH net-next] net/hanic: Add the hanic network
 interface for high availability links
Message-ID: <20221123152543.ekc5t7gp2hpmaaze@skbuf>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <20221121195810.3f32d4fd@kernel.org>
 <20221122113412.dg4diiu5ngmulih2@skbuf>
 <CALHoRjcw8Du+4Px__x=vfDfjKnHVRnMmAhBBEznQ2CfHPZ9S0A@mail.gmail.com>
 <20221123142558.akqff2gtvzrqtite@skbuf>
 <Y34zoflZsC2pn9RO@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y34zoflZsC2pn9RO@nanopsycho>
X-ClientProxiedBy: AM0PR02CA0129.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB6921:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df08fd1-84f5-4b5f-24eb-08dacd66fe73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TyujE0HR2QHGIozblYHCWS3vaft76ykKVt1e+Yao3DGXN5xDXTmCbS9g5FmVnt4QINVZBSvPKemZ4Sdm9yQFe+xjpBPQnzbyYdwRvLeFF/mmjtF/1eihHSxly5Bz0Z5snfv14iL9QvLrL9h5rY+djkKffkmxZHCXwvpm9+OGCXz/apVS/4vi6a5cH/l8fK7qyPigWeZ7QKsm/QboCufGMTioBTo890w2Vrf0IvF65g19x6Ng8Wm5dpmNDr+6KVTB69N0RC2N/Mm9fd7cQ0eQCv/Iiag5/yF/k/yJOd5IQMQ1OZR9tDn/lpO4WgvEuaB2pUwlH0m2n9YbPDRkFT0sbL5X25MB6yGppiH0OJPHcKhHQS4PhnascTy1oo7KGZHpMRKGMfbGS80ti0wPvTV6sCaBjwqUaVTuhI/obOKHnqzCWkaHxLjwo1jt/HkiM2hLkpbWb2EdHnvhOQ0IdtOt9Hh+iMHBqE+v6HAnw04df15LRdu2CqE1UiO72D0KY9yfqwrurczupdUAVOiskmtumq5BJY/UerdqNCkmztoafM8MsvKx1NmQS4PF4e/q1w3NnEsyUBFdFVuPhTm5cBDqmyov0FpZMeK9z2Cz5y0lBxk8D4AQ8TZ48Fh84XFpLQO358KkwuheHnEDgyxi9Q+VZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(136003)(376002)(396003)(346002)(39860400002)(451199015)(2906002)(83380400001)(1076003)(66946007)(41300700001)(86362001)(66556008)(6486002)(33716001)(54906003)(6916009)(4326008)(6506007)(38100700002)(9686003)(8676002)(5660300002)(6666004)(186003)(66476007)(8936002)(44832011)(6512007)(26005)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KW0wi4KjKcyycaiobqmZl3PcV+zgEXn2jwxQvOl9Oi/wFO5HPpio2oO2Uk1a?=
 =?us-ascii?Q?BGFyOH9NOKGMLwzQB0TSMX6uwhfSPxNtUfNcJ0gV534+T+S6YRfcgYY0iuMr?=
 =?us-ascii?Q?gn122VqMolQInQ51W33102crIE0LiSVakip9FUnU2OS4X9hW9nk10RISmhOO?=
 =?us-ascii?Q?uQpSGKHIeOiUO0zyEycOth3hqe0IIeA8IRMVmVwcQ+j/R3hgXEHGLO8aQuS4?=
 =?us-ascii?Q?KOHFVsFtk7KzF8bd1O1+QDGzW/kuDJWNoHWxwRRv3D11qppVcO67Yu+SbWv5?=
 =?us-ascii?Q?NuFRn5mhnzL59GfN+tvkbNWlHNXiRDBx9r1zm6GXqcE2Ty57BsJLf16CASWJ?=
 =?us-ascii?Q?Q7357kJSaV6XZoDI4S6E0VRioSkOjvAtK6ls766GNBL30+ow/oLCFij2n374?=
 =?us-ascii?Q?aRl2yCUUpNu0ZQf9C1zxT+CQH3vhphrLcNaR61PhGJNJnCIsPLy8z7ZC7wpM?=
 =?us-ascii?Q?30ZxeNuB9QfbopruUivLQiyccwOzayHymNtAu3Dd0TxA6zi/fUBdQIO0f6dW?=
 =?us-ascii?Q?3q2syftTvBh0JnzMZtGPH6+tzSHU1Y/yYkolFjGXNm+xTfdMvsDTjmxztTIg?=
 =?us-ascii?Q?0DzDAf/pq77eYfuUKI0Ry995Az/XZ+ZEiEGizz6B6qZ/N3s1t0K1B4AGHK4X?=
 =?us-ascii?Q?OXJJmIpwgRLHbOsJQnCzACJGVEnCkvbpwOwPontS2yVJV02bVQsff6i2N2UE?=
 =?us-ascii?Q?ZNMzhgwKKEuRUwvgK91kXFG1i4sirL51XhwE0iCbOaO/aiKjM4eMLvYKX/vv?=
 =?us-ascii?Q?inpGGHkk5kO/pEnexwcybNNiwIGfTk6R+3CheHnIuRsHVPlmjLkTF6moZ5l4?=
 =?us-ascii?Q?I8cSF5++WzbQplQxtxmOzl9ZQfa8VsnMBc9IXruTYR4+L3zClYLIg2OgUqef?=
 =?us-ascii?Q?D01DrzT//iRU3mOtAlY5Eoyz+8sLId6BTCB+tEfYB42Ul8GZJof2hdHaHlIW?=
 =?us-ascii?Q?Jewm8RTuBo7Wu2lSOoAimsX/dXx17B1sTpqIPEqIxqeX0pswkCo8qdHBXdzH?=
 =?us-ascii?Q?/HhgG97MOnjPpNLGoNojXxdZVX7tzi/8sXhK809wM79YcOvJuXqvl1f75udE?=
 =?us-ascii?Q?JclXhS0pp1aroqpzBEZoH0bCuaps8OlIOiP1C29tVOZxMA8gZ6XybYsA5LLn?=
 =?us-ascii?Q?269NoW4ydBrZ8fC82wUruM1Ff8oMNjgGSoGySh1lSXVBh7ZD5/hQpZQ5pOmn?=
 =?us-ascii?Q?JV7RSS118wPkQIFJhtg2yY3prj4XKXUxen5keE/t3OvM9vhseylEdiniLBlr?=
 =?us-ascii?Q?vX87xVpxzS4RSIN2rmuh5KPAboc4jOd/t6752n7NRQw4gCvpQWv4r5ReSnfL?=
 =?us-ascii?Q?S21vU6hudVSvNmo845si0ph908HdoXUG5hyPLkIAIZJciXmCblM5ngmU6HJz?=
 =?us-ascii?Q?EWQvbYhDhKOsPGofRLbuyVPvI4inkVw/LtQiZHqPwG1UpnShR4fxB5bBAKf3?=
 =?us-ascii?Q?5dQQ4xLeK+mkWD0h4LLCYqS9lUIzBa6TaoklkKpgjAdm3S6LsN2B5q+DNmBM?=
 =?us-ascii?Q?FtpVAppAaLq1h0OBZux2TmztELQwNtadhGa/R2LdMa6kjdb13Wf9vVRstG1J?=
 =?us-ascii?Q?06PV70s4w8/iSMfJbFoxMoW4WWctKm4SmxQUoDJhtJkii4ic27n1SHaYdofK?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df08fd1-84f5-4b5f-24eb-08dacd66fe73
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 15:25:46.7226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmLeaL0dPAp4Wa+gUjHvemSf57hNtk0OHJeTXjd6xJqHNit6AX8Y8RydhaLr5m1thpc67JxH0PckgpqEafcQ/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6921
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 03:52:17PM +0100, Jiri Pirko wrote:
> >Reworded, why must the hanic functionality to be in the kernel?
> 
> I guess for the same reason other soft netdevice driver are in the
> kernel. You can do bridge, bond, etc in a silimilar way you described
> here...

You have to consider the value added to the kernel in each case
(and also what were the best practices when those other drivers were
introduced; you can't just use bonding as a precedent for anything).

I believe hanic does not even attempt to solve a generic enough problem
to be the FRER endpoint driver for the Linux kernel. It assumes streams
will be {MAC SA, VID} on RX, and {MAC DA, VID} on TX. That's already
policy enforced by the kernel, when the kernel should just provide the
mechanisms for user space to enforce one. This type of stream
classification will not be the case for 802.1CB networks in general.
According to some of my own research, you can also solve some of the
problems Steve is addressing in other ways.

For example, in order to make {MAC DA, VLAN} streams identify both the
sender and the receiver, one can arrange that in a network, each sender
has its own VLAN ID which identifies it as a sender. I know of at least
one network where this is the case. But this would also be considered
policy, and I'm not suggesting that hanic should use this approach
rather than the other. 802.1CB simply does not recommend one mode of
arranging streams over another.

The fact that hanic needs 802.1Q uppers as termination points for
{MAC, VLAN} addresses seemst to simply not scale for IP-based streams,
or generic byte@offset pattern matching based streams.

Additionally, the hanic driver will probably need a rewrite when Steve
enables some options like CONFIG_PROVE_LOCKING or CONFIG_DEBUG_ATOMIC_SLEEP.
It currently creates sysfs files for streams from the NET_TX softirq.
It's not even clear to me that stream auto-discovery is something
desirable generally. I'd rather pre-program my termination streams if
I know what I'm doing, rather than let the kernel blindly trust possibly
maliciously crafted 802.1CB tags.

When I suggested a tap based solution, I was trying to take the Cruise
hanic driver, as presented, at face value and to propose something which
seems like a better fit for it. I wasn't necessarily trying to transform
the hanic driver into something useful in general for the kernel, since
I don't know if that's what Steve's goal is.
