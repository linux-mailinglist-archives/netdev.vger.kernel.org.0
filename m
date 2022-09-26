Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBE45EB47A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiIZWVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiIZWVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:21:22 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBBF3C8F8;
        Mon, 26 Sep 2022 15:21:21 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id p17so2938711uao.11;
        Mon, 26 Sep 2022 15:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=1px19wL6Nmk0leKHhHEPIsYZTb3ixLSMqAEx3TXjZKg=;
        b=nzshlrpweXwMjdwYC6R8cTb/iKrQl1ddCEEEM5rmReV/wmkLb7MKMUEg4+TgOXyLuC
         C9tqcl58YUqqOyJpEFawTz9WLbEDdDw0tTgMtI5UFqpaXZnebgHTpUHiw7VyuPAtRAbo
         waiHJiV4RLtDAySmCbpsdzoNOLNlIPPIJNiWV+nEy/HZacaDKuls4T7xxGrcu2cIKqML
         tyfDTjEETXUJ0vrGVftfWok9G6SbqreTUbjAnyW+25CYp+7VM87cmRgbmV1/YvHCovOQ
         a1eRHyhWqqy8PGVct2HSFwFIf3PN0PTOjP8Dw1duumxm+bxkeY4Db9hBTx8dp3ctV2G1
         rRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=1px19wL6Nmk0leKHhHEPIsYZTb3ixLSMqAEx3TXjZKg=;
        b=rA/uCe2CgaWl12zFXnFP+/kaJNfASZOWkSKUGYb+4SX9zwnvnc4Xxg5OjjYQfvtZmo
         tsiXWRbd85ys3UYCD+pwA2N0gnLSa+QEx7hcTXbOq6R6c4gpd+BY/r8uSJuwauUQIlKk
         KrFNVmlH77eFzN0PxKKLA+dgtjfjyIVrOEoo/lVDIZBRCQT2sjTYJlLvfkruElzH1q9M
         2kUWd5s2hCZ5yXzxEWkFu4BHE2jX89Yx5PHuyAXTNDaROEntI7RMJiMekTph7hAjHdnZ
         7KNuCl+u6HfECnb8D70jTUeYsgDHMWbOaz4nswgbO5S/o8fxr+korQohzvj0IKAnnjhV
         jP3Q==
X-Gm-Message-State: ACrzQf15j5EEVRhqnFkwVTIxmVbTkioKAEkwwOOiGzRwvep9cop4q7aZ
        oTAeAOIblJMhpaZlFmPCv0QeQTJrWpG4IFhjAVqet+CHnqo=
X-Google-Smtp-Source: AMsMyM6Bdnd4fnQvQ5mSFRjMz7nywFUaNIfT0TumJFyBOwk3yETkDagYkSPTVkQPtET+GStD++EItbGHdn6vDOoNr6A=
X-Received: by 2002:ab0:7605:0:b0:3cf:3df7:e2ce with SMTP id
 o5-20020ab07605000000b003cf3df7e2cemr1848601uap.49.1664230881083; Mon, 26 Sep
 2022 15:21:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220926040524.4017-1-shaneparslow808@gmail.com>
 <20220926131109.43d51e55@kernel.org> <CALi=oTY7Me6g1=jtnZig-MzS-TPOOMQ53ih-78QuF-K+Rs0rUw@mail.gmail.com>
 <20220926143711.39ba78e9@kernel.org>
In-Reply-To: <20220926143711.39ba78e9@kernel.org>
From:   Shane Parslow <shaneparslow808@gmail.com>
Date:   Mon, 26 Sep 2022 15:21:09 -0700
Message-ID: <CALi=oTa_=kN=To=67kG71Za2UdbvA9e4S5+CbnZStBRAsJENew@mail.gmail.com>
Subject: Re: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel mapping
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Got it, thanks. This fixes: 1f52d7b62285 ("net: wwan: iosm: Enable
M.2 7360 WWAN card support"). Thank you for your patience.

On Mon, Sep 26, 2022 at 2:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 26 Sep 2022 13:51:23 -0700 Shane Parslow wrote:
> > There isn't currently an open bug report for this. I can open one if that
> > is preferred.
> > The gist is that previously, any writes to the 2nd userspace AT port
> > would crash the modem.
> > This is my first patch -- I apologize if I did things out of order.
>
> The Fixes tag just points us to the commit which introduced the bug,
> look thru the git history of the kernel for examples. The expected
> format is:
>
>         fixes = Fixes: %h (\"%s\")
>
> You need to find the oldest commit where problem exists. This helps
> stable tree maintainers to backport the necessary fixes (and netdev
> maintainers to make sure that the right tree is targeted).
