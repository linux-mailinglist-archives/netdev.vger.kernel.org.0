Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA7546F5FD
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 22:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhLIVhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 16:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhLIVhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 16:37:25 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AF6C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 13:33:51 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id q16so6231743pgq.10
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 13:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=58WqpZVC9LkD3yWfFlckUYmfeujiGWI9re0jm1Cx3oU=;
        b=QXn+0CeujQ7LF6a5BjMkzgYI4/soCq4HfpojGAoZedb2X3nTtpmVba0kofhDI8WTIk
         J2A50lCTDjKiDoFzbc365iPZLmqYJl4FQQVNwhN7E7RDmAMEe3HLVaWUeS06SJW9brfZ
         PNVv1J652XZXB6qQIlmDz74ifbPqCYgfdK7MhW0lTwryvAconNXsLW/ZU9Dvazac+ASC
         Slj61Z23iBHDDLxd2ds17VPJMHzKiK/aNXNC73ol9emwtN/XB0Ts28ZZCrPQ0u10t9SV
         O/vKuSn6bP5MAbjnaXeYkXjHelLkv50EtrZ2zAkegiGs6Nf3wahEk7/RUGg9bFgRNUQb
         Zk9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=58WqpZVC9LkD3yWfFlckUYmfeujiGWI9re0jm1Cx3oU=;
        b=xLue8RHvf2z2n4dgCFZ8i8Q5AZDz4v8LD/Kr+kInvLqS/VNwq+6DNnPjByBaLJTNwA
         T0FIZFUe1S9FjDmCx3slfPinKqwUeCW/JY6VHdZYJ2UQD2DHeWeQhEtDVbhqujRVAOku
         tN0gp5qIVXLdUbOfE+FInIpLMdyETh4nsbnmP6/098+mwhOYL10iTmxo+rWYqaKx43Cm
         gOjlyX8HvAw8g/U1rEAq90CW2rUNZlqf3HyYSKAlchs4UIjWEviRiBd2Ps0zjT3F5Ttt
         QdyCedFU+9hE9onjxXxteJ+KgijsEc2Q3tMb/GdOH9zG0Kmv3JKqyrg1n4KAkWWz3mXX
         Pz2w==
X-Gm-Message-State: AOAM532S38d6uPiguk1XrpZlUva5Uj6EvWcuxVWw0UicUNuZcK2rxfgv
        jAvtfp1KqbptsUniF6dktPc=
X-Google-Smtp-Source: ABdhPJyQuDk7/CEyAPJymfCi2yqxxR4YkQRUiwCpecdF5zd+K6jm2LwPJlQKcQpckgojFnBWuGz3kg==
X-Received: by 2002:a05:6a00:2408:b0:4a8:45ef:c960 with SMTP id z8-20020a056a00240800b004a845efc960mr13827728pfh.53.1639085630793;
        Thu, 09 Dec 2021 13:33:50 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x6sm517270pga.14.2021.12.09.13.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 13:33:50 -0800 (PST)
Date:   Thu, 9 Dec 2021 13:33:47 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCHv2 net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAG_BONDED_PHC_INDEX
Message-ID: <20211209213347.GE21819@hoboy.vegasvil.org>
References: <20211209102449.2000401-1-liuhangbin@gmail.com>
 <20211209102449.2000401-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209102449.2000401-2-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 06:24:48PM +0800, Hangbin Liu wrote:

> +/* possible values for hwtstamp_config->flags */
> +enum hwtstamp_flags {
> +	/*
> +	 * With this flag, the user could get bond active interface's
> +	 * PHC index. Note this PHC index is not stable as when there
> +	 * is a failover, the bond active interface will be changed, so
> +	 * will be the PHC index.
> +	 */
> +	HWTSTAMP_FLAG_BONDED_PHC_INDEX = (1<<0),
> +
> +	/* add new constants above here */
> +	__HWTSTAMP_FLAGS_CNT
> +};

I think this shouldn't be an enumerated type, but rather simply a bit
field of independent options.

Thanks,
Richard
