Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2BF41AF6B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240838AbhI1MxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:53:03 -0400
Received: from mail-mw2nam12on2079.outbound.protection.outlook.com ([40.107.244.79]:20449
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240712AbhI1MxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:53:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLOvzj5SgkGktEx17TS8CQrj8L3/6CluRkTSUI9Wmx74fXj+yN9C9rdZ2ic+grQ59EklIwBKGgsuD0hz3pjAhYVqgahzNj+1k2+gLLNiuHdps2cddX2pMdUWfZ2/EuB8VRSN5ZAMiqVdFSeAIVJtjYjWA1KB9oqGLbPSY4du5aU+thUG9e33KCVzrJBHD2MyGG6+7WPu4FEMP2MD1N9+JgjkVjiVBkR2NtxDYRST3IU6E/Carf3XD+7RawAtS0JB4ELQsuzLbMNKvi52mgCl8u1g4YWNC2lo4KZ9XG88IS3/t3xyEXyU9yGFb3OJkNSlRmUgSxq8DAAbt/nfE+fkkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/pGJhUmkjtSoyz0F+/965Pf821lp2qWIY7MWifaYRsw=;
 b=kCyLVrrdksmoppS87O5izw0R9784GblXfZ+51RTC8jU/uAbVs3BeD8NRa6TEvCtC6uWvDaIhuB+gYE4XciGC77CSzKo4GYY+sk7qZcJnvKE+YS9Z0HuvEA0713ym+cyu0qTxZwsE0nEFIJOm40vg6zc6rjVPpvtYG+grU6TGCXf6u+AawEvr5MZZSC6MWRG/YK9ZpcdpNdkfvlLvTC0YAKBxLpaVZpaF4janZxS/yOuYOrPnciJLGTZYCCSVrFRsLc0NY8IX1/57xSivj4ArNwEHUn/ydCu0qzUar4x65aWsNiZnUyKAizTsoHGyvfu/fWIjAG3vA1Sht6cCEAAyCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pGJhUmkjtSoyz0F+/965Pf821lp2qWIY7MWifaYRsw=;
 b=AWFc8W7KArTkEcwuXc9DV+baWlESHBVD+aacE2YfqMlQGupChZUmtiGCIusl2joEr6+Kmli8v172hN4+N4VpGFojwyKiIgvYXFfO/zeZlFeNtSg/5vQ0pexAuJV328dn3Ou+iX7VYrdkVv+1r+DNggwEJT0HLEUfjQ/qmElDIfEQKi/rka3TJtEh1ZEMsCsJ6cPih7NpPdu+P2e26UhDZy0mnl+FqCbqJgVf1EAjVsfmshP3TKrA7rZfvxrwfSJupFfkOM0xsX6Hqo2Me6J0hNpfjypEKAb1CKZvaJd0EIoNHDwORw0yqdIk6RaYq+FzPpTV6cikMo7OSP8TXi/UVg==
Received: from MWHPR19CA0063.namprd19.prod.outlook.com (2603:10b6:300:94::25)
 by BL1PR12MB5253.namprd12.prod.outlook.com (2603:10b6:208:30b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 12:51:21 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:94:cafe::aa) by MWHPR19CA0063.outlook.office365.com
 (2603:10b6:300:94::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend
 Transport; Tue, 28 Sep 2021 12:51:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 12:51:20 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 12:51:19 +0000
Received: from [172.27.4.189] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 12:51:14 +0000
Subject: Re: [PATCH rdma-next v1 06/11] RDMA/nldev: Add support to get status
 of all counters
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
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
 <d812f553-1fc5-f228-18cb-07dce02eeb85@nvidia.com>
 <20210928115217.GI964074@nvidia.com>
From:   Mark Zhang <markzhang@nvidia.com>
Message-ID: <d71e2841-43b1-9be2-40f5-e9fb50400904@nvidia.com>
Date:   Tue, 28 Sep 2021 20:51:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928115217.GI964074@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2dc4264b-011d-4fd7-183d-08d9827eab8b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5253:
X-Microsoft-Antispam-PRVS: <BL1PR12MB525394DA8476D5B6B851E004C7A89@BL1PR12MB5253.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vaxGgrdDIc/IauIeJEo/ttwNgxrhm1hc0uYdg8VIdjsi5WS+p9XaKGRuexsrvX6n9sa47bb0dSWG0atdWtLwaHl0vodNgJLk6xPXW/KUeKKpo0SuKxSQcy5V4jy1U7X039oou6ItZmWPLPZTXlGVE637kCBxEE1W7LCooc7J7SabeZfAi1i9BQ/jdvf4sn4AC+UcWI35KxY/xSd+8JI5UV1px7LyVhIZFgyCpXENEOvunlUqQ1AfNfnlrcn0wCWG2UQaqORjg1Z2xhNp6kJZIpQRuKbVadCsrDM1g9yZVOHvX903I4hpJ+/ceRfAKoGyEiBJ6cnMC6X1kxVvGe9qcP83Yv5Q9Y4wnKNlh0UP5u4ljp3d1iAg/7agRcwI+qV+FzungYX3R6fXdvNHElCTOpeQBJcYi3kqdDtDbntCb227DW7SD3YCVUgO9bDshFzCiI9Bzc3X+BENhQ7lIrdx/XrOSsEpFDtK9C3Jc2qO+7ye35V1YReCE5ijXGFSGXNDM6JojvGLyJ+59jm3wHU0uT/H8hknwrG2JbLa/KUkyLnpMXdpS+h7bSQW1X76bqEWYuogbuuhH7rM4u2ahJ2U9eL51JA5etv2VKMmInQ6dHP8OxScV8NFHUD30P/iqi0n2BjA/cILmy34k7agOX9Q74yVTYY73HEYdwkXNy8BCwxKjVeC4lrYOWXrWt8FA8BvQ5OSeit2FbUsJvTHX18FhSwiy3V5Ar80vrYar2Krk9Q=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(53546011)(6862004)(16576012)(508600001)(47076005)(356005)(316002)(31696002)(7636003)(54906003)(6636002)(186003)(37006003)(16526019)(8936002)(31686004)(70586007)(6666004)(336012)(36756003)(4326008)(426003)(26005)(86362001)(2906002)(5660300002)(82310400003)(8676002)(2616005)(70206006)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 12:51:20.3996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dc4264b-011d-4fd7-183d-08d9827eab8b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5253
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/2021 7:52 PM, Jason Gunthorpe wrote:
> On Tue, Sep 28, 2021 at 05:12:39PM +0800, Mark Zhang wrote:
>> On 9/28/2021 1:30 AM, Jason Gunthorpe wrote:
>>> On Wed, Sep 15, 2021 at 02:07:25AM +0300, Leon Romanovsky wrote:
>>>> +static int stat_get_doit_default_counter(struct sk_buff *skb,
>>>> +					 struct nlmsghdr *nlh,
>>>> +					 struct netlink_ext_ack *extack,
>>>> +					 struct nlattr *tb[])
>>>> +{
>>>> +	struct rdma_hw_stats *stats;
>>>> +	struct ib_device *device;
>>>> +	u32 index, port;
>>>> +	int ret;
>>>> +
>>>> +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
>>>> +		return -EINVAL;
>>>> +
>>>> +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
>>>> +	device = ib_device_get_by_index(sock_net(skb->sk), index);
>>>> +	if (!device)
>>>> +		return -EINVAL;
>>>> +
>>>> +	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
>>>> +	if (!rdma_is_port_valid(device, port)) {
>>>> +		ret = -EINVAL;
>>>> +		goto end;
>>>> +	}
>>>> +
>>>> +	stats = ib_get_hw_stats_port(device, port);
>>>> +	if (!stats) {
>>>> +		ret = -EINVAL;
>>>> +		goto end;
>>>> +	}
>>>> +
>>>> +	if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
>>>> +		ret = stat_get_doit_stats_list(skb, nlh, extack, tb,
>>>> +					       device, port, stats);
>>>> +	else
>>>> +		ret = stat_get_doit_stats_values(skb, nlh, extack, tb, device,
>>>> +						 port, stats);
>>>
>>> This seems strange, why is the output of a get contingent on a ignored
>>> input attribute? Shouldn't the HWCOUNTER_DYNAMIC just always be
>>> emitted?
>>
>> The CMD_STAT_GET is originally used to get the default hwcounter statistic
>> (the value of all hwstats), now we also want to use this command to get a
>> list of counters (just name and status), so kernel differentiates these 2
>> cases based on HWCOUNTER_DYNAMIC attr.
> 
> Don't do that, it is not how netlink works. Either the whole attribute
> should be returned or you need a new get command

Will add a new get command for backward compatibility, thanks.
