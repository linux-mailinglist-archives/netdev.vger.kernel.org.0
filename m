Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82733273C18
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbgIVHhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729634AbgIVHhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:37:14 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4164EC0613CF
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:37:14 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l15so1553332wmh.1
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f6NEte3lutGwCOE6JLOavb/M9H8I1XfzDGWcZi3Iq7Q=;
        b=XNaPLn0t+kxDTIOfVoPVBX4FPKsDFUw4iGC5BV0MEuJKWj/BvrlvjgHDauwC0X3iri
         klyOdAfM43Y3kMVpgvFWfFpwgIgy/4bLbHMv2iaKFjCSacJv5dHinCvYaGYW+H7Anrgo
         DHcq25ogTZUd/m5pG0b1NjM6JTn/fFVJtDY1E6vPZ89HxAi8vGOVIFVxL7tlHk0Hznp3
         FDoQs92XNxUgQ80msZD3Axv/B0hTL33ZPIga+06PWwEN4jw3bXdGUlhja3t6o6+NCzHF
         /3q6zFTs5kMF70vvrisNhfHUbgH90fmb0A5Nz6HggmxQdyRPyUBYqQWE5ndgyOqCXGuP
         azEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f6NEte3lutGwCOE6JLOavb/M9H8I1XfzDGWcZi3Iq7Q=;
        b=Rxv+PSg94bs6Qy2tfA5c1sfVYiEPdEDdo0ep0mIwP6TvRS6b1Hji0an2YzMMZGTa3e
         jBDtVdpAAK0tgD89RjcgQBNGXr/8zYoBUh7y1kwWRJUiD56H3Q9XEmp9oKykuxuxWgav
         5o7qaT9WiOV+WRK/a65c1MKdHv4vprIzQ3mkEtPG2OyrRVV4BxBOfJKLkfCviVaLLysd
         w6OnLFVGdpkmJ4hRRs235KbIfNRofPI1te8CsVZZzi9F1HwYioh4y+0Knrs1mU/32kqR
         AwPlUI/5RYXqbpLtozcM+wyqdS1WUvqgz0jTLstSdReEmGjLHQlKdkDV9h3tCSsqUGOd
         xFLA==
X-Gm-Message-State: AOAM530O8O7PfWBaS9IsGWajsVRvDJiRZbV4YudAQCQ//JItmipR7eZ3
        X2JIf9cIsCv1yWI+IOfYuqWSwRLyExYsFLXXdBR9zg==
X-Google-Smtp-Source: ABdhPJzVWqCDtrVv7PLgmds+KflwVNovPQCQJ66ow/a2qlmcY4wT3p6qVfV9Z66NlM7m5l2WQeWjU4ZdmDud0sjo51k=
X-Received: by 2002:a1c:7308:: with SMTP id d8mr3081805wmb.55.1600760232528;
 Tue, 22 Sep 2020 00:37:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200921163021.v1.1.Id3160295d33d44a59fa3f2a444d74f40d132ea5c@changeid>
 <CABBYNZJGfDoV+E-f6T=ZQ2RT0doXDdOB7tgVrt=4fpvKcpmH4w@mail.gmail.com>
In-Reply-To: <CABBYNZJGfDoV+E-f6T=ZQ2RT0doXDdOB7tgVrt=4fpvKcpmH4w@mail.gmail.com>
From:   Archie Pusaka <apusaka@google.com>
Date:   Tue, 22 Sep 2020 15:37:01 +0800
Message-ID: <CAJQfnxHcvm_-iCP-2Y6GR1vG4ZmMr==ZuMHBua8TeeiNbqAJgA@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: Enforce key size of 16 bytes on FIPS level
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

On Tue, 22 Sep 2020 at 01:13, Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Archie,
>
> On Mon, Sep 21, 2020 at 1:31 AM Archie Pusaka <apusaka@google.com> wrote:
> >
> > From: Archie Pusaka <apusaka@chromium.org>
> >
> > According to the spec Ver 5.2, Vol 3, Part C, Sec 5.2.2.8:
> > Device in security mode 4 level 4 shall enforce:
> > 128-bit equivalent strength for link and encryption keys required
> > using FIPS approved algorithms (E0 not allowed, SAFER+ not allowed,
> > and P-192 not allowed; encryption key not shortened)
> >
> > This patch rejects connection with key size below 16 for FIPS level
> > services.
> >
> > Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > Reviewed-by: Alain Michaud <alainm@chromium.org>
> >
> > ---
> >
> >  net/bluetooth/l2cap_core.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > index ade83e224567..306616ec26e6 100644
> > --- a/net/bluetooth/l2cap_core.c
> > +++ b/net/bluetooth/l2cap_core.c
> > @@ -1515,8 +1515,13 @@ static bool l2cap_check_enc_key_size(struct hci_conn *hcon)
> >          * that have no key size requirements. Ensure that the link is
> >          * actually encrypted before enforcing a key size.
> >          */
> > +       int min_key_size = hcon->hdev->min_enc_key_size;
> > +
> > +       if (hcon->sec_level == BT_SECURITY_FIPS)
> > +               min_key_size = 16;
> > +
> >         return (!test_bit(HCI_CONN_ENCRYPT, &hcon->flags) ||
> > -               hcon->enc_key_size >= hcon->hdev->min_enc_key_size);
> > +               hcon->enc_key_size >= min_key_size);
>
> While this looks fine to me, it looks like this should be placed
> elsewhere since it takes an hci_conn and it is not L2CAP specific.

From what I understood, it is permissible to use AES-CCM P-256
encryption with key length < 16 when encrypting the link, but such a
connection does not satisfy security level 4, and therefore must not
be given access to level 4 services. However, I think it is
permissible to give them access to level 3 services or below.

Should I use l2cap chan->sec_level for this purpose? I'm kind of lost
on the difference between hcon->sec_level and chan->sec_level.

>
> >  }
> >
> >  static void l2cap_do_start(struct l2cap_chan *chan)
> > --
> > 2.28.0.681.g6f77f65b4e-goog
> >
>
>
> --
> Luiz Augusto von Dentz
