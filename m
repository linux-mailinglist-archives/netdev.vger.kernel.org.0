Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689D15AE927
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 15:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240368AbiIFNMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 09:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240165AbiIFNMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 09:12:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6307D2C655
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 06:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662469963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nPXU2vL80KndlHKrXBdhj3U+PkIo9q6AqsJq3aprkc8=;
        b=jWjps2iNLSGusiWMtYgoqhJs7mWcu1diMAxG4mz3Hm9XZDKk6s7ds1FwNUz1jH/HaS3g5Q
        J1CjBcvU6H5Pqnx4y3OMecblf368ZqOMarbaHyyMNMowep8zyC5Ji4UJXibTKuvfN7nU6w
        FQDaw5q7K8gjlgab0unGzz7oluZpefo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-572-6w2B2PNrPairAagiYUa36Q-1; Tue, 06 Sep 2022 09:12:41 -0400
X-MC-Unique: 6w2B2PNrPairAagiYUa36Q-1
Received: by mail-wm1-f72.google.com with SMTP id p19-20020a05600c1d9300b003a5c3141365so8761536wms.9
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 06:12:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=nPXU2vL80KndlHKrXBdhj3U+PkIo9q6AqsJq3aprkc8=;
        b=sElL2lU33yKrIR1ItoaAGGzSQ64nxLXWEDNH+lhREVhTOuyBdaw3mfWiGjKFym7G+D
         tVnMCOirntPxOBPtTgjCNAgjLcCnBEham4I4SdEfJV/QF8YTH0heiIm6c80WGvfnjo2I
         GF974p5MYTgiIKQh6DS00hSsnU7QIKCuc/iZnlSbYm088amcOW+KFt7/4KgFBZCuTrtF
         GxjpahLeJfXaqDKmJf85lKZ+h5rqXIyDobFibrhuglhnOCDQSZwqi+nW+nAZ6oRJ70ny
         JlkdymQwioNDUCprQxoWKTHAeffVNlsuuEGe9r5GS+G79zbzITFrYFQA0JQwGMWRy4W7
         Joqw==
X-Gm-Message-State: ACgBeo3llo+LOXcUhHXpRnS/7Bc8I8VV6Z6sY8v5H1RwpRBCzTEl/AZK
        /dioPf7eKMo1nLcX+p30vbiaRWwSHS3KhmeKQyWwYqvZQNokM3HgUkZIyB+0o+4OXZwCY6IKuR7
        rggt8SHhJEicJGeO+
X-Received: by 2002:adf:fb0a:0:b0:225:265d:493 with SMTP id c10-20020adffb0a000000b00225265d0493mr27349806wrr.394.1662469959425;
        Tue, 06 Sep 2022 06:12:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7BPkkEtX4haa8tO2sfQDf8b9gde5k8lEFdtYT/OxeEtfQ4rOrUg4tf1Eu0Bo3O9H+Sx950Yw==
X-Received: by 2002:adf:fb0a:0:b0:225:265d:493 with SMTP id c10-20020adffb0a000000b00225265d0493mr27349778wrr.394.1662469959088;
        Tue, 06 Sep 2022 06:12:39 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-72.dyn.eolo.it. [146.241.112.72])
        by smtp.gmail.com with ESMTPSA id x5-20020a5d6505000000b00228634628f1sm8735224wru.110.2022.09.06.06.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 06:12:38 -0700 (PDT)
Message-ID: <624262faa90a788ba37f8cb3df50895d13fa8eaf.camel@redhat.com>
Subject: Re: [PATCH net-next 1/5] net: hns3: add support config dscp map to
 tc
From:   Paolo Abeni <pabeni@redhat.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        lanhao@huawei.com
Date:   Tue, 06 Sep 2022 15:12:37 +0200
In-Reply-To: <20220905081539.62131-2-huangguangbin2@huawei.com>
References: <20220905081539.62131-1-huangguangbin2@huawei.com>
         <20220905081539.62131-2-huangguangbin2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-09-05 at 16:15 +0800, Guangbin Huang wrote:
> This patch add support config dscp map to tc by implementing ieee_setapp
> and ieee_delapp of struct dcbnl_rtnl_ops. Driver will convert mapping
> relationship from dscp-prio to dscp-tc.
> 
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  10 ++
>  .../net/ethernet/hisilicon/hns3/hns3_dcbnl.c  |  28 +++++
>  .../hisilicon/hns3/hns3pf/hclge_dcb.c         | 107 ++++++++++++++++++
>  .../hisilicon/hns3/hns3pf/hclge_dcb.h         |   3 +
>  .../hisilicon/hns3/hns3pf/hclge_main.c        |   1 +
>  .../hisilicon/hns3/hns3pf/hclge_main.h        |   4 +
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  50 +++++++-
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |   5 +
>  8 files changed, 207 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> index 795df7111119..33b5ac47f342 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> @@ -310,6 +310,11 @@ enum hnae3_dbg_cmd {
>  	HNAE3_DBG_CMD_UNKNOWN,
>  };
>  
> +enum hnae3_tc_map_mode {
> +	HNAE3_TC_MAP_MODE_PRIO,
> +	HNAE3_TC_MAP_MODE_DSCP,
> +};
> +
>  struct hnae3_vector_info {
>  	u8 __iomem *io_addr;
>  	int vector;
> @@ -739,6 +744,8 @@ struct hnae3_ae_ops {
>  	int (*get_link_diagnosis_info)(struct hnae3_handle *handle,
>  				       u32 *status_code);
>  	void (*clean_vf_config)(struct hnae3_ae_dev *ae_dev, int num_vfs);
> +	int (*get_dscp_prio)(struct hnae3_handle *handle, u8 dscp,
> +			     u8 *tc_map_mode, u8 *priority);
>  };
>  
>  struct hnae3_dcb_ops {
> @@ -747,6 +754,8 @@ struct hnae3_dcb_ops {
>  	int (*ieee_setets)(struct hnae3_handle *, struct ieee_ets *);
>  	int (*ieee_getpfc)(struct hnae3_handle *, struct ieee_pfc *);
>  	int (*ieee_setpfc)(struct hnae3_handle *, struct ieee_pfc *);
> +	int (*ieee_setapp)(struct hnae3_handle *h, struct dcb_app *app);
> +	int (*ieee_delapp)(struct hnae3_handle *h, struct dcb_app *app);
>  
>  	/* DCBX configuration */
>  	u8   (*getdcbx)(struct hnae3_handle *);
> @@ -786,6 +795,7 @@ struct hnae3_knic_private_info {
>  	u32 tx_spare_buf_size;
>  
>  	struct hnae3_tc_info tc_info;
> +	u8 tc_map_mode;
>  
>  	u16 num_tqps;		  /* total number of TQPs in this handle */
>  	struct hnae3_queue **tqp;  /* array base of all TQPs in this instance */
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c b/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c
> index d2ec4c573bf8..3b6dbf158b98 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c
> @@ -56,6 +56,32 @@ static int hns3_dcbnl_ieee_setpfc(struct net_device *ndev, struct ieee_pfc *pfc)
>  	return -EOPNOTSUPP;
>  }
>  
> +static int hns3_dcbnl_ieee_setapp(struct net_device *ndev, struct dcb_app *app)
> +{
> +	struct hnae3_handle *h = hns3_get_handle(ndev);
> +
> +	if (hns3_nic_resetting(ndev))
> +		return -EBUSY;
> +
> +	if (h->kinfo.dcb_ops->ieee_setapp)
> +		return h->kinfo.dcb_ops->ieee_setapp(h, app);
> +
> +	return -EOPNOTSUPP;
> +}
> +
> +static int hns3_dcbnl_ieee_delapp(struct net_device *ndev, struct dcb_app *app)
> +{
> +	struct hnae3_handle *h = hns3_get_handle(ndev);
> +
> +	if (hns3_nic_resetting(ndev))
> +		return -EBUSY;
> +
> +	if (h->kinfo.dcb_ops->ieee_setapp)
> +		return h->kinfo.dcb_ops->ieee_delapp(h, app);
> +
> +	return -EOPNOTSUPP;
> +}
> +
>  /* DCBX configuration */
>  static u8 hns3_dcbnl_getdcbx(struct net_device *ndev)
>  {
> @@ -83,6 +109,8 @@ static const struct dcbnl_rtnl_ops hns3_dcbnl_ops = {
>  	.ieee_setets	= hns3_dcbnl_ieee_setets,
>  	.ieee_getpfc	= hns3_dcbnl_ieee_getpfc,
>  	.ieee_setpfc	= hns3_dcbnl_ieee_setpfc,
> +	.ieee_setapp    = hns3_dcbnl_ieee_setapp,
> +	.ieee_delapp    = hns3_dcbnl_ieee_delapp,
>  	.getdcbx	= hns3_dcbnl_getdcbx,
>  	.setdcbx	= hns3_dcbnl_setdcbx,
>  };
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
> index 69b8673436ca..7fcacc76e749 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
> @@ -359,6 +359,111 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
>  	return hclge_notify_client(hdev, HNAE3_UP_CLIENT);
>  }
>  
> +static int hclge_ieee_setapp(struct hnae3_handle *h, struct dcb_app *app)
> +{
> +	struct hclge_vport *vport = hclge_get_vport(h);
> +	struct net_device *netdev = h->kinfo.netdev;
> +	struct hclge_dev *hdev = vport->back;
> +	struct dcb_app old_app;
> +	int ret;
> +
> +	if (app->selector != IEEE_8021QAZ_APP_SEL_DSCP ||
> +	    app->protocol >= HCLGE_MAX_DSCP ||
> +	    app->priority >= HNAE3_MAX_USER_PRIO)
> +		return -EINVAL;
> +
> +	dev_info(&hdev->pdev->dev, "setapp dscp=%u priority=%u\n",
> +		 app->protocol, app->priority);
> +
> +	if (app->priority == hdev->tm_info.dscp_prio[app->protocol])
> +		return 0;
> +
> +	ret = dcb_ieee_setapp(netdev, app);
> +	if (ret)
> +		return ret;
> +
> +	old_app.selector = IEEE_8021QAZ_APP_SEL_DSCP;
> +	old_app.protocol = app->protocol;
> +	old_app.priority = hdev->tm_info.dscp_prio[app->protocol];
> +
> +	hdev->tm_info.dscp_prio[app->protocol] = app->priority;
> +	ret = hclge_dscp_to_tc_map(hdev);
> +	if (ret) {
> +		dev_err(&hdev->pdev->dev,
> +			"failed to set dscp to tc map, ret = %d\n", ret);
> +		hdev->tm_info.dscp_prio[app->protocol] = old_app.priority;
> +		(void)dcb_ieee_delapp(netdev, app);
> +		return ret;
> +	}
> +
> +	vport->nic.kinfo.tc_map_mode = HNAE3_TC_MAP_MODE_DSCP;
> +	if (old_app.priority == HCLGE_PRIO_ID_INVALID)
> +		hdev->tm_info.dscp_app_cnt++;
> +	else
> +		ret = dcb_ieee_delapp(netdev, &old_app);
> +
> +	return ret;
> +}
> +
> +static int hclge_ieee_delapp(struct hnae3_handle *h, struct dcb_app *app)
> +{
> +	struct hclge_vport *vport = hclge_get_vport(h);
> +	struct net_device *netdev = h->kinfo.netdev;
> +	struct hclge_dev *hdev = vport->back;
> +	int ret;
> +
> +	if (app->selector != IEEE_8021QAZ_APP_SEL_DSCP ||
> +	    app->protocol >= HCLGE_MAX_DSCP ||
> +	    app->priority >= HNAE3_MAX_USER_PRIO ||
> +	    app->priority != hdev->tm_info.dscp_prio[app->protocol])
> +		return -EINVAL;
> +
> +	dev_info(&hdev->pdev->dev, "delapp dscp=%u priority=%u\n",
> +		 app->protocol, app->priority);
> +
> +	ret = dcb_ieee_delapp(netdev, app);
> +	if (ret)
> +		return ret;
> +
> +	hdev->tm_info.dscp_prio[app->protocol] = HCLGE_PRIO_ID_INVALID;
> +	ret = hclge_dscp_to_tc_map(hdev);
> +	if (ret) {
> +		dev_err(&hdev->pdev->dev,
> +			"failed to del dscp to tc map, ret = %d\n", ret);
> +		hdev->tm_info.dscp_prio[app->protocol] = app->priority;
> +		(void)dcb_ieee_setapp(netdev, app);
> +		return ret;
> +	}
> +
> +	if (hdev->tm_info.dscp_app_cnt)
> +		hdev->tm_info.dscp_app_cnt--;
> +
> +	if (!hdev->tm_info.dscp_app_cnt) {
> +		vport->nic.kinfo.tc_map_mode = HNAE3_TC_MAP_MODE_PRIO;
> +		ret = hclge_up_to_tc_map(hdev);
> +	}
> +
> +	return ret;
> +}
> +
> +int hclge_get_dscp_prio(struct hnae3_handle *h, u8 dscp, u8 *tc_mode,
> +			u8 *priority)
> +{
> +	struct hclge_vport *vport = hclge_get_vport(h);
> +	struct hclge_dev *hdev = vport->back;
> +
> +	if (dscp >= HCLGE_MAX_DSCP)
> +		return -EINVAL;
> +
> +	if (tc_mode)
> +		*tc_mode = vport->nic.kinfo.tc_map_mode;
> +	if (priority)
> +		*priority = hdev->tm_info.dscp_prio[dscp] == HCLGE_PRIO_ID_INVALID ? 0 :
> +			    hdev->tm_info.dscp_prio[dscp];
> +
> +	return 0;
> +}
> +
>  /* DCBX configuration */
>  static u8 hclge_getdcbx(struct hnae3_handle *h)
>  {
> @@ -543,6 +648,8 @@ static const struct hnae3_dcb_ops hns3_dcb_ops = {
>  	.ieee_setets	= hclge_ieee_setets,
>  	.ieee_getpfc	= hclge_ieee_getpfc,
>  	.ieee_setpfc	= hclge_ieee_setpfc,
> +	.ieee_setapp    = hclge_ieee_setapp,
> +	.ieee_delapp    = hclge_ieee_delapp,
>  	.getdcbx	= hclge_getdcbx,
>  	.setdcbx	= hclge_setdcbx,
>  	.setup_tc	= hclge_setup_tc,
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h
> index b04702e65689..17a5460e7ea9 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h
> @@ -12,4 +12,7 @@ void hclge_dcb_ops_set(struct hclge_dev *hdev);
>  static inline void hclge_dcb_ops_set(struct hclge_dev *hdev) {}
>  #endif
>  
> +int hclge_get_dscp_prio(struct hnae3_handle *h, u8 dscp, u8 *tc_mode,
> +			u8 *priority);
> +
>  #endif /* __HCLGE_DCB_H__ */
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> index fcdc978379ff..f43c7d392d1a 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> @@ -12907,6 +12907,7 @@ static const struct hnae3_ae_ops hclge_ops = {
>  	.get_ts_info = hclge_ptp_get_ts_info,
>  	.get_link_diagnosis_info = hclge_get_link_diagnosis_info,
>  	.clean_vf_config = hclge_clean_vport_config,
> +	.get_dscp_prio = hclge_get_dscp_prio,

This brings in an implicit dependency on CONFIG_HNS3_DCB, causing the
build error reported by the intel bot.

Please, address the above, thanks!

Paolo

