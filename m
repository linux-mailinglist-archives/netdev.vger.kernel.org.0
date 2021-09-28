Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E269041AB64
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 11:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbhI1JFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 05:05:16 -0400
Received: from mail-co1nam11on2041.outbound.protection.outlook.com ([40.107.220.41]:25472
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239711AbhI1JFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 05:05:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1xE8/BMU9KEJiSd+2Agq26TrLPCpKPP/XPOb0UynBgNjbOF1SIFl7AyG4MtsECU/o0iM4x9/I1yKb/rJbSSxG2YQS89MI4q+MtJsp+fN0p43XmgHOaaPT/HsdasF0Ps6SIBilZUFEnPOdESmWmJa8b+RkAGzWDUl2MtRY63T2Z2BfTARQezoyLdo++0cIuzUzPOo+2nadUaBp6Sr45fOm4o690pEr88R20Ws4tdYK8GbUTBaWRXuklFsx3HZmDXYZTjOmINUjvzRau+esx3K6Bh9lLw2SmyrQQnLk3wdnm23SqA2fd9qV/xKbjgEZ5gWkI0Uz80pr9OO9LLSakxKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PNGcfcsCkiA1B568wC9bq1XL1SbKrk3H+ei6V+Uw438=;
 b=eTrQODA3TpC1E2eOEQkd2eAbUDMcKe6+J1tok40wtdu1mBG1ytN4ngLdoeSbmFnu4VJ3p+NVh5GLNzDgYgXGGY/nndQkvQ6NcldNgpW5me4x5GldtyfLJKUePnT1zC0z5AjGh7IgcO+Un68ca5rRcxt1w3GYhAq3nMDoqNBA5jwQOZYs7iS1qZui4sl+DwlGUCQNYjwamyWrZwLZxDBEHMA3KJjH+vMbgsgJvkUisuSyZClqbnnvLW8hz3Mfmd1VNd1EKNSkjlmUlU2zUx2M7BugXDBKL2s4PelqrQCSjldbBtzcjnaNkWVackOq1Krw7MK0sO4kGNQ0Gxksv/umpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNGcfcsCkiA1B568wC9bq1XL1SbKrk3H+ei6V+Uw438=;
 b=X6+JMwdj3zRlBdG6PySYegQDNUX36CA6bLv+eh0sCxslBAckiLTNptP+ZRGb+7Ip1dXU+eSthABEEcrX0dbWisUrO5AFiwKNwsQyQ0j77BBxRPn0YydzTuQz80OHAC3v+KSoZxUGsZa/rJIm8+xpNmXayODQmzmpHzHOYws5062fxV9jHxaelskNfk6Gu1KBSW6JQVzVaKevtSdAW2u1jaVqkCAbcnGCDXKIZPNAPAUUyTNhsCdW24VQgAUlJrsFC9bf0MmxFfLOLyXv2i+6qYqXtt7OO/I6Ra+683J/L/JhP4i1avn2pb02mCET93Evp65Ij4Lt1mRuuoW8WipJsQ==
Received: from MW4PR04CA0269.namprd04.prod.outlook.com (2603:10b6:303:88::34)
 by BYAPR12MB3079.namprd12.prod.outlook.com (2603:10b6:a03:a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 09:03:34 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::1d) by MW4PR04CA0269.outlook.office365.com
 (2603:10b6:303:88::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend
 Transport; Tue, 28 Sep 2021 09:03:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 09:03:33 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 02:03:32 -0700
Received: from [172.27.4.189] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 09:03:27 +0000
Subject: Re: [PATCH rdma-next v1 05/11] RDMA/counter: Add optional counter
 support
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
 <04bd7354c6a375e684712d79915f7eb816efee92.1631660727.git.leonro@nvidia.com>
 <20210927170318.GB1529966@nvidia.com>
From:   Mark Zhang <markzhang@nvidia.com>
Message-ID: <d9cd401a-b5fe-65ea-21c4-6d4c037fd641@nvidia.com>
Date:   Tue, 28 Sep 2021 17:03:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210927170318.GB1529966@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd7121ad-9d75-4d4f-dbf9-08d9825ed97a
X-MS-TrafficTypeDiagnostic: BYAPR12MB3079:
X-Microsoft-Antispam-PRVS: <BYAPR12MB307958F5307F4BDAC1E42EFAC7A89@BYAPR12MB3079.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0C2WAg+xoq530E5p9c4e+46yT3A2NA/nO01aj19gEe/CysV4BSWMuunFSgMR2rS9mH2JBpEtnrMdbDQ2CDHb9zWpTIpB4vhCXncEQH3SVtbuKBxVTvfbAijQvDSUfT2OdHIPCKxD2GcslBbf472ehnH8fhnX48lUsQYPVfs/4FHrciFPQKryX86udUH1JgWmsZKuYi1TJfJ4ZJiJ1f4O3tG+c/B2e8e7aV1q9ml5GYKl9O1onJ19KwckCXOdVdUDiz10C1wBIIP6gcVgh8Iuv1aVM4hEZRDL+Q39BgUaVUxWjBVNHd8EejkuVOPhcCZWQFZQRxvpNiqjTm8LP3i86rMMY/8zXbkhKqpyJsJpFyINqr2Lpk26N70xGxBql9fe7zFVIlMYsIudc5P6Iq0v9TB1EJJ35+wpFxxqF/Hp3vItbxYiSPBHiLXC2eHchGbGUHUHYhBEmIUoSCN2jepk9Tn3P1TccXSthcySG6WBmKkxdE60Oxzwb5M/wm4d3MtbLC1de6WYgkEGmSG1JwLr31kmMuhHxKZg23Q0lKoYyPunTVQGrJLPBHmPl0uHtY2cl6SYXrxquTKYaFkKk1Ybv9iWWuNC3UT4YeX8pARp+ypu6ADPHPO2oP72NhsSr7eT3fXUvNuzIopoU8YcrqJqFqs+7joPHyaGkImYIxKS3kfjQp0HwhmoD/WZHIDM7+GWEi4h0agZhjo+C3c52uaidNNmQm6YvCG5pk1nWoLWy/E=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(110136005)(8676002)(6666004)(7416002)(31686004)(53546011)(5660300002)(8936002)(16576012)(2616005)(426003)(54906003)(70206006)(336012)(70586007)(316002)(83380400001)(47076005)(36756003)(31696002)(86362001)(186003)(36860700001)(4326008)(16526019)(508600001)(26005)(2906002)(82310400003)(356005)(7636003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 09:03:33.5740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7121ad-9d75-4d4f-dbf9-08d9825ed97a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/2021 1:03 AM, Jason Gunthorpe wrote:
> On Wed, Sep 15, 2021 at 02:07:24AM +0300, Leon Romanovsky wrote:
>>   
>> +int rdma_counter_modify(struct ib_device *dev, u32 port, int index, bool enable)
>> +{
>> +	struct rdma_hw_stats *stats;
>> +	int ret;
>> +
>> +	if (!dev->ops.modify_hw_stat)
>> +		return -EOPNOTSUPP;
>> +
>> +	stats = ib_get_hw_stats_port(dev, port);
>> +	if (!stats)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&stats->lock);
>> +	ret = dev->ops.modify_hw_stat(dev, port, index, enable);
>> +	if (!ret)
>> +		enable ? clear_bit(index, stats->is_disabled) :
>> +			set_bit(index, stats->is_disabled);
> 
> This is not a kernel coding style write out the if, use success
> oriented flow
> 
> Also, shouldn't this logic protect the driver from being called on
> non-optional counters?

We leave it to driver, driver would return failure if modify is not 
supported. Is it good?

>>   	for (i = 0; i < data->stats->num_counters; i++) {
>> -		attr = &data->attrs[i];
>> +		if (data->stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL)
>> +			continue;
>> +		attr = &data->attrs[pos];
>>   		sysfs_attr_init(&attr->attr.attr);
>>   		attr->attr.attr.name = data->stats->descs[i].name;
>>   		attr->attr.attr.mode = 0444;
>>   		attr->attr.show = hw_stat_device_show;
>>   		attr->show = show_hw_stats;
>> -		data->group.attrs[i] = &attr->attr.attr;
>> +		data->group.attrs[pos] = &attr->attr.attr;
>> +		pos++;
>>   	}
> 
> This isn't OK, the hw_stat_device_show() computes the stat index like
> this:
> 
> 	return stat_attr->show(ibdev, ibdev->hw_stats_data->stats,
> 			       stat_attr - ibdev->hw_stats_data->attrs, 0, buf);
> 
> Which assumes the stats are packed contiguously. This only works
> because mlx5 is always putting the optional stats at the end.

Yes you are right, thanks. Maybe we can add an "index" field in struct 
hw_stats_device/port_attribute, then set it in setup and use it in show.


