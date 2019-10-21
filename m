Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3F8DEF1E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfJUOQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:16:01 -0400
Received: from mail-eopbgr690086.outbound.protection.outlook.com ([40.107.69.86]:23523
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728551AbfJUOP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 10:15:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTo6Infd3CXDeysucGi7sU6dNYYv+PjU3vunbYK0zgflC88hYtMisAoQ0ysEdJ1fSZIr3Agu8Mo+4kvk9lpkDq3N2g+YzkXLT8OGF97dVifKAu6SJHe6gVmXWXPUFm69TYYFjPilWQKPB7Zp7Nuu27ADviq2buGWqY85fs25vY+do+Pb2iy8z0RIl4OVvZzupIslFy0zphe7BfJE2wbXt5OjWLap/5BqXr85cXdV8D/4c79KBur6511W5n+yVylrIQmt4CSkd+Oe6JB5xkBNNKTArEBJRgkSOkAYPY94iNeWXlF8eap6PeWAdW1w9/2EIWuXJax5WC1E6lyxM4TPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTtI2AgSGAyBr7yiugDE7l54HJqEHszXaHLRsfY7aN0=;
 b=n0CYA6Y+dgF0Y51mZTB257JWqp+zdiitEqLIvEDjrsvzw0y5NLHkBMInW85szUBKxP99tdcff44f/M4QnETAiL5SRohJhnT70/BbO6xRFLA05lvSesLiCQEJmaGQffWsNHIxzkBnUGo/6qri2BxyqRqtLv+TuBgJSZSc8w0oqy6/q7xhT+eOMwXiZAj5wYgmTrQHoKOI7lQ6cBVTsoCGEz8spYytRT7Oid9d5nUyPhSd5wr7NAQ8c8xGNMuplNWvad6R1y/ftDuXRxhktY7dfDkWiqU072P80w/uSipRcKRwBTqsyeHzjc83MKKtl6srRkYY9wv5wjo0FlgHVmEhBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTtI2AgSGAyBr7yiugDE7l54HJqEHszXaHLRsfY7aN0=;
 b=tKaxAoJhdKpxmxSCQgLZkcsKn+biq8xuxUBabGd+l4Tnw+IUUMiq5g8roC38sVYGqx6L61znNvj0XNWPc2PQ+fbqRmfSw7ovI10EGl7J4SH5LTaunZMggOK/TFKHIrQjqqO5Gw0KXLLHaI8yg904P2AO0uRh5a/fpr4fge4avnc=
Received: from SN6PR02CA0016.namprd02.prod.outlook.com (2603:10b6:805:a2::29)
 by CH2PR02MB6661.namprd02.prod.outlook.com (2603:10b6:610:7c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2367.24; Mon, 21 Oct
 2019 14:15:56 +0000
Received: from SN1NAM02FT030.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::203) by SN6PR02CA0016.outlook.office365.com
 (2603:10b6:805:a2::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2367.21 via Frontend
 Transport; Mon, 21 Oct 2019 14:15:56 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT030.mail.protection.outlook.com (10.152.72.114) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2367.14
 via Frontend Transport; Mon, 21 Oct 2019 14:15:55 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iMYTT-0006KF-3t; Mon, 21 Oct 2019 07:15:55 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iMYTO-0006RU-3c; Mon, 21 Oct 2019 07:15:50 -0700
Received: from xsj-pvapsmtp01 (maildrop.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x9LEFms3016333;
        Mon, 21 Oct 2019 07:15:49 -0700
Received: from [172.30.17.123]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1iMYTM-0006Qp-Nh; Mon, 21 Oct 2019 07:15:48 -0700
Subject: Re: [PATCH v2 net-next] net: axienet: In kconfig add ARM64 as
 supported platform
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     michal.simek@xilinx.com, anirudha.sarangi@xilinx.com,
        john.linn@xilinx.com, mchehab+samsung@kernel.org,
        gregkh@linuxfoundation.org, nicolas.ferre@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1571653110-20505-1-git-send-email-radhey.shyam.pandey@xilinx.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <cbdd6608-804a-086c-1892-1903ec4a7d80@xilinx.com>
Date:   Mon, 21 Oct 2019 16:15:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1571653110-20505-1-git-send-email-radhey.shyam.pandey@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(396003)(39850400004)(199004)(189003)(305945005)(6246003)(4326008)(23676004)(2486003)(230700001)(47776003)(76176011)(36386004)(58126008)(316002)(36756003)(229853002)(106002)(2906002)(9786002)(50466002)(81156014)(31696002)(478600001)(8676002)(81166006)(8936002)(446003)(6666004)(356004)(5660300002)(31686004)(26005)(336012)(2616005)(44832011)(65956001)(486006)(65806001)(70206006)(426003)(70586007)(126002)(11346002)(476003)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6661;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8dc608b8-a8cf-4951-3103-08d756313013
X-MS-TrafficTypeDiagnostic: CH2PR02MB6661:
X-Microsoft-Antispam-PRVS: <CH2PR02MB666109E2F97B47E1D22F5370C6690@CH2PR02MB6661.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-Forefront-PRVS: 0197AFBD92
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +KLVnFws6PMKBTojAm2CaIKPbpPNuiNpTTFZ9cWledxGvt1ELhOxdEb23KEGRgLhbVhXHax1ziuyEj9KYOMwPHVq2guDGmtiChLNmXtgcLHJQjyZvdawypyE5kYIO32dVppozrORmmb5XL9DjIaeENTPEnLPobfse3zbQyLrgyNJK6yLyJrg5VlE3+wC+pMREYi7uBdSRitTMRuxS5/eFIzcQOi7dP3ncw5avUgMrNuePSQXM4CRtQFEXo3AjqJbIBNrLkmCnRhdoOIb6Jnb8POad34M09VUd3dwoI9Acd0UHpD37QaKY5mS1U5IPxbfjBeyQ8F00qFFEbCDpbiXWvq0tLoqnySR+z2Cpw3gS3gVxHWoEDGakw/fb9ptc1zvhL68Ue26oEQ7rVQVFYZzEkAk/4iqVphbFv/MO59oPrSp1tWimYArEnYgh+4tAuGh
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2019 14:15:55.5023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dc608b8-a8cf-4951-3103-08d756313013
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21. 10. 19 12:18, Radhey Shyam Pandey wrote:
> xilinx axi_emac driver is supported on ZynqMP UltraScale platform.
> So enable ARCH64 in kconfig. It also removes redundant ARCH_ZYNQ
> dependency. Basic sanity testing is done on zu+ mpsoc zcu102
> evaluation board.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> ---
> Changes for v2:
> Remove redundant ARCH_ZYNQ dependency.
> Modified commit description.
> ---
>  drivers/net/ethernet/xilinx/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
> index 8d994ce..da11876 100644
> --- a/drivers/net/ethernet/xilinx/Kconfig
> +++ b/drivers/net/ethernet/xilinx/Kconfig
> @@ -6,7 +6,7 @@
>  config NET_VENDOR_XILINX
>  	bool "Xilinx devices"
>  	default y
> -	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || ARM || COMPILE_TEST
> +	depends on PPC || PPC32 || MICROBLAZE || MIPS || X86 || ARM || ARM64 || COMPILE_TEST
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

Acked-by: Michal Simek <michal.simek@xilinx.com>

But I can image that others could prefer to remove all dependencies.

Thanks,
Michal
