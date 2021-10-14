Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CB942D5AB
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 11:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhJNJKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 05:10:45 -0400
Received: from mail-mw2nam12on2064.outbound.protection.outlook.com ([40.107.244.64]:43991
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229551AbhJNJKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 05:10:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Za7iuN60Pv5h7ln8/ym7G1RVT8rDQkpLam+EyV+Q97tvENGQ5AJUw55lE5B8nl3kSZ2gzSc04qDbT1TmVJwfZLQVwd8X1/JOzPYUv+o16h+q69dE08voUgM8zyb2hM9oTG9WVd79bC/TYyegw2Yns5aOwpv5qZyb9W/yDHnC77SfqdbaLClNHSF/z8CSCK0N3NhKViOoAA09RIp9xLo6kMjAunOwflOXMLaxEggZMJ6Oo6IDFY5V9c6qd2C+hhY5AXSdNXMqFV8G4zLR5K6O6Fh/8DkmrWsyvX2SfWpE3jrJBCFT8N5cvh0QrvHQS5SWWkliCBMHGmXQunAodlIxHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJy7VKXgtgD3G2QDSXPpk4vWJnG3p/DKX0If/EhyGyE=;
 b=m0/OfHsuSIJnIP2MzAIxtDCFVkQnoxL+mCB8UyLfSd+nYqvcHKRKw5a9sB9KnoEBi3BW2APtwl6HLblEDuRZqk2fptmDd3Ieu8eRyI2/jeHOF3NqXpRpIx1VPjUthwJHvd0erHwwZoHcVU6TIc6ob5sBtk8L3PMKCs62q/CvM6MOrgbL52P3DKuwfksPAAYWuRY0ooHXLxMElWV0XIIiSXilmVsFExDDch0SWPMdoF2k7NgTJghpS09/0tLUQUDYdNSCwusUYTWFLc6r99WdE1FViO7np0TNkSyqTCCr8zGuoTgKK1umh95DQajmT8ik9HwDo9gnMQO7Q/cK7vgRSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJy7VKXgtgD3G2QDSXPpk4vWJnG3p/DKX0If/EhyGyE=;
 b=Cx4jZhKnA2S4rtkLWng1VGnZiAdirf9OswhEmtLVrOQuwjto+8Uu+C4b9Obidlj6T7Y9NgK/1invJxSkEEi+LgAd3tN2XrBc523ohubbW9YiKsnXhfC5PX0PRgwZQZV0Gm4pZeAUbRjAWuGLHCnYWW5IjD13kDm8VNuksHeuIMmeD2TkutZ6hoWMFxIdg2Ax+tQA1cSX4HSNBf5vr0z6oKdnKVScn2X1wrSuRyfzfSr7hggLJigfkck34nIGtvnN4Kprb3VT8AAmiBoUtGpwK0OHkGrfLJOvic2+5uJsIt/qW9QGLcvXY4YX5TjDQlES3r1W0l/T5XJ7hak2fTZwjQ==
Received: from MW4PR03CA0077.namprd03.prod.outlook.com (2603:10b6:303:b6::22)
 by CH2PR12MB3688.namprd12.prod.outlook.com (2603:10b6:610:28::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 09:08:38 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::11) by MW4PR03CA0077.outlook.office365.com
 (2603:10b6:303:b6::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Thu, 14 Oct 2021 09:08:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 09:08:37 +0000
Received: from [172.27.11.74] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 09:08:31 +0000
Subject: Re: [PATCH V1 mlx5-next 01/13] PCI/IOV: Provide internal VF index
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <kwankhede@nvidia.com>,
        <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211013181426.GA1906116@bhelgaas>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <68d1d356-3a3e-7254-6127-297fc48cf197@nvidia.com>
Date:   Thu, 14 Oct 2021 12:08:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211013181426.GA1906116@bhelgaas>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa27df6f-7034-4f29-9612-08d98ef2353f
X-MS-TrafficTypeDiagnostic: CH2PR12MB3688:
X-Microsoft-Antispam-PRVS: <CH2PR12MB3688B683DE3512EE6D4731FBC3B89@CH2PR12MB3688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kWKHOs3iGcC/N7uyeGgWiC9Eu1fAGEso30wqoeXm9TEjFW6lOQ+iI0qPPkdqv+4iKIIpRMoy/Gnc1GufyxabN6JlfiWB6+jfQ+iT0TgCrHjGX9f5OppN/wt9vCmcltUxwHa73QXSYJUamDtkjsbX1EGdubGOKXbOMkHw2dNZJk+8+C5o7XsY3VRC9+rZNH229+1YPnaizS5Ff0ndYZrvpuzu3qSB6Z+OJVnh1qQGS/trwD/y+C31RvofdsElW/yN/rPr47ydRAYX31sekDXbZO5KRLCZ+iioOF/s06HCAzSBOp1M9X8Bk5o1cf9fv3LULUrNLzpf30Dwp5N2vM7IvcAfArpaz+uXpH8x7TVdxeumH7Qtdwq8Jz6wABLaYN+fsEZu/PTTx3cScDiO+TIQ0oPKXeVKPCJL8GuxECAHKgUfKtgS978iVEfLTITHpd7JUfxfIqOzQy76BL+1D1CG15kzyjQCqqrPQSul3ZU3hOsTuouNcr28WCidiOF7BDIb3mrHodEJwWBq0e0yUHP8LfY/nYvrTXOHjAfqcrMam+aQSnXa0f03NA4lJYiLAmJFi+8xxxT0MNNKQHcb/NLQeI6A8OTPtrE5ywzfggczgqXe1EyUlmnWUFkgjlRpOgC7xcVsl7ydVw+oD4Sl9G4+Yar+8dRzBcEA8Xwn4zUFg61kUdWzc7vT/KaMx4UHlWtq7Kq7BlMwmjp/XsNjyA6evjplsx647tFvbgKk9B0F5DMM7kQRId80xZXUxrCEuHR8NeQ9OZUU+HUKxelOty7t52JSb3gC9Zrhn1iwLyWgW6TPV3V7rn8tf716TbhIjwoy
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2616005)(4326008)(53546011)(26005)(426003)(6916009)(336012)(47076005)(966005)(31696002)(8936002)(508600001)(82310400003)(83380400001)(70586007)(70206006)(8676002)(36756003)(6666004)(54906003)(5660300002)(2906002)(316002)(86362001)(36860700001)(186003)(16526019)(107886003)(31686004)(16576012)(7636003)(356005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 09:08:37.5132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa27df6f-7034-4f29-9612-08d98ef2353f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/2021 9:14 PM, Bjorn Helgaas wrote:
> On Wed, Oct 13, 2021 at 12:46:55PM +0300, Yishai Hadas wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>>
>> The PCI core uses the VF index internally, often called the vf_id,
>> during the setup of the VF, eg pci_iov_add_virtfn().
>>
>> This index is needed for device drivers that implement live migration
>> for their internal operations that configure/control their VFs.
>>
>> Specifically, mlx5_vfio_pci driver that is introduced in coming patches
>> from this series needs it and not the bus/device/function which is
>> exposed today.
>>
>> Add pci_iov_vf_id() which computes the vf_id by reversing the math that
>> was used to create the bus/device/function.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> I already acked this:
>
>    https://lore.kernel.org/r/20210922215930.GA231505@bhelgaas
>
> Saves me time if you carry the ack so I don't have to look at this
> again.  But since I *am* looking at it again, I think it's nice if the
> subject line includes the actual interface you're adding, e.g.,
>
>    PCI/IOV: Add pci_iov_vf_id() to get VF index


Sure, will change as part of V2 and add your Acked-by.

>> ---
>>   drivers/pci/iov.c   | 14 ++++++++++++++
>>   include/linux/pci.h |  8 +++++++-
>>   2 files changed, 21 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>> index dafdc652fcd0..e7751fa3fe0b 100644
>> --- a/drivers/pci/iov.c
>> +++ b/drivers/pci/iov.c
>> @@ -33,6 +33,20 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
>>   }
>>   EXPORT_SYMBOL_GPL(pci_iov_virtfn_devfn);
>>   
>> +int pci_iov_vf_id(struct pci_dev *dev)
>> +{
>> +	struct pci_dev *pf;
>> +
>> +	if (!dev->is_virtfn)
>> +		return -EINVAL;
>> +
>> +	pf = pci_physfn(dev);
>> +	return (((dev->bus->number << 8) + dev->devfn) -
>> +		((pf->bus->number << 8) + pf->devfn + pf->sriov->offset)) /
>> +	       pf->sriov->stride;
>> +}
>> +EXPORT_SYMBOL_GPL(pci_iov_vf_id);
>> +
>>   /*
>>    * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
>>    * change when NumVFs changes.
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index cd8aa6fce204..2337512e67f0 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -2153,7 +2153,7 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
>>   #ifdef CONFIG_PCI_IOV
>>   int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
>>   int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
>> -
>> +int pci_iov_vf_id(struct pci_dev *dev);
>>   int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
>>   void pci_disable_sriov(struct pci_dev *dev);
>>   
>> @@ -2181,6 +2181,12 @@ static inline int pci_iov_virtfn_devfn(struct pci_dev *dev, int id)
>>   {
>>   	return -ENOSYS;
>>   }
>> +
>> +static inline int pci_iov_vf_id(struct pci_dev *dev)
>> +{
>> +	return -ENOSYS;
>> +}
>> +
>>   static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
>>   { return -ENODEV; }
>>   
>> -- 
>> 2.18.1
>>

