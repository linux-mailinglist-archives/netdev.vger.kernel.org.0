Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8732C1796
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgKWVVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:21:35 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:14469 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbgKWVVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 16:21:34 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbc27dc0000>; Tue, 24 Nov 2020 05:21:32 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 23 Nov
 2020 21:21:32 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 23 Nov 2020 21:21:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpCY7vI5qtHbdITH8Kp2kVgCpahYHUjaEF7VMeLF8e0pS0BC8DicY3qOzu+9FXGIuGIO8Olg/rtFkpuCR8jhzSXMfoc1tow+Dov7svulblP3jKpJfGa+41Rx2nkRog64L4FsdE1YZCpGLkQU3MDcViL6nJ/u073HfjvoFMSa3UTVnze+irdtY7gBncK8nWdx6N1Hlo649Lmf5UrW4RfLBg8eU/8LydEb5T0WZiCwuL564sv+hEt+0GwEgtU0GzUAnKfngRk31sDE1SQoul/mPGUw4+6SxEsg0Ck20yRSnZ4STE9wqhdwbYRyzE65H4sM99O1w59h4JmAy5/KbGisVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+uXYD2HWwkWz7SWPc3pH/hiVzpyigPMaCMgeHTyEJE=;
 b=Zu8Vm7kUTpH6gp/d76ri4BsZE3OgNMGCjWMUnp7NgJazgN5HujNXbkhVel4qmk9NF2j8Kdg5h08TPTGbj1E2pbtQh1V4Jzm7jIdjgvB8c0ePjC3cmYefr9d1PELb7wnIuEn1LW1TUqk6OfVzpvaPtSC1XLvDPFrlWqUNGx4qk/xAFHxOFl9w3cSdQmXczxh3QSqzC/lhJiKnp5UbPXxCjwrJ2AU/0fwUrh6yq7W1xX48FX5Ry6BfppYVRbqQiz7sba9oWj3Wjfp1pQlJ9cOmxaz0gLZnBnRCJGSEkpuV5pTNfDTNUROSsCdBdmQ2vn6Ft/khxV4fjyYoxHhBkoQhig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM6PR12MB2795.namprd12.prod.outlook.com (2603:10b6:5:41::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.29; Mon, 23 Nov 2020 21:21:29 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3589.028; Mon, 23 Nov 2020
 21:21:29 +0000
Subject: Re: [PATCH iproute2-next 0/7] Convert a number of use-cases to
 parse_on_off(), print_on_off()
To:     David Ahern <dsahern@gmail.com>, Petr Machata <me@pmachata.org>,
        <netdev@vger.kernel.org>, <stephen@networkplumber.org>
References: <cover.1605393324.git.me@pmachata.org>
 <dcbc0c8b-feb8-634c-4eec-80afa0809c06@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <da8fe4ee-f71e-fdf0-f014-c34bd417b9ab@nvidia.com>
Date:   Mon, 23 Nov 2020 23:21:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <dcbc0c8b-feb8-634c-4eec-80afa0809c06@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0064.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::15) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.83] (213.179.129.39) by ZR0P278CA0064.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21 via Frontend Transport; Mon, 23 Nov 2020 21:21:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4507734b-0fab-47fa-0218-08d88ff5bdfc
X-MS-TrafficTypeDiagnostic: DM6PR12MB2795:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2795CB075C4A503552555177DFFC0@DM6PR12MB2795.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: suU5jqiDe2w05HO1gYdTMk7iTnwglHljv4bkM0kZlfO6eSEnOQUuUsLejJNitCdHHjPV/oqYKQ+WDwcNSJVhWGCnzMrFZ8ZKGjemaQmZJugwVMdpOxTwslmQXTg2a390QBzy4gaz+bVKpgBJvK3Wcmy/jiqto0+zpR6FNmvlcJEIBiGzQHrmyzdALhh1Ujrk58srFpX+hV6TQKtKZnvroZJt8FBheMUpNrd909jX35Rft2d/V1xIebLoiGdxDncin9DkecFy+Ho8+SIaeV08mfqZUEPWLQ6AVAvzvN7JqYzM/6axdF627UWPhKvnmJURSWWdWjCjwozzEDoQV9oGrXV0rb7uV4pZMICOpTf+cx60HDOVLd3CPDShwkDdLKHg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(83380400001)(31696002)(66476007)(6486002)(66946007)(86362001)(66556008)(53546011)(478600001)(6666004)(31686004)(26005)(316002)(110136005)(186003)(16526019)(16576012)(36756003)(2906002)(5660300002)(8676002)(8936002)(2616005)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pwAuzWBgdg/ZuNBc4l6/t0uVmpdiq0b87ezGHsUK5V9xNZP/ZYG3Zy9kSqL3Qha2AU+sFkavP4RVcZlI+uVdkku6HaaoHxTKw4Jc+Fb2QuYlWKJD+EqepHceKtYBle1y/W9nM176MShhg9NvBZeKiUExtb38XJW0Pb6rgdwAiI5O/bQOTsjxKLckIkQfJnu7EBtoQkcoqWV4C1F/fdGE1OPUjZitqqtTAxnoApPFh9soplulkAh68jXcev6JQhNg9fQlnNxeHArzVyrjJhaITnXoYqrAbTeLh6uG6E7Wu/y/eLckDHZDn6Lbq+wqpZRXbmPfW4hEAvrsP07qCHOZDLmh+9Oj9j1fOJXZLHe51cgqRCftkRkAkK3ok56S9+ckLEVjFLc+dvnpyIXCzXWFowYJy2hjFpF+6qLI8+/B8H7S7/953CvUPOZdZIAxPP0NGc8tqfAzVlXGSPWHLEfzkBJhTDvl3mD9ZbwR5L9Q5+FEKrP9ZwxVR7On+WB7F8UBPjhA5zqpoJOt/OeVUjzPZp0XvIcvP4G3K6OecdsLX+N4tVJDzj5e77mYz5IsLinZdhXU7DgiD7Km86gDJDE4quxUuSqp88TYHUVcWlDjVsBaapatFzZd6qiv1uTaoCTBPVWhTYPWtowZbVebaVaU3cYDLNELkJDreXb/SZyQHWxeAn1bHQ6Dxqk2KYQzihKB0OxQvLMQfB6lduAwDl3ouxm1vyS7V/QdV4vJ8YlrQDgNuvce17/odHq48gQ6aq+5H8ruunHMvZ6QDDOlrvt7mYS94L9KAEiuDBvXzy+leZFnSJTWVzcaapaAhFn/VLREByiz2R1bAGJzoWwUaJCIJuTvl5QKk3KmIbd5Dnu0qEJEuTNyuIzCaFoVYihnIMJYGHwSo1oYqnzckWuLb0NYjA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4507734b-0fab-47fa-0218-08d88ff5bdfc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2020 21:21:29.1433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zoOOWqQ132NUFr/OmNMWPXv2qrP5iACcvifR8USs5813Yz2HsU2rihvL5au/JuL4Q4bYeeXFbfiOechcLZhhJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2795
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606166492; bh=B+uXYD2HWwkWz7SWPc3pH/hiVzpyigPMaCMgeHTyEJE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:References:From:Message-ID:Date:
         User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Ulu50ob5FeBc5VAYcd0jDzslwB27uT3hiSpDLOSOVWkhd6Q26uwf1YyA2lmeCtv+Q
         ijpe/ghIl4nktz3GtZfrjRZKaTc3KFg/nCzOJ56i4BpVNvUSveV1ZyvfN04XujUPrU
         75PSzO6E7IhhsRvbmk22Kh6xJgLGuOw7st+ZlG74sjUb3SJww9CePqry92v5QSAmWR
         yDOa2d8CmxeC7/0Itm1jvHQEzDDpbAI65yo1N974xPfKO7mnADJvGHj6bWDoQnpoH1
         ZtTq7fZH/1uV0ut14Qe3w52FOo1Qu4InkHnQvufqB85x580RCQLODrBusLZnc+8KcQ
         vHovk1uh48TVg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/11/2020 02:56, David Ahern wrote:
> On 11/14/20 3:53 PM, Petr Machata wrote:
>> Two helpers, parse_on_off() and print_on_off(), have been recently added to
>> lib/utils.c. Convert a number of instances of the same effective behavior
>> to calls to these helpers.
>>
>> Petr Machata (7):
>>   bridge: link: Port over to parse_on_off()
>>   bridge: link: Convert to use print_on_off()
>>   ip: iplink: Convert to use parse_on_off()
>>   ip: iplink_bridge_slave: Port over to parse_on_off()
>>   ip: iplink_bridge_slave: Convert to use print_on_off()
>>   ip: ipnetconf: Convert to use print_on_off()
>>   ip: iptuntap: Convert to use print_on_off()
>>
>>  bridge/link.c            | 135 ++++++++++++++++++---------------------
>>  ip/iplink.c              |  47 +++++---------
>>  ip/iplink_bridge_slave.c |  46 +++++--------
>>  ip/ipnetconf.c           |  28 ++++----
>>  ip/iptuntap.c            |  18 ++----
>>  5 files changed, 112 insertions(+), 162 deletions(-)
>>
> 
> looks fine to me. Added Nik for a second set of eyes on the bridge changes.
> 

It's much later, but the changes look good to me. Thanks!

Cheers,
 Nik

