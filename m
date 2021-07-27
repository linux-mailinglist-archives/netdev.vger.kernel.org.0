Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5A73D8206
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhG0VpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbhG0Vo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:44:59 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1490BC061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:44:59 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n10so140957plf.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RfgDHMUec9+wVkID26xSl8008ahCk/fggJ3JlLD9c5U=;
        b=EnA4iiMtW8N9C7txFmWDjJMK7zhwXlga6204mphuSmeaQuf9sQc3sxaZ7jvkLpvUYd
         7h2oCYmyfhNezELTugPUd7onfdU3cG77IY/xEWGKhh+sho32dwz5ryrlPFujSLO9X0hI
         OK7UOMafl5moF+os7BvRtPk4OcPDx9Hu+Gr/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RfgDHMUec9+wVkID26xSl8008ahCk/fggJ3JlLD9c5U=;
        b=eR84PcTrE5nbKHRmiiVSH0ox70fYtMRMN72YDaDCigF9p8/L5gLnqmND0z83hANRjO
         YiOE6Jjb0lD2rRag1+myeG72WER8X70KmAgsXmxek/7QKzTN9bsSnYjXLJj9dcvG2si1
         PVp43yzj7C3PeiMXiRaLdcoU9HAVb36pTr+CMbZXvYC1EETWqLvYL0dM3kdtfB3iihVr
         BEbtF6TdXW0zy1lks6+Mroh1i+JfsaaIehLpBdjS+mTxZq6CprGVaLN1RF2nEUPbpuVR
         ZfgxFQLgTzByBNU4F3mH4U7HA1CbQ6gXCiN9omFxCIO5EE2laZIPHK87uZyHnBs8tUtc
         Azxw==
X-Gm-Message-State: AOAM530/O4WfQptI1SZiRUexHEF1ld7fAYm6j/2UHKOHo9eHxkjkMsbW
        RJEB45vk7KKqZ6d1kvFZRNajKZOVS0J5DtHLZtYofg==
X-Google-Smtp-Source: ABdhPJzrcjU3d2o77c4q3K9yi+NENzM3iqP9EUm7DQejc+zSk8XHK7bTkFanFiuLl6pmQ/cdhVvIcx0/mmrgNhYcMRM=
X-Received: by 2002:aa7:9dc8:0:b029:35f:7eca:72cf with SMTP id
 g8-20020aa79dc80000b029035f7eca72cfmr25066252pfq.77.1627422298562; Tue, 27
 Jul 2021 14:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210727190001.914-1-kbowman@cloudflare.com> <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
 <20210727211029.GA17432@salvia> <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
 <20210727212730.GA20772@salvia>
In-Reply-To: <20210727212730.GA20772@salvia>
From:   Alex Forster <aforster@cloudflare.com>
Date:   Tue, 27 Jul 2021 16:44:42 -0500
Message-ID: <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: xt_NFLOG: allow 128 character log prefixes
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'm not refering to nftables, I'm refering to iptables-nft.

Possibly I'm misunderstanding. Here's a realistic-ish example of a
rule we might install:

    iptables -A INPUT -d 11.22.33.44/32 -m bpf --bytecode "43,0 0 0
0,48 0 0 0,...sic..." -m statistic --mode random --probability 0.0001
-j NFLOG --nflog-prefix "drop 10000 c37904a83b344404
e4ec6050966d4d2f9952745de09d1308"

Is there a way to install such a rule with an nflog prefix that is >63 chars?
