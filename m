Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA8B353A28
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 01:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhDDXlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 19:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhDDXlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 19:41:16 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC880C061756
        for <netdev@vger.kernel.org>; Sun,  4 Apr 2021 16:41:10 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 11so5401432pfn.9
        for <netdev@vger.kernel.org>; Sun, 04 Apr 2021 16:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rUJiui9YG3nZXK2YeLPdqyNf9jZ1rQnEZD3irUCtHxk=;
        b=boWvko9795EbIP1Mk2VHMijD/OhENwj6CJUvPRqi0J0i3waabTYD2+PyrFzcQKWgnX
         kIBx5UX9z0I2cjrdwOS/bJYns4um8hbIRl7Zg9p7ukXWVPlOBoS4zmB3QmDYOxHtZQ4D
         hI/enVIPjPu2thzep3c8vB6XdR35HpoxYMBKMC6e8R/1gC5PBdp/GidlmHFMUfEAZVo0
         2aAni0i4rYLZ3/8EXIeTQXXmnSP35/tfIxizHvZY/iispn4YtHio+caL7DmtgOCrJ3Cg
         ZjJc7JnXnsUX05JBV9fQlJ/tPINayI8SqcduJRIW9PwJEM3VX+BmX7pZUnlqHvR1E2qg
         VFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rUJiui9YG3nZXK2YeLPdqyNf9jZ1rQnEZD3irUCtHxk=;
        b=N7vD3oozg5XH9uXohgwykNNzCMPo0O4NM+BOZKVfAAKY4VnguxoKdTCYc6IQNtHooH
         m8fBky8/kLfxI+TOEM2yt6PUHdCqr7RScCHPJcyl2QdF9LMIKK4Pwh5SVnHWRW4ebYj7
         bzMju8UpT4dr4TbmwDgBt6HCoUuuP/bwR/bWrPvvJaB8x0Qa++HS/E2za9TrvS3WT4BU
         gmZ0253oT98UfXZcgsR/hgcWaMGIxCQq9dgO0ux6/UjtAsjq3e8AZTvWwEjXrT/aHvmo
         lQZfVkkOavUBEAzXvzcf+xLh8CYNuvcoEv/b3jdDhZaDkKnaeevpRYPub4AvqtENt0Xg
         qekA==
X-Gm-Message-State: AOAM5315coRizlIqhJSnPZU17BaU0rW3E3w0OySnFMV19LPF4wzEB1w7
        snbPareftsgTZvm8/iqG0oQ=
X-Google-Smtp-Source: ABdhPJwSs1NeJnqGtku3ZoKrkIEXehhNtYnlH1V/M7fUyJf5435W26k/aDgiv2IMKI6Cmi97uMxo4Q==
X-Received: by 2002:aa7:960c:0:b029:1fa:8cbb:4df4 with SMTP id q12-20020aa7960c0000b02901fa8cbb4df4mr21036528pfg.12.1617579670417;
        Sun, 04 Apr 2021 16:41:10 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s17sm13758340pfc.53.2021.04.04.16.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 16:41:09 -0700 (PDT)
Date:   Sun, 4 Apr 2021 16:41:07 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
Subject: Re: [PATCH net-next 09/12] ionic: add and enable tx and rx timestamp
 handling
Message-ID: <20210404234107.GD24720@hoboy.vegasvil.org>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-10-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401175610.44431-10-snelson@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 10:56:07AM -0700, Shannon Nelson wrote:

> @@ -1150,6 +1232,10 @@ netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
>  		return NETDEV_TX_OK;
>  	}
>  
> +	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
> +		if (lif->hwstamp_txq)
> +			return ionic_start_hwstamp_xmit(skb, netdev);

The check for SKBTX_HW_TSTAMP and hwstamp_txq is good, but I didn't
see hwstamp_txq getting cleared in ionic_lif_hwstamp_set() when the
user turns off Tx time stamping via the SIOCSHWTSTAMP ioctl.

In addition, the code should set

	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;

once the above tests pass.

Thanks,
Richard


