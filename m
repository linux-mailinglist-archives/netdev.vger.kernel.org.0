Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFB45F3953
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 00:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJCWuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 18:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiJCWuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 18:50:16 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B409F13F40
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 15:50:15 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-354c7abf786so120515607b3.0
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 15:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=+yOmU2koXJaUi4kTLXBCgS1sOIuDpjEm5txZroHl0aY=;
        b=PO3vwBSOG9derv7yFSwl5QxJT2WZMzhC37vJ0uFCy1+vEWDiufh6gL7N1VyhAK+FDB
         bP7Wd+d6YCVw3i5nfJxNz4YydRDRH/RFPIRcG8ff7wAq28lu/qOuYbm03LvbhxCar0x+
         F8QgWwtUyUL/c11rY4UiFCdRDhdShPzthVHFoS8JfIYFiDY/FxKiuj9ZVGoOJBOooH+N
         fvkCqQ0qoHL/NZWhlHXv0udPMD/Nw6GnUyagsmED0lmjfSJg1UGq4cbbveNxmR6ThY0b
         qagPn8fLUM8FECXXN4JFsYYEgnWPokTxdh+wGW1/yAN3sTcmmNOVsMWDBfZCxBpktweM
         AvLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=+yOmU2koXJaUi4kTLXBCgS1sOIuDpjEm5txZroHl0aY=;
        b=VJHUrx/ZcW9lW6aFVlsA3McZSszmlhLEIef4pr0QlXbvbCZstZB7t1OBYeE4nlPsb3
         TP70oYOEpEJOl9mnyiMXBClnyzF9dfcprax9c5yGgzR6zthdZKi6/q94+KN+izWraV0D
         AApy9kuUTLqCEbmFuB7Z1T1PHmgIBm2IXuRrIcVOHZH3iFgFung/KBT98uAKdlgXlJlb
         MJsw55m7FqwIaItwvRKzAhqGx4wvINekRBWxZ3CWyXGckQopITTpFaVi7nCnNjKpst57
         qcy3r0wLlyoRDXc2MWY7ajY5/OOVqB5w6zFiv4nk61cr0JFBiikY5NXErkhCgOvIml4o
         2DSg==
X-Gm-Message-State: ACrzQf3qoKDyV9PScNIBhlRM93E0oIKLJRSsCsvQjLMs2fsFD+Xx30i2
        YPOE9LM/suyPocDyCjvXWMNjb9q02oHZsvA1TY9x2EEjzkQ=
X-Google-Smtp-Source: AMsMyM48kBViyeH9nPrv3iPS/EkfLUaEgz3hWA92cdqVIuwD2xt7nymQsd62veF5gqlY0N1pqyLnle/mQdPGyx+d0KE=
X-Received: by 2002:a0d:ea85:0:b0:355:58b2:5a48 with SMTP id
 t127-20020a0dea85000000b0035558b25a48mr19921240ywe.332.1664837414684; Mon, 03
 Oct 2022 15:50:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oh1aFCMBeV-vvtfMoCx4N5r_tABp79tkPNNLJnc1ug7Q@mail.gmail.com>
 <20221003181413.1221968-1-Jason@zx2c4.com>
In-Reply-To: <20221003181413.1221968-1-Jason@zx2c4.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 3 Oct 2022 15:50:03 -0700
Message-ID: <CANn89i++SRXTZspEkeL+5gF71=ssXcK-XwJmjWo89K+=pU4cZA@mail.gmail.com>
Subject: Re: [PATCH] once: rename _SLOW to _SLEEPABLE
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 3, 2022 at 11:14 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> The _SLOW designation wasn't really descriptive of anything. This is
> meant to be called from process context when it's possible to sleep. So
> name this more aptly _SLEEPABLE, which better fits its intended use.
>
> Fixes: 62c07983bef9 ("once: add DO_ONCE_SLOW() for sleepable contexts")

Yes, this works for me, thank you.

Reviewed-by: Eric Dumazet <edumazet@google.com>
