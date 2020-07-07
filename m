Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9F1217770
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgGGTBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:01:51 -0400
Received: from mail-dm6nam10on2061.outbound.protection.outlook.com ([40.107.93.61]:57569
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728243AbgGGTBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 15:01:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqEOqWR6r2cG40X730/TKTHG7G9AlHeNZWocKWsccKwMGEoJDc7fPLd4dsCOT7Zw3tclK8lzRowQ4D4C3+gP3qDmqS9zWzYbhWJjWFTKmqJQymi2X/zPWDTnjJ353Ex0c/tl6BrH/Wu00bkb8RU5D3+1McJRUpOEt7XPaGFnkeTk0x4zQbt+uKelxutlm/X2qu8M/S4pnls1c5/JCXUaGDlvgQjaIG5rOerRoou7JyfTMH1Z3SAg6dlZcZ1ELyiNn/BI7xSdBwH7iyxu77F9tjFAsDCCkiweSAMjWvOYlSOIAKm3tTs1gqnm1cUexMa48f78yore7S/QzZCoxqeuRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PidHPGUUO019W46a7XOQ8wsKhe/qrbp30qmDh1RIawA=;
 b=kfHmvWeuhHoL/rCnz7XlEnmJG5Kghcw05oSA2dwDewWcTNNetQm9B+mPdMh0pjq4vZskBVV/l8fIJgsdQLNtLYSYSQx8XoVLAc2omEfw8yqpbkYxMFl+XLdM+dl3kouu+J2ERsIPhB5yYbD2TBc+xAeJplX27hFg5QaQUZyJBucAYFOd/uV/S0gT5+Afh09ihUFeZBHaPyVeWd7BEYykqSG1ocrW1duV5cd4lUU3FyMe/Dsq+CwaBOIr0vU7uHnYQJuqms6ek+RllFW5H/CPUUO4Y5/MuAynGujaf68pSVWgI3wT5ZEIBdBRYWItRUkFcF2B2y2G8qQcmuKF2f4y+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PidHPGUUO019W46a7XOQ8wsKhe/qrbp30qmDh1RIawA=;
 b=wFjABsKC0DQ17ecWiTM8XAEkRGBLiHqZvTaqN1no9t/TA90ghxXre5k2CHPCfQVg//sme1Os5f7GVa3YjFFDTeLxBjVvsXkKIDo69R/dHd1w5SZQNsSzYDCLkeSeZ9uByFxTJ2C73CEZJB+t9OYN8wQHTzWW6p9uqRCOGKhGK/k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BN6PR1201MB0258.namprd12.prod.outlook.com
 (2603:10b6:405:57::13) by BN7PR12MB2802.namprd12.prod.outlook.com
 (2603:10b6:408:25::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Tue, 7 Jul
 2020 19:01:46 +0000
Received: from BN6PR1201MB0258.namprd12.prod.outlook.com
 ([fe80::ac9a:b1f:fa1a:403b]) by BN6PR1201MB0258.namprd12.prod.outlook.com
 ([fe80::ac9a:b1f:fa1a:403b%3]) with mapi id 15.20.3153.020; Tue, 7 Jul 2020
 19:01:46 +0000
Subject: Re: [PATCH] amd-xgbe: add module param for auto negotiation
To:     Andrew Lunn <andrew@lunn.ch>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20200707173254.1564625-1-Shyam-sundar.S-k@amd.com>
 <20200707175541.GB938746@lunn.ch>
From:   Shyam Sundar S K <ssundark@amd.com>
Message-ID: <a9e5c55f-55cf-439e-30aa-6cf70e44dffd@amd.com>
Date:   Wed, 8 Jul 2020 00:31:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <20200707175541.GB938746@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: BMXPR01CA0075.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::15) To BN6PR1201MB0258.namprd12.prod.outlook.com
 (2603:10b6:405:57::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.252.89.180] (165.204.159.242) by BMXPR01CA0075.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Tue, 7 Jul 2020 19:01:44 +0000
X-Originating-IP: [165.204.159.242]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8bc1d5b8-1b02-469c-b02c-08d822a8322b
X-MS-TrafficTypeDiagnostic: BN7PR12MB2802:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR12MB28020AC54BE5239CAE1618299A660@BN7PR12MB2802.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a56A4bGyCHKOSl1ff8nX6nSVF+8soOQwZCSrgYIG4nKQ/MN9ohU2kMgl7QjjWb7P4Tru4I1KZ6UHPhhiOcv7rYvQ94RotoCikXKQ1Kaj5nKF7nZnHOg4rQK+gfEedF0zhtdHRPQUvQBOVFCDBqECFdGOQXmzm1bSstbF2Ok22vwMp0MAoW4ZAGWyjIPCJ/T8jWNcllHw8Vuzj1uf8/AjL3+pPg8S7ewl3UYal8+jLrOvoSBUaWR4/WO1qJpsYFg2jTKSJ6xWlcTc9WX7wTDFASMM7d7UDW7kaRSTlJvf39+69OiRzr21pBFu4SmjTrpv+ZeJR4g+x/8RHOhKpjJv8QKkvWF4LJ/bsPiU8Uy0NoaFcjhgWTsSqeHY9MZtL5aB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1201MB0258.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(4744005)(66556008)(66476007)(26005)(6486002)(31696002)(2906002)(186003)(16526019)(31686004)(478600001)(8676002)(6666004)(8936002)(53546011)(66946007)(36756003)(52116002)(54906003)(956004)(2616005)(6636002)(4326008)(16576012)(110136005)(5660300002)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 53yD9Z34eAMqi0YDlOdhJQKOi3rXJ9kdzp2W6TqYD5dcc8wk1WfICAI5usEl/KcZ07yprG8SRwWxLPbMdaLmi+oiBLxKQmSjDWB3UDAEKVIfH4Wc3h30nm8kSX91RySRWm7YfrWkTdAEut5DMQHBAFHA0NIcSoMHT2y/1s6c/yyiRZRgbJ7VHMqvNV5ZfMMc2UHrWquZpDNRl+4imXSDWgjzgVmfOuq2HwXqmKFV+PiLZ4X5sHYE4N4j5fL2b74e83k4EjT/kfpgURux1BoThXmqlAYH8K59XzuxPb0YgDmfZxH2cUqhIbu5NCjXl5fbkVszz+Mwk2LDWEcqstfmzPBzUt1ry36yDwCdeo5WvOAV9iH0BTcHZz72fy9YC/gJHLlsDd4XkHQ18QbOXXL8O3Zkw5QOa0sS3FIJcWtK3GRz2tXKFU0Ek0Nded34aY3NXyqxBGuL/Hw2R2oz0EmSr7cUxDcSUx36B8cGS9cLGcijHWnb2pKpV71HcnXo9cL1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc1d5b8-1b02-469c-b02c-08d822a8322b
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1201MB0258.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 19:01:46.8137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74GeF0v3TGMCTvAneE3IeC1/qCLRtToKsg9I4YCwWxygXfltjs00hsRPrp7A+HhZjnwmfJFTbz1jswYZ1RkEeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2802
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/7/2020 11:25 PM, Andrew Lunn wrote:
> [CAUTION: External Email]
>
> On Tue, Jul 07, 2020 at 05:32:54PM +0000, Shyam Sundar S K wrote:
>> In embedded environments, ethtool may not be available to toggle between
>> auto negotiation on/off.
>>
>> Add a module parameter to control auto negotiation for these situations.
Hi Andrew
> Where does this end? You can set the link speed via module parameters?
> Pause? Duplex?
>
>         Andrew

Agree to your feedback. Most of the information required to control the 
connection is already present in the

driver and this piece of information is missing. Customers who run a 
minimal Linux do not have the flexibility

to add userspace applications like ethtool to control the connection 
information. Please consider this as expectional

case, or else I would not have proposed this change.

Thanks,

Shyam

