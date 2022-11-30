Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D2063E3B9
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiK3Wxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiK3Wxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:53:35 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDBA91340;
        Wed, 30 Nov 2022 14:53:34 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id m19so62828edj.8;
        Wed, 30 Nov 2022 14:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=he18Ty+t21/VkUIeC4fWtq21Akv8TgmBIxHJZ1ebQ1U=;
        b=WLZIDOBQgShvIp7ewHs19YFK5aqftgWuYsyvhgBmsNX2lVv7oZZLCVlHy667bbv9Rc
         S0MuR21M9eXZxtyDNUaF1FSzcNyQu/e9ufad9bk5xiJ7LLoTc+yABHGy5RWM6rrTDoS6
         nKmgryacxPuSVJq3ZmTzoT3M2TUOFsOOmWlyeVfOntnRz1Pnhn2n1boY/L7fN6i2CzQh
         AYqzgxHA+Dt8eBDOS9bFmuW+USDw8tSy1zVVLqQZIwJUoRokSIhmZyfthvghKiII3TuK
         3KapBHbpcxzYCid/HAvHf4IUGsz5nalSRjZfTqpqhASye1rh6xdVQS7/xQrbh3g+moBZ
         klkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=he18Ty+t21/VkUIeC4fWtq21Akv8TgmBIxHJZ1ebQ1U=;
        b=3ySxfDZkc7RF7IHKKOAuB3F/2/RVA6UuuzUDZEldlXFwaZ28qEB2t2dEP09uM19wvc
         4rKAJMtxsbl7bUZNcmB8d8NhV/g0UC40lfXkpYdKAQyTW8uTICEPtIZTklGtex5Nnlpg
         wXsj+NjGC+5/j9jNwBto0VXime3xnvYsd2kodpBKe0Ukv5okpw93/Lj6+ZqiyF0IDKZd
         xFgSvxa7V665VwVANQYbLtJSHuccZO2MqfIPjsQGLhIBEBuvgvChJKOmSTKeQpwcAFC7
         GsrgzY3sWXb/i8DJE0RsPWEW8AN4Q06zaOVLkphL9YUPFrDzVaJuOAB1kwCrYmPcf7qs
         SoOw==
X-Gm-Message-State: ANoB5plnFUL2nDR/UgJHT4tWrzfgotfQ2BIfhj+3L7d9VcD/2jBmFV/Q
        hliOeTe5fJZKKFFHEKz0Eqo=
X-Google-Smtp-Source: AA0mqf6M1wP3ap0tq4chTXF0kdMGnO1/4tVEvS3kNMGEhDjfcYAw3XMNSeiDYA6bsqx9spAYL7v5lw==
X-Received: by 2002:a05:6402:1a:b0:467:30ad:c4ca with SMTP id d26-20020a056402001a00b0046730adc4camr57816608edu.285.1669848813095;
        Wed, 30 Nov 2022 14:53:33 -0800 (PST)
Received: from skbuf ([188.26.184.222])
        by smtp.gmail.com with ESMTPSA id kv8-20020a17090778c800b007c0a9f3eaf1sm415213ejc.8.2022.11.30.14.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 14:53:32 -0800 (PST)
Date:   Thu, 1 Dec 2022 00:53:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Artem Chernyshev <artem.chernyshev@red-soft.ru>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] net: dsa: Check return value from skb_trim_rcsum()
Message-ID: <20221130225330.6ybtgsycioq2h73p@skbuf>
References: <20221129165531.wgeyxgo5el2x43mj@skbuf>
 <20221129194309.3428340-1-artem.chernyshev@red-soft.ru>
 <20221130224618.efk7tjv54o57lolj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130224618.efk7tjv54o57lolj@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One more thing. I gave you a Reviewed-by tag for v1. The patch submitter
is supposed to carry it over to the applicable code in future patch
revisions, below his Signed-off-by tag (see "git log" for examples).
The reviewer is not supposed to chase the submitter from one revision to
another with the same tags all over again. So I expect that v3 will have
the tag added for the tag_ksz.c related change.
