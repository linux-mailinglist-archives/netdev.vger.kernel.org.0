Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E15569EFD9
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 09:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjBVIEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 03:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBVID7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 03:03:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F4B1EBD0;
        Wed, 22 Feb 2023 00:03:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E02EB811D5;
        Wed, 22 Feb 2023 08:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DF3C433D2;
        Wed, 22 Feb 2023 08:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677053034;
        bh=2dFmx76LSc1nkfQUy0U1ICQ491CjQLf/H4jR4PZN1eQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WOM8cH+ZIsNbVpT5XGPUoqNzs/hB/34MhPqlRByLZFALd/Z9NPEtETfhD2lBdADBj
         BojqeVcZiTTkM643cBAtmBM/ekbxsQwWNPXxZr7MKiXuCfewg1pBOybKOEm6ZmMyt5
         Biago2NtVOxAcCFFxIQGuvDBRLb87vJo9toRL+AyChzTZ66xfk6E+yyOlAolWfFYd5
         4DgTZ63aKsSe4N27hviWZETKouwwMCSi1kVggJTDZufMTkvtktw1q+39MANOd+yZZb
         4Al8n5mtgaEPlOkM1rYtnD6N2O9LLQm/w0CAySmGKcoxONs+zPmHkJhLhwql4bZhHd
         15b3enz3cM9wg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pUk6Y-0003hx-LJ; Wed, 22 Feb 2023 09:03:58 +0100
Date:   Wed, 22 Feb 2023 09:03:58 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>
Subject: Re: [PATCH v5 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
Message-ID: <Y/XMbhIgF8veIIdl@hovoldconsulting.com>
References: <20230209020916.6475-1-steev@kali.org>
 <20230209020916.6475-3-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209020916.6475-3-steev@kali.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 08:09:14PM -0600, Steev Klimaszewski wrote:
> Added regulators,GPIOs and changes required to power on/off wcn6855.
> Added support for firmware download for wcn6855.
> 
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> ---

>  drivers/bluetooth/btqca.c   |  9 ++++++-
>  drivers/bluetooth/btqca.h   | 10 ++++++++
>  drivers/bluetooth/hci_qca.c | 50 ++++++++++++++++++++++++++++---------
>  3 files changed, 56 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
> index c9064d34d830..2f9d8bd27c38 100644
> --- a/drivers/bluetooth/btqca.c
> +++ b/drivers/bluetooth/btqca.c
 
> +static const struct qca_device_data qca_soc_data_wcn6855 = {
> +	.soc_type = QCA_WCN6855,
> +	.vregs = (struct qca_vreg []) {
> +		{ "vddio", 5000 },
> +		{ "vddbtcxmx", 126000 },
> +		{ "vddrfacmn", 12500 },
> +		{ "vddrfa0p8", 102000 },
> +		{ "vddrfa1p7", 302000 },
> +		{ "vddrfa1p2", 257000 },
> +	},
> +	.num_vregs = 6,
> +	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
> +};
> +
>  static void qca_power_shutdown(struct hci_uart *hu)
>  {
>  	struct qca_serdev *qcadev;

As I just mentioned IRC, you forgot to update qca_power_shutdown() here
so the regulators are currently never disabled (e.g. when closing the
device or on module unload).

> @@ -2047,7 +2066,8 @@ static int qca_serdev_probe(struct serdev_device *serdev)
>  
>  	if (data &&
>  	    (qca_is_wcn399x(data->soc_type) ||
> -	    qca_is_wcn6750(data->soc_type))) {
> +	    qca_is_wcn6750(data->soc_type) ||
> +	    qca_is_wcn6855(data->soc_type))) {
>  		qcadev->btsoc_type = data->soc_type;
>  		qcadev->bt_power = devm_kzalloc(&serdev->dev,
>  						sizeof(struct qca_power),

> @@ -2150,7 +2174,8 @@ static void qca_serdev_remove(struct serdev_device *serdev)
>  	struct qca_power *power = qcadev->bt_power;
>  
>  	if ((qca_is_wcn399x(qcadev->btsoc_type) ||
> -	     qca_is_wcn6750(qcadev->btsoc_type)) &&
> +	     qca_is_wcn6750(qcadev->btsoc_type) ||
> +	     qca_is_wcn6855(qcadev->btsoc_type)) &&
>  	     power->vregs_on)
>  		qca_power_shutdown(&qcadev->serdev_hu);
>  	else if (qcadev->susclk)

Johan
