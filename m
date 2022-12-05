Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E312E642ACF
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 15:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiLEO7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 09:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiLEO7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 09:59:07 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157ABB4B6;
        Mon,  5 Dec 2022 06:59:06 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id n1so13829704ljg.3;
        Mon, 05 Dec 2022 06:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gnY8SXBp9bPMd0kyQP/BWkN4rezvSUUK12e+MubMKbQ=;
        b=MMERCxtHk89MgOW+yDQfLlDS0NCrb7ujfFQsH6Z6K/visG0Laknf61poCvrUinX/cz
         D9B9K74wgAOE5N6+1RK8VXqmiYYz9fdR55EPAtR88ZgDE/xxDk0p9lgVW5ejZds9nBt6
         2zJJ+wK3WZ20xvuxO3WlFDlc5b4xWA/qMHELGWfU0Up3zdq+bYjUD3iMoohsB5WrTn7J
         ECvRLNhMMrftG8YGsWbq0jo9hVKVJVxxZcNFnOIokMCZyHN5qQxUmk+4ensxrUFLnLtR
         UyclnSXQDQz6tTIGjRivoO7WOeb0V8LnbMYrQSGCX/M+PKtO8rlfqr1bgmmPkSFG/9tB
         yhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gnY8SXBp9bPMd0kyQP/BWkN4rezvSUUK12e+MubMKbQ=;
        b=3HDYxEd8cpLrkABBkjTOZrd3Bb6K/Qwhgme6NRbylP1slBR/hPjOztCp6VFNtmj3Lv
         7GCar/XiK1dmv/giZazixnehkaISa1IoGSb4z1qNOhIznHPAuyFmxAIsNIzNGUAcV5b3
         3i2yhrfSn0UaAbPuvqBD5muU8AtcScmdXdfgUBSLHNQpHIizIhOEHLtA8uaNd7HF7+e9
         F2y9FdDJFJv1bGSUYBVoWmWEbDje6SDrd2F0Gy/PYslYxqFU34jm/4OPms7Yd9YkWZcV
         wD/l7yOnnHTQzhe1ynhsvHLne4EsFw2x8DzYsd9W5aC0O01OfIRr6lNnC1krdf0Olt5m
         8CjA==
X-Gm-Message-State: ANoB5plxI5yGNElrvsH1ek0rc4yJOimOiI6rUsr4u/0PT/dlzHPo7Uu4
        QL8abzbSPgro5pEGuMYW6ks=
X-Google-Smtp-Source: AA0mqf6TWHqu6ej08VQH7KjY/A4PtoifjRpaC4iC9QJmFd2OpjEbIf6wqfEaQCCUJj7PK7MQUyo9yg==
X-Received: by 2002:a05:651c:988:b0:279:7ab3:8738 with SMTP id b8-20020a05651c098800b002797ab38738mr19778054ljq.232.1670252344188;
        Mon, 05 Dec 2022 06:59:04 -0800 (PST)
Received: from pc636 (host-90-235-25-230.mobileonline.telia.com. [90.235.25.230])
        by smtp.gmail.com with ESMTPSA id bd11-20020a05651c168b00b002773a9b5898sm1411422ljb.138.2022.12.05.06.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 06:59:03 -0800 (PST)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date:   Mon, 5 Dec 2022 15:59:01 +0100
To:     Eric Dumazet <edumazet@google.com>
Cc:     Uladzislau Rezki <urezki@gmail.com>, paulmck@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Dmitry Safonov <dima@arista.com>,
        rcu@vger.kernel.org
Subject: Re: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
Message-ID: <Y44HNfuR5OgfEXxV@pc636>
References: <CAEXW_YRW+ZprkN7nE1yJK_g6UhsWBWGUVfzW+gFnjKabgevZWg@mail.gmail.com>
 <21A10014-22D8-4107-8C6C-14102478D19B@joelfernandes.org>
 <Y43RXNu0cck6wo/0@pc636>
 <CANn89i+RNj0gaJCyNUyrMBpSTsxSgjW1YN_FuRW_pMUOMiQtuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+RNj0gaJCyNUyrMBpSTsxSgjW1YN_FuRW_pMUOMiQtuQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Dec 5, 2022 at 12:09 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> >
> > Hello, Eric.
> >
> > > +rcu for archives
> > >
> > > > On Dec 2, 2022, at 7:16 PM, Joel Fernandes <joel@joelfernandes.org> wrote:
> > > >
> > > > ﻿On Sat, Dec 3, 2022 at 12:12 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> > > >>
> > > >>> On Sat, Dec 3, 2022 at 12:03 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> > > >>>
> > > >>> On Fri, Dec 02, 2022 at 11:49:59PM +0000, Joel Fernandes wrote:
> > > >>>> On Fri, Dec 02, 2022 at 05:28:47AM +0000, Eric Dumazet wrote:
> > > >>>>> kfree_rcu(1-arg) should be avoided as much as possible,
> > > >>>>> since this is only possible from sleepable contexts,
> > > >>>>> and incurr extra rcu barriers.
> > > >>>>>
> > > >>>>> I wish the 1-arg variant of kfree_rcu() would
> > > >>>>> get a distinct name, like kfree_rcu_slow()
> > > >>>>> to avoid it being abused.
> > >
> > <snip>
> > tcp: use 2-arg optimal variant of kfree_rcu()
> > Date: Fri,  2 Dec 2022 05:28:47 +0000   [thread overview]
> > Message-ID: <20221202052847.2623997-1-edumazet@google.com> (raw)
> >
> > kfree_rcu(1-arg) should be avoided as much as possible,
> > since this is only possible from sleepable contexts,
> > and incurr extra rcu barriers.
> >
> > I wish the 1-arg variant of kfree_rcu() would
> > get a distinct name, like kfree_rcu_slow()
> > to avoid it being abused.
> >
> > Fixes: 459837b522f7 ("net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Dmitry Safonov <dima@arista.com>
> > Cc: Paul E. McKenney <paulmck@kernel.org>
> > <snip>
> >
> > Could you please clarify a little bit about why/how have you came
> > up with a patch that you posted with "Fixes" tag? I mean you run
> > into:
> >   - performance degrade;
> >   - simple typo;
> >   - etc.
> 
> Bug was added in the blamed commit, we use Fixes: tag to clearly
> identify bug origin.
> 
> tcp_md5_key_copy()  is called from softirq context, there is no way it
> could sleep in synchronize_rcu()
>
So it was a typo then. How did you identify that BUG? Simple go through
the code? Or some test coverage?

Thank you!

--
Uladzislau Rezki
