Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2867A150884
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 15:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgBCOgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 09:36:42 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34986 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgBCOgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 09:36:42 -0500
Received: by mail-lf1-f67.google.com with SMTP id z18so9890987lfe.2
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 06:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iA3rUy3IoAWcEhvKqIMVKBY7EMaXCbeC/wQFr/zEBC8=;
        b=bnGkNQqzdhbTbt8WvqziR+ZMLt7qP3qFh87hpVl6Ik5s45rNmx3B86MMswyF/ebf0+
         vhR729XnR+sil3EjiJ+GRyGFLhpR3g+Upxajzi1QeLzfSR7SCzfHcn8STu6hf3hXKWp4
         Cd89gexkOJhEpkm69ow749j39gLlJ/24iQEQ9LOCZX6n2oYmYyingY6Q/3T0T8VWKWjT
         a8eKxS84ms+XqrU5+FDtEOc9XQELUVobZXe0tHYmekpzxDfsraXIifhQxOYTaCGXzJWv
         FTZ+fXpKlyP9R8L/PdV8aQtRFRo+LWiWBnXb/aMz9xM67pLjeFakvkFk3AVZvpekn0Nl
         oesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iA3rUy3IoAWcEhvKqIMVKBY7EMaXCbeC/wQFr/zEBC8=;
        b=I2f50C7SG5Cj7NCIez1yLSSmyQvgBd1NUhU0/3ep2Uad2/MgHR/sSSiM6rHQL19r0j
         R2U/A8xbOoaEyPz+sgQ/J8QRqvd+jZWHj9oZVE2gvSgziCKvCjpOqxpp9fMV7ifJ6vEn
         ibix46pT+8e/nwk0zFKBP1YRxDqgq8Me/GfZ5W+XTGJ8im7g4uuBpqKm/4uDSY8nkB0d
         C8i/F/SCm7SBQevzD1kVG3EfXCt1AZHog1SrUpsdxjRN9CZPCAPfaLLWkTNx2YCuqWyB
         s4+RwKjBQjfpN4ztQ7u9bZsOet335xffqtjVlXShW9PV9shzNpz/9mV7UYMKR8GNThXb
         xf0w==
X-Gm-Message-State: APjAAAXO5yhfLDM1aKzE8urv/FTAjlP8fZ3MMRWf5NRI1L4mFie+B6U9
        UELgY/bXm6yoyNnWaIxlRyzM+8e0zKqfOxoA6oHEHQ==
X-Google-Smtp-Source: APXvYqyXaJHMzbkRw4mSvBmKyB+YnINAn5BX43Rdq3hG9xzSHuk7HbLKptOyDQfEJsD4Z8u08WEZ8wnckynIm7s0Iao=
X-Received: by 2002:ac2:5e7a:: with SMTP id a26mr12251947lfr.167.1580740599926;
 Mon, 03 Feb 2020 06:36:39 -0800 (PST)
MIME-Version: 1.0
References: <20200124132656.22156-1-o.rempel@pengutronix.de>
 <CA+G9fYsxOouFBgCBacXzdimJUfZ3DXVAia6XL7kCvcQX7qgOnA@mail.gmail.com>
 <7ee9df43-2efb-ba57-c8a9-301bae12c0d7@pengutronix.de> <b0aa1582-98d0-6929-da8d-879151c49654@pengutronix.de>
In-Reply-To: <b0aa1582-98d0-6929-da8d-879151c49654@pengutronix.de>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 3 Feb 2020 20:06:28 +0530
Message-ID: <CA+G9fYv8mnoSoJp0fw4TqpoJweSh0C2KVih=f9MYK20=H=6fGA@mail.gmail.com>
Subject: Re: [RFC] can: can_create_echo_skb(): fix echo skb generation: always
 use skb_clone()
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        dev.kurt@vandijck-laurijssen.be, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org, linux-can@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        wg@grandegger.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Feb 2020 at 19:22, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 2/3/20 2:48 PM, Marc Kleine-Budde wrote:
> >>> WARNING: CPU: 0 PID: 293 at lib/refcount.c:25 refcount_warn_saturate+0x108/0x174
> >>> refcount_t: addition on 0; use-after-free.
> >>
> >> FYI,
> >> This issue noticed in our Linaro test farm
> >> On linux next version 5.5.0-next-20200203 running on beagleboard x15 arm device.
> >>
> >> Thanks for providing fix for this case.
>
> Please look closely at your backtraces, they are totally unrelated. It
> seems the whole culprit in your testcase fails with:
>
> > [    0.000000] OF: ERROR: Bad of_node_put() on /ocp/interconnect@4a000000/segment@0/target-module@8000/cm_core@0/l4per-cm@1700/l4per-clkctrl@28

I have reported on another email regarding this dtb issue.

>
> ...the rest are subsequent faults.
>
> > Can we add your Tested-by to the patch?

We generally test linux mainline, linux-next, LTS 5.4, 4.19, 4.14, 4.9
and 4.4 branches.
When issue like this found and with a proposed fix patch.
I do schedule it for apply patch and test and report it back on email thread.

- Naresh
