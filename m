Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4A85BEDCF
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbiITTbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiITTbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:31:19 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23CA71BFE;
        Tue, 20 Sep 2022 12:31:18 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id sb3so8603698ejb.9;
        Tue, 20 Sep 2022 12:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=p1WYBKPzJxS0/nMX3JitYmpQIgorQcICZWCbOg4AvPE=;
        b=BnmYjNc9yEv+zEKdDCllEkwsoFVflf6Mua1hd5/KD2bkgzMvhc0u0GNDOvETqEeTd9
         jQDUMz7XwbU9TX4nsJ1O3QA/8/0+tbnWwo49iKH2P3NpmnlNdIJ5Hmvfxtomii+nXi+V
         HR0CwEL08gRFQDLpsbjnPSNMPBhSdRPD76o9XaCSbuaD9kpHyI7xF+qmlKL9QLE6bMj0
         sZsLFHfhDpdpvX2Q7V0Dwu5avfoFREFGf8wXk270rw7RRm5ml5Gv08TxA3XmX0x7/mKa
         wR26Sh2CHEqWhF7nk0d7LO86UESkA3oKNhOLxS5AgFyuluAbU7ehs+6U0R2fhy9QMdkr
         uWPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=p1WYBKPzJxS0/nMX3JitYmpQIgorQcICZWCbOg4AvPE=;
        b=igS0uGjprx/Qbr0UWlieEdPTgnMU2WCTf0xkEdP26F7QoT+vjEi/7ltEh3sjIKjPrO
         eX56zUXBO+z0PigPePZI/MY6MbbR3wmwM9xnQrGEyDTb2Ava/ZGneDW5xj3DB40F7H7H
         RsBI+B+pD+V6fEM8v8KZqKKI/a17mX4mbmKiyk9j4VnX5SbTHddvKdODvaApTF8Tr/hJ
         HxzmX1cYYqMVW9TsPwnB4Ozpq8EjzrzoIiIqpp5wKBylCr+4dmA55uatuFQWKW3ZfMm/
         XYAzwTtrlABjX/ZNFGZnkpWrLY46PO3oufmhD2+yzNOG7fW5sr9tV2SHqyvtcyojOYfs
         cpRQ==
X-Gm-Message-State: ACrzQf1Gt9XCzy3bDC3G1Mnh4xG2QnopGes2tsae/kxlzkXJyQvMt6XJ
        bairsEdJNA97PoM4g6lVxNBcm7B0i3yArSTXaFY=
X-Google-Smtp-Source: AMsMyM4pq7MNcRRtZ3uWVDKe6Dl21Cztd4sFP9VN7B5AKpswNaQlwB3KwAu9LVJrtYwmSkdfDznJTbEvZdAitv5B70Q=
X-Received: by 2002:a17:907:74a:b0:77e:9455:b4e3 with SMTP id
 xc10-20020a170907074a00b0077e9455b4e3mr18447476ejb.471.1663702277120; Tue, 20
 Sep 2022 12:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220917022602.3843619-1-floridsleeves@gmail.com> <20220920113744.64b16924@kernel.org>
In-Reply-To: <20220920113744.64b16924@kernel.org>
From:   Li Zhong <floridsleeves@gmail.com>
Date:   Tue, 20 Sep 2022 12:31:29 -0700
Message-ID: <CAMEuxRq3YDsCVBrdP78HnPeL7UcFiLWwKt6mEB2D+EVeSWG+pw@mail.gmail.com>
Subject: Re: [PATCH v1] net/ethtool/tunnels: check the return value of nla_nest_start()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, edumazet@google.com, davem@davemloft.net
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

On Tue, Sep 20, 2022 at 11:37 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 16 Sep 2022 19:26:02 -0700 Li Zhong wrote:
> >                       goto err_cancel_table;
> >
> >               entry = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
> > +             if (!entry)
> > +                     return -EMSGSIZE;
>
> not even correct, and completely harmless

Thanks for your reply. Maybe a more suitable way of error handling is 'goto
err_cancel_table;'?
