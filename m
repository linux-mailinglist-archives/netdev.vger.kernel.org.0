Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D95E28D30B
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 19:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388367AbgJMRUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 13:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJMRUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 13:20:37 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CF9C0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 10:20:36 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id f8so488446vsl.3
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 10:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q881i9ci2QuprURu2T3tf48Pqp0gc9MKpu5hxYilB+g=;
        b=eFQzsiuCFyYGjk1JsFCyldI6bQWERpHPtyXAng9JAdyEsVnbOu3O82ISh/bo44+iZg
         AwEiOw2ESU3v1QP/LeAscRyl9EMM3JuI5/qw2adwBkRw2l0c7iMYsOJH5Tav7fNdKjLi
         Q00NFqPf88MLgULgyRRf76fl5ve1dSmf55z/URd+YXEm9/TeCQ2sbcYXxK4Gk2be/ewy
         5NEjj3+Kumt+8xBoXVwboNjqAWkqN5fbm3fDVqBssOwKBcCD2x7XIzM1zIK3Dx4k2eWJ
         hrsj6rgYMYNCciUXEoZnxYKQnTfvThYWppuPJxaDUjjH3Iww2dRPwm5nigHyAeJqE8i+
         e+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q881i9ci2QuprURu2T3tf48Pqp0gc9MKpu5hxYilB+g=;
        b=U1sVuEpsVd/46KKOQ/EQMHPdeV3wnv26FVxzYZeuMbattMkT+I78S0j+dwdHxx41Ef
         2DM6gvZt3RIDnH4HsSpwRb+P0d8O+Q3f+hHYEPxJVWQvona7iLp5GIc2VtHMhnPvEs44
         /8SUkgw38pCoZGLcA665teHRLNKyPVytqe98GC4rC3OZ2D8rxZOM4vLAyk8QtmQN2rO2
         nBqTU+aHypj7f+JeR8z03+PxRF6/78gQS/we7EorqA1Yw8ZO0bCeoyK4KyAa0FBGVbAX
         7oOSm9xL2MZVBTqOcvDvFW3CpS5158ROfRJ4XVavzWPeHdZ7tA8W84ISR1wP7JKXcz4v
         Irrw==
X-Gm-Message-State: AOAM531fGDppEjldTZpuG3I6ruvbkaZfH3pssxHHaixvD4wxFNnpJ6yE
        jyHNCkBLPliuYs2a0447bUJM7TUcCVA=
X-Google-Smtp-Source: ABdhPJzSuJOGerfDRMbBEN+IAA2fuBXyFSIPC9FTIbL9/jLuaDYQgq/WR9hl3L1mqkkAP2pe6b319A==
X-Received: by 2002:a67:68d1:: with SMTP id d200mr696696vsc.60.1602609635723;
        Tue, 13 Oct 2020 10:20:35 -0700 (PDT)
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com. [209.85.217.52])
        by smtp.gmail.com with ESMTPSA id h10sm75175vke.46.2020.10.13.10.20.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 10:20:34 -0700 (PDT)
Received: by mail-vs1-f52.google.com with SMTP id f8so488356vsl.3
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 10:20:33 -0700 (PDT)
X-Received: by 2002:a67:fb96:: with SMTP id n22mr681911vsr.13.1602609633308;
 Tue, 13 Oct 2020 10:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1602574012.git.lucien.xin@gmail.com> <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 13 Oct 2020 13:19:56 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc1FRRZS8Yt0U7bt6M9Qjvi+xrQTefvMuOxF6=FL3dPPw@mail.gmail.com>
Message-ID: <CA+FuTSc1FRRZS8Yt0U7bt6M9Qjvi+xrQTefvMuOxF6=FL3dPPw@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 02/16] udp6: move the mss check after udp gso
 tunnel processing
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        David Miller <davem@davemloft.net>, gnault@redhat.com,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 3:28 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> For some protocol's gso, like SCTP, it's using GSO_BY_FRAGS for
> gso_size. When using UDP to encapsulate its packet, it will
> return error in udp6_ufo_fragment() as skb->len < gso_size,
> and it will never go to the gso tunnel processing.
>
> So we should move this check after udp gso tunnel processing,
> the same as udp4_ufo_fragment() does.
>
> v1->v2:
>   - no change.
> v2->v3:
>   - not do any cleanup.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for revising
