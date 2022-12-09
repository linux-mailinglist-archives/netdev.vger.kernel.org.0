Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFA864891C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 20:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiLITkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 14:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiLITkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 14:40:22 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2091.outbound.protection.outlook.com [40.107.6.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2037ACB18;
        Fri,  9 Dec 2022 11:40:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=la0Pp8WmFPe3jlzalAlVP+vMHRXD7SDmfuTQNedkNiax6jvWyZVz1j/C8YDM9mT+P9r8aP+5x7R3bM9i24qbHugGL3s6Dpzm1cOnFLyHwVPGgOvnTx+NVE2JiMtuQ1sHefJRTLpfvyZVej0abRziq4SGJE3pUl1XCzE3WX6REGujo72FaTpAdfyKYuQRx1A87UtCY4sa3LbzHjoSKsaG6hF442LXpppYdqC6nH7o0hVFPUkPcgT9iJX+Pl+Pum3CgEdV6JMFwC92pJIrDv6QOZp+xUkcQxn2I7LIL7k0jTT1MirPsHbkiwq+zUHjbRlqUn7aG7xFjN5Q+b0i88BMxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQdzigHh+RF1qCIYEDP63Xg2jQeoZp8hj3DRS1t75Os=;
 b=Dy4k2yhenNagwsz90NCPlFmiP+Dt+ajnXpn8qK+T3sEcRABjLD6D5QzlacqaUeeIcb0vmVzFaE44Fyyd5DM2K9VSi62Ax8x28xhKA0VJBCg6CLdoWhqVGP2ra+9ii1jes+9h/ve5j0WYgPMAPU+XY/8o15YinEd0+iHlqDhrO4dCE3k3yR+V/tIYHMGXg/0rQlFWvfvy0Db99NwK8KzOqpx6+Oy9vJ4Y2y6O7XakCG4lTKcDbzVu3DybLINNItbmWxMkTkyqFAjT7Luc36Td8c4K7Y7wOOOWkhiDE3V9HjgtVPAJAZabI5DJx1JxmfXhb8YarOIAf06/RqKHNQXSjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arri.de;
 dmarc=none action=none header.from=arri.de; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQdzigHh+RF1qCIYEDP63Xg2jQeoZp8hj3DRS1t75Os=;
 b=Jyvch477YDUhRukqide9ym16VwhJYYH6uXCEvWWhCqIerTt5RtbOKu49NQ6L+lx4leXJmgbWr0HFkj5kIrwO8vqpmDZvZSrRgUCh3DJyDrR5ZgKDO5NCTX0qh3r9E6rV50tf/cbOwOOFl/CFtL2secfrQ00QEn499sLASP8JYSo=
Received: from FR0P281CA0132.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:97::14)
 by AS8PR07MB8219.eurprd07.prod.outlook.com (2603:10a6:20b:376::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Fri, 9 Dec
 2022 19:40:13 +0000
Received: from VI1EUR02FT005.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:d10:97:cafe::72) by FR0P281CA0132.outlook.office365.com
 (2603:10a6:d10:97::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.5 via Frontend
 Transport; Fri, 9 Dec 2022 19:40:12 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 VI1EUR02FT005.mail.protection.outlook.com (10.13.60.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.17 via Frontend Transport; Fri, 9 Dec 2022 19:40:12 +0000
Received: from n95hx1g2.localnet (192.168.54.11) by mta.arri.de (10.10.18.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 9 Dec
 2022 20:40:11 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: Re: [Patch net-next v3 05/13] net: dsa: microchip: ptp: enable interrupt for timestamping
Date:   Fri, 9 Dec 2022 20:40:11 +0100
Message-ID: <5904188.lOV4Wx5bFT@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20221209072437.18373-6-arun.ramadoss@microchip.com>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com> <20221209072437.18373-6-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.11]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR02FT005:EE_|AS8PR07MB8219:EE_
X-MS-Office365-Filtering-Correlation-Id: 32317635-ff9b-47d2-87af-08dada1d3069
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XYtXeypI7hCbxlsMYFdRDaiWWx/4Z3mEoUpY3pveaxFVGaGFfWBIGHvXXZ5NDCO5BQ6Jxmg1fy/JF23yjLUzB0gnIvoq/JFmtqZND9EiqBRZx29QBdOI6NRxtu58lJeh2qRQDyEoUouZu7rC+bI86xEfme96Rh/cUyDL4vu4JVTDfxRPwFSOhpyYx3qO2uYcDOnPZFh7zeDy76MIC8mmrYQyYc3A3Il5Oiq9UmpMfHDKcbhG6lFDiMWHKIi11IuJvt87E9Ppa8JfFTEY6+ZBwGVrN4MzVv1ZX3ds7e3qbSl0X/cwdRa5IoPhi6NRwpieTAdGGFUYDhp9YF0GXcsY1sUAogoQqbiWepqgt7amAzhyqliScFpy3dq0g92DznsibsMVnPB4OhqS0ooQArXBvbxJ8iZmG9aFZH3Q4kyoAYparfgADWpRzMu0luF8f/qqZmpvSB3elG386+eq4wpFSp6/jtdR4HmTbIob/7nkryarVj46UJbyN4ZEZhk7EckC4Nvu+MTtvwowdebIeM7GjppTmitjIQ2WDmyXomuCfsbm4GUElHYqx4lILYHHjEKd8TFX8lR/1Pua46g7FzYlzb7sgZQYV9BroJQSCN8i0t2fKQhDt1ontAqRiMISQC/wFoX2kKPjkq7WyMpFqR5hUO6TimOEYKlxSJrKrUZTmT+94T98hXEQXiFEYWojEY43oOdu8QsjcxPZwf8RZfumMOwHU6z0idwG91ZtZyDchdIdN6lWciFTf627vS0/U9Bm
X-Forefront-Antispam-Report: CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199015)(46966006)(36840700001)(2906002)(33716001)(966005)(36860700001)(36916002)(82740400003)(478600001)(9576002)(70586007)(70206006)(8676002)(4326008)(8936002)(41300700001)(86362001)(54906003)(110136005)(40480700001)(356005)(81166007)(5660300002)(7416002)(316002)(30864003)(16526019)(186003)(83380400001)(82310400005)(336012)(426003)(47076005)(26005)(9686003)(39026012)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 19:40:12.7006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32317635-ff9b-47d2-87af-08dada1d3069
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR02FT005.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR07MB8219
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

On Friday, 9 December 2022, 08:24:29 CET, Arun Ramadoss wrote:
> PTP Interrupt mask and status register differ from the global and port
> interrupt mechanism by two methods. One is that for global/port
> interrupt enabling we have to clear the bit but for ptp interrupt we
> have to set the bit. And other is bit12:0 is reserved in ptp interrupt
> registers. This forced to not use the generic implementation of
> global/port interrupt method routine. This patch implement the ptp
> interrupt mechanism to read the timestamp register for sync, pdelay_req
> and pdelay_resp.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> 
> ---
> RFC v2 -> Patch v1
> - Moved the acking of interrupts before calling the handle_nested_irq to
>   avoid race condition between deferred xmit and Irq threads
> ---
>  drivers/net/dsa/microchip/ksz_common.c  |  15 +-
>  drivers/net/dsa/microchip/ksz_common.h  |  11 ++
>  drivers/net/dsa/microchip/ksz_ptp.c     | 200 ++++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_ptp.h     |   9 ++
>  drivers/net/dsa/microchip/ksz_ptp_reg.h |  19 +++
>  5 files changed, 252 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 81da650b70fb..1611f8f5cd6c 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -2101,13 +2101,17 @@ static int ksz_setup(struct dsa_switch *ds)
>  			ret = ksz_pirq_setup(dev, dp->index);
>  			if (ret)
>  				goto out_girq;
> +
> +			ret = ksz_ptp_irq_setup(ds, dp->index);
> +			if (ret)
> +				goto out_pirq;
>  		}
>  	}
>  
>  	ret = ksz_ptp_clock_register(ds);
>  	if (ret) {
>  		dev_err(dev->dev, "Failed to register PTP clock: %d\n", ret);
> -		goto out_pirq;
> +		goto out_ptpirq;
>  	}
>  
>  	ret = ksz_mdio_register(dev);
> @@ -2124,6 +2128,10 @@ static int ksz_setup(struct dsa_switch *ds)
>  
>  out_ptp_clock_unregister:
>  	ksz_ptp_clock_unregister(ds);
> +out_ptpirq:
> +	if (dev->irq > 0)
> +		dsa_switch_for_each_user_port(dp, dev->ds)
> +			ksz_ptp_irq_free(ds, dp->index);
>  out_pirq:
>  	if (dev->irq > 0)
>  		dsa_switch_for_each_user_port(dp, dev->ds)
> @@ -2143,8 +2151,11 @@ static void ksz_teardown(struct dsa_switch *ds)
>  	ksz_ptp_clock_unregister(ds);
>  
>  	if (dev->irq > 0) {
> -		dsa_switch_for_each_user_port(dp, dev->ds)
> +		dsa_switch_for_each_user_port(dp, dev->ds) {
> +			ksz_ptp_irq_free(ds, dp->index);
> +
>  			ksz_irq_free(&dev->ports[dp->index].pirq);
> +		}
>  
>  		ksz_irq_free(&dev->girq);
>  	}
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 641aca78ef05..918028db2e6f 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -20,6 +20,7 @@
>  #define KSZ_MAX_NUM_PORTS 8
>  
>  struct ksz_device;
> +struct ksz_port;
>  
>  struct vlan_table {
>  	u32 table[3];
> @@ -83,6 +84,13 @@ struct ksz_irq {
>  	struct ksz_device *dev;
>  };
>  
> +struct ksz_ptp_irq {
> +	struct ksz_port *port;
> +	u16 ts_reg;
> +	char name[16];
> +	int irq_num;
> +};
> +
>  struct ksz_port {
>  	bool remove_tag;		/* Remove Tag flag set, for ksz8795 only */
>  	bool learning;
> @@ -106,6 +114,8 @@ struct ksz_port {
>  	struct hwtstamp_config tstamp_config;
>  	bool hwts_tx_en;
>  	bool hwts_rx_en;
> +	struct ksz_irq ptpirq;
> +	struct ksz_ptp_irq ptpmsg_irq[3];
>  #endif
>  };
>  
> @@ -612,6 +622,7 @@ static inline int is_lan937x(struct ksz_device *dev)
>  #define REG_PORT_INT_MASK		0x001F
>  
>  #define PORT_SRC_PHY_INT		1
> +#define PORT_SRC_PTP_INT		2
>  
>  #define KSZ8795_HUGE_PACKET_SIZE	2000
>  #define KSZ8863_HUGE_PACKET_SIZE	1916
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
> index b864b88dc6f9..a7b015ac2734 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.c
> +++ b/drivers/net/dsa/microchip/ksz_ptp.c
> @@ -6,6 +6,8 @@
>   */
>  
>  #include <linux/dsa/ksz_common.h>
> +#include <linux/irq.h>
> +#include <linux/irqdomain.h>
>  #include <linux/kernel.h>
>  #include <linux/ptp_classify.h>
>  #include <linux/ptp_clock_kernel.h>
> @@ -25,6 +27,8 @@
>  #define KSZ_PTP_INC_NS 40  /* HW clock is incremented every 40 ns (by 40) */
>  #define KSZ_PTP_SUBNS_BITS 32
>  
> +#define KSZ_PTP_INT_START 13
> +
>  static int ksz_ptp_enable_mode(struct ksz_device *dev)
>  {
>  	struct ksz_tagger_data *tagger_data = ksz_tagger_data(dev->ds);
> @@ -415,6 +419,202 @@ void ksz_ptp_clock_unregister(struct dsa_switch *ds)
>  		ptp_clock_unregister(ptp_data->clock);
>  }
>  
> +static irqreturn_t ksz_ptp_msg_thread_fn(int irq, void *dev_id)
> +{
> +	return IRQ_NONE;
> +}
> +
> +static irqreturn_t ksz_ptp_irq_thread_fn(int irq, void *dev_id)
> +{
> +	struct ksz_irq *ptpirq = dev_id;
> +	unsigned int nhandled = 0;
> +	struct ksz_device *dev;
> +	unsigned int sub_irq;
> +	u16 data;
> +	int ret;
> +	u8 n;
> +
> +	dev = ptpirq->dev;
> +
> +	ret = ksz_read16(dev, ptpirq->reg_status, &data);
> +	if (ret)
> +		goto out;
> +
> +	/* Clear the interrupts W1C */
> +	ret = ksz_write16(dev, ptpirq->reg_status, data);
> +	if (ret)
> +		return IRQ_NONE;
> +
> +	for (n = 0; n < ptpirq->nirqs; ++n) {
> +		if (data & BIT(n + KSZ_PTP_INT_START)) {
> +			sub_irq = irq_find_mapping(ptpirq->domain, n);
> +			handle_nested_irq(sub_irq);
> +			++nhandled;
> +		}
> +	}
> +
> +out:
> +	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
> +}
> +
> +static void ksz_ptp_irq_mask(struct irq_data *d)
> +{
> +	struct ksz_irq *kirq = irq_data_get_irq_chip_data(d);
> +
> +	kirq->masked &= ~BIT(d->hwirq + KSZ_PTP_INT_START);
> +}
> +
> +static void ksz_ptp_irq_unmask(struct irq_data *d)
> +{
> +	struct ksz_irq *kirq = irq_data_get_irq_chip_data(d);
> +
> +	kirq->masked |= BIT(d->hwirq + KSZ_PTP_INT_START);
> +}
> +
> +static void ksz_ptp_irq_bus_lock(struct irq_data *d)
> +{
> +	struct ksz_irq *kirq  = irq_data_get_irq_chip_data(d);
> +
> +	mutex_lock(&kirq->dev->lock_irq);
> +}
> +
> +static void ksz_ptp_irq_bus_sync_unlock(struct irq_data *d)
> +{
> +	struct ksz_irq *kirq  = irq_data_get_irq_chip_data(d);
> +	struct ksz_device *dev = kirq->dev;
> +	int ret;
> +
> +	ret = ksz_write16(dev, kirq->reg_mask, kirq->masked);
> +	if (ret)
> +		dev_err(dev->dev, "failed to change IRQ mask\n");
> +
> +	mutex_unlock(&dev->lock_irq);
> +}
> +
> +static const struct irq_chip ksz_ptp_irq_chip = {
> +	.name			= "ksz-irq",
> +	.irq_mask		= ksz_ptp_irq_mask,
> +	.irq_unmask		= ksz_ptp_irq_unmask,
> +	.irq_bus_lock		= ksz_ptp_irq_bus_lock,
> +	.irq_bus_sync_unlock	= ksz_ptp_irq_bus_sync_unlock,
> +};
> +
> +static int ksz_ptp_irq_domain_map(struct irq_domain *d,
> +				  unsigned int irq, irq_hw_number_t hwirq)
> +{
> +	irq_set_chip_data(irq, d->host_data);
> +	irq_set_chip_and_handler(irq, &ksz_ptp_irq_chip, handle_level_irq);
> +	irq_set_noprobe(irq);
> +
> +	return 0;
> +}
> +
> +static const struct irq_domain_ops ksz_ptp_irq_domain_ops = {
> +	.map	= ksz_ptp_irq_domain_map,
> +	.xlate	= irq_domain_xlate_twocell,
> +};
> +
> +static int ksz_ptp_msg_irq_setup(struct ksz_port *port)
> +{
> +	u16 ts_reg[] = {REG_PTP_PORT_PDRESP_TS, REG_PTP_PORT_XDELAY_TS,
> +			REG_PTP_PORT_SYNC_TS};
> +	struct ksz_device *dev = port->ksz_dev;
> +	struct ksz_irq *ptpirq = &port->ptpirq;
> +	struct ksz_ptp_irq *ptpmsg_irq;
> +	int ret;
> +	u8 n;
> +
> +	for (n = 0; n < ptpirq->nirqs; n++) {
> +		ptpmsg_irq = &port->ptpmsg_irq[n];
> +
> +		ptpmsg_irq->port = port;
> +		ptpmsg_irq->ts_reg = dev->dev_ops->get_port_addr(port->num,
> +								 ts_reg[n]);
> +		ptpmsg_irq->irq_num = irq_create_mapping(ptpirq->domain, n);
> +		if (ptpmsg_irq->irq_num < 0) {
> +			ret = ptpmsg_irq->irq_num;
> +			goto out;
> +		}
> +
> +		snprintf(ptpmsg_irq->name, sizeof(ptpmsg_irq->name),
> +			 "PTP-MSG-%d", n);
> +
> +		ret = request_threaded_irq(ptpmsg_irq->irq_num, NULL,
> +					   ksz_ptp_msg_thread_fn,
> +					   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,

I assume that IRQF_TRIGGER_FALLING is not required here as nested interrupts are fired by 
software (withing having an edge / a level).  Additionally I had to remove all existing
occurrences of this flag in ksz_common.c in order to rid of persistent "timed out while
polling for tx timestamp" messages which appeared randomly after some time of operation.
I think that on i.MX6 I need to use level triggered interrupts instead of edge triggered
ones.  Additionally I think that such flags should be set in the device tree instead of
the driver:

https://stackoverflow.com/a/40051191


> +					   ptpmsg_irq->name, ptpmsg_irq);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	return 0;
> +
> +out:
> +	while (n--)
> +		irq_dispose_mapping(port->ptpmsg_irq[n].irq_num);
> +
> +	return ret;
> +}
> +
> +int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	const struct ksz_dev_ops *ops = dev->dev_ops;
> +	struct ksz_port *port = &dev->ports[p];
> +	struct ksz_irq *ptpirq = &port->ptpirq;
> +	int ret;
> +
> +	ptpirq->dev = dev;
> +	ptpirq->masked = 0;
> +	ptpirq->nirqs = 3;
> +	ptpirq->reg_mask = ops->get_port_addr(p, REG_PTP_PORT_TX_INT_ENABLE__2);
> +	ptpirq->reg_status = ops->get_port_addr(p,
> +						REG_PTP_PORT_TX_INT_STATUS__2);
> +	snprintf(ptpirq->name, sizeof(ptpirq->name), "ptp_irq-%d", p);
> +
> +	ptpirq->irq_num = irq_find_mapping(port->pirq.domain, PORT_SRC_PTP_INT);
> +	if (ptpirq->irq_num < 0)
> +		return ptpirq->irq_num;
> +
> +	ptpirq->domain = irq_domain_add_simple(dev->dev->of_node, ptpirq->nirqs,
> +					       0, &ksz_ptp_irq_domain_ops,
> +					       ptpirq);
> +	if (!ptpirq->domain)
> +		return -ENOMEM;
> +
> +	ret = request_threaded_irq(ptpirq->irq_num, NULL, ksz_ptp_irq_thread_fn,
> +				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
> +				   ptpirq->name, ptpirq);
> +	if (ret)
> +		goto out;
> +
> +	ret = ksz_ptp_msg_irq_setup(port);
> +	if (ret)
> +		goto out;
> +
> +	return 0;
> +
> +out:
> +	irq_dispose_mapping(ptpirq->irq_num);
> +
> +	return ret;
> +}
> +
> +void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_port *port = &dev->ports[p];
> +	struct ksz_irq *ptpirq = &port->ptpirq;
> +	u8 n;
> +
> +	free_irq(ptpirq->irq_num, ptpirq);
> +
> +	for (n = 0; n < ptpirq->nirqs; n++)
> +		irq_dispose_mapping(port->ptpmsg_irq[n].irq_num);
> +
> +	irq_domain_remove(ptpirq->domain);
> +}
> +
>  MODULE_AUTHOR("Christian Eggers <ceggers@arri.de>");
>  MODULE_AUTHOR("Arun Ramadoss <arun.ramadoss@microchip.com>");
>  MODULE_DESCRIPTION("PTP support for KSZ switch");
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
> index 2c29a0b604bb..7c5679372705 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.h
> +++ b/drivers/net/dsa/microchip/ksz_ptp.h
> @@ -30,6 +30,8 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port,
>  		    struct ethtool_ts_info *ts);
>  int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
>  int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
> +int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p);
> +void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p);
>  
>  #else
>  
> @@ -45,6 +47,13 @@ static inline int ksz_ptp_clock_register(struct dsa_switch *ds)
>  
>  static inline void ksz_ptp_clock_unregister(struct dsa_switch *ds) { }
>  
> +static inline int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
> +{
> +	return 0;
> +}
> +
> +static inline void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p) {}
> +
>  #define ksz_get_ts_info NULL
>  
>  #define ksz_hwtstamp_get NULL
> diff --git a/drivers/net/dsa/microchip/ksz_ptp_reg.h b/drivers/net/dsa/microchip/ksz_ptp_reg.h
> index 4ca4ad4bba7e..abe95bbefc12 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp_reg.h
> +++ b/drivers/net/dsa/microchip/ksz_ptp_reg.h
> @@ -49,4 +49,23 @@
>  #define PTP_MASTER			BIT(1)
>  #define PTP_1STEP			BIT(0)
>  
> +/* Port PTP Register */
> +#define REG_PTP_PORT_RX_DELAY__2	0x0C00
> +#define REG_PTP_PORT_TX_DELAY__2	0x0C02
> +#define REG_PTP_PORT_ASYM_DELAY__2	0x0C04
> +
> +#define REG_PTP_PORT_XDELAY_TS		0x0C08
> +#define REG_PTP_PORT_SYNC_TS		0x0C0C
> +#define REG_PTP_PORT_PDRESP_TS		0x0C10
> +
> +#define REG_PTP_PORT_TX_INT_STATUS__2	0x0C14
> +#define REG_PTP_PORT_TX_INT_ENABLE__2	0x0C16
> +
> +#define PTP_PORT_SYNC_INT		BIT(15)
> +#define PTP_PORT_XDELAY_REQ_INT		BIT(14)
> +#define PTP_PORT_PDELAY_RESP_INT	BIT(13)
> +#define KSZ_SYNC_MSG			2
> +#define KSZ_XDREQ_MSG			1
> +#define KSZ_PDRES_MSG			0
> +
>  #endif
> 




