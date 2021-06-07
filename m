Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD86539D4D3
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 08:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhFGGS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 02:18:56 -0400
Received: from mail-dm6nam11on2066.outbound.protection.outlook.com ([40.107.223.66]:40545
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229436AbhFGGSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 02:18:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEOFexrAKignRM2JVsvNprtOr8HVszkwhRvEK/XmNy52xrEX+89YlRCVVuXq8y7ozDI6jPdC+oxV5dcmnT/1aWptkcBduPZv8YQobDWvvYsOKTYbWL+OpSgLP+6GZFleS8OlGc6lGbaYF2JKYMj8f05nbP79J/fB1GG/cGShwz6ZLvDlzK9K8T+UbqaVBmD6Skn5fDvoajqsHSBzA8UbZ7MS1hUDRTIPIhJfzDrDQZkLjJq8YV5/v/6C7x31LEfeAptmDse2TBkTE5pU7lxXzhPq8sZRWqh6ZPsKGIgBaF0KRY6a8vKVMHTkBrH0YPjvUSERo+0LhR7QN/XydxWwHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUwia+JPAh1CZ4fPr5K1p+poC4MEIAUWoxWXJGWnk3Y=;
 b=VR0L6BN2zTnot5nLn1NxsEsNkVjc4ymr3Rf7PtD7gfrFkk/ZGsQHPz302qNPKatcvRMFRYuGTnNMlytuYCasgibY9gkyYcs4sH94NzuzfUdfVTQ49Upmd6qks4B0WMc7MpR4gOxHNDHxDpjR5o1tILrUFufRGsD6/2XKgk7dA7CwOOgRCLg5Z/jqukoru9iHEkemX+eSoz9B0p+XZcMu3lldqqz3PDqTDezVckvUapkPYhIyLe/cISUVqd0MjT8vmuDR8VWFnO5jwkCrhEyVQlLiMYFR997YL9y5FSJdEipObPUF/6Go+PJZ249N/NbkaKIFIucytyELG5GgJjXJXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUwia+JPAh1CZ4fPr5K1p+poC4MEIAUWoxWXJGWnk3Y=;
 b=txl4lAtpqeoXaJZaS2jwu9dikJ9ko6+VuZK3g7o/d02N1YHVhj/zEP3ZYCGel1P3TSx2JQeOMSFCH2Chc79gZ+q/dSXciXf20E8aEEVTjWD6TFIEGvU4f9Vi2E39DuCVwbgLl4th+kB+MK7YijQeIlpbcfHbwVVVTEVpTnJ97dmOlFVwpMKKL+ZcfpeMMFVBwmChDHRbrmeWvhjmeZrrEUY095A5UHqfz88ac174E2HJzG7/siT3whRj12OC57rKORXnS5ddjHNWaub492dkHqd+xUwC8OEDFLYGYtabfl27LTZOrXVxd3M6Hkc0EJQmKlLphEpZILOuO/C90rgunw==
Received: from MW4PR03CA0354.namprd03.prod.outlook.com (2603:10b6:303:dc::29)
 by MWHPR12MB1519.namprd12.prod.outlook.com (2603:10b6:301:d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Mon, 7 Jun
 2021 06:17:03 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::f6) by MW4PR03CA0354.outlook.office365.com
 (2603:10b6:303:dc::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Mon, 7 Jun 2021 06:17:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 06:17:03 +0000
Received: from [172.27.13.27] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Jun
 2021 06:17:00 +0000
Subject: Re: [PATCH iproute2-next v3 1/1] police: Add support for json output
To:     David Ahern <dsahern@gmail.com>, <netdev@vger.kernel.org>
CC:     Paul Blakey <paulb@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210606062226.59053-1-roid@nvidia.com>
 <4926d9e1-4b0a-75b8-6a63-c1fd67eff58a@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <a8ac760c-e05e-e01c-4c84-5883370ba403@nvidia.com>
Date:   Mon, 7 Jun 2021 09:16:57 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <4926d9e1-4b0a-75b8-6a63-c1fd67eff58a@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f68fbbe3-6d81-4fa5-8d00-08d9297bde0a
X-MS-TrafficTypeDiagnostic: MWHPR12MB1519:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1519D161CB3FE5BB94FAD579B8389@MWHPR12MB1519.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9srs8T9jOprD1k1CaltrCGev0AMpKmNm0rLpCAAIwQ0xc53fsEc2hUCqsBw6/j4/KXP++PwHzU3+sb6UZDJFjqSch+mHwwXXMxkkClHwXHYIkpRWapPbOIOP8damPvr2qQ52lgMTimgf5QtXvhDfd942nXAjx6bg/QvIi47REobAxSrzk9LYNF2WMQzP80VNYoos6IetiKWxPRfDmXdOhcsz+O16HxrjmrKEQmfgzsGVVZlFiC9YXe4J6D4g6sUJRu4pG0JCxBa+YQpiTpAvvfWObreN/UFJ7HKsXMQmghqvftHARYCEm3m+sxzeuPMj9wE4EJeMq9oocQJ/LDbD5gpMgXe2P4xlUtbLDpBcpNROduMdlysZTyUY1bgBgJEI2vjULRClAM28fN2y0JXMcr57onfkRvPp8QB2JSGviFjPMNxQ1yn3lyfiYR0VNbdaw5YbOQugFiGH++CODUuCs6frjl+hCKGm8JZTEiFeAkl39W1Te947TLvApJ+p8fUjAYib08yeuF990DheNPpuvDRAej+xU5KdEgIgLEdPa8HYSVu+Px4Fuh9T+teCYduZvwQ0TDmpht33mFsJg1fxzE7WKjlw/MXbWzLt9826YVw5HdEDoOQY+MIt++O+B5on5UhKV23XH9+Ff/Bdg1qIq6O6Z1sYidqHwz8bXowPpPki7fz413aqWH0zDK4/DTUJ
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(46966006)(36840700001)(356005)(86362001)(53546011)(16526019)(186003)(4744005)(2906002)(7636003)(478600001)(47076005)(4326008)(426003)(5660300002)(36756003)(16576012)(54906003)(110136005)(36906005)(316002)(31686004)(8936002)(36860700001)(6666004)(31696002)(8676002)(82310400003)(26005)(336012)(2616005)(82740400003)(70586007)(70206006)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 06:17:03.1496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f68fbbe3-6d81-4fa5-8d00-08d9297bde0a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1519
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-06-07 5:48 AM, David Ahern wrote:
> On 6/6/21 12:22 AM, Roi Dayan wrote:
>> diff --git a/tc/m_police.c b/tc/m_police.c
>> index 9ef0e40b861b..560a793245c8 100644
>> --- a/tc/m_police.c
>> +++ b/tc/m_police.c
>> @@ -278,18 +278,19 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>>   	__u64 rate64, prate64;
>>   	__u64 pps64, ppsburst64;
>>   
>> +	print_string(PRINT_ANY, "kind", "%s", "police");
>>   	if (arg == NULL)
>>   		return 0;
>>   
>>   	parse_rtattr_nested(tb, TCA_POLICE_MAX, arg);
>>   
>> -	if (tb[TCA_POLICE_TBF] == NULL) {
>> -		fprintf(f, "[NULL police tbf]");
>> -		return 0;
>> +	if (tb[TCA_POLICE_TBF] == NULL || true) {
> 
> why '|| true'? leftover from special casing tests?
> 
> 
> 

oops debug left over. sorry for that. fixing.
