Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9992239A4
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgGQKpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:45:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42116 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbgGQKpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:45:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HAf5HS000706;
        Fri, 17 Jul 2020 03:45:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=kUUV0lqEb9Xz6K+RwOiQpvVDxu/YkSCqofPspW+1YoY=;
 b=SNvuhoJTEhg9HEnJEQNY54Czw4gqsE8vAPqmFYgEDU4/RCHpjgXS6vtG2qdCVQojVGCR
 aKbI7iXyvDWR+pZtsUL5aNssyCVtK/OR/Wr3phptilEW8C7043wn8SiJ6kNSZQkFBTWE
 XV9rK1BBXS4z+1PHwT/vHAbDKY2TGplo5XwDTh+bWgDMzl3t3XnxuxnVTF6kgpwMW/ZE
 Rb14Hs/PnqetbHJ60fazMYU3R/Vgqi3b9vgcVeqhjx4oFc83Nwu0lEaeavOOjlBWvlKe
 /PZwBI+vv2+b+W1y9Q7TVeDSqbREhuivL5c04Q9fKh1HGjcfSTlW6cs/0ovS7BCX4xi3 aA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmj43he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 03:45:17 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 03:45:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 17 Jul 2020 03:45:15 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 52CE13F703F;
        Fri, 17 Jul 2020 03:45:11 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Denis Bolotin" <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 10/13] qed: add support for new port modes
Date:   Fri, 17 Jul 2020 13:44:37 +0300
Message-ID: <20200717104437.523-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716181853.502dd619@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200716115446.994-1-alobakin@marvell.com>,
 <20200716181853.502dd619@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_06:2020-07-17,2020-07-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 16 Jul 2020 18:18:57 -0700

Hi Jakub,

> On Thu, 16 Jul 2020 14:54:43 +0300 Alexander Lobakin wrote:
>> These ports ship on new boards revisions and are supported by newer
>> firmware versions.
>> 
>> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
>> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> 
> What is the driver actually doing with them, tho?
> 
> Looks like you translate some firmware specific field to a driver
> specific field, but I can't figure out what part of the code cares
> about hw_info.port_mode

You're right, we just check NVM port type for validity and store it
for the case of future expansions. Is that OK or I should do smth
with that?

>> diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
>> index 6a1d12da7910..63fcbd5a295a 100644
>> --- a/drivers/net/ethernet/qlogic/qed/qed.h
>> +++ b/drivers/net/ethernet/qlogic/qed/qed.h
>> @@ -257,6 +257,11 @@ enum QED_PORT_MODE {
>>  	QED_PORT_MODE_DE_1X25G,
>>  	QED_PORT_MODE_DE_4X25G,
>>  	QED_PORT_MODE_DE_2X10G,
>> +	QED_PORT_MODE_DE_2X50G_R1,
>> +	QED_PORT_MODE_DE_4X50G_R1,
>> +	QED_PORT_MODE_DE_1X100G_R2,
>> +	QED_PORT_MODE_DE_2X100G_R2,
>> +	QED_PORT_MODE_DE_1X100G_R4,
>>  };
>>  
>>  enum qed_dev_cap {
>> diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
>> index d929556247a5..4bad836d0f74 100644
>> --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
>> +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
>> @@ -4026,6 +4026,21 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
>>  	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G:
>>  		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_4X25G;
>>  		break;
>> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X50G_R1:
>> +		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_2X50G_R1;
>> +		break;
>> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_4X50G_R1:
>> +		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_4X50G_R1;
>> +		break;
>> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R2:
>> +		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_1X100G_R2;
>> +		break;
>> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X100G_R2:
>> +		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_2X100G_R2;
>> +		break;
>> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R4:
>> +		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_1X100G_R4;
>> +		break;
>>  	default:
>>  		DP_NOTICE(p_hwfn, "Unknown port mode in 0x%08x\n", core_cfg);
>>  		break;
>> diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
>> index a4a845579fd2..debc55923251 100644
>> --- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
>> +++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
>> @@ -13015,6 +13015,11 @@ struct nvm_cfg1_glob {
>>  #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X25G			0xd
>>  #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G			0xe
>>  #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X10G			0xf
>> +#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X50G_R1		0x11
>> +#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_4X50G_R1		0x12
>> +#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R2		0x13
>> +#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X100G_R2		0x14
>> +#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R4		0x15
>>  
>>  	u32							e_lane_cfg1;
>>  	u32							e_lane_cfg2;

Al
