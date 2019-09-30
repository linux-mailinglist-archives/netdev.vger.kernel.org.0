Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0F3C2AF2
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfI3Xct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:32:49 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36652 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3Xct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:32:49 -0400
Received: by mail-qk1-f195.google.com with SMTP id y189so9480510qkc.3
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 16:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=y79wprhrF5YCHHmipuFUPKU5FD+RilKXQX4DkeF0tac=;
        b=YxM7ylKYaHP9twiA82JKRFPi9AM0dOFFEsyYLM+wOwfAkMeFWCQaRcUJL1y+GwQuZr
         eJ0HkUuYpAUgYMmE0bj+wFsm2xUeJYV4OG+VQOKCYpG7Vt5xiF6VFlk4lqulIR0yy91T
         I3dtr60G3PXWUPh2DbVWueQDSf9HvEBFxZktAuJyhDERnNws6FTb9XS+Y7os4i8IZ4li
         NVGwUBYOSVw6hvbJ3v91wn4VRbHeXDMRGctF95YJFS3IoCEzDlJ07UmvvH1qkGI4JyKp
         S//ahmeUURWcT/qDGFINVgsGkiuMUOWXuvGjsF0saG9TtKW24UFgjVCWD0Z5BjvYAO3J
         XyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=y79wprhrF5YCHHmipuFUPKU5FD+RilKXQX4DkeF0tac=;
        b=BxIOfY4bGlRYO0D9Bleh1rv4N5m5xFgqWganOTGBv+xLnVpJ/BO9YE7obyw6Kc6Io4
         JQjuyI7TQve9LWj/P00v8ZXyFeguyNhnq0nd4/AnMs71PpSE4LZ+g5BKfYdykOl/Jsas
         7r8T1j/dr7fPUompA5hKbDt8F4OR4YqRaxZ0kmmChCjAiwJ/oMCANHfCGJgme5QIOL5O
         gbcrauQB5xZeB+IfnEMl6RwJAIJb800x4U/YNfqyLJyiQCC4a+cQ1PfxKX7N0pcgXyb7
         9AJYV/5oUm0ZBCyps7Y8+DhrLRzduCf/B6t/P8XWSLFcR2Gquo/0/+C7OuUoH9G2Ffpq
         LV5Q==
X-Gm-Message-State: APjAAAVCsQWyNGEaYjH2Ptc5/qzEp/dilhnDxm6A28Dh0RimS5SSxNTf
        GZHLXpxKPK6ep1FY4v641wTwSQ==
X-Google-Smtp-Source: APXvYqyMD7n8CZSdFsxsumt0r+5x22ezKRoRZodBkkyfHXx5olTTMWEVHbsbCNRvGTDZ3p972nBjgQ==
X-Received: by 2002:a37:a24f:: with SMTP id l76mr2938399qke.91.1569886368462;
        Mon, 30 Sep 2019 16:32:48 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p77sm7159657qke.6.2019.09.30.16.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 16:32:48 -0700 (PDT)
Date:   Mon, 30 Sep 2019 16:32:45 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 5/5] ionic: add lif_quiesce to wait for
 queue activity to stop
Message-ID: <20190930163245.540577ea@cakuba.netronome.com>
In-Reply-To: <20190930214920.18764-6-snelson@pensando.io>
References: <20190930214920.18764-1-snelson@pensando.io>
        <20190930214920.18764-6-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Sep 2019 14:49:20 -0700, Shannon Nelson wrote:
> Even though we've already turned off the queue activity with
> the ionic_qcq_disable(), we need to wait for any device queues
> that are processing packets to drain down before we try to
> flush our packets and tear down the queues.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

This one, in turn, seems like something that could cause
unpleasantness, and therefore Fixes: could be specified :)

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 372329389c84..fc4ab73bd608 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -242,6 +242,29 @@ static int ionic_qcq_disable(struct ionic_qcq *qcq)
>  	return ionic_adminq_post_wait(lif, &ctx);
>  }
>  
> +static int ionic_lif_quiesce(struct ionic_lif *lif)

Possibly static void?  As with most cleanup functions there isn't much
caller can do with the error..

> +{
> +	int err;

reverse xmas tree

> +	struct device *dev = lif->ionic->dev;
> +	struct ionic_admin_ctx ctx = {
> +		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
> +		.cmd.lif_setattr = {
> +			.opcode = IONIC_CMD_LIF_SETATTR,
> +			.attr = IONIC_LIF_ATTR_STATE,
> +			.index = lif->index,
> +			.state = IONIC_LIF_DISABLE
> +		},
> +	};
> +
> +	err = ionic_adminq_post_wait(lif, &ctx);
> +	if (err) {
> +		dev_err(dev, "failed to quiesce lif, error = %d\n", err);
> +		return err;
> +	}
> +
> +	return (0);

no parens needed here

> +}
> +
>  static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
>  {
>  	struct ionic_dev *idev = &lif->ionic->idev;
> @@ -1589,6 +1612,7 @@ int ionic_stop(struct net_device *netdev)
>  	netif_tx_disable(netdev);
>  
>  	ionic_txrx_disable(lif);
> +	ionic_lif_quiesce(lif);
>  	ionic_txrx_deinit(lif);
>  	ionic_txrx_free(lif);
>  

