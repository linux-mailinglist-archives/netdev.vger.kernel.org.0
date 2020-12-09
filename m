Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D572D44DF
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733142AbgLIOzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733146AbgLIOz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 09:55:28 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18714C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 06:54:48 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id p126so1965356oif.7
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 06:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hShlS2uVS2d9bHdBgdptUW1uO7X52rcjvewYBmPnugc=;
        b=mRoruZHNfu19Yb+tSUpKXXL5gKUvr9Kcaq62eYiEWOyget+j6YP8E8xTfViXpHGqUo
         Hb51DKMPYauiMKeieF+0DZX4+XxROvI1IDZAdNg3XGYP03nBrjcDfdVRwQ8JljxTDgdG
         TIUMRHcl//AV+RIzSlnEwOSbhB6zm5e8JpbV7pSbIkaDKjJ+pvhNWtsocdhmpD2twtns
         b9zvfsqUMaBromdknPzrVWcGyQmUVoVkew3lUp4uJHlGTrSKp1oDElGK7HrJywOshYM/
         nkgpow3D4/H69GyOF6PKuCH6wYg2/0kZ7eci6XoE2lVi6YbetkegR+xlpQAGGiHCVQdH
         BlCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hShlS2uVS2d9bHdBgdptUW1uO7X52rcjvewYBmPnugc=;
        b=ozgDJq14Nl3AOAeOFqGl4q1T+4JzoDsteygmn+Qn/sNWjciY5U4asaCjHVM5UyvbXn
         tMo/IfA5w12k8fM9FN4Xh1exmsfQW+Cv54iFJJX/Y8fkhu8LkCHTsMJvNZ61Mi1JQkuE
         aE31OWMj4g+9e5oQOuWQyc5u/+Ni9GRh+jSqem1OxWyv/FK6rwFPoFJjQOX+BdEhABzr
         Y+eFIb3lvxQIPJwgtTRwQ3IhH9ebwfgsg+rUS2o1uNn/Po7RlKZURSm947IruvqBm37G
         pqbCAHwvRJFqtTRUcLZCZeBm3TWeJ0PGCFQQ/iqIH84fLZ7w7ytmdoHNvDhXIXQDjnVK
         OTlQ==
X-Gm-Message-State: AOAM532/PYE1gW/mAHi4iGyLaSRYK0K6slI0z3QaphfQ89J+dP0YW0QM
        oREfRiEbgynQOsIS4Cn+Eu/8tauYXnE2yg==
X-Google-Smtp-Source: ABdhPJxAeu2Qyo69bHU2oHAANmQYU3W17dJZ+EAIxC7DoR5UkEDO8cMWQ2G8M2qLCgJ18ff3Iavz5A==
X-Received: by 2002:a54:4799:: with SMTP id o25mr1978228oic.33.1607525687177;
        Wed, 09 Dec 2020 06:54:47 -0800 (PST)
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id w66sm376492oib.0.2020.12.09.06.54.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 06:54:46 -0800 (PST)
Received: by mail-oo1-f51.google.com with SMTP id q20so437195oos.12
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 06:54:46 -0800 (PST)
X-Received: by 2002:a9f:2356:: with SMTP id 80mr1862380uae.92.1607525369794;
 Wed, 09 Dec 2020 06:49:29 -0800 (PST)
MIME-Version: 1.0
References: <20201209143707.13503-1-erez.geva.ext@siemens.com> <20201209143707.13503-2-erez.geva.ext@siemens.com>
In-Reply-To: <20201209143707.13503-2-erez.geva.ext@siemens.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 9 Dec 2020 09:48:53 -0500
X-Gmail-Original-Message-ID: <CA+FuTScWkYn0Ur+aSuz1cREbQJO0fB6powOm8PFxze4v8JwBaw@mail.gmail.com>
Message-ID: <CA+FuTScWkYn0Ur+aSuz1cREbQJO0fB6powOm8PFxze4v8JwBaw@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add TX sending hardware timestamp.
To:     Erez Geva <erez.geva.ext@siemens.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Ogness <john.ogness@linutronix.de>,
        Jon Rosen <jrosen@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Mao Wenan <maowenan@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Martin KaFai Lau <kafai@fb.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Xie He <xie.he.0141@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Ines Molzahn <ines.molzahn@siemens.com>,
        Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Andreas Bucher <andreas.bucher@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andreas Zirkler <andreas.zirkler@siemens.com>,
        Ermin Sakic <ermin.sakic@siemens.com>,
        An Ninh Nguyen <anninh.nguyen@siemens.com>,
        Michael Saenger <michael.saenger@siemens.com>,
        Bernd Maehringer <bernd.maehringer@siemens.com>,
        Gisela Greinert <gisela.greinert@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 9:37 AM Erez Geva <erez.geva.ext@siemens.com> wrote:
>
> Configure and send TX sending hardware timestamp from
>  user space application to the socket layer,
>  to provide to the TC ETC Qdisc, and pass it to
>  the interface network driver.
>
>  - New flag for the SO_TXTIME socket option.
>  - New access auxiliary data header to pass the
>    TX sending hardware timestamp.
>  - Add the hardware timestamp to the socket cookie.
>  - Copy the TX sending hardware timestamp to the socket cookie.
>
> Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>

Hardware offload of pacing is definitely useful.

I don't think this needs a new separate h/w variant of SO_TXTIME.

Indeed, we want pacing offload to work for existing applications.

It only requires that pacing qdiscs, both sch_etf and sch_fq,
optionally skip queuing in their .enqueue callback and instead allow
the skb to pass to the device driver as is, with skb->tstamp set. Only
to devices that advertise support for h/w pacing offload.
