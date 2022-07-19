Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2527E579F8F
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239179AbiGSNYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243608AbiGSNYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:24:16 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74565465E;
        Tue, 19 Jul 2022 05:40:28 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id m16so19371217edb.11;
        Tue, 19 Jul 2022 05:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aDi9qs5NlA2rwxPldcUQfcZd+IXc+ZeiZMYtg6hMZ60=;
        b=aXNocC/q5VvfedgC2S0TtcEMefpucqrEgikMH4XqSiMGqC0YXnR3XAtsxI6viMdje/
         ptq2hmis07F0gM3omW4bp/ibBY8pIslmjESQv2/WdekxXJ7jJgMBs/FoEfGutuI36gbs
         YJq547t1RBK/01fV1itKItC4iCsdsmlzZr29aL08El5Kq+xqDE4D8r1Qved3WOmvelLL
         3u17GgmIYZFUDEzHOjzN1EiQVG6uMSlwMZHDEDsZce4/d1QtlM8lfyu12ieumnpsAnUS
         jVsvK/iFJXfuk4FNmGxlthXWLm8vTjXmfmB6UOYn2wC7CC524Q3fkfdRbVvuoVoaUEjJ
         Gybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aDi9qs5NlA2rwxPldcUQfcZd+IXc+ZeiZMYtg6hMZ60=;
        b=BGSsc+cPFWFkC6nxR9BnEog5uraa1YdDORxELti9fw3eMsHggmkaZ7ykgza5Fzuvvv
         Yeqyoar3p8MzsksXZrk2xVB957Qm4Gtw5e4sN8nd989xXq/XiQerX7ZMYJPEs0zcHMfv
         EiG+1Th80wKcN8w+UclaNLNspBqSWHbraFiSvTwr/3ayU3dWPVa2R7gHrtxcj/aNqjFB
         FtwSeoKu517eoviGZ6q9mFi75RC2AyS2GXjaN/bre37+m+CPtGRui/6XYxVQ2rziNHej
         TSQJOQ0tJ07f/TRY1nA94bHIcgmHKz3J7JbXZvjD9mTUHYZWP7br7vD4tPsNtNGQSLzW
         4uSQ==
X-Gm-Message-State: AJIora/z8ewJRtluYBAODVD/QDd4UaXUkeqTakI1o4voKzSGJQU8oOHG
        v8awtSkt/qJdyH07ClVEGSs=
X-Google-Smtp-Source: AGRyM1uC+fK7WO/K2l+R9zBo7USK2Vw4QdfT9OsJm6goYJJNT0MZtc8To78MLCIn+XzzTm2iO2lNQg==
X-Received: by 2002:a05:6402:782:b0:43a:7387:39df with SMTP id d2-20020a056402078200b0043a738739dfmr44995178edy.251.1658234426521;
        Tue, 19 Jul 2022 05:40:26 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id g21-20020a1709063b1500b00722dcb4629bsm6776083ejf.14.2022.07.19.05.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:40:25 -0700 (PDT)
Date:   Tue, 19 Jul 2022 15:40:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 04/15] net: dsa: qca8k: move qca8k bulk
 read/write helper to common code
Message-ID: <20220719124023.43ljzldalmn5orji@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-6-ansuelsmth@gmail.com>
 <20220719005726.8739-6-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-6-ansuelsmth@gmail.com>
 <20220719005726.8739-6-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:15AM +0200, Christian Marangi wrote:
> The same ATU function are used by drivers based on qca8k family switch.
> Move the bulk read/write helper to common code to declare these shared
> ATU functions in common code.
> These helper will be dropped when regmap correctly support bulk
> read/write.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

I'll re-review this patch after the changes w.r.t. of_device_get_match_data().
