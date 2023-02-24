Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63CA36A1F6B
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjBXQPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjBXQPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:15:00 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DBF1F91C
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 08:14:59 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id j2so14278554wrh.9
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 08:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wqctOt0Z9Z4oI79oBbfnBf5nVakOpUKrrJaXQvs3lDA=;
        b=eMn43wEeRu6kCrDb8soTKv4oBUddYu2GcC/dmfld+GvMJeR/DByh+FI0jgjFEU9XMC
         trxHOZJ+z3CX1Ys7kFb+M7ZHtbJVmpBxKJ0u0PZj5kzJzQOGh4DcOzezEAgGazLd/zte
         j+JXLR6KJ8EEubKU0clja+9LWSGRXdGosCRM1bY7xtRPnZNpnkGhP/mjDlQIDR/m3KDz
         oPhYuPTRoeITEpzHyFMMdkZrud8Z7rSAG7Ymsp6qonm4CKkr7DKufYdqFm2R/l3zWq5R
         tVeBb0U6Dn+b13kxn7lJsdTn8yw9cmdjMgRQjzsHp59OyusIXXsbAoBLo1ToOu3nBoCP
         w1yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wqctOt0Z9Z4oI79oBbfnBf5nVakOpUKrrJaXQvs3lDA=;
        b=adRVFLHkxM4LF++zbJ8U+2wyTmZnZPB+NFKdcl12EOB+hRltgp2yQAO0fZH5QOqYL+
         SNd/zBUP5YwESIsjo9SgOJVfmcaxsGQ6UyLf694P9T20QnYmfs06U3GjeDSF69W0bIlt
         Thd2MGfGPD4kgXurFD2X2f7fsl8p6lff6C/bLGrNiUVjySXHGqVq0UpOp+vnTsHwZZjn
         lqxrBWaPu/I27vN/HPDYtQkRzwfPvDx9Fp+Bu3tkglgUjT/H5PGvoD7fywcZM1vuGL5v
         3283QBcBe2j71d5c0Ofd9YAITll2uX0oll1rQYPRiASOtGCESSmgElean2K/8zUzHAAW
         eItw==
X-Gm-Message-State: AO0yUKVPsQ+fCTpIVpu69ziasozsI+y/ewR0IcXOFhoKcsXLunxQZqhk
        FO6Q+5GyT440olChudE7xaNA2LYe5y/Eg4K7WLC1Fw==
X-Google-Smtp-Source: AK7set9tn8+uVIVmP/VkpI+R+yeCwNyOdPrjXWzx2RWUr3qkYE62TTdIkuPoaSVWdp34H5M7jW4uJ0GdeA3U7TaqghM=
X-Received: by 2002:a5d:49cd:0:b0:2c3:be6a:d7d4 with SMTP id
 t13-20020a5d49cd000000b002c3be6ad7d4mr1070400wrs.11.1677255297637; Fri, 24
 Feb 2023 08:14:57 -0800 (PST)
MIME-Version: 1.0
References: <CANn89iJE6SpB2bfXEc=73km6B2xtBSWHj==WsYFnH089WPKtSA@mail.gmail.com>
 <20230224150123.128346-1-equinox@diac24.net>
In-Reply-To: <20230224150123.128346-1-equinox@diac24.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 24 Feb 2023 17:14:45 +0100
Message-ID: <CANn89iL1q6vs5MVt9SUNJ6uzPwg738vKKOFvyXQD3K3m7BAd8g@mail.gmail.com>
Subject: Re: [PATCH] io_uring: remove MSG_NOSIGNAL from recvmsg
To:     David Lamparter <equinox@diac24.net>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 4:04=E2=80=AFPM David Lamparter <equinox@diac24.net=
> wrote:
>
> MSG_NOSIGNAL is not applicable for the receiving side, SIGPIPE is
> generated when trying to write to a "broken pipe".  AF_PACKET's
> packet_recvmsg() does enforce this, giving back EINVAL when MSG_NOSIGNAL
> is set - making it unuseable in io_uring's recvmsg.
>
> Remove MSG_NOSIGNAL from io_recvmsg_prep().
>
> Signed-off-by: David Lamparter <equinox@diac24.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>
> > Sure, or perhaps David wanted to take care of this.
>
> Here you go.  But maybe give me a few hours to test/confirm...
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
