Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CAB224434
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgGQT1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:27:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64984 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727999AbgGQT1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:27:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HJQCto017519;
        Fri, 17 Jul 2020 12:27:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=palg9+Cwha2/Apktwa1QnMjhU+VZ5A2f4++3ln+xwns=;
 b=yIvI0olhLxL+GCxtCsByQtsee2G7kmJ3VV3BQhuLvu5GhHG7lpkuXMUXVHf3BbxLezD2
 TsIpfTwVGg87FEfpJ+x7nPgKhIAgkisJdQcGPVfWPnQb8G5GqaX/l82ykKEc8vIDg8YJ
 ImIPXSsfBV7i6MjZuCf4mz8V5Ou0ablKXPpV2VCuFNbP2/KHvfe1K4LaR7eFmkz0c0hd
 VnWTOnxE0LhphSIIgAXROuNBDToENRhXHUcGhi6wHDr53yh58OVqg7LouIUZLqQNdTlV
 xENcg15GgfTTyOD9brFweYFu9Zbuol1z9SQfh8prLh1tQ6C2c9h5neEVTl4WLPmHwGAw qQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32ap7ven3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 12:27:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 12:27:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 17 Jul 2020 12:27:08 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id F0B703F7041;
        Fri, 17 Jul 2020 12:27:03 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 10/13] qed: add support for new port modes
Date:   Fri, 17 Jul 2020 22:26:33 +0300
Message-ID: <20200717192633.181-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200717113155.1a9234b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200717113155.1a9234b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200716115446.994-1-alobakin@marvell.com>
 <20200716115446.994-11-alobakin@marvell.com>
 <20200716181853.502dd619@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <27939848-7e83-2897-36f9-44f47d1bfb9c@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_09:2020-07-17,2020-07-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Date: Fri, 17 Jul 2020 11:31:55 -0700
From: Jakub Kicinski <kuba@kernel.org>

> On Fri, 17 Jul 2020 13:49:33 +0300 Igor Russkikh wrote:
>>> ----------------------------------------------------------------------
>>> On Thu, 16 Jul 2020 14:54:43 +0300 Alexander Lobakin wrote:  
>>>> These ports ship on new boards revisions and are supported by newer
>>>> firmware versions.
>>>>
>>>> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
>>>> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>  
>>> 
>>> What is the driver actually doing with them, tho?
>>> 
>>> Looks like you translate some firmware specific field to a driver
>>> specific field, but I can't figure out what part of the code cares
>>> about hw_info.port_mode  
>> 
>> Hi Jakub,
>> 
>> You are right, this info is never used/reported.
>> 
>> Alexander is extending already existing non used field with new values from
>> our latest hardware revisions.
>> 
>> I thought devlink info could be a good place to output such kind of information.
>> 
>> Thats basically a layout of *Physical* ports on device - quite useful info I
>> think.
>> 
>> Important thing is these ports may not be directly mapped to PCI PFs. So
>> reading `ethtool eth*` may not explain you the real device capabilities.
>> 
>> Do you think it makes sense adding such info to `devlink info` then?
>
> Devlink port has information about physical port, which don't have to
> map 1:1 to netdevs. It also has lanes and port splitting which you may
> want to report.
>
>
> For now please make sure to not include any dead code in your
> submissions (register defines etc. may be okay), perhaps try:

I think it would be better to drop this struct member at all since it's
really not used anywhere. There'll be no problem to add it back anytime
we might need it, but for now it seems unreasonable to keep it "just in
case".

Got it, thanks, will send v2 soon.

> diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> index d929556247a5..4bad836d0f74 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> @@ -4026,6 +4026,21 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
>  	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G:
>  		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_4X25G;
>  		break;
> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X50G_R1:
> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_4X50G_R1:
> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R2:
> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X100G_R2:
> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R4:
> +		/* TODO: set port_mode when it's actually used */
> +		break;
>  	default:
>  		DP_NOTICE(p_hwfn, "Unknown port mode in 0x%08x\n", core_cfg);
>  		break;
>
> And see if it will pass the muster.
>
> Dead code makes it harder to review the patches.
