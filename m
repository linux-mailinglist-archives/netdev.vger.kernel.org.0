Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D623C642E63
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiLERKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiLERKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:10:37 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD26B7DE;
        Mon,  5 Dec 2022 09:10:36 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id s8so19616498lfc.8;
        Mon, 05 Dec 2022 09:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O7MqUoslkh62iX3F4jHk5zmRkkCLZUGOXpp/72m0ZYQ=;
        b=L/sbtUbwlL7jLQjroEol9toJppHAmxI+SH3euz2PPkW3ryQ/6SUEL8wfh2IARBdjMG
         C1t39YVnuHneEZeInhV+8LsFSarPrXGntU+LAIzSrElEs93DnpnP6IoxCyvunG5xkCnA
         y9Y3w0zJVbvet61G0fIwl1XUgB6EzsGvCN3GzcII+hrM0YgJXs9Leh0fGNaOqWyaHVvq
         M3NB0ytvYZpRl8pwawytZdxayxfetl9DvlHgsoTQpCitppcgHvzZBIzCI5pyoZQl0eEC
         F49/482FXqdQ3rJd1qjy7G8jCr1Bb/iWUFEd4P1lE4fanlIOxuIoNOIGuplWJz7qFK6K
         XXfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7MqUoslkh62iX3F4jHk5zmRkkCLZUGOXpp/72m0ZYQ=;
        b=7QP9UxyNufXH4ANhXRvOlBhnlF5+rretHtG1BdAKLHBId141UXkcp34H+qbyUTDInx
         LsuHSF5x3kmB2j20F5aGfgS0EUjZqqTah581H/DjpCKmFVb5sRV7/jR3sNBjhjpbGZ8N
         kU3HRlc1U9LVYGgawma2FnF8elqLkY7gh2HnvBs1FOC1ayFzg8jMjS41TyAn1AjbbG01
         lD71OfURq2vngso4s6WDXmRUaVyzesblgDSuP9CORa904bY8hI903nccQahBj4FfqMyy
         h6lRNv6OvbYD+DWW6X3DhEIP8j76TQN3x5vzhbTkFVDB/7dxcBFw09tzxcMInUjKp9b+
         5IXQ==
X-Gm-Message-State: ANoB5pmuxe/uk79epwzkghJ8Pd55jOUzH6FsnhqjPRa8hx/zHs8ySLUC
        TsYgHZf3fMDdZ20I5+0JGYE=
X-Google-Smtp-Source: AA0mqf6Lu25sKO/cOgh4PoYE6VpIIAK0cgasiCf20DSqDLNXX8Bx5U11k/Dkfr8ktgmNK+xp7S5lnw==
X-Received: by 2002:a05:6512:33ce:b0:4b5:ff:4050 with SMTP id d14-20020a05651233ce00b004b500ff4050mr16768988lfg.476.1670260234867;
        Mon, 05 Dec 2022 09:10:34 -0800 (PST)
Received: from pc636 (host-90-235-25-230.mobileonline.telia.com. [90.235.25.230])
        by smtp.gmail.com with ESMTPSA id z16-20020a0565120c1000b004b577877286sm389613lfu.50.2022.12.05.09.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 09:10:34 -0800 (PST)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date:   Mon, 5 Dec 2022 18:10:32 +0100
To:     Eric Dumazet <edumazet@google.com>
Cc:     Uladzislau Rezki <urezki@gmail.com>, paulmck@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Dmitry Safonov <dima@arista.com>,
        rcu@vger.kernel.org
Subject: Re: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
Message-ID: <Y44mCDh2eweZD74I@pc636>
References: <CAEXW_YRW+ZprkN7nE1yJK_g6UhsWBWGUVfzW+gFnjKabgevZWg@mail.gmail.com>
 <21A10014-22D8-4107-8C6C-14102478D19B@joelfernandes.org>
 <Y43RXNu0cck6wo/0@pc636>
 <CANn89i+RNj0gaJCyNUyrMBpSTsxSgjW1YN_FuRW_pMUOMiQtuQ@mail.gmail.com>
 <Y44HNfuR5OgfEXxV@pc636>
 <CANn89i+8Au1+Wa_F0QGAz2zfA7UYcCF_9a0BqCpdAqMOrNVbsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+8Au1+Wa_F0QGAz2zfA7UYcCF_9a0BqCpdAqMOrNVbsw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Dec 5, 2022 at 3:59 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> 
> > So it was a typo then. How did you identify that BUG? Simple go through
> > the code? Or some test coverage?
> 
> Code review. I am the TCP maintainer, in case you do not know.
> 
OK, thank you.

--
Uladzislau Rezki
