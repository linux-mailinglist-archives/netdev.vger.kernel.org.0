Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FBF3E1D16
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240577AbhHET7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240414AbhHET7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:59:09 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90601C0613D5
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 12:58:54 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id f42so13338348lfv.7
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 12:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vEevYj21zoSQmliOP+GMeNBU1++4inbujPB40FoMVRE=;
        b=Y6sdNXACERnZgRtJfiblGNVRlF8k/of8efB8rL4qUsGwzT1eoMcbK46RBdFjsO7Xwc
         Hfv/7BQ3ZeTPsSVcChRDC7JvZFHwWjCfnij0+Vub/bgZ4OW10c3WBY1qWPx0ud0v648Z
         m00O68w2gE0PjbLMN9g03sAVgXn0Fct0sky1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vEevYj21zoSQmliOP+GMeNBU1++4inbujPB40FoMVRE=;
        b=Xnf5Uomwim4yzax6Al4R5cz4IgqYBGUSfufgsJnSqBXtciXLPH3DgrfvBCRTVd9X0a
         2hO3KrD61/BErOnjqmIzXAGmRJHx6QjXZM3zyJ8ufVWWfTpMcRmqnTwLefe55thnwhFE
         enUo84q8KV9mpVUpeJp3M3fl+fWHS28pk3hAtOtuUWNb2KXVSuy8Ic+a7+VGuhOqRVkx
         1l9qVtQCV7mj1aZr0aag8LX9FMDroVub0MapOlbBYLKc14ACNIXjps0IarP+vSb6oLug
         FxhCp+uKwOHK9nXBb/MDzkb5LdRq/8UsdA06/fOcvlCCoaVF77m+GIjgkU8dkz+U0xz9
         c58w==
X-Gm-Message-State: AOAM531ciI+jfd6jtkA+tTPnBbfREiDAbm+uw9hm9PmrOMY/rlzONus5
        po49/yw+eoFuPRpklNSqZVa6qT9MZQp5A0Ycr1M=
X-Google-Smtp-Source: ABdhPJwtXDnunJiLdSq6aXL3xWHrW4x92pfjs6yeUiBWOfYO7mqMmsD1r7BQESYFxYnYXUyzueANJA==
X-Received: by 2002:a05:6512:69:: with SMTP id i9mr5153029lfo.162.1628193532686;
        Thu, 05 Aug 2021 12:58:52 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id u2sm609270lfd.43.2021.08.05.12.58.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 12:58:52 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id n17so10685799lft.13
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 12:58:51 -0700 (PDT)
X-Received: by 2002:ac2:569a:: with SMTP id 26mr4868925lfr.41.1628193530897;
 Thu, 05 Aug 2021 12:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210805154335.1070064-1-kuba@kernel.org> <CAHk-=wi8ufjAUS=+gPxpDPx_tupvfPppLX03RxjWeJ1JtuDZYg@mail.gmail.com>
 <afa0b41f-bcb9-455e-4ea8-476ed880fbd2@infradead.org> <20210805123829.1f3a276f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210805123829.1f3a276f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 5 Aug 2021 12:58:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjtH6RFPUdOudOydvqnMJdORNAPb_uTHCPny115LZ2dSw@mail.gmail.com>
Message-ID: <CAHk-=wjtH6RFPUdOudOydvqnMJdORNAPb_uTHCPny115LZ2dSw@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.14-rc5
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 5, 2021 at 12:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Oops, I thought it was pan-European term, guess not.

Seems to be fairly widespread, but never heard it in Finnish or
Swedish (but google claims the concept is at least known in Denmark,
Norway and Iceland)

              Linus
