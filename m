Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E692E44E7B4
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 14:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbhKLNq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 08:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbhKLNqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 08:46:25 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CF6C061766;
        Fri, 12 Nov 2021 05:43:34 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v11so37970816edc.9;
        Fri, 12 Nov 2021 05:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iO5emtRPnGmOCMUn6VwWGOyJ9gcEJvtioUiXTohyKmQ=;
        b=PgBy3bnMM87Y9R2LNmZQAcHDM2Fq8NOpJvPCN350nw5D40ie6Jf0NN8v4OY4uQ/8JP
         Tp3lFmZlpG5hprTQrnIpGlR56OQtHFBS/CsU9k0jujPQ9dL5eBsXWzsUup2LvdR70GqX
         s44Q60TOOxQ++2F7Q1GKuUQwdhdP6i46wr2FRx/QYhxTCL9tc1nu8/8RLeiMquCExSyx
         0PIzM18brLIlrt4U87D39AOyPUDBDQI2NWYLGsyWBxFbtiqqXiPWwY/v+R8ZOxev6lzK
         FxETIVbC3dz2XZ7YvII5hlCthPwzMekZs4/UcTP8OHKUCZ+gDJwazpXVcmZRRMu7UCKb
         7U4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iO5emtRPnGmOCMUn6VwWGOyJ9gcEJvtioUiXTohyKmQ=;
        b=7mxYli5xwhvWcqn9NFmwdMnbf+U5zD1Kxt9OG8yaXGOY4vdUxk7HzVdTFY0JQKVRV/
         i+t4knBnl4mBQqB6bjymG7g/OKNWhM6145QALgscJYPRFwle+dhFpdT8W8/7aVl+XB5L
         kPJvtveBugqmoqBPWx4lSGfa8ilp3vLDSiseUEo7Q4mW95soUnwJVn/Hvz85jXDM1gj4
         fygm7Pn7lH9KvBDXwC0FNULkvnbW+1xupHX3QPNmlQsJ7WKdjsdoDjBBGWAaD1x74Ez4
         2TwMI0NgAqk4pc25oeAlERO88nJO6paiGcCERxVyq4M+TkX07dh8dhwHMWXTloq8virW
         4N8w==
X-Gm-Message-State: AOAM533UhCrlHqUa7s6ZaWeD/h5qs7Pvf5dAcub3QW+C2jdVvMk2BHdr
        /7L3V3L9fkSWHGM6oPQmvKw=
X-Google-Smtp-Source: ABdhPJzRDvPzZjk6qrsnkmIWgAfQE0UvlUSv+7RSVEmqzbml9Y88L3HoorlmVGWIEQ31IUqqSm+fVg==
X-Received: by 2002:aa7:d34c:: with SMTP id m12mr17845644edr.269.1636724613576;
        Fri, 12 Nov 2021 05:43:33 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id di4sm2629037ejc.11.2021.11.12.05.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 05:43:32 -0800 (PST)
Date:   Fri, 12 Nov 2021 15:43:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: stmmac: fix system hang caused by
 eee_ctrl_timer during suspend/resume
Message-ID: <20211112134331.initwvks6ytlfi4x@skbuf>
References: <20210908074335.4662-1-qiangqing.zhang@nxp.com>
 <20211111151612.i7mnye5c3trfptda@skbuf>
 <DB8PR04MB6795FCF1B1E5E0B03CA49B90E6959@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795FCF1B1E5E0B03CA49B90E6959@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 01:21:57AM +0000, Joakim Zhang wrote:
> Hi Vladimir,
>
> > Hi Joakim,
> >
> > This patch looks strange to me. You are basically saying that the LPI timer for
> > MAC-level EEE is clocked from the clk_ptp_ref clock?! Are you sure this is
> > correct? I thought this clock is only used for the PTP timestamping counter.
> > Maybe the clock definitions in imx8mp.dtsi are not correct?
>
> No, MAC-level EEE is not clocked from the clk_ptp_ref clock, this clock is for PTP. To fix this issue,
> I can only move pm_runtime_force_suspend() into noirq suspend stage. As commit message said,
> "postpone clocks management from suspend stage to noirq suspend stage", that means I move all
> the clocks management into noirq suspend stage, including PTP clock, it's should be harmless for PTP
> function. Do you find any regression with this patch?

No, I didn't find any regression, I was just frustrated yesterday that a
bugfix patch I wanted to send to "stable" on the handling of clk_ptp_ref
is conflicting with your (apparently unnecessary) movement of this clock
to the noirq suspend stage. I'm better now.
