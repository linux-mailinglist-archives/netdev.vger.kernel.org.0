Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A48B5A58DA
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 03:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiH3BPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 21:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiH3BPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 21:15:14 -0400
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5921FCD9;
        Mon, 29 Aug 2022 18:15:12 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-33dc31f25f9so237806127b3.11;
        Mon, 29 Aug 2022 18:15:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=YY4EvYlIxF4cRJxUop7qemsLYYOepkMFoFeZ9idYEBg=;
        b=P1gTJDxVXNI00q3I1CecYMSLhnZg6hBw7u/aGi6awjbaWExPmca84f4u5vDEyLkIxE
         sGJon5LRrbAfe1tqUcKcCDIysOKBVJUlBkiuWNu668nXdSU9vjmWmvihN+n7BgWUbGND
         GnD7WyRC2YhKVtTfo2rj627dXVLpwVzl/mTuWQCBCj9OAetbOHa4D7osFfL40uzDPdVK
         4P1Q68BGt1ifHD+zEhzu3VE/1RIjzWnWHgIN3WFbwsHNggxvl1xYRa/vXtkh3OI0ioGk
         KIeUunJ8hYpsVeLdTgKYHuKAYqj3SmGTxskaLGxN1zAn64hJchLb/BSb2UWuTYlLPIKg
         Ga9A==
X-Gm-Message-State: ACgBeo3dwfMPu8XiHGlqDEshvl82xfjtclXk4bJhbOvJuQHJLd/AbRmw
        NZA4E+EFlP8/f2VOfzPXytmQe5j4dyH53mgE1S8=
X-Google-Smtp-Source: AA6agR4Om2tcy5zRqDBUKel7/760x0htS0Cx+Hok9y1x5iN2hyfCCPZZmSQZMyTxoafJe4FXHKfCAkzzFf+VhPzIsi4=
X-Received: by 2002:a81:6f43:0:b0:335:9e7e:ad25 with SMTP id
 k64-20020a816f43000000b003359e7ead25mr12384196ywc.518.1661822111809; Mon, 29
 Aug 2022 18:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <Yw00w6XRcq7B6ub6@work> <202208291506.869166F4CE@keescook>
In-Reply-To: <202208291506.869166F4CE@keescook>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 30 Aug 2022 10:15:00 +0900
Message-ID: <CAMZ6RqJzdrjTR6jDmi4qXwt+YZjwD-5M7LLjaiU5z0xu2tHWXg@mail.gmail.com>
Subject: Re: [PATCH][next] can: etas_es58x: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
To:     Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 30 Aug. 2022 at 07:15, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Aug 29, 2022 at 04:50:59PM -0500, Gustavo A. R. Silva wrote:
> > Zero-length arrays are deprecated and we are moving towards adopting
> > C99 flexible-array members, instead. So, replace zero-length array
> > declaration in union es58x_urb_cmd with the new DECLARE_FLEX_ARRAY()
> > helper macro.
> >
> > This helper allows for a flexible-array member in a union.
> >
> > Link: https://github.com/KSPP/linux/issues/193
> > Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>


Yours sincerely,
Vincent Mailhol
