Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 616D855C8A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfFYXpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:45:00 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41026 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFYXpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:45:00 -0400
Received: by mail-qt1-f193.google.com with SMTP id d17so415319qtj.8
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=W9xtp9KDae2fYNYQEKGY9AweOZeDMV4rTR6kQmSuty8=;
        b=LpqQkEhtDvUPizcsFVRFFPzfwtSr9PoaM1naJBzrpDpP23HLmKmg7jxgqzQeznnR5G
         +kz1P/7bij85Sp5BU/nMzYnts2bKqvbJmPZHUOR2LVDU3AnyUvFxa6aZiXCgEbjYh8lS
         xSknFsd41p2bd1cGtMPlkieZ8gKEPKhwLwJmybYmGTQXZyFYS/iML8GeGVWq+0KOnSDt
         mZdBoLcfMn+eWWrj04nH3ouz6leEbOAILEQXMlBaPCpDMo6WHL6e3RFjl7/un2IgcTOh
         kaRmHNU7TxogpBesXK1SKA04WYNXNp+gaJ5xBcvJedyOQIzg8TOnKDLTy8LdCLpSVsGW
         1MWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=W9xtp9KDae2fYNYQEKGY9AweOZeDMV4rTR6kQmSuty8=;
        b=LIVsLj4/jq1GvuJDgQNqMzbrx9Qzd5RLKcROTBBFeSL+Cv/So6O7lbvP5FYYD+EcSw
         x1vyv+k/yhT7+AAxJ3BcFKIhGrIDsDvFjcbjxv87dLmHP4D1zXNrWZf2MY8+VD1BEpCG
         rbeNTYroVIOoRGu5mOk+rV2aPMfSz5xGSCthSwI+EsNiAl+zaP5bnDmPZEfQZaxrY6VU
         9ECQHmJx5JRTT+XbffHLeKvQmwpd0XHYdpdVMXVHa/jKLZa6W1qc5cGLdM3f/E5x6+03
         9iFmYH/umnMZLUnzddXLGMbWQ9apiGbueKVsHIbPpK/OioUCQtRPgg1+AgStjCmPpqvp
         wY6Q==
X-Gm-Message-State: APjAAAU6FeSQXNe5TLxz8o8q99b7sf2rEKGxCtpaf0uoVfZefylYuSPl
        /8V+ETMgT+B90aRzV2DiuOxij15Iuqs=
X-Google-Smtp-Source: APXvYqy1aww/4MMHCTvuVWvecp5CSrAsVpp58EiKn2mpGY0m14YvBDo0TELO5YxkjF7Yxx7t7bKtVw==
X-Received: by 2002:ac8:5311:: with SMTP id t17mr973287qtn.304.1561506299539;
        Tue, 25 Jun 2019 16:44:59 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s8sm7614428qkg.64.2019.06.25.16.44.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 16:44:59 -0700 (PDT)
Date:   Tue, 25 Jun 2019 16:44:56 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 11/18] ionic: Add Rx filter and rx_mode nod
 support
Message-ID: <20190625164456.606dd40a@cakuba.netronome.com>
In-Reply-To: <20190620202424.23215-12-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-12-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 13:24:17 -0700, Shannon Nelson wrote:
> Add the Rx filtering and rx_mode NDO callbacks.  Also add
> the deferred work thread handling needed to manage the filter
> requests otuside of the netif_addr_lock spinlock.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

>  static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
>  				  u16 vid)
>  {
> -	netdev_info(netdev, "%s: stubbed\n", __func__);
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic_admin_ctx ctx = {
> +		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
> +		.cmd.rx_filter_del = {
> +			.opcode = CMD_OPCODE_RX_FILTER_DEL,
> +			.lif_index = cpu_to_le16(lif->index),
> +		},
> +	};
> +	struct rx_filter *f;
> +	int err;
> +
> +	spin_lock_bh(&lif->rx_filters.lock);
> +
> +	f = ionic_rx_filter_by_vlan(lif, vid);
> +	if (!f) {
> +		spin_unlock_bh(&lif->rx_filters.lock);
> +		return -ENOENT;
> +	}
> +
> +	netdev_dbg(netdev, "rx_filter del VLAN %d (id %d)\n", vid,
> +		   le32_to_cpu(ctx.cmd.rx_filter_del.filter_id));
> +
> +	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
> +	ionic_rx_filter_free(lif, f);
> +	spin_unlock_bh(&lif->rx_filters.lock);
> +
> +	err = ionic_adminq_post_wait(lif, &ctx);
> +	if (err)
> +		return err;
> 
>  	return 0;

nit: return directly?

>  }

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> index 8129fa20695a..c3ecf1df9c2c 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> @@ -60,6 +60,29 @@ struct qcq {
>  #define napi_to_qcq(napi)	container_of(napi, struct qcq, napi)
>  #define napi_to_cq(napi)	(&napi_to_qcq(napi)->cq)
>  
> +enum deferred_work_type {
> +	DW_TYPE_RX_MODE,
> +	DW_TYPE_RX_ADDR_ADD,
> +	DW_TYPE_RX_ADDR_DEL,
> +	DW_TYPE_LINK_STATUS,
> +	DW_TYPE_LIF_RESET,
> +};
> +
> +struct deferred_work {

If you don't mind prefixing these structures with ionic_ that'd be
great.  I'm worried deferred_work is too close to delayed_work..

> +	struct list_head list;
> +	enum deferred_work_type type;
> +	union {
> +		unsigned int rx_mode;
> +		u8 addr[ETH_ALEN];
> +	};
> +};
> +
> +struct deferred {
> +	spinlock_t lock;		/* lock for deferred work list */
> +	struct list_head list;
> +	struct work_struct work;
> +};
