Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065712658FA
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 07:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgIKF5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 01:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgIKF5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 01:57:04 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B6BC061573;
        Thu, 10 Sep 2020 22:57:03 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id u25so7422291otq.6;
        Thu, 10 Sep 2020 22:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bXRDcpcdk/Mv5GNEux60X8UU9ajHOjMM0sdDWglatzg=;
        b=Jzm76A5J/d1K96oMaHeTblKjAR7NYcEU5JmyKqGN9TfouTYNAkZH9bYa4o4dSvuvGl
         vVTb3FWIRo1E/kicwmEyTW49kQeGF56csdG9I60QXBWjZZUo8JV+3W4+yIE2xw9arWbV
         6LEwfObp38nOgKLo2gc473gb+QeI21sPdfrB9Ky+cJY8ttK02BHNM9xg14W1/cX3W/tV
         CnVt225QGFltT7CtUNX2p0bn7FLAyfYpvdLgHjkLRaVuqsYoutPzHQSD0HAMXYxb2ZwI
         paPAE7jqIImE/1RQNc+GALcruF18UBi1TX8NsB0Mq0WwM+Tti2Wt4jTNSy5i/JV1l9Lc
         YpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bXRDcpcdk/Mv5GNEux60X8UU9ajHOjMM0sdDWglatzg=;
        b=EvysNWDEBcioW5bcXySpbPbIqdG3aqS1eK3+KlPhLJGEAX5kfo09aQLOzMYSbWgDzW
         IqfKKA/6XuUyB/XwGGGDEq8zPLvfwiTUjaslYpoAMX09CV4tKoEOYhBqSu71e0mcKR18
         zB9dfGSEMGc5j9Ipen8j8++fkyCTM2VNpd0fhLK0OhQnfmEZChgsfWHBSkN2Po/v/fkU
         W43o4LyEPCcnYsyOdMBnie1bqUlWZvGC4pa8d57ifd8InzNR/3JSEY6NvL9BXInlAgue
         LdymfVwpsiwzpDFZ2J7wwJYJYbSIfacfuVoiBfXJHaeYIpzXL/uV7+JLFQNxJ90IyAVc
         2pKg==
X-Gm-Message-State: AOAM533/3iLsyXwU6jcZbkickGGgB+3Ody/5NouZbvJty80w52gxlI8g
        d5toZAiqTTJCS4C432+98pqvIfKR1rIHRJ6+/9M=
X-Google-Smtp-Source: ABdhPJwZlCcBfE23ZIWj4B9Fbnh0ADcF5CcKkBnr4rjFillgbSG1GAfMsJ8VnQfF5J6jUdkURyR45XlLMBnhmHTGTB4=
X-Received: by 2002:a05:6830:2246:: with SMTP id t6mr242842otd.264.1599803823245;
 Thu, 10 Sep 2020 22:57:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200817084614.24263-1-allen.cryptic@gmail.com>
In-Reply-To: <20200817084614.24263-1-allen.cryptic@gmail.com>
From:   Allen <allen.lkml@gmail.com>
Date:   Fri, 11 Sep 2020 11:26:52 +0530
Message-ID: <CAOMdWSJohOLK023ZM-yTnZiNHdy2TfyyWV3+iuuQiALiYV2NLQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] drivers: net: convert tasklets to use new tasklet_setup()
To:     David Miller <davem@davemloft.net>
Cc:     m.grzeschik@pengutronix.de, paulus@samba.org, oliver@neukum.org,
        woojung.huh@microchip.com, petkan@nucleusys.com,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David,
>
> Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
> introduced a new tasklet initialization API. This series converts
> all the net/* drivers to use the new tasklet_setup() API
>
> Allen Pais (8):
>   net: dccp: convert tasklets to use new tasklet_setup() API
>   net: ipv4: convert tasklets to use new tasklet_setup() API
>   net: mac80211: convert tasklets to use new tasklet_setup() API
>   net: mac802154: convert tasklets to use new tasklet_setup() API
>   net: rds: convert tasklets to use new tasklet_setup() API
>   net: sched: convert tasklets to use new tasklet_setup() API
>   net: smc: convert tasklets to use new tasklet_setup() API
>   net: xfrm: convert tasklets to use new tasklet_setup() API
>
>  net/dccp/timer.c           | 10 +++++-----
>  net/ipv4/tcp_output.c      |  8 +++-----
>  net/mac80211/ieee80211_i.h |  4 ++--
>  net/mac80211/main.c        | 14 +++++---------
>  net/mac80211/tx.c          |  5 +++--
>  net/mac80211/util.c        |  5 +++--
>  net/mac802154/main.c       |  8 +++-----
>  net/rds/ib_cm.c            | 14 ++++++--------
>  net/sched/sch_atm.c        |  9 +++++----
>  net/smc/smc_cdc.c          |  6 +++---
>  net/smc/smc_wr.c           | 14 ++++++--------
>  net/xfrm/xfrm_input.c      |  7 +++----
>  12 files changed, 47 insertions(+), 57 deletions(-)
>
> --
> 2.17.1
>

Will you pick these up or should I send these out again when I
have fixed the two patches on the other thread.

Thanks,


-- 
       - Allen
