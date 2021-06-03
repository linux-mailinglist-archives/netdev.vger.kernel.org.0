Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83E0399B8F
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 09:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhFCH3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:29:46 -0400
Received: from mail-dm6nam11on2073.outbound.protection.outlook.com ([40.107.223.73]:5263
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229849AbhFCH3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 03:29:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xf//y5rZ5ZjddNdjPsBBQUWrGFd0+WD3h1dpJ8079CG5CCYo1ag8iBuDNtgk/D6giQ4tulm/JslYMdeWx1bjaf+lum7oEKe2Vel7VxG0DTXwVCRlGgseVO2fKiAgAU21MTiZe/w1k9wVDFeoWrGidR0dJyOzPnKRJiqSH2VJUdygSEJo/+BKNpRzJHw69AiRmn3przzGmvNNh7F/lmRT/Dejlu5S59+jVq1YxDB9Kyd++oq3B5SVBlEvID+vaL/LPEc9dC4RVEctCV9ZBGx+nPwCQ7ZlD48No0o/iOiG86VbceOy6KCg7fT2OHDzh8vmrpPV1fAazc9mq2z5xKc3WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cax6b7ywcRr8llEjQF7oXU0a9v4Fc5bJcLaYQfAw5Us=;
 b=KLCDIi2cX+Jf04IMLplxu3w+CYQuOPMXMifygpOG0dFVeGU1FRRB2aMf7ltQGNmSEz9xakk9OvW7aXk1DBK+616f6qoJ6+vP7FQItkath9GUKuX0wTFCtpmLQoA5e0VFHVJB0LDv37Csvf415JTb7lFsTv4vxViEIELmfsPcUMaExvGkAXNYZKv+GzaZ5fvoaqs682vAzRrfKHQWR1TDBEdfMDGSurlbrLogQpaTQxpkby1zdD6ZsnH70HToFSzKH7b1WrlBf9lcTpeRVLOx+atMQGWPcgA4r4v3MyTvj0ZhkDZcWhOnC+wobF+6216D5VVSojaW5CgR7YRad31yXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cax6b7ywcRr8llEjQF7oXU0a9v4Fc5bJcLaYQfAw5Us=;
 b=H4oBzMocFjep9dGiQ9Olep8wVrpxr0QqBv3J50DNvdeExs46L2uSXTZUCID2JMNfieY3lJuGGPvx828RMD4jUa9lDu7BPd6cqMdCv70SzKtBXC0GWgPrprMQxX4yxQjmkpglsAWf3jwxyrjOyIuJglZmqwvnEpq5cLb1EcnXhfl2kjGb4HGE5rVabQiMPrtBGqY5BF/NsgSbYIkyhtdaxj/BOCr2nZj1IOdaHv6dX9b2dFl+3/zHV45sHUaBideZ/qRUgo+9YN1MXLC2vAv0qRM30+I5x9e76wzypVTbzPXhRKXvycMJ1eEK4LL9N35Lfdop5dxN67BVc7MwAxEJWQ==
Received: from DM5PR19CA0058.namprd19.prod.outlook.com (2603:10b6:3:116::20)
 by DM6PR12MB3322.namprd12.prod.outlook.com (2603:10b6:5:119::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26; Thu, 3 Jun
 2021 07:28:00 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:116:cafe::67) by DM5PR19CA0058.outlook.office365.com
 (2603:10b6:3:116::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend
 Transport; Thu, 3 Jun 2021 07:28:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 07:27:59 +0000
Received: from [172.27.13.231] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 07:27:57 +0000
Subject: Re: [PATCH iproute2-next] police: Add support for json output
To:     David Ahern <dsahern@gmail.com>, <netdev@vger.kernel.org>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Paul Blakey <paulb@nvidia.com>
References: <20210527130742.1070668-1-roid@nvidia.com>
 <e107ce61-58bf-d106-3891-46c83e3bfe8f@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <a745235f-ff64-3f7f-1264-198649795856@nvidia.com>
Date:   Thu, 3 Jun 2021 10:27:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <e107ce61-58bf-d106-3891-46c83e3bfe8f@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8917589c-58cc-47bd-5d7d-08d926611d97
X-MS-TrafficTypeDiagnostic: DM6PR12MB3322:
X-Microsoft-Antispam-PRVS: <DM6PR12MB332230045DAC521E4AEF7119B83C9@DM6PR12MB3322.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XpxgBHC9Hu8s3opzBsUsInbrRvjx0NNopnVYVSW5K4Kt9zu7JjnNdM7NhR1rEqBDQvhJmu5vzmLii8TWJWtK8VwMXEyJMowzsHL7HXqmfCagwcNuU2FyY9KsUfi/sE0dZAj4xi60LBgJmX7YeBPJFHRMe9A45jnBKwwG6rFKFSCZlTtPLal3WoYtlHKyb1nO0zHIv2gwQvNg/lZQGcMxu7ZVwmN9zmLOMYMGT5zY8skYRijeXPyYf1/XXz5LTgDpViZyxN2y2391JV53/4Eiamz2MAip8lpqAETEHgMFMXwJIMSpCpw1tAWulm1ZdzEalIqo0/Sdx/C+yAJlC9eIaytNQJKeCVtCdrerTHa4Brv8iUPZ6UBA4zxn3k0BD1DbnoT4L2QeFnmUzgXFVKTZzqGStYhV/opniPJgrA8BndoLUl4hmooGaTxLm09SN3pUcg+64Gppf/PExD5/7kBFMm3PHMC8c+n0dvjh/NIZJmBoqqZCPrd+Du+DtMRu3W40ivElItydJ14hn7X0MIYzWaDnJZM6Y70uNGC/YuKG+g47/Xm3SIsOE5ylkdp+9stef478I5NLOoIf5/zMs5yx/iOrzUVukQO0vLTVws3KwE6oeM+kNhYvngQC9Q+Mg4Z1wrGgx3RadzkU1/YHbD98p5BHX1d6Nv72Wp8RkWGSGHgLpTrfPKz/0Ya/Usf2ubCC
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(46966006)(36840700001)(26005)(36860700001)(2906002)(4326008)(47076005)(8676002)(31686004)(110136005)(356005)(86362001)(70206006)(16576012)(7636003)(478600001)(31696002)(8936002)(316002)(82740400003)(16526019)(36906005)(186003)(336012)(83380400001)(5660300002)(70586007)(426003)(107886003)(36756003)(53546011)(82310400003)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 07:27:59.8778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8917589c-58cc-47bd-5d7d-08d926611d97
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3322
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-06-02 5:29 PM, David Ahern wrote:
> On 5/27/21 7:07 AM, Roi Dayan wrote:
>> @@ -300,13 +300,13 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>>   	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
>>   		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
>>   
>> -	fprintf(f, " police 0x%x ", p->index);
>> +	print_int(PRINT_ANY, "police", "police %d ", p->index);
> 
> this changes the output format from hex to decimal.
> 

hmm thanks for the review. actually I see another issue with this.
I missed this but this should actually be split into "kind" and "index".
And index should be unsigned as the other actions.
so we should have kind printed at the top of the function even if arg
is null and index here.

         print_string(PRINT_ANY, "kind", "%s", "police"); 

         if (arg == NULL) 

                 return 0;
...
         print_uint(PRINT_ANY, "index", "\t index %u ", p->index); 



then the json output should be this

            "actions": [ {
                     "order": 1,
                     "kind": "police",
                     "index": 1,


i'll send v2.


> 
>>   	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
>>   	buffer = tc_calc_xmitsize(rate64, p->burst);
>>   	print_size(PRINT_FP, NULL, "burst %s ", buffer);
>>   	print_size(PRINT_FP, NULL, "mtu %s ", p->mtu);
>>   	if (show_raw)
>> -		fprintf(f, "[%08x] ", p->burst);
>> +		print_hex(PRINT_FP, NULL, "[%08x] ", p->burst);
>>   
>>   	prate64 = p->peakrate.rate;
>>   	if (tb[TCA_POLICE_PEAKRATE64] &&
> 
> 
