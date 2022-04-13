Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32284FF9BF
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbiDMPJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236359AbiDMPJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:09:24 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B622DD59;
        Wed, 13 Apr 2022 08:07:02 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id g21so2176245iom.13;
        Wed, 13 Apr 2022 08:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=TuXEAXXN4FdSFvJmY2E4QvZOQcDvisndriIsWDy+9fM=;
        b=GsB2Ev82NreMGIA8uvogn0/9XQwMfmY0tB/CqgJotJzPJcasMXnVVtFZV/Svy8sjJr
         3TBiO6P8VfKQ/MvpvZqDAC9MmdbMWU+Af4nJm8FvYKhxHb8JwuNtKztNql7j6t3KgJGG
         x3yHEvVBRXwkcv68HHNHy05m1+Fx3Vk6YO2mfHnZt413ma9wYxAq6EXvevDwzd751saF
         B4y0Qz8EQRMCrON7tD8ZcSDg9SYB0elOygDtkJ1gDy2i4pwlq5IexWnH3knMd+3ucuMB
         46r4hF0bFSpnlmnNboHGCzUbNpaJ+wWUyfOZIj8t/Glc2QK/TKdMQ0f+sLyFikryfC71
         AHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=TuXEAXXN4FdSFvJmY2E4QvZOQcDvisndriIsWDy+9fM=;
        b=HGdvp8lWGpsB87JmZg6xq56qS8ln8hoGVuyZiw42XU7Nt0X+bX23P1NV6mCSs2+QcT
         iuE/TcsOu5g6V10yd13tbjiwO51fPz8gR+rPSlMRGamtbWoo2odhGgrR+f0P1eUiaiP2
         wO8rXHBQnJgM9oeoCNlttYnWsiMRRGqk1lL25WDpifnPl4vm8e8NIETKB7Bx0hGFBaGQ
         4bAEILgXUWBKb2pCbtkAED4v7N+j5uWaTfPgWbIT0AhpJalmq2JFkjn16Tm+zF+E0gs4
         8z/aNcA3N0ieYLfkPCqmKV2jvYplRjLxOvl3yvMoBx1K1FAEerEUkN0JRubWpO/GvOOh
         SIHw==
X-Gm-Message-State: AOAM530K4XZeZKBveJvqCUrSa6+I2m/pF0qzj2MFR0YbUGrj+Jt/hay+
        9Q8Uet4CSN18nQof8aXPjYGb94CB44/edlGHdlE=
X-Google-Smtp-Source: ABdhPJyZJj8/LyhFi/9KtP4n919c6CzmL+rXMvY3/qS+0Hkx0Bp9k/E4yK/B83BABc3bRgsV1lBl6u764Dl9PPlX3EE=
X-Received: by 2002:a6b:f60d:0:b0:645:b224:8d45 with SMTP id
 n13-20020a6bf60d000000b00645b2248d45mr18223544ioh.131.1649862421930; Wed, 13
 Apr 2022 08:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220411154210.1870008-1-linux@roeck-us.net> <afd746404a74657a288a9272bf0c419c027dbd06.camel@intel.com>
In-Reply-To: <afd746404a74657a288a9272bf0c419c027dbd06.camel@intel.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 13 Apr 2022 17:06:26 +0200
Message-ID: <CA+icZUVEfKcGi7ME3hoyinz2VQxLKhCXgwDA2K3AB7MEK-bveQ@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
To:     "Greenman, Gregory" <gregory.greenman@intel.com>
Cc:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 11:56 AM Greenman, Gregory
<gregory.greenman@intel.com> wrote:
>
>
> On Mon, 2022-04-11 at 08:42 -0700, Guenter Roeck wrote:
> > In Chrome OS, a large number of crashes is observed due to corrupted
> > timer
> > lists. Steven Rostedt pointed out that this usually happens when a
> > timer
> > is freed while still active, and that the problem is often triggered
> > by code calling del_timer() instead of del_timer_sync() just before
> > freeing.
> >
> > Steven also identified the iwlwifi driver as one of the possible
> > culprits
> > since it does exactly that.
> >
> > Reported-by: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Johannes Berg <johannes.berg@intel.com>
> > Cc: Gregory Greenman <gregory.greenman@intel.com>
> > Fixes: 60e8abd9d3e91 ("iwlwifi: dbg_ini: add periodic trigger new API
> > support")
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > v1 (from RFC):
> >     Removed Shahar S Matityahu from Cc: and added Gregory Greenman.
> >     No functional change.
> >
> > I thought about the need to add a mutex to protect the timer list,
> > but
> > I convinced myself that it is not necessary because the code adding
> > the timer list and the code removing it should never be never
> > executed
> > in parallel.
> >
> >  drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
> > b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
> > index 866a33f49915..3237d4b528b5 100644
> > --- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
> > +++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
> > @@ -371,7 +371,7 @@ void iwl_dbg_tlv_del_timers(struct iwl_trans
> > *trans)
> >         struct iwl_dbg_tlv_timer_node *node, *tmp;
> >
> >         list_for_each_entry_safe(node, tmp, timer_list, list) {
> > -               del_timer(&node->timer);
> > +               del_timer_sync(&node->timer);
> >                 list_del(&node->list);
> >                 kfree(node);
> >         }
>
> Hi Kalle,
>
> Can you please pick it up to wireless-drivers for the next rc?
> It is an important fix.
> Luca has already assigned it to you in patchwork.
>
> Thanks!
>
> Acked-by: Gregory Greenman <gregory.greenman@intel.com>

I have tested this on top of Linux v5.17.3-rc1.

Feel free to add my...

Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # Linux v5.17.3-rc1 and
Debian LLVM-14

- Sedat -
