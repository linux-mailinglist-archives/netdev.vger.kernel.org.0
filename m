Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D2B2157EE
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 15:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgGFNBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 09:01:09 -0400
Received: from mail-eopbgr30085.outbound.protection.outlook.com ([40.107.3.85]:2252
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729225AbgGFNBI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 09:01:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXIKUK5f4gGGsE8sE6kCL6Efc6ag0nZYW/+TrGONMvsgFKV3gybIa0ac85zAJ3VDbcWdNV9J4Gl+ukcAYMq+xAt8jCmwGbW5LYCYxz7efXzOKUlSQpLyRB/EhmOXkebA9QUwKBYITKtA63KSviBfKi/AcCEk3XF6wpzzwC12oZ0la/WrL35f4K/3ko0p1pCuYRIosKap7bpfkFo1u/YSSRvx3ySzcePMxzeV55twHS/61GcuyvlZZCVI5qeMW/zeiLGlxnJurd6Czv1wI1OeqinMyaw0dxr1eqVKCRLvtoMZxo5BtlPzGff/3ovhkzdWoWLzK0q8OhVeUkBXBEKGSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgPf39u2qC4u/XbQ8JPcB+ICDrGoP40e3AnqRQnR0ek=;
 b=PcpPn74I2D3RW5GfJmdCyvi2bhOqCbOIiFJUz3benShLSv0tfcOENhwxRMDa2GL4YB70Jz3TzbOlm6FXmuTE6SIOucfuvJocPRxITuKaQ5c0Qx43claHs4WmO2J4a4f011jEjRaDslNHSh8XbZ7RSVw9l2gouhOQokH+04PzOTrU0KA7RHiWYLM0z7vZWbSYQINBbthrPVI+NaTwIm0Ig/IWnYTLtfxKH/AiJa+z/JyjXk3PapkmRmKGnd4/Pf7PxJXbDebipnd5OYaqWvh8UuOsEp8+FA4IdbhhoyL0As7PpTLp/1PaVTWGIIBuLxU4/vcwkwK7LBFVoT0vsmxh9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgPf39u2qC4u/XbQ8JPcB+ICDrGoP40e3AnqRQnR0ek=;
 b=Apoq5UJtSh3HrXv9YQtX8rDA4JZ6ra07ZQ3F0dxwqdgT6ZmihDWLr9k2CDyld+AY2mmhwrhUYBhB53Zyo7/RWSN1y08ffDm+TyX31k0uCBQVpgAEA7x+p//6mkMjvP3N0GXEOpMRLZoYVEP8b7ciU5zAEr9kkqvdiX+QT4zIi7E=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none
 header.from=mellanox.com;
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com (2603:10a6:10:d1::21)
 by DB3PR0502MB4009.eurprd05.prod.outlook.com (2603:10a6:8:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24; Mon, 6 Jul
 2020 13:01:04 +0000
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::a406:4c1a:8fd0:d148]) by DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::a406:4c1a:8fd0:d148%4]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 13:01:04 +0000
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "alexander.h.duyck@linux.intel.com\"" 
        <alexander.h.duyck@linux.intel.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
 <20200623195229.26411-11-saeedm@mellanox.com>
 <20200623143118.51373eb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dda5c2b729bbaf025592aa84e2bdb84d0cda7570.camel@mellanox.com>
 <082c6bfe-5146-c213-9220-65177717c342@mellanox.com>
 <20200624102258.4410008d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <19a722952a2b91cc3b26076b8fd74afdfbfaa7a4.camel@mellanox.com>
 <20200624133018.5a4d238b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Aya Levin <ayal@mellanox.com>
Message-ID: <7b79eead-ceab-5d95-fd91-cabeeef82d6a@mellanox.com>
Date:   Mon, 6 Jul 2020 16:00:59 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200624133018.5a4d238b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0010.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::23) To DBBPR05MB6299.eurprd05.prod.outlook.com
 (2603:10a6:10:d1::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (37.142.4.236) by AM0PR02CA0010.eurprd02.prod.outlook.com (2603:10a6:208:3e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Mon, 6 Jul 2020 13:01:02 +0000
X-Originating-IP: [37.142.4.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a2bc92d0-3ddd-4068-9f83-08d821aca3aa
X-MS-TrafficTypeDiagnostic: DB3PR0502MB4009:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0502MB4009DF8C15341AC1B44C9E5DB0690@DB3PR0502MB4009.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04569283F9
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SbjIbtJsBy2t28TTjR5+OLU6S4mjO27NpRK5vq6dd3VrN4NhxBYRBbTg57olf8bN58//+boHwYw+n/K2PbegukCxQPX/1al+ZivunfuysW4/TT9n6MNML94e7FW4eFYq1zt8h9o2CooiwB4NtCjMFiGhtwuxbaJpX9tg7b/GaSKIFpi5uDuQBDbCWtjNf1ch4xab4NSIGlMZcS7zik1X4qgoUlPFmRI1ZF6B1k3LOMXuzsZojo7sfIXv7sQoH8+/Mb19+fHGv4T1J82khcm+U54tYaCvuvZh/dO0aQxkBeyFAAsKqihUkaoEzf6oYaK6HfR2V587gBL17eajE1eFdZt8gpY4wrLgcd2WmB76f0gCmQ7wbcYD1USVtpwjdaVp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB6299.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(6666004)(83380400001)(53546011)(31686004)(316002)(16576012)(8676002)(66946007)(66476007)(66556008)(478600001)(52116002)(4326008)(36756003)(6486002)(5660300002)(31696002)(26005)(86362001)(2906002)(956004)(110136005)(8936002)(16526019)(54906003)(186003)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kRr9Dwusu1F/ngdFdu1AU4AAWQsS9172GlO/XT+Dhup4BTuWZ3Suwd9MZZA9m0UxchOnlLcqHsNEjSbuoTTCjExnTlaSDQihnbu05GkeeTg1JCElok/0s9CB8BFB3RCN7g7t9O3P8m1yGeORhKO6fsXKnscqgd2/yKmkxwc3YCx35j/1UOyw1Jp23fFj9tIp+vhpLGaelu2VW1s/TYuCOkMHWmC+3caFl4LIvwVASdDkg/xpPSEtA2Q1xRtcRQGV+XnfUnQh4SkOSeEhJzhIBWq2HQYurVJ9BB44MZM1K/RpuoU0RhFZ27ttIaO/ob1c74lFRUpet+I4UjMOyPmBjNF8VQ0w9S097tVLgnu3ZQzczbqjOuBOr81enCkhtEQud5z3i+f7zzAyYER9nch3h1OOsFiAY3rs7fIAQZNtObGey9w3GyWLvWRdy6ECcNiMfX2M/deGV33qdNC6ixxIrE5yye5K1AlV4KyZ3yZmFzI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2bc92d0-3ddd-4068-9f83-08d821aca3aa
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB6299.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2020 13:01:04.0182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qxuoZ3uimPc+egEN/sajvdHS60vuu1oU3nuhxNKcyM/H65f+SdXsdFvnFvJtLVumAkX8KFvDqBt/mZG2FfBwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0502MB4009
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2020 11:30 PM, Jakub Kicinski wrote:
> On Wed, 24 Jun 2020 20:15:14 +0000 Saeed Mahameed wrote:
>> On Wed, 2020-06-24 at 10:22 -0700, Jakub Kicinski wrote:
>>> On Wed, 24 Jun 2020 10:34:40 +0300 Aya Levin wrote:
>>>>>> I think Michal will rightly complain that this does not belong
>>>>>> in
>>>>>> private flags any more. As (/if?) ARM deployments take a
>>>>>> foothold
>>>>>> in DC this will become a common setting for most NICs.
>>>>>
>>>>> Initially we used pcie_relaxed_ordering_enabled() to
>>>>>    programmatically enable this on/off on boot but this seems to
>>>>> introduce some degradation on some Intel CPUs since the Intel
>>>>> Faulty
>>>>> CPUs list is not up to date. Aya is discussing this with Bjorn.
>>>> Adding Bjorn Helgaas
>>>
>>> I see. Simply using pcie_relaxed_ordering_enabled() and blacklisting
>>> bad CPUs seems far nicer from operational perspective. Perhaps Bjorn
>>> will chime in. Pushing the validation out to the user is not a great
>>> solution IMHO.
>>
>> Can we move on with this patch for now ? since we are going to keep the
>> user knob anyway, what is missing is setting the default value
>> automatically but this can't be done until we
>> fix pcie_relaxed_ordering_enabled()
> 
> If this patch was just adding a chicken bit that'd be fine, but opt in
> I'm not hugely comfortable with. Seems like Bjorn has provided some
> assistance already on the defaults but there doesn't appear to be much
> progress being made.

Hi Jakub, Dave

Assuming the discussions with Bjorn will conclude in a well-trusted API 
that ensures relaxed ordering in enabled, I'd still like a method to 
turn off relaxed ordering for performance debugging sake.
Bjorn highlighted the fact that the PCIe sub system can only offer a 
query method. Even if theoretically a set API will be provided, this 
will not fit a netdev debugging - I wonder if CPU vendors even support 
relaxed ordering set/unset...
On the driver's side relaxed ordering is an attribute of the mkey and 
should be available for configuration (similar to number of CPU vs. 
number of channels).
Based on the above, and binding the driver's default relaxed ordering to 
the return value from pcie_relaxed_ordering_enabled(), may I continue 
with previous direction of a private-flag to control the client side (my 
driver) ?

Aya.
> 
