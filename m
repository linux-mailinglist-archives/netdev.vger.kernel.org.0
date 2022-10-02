Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766725F2368
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 15:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiJBNj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 09:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiJBNj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 09:39:26 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E5127156
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 06:39:25 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id s2so841006edd.2
        for <netdev@vger.kernel.org>; Sun, 02 Oct 2022 06:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=g5YxM2B4MZQAHZYEB0osJEZK6g9pn8IQQOgQYOeXjm8=;
        b=c7KcbMNFzS+JQdYN7mZLp3rfq/2yvMDwyIka4D0+Kn1vaWSy3nGzEoD//Ex5WN1r6Q
         doq3b611hWLR/+J8qketOhtXpIWoxEzAsvQuCqFqevbX8p/GHOA2F5/bkkHvLPpOFrIN
         IJ95glN1KFGx/ERp1wFh6R4jQZEYNtoGT7KQ3Y7B+xIKebvwG277x6o4afjek9rpv89k
         nvp17IE6ESIgAoKu7XyhtGWHjUIwFmHxLE3e0xF/YGpbpEnT8znFl8xXbJEGtXjJ70V3
         lXZvQf+h47/qwg0B0dgHpRZSvofJzLoV7qU3dDoRxOXKEmXJA86GwIm5hULUY90X44q0
         pPpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=g5YxM2B4MZQAHZYEB0osJEZK6g9pn8IQQOgQYOeXjm8=;
        b=5Vc8mFRLouTkE7feFsaSA/PbViEaL0ppgQOCOrNEzRrzGk6DExIjt7JK1L5Sv4E0I3
         BkxPwV1U15zw1B2dEMq7drU61KO3Mi3GTyLUjFz8ChzbArSWxaOK/sPgAI9wYxJSqUq0
         73E0gfIQ09Tb8huknbuwXMF3XdWFfPHJ73ZJ2kDW45y8CokmaUL10T7ZXOYMmEG8juwp
         rpE0uIVS9bG54xJiGqQYE1xNzc+dNRDM02uXJHfthOlea8Ohqe4GeG1G6oaLqHQR3ft/
         Di/gLTYF5NfvGBPH4PyoJ7I0yqSAzoJ1XVd+d7DXKQ2SIv2VB7T+g8rXd7BkZp2mqpSw
         bzww==
X-Gm-Message-State: ACrzQf0ZhKaNLjE68jU1sWjnz3G6Ot2s60XcLGDUUBLIKEktgR0ZvciM
        N7GtXg0nuA4n+dLwrjUVDyy/BMPtSf5j6W7E7COpyg==
X-Google-Smtp-Source: AMsMyM5qvbrlMyVM6nLhhslzLO3+Yab526Lq6ayh25C6ssn8nwudq+N0VhwKxhtK+7Vu5+8EMrdCAjz+E3mbp89IpTM=
X-Received: by 2002:a05:6402:370c:b0:453:9fab:1b53 with SMTP id
 ek12-20020a056402370c00b004539fab1b53mr15533828edb.28.1664717963581; Sun, 02
 Oct 2022 06:39:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220930192254.971947-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20220930192254.971947-1-m.chetan.kumar@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Sun, 2 Oct 2022 15:38:47 +0200
Message-ID: <CAMZdPi9KAoDsgoDWk02ofcoeBEGSZhrO1qSgF3fgLKFSXnS7og@mail.gmail.com>
Subject: Re: [PATCH V2 net-next] net: wwan: t7xx: Add port for modem logging
To:     m.chetan.kumar@linux.intel.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Moises Veleta <moises.veleta@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sept 2022 at 15:55, <m.chetan.kumar@linux.intel.com> wrote:
>
> From: Moises Veleta <moises.veleta@linux.intel.com>
>
> The Modem Logging (MDL) port provides an interface to collect modem
> logs for debugging purposes. MDL is supported by the relay interface,
> and the mtk_t7xx port infrastructure. MDL allows user-space apps to
> control logging via mbim command and to collect logs via the relay
> interface, while port infrastructure facilitates communication between
> the driver and the modem.
>
> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
> Acked-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> --
> v2
>  * Removed debugfs control port.
>  * Initialize in Notify function upon handshake completion.
>  * Remove trace write function, MBIM will send commands.
> ---
>  drivers/net/wwan/Kconfig                |   1 +
>  drivers/net/wwan/t7xx/Makefile          |   3 +
>  drivers/net/wwan/t7xx/t7xx_hif_cldma.c  |   2 +
>  drivers/net/wwan/t7xx/t7xx_port.h       |   5 ++
>  drivers/net/wwan/t7xx/t7xx_port_proxy.c |  12 +++
>  drivers/net/wwan/t7xx/t7xx_port_proxy.h |   4 +
>  drivers/net/wwan/t7xx/t7xx_port_trace.c | 112 ++++++++++++++++++++++++
>  7 files changed, 139 insertions(+)
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_port_trace.c
>

[...]

> +
> +static void t7xx_port_trace_md_state_notify(struct t7xx_port *port, unsigned int state)
> +{
> +       struct rchan *relaych;
> +
> +       if (state != MD_STATE_READY || port->relaych)
> +               return;
> +
> +       port->debugfs_wwan_dir = wwan_get_debugfs_dir(port->dev);
> +       if (IS_ERR(port->debugfs_wwan_dir))
> +               port->debugfs_wwan_dir = NULL;

Why continuing here despite the error? Is it a possible valid scenario?

> +
> +       port->debugfs_dir = debugfs_create_dir(KBUILD_MODNAME, port->debugfs_wwan_dir);
> +       if (IS_ERR_OR_NULL(port->debugfs_dir)) {
> +               wwan_put_debugfs_dir(port->debugfs_wwan_dir);

port->debugfs_wwan_dir can be NULL here...

> +               dev_err(port->dev, "Unable to create debugfs for trace");
> +               return;
> +       }
> +
> +       relaych = relay_open("relay_ch", port->debugfs_dir, T7XX_TRC_SUB_BUFF_SIZE,
> +                            T7XX_TRC_N_SUB_BUFF, &relay_callbacks, NULL);
> +       if (!relaych)
> +               goto err_rm_debugfs_dir;
> +
> +       port->relaych = relaych;
> +       return;
> +
> +err_rm_debugfs_dir:
> +       debugfs_remove_recursive(port->debugfs_dir);
> +       wwan_put_debugfs_dir(port->debugfs_wwan_dir);

same here.

> +       dev_err(port->dev, "Unable to create trace port %s", port->port_conf->name);
> +}
> +
> +struct port_ops t7xx_trace_port_ops = {
> +       .recv_skb = t7xx_trace_port_recv_skb,
> +       .uninit = t7xx_trace_port_uninit,
> +       .md_state_notify = t7xx_port_trace_md_state_notify,
> +};
> --
> 2.34.1
>
