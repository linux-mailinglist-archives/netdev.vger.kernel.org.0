Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E48D51C0AB
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379491AbiEENcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243197AbiEENcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:32:52 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892714CD4D;
        Thu,  5 May 2022 06:29:12 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id y3so8697874ejo.12;
        Thu, 05 May 2022 06:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=EIeefQQ07tuKIdHMea42zyANLHjPxyTpoyYL7WnarXw=;
        b=JdivQ0zWU/g1d8r9j30OxOJR9jjBtFXk/6cJdhiU/fq71yY7ikHYmRIJmFD2h35W8u
         S8oHOEU6DF3rjtVaf+B/+CQjly+4HlJovNJAwJTKnh9HSJ335oAozCVV6VOP9VJOTL8h
         AAPm4bQTPXEZ3m5aVnTyqa4d3vh9olrMTeW7sXHOei9k1rlGZ9wanU1GlSm7fxUNwIG3
         rEuE51x+6a/ZsSglrIQE7Z1beKjok6jlF1hpzakdlmke5TfRU5Uc6/ascBvqyD2S/tZV
         w0cvsNMexffgcyrFS4O5GbCkBLmxhOtfy4h9LKouiDWGAq5yoroU40jzvdUMmc3637Jd
         5YYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=EIeefQQ07tuKIdHMea42zyANLHjPxyTpoyYL7WnarXw=;
        b=4/6RRwGzcO6ffsAtHzKzaUCrkaNnZMzcxsobt8MgcUWBfTG7e2HS49k7L5ZISpy9qi
         ninQnH5qXOtvxfw358efEXHr5Cv0o+SwhCvJDFUCsxUC8mw7gbawMy6jsrQfsKUaQhN4
         JrAd6Z/ro1HFCgYGFGacfpwnJh81aVz3yawJVkihJFsMfywEB9tCn6ErHlmgq9zmyN3e
         bg4vIrioqrKOlpC3SIgl4rD8r63WOHAIrFA+7rN9CoAox+yrYQM9PlYt/cA53JrWQDM8
         0s+7fx045XJff32fphiU+UNFFtLXjdqt305UUAsduwPNp29+JKoRiTZy5OfNeAphErpP
         av7g==
X-Gm-Message-State: AOAM531aWyZNCSUibOkoNaYsHtRxnvmhpjoAA0BI9x4VteI7K9pc0nqU
        UVgJYkiaRZKIn3CYJIytHhU=
X-Google-Smtp-Source: ABdhPJw1ezRt9Ay2D+yBcuSXjuFkel+4cbAQ6r26j4VCRzs9+YhuMZ/6gDo26mm1OuFog9oY6qmKbg==
X-Received: by 2002:a17:906:cb09:b0:6f3:87ca:1351 with SMTP id lk9-20020a170906cb0900b006f387ca1351mr25935717ejb.674.1651757351043;
        Thu, 05 May 2022 06:29:11 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id r12-20020aa7cfcc000000b0042617ba638esm806835edy.24.2022.05.05.06.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:29:10 -0700 (PDT)
Message-ID: <6273d126.1c69fb81.7d047.4a30@mx.google.com>
X-Google-Original-Message-ID: <YnPRJeN6tIeZQynu@Ansuel-xps.>
Date:   Thu, 5 May 2022 15:29:09 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 07/11] leds: trigger: netdev: use mutex instead of
 spinlocks
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-8-ansuelsmth@gmail.com>
 <YnMj/SY8BhJuebFO@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnMj/SY8BhJuebFO@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 03:10:21AM +0200, Andrew Lunn wrote:
> > @@ -400,7 +400,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
> >  
> >  	cancel_delayed_work_sync(&trigger_data->work);
> >  
> > -	spin_lock_bh(&trigger_data->lock);
> > +	mutex_lock(&trigger_data->lock);
> 
> I'm not sure you can convert a spin_lock_bh() in a mutex_lock().
> 
> Did you check this? What context is the notifier called in?
> 
>     Andrew

I had to do this because qca8k use completion to set the value and that
can sleep... Mhhh any idea how to handle this?

-- 
	Ansuel
