Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB946A1C95
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 14:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjBXNBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 08:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjBXNBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 08:01:39 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467EB59E4F
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 05:01:37 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id iv11-20020a05600c548b00b003dc52fed235so1683984wmb.1
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 05:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GukOmiFG3my4gx8rgc8wJEjY9qate1byNyIrFEYJmtQ=;
        b=Vjv6GGL167rN5OplRDEmvR7S3gm/sr2vgrFYfDz+uWm12nsMltZKFiDUTll6fRHfLN
         Ymvo41yC/qD4HXmcCiClYgExHn53h/xjHx6oMwMs1awA3DwfWsJJmRuUapjjlecTb8Dj
         p+1EhMcH8lXmcQgnwUU64LM4aeylFpN2Izn/YhZZKl2SLMK0rZ++hTeHHhL1DTb1YwaF
         hhv4GbGXnFXpMwVi2ifu/M+X/PO1xMa7lvauBCRptmKWYDV68BBG4yQRJ/DxVUDTl4xj
         Pi6La1BJakpesqB81Yls24fsXyb3IydFIYRgqUHxEazvNCeLOZE13UUi96MD9mYBIiT+
         EmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GukOmiFG3my4gx8rgc8wJEjY9qate1byNyIrFEYJmtQ=;
        b=MJncwSpI1Xxikfo2qbgLHr9JW4G6Z5ZKc6REc3l0xJNxgAfMvVHpibZSbwdVkTM4tv
         BHu0FomtaPUeFJO7P0LXSaSuE8L99+PNnDsRNN0513d+5B51Zm/C+zTyaCSipms6JJzn
         ErNL+fm+hzslUXeC9CICM7WyXv4ttsLJLpWEFebZk+RY/q0XKmGqSS3rWXD+InUVkHMH
         xJpvAsNGaanQDy/6fHXwksx2v/SstNOoVUoqIsIcs1t9jMoxAeQi+uRLmH722LH//cKM
         wDDoy7bnLRhGZPTfP3QhgbRQPjBoHFmpRsIa6BKGxTZ5AXlRDIf8Iqq9T2k92MVAIljg
         B1kQ==
X-Gm-Message-State: AO0yUKUR7H8CihSW56jg3CX3A20yKb3CHZBnyYspno6Nf0YfKi+GGuvC
        jLpN94enxRr/+phpJ9ZOWC5Lqa8vDszGe8N6DRnzsA==
X-Google-Smtp-Source: AK7set/pJiyPDJ7EFKzIdmiry+h5p2Ol0U1EGuX0TZVL6cBgPMc3ZVsYEwxzcHtVLaeF5TIevAW6OMN7Kh84/EauwxI=
X-Received: by 2002:a05:600c:1d8a:b0:3df:97de:8bad with SMTP id
 p10-20020a05600c1d8a00b003df97de8badmr1203793wms.6.1677243695639; Fri, 24 Feb
 2023 05:01:35 -0800 (PST)
MIME-Version: 1.0
References: <20230224071745.20717-1-equinox@diac24.net> <CANn89iL5EEMwO0cvHkm+V5+qJjmWqmnD_0=G6q7TGW0RC_tkUg@mail.gmail.com>
 <Y/inNodCGZlPz5wF@eidolon.nox.tf>
In-Reply-To: <Y/inNodCGZlPz5wF@eidolon.nox.tf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 24 Feb 2023 14:01:23 +0100
Message-ID: <CANn89iKaLMFh0636cDdKOSegLG_tJQzF+u-+kKtLPt2MGn=y-w@mail.gmail.com>
Subject: Re: [PATCH net-next] packet: allow MSG_NOSIGNAL in recvmsg
To:     David Lamparter <equinox@diac24.net>
Cc:     Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Feb 24, 2023 at 1:02=E2=80=AFPM David Lamparter <equinox@diac24.net=
> wrote:
>
> On Fri, Feb 24, 2023 at 11:26:27AM +0100, Eric Dumazet wrote:
> > On Fri, Feb 24, 2023 at 8:18=E2=80=AFAM David Lamparter <equinox@diac24=
.net> wrote:
> [...]
> > > packet_recvmsg() whitelists a bunch of MSG_* flags, which notably doe=
s
> > > not include MSG_NOSIGNAL.  Unfortunately, io_uring always sets
> > > MSG_NOSIGNAL, meaning AF_PACKET sockets can't be used in io_uring
> > > recvmsg().
> >
> > This is odd... I think MSG_NOSIGNAL flag has a meaning for sendmsg()
> > (or write sides in general)
> >
> > EPIPE is not supposed to be generated at the receiving side ?
>
> I would agree, but then again the behavior is inconsistent between
> socket types.  (AF_INET6, SOCK_RAW, ...) works fine with
> io_uring/MSG_NOSIGNAL, meanwhile setting MSG_NOSIGNAL on (AF_PACKET,
> SOCK_RAW, ...) gives EINVAL.
>
> Just to get consistency, MSG_NOSIGNAL might be worth ignoring in
> AF_PACKET recvmsg?  Independent of dropping it from io_uring...
>

Probably because rawv6_recvmsg() never bothered to reject unknown flags.
(Maybe the reason for that was that RAW sockets were privileged ones
back in linux-2.6)
It is too late to add a check there, it might break some applications
mistakenly adding MSG_NOSIGNAL (or any currently ignored bits)

Consistency would be to make sure no recvmsg() handler pretends
MSG_NOSIGNAL has a meaning.

Your patch would prevent us using this bit for a future purpose in af_packe=
t.


> > So I would rather make io_uring slightly faster :
> [...]
> > -       sr->msg_flags =3D READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
> > +       sr->msg_flags =3D READ_ONCE(sqe->msg_flags);
