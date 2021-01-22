Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D6E300983
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbhAVQuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729400AbhAVQOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:14:40 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2044C06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:13:59 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id f22so3271078vsk.11
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8+g/NRfnVZLGFcDvx8fAHELJk187RHrW8PWSNrlAnk=;
        b=WSNVo6+0oBK2cG3IjqGcQfv7+Csg2Rems3GNcds6v0PCg2X3V13M8qPfjwYQHc+3VQ
         CzB5MgRh4tqLusti9t05XHIOHMZoOjsRXL5rpUtOt5TGwU/EakqZQzzoA2slfkbAyZP+
         fdnd2EDTbGcIonZkXmqzhDQVKuUQDougJYnh6sZ/OFBL1NMD0lsJmQomyhYzvi2s4RIo
         Gps6J3K/c5pSQpce8U5xq33KC6+tTVJUWjZnc9oymht+I6LIqmdQZrYvG0uEu4xYN+Uq
         PxJhbPSmu2BVaQXWFyVSMPBfVEFc4KPcq9t3kzSi2PnMPqN+XkgjPb7hGm+eDb/cjZzo
         agfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8+g/NRfnVZLGFcDvx8fAHELJk187RHrW8PWSNrlAnk=;
        b=sP2Ln7Ynx88uGUtrbzSSMANnGAVLzo3wV++H5HIDGMbqMEjctOXc/kAj+ze3N/zvc2
         FEpPX26ZONagDPxWVh4uzwmWyv6hZpU4cL3HPCz0StYhP/NP2OsDFjR4otVv5b1joeBk
         CGFPVq+bAA3x6t/D0vz4lLA6EG5PZK0egTraijFLEwcRLu/ZGlcu/z2NzQZuKWMUCfR4
         G75CHjKbKLqk1Vjl9Qf4HYoPzRGCdQY4iMlCoWbb7sWgUx4RVtW+RizNhA79+1Id9Ooj
         pl8vPOQm3PN881Dnx2IxyLhbHI3kQXZbvxh+TZJcReKYS8p0otqE/uN0jiUhz/3KeQyu
         3ZnQ==
X-Gm-Message-State: AOAM531epnLkbqxyWqbnF/uHj4xf3EkCdPgvkwddwKu4Q7k9WtegZNWH
        sIvCx0EV3FLhCBoBWuVVh7fPvgqQYgk=
X-Google-Smtp-Source: ABdhPJzk95EsPbkzpaolkjNJIZTcmZiMksYgIdyqYcsSCvUP7ghpoGXc5ry8BtNIZWCngLOuPzdlVg==
X-Received: by 2002:a67:f787:: with SMTP id j7mr1755024vso.60.1611332037988;
        Fri, 22 Jan 2021 08:13:57 -0800 (PST)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id v76sm1283541vkv.20.2021.01.22.08.13.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 08:13:56 -0800 (PST)
Received: by mail-vs1-f43.google.com with SMTP id h11so3265301vsa.10
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:13:56 -0800 (PST)
X-Received: by 2002:a67:a41:: with SMTP id 62mr1273885vsk.51.1611332035582;
 Fri, 22 Jan 2021 08:13:55 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611304190.git.lukas@wunner.de> <012e6863d0103d8dda1932d56427d1b5ba2b9619.1611304190.git.lukas@wunner.de>
In-Reply-To: <012e6863d0103d8dda1932d56427d1b5ba2b9619.1611304190.git.lukas@wunner.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 22 Jan 2021 11:13:19 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfuLfh3H45HnvtJPocxj+E7maGwzkgYsfktna2+cJi9zQ@mail.gmail.com>
Message-ID: <CA+FuTSfuLfh3H45HnvtJPocxj+E7maGwzkgYsfktna2+cJi9zQ@mail.gmail.com>
Subject: Re: [PATCH nf-next v4 5/5] af_packet: Introduce egress hook
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 4:44 AM Lukas Wunner <lukas@wunner.de> wrote:
>
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> Add egress hook for AF_PACKET sockets that have the PACKET_QDISC_BYPASS
> socket option set to on, which allows packets to escape without being
> filtered in the egress path.
>
> This patch only updates the AF_PACKET path, it does not update
> dev_direct_xmit() so the XDP infrastructure has a chance to bypass
> Netfilter.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> [lukas: acquire rcu_read_lock, fix typos, rebase]
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Isn't the point of PACKET_QDISC_BYPASS to skip steps like this?
