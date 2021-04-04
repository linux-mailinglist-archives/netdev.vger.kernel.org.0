Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7658B353A19
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 00:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhDDWu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 18:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhDDWu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 18:50:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0262C061756
        for <netdev@vger.kernel.org>; Sun,  4 Apr 2021 15:50:52 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j7so137942plx.2
        for <netdev@vger.kernel.org>; Sun, 04 Apr 2021 15:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=X8s/Q23zMV87G84/j0F5ov7kW8qmVB3ldz4oEbAtaSk=;
        b=aRY/BodJmpCPefwz8iuSR7S3kS6TGVbQo6TM2xyDlwn+uYHPS5ypsm4V0ZC0C+56/I
         WQQ5oK6rUiBNZuWXXLvM6mr2dZHv0VZbdAUlhFpKmRV/0MGME3ozko41fa78FlF45Wqi
         pwhvH5KntCPWpl+TnAThvghdmbRfyteUaVpZbLu2bzvfqnCfS3B/UY+FIWSncuTWrnIo
         UQ4UuRo0fLGHgfAfSRjA7NfGgOQab4BlkGUIP4XM8sG9yg1Jsje1i3p4OEYhDOENkVMQ
         KoI+2bMFfFB/xowPFKXQRZyEjFzgMZCrTksxzcg2tcyXY0HH7aqB5Fj77R0XNqfEbW5Q
         7yzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=X8s/Q23zMV87G84/j0F5ov7kW8qmVB3ldz4oEbAtaSk=;
        b=sPO/R/XURXcKlQFzhW5Z9cyr18Gacpp9YGjkz0rq3FJVAtBFB2ZO5nKXLuzIZZ6pqX
         5w5OQ0pDb4Lm49Dt62rD5HETk8LZAgHxMftTXYSwkRnOBzXw0ag6rNXfrQ4Qqvy2OoSz
         pfEdxuP1QZdW/K5EXsTAeBUnpJigGjVCtyg2b9hz4Wk6fsdl6hgcJyRT4LDuNJNUxetd
         ZfVZ32r9v1BNVKbY3Gvk1SItkGpYsGnaSlfh0rOgK/o5ez9uHdmDnTxOHPKcnpLDRaXp
         3bUA+KugJ/vrS3mcRUyCrYXN9fFp0vL6fE27221qPan7gxbz69UwNo60QSYKwWU73//V
         y23w==
X-Gm-Message-State: AOAM530ZcPiD4hgnwtBkhe9EjH8JiBA0B1GOZuFhpuR51BB+BGJ7oKXX
        puha7TPeUVlUsD3QQQHoOgbCVls88bEUpg==
X-Google-Smtp-Source: ABdhPJzof4sfEZW5MXbmg9KsmOZvAzBB1xuHL67Ne1tf6yfJRCDINF7VvFxT0/icaDg7s/aQO8yiNw==
X-Received: by 2002:a17:90b:438a:: with SMTP id in10mr23579851pjb.165.1617576652280;
        Sun, 04 Apr 2021 15:50:52 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id d5sm13156830pjo.12.2021.04.04.15.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 15:50:51 -0700 (PDT)
Date:   Sun, 4 Apr 2021 15:50:49 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
Subject: Re: [PATCH net-next 02/12] ionic: add handling of larger descriptors
Message-ID: <20210404225049.GA24720@hoboy.vegasvil.org>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401175610.44431-3-snelson@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 10:56:00AM -0700, Shannon Nelson wrote:
> @@ -1722,11 +1722,15 @@ static void ionic_txrx_free(struct ionic_lif *lif)
>  
>  static int ionic_txrx_alloc(struct ionic_lif *lif)
>  {
> -	unsigned int sg_desc_sz;
> +	unsigned int num_desc, desc_sz, comp_sz, sg_desc_sz;
>  	unsigned int flags;
>  	unsigned int i;

Coding Style nit: List of ints wants alphabetically order,
List can also fir 'flags' and 'i' with the others.

> @@ -2246,9 +2258,9 @@ static void ionic_swap_queues(struct ionic_qcq *a, struct ionic_qcq *b)
>  int ionic_reconfigure_queues(struct ionic_lif *lif,
>  			     struct ionic_queue_params *qparam)
>  {
> +	unsigned int num_desc, desc_sz, comp_sz, sg_desc_sz;
>  	struct ionic_qcq **tx_qcqs = NULL;
>  	struct ionic_qcq **rx_qcqs = NULL;
> -	unsigned int sg_desc_sz;
>  	unsigned int flags;

Ditto.

Thanks,
Richard
