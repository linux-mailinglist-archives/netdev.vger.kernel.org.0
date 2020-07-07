Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB851216893
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 10:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgGGIrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 04:47:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43276 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725941AbgGGIrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 04:47:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0678e1pQ017342;
        Tue, 7 Jul 2020 01:47:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=8c5mPkGG7H30YLL+hWMIaNUtKr3dVimKBm6pzrqc0Es=;
 b=yvoJFDIoFDNvAY7UK5NmLn9ZAqLCWAYEQ/IHSt9Epx7RFwwb/laTEA9+Q0AA149qdNpN
 VobDgnt0HnT8y3MRaJGYRnhOTUg2gGGEA+Ui1/uHRARtcENx2tAXQ72H2vNhVt4GQJpF
 +dV50CwxIFvdJE7g4sApNeoji+PpDLdY6ChyWxGnAT8njXpzpTx4nEPSNoIgG5jfZVs8
 Z07xGg0mxDrRrKPweNeJ/EV8nu93tIlF7qsJxmAVwL194h49YX/8aAPW73/OOVKS9u3M
 oIQf3OnfmejLoY1/zGa8RSXDd7rTxub0eBDttzvOj/UnY+54oHCxn4ZtZnOLcJbt0gS4 zw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 322q4ptt6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 01:47:36 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 7 Jul
 2020 01:47:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 7 Jul 2020 01:47:35 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 286E53F703F;
        Tue,  7 Jul 2020 01:47:31 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        <anthony.wong@canonical.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikita Danilov <ndanilov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        "Dmitry Bezrukov" <dmitry.bezrukov@marvell.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: atlantic: Add support for firmware v4
Date:   Tue, 7 Jul 2020 11:46:57 +0300
Message-ID: <20200707084657.205-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707063830.15645-1-kai.heng.feng@canonical.com>
References: <20200707063830.15645-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_05:2020-07-07,2020-07-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Tue,  7 Jul 2020 14:38:28 +0800

> We have a new ethernet card that is supported by the atlantic driver:
> 01:00.0 Ethernet controller [0200]: Aquantia Corp. AQC107 NBase-T/IEEE 802.3bz Ethernet Controller [AQtion] [1d6a:07b1] (rev 02)
> 
> But the driver failed to probe the device:
> kernel: atlantic: Bad FW version detected: 400001e
> kernel: atlantic: probe of 0000:01:00.0 failed with error -95
> 
> As a pure guesswork, simply adding the firmware version to the driver

Please don't send "pure guessworks" to net-fixes tree. You should have
reported this as a bug to LKML and/or atlantic team, so we could issue
it.

> can make it function. Doing iperf3 as a smoketest doesn't show any
> abnormality either.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
> index 73c0f41df8d8..0b4cd1c0e022 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
> @@ -46,6 +46,7 @@
>  #define HW_ATL_FW_VER_1X 0x01050006U
>  #define HW_ATL_FW_VER_2X 0x02000000U
>  #define HW_ATL_FW_VER_3X 0x03000000U
> +#define HW_ATL_FW_VER_4X 0x0400001EU
>  
>  #define FORCE_FLASHLESS 0
>  
> @@ -81,6 +82,9 @@ int hw_atl_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops)
>  	} else if (hw_atl_utils_ver_match(HW_ATL_FW_VER_3X,
>  					  self->fw_ver_actual) == 0) {
>  		*fw_ops = &aq_fw_2x_ops;
> +	} else if (hw_atl_utils_ver_match(HW_ATL_FW_VER_4X,
> +					  self->fw_ver_actual) == 0) {
> +		*fw_ops = &aq_fw_2x_ops;
>  	} else {
>  		aq_pr_err("Bad FW version detected: %x\n",
>  			  self->fw_ver_actual);
> -- 
> 2.17.1
