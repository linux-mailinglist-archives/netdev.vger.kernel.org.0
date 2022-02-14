Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FBE4B4E70
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351383AbiBNLa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:30:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351665AbiBNLaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:30:07 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426BF66606
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 03:11:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLyeqMglP8o6E+48Gzj68SzmmZ+MdmB1j/se82VagS+ty3+ImY2I30vwtLcACfaF4y7ZgZRwjagT3WdVndMS5weleBIrC40sZmy3FX01yz2k+lWjLcPC9SM2kkONC5Sceq1peXYcPOqBG3awGeeHz6H9JHwy42RGWTteWM44X/8cR+x5tTrzu0BmkwJw2DQRoZH57AIKj52i+SAAaxxf5mxxx5gT7p3VgxhXuCgWPJgmXrqmkv+nN/fRRZuRqW1TM2aF/n9fa0J8i/JKyX3C45+Cp2m8vHQUWMIck57AHTDKjE2oyO4B9OcSldE0f7dIH10CB+RZffZBzE6p9yVcVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPevM7/IMMAGQb+IssLaSw0yxEKfsQarxzE49id863Y=;
 b=WZHdOPraeq8EsRIfVmoT9SQsFW+eejXyCa/9Qk4enkn8orColpo2jYQc02SPHaRkkC5r5G5zbj5P0V9o7TJ/kIAFyjCg3FEmLu0k9cBBTF0KCa0ggGsNNRv7+Y9p+BOmijs2/Tpe5/HoQOKBdlowghqrwnnL81X5YP0jz11roo59MGhKAM5lmQvgVbM+z847qhP852/gzjcmK/C/kFwlol60bd0BNm3k5pRSGM584WtERljoqaJrKm/N37qryPnDgkW5FXMPjH541opLJsh+yLYQ/6iELNj8m1UEUkmcy74P8vYWFbuTyVZSCWxexcGrE4a/7nKBzW3W2Gew9Xi8PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPevM7/IMMAGQb+IssLaSw0yxEKfsQarxzE49id863Y=;
 b=LvJfALdfCBNTsL0AWqqi8Rk8SbsGwK3ho8TGkl0FOOneoCHiCd4UzftgsnY9/7mTsIP1n0lJpd00+z07GAVHT/4xoRBW4qyfc6APmtTKk4nuF/uVW2qAjRhCj+Cim3eG57r9AKJeoLgfRcfy/qN+JlOn4XxEA8KwzXL5V6EaD0XTpFjcG3qH61EInfobFHnJgmhSAr8HSoCXACArD5lgZNGOksbPm24pKuBQwgP0cDBfwYfaoZgcgxf8BG/6ZsNYcnSUjOolKyJg+HgX02UTFiquY0yD/tdHNdBIyk40yTln0IJkuHm3tCUtVrivTwedFoQUxpECdXYjb/046vQ7NQ==
Received: from MWHPR18CA0047.namprd18.prod.outlook.com (2603:10b6:320:31::33)
 by BY5PR12MB4211.namprd12.prod.outlook.com (2603:10b6:a03:20f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Mon, 14 Feb
 2022 11:11:13 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::18) by MWHPR18CA0047.outlook.office365.com
 (2603:10b6:320:31::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17 via Frontend
 Transport; Mon, 14 Feb 2022 11:11:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 11:11:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 11:11:12 +0000
Received: from [172.27.14.193] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 03:11:05 -0800
Message-ID: <bee3d33c-1c66-2234-2be2-f0a279bafc42@nvidia.com>
Date:   Mon, 14 Feb 2022 13:11:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        "Tobias Waldekranz" <tobias@waldekranz.com>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <7b3c0c29-428b-061d-8a30-6817f0caa8da@nvidia.com>
 <20220213200255.3iplletgf4daey54@skbuf>
 <ac47ea65-d61d-ea60-287a-bdeb97495ade@nvidia.com> <Ygon5v7r0nerBxG7@shredder>
 <20220214100729.hmnsvwkmp4kmpqwt@skbuf>
 <fb06ccb9-63ab-04ff-4016-00aae3b0482e@nvidia.com>
 <20220214104217.5asztbbep4utqllh@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220214104217.5asztbbep4utqllh@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cc29331-2df9-4010-0f03-08d9efaab670
X-MS-TrafficTypeDiagnostic: BY5PR12MB4211:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB42116B09534143B792DDE1FEDF339@BY5PR12MB4211.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uy7irjAmoTJms33bn9ieR1jS0c1LnkLEM/gg5rOM+i9ytZDwp5gFnURlxvn6b0ll8cdxNrvnXm4XzyuzCWZACMUZp6DyMxfgYuyPIlend+BRIffYGtrK/fG8dCrujT6D+gi5O7wa6TjfmAhpWh1Rs62mlM5q8n5Chz+o6Rh6JEMJaI/1IoCEH4csXcY+2/wBbMPmWkAKQ0GwnIuUAtRyg4F+9PLoA0Vl5+1MP9OSq0ZQ73gD8AQLpQh0qTEZOSXyBAMmaz01NbXM4G4Opa+Spy+DJ48eeKoBfrAcI6jKGtjpFW24TDm4avNVD4Gkyp8B5b3n9GaYL3zrXPk2MdJA0NEpF8tsMfD1A7HYTDd4fsyYT6+0frs+vcyayPDe9qTsgFakrSamwDNTaXtj67y373R2eDlDRsfpFLe+xO0W5ttp98kVPyPbTgiEMst1q8y68s3RJJn8lgCz1Y1vg7H9fAgOkyM2rbzPoluUM6SVKbNbNCepI4k3hcJHWPWPLPhcTX+EKzCU1ktRaeWzoPW4wUnwICdiT0vBFAO5Z89ecCjTwVqQfNqqEo9sVuC3JF+IqdT0EOQg0CZWKo5bUZ2aTRa5uNXpvz+tz0d2UMR/vX/LNn/hlV1NDjAp67jyHedNrXQ/Ks4sJ5yCZnpIjOkHgL33z2uaLdAMDXdEERHu7RKt7OlQt+rCYm5/e6vorooDsXzX4eFkTvEWwXgcsA458Ny+0ChhfyrzKJgsYa0+11FpPBcw6yeH6MCwtKyPwWSq
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(53546011)(2906002)(83380400001)(2616005)(26005)(186003)(426003)(336012)(16526019)(47076005)(82310400004)(508600001)(316002)(16576012)(8936002)(36756003)(31686004)(70586007)(54906003)(70206006)(86362001)(40460700003)(8676002)(4326008)(6916009)(31696002)(6666004)(7416002)(5660300002)(356005)(81166007)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 11:11:13.2818
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc29331-2df9-4010-0f03-08d9efaab670
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4211
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2022 12:42, Vladimir Oltean wrote:
> On Mon, Feb 14, 2022 at 12:27:57PM +0200, Nikolay Aleksandrov wrote:
>> On 14/02/2022 12:07, Vladimir Oltean wrote:
>>> On Mon, Feb 14, 2022 at 11:59:02AM +0200, Ido Schimmel wrote:
>>>> Sounds good to me as well. I assume it means patches #1 and #2 will be
>>>> changed to make use of this flag and patch #3 will be dropped?
>>>
>>> Not quite. Patches 1 and 2 will be kept as-is, since fundamentally,
>>> their goal is to eliminate a useless SWITCHDEV_PORT_OBJ_ADD event when
>>> really nothing has changed (flags == old_flags, no brentry was created).
>>>
>>
>> I don't think that's needed, a two-line change like
>> "vlan_already_exists == true && old_flags == flags then do nothing"
>> would do the trick in DSA for all drivers and avoid the churn of these patches.
>> It will also keep the order of the events consistent with (most of) the rest
>> of the bridge. I'd prefer the simpler change which avoids config reverts than
>> these two patches.
> 
> I understand you prefer the simpler change which avoids reverting the
> struct net_bridge_vlan on error, but "vlan_already_exists == true &&
> old_flags == flags then do nothing" is not possible in DSA, because DSA
> does not know "old_flags" unless we also pass that via
> struct switchdev_obj_port_vlan. If we do that, I don't have much of an
> objection, but it still seems cleaner to me if the bridge didn't notify
> switchdev at all when it has nothing to say.
> 
> Or where do you mean to place the two-line change?

You mention a couple of times in both patches that you'd like to add dsa
vlan refcounting infra similar to dsa's host fdb and mdb. So I assumed that involves
keeping track of vlan entries in dsa? If so, then I thought you'd record the old flags there.

Alternatively I don't mind passing old flags if you don't intend on keeping
vlan information in dsa, it's uglier but it will avoid the reverts which will
also avoid additional notifications when these cases are hit. It makes sense
to have both old flags and new flags if the switchdev checks are done pre-config
change so it can veto any transitions it can't handle for some reason.

A third option is to do the flags check in the bridge and avoid doing the
switchdev call (e.g. in br_switchdev_port_vlan_ calls), that should avoid
the reverts as well.

If you intend to add vlan refcounting in dsa, then I'd go with just keeping track
of the flags, you'll have vlan state anyway, otherwise it's up to you. I'm ok
with both options for old flags. 

Cheers,
 Nik
