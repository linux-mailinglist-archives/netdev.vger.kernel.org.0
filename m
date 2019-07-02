Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3E85D674
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 20:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfGBS6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 14:58:46 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40704 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBS6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 14:58:46 -0400
Received: by mail-lj1-f196.google.com with SMTP id a21so18032393ljh.7
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 11:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HJRRZ7xwVWKgrrchV3QbMX/wgWRGVLbHC2E+m6l+0/o=;
        b=RxycRGr5u5OwWuZ2gNevQdwgxs7WNYCcmy6MN0Xz79Q2tNLNs9oq+9T+GtYIaKou4x
         ApR0Uy9q0zxgvGzaYSBJKVvkIoXFr2fitP7amOqfsC1+gzDKM5svTDQXAnLJRSi6kRsI
         lK/ehsnPvFZW9qpq7sF5A7L+b0lAYwspjsHRHpiLcqhVBTr7D63JpIV+329tMpzh8b8p
         TxWQUv26+Xm5H7imex4kC2lwaVpHvj+tPooHa7MKHwF4ZTeQt1PL7nBQF8/WZ2STEOsc
         kjDlnPXKKR6HCmEvt2fYSEmuRWh39ix8wP0ttAcjK6Dw6L0e5zkxQOh8ocywsKapU8H5
         +/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=HJRRZ7xwVWKgrrchV3QbMX/wgWRGVLbHC2E+m6l+0/o=;
        b=jGrS2uoiv8FHu5KPu0fH5NPffK49aVUiujAyzl0EKac/yWgh9VcfbVNk5iLLqOlFvP
         GooFvhny78g4H5H56Z0b+K67pQR1qpZT5PsUURTtvv9EB9g2XhkVMcPznJmuhIZ1DHHD
         L3EqggvHtsu9iWG9g/On0MpjCaqTfGiUozji+0Yl8HlPo6b9UPGsYQv5IFWZ1fcOiQgb
         gbBGKHjtRMeWBElgvMVKIIbgSkT8Ul8fr08vyOMzZUg0sT3BnZVxk8ttQTwxmeiAHmEI
         gSWKvNEmGMNJFtGb8dPe5ZWrewh/YGbbEJEamycQQA4/C6cmYgKc/7vLsQCP25xG4eu2
         FMUw==
X-Gm-Message-State: APjAAAV2oPQtEGLjak5CNNlFZ1u9PZEJ3lkI1vbVBH4hjkb9PXZd/5+C
        ZeLzLM32OFmj/WwCVGsrtxQP4g==
X-Google-Smtp-Source: APXvYqwOnRz12ZXWfwVkH3WodU4LhkeAYjXfGRaMtJWg1mdkdc5MbazZkwv/mQfmjb288oDC/euaTw==
X-Received: by 2002:a2e:730d:: with SMTP id o13mr517630ljc.81.1562093923391;
        Tue, 02 Jul 2019 11:58:43 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id o8sm842315ljh.100.2019.07.02.11.58.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 11:58:42 -0700 (PDT)
Date:   Tue, 2 Jul 2019 21:58:40 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        grygorii.strashko@ti.com, jakub.kicinski@netronome.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: core: page_pool: add user refcnt and reintroduce
 page_pool_destroy
Message-ID: <20190702185839.GH4510@khorivan>
Mail-Followup-To: Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        grygorii.strashko@ti.com, jakub.kicinski@netronome.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <20190702153902.0e42b0b2@carbon>
 <156207778364.29180.5111562317930943530.stgit@firesoul>
 <20190702144426.GD4510@khorivan>
 <20190702165230.6caa36e3@carbon>
 <20190702145612.GF4510@khorivan>
 <20190702171029.76c60538@carbon>
 <20190702152112.GG4510@khorivan>
 <20190702202907.15fb30ce@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190702202907.15fb30ce@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 08:29:07PM +0200, Jesper Dangaard Brouer wrote:
>On Tue, 2 Jul 2019 18:21:13 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> On Tue, Jul 02, 2019 at 05:10:29PM +0200, Jesper Dangaard Brouer wrote:
>> >On Tue, 2 Jul 2019 17:56:13 +0300
>> >Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>> >
>> >> On Tue, Jul 02, 2019 at 04:52:30PM +0200, Jesper Dangaard Brouer wrote:
>> >> >On Tue, 2 Jul 2019 17:44:27 +0300
>> >> >Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>> >> >
>> >> >> On Tue, Jul 02, 2019 at 04:31:39PM +0200, Jesper Dangaard Brouer wrote:
>> >> >> >From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> >> >> >
>> >> >> >Jesper recently removed page_pool_destroy() (from driver invocation) and
>> >> >> >moved shutdown and free of page_pool into xdp_rxq_info_unreg(), in-order to
>> >> >> >handle in-flight packets/pages. This created an asymmetry in drivers
>> >> >> >create/destroy pairs.
>> >> >> >
>> >> >> >This patch add page_pool user refcnt and reintroduce page_pool_destroy.
>> >> >> >This serves two purposes, (1) simplify drivers error handling as driver now
>> >> >> >drivers always calls page_pool_destroy() and don't need to track if
>> >> >> >xdp_rxq_info_reg_mem_model() was unsuccessful. (2) allow special cases
>> >> >> >where a single RX-queue (with a single page_pool) provides packets for two
>> >> >> >net_device'es, and thus needs to register the same page_pool twice with two
>> >> >> >xdp_rxq_info structures.
>> >> >>
>> >> >> As I tend to use xdp level patch there is no more reason to mention (2) case
>> >> >> here. XDP patch serves it better and can prevent not only obj deletion but also
>> >> >> pool flush, so, this one patch I could better leave only for (1) case.
>> >> >
>> >> >I don't understand what you are saying.
>> >> >
>> >> >Do you approve this patch, or do you reject this patch?
>> >> >
>> >> It's not reject, it's proposition to use both, XDP and page pool patches,
>> >> each having its goal.
>> >
>> >Just to be clear, if you want this patch to get accepted you have to
>> >reply with your Signed-off-by (as I wrote).
>> >
>> >Maybe we should discuss it in another thread, about why you want two
>> >solutions to the same problem.
>>
>> If it solves same problem I propose to reject this one and use this:
>> https://lkml.org/lkml/2019/7/2/651
>
>No, I propose using this one, and rejecting the other one.

There is at least several arguments against this one (related (2) purpose)

It allows:
- avoid changes to page_pool/mlx5/netsec
- save not only allocator obj but allocator "page/buffer flush"
- buffer flush can be present not only in page_pool but for other allocators
  that can behave differently and not so simple solution.
- to not limit cpsw/(potentially others) to use "page_pool" allocator only
....

This patch better leave also, as it simplifies error path for page_pool and
have more error prone usage comparing with existent one.

Please, don't limit cpsw and potentially other drivers to use only
page_pool it can be zca or etc... I don't won't to modify each allocator.
I propose to add both as by fact they solve different problems with common
solution.

-- 
Regards,
Ivan Khoronzhuk
