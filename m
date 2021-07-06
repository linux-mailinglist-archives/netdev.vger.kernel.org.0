Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B09F3BC7DE
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 10:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhGFIdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 04:33:16 -0400
Received: from mail-bn8nam11on2068.outbound.protection.outlook.com ([40.107.236.68]:56161
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230389AbhGFIdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 04:33:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZ1x1t0CeVWqeXXPoJB4IyBPoIPFml+VIszZdxqLKpxYSAQCTrRTQP99jkl6L5GbOzRTYz53lHFSsUE58b2Amc43KT2Ir9VUIPRPzJUFtjXOBc/BozxWjpZKRorcj/ir8uVUJrxTkFRtPf302nfWRt11wyi70LQ+DKdrPA3siQVPlnz6H4jyGQRsFYF7L40btCrw78MjW7aXL5NKVE3X4Jl0M+b7c4GgyoqTjFvp9n8/fXlRSUMnaZCoe02yunRm2+Z0NNvbiSWTZVI06l4qeFTRmj76vaiTrMEh0gKhOq1oumVQmi6UlojrtgakbC2TlZHQHQfbIolfvjtfxlu6iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9dkP0iIMswMAzvlxQK2GI33FHRDO8U64zoSWNnMMEOg=;
 b=l/pUIGptMbAgG7dJ5PxZWFzXfdGKlsNLtVeOhtV1Op1EDQbb6S1INi9EweS9nMnWge69Cu46w3m9+F9zW2cYo+t+N/XlchwkXNedoLGxzSJ1IpYwqFtVGvIOt9cVp5Pqd7VwvJoVqXNoNCFdlCERRT26xVjfYRUL/v2rY9oraGjQ/pW3Ffof5ZTwikTwmqNmog9AMLQpIjkl8QD4b00qVTuhRSmWuqvJwH+zEPVMuEoQx0HbbzWCFoo5AK7Pw28uwpSujVyE6Pm04G9N37j7PWVzVH7X+6EeLRLxP6DLsPlUi6+AgJ3FR+N0rYWcVV4f1ScnxX0h5ah6/HEOLyTzaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9dkP0iIMswMAzvlxQK2GI33FHRDO8U64zoSWNnMMEOg=;
 b=G5RmZlX1ooWFgy+z+HQO3sRwjn9aeZAydqcmqxLKjb9zyURFvuoz/ymVTAbs36brByj97tUbTYjgMwljqoC+J+Ol33xhudcWqF3rPzNco8QTB0E0dioGkPyAaKZSGVvW3cxbGk1kVGbFAS1AgHTCSpq3on2FR/u035DnEtwo1twCy1GAVrHHHzDKtrJFDgil9maGzKsLQQzoUtW76OZnXhwUDXfxSE/MN7l/Qze+oBcBm8iMwzfco8OADWJm0ns/hCKdyVL5cypyQac19SIaZJzlU83T5aCBJR2ijWQprGVPtaFS9wEsZVsQW3RNnxeIDPZAeN8ziupRavH+JsHuXg==
Received: from MWHPR15CA0060.namprd15.prod.outlook.com (2603:10b6:301:4c::22)
 by CY4PR1201MB0104.namprd12.prod.outlook.com (2603:10b6:910:1d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.30; Tue, 6 Jul
 2021 08:30:35 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4c:cafe::6a) by MWHPR15CA0060.outlook.office365.com
 (2603:10b6:301:4c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend
 Transport; Tue, 6 Jul 2021 08:30:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4287.22 via Frontend Transport; Tue, 6 Jul 2021 08:30:35 +0000
Received: from [172.27.11.204] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 6 Jul
 2021 08:30:33 +0000
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
 <20210705092817.45e225d5@hermes.local>
 <3678ebef-39b3-7e00-1ad1-114889aba683@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <5918cbc9-9569-15fb-6ee6-fea13a7cca2d@nvidia.com>
Date:   Tue, 6 Jul 2021 11:30:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3678ebef-39b3-7e00-1ad1-114889aba683@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8d40548-f7d2-4fd4-3f33-08d9405853ac
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0104:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB010421CDBFBA0B23E06CA4C2B81B9@CY4PR1201MB0104.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3337IqXFM6QGCHe7lss4k9/9g+PefPLzC9tQa0EiqqZId+EQPGKHNw5SJ+iaEpKdoQRuzO0HWv9cGg1W6XrZFzI2uev+D0GqQrOjNVsA53MeIBrc8qpQU6/RUtpRI3C2PN8QXGsLiM4w6GoqVGSv9AnWRXDN6tKwpHeHR/F6nKGWYZpvwodZb+Z7JJJlFJK+150sQ37dCDP4OG7uM8wo1U+642hVtJ15bCnDmqxD/Gx7erfKNTz/ZH/w6+W8IBySbUaVoGUCEXDvuFwhmBM9ZAMpj+j6srwbV9FHurQnr7g6ow83T8zpkOjLXC0DrFtJBWx9x2ukvUNExTCQUQbrDTlW1NWE9TU3SSV4kSsU1jEUQvH3DcFIRsr7bAfsIl3Y2Hmgwvf6VrzgPuRSqnVlY3A8BcK0Llr03Bgf4v6UUTzO9iB51u+peTw7TOAFCliys30/D9c8WfwdvQlhWLYg8qw6AKVv26tLW5O7jCFC9PrcvvlAOttyubS148KlzS7K/4jtnvF4CwV2DbaUa6zgQAkl2QFmb08zmFDI7+HKhKmTHOiFVVZywe+tsKv/8tv4SbqIwpuXzQ9JkmoGn31BOKq4fZTaEJlZMvJDfFUa9cZ7a8AKMlKMyj4Yk9a/zfN8LU1C2tAy66Xx4qIOnzVWQCyHPtg9ftgyjvVoqHSZSn5b6JVqrPpqwSvZnHg1+/wLdnNpfNVF8WCPIWK7hxPVeDDDYyPAZGtphvRUxMGK5UM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(46966006)(36840700001)(82310400003)(86362001)(31686004)(7636003)(478600001)(31696002)(26005)(53546011)(186003)(82740400003)(47076005)(36756003)(16526019)(36906005)(4326008)(8676002)(336012)(36860700001)(356005)(2616005)(5660300002)(70586007)(70206006)(426003)(110136005)(16576012)(316002)(4744005)(54906003)(8936002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 08:30:35.3743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d40548-f7d2-4fd4-3f33-08d9405853ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-05 7:30 PM, David Ahern wrote:
> On 7/5/21 10:28 AM, Stephen Hemminger wrote:
>> On Mon, 7 Jun 2021 09:44:08 +0300
>> Roi Dayan <roid@nvidia.com> wrote:
>>
>>> -	fprintf(f, " police 0x%x ", p->index);
>>> +	print_uint(PRINT_ANY, "index", "\t index %u ", p->index);
>>
>> Why did output format have to change here? Why not:
>>
>> 	print_hex(PRINT_ANY, "police", " police %#x", p->index);
>>
> 
> it should not have. I caught it in the first version in a review
> comment; missed it in v4 that was applied.
> 

Hi,

I replied to your review in v0 that I wanted to match all the other
actions output which output as unsigned.
Since I didn't get another reply I thought its ok to continue and sent
another version which other changes that were required.


