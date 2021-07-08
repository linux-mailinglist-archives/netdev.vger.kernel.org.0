Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C303BF9E3
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 14:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhGHMOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 08:14:45 -0400
Received: from mail-bn7nam10on2061.outbound.protection.outlook.com ([40.107.92.61]:60384
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231404AbhGHMOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 08:14:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIvCRRfiy1vbHPlHd9VWXzwMhNTB5a1RvjWtgd8GQcd0ny/Mr1YsY/DfXYsJzUnd2QJCz/JfMYf8uJfHIiiWy4pLnjkbziffpCv1xN8tXLgniqgP3inKTJFcWdhZESMSMbRqUwv4mvhcmKUc6HrCRjJcEYKoI2WQWVLjsraIe/pBGZuiVa3XhFEcPP8mY1aJVM+SJLgn2qoI+fKW46ojeWq1mfXnOqvOVsxaBXacV4iEBsD6oFbnzCiizhTHSM61tfCGF3iAFwCyhK2Ld/Mxutw9d3+k+5NBTBQq30M8oNHO+Q+vEGhjQfXBfa8FUz8GYiynd4W0euVCHc7CPiuJPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMMA4rfa8EO00JV09GM9/6y6YVod4m8zKsxT4OSburU=;
 b=hyUApLMIToMJYGUNAxQrZ3sXwrZ4jHDgSHCTpSY1igkazuEwiZbPNK3jD52cO0YyMPiMC5srhpyPktkvrH8xi4/AR4mL3+rdN95YJCvkg2ufuukJ7TLk2H6niv0tn/KJEN8tGVVtcwzpL3NIVKhh7GI/Z8SY1f8QPBjCXp2XehHZuTDvhmRZQr1s3Q7rUHzgpPz1H7Q/hA+Z6tbgbV1rnXIwzcc7Nnh31aJfOoE3rLQX+d9hJ4mCvngbcLA0SQAPENa9Xau8zLJEEK8DXFS0r22RQcrBApuouOg9xT0KY9URK9Jkvu8nAWwyD5kk5LfaenjSzTVIvMbvZAS5ddCmBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMMA4rfa8EO00JV09GM9/6y6YVod4m8zKsxT4OSburU=;
 b=Ki/ZFyfqI6wksw4q4rVbaG6O6cUAVq7uxXrutLb82eJ6VnK6A+PoxW4dbBwk60SYajjiGSk0K32HifIEYko6Lo1uqNvKSQwCqTPveCK2aqDYVBvzcaJqFnBECjXkJA0OcqU7ioHaAT85qLC0P23qSAdbg2xxxHxv4W4YFkkenmmC0MD425myOqsRBpP4a0xmdD8HrzHMCVR5RdPV4l4Fu4MRGS7h/SlL79fzVRzqgkSjATeyz9hlsit+BBOfvVPw71PJq1nDJP54yH0v1w0H3dG38bLthT7HrKq8XMB+uo9888SfNGD90igVdukZUt/lIQesSrNxi22xBcZWorwMpg==
Received: from BN7PR06CA0043.namprd06.prod.outlook.com (2603:10b6:408:34::20)
 by MN2PR12MB4189.namprd12.prod.outlook.com (2603:10b6:208:1d8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Thu, 8 Jul
 2021 12:12:02 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::fb) by BN7PR06CA0043.outlook.office365.com
 (2603:10b6:408:34::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Thu, 8 Jul 2021 12:12:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Thu, 8 Jul 2021 12:12:01 +0000
Received: from [172.27.1.80] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Jul
 2021 12:11:58 +0000
Subject: Re: [PATCH net 1/1] tc-testing: Update police test cases
To:     Jamal Hadi Salim <jhs@mojatatu.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "Paul Blakey" <paulb@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
References: <20210708080006.3687598-1-roid@nvidia.com>
 <54d152b2-1a0b-fbc5-33db-4d70a9ae61e6@mojatatu.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <1db8c734-bebe-fbe3-100f-f4e5bf50baaf@nvidia.com>
Date:   Thu, 8 Jul 2021 15:11:56 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <54d152b2-1a0b-fbc5-33db-4d70a9ae61e6@mojatatu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac451c36-3681-447b-66ac-08d9420997fb
X-MS-TrafficTypeDiagnostic: MN2PR12MB4189:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4189155E09F1278239403AECB8199@MN2PR12MB4189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O8G2zsICXYwGTuPULeR9Z6rjtSBpPpuhs2jKnl1UYdCHDy9WO1p7xgYRRPuZWqRcX9m/ldOgWsse2w7AkQrrMicF1OGNvT1UcgCuuMaok0D5cYZABIfUPIwfMD7GJU0aiSuPNaEuWqJhAfd0WliL9CcP1nksHICeZAAJ3zNyhS2TBI7FfEExAZMpU0c8NGTODhrjH91gyOsNojWg6Z4XXGQRxbtVi73104lfoLLKdG1dyi9yk7oWbIG+RkONa/Iq5UNpw+8zglZt2tJEXN8XI7Kj+6cGKt8LBTS9fTO/hju5J6wZMyMBjOwPkRd4dAosGdW//bmJ/mSaHvY9hYMqMhzErni9iVKZtuka7ONBJ/7GYY4PhjUanS4Clthj6i4/bACD8h2fiUThCEK7NKf9q6fPfv1XhDFgHC2VkO/Nx9oIpMiOf/SLcZFza8CN36zR9m7VmNdzk9nvDjkYJ5/zCfhXcM1WNLtPOFVbyivuJcs8YuIYClLakmZAm8UGXMqH/Gjf6CKRILUXFBIVhOKKoB7j9vu2NSMS6V3WM95MdRMkLUOapv6nk9+QlGIAMlgOE6H9slQSGqpZ94GQUOrpScWcpRiECOLW8G4MGAaBXyuOOlxpNR4wFm0q+fYph7zCFBY5mzBh6eP1k5WkTII5uHOl2Qri65q0pXfwK3iUcbB6HrK/FJGvccr6gDKjzfLR63ID0w6jzg/PuTgh3tIeUDGq4ontkn3aelfUd2lxBI4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(36840700001)(46966006)(26005)(8676002)(8936002)(356005)(82740400003)(53546011)(2906002)(16576012)(2616005)(70586007)(426003)(54906003)(7636003)(36906005)(316002)(110136005)(31686004)(70206006)(31696002)(36756003)(83380400001)(86362001)(336012)(5660300002)(36860700001)(4326008)(15650500001)(82310400003)(478600001)(186003)(47076005)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 12:12:01.9821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac451c36-3681-447b-66ac-08d9420997fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4189
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-08 2:17 PM, Jamal Hadi Salim wrote:
> On 2021-07-08 4:00 a.m., Roi Dayan wrote:
>> Update to match fixed output.
>>
>> Signed-off-by: Roi Dayan <roid@nvidia.com>
>> ---
>>
>> Notes:
>>      Hi,
>>      This is related to commit that was merged
>>      55abdcf20a57 police: Add support for json output
>>      and also submitted another small fix commit titled
>>      "police: Small corrections for the output"
>>      Thanks,
>>      Roi
>>
>>   .../tc-testing/tc-tests/actions/police.json   | 62 +++++++++----------
>>   1 file changed, 31 insertions(+), 31 deletions(-)
>>
>> diff --git 
>> a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json 
>> b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
>> index 8e45792703ed..c9623c7afbd1 100644
>> --- a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
>> +++ b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
>> @@ -17,7 +17,7 @@
>>           "cmdUnderTest": "$TC actions add action police rate 1kbit 
>> burst 10k index 1",
>>           "expExitCode": "0",
>>           "verifyCmd": "$TC actions ls action police",
>> -        "matchPattern": "action order [0-9]*:  police 0x1 rate 1Kbit 
>> burst 10Kb",
>> +        "matchPattern": "action order [0-9]*: police.*index 1 rate 
>> 1Kbit burst 10Kb",
>>           "matchCount": "1",
>>           "teardown": [
>>               "$TC actions flush action police"
> 
> Does the old output continue to work here?
> 
> cheers,
> jamal


no. old output doesn't have the string "index" and also output of index
is in hex.

it is possible to make the old version work by allowing without index
and looking for either the unsigned number or hex number/

but why do we need the old output to work? could use the "old" version
of the test.

