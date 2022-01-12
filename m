Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849FF48C918
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355475AbiALRIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355483AbiALRIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:08:53 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AA8C06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 09:08:53 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id bl18so3601709qkb.5
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 09:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ktD8M0DEqnZ9UOw0fjjpwpwsY/OSUY1dkaxz/ndN2o=;
        b=htPLaTgz7Y+MAIZOp/r3nuPNqn/yPYsyKfCtN6PkiI9ILGEdd7Swdk9o9omUg1I1Bd
         x/biXat/iHF1/HXgB4XTTl94Ca+zA/UzHiLoj20OYtLQJnvlXDVqviYp7lSU7WatfNUe
         OdhqGim9mRZ6E6sMNT4RGn74/lP1VY5nGGMJIcFTx9c5DeXP5ijbjy5pirGni0H+KESJ
         3uI+dh44Eg2c+CD/DF7a6V2OocagJ8s6oncWp/YJBeFK0elolKnec7rhhQjvUf6/cjbj
         bOpaoYcW6dZXR+Z237XdPCWHaVoedXQi+aYdO7/+rBMqyw/ZRyDPk/6FufHbLz/ELmVN
         9ENQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ktD8M0DEqnZ9UOw0fjjpwpwsY/OSUY1dkaxz/ndN2o=;
        b=ADH8ivLAOmlGHOdk78VU0b8O7RZnyVH4DhwnKOPPhm1If/zsxrQgKIeKwdmWzl8moN
         78WnsOEtN/q/TkDoLd1K6BHMRlUUek2t0Bfr/ziMCAtTIC1p9rjDiiz3z/ATSx0n7gQ2
         kQl77t58CJsXZlAHiYuBgaBj+ll7t5TyGdUA6hcp2eTxtRT7WPGFBjbZh41fmhwsiT4n
         cWjxJjFbsa3pRemn+gTTDffwQT4CHIr7d7v28Zp4i7jVKIeCOiWSXMh2unVK6F2BGtje
         wMz5/STQWtB7IhnYYHzQY/2d9z6qNJZDjedlAvOX+UcXNI22GMIVXUZmdIc1HepIc/P7
         Myzg==
X-Gm-Message-State: AOAM532KKKBS4x+E4w7ZjKxNa+lMGC5eLGphiw9KW7Ncj9jWEboHvnJG
        jZxB1SXby0aLCWoYe7+/we4wCFUR0VV8Vc9Zbvr0tv/9k3U=
X-Google-Smtp-Source: ABdhPJzHTNmvMfCop1CG3F3K8syCf3QtO1rkHA6TbZl/pj/FyiX+a7/kKEBsP4YXCRu54oFhfI5SZGTzmlkdYQqT1Hg=
X-Received: by 2002:a25:9d82:: with SMTP id v2mr747065ybp.383.1642007332028;
 Wed, 12 Jan 2022 09:08:52 -0800 (PST)
MIME-Version: 1.0
References: <20220112170210.1014351-1-kevin@bracey.fi>
In-Reply-To: <20220112170210.1014351-1-kevin@bracey.fi>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Jan 2022 09:08:40 -0800
Message-ID: <CANn89iJiAGD11qe9edmzsf0Sf9Wb7nc6o6zscO=4KOwkRv1gRQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net_sched: restore "mpu xxx" handling
To:     Kevin Bracey <kevin@bracey.fi>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Vimalkumar <j.vimal@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 9:02 AM Kevin Bracey <kevin@bracey.fi> wrote:
>
> commit 56b765b79e9a ("htb: improved accuracy at high rates") broke
> "overhead X", "linklayer atm" and "mpu X" attributes.
>
> "overhead X" and "linklayer atm" have already been fixed. This restores
> the "mpu X" handling, as might be used by DOCSIS or Ethernet shaping:
>
>     tc class add ... htb rate X overhead 4 mpu 64
>
> The code being fixed is used by htb, tbf and act_police. Cake has its
> own mpu handling. qdisc_calculate_pkt_len still uses the size table
> containing values adjusted for mpu by user space.
>
> iproute2 tc has always passed mpu into the kernel via a tc_ratespec
> structure, but the kernel never directly acted on it, merely stored it
> so that it could be read back by `tc class show`.
>
> Rather, tc would generate length-to-time tables that included the mpu
> (and linklayer) in their construction, and the kernel used those tables.
>
> Since v3.7, the tables were no longer used. Along with "mpu", this also
> broke "overhead" and "linklayer" which were fixed in 01cb71d2d47b
> ("net_sched: restore "overhead xxx" handling", v3.10) and 8a8e3d84b171
> ("net_sched: restore "linklayer atm" handling", v3.11).
>
> "overhead" was fixed by simply restoring use of tc_ratespec::overhead -
> this had originally been used by the kernel but was initially omitted
> from the new non-table-based calculations.
>
> "linklayer" had been handled in the table like "mpu", but the mode was
> not originally passed in tc_ratespec. The new implementation was made to
> handle it by getting new versions of tc to pass the mode in an extended
> tc_ratespec, and for older versions of tc the table contents were analysed
> at load time to deduce linklayer.
>
> As "mpu" has always been given to the kernel in tc_ratespec,
> accompanying the mpu-based table, we can restore system functionality
> with no userspace change by making the kernel act on the tc_ratespec
> value.
>
> Fixes: 56b765b79e9a ("htb: improved accuracy at high rates")
> Signed-off-by: Kevin Bracey <kevin@bracey.fi>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: Vimalkumar <j.vimal@gmail.com>

Thanks for the nice changelog.

I do have a question related to HTB offload.

Is this mpu attribute considered there ?

Thanks.
