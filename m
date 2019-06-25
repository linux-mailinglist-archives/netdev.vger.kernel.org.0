Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A8855CA7
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfFYXyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:54:16 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39766 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFYXyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:54:16 -0400
Received: by mail-qt1-f196.google.com with SMTP id i34so447042qta.6
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=BQxDrnYUpRl/KXi6qqn/2eISXeCkfJcQQcNrVz9yqP4=;
        b=VPpae+u2GvYP0vPU/JHlO+qeTlgI2se/rFM/Oe2+2fTfdTxdj4A8HEUIaRzxuO2cKf
         lY0S3jEzQ1Mf2azUwaN6fsaR57ZTHtdJ0L48B+uQj+qDf/pTxOsfG/9sto8EYS0S5bFS
         qsY08OjUh9ftZzap/9Mn8h77Y2Vq+Yqi0JzqK0SFaj2jGhsvwDpmrPLCu/axwSFiwrlF
         XOGmerTFqCV9qAvndUO/xr/Hi6p+vVq+Jk39xbj1TwYnL0dZS3mBpRAhLP5nMy++9kDx
         acYo98DQ11FnofCObc50DTMdcV5dKqv9GvjYDhMQeb3VmRU5AiubdSSU6LfkzY3NINvx
         vHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=BQxDrnYUpRl/KXi6qqn/2eISXeCkfJcQQcNrVz9yqP4=;
        b=BWpXpMyeUH24GRhBOekvBHmuoiCbfMAkh9UNfSGaaacwUzZ+H8g3upIPvYQ1wvOehn
         sX3YLCrcUr/wL9kYFekDEKcQ7Q10AtAMbfbwaqGbFOzV7re3C79AN7saN1Q6EVPwJtmb
         tEFcK1lQxFIxwybpeFq7dOo1sjuhugj9EiOyvyk39ctksD/ID8oWmKB3rsUTP0/I9oW7
         FX3A+rLU7Hso3aSBBdK7kySUOMF9LLFcaIQ37IehbtIlFVYe1rizE+hK13b/opExGO9j
         167fG9Bg4s+orqMuAPaF0zppdLtp1Ov5zifFmd/kxqMrRYqhqyRkvzrd2fGND3gThx3Q
         PA7A==
X-Gm-Message-State: APjAAAXJui9pgjDVcmNMnfvbdEfU0ONSKMmp+3iGNtlwaH4ChkV5xSbP
        yYOeFfHgv3OEZsWQe6TBvD/80g==
X-Google-Smtp-Source: APXvYqwnPNdzYEvQLK/yUdSQr7v01ExY+D1WrbHsJ0OwNK+Ik7MxCIo/2fmeu+M+erSLJz1dBUsrVw==
X-Received: by 2002:ac8:70cf:: with SMTP id g15mr986928qtp.254.1561506855627;
        Tue, 25 Jun 2019 16:54:15 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o63sm7636691qkb.106.2019.06.25.16.54.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 16:54:15 -0700 (PDT)
Date:   Tue, 25 Jun 2019 16:54:12 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 13/18] ionic: Add initial ethtool support
Message-ID: <20190625165412.0e1206ce@cakuba.netronome.com>
In-Reply-To: <20190620202424.23215-14-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-14-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 13:24:19 -0700, Shannon Nelson wrote:
> +	running = test_bit(LIF_UP, lif->state);
> +	if (running)
> +		ionic_stop(netdev);
> +
> +	lif->ntxq_descs = ring->tx_pending;
> +	lif->nrxq_descs = ring->rx_pending;
> +
> +	if (running)
> +		ionic_open(netdev);
> +	clear_bit(LIF_QUEUE_RESET, lif->state);

> +	running = test_bit(LIF_UP, lif->state);
> +	if (running)
> +		ionic_stop(netdev);
> +
> +	lif->nxqs = ch->combined_count;
> +
> +	if (running)
> +		ionic_open(netdev);
> +	clear_bit(LIF_QUEUE_RESET, lif->state);

I think we'd rather see the drivers allocate/reserve the resources
first, and then perform the configuration once they are as sure as
possible it will succeed :(  I'm not sure it's a hard requirement, 
but I think certainly it'd be nice in new drivers.
