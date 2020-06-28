Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8A420CA50
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 22:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgF1UQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 16:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgF1UQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 16:16:20 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33175C03E97A
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 13:16:20 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 207so6799221pfu.3
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 13:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+7G1cJiL1IaJ+/+KocmI0bkRGjYWF6YUbbOVAYsF63s=;
        b=p8g0DnAnbblnRq6Uq4Hsbr0IiZTuN2Rp65mtL+hgMHWaxsoGSb00VsNX5CczW4oA1F
         IsV2y/l6REPdK8oUxv1WWuYhu3ihH5vrZ9kN88u5IWlDNNgn2VyUqPjho7sL5pgEFOYo
         Q7SzlRUysBH3GI6t/EH6Weo1053EgNGy83WuIypjNG8BONmsspnozk3rwODuFRw6u5zE
         b7/1lwJNdS2ScMuyr8eE4mF7PRkuk1cG2h6h0MBjIxZHNIwPrO1voUM8f98ktxkGh1/s
         OUdZvXsZYGKRCh+Q4fdLI7rJuBwe/ahroTZr8vPFsPCojtkxJZuXJqhtXj4abU8/9ARt
         OPDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+7G1cJiL1IaJ+/+KocmI0bkRGjYWF6YUbbOVAYsF63s=;
        b=RpDE0GRQcUEXzt45usd392ERfbdSbgaKmrb/7tWR8zsggc2Q9b57OZma9FD4v5DVD2
         iJR2hEoIAlBYPLQ7iLai19YU+ZgkeYJvwEC7sVxbE7EtPD0bfPSl7IeLdnG8VLbkL/WW
         75jM38RiBlIZdkfF8Cx5Isx5vcU8JhxIY3wrpW5x2Lm+DPMllUy9hGegNL8GWPMp7GcL
         FbTSCHIRsPiSS7Yytkzp/Piw5bCNUJKjd02VPk5eElI4ZN8SJ30KrsIvWvXx9FjV6Kqy
         df97byw6nt2UpHHiRZZlFcfOQjg2nIYHap1nDmvbiEouS04gkjgj8T11aKP0HfHGzTIG
         Uefw==
X-Gm-Message-State: AOAM532z3OhY1wjqkWb/W9c2M9g7SvSd5tgS8bQ3HY4dARuQBPdIRATI
        2Tw0qr7lxhpKSiAvMislmKMc7w==
X-Google-Smtp-Source: ABdhPJyKqEy1028f1nQBTUzdkcwC6jZKH1WucOTYeo7/JSpqsOCcC4rMkiR51RJy5ARn7vKrtgK6kg==
X-Received: by 2002:a63:d317:: with SMTP id b23mr7563957pgg.132.1593375379539;
        Sun, 28 Jun 2020 13:16:19 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s9sm27793405pgo.22.2020.06.28.13.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 13:16:19 -0700 (PDT)
Date:   Sun, 28 Jun 2020 13:16:11 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Po Liu <po.liu@nxp.com>
Cc:     dsahern@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        vlad@buslov.dev, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com
Subject: Re: [iproute2-next] action police: make 'mtu' could be set
 independently in police action
Message-ID: <20200628131611.48a07e81@hermes.lan>
In-Reply-To: <20200628014602.13002-1-po.liu@nxp.com>
References: <20200628014602.13002-1-po.liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Jun 2020 09:46:02 +0800
Po Liu <po.liu@nxp.com> wrote:

> Current police action must set 'rate' and 'burst'. 'mtu' parameter
> set the max frame size and could be set alone without 'rate' and 'burst'
> in some situation. Offloading to hardware for example, 'mtu' could limit
> the flow max frame size.
> 
> Signed-off-by: Po Liu <po.liu@nxp.com>
> ---
>  tc/m_police.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tc/m_police.c b/tc/m_police.c
> index a5bc20c0..89497f67 100644
> --- a/tc/m_police.c
> +++ b/tc/m_police.c
> @@ -161,8 +161,8 @@ action_ctrl_ok:
>  		return -1;
>  
>  	/* Must at least do late binding, use TB or ewma policing */
> -	if (!rate64 && !avrate && !p.index) {
> -		fprintf(stderr, "\"rate\" or \"avrate\" MUST be specified.\n");
> +	if (!rate64 && !avrate && !p.index && !mtu) {
> +		fprintf(stderr, "\"rate\" or \"avrate\" or \"mtu\"MUST be specified.\n");

Missing blank.
Your message will come out as:
"rate" or "avrate" or "mtu"MUST be specified.


The quotes aren't adding to the readability, why not just remove them instead.
