Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2336BED2E
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjCQPns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjCQPnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:43:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F04448E10
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:43:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yas9s3FuNpqQ4bON841ahb3iNkWuDwHBNpMElETN1EuAA2uiImDiOgx/nNO9okHOPhYHNrCLoByrDCTHrS2/Mh2ZGtBp1SN0vuuSuc+cPIrq3/Ku52icQgd36PLnDdtOI9Vfu8z5ezYqRLOKV7unbrGAG4FA2P5foIiJqqglw8ioRD6odYCTKaLHOIZHcjpT7tCNcVGqWA/GP/WKCCVzk3TVPCvtrhTDa9JNoiQ1hWdeuuY7kNBqrMRipWFtOXK4pmmJZYUT6aNU8JzNWSFwj+NJMPbgz76LpM4b07N84Tc9+iq9/hNXeDz7tMI4E7KFgE6jA9Y9gjm+DAuG2RBFMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3r0ghGhi42QnIhmxp/SnLqiku0MhievLa1jm6+8T1I=;
 b=X05OupNVqFhzTkn02qydIgMnFHRlw+9y8jS8W/GGGhZwqvX8R0KEp23eR4NKYWJoZoCX2M34VhW/4vnT0nw68wckTqzIGWpBj/lgISXe1LXrcJQplkV6ixBakjsYtFZFNraVZNfOsIkAKa7NIQFGiMtclok8d55YYHUer8QFAkRAj0pHxrE9v0QEtvJY7xx/boGlhMvGY1Ot0cFUfZBNQv7I6DpzyxiFNX1O9UMN7NkhJnnIfClJLmEQGtUM9fghZznIJl9uIzGyw5lXPEGAZr1HE5DJYCycPq9A5ejwo+HdANx+XU1MAdY8Qvll1OicYskoMmxDBYLegPj0B0b/wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3r0ghGhi42QnIhmxp/SnLqiku0MhievLa1jm6+8T1I=;
 b=fBcyxLBh1lXuuGYhxT0jFDs1S6GTvpplpY98FNCw2r8H3a5pZYj9Dgt6G/f+mXmjABK26JFv2gRFurBrQzQxzsgSUv8OwBMqUZTPdfmT5CRydJHBFlX1jSJYhsaoiVkAzBAVg1ANDu8stLNwrVvtk+2sVZrKFydL30fR8vEylxCbtICeFx+Cb54CHU+pk4FsHXh2iRdV2GYTTtlFaGCXXmaiTPWmAYlR5sjWk2s8rS8gU9WcJEete7Q/6+bZyQs+Ai59QdLlC95p9NchJl0xoiaYP6rCRvWHCr2+7X2otLQEi0uVbGihfyASsGD4AFBELvVXKJCszpVrfkx2LgudrA==
Received: from MW4PR04CA0240.namprd04.prod.outlook.com (2603:10b6:303:87::35)
 by BN9PR12MB5212.namprd12.prod.outlook.com (2603:10b6:408:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Fri, 17 Mar
 2023 15:43:40 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::2f) by MW4PR04CA0240.outlook.office365.com
 (2603:10b6:303:87::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33 via Frontend
 Transport; Fri, 17 Mar 2023 15:43:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.20 via Frontend Transport; Fri, 17 Mar 2023 15:43:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 17 Mar 2023
 08:43:32 -0700
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 17 Mar
 2023 08:43:30 -0700
References: <20230210221243.228932-1-vladimir.oltean@nxp.com>
 <873579ddv0.fsf@nvidia.com> <20230213113907.j5t5zldlwea3mh7d@skbuf>
 <87sff8bgkm.fsf@nvidia.com> <87y1nxq7dk.fsf@nvidia.com>
 <87ttykreky.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next] selftests: forwarding: add a test for MAC
 Merge layer
Date:   Fri, 17 Mar 2023 16:35:58 +0100
In-Reply-To: <87ttykreky.fsf@nvidia.com>
Message-ID: <871qlnqt7k.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT051:EE_|BN9PR12MB5212:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a5a7398-749a-4017-e42d-08db26fe61b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: teCt4WWY6Nc8DyW2GLhtUuy6By7qbLadbFyAbino8Vyc+kPYC/jT3v9YZKAexM/x/0QL/Y2G7ieR6HtbgkwUIN38J0j9blGrDA/4rA8FeeioapnB+QkO0FB29Ny8RTzQf9ysJ9jWXLSMIcNYIa83pZo+HoRoDQ6ef4ywhjMP+3Cfvd0pKZpowYZtOJvrdxCU/TELMob7AfOZYINT5B0zG8TIhlRjOWyDD/fVwPkw0hr3S56quDuTUhKzAAAlzsVmVR0w8j2IUjD9Pf6/FNpGEN//Lz1yVtkHcOS/t3CYcK4zFrBeBvhcLvZcaAKPRfk17l/NqgZGtAG2uUkRUloo2vy01rrn1gupjxs6AQQWlw7631aEd3DnphX008HnOGbtQ79wXF8amvPTbLmTpGyDcT6yq7t+9TNvXcL5N5WvTyxAY7bDBk4VgeCX2HgwTskdY3M/EKq6dfyDdAtEYHQdBLOydhLivqjjmGytFbF8WL/5p0Jm4b3iN+x1S8OLxpeFFcX+CMb0bDZ0uxcEWN9ay6F/foyxNeeuJgh1EImy2hteHkoaCk4VW+6J80VTijGMbqRpbwaIVGtW5Yz1rXwTyyfetE4PexE93NC5wEyjKUlFAxGuIA1GzoozznIYETiO3psIfI6GV5vwRr/33Smypz28mTdRTCuoXUZvjP/9ex290MiACvj9IUeXk08V3imUGfwyOnRyLhOHe3+Uqf5HLjnDXnPQW31Sz0FUikhBugQ41k57dQ8qIRBb7AxJA1IR3pKOsHes7Pef9+JeKSNhzLzEw7fFya50KHYp/+QCiU0=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199018)(46966006)(40470700004)(36840700001)(86362001)(82310400005)(2616005)(16526019)(36756003)(37006003)(356005)(186003)(966005)(336012)(66899018)(47076005)(478600001)(40480700001)(54906003)(316002)(26005)(426003)(41300700001)(7636003)(4326008)(2906002)(36860700001)(70206006)(8676002)(70586007)(5660300002)(6862004)(8936002)(6666004)(40460700003)(82740400003)(6200100001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 15:43:40.4459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a5a7398-749a-4017-e42d-08db26fe61b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5212
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> Petr Machata <petrm@nvidia.com> writes:
>
>> Petr Machata <petrm@nvidia.com> writes:
>>
>>> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
>>>
>>>> diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
>>>> index c6ce0b448bf3..bf57400e14ee 100755
>>>> --- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
>>>> +++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
>>>> @@ -2,7 +2,7 @@
>>>>  # SPDX-License-Identifier: GPL-2.0
>>>>  
>>>>  source qos_lib.sh
>>>> -bail_on_lldpad
>>>> +bail_on_lldpad "configure DCB" "configure Qdiscs"
>>>
>>> ... lib.sh isn't sourced at this point yet. `source
>>> $lib_dir/sch_tbf_ets.sh' brings that in later in the file, so the bail
>>> would need to be below that. But if it is, it won't run until after the
>>> test, which is useless.
>
> I added a shim as shown below. Comments welcome. Your patch then needs a
> bit of adaptation, plus I've dropped all the now-useless imports of
> qos_lib.sh. I'll pass this through our regression, and if nothing
> explodes, I'll point you at a branch tomorrow, and you can make the two
> patches a part of your larger patchset?

(I only pushed this to our regression today. The patches are the top two
ones here:

    https://github.com/pmachata/linux_mlxsw/commits/petrm_selftests_bail_on_lldpad_move

I'll let you know on Monday whether anything exploded in regression.)
