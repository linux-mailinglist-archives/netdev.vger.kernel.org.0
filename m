Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB19D263B54
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 05:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgIJDW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 23:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIJDWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 23:22:08 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B0BC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 20:22:07 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id g11so1561423ual.2
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 20:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n26IpsaC3Nl+F86KD03rhCZ/xFoW40avlTFPBZAS21w=;
        b=c9Ini2Hu5zge3tetERjAkEgOnu6eT7cQW+eWobjhWPrKQNEWi3ZIo/cA4xSe7OE5zl
         UmKwUFWjiJj4XKwGX/scQujAPAzDaieX5hL16QsYQ7UwDGvAPL5P0vhQO7OqcalDERNd
         oACCX7oyPRFz5cMwn11NKv9K+ORVIEROaOy6gxRvVdy+groJYQRekflFvm5DKCOkTUy+
         YZpITz4UnDS3fAGAOIKfuB6dhKLxM8QxiTGJeW1rFewQQyu7HF2w7QzJv+cTnjAOuuNS
         HO1CqSCgytSKeuOHTLOVO5BV6BRm6iu/MSAuSIa4azfRCsUYpNUK/90xDiYGIu3w6xk6
         d8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n26IpsaC3Nl+F86KD03rhCZ/xFoW40avlTFPBZAS21w=;
        b=kNYr9cLOOyanHKpWYPNcIS97qDc3fKsqV2/I7rhkR+E9Pc9h6sFNH2JNI2DAWOCzZ4
         iMQeHUFbgUiUUngIoGhwhpW5rj1WxSsMsQZrD32+/ryz1FgLrymnWyoR6kVb4c8KYlJO
         a9OodmabDeFvXbsxLmKHF5QjFZLimRgxOQlqn6JljQeF1jSGC70XJbZ5scY6+I/vsxKn
         UQJULQypHK9ao24WYm8GjMF9MqazKV1FF9e16lsSVG4fQe37h/wr4a/uQcbt4qHRpmma
         uVpjb8kc7mnog6ZaJarqudwJWr5IKvd8AMZ2aUU3eNeo5nDvGPp7dGBxR7LIcTmCn69v
         wSow==
X-Gm-Message-State: AOAM533H0R3NGL7qCwsUoMReJK9Xa3rT9UyBz0p5SEl/lEzG2CgRdKqQ
        EAzWbRfVFsRS+y821Vr/UnTdbpok+igTcUIZhHCdlg1YltphUg==
X-Google-Smtp-Source: ABdhPJwNcz9Mct32xY8yw/REtL3tLlCHkM/Cewct0f33bY/tBOlFrPGcPI7o91oQUoRhKxg1WghW2j8FrmeM5N/g/JI=
X-Received: by 2002:ab0:ef:: with SMTP id 102mr2538299uaj.142.1599708126423;
 Wed, 09 Sep 2020 20:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200909181556.2945496-1-ncardwell@google.com> <20200910003606.fvuupr56as4uknxn@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200910003606.fvuupr56as4uknxn@kafai-mbp.dhcp.thefacebook.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 9 Sep 2020 23:21:50 -0400
Message-ID: <CADVnQymvJTusK+UohmpzJL1_8NX+MiYagkzA5Jkvj0Ywched-w@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] tcp: increase flexibility of EBPF congestion
 control initialization
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 8:36 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Sep 09, 2020 at 02:15:52PM -0400, Neal Cardwell wrote:
> > This patch series reorganizes TCP congestion control initialization so that if
> > EBPF code called by tcp_init_transfer() sets the congestion control algorithm
> > by calling setsockopt(TCP_CONGESTION) then the TCP stack initializes the
> > congestion control module immediately, instead of having tcp_init_transfer()
> > later initialize the congestion control module.
> >
> > This increases flexibility for the EBPF code that runs at connection
> > establishment time, and simplifies the code.
> >
> > This has the following benefits:
> >
> > (1) This allows CC module customizations made by the EBPF called in
> >     tcp_init_transfer() to persist, and not be wiped out by a later
> >     call to tcp_init_congestion_control() in tcp_init_transfer().
> >
> > (2) Does not flip the order of EBPF and CC init, to avoid causing bugs
> >     for existing code upstream that depends on the current order.
> >
> > (3) Does not cause 2 initializations for for CC in the case where the
> >     EBPF called in tcp_init_transfer() wants to set the CC to a new CC
> >     algorithm.
> >
> > (4) Allows follow-on simplifications to the code in net/core/filter.c
> >     and net/ipv4/tcp_cong.c, which currently both have some complexity
> >     to special-case CC initialization to avoid double CC
> >     initialization if EBPF sets the CC.
> Thanks for this work.  Only have one nit in patch 3 for consideration.
>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Thanks for the review! I like your suggestion in patch 3 to further
simplify the code. Do you mind submitting your idea for a follow-on
clean-up/refactor as a separate follow-on commit?

thanks,
neal
