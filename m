Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9815841AB91
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 11:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbhI1JOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 05:14:33 -0400
Received: from mail-sn1anam02on2059.outbound.protection.outlook.com ([40.107.96.59]:64325
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239712AbhI1JOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 05:14:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1Vm6R9vbSoi256K2tV9/Kq6jxlFJgYqPKYmgPaLXFMRhFHELsJHS5IorH7MvS2hHtiQIJwyZqJHY3KZfh1inx+2NU+rh5hW26txbRPaD27nlGd7SpePUdRpwlpUl7i4HZnUAV+HWm1tb9/S3colvsF2tjSrrMBi8ttdnNqm07ptvbkdxv8eZP4cSNRo7R8Xc1Km4uE3YtEAaiRFSPjFqq8IOy23UMSOmA3U87gMWZERT6L3wJrVK/NAqWHEAHORPgRJwGbvx561fxPhBPaqxfuhv314mfOZ829czjmVF8IfHW3qX8sES6VqnWrWzQX6OyRCcJbw/nB6Miq5zlqwHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qkuBLM/PzhqudKzcV0GBqwa3pd2Yj5UJP4ebUSdJ0to=;
 b=FKDVW+k6GVcy0d96JzIXEi4PrWpmeGx8o7KXRstxsvVbNsXG0byh1PFr4yXNaB7OKB6ZUDxAkoq8tdnOThJKSukx70Iw8GTN5nsBVCegPttBTEeUhCTTP8k/d1/DLjsDBLc/lEkZ4OkK+Gae8qP0VB2hYQaQjc/fWq8Twe3prgVTN9XVJtjhZFdTFToQ94jRzQBMamqTjxU3XYCrFIpBQf3xW6kcZ2U1H6J1vxZ9RlwH1/JY8K0tx415312oRwW8iNmkKS3h2d5kAGV3i+2tYKcgI14MpD+D0b8zMaXXFuMvxgQDsBPXhXN3rf3zCDWtIasvVfwemkApcWtB/nlOrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkuBLM/PzhqudKzcV0GBqwa3pd2Yj5UJP4ebUSdJ0to=;
 b=ob2D7ZL5aSB0KEAt0wcTMcuQH5yV81zl1+ZpcVAeUtnX5yEfzahuxkd2j2iRq0u5gl3RVbMXhz7gaUe0T9efpr6azQWjNOyL5QxUy41HJxCDn4OLC7fdn+wzZrfssRH3SL8hT+YTc1Mw+L8GZG3yTWFgIIO3sQMLn1SK9ovOjYvJjITsuhSR8HyXTJE6mrbbN2XVGCxJ9fquT/t75lmgdyF2Ap2DEpWXmGC7UnsqJYZyR7Jt7/3GRQvgIcuMDMUgn5/0zHgmslduiKs0VS9OfCOj4jcHW7UO1LgickiBO2djIy3zDuvXC3rF4nWZWNMI/QELM0ywUxiz37+n2MJDXA==
Received: from MWHPR22CA0001.namprd22.prod.outlook.com (2603:10b6:300:ef::11)
 by BN6PR1201MB2483.namprd12.prod.outlook.com (2603:10b6:404:a6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 09:12:48 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ef:cafe::12) by MWHPR22CA0001.outlook.office365.com
 (2603:10b6:300:ef::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Tue, 28 Sep 2021 09:12:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 09:12:48 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 02:12:47 -0700
Received: from [172.27.4.189] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 09:12:41 +0000
Subject: Re: [PATCH rdma-next v1 06/11] RDMA/nldev: Add support to get status
 of all counters
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Neta Ostrovsky <netao@nvidia.com>, <netdev@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
References: <cover.1631660727.git.leonro@nvidia.com>
 <86b8a508d7e782b003d60acb06536681f0d4c721.1631660727.git.leonro@nvidia.com>
 <20210927173001.GD1529966@nvidia.com>
From:   Mark Zhang <markzhang@nvidia.com>
Message-ID: <d812f553-1fc5-f228-18cb-07dce02eeb85@nvidia.com>
Date:   Tue, 28 Sep 2021 17:12:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210927173001.GD1529966@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd8fe218-386d-4d16-545c-08d982602406
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2483:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2483E35D0BFA8529EB8BD7B9C7A89@BN6PR1201MB2483.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KQhe85z0XBxCUoVtMvbHHcPJ8UMEoBbgyGAT/qS58Lfqzn0v89BoHh6BdkGSq4NDR5eu60qi1zeOTniu3TwEyoNj5ajeDs/7J/N8zM0svWF8+taHENQfUd/qB5ZYiBKIkFQBog7qXoLBgvXLZb8sCNl59HXpOsXb03bPv8LI/Yh96uVHKj82OtlRdn5RC8XvmtXoD1DCt+99S7kInMzsJdNia14ggyYZ4qklicMOmJrI4lBtdKfjN0o05ZakSAF5OzhL/HUi0vT0fybBVpyUY4flzQ4bzxWazkSYCVFTArI8craiCJ/jGRhCvjTzvlEZ+NVOfcnfk9CW1phcfptu2wf5K3aFUDerdhvjT6YmbobhSibhO3ai25lKF13ALhm5BQfCpPNsSO0QRvakljjWYuDyIMxVCy9JDP2y0aXypqcw/5y6pkFpnXcW+G3BLFqgdjjIv4DLBsvomqYQVwHHc1AaVnrfnS7DY8gzoOjw2qve+yNgnK8aqHtvMHrjuD88ha9393a7zDUVYMMlNkmtv8TvQ4MurfFhehNd3NQ3zsEgWDtR0URfE9Y+cLU+tuhvoR48nUXO2xfA4++TbaV3vu46l7WIiB6u+6XPuC5gCE4zrRRLYT1gyOHq92W9JnxfxArh7xfQhkkM0QqN8QdqT/TRewVQP6HNiF9216qrnHSOws8+0bJafaNT89n61xGhOXhTejCVDcUWo5kWIZULjxiOqVMSCk9QAGCUcdtc6ss=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(110136005)(31696002)(7416002)(4326008)(26005)(426003)(54906003)(2906002)(53546011)(86362001)(7636003)(508600001)(36860700001)(31686004)(336012)(82310400003)(16576012)(316002)(8936002)(356005)(186003)(2616005)(36756003)(8676002)(16526019)(70206006)(5660300002)(47076005)(70586007)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 09:12:48.1442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8fe218-386d-4d16-545c-08d982602406
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2483
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/2021 1:30 AM, Jason Gunthorpe wrote:
> On Wed, Sep 15, 2021 at 02:07:25AM +0300, Leon Romanovsky wrote:
>> +static int stat_get_doit_default_counter(struct sk_buff *skb,
>> +					 struct nlmsghdr *nlh,
>> +					 struct netlink_ext_ack *extack,
>> +					 struct nlattr *tb[])
>> +{
>> +	struct rdma_hw_stats *stats;
>> +	struct ib_device *device;
>> +	u32 index, port;
>> +	int ret;
>> +
>> +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
>> +		return -EINVAL;
>> +
>> +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
>> +	device = ib_device_get_by_index(sock_net(skb->sk), index);
>> +	if (!device)
>> +		return -EINVAL;
>> +
>> +	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
>> +	if (!rdma_is_port_valid(device, port)) {
>> +		ret = -EINVAL;
>> +		goto end;
>> +	}
>> +
>> +	stats = ib_get_hw_stats_port(device, port);
>> +	if (!stats) {
>> +		ret = -EINVAL;
>> +		goto end;
>> +	}
>> +
>> +	if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
>> +		ret = stat_get_doit_stats_list(skb, nlh, extack, tb,
>> +					       device, port, stats);
>> +	else
>> +		ret = stat_get_doit_stats_values(skb, nlh, extack, tb, device,
>> +						 port, stats);
> 
> This seems strange, why is the output of a get contingent on a ignored
> input attribute? Shouldn't the HWCOUNTER_DYNAMIC just always be
> emitted?

The CMD_STAT_GET is originally used to get the default hwcounter 
statistic (the value of all hwstats), now we also want to use this 
command to get a list of counters (just name and status), so kernel 
differentiates these 2 cases based on HWCOUNTER_DYNAMIC attr.

