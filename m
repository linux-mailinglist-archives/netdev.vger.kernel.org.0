Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FA46C9220
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 04:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjCZChd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 22:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCZChc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 22:37:32 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B8AAD1C;
        Sat, 25 Mar 2023 19:37:32 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id fb38so3555087pfb.7;
        Sat, 25 Mar 2023 19:37:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679798251;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xHcEk5icyFpIFsnzV+XrESkp/yZHE58RIgb+N7Pys8E=;
        b=SXfl8D5KGSHXDObziZsM0PrZZgeIN+pTXPJ+k3A80ARaLrvUatbwfNjya7asM8eZj5
         4S91k6ljwDGZqnYMSMvNi7yfIvRS5Ez+qbq7Mnp55iXlkXdc7WQsK+6/8wO+01DnsGev
         kwlYMz/3zd9Z2d1N2ysddUFxtxMqPEk9mzlvejFhV5z3clDRRZm1aZ7a60TriSgFVuCH
         5+2j9JLdxVkuGdD9S+Ytevuhrpw2pZQhtBW95xiHrIsbGN0kmqz8rps70vIqs5m9HbGi
         wePxvos9/sh+txE8+1AVMVPu7zias2GOsOlIDfaYCAyPUUmCIQNLz0hRwBUBvkvyIhXj
         nzrQ==
X-Gm-Message-State: AAQBX9ejIFF4NzJ2XEB1CVgxan7nUQaWHEJ+my/5FMjsc6bU5SDpMWI6
        gUX5g6kODtPNo8ZcDnJprYx5z54BUnQ5LgB1I4xitHR83hk=
X-Google-Smtp-Source: AKy350ZSRgjB4+CEYz+LxcJSgzmMD1WKybLUEJytm6bXOQ5Bb7+ST1EQ5pz8zOtr1YKBTH6Zi8Mk612LVVyIjicja14=
X-Received: by 2002:a05:6a00:1894:b0:622:b78d:f393 with SMTP id
 x20-20020a056a00189400b00622b78df393mr4140493pfh.2.1679798251148; Sat, 25 Mar
 2023 19:37:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230321081152.26510-1-peter_hong@fintek.com.tw>
 <CAMZ6RqJWg1H6Yo3nhsa-Kk-WdU=ZH39ecWaE6wiuKRJe1gLMkQ@mail.gmail.com> <20230324161320.jutuyor7jrbqu37p@pengutronix.de>
In-Reply-To: <20230324161320.jutuyor7jrbqu37p@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 26 Mar 2023 11:37:19 +0900
Message-ID: <CAMZ6Rq+0MQFXeQAJigqUzbQnbMFHXbOfViXQkkBMUBm29k1U+A@mail.gmail.com>
Subject: Re: [PATCH V2] can: usb: f81604: add Fintek F81604 support
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
        wg@grandegger.com, michal.swiatkowski@linux.intel.com,
        Steen.Hegelund@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        frank.jungclaus@esd.eu, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        hpeter+linux_kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 25 Mar 2023 at 01:13, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 22.03.2023 00:50:20, Vincent MAILHOL wrote:
> > Hi Peter,
> >
> > Welcome to the linux-can mailing list.
> > This is my first review, I will wait for the next version to give a
> > more thorough look.
> >
> > On Tue. 21 Mar 2023 at 17:14, Ji-Ze Hong (Peter Hong)
> > <peter_hong@fintek.com.tw> wrote:
> >
> > From your email header:
> > > Content-Type: text/plain; charset="y"
> >
> > It gives me below error when applying:
> >
> >   $ wget -o f81604.patch
> > https://lore.kernel.org/linux-can/20230321081152.26510-1-peter_hong@fintek.com.tw/raw
> >   $ git am f81604.patch
> >   error : cannot convert from y to UTF-8
> >   fatal : could not parse patch
>
> I'm using b4 [1] for this:
>
> $ b4 shazam -l -s 20230321081152.26510-1-peter_hong@fintek.com.tw
>
> and it works.

Thanks for the tip. I was suspecting such a tool to exist but never
heard about b4 before. It is kind of very well hidden in the document.

@Peter: Then, no need to fix. Please ignore the above comment.
