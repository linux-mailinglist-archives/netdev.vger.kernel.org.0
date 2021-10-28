Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C693143D985
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 04:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhJ1Cwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 22:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhJ1Cwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 22:52:39 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C920BC061570;
        Wed, 27 Oct 2021 19:50:12 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id v10so3138935qvb.10;
        Wed, 27 Oct 2021 19:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZIj8JUAa/oKHTviYbVQQPi5hTbJg26A4cMkQ91+NOI8=;
        b=iZ0NK8UU6jtSoNk8YFG/C/0ZrYxJp3ssvBFgVcBvZgrxo9WuTceVxZB2S/SLU1Qvbs
         BBsbwbXXYm7q0hx5iKdqjKl+pBjARCIP4tXohpNC6DGM9fin60TEzIMXbTDzHbrgFueE
         KuDGrQ6uuKxSbG2zaJ3MUHSYNwB05x+w5UAkne8B6NFsB4lORD7mjgV1B4d7lQxHQ0ov
         O2BBsbB0cWHi0i0CXs8wCGY1x/+J4Tfrkb7NdZAl1H37fI+46fQVtT2A+IMm7seG7ul/
         B1EKUouwzqWkXuYJuIDq31/EtIzFoZkmrsNcJLUqL+8KA3toIRERpwpsM0c4n2YGpjC6
         Baog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZIj8JUAa/oKHTviYbVQQPi5hTbJg26A4cMkQ91+NOI8=;
        b=paCHJJm0U8pcLwytA23cnLjR1h157UecK2kWxT4ZIx2+LRzuHSFRZRI9aYlTQ4Apr+
         uagXXokuLreJGqjqDuHMClzBLaeKkEsranWJH7UqjLvXC1u85TAT0ZhyFQ4MIlvFz+wg
         8LSqtrtJQ/+e/61jlkfSFycdbSSUIJpis1OCVjJ2E2uWSuZBRvMtRqyu9f2yXamQZq5O
         F0Y5lKSIYI33K/LmiZm3s+xn0Ji5tKAW45zefrGrrfVYHCl8N6tMAplbqfiBjdvEG7OR
         qsNFkEEvE4dcY994COfBUYJQdodCpw6Ku3rmOY6W/hyDsRrARAixYnbma7MQdoyqVcWT
         5sCA==
X-Gm-Message-State: AOAM530HAkh02g3coHTiSGCBEbzAI5/gQ4rVYs6k7/QQHVKFfqcHm4pA
        7f7WXp7Md8BNnwq7/FLxwfTSH2VHSprJ/HS8yc+r/9+uhY6R2w==
X-Google-Smtp-Source: ABdhPJxTREUyUzJXRE21WgWrK4gKtQ6gtBOxN1/R5dXaxto/CWqUoYyxfx4owr3NEBjPv9LNJstmDKe53jL0UbH+NSs=
X-Received: by 2002:a05:6214:2308:: with SMTP id gc8mr1230271qvb.31.1635389412045;
 Wed, 27 Oct 2021 19:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211025115910.2595-1-xingwu.yang@gmail.com> <707b5fb3-6b61-c53-e983-bc1373aa2bf@ssi.bg>
 <CA+7U5JsSuwqP7eHj1tMHfsb+EemwrhZEJ2b944LFWTroxAnQRQ@mail.gmail.com>
 <1190ef60-3ad9-119e-5336-1c62522aec81@ssi.bg> <CA+7U5JvvsNejgOifAwDdjddkLHUL30JPXSaDBTwysSL7dhphuA@mail.gmail.com>
 <CA+7U5Jta_g2vCXiwScVVwLZppWp51TDOB7LxUxeundkPxNZYnA@mail.gmail.com> <35e6215-4fb3-5149-a888-67aa6fae958f@ssi.bg>
In-Reply-To: <35e6215-4fb3-5149-a888-67aa6fae958f@ssi.bg>
From:   yangxingwu <xingwu.yang@gmail.com>
Date:   Thu, 28 Oct 2021 10:50:00 +0800
Message-ID: <CA+7U5JuxN1BSneYuiZde_kZRNpPDuT23Wn7_Uyv12yk26tXEzA@mail.gmail.com>
Subject: Re: [PATCH] ipvs: Fix reuse connection if RS weight is 0
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello

On Thu, Oct 28, 2021 at 5:09 AM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Wed, 27 Oct 2021, yangxingwu wrote:
>
> > what we want is if RS weight is 0, then no new connections should be
> > served even if conn_reuse_mode is 0, just as commit dc7b3eb900aa
> > ("ipvs: Fix reuse connection if real server is
> > dead") trying to do
> >
> > Pls let me know if there are any other issues of concern
>
>         My concern is with the behaviour people expect
> from each sysctl var: conn_reuse_mode decides if port reuse
> is considered for rescheduling and expire_nodest_conn
> should have priority only for unavailable servers (nodest means
> No Destination), not in this case.
>
>         We don't know how people use the conn_reuse_mode=0
> mode, one may bind to a local port and try to send multiple
> connections in a row with the hope they will go to same real
> server, i.e. as part from same "session", even while weight=0.
> If they do not want such behaviour (99% of the cases), they
> will use the default conn_reuse_mode=1. OTOH, you have different
> expectations for mode 0, not sure why but you do not want to use
> the default mode=1 which is safer to use. May be the setups
> forget to stay with conn_reuse_mode=1 on kernels 5.9+ and
> set the var to 0 ?

The problem is we can NOT decide what the customers do, many of them
run kubernetes with old versions of kube-proxy. And most importantly,
upgrade to new version is a very long and painful process, that's why
we want to fix this at the kernel level

>         The problem with mentioned commit dc7b3eb900aa is that
> it breaks FTP and persistent connections while the goal of
> weight=0 is graceful inhibition of the server. We made
> the mistake to add priority for expire_nodest_conn when weight=0.
> This can be fixed with a !cp->control check. We do not want
> expire_nodest_conn to kill every connection during the
> graceful period.

ok, got it, I will try to fix this problem

> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
