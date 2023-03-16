Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8904E6BC5AB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 06:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjCPFb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 01:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCPFb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 01:31:26 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA241ADD8;
        Wed, 15 Mar 2023 22:31:25 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id z10so272682pgr.8;
        Wed, 15 Mar 2023 22:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678944685;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1D2l/ApEmi4Vc7ASr5HhxylYAvnIY/AdoSI+9FERZQU=;
        b=K/f2p4P9NUPLS0lJZ20qLYTenUufyg/OniKmfAqDlCtdBHEDOZuRQ0lbzbMaie/eNz
         8YKlVGxDHmObUWqqLxVFgcBR6KRqJx88vp9QkFxj2pXaczajX2ZLXDhED43MSYjYEB3T
         UowoJV5jtKAJCQDpLwzGmJWYkX3+R6ykhEcIdnTOqmbRgwtltNVndR2BGoqhFrhsY3Oc
         hpLsynrG3DAVYkiGqN+B1+4TRvZhGphvnL6h4RbJ/aj6/6sT5LwMGZ4kKSc18KWYWDX6
         1O7XY5D5S0f1FPob1LwLXZQILVl8VDb4ueceabELUUDw2jFlyUR95nchQXVmHXI+ov+C
         OHpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678944685;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1D2l/ApEmi4Vc7ASr5HhxylYAvnIY/AdoSI+9FERZQU=;
        b=2Yjuzt/douqEYSztaoPIVfmHvjb6NtdPZ4vA3L5c7KTwQjqRfF36sgBJ5ykQPJ6DxY
         v25LBVyVAVJSxf2QYwRSk57gtNqrkhe8hzC51GcBbf2o1H9+8qlwus8/8XELjhZ0nWyE
         OLWdJISYFtMlEsl6BHyH5hLZ6vNfEuj8HjS+j5k3WZ2kAvvbf4rYBKqc5liU/uhYgicq
         QTdtpLE3CBwqdhk2kN420pCfTOC3E+MMnls+NxGmmSj9XFo4Lg+V4IrRWM3tRV9nN8Vk
         LNR84xkuJnGQMe/vVwEKZy2tbK4l1ylnzr78araxWGJJpgSchyQaZD1nayC6bhgK0JgM
         dyaw==
X-Gm-Message-State: AO0yUKUitcaC4Gi64O8w2rDpIg3MgJSZu3m1zh0LbgNffl1q4jeauMMG
        UtVfBQY3mm1BGGM+FSO+IZg=
X-Google-Smtp-Source: AK7set/x3+XLRUUYU1rCCTGxvlsUqRR8pRCGNsPKH8X+UTq8LSVHqpTQ5OtFM91YHyKl4Pea4GQr4g==
X-Received: by 2002:aa7:9826:0:b0:5a9:bf42:fcc5 with SMTP id q6-20020aa79826000000b005a9bf42fcc5mr2118439pfl.0.1678944684914;
        Wed, 15 Mar 2023 22:31:24 -0700 (PDT)
Received: from localhost ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id n3-20020aa78a43000000b00625d5635617sm1118668pfa.67.2023.03.15.22.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 22:31:24 -0700 (PDT)
Date:   Wed, 15 Mar 2023 22:31:22 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        lorenzo@kernel.org, tariqt@nvidia.com, bpf@vger.kernel.org
Message-ID: <6412a9aa92347_8961e20896@john.notmuch>
In-Reply-To: <20230316002903.492497-1-kuba@kernel.org>
References: <20230316002903.492497-1-kuba@kernel.org>
Subject: RE: [PATCH net] net: xdp: don't call notifiers during driver init
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> Drivers will commonly perform feature setting during init, if they use
> the xdp_set_features_flag() helper they'll likely run into an ASSERT_RTNL()
> inside call_netdevice_notifiers_info().
> 
> Don't call the notifier until the device is actually registered.
> Nothing should be tracking the device until its registered.
> 
> Fixes: 4d5ab0ad964d ("net/mlx5e: take into account device reconfiguration for xdp_features flag")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: ast@kernel.org
> CC: daniel@iogearbox.net
> CC: hawk@kernel.org
> CC: john.fastabend@gmail.com
> CC: lorenzo@kernel.org
> CC: tariqt@nvidia.com
> CC: bpf@vger.kernel.org
> ---
>  net/core/xdp.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 87e654b7d06c..5722a1fc6e9e 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -781,6 +781,9 @@ void xdp_set_features_flag(struct net_device *dev, xdp_features_t val)
>  		return;
>  
>  	dev->xdp_features = val;
> +
> +	if (dev->reg_state < NETREG_REGISTERED)
> +		return;
>  	call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
>  }
>  EXPORT_SYMBOL_GPL(xdp_set_features_flag);
> -- 
> 2.39.2
> 

LGTM

Acked-by: John Fastabend <john.fastabend@gmail.com>
