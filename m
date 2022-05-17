Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F35152AAAC
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 20:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244369AbiEQSZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 14:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiEQSZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 14:25:46 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521B99FDA
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 11:25:45 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i17so18061970pla.10
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 11:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aMbdfdYBSSU6cNb99NFW59d4hHqZdOa2lmG8jf4EBMk=;
        b=1uL0DEZS5JzoCVi9TWcVk3Ici8vvl0J2xRuZ+4C88UgXQeOIM4k1Ce8MgNo0MCCd0s
         r6v1mP6y80yH95nyYl72GdaIHmX2x59n7PqQiezIyizfGhGVODzA0i34Z1Te1EPPYn5t
         mGVu9vPna0pcdKR6nnTAll1jitgTKksLKP+tjzc9LstkZO1W/lJXc8hVAEff209dijqo
         M+r5Gf7eBeX3njk5i1C4ZAyNQv5i7ZYc4EeRi9jTWIF3Ecvf47JE5s5XWF0p9HE+NCyO
         twspKsu/jUjl3u79JB5e1h+3mtn9IDkJwGUry2xv9NB/TKKkNBmkS6GZ8XmRkU7vRlCR
         8MjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aMbdfdYBSSU6cNb99NFW59d4hHqZdOa2lmG8jf4EBMk=;
        b=fPBU+Q0ZeZajfVGjZNIcmOPxLlHmtcFD6cmgiXJkqPAVWYJdXrjU+dzBveFuA85q9d
         0d1gJxR9tOzltFn8rZXiw48QcAKUtGYxY/mT8jNfoIeiPsv8eLF8pll5wUaIFxfbNGIv
         EfeMvLpVpZ4OtDBL/uTPkya4ygN3zf8MpfpHq8g4ldCIzUlfwg6uhHF9VYzeYnzH7IGB
         fbkyOk1rDYzuLdqSt+hIzP1NxQLxYiyZ3wBcID+qe5tHYlFQtncG0EUANxn/ycPsekrR
         AWvRVaMsAbHIT5Y012DWIRLCdbfdOHFR4YlZ1I/+DKkIYJRfDAClT13JJvEHkGtFb8Wy
         do3Q==
X-Gm-Message-State: AOAM533Xw/f4xL+ZtxXq4OLAOn1rLwqiyrb8RmKAreKIJdMuAwIUEWc1
        0cw7vORNopKVUeQ+05ILo/qg2g==
X-Google-Smtp-Source: ABdhPJwEC4dLoDlmIz+S00d34peCNBOUbhNouJXMKN90tbG6DqtVBG/YTC5Lsl6UYFNYCnJG7d3O2w==
X-Received: by 2002:a17:90b:1b44:b0:1dc:315f:4510 with SMTP id nv4-20020a17090b1b4400b001dc315f4510mr37515520pjb.28.1652811944819;
        Tue, 17 May 2022 11:25:44 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id p18-20020a17090a429200b001d25dfb9d39sm1971448pjg.14.2022.05.17.11.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:25:44 -0700 (PDT)
Date:   Tue, 17 May 2022 11:25:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCHv2 net] bonding: fix missed rcu protection
Message-ID: <20220517112541.26b4ddca@hermes.local>
In-Reply-To: <20220517105445.355b1d22@kernel.org>
References: <20220517082312.805824-1-liuhangbin@gmail.com>
        <20220517105445.355b1d22@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 10:54:45 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> dev_hold() and dev_put() can take NULL these days, for better or worse.
> I think the code simplification is worth making use of that, even tho
> it will make the backport slightly more tricky (perhaps make a not of
> this in the commit message).

Since that is so, would be worth having coccinelle script to cleanup
existing code.

See scripts/coccinelle/ifnullfree.cocci for similar example.
