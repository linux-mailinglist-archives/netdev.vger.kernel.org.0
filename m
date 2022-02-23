Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6CF4C09A7
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbiBWCtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbiBWCte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:49:34 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDCF6371
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 18:49:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxB+HRCP6cVVXEo9WaK1smfliDkplfGer3mKnNwpzxbb6y12+b+CaFfwvx6DlEbgnCBpxkF+SxHitngbLXRG90/bJ2RnWosScteWzY/Pz/gPFYE1s1ChBEp2XNJdMHM2XHsyWN8l7wHSpFrvFbZCY/a8GezaclqtSRXjHhN0BI8f43915b1/jJzEReXwwcTYe18ZTmRLYUdq56S5PW9Zf2QUGejBAqggHKKfEhY61BYshuaA1SYa1qfq1zdBj8hqyVPF3csd7sSXZx1z5UMGVKUleARde1v8vDXny2c1x4pq/W0QuIa/K7LS71G9eUm8DFh+Pia+j5NWSV46d8xRng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/vSsqTwCR4aQcFvm28ccquCs+aniITwLaug7x4csI4=;
 b=DKy12BAeTJB7RYw5sXCVptQXCLfWEfN9A6FuANjyk7lnjG09q9GXnqOAtaoJxIMZZIG0OQiWT58aGHuOPesZUyu1jV+YlXy1KsWca4/jTvqw0GH8hQ2WExwzprOQt8IJ5m3fET5/NwqbObIJz9OX05vOnffj/S4P3m03WO21c9jdYfCUy8uEA1YoiWHSB/3GID6KvjJUgGlYbFHQnXJZyt35MaIw+O9znwmUs9S6h/W2V2gTtS5c3Dge9LjRaL4lsUnsJlFo0jC4GFFCWhY2jN4tzpr/cvHcXcK2I4K5RVfXh3wZiWZLmG0gUmnV/JFcbhtBEJkUEhM8w/U47NbP/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/vSsqTwCR4aQcFvm28ccquCs+aniITwLaug7x4csI4=;
 b=C61araTzEk/1/qC3amySiAMdPgaUfDFfaUbViS9obrL1skkyYEqboa82yRvsGZMSkPfQUpreBpvk+He+t/3hz9oIcB8S8I5Nhzdz2ZPpsjHq0p/Kedht+mtLkPZ2qXOp4iQfHrt7JRGxkAPAhLTJFTsc7Dpi9LhTv1PNvaEeHQ1f3kWSTmNMSiUF7lYdhPSBkWuLVPtNIW96j3tFWtzmV26ZW34L7ZPU64ufKbSEhkYXwassLOO6Iid9cmvla9xLmB6H1oQUv/H67ud2xi6fdvAxKC+9TzozQmB47d7DXri3ofu3dUD3CcRISBEXpDcAFrR0hzTiy4+qmr5tnoBArw==
Received: from CO2PR04CA0067.namprd04.prod.outlook.com (2603:10b6:102:1::35)
 by DM6PR12MB4340.namprd12.prod.outlook.com (2603:10b6:5:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 02:49:06 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:1:cafe::c0) by CO2PR04CA0067.outlook.office365.com
 (2603:10b6:102:1::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Wed, 23 Feb 2022 02:49:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Wed, 23 Feb 2022 02:49:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Feb
 2022 02:49:05 +0000
Received: from [10.2.163.46] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 18:49:04 -0800
Subject: Re: [PATCH net-next v2 07/12] rtnetlink: add new rtm tunnel api for
 tunnel id filtering
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>, <nikolay@cumulusnetworks.com>,
        <idosch@nvidia.com>, <dsahern@gmail.com>, <bpoirier@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
 <20220222025230.2119189-8-roopa@nvidia.com>
 <20220222172630.44bba0d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <920ce92c-46e2-3b8a-4d0a-40daaf049b64@nvidia.com>
Date:   Tue, 22 Feb 2022 18:49:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220222172630.44bba0d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2dc8b4d6-f7b5-4922-8f4d-08d9f6770ed7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4340:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4340A5BA70A11B83231E2942CB3C9@DM6PR12MB4340.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4tqus++YW1atKY7i6yOQQlARifLIHZW9Neu1yc0fzXhItl56amu28ZAzWUEel4D2C1lfOpRobU1z+RA81zYyUclB/x/ip1YPI4ySSkmfyZjV6+0hCJUu4j7XCYtFa5zGVYzEUPXicqPi5ye/MCVNPI4NbzPidq6uKVbgS84ryfK72779Oz6aXl2ANre0XaRGt2IajKmmQ2imZNITYuEdf7rIYqpw8Dw332lLx8SwgIK8/HFEsSU3BfzXJ63ncSrf/bqfgHF8Gw4rzB0hKA2FV9Y29w/8COrOAIWvpj0D0sST52Iscp264nX7VnO6R8SpbQrj6xTbloy0k3kufCH+5R12/YY+jEAACh4ySDeGg359NQ+TzOQbebQAVH7rwScpwg9qnQRAh5kkovtEhZlTDgN/jjWaBTvcVx67ROy1vqYL1K2kZJQ8KqLepw2QnQSS9ctRM7qGjWHmYhv5uKZuQNJUoJwdpPT5WazwZ/1l4IcOAS+Os9xiCCs59onhuQ+BQoZiZCZ6X6560sxvHQE9VjSfrNd5UsrjjWYuum/KNWHy3zwcmYRmWJ32TTRF2GYy9LN1a76g4E8xhma732v5GejRJVnuU5P7hFAE647Hc2lpjmtH3Jul6gZBeMnbcFPEanVrhqemoF7pzAnTzzueDojzm0i1gToztPvFq4XnYX4gw0oJOa5vlZlYFAYllXjVNLDOsB+HeZOW9MzSlW3kH8DdhgdU5vfvZa/cTyR+qj4evo6zDbTGTY9GEI+cigDc
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8676002)(31696002)(4326008)(70586007)(70206006)(356005)(316002)(31686004)(16576012)(6916009)(81166007)(54906003)(5660300002)(36860700001)(508600001)(8936002)(86362001)(40460700003)(107886003)(53546011)(2906002)(83380400001)(36756003)(47076005)(2616005)(26005)(186003)(336012)(426003)(82310400004)(16526019)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 02:49:05.9091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dc8b4d6-f7b5-4922-8f4d-08d9f6770ed7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4340
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/22/22 5:26 PM, Jakub Kicinski wrote:
> On Tue, 22 Feb 2022 02:52:25 +0000 Roopa Prabhu wrote:
>> +	RTM_NEWTUNNEL = 120,
>> +#define RTM_NEWTUNNEL	RTM_NEWTUNNEL
>> +	RTM_DELTUNNEL,
>> +#define RTM_DELTUNNEL	RTM_DELTUNNEL
>> +	RTM_GETTUNNEL,
>> +#define RTM_GETTUNNEL	RTM_GETTUNNEL
> Why create new RTM_ commands instead of using changelink?
>
> I thought we had to add special commands for bridge because
> if the target of the command is not a bridge device but possibly
> a bridge port, which could be anything. That's not the case here.
>
> Is it only about the convenience of add/del vs changelink where
> we'd potentially have to pass and parse the entire vni list each time?

yes, exactly. that's the reason. My first internal version used 
changelink and soon realized it was too limiting.

especially notifications. Its too heavy to notify the full vni list 
every-time.

IIRC bridge also went through a similar transition. Now bridge also has 
RTM_*VLAN commands.

Couldn't think of another way than adding a new msg. Tried to keep the 
name generic for use by potentially other dst/collect metadata devices

