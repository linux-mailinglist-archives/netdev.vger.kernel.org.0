Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B99557674
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 11:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiFWJSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 05:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiFWJSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 05:18:41 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB010192B2
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:18:38 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id a11so13753642ljb.5
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XcQS1XCkl/vk/iiK9UlBRssI2Zu/U1XTYmHdI6QOmKg=;
        b=NCukPQSVf9nm4WScxjlBsKJl1tSICpwfp1JKN9pkxN5Js4SU4FWxjMg0gKJq4i/Z3m
         juea/x0zHxdUfCT/ONLj7NebPZEoZJQqOyHhdztWJd5fEexSPqteI81MXJCxC5gpxjwn
         UdWSFNlaYPg6BXAtysbcR07TeooqQQPSQryAXEZvP4+kg0k+4fBeJ6fAk+GWUnxbteMk
         TjTguyQ95dylDp9yGPe2XzK81ISIWdfO08e8MwwSvjEb7vRfPC/KRSfzQA49Ib/nxmlh
         70eR5CzA+OqKFS/EQ/t2WDFWh9SEsUU4uWB0Mx4QH7EQY6iI5lEus1EvmxmQZBcWKTGM
         Dy9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XcQS1XCkl/vk/iiK9UlBRssI2Zu/U1XTYmHdI6QOmKg=;
        b=fPHIFW3xatu+W37Tx4ov9MiYPqQRqJEejylYjuT3k5wFkA1tjThmQ5bfPZFqLvRxve
         XZCjn4A0VSUq3yAK0HJfyasC5PPMl5NPZG/T/fSdEs1hWf490gSO8A4Kh82hBeNu2kLe
         Ul1CHTJAr1E3HvuDTnXKcD8bRWrarBedyQlLpqiylP/do0LatZzptB2zHpRi4+Zn34qh
         XPByxJoS0NmYmeKe4YlJ37DF3mldG4WPeCYMv54t6hWB77rBqJteeW3bh245C4tsMcDm
         uOG7ngsQJJZ5LdFFCykhurRV78luHzuV75jDo8HM2nM+eRplGcf1tsRxm1iCSScLpcle
         Ig1Q==
X-Gm-Message-State: AJIora9Bbu8tM53AbgpDcDn2a6q+pvVKCtD9JzDZFX7a1QUDWXH3Hd6U
        wJSgn0YtFl0kdvVFPQ5Kg9FQBRO1NpuIHxsLPsELUA==
X-Google-Smtp-Source: AGRyM1uZOd8+a/MGh7Ds9XxSG3qQcz0C1wEyURCRfKYw863suXgA3Ov2iAiQPtxpH7+zkOQpaRk2+sY63kjzx4nYjIU=
X-Received: by 2002:a2e:b0fc:0:b0:255:6f92:f9d4 with SMTP id
 h28-20020a2eb0fc000000b002556f92f9d4mr4259427ljl.92.1655975917005; Thu, 23
 Jun 2022 02:18:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220607104015.2126118-1-poprdi@google.com> <CAPUC6bJbVMPn1FMLYnXg2GUX4ikesMSRjj=oPOOrS5H2DOx_bA@mail.gmail.com>
 <CAPUC6b+xMnk8VDGv_7p9j4GHD75FrxG3hWKpTSF2zHj508=x9A@mail.gmail.com> <CANp29Y7gb7cop8p8k-LqR1WoLwOLxi+QGRGLEZrbYW8Tw6_i2w@mail.gmail.com>
In-Reply-To: <CANp29Y7gb7cop8p8k-LqR1WoLwOLxi+QGRGLEZrbYW8Tw6_i2w@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 23 Jun 2022 11:18:25 +0200
Message-ID: <CACT4Y+b3LHerJNwcPuUSxWMXRKFAunK83BHEXiwGs53Jves6QQ@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Collect kcov coverage from hci_rx_work
To:     Aleksandr Nogikh <nogikh@google.com>
Cc:     =?UTF-8?Q?Tam=C3=A1s_Koczka?= <poprdi@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jun 2022 at 12:20, Aleksandr Nogikh <nogikh@google.com> wrote:
>
> (Resending the reply I sent to the v1 of the patch. I sent it by
> mistake with HTML content, so it did not reach lore.)
>
> I checked out v5.18.1, applied this patch and fuzzed it with syzkaller
> for a day. The fuzzer was indeed able to find and report more coverage
> of the BT subsystem than without the patch.
>
> Tested-by: Aleksandr Nogikh <nogikh@google.com>
>
>
> On Tue, Jun 14, 2022 at 3:34 PM Tam=C3=A1s Koczka <poprdi@google.com> wro=
te:
> >
> > Hello Marcel,
> >
> > I hope this was the change you originally requested, and I did not
> > misunderstand anything, but if you need any additional modification to
> > the code or the commit, please feel free to let me know!
> >
> > Thank you,
> > Tamas
> >
> > On Tue, Jun 7, 2022 at 1:44 PM Tam=C3=A1s Koczka <poprdi@google.com> wr=
ote:
> > >
> > > Hello Marcel,
> > >
> > > I added some comments into the code about what the kcov_remote calls =
do and
> > > why they were implemented and I also added some reasoning to the comm=
it
> > > message.
> > >
> > > I did not mention in the commit but these functions only run if the k=
ernel
> > > is compiled with CONFIG_KCOV.
> > >
> > > Thank you again for reviewing the patch!
> > >
> > > --
> > > Tamas
> > >
> > > On Tue, Jun 7, 2022 at 12:40 PM Tamas Koczka <poprdi@google.com> wrot=
e:
> > > >
> > > > Annotate hci_rx_work() with kcov_remote_start() and kcov_remote_sto=
p()
> > > > calls, so remote KCOV coverage is collected while processing the rx=
_q
> > > > queue which is the main incoming Bluetooth packet queue.
> > > >
> > > > Coverage is associated with the thread which created the packet skb=
.
> > > >
> > > > The collected extra coverage helps kernel fuzzing efforts in findin=
g
> > > > vulnerabilities.
> > > >
> > > > Signed-off-by: Tamas Koczka <poprdi@google.com>
> > > > ---
> > > > Changelog since v1:
> > > >  - add comment about why kcov_remote functions are called
> > > >
> > > > v1: https://lore.kernel.org/all/20220517094532.2729049-1-poprdi@goo=
gle.com/
> > > >
> > > >  net/bluetooth/hci_core.c | 10 +++++++++-
> > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > > > index 45c2dd2e1590..0af43844c55a 100644
> > > > --- a/net/bluetooth/hci_core.c
> > > > +++ b/net/bluetooth/hci_core.c
> > > > @@ -29,6 +29,7 @@
> > > >  #include <linux/rfkill.h>
> > > >  #include <linux/debugfs.h>
> > > >  #include <linux/crypto.h>
> > > > +#include <linux/kcov.h>
> > > >  #include <linux/property.h>
> > > >  #include <linux/suspend.h>
> > > >  #include <linux/wait.h>
> > > > @@ -3780,7 +3781,14 @@ static void hci_rx_work(struct work_struct *=
work)
> > > >
> > > >         BT_DBG("%s", hdev->name);
> > > >
> > > > -       while ((skb =3D skb_dequeue(&hdev->rx_q))) {
> > > > +       /* The kcov_remote functions used for collecting packet par=
sing
> > > > +        * coverage information from this background thread and ass=
ociate
> > > > +        * the coverage with the syscall's thread which originally =
injected
> > > > +        * the packet. This helps fuzzing the kernel.
> > > > +        */
> > > > +       for (; (skb =3D skb_dequeue(&hdev->rx_q)); kcov_remote_stop=
()) {
> > > > +               kcov_remote_start_common(skb_get_kcov_handle(skb));
> > > > +
> > > >                 /* Send copy to monitor */
> > > >                 hci_send_to_monitor(hdev, skb);

Looks good to me.
Anything else needed to merge this patch?

Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
