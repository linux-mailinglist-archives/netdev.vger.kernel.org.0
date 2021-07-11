Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE173C3B81
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 12:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhGKK1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 06:27:39 -0400
Received: from mail-co1nam11on2061.outbound.protection.outlook.com ([40.107.220.61]:39649
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230430AbhGKK1i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 06:27:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBvmwVu6FcdUZqX8rdUyNHftu3GPHbgl+bhUxWx2dR36qE77rxVWCBdjFCAChkdPzpUDr4SuxKDnXk0VyQhis+sthBDXFCf6sL1TQe50ZWcMlRTa39xxMyg85OHUIDDFcoVZewqpKbZT54E4fkTDPOw0CrMgYRQCNIMuG8KC8RDJMg2X6KT592u0h7gfv/+VmkuOEse5r2MwcXGFmALVy7qje7lYnpTKMLvOCIjaC+iVS1mFYQ0OVRL47JFdWHY+gdcw+OzKX+1FRU/kTQo9OThf3Yv4HCVsvkdRrGtQm5lDGxTbH2GiBBPJRkVjTGj7bibbgMYr9mCrkZ83cHjb7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZG/mLgjCEjS9KYGYh83kxMFxsVBY8g8ORS7MPSaLck=;
 b=GgmrqjQvwTxak33CoxUwiV7LgHxD/luNd2u0gZOzp8AHKGBxZPgFUUxwzm1qclgx4e2OT5qW9sU3/539pKE0rtEvtfQb/lq+vonAoc1RWev3o9M1HXwcfakQ7d7oxpAeCOHnUk89XjPB26kKt4wJlnAVyBL+KyvyAkkueYV5ZE6mWTe45BA+9/q5rpYraqKjCJ+WdGdy0rtuBQrjP5MXsVxhw4ayYifzdGX5s7ww5uiGaHAERMlVtSRhvHbBYPlhQOZUvsM61YKTtBdlyI9QEqvgS4dapYXTRr2umf4Tn0UVBEkm14ZKUwADZmP+HqbRSylKQTN/umypcn4LfNrE4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZG/mLgjCEjS9KYGYh83kxMFxsVBY8g8ORS7MPSaLck=;
 b=GnhWrjqHCwcFTItPxSEz1C+qxs13ZgoB0MRSNvruaBV7X/wHGcRw338nzH6y+igSxjROKUJH68jpLUzspnPqgoTyNAHNK8PS4cwX8VOkpdabeybGn8NCCoXjVsh/3opGbh986cIhpOmsZVP9FNpIjT0aGlL19abLCLxon7DTk+NJBmieBoi5spm3L5ZnS0w9fuf8IH0cKlXfxqrZ5OS2Wfm5JVfvcOPK8xjksJt9hBcOqVVVueXvPJvbCWokMjjvRgDgHWo4vjpvGZ2dzcxZChY92bwaNtn1lx1IpCOi3DhKHUO52fnbIG/bXlAiJvfqEiPUPghzBxl+jp3HCQsUFg==
Received: from MWHPR15CA0054.namprd15.prod.outlook.com (2603:10b6:301:4c::16)
 by BY5PR12MB3970.namprd12.prod.outlook.com (2603:10b6:a03:1ac::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Sun, 11 Jul
 2021 10:24:51 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4c:cafe::73) by MWHPR15CA0054.outlook.office365.com
 (2603:10b6:301:4c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Sun, 11 Jul 2021 10:24:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Sun, 11 Jul 2021 10:24:50 +0000
Received: from [172.27.15.179] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 11 Jul
 2021 10:24:47 +0000
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
To:     David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
CC:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
 <YOLh4U4JM7lcursX@fedora> <YOQT9lQuLAvLbaLn@dcaratti.users.ipa.redhat.com>
 <YOVPafYxzaNsQ1Qm@fedora> <d8a97f9b-7d6b-839f-873c-f5f5f9c46eca@nvidia.com>
 <ba39e6d0-c21f-428a-01b1-b923442ef73c@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <37a0aae7-d32b-4dfd-9832-5b443d73abb6@nvidia.com>
Date:   Sun, 11 Jul 2021 13:24:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ba39e6d0-c21f-428a-01b1-b923442ef73c@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de722289-d317-4828-fba7-08d944561dc9
X-MS-TrafficTypeDiagnostic: BY5PR12MB3970:
X-Microsoft-Antispam-PRVS: <BY5PR12MB39708D9B459479D88955CC12B8169@BY5PR12MB3970.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:422;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IglPJjl6Wg/RLIfuSYgWWrl6zjd9UiGD5V7yyTUF/fQwmu17DfP6q3gWiZ1u9kky10LBFTh1ALI9WuKEzxc5nnds38MYoOYxS/RT/iIqZeobIq/T8Zx3aHe8w8aVyaDtiYTdshf75oGVkRSVtFhIzVY06UYdq5vEoGBIDrTvcPKub5E1V1ONMM+6Sge8dfXtLpx9HQTQpjr1RFBQkpIAzpe7i9LRPW5THxpT26wuNMN/OAumFyzwJjiYoSigYwJxxw0UKpCakDC88mCGxtndBmPJ+bU2ejlykC2adKKQbRcBQvW/DZ3nKfShvBIKAaBZhtlqY2Xu4DPnkloucajngPHQghAzIUgRXdEQ8mtAK9nU3uRT3eBriHYdA7h5jw7jIHUAUAD/DMnJgxDCHBER/Qh0GdGRBpS0317Qa1l94FC3HK0O4FQhscWDxe4M2tp/Ik/Mi+HhQEJTqpWnKU10MzFoo7Uoe1a7sGTlR4m8euE7XgJ9zUIPeb3mTEtATNVNvzVwlZcT03fQQ249HROtAqoLqhKe5D29r6CPgFzhAYjGHE1pwDB74oYri4eTN0iMspP3PBHI7THGh4pDn5p/LvpYjgEJ+S2gBApo98Q3mnZWX7E2//fDVPRwikyCgyQiZT3mX3wmLlcbfxwf57iXOBiAEUSNuRe/PRyD6xqVRdfGyFyyX3u4/n+Vi9Iq1xTGlSmA32AUR1Y6llV0Bwq2TAETy/WEvKS336C8qE4U2l3XMLvNcVcbSbMjIS4wID05Qun4DSszNHn6pfGHFGx98g==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(36840700001)(46966006)(83380400001)(82310400003)(34020700004)(110136005)(47076005)(336012)(86362001)(2906002)(36860700001)(4326008)(16576012)(8936002)(31686004)(36906005)(70206006)(82740400003)(2616005)(316002)(70586007)(356005)(54906003)(16526019)(53546011)(7636003)(5660300002)(186003)(26005)(478600001)(426003)(31696002)(36756003)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2021 10:24:50.5819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de722289-d317-4828-fba7-08d944561dc9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3970
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-08 5:46 PM, David Ahern wrote:
> On 7/8/21 12:57 AM, Roi Dayan wrote:
>>
>>
>> On 2021-07-07 9:53 AM, Hangbin Liu wrote:
>>> On Tue, Jul 06, 2021 at 10:27:34AM +0200, Davide Caratti wrote:
>>>> my 2 cents:
>>>>
>>>> what about using PRINT_FP / PRINT_JSON, so we fix the JSON output
>>>> only to show "index", and
>>>> preserve the human-readable printout iproute and kselftests? besides
>>>> avoiding failures because
>>>> of mismatching kselftests / iproute, this would preserve
>>>> functionality of scripts that
>>>> configure / dump the "police" action. WDYT?
>>>
>>> +1
>>>
>>
>>
>> why not fix the kselftest to look for the correct output?
> 
> That is but 1 user. The general rule is that you do not change the
> output like you did.
> 

but the output was "broken" and not consistent with all actions.
we are not fixing this kind of thing?
so to continue with the suggestion to use print_fp and keep police
action output broken and print_json for the json output?
just to be sure before submitting change back to old output for fp.


...
         action order 1:  police 0x1 rate 1Mbit burst 20Kb mtu 2Kb 
action reclassify overhead 0b




-       print_string(PRINT_ANY, "kind", "%s", "police");
+       print_string(PRINT_JSON, "kind", "%s", "police");

-       print_uint(PRINT_ANY, "index", "\tindex %u ", p->index);
+       print_hex(PRINT_FP, NULL, " police 0x%x ", p->index);
+       print_uint(PRINT_JSON, "index", NULL, p->index);


