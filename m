Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13443473822
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 23:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbhLMW6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 17:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235493AbhLMW6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 17:58:34 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62573C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:58:34 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id f9so42031886ybq.10
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J/w+nXtHYSJuTy/H7Ckde+eVqRZ1ghhi+tKVUbCeHyM=;
        b=CiOqhEuMaW5xcAJeNTk5fyO1s0h+Vjpzt5s7JHALNU3EfIhrsTJypNrOHfc/3lfNR+
         NVVlm/SgJdXowNbRctaT4cwanqNfcvCa2PHEALALEd4ASSpnusKzdBCs16URGf+Vdjmh
         fUFS0qokWQ7+IN64/zSX2Ecy9by5hFOmbl44x6horgXnWA3n0LslXfEYUgTOOJWYUoBw
         JE2lbezIrKvj+lnK10LLWQgvKs9b6LQ8mafU90WcYRsSks/pPoAdPrx7dF8p2t9UK1s0
         7rCeb5zpdS/lujPamymv/UkbhSFUB8Y/ujMLlCvzP4jjI46DyoVvUFN7wO/IykiwXPtO
         CA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J/w+nXtHYSJuTy/H7Ckde+eVqRZ1ghhi+tKVUbCeHyM=;
        b=n7aC43rS9zvZ5aPP7Oyfc6ZiwDUpdghLnQM41J7PWVd/h1TlYXNiBWwI2MNB0SZuLj
         PQUbXuXlDbBZ+hmqxtAQ/f6uhZ6ZE0FYigZTzu+rnZ3NE1WD/SJfCHRk2elHjjSqLWfl
         FSYWXWnOGEXmzRzhehuh8cjaYhNwg6ZlBdi7EFFrd6sB69+sflqmMMUwce+h0sUcKDvY
         0++AmV0oRGbOOwIRWSVYgSEAPv0YrMM7YBEvy6J/EcKnUg4pwrxMuDcxHzxPukx9iHpN
         sYqLSIM4mqiWqyqXZnayXwBPSXRXaF6egAjTQhNhH5nAmGJi6BGiM8oYbkjhK2MBRp+h
         +bBw==
X-Gm-Message-State: AOAM531BN9SY2hP8CHPA0+HuyAVcI2OalFNJAMwG6lPVm2IRZpaD2jW7
        Fuuv2ABMaX3ghn8rTOEbtIg4BgAomP/KXGMwHqk=
X-Google-Smtp-Source: ABdhPJwVF2LO92TqC8P9Z1ConTUJHKwgNJIClFVXNiGR4XmJHY5iIWDd2t0b5IHvQQfzw5hxjriN4pFOpYcfGGRKJgk=
X-Received: by 2002:a05:6902:70a:: with SMTP id k10mr1744052ybt.120.1639436313666;
 Mon, 13 Dec 2021 14:58:33 -0800 (PST)
MIME-Version: 1.0
References: <20211210023626.20905-1-xiangxia.m.yue@gmail.com> <20211210023626.20905-2-xiangxia.m.yue@gmail.com>
In-Reply-To: <20211210023626.20905-2-xiangxia.m.yue@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 13 Dec 2021 14:58:22 -0800
Message-ID: <CAM_iQpW=tWKkrFpZR9tqNYRNA82SaHUFvy5OFpPv0AKRgzS4VQ@mail.gmail.com>
Subject: Re: [net-next v3 1/2] net: sched: use queue_mapping to pick tx queue
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 9, 2021 at 6:36 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This patch fix issue:
> * If we install tc filters with act_skbedit in clsact hook.
>   It doesn't work, because netdev_core_pick_tx() overwrites
>   queue_mapping.
>
>   $ tc filter ... action skbedit queue_mapping 1

Interesting, but bpf offers a helper (bpf_set_hash()) to overwrite
skb->hash which could _indirectly_ be used to change queue_mapping.
Does it not work?

BTW, for this skbedit action, I guess it is probably because skbedit was
introduced much earlier than clsact.

Thanks.
