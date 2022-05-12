Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC0852444F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 06:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347244AbiELEgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 00:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346868AbiELEf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 00:35:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B088A645E;
        Wed, 11 May 2022 21:35:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso3808482pjb.5;
        Wed, 11 May 2022 21:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HYujfKEE4FRBcffvvm/ENwPqr1+X2EgAq7QQ3ImY+bQ=;
        b=jHNmqQtI3JjAQf13WCLhhUg/GhvEmfOIM1kfRhBNBgNtmAi51zl+XJnGjcL7McS6Ar
         LMPr3XQlMh4JzZi1rdWCZAhI5l6Uv75+2ApXs/spGXnT1ggSZHiU+55cGnCngn8WuC7a
         iqwyqc8GO4v2p8VDLew+kKz0NybCB6ZqT0P6zdu72hakXr8XvtfpAj5QfIb+hd3C3PQd
         lxsAOJ2j7YonNfXBAVbpqRLMmL/JGPRt1TtVwU2BeRfPEqRLnolMs/lT1golpwTxKWZy
         unZtCk7SkTT8aMzo2xP30tsjDyU52WBzQfyh7KpKe6ECaApQHggr0x0IuXbuXHCIZ9mV
         XRtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HYujfKEE4FRBcffvvm/ENwPqr1+X2EgAq7QQ3ImY+bQ=;
        b=471YYjuUEqKmHdLqZiXCMpnAhFSdFUP6/KHddyFLxwicnhKiTGSG40r1HmTMarSDCi
         uZkA6oohJOIanthFT+JaWq8N2M00yK7OJ5h0KcIgBno4zbJeZcmTCGHFpHj2XawJAN8G
         1TsJ9yCmi9nRp/8cvfbzsxtfpIkUkcnMKnjpgtK0OgBXd3IYExpCZSPAl7tfQtGwIfvD
         xr00WQBd5dFzlkMrQEmDNdPeHLDqkICPpiT+wR7vzfSFU+zjqv/NBZYPLIyEuGOPVd00
         uY+M7ym52Nr09/Kcyt1I6LlP3GhROEhEOuAtfNscjZ+xy4eSewrOj96GEgY/nbHBmKoY
         p5vw==
X-Gm-Message-State: AOAM530LFaGt4eck6CO+9+1ZajWAXfQYvFhUoO5ptVYOjMGuAQmVVbSq
        bFKQgwtj2oEHbkr8x01AwlrdE4xr7rWhpfN/nMQ=
X-Google-Smtp-Source: ABdhPJxE1V9btljZ/t5/qYQ28xGw+YiKTMw49we5zx+AI0AipeCM011JF7Jcpuq8Ml06bzMykWZ5YQyq6i+Rpf0FXGc=
X-Received: by 2002:a17:902:7487:b0:15f:330:5022 with SMTP id
 h7-20020a170902748700b0015f03305022mr21498706pll.18.1652330155178; Wed, 11
 May 2022 21:35:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220509140403.1.I28d2ec514ad3b612015b28b8de861b8955033a19@changeid>
 <CABBYNZ+qpWTX-FQ8QCiey0kf_rghDMnfQi3tt8zsv-5cuudbtg@mail.gmail.com> <CAGPPCLBTec4SuL+UiFPkvq9=Bz8UY_3nQa5JjjHZ_415yt7KjA@mail.gmail.com>
In-Reply-To: <CAGPPCLBTec4SuL+UiFPkvq9=Bz8UY_3nQa5JjjHZ_415yt7KjA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 11 May 2022 21:35:44 -0700
Message-ID: <CABBYNZKU5TFYv14bNLksWV7Y5fOdLxdWPWm-bv7qeq0uXApiXg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Fix Adv Monitor msft_add/remove_monitor_sync()
To:     Manish Mandlik <mmandlik@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On Wed, May 11, 2022 at 5:56 PM Manish Mandlik <mmandlik@google.com> wrote:
>
> Hi Luiz,
>
> On Wed, May 11, 2022 at 2:23 PM Luiz Augusto von Dentz <luiz.dentz@gmail.=
com> wrote:
>>
>> Hi Manish,
>>
>> On Mon, May 9, 2022 at 2:05 PM Manish Mandlik <mmandlik@google.com> wrot=
e:
>> >
>> > Do not call skb_pull() in msft_add_monitor_sync() as
>> > msft_le_monitor_advertisement_cb() expects 'status' to be
>> > part of the skb.
>> >
>> > Same applies for msft_remove_monitor_sync().
>> >
>> > Signed-off-by: Manish Mandlik <mmandlik@google.com>
>> > ---
>> >
>> >  net/bluetooth/msft.c | 2 --
>> >  1 file changed, 2 deletions(-)
>> >
>> > diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
>> > index f43994523b1f..9990924719aa 100644
>> > --- a/net/bluetooth/msft.c
>> > +++ b/net/bluetooth/msft.c
>> > @@ -387,7 +387,6 @@ static int msft_remove_monitor_sync(struct hci_dev=
 *hdev,
>> >                 return PTR_ERR(skb);
>> >
>> >         status =3D skb->data[0];
>> > -       skb_pull(skb, 1);
>> >
>> >         msft_le_cancel_monitor_advertisement_cb(hdev, status, hdev->ms=
ft_opcode,
>> >                                                 skb);
>> > @@ -506,7 +505,6 @@ static int msft_add_monitor_sync(struct hci_dev *h=
dev,
>> >                 return PTR_ERR(skb);
>> >
>> >         status =3D skb->data[0];
>> > -       skb_pull(skb, 1);
>>
>> Well if it expects it to be part of the skb then there is no reason to
>> pass it as argument in addition to the skb itself.
>
> The problem is msft_le_monitor_advertisement_cb() is invoked directly via=
 msft_add_monitor_sync() and also from __msft_add_monitor_pattern() as a ca=
llback from hci_req_run_skb(). So, when it is invoked from hci_req_run_skb(=
) it sends status separately as an argument along with the skb and that's w=
hy that argument is required.
>
> Looks like some parts of msft.c still use the old way i.e. hci_req_run_sk=
b() instead of __hci_cmd_sync() after hci_sync related refactoring. I am wo=
ndering if it was left like this intentionally? If not, then we probably ne=
ed to refactor msft.c to use __hci_cmd_sync() for all hci requests. In that=
 case, I can work on refactoring and we can discard this patch altogether. =
Please let me know.

Yes, if you have time please convert it to use hci_sync.c since we
would like to completely deprecate/remove hci_request.c eventually, if
you think that will take some time we can perhaps merge this changes
first though.

>>
>> >         msft_le_monitor_advertisement_cb(hdev, status, hdev->msft_opco=
de, skb);
>> >
>> > --
>> > 2.36.0.512.ge40c2bad7a-goog
>> >
>>
>>
>> --
>> Luiz Augusto von Dentz
>
> Regards,
> Manish.



--=20
Luiz Augusto von Dentz
