Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD18468C271
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjBFQEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBFQEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:04:34 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF05172F
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 08:04:32 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id g9so8730733pfo.5
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 08:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KtQi0bSp1x+mrwEjHVpLnsh5rQDJ9jG6BP2yiSWkKY4=;
        b=maclRyJStw25YUsnE9wlAxrxn9igVMxNhNVR4kkmEb/CmcuH0PRnCdiGISTLaiXNrp
         eNpf1Uq/hX/pfu0+yIkoeZ07dvWFY77yZkF29xp8qk7sYX+pF8H9WrtZlnrZxNJzsUMc
         shecc9kqfJMp38RNce0Zddu6QNoG3eAKsyMj0pO0qsvmUwdWXI/Iqu+HnnquZLJf8DXP
         Un8L2bvBz+BoVfRid4BuAO1DU6S333BlZDUZpnbMsteHopoVBFEptxQ08BvQgXZXF+V0
         pk8eeH5m9BOXlhj9Mzyh82FOqaoEz+AwX4YwYzQKRsCne+2iwTYK40fNMHuDqjQ1148H
         DvcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KtQi0bSp1x+mrwEjHVpLnsh5rQDJ9jG6BP2yiSWkKY4=;
        b=44Wjk50ft7vym+W2L5JdogP2y/4M1lxizaV8M8hOoctVV99T3gL2A7CzsTSDCf4MjF
         7iiQmnIZ5ka08+ohyxYNmWhRSXi8AkxZpDID4Fvt11eb+dn+qMmLaVnRt6Gs1TVwvUvu
         cX4UthUkm5lHQFhK692vpPGVjV2Otjg7mrp6O6zWQdcHg4XSnjKRGMmXtfg0oGTTTmav
         PTLF5W7A02upU7N0laqlxXMv2j2hJVcGIZI3RBGhHT/mGbuPkbzhmc1IFwDJB3ffjRIN
         T0fdynHG9Dsqvt2OSXAt0EuS19ruXVbVHrRZ3LFTBpjduDuWZiKn1tNIRvfEDGrs86Qr
         YH/Q==
X-Gm-Message-State: AO0yUKWtqX9tn5TuRwE0GiTqaDuwfAGFMIQPMxsKoBAw0dTvrhVuVMCW
        i4QoTgNzE7X8WoA/ilXM9b28lZXLfqM=
X-Google-Smtp-Source: AK7set9vqfAlBoCGNoy7yPzSGHMrPEhqh/H/0B3jukk2xHjigINP9A2egxG/r/hMPknZ5kPgDUzPpA==
X-Received: by 2002:a05:6a00:15cb:b0:590:7735:5384 with SMTP id o11-20020a056a0015cb00b0059077355384mr24568849pfu.23.1675699472214;
        Mon, 06 Feb 2023 08:04:32 -0800 (PST)
Received: from [192.168.0.128] ([98.97.112.127])
        by smtp.googlemail.com with ESMTPSA id z186-20020a6265c3000000b005821c109cebsm7216457pfb.199.2023.02.06.08.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 08:04:31 -0800 (PST)
Message-ID: <3b65d8d8d90dd7c2d29a007b4b1746950d6fc788.camel@gmail.com>
Subject: Re: [PATCH v2 net-next] net: hns3: support wake on lan
 configuration and query
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Hao Lan <lanhao@huawei.com>, andrew@lunn.ch, davem@davemloft.net,
        kuba@kernel.org
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        edumazet@google.com, pabeni@redhat.com, richardcochran@gmail.com,
        shenjian15@huawei.com, netdev@vger.kernel.org,
        wangjie125@huawei.com
Date:   Mon, 06 Feb 2023 08:04:30 -0800
In-Reply-To: <20230206140640.32906-1-lanhao@huawei.com>
References: <20230206140640.32906-1-lanhao@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-02-06 at 22:06 +0800, Hao Lan wrote:
> HNS3 (HiSilicon Network System 3) supports Wake-on-LAN,
> magic mode and magic security mode on each pf.
> This patch supports the ethtool LAN wake-up configuration and
> query interfaces.
> It does not support the suspend resume interface because
> there is no corresponding application scenario.
>=20
> Signed-off-by: Hao Lan <lanhao@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  12 ++
>  .../hns3/hns3_common/hclge_comm_cmd.c         |   1 +
>  .../hns3/hns3_common/hclge_comm_cmd.h         |   3 +
>  .../ethernet/hisilicon/hns3/hns3_debugfs.c    |   3 +
>  .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  30 ++++
>  .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  14 ++
>  .../hisilicon/hns3/hns3pf/hclge_main.c        | 149 ++++++++++++++++++
>  .../hisilicon/hns3/hns3pf/hclge_main.h        |   8 +
>  8 files changed, 220 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/et=
hernet/hisilicon/hns3/hnae3.h
> index 17137de9338c..312ac1cccd39 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> @@ -99,6 +99,7 @@ enum HNAE3_DEV_CAP_BITS {
>  	HNAE3_DEV_SUPPORT_CQ_B,
>  	HNAE3_DEV_SUPPORT_FEC_STATS_B,
>  	HNAE3_DEV_SUPPORT_LANE_NUM_B,
> +	HNAE3_DEV_SUPPORT_WOL_B,
>  };
> =20
>  #define hnae3_ae_dev_fd_supported(ae_dev) \
> @@ -167,6 +168,9 @@ enum HNAE3_DEV_CAP_BITS {
>  #define hnae3_ae_dev_lane_num_supported(ae_dev) \
>  	test_bit(HNAE3_DEV_SUPPORT_LANE_NUM_B, (ae_dev)->caps)
> =20
> +#define hnae3_ae_dev_wol_supported(ae_dev) \
> +	test_bit(HNAE3_DEV_SUPPORT_WOL_B, (ae_dev)->caps)
> +
>  enum HNAE3_PF_CAP_BITS {
>  	HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B =3D 0,
>  };
> @@ -560,6 +564,10 @@ struct hnae3_ae_dev {
>   *   Get phc info
>   * clean_vf_config
>   *   Clean residual vf info after disable sriov
> + * get_wol
> + *   Get wake on lan info
> + * set_wol
> + *   Config wake on lan
>   */
>  struct hnae3_ae_ops {
>  	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
> @@ -759,6 +767,10 @@ struct hnae3_ae_ops {
>  	void (*clean_vf_config)(struct hnae3_ae_dev *ae_dev, int num_vfs);
>  	int (*get_dscp_prio)(struct hnae3_handle *handle, u8 dscp,
>  			     u8 *tc_map_mode, u8 *priority);
> +	void (*get_wol)(struct hnae3_handle *handle,
> +			struct ethtool_wolinfo *wol);
> +	int (*set_wol)(struct hnae3_handle *handle,
> +		       struct ethtool_wolinfo *wol);
>  };
> =20
>  struct hnae3_dcb_ops {
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_c=
md.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
> index f671a63cecde..cbbab5b2b402 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
> @@ -155,6 +155,7 @@ static const struct hclge_comm_caps_bit_map hclge_pf_=
cmd_caps[] =3D {
>  	{HCLGE_COMM_CAP_FD_B, HNAE3_DEV_SUPPORT_FD_B},
>  	{HCLGE_COMM_CAP_FEC_STATS_B, HNAE3_DEV_SUPPORT_FEC_STATS_B},
>  	{HCLGE_COMM_CAP_LANE_NUM_B, HNAE3_DEV_SUPPORT_LANE_NUM_B},
> +	{HCLGE_COMM_CAP_WOL_B, HNAE3_DEV_SUPPORT_WOL_B},
>  };
> =20
>  static const struct hclge_comm_caps_bit_map hclge_vf_cmd_caps[] =3D {
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_c=
md.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
> index b1f9383b418f..de72ecbfd5ad 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
> @@ -294,6 +294,8 @@ enum hclge_opcode_type {
>  	HCLGE_PPP_CMD0_INT_CMD		=3D 0x2100,
>  	HCLGE_PPP_CMD1_INT_CMD		=3D 0x2101,
>  	HCLGE_MAC_ETHERTYPE_IDX_RD      =3D 0x2105,
> +	HCLGE_OPC_WOL_GET_SUPPORTED_MODE	=3D 0x2201,
> +	HCLGE_OPC_WOL_CFG		=3D 0x2202,
>  	HCLGE_NCSI_INT_EN		=3D 0x2401,
> =20
>  	/* ROH MAC commands */
> @@ -345,6 +347,7 @@ enum HCLGE_COMM_CAP_BITS {
>  	HCLGE_COMM_CAP_FD_B =3D 21,
>  	HCLGE_COMM_CAP_FEC_STATS_B =3D 25,
>  	HCLGE_COMM_CAP_LANE_NUM_B =3D 27,
> +	HCLGE_COMM_CAP_WOL_B =3D 28,
>  };
> =20
>  enum HCLGE_COMM_API_CAP_BITS {
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers=
/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> index 66feb23f7b7b..4c3e90a1c4d0 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> @@ -408,6 +408,9 @@ static struct hns3_dbg_cap_info hns3_dbg_cap[] =3D {
>  	}, {
>  		.name =3D "support lane num",
>  		.cap_bit =3D HNAE3_DEV_SUPPORT_LANE_NUM_B,
> +	}, {
> +		.name =3D "support wake on lan",
> +		.cap_bit =3D HNAE3_DEV_SUPPORT_WOL_B,
>  	}
>  };
> =20
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers=
/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> index 55306fe8a540..da766461d4ad 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> @@ -2063,6 +2063,34 @@ static int hns3_get_link_ext_state(struct net_devi=
ce *netdev,
>  	return -ENODATA;
>  }
> =20
> +static void hns3_get_wol(struct net_device *netdev, struct ethtool_wolin=
fo *wol)
> +{
> +	struct hnae3_handle *handle =3D hns3_get_handle(netdev);
> +	struct hnae3_ae_dev *ae_dev =3D pci_get_drvdata(handle->pdev);
> +	const struct hnae3_ae_ops *ops =3D handle->ae_algo->ops;
> +
> +	if (!hnae3_ae_dev_wol_supported(ae_dev) || !ops->get_wol || !wol)
> +		return;
> +

As far as the !wol that is some defensive programming that is likely
not necessary. If ethtool is passing NULL values for that pointer we
likely have a serious programming issue in the kernel anyway.

Also in the !ops->get_wol case it would seem like we should be
indicating that we don't support wol. Perhaps it would make sense to
set wol->supported to 0 at the start of this funciton so that it is set
in all return cases.

> +	ops->get_wol(handle, wol);
> +}
> +
> +static int hns3_set_wol(struct net_device *netdev,
> +			struct ethtool_wolinfo *wol)
> +{
> +	struct hnae3_handle *handle =3D hns3_get_handle(netdev);
> +	struct hnae3_ae_dev *ae_dev =3D pci_get_drvdata(handle->pdev);
> +	const struct hnae3_ae_ops *ops =3D handle->ae_algo->ops;
> +
> +	if (!wol)
> +		return -EINVAL;
> +

Same here. If wol is NULL then ethtool has serious problems. I probably
wouldn't bother with checking this since callers are required to
provide it.

> +	if (!hnae3_ae_dev_wol_supported(ae_dev) || !ops->set_wol)
> +		return -EOPNOTSUPP;
> +
> +	return ops->set_wol(handle, wol);
> +}
> +
>  static const struct ethtool_ops hns3vf_ethtool_ops =3D {
>  	.supported_coalesce_params =3D HNS3_ETHTOOL_COALESCE,
>  	.supported_ring_params =3D HNS3_ETHTOOL_RING,
> @@ -2139,6 +2167,8 @@ static const struct ethtool_ops hns3_ethtool_ops =
=3D {
>  	.set_tunable =3D hns3_set_tunable,
>  	.reset =3D hns3_set_reset,
>  	.get_link_ext_state =3D hns3_get_link_ext_state,
> +	.get_wol =3D hns3_get_wol,
> +	.set_wol =3D hns3_set_wol,
>  };
> =20
>  void hns3_ethtool_set_ops(struct net_device *netdev)
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/dri=
vers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
> index 43cada51d8cb..b2f0bbf23603 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
> @@ -872,6 +872,20 @@ struct hclge_phy_reg_cmd {
>  	u8 rsv1[18];
>  };
> =20
> +#define HCLGE_SOPASS_MAX	6
> +
> +struct hclge_wol_cfg_cmd {
> +	__le32 wake_on_lan_mode;
> +	u8 sopass[HCLGE_SOPASS_MAX];
> +	u8 sopass_size;
> +	u8 rsv[13];
> +};
> +
> +struct hclge_query_wol_supported_cmd {
> +	__le32 supported_wake_mode;
> +	u8 rsv[20];
> +};
> +
>  struct hclge_hw;
>  int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num=
);
>  enum hclge_comm_cmd_status hclge_cmd_mdio_write(struct hclge_hw *hw,
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/dr=
ivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> index 1853f499cd94..b34439361aca 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> @@ -11533,6 +11533,143 @@ static void hclge_uninit_rxd_adv_layout(struct =
hclge_dev *hdev)
>  		hclge_write_dev(&hdev->hw, HCLGE_RXD_ADV_LAYOUT_EN_REG, 0);
>  }
> =20
> +static int hclge_get_wol_supported_mode(struct hclge_dev *hdev,
> +					u32 *wol_supported)
> +{
> +	struct hclge_query_wol_supported_cmd *wol_supported_cmd;
> +	struct hclge_desc desc;
> +	int ret;
> +
> +	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_WOL_GET_SUPPORTED_MODE,
> +				   true);
> +	wol_supported_cmd =3D (struct hclge_query_wol_supported_cmd *)desc.data=
;
> +
> +	ret =3D hclge_cmd_send(&hdev->hw, &desc, 1);
> +	if (ret) {
> +		dev_err(&hdev->pdev->dev,
> +			"failed to query wol supported, ret =3D %d\n", ret);
> +		return ret;
> +	}
> +
> +	*wol_supported =3D le32_to_cpu(wol_supported_cmd->supported_wake_mode);
> +
> +	return 0;
> +}
> +
> +static int hclge_get_wol_cfg(struct hclge_dev *hdev,
> +			     struct ethtool_wolinfo *wol)
> +{
> +	struct hclge_wol_cfg_cmd *wol_cfg_cmd;
> +	struct hclge_desc desc;
> +	int ret;
> +
> +	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_WOL_CFG, true);
> +	ret =3D hclge_cmd_send(&hdev->hw, &desc, 1);
> +	if (ret) {
> +		dev_err(&hdev->pdev->dev,
> +			"failed to get wol config, ret =3D %d\n", ret);
> +		return ret;
> +	}
> +
> +	wol_cfg_cmd =3D (struct hclge_wol_cfg_cmd *)desc.data;
> +	wol->wolopts =3D le32_to_cpu(wol_cfg_cmd->wake_on_lan_mode);
> +	if (wol->wolopts & WAKE_MAGICSECURE)
> +		memcpy(wol->sopass, wol_cfg_cmd->sopass, HCLGE_SOPASS_MAX);
> +
> +	return 0;
> +}
> +
> +static int hclge_set_wol_cfg(struct hclge_dev *hdev,
> +			     struct hclge_wol_info *wol_info)
> +{
> +	struct hclge_wol_cfg_cmd *wol_cfg_cmd;
> +	struct hclge_desc desc;
> +	int ret;
> +
> +	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_WOL_CFG, false);
> +	wol_cfg_cmd =3D (struct hclge_wol_cfg_cmd *)desc.data;
> +	wol_cfg_cmd->wake_on_lan_mode =3D cpu_to_le32(wol_info->wol_current_mod=
e);
> +	wol_cfg_cmd->sopass_size =3D wol_info->wol_sopass_size;
> +	memcpy(wol_cfg_cmd->sopass, wol_info->wol_sopass, HCLGE_SOPASS_MAX);
> +
> +	ret =3D hclge_cmd_send(&hdev->hw, &desc, 1);
> +	if (ret)
> +		dev_err(&hdev->pdev->dev,
> +			"failed to set wol config, ret =3D %d\n", ret);
> +
> +	return ret;
> +}
> +
> +static int hclge_update_wol(struct hclge_dev *hdev)
> +{
> +	struct hclge_wol_info *wol_info =3D &hdev->hw.mac.wol;
> +
> +	if (!hnae3_ae_dev_wol_supported(hdev->ae_dev))
> +		return 0;
> +
> +	return hclge_set_wol_cfg(hdev, wol_info);
> +}
> +
> +static int hclge_init_wol(struct hclge_dev *hdev)
> +{
> +	struct hclge_wol_info *wol_info =3D &hdev->hw.mac.wol;
> +	int ret;
> +
> +	if (!hnae3_ae_dev_wol_supported(hdev->ae_dev))
> +		return 0;
> +
> +	memset(wol_info, 0, sizeof(struct hclge_wol_info));
> +	ret =3D hclge_get_wol_supported_mode(hdev,
> +					   &wol_info->wol_support_mode);
> +	if (ret) {
> +		wol_info->wol_support_mode =3D 0;
> +		return ret;
> +	}
> +
> +	return hclge_update_wol(hdev);
> +}
> +
> +static void hclge_get_wol(struct hnae3_handle *handle,
> +			  struct ethtool_wolinfo *wol)
> +{
> +	struct hclge_vport *vport =3D hclge_get_vport(handle);
> +	struct hclge_dev *hdev =3D vport->back;
> +
> +	if (hclge_get_wol_supported_mode(hdev, &wol->supported))
> +		return;
> +
> +	if (hclge_get_wol_cfg(hdev, wol))
> +		wol->supported =3D 0;
> +}
> +

Is there a reason for fetching this from hardware rather than using the
version you should have acquired during init that would be stored in
hclge_wol_info?

> +static int hclge_set_wol(struct hnae3_handle *handle,
> +			 struct ethtool_wolinfo *wol)
> +{
> +	struct hclge_vport *vport =3D hclge_get_vport(handle);
> +	struct hclge_dev *hdev =3D vport->back;
> +	struct hclge_wol_info *wol_info =3D &hdev->hw.mac.wol;
> +	u32 wol_mode;
> +	int ret;
> +
> +	wol_mode =3D wol->wolopts;
> +	if (wol_mode & ~wol_info->wol_support_mode)
> +		return -EINVAL;
> +
> +	wol_info->wol_current_mode =3D wol_mode;
> +	if (wol_mode & WAKE_MAGICSECURE) {
> +		memcpy(wol_info->wol_sopass, wol->sopass, HCLGE_SOPASS_MAX);
> +		wol_info->wol_sopass_size =3D HCLGE_SOPASS_MAX;
> +	} else {
> +		wol_info->wol_sopass_size =3D 0;
> +	}
> +
> +	ret =3D hclge_set_wol_cfg(hdev, wol_info);
> +	if (ret)
> +		wol_info->wol_current_mode =3D 0;
> +
> +	return ret;
> +}
> +
>  static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
>  {
>  	struct pci_dev *pdev =3D ae_dev->pdev;
> @@ -11729,6 +11866,11 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev=
 *ae_dev)
>  	/* Enable MISC vector(vector0) */
>  	hclge_enable_vector(&hdev->misc_vector, true);
> =20
> +	ret =3D hclge_init_wol(hdev);
> +	if (ret)
> +		dev_warn(&pdev->dev,
> +			 "failed to wake on lan init, ret =3D %d\n", ret);
> +
>  	hclge_state_init(hdev);
>  	hdev->last_reset_time =3D jiffies;
> =20
> @@ -12108,6 +12250,11 @@ static int hclge_reset_ae_dev(struct hnae3_ae_de=
v *ae_dev)
> =20
>  	hclge_init_rxd_adv_layout(hdev);
> =20
> +	ret =3D hclge_update_wol(hdev);
> +	if (ret)
> +		dev_err(&pdev->dev,
> +			"fail(%d) to update wol config\n", ret);
> +
>  	dev_info(&pdev->dev, "Reset done, %s driver initialization finished.\n"=
,
>  		 HCLGE_DRIVER_NAME);
> =20
> @@ -13154,6 +13301,8 @@ static const struct hnae3_ae_ops hclge_ops =3D {
>  	.get_link_diagnosis_info =3D hclge_get_link_diagnosis_info,
>  	.clean_vf_config =3D hclge_clean_vport_config,
>  	.get_dscp_prio =3D hclge_get_dscp_prio,
> +	.get_wol =3D hclge_get_wol,
> +	.set_wol =3D hclge_set_wol,
>  };
> =20
>  static struct hnae3_ae_algo ae_algo =3D {
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/dr=
ivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> index 13f23d606e77..bd23d57b2ef2 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> @@ -249,6 +249,13 @@ enum HCLGE_MAC_DUPLEX {
>  #define QUERY_SFP_SPEED		0
>  #define QUERY_ACTIVE_SPEED	1
> =20
> +struct hclge_wol_info {
> +	u32 wol_support_mode; /* store the wake on lan info */
> +	u32 wol_current_mode;
> +	u8 wol_sopass[HCLGE_SOPASS_MAX];
> +	u8 wol_sopass_size;
> +};
> +
>  struct hclge_mac {
>  	u8 mac_id;
>  	u8 phy_addr;
> @@ -268,6 +275,7 @@ struct hclge_mac {
>  	u32 user_fec_mode;
>  	u32 fec_ability;
>  	int link;	/* store the link status of mac & phy (if phy exists) */
> +	struct hclge_wol_info wol;
>  	struct phy_device *phydev;
>  	struct mii_bus *mdio_bus;
>  	phy_interface_t phy_if;

