Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE9D6D576D
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbjDDEIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjDDEIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:08:00 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389EC1984
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 21:07:59 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id i9so31366660wrp.3
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 21:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680581277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KktoCWiY67YN/IFslxE7hfcrAvse71hZhHEpfT/ThtA=;
        b=BiKdzxSRbsPO/oGgDtUdo3Y2FY72n5Mfw4BO+0Ev7QvT+Iqm/SLl/VXU2sQjvfegkQ
         mo4S7tB7oWSHTpgopS0cGJkO86rBdy1t8sGONn2F1ZV7QSE0Ob+Zd4c+W1xffau4kHe8
         K1HEB3/UKS5u4PpGlm/GKDM+8OMwGoan+yynSkBtkozjX82BdFeQ6TdcAYnU3LWtPy/m
         M/yRa93eirx6o9+AVqjLfBn/rdBikeJ3iS5wIgdGa7bQWY5WedN8c70mH1v+EM6HmikI
         uKIdnak2A+B2q1wZLq99Flxhm8wH3MXYb3Y9ahrNOYyt/9NFHIba3QJHwj5UCUtT+4Sv
         cQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680581277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KktoCWiY67YN/IFslxE7hfcrAvse71hZhHEpfT/ThtA=;
        b=qjQ3reycbjdn3NRJhJKTjkYmXrkFpiK/B7c2o1pchDq7ymqX6Jy4bXHW4I0CAIdycl
         iinsW4Aje5s8svSiM0vMVXrmjCvzSAXFB3q7V9AtQR2OGBvlBgXGYsoodnnwKnrWpqpJ
         XAAkvu4xZru3ECArQoeSOzSXkqCv+blVupP7ReGNkN26w6FQH+vp/TUSicY3qqZoT1p1
         hSdGB+Dp1H7C7O5GGrdNTug3YUhmSjgrpY1p7u8fonALve4SNCcmvxlat2YWrt7ZSMQW
         UO6JtSnHAsmH0JWjsb5op5VMKYmBcMtDMhHNzZZhhy17c5FkSsLSFOIc89guhJh3V4nf
         tGDA==
X-Gm-Message-State: AAQBX9f9BBpNregDNEl+vkP9e2Pr6Gp/2NNpGTZvwe2jgS8gYWm0q74p
        lBEecdpLq2JQo3kZJTyPeFXjxQzcJKlCeJ/ZJbsCvA==
X-Google-Smtp-Source: AKy350bnvQ2geLTuIPaD7D/bFNV+uPCdYZFniKTWRL0ASo3F6eA0KrhhHJxUYUX6BwDBD25jfxyuTuO6nULTEjWSlCg=
X-Received: by 2002:adf:fc41:0:b0:2ce:a5f8:b786 with SMTP id
 e1-20020adffc41000000b002cea5f8b786mr138484wrs.12.1680581277463; Mon, 03 Apr
 2023 21:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230403194959.48928-1-kuniyu@amazon.com> <20230403194959.48928-2-kuniyu@amazon.com>
 <CAL+tcoB911=NZYiiAHV8vRv+=GdWmXqNv0YWd9mc4vLaTgjN1g@mail.gmail.com>
In-Reply-To: <CAL+tcoB911=NZYiiAHV8vRv+=GdWmXqNv0YWd9mc4vLaTgjN1g@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Apr 2023 06:07:45 +0200
Message-ID: <CANn89iKO9xtHoa39815OyAbTQ_mYr8DMBYu4QX6bs_uDBaT9Tg@mail.gmail.com>
Subject: Re: [PATCH v1 net 1/2] raw: Fix NULL deref in raw_get_next().
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        "Dae R . Jeong" <threeearcat@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 4:46=E2=80=AFAM Jason Xing <kerneljasonxing@gmail.co=
m> wrote:
>
> I would like to ask two questions which make me confused:
> 1) Why would we use spin_lock to protect the socket in a raw hashtable
> for reader's safety under the rcu protection? Normally, if we use the
> RCU protection, we only make sure that we need to destroy the socket
> by calling call_rcu() which would prevent the READER of the socket
> from getting a NULL pointer.

Yes, but then we can not sleep or yield the cpu.

> 2) Using spin lock when we're cating /proc/net/raw file may
> block/postpone the action of hashing socket somewhere else?

/proc/net/raw file access is rare, and limited in duration (at most
one page filled by system call)

Use of RCU was only intended in my original patch to solve deadlock issues
under packet floods, like DOS attacks.

Really using RCU in the data/fast path makes sense (and we did that already=
).
For control paths (or /proc/.... files), not so much.
