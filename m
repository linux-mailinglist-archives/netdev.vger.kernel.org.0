Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21A1A2A53
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 00:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfH2WxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 18:53:16 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36540 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2WxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 18:53:16 -0400
Received: by mail-ed1-f66.google.com with SMTP id g24so5846079edu.3
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 15:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=d218oy/Eq/wy4nrulrtypuTyYY1MeZFwZXyhw9Emhb4=;
        b=LWnlAlw3ErFfCotDrzYFUXXnHNOWLQf/UvTocBelF1bCRAu9gJkamc3qDl5m8ESMvN
         +d7wZRGSkXMbYYv+zrS//JqHhtVCn8Dq6Gkucdyg9ZdhvciG1igxxBMkUrFw3CDWYiZS
         ZcxiDm29Q04b5r3542uHaxZLVS4Q2g5Y6wMSslsvbofRG+L2I+gb3yAKDOP9ewQvExVI
         5HbDivO75XCj5dhhgy5ObQ8IbNreKxAG0uYzlgLEdlRNB1royDmzMX3icwq8q6Z/dqrO
         g0KCdVrF9Cb+Ys6sPPj+2AD22xqVKeaXQq0uzSh6k1zvPRDFEIIbtYEkN+bFD0Q3sRTI
         ECDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=d218oy/Eq/wy4nrulrtypuTyYY1MeZFwZXyhw9Emhb4=;
        b=r6XS7gKajAZM6rqE3Ix3iMqcHTJNFrLGsDoKFxowJkEZCDbdU4zAgA3pC5djQT751l
         g+00D7TUbGfW1cYwx1zzOX9NguXYPTl/k00Ctkzhknkn/T7Q80g8JOOQmvXlXz3ZXdmm
         JAlIlOH1sDRESDvS+e+skEK28m+EHYdQiJnSFaI2h/JnrLJpOfzs4XVd0qa7hKhrMkv9
         qFaFjdYdKw4FaiZK4EY3Gbx/9NYg4/Lz80Op7w9yiua+OIjz7Jl/46UB1JB/Q1Hkxkx5
         zGcy4RFdjr0wgXafVJkbEvtPUY8f2OAiZ2oGerxKQL4OVh7TF3bubixD3MUFVz/Rla1Y
         tCeA==
X-Gm-Message-State: APjAAAVmnGuyWQnQrRL37h+1mQdrkli2Txd6SNRnLNsIJ4/bkAQg8vso
        vUzoTkuAqwUolQzXjR/M7FREoA==
X-Google-Smtp-Source: APXvYqy3ggdkWc3fQp/LxBtrZc+mEPac3dwERRy/Dl2E4acKMUVVjtAUCRETgC9omzG7jc019I/7kQ==
X-Received: by 2002:aa7:d80d:: with SMTP id v13mr7112902edq.168.1567119194999;
        Thu, 29 Aug 2019 15:53:14 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x42sm685196edm.77.2019.08.29.15.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 15:53:14 -0700 (PDT)
Date:   Thu, 29 Aug 2019 15:52:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v6 net-next 07/19] ionic: Add basic adminq support
Message-ID: <20190829155251.3b2d86c7@cakuba.netronome.com>
In-Reply-To: <20190829182720.68419-8-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-8-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 11:27:08 -0700, Shannon Nelson wrote:
> +static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
> +{
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	struct device *dev = lif->ionic->dev;
> +
> +	if (!qcq)
> +		return;
> +
> +	ionic_debugfs_del_qcq(qcq);
> +
> +	if (!(qcq->flags & IONIC_QCQ_F_INITED))
> +		return;
> +
> +	if (qcq->flags & IONIC_QCQ_F_INTR) {
> +		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
> +				IONIC_INTR_MASK_SET);
> +		synchronize_irq(qcq->intr.vector);
> +		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);

Doesn't free_irq() basically imply synchronize_irq()?

> +		netif_napi_del(&qcq->napi);
> +	}
> +
> +	qcq->flags &= ~IONIC_QCQ_F_INITED;
