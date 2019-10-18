Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68824DBF6F
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 10:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504919AbfJRIIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 04:08:04 -0400
Received: from mail-eopbgr730083.outbound.protection.outlook.com ([40.107.73.83]:27820
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391374AbfJRIIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 04:08:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdeeqVcEF2HmZB6padbz9/Lbu+13RLmrwg4irEjnVt0pnwH3hJOpVVZeT9tX/gQBl+RZRC9mbufEoEVqBcQX4g8bi6QQ/qypM3dly7Mrf53q3ro3e4UFVLJEPpCpJZMzqQSjl7JW2jicg3JfabqSKzrAYTVPU573UB0xVlcSxrIawlrPksXcOTYXIzmWnt+mCBHqLW7Ke3KqBpW87YPTBtyIiBXcc54kXpcr1Yw89ZnT8qbPcKwpIvadSCJcZps9HQRXQBmc52kY9+6eRyI+46GDit+q74kCAokLWe1aq/hVXcpHGeAhadJIhtfqywNnyn1+59lhInhpnnLjnCV1Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPZbVR1+0g24dXFjPgttoII5bqlwh3+NG8UyiP13LUM=;
 b=Gh4BDv3lWhvml5YXCCodyups+ajsS/4+Mol36X/hz7W3cXe1xL5BeW0to6KKfeV9bZcJ3mUJrdUMob3QSCelFIyWSpe1M1voeH/GCy45E2aIFQ0dBmmNJlQfobGogF2SZe5IXkidSZhFR1oNhlU5JaDABDx5rJ3qN1meVA5lBocREIPgSzk02wkWt+AVfJLc0gAw8w7pPH8kamZyUvvpKRZfyqSkSP+VDacSBsHvS/cbcLhdBvniI3PQT3gIUom1FPKYTKcs8fQuoSA5I4OKmk0vZKUxQHMHotH8jRPQdawfl0zJFkInRr5/tD9aMXfamtBrIuu7ey8mFweFCcIvug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPZbVR1+0g24dXFjPgttoII5bqlwh3+NG8UyiP13LUM=;
 b=V9Lby2RlhnxwfwSCk2m1+X3yrLXm6F2wK45y6uiScUbxxlR5T3NTYIJcSrllsKEgLcObTuK1z3E2V7X1s8M+95+Tk/MbDgBXFKrgPWzrz3Y2KXaoJgug4Hp0oGY2MSRXiAJ67Gjk3ahpsnSTHyM+XhnnBI4nNQ40HKPrdCTTfLc=
Received: from CY4PR02CA0023.namprd02.prod.outlook.com (2603:10b6:903:18::33)
 by SN6PR02MB3967.namprd02.prod.outlook.com (2603:10b6:805:2b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.19; Fri, 18 Oct
 2019 08:08:01 +0000
Received: from SN1NAM02FT038.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::202) by CY4PR02CA0023.outlook.office365.com
 (2603:10b6:903:18::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.16 via Frontend
 Transport; Fri, 18 Oct 2019 08:08:01 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT038.mail.protection.outlook.com (10.152.72.69) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2367.14
 via Frontend Transport; Fri, 18 Oct 2019 08:08:00 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iLNIm-0000mD-5W; Fri, 18 Oct 2019 01:08:00 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iLNIh-0007n6-1Z; Fri, 18 Oct 2019 01:07:55 -0700
Received: from xsj-pvapsmtp01 (xsj-pvapsmtp01.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x9I87jHK015921;
        Fri, 18 Oct 2019 01:07:45 -0700
Received: from [172.30.17.123]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1iLNIX-0007lR-1F; Fri, 18 Oct 2019 01:07:45 -0700
Subject: Re: [PATCH net-next] net: axienet: In kconfig add ARM64 as supported
 platform
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     michal.simek@xilinx.com, anirudha.sarangi@xilinx.com,
        john.linn@xilinx.com, mchehab+samsung@kernel.org,
        gregkh@linuxfoundation.org, nicolas.ferre@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1571381686-13045-1-git-send-email-radhey.shyam.pandey@xilinx.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <eb41070c-8393-ec4e-f9c9-f16d082fbe1c@xilinx.com>
Date:   Fri, 18 Oct 2019 10:07:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1571381686-13045-1-git-send-email-radhey.shyam.pandey@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(136003)(376002)(199004)(189003)(70586007)(4326008)(50466002)(47776003)(8676002)(31696002)(70206006)(65806001)(81166006)(65956001)(5660300002)(36756003)(9786002)(81156014)(8936002)(478600001)(316002)(2616005)(44832011)(336012)(6666004)(126002)(31686004)(36386004)(6246003)(106002)(476003)(305945005)(356004)(11346002)(186003)(2906002)(230700001)(26005)(229853002)(58126008)(23676004)(426003)(446003)(2486003)(486006)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB3967;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8695f6cb-5ce8-4317-992d-08d753a24b24
X-MS-TrafficTypeDiagnostic: SN6PR02MB3967:
X-Microsoft-Antispam-PRVS: <SN6PR02MB3967687650A478FA792C61DDC66C0@SN6PR02MB3967.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 01949FE337
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yrmu1g9Ryw0QdQdi9axOai5Qc01deVTtjRdGhUnkF/7ThbC+Rqhdi0fIvZbzBq20c+TGLObf8tHBaeh0ApokRt4ZbBUxjMOaO4xtbXr8MQK0z683pZWhDHbaQknaAPtfGKARG3EVx1p4nr8xEwasA6tYFejslzafBxMpSLHcXwOsjgzZ6mSth8Sw9QAEdO7g5yjjxlw7VP0hfK3Pqxo/A1OQJH+p2YrQRVYHoCbL8cZ3lVyk41zIbyQbcZESxB7QVvfOc4ICR1TJrV7fviLAAqXwbQ7FAkKNQ1AeDJVULcAv2LeWJV1mqzPAfJNx9vrKKkavZJa+aLPuPpuHks2vNo97UEEhiT6kuvhNLFxQUm8nW98KJAMq5GOQvBzM3PNtcsiRRucgOXQN5ZOdT/mOY0hlerjJ3JkSzw9Rr/I43tU=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2019 08:08:00.5580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8695f6cb-5ce8-4317-992d-08d753a24b24
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB3967
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18. 10. 19 8:54, Radhey Shyam Pandey wrote:
> xilinx axi_emac driver is supported on ZynqMP UltraScale platform(ARM64).
> So enable it in kconfig. Basic sanity testing is done on zu+ mpsoc zcu102
> evaluation board.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> ---
>  drivers/net/ethernet/xilinx/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
> index 8d994ce..a616bdc 100644
> --- a/drivers/net/ethernet/xilinx/Kconfig
> +++ b/drivers/net/ethernet/xilinx/Kconfig
> @@ -6,7 +6,7 @@
>  config NET_VENDOR_XILINX
>  	bool "Xilinx devices"
>  	default y
> -	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || ARM || COMPILE_TEST
> +	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || ARM || ARM64 || COMPILE_TEST

You can remove ARCH_ZYNQ from this line because ARM is there already.


>  	---help---
>  	  If you have a network (Ethernet) card belonging to this class, say Y.
>  
> @@ -26,11 +26,11 @@ config XILINX_EMACLITE
>  
>  config XILINX_AXI_EMAC
>  	tristate "Xilinx 10/100/1000 AXI Ethernet support"
> -	depends on MICROBLAZE || X86 || ARM || COMPILE_TEST
> +	depends on MICROBLAZE || X86 || ARM || ARM64 || COMPILE_TEST
>  	select PHYLINK
>  	---help---
>  	  This driver supports the 10/100/1000 Ethernet from Xilinx for the
> -	  AXI bus interface used in Xilinx Virtex FPGAs.
> +	  AXI bus interface used in Xilinx Virtex FPGAs and Soc's.
>  
>  config XILINX_LL_TEMAC
>  	tristate "Xilinx LL TEMAC (LocalLink Tri-mode Ethernet MAC) driver"
> 

M
