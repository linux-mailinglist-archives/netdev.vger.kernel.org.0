Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EDE430968
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 15:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343750AbhJQNpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 09:45:38 -0400
Received: from mail-dm6nam12on2069.outbound.protection.outlook.com ([40.107.243.69]:55681
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237604AbhJQNph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 09:45:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKyjMn/yJYzoeofutWZOiyhYSZeKmC4ZC5UvggRja26HpuMKggAUihlOFjhPTKlIWWANWpFvPgiPdxsN4P9oYe4Bsxiisv/Fs+KxS19Fvg9D5WBPPSf4Pv/Tgw2GvAD+IqgeLexpmewfo5AwwjP6B4txuahl6LPIHQNX7q7tYTYtz/mP+y+3aW/mtCwuwER0+tl64zm/efy5nPqlpUiGndrnaqOKHUd0MwBHkshWJ7rGdfPQwmiJSylp1u3MNhgW0Z8IIRLPZ1sif9y8L6zDC0h1MQMPYUse65MVnGn6DnnIIYIMQaQVH4nMXSucdbE9NJlBEUACVchqshgcPpYb1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzMGmPlqgqVkIOv0sWJGJAWcKBy69bzFCnQv5lzMcNk=;
 b=njN9RFDKafJnaX8mSDomNM5kDn5fwyWGO5gWc8ffNza6eQpE4R2pRoRRBAlck0oYMHQdDdADv/N+cnTFFrIuA+6nd714nIba4u3SYKoFebGnXgpbDgsn8e884fSfn1C7S254OwHavpxEtHJR0k+vLdov2t3owV7qp42+nmjFGEgN1YAgjhws1WXXk5OzJFnv7+P6DwKyPbpxSj9Da7Zjcik55oIzDLi5zJ0qhFcqgLf3LNIJagxm47p1VDGpFekANA39IgA+td5U2mddUz2IcSwmTkxpMrTid3AejEJgi9lClbQkFDH45JTZYNTgfuxDYY/a4JetFuQrYsRnOQ+DSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzMGmPlqgqVkIOv0sWJGJAWcKBy69bzFCnQv5lzMcNk=;
 b=ViPPcnqo3950RyR3ACxpKkV9kb+f2y6H+AKk5MnXYJ5Sl78+bSDvdEFiU3wpIb4K0OFpkDtahrCfEf4jwH3HtwrVAJv0Cu99Y5rPJXMQSwWJe9vYl7hbFfN0j52rBG01fMXr3Aeh0/Ql94X0v4wwPzqg8WeFBdNwVo3Z5Bv/nVEmV0e5/Y8WiK4//dp++c+dm6zFCevDSYPE02o6dcvaKIWMyCX3ylw7hkLT9c/JcTfpT3yEqzKxquvaccBtWf89k1eRCaTMBGcT6QMg4IwGLbH+YLWzXcaRACY7E9tPyMR3J8BuxkffQ4XlB8hOeQslxR4gZaL8kbLTguUVZWUTgQ==
Received: from DM6PR11CA0068.namprd11.prod.outlook.com (2603:10b6:5:14c::45)
 by CH2PR12MB4922.namprd12.prod.outlook.com (2603:10b6:610:65::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 13:43:26 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::88) by DM6PR11CA0068.outlook.office365.com
 (2603:10b6:5:14c::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Sun, 17 Oct 2021 13:43:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Sun, 17 Oct 2021 13:43:25 +0000
Received: from [172.27.13.186] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 17 Oct
 2021 13:43:21 +0000
Subject: Re: [PATCH V1 mlx5-next 04/13] PCI/IOV: Allow SRIOV VF drivers to
 reach the drvdata of a PF
To:     Alex Williamson <alex.williamson@redhat.com>, <bhelgaas@google.com>
CC:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <kwankhede@nvidia.com>,
        <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-5-yishaih@nvidia.com>
 <20211014161150.38e3d8aa.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <0b3d2152-d925-4bca-bd81-447c186b4b41@nvidia.com>
Date:   Sun, 17 Oct 2021 16:43:17 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211014161150.38e3d8aa.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed102ceb-a940-4cfc-450c-08d991741846
X-MS-TrafficTypeDiagnostic: CH2PR12MB4922:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4922DC636C79ABD28A7DEA40C3BB9@CH2PR12MB4922.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SqCwuz17hUfWfCEybVLApPHpbqTHkupCsftngg/P2f83uOdC+GMl6dL+DGMdbK8Y1kTrVAZAd5hgkhx7b+6pBJiZPtJjW24JG5B6tpjzgaTQt+kwWwp4U4J5vd1AhdYPzYBWgiWn8tRq4UGnrO15hvq0aAox6TA0L9XOxZ3dvi/XRRaaHyxoURxekR7xPIGoiAeEYIaPL72cegiUfDOJFQZG87Oop07hiwzXdM6N4LTFO1ZOuCItEG+x+bSqAdamsZ1IfsBikyIEle/lOapLnTpZa89JkJdxSLL1nSDO8HBJKv4HzKV7pDd37v/n680KlQw6+h2AbmUG6PUhgXHt2MXfTIREU0/G/0rZIY3ul7FoR49sIg6EXTz/OblEoTjB8Cy50/tElptiPO2hf66afD89rov9LT00QqZh2cGq+QJlfbz780KFcjkLuoHHNcIYmSR94wmWMcnAaksNo9aY/L+9wwX0CaitV5LRVer+tkFuDP1Hi32M1TBXDgLK421wBSDwE1EbpxPIxFKjsuzn/BWfNTW4jpPWs+RAAhrgTw4TqXzLCtrPpOOew4UB1YNd1nB4jzUwVt611twm233bzrvlo07tMyPymVYYbVemytn9MFE7wDiMrZj2ksxGVSEJoOq8MfAeAf5ZlbBHZiQf4aMdhNWxjAnNiwuMxO8appJ5E1F5ZycOrxbabJSHVy+Srzo7PLYBYM1EyqUCtoBrzJmtZV1TV27DHcc8Uo4K4Ys=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2616005)(426003)(16576012)(70206006)(70586007)(86362001)(47076005)(107886003)(36756003)(110136005)(82310400003)(83380400001)(336012)(8676002)(8936002)(508600001)(54906003)(2906002)(356005)(4326008)(5660300002)(7636003)(31686004)(6666004)(186003)(16526019)(36860700001)(26005)(316002)(53546011)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 13:43:25.7628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed102ceb-a940-4cfc-450c-08d991741846
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/2021 1:11 AM, Alex Williamson wrote:
> On Wed, 13 Oct 2021 12:46:58 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> From: Jason Gunthorpe <jgg@nvidia.com>
>>
>> There are some cases where a SRIOV VF driver will need to reach into and
>> interact with the PF driver. This requires accessing the drvdata of the PF.
>>
>> Provide a function pci_iov_get_pf_drvdata() to return this PF drvdata in a
>> safe way. Normally accessing a drvdata of a foreign struct device would be
>> done using the device_lock() to protect against device driver
>> probe()/remove() races.
>>
>> However, due to the design of pci_enable_sriov() this will result in a
>> ABBA deadlock on the device_lock as the PF's device_lock is held during PF
>> sriov_configure() while calling pci_enable_sriov() which in turn holds the
>> VF's device_lock while calling VF probe(), and similarly for remove.
>>
>> This means the VF driver can never obtain the PF's device_lock.
>>
>> Instead use the implicit locking created by pci_enable/disable_sriov(). A
>> VF driver can access its PF drvdata only while its own driver is attached,
>> and the PF driver can control access to its own drvdata based on when it
>> calls pci_enable/disable_sriov().
>>
>> To use this API the PF driver will setup the PF drvdata in the probe()
>> function. pci_enable_sriov() is only called from sriov_configure() which
>> cannot happen until probe() completes, ensuring no VF races with drvdata
>> setup.
>>
>> For removal, the PF driver must call pci_disable_sriov() in its remove
>> function before destroying any of the drvdata. This ensures that all VF
>> drivers are unbound before returning, fencing concurrent access to the
>> drvdata.
>>
>> The introduction of a new function to do this access makes clear the
>> special locking scheme and the documents the requirements on the PF/VF
>> drivers using this.
>>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/pci/iov.c   | 29 +++++++++++++++++++++++++++++
>>   include/linux/pci.h |  7 +++++++
>>   2 files changed, 36 insertions(+)
>>
>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>> index e7751fa3fe0b..ca696730f761 100644
>> --- a/drivers/pci/iov.c
>> +++ b/drivers/pci/iov.c
>> @@ -47,6 +47,35 @@ int pci_iov_vf_id(struct pci_dev *dev)
>>   }
>>   EXPORT_SYMBOL_GPL(pci_iov_vf_id);
>>   
>> +/**
>> + * pci_iov_get_pf_drvdata - Return the drvdata of a PF
>> + * @dev - VF pci_dev
>> + * @pf_driver - Device driver required to own the PF
>> + *
>> + * This must be called from a context that ensures that a VF driver is attached.
>> + * The value returned is invalid once the VF driver completes its remove()
>> + * callback.
>> + *
>> + * Locking is achieved by the driver core. A VF driver cannot be probed until
>> + * pci_enable_sriov() is called and pci_disable_sriov() does not return until
>> + * all VF drivers have completed their remove().
>> + *
>> + * The PF driver must call pci_disable_sriov() before it begins to destroy the
>> + * drvdata.
>> + */
>> +void *pci_iov_get_pf_drvdata(struct pci_dev *dev, struct pci_driver *pf_driver)
>> +{
>> +	struct pci_dev *pf_dev;
>> +
>> +	if (dev->is_physfn)
>> +		return ERR_PTR(-EINVAL);
> I think we're trying to make this only accessible to VFs, so shouldn't
> we test (!dev->is_virtfn)?  is_physfn will be zero for either a PF with
> failed SR-IOV configuration or for a non-SR-IOV device afaict.  Thanks,
>
> Alex
>

Yes, this should be accessible only for VFs.

We can go with your suggestion to explicitly check (!dev->is_virtfn) as 
this seems cleaner and safer as you mentioned.

We already got ACK on this patch from Bjorn but as your suggestion seems 
straight forward I may put the Acked-by as part of V2 in any case.

Yishai
