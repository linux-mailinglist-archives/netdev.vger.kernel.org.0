Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4C75F0E6F
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 17:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiI3PHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 11:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiI3PHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:07:07 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389561581B
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 08:07:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 10so605226pli.0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 08:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=vO92sWDbKjH2JfK+3czl3ktWxvUiB87fH3eQStVDESg=;
        b=HbpU5K2lHkHxlQIfpheT9U/C9Sypdfr21sXug86JWbimiMROPa2ZM+S84Fh6lOJfCQ
         DKxM71QebMBcFV4crzzFTlKReZP522Wpbh2G+s2BAG4Tw+y7FrFTJLbPwoHvunfHFt+W
         lFnlQbmRliajbGQYJEjM5B10fbsjissQcrJMRxUvYvRa92yGKOgUl+fYsEuOtU70f7tD
         7n7+aczdklHP2qcufWCO3VatWYRW0UfzRBZsW2eL6xk2/2I2YLAbzK/ps8TVvd2WLgoE
         4aKPqg65MsYlt4KLavoMc8Z8whfMb0ssuCGnhr1LiYpGxDNUAd54283Vrsf7yVbgK53O
         c98w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vO92sWDbKjH2JfK+3czl3ktWxvUiB87fH3eQStVDESg=;
        b=nEj6kWtu2TRF/1oM8oGoiMCmV6X99CuckPXtkNyO3YuOVsgmRxK1GK+09jv7mEiHTD
         P9QhjSbHmzrY6j29JoZ1WOorggN9MjKiKkRkgHLnn/XFzdlpWpdCT3yw8w1xrh+Ocz7+
         b0cchXB8e8YGZgAOEapnONyi7vBjtD1bGYfC0GMXMqj7FcywKnuJNcGrulH3DHr+8qa5
         A9zKDy/FpZB2A/JASRWTvlr+0HR5HfVq9t6WJKO+gTQG03BTPKjkiCHcKlmQRnEt42ES
         h8x9su/+h8F6E8akLRiI1wlWNcZmynINlQzzNTJ9NCNbdpBm6vWTqLSvhjkCT81UASJ6
         KxgQ==
X-Gm-Message-State: ACrzQf0leyd7912JCg4D3Wsfs5OSCqKHFmYf3PDSmVfjwslIzLeFyoO0
        VR0wd0rPC54/3nTparFV9jR7oxUBYoIxpQ==
X-Google-Smtp-Source: AMsMyM5FezwPRK7mnePu2GXZ+KrOa+NKCPDmiYT3UkIhfWyMIWnrJpVZaMhcJiyUkm4SDMPKkSKPXQ==
X-Received: by 2002:a17:902:c94f:b0:178:4423:af05 with SMTP id i15-20020a170902c94f00b001784423af05mr9485729pla.147.1664550425699;
        Fri, 30 Sep 2022 08:07:05 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id p189-20020a625bc6000000b005459e8a103asm1910210pfb.167.2022.09.30.08.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 08:07:05 -0700 (PDT)
Date:   Fri, 30 Sep 2022 08:07:03 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: Remove DECnet leftovers from flow.h.
Message-ID: <20220930080703.43132033@hermes.local>
In-Reply-To: <2796f9d0c6bf31128f9330d6a3ef9e863f833c40.1664548584.git.gnault@redhat.com>
References: <2796f9d0c6bf31128f9330d6a3ef9e863f833c40.1664548584.git.gnault@redhat.com>
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

On Fri, 30 Sep 2022 16:37:30 +0200
Guillaume Nault <gnault@redhat.com> wrote:

> DECnet was removed by commit 1202cdd66531 ("Remove DECnet support from
> kernel"). Let's also revome its flow structure.
> 
> Compile-tested only (allmodconfig).
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
