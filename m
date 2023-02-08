Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88EDD68E81B
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 07:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjBHGSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 01:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBHGSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 01:18:20 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C94216322;
        Tue,  7 Feb 2023 22:18:19 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id az4-20020a05600c600400b003dff767a1f1so650969wmb.2;
        Tue, 07 Feb 2023 22:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L7q8S81+QCbZo1CyWIUIUBVbS2Zujk5QDwokHmPbwv0=;
        b=QwoV7tI1fvdyvx1aXw/9FEeni7RPGCSBPziU80UtJ7TMmNib7bISG2U1COoM/ns4xG
         1qZt8wE0i8KGbtKBbLozHlPuknkczGkhlS9gqkoeqYTTV1Ub+i3GoIFUpe3dXCy8J6/j
         koy5Y25MYcU2tVA6mIOmEfsvPJFzdZS/8x/wFep8kCSo1tYTY23z3G4/dY/TWJh4jCtD
         KPJDc5jZgGnH3aAyHnIBhkdd2gWCrVIxhgHBB4jFuNG+cbOVqorx4Rc8S9EAMntAYDu0
         3FIa6VaGQPEXI9uUuPV7QeJPVrg8Kzkqv/iZD7pr7aK7yxXwlWLuZz0ZRB0nSGKIGqML
         k7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L7q8S81+QCbZo1CyWIUIUBVbS2Zujk5QDwokHmPbwv0=;
        b=mCJ9vOdG94T+QggDxhHVHEqSl+96YCpisqP9nUb+FAvoTdKZ+HByXr9eZZvKprDdOu
         DGB0TPPmxuCAFs6lQLCD0E69/Mj8lSFbNddvZK0d1KNiW3sd5n1HtWZAccWo7wubxD3s
         E5i4jczhjWhkM/amE7Ie01wFtrKRGzDoe35pH/3ftL0Lom+4H+MvsEDKg2sGHehtfJDe
         IG4nr4hGLuwiE16YsoDCoCAkLBIxl5/qdYIeREkQ4SnwbQcNBOk1M343ICUU+OfTGK7u
         VIpYtp+LNY2gSBwIfnL4jD2yU4aWHZJpYx2CJpUDd87DQKhEoO0/hru2QrJ3xlp93ZB8
         yuHw==
X-Gm-Message-State: AO0yUKXNpA1a2IGuoPf9LqIb19EGYDEl60Tggo3frSo/VrKhDobgIBRs
        aVoXRW2dXtHoBXffgNzXYrI=
X-Google-Smtp-Source: AK7set/kAvC2tSeP71wEagj4isNQOps9qGbG98h0F7Jg5sBK1ahgh0pJCrxr9Mw3ic9zOySnAfHOgA==
X-Received: by 2002:a05:600c:30d2:b0:3d9:ebf9:7004 with SMTP id h18-20020a05600c30d200b003d9ebf97004mr5267452wmn.29.1675837097669;
        Tue, 07 Feb 2023 22:18:17 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id l8-20020a05600c2cc800b003dfefe115b9sm945622wmc.0.2023.02.07.22.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 22:18:17 -0800 (PST)
Date:   Wed, 8 Feb 2023 09:18:13 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Kees Cook <keescook@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: sched: sch: Fix off by one in
 htb_activate_prios()
Message-ID: <Y+M+pZz6i5N0Ic3/@kadam>
References: <Y+D+KN18FQI2DKLq@kili>
 <20230207201603.41f295ff@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207201603.41f295ff@kernel.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 08:16:03PM -0800, Jakub Kicinski wrote:
> On Mon, 6 Feb 2023 16:18:32 +0300 Dan Carpenter wrote:
> > Subject: [PATCH net-next] net: sched: sch: Fix off by one in  htb_activate_prios()
> 
> Thanks for tagging but just to be sure - this is for net, right?
> (no need to repost)
> 

Yes.  And I did verify before sending that it applied to net, but I
still put net-next in the subject because I'm an idiot.

regards,
dan carpenter

