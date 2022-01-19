Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED8D4938D8
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237771AbiASKqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:46:52 -0500
Received: from mail-dm6nam12on2071.outbound.protection.outlook.com ([40.107.243.71]:23777
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230132AbiASKqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 05:46:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZG//PqSWsmMcVc4AYvaBQTTwGg8zOd4R8wxoF2Fx6VvkAbzaPip4pMB/opKP8dUqNIOQDiCKBLcmKR7ICrEts4LlWWt8y4Upb4p8qXKkQ+PG9IBD3jV1hbRHlTTF/Mi2UNw3i68qtnD54IdDGX6lCvEw+0/Xbd5lpC5QrzPRflpKnGU+2aYUNzSdUI4PS4Xy2P9y8kKiBa8e0rsMwiaXiCKkzOkxcr6RtZIhDIZcw2XCPRpvVkUdREE9aBLbgdsq3ecmxAbGDYdpQvOE5MKznAFFN4Ls6YCAJQa0AE6P78Z1QCjUFvfS+e5TKfMUdsPwzDUtMeMze7hc5a3jiQqcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1A0R54uBLWB7ltKj6M61Z0180A/EsVYAbMTFXd3jrcg=;
 b=jOluB0YpDeFL6oJHLcYNuj0NRwsVxJsfOdjXNQohZuRjUofvxaH71S9sSkCdcigLGN9s+GgOZJ/ErQnfCpnq2XdhYW9X8OIMKgr7X0yvagITawqq0q/ovGDZLd0cNwc46b5PVpUV/eoStqmv/Kdy/FIPg/bheV7Ukt0jgsLtuo+2K9MoRe/NZnZ6QkiAOlWRxRwAwYMnUTOCzuKOZxHZti5wfmopn/8j3XS3FMP/QfgVE4xghUF25wLxeFafoN8f3kUxmbUtkeTC+pQn5QXyN7NZGsODeze5lx330CYU+9QVeJfCbe1696GnzUWMJVUuF4qLTZWxX89brWLqkgT/Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1A0R54uBLWB7ltKj6M61Z0180A/EsVYAbMTFXd3jrcg=;
 b=Ko56ssBA5ciReLvi/L3Ty2TOrcYREGyon6+jdKFmuHYh0SzVdogdOA/K+R7QSAN0GKg129hIvNlqQkWBCQsZrhGh93i3fIpGN88b3jcJt7CLc6E7b9mfn7FIcr5wABBjYilbKYNM/cU8OM/5gMkUpF2Fr/ikHxpzSJ7xP6uRntJwpRu1C+L25uFAkBLKdaRuXEnaC1sla4obVRKjnQBH1TFPaOF+n4cZyfM8qhL2ngLe+4UcKHLjP/ZIjx/Cq19C8QthpIa+Ny6i1yYf9BNQ0Em/Whjuzcnp4L4WZVL/02A7hrsrYkfGbRAlpzVsmGZ66zrhosOMSHASYq9PDynPhQ==
Received: from DM5PR15CA0052.namprd15.prod.outlook.com (2603:10b6:3:ae::14) by
 DM6PR12MB2890.namprd12.prod.outlook.com (2603:10b6:5:15e::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.11; Wed, 19 Jan 2022 10:46:50 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ae:cafe::a4) by DM5PR15CA0052.outlook.office365.com
 (2603:10b6:3:ae::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7 via Frontend
 Transport; Wed, 19 Jan 2022 10:46:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Wed, 19 Jan 2022 10:46:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 19 Jan
 2022 10:46:49 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Wed, 19 Jan 2022
 02:46:47 -0800
References: <f6e07ca31e33a673f641c9282e81ee9c3be03d3c.1642505737.git.petrm@nvidia.com>
 <0758f5ce-2461-95c2-edc0-9a24e44671d3@gmail.com>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        Maksym Yaremchuk <maksymy@nvidia.com>
Subject: Re: [PATCH iproute2] dcb: app: Add missing "dcb app show dev X
 default-prio"
Date:   Wed, 19 Jan 2022 11:38:54 +0100
In-Reply-To: <0758f5ce-2461-95c2-edc0-9a24e44671d3@gmail.com>
Message-ID: <87pmooove2.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16bf64b9-267f-4c09-342c-08d9db38ffc4
X-MS-TrafficTypeDiagnostic: DM6PR12MB2890:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB28900764865C96A6A372C6C8D6599@DM6PR12MB2890.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hn2oQzfvbX7rBElM7z/WqF2kpTU3u8ZdzDkkfiRBTJoYr7j3nF4uwWZndkH3SXG8XfFsdM/6+R3AMpkQTBlV3ZcemQLFnlAi3EMd0OzozhH+QkahJlN875FT/OJcj3W+q38DkgzLcZksmsDEf4/v939tIkotpo+cXuBpLDWvG4ACFzkx/ogqHDmLHGV9SZZCwVhcMBVlzOzNSa/UfytAL6PA2l1vx4toK+I2Z68O5b8j6bOcSbXEbePx2yIWwyGv8VR1gRiZO6GGO8TlNjF3M+nJdR9Ks8BOVIYRnvfmy4kI23Ct6o22O9SJCoCJSFYrVpf1uA1UZvk+i/r0R1IZKd2+LPrwn2dd2sY34azp2c7ppJOGnQbG+0C04ait4EZSdKGLUkn34VF6ah2Ej1Kl0Xx2etGbfMMfPeTYsX2OwkAdzltUjgFIKgSUoB90AFVwwNGj8x5PD5BEmwoixi8d49ySpsOsy8vDoJawOreygvVqelUiehXR9Osx/4lnGyiIdLCWvRtPtZ2A2HEATj9y/uhfUIUbFyW6MgNP+bsiTy7PDbhXXJp0cOciZZnMcawtJ7mwznW1zAqMsMw04b9SSwqPJPRCktovYN4t98ZIheMKYSo3MSDa6Wo+So9QyJKwWNaEiHnhMFNQno3Mrht3664gSfsaDk3fpAETciP/4CZfdfUCfVpabpsaPXsY4Y/VNkHaS3iCILmsuDQAoBOxGNkdz2zJNMpf14m8QHmc59CzNuXxIm+HlR6QnitouBV0EplPRdm62LMKapp8hjtjbUgufyhQ2za9ITVMftANPVY=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(5660300002)(16526019)(356005)(53546011)(6666004)(81166007)(316002)(8936002)(54906003)(2616005)(86362001)(107886003)(4326008)(26005)(70586007)(70206006)(40460700001)(36860700001)(336012)(47076005)(82310400004)(2906002)(508600001)(6916009)(36756003)(186003)(426003)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 10:46:50.3929
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16bf64b9-267f-4c09-342c-08d9db38ffc4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2890
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 1/18/22 4:36 AM, Petr Machata wrote:
>> All the actual code exists, but we neglect to recognize "default-prio" as a
>> CLI key for selection of what to show.
>> 
>> Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
>> Tested-by: Maksym Yaremchuk <maksymy@nvidia.com>
>> Signed-off-by: Petr Machata <petrm@nvidia.com>
>> ---
>>  dcb/dcb_app.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
>> index 28f40614..54a95a07 100644
>> --- a/dcb/dcb_app.c
>> +++ b/dcb/dcb_app.c
>> @@ -646,6 +646,8 @@ static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **a
>>  			goto out;
>>  		} else if (matches(*argv, "ethtype-prio") == 0) {
>>  			dcb_app_print_ethtype_prio(&tab);
>> +		} else if (matches(*argv, "default-prio") == 0) {
>> +			dcb_app_print_default_prio(&tab);
>>  		} else if (matches(*argv, "dscp-prio") == 0) {
>>  			dcb_app_print_dscp_prio(dcb, &tab);
>>  		} else if (matches(*argv, "stream-port-prio") == 0) {
>
> In general, we are not allowing more uses of matches(). I think this one
> can be an exception for consistency with the other options, so really
> just a heads up.

The shortening that the matches() allows is very useful for typing. I do
stuff like "ip l sh dev X up" and "ip a a dev X 192.0.2.1/28" all the
time. I suppose there was a discussion about this, can you point me at
the thread, or where & when approximately it took place so I can look it
up?
