Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94461162959
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 16:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgBRPYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 10:24:12 -0500
Received: from mail-eopbgr20074.outbound.protection.outlook.com ([40.107.2.74]:31710
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbgBRPYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 10:24:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfRN1N0pQPzgP5Fdn6VBaTlUkljwesv//+b2yH9qRNFLpCtTEy84j8dV2CmXcbcgkDmJvNCOlbF7dIar4UHISb1GMmctLoz4zlRWDIMHWiRG8vMiZvWQ7UCF7Y6iW766CDBCXDfo8hYNt2HZGkPAnik3JvAoESYL07WkFnl7Vxl5h8r3deqQ2H9b+nXejqXXReJe++GBx54mDhvPFPNMhJj6XE2wHdn2g63z3atXixEYTktkG5HneyNYBtTH8tuyoOceAP26k85L2Evp+QJ/Hz6utRVLOJmTQiPYKLSnW5jd2WlrJ0cP6cefYtXXIlFSX1IoZbWzjnSk6XU21gt2mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOVkb87yXurJu/NDHR+/f4K9MwtrB6LX0JSkHaZDOoA=;
 b=ml3h+X/Tx5c2f8IaX6jaoYLgSA5amyXeRrBjSWPiGj7iCPSZQW+x2lUrA/BM+h0gKQNDo5+LB637CYoSqTj8CjT/lZfWFrqmRmmAFqFIoa1VEtsVBEcCjDxt4sr6vRD5/An1aX+ZrPk8XSpzTCFOKRsyaJVqeGnbWXiORWLBBbdyey5Uq/AZ1Wc6CqHte4odx37iori88mb7STJM2Or0roLtfTIL1+3rUE6aq9BEWoJAaxdRbRKTmPrbRce9UP85XSBq/2AXCNHHUDRyJ23o975MZEgL3ufoX2xeWzsy8CP+O3lUXTDS9V23GL19NfrVADgS4c7j7D7umQgT562Vhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOVkb87yXurJu/NDHR+/f4K9MwtrB6LX0JSkHaZDOoA=;
 b=OFFqnTCfRCY4903djiILYQjN6LZugqwrg0tNi/88Nt3bsTatuBZOtYWjvih1omQ1t9+BFaJ01S36WDvVeqe7Kg10HOtHuPBN6obvIH4ArvhPVxUlkbS3zWTOOHrRV6q2hk8wmezWaA9KbdD0ENyXPizMwqwnGYTBBMM7FtVNz6Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=diana.craciun@oss.nxp.com; 
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com (10.172.255.144) by
 VI1PR0402MB2879.eurprd04.prod.outlook.com (10.175.24.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Tue, 18 Feb 2020 15:24:07 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a8ee:1b0f:6b3e:4682]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a8ee:1b0f:6b3e:4682%12]) with mapi id 15.20.2729.032; Tue, 18 Feb
 2020 15:24:06 +0000
Subject: Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Pankaj Bansal (OSS)" <pankaj.bansal@oss.nxp.com>
Cc:     Calvin Johnson <calvin.johnson@nxp.com>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "nleeder@codeaurora.org" <nleeder@codeaurora.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        "jon@solid-run.com" <jon@solid-run.com>,
        Russell King <linux@armlinux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
References: <VI1PR04MB5135D7D8597D33DB76DA05BDB0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
 <615c6807-c018-92c9-b66a-8afdda183699@huawei.com>
 <VI1PR04MB513558BF77192255CBE12102B0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
 <20200218144653.GA4286@e121166-lin.cambridge.arm.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <e566692c-9b2e-ab56-29db-465d3232d50d@oss.nxp.com>
Date:   Tue, 18 Feb 2020 17:24:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200218144653.GA4286@e121166-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM5P189CA0028.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:206:15::41) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
Received: from [10.171.73.123] (212.146.100.6) by AM5P189CA0028.EURP189.PROD.OUTLOOK.COM (2603:10a6:206:15::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.24 via Frontend Transport; Tue, 18 Feb 2020 15:24:04 +0000
X-Originating-IP: [212.146.100.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8aa3dfd3-52de-4151-aa54-08d7b4869801
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2879:|VI1PR0402MB2879:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2879BD20249E814F3FF35DD8BE110@VI1PR0402MB2879.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 031763BCAF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(189003)(199004)(5660300002)(52116002)(54906003)(86362001)(8676002)(4326008)(7416002)(81166006)(81156014)(31696002)(66946007)(110136005)(186003)(8936002)(66556008)(53546011)(16526019)(31686004)(2616005)(66476007)(26005)(956004)(2906002)(6486002)(6636002)(966005)(16576012)(478600001)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2879;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w0HsRxWqJbTuuzZOH9PYA31jCQ2g1WoL4Dzo0FyRpTVq4+5lsZkOo0UXpPkbVn8ixGMrehzOjieRWzk5w1n8dh4cGpoQV1ZvKGIZzhvu9MROKT10xQ9yJ2FnWGzBV0wOhcAF3I23HfRPtJgpCAcyoBnX8I+nwguNUjNYdS5EddNCcqAIiQjES76sjh59EUDq0N0/nGOwJkJlUp0oCkiHWIoGXvJ12ioXbdu2FUyniYSDsGiKvVEzCI5Fpy6dc700n/TQYtoNzSXpoH9YLF4odm1nz5l/Ho50+bJWquIwAiZK4shlgcBcBKdOPZ8SGVh8lmVR+ESR2ctrfpm9Ikxz+FC3gBXq1dlYTlYl8vFd0dLvsO+lZWkvpKExpS2SU/28S7U7BzQPHyurexeIVIZqk+t5TtiXqP0zOvPw7/S5cbE6h6jtW1Dwfy/0HgYpU9pgePrXNJF1Mgzb/OCrbxPipMzAXDz8L4cX4VlmiSPMgnWljOrN0b5pErniIL5FNKrp9ULX4ZkRtHKdhRxOFFmVWA==
X-MS-Exchange-AntiSpam-MessageData: D+3ABepQNKo5212AlTwFc72wwJzqyblz1eRARjqgJv4sJ6QTm2+APQ7ecblzdksds8LWl68sFpPYKhENJFSRLneAvm4cLPjYZO0Faa21BZG1KpOUdJwziPqgRbZ1nCHecHQx1SfJGGXpRRmFVlHo+g==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa3dfd3-52de-4151-aa54-08d7b4869801
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2020 15:24:06.9056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V4+aR5IHZLwljR2xsIlE4rxTz2vkeL7Df3bpRSXfOJukyT6gr+rk/6QgACQuEIfMmTM2CQDVPPLYlF5ajNRTmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2879
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On 2/18/2020 4:46 PM, Lorenzo Pieralisi wrote:
> On Tue, Feb 18, 2020 at 12:48:39PM +0000, Pankaj Bansal (OSS) wrote:
>
> [...]
>
>>>> In DT case, we create the domain DOMAIN_BUS_FSL_MC_MSI for MC bus and
>>> it's children.
>>>> And then when MC child device is created, we search the "msi-parent"
>>> property from the MC
>>>> DT node and get the ITS associated with MC bus. Then we search
>>> DOMAIN_BUS_FSL_MC_MSI
>>>> on that ITS. Once we find the domain, we can call msi_domain_alloc_irqs for
>>> that domain.
>>>> This is exactly what we tried to do initially with ACPI. But the searching
>>> DOMAIN_BUS_FSL_MC_MSI
>>>> associated to an ITS, is something that is part of drivers/acpi/arm64/iort.c.
>>>> (similar to DOMAIN_BUS_PLATFORM_MSI and DOMAIN_BUS_PCI_MSI)
>>> Can you have a look at mbigen driver (drivers/irqchip/irq-mbigen.c) to see if
>>> it helps you?
>>>
>>> mbigen is an irq converter to convert device's wired interrupts into MSI
>>> (connecting to ITS), which will alloc a bunch of MSIs from ITS platform MSI
>>> domain at the setup.
>> Unfortunately this is not the same case as ours. As I see Hisilicon IORT table
>> Is using single id mapping with named components.
>>
>> https://github.com/tianocore/edk2-platforms/blob/master/Silicon/Hisilicon/Hi1616/D05AcpiTables/D05Iort.asl#L300
>>
>> while we are not:
>>
>> https://source.codeaurora.org/external/qoriq/qoriq-components/edk2-platforms/tree/Platform/NXP/LX2160aRdbPkg/AcpiTables/Iort.aslc?h=LX2160_UEFI_ACPI_EAR1#n290
>>
>> This is because as I said, we are trying to represent a bus in IORT
>> via named components and not individual devices connected to that bus.
> I had a thorough look into this and strictly speaking there is no
> *mapping* requirement at all, all you need to know is what ITS the FSL
> MC bus is mapping MSIs to. Which brings me to the next question (which
> is orthogonal to how to model FSL MC in IORT, that has to be discussed
> but I want to have a full picture in mind first).
>
> When you probe the FSL MC as a platform device, the ACPI core,
> through IORT (if you add the 1:1 mapping as an array of single
> mappings) already link the platform device to ITS platform
> device MSI domain (acpi_configure_pmsi_domain()).
>
> The associated fwnode is the *same* (IIUC) as for the
> DOMAIN_BUS_FSL_MC_MSI and ITS DOMAIN_BUS_NEXUS, so in practice
> you don't need IORT code to retrieve the DOMAIN_BUS_FSL_MC_MSI
> domain, the fwnode is the same as the one in the FSL MC platform
> device IRQ domain->fwnode pointer and you can use it to
> retrieve the DOMAIN_BUS_FSL_MC_MSI domain through it.
>
> Is my reading correct ?

Thank you very much for your effort! Really appreciated! Yes, the 
understanding is correct. I have prototyped this idea for DT, see below [1].
So, I get the fwnode from the platform device domain (because they are 
the same with the devices underneath the MC-BUS bridge) and use the 
fwnode to retrieve the MC-BUS domain.

>
> Overall, DOMAIN_BUS_FSL_MC_MSI is just an MSI layer to override the
> provide the MSI domain ->prepare hook (ie to stash the MC device id), no
> more (ie its_fsl_mc_msi_prepare()).
>
> That's it for the MSI layer - I need to figure out whether we *want* to
> extend IORT (and/or ACPI) to defined bindings for "additional busses",
> what I write above is a summary of my understanding, I have not made my
> mind up yet.
>
> As for the IOMMU code, it seems like the only thing needed is
> extending named components configuration to child devices,
> hierarchically.

Laurentiu used a similar approach for DMA configuration (again 
prototyped for DT). [2]
It involves wiring up a custom .dma_configure for our devices as anyway, 
it made little sense to pretend that these devices are platform devices 
and trick the DT or ACPI layers into that. As a nice side effect, this 
will allow to get rid of our existing hooks in the DT generic code.

>
> As Marc already mentioned, IOMMU and IRQ code must be separate for
> future postings but first we need to find a suitable answer to
> the problem at hand.
>
> Lorenzo
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

[1] MSI configuration

  drivers/bus/fsl-mc/fsl-mc-msi.c | 11 +++++++++--
  1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-msi.c 
b/drivers/bus/fsl-mc/fsl-mc-msi.c
index 8b9c66d7c4ff..674f5a60109b 100644
--- a/drivers/bus/fsl-mc/fsl-mc-msi.c
+++ b/drivers/bus/fsl-mc/fsl-mc-msi.c
@@ -182,16 +182,23 @@ int fsl_mc_find_msi_domain(struct device 
*mc_platform_dev,
  {
      struct irq_domain *msi_domain;
      struct device_node *mc_of_node = mc_platform_dev->of_node;
+    struct fwnode_handle *fwnode;

-    msi_domain = of_msi_get_domain(mc_platform_dev, mc_of_node,
-                       DOMAIN_BUS_FSL_MC_MSI);
+    msi_domain = dev_get_msi_domain(mc_platform_dev);
      if (!msi_domain) {
          pr_err("Unable to find fsl-mc MSI domain for %pOF\n",
                 mc_of_node);

          return -ENOENT;
      }
+    fwnode = msi_domain->fwnode;
+    msi_domain = irq_find_matching_fwnode(fwnode, DOMAIN_BUS_FSL_MC_MSI);
+    if (!msi_domain) {
+        pr_err("Unable to find fsl-mc MSI domain for %pOF\n",
+              mc_of_node);

+        return -ENOENT;
+    }
      *mc_msi_domain = msi_domain;
      return 0;
  }
-- 
2.17.1



[2] DMA configuration

  drivers/bus/fsl-mc/fsl-mc-bus.c | 42 ++++++++++++++++++++++++++++++++-
  1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c 
b/drivers/bus/fsl-mc/fsl-mc-bus.c
index f9bc9c384ab5..5c6021a13612 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -132,11 +132,51 @@ static int fsl_mc_bus_uevent(struct device *dev, 
struct kobj_uevent_env *env)
  static int fsl_mc_dma_configure(struct device *dev)
  {
      struct device *dma_dev = dev;
+    struct iommu_fwspec *fwspec;
+    const struct iommu_ops *iommu_ops;
+    struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+    int ret;
+    u32 icid;

      while (dev_is_fsl_mc(dma_dev))
          dma_dev = dma_dev->parent;

-    return of_dma_configure(dev, dma_dev->of_node, 0);
+    fwspec = dev_iommu_fwspec_get(dma_dev);
+    if (!fwspec) {
+        dev_err(dev, "%s: null fwspec\n", __func__);
+        return -ENODEV;
+    }
+    iommu_ops = iommu_ops_from_fwnode(fwspec->iommu_fwnode);
+    if (!iommu_ops) {
+        dev_err(dev, "%s: null iommu ops\n", __func__);
+        return -ENODEV;
+    }
+
+    ret = iommu_fwspec_init(dev, fwspec->iommu_fwnode, iommu_ops);
+    if (ret) {
+        dev_err(dev, "%s: iommu_fwspec_init failed with %d\n", 
__func__, ret);
+        return ret;
+    }
+
+    icid = mc_dev->icid;
+    ret = iommu_fwspec_add_ids(dev, &icid, 1);
+    if (ret) {
+        dev_err(dev, "%s: iommu_fwspec_add_ids failed with %d\n", 
__func__, ret);
+        return ret;
+    }
+
+    if (!device_iommu_mapped(dev)) {
+        ret = iommu_probe_device(dev);
+        if (ret) {
+            dev_err(dev, "%s: iommu_fwspec_add_ids failed with %d\n", 
__func__, ret);
+            return ret;
+        }
+    }
+
+    arch_setup_dma_ops(dev, 0, *dma_dev->dma_mask + 1,
+                iommu_ops, true);
+
+    return 0;
  }

  static ssize_t modalias_show(struct device *dev, struct 
device_attribute *attr,
-- 
2.17.1

Regards,
Diana

