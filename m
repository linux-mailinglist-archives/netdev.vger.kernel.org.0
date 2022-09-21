Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3285BFFF9
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 16:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiIUOfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 10:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiIUOfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 10:35:01 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F8933A38;
        Wed, 21 Sep 2022 07:35:00 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id iw17so5914686plb.0;
        Wed, 21 Sep 2022 07:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=IJx24pWD5kavn/uysl/yW1+FtFUYsw+GT0llY/pLrjc=;
        b=Jtop5FnB2cxvuhmAwxO9I9XUia/xHvNHJCVcRFfuhfT0fxrZ6WwuBbNUK43D7M1P83
         LcL1fkQJaEdu1ONZzGLOXDJ5aguhUkfaySHXrSl4ZgSyohwuHuQ7TfdNVe5aAZ3HhD6c
         HESuSDjMqwtjI7UG52fkJcMnFi/wXmuLqrnphovgXQWaeK3f4pxM1uyRGGxynBX1R61Q
         bZnj+PO2CQ2yvQyIWuILNGMMYVzr2YVzbW7wpnL9YWKBcK8L0rZAq82L7hh4fJepP+wT
         esVa2sZzJ2RzWetNzLUcZtlRg2Rv9PXKU+K28ws1Mu3Vph3X4ZCzuxb6DA6+HrPOzytt
         WV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=IJx24pWD5kavn/uysl/yW1+FtFUYsw+GT0llY/pLrjc=;
        b=iK8pC9/CTw077VjVqneelfNBPQTYbKlmIpvZRyRi6TYm4t+Zk1QRMMv1M8cLsG7Heu
         EQSYzxizljbYMBxm+ezrKA1lknP1lBBZ1h+nxtlSsNPUjt0EM/Go4x+gVA7yF2aygTbD
         kXtAxmM3XHYc9aiwetUoNjQXEgm8g0pfm81TEzaI5qKo9iLer3i0GVOZf05PqHrtcnfS
         bnxfgqLYbD5cWsFr/6M2ewddKAL87UfIYTW/eTNeSujGDHVber4oakVCAHeXM53gbLYe
         OIf/5jcKCFNt/s2bYDZASg2Kpw8WDU84e5ZJKdWXFYvIvDgEduUuHidftjTdgVHNvbKh
         FzFg==
X-Gm-Message-State: ACrzQf1M4QtrlKYfEarYLq4O72p8oXTK2MCPJmmKoi493sHgb5H46RNX
        7r13f7VnWFVAutM3SUZ4Pjk=
X-Google-Smtp-Source: AMsMyM4dM+klOv+6pQUBD5nau2LCOnFIOdc+fmGnd2hNs15Z1TLWmJJjkgXwc0T6vgyAMLBgbykYgg==
X-Received: by 2002:a17:90a:fa8e:b0:200:b4b9:c6f3 with SMTP id cu14-20020a17090afa8e00b00200b4b9c6f3mr9902982pjb.190.1663770899886;
        Wed, 21 Sep 2022 07:34:59 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q15-20020a170902a3cf00b0017691eb7e17sm2070576plb.239.2022.09.21.07.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 07:34:59 -0700 (PDT)
Date:   Wed, 21 Sep 2022 07:34:56 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     kishon@ti.com, vkoul@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        geert+renesas@glider.be, andrew@lunn.ch,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 6/8] net: ethernet: renesas: rswitch: Add R-Car Gen4
 gPTP support
Message-ID: <YyshEGhh7zr+gXpa@hoboy.vegasvil.org>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921084745.3355107-7-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921084745.3355107-7-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 05:47:43PM +0900, Yoshihiro Shimoda wrote:

> +static int rcar_gen4_ptp_gettime(struct ptp_clock_info *ptp,
> +				 struct timespec64 *ts)
> +{
> +	struct rcar_gen4_ptp_private *ptp_priv = ptp_to_priv(ptp);
> +
> +	ts->tv_nsec = ioread32(ptp_priv->addr + ptp_priv->offs->monitor_t0);
> +	ts->tv_sec = ioread32(ptp_priv->addr + ptp_priv->offs->monitor_t1) |
> +		     ((s64)ioread32(ptp_priv->addr + ptp_priv->offs->monitor_t2) << 32);

No locking here ...

> +	return 0;
> +}
> +
> +static int rcar_gen4_ptp_settime(struct ptp_clock_info *ptp,
> +				 const struct timespec64 *ts)
> +{
> +	struct rcar_gen4_ptp_private *ptp_priv = ptp_to_priv(ptp);
> +
> +	iowrite32(1, ptp_priv->addr + ptp_priv->offs->disable);
> +	iowrite32(0, ptp_priv->addr + ptp_priv->offs->config_t2);
> +	iowrite32(0, ptp_priv->addr + ptp_priv->offs->config_t1);
> +	iowrite32(0, ptp_priv->addr + ptp_priv->offs->config_t0);
> +	iowrite32(1, ptp_priv->addr + ptp_priv->offs->enable);
> +	iowrite32(ts->tv_sec >> 32, ptp_priv->addr + ptp_priv->offs->config_t2);
> +	iowrite32(ts->tv_sec, ptp_priv->addr + ptp_priv->offs->config_t1);
> +	iowrite32(ts->tv_nsec, ptp_priv->addr + ptp_priv->offs->config_t0);

... or here?

You need to protect multiple register access against concurrent callers.

Thanks,
Richard

> +	return 0;
> +}
