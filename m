Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE2564272D
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiLELJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiLELJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:09:23 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF024B7D0;
        Mon,  5 Dec 2022 03:09:21 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id s8so17979086lfc.8;
        Mon, 05 Dec 2022 03:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Fq1/F1NL0myqtHrxXGJKtIReJGnYY6Iv7q7hOczmpX8=;
        b=gCEgR7a83j2XMpvh2i7Fo0GPG1b131fATfmRII6AmfoT7NqVqVNxuwjU3TgbnUaoxp
         REKXG4ZcPD23+Gwf8NrqgysDLJCRsnHXYiGZttqOix1pHUAsvmGELjDYTzig34yhtSTV
         lboHJ8eJ6te13N6wRvBnFOwwkxJNFNrJK3GxJOggdkZHe4Uk+4wQIjgAiFUPn4hqjyp1
         Jt1lUhD9ngvOm+M6VlHojrFE88tu6D2u2ZNYiRSOMU4ckhoFRNQXOPY0+BHjBjBIpS9y
         CUrGmyQZSQ2gOe3T2OhH3XNg2fLfibet3wTC/hjDtRwvlWCQtCy7iyRoZLvX4sRUXdxM
         MVWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fq1/F1NL0myqtHrxXGJKtIReJGnYY6Iv7q7hOczmpX8=;
        b=jUu3/mu2/NYTj7FlIVCQ6XAFWi21cc6KUZfif5veaYwArm2Ei4HMsrB5nIk4LcP3tG
         1WGd1rjQnJEVVqv6We2k75BC8OWM7OxzzGyvhKX7k61xNaRa/lpRjJvYiP0AwvhGlU4h
         /yBoB67bZweHj00yTuqMe1cj5ceqx9UC+c6UghAcfNXIMpXEXCASG+1M2ZFuLo0EyaSO
         TBpxaTWQIwc2aQz/HStyydPhGGMAzxen5Ev60AtUZnDr6CC9AaRm5qn1nafPqqxYou73
         4V3ZYZACnGUn0OE4+i83jwZP812ELZonVG7srMBSnhBU99wc9juj9Rno8B0YxOMc7nbF
         pdRQ==
X-Gm-Message-State: ANoB5ploScOPs7K4MhEJ59/n0dlFHPLlAr0Fdjt3FBgrQvMO3WKUZefu
        B0JWaD4WgCtpys8ycwKVf4w=
X-Google-Smtp-Source: AA0mqf55SfZgj07Iw0ay+yC4hXgIVwbwsdunGZxYsaFkaX4LuPRUxe4MxHmJ/4/jovYu2mgGcSgsTA==
X-Received: by 2002:a05:6512:1687:b0:4b5:4637:3715 with SMTP id bu7-20020a056512168700b004b546373715mr5423545lfb.308.1670238560005;
        Mon, 05 Dec 2022 03:09:20 -0800 (PST)
Received: from pc636 (host-90-235-25-230.mobileonline.telia.com. [90.235.25.230])
        by smtp.gmail.com with ESMTPSA id w13-20020a05651c118d00b0026c42f67eb8sm1164863ljo.7.2022.12.05.03.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 03:09:19 -0800 (PST)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date:   Mon, 5 Dec 2022 12:09:16 +0100
To:     Eric Dumazet <edumazet@google.com>
Cc:     paulmck@kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Dmitry Safonov <dima@arista.com>,
        rcu@vger.kernel.org
Subject: Re: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
Message-ID: <Y43RXNu0cck6wo/0@pc636>
References: <CAEXW_YRW+ZprkN7nE1yJK_g6UhsWBWGUVfzW+gFnjKabgevZWg@mail.gmail.com>
 <21A10014-22D8-4107-8C6C-14102478D19B@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21A10014-22D8-4107-8C6C-14102478D19B@joelfernandes.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Eric.

> +rcu for archives 
> 
> > On Dec 2, 2022, at 7:16 PM, Joel Fernandes <joel@joelfernandes.org> wrote:
> > 
> > ﻿On Sat, Dec 3, 2022 at 12:12 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> >> 
> >>> On Sat, Dec 3, 2022 at 12:03 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> >>> 
> >>> On Fri, Dec 02, 2022 at 11:49:59PM +0000, Joel Fernandes wrote:
> >>>> On Fri, Dec 02, 2022 at 05:28:47AM +0000, Eric Dumazet wrote:
> >>>>> kfree_rcu(1-arg) should be avoided as much as possible,
> >>>>> since this is only possible from sleepable contexts,
> >>>>> and incurr extra rcu barriers.
> >>>>> 
> >>>>> I wish the 1-arg variant of kfree_rcu() would
> >>>>> get a distinct name, like kfree_rcu_slow()
> >>>>> to avoid it being abused.
>
<snip>
tcp: use 2-arg optimal variant of kfree_rcu()
Date: Fri,  2 Dec 2022 05:28:47 +0000	[thread overview]
Message-ID: <20221202052847.2623997-1-edumazet@google.com> (raw)

kfree_rcu(1-arg) should be avoided as much as possible,
since this is only possible from sleepable contexts,
and incurr extra rcu barriers.

I wish the 1-arg variant of kfree_rcu() would
get a distinct name, like kfree_rcu_slow()
to avoid it being abused.

Fixes: 459837b522f7 ("net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Dmitry Safonov <dima@arista.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
<snip>

Could you please clarify a little bit about why/how have you came
up with a patch that you posted with "Fixes" tag? I mean you run
into:
  - performance degrade;
  - simple typo;
  - etc.

Thank you.

--
Uladzislau Rezki
