Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147FF41E9AC
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 11:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353072AbhJAJhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 05:37:51 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:16136 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352982AbhJAJht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 05:37:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633080966; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=BeCtPj+gAx1yb+qr7Piiqq97L5UNvZlh+6GnVLGIR9Q=; b=llTsoZcxrLrurcUw0FfXxByC9KhKJ+bb4ne2Nhp5SwgO01bpFCEkq/gHHL368UVVuDIPXadv
 TAL/HZbyANlo3sKdxjx1MpMd5fuM6/wnQYfsFs47CONBZ8ImDBpNBKHywrE5FQFMUT/zEF7O
 WaGo+KlD9XpXASEqStNJ58HIOnk=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6156d66947d64efb6dd25f21 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Oct 2021 09:35:37
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 399F7C4338F; Fri,  1 Oct 2021 09:35:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B05F2C4338F;
        Fri,  1 Oct 2021 09:35:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B05F2C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 20/24] wfx: add scan.c/scan.h
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-21-Jerome.Pouiller@silabs.com>
Date:   Fri, 01 Oct 2021 12:35:28 +0300
In-Reply-To: <20210920161136.2398632-21-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Mon, 20 Sep 2021 18:11:32 +0200")
Message-ID: <87r1d5krz3.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>
> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>

[...]

> +/* It is not really necessary to run scan request asynchronously. Howeve=
r,
> + * there is a bug in "iw scan" when ieee80211_scan_completed() is called=
 before
> + * wfx_hw_scan() return
> + */
> +void wfx_hw_scan_work(struct work_struct *work)
> +{
> +	struct wfx_vif *wvif =3D container_of(work, struct wfx_vif, scan_work);
> +	struct ieee80211_scan_request *hw_req =3D wvif->scan_req;
> +	int chan_cur, ret, err;
> +
> +	mutex_lock(&wvif->wdev->conf_mutex);
> +	mutex_lock(&wvif->scan_lock);
> +	if (wvif->join_in_progress) {
> +		dev_info(wvif->wdev->dev, "abort in-progress REQ_JOIN");
> +		wfx_reset(wvif);
> +	}
> +	update_probe_tmpl(wvif, &hw_req->req);
> +	chan_cur =3D 0;
> +	err =3D 0;
> +	do {
> +		ret =3D send_scan_req(wvif, &hw_req->req, chan_cur);
> +		if (ret > 0) {
> +			chan_cur +=3D ret;
> +			err =3D 0;
> +		}
> +		if (!ret)
> +			err++;
> +		if (err > 2) {
> +			dev_err(wvif->wdev->dev, "scan has not been able to start\n");
> +			ret =3D -ETIMEDOUT;
> +		}
> +	} while (ret >=3D 0 && chan_cur < hw_req->req.n_channels);
> +	mutex_unlock(&wvif->scan_lock);
> +	mutex_unlock(&wvif->wdev->conf_mutex);
> +	__ieee80211_scan_completed_compat(wvif->wdev->hw, ret < 0);
> +}
> +
> +int wfx_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +		struct ieee80211_scan_request *hw_req)
> +{
> +	struct wfx_vif *wvif =3D (struct wfx_vif *)vif->drv_priv;
> +
> +	WARN_ON(hw_req->req.n_channels > HIF_API_MAX_NB_CHANNELS);
> +	wvif->scan_req =3D hw_req;
> +	schedule_work(&wvif->scan_work);
> +	return 0;
> +}

This scan logic looks fishy to me, but no time to investigate in detail.
Though not a blocker.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
