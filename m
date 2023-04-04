Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF676D6BF9
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 20:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbjDDS1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 14:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjDDS13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 14:27:29 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BEF6EB2;
        Tue,  4 Apr 2023 11:24:40 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id ay14so23881048uab.13;
        Tue, 04 Apr 2023 11:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680632679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjqaR1zqDFifRyDd7iAhwy7vRQIXca8FdbAreZ2wO6E=;
        b=C0Z2VcjozzMf+0vHaPNqjedcOIgyUQ8wYs4YQBtN7LPUJsWLUXJzWOap8LNnEerQv2
         hJg+IbVogzrLeRrC4QqJSfCWuTkBkbnT/qh9CSiYOTQXRQcMnpt14haFQ2m/2YYPbQU2
         k736gQ7EBmavmZfAgfsei0DY4VnBAMUBHi+HxqC2HShTBKmUy5PpsvXtYez2tGqtTg7f
         jgfCzWvRGQ7Oxokgs2hJ6a24CLL+/nm/JvZ1UpZyBy0IDCzLFTOJ7aEIXeP4ZmOR2z+5
         ZJKW3pz+7dUSi+6ZJyWyTCOC6VYzfYWwXTgq/jrmFwE9AuOvWt1w09F5kTzaqu28re76
         PTOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TjqaR1zqDFifRyDd7iAhwy7vRQIXca8FdbAreZ2wO6E=;
        b=dr4WV6Q+R1uOOXTk9n0Gzv3bEfZYL++ObVQUqFbFin/IqTjvPZb2n0BtRtPWGLm3Aj
         49JvdEL6q5/TOPZwIMYpO8SkACFXZxyC19RRtuLDrUu77IZ8CuEMaNiM3IFeJLizClG/
         3ePlYVsLs7W7STxmqCsFkZVPsywddKZ3jiDzRrRgIZWuRob8b7bUKbgNu+AVDlOmRo9M
         U7y6DegWl2TVnoJUq+xXnI5KKaxix0q7Z7dnVIKL5za4nbB2evkcSV+IA2Eeg4SvXodu
         J89+FiY4lhmpFAiOe+Jo5LgALT6p9dwk7oZsmw4tQ/UqHSAOu8ctR2I6tc5zhnct1ra9
         7jrA==
X-Gm-Message-State: AAQBX9dlu9II/Vj1gdDstFyCnrVJMU8mbFgqm80CLnwMdqDvJdlA8jq/
        JTR97SjLF75Oh7cdb7JGPYjUJ1imndJAGodL1AU=
X-Google-Smtp-Source: AKy350b0zfjfj/Z4ssrwH6P3mRWPznO/hUk1CJIzO8/kR81xItsmg2eWZZ9wm5aUA1sRlwnAvVuiK+qJf3hbdFzQzeA=
X-Received: by 2002:a1f:2997:0:b0:42d:7181:7c63 with SMTP id
 p145-20020a1f2997000000b0042d71817c63mr2835745vkp.1.1680632677330; Tue, 04
 Apr 2023 11:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230404015258.1345774-1-michenyuan@huawei.com> <ZCxE2zHwezg5DyjX@corigine.com>
In-Reply-To: <ZCxE2zHwezg5DyjX@corigine.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 4 Apr 2023 11:24:20 -0700
Message-ID: <CABBYNZJmUfCqyn_+12s8KA0rRE0g_cv=hSKfj7grP58-g99y3g@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] bluetooth: unregister correct BTPROTO for CMTP
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Chenyuan Mi <michenyuan@huawei.com>, isdn@linux-pingi.de,
        marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Apr 4, 2023 at 8:40=E2=80=AFAM Simon Horman <simon.horman@corigine.=
com> wrote:
>
> On Tue, Apr 04, 2023 at 09:52:58AM +0800, Chenyuan Mi wrote:
> > On error unregister BTPROTO_CMTP to match the registration earlier in
> > the same code-path. Without this change BTPROTO_HIDP is incorrectly
> > unregistered.
> >
> > This bug does not appear to cause serious security problem.
> >
> > The function 'bt_sock_unregister' takes its parameter as an index and
> > NULLs the corresponding element of 'bt_proto' which is an array of
> > pointers. When 'bt_proto' dereferences each element, it would check
> > whether the element is empty or not. Therefore, the problem of null
> > pointer deference does not occur.
> >
> > Found by inspection.
> >
> > Fixes: 8c8de589cedd ("Bluetooth: Added /proc/net/cmtp via bt_procfs_ini=
t()")
> > Signed-off-by: Chenyuan Mi <michenyuan@huawei.com>
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
> > ---
> >  net/bluetooth/cmtp/sock.c | 2 +-
> >  1 files changed, 1 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
> > index 96d49d9fae96..cf4370055ce2 100644
> > --- a/net/bluetooth/cmtp/sock.c
> > +++ b/net/bluetooth/cmtp/sock.c
> > @@ -250,7 +250,7 @@ int cmtp_init_sockets(void)
> >       err =3D bt_procfs_init(&init_net, "cmtp", &cmtp_sk_list, NULL);
> >       if (err < 0) {
> >               BT_ERR("Failed to create CMTP proc file");
> > -             bt_sock_unregister(BTPROTO_HIDP);
> > +             bt_sock_unregister(BTPROTO_CMTP);
> >               goto error;
> >       }
> >
> > --
> > 2.25.1
> >

This one does not appear on pw for some reason, not sure if that was
because of subject or what, so please resubmit it, don't forget to add
Reviewed-by you got in this thread.

--=20
Luiz Augusto von Dentz
