Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF58648561
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiLIP1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiLIP1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:27:18 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C418D195;
        Fri,  9 Dec 2022 07:27:17 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id x22so12274944ejs.11;
        Fri, 09 Dec 2022 07:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sellxn+qpRx1/DuL5IfjB8JPMxjkBaM822IJtvbC2DM=;
        b=Wi5SPhesEAkDMVGSMH37+tQIpLM2sfMQITss1JrwUE7sHDicrUPrcwLwkPZaM10yjQ
         KO+DQmAJWq74UjmUpY9O7Fs0ABlFLtwjH4/mQN5CbmOpIgSlbjcsZONxjM6ItwxkMDY2
         jE1Osv6GPfkFf444xBmUhDNuYa9g4OTWnBHHuIsm5tz9B8+jUhAuQnTROUjYNkCraGAq
         D5h5pONYRa/OZpvLq1nCbdgJbRLt5ObnLpLneBeuBC2KxzIpsNe4b/el1lbA/0oDolER
         OEzirp3MWH/jiPNXrVCOdaWibhXRNprjE01ckq2ImKhr86/dl9LVawg29LYazSl6O7wM
         3emg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sellxn+qpRx1/DuL5IfjB8JPMxjkBaM822IJtvbC2DM=;
        b=ekMvwVGruNc/dPLZ89BMFZsDlmt8U2rKhaPNPbiK3uH2OZ0cpRMDZYHvDuzdX6h0gn
         ldqLl9Lp5eS7D1EmneXGs1luCiiUYfhmSFnWduXGqpavkBVJYyw88x3FFMtqI/YH8/P3
         kJ8jttK7wPAzKKzJYZLrwjjctTt5+gNXGmYNzeH7fIUfR1xIgvIBquz4qx3oCQkzLYm3
         YHofUfcp0sVvDKGn1oI7zF0i1cJ4/AkvT2KXc5CMWli3bKWpx81nHBFIVeHzCVCYIJ4G
         whHhxJ78/cVLX7pvZHHbnivzzlqQhcfMm++G5BlM0/ggViQaiY9+SPuh9C+DaYRADLOR
         Z5ag==
X-Gm-Message-State: ANoB5pnzy4Io7PVuWCoIft1xV+vHRHuh8yf1TZzdjrfnkknMBZVoKPFz
        /LPY2RWWx5ypp3uU6fb6S/Y=
X-Google-Smtp-Source: AA0mqf7EdwDPavti3vcA1PVCgAbVhtFkKigiP8JIkUHd+q1ZCC/Q37/Q5ySGdI26K3dsM3C/+PRluQ==
X-Received: by 2002:a17:906:60c9:b0:7c1:b65:14c1 with SMTP id f9-20020a17090660c900b007c10b6514c1mr5395638ejk.10.1670599635589;
        Fri, 09 Dec 2022 07:27:15 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id i11-20020a17090671cb00b007c0c1e18e28sm23868ejk.124.2022.12.09.07.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:27:15 -0800 (PST)
Date:   Fri, 9 Dec 2022 17:27:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Michael Walle <michael@walle.cc>, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, daniel.machon@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        lars.povlsen@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221209152713.qmbnovdookrmzvkx@skbuf>
References: <20221209092904.asgka7zttvdtijub@soft-dev3-1>
 <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
 <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
 <20221209125611.m5cp3depjigs7452@skbuf>
 <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
 <20221209142058.ww7aijhsr76y3h2t@soft-dev3-1>
 <20221209144328.m54ksmoeitmcjo5f@skbuf>
 <20221209145720.ahjmercylzqo5tla@soft-dev3-1>
 <20221209145637.nr6favnsofmwo45s@skbuf>
 <20221209153010.f4r577ilnlein77e@soft-dev3-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209153010.f4r577ilnlein77e@soft-dev3-1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 04:30:10PM +0100, Horatiu Vultur wrote:
> For example this rule:
> tc filter add dev eth0 ingress chain 8000000 prio 1 handle 1 protocol all
> flower skip_sw dst_mac 00:11:22:33:44:55/ff:ff:ff:ff:ff:ff action trap
> action goto chain 8100000
> 
> This will not be hit until you add this rule:
> tc filter add dev eth0 ingress prio 1 handle 2 matchall skip_sw action goto chain 8000000
> 
> Because this rule will enable the HW. Just to aligned to a SW
> implementation of the tc, we don't enable the vcap until there is a rule
> in chain 0 that has an action to go to chain 8000000 were it resides
> IS2 rules.
> 
> So for example, on a fresh started lan966x the user will add the following
> rule:
> tc filter add dev eth0 ingress chain 8000000 prio 1 handle 1 protocol
> all flower skip_sw dst_mac 00:11:22:33:44:55/ff:ff:ff:ff:ff:ff action
> trap action goto chain 8100000
> 
> He expects this rule not to be hit as there is no rule in chain 0. Now if
> PTP is started and it would enable vcap, then suddenly this rule may be
> hit.

Is it too restrictive to only allow adding offloaded filters to a chain
that has a valid goto towards it, coming (perhaps indirectly) from chain 0?
