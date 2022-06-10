Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EBF546A3B
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348217AbiFJQTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241014AbiFJQTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:19:02 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD4219006
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:18:59 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id d23so5370947qke.0
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pzAzvmdTt5IK2+SlYn4eRC+FxMxD6cIkniPSUxyq1eI=;
        b=bgOt7bh3Cb2bu7XQhuEIZjjJePPrOzV+Cb5X7CwWS75nxcgTDiDFyOpelkn7njJow1
         EH5f5nP+XEskb1Arf6gAda7EL5em3P6HkkRYTE0ZAxXV5/ObL6/a76DG8eehGEgnK6Oy
         j23E8b7nwp7WWVectbuSnIyJrEXyYrLAEf/8PVVexroqVq3azuZXkcM4+XsZjg92xCTu
         EPFuN7fbCA2HmVMZs8+xrO081vZQlCPWYvUpfkTvr+6/leA1+hNXK6SRAablx903RHOI
         1M8YX3DZIHR+Vp+Ry+ej1qage0Bjv7yVi2wldsaTTboSXFYzOKhFI/8HeBtax3xV8bf5
         Vttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pzAzvmdTt5IK2+SlYn4eRC+FxMxD6cIkniPSUxyq1eI=;
        b=6hsJU+qizoVyKrK/pH29HRyxjS3QKCagtvDV0Gjcc1JVHbozy8WA3BMXvjpfrDUU/Z
         dImr27XtzGNcEu1cwCG6cl8kyx2ADxbNEhb+3/a+LB4YMEuQMwuk3UPE+9Pc0eCbReGz
         MAfR/B8tF3hGx66r2pg7buUkpTdkL+3J0+o7g70SQcIqugrDbmJBzobuTXtEcf747g62
         STV8ItgjRTJ5IeRtAXqj/SZ8dTsY6yhUward8uAYyjU/HjcK1xV+5CB1c0gpkNoxS/1x
         kVDeDju71afJGeqWyL+ik696IQtWzLLVbgj7EHn/Ol1Qk/EEIIQ8RSsRLMc8yIpAnPlv
         T+gQ==
X-Gm-Message-State: AOAM533j7RS3Vbz1lNrAbIzceqpleZB+eUpIb3lvQ4Yv+2JlLfUqYFnL
        troOPlrBBYnuQpinOWSAnHrGv75+lz/aIM3Cj93nu2A/f/juUA==
X-Google-Smtp-Source: ABdhPJyrifzEQmuDcAyJbcSiyA4Qre7vLkzPkjVHhytv8uYUeYG5XB6qgbHzKY5kJflTPL6wS1Q5bmtUhLko+k0syYM=
X-Received: by 2002:a05:620a:9c4:b0:6a6:9c07:c243 with SMTP id
 y4-20020a05620a09c400b006a69c07c243mr26872194qky.783.1654877938559; Fri, 10
 Jun 2022 09:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
 <ed6768c1-80b8-aee2-e545-b51661d49336@nvidia.com> <20220606201910.2da95056@hermes.local>
 <CA+HUmGidY4BwEJ0_ArRRUKY7BkERsKomYnOwjPEayNUaS8wv=w@mail.gmail.com>
 <20220607103218.532ff62c@hermes.local> <CA+HUmGjmq4bMOEg50nQYHN_R49aEJSofxUhpLbY+LG7vK2fUdw@mail.gmail.com>
 <78825e0b-d157-5b26-4263-8fd367d2fb2c@nvidia.com> <CA+HUmGhPbcY0Jr9vh5F2Mov4jbAbeLb50ugTpGNuLcDzLTqfDA@mail.gmail.com>
In-Reply-To: <CA+HUmGhPbcY0Jr9vh5F2Mov4jbAbeLb50ugTpGNuLcDzLTqfDA@mail.gmail.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Fri, 10 Jun 2022 09:18:47 -0700
Message-ID: <CA+HUmGhy1gqH8MjiOqfsq7-sbGnWDzosC334SPR9dQYJZrMY9Q@mail.gmail.com>
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

On Thu, Jun 9, 2022 at 9:40 AM Francesco Ruggeri <fruggeri@arista.com> wrote:
>
> On Mon, Jun 6, 2022 at 7:07 PM Andy Roulin <aroulin@nvidia.com> wrote:
> >
> > Below is the patch I have been using and it has worked for me. I didn't
> > get a chance yet to test all cases or with net-next but I am planning to
> > send upstream.
>
> Thanks Andy, the patch fixes the reordering that I was seeing in my
> failure scenario.

I think that with this patch there may still be a narrower race
condition, though probably not as bad.
The patch guarantees that the notification is for the latest state change,
but not necessarily the change that initiated the notification.
In this scenario:

n->nud_state = STALE
write_unlock_bh(n->lock)
                       n->nud_state = REACHABLE
                       write_unlock_bh(n->lock)
                       neigh_notify
neigh_notify

wouldn't both notifications be for REACHABLE?
