Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CF55D2AD
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfGBPVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:21:18 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34536 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBPVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:21:17 -0400
Received: by mail-lj1-f193.google.com with SMTP id p17so17332350ljg.1
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 08:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0TkSkngZdck7UKTXKBmDJA2j9VIjGdFPAA61I5eODcU=;
        b=KTlThSTnOE6lWvTUThYJDYVL/7CL8piTPRnDz6JcXOmmAg8MNvTDGEBh8ippIy7YMi
         xgN+zOYARvDCuA0Vk6ljON7ABQTDsqcUuUeKhZMmXLP9ecr7ak0M5/QeRB+YGTc5dQMx
         Pc7Y8nQkEudHGoAb3DpBdRcqlh+XohQsCGZvqzlyAgpA3ttu96IQYASM0jyHg6yRlwRI
         Wyh1eMycvU7sT/jiWnY/4H15x2BS17oiy5NLwQhxmMuDpkzWJfPrh39Qv3A7EE2u4owr
         cxuWzUVVO0PZprn2VzEpqbOOeuk786a+1HLhu25036vorlCqRoTzoUlT5Rwj8OrC0eOo
         uEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=0TkSkngZdck7UKTXKBmDJA2j9VIjGdFPAA61I5eODcU=;
        b=sDE4l7KpxyA5QjGRizuOxghecNMhFVdz4KkbFMuImhHj1f6+F/0fyV+Kj4VSxbluV0
         6EK+2WXaRSUP5fIednCwGrwia2yk2DS/9oqdQDFBMWtcZFDxv+lESni9zvpbUax+Klme
         bLPJ66qXddWoAznMoFgjwYC9wdad7oCJveGdFJV4xcGPVa7T7DkweInzsJcJ2aA7cwlA
         i6lfZhnMKlSwuCRuUu2txP7SpFds9pX2CrVigNzbECAX9kLlpxfAAU2kq4pyz9sE7ZGE
         M5bv4X8J704Bk/oQgktsn6zD1BLatq1xeDnLSlCgD8PQHByQGtJzm4oV6T7oc/JY/mYb
         VsTw==
X-Gm-Message-State: APjAAAW06BX364FEoMc7Uc4b4a987w0QrISOl3PLjHxwfxwfyUnS1NA2
        jj9eszEnqPMzvUPc0CghY5kSFA==
X-Google-Smtp-Source: APXvYqxO5e9n3+IyfuLwxEvPs4G0YXZWy2MJuHoj1o6g3GQB3lVvbxA4zPP4MFCS6YZb4/Wnfii+Yw==
X-Received: by 2002:a2e:9ad1:: with SMTP id p17mr18019700ljj.34.1562080876092;
        Tue, 02 Jul 2019 08:21:16 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id t21sm3009177lfd.85.2019.07.02.08.21.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 08:21:15 -0700 (PDT)
Date:   Tue, 2 Jul 2019 18:21:13 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        grygorii.strashko@ti.com, jakub.kicinski@netronome.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: core: page_pool: add user refcnt and reintroduce
 page_pool_destroy
Message-ID: <20190702152112.GG4510@khorivan>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190702171029.76c60538@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 05:10:29PM +0200, Jesper Dangaard Brouer wrote:
>On Tue, 2 Jul 2019 17:56:13 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> On Tue, Jul 02, 2019 at 04:52:30PM +0200, Jesper Dangaard Brouer wrote:
>> >On Tue, 2 Jul 2019 17:44:27 +0300
>> >Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>> >
>> >> On Tue, Jul 02, 2019 at 04:31:39PM +0200, Jesper Dangaard Brouer wrote:
>> >> >From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> >> >
>> >> >Jesper recently removed page_pool_destroy() (from driver invocation) and
>> >> >moved shutdown and free of page_pool into xdp_rxq_info_unreg(), in-order to
>> >> >handle in-flight packets/pages. This created an asymmetry in drivers
>> >> >create/destroy pairs.
>> >> >
>> >> >This patch add page_pool user refcnt and reintroduce page_pool_destroy.
>> >> >This serves two purposes, (1) simplify drivers error handling as driver now
>> >> >drivers always calls page_pool_destroy() and don't need to track if
>> >> >xdp_rxq_info_reg_mem_model() was unsuccessful. (2) allow special cases
>> >> >where a single RX-queue (with a single page_pool) provides packets for two
>> >> >net_device'es, and thus needs to register the same page_pool twice with two
>> >> >xdp_rxq_info structures.
>> >>
>> >> As I tend to use xdp level patch there is no more reason to mention (2) case
>> >> here. XDP patch serves it better and can prevent not only obj deletion but also
>> >> pool flush, so, this one patch I could better leave only for (1) case.
>> >
>> >I don't understand what you are saying.
>> >
>> >Do you approve this patch, or do you reject this patch?
>> >
>> It's not reject, it's proposition to use both, XDP and page pool patches,
>> each having its goal.
>
>Just to be clear, if you want this patch to get accepted you have to
>reply with your Signed-off-by (as I wrote).
>
>Maybe we should discuss it in another thread, about why you want two
>solutions to the same problem.

If it solves same problem I propose to reject this one and use this:
https://lkml.org/lkml/2019/7/2/651

-- 
Regards,
Ivan Khoronzhuk
