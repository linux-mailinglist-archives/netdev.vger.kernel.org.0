Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2545B46D6CF
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235912AbhLHPX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbhLHPX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:23:58 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BDBC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 07:20:26 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id l64so2312185pgl.9
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 07:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iqRFLZBH3sa6uz1YIRiEJTbCGGXNUi72xzKwEG025BI=;
        b=clxJF52G0IPCIC/JVTbtAMGHbpC8DbopFYaAMAlrjCwZgljgRmZpa2JxYTh81Qteuj
         +ZJ/sKmIq2OcAkU9qNCkFTC1JlTghkh09s2HLPj/2lWQfX74o99T7N/Bep5pfNpuCeN9
         VJ/rW/7Wk//b/jNpJ33HIH2QQalZ2yZVqGZNmRAsGoEOZF6ZBIWjFHf4ER0NtIFdgDLj
         pvT7yK6dvcuXSX65cjLQIiUvi/IW2viFNs7F9JOTHw288YFA2Y2hHoSvST7y6vHM1tSd
         yVL7G9vZSwdQQQqROH1g6MDleuZwZCg+Lbhu/eE9Ypfojnlh1gJh78L3SmXMh0yymADk
         hYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iqRFLZBH3sa6uz1YIRiEJTbCGGXNUi72xzKwEG025BI=;
        b=eHd61Zo7sKwa8Kf6UCTG0demjehn02oiBf7HtOmlNyW7ELDqEJeqU2b2YHJWUvXJR2
         ggv/9KyzCoUw+B9EAIDbupXmRLPS7mgy+A8/NEBPwJFU27QYsoQanv4TjZUtd/HRqWcd
         x/ycuhHYVK6NkDAqalXAn1fBNEZheSVW6XWUHD6nbtaITlr1WssTMS1wgcyLAeCtqTBw
         qpWReCGzO6Eze2NKNzISbTYheo09Ke+HacIzGW9edrSrOpblMitHMGdxDtvPBeMGQJtf
         e+VrFYc/dhQKFz6zLOQShYcSqH3wheRsDNNqeT3fotB+pDMUhygWRk7evvizXoNgNFwT
         lCNw==
X-Gm-Message-State: AOAM532fwgffiBUfIxy3b1yzf/Kejq/ls5v/UwTsqZoCz+PhuPQVsoVn
        ysG43ia1mfxY1l1EIsOdlLPebQRTqUY=
X-Google-Smtp-Source: ABdhPJyxnwl5hRWs1+Q87qDPTE1otCXshwpP+FzlymmoqbcPwIHWf95Ll5wEosUwH3Mm8uvvQCnGVg==
X-Received: by 2002:aa7:8b07:0:b0:4a4:d003:92a9 with SMTP id f7-20020aa78b07000000b004a4d00392a9mr6080770pfd.61.1638976825837;
        Wed, 08 Dec 2021 07:20:25 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id o22sm4096577pfu.45.2021.12.08.07.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 07:20:25 -0800 (PST)
Date:   Wed, 8 Dec 2021 07:20:22 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAGS_UNSTABLE_PHC
Message-ID: <20211208152022.GB18344@hoboy.vegasvil.org>
References: <20211208044224.1950323-1-liuhangbin@gmail.com>
 <20211208044224.1950323-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208044224.1950323-2-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
> index fcc61c73a666..d3aaab8396ef 100644
> --- a/include/uapi/linux/net_tstamp.h
> +++ b/include/uapi/linux/net_tstamp.h
> @@ -62,7 +62,7 @@ struct so_timestamping {
>  /**
>   * struct hwtstamp_config - %SIOCGHWTSTAMP and %SIOCSHWTSTAMP parameter
>   *
> - * @flags:	no flags defined right now, must be zero for %SIOCSHWTSTAMP
> + * @flags:	one of HWTSTAMP_FLAGS_*

Nit: should be FLAG (singular) not FLAGS.
1 bit set -> 1 flag enabled

>   * @tx_type:	one of HWTSTAMP_TX_*
>   * @rx_filter:	one of HWTSTAMP_FILTER_*
>   *
> @@ -78,6 +78,19 @@ struct hwtstamp_config {
>  	int rx_filter;
>  };
>  
> +/* possible values for hwtstamp_config->flags */
> +enum hwtstamp_flags {
> +	/*
> +	 * With this flag the user should aware that the PHC index
> +	 * get/set by syscall is not stable. e.g. the phc index of
> +	 * bond active interface may changed after failover.
> +	 */
> +	HWTSTAMP_FLAGS_UNSTABLE_PHC = (1<<0),

Can we please find a different name?  I see this, and I think,
"unstable ptp hw clock".  Nobody would want to use such a clock.

How about HWTSTAMP_FLAG_BONDED_PHC_INDEX ?

> +	/* add new constants above here */
> +	__HWTSTAMP_FLAGS_CNT
> +};

I guess that the original intent of hwtstamp_config.flags was for user
space to SET flags that it wanted.  Now this has become a place for
drivers to return values back.  Please make the input/output
distinction clear in the comments.

Thanks,
Richard

