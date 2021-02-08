Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666AF313B04
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhBHRdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbhBHRcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:32:51 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57213C061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 09:32:11 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id d7so12650724otq.6
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 09:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PvSNwT+Dwof25hn6VgBbWTXMj73I7g397WoC0dzBPHQ=;
        b=sb2P2eg/Ebhuqdt2OY+jSgfGPweU9YRFdDmgeYGiiJqr0SCeaiV9oL+jB0LkYNDetf
         SY9Y4JZalk1BDLFvxQV/73LLESfs0oneg10HSu5xZeTbPGZQJeIB1sCheS9E5SzLd5oP
         sVK40eFG3/7VrukNnHpofkZKALvJCt9UEPVEhpG57FKYhIIJjcKQvppWC/TfR36aDb3D
         NyLeFA51iUX2/pl+ycUqKZUTbeFQXE1gzRU2P33J5A/h4ZsmAaXe9e+vACzIigZeGM5x
         +7rFfRM/2B0VlMeTqoMRgBpKXCP1DDeC3UqJQUUkLDa1YgxMzZxaFFab9PQn78ioV+dw
         oKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PvSNwT+Dwof25hn6VgBbWTXMj73I7g397WoC0dzBPHQ=;
        b=mUE84iGMlXzvDVbjEHvRAPXOP36gYm1xfuNk01tjOQ0X6XOHaYtw0sSuZR/en7nHj2
         U8MQ3Kt2JpDCruMMLMouZsdNUKwwKo1bM82XM5uhlQE5xdnztO0CEZsDwpWpmwHUL90E
         STbPrOK57UJH8AjE5iFNSMJNmMWR+flRaDfb+UOGWnE/Loub1Rz4ejYGLxy3LSX/3SmR
         Ix2rRUegEhlT8IRqSW48vF09du4htR+l/FNho4RhzrWPpUkTg/F5+SJqIQtLjiA0oj7C
         lKACVjV76VXydHb95i+bxu3PGvixP8oVxH/uGiIQjcKq6LGsrx+ZVy15/9lqSLukUWWw
         EmDg==
X-Gm-Message-State: AOAM530FFONdAmozfpxTpuy9rW/Q4oWDrmAhCcprWWhQMAC2xlwVFBj+
        1D29Cp63DysN+TmG0KkorGSFGWaVv0fj23u3XQ==
X-Google-Smtp-Source: ABdhPJzfSR6gdVZIKZhqh9eV4DgyO85FCwvVCPD0MmWSe20TNXLWHEnxWTaGOyeeBKGy161kv9xLuWWhivdv/aZg870=
X-Received: by 2002:a9d:12f2:: with SMTP id g105mr3857691otg.132.1612805530701;
 Mon, 08 Feb 2021 09:32:10 -0800 (PST)
MIME-Version: 1.0
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <20210204215926.64377-2-george.mccollister@gmail.com> <20210207012650.ewehcarai3tep5xa@skbuf>
In-Reply-To: <20210207012650.ewehcarai3tep5xa@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 8 Feb 2021 11:31:58 -0600
Message-ID: <CAFSKS=MSV3_bQYpE38_gJX6gXm489J-m404Bf6L4C0+mSXkmVg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/4] net: hsr: generate supervision frame
 without HSR/PRP tag
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 7:26 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Feb 04, 2021 at 03:59:23PM -0600, George McCollister wrote:
> > @@ -289,23 +286,12 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
> >               hsr->announce_count++;
> >       }
> >
> > -     if (!hsr->prot_version)
> > -             proto = ETH_P_PRP;
> > -     else
> > -             proto = ETH_P_HSR;
> > -
> > -     skb = hsr_init_skb(master, proto);
> > +     skb = hsr_init_skb(master, ETH_P_PRP);
> >       if (!skb) {
> >               WARN_ONCE(1, "HSR: Could not send supervision frame\n");
> >               return;
> >       }
>
> I wonder why you aren't even more aggressive, just remove the proto
> argument from hsr_init_skb and delay setting skb->protocol to
> hsr_fill_tag or the whereabouts. This is probably also more correct
> since as far as I can see, nobody is updating the skb->proto of
> supervision frames from HSR v0 to v1 after your change.

Will do. Thanks.
