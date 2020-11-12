Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC062B0C73
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgKLST6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgKLST6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:19:58 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4362FC0613D1;
        Thu, 12 Nov 2020 10:19:58 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 34so1610661pgp.10;
        Thu, 12 Nov 2020 10:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n7g1gNiWNUoiOnTmGN2ApE9IfRXIw3myaShl47KJKcQ=;
        b=kJnc+FEG/l4y8Napsm/X9/qjqvCMpN4vmUqqRFGL0KIjULmi6J5JWxQ7fJd2a/F1pu
         35Jn3Wd5EMd2KfRBPB7Tni7AYnhQqSXZpECGgNn2pZL9CKDn6drTTpb+lvKyHzpfdgBs
         e21MDX98i4B4ufrH+M3JcOBxx01BdL6bdIYAfEGlp87Y5uMRRNEshp6W2byJ12X+ibQt
         QRb4O1dSR2vDj/wNu9xFAjT4mIHtWp66DRJyJI9GOZtEWOpMQEzXkO9W+7J0gh+ZI8wT
         qEka8Jz2/E2cfnlAvDkdlDaLeEIa5hBcBUbsjksFGH1NxZ2eKdgB0FFKEQcrc9TxNBtg
         77Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=n7g1gNiWNUoiOnTmGN2ApE9IfRXIw3myaShl47KJKcQ=;
        b=FT2BY1iAUc9OG6s/oI5CufRhwPChf7bcGe3H7huf0s35tb6CWwsSzKRReh78SpDVUH
         YLFnUOdXTqdaoOUkw5B2Dr43gyzqk3D954hb0gl/VBa1E62NNELuALS49cSe2ksL6/5k
         C7wTwgxIecuK0AVccUm9TL0Er0jziFHhXfbuuIs8DpanJk4UkH+jpKMPWGYQfxB16DiH
         dlOCB90SNTXekunu/98sFE2eyDz85fKOY4yEOfoiSRhwLaNj86RUa2X5v9wn5PQZ1MPi
         f1jRkNJx9EcrOu2gVkSlwCQ1ZXuyA73xpr8EycnKvr8D/NB5wLVuPs1bueGRP3+UBh6W
         kqMA==
X-Gm-Message-State: AOAM533zpWQrXWTbhxFziHEzweZ1JOK8+5QWO43t7x+DSkOENZqmbOVZ
        DQ9uHru6Yii1IUstRETjOJM=
X-Google-Smtp-Source: ABdhPJwMTfvFMTxs0p4jnKJl/SOqqPdhZH2Jzh4/mv0luqjTZxAlap+i91fJvmHNNH/jUUhG7WQEUQ==
X-Received: by 2002:a62:7ccd:0:b029:18b:9083:ae1b with SMTP id x196-20020a627ccd0000b029018b9083ae1bmr658078pfc.27.1605205197831;
        Thu, 12 Nov 2020 10:19:57 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 144sm7236849pfb.71.2020.11.12.10.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 10:19:57 -0800 (PST)
Date:   Thu, 12 Nov 2020 10:19:54 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     =?utf-8?B?546L5pOO?= <wangqing@vivo.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when
 ptp_clock is ERROR
Message-ID: <20201112181954.GD21010@hoboy.vegasvil.org>
References: <20201111080027.7830f756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
 <CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 09:25:12AM +0100, Arnd Bergmann wrote:
> This is not really getting any better. If Richard is worried about
> Kconfig getting changed here, I would suggest handling the
> case of PTP being disabled by returning an error early on in the
> function, like
> 
> struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
>                                    struct device_node *node)
> {
>         struct am65_cpts *cpts;
>         int ret, i;
> 
>         if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK))
>                  return -ENODEV;

No, please, no.  That only adds confusion.  The NULL return value
already signals that the compile time support was missing.  That was
the entire point of this...

 * ptp_clock_register() - register a PTP hardware clock driver
 *
 * @info:   Structure describing the new clock.
 * @parent: Pointer to the parent device of the new clock.
 *
 * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
 * support is missing at the configuration level, this function
 * returns NULL, and drivers are expected to gracefully handle that
 * case separately.

Thanks,
Richard
