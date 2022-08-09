Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BDE58DA72
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 16:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243742AbiHIOjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 10:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiHIOjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 10:39:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB8E1B7B4
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 07:39:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwr2RM+3mdSqEvNdvvMOd4VCH0sIfkMZyaOdzG78aw5ikN9DQA0yCrM4IwW6JqYH6Yfrx2psl7SxUIRazi0NoCiie+nrhyQE4hKgoQzZ4djlFB8SoO9YP2z2K12IccySlayyZhUqntF66Dnu7Krd+VGQ1/pAypJLhiSrusR62wTeBW4QIH7MAsfSZdY4w9pFEliXygf5D4AO8b3zoW5AiR94VIcOSTW5DrnUN3dxDve7RkDmllMWuNuBGhCps1hwKTdrV7U0MQu2PeNvhXXPazn+tIZeFppRoXaqjZTfiKPr0gH4ejQqqaKWlgh+ZSwvK6nIbPMLj4wPbAzfmC+Exg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3+WjLlPKH93zDf93y76TFPiWaRkxxEhEMVqV0+4WD0=;
 b=mGStLZFk9RZ3N9hb3FCrtLcG8qyWyXEiojdRrE8Ox109MWLmp89InXFBBphO+lNRjw2LoaH3uhWgQuS9UasWP4XdPzwKILGDM+n4cJo/jHCM5BOAH2MLp52666wzV8viFD8eGeQTGIh2PYn+yWnEujvqznrIdzXzIxvKunIKIuo21zGYEGVb0BI4lZ9dWFttUBcOPNHkdlAkWt72lk4yd0e8+TM0JrYDp/wyogl3Jm9w6SHXs52DcYsmqOvDg2eGH+pLiQOuDWsJ73Thy5lL0oe24R7tgf3m55Rcz5ZO4bQODXgFvFOk/fTCFLxupCGUzYygs9vgiqi9U/iJUiwiwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3+WjLlPKH93zDf93y76TFPiWaRkxxEhEMVqV0+4WD0=;
 b=Lszr+Y9hGK1t04BOYMpxZrawig2yMsa4qhPZP7Q9FWocMNdXKE04Ic0NigVsDk2rCGI8El146zsAfSzCpZE/krHLip6YoXGXuz3bpOuFKf0tPiXOWs2eu22Rq0mO0LwkJglNhysF1uMuDjL2QhHrt5mp/6O0OwPscl/Ruh6P5G53AkTRHqQTtTsuu/xtussRXAlsnenQR+GDIYoXHGsFgqHc/MrDgiShieu62ssCou39CjfpnBBl51XJUJBYhgD+EDKmB58OTueJI8ol5xCTkkoFQft/y5VqtY+t+OcesxQiIJN0RzOKK/KlOY3yHLSd97foSa/imuhVkkNEdemsXg==
Received: from BN0PR04CA0108.namprd04.prod.outlook.com (2603:10b6:408:ec::23)
 by SN6PR12MB5694.namprd12.prod.outlook.com (2603:10b6:805:e3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Tue, 9 Aug
 2022 14:39:44 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::5f) by BN0PR04CA0108.outlook.office365.com
 (2603:10b6:408:ec::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Tue, 9 Aug 2022 14:39:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5504.14 via Frontend Transport; Tue, 9 Aug 2022 14:39:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 9 Aug
 2022 14:39:43 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 9 Aug 2022
 07:39:40 -0700
References: <20220809113320.751413-1-idosch@nvidia.com>
 <YvJcql9M0CHJ6qGP@nanopsycho>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Jiri Pirko <jiri@nvidia.com>
CC:     Ido Schimmel <idosch@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <amcohen@nvidia.com>, <dsahern@gmail.com>,
        <ivecera@redhat.com>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net] selftests: forwarding: Fix failing tests with old
 libnet
Date:   Tue, 9 Aug 2022 16:21:31 +0200
In-Reply-To: <YvJcql9M0CHJ6qGP@nanopsycho>
Message-ID: <875yj17a6t.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2f3f791-6a57-40a8-a653-08da7a150052
X-MS-TrafficTypeDiagnostic: SN6PR12MB5694:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NR2W+zwiE0BHsfKOnq6A0ExZ1G0j+GAWtM0dkOmO756eFvbPzDIXjcYDQPBP1wcafy4pHn5P9B4TlpJsnxmjZBwXBGcoe/e89BgFN7qQ5tJ6/CvEQjjlwCOQZYwpXaltg6sFDOSjgusPYdrAGABx59tNNaCb7eRcXeFkSMJ+w1qv1KdUfqzyz0jsf8CqdgB1EKZpfHJeCA34WgVRH1hL+ysBWSPV4qWRX70ccgEsUNi7ebzqvHNuG3MWAMySB+wivzzAmOpBPnvbB7eVO3dGynmP8gT4PqHb+IhQj+B8YBM+JjiNpC/GCcU6KQ+C2pRrOzUlBqFoN5A8AK3p/bTVdCzIALu/TUxHHTYF1BXEEfRsZpeCzCj9HjYhSPTF3dxRZl8m7sHlyKkCQaZYKywT7IVJp95cBorCFaxTptQVLy/U1Gv47FJ6xanTr2lXE6HEYgwut7mfAyjIC8yZoRuuvHaedLOInGCj5a7UkzIzGU5zrXEsY2DznL3p2x4t98UPAnIL/Qwsj/o3JObGZpypVvKnkXU8DOvd8u77gkZj7Ji2IliXB2IyLrGHS/fcho8aA0ddnqstwt+BHsfMaRFvToB2wswnKRTHb1c45cxkp10quvFuzxGUzC0zpiC5qI8yoZ4feqmbRhlELyW0dg+RhtnHiOHIYz2j9Ovdnd3stcx4TL0smlu7yItoVz1fKy+g6NSyNEAzOWGDqQ/8xn0K4dmcDz17451twsUqfHL5TexdINr8qWza8evQbzdori1XF/NCIpre7YFqCzE3V3Fq0simUK2NClC+Oo8GdPNRRhwV+KfrXZV+mjFTtExzgNaddwv+f+R46qQ2RoqkmUmHZQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(346002)(396003)(46966006)(40470700004)(36840700001)(6862004)(8676002)(2616005)(8936002)(4326008)(70206006)(70586007)(40460700003)(6636002)(336012)(426003)(16526019)(186003)(47076005)(316002)(36860700001)(86362001)(107886003)(54906003)(37006003)(82310400005)(356005)(5660300002)(40480700001)(41300700001)(26005)(82740400003)(478600001)(36756003)(6666004)(81166007)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 14:39:44.2946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f3f791-6a57-40a8-a653-08da7a150052
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB5694
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jiri Pirko <jiri@nvidia.com> writes:

> Tue, Aug 09, 2022 at 01:33:20PM CEST, idosch@nvidia.com wrote:
>>diff --git a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
>>index a15d21dc035a..56eb83d1a3bd 100755
>>--- a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
>>+++ b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
>>@@ -181,37 +181,43 @@ ping_ipv6()
>> 
>> send_src_ipv4()
>> {
>>-	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
>>+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
>
> Not directly related to this, but I was wondering, if it would be
> possible to use $IP and allow user to replace the system-wide "ip" for
> testing purposes...

A typical forwarding test builds a whole topology with a number of IP
addresses and assumptions about them. E.g. routes need network address
derived from address of the remote endpoint, directly attached hosts
need addresses from the same network, flower rules etc. might match
pieces of endpoint addresses, the above code fragment actually walks a
range of IPs... So it's not just $IP. At the minimum it's a map of IPs
plus some helpers to derive the rest, and conversion of the selftests to
correctly use the helpers. Doable, sure, but I suspect a fairly messy
deal.

That's why the selftests use reserved ranges: 192.0.2.0/24,
198.51.100.0/24 etc. and 2001:db8::/32. They are not supposed to
conflict with whatever addresses the user uses.
