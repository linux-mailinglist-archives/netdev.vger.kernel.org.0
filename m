Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4475BF344
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 04:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiIUCEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 22:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiIUCEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 22:04:54 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC0D24979
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 19:04:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d24so4225071pls.4
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 19:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ypkjJ0pkA9ZonNZv/x+LJZ8KBXK54VCizBoAcqwqlcE=;
        b=6GSqzAeFkP9C0k2e+Yk0RzsUglnm2j78Hnl4Kw4VzUxKYrQ62+LHCMrYJcYt50oQnY
         g9CR+PxY3RC8uF/QFhdTGUm2iHyS1ysmFfmjbhfJk3413A/a6htIscyzHqV9f278ptYM
         BfB2R8BBNz3Psn9UseFRIt7oLVuQtQ/IN5ndfl+QWEZGJAeqRluOcO71gmhO2Kv/dYU2
         o3imDUlBhcxSXQ1jZHQUWPF8qCPHEL8N7ll1cwG22RkJ+E2fjSGEUq7DzUbh93gQ38uO
         jty+CIL4oTvyCSNSRV2tdhuJkJIqo7UGFP6AtaTFHW8YMnVQM9YqSSw68BfbJVWikgGg
         idUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ypkjJ0pkA9ZonNZv/x+LJZ8KBXK54VCizBoAcqwqlcE=;
        b=ADaB8KrKUz3UV7leMQ68qO5l84+CgCtpI6ucG2eYwWUieZgcA4+7KaI41SnKwNUO6L
         Q3E0S9NfJx+89w0nQGjZtEHJ8711/euVI3EAm7RxVb1SoHhUJ63jqwWIsCCgWCKgUsmr
         IEfKgDbJYpj1Cf7R3YnHUGV13bvL7wXa2sqFdqbJYTB9Cv122WNpYKH6yipMQpu6xN9r
         9+rbx8Ri5euAR9XN9s2YefnU2CESxEmg7S2kaK9yrYC6VtwBl2ncaKTZeOxyeofst7YI
         xEdJyWVzRTxGX9WCyMXMMqhcCye89gO2iFoo/YyO9QPWlpX4uq5Pb1Tmms0GvF8YhLSp
         ZnHA==
X-Gm-Message-State: ACrzQf36K4gkKoyu/LRe5rpuUQM2SuHQ71QZgd6TivBG8vC993RzcrHq
        ldV32QG6sH40CMh3C3Tk1lcOcA==
X-Google-Smtp-Source: AMsMyM7ZoUqi8WlIRqtiU7eaQ9N8QFx5zkk+g2ww50HNRcjRVq4y3B/ZPeN1eWmDy/K9fN/ZBM0mKg==
X-Received: by 2002:a17:90b:4c8f:b0:202:bcbb:1984 with SMTP id my15-20020a17090b4c8f00b00202bcbb1984mr6863033pjb.64.1663725891921;
        Tue, 20 Sep 2022 19:04:51 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id qe12-20020a17090b4f8c00b00202df748e91sm618192pjb.16.2022.09.20.19.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 19:04:51 -0700 (PDT)
Date:   Tue, 20 Sep 2022 19:04:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Zaharinov <micron10@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, pablo@netfilter.org
Subject: Re: Bug Report kernel 5.19.9 Networking NAT
Message-ID: <20220920190449.39910094@hermes.local>
In-Reply-To: <20220920161918.6c40f2a6@kernel.org>
References: <7D92694E-62A2-4030-8420-31271F865844@gmail.com>
        <20220920161918.6c40f2a6@kernel.org>
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

On Tue, 20 Sep 2022 16:19:18 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Sat, 17 Sep 2022 11:03:55 +0300 Martin Zaharinov wrote:
> > xt_NAT(O)  
> 
> What's this? Can you repro on a vanilla kernel?


Google says it is out of tree full cone NAT
https://github.com/andrsharaev/xt_NAT
