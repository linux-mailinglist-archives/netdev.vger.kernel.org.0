Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8F74D5E98
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 10:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347642AbiCKJjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 04:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347624AbiCKJjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 04:39:20 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473FAE02CB
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 01:38:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZ97VUjzeFyQo0/22Wvh4Ou0/yraBOvHVb0Q/Cy54N6WyiKOECEBp92yDQv9eO7w9NgZ5cbPM2nOFTEo4wzBQpcCkcMJSZ4f4ZuQm0il3CvViBOkgDyoYc7qnCdkND/FOwwLLfH8aCY3/7IVILXg6W5mSiaJboD/X5D/xixNR6TYVuL+KmrFwKSof59nVmOkmhl6wQABCOjudfPcqND3Yx7RzWDSc4u+FWiteqTDLZcT4hQWBhCkuCMHIP3Iaw8PsFwrgFOvxLi/K5tWbHUV0bkY28on1axyiEjtOku35li+ztNqsR00BO0m7enoIty/eCVPlpf7P6Nd/WDFrXLStQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DM9EkabychAFfkNh3ozF1QUVQ0/m7AK3/nzZaGcg7wE=;
 b=hiTsnYQUTU85AGLh8kd+xKHp5N4IpNcKXCmdnl1vKbzIlfhBPMZc6+l1SpkuTJSwUNAex7repEYPfqkuUo9UIUwuJrVua/vQhO7Ie8PBUuQLDUfDC5aFMsxPpByDInOStQikzZj5hpKFWSKdnswAjITjGbccjGNvXdHCqUw27r99q08RHYftMVgKUpc+dfB2CZUfQde7dzyN9zlw92GB4noeDqBnuT6lTklT8IJnYmdbtgzV94NjeBBi8xBkLsksvybyg+0Dmmz8TE1g6mEr3sHzPpMWV/4ZY4cKyngGGg8VKsbQRuBQqFBaWjul0zAu5qgXhigtnMA3iOW2DM5Beg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DM9EkabychAFfkNh3ozF1QUVQ0/m7AK3/nzZaGcg7wE=;
 b=b5VsG5Qq8/NWUsEOLoS0/Bq3/oMYAwBWeQ0r1OOPqinBG21e49OZFpnSCse7rPIxu4+Z02CcCIlrcLctstnsZmYCBrDnzjkihsADu1QprIxmZHSKqVIEtNzFpTx17RQxFINzHvwgqVRvx3UdcaQmHDQBOLtxrHZX53TYW6G5QKo6HqHv5UC7hivCpmEBWUVV3qn7OzCFZtBjDTsCYD9o7uIqrL072Q2/LONPdQ/01V++KIfNWsFZ9fH6MygvO4oTsEGqYrJA3UJRik3KlmRkZe51HhXvc1nLLV4Oz55lRZ1MBUv56gQxm0fJXVmUxYocgOX44PwgxGRNTLlKqaXk/w==
Received: from BN0PR08CA0014.namprd08.prod.outlook.com (2603:10b6:408:142::23)
 by BN8PR12MB3137.namprd12.prod.outlook.com (2603:10b6:408:48::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 11 Mar
 2022 09:38:12 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::b8) by BN0PR08CA0014.outlook.office365.com
 (2603:10b6:408:142::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.23 via Frontend
 Transport; Fri, 11 Mar 2022 09:38:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 09:38:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 09:38:10 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 01:38:07 -0800
References: <cover.1646928340.git.petrm@nvidia.com>
 <288b325ace94f327b3d3149e2ee61c3d43cf6870.1646928340.git.petrm@nvidia.com>
 <20220310211301.477e323c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/3] netdevsim: Introduce support for L3
 offload xstats
Date:   Fri, 11 Mar 2022 10:18:39 +0100
In-Reply-To: <20220310211301.477e323c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <87y21g96de.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd9e3ddb-6c83-44d9-7a9c-08da0342dbf1
X-MS-TrafficTypeDiagnostic: BN8PR12MB3137:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3137DFDFB5872DD3898D52EAD60C9@BN8PR12MB3137.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: psLHJmvKwMKGcyHsm4ex1aK+MA5KWtLGpE14xWJPcJtBYkDamxT1r9ERaGIlP6IbYRuZIiXh8qdQFdjzqdMwrKcCd8ElJmm9BmDnUuywZI6G+0SvKfj8WYDQW1mHTi45mAh/sCQKf7xORrmPRJWOGbuE6Xf9IOkP0Gkhvtab/ORHTP6WNp8V7RggGNTphHLr+M3R55Q6RfSdvUyvAdTO7uXx9TstM+fAtn1Ruko3IZa+DeOQjOTYNISGW7SWA7vPV0Gv6sYCsTSgZu4UngJCUxFsDU+288dJxsNsBXB/tGPuIm4DhOLxBQLwqUL+eh5OFNCQSoJnJ0Gb88go1fxHy/V6SNvbm+q6kbKLTqoS8pKNq5eL2dteIKBAuM4thq4+6Xabu8s7VTuDJPd+S4GFV7S0pMjF/TmODGV0+9w/6IYpQHJDa4kt7BXwRFJanlYolL0CUixIvvYyEV6VD2Bglx4guT4v7TcJ5L9OOmyj6XOgtHhh/RemWE2ohcicdQ12wEasBx5WVvTPIwPUQG2qbAHJ0W/KWbJWbxKIYgWjjItQXjKoUyLKy1HnU+6liZ24dDXV1w1KF8lVnl8CFeW9ftikCYxkNM0M1tvh+ztHMTY7doe+qpvwfq7mXV6YB4uW0sONluN/01QqrZkZQWEjpJFh4fzKVyEwAgv1yJ5CvANx7qyC/pmMcwvBx9uPqJwszq8glVWpieEkBDf9agwPeg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(186003)(47076005)(16526019)(336012)(426003)(5660300002)(82310400004)(40460700003)(26005)(8936002)(2906002)(54906003)(6916009)(81166007)(356005)(70586007)(70206006)(4326008)(8676002)(36756003)(36860700001)(107886003)(508600001)(86362001)(316002)(6666004)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 09:38:11.7388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9e3ddb-6c83-44d9-7a9c-08da0342dbf1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3137
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 10 Mar 2022 17:12:22 +0100 Petr Machata wrote:
>> +static ssize_t nsim_dev_hwstats_l3_enable_write(struct file *file,
>> +						const char __user *data,
>> +						size_t count, loff_t *ppos)
>> +{
>> +	return nsim_dev_hwstats_do_write(file, data, count, ppos,
>> +					 NSIM_DEV_HWSTATS_DO_ENABLE,
>> +					 NETDEV_OFFLOAD_XSTATS_TYPE_L3);
>> +}
>
> I think you could avoid having the three wrappers if you kept 
> separate fops and added a switch to the write function keying 
> on debugfs_real_fops().
>
> With that:
>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

How about this?

struct nsim_dev_hwstats_fops {
	const struct file_operations fops;
	enum nsim_dev_hwstats_do action;
	enum netdev_offload_xstats_type type;
};

static ssize_t
nsim_dev_hwstats_do_write(struct file *file,
			  const char __user *data,
			  size_t count, loff_t *ppos)
{
	struct nsim_dev_hwstats *hwstats = file->private_data;
	struct nsim_dev_hwstats_fops *hwsfops;
	struct list_head *hwsdev_list;
	int ifindex;
	int err;

	hwsfops = container_of(debugfs_real_fops(file),
			       struct nsim_dev_hwstats_fops, fops);

	[...]

	switch (hwsfops->action) {
	case NSIM_DEV_HWSTATS_DO_DISABLE:
		err = nsim_dev_hwstats_disable_ifindex(hwstats, ifindex,
						       hwsfops->type,
						       hwsdev_list);
		break;
	[...]
}

const struct file_operations nsim_dev_hwstats_generic_fops = {
	.open = simple_open,
	.write = nsim_dev_hwstats_do_write,
	.llseek = generic_file_llseek,
	.owner = THIS_MODULE,
};

static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_disable_fops = {
	.fops = nsim_dev_hwstats_generic_fops,
	.action = NSIM_DEV_HWSTATS_DO_DISABLE,
	.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
};

static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_enable_fops = {
	.fops = nsim_dev_hwstats_generic_fops,
	.action = NSIM_DEV_HWSTATS_DO_ENABLE,
	.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
};

[...]
