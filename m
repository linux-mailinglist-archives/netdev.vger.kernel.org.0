Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D1739A544
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhFCQGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:06:24 -0400
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:24513
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229812AbhFCQGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 12:06:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJd/amqLi3CjcYS3f/qYCAlicd6XQsPWS/HIgE/NCnIqh1uy3PFiL5OpQA9l5eum1VhzcgJtFwWvarJnfCrCS7k+0uUXGlBKjCd1bpnbRWRqv8Vk16sPkaz75or7LgUpwyf9rJYrmdh/AfQkXilQwiIVtePvFl9YHt7aOtGCTiWdtp6XWnubNSaNBrR1UM1h9G31Gy0DQNmteRX5xVWghL2U68REAfUdOs6K+mSuKnjU9EVspKlE467uCoYMjaU6F9zSlgyE1bYICPEhbArEQw4X6CnMidReVF25F6oC5ZqFOqY+v77OJl82FZlyItxMNjihoFhXQAChzxin1/y/Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SsPSbnIz8A7EwY96Sjw554gjDG9lHqeGlFJFtsNW4M=;
 b=QAO2Ubgx6LkpRpXUhsslXptOv+v+8znjJebdO4Scqh3NRqG06m2HwTLPWC8ovgMCHOClsNhvzwIdtJWMJm2mB1dwPhBSFHoXdaF/lFrG+esFev+17I42TV0ew5P2zMPgqNbMZXyoZR40YDCymAe8wijKvkaV362eeb0KnsuxbQPvcBeHtFzJaFP1LdwAdZsNAsEidhYtwt25G2TLkjcISeK8TVE97rJ/+BZdvv23YM1SmRc0MGi7PaVe3oQbKuzyJFZ84+HJraudOZqTK+DlwoilLySE9042p5YnGNGZ2SAX2VhV/GuZF99Nwi3jetsp/9Lep0v9CzmUU2q6xYLAJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SsPSbnIz8A7EwY96Sjw554gjDG9lHqeGlFJFtsNW4M=;
 b=FT28JtQlE6V8iyOnijHd1SDDy4AhapJnL6FeyWUKUjOLcaVv+Dh7FeXolIz+fT9CV832jMt8+aRL4VqAyAB0Ve+9UnxFvTvgpaymDZ//kuMrgee+FAN2fqUDGccw+NV7BPGkqNTMZ6BbwXuf99lXdsFxV28RmCVmd8jvXBErYg8zur8f09+aFfer0SogCNwpV4yk1DgAiy6/1VZTKs4WtUGHsikwfFm6S2h2IUkXzI8lH0v2wowWLAf1Xow3O+XPDkaMsqjijMFIBrJvDQ1edaRbCgoSa0ts94fFt+e81exUlbOXgcPJnTo8pIDLdlTIw/d150j/5xJJczTrNc3fVw==
Received: from DM6PR05CA0057.namprd05.prod.outlook.com (2603:10b6:5:335::26)
 by MN2PR12MB3375.namprd12.prod.outlook.com (2603:10b6:208:cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 3 Jun
 2021 16:04:38 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::a) by DM6PR05CA0057.outlook.office365.com
 (2603:10b6:5:335::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend
 Transport; Thu, 3 Jun 2021 16:04:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:04:37 +0000
Received: from [172.27.13.231] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:04:35 +0000
Subject: Re: [PATCH iproute2-next] police: Add support for json output
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     David Ahern <dsahern@gmail.com>, <netdev@vger.kernel.org>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Paul Blakey <paulb@nvidia.com>
References: <20210527130742.1070668-1-roid@nvidia.com>
 <e107ce61-58bf-d106-3891-46c83e3bfe8f@gmail.com>
 <a745235f-ff64-3f7f-1264-198649795856@nvidia.com>
 <20210603084006.3e3c9b4b@hermes.local>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <1e6420f9-6646-30b2-480e-82348b84be32@nvidia.com>
Date:   Thu, 3 Jun 2021 19:04:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210603084006.3e3c9b4b@hermes.local>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e676a6e-ba23-4977-4dd4-08d926a949da
X-MS-TrafficTypeDiagnostic: MN2PR12MB3375:
X-Microsoft-Antispam-PRVS: <MN2PR12MB337585AA31E99E72050B4873B83C9@MN2PR12MB3375.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:519;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7/eTYQtHS/iWbd58dq3rw9Km37/QMcQxDV8HEgiRAJkzs6BK/7jDZbJ81qGm51LN+aD+FPlOnyRlACk6Wl8KxBp34m4uwxK+NqqTCfhvY55qrkAJATlTc2z38JCqur4nNdJpG+vydzl/k+tyaDbhrfiyOBXDz9RV1MH2WxM5fvBzgRhMjugN0KJN3lsKWcreNLzD7cmpj0fjP8cnT4SPDfPnSSm/DwN7+4zuGgxCrNqk4GlTtQE/N9dxyHzPrYDe3MGbv5+CT94sN+DsmpVyNL/LrdtyMk0IQrjEGOBzsaC9vBJMByfUspm45FuEYhrWyqq5SQrfo4QdcNcl+UGFl2ncBSm7s/AdfS+Uvsxha1JJH/lW7LE5kisBCGOOeOTGqyg3SuRswL+/ryS+1cViABompXB0+e2Qcl/0FM4ItAESBMar/qp+KhiP+bK6JWZw8Uhh9Es1V4OzuSnqzuZ+n0gJ7Z8GJIjHThZDb463Qty6xcITkLsfbpRo5FIL0LPWrkqjjMnstpQNNtqBORCw3iKf9c+680jTDIvMp5gKyBkA4nr/rTSoIxVb+mZMIbnJgI6kqOEliDWYwiHB3JZ+x/stLxT/0ESjHeWMwAEOQirmWGHBge4/o2yglzIAZ6wz4PhNJTX5EClkN7KsVtFcacJhrKlcLJkeqf9AfD1enwtoECYTUNseqooWpqOXx8ef
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39850400004)(396003)(376002)(346002)(46966006)(36840700001)(6916009)(83380400001)(186003)(356005)(4326008)(82310400003)(36860700001)(54906003)(7636003)(16526019)(8936002)(47076005)(31686004)(2906002)(36906005)(31696002)(426003)(2616005)(8676002)(70206006)(70586007)(336012)(16576012)(26005)(316002)(53546011)(5660300002)(36756003)(478600001)(107886003)(82740400003)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:04:37.8884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e676a6e-ba23-4977-4dd4-08d926a949da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3375
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-06-03 6:40 PM, Stephen Hemminger wrote:
> On Thu, 3 Jun 2021 10:27:55 +0300
> Roi Dayan <roid@nvidia.com> wrote:
> 
>> On 2021-06-02 5:29 PM, David Ahern wrote:
>>> On 5/27/21 7:07 AM, Roi Dayan wrote:
>>>> @@ -300,13 +300,13 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>>>>    	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
>>>>    		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
>>>>    
>>>> -	fprintf(f, " police 0x%x ", p->index);
>>>> +	print_int(PRINT_ANY, "police", "police %d ", p->index);
>>>
>>> this changes the output format from hex to decimal.
>>>    
>>
>> hmm thanks for the review. actually I see another issue with this.
>> I missed this but this should actually be split into "kind" and "index".
>> And index should be unsigned as the other actions.
>> so we should have kind printed at the top of the function even if arg
>> is null and index here.
>>
>>           print_string(PRINT_ANY, "kind", "%s", "police");
>>
>>           if (arg == NULL)
>>
>>                   return 0;
>> ...
>>           print_uint(PRINT_ANY, "index", "\t index %u ", p->index);
>>
>>
>>
>> then the json output should be this
>>
>>              "actions": [ {
>>                       "order": 1,
>>                       "kind": "police",
>>                       "index": 1,
>>
>>
>> i'll send v2.
>>
>>
>>>    
>>>>    	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
>>>>    	buffer = tc_calc_xmitsize(rate64, p->burst);
>>>>    	print_size(PRINT_FP, NULL, "burst %s ", buffer);
>>>>    	print_size(PRINT_FP, NULL, "mtu %s ", p->mtu);
>>>>    	if (show_raw)
>>>> -		fprintf(f, "[%08x] ", p->burst);
>>>> +		print_hex(PRINT_FP, NULL, "[%08x] ", p->burst);
>>>>    
>>>>    	prate64 = p->peakrate.rate;
>>>>    	if (tb[TCA_POLICE_PEAKRATE64] &&
>>>
>>>    
> 
> One useful check is to run your JSON output into python parser to be sure it is valid
> 

I used jq to parse the output from tc.
jq gives an error on the original output, example:
parse error: Invalid numeric literal at line 15, column 38

and after the fix jq works and gives a nice colored output.

the fix i pointed out here is to match the dump like in other
actions. so instead of key police with value index it should be
key kind with value police and key index with the value index.
