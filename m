Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E1743E0A5
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhJ1MQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:16:54 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50278 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhJ1MQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 08:16:53 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DD4AA1FD53;
        Thu, 28 Oct 2021 12:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635423265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3E7wkRJp91MKjK1zSRVHtFUse8VULFkLnWAwqt+tOU=;
        b=h00ymuW0J36OBNpp5TDQG2drxGIjwsWQwk1DtOLEnvbZJHg5OmxlJseSUd1opoL2qjYfln
        W0uKNXOqaujxpSihFkMFJ8nZ2lgwLuxN4ttxpfJSJZm+IgoFujignT0gXFNBKroaFDgNy+
        HTPzbS8tY8EJP/DcfXAMohwGxGqkjH8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635423265;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3E7wkRJp91MKjK1zSRVHtFUse8VULFkLnWAwqt+tOU=;
        b=0rvApIq8a4o3k783acr29655BKyqavq+u45qpDkAy7SZyOslxOt6li+h1mlXlYCDZ8qSuv
        Hu8pUTgrVmr22+DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0C44B13CFD;
        Thu, 28 Oct 2021 12:14:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YoUUACGUemGDXQAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Thu, 28 Oct 2021 12:14:24 +0000
Subject: Re: [PATCH] mwifiex: Add quirk to disable deep sleep with certain
 hardware revision
To:     =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tsuchiya Yuto <kitakar@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
References: <20211028073729.24408-1-verdre@v0yd.nl>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <0123bb9b-7c66-9197-94dd-d96e226f439f@suse.de>
Date:   Thu, 28 Oct 2021 15:14:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211028073729.24408-1-verdre@v0yd.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



10/28/21 10:37 AM, Jonas Dreßler пишет:
> The 88W8897 PCIe+USB card in the hardware revision 20 apparently has a
> hardware issue where the card wakes up from deep sleep randomly and very
> often, somewhat depending on the card activity, maybe the hardware has a
> floating wakeup pin or something.
> 
> Those continuous wakeups prevent the card from entering host sleep when
> the computer suspends. And because the host won't answer to events from
> the card anymore while it's suspended, the firmwares internal
> powersaving state machine seems to get confused and the card can't sleep
> anymore at all after that.
> 
> Since we can't work around that hardware bug in the firmware, let's
> get the hardware revision string from the firmware and match it with
> known bad revisions. Then disable auto deep sleep for those revisions,
> which makes sure we no longer get those spurious wakeups.
> 
> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
> ---
>   drivers/net/wireless/marvell/mwifiex/main.c      | 14 ++++++++++++++
>   drivers/net/wireless/marvell/mwifiex/main.h      |  1 +
>   .../net/wireless/marvell/mwifiex/sta_cmdresp.c   | 16 ++++++++++++++++
>   3 files changed, 31 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index 19b996c6a260..5ab2ad4c7006 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -226,6 +226,19 @@ static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
>   	return 0;
>   }
>   
> +static void maybe_quirk_fw_disable_ds(struct mwifiex_adapter *adapter)
> +{
> +	struct mwifiex_private *priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
> +	struct mwifiex_ver_ext ver_ext;
> +
> +	set_bit(MWIFIEX_IS_REQUESTING_FW_VEREXT, &adapter->work_flags);
> +
> +	memset(&ver_ext, 0, sizeof(ver_ext));
> +	ver_ext.version_str_sel = 1;
> +	mwifiex_send_cmd(priv, HostCmd_CMD_VERSION_EXT,
> +			 HostCmd_ACT_GEN_GET, 0, &ver_ext, false);
> +}
> +
>   /*
>    * The main process.
>    *
> @@ -356,6 +369,7 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
>   			if (adapter->hw_status == MWIFIEX_HW_STATUS_INIT_DONE) {
>   				adapter->hw_status = MWIFIEX_HW_STATUS_READY;
>   				mwifiex_init_fw_complete(adapter);
> +				maybe_quirk_fw_disable_ds(adapter);
>   			}
>   		}
>   
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> index 90012cbcfd15..1e829d84b1f6 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.h
> +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> @@ -524,6 +524,7 @@ enum mwifiex_adapter_work_flags {
>   	MWIFIEX_IS_SUSPENDED,
>   	MWIFIEX_IS_HS_CONFIGURED,
>   	MWIFIEX_IS_HS_ENABLING,
> +	MWIFIEX_IS_REQUESTING_FW_VEREXT,
>   };
>   
>   struct mwifiex_band_config {
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> index 6b5d35d9e69f..8e49ebca1847 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> @@ -708,6 +708,22 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
>   {
>   	struct host_cmd_ds_version_ext *ver_ext = &resp->params.verext;
>   
> +	if (test_and_clear_bit(MWIFIEX_IS_REQUESTING_FW_VEREXT, &priv->adapter->work_flags)) {
> +		if (strncmp(ver_ext->version_str, "ChipRev:20, BB:9b(10.00), RF:40(21)", 128) == 0) {
> +			struct mwifiex_ds_auto_ds auto_ds = {
> +				.auto_ds = DEEP_SLEEP_OFF,
> +			};
> +
> +			mwifiex_dbg(priv->adapter, MSG,
> +				    "Bad HW revision detected, disabling deep sleep\n");
> +
> +			mwifiex_send_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
> +					 DIS_AUTO_PS, BITMAP_AUTO_DS, &auto_ds, false);
> +		}
> +
> +		return 0;
> +	}

mwifiex_send_cmd() may return an error

> +
>   	if (version_ext) {
>   		version_ext->version_str_sel = ver_ext->version_str_sel;
>   		memcpy(version_ext->version_str, ver_ext->version_str,
> 
