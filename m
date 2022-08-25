Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06AE5A0C78
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 11:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239029AbiHYJYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 05:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiHYJYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 05:24:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DB0A99D1;
        Thu, 25 Aug 2022 02:24:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nz1FuwE5cbgprXXMzh2qs1qtFV6mCDOM7iDcAFWJHl2N7iDQzGpjJIoUT48efp7Kj7rNXE9JHvEfZe3PdPdhiUqZDr2URL/DE2vA0r7Z1fEyKOmhJUWHfAAVJmcVX1OPk9KZP/CpMZG+Nns6J5VkF9Opi9nlg4aEtHnyjkBKB6dsPqU7c72+FR7iwgmTkzbowbR/ncdRxV1iUQXqvka0oilsns27NalV/cA8QUzqNzu82y1a07YpnZHoZ/yQtCxyXutnavUuD7bGkW6phRy9H29uLSH9+VBReT4qt9lv+TyD3x6KEULSNBBnwchQjVKg62O5R4/E4IvMnbRJDv/WSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+2DNsbfIJrNbp61vIf1+hTet7jNQs1B8avgYMskci7s=;
 b=K0A0w24dIH6BAmGdTQaMTUZGUMZAWJZGMnxIBq3X5bIZXtldAyMxLN5UULcf1qkvx8q85oGFbLxTS2V+GArLv9LWGDa+ilT0QEf8WTZ5e7tjnTjlPhmUlwNtgPcWdVOLaGmik7nFbRQ64VYhbhCFMRBPDvfCXrwyzlvGQ1BPcpPLoWXUEWPqZ3nJRpoN0Ry2WS3o2aPJrmd37O2Etf1lmQs4no91BgZKtgOisA10pAM9SJRL5j0ls6hp4riRYVEp7OSnuX0DN8T2bBtZkV0ISjCCNmX1+/EdlsMmMav0ZXvPuwB+ywN62k6uKqLXF4yUVnd1INCv+BUf0O/iICZffw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2DNsbfIJrNbp61vIf1+hTet7jNQs1B8avgYMskci7s=;
 b=KKGOTphDMoOP/eK6gSicAnHHMIqRfhXUTns9PTW8E/TJTSw1AIRh6LKU25v36L6sfNBI4V2yo+ua22cosgJ4a9P4AGoCNB+pct7g/O0og4lscfWJy/0VU35UMajv0Sse7WHzDmaR8Os+PxyuKit5Koa+NWAfU+xW7xXg8MDUchB69eLO3SntOVC9xloNIjzG/sRZ/Kpw6QoY+bkxtFOpz6ZZFnnwhdQp07NDUwU2rXSMUN3QHggCWzfdceuOgm9iPqXbr9NOFkHNYEWrPqq3hOjcJGkdYexV71Lw7cseFPrFVesYanHAdDOk7aOCC1xzqeiwHk38LS8Y3tUiyrWwAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7SPRMB0001.namprd12.prod.outlook.com (2603:10b6:510:13c::20)
 by BN6PR12MB1921.namprd12.prod.outlook.com (2603:10b6:404:fe::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 09:24:01 +0000
Received: from PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e]) by PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e%6]) with mapi id 15.20.5504.025; Thu, 25 Aug 2022
 09:24:00 +0000
Date:   Thu, 25 Aug 2022 12:23:53 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <Ywc/qTNqVbS4E7zS@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
 <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
 <7016ed2ce9a30537e4278e37878900d8@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7016ed2ce9a30537e4278e37878900d8@kapio-technology.com>
X-ClientProxiedBy: VI1P18901CA0016.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::26) To PH7SPRMB0001.namprd12.prod.outlook.com
 (2603:10b6:510:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 490bf4eb-eeb9-4a9c-233a-08da867b8b5c
X-MS-TrafficTypeDiagnostic: BN6PR12MB1921:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TMvj5cuC4eNHo1HtQAcO89UPjkxlAijWRTl78MvZIFNb1epcZ5RzD+bYPK3QjocmWMEwErb+sHBXaowdZy+Flc8+S7Wf3hMqn7fdNNesbgnNSKftzp8ZT3pubNa8u810HBmI4coctnyu/qf6Nov1+PXJJAGJoJ9nAc7PK8GhUOd7i41uFcfojp0A6roWqyT1pjim62T9GS9SJ53DRfQ8eIsNterSDWhouM2UdzKPVYy4kAOaxwW3g4xCQsSIVl4WGFTF+d1fcIDRWOp7akwsOqgE0XPaQjq/1vCzlA5WC5X+QLB86uV6nkYnBYYUYquWnUfCtFWwHlUGV4OWi4mptmB2eR5IAliYrMmsXpwFpeWu6yjASXeNOzmuSBJC9BLipelDxrKB/2XhsX1jGgXPWIRY85CE/o456Dbf7b4qc43Ci+UZdAm3OeNimTM8sQSo4LltrCqTQbwqZQjkHBJQUKlhM/zBSOJiBu/H1z6dlW0wVCOLzwQQhi4E15v8xVXv1R2v7O5rWD5zpKRAxCWb93qEqWRoHrVy5sRFyRjri8LVHzD9Trj3E4xMeYw+WbvFB0ja5lO8fCnJlkVdsV5Ni4QRqmVE4ZeQJ3t8bctAyvUno4bkkpMfwP9AVKgw5lxmpsr7Liqz/SfyNNubWN8Vnw5PgyI424R0UAoxs6eeBQbVsQPcG2/uaJJO2Xzgaozf1gGgv4NyJ8w4IO58kWnyYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7SPRMB0001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(4326008)(186003)(83380400001)(38100700002)(7416002)(5660300002)(8936002)(8676002)(66946007)(478600001)(66476007)(66556008)(33716001)(6512007)(2906002)(6486002)(9686003)(6506007)(53546011)(6666004)(26005)(41300700001)(6916009)(316002)(54906003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bynClLP/vGzJSUAaWfNzEl66VZkw1eBQ1ZLudgkI6UbDWLzilGjUq4Tr5Y/v?=
 =?us-ascii?Q?tdu5fAqBmrxFBHYNcjfv5J1nzmT6tWkReqkXpUBJ61EqQ7/TYBjtk5w/oIIM?=
 =?us-ascii?Q?7hkCyqD2FBHtZvAIv6ZVdATqmLHySMECLW9IapkHrrUUiJklfGGHm5yL2M6z?=
 =?us-ascii?Q?zSEAtI4sdxTO3I4427kvyUOci81NJWF529mEbqZBKxLKA0eCnq8KAFzLXVa6?=
 =?us-ascii?Q?xnn9CkimhUnMphLc62JFs8iDSUuQ+QAUAtV2QZrlAiGXJ4MFxJNWZevZWJ/b?=
 =?us-ascii?Q?wN5SZs+hr+QC8esPN5PpeRWO8xqsJUiwGN+c8bZf/KICeqq5Sy0tHAXhJphE?=
 =?us-ascii?Q?YFjS7gzAbI4MuXdXMCfGzcLtgQ/vp6DNv+9q0Pw7M0v1yfjHGoprN71cCaOX?=
 =?us-ascii?Q?YhILEY6jn5Wgm7e/ABbfjOxY7SFAdA2mss+BG/abDXHMfmdCuFb569gx2anV?=
 =?us-ascii?Q?4ykF56xi0oCWtmMlFeYBu5NWrlhs2evJZqXQU9Kmm+d7t5+SKJk+rKWVwW8C?=
 =?us-ascii?Q?Z6fhSmMJk07rYBL1+HP3Uqmvy0fqkdyD6s6fVhkcqE/XqneWosf7aIXbEYna?=
 =?us-ascii?Q?FfCvm3glbLYRLiYAXhOYZsYiUTH9tx8JSwd6wDzVEtzPOIYrNE3ejxL9KvxZ?=
 =?us-ascii?Q?iuf6Wtsszjko5cSIW6ppLu2OTnGe0g93G4SeN0Yxyz5sI1ldhW63hdMMnUKN?=
 =?us-ascii?Q?iZAQ7D4z/S+CvzhwbYWdK9GAtgfhvK+PxDr2dDgxCEBe4VnfQfLFosUKT/QP?=
 =?us-ascii?Q?FlpGXkwlkF66CekLejiuTMT8Upb6HgAM+Aoo2I+9A1WWljIASaIrUya+y5mq?=
 =?us-ascii?Q?qT+4q9M8G5RFIKtBXn3E87pIjCIsnhRZoRuwlqwy7Au8QcOpIMfuTQ/1Wv9U?=
 =?us-ascii?Q?Gus0rYuDLzsCAIwzYIIGOEZXjSlbwUJvW0HcAafVvMBfwHZEaq2A3/grn+JZ?=
 =?us-ascii?Q?lZXOtt4M9MMlCJIhuAZynxOxGFKoZ/1jSWstag53Z0tJJBTX23LbquwcqUBQ?=
 =?us-ascii?Q?UAOUEN88osIDukhd6WzoyEZqizzjaHP+Cddr93RhF6Bg9mevp3zuLg4TNzcU?=
 =?us-ascii?Q?Qppzz6kn+YqrxLpRTUgk7cA8ijM0++Y+ExkC6XkYWmPhruGdLR1EI4IB0ZPv?=
 =?us-ascii?Q?+pgwBUWNHlT7ZW6t640huhaJfb3RkTHX8X2ctPmI2utm7WsNL5s8KSFFR6F7?=
 =?us-ascii?Q?rmEa+E7XnPwOBsqr8D4buzt3rRZVwcjuVI5Tr2e4OpqaAMinYDSzWOJiXjrB?=
 =?us-ascii?Q?wCgH/Qc49ayAQIom6Iw0iqhpld1G88X2OJjQ41o48uFPR+cZCKZmjqMiuBLT?=
 =?us-ascii?Q?WiR+ZMbFomx4Me5vryJ6zlKhU29Ay6toBsV/gggdE8co9pWNoIgAmUUivUNk?=
 =?us-ascii?Q?7kmh9gVcdlcZ533BlbgSBAiGgkeSe/aXmSCk48n6U4NQgD181htFDxhNuU5s?=
 =?us-ascii?Q?W817azYEeTyDvCyGEd8ePVhG99omr/C0J2jvuUCj7k1n2TgMWwfUE2fZje/3?=
 =?us-ascii?Q?B5QUN8Lf/XteN1R1eZrvgszI3x0vubt9g0IkH3Ly0a6NSozX3dqu+byDOLHd?=
 =?us-ascii?Q?I9kgGycJOtIgDJBFMQkNYyK4SXVNfGPn5aXhk3Cl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 490bf4eb-eeb9-4a9c-233a-08da867b8b5c
X-MS-Exchange-CrossTenant-AuthSource: PH7SPRMB0001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 09:24:00.7266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ft8o5Yow1bBrLTIaAjFG+/MkNp36qJoMDkJiB4ZevUVlfHvjbTWHt9OuP5IR7GzV5ZOQAlVMuZIBG/9+QhI+Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1921
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 10:29:20PM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-21 09:08, Ido Schimmel wrote:
> > 
> > I assume you want a hub to simulate multiple MACs behind the same port.
> > You don't need a hub for that. You can set the MAC using mausezahn. See
> > '-a' option:
> > 
> > "
> >    -a <src-mac|keyword>
> >        Use specified source MAC address with hexadecimal notation such
> > as 00:00:aa:bb:cc:dd.  By default the interface MAC address will be
> > used. The  keywords  ''rand''
> >        and  ''own''  refer to a random MAC address (only unicast
> > addresses are created) and the own address, respectively. You can also
> > use the keywords mentioned below
> >        although broadcast-type source addresses are officially invalid.
> > "
> > 
> 
> 
> Ido, I am not so known to the selftests, so I am wondering why I don't see
> either check_err or check_fail fail, whichever I use, when I think they
> should and then they are not really checking...
> 
> 
>         local mac=10:20:30:30:20:10
> 
> 
>         $MZ $h1 -t udp -a $mac -b rand
>         bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0 locked"
>         check_err $? "MAB station move: no locked entry on first injection"
> 
>         $MZ $h2 -t udp -a $mac -b rand
>         bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0 locked"
>         check_err $? "MAB station move: locked entry did not move"
> 
> What is wrong here?

Did you try adding a sleep between mausezahn and the FDB dump? At least
that is what learning_test() is doing. It is possible that the packet is
not sent / processed fast enough for the bridge to learn it before the
dump.

> 
> For a mv88e6xxx test I guess I can make a check to verify that this driver
> is in use?

Not in a generic forwarding test. Maybe in
tools/testing/selftests/drivers/net/dsa/

My preference would be to get as much tests as possible in
tools/testing/selftests/net/forwarding/bridge_locked_port.sh.

I'm not sure which tests you are planning for mv88e6xxx, but we can pass
/ fail test cases based on the flags we observe in the FDB dump. For
example, if the entry has the "sticky" flag, then the expectation is
that the roaming test will fail. Otherwise, it should pass.
