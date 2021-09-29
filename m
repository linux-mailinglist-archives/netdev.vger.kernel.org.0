Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DBC41C2EF
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244845AbhI2KqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:46:03 -0400
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:36609
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244849AbhI2KqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:46:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqzEisxO6uYWiptTNUMz7gmDR1Rc4eEh/c34byGR56JxAhcUCplYpNPOWLwnAIQCx6rOGpY+FZwQVsmW99W9ISyvJwRMpCCVhUb7eoeb2zy5y1xnwb+SjnRG5OQB+iU+Hic9VYQurFreRsmR81aGeYLpE0W9OBG9Mrb9ffuwx6VxsSW3M65SeimS5MziAYiy08/JpbYK/FvqlEEOAkO1kFXgE7umnZEhEhYoYGehfAy2YiPs34HsL89HTemrtEt70+XOl/BazR7kHLOV8hlbR2rDX3q1pYowDAC7HfkoJ4KRDutRHcGwKwl6m1heipbDA025SXfdfb+gncL5e8M/7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rl8gDfxZd2jhU04r3sMO1Dg1CuWd6z9hLshx3hPVyts=;
 b=URyHMAoBkP9gLTfy4cu5CcMuWIQCXgWDdPObqDgfs5r1+/MxfrT8N1qnuLcaWnWPmQcG5AG4JH/4Pt84jUADM+0go0b/r/wc9VqJxnxU3Pyj96t/YXxm9tLQBD1QFFmLfsOLNBW1us+6VDhSLV5i7aXGYRi6jZ55Niv/ChUlkW7oh2GiIYoweclNuJanE3IZ/m0GZBCLXWSy5bBnaCBqEex/HcIhqq+zYw2SPbhOaK1Op4FDBqCZ/LDpN+0sz456xPjRCHVgZY65MZ0hfUtqgj2VaFTu5E5pxLSEz7oXmzSJzoXWhWrfYT8XgcBZswNP76+cFaVLRbfWnO+t5FNI4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rl8gDfxZd2jhU04r3sMO1Dg1CuWd6z9hLshx3hPVyts=;
 b=jV6pRZvhuzRk0AyHX2sEFqWm2kpcq8r4iTvsk+epT/Xq7C3hTM1F9XR5XzEanuFQhRFRJf031HToz3S5hoX9oLycfSGQErOa5ETJMQmoErR60Pfuen3kCW+NAExpEIrY3cYPosPAz6Sh4vzyiqlSGtmAcJRyKsj5MxtBKeYY6alYD1VTI4BwG2XTOIsAEy32yQ2w3RNL/9AzOFBw29YEG/1/aYb4xET2ShFO6wLF3mBPhFQZfU5gFtL+34IxBOoat78tHhkjQsyLza3c23t/GNMecZMauRJZxKQkgPAHKjd2MKxeQ5snVCMIVIsyIm4mPdrL0yIDvxar35lhed10FA==
Received: from MW4P222CA0018.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::23)
 by BN6PR12MB1122.namprd12.prod.outlook.com (2603:10b6:404:20::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Wed, 29 Sep
 2021 10:44:19 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::41) by MW4P222CA0018.outlook.office365.com
 (2603:10b6:303:114::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend
 Transport; Wed, 29 Sep 2021 10:44:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 10:44:18 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 10:44:17 +0000
Received: from [172.27.14.186] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 10:44:13 +0000
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <cover.1632305919.git.leonro@nvidia.com>
 <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
 <20210927164648.1e2d49ac.alex.williamson@redhat.com>
 <20210927231239.GE3544071@ziepe.ca>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <25c97be6-eb4a-fdc8-3ac1-5628073f0214@nvidia.com>
Date:   Wed, 29 Sep 2021 13:44:10 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210927231239.GE3544071@ziepe.ca>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f712be06-5225-4198-cbc6-08d9833616f1
X-MS-TrafficTypeDiagnostic: BN6PR12MB1122:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1122E8C59F5F942CA448AE17DEA99@BN6PR12MB1122.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fU4KJqFLGoFWFBAM153mthjjlJlPKhtF9tvftCUQyUx1BE1RIi8tBummXWia/oix0yoIhlZcslS4TP6+THv72D0LlpIaxmtbdnK+0rG17SmYs04YtFFZEZomf7ZZxp+deyBAQK3iziOLJ2JvO7EYvofmpYJToagvgMp6YZZGUrEVVIuSUH0/PLL/Hb9wbPLBV0IHn0KvRkMN8/vVCISFn3EftRtAv4h1pkNIImLxVjnYRmhkbQVO4PurGg9Q3/OrrOLlXPEqSbM/OBge5vZ8JCZ1i7srmlyz0w1MSH2Tusp4FJ9DgUlKmQJZ3cKt32+2J3UUe2YMaYAXpmKSeOhiPeXD6EOL/21D+LYZJy3dEaD6N+M/GvQ/A6SZre01G7D9kGTAgpVZ3psUWNhI9S+OP7oWM+MiY3SmE5t+onLGNqwVEkb0fZ5iozvwu2Foc1rC+Nb8Q54fCZDmNUqUGxAyeaoNK7aPlXKmnOmU8PT5674rFOT5FdS5M3L4sE9sFUykH+AldItM6LdNT9kdDsT2jAXyM8f1RBEtOo8sAiyRUIRf8oRxeqzNFkyxtM0RmAZZUGrczNoMpSAi6QeBLWAhXj8Qagua9Fzq8IOIkWMXZ13J1tmF7vkSXVZBAoG9siqWOAluMg+Xa1JVLUii0yV5v8f8nYD2lgw5Kr0CRLmiHfVrpLyvS+CSSpeV5avBgzlLPpP+TKYxgVJ5rjsFuraFiRq0BzkBf/D/xdlWW9WRKK8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(26005)(110136005)(54906003)(31696002)(53546011)(82310400003)(47076005)(508600001)(16576012)(316002)(5660300002)(31686004)(2906002)(336012)(36756003)(7416002)(356005)(186003)(7636003)(4326008)(8936002)(16526019)(8676002)(70206006)(2616005)(70586007)(83380400001)(36860700001)(426003)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 10:44:18.5015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f712be06-5225-4198-cbc6-08d9833616f1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/28/2021 2:12 AM, Jason Gunthorpe wrote:
> On Mon, Sep 27, 2021 at 04:46:48PM -0600, Alex Williamson wrote:
>>> +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
>>> +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE + 1] = {
>>> +		[VFIO_DEVICE_STATE_STOP] = {
>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>> +			[VFIO_DEVICE_STATE_RESUMING] = 1,
>>> +		},
>> Our state transition diagram is pretty weak on reachable transitions
>> out of the _STOP state, why do we select only these two as valid?
> I have no particular opinion on specific states here, however adding
> more states means more stuff for drivers to implement and more risk
> driver writers will mess up this uAPI.

_STOP == 000b => Device Stopped, not saving or resuming (from UAPI).

This is the default initial state and not RUNNING.

The user application should move device from STOP => RUNNING or STOP => 
RESUMING.

Maybe we need to extend the comment in the UAPI file.

>
> So only on those grounds I'd suggest to keep this to the minimum
> needed instead of the maximum logically possible..
>
> Also, probably the FSM comment from the uapi header file should be
> moved into a function comment above this function?
>
> Jason
