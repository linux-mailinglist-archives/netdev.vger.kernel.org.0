Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E364B452B
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 10:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239420AbiBNJGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 04:06:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbiBNJGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 04:06:17 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF335FF16
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 01:06:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJTyYtJKB/Ze1PyRIJgq31F1y30f9bMa6cCsQM1IToKnOWbNePO5oTTu0HbYVQigcCPPKs8DfAreQEUqZrCN6sIsDliYauTtbXIA4EiXdHANQTarKcU/+qo1f6nDywMkWQ9djqUAiyESaANcVcmjDUxYYnuqU2ILR0bnHBotzqsvT/AJ7YHR0YM/JSzxCBmNAkFlHR4/mg3H0b0FiDVJjIUq7c+ztPea+B1B76ajBmHm9++QoOVqb7rhxGCnm2IYCeFZgP3HJKietxhz70RrdpglrcZjlvWmZlUsxcBSSeDnBXs2PyiSqcqKgScOfWMI6m43ajzpEq9bF7mL0jBVOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEEQaNfqIrHpjJP6D9zm49aHC8ziSvCP4iVePFsE02A=;
 b=Oapx/vpccqoUQXpVvFgfkZhwSAbIA33jQ0/jxaKvArXacwqSo+xPZoJ2NUTnpY6sEZXX6S6IG8ogRvnyLKus69EIFWq6p27nmdeKNqrwTl2iIuhCFWecW357lMeKWo3Sm++EXAr04utVnVitnBgs6HqcAFW/a+/zXhTH/qWghqq+JZrHPwyZH/4FWSTgOsIZYSDCsiI6btNnFqAMnDxtBnFmPPY5HZ108IGtNhnTgQqUNJZVrLHvuHxTCpoIaF/qhmzAKTHuqxL+nWC3R2vk2ymheTutMA2ZirE/puuIQq2k2GMiUYfpV/xULevGzq7VKCWloooWjsBgO+7RFvsXKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEEQaNfqIrHpjJP6D9zm49aHC8ziSvCP4iVePFsE02A=;
 b=J02FbGZt1YB92CVYMwb+y3RYpuy8+dYYMZMj8CnQv8Dw+BnshGiui761PL/a3WE3TxYmni2c+owGk4mxCtp6N7lz974RK7wEXtNVpGmPO1deaYdQi9BvuAJKuiNnwMDdnH+opHE2rOD4ZiNvwjcQqomXAqDV0Zbx0n3SkOiPiJ4mbLMEV/1TraPTJ2YMgggMB62Mj64dsMd3UH2nOziC3LRAHtuTHFdXAUSkfOFViidZi6f3SR4MRzWvCT6C0STvigbWdcFI2zWW8eTmuVZEJQLJ3hUTXE1ArHSgxvaCfhKd/3nTPYIEzwxIbLlZzfhlenqJ6kDtOyHDdeK2bTQnmw==
Received: from DM5PR13CA0059.namprd13.prod.outlook.com (2603:10b6:3:117::21)
 by DM6PR12MB3532.namprd12.prod.outlook.com (2603:10b6:5:182::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 09:06:06 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::ac) by DM5PR13CA0059.outlook.office365.com
 (2603:10b6:3:117::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.6 via Frontend
 Transport; Mon, 14 Feb 2022 09:06:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 09:06:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 09:06:05 +0000
Received: from [172.27.14.193] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 01:05:58 -0800
Message-ID: <ac47ea65-d61d-ea60-287a-bdeb97495ade@nvidia.com>
Date:   Mon, 14 Feb 2022 11:05:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <7b3c0c29-428b-061d-8a30-6817f0caa8da@nvidia.com>
 <20220213200255.3iplletgf4daey54@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220213200255.3iplletgf4daey54@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42138a6c-7e98-45be-8eda-08d9ef993bbc
X-MS-TrafficTypeDiagnostic: DM6PR12MB3532:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB35327BC49F1EFD62E8A110C7DF339@DM6PR12MB3532.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FRDsYIVo3OfgvO5wwuER/D43IBGfhblzWLN+IsT54rGm7UzIDN95rap4dZZQG7w2bY49xfvXaOjCqwaZFf6Gt96T/yA68OnyUAstsINVWpuSbDTTPGq8w8u8saezu8LcUHmfK9ABkp0aG3uIl1VF/4oeCD+p2nCb7FFAgpRZ8XUsRYooUVwa/0uY8XrwkySrqZh3nhdffmdRZQQo3+x8/nbRN8VMXYhAyk/BwoI3FPYXTE8OQLepPNZKZGBgQ1nOHymfBWNuNjKIe7VUrBEg68a3zsIEjHmIvGcKqxN6okKxSlRRqkqxnob0q9CveBEKTIfBVio+J8joNPp3uu1ZiXJ7SswLecFCgB1PTgBoKQ01/SPxbz1cEiBXBtsvbeGcmQdO+0PlG5tVnPkTjzPM+mZ+Wr42wjDqZ8Oz8yVGOWEtUn8WHh6mJQlEzkvHcY7gG7zt7exNJ0AiBdtOmNSICRD20WNUqwp5fAuqW/vlerNtiyMCSNWk4MOWtWsPgYo1EHio5wLtQG/Phm9rxb9RZmIlMoUsDpLg/UjOCmiSt5PASmgJ5VCW6Dd805HQxPXbsT7q8EJADKauPYs6lFGSb6fQX/gVgRpgkTbfX+1KKxR8P4pW1QEh1b9M/6UEYEIU1uB7t6YGJ/DcCbV2URddx/+Rp2w1DTNcmuvcofoPVDMWKslJTg3+M++3ZRzOnuDjNfJxvZLtCyED4MejYPkqMl/rbHPSWwnuh6k/g4PRjr4Gdq88JQxGSMpWX/dDKAtu
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(31686004)(47076005)(36860700001)(83380400001)(336012)(26005)(2616005)(40460700003)(16576012)(53546011)(426003)(6666004)(508600001)(54906003)(6916009)(316002)(2906002)(186003)(70206006)(5660300002)(8936002)(7416002)(4326008)(16526019)(356005)(81166007)(8676002)(70586007)(82310400004)(31696002)(86362001)(36756003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 09:06:05.8071
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42138a6c-7e98-45be-8eda-08d9ef993bbc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3532
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/02/2022 22:02, Vladimir Oltean wrote:
> Hi Nikolay,
> 
> On Sun, Feb 13, 2022 at 08:54:50PM +0200, Nikolay Aleksandrov wrote:
>> Hi,
>> I don't like the VLAN delete on simple flags change to workaround some devices'
>> broken behaviour, in general I'd like to avoid adding driver workarounds in the bridge.
>> Either those drivers should be fixed (best approach IMO), or the workaround should only
>> affect them, and not everyone. The point is that a vlan has much more state than a simple
>> fdb, and deleting it could result in a lot more unnecessary churn which can be avoided
>> if these flags can be changed properly.
> 
> Agree, but the broken drivers was just an added bonus I thought I'd mention,
> since the subtle implications of the API struck me as odd the first time
> I realized them.
> 
> The point is that it's impossible for a switchdev driver to do correct
> refcounting for this example (taken from Tobias):
> 
>    br0
>    / \
> swp0 tap0
>  ^     ^
> DSA   foreign interface
> 
> (1) ip link add br0 type bridge
> (2) ip link set swp0 master br0
> (3) ip link set tap0 master br0
> (4) bridge vlan add dev tap0 vid 100
> (5) bridge vlan add dev br0 vid 100 self
> (6) bridge vlan add dev br0 vid 100 pvid self
> (7) bridge vlan add dev br0 vid 100 pvid untagged self
> (8) bridge vlan del dev br0 vid 100 self
> (8) bridge vlan del dev tap0 vid 100
> 
> basically, if DSA were to keep track of the host-facing users of VID 100
> in order to keep the CPU port programmed in that VID, it needs a way to
> detect the fact that commands (6) and (7) operate on the same VID as (5),
> and on a different VID than (8). So practically, it needs to keep a
> shadow copy of each bridge VLAN so that it can figure out whether a
> switchdev notification is for an existing VLAN or for a new one.
> 
> This is really undesirable in my mind as well, and I see two middle grounds
> (both untested):
> 
> (a) call br_vlan_get_info() from the DSA switchdev notification handler
>     to figure out whether the VLAN is new or not. As far as I can see in
>     __vlan_add(), br_switchdev_port_vlan_add() is called before the
>     insertion of the VLAN into &vg->vlan_hash, so the absence from there
>     could be used as an indicator that the VLAN is new, and that the
>     refcount needs to be bumped, regardless of knowing exactly which
>     bridge or bridge port the VLAN came from. The important part is that
>     it isn't just a flag change, for which we don't want to bump the
>     refcount, and that we can rely on the bridge database and not keep a
>     separate one. The disadvantage seems to be that the solution is a
>     bit fragile and puts a bit too much pressure on the bridge code
>     structure, if it even works (need to try).
> 

This is undesirable for many reasons, one of which you already noted. :)

> (b) extend struct switchdev_obj_port_vlan with a "bool existing" flag
>     which is set to true by the "_add_existing" bridge code paths.
>     This flag can be ignored by non-interested parties, and used by DSA
>     and others as a hint whether to bump a refcount on the VID or not.
> 
> (c) (just a variation of b) I feel there should have been a
>     SWITCHDEV_PORT_OBJ_CHANGE instead of just SWITCHDEV_PORT_OBJ_ADD,
>     but it's probably too late for that.
> 
> So what do you think about option (b)?

(b) sounds good if it will be enough for DSA, it looks like the least
intrusive way to do it. Also passing that information would make simpler
some inferring by other means that the vlan already exists in drivers.

Cheers,
 Nik
