Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43A525993E
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbgIAQhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 12:37:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17562 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730531AbgIAP30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 11:29:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 081FQWsJ013719;
        Tue, 1 Sep 2020 08:29:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=IXCq5lTYbiRaQeEiRZ93A48y/eoRvMPA5aHnvPmRPUw=;
 b=dvnLz+2UgrgzHn9qrCah5/B2TO82zDfca2X634/pWapsKj02a1Q+A7xbtOIjJ+u/ZlQM
 kio9jsBD45lw3IMnGScXvSd0zEYkDbzfikiw58ImaqWPzNeH/yhKB6nkg3+6Dxo9GeV3
 qviGNCMGkCUEp7WKtiTtcKrMv7il9uQoc9g4uMM8nQ1F2nPKdWGJvLLzT+jXs+QOg6Y/
 3GuMQlxr1yoNW0f7AgsaOiopRIhXwP+hYgQ73uuhXvS8hlqRW2JeyO6/bR60ihe/PPhp
 rI29Wr5mKscX6WuBWvNOU263efkBmZSNhvNATj9JLvRHj8/G+2upX+vs3Z82GxY6EjxR hw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcq9p8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 08:29:23 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Sep
 2020 08:29:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Sep 2020 08:29:22 -0700
Received: from [10.193.39.7] (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id BE5DD3F703F;
        Tue,  1 Sep 2020 08:29:20 -0700 (PDT)
Subject: Re: [PATCH v2 net 1/3] net: qed: Disable aRFS for NPAR and 100G
To:     Dmitry Bogdanov <dbogdanov@marvell.com>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     Manish Chopra <manishc@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>
References: <cover.1597833340.git.dbogdanov@marvell.com>
 <ef4c8d8002a50a0d69978e8fca1b8fa8227a4519.1597833340.git.dbogdanov@marvell.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <2ec7b43a-e4eb-e5cb-dd86-ba9f9eb83518@marvell.com>
Date:   Tue, 1 Sep 2020 18:29:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:81.0) Gecko/20100101
 Thunderbird/81.0
MIME-Version: 1.0
In-Reply-To: <ef4c8d8002a50a0d69978e8fca1b8fa8227a4519.1597833340.git.dbogdanov@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_10:2020-09-01,2020-09-01 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Strangely I don't see this series from Dmitry on patchwork, but emails seems
reached the list correctly:

https://lore.kernel.org/netdev/20200831094326.0mIWCNw1jJrHOif9nW17zot9j5BvO_ZP0orBrhmv6KE@z/

Could you please help with that?

Thanks,
  Igor

On 31/08/2020 12:43 pm, Dmitry Bogdanov wrote:
> In CMT and NPAR the PF is unknown when the GFS block processes the
> packet. Therefore cannot use searcher as it has a per PF database,
> and thus ARFS must be disabled.
> 
> Fixes: d51e4af5c209 ("qed: aRFS infrastructure support")
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_dev.c  | 11 ++++++++++-
>  drivers/net/ethernet/qlogic/qed/qed_l2.c   |  3 +++
>  drivers/net/ethernet/qlogic/qed/qed_main.c |  2 ++
>  include/linux/qed/qed_if.h                 |  1 +
>  4 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> index b3c9ebaf2280..c78a48ae9ea6 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> @@ -4253,7 +4253,8 @@ static int qed_hw_get_nvm_info(struct qed_hwfn
> *p_hwfn, struct qed_ptt *p_ptt)
>  			cdev->mf_bits = BIT(QED_MF_LLH_MAC_CLSS) |
>  					BIT(QED_MF_LLH_PROTO_CLSS) |
>  					BIT(QED_MF_LL2_NON_UNICAST) |
> -					BIT(QED_MF_INTER_PF_SWITCH);
> +					BIT(QED_MF_INTER_PF_SWITCH) |
> +					BIT(QED_MF_DISABLE_ARFS);
>  			break;
>  		case NVM_CFG1_GLOB_MF_MODE_DEFAULT:
>  			cdev->mf_bits = BIT(QED_MF_LLH_MAC_CLSS) |
> @@ -4266,6 +4267,14 @@ static int qed_hw_get_nvm_info(struct qed_hwfn
> *p_hwfn, struct qed_ptt *p_ptt)
>  
>  		DP_INFO(p_hwfn, "Multi function mode is 0x%lx\n",
>  			cdev->mf_bits);
> +
> +		/* In CMT the PF is unknown when the GFS block processes
> the
> +		 * packet. Therefore cannot use searcher as it has a per
> PF
> +		 * database, and thus ARFS must be disabled.
> +		 *
> +		 */
> +		if (QED_IS_CMT(cdev))
> +			cdev->mf_bits |= BIT(QED_MF_DISABLE_ARFS);
>  	}
>  
>  	DP_INFO(p_hwfn, "Multi function mode is 0x%lx\n",
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c
> b/drivers/net/ethernet/qlogic/qed/qed_l2.c
> index 4c6ac8862744..07824bf9d68d 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
> @@ -1980,6 +1980,9 @@ void qed_arfs_mode_configure(struct qed_hwfn
> *p_hwfn,
>  			     struct qed_ptt *p_ptt,
>  			     struct qed_arfs_config_params *p_cfg_params)
>  {
> +	if (test_bit(QED_MF_DISABLE_ARFS, &p_hwfn->cdev->mf_bits))
> +		return;
> +
>  	if (p_cfg_params->mode != QED_FILTER_CONFIG_MODE_DISABLE) {
>  		qed_gft_config(p_hwfn, p_ptt, p_hwfn->rel_pf_id,
>  			       p_cfg_params->tcp,
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c
> b/drivers/net/ethernet/qlogic/qed/qed_main.c
> index 2558cb680db3..309216ff7a84 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_main.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
> @@ -444,6 +444,8 @@ int qed_fill_dev_info(struct qed_dev *cdev,
>  		dev_info->fw_eng = FW_ENGINEERING_VERSION;
>  		dev_info->b_inter_pf_switch =
> test_bit(QED_MF_INTER_PF_SWITCH,
>  						       &cdev->mf_bits);
> +		if (!test_bit(QED_MF_DISABLE_ARFS, &cdev->mf_bits))
> +			dev_info->b_arfs_capable = true;
>  		dev_info->tx_switching = true;
>  
>  		if (hw_info->b_wol_support == QED_WOL_SUPPORT_PME)
> diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
> index cd6a5c7e56eb..cdd73afc4c46 100644
> --- a/include/linux/qed/qed_if.h
> +++ b/include/linux/qed/qed_if.h
> @@ -623,6 +623,7 @@ struct qed_dev_info {
>  #define QED_MFW_VERSION_3_OFFSET	24
>  
>  	u32		flash_size;
> +	bool		b_arfs_capable;
>  	bool		b_inter_pf_switch;
>  	bool		tx_switching;
>  	bool		rdma_supported;
> 
