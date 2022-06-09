Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AA1545229
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 18:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbiFIQkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 12:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238148AbiFIQkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 12:40:16 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52B2178552
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 09:40:14 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id y15so17563540qtx.4
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 09:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5XK4RTaIhjSyzNFItO7hitIZ5rV7BQTiI9os+bmtjQY=;
        b=XqWGG+zBrnCM6Uqj7ziNEq3SZtVxq2ZODNcTQRXl8+85IdPCTm5ysEKmdsh1ppcDUq
         IrKgrUqXrYk7ibhVYW5keV5DWcpEJvXHY/HwiBx642DA81MToNFZOFsZ4m4l+Y79JUrE
         2ktsKdjbqq1HG7MxGuXRF9JMXih4ZyOYY2d4nNZOn4dkCL/73YtOUg8tsUHZ3p+NA79t
         SL/PPE3kwG/v5jKFyZJTmqi3UEyyhAl870aSsG/Flwcx0WQT0Mu5o2Pga7IbieBF+Li7
         z1otvk+Yc8ISz2Qa2/oXc7RuOHzn3ntgQJVENBia2PjhjUPX8GF2CV67vOUdSExRxGmM
         PR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5XK4RTaIhjSyzNFItO7hitIZ5rV7BQTiI9os+bmtjQY=;
        b=MHLmxAaLkiwbC7V++mMOheI8jQ0npWc5NprzX/TCv2Td65mVwD+thDsOkDXyp0CzIY
         OzoHqMT/fAe0JjmZWRe1nkD1lMJTek6owavKwIfOGG1X7oMt95csz49iGj3YxJs71YX+
         jMtz0R/clgBfAoBD3PYpZXDyTFOojPkgW7lk3L6jvguxgfT9gkC2iQ7n6YmSaqBoBOgq
         l8+9eN7B6CaEEHhWxnmRAWfniTms0Tw42yExfOLRv2ljgBlAv1n5rNm4FjGZvNKJsWlw
         hnlU6pZKWU8aoXE8z2QR648NpdfVkjFxYQXxpQXyhhgWESZnuz2NNHaIeQutKF1HT8+6
         4i0g==
X-Gm-Message-State: AOAM5335PnNxk/1F5nTIKEuPhkiRSL3Ika4OjkstqRufGOjntU7hMZ0D
        pq8DvcLBByndaM39rfOyhpmD5hcUoAINu//O6J/iIkJRfuTmOg==
X-Google-Smtp-Source: ABdhPJzzA1TuRGB8PpK8R5eW/CVTE5zwIWJ5Uu6mVtRMkncJx9J/ZYBjlD9mGQtH6SCXjeHUtEQfFLzXUJcZeCfFwfE=
X-Received: by 2002:a05:622a:180e:b0:305:8aa:a24a with SMTP id
 t14-20020a05622a180e00b0030508aaa24amr6134309qtc.429.1654792813396; Thu, 09
 Jun 2022 09:40:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
 <ed6768c1-80b8-aee2-e545-b51661d49336@nvidia.com> <20220606201910.2da95056@hermes.local>
 <CA+HUmGidY4BwEJ0_ArRRUKY7BkERsKomYnOwjPEayNUaS8wv=w@mail.gmail.com>
 <20220607103218.532ff62c@hermes.local> <CA+HUmGjmq4bMOEg50nQYHN_R49aEJSofxUhpLbY+LG7vK2fUdw@mail.gmail.com>
 <78825e0b-d157-5b26-4263-8fd367d2fb2c@nvidia.com>
In-Reply-To: <78825e0b-d157-5b26-4263-8fd367d2fb2c@nvidia.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Thu, 9 Jun 2022 09:40:02 -0700
Message-ID: <CA+HUmGhPbcY0Jr9vh5F2Mov4jbAbeLb50ugTpGNuLcDzLTqfDA@mail.gmail.com>
Subject: Re: neighbour netlink notifications delivered in wrong order
To:     Andy Roulin <aroulin@nvidia.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 7:07 PM Andy Roulin <aroulin@nvidia.com> wrote:
>
> Below is the patch I have been using and it has worked for me. I didn't
> get a chance yet to test all cases or with net-next but I am planning to
> send upstream.

Thanks Andy, the patch fixes the reordering that I was seeing in my
failure scenario.

Francesco
