Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8DC5BD37D
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 19:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiISRSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 13:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiISRSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 13:18:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BB812636
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 10:18:05 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so8012511pjm.1
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 10:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=UvF3ChZ5CPia+qy6sW6VFFCUj20iQ5Qoy4ycYXn5ik0=;
        b=otZn0oZxT1Qijj6pytiCU/JnRuXtd8mM9m8F0RnNkaTQrF7+VTpUmaEzW7YQw+JBkj
         jOpCLnAFvH2auDV8EhiZtVQz5H5i8OzgROTpTchp2Y1zE8/fQBi1bHR124urZK7lH5xx
         iGGWocMsbTXIMdz+/uaZldH7uKlbP8ts4YCSW5X4EWi2Bx3aZhNsKekLSS3DIw2FbNtN
         P2OxoIYyjeh14+fZHIzUUCQvOB5WXu5jDUR0hVIQggW995k/xnFw9AbnDeBi8LyNZOwU
         pHrttan/6idth7aOxBNgWm7JS6QbaGL57tPRSgyKWBcrMKQHF4q4bt6rYmJCuPzFtYKD
         Zz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=UvF3ChZ5CPia+qy6sW6VFFCUj20iQ5Qoy4ycYXn5ik0=;
        b=5JEb0hDhdQ+wz9gTtQisdtryTD86hn07JNW/Ut+LaSBNoXVT7WuKUaEcegGu3+MJ3E
         ITAFX8T1M3ChMs8BjxEvqQZsJDE8fK2hsKI8Xa5SE0bLJ8RcBsd1PoIvoNK8z15rkuVe
         NxlJc3bkRTT1QF/BGXJDPf2OVkAaHsgkj/emjGlG/OgooOMHiRf7eGwVUSHTpm7IsxCm
         zVO3q/6isa0Iy9QPKpz30f+bzTVoqB7VWfYq4ivNXIt6cDaH/3Gx2a6fMdY5PYikSsx5
         yCvC+IcIhvhi+l3LmqHySbY6qW01TucvmqUAgu3jbPeL7LxUGAXKySg9z95/ZrQKHpTo
         uFKg==
X-Gm-Message-State: ACrzQf13w0IWNyENOU0GUiLoeAO7hQuGp5Ha4rzbdCH923RUep2uaEiG
        MAGAOiFomTzhFRzFj/LWhdsbRw==
X-Google-Smtp-Source: AMsMyM48dXu+c0+/2TGKMOAVU3rcHgR8dmZhvCmBqnf5kKavR3I0ueEqf6P54qFRkZXeorjv4AP1HA==
X-Received: by 2002:a17:90a:641:b0:202:8568:4180 with SMTP id q1-20020a17090a064100b0020285684180mr21384606pje.227.1663607884490;
        Mon, 19 Sep 2022 10:18:04 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902a38f00b001785dddc703sm11864039pla.120.2022.09.19.10.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 10:18:04 -0700 (PDT)
Date:   Mon, 19 Sep 2022 10:18:02 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Patrick Rohr <prohr@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        "Maciej =?UTF-8?B?xbtlbmN6eWtvd3Nr?= =?UTF-8?B?aQ==?=" 
        <maze@google.com>, Lorenzo Colitti <lorenzo@google.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] tun: support not enabling carrier in TUNSETIFF
Message-ID: <20220919101802.4f4d1a86@hermes.local>
In-Reply-To: <20220916234552.3388360-1-prohr@google.com>
References: <20220916234552.3388360-1-prohr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Sep 2022 16:45:52 -0700
Patrick Rohr <prohr@google.com> wrote:

> diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
> index 2ec07de1d73b..12dde91957a5 100644
> --- a/include/uapi/linux/if_tun.h
> +++ b/include/uapi/linux/if_tun.h
> @@ -75,6 +75,8 @@
>  #define IFF_MULTI_QUEUE 0x0100
>  #define IFF_ATTACH_QUEUE 0x0200
>  #define IFF_DETACH_QUEUE 0x0400
> +/* Used in TUNSETIFF to bring up tun/tap without carrier */
> +#define IFF_NO_CARRIER IFF_DETACH_QUEUE

Overloading a flag in existing user API is likely to break
some application somewhere...
