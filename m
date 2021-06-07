Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADDF39E96B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 00:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhFGWSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 18:18:21 -0400
Received: from mail-sn1anam02on2066.outbound.protection.outlook.com ([40.107.96.66]:19465
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231184AbhFGWSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 18:18:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ad6niik3hXElfwnJtPlgKcwgtUl9TYl44ouemWm5+76vSLj91FkNEikldkovlsp9Ye/dlaisKj07Fu3jA70UUbluEuSQdvfj/WL4sABoqDB3wgADEool7mGJw2KD84mS0L5J1BnjjRbLhwWzf59JXlkvqDjBW9aIz7p9VYT06B92ya81UPAkzU6XuUmZDyDXJLB5U9BN63eVtWLQN8pG1P7CyaJt/Hsg572t429m25MeXDKwbEHnso3eR6ah2yMPuAVLorHkLtANF3czcpfPNPBpYYdvImgbxzWOB4FSZh1i3KZ9z6jo2Vga/RO0o9J/RtHO4r+ImcTbnSqczvk8SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMMfsfD4VXvsTn2OjayVDelvTxn1Qu7428HXv1a3qqY=;
 b=cwTTPqAAeRbBw8gb9wTSgpz3WGekQ0fWiI3Y5piinsx/S2cO9rDC34s6zDbR2G2Cy08zilQPSvrnG0XaVga4WaFqc4IijRFBVcLhcWuuUA9gSkIEmYNUVjmh6DC+P/7coY1RHQV2Aj/F9cW8xPmSxz24rBtzKDYMHIS4QcRasqHNJ4gq4jPnSMDGKhd7EZU7HEGm78kCozuejFW9KKES8rHKQr16TJtAYCrZ5x4i9NeWknuB8ZTTDRnAU6JGhvGYeLbWzxBe9m9SKxygMdihIV7SWOsYNogyRsazmMEmygJnu5VT6GMN2cplPKFUKB8nwJXf2FVkikf11TD22SIDsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMMfsfD4VXvsTn2OjayVDelvTxn1Qu7428HXv1a3qqY=;
 b=UHN9FhuhVcKyUYRIU9wa4/niYD+kjjQEAygK6/ZA92a0oAJfHcwRNuLdrqtRECLzjwfiepPpKpATXUN4ZCjl/VKsvWIEyz/S1Ci6SGSo6zc3dtm+CqnuqFbvBJoz3b3bOlwrwa6VQwFZguQChyrrAAmlZu4Y3Zz7BoenWQM1RCvuIq7XtMvYERmLp1zhd2ZMYaQYj75vfOcukPwmdcb5mHkxtj4b9NayEPsOCjD8CKZKmcs2hO9wXrVF6Y/CWD7yLOxpuWHCG2MtFf+feW2oKxOdII/1XoPCB2p7kMyBISsCfbyfn3R5m5+UV+2eiR3oJhjFPfL2xklA7APVOCAJYw==
Received: from MW4PR04CA0325.namprd04.prod.outlook.com (2603:10b6:303:82::30)
 by BYAPR12MB3336.namprd12.prod.outlook.com (2603:10b6:a03:d7::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 22:16:27 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::5f) by MW4PR04CA0325.outlook.office365.com
 (2603:10b6:303:82::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend
 Transport; Mon, 7 Jun 2021 22:16:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 22:16:27 +0000
Received: from [10.2.55.16] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Jun
 2021 22:16:26 +0000
Subject: Re: [PATCH net] neighbour: allow NUD_NOARP entries to be forced GCed
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
References: <20210607173530.46493-1-dsahern@kernel.org>
 <c704333a-e326-57ba-78e7-1e7111f1e79c@nvidia.com>
 <080b469b-1fb2-dcb6-1a95-7c02918e97c4@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <e114a16f-5cb2-472a-e790-a84311481251@nvidia.com>
Date:   Mon, 7 Jun 2021 15:16:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <080b469b-1fb2-dcb6-1a95-7c02918e97c4@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de0d2858-2637-49e7-a119-08d92a01e4d8
X-MS-TrafficTypeDiagnostic: BYAPR12MB3336:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3336629D5D5D65E130DFDE24CB389@BYAPR12MB3336.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hILeK2/wu8tFR6f7GuQopKL1ePCxrtLMYUd2BD11/wOTdjltl3SWoxCtHt+Pb99mbZNrivsdL39SJg9YbupQYTx512119r1Y3qWZCt/iWiKRjuY5b92k4MuZb2HqVAnycGXn+6xEFa84ltjNxkME5mUpscd6x9nE5X2YobO/oXnGUdGCPAfApDP3caHCdHuoGAXEpbm2eKoj8T7gIrjgzUBEnzWKdXvSYt+hgP6oWWJFQ86xP1WNHkWh308h9TOKILR+vbtbKv50vNmxUc2LXakmE0ii+iiDB/OMpJImV0iKYmY3UmuVGD/9M6bIyAzBHwBB6Vm7NTqR6FmpdkBp1Pjj19BHb3wEf8zVnavK9w+kJsQbLRU/6pBOOxF/QXpZUj4sXmvupbyt36sa/A62gHkKC0ygu16P69b2FN6L8NXsS8dpha6/2Gb/Bn4ulwhDwHO//OP2KCTxNRM+Eks6ZIyh3f7hZUo53aaeec2ktm++TvIBDERxwCzTF8fXb/CL5rPxV/OvW5s/tXAJQUn2LbSw35gpbBT1csl7mrXJtiZKjTggOgctyF+7CV51lhro7uSjvrmlw5/M8l0mB6/5YMtMwvZc6da3Vz1tfXGAUNvbvCCUe5JHJLG65MuKYQMT6zDI1bdpUDF9EhwlIm83jo6HPdQrbVR9V0dT7qTlj9aa99EJMeaDBLCdJnggbbJs
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(346002)(396003)(36840700001)(46966006)(8936002)(70586007)(7636003)(26005)(82740400003)(8676002)(83380400001)(70206006)(53546011)(356005)(31686004)(16576012)(36906005)(5660300002)(316002)(6666004)(36860700001)(2906002)(47076005)(36756003)(110136005)(54906003)(2616005)(86362001)(31696002)(82310400003)(478600001)(336012)(426003)(186003)(16526019)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 22:16:27.1234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de0d2858-2637-49e7-a119-08d92a01e4d8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3336
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/7/21 3:04 PM, David Ahern wrote:
> On 6/7/21 12:53 PM, Roopa Prabhu wrote:
>> On 6/7/21 10:35 AM, David Ahern wrote:
>>> IFF_POINTOPOINT interfaces use NUD_NOARP entries for IPv6. It's
>>> possible to
>>> fill up the neighbour table with enough entries that it will overflow for
>>> valid connections after that.
>>>
>>> This behaviour is more prevalent after commit 58956317c8de ("neighbor:
>>> Improve garbage collection") is applied, as it prevents removal from
>>> entries that are not NUD_FAILED, unless they are more than 5s old.
>>>
>>> Fixes: 58956317c8de (neighbor: Improve garbage collection)
>>> Reported-by: Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
>>> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>>> Signed-off-by: David Ahern <dsahern@kernel.org>
>>> ---
>>> rebased to net tree
>>
>> There are other use-cases  that use NUD_NOARP as static neighbour
>> entries which should be exempt from forced gc.
>>
>> for example when qualified by NTF_EXT_LEARNED for the E-VPN use-case.
>>
>> The check in your patch below should exclude NTF_EXT_LEARNED entries.
>>
>>
>> (unrelated to the neighbour code ,  but bridge driver also uses
>> NUD_NOARP for static entries)
>>
>>
> Maybe I misunderstand your comment: forced_gc does not apply to static
> entries; those were moved to a separate list to avoid walking them.
>
I think you are right. so just to confirm, NUD_NOARP + NTF_EXT_LEARNED 
will never be included in the list for forced_gc and hence not affected 
by your patch ?

if yes, I am good.



