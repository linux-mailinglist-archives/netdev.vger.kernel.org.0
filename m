Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E0B6B9FCC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 20:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjCNTa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 15:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjCNTa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 15:30:28 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF17B29E1B;
        Tue, 14 Mar 2023 12:30:09 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id h9so17144394ljq.2;
        Tue, 14 Mar 2023 12:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678822207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dqgms4mBVohNM7iW30qEDQ+lDG4KIARpTXgSHSORq30=;
        b=F3bvLAaOVnkJ4xkEZeYyInmloRQNEHJEFV/EjiGaMY54T1YvbiYXjUCin9X7zg00z7
         Qzq1RUZF6PZb0RqEIJN6q+2jGgRuZyle2FVmH3gRugOUlf56BSUBDE69GWEgm5capqEp
         0moRLYqoLZ/aV2Iz4vJGXyPYXA94iXPBsqu6gdRduNibfPB+QSE12YFmIzkIWXM2T1IF
         PAMcGk2EB6XPRVS+hIo3/LQuouSPqgx37meIYtMbly2DZoZsJwUgcTgcm1sghOgDBgHZ
         E+1Cap+9AYlQuXNsdJtWncpPSYPCeVUqYHuOzb+n7kr1BfJg5hFfFc81ZYwe+wIp8QvW
         uuag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678822207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dqgms4mBVohNM7iW30qEDQ+lDG4KIARpTXgSHSORq30=;
        b=M9Jba3PzpEN5rmiu+F9Tyu7wvdyJ0f1lU3Sqttsie535zBoUXWv0Jtxs3GbmxHr6lL
         nOzfgxyq0V9QaDC5kjii0PHAmhQeI5QumVjTYn8cvjlp1IJtGZAsQ9uhMd+vchplecv9
         XtSlGYmvT9K3qOJ78MnBuaeiXH8Ni6PETs0jQbsx2Z6UD+c4LR2uLI3LmRaEv2R91o1B
         u+cDQ7MTEZ2B75i9b12YHGTDgBrQU7eKR4+KYUJM9voOd1YrkC2bzs7un0SdKD+BcNlS
         PLPflQE2NYYs++p1UldGgAc67hqhrWN7I+vhwtiwwCMytS6rimKk9wX34jc97Zi3+dZo
         QirQ==
X-Gm-Message-State: AO0yUKV843dpBJu8kZ3atGo4IvJzv6ttgUtZhWmRpFplQVSjnQjPnZ0k
        lYPr1BiRwNkIsL3GwrxrfKCmB8irM3zO79xyxUY=
X-Google-Smtp-Source: AK7set+SM7jX1PJsr5O6/4TOBKUpUU46b1xy5TdJHkG86pFItAWyRncMY0cFbgoZ/JH8OMB04G/rLYtXA9opsMA4DS8=
X-Received: by 2002:a2e:b81a:0:b0:295:a96a:2ea1 with SMTP id
 u26-20020a2eb81a000000b00295a96a2ea1mr93979ljo.0.1678822207382; Tue, 14 Mar
 2023 12:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230313144028.3156825-1-neeraj.sanjaykale@nxp.com>
 <20230313144028.3156825-4-neeraj.sanjaykale@nxp.com> <ZBBUYDhrnn/udT+Z@corigine.com>
 <AM9PR04MB8603E3F3900DB13502CFCB8DE7BE9@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <ZBCh98lGvhlMKQQp@corigine.com>
In-Reply-To: <ZBCh98lGvhlMKQQp@corigine.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 14 Mar 2023 12:29:55 -0700
Message-ID: <CABBYNZ+Zx8r-yJD9qq6B0oiDKTjzrvRa2Je0=C1hBjKvMyjmgA@mail.gmail.com>
Subject: Re: [PATCH v10 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
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

Hi,

On Tue, Mar 14, 2023 at 9:34=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Tue, Mar 14, 2023 at 03:40:34PM +0000, Neeraj sanjay kale wrote:
> > Hi Simon
> >
> > Thank you for reviewing the patch. I have a comment below:
> >
> > >
> > > > +send_skb:
> > > > +     /* Prepend skb with frame type */
> > > > +     memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
> > > > +     skb_queue_tail(&nxpdev->txq, skb);
> > > > +
> > > > +     btnxpuart_tx_wakeup(nxpdev);
> > > > +ret:
> > > > +     return 0;
> > > > +
> > > > +free_skb:
> > > > +     kfree_skb(skb);
> > > > +     goto ret;
> > >
> > > nit: I think it would be nicer to simply return 0 here.
> > >      And remove the ret label entirely.
> > >
> > > > +}
> > >
> > We need to return from this function without clearing the skbs, unless =
"goto free_skb" is called.
> > If I remove the ret label and return after kfree_skb() it causes a kern=
el crash.
> > Keeping this change as it is.
> >
> > Please let me know if you have any further review comments on the v11 p=
atch.
>
> I'll look over v11.
>
> But for the record, I meant something like this:
>
> send_skb:
>      /* Prepend skb with frame type */
>      memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
>      skb_queue_tail(&nxpdev->txq, skb);
>
>      btnxpuart_tx_wakeup(nxpdev);
>      return 0;

+1, perhaps it wouldn't be a bad idea to have the code above in a
separate function e.g. btnxpuart_queue_skb since this code might be
common.

> free_skb:
>      kfree_skb(skb);
>      return 0;
> }
>
> > We need to return from this function without clearing the skbs, unless =
"goto free_skb" is called.
> > If I remove the ret label and return after kfree_skb() it causes a kern=
el crash.
> > Keeping this change as it is.
> >
> > Please let me know if you have any further review comments on the v11 p=
atch.



--=20
Luiz Augusto von Dentz
