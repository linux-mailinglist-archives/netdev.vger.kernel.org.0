Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE20637645
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 11:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiKXKXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 05:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiKXKXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 05:23:05 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D3A2D2;
        Thu, 24 Nov 2022 02:22:26 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ha10so3175348ejb.3;
        Thu, 24 Nov 2022 02:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=stdCwGhL1mHRmXy8gxhkkhvFFywWZf8vqJUMKC2QRIs=;
        b=oGLkjrrOidE3YmS32GPKlogmQTBiN4XUIyC8I7bF0OYljNVDivq/a+3FS5nq0Y8TUn
         bTCI1iktkkjR1XbWWU9uZ/3boh3GzIZc8xFp2b5CQKuNU1eIy/55g+Ul9bha3C8IyhLk
         vbq+x2veJFR7JYWOf+kB058CSQx0GaF8YDf2r/ZpsE/k9Rp8bHO0qVXhMa3MEB1rtoGi
         qbf9EN/0iC5fCxgfd8VMdEqC/R9tHwTjIIdJ3PjAjvziFn0WGerYhdk6ePXjo707Se6a
         +vqPijI8JRtTErRffXO4wE4C9thHmzhywQrgzmU90EsrJglOhFTitTAMtlA4IV0nNfNd
         l0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=stdCwGhL1mHRmXy8gxhkkhvFFywWZf8vqJUMKC2QRIs=;
        b=p4Fd01cCmjpVmtmfXYCoVVHVhvSTA34huw4BqNuwrGSP/Ce0C72SA9uuTOMVFcV8/4
         XmFVlYBwH3t3raHY8TP7y4xvLVVB9mknRxZUtOBgj9Ix7GOawDdb5jw21fH6IW+nvodW
         FHilbSjoX0otoACndZrQFU0K4bSzXLVJkZx/AzaEvCxNCKpdk/ySM7JVMKhGACQAUuMQ
         pF6vS/id5W1wr89K5aGaRW9uN3Uiq6xLKCOG57DfQlsscn1+DyUBwxC+6zvYTfWJ3LLY
         nHMqFRu8hv1flZ68auemExOu8BCqCoJYN+M0LB53LNaP+qgG9zxP4wqxnH69f1VLk9dt
         jmjw==
X-Gm-Message-State: ANoB5pm5nzvJRKY2NdStGQMsJfK7OMqaxLq9YQ72zR7QGBRsHmXfveqd
        9c7p5YGdAUvolF30XE2vgXg=
X-Google-Smtp-Source: AA0mqf7C/mX/HsawCOYBF9Yqmbq+WucHlUwatJgrzcc90no4pq+9Q3VhTkrYD3eMm1WDnyO9OPW+/w==
X-Received: by 2002:a17:906:2e86:b0:7a5:f8a5:6f86 with SMTP id o6-20020a1709062e8600b007a5f8a56f86mr26183204eji.610.1669285344892;
        Thu, 24 Nov 2022 02:22:24 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id o26-20020a170906289a00b0077d37a5d401sm278357ejd.33.2022.11.24.02.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 02:22:24 -0800 (PST)
Date:   Thu, 24 Nov 2022 12:22:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, Tristram.Ha@microchip.com,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Woojung.Huh@microchip.com,
        davem@davemloft.net
Subject: Re: [RFC Patch net-next v2 3/8] net: dsa: microchip: Initial
 hardware time stamping support
Message-ID: <20221124102221.2xldwevfmjbekx43@skbuf>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
 <20221121154150.9573-4-arun.ramadoss@microchip.com>
 <20221121231314.kabhej6ae6bl3qtj@skbuf>
 <298f4117872301da3e4fe4fed221f51e9faab5d0.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <298f4117872301da3e4fe4fed221f51e9faab5d0.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 01:57:47PM +0000, Arun.Ramadoss@microchip.com wrote:
> > What's your excuse which such a horrible code pattern? What will happen
> > so bad with the packet if it's flagged with a TX timestamp request in
> > KSZ_SKB_CB(skb) at the same time as REG_PTP_MSG_CONF1 is written to?
> > 
> > Also, doesn't dev->ports[port].hwts_tx_en serve as a guard against
> > flagging packets for TX timestamps when you shouldn't?
> > 
> 
> I took this configuration template routine from other driver.

Not really a good excuse. The sja1105 driver has more hardware-specific
issues to deal with, not necessarily the same as ksz.

> Can I replace above snippet with
> 
> tagger_data->hwtstamp_set_state(dev->ds, rx_on);
> ret = ksz_ptp_enable_mode(dev, rx_on);
> if (ret)
>     return ret;

Why do you need to call hwtstamp_set_state anyway?
