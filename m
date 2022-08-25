Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8F55A0FB5
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241093AbiHYL6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241053AbiHYL63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:58:29 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2048.outbound.protection.outlook.com [40.107.96.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2564A61D0;
        Thu, 25 Aug 2022 04:58:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=li9kVjzqyuW5lYJGeQmb8CPSl52GiazxIjXi5zr7cYzVJx/UP+U2VRDbQsU5BEGFVDX0AAV0rij0qnPzYQ3dVYtkEiBd8Qd1f+Jb3tEAKgAbscfUvcOMvhBPWitZPgZvHdKmU8W+d5dPGy/yTvaPgywErrdW1NUV/4jKWwIU7pO2bYHt0SL+QXlJbizhlKFugHlYpzQVjIeDMJ8q8RBILjOVS+YKiGsSJMfJB+tEeXiipEbQ2Q92ws9r/B0wv5fPjZSVVcZRSfh1S9ngF0a6vl8pXCoOmrWU5ld3QQi+3S1mavdEWFGdSt9DGM3YLTdJk6SFO260+iOFCxoV4zEdSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3VAm/HXAxjFwtdRn3M0NwG59vZPWh838PZ/yDFuNLg=;
 b=ct6gKxZWO+1s+7KA8NM99nfD/kpCNHKymIUPNaE5YA+uoKEV0E29s9+R9VItyXAbLIZOY8ptKbMV3ILhYBTQV6cPnALNJKg0LGY7tD1QQLbEaFt8zZAIzxnICT9vzzS5xbhqmQ46E2tXJKCe4tGpl78gJDjaQeFX36gR8PdQ3G0wH0cbT8qI3IqlzgFOH1sMjg7Bce22H9rcThDSEpl31TqMqzP1N9Rf9PZRJFfp1hmbsEEirBNQyd9kGkevASHHbaDI0g7uE3TCfBz7/wwPBBzDMuQuO5Oo+49wYzh0GQz+g22cTKFFu1bjApACKy5xVhCK5SeFcjgLPdrC22vYig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3VAm/HXAxjFwtdRn3M0NwG59vZPWh838PZ/yDFuNLg=;
 b=jRO20h/g/VejN6xrIvmfmhkiKrPVCxK5aBQKCqgFouq+efO5Z7Zd2vTAhTtBftCLt3jFUS/xrAMhcMezZn9cR6PXiD/Ksx652nL86p3wSyqAhAFr5GBeYz/ZlrOB7u8780Ta1YYSIK0l3CgzqjGBZeqZLvZoDz3LkNEYCplQvQXl/emn+VngkgS5PbjGcosmZhiRyR4EuZ7ZvMIjjTUgZ6uN4WaA2rCSfVbkYa/AwHK9Lcm33iyfoq1jDdbDQzFIN3Ti3BHtq+J9x28g5GkFrpZWW4pxkJQlk1fhOXOGmJofAJ496CDarXr3QHrTsuyBqo4cFLI2GlGaZqtrMf74sA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7SPRMB0001.namprd12.prod.outlook.com (2603:10b6:510:13c::20)
 by DM4PR12MB6542.namprd12.prod.outlook.com (2603:10b6:8:89::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Thu, 25 Aug 2022 11:58:26 +0000
Received: from PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e]) by PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e%6]) with mapi id 15.20.5504.025; Thu, 25 Aug 2022
 11:58:26 +0000
Date:   Thu, 25 Aug 2022 14:58:19 +0300
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
Message-ID: <Ywdj2+mIQFR6+drZ@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
 <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
 <7016ed2ce9a30537e4278e37878900d8@kapio-technology.com>
 <Ywc/qTNqVbS4E7zS@shredder>
 <7dfe15571370dfb5348a3d0e5478f62c@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dfe15571370dfb5348a3d0e5478f62c@kapio-technology.com>
X-ClientProxiedBy: VI1PR09CA0172.eurprd09.prod.outlook.com
 (2603:10a6:800:120::26) To PH7SPRMB0001.namprd12.prod.outlook.com
 (2603:10b6:510:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d8b98af-8363-4a31-7dd7-08da86911e1d
X-MS-TrafficTypeDiagnostic: DM4PR12MB6542:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ky9Ll5m3Rtg755wx6DWXqjGNOpkmym6IKdJTV5MVb/81mF3S5sAskfPtwsiSo5r5/+3VFHf5wHqao2BqJfSVh7S9Ok1xigpH+kmQk8+4a3MBZsrLfyVpj2KpyPL0yHKK1LcRW2VjyWzKjHoe1PaJZn+wEHwUVz3TWSEsSV3ZrZ8yB3iYmPHv8lybZHH28bWpLadB/2uPKfynL6vZ6e4Vt9xXvo259KIz9m/gvuH4K50tS+oD1LHqBUr8+VXPVkrd7NhUmb9KYeXSSXkTmzx29FwQyAwmMcgTOcK1Yn9kKG+o/zplUrHPEMcdArIgcDrtkOvkJYH7i+ISTWJurRAH/8e9PZqmwhk2vM2o0XnHwxcYVG6wHPCgL6GXdr5dlSxP2s7JCrTZEv2MKN/xT8UxcnsZUMB1XcL9zhc3TFHGpHcZDszLNTuk9PP2fcrQ7Vl9sST1FJsq/RNTeCJihUnVrko8gJHR3uwnQ3ToaAye7EVTTKxAuuM6uDeXS+q9B5crtyUeDS3PAe8GAZJLlhpEG02ldbUG3PQx3JVe+UuyOBdqNQCvBYcTmOZAA2X8UdeVvSwCvJ9k/4VGMN7lUWKlI2tVZLuomaQRtkWPbRIx+5FFIdGq0H60GCNd4kHSWd++cHJwVopbCriVb6DI9dfF44XNE55Kvn9OB/3eM0T7Ia6m+fNiHyyLjQTu8fAzb2GVGvdGwo1hysBhq2ErFKGb6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7SPRMB0001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(39860400002)(136003)(396003)(376002)(346002)(83380400001)(8676002)(66476007)(38100700002)(54906003)(6916009)(66556008)(316002)(6486002)(478600001)(45080400002)(66946007)(4326008)(5660300002)(7416002)(86362001)(8936002)(41300700001)(186003)(33716001)(26005)(6512007)(53546011)(6506007)(2906002)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UYq2jLgHrOuKz0qH13bYYucFFcxLmxbThze58uyEgDp/TY7qafdRX3aE2ORU?=
 =?us-ascii?Q?It04e9pdFrMtFx9rMvjIveMOwV7GqNn+ZlV3jXsPScdhwa+qxmq/sO/Q68K8?=
 =?us-ascii?Q?3k2JVB5cw9LcPYS8BMPi2CK+wn2qD5/qtgK4c3Ml2MZUNpWVN0WqtMMXHvXc?=
 =?us-ascii?Q?1+KdoIp+0QuudoyC8rExO0qfHkedT3tCESXgzkLofcLd+JOnV3pOKXDlscvS?=
 =?us-ascii?Q?UZY6tb6n/csWFithDQaDUiAW8CZqjujm8pOpGSFIzlgXtwcz7EILfMFKPsPj?=
 =?us-ascii?Q?GK2UCTr++3Y/YoJVaX/JgnAb5pCTX98PDCdLDCMRM62laVjShtHLvPwuBMjp?=
 =?us-ascii?Q?z03f852yM39pgDZWKk6YMnJb43w2xFufnN6kHayOk1rsyifpTaTinrGBJgwG?=
 =?us-ascii?Q?IPfFf0JksLWuZFxf6TkbSLLKE1k2xknaE9ye14sX3nORT9UYTfguf6wdNydl?=
 =?us-ascii?Q?5pAAADD2Cby0Vs02HZLVLau8+K9lZDK87eF4knlMHWBuawya2011k7+4S6vx?=
 =?us-ascii?Q?ccC3OlWOjQWZPhX4EmefszhT0To7+sZjp1HrBglAguHahKZIawOIRK0YTVd/?=
 =?us-ascii?Q?byXz+jAcmpBDTWT9qvQkxzW7EBEUDCMcG1FzHal8faCGYARhvv3BUmbC7SeS?=
 =?us-ascii?Q?V+Q3+kNMDkuNNff8L/vjj4W7CxuwsZ+IVk7g2saarf9GVb36AensIcflHC0r?=
 =?us-ascii?Q?XXihrY8jgiwySMRsxF+bwY2Q9VDcmEC97z67DhhGKNZ2+RXX/czj+6gucCWI?=
 =?us-ascii?Q?TYNNQN8mg724+z1g7ORHnkzbFBdX1T3gKF5HZvQH0OjHbW80p+DUgn8a1sza?=
 =?us-ascii?Q?D2z41b7778ObDinyMaiDp0oaCqYvuFHobaVFnKvLg3IIZxxuLHyDbq7vLmVw?=
 =?us-ascii?Q?jPkOfJt2udL9nZLWa8Mp0pz6RrjsYBBMDo+pSV4EKXZ7OtZCZYjxA5fdWAsg?=
 =?us-ascii?Q?iTPfQkDORre/LFlJkPBYSOaA7S/u8juvtM0DkNN2Yew5Q32mf67CtMczXy+G?=
 =?us-ascii?Q?Eclq63HksJqPxt97+isGKSt2y5jRL34pQ9T3E+SM/dEn099sqrUz3Ca51dDN?=
 =?us-ascii?Q?XDbCeMex/tJ6wf2o3LIML3Omd7imcwInMj3KAqHiAOnvBK8FW3NGaqI/wQUB?=
 =?us-ascii?Q?AwWBH6G9/LPMMGScPV18mYwYjXAVW7Qooh9Ppw9C+JqyY9E8E14nIoW61joW?=
 =?us-ascii?Q?alqJyk0C26ZK5YdCpikeFSMavrRNGO5yAljHfTFb53Bb6Bnrp7XQ629oarHO?=
 =?us-ascii?Q?kv+3swIBqfTM9KKvKgxtl1zgD8LIgWtXSPRZZcAzw0seTKVa72eybjDQufro?=
 =?us-ascii?Q?frzzURWBqD6GuqgfQuOmWqEkoL0Lqiv61yWPrPfqhZPnEvZnfqfB9msbQgu1?=
 =?us-ascii?Q?WIm6hILx5RNhrsUXnRaerSDvEenInf3x2/3dXj+ITwvF1I9RcBzvYXVbDaJ1?=
 =?us-ascii?Q?oSgANd41wveMlZklDE+6rBZWsYaZ7VkxQlBqR2B5nWYR3mAW4zBkx6mXVq9b?=
 =?us-ascii?Q?nYYVbfkPi1yKLgaS4lyYYpTzr7xFVtkk92/IJgQ2RAXSiV0w29dy/VqIisqS?=
 =?us-ascii?Q?8OJMMz5rGXieTexXWGa3JsO90CCUPqrrW/2ch+4Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d8b98af-8363-4a31-7dd7-08da86911e1d
X-MS-Exchange-CrossTenant-AuthSource: PH7SPRMB0001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 11:58:26.1849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JYCTE9GfDdnaGAgb87ZgEraN5PwlCTwK26SxRNcDjFUXRymGNd9URD7Nu7LyJeZrMt2or+tugeyqxq1nCjbSbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6542
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

On Thu, Aug 25, 2022 at 12:27:01PM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-25 11:23, Ido Schimmel wrote:
> > > 
> > > 
> > > Ido, I am not so known to the selftests, so I am wondering why I
> > > don't see
> > > either check_err or check_fail fail, whichever I use, when I think
> > > they
> > > should and then they are not really checking...
> > > 
> > > 
> > >         local mac=10:20:30:30:20:10
> > > 
> > > 
> > >         $MZ $h1 -t udp -a $mac -b rand
> > >         bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0
> > > locked"
> > >         check_err $? "MAB station move: no locked entry on first
> > > injection"
> > > 
> > >         $MZ $h2 -t udp -a $mac -b rand
> > >         bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0
> > > locked"
> > >         check_err $? "MAB station move: locked entry did not move"
> > > 
> > > What is wrong here?
> > 
> > Did you try adding a sleep between mausezahn and the FDB dump? At least
> > that is what learning_test() is doing. It is possible that the packet is
> > not sent / processed fast enough for the bridge to learn it before the
> > dump.
> > 
> 
> I missed the call to log_test at the end of the test.
> 
> > > 
> > > For a mv88e6xxx test I guess I can make a check to verify that this
> > > driver
> > > is in use?
> > 
> > Not in a generic forwarding test. Maybe in
> > tools/testing/selftests/drivers/net/dsa/
> > 
> > My preference would be to get as much tests as possible in
> > tools/testing/selftests/net/forwarding/bridge_locked_port.sh.
> 
> I now have a roaming test in
> tools/testing/selftests/net/forwarding/bridge_locked_port.sh, but it will
> not pass with mv88e6xxx as it is meant for the SW bridge.
> 
> I can check if the sticky flag is set on the locked entry and then skip the
> test if it is.

Instead of skipping it you can check that roaming fails when "sticky" is
set.

> 
> The bridge_locked_port.sh test is linked in
> tools/testing/selftests/drivers/net/dsa/, but if I cannot check if the
> mv88e6xxx driver or other switchcores are in use, I cannot do more.

Since the behavior of the HW data path is reflected to the software
bridge and user space via "sticky" / "blackhole" / "extern_learn", you
should be able to add test cases to the generic selftest. For example,
if "blackhole" is set, then simple ping is expected to fail. Otherwise
it is expected to pass.
