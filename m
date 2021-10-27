Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4273043C57B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239592AbhJ0Iu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:50:58 -0400
Received: from mail-yb1-f176.google.com ([209.85.219.176]:44881 "EHLO
        mail-yb1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbhJ0Iu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:50:57 -0400
Received: by mail-yb1-f176.google.com with SMTP id v200so4407237ybe.11;
        Wed, 27 Oct 2021 01:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mb0Y3wYj7BF8ZoJLg1h16yj+3u3ARbbLM49sVTMwbiU=;
        b=UWpZ3kYbR0zUzOWgtZJgmZ1MfMyvkCbPBJ3wdz9yYekQ2q78ZDU2ckPsFlNqgqfOWm
         9c6XlRgeDsGrhF3TXosScP4Ow9/WMD18ozrhdIOIvAT6JaFwAI2iuKuZr1IQUdbBjVd6
         /q4qqEIqAcgdL5TyrdYjr2DaRO6kKnQHpUAjFs3kA6Wae55cWnAIuCZh6p6bjb8uHqVe
         nmlUp/OBb3tyZBLFm+OCzk/llaZnFC/y835R1ArNWcZXC8DVrq8F3P9/TSge0iagWaFh
         j8O4PJMWEQkB6jylbbofwxyKh6N3UMtP9w58/HPdYBGdusMBSEBBY18SPMpSIToTXWfn
         rufA==
X-Gm-Message-State: AOAM532tgPgT/UJwuoPjjxHn3hh41YCghjeSGrhKkMfe6l2R0m6FfOJ/
        9whQTEhfNuRyC3CGhPHLJfpaM5TaQqygf2XnnRlYWeZp
X-Google-Smtp-Source: ABdhPJyDCftJnYOJsIzTQCYDuSTq0sRdPfmMZyWjt2buhsFaDh0Y0H5SncYB4sg1Lb1EH9VRBwgBk4BvEnfjBSLvjFA=
X-Received: by 2002:a25:80d2:: with SMTP id c18mr25790053ybm.113.1635324511827;
 Wed, 27 Oct 2021 01:48:31 -0700 (PDT)
MIME-Version: 1.0
References: <20211026180740.1953265-1-mailhol.vincent@wanadoo.fr> <20211027073905.aff3mmonp7a3itrn@pengutronix.de>
In-Reply-To: <20211027073905.aff3mmonp7a3itrn@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 27 Oct 2021 17:48:21 +0900
Message-ID: <CAMZ6RqKC2SXsDE2pvNw0LT9TsOHR9W-evTqzv35W+-Dtd-Peow@mail.gmail.com>
Subject: Re: [PATCH v1] can: etas_es58x: es58x_rx_err_msg: fix memory leak in
 error path
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 27 Oct 2021 at 16:39, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 27.10.2021 03:07:40, Vincent Mailhol wrote:
> > In es58x_rx_err_msg(), if can->do_set_mode() fails, the function
> > directly returns without calling netif_rx(skb). This means that the
> > skb previously allocated by alloc_can_err_skb() is not freed. In other
> > terms, this is a memory leak.
> >
> > This patch simply removes the return statement in the error branch and
> > let the function continue.
> >
> > * Appendix: how the issue was found *
>
> Thanks for the explanation, but I think I'll remove the appendix while
> applying.

The commit will have a link to this thread so if you don't mind,
I suggest to replace the full appendix with:

Issue was found with GCC -fanalyzer, please follow the link below
for details.

You can of course do the same for the m_can patch.


Yours sincerely,
Vincent Mailhol
