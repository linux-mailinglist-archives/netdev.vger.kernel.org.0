Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06FD641780
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 16:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiLCP0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 10:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLCP03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 10:26:29 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C3520378
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 07:26:27 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-3b48b139b46so76664307b3.12
        for <netdev@vger.kernel.org>; Sat, 03 Dec 2022 07:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bGe4GNyxmwK9fHKcpWPV+aY9F1fVNX/Avi/M8MffBQI=;
        b=q0AAAtRQUPt6x1NzIQzLDCal68Zv9htM6kw5MefoKLrKHB70OQELY1Be9ug1yQOiZP
         KlCSVt/SBNT9ZXWMh1MpBxy0EF9Hk4Dh9dcoZrHsXbnJdHzey6ktOBn2jPYrYq/qbc7d
         jvjuCDZRRfSqkyEa0iEYxu8Bkz3kMHpEMmRy65m/7JfHFHyY6Mq/DmwV56+uCL1VtT20
         MpWR2PA91JYuaWf0XsLqmW8gkL5Gkz7R7V2q5qVsEZtCe5Au+zwJflTDyWyjY+lUo3UU
         hSTnZL0GPRGVdfJT8qZt9jXne3Ck0oIdhvQ6lEgzrBKY7jp5YsFb4P9ajhkImosJgJE+
         qWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bGe4GNyxmwK9fHKcpWPV+aY9F1fVNX/Avi/M8MffBQI=;
        b=7dDs9BHBeko+sDFe02VcLBAJN76EEEe0cWwqGF6Svdp5bMG4Z5UnKlpqXQwljwFdhY
         zwytXo3E2BXQENEgE4rSGoSG+6+aQgcf8aPN90w6uff2IPksWKLTng/Au6LVjLIl7Vu2
         ECfes2jjgRWbE91tJuvrJbeU/AnpjLy2amIYVG5ynPU3pIwZwBJnXTbE5wghdRsVwJrZ
         lzZYS3LX1Sf7CJxOv9u6YgidnIjuq/YZvMX3YsuZqjvmpt+7aZ7FYR629QpvcTakF77w
         v7mm6wWu2q1KfMTjajmFoZrysAX7RXjNHd9EuHDOxSvpBtErbMK5IIhiHtkfL2aiGjom
         Cl2g==
X-Gm-Message-State: ANoB5pnCAnIocCJe3wygkQMBgxnc6hDZUon5ZcnduExDz+vMmNL78d7S
        ohaZsU5/4UF5xx8XOKOjoAGNsGm7xwRTQXtPeoQ=
X-Google-Smtp-Source: AA0mqf54PrQoV5w4okOLBENvwPVGVbjNmDqfM6qPF4Z8yT5QkCJES0ksNRPMfeBxFGWFgrtPZYcOT5MG5Z1gJEIFSr4=
X-Received: by 2002:a0d:d90a:0:b0:3e7:c742:f90c with SMTP id
 b10-20020a0dd90a000000b003e7c742f90cmr1033143ywe.475.1670081186602; Sat, 03
 Dec 2022 07:26:26 -0800 (PST)
MIME-Version: 1.0
References: <20221203032858.3130339-1-liuhangbin@gmail.com>
In-Reply-To: <20221203032858.3130339-1-liuhangbin@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Sat, 3 Dec 2022 07:25:50 -0800
Message-ID: <CALDO+SbuAAsPHRq=KHh1Z_+DquwdDVJaUqXozGgzoixOUddJNA@mail.gmail.com>
Subject: Re: [PATCHv2 net] ip_gre: do not report erspan version on GRE interface
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jianlin Shi <jishi@redhat.com>
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

On Fri, Dec 2, 2022 at 7:29 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Although the type I ERSPAN is based on the barebones IP + GRE
> encapsulation and no extra ERSPAN header. Report erspan version on GRE
> interface looks unreasonable. Fix this by separating the erspan and gre
> fill info.

Thanks, it's true that current code when using GRE, we will report ERSPAN type,
which is not necessary.

>
> IPv6 GRE does not have this info as IPv6 only supports erspan version
> 1 and 2.

I checked the ipv6 GRE, and it doesn't report because we're checking
in ip6gre_fill_info
        if (p->erspan_ver == 1 || p->erspan_ver == 2) {
So it's indeed ok for IPv6 GRE.

>
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: f989d546a2d5 ("erspan: Add type I version 0 support.")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: William Tu <u9012063@gmail.com>
