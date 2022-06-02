Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E266853B8DB
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 14:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbiFBMSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 08:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbiFBMSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 08:18:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0108E0C9;
        Thu,  2 Jun 2022 05:18:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMGf73d53LLA71tO4hkvmTQMkfAJP7SF5NIJPGDLEzL5dmjQdcuwVrOhaO1wZT2Y8C1U9RjWy1ayBjGt59bXSE/GBg3fk2XYOVrZvC26FJbjRFwUdgDMTvnMcnRvqkpzvNmygCfOgCV+5OEMyylkUdVcceQCkmNo04nhpoHcfCbslaVzAPr+PhYjJgSQ9+uY+d5GbkfGWR+F6x/YUv2hbuM413V/zAVsIVWvHMEauDNVPDbVBVkCgJvyBJ8bHT6yJdc0lL2ew5QiJq0dIA2cq/vB4OdYATyHOqi8hs84+d2k0Jnj03WSFnVoflYbhsMtwG2bSIlQDgNfHT55+qTuuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9kZhFWd/1xWGauzcAV7xzrvbmjGqdFbwJMrVUn0+o4=;
 b=E7TqnqB8RwKaAMRfDo1OoXGIfW/dZXxNT+JKIJBH0yBWTig2M+s0xEz6vqt6SF6EOTUnnlkMGP1s1utuTgm1s2+YGLk504ICZGyWuVN/TG1BN0EjMy2qB/46SmbTFCaMJGoNi3tJXMiijeOHQkpNhp+xBdmuBvEZf1SDijkY8JIZf5wioVRkmsHliVFCo0SYX3n4A3sBS62VH3fEnbe2BPy75mo/6K6nHC/TeskMKBD4CRNhew+9+OKCqVmRBmUWkrSfi4o5uY0Kx/gLzz8i0F8O35eKfz7j4nIXec+Cz1vSHAygXZ3cCOUOmx1B4yljujX+fPTI8xSWCBEgckZdnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9kZhFWd/1xWGauzcAV7xzrvbmjGqdFbwJMrVUn0+o4=;
 b=NUQ5HuNKfdRJPyEVUcj8nOgGOLYMZEkpk8/wljJs2PbwmphkuEWC9jsHXt3nz4N4XzDeazOzetkn62IpYkblwDmHv3IKXReEbb+BRalCXml7xtfnfQ76GBatmfsKGByer0mIZHHPFyLx3hhhUheVSVLFnEOyfFQVPupFuUcdRMrQThlNyQdoSSUGp7RtgwDNHz4mzpqcc9M+Sz3EPRYeg52A27uICAn7KmIpfuUZHotxmZb3hUzQppY7ckNtvAPFD7NVGeYo04kk4GvNtJ6KOfQTtJS2DSnl1XPmzHfh1aokwXu46UbWQShY4rbOee1Uyyw9PAIlsKXKTqCPlpFLFA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN6PR1201MB0004.namprd12.prod.outlook.com (2603:10b6:404:ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Thu, 2 Jun
 2022 12:18:38 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099%2]) with mapi id 15.20.5314.012; Thu, 2 Jun 2022
 12:18:38 +0000
Date:   Thu, 2 Jun 2022 15:18:31 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Message-ID: <YpiqlziXDCg/1FJH@shredder>
References: <86sfov2w8k.fsf@gmail.com>
 <YpCgxtJf9Qe7fTFd@shredder>
 <86sfoqgi5e.fsf@gmail.com>
 <YpYk4EIeH6sdRl+1@shredder>
 <86y1yfzap3.fsf@gmail.com>
 <d88b6090-2ac8-0664-0e38-bb2860be7f6e@blackwall.org>
 <86sfonjroi.fsf@gmail.com>
 <3d93d46d-c484-da0a-c12c-80e83eba31c9@blackwall.org>
 <YpiTbOsh0HBMwiTE@shredder>
 <86mtevjmie.fsf@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86mtevjmie.fsf@gmail.com>
X-ClientProxiedBy: VI1PR0602CA0024.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05d96115-8d4e-4b2e-1046-08da449205af
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0004:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0004066CA7D6967249AB935CB2DE9@BN6PR1201MB0004.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y4PpsbCVsTJ9nvMNTooKDbywNdC0AQgrWJZbTrAPfhIKr2DDl/7u3wZ1vWrJsL0XOnhzIgsQdJEiFrgUIaosTXB++Q0pq81FVO2ozJ2eOiRSnfutqxWUwNyk0igVHi/wA+PdtnwJUMVXMrbX1o/Z48mr82wKpZeREd8FUcKF0xfTGEIU3mXbqhwWuvWyRAVwstfLp60CRZyoyP5BZ1O5pXJKqljmGwfH95Kdj/SvvSXdiCIz36404DpoUtatYfMRnS5JUXTL1hOG0bd7L6LHFbgPyxqmEhrqGvPyea/AINV6TF73QmK649w16OniRRU4/2Ne21I8eqcuR0xl+tcxst003hhJ97R/5X2ZC6+BKX2lY06xM2sbr9YD+e2b7PP/0uUMrxChXYEvNArv3cH/UHUm+iob2cljRLs6O0/EZpnnngkWHVeQ9U9KphIZ6T0ja4oMg4l428G7ZyfL8sgtyjenS1dP/x1Ew4IfH3n5lNksPwcHeZXvzLdXK9SlF34gwU5s+QuOCyRj4iBGwayJ55xq4ulH9FC9Rww9dlfzFK/a23T9rPQw2lBDVXGPe0PPf2h49fpTOkszYkhfpjs47dJgBU4gafNX1DMGOZCMcHXjx74QyS9UbeIEmtOZetZG1dGrVPV4SuwJMx81K06mSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6486002)(6916009)(66556008)(54906003)(66476007)(66946007)(316002)(5660300002)(8676002)(186003)(4326008)(8936002)(508600001)(86362001)(33716001)(38100700002)(2906002)(26005)(7416002)(9686003)(6506007)(6666004)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VmrPmcTgldS+Za+rSo5I8QMKc1EPHnFAaKorflwwXylmKWP7Wn6WQgiTac76?=
 =?us-ascii?Q?fxrPwwfVBgiYdG9DjXTYZH1fD6VOhqH44M1peJhknRHbk2D/8eCDITo97w1b?=
 =?us-ascii?Q?WudqsUBl2Dt+uX3FtVPjL4ijnnqtL29heoFQr66i6txNpSSQY2sMKCMf+grx?=
 =?us-ascii?Q?ryStrBTI6KR+s8pdora3Ot/bkCYwc3hmRJs9gswE1AeTK9L2uc8f7L2ecMx7?=
 =?us-ascii?Q?6Z1JORZwE2TUFpqdU0B0yEleiZGRrVdS0UclL7BVptFX8cU6CP3CXRrB7Hbb?=
 =?us-ascii?Q?UCF5MuDH4xZYivQyhnfbhwBn0R1ilWTnCaGMl5EFwTtrqYdOGMg6oqVI4TWR?=
 =?us-ascii?Q?R4AxCcQ2Npjg9lP3NP6VU5iFqe2zh1eW9pe1/p+j5RcHPUEPVFNpSVsynTE5?=
 =?us-ascii?Q?Mtf6LdTgjHQG3J1HwdhMYmX/0q0iJRbBvUq72mcpiCjkl20ZMpbaw4amqHRg?=
 =?us-ascii?Q?fpcNVFLMEDSx0TMuvcmVKUIGSDlmFZnF08pS/a/rr+Jeg/n2AnARgb+QnYnh?=
 =?us-ascii?Q?newwhvMn6t1mKyFo41CpjWb35wtB4U8cuMgAw4oUF8I5y06pnYeFb/inXIUN?=
 =?us-ascii?Q?Z6yU6Yia34U0RfH70CTYG6/QzM0QgBniHUOfGkV7Iry1JEf9SoVCIEXQld6X?=
 =?us-ascii?Q?oHu4w6odzegN5PRZAm3ePa3XU9AZdPF4yW1c56wDTd+DWl584N1wYJev7x6v?=
 =?us-ascii?Q?xcQlu5QlqaGuMNk7ceycdLvO/rUTwOC7AIiMb+FSvLG2YEIy19yebI1B1wBS?=
 =?us-ascii?Q?3lSJVfuvkAVcTubbBynQmlNDmK/Xt5cHKiKbNXZ0mbkFZdn6ukHp4VvD75so?=
 =?us-ascii?Q?/QqfKeqWXGP8G3qBb9cmVfOhoPvp0RKelpf+Kgwth0I/U/4stDDx61osnCUb?=
 =?us-ascii?Q?4azYQexyqQ5z9cBzsOhNzeLMVO0Uqi5x9JwBYrZdF+LlvEGYvns2jMVxCTqM?=
 =?us-ascii?Q?0bsQq4DduQy+GFU3E22Vw0MZkP3bzXXTV2octowLONYWzsUFy8JYJlUEB9At?=
 =?us-ascii?Q?nBvPp+gYxUteAI1FO5Us7HFBcJZbnelZ1umUDoXdJQdvL/fj0dizOSzCkFiJ?=
 =?us-ascii?Q?X+t9YBes21H0BdsjS/eetGLsnDV/HzuNF1A0zXA43wMOiUrQIONaz4//sugK?=
 =?us-ascii?Q?t/Dd9aztbZFp8aSx+YUovnVOA4w1x8yb9Rgq25g1PwNn3q2E2k6iFRIwwXbn?=
 =?us-ascii?Q?zeQOxBZKvHWO4hKXJKvvdmzrBMiwvVrojxX90SjzU09t36fASIU/l73MOZkL?=
 =?us-ascii?Q?hHGbLBs1/rI4e7F8FYQIVDJyneaQpfLyAJx2GEwPSZoQjmJL9RrQRoq3OM5h?=
 =?us-ascii?Q?D8xj+6i9gKcrJxeYLVHaqak088vp8XnXwA8kmbAl9WOfaib/RBexqV3LKWrg?=
 =?us-ascii?Q?kQTqvKA4qmlvRfk4eQmhuxOL2Esl/3H2BB8rGa2I3370bp+sf5wKwb/4E/Q3?=
 =?us-ascii?Q?x0zYVGRnCD7gEkG8i04XcjhzmhdxGUdpCg51iVKPMj4tgcmxl6b8syTLPCjQ?=
 =?us-ascii?Q?msmx4sziV4K1M/2xuHUuTb/LLVuTJfhzdljcdXF9Gjg202LvX5I+1YDRPmnm?=
 =?us-ascii?Q?qh0Nwz8GiMqSQNCHAFSIk8FNYbr/ReI4bBZTU+0qFXzTzkrGI8mTIPx1ERC0?=
 =?us-ascii?Q?KNpr/kl3DOsEJIWDqglwO7zvgx65G4VZlDuEy/9QU2H/0gFr8/CnJrhmV2xT?=
 =?us-ascii?Q?JrtuPJy6fplCrE0QIToQ+KzztjJIhmvTlLXNUhEBqfCpGR2plyfbSvbqBUoE?=
 =?us-ascii?Q?FuxG2wS9kQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d96115-8d4e-4b2e-1046-08da449205af
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 12:18:38.0119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YfjCJUNxbIggygLS14c7ZJCwqlvdxmPUnaNmgan6pUi8wG5LVd+XnuhMYw/meN9TsFRqkSg7MZe98jdJ6Cd7WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0004
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 02:08:41PM +0200, Hans Schultz wrote:
> >
> > I think Hans is testing with mv88e6xxx which dumps entries directly from
> > HW via ndo_fdb_dump(). See dsa_slave_port_fdb_do_dump() which sets
> > NTF_SELF.
> >
> > Hans, are you seeing the entry twice? Once with 'master' and once with
> > 'self'?
> >
> 
> When replacing a locked entry it looks like this:
> 
> # bridge fdb show dev eth6 | grep 4c
> 00:4c:4c:4c:4c:4c vlan 1 master br0 extern_learn offload locked
> 
> # bridge fdb replace 00:4c:4c:4c:4c:4c dev eth6 vlan 1 master static ; bridge fdb show dev eth6 | grep 4c
> 00:4c:4c:4c:4c:4c vlan 1 self static

This output means that the FDB entry was deleted from the bridge driver
FDB.

> 
> The problem is then that the function
> br_fdb_find_rcu(br,eth_hdr(skb)->h_source, vid);
> , where the h_source and vid is the entry above, does not find the entry.
> My hypothesis was then that this is because of the 'self' flag that I
> see.

br_fdb_find_rcu() does a lookup in the bridge driver FDB, but per the
output above, the entry isn't there for some reason. It's only in HW.

Can it be that you driver is deleting these entries from the bridge
driver FDB via SWITCHDEV_FDB_DEL_TO_BRIDGE for some reason?

> 
> I am thinking that the function dsa_slave_port_fdb_do_dump() is only for
> debug, and thus does not really set any flags in the bridge modules FDB,
> but then I don't understand why the above find function does not find
> the entry?
