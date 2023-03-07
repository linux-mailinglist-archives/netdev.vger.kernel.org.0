Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3DE6AD353
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 01:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCGA0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 19:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCGA0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 19:26:12 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5745C6487A;
        Mon,  6 Mar 2023 16:25:48 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id cw28so46031739edb.5;
        Mon, 06 Mar 2023 16:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678148747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+UR9FFBEa9VeA+oww67B6rFyUQmEe/PPppV1t7khWOE=;
        b=YtCf/G8y5zoYuVqIEvqRe4vOcs9im83Qf4S3UIgvr0MXCvIpCCYbAOxj+sAVTGFnxC
         Dmy1uYOKzKzzp0RcTA5Ca0HkzuJ+l2HRS9wTRbYYWCDRY92YGL8q1xWDhdzNO6eEhjqL
         Qu5fdBDMNrPtKV7tnzGiBWFE2aP/AGd6GItdER1NdZUtD2RYGgxz2whfKm8w2X7/EHqZ
         v5bjmCgGpQ8SABd7TqOWUTVld2b4nXnY/q1K+vPtCHHsIef/4jX/5gjJbPMT0cGYicAi
         oc56BdeZN6ftDEPOk4QQaOH59ixEdSzoRsxAuDZuOMOz4CubTWIF+1ou4dXfikLr1dGa
         FqqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678148747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+UR9FFBEa9VeA+oww67B6rFyUQmEe/PPppV1t7khWOE=;
        b=IkuvzIcjBtDDQHrZQntnZuRB3L6mViEvhfzBz7iODyRkUxIO9vvf6/Qi9+38uENwq2
         scPapW1OBooRdlO9kyPwvmWogNXFyaLilOpDGp9PNdYSTC5tVHtcIhqRtedmYqDLsr1/
         KMTEV/xxULgiogJiqyGEqkxZ1gpPNsg/eKCNj3bVcheommQI/RJ9JbT6cIvlyquhJpQ/
         gFkfg8eZjSe/htmOAKAX+t8OFTxAkSwZrt8L8aADA0W2avmG4dwYfX4jN3QYpuHyVSeT
         CjlfpJwysuunzHVDQyNjFru5XgpoVV72le+72a60bZ9D74n6jRIEwrqP+sGXFfyR4FyN
         bRhw==
X-Gm-Message-State: AO0yUKVUn85h5A75lmnwKgjQpJj0GSSAHdsBwdd0AeC/ck9ZfgoD3e77
        aUVcNJ7nSA98+QjRKaBgJOdvYMANbPGcT6cDyec=
X-Google-Smtp-Source: AK7set9PO9Kg/5pL+9arPCWrc2LMan5SygAUNqKvXUnWpE2y0K1fIhjZpNIIy59E8TtdA7J7USobuxaQcjT3YXuB114=
X-Received: by 2002:a17:907:20b8:b0:914:5659:593 with SMTP id
 pw24-20020a17090720b800b0091456590593mr1306665ejb.3.1678148746754; Mon, 06
 Mar 2023 16:25:46 -0800 (PST)
MIME-Version: 1.0
References: <20230306115745.87401-1-kerneljasonxing@gmail.com> <ZAX98D91HvKrJBCO@corigine.com>
In-Reply-To: <ZAX98D91HvKrJBCO@corigine.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 7 Mar 2023 08:25:10 +0800
Message-ID: <CAL+tcoDAeTznH_EDdaM5dA4N5U-KhhnnvrxOCCAceMOdvGa+MA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] udp: introduce __sk_mem_schedule() usage
To:     Simon Horman <simon.horman@corigine.com>
Cc:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 6, 2023 at 10:51=E2=80=AFPM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Mon, Mar 06, 2023 at 07:57:45PM +0800, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Keep the accounting schema consistent across different protocols
> > with __sk_mem_schedule(). Besides, it adjusts a little bit on how
> > to calculate forward allocated memory compared to before. After
> > applied this patch, we could avoid receive path scheduling extra
> > amount of memory.
> >
> > Link: https://lore.kernel.org/lkml/20230221110344.82818-1-kerneljasonxi=
ng@gmail.com/
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> > V2:
> > 1) change the title and body message
> > 2) use __sk_mem_schedule() instead suggested by Paolo Abeni
> > ---
> >  net/ipv4/udp.c | 31 ++++++++++++++++++-------------
> >  1 file changed, 18 insertions(+), 13 deletions(-)
> >
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 9592fe3e444a..21c99087110d 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1531,10 +1531,23 @@ static void busylock_release(spinlock_t *busy)
> >               spin_unlock(busy);
> >  }
> >
> > +static inline int udp_rmem_schedule(struct sock *sk, int size)
>

> nit: I think it's best to drop the inline keyword and
>      let the compiler figure that out.

Thanks for the review. I'll do that in the v3 patch.

Jason
