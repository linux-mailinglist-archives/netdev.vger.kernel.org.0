Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4BE612C2C
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 19:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJ3SRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 14:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiJ3SRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 14:17:09 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19716B7E5;
        Sun, 30 Oct 2022 11:17:09 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id c12so4282144uat.13;
        Sun, 30 Oct 2022 11:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=txmTGAMifC3Rn7VeWx1LArJJ7ap4F/CwQddYyX6R1NE=;
        b=WpX3scVrmev+kzik8FLaRItm/89KWJf1bhHzFPoh5KEXv2ZQpnFfblaoW54awQjB2s
         1NV76XDvI7AlONzPLjMKjcrExhnLwyj6n2TLRUebkpQCP+w9YPW3pe2qXsZSeOqN40OH
         u+8MxFhp+Bs4TIwvJ43+lT6KgmlZAq7B9lP1CpdFAzm+MIIWZaoIQxjXhDlYvOOIBjRT
         B0Et0yt2+JRayDeKGJ7lPsVUozZyxGeCPSsZly/avvfXeRVQOFJ9vEhe7KMZRqBc6tZ1
         p4QA371iqX7iZoXn9850jPPsEhCnON/f8uDV1+9b1jlH6fEBEBbFGRP6pF3ybKbPsnCS
         w3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=txmTGAMifC3Rn7VeWx1LArJJ7ap4F/CwQddYyX6R1NE=;
        b=K0862frjQ4gQdJGek29muOJufNNxLQLnWzoUKmbcUDJ8lrh4G0jnE0vXulvTpvRDYN
         KYe83zt9Km0vGRCJYbZ3eTCZ5pnKRy7LDC1qFhDD+7F28j1qT6fFCJu9FxUMhbFGt9KM
         FYVQjhudA3is4R0aFEi11bTM+MCDzpKgbEq3nMoTZJURMGoRNsBHPqo6PTt6f33SFKzo
         /X2zd5VUmpAV8MAYP1gXKX3GUnZi/fi4BQqJaBqTzvBiTtx1f9PNPsAz7xoGbioV1bUF
         iNEIhQynxgXPTTNQcDKEtDexd5uIcGhyxsFNFFQ4PP2CNrpgjKsnrSyKpZ7cbP2xzL15
         ai5A==
X-Gm-Message-State: ACrzQf3zY5WwRuoYvTm8dySg21FJf6LrHLmpygiJz8w7VFN4MUA0Bk9m
        tqMKbH5Y/R/k/r/FTaRNAfejbrNn1W5QQILbxgU=
X-Google-Smtp-Source: AMsMyM5XH/mC9fT3Up1my1hkrnC5S+0Xga5utJh3mb2B54nBrk/NFTwQK7zR8k1080Ifo3OxotHj1skxM3x/2GaWq3c=
X-Received: by 2002:ab0:6894:0:b0:40a:3623:1c81 with SMTP id
 t20-20020ab06894000000b0040a36231c81mr3302915uar.56.1667153828187; Sun, 30
 Oct 2022 11:17:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221029214058.25159-1-tegongkang@gmail.com> <80f39eff-d175-785c-c10f-a31a046ec132@molgen.mpg.de>
 <CA+uqrQDukt7u8Nvbn7RK5K+Lw8PoxO769Nf9CF9UbvM2WshXTw@mail.gmail.com>
In-Reply-To: <CA+uqrQDukt7u8Nvbn7RK5K+Lw8PoxO769Nf9CF9UbvM2WshXTw@mail.gmail.com>
From:   Kang Minchul <tegongkang@gmail.com>
Date:   Mon, 31 Oct 2022 03:16:57 +0900
Message-ID: <CA+uqrQAjCJOJ=x4pxEYFVy_Kh+n=m=A0yiV1tcv3q+0=1-WtLg@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Use kzalloc instead of kmalloc/memset
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just amended the message and sent patch v3.

Again, thanks for the feedback.

regards,

Kang Minchul
