Return-Path: <netdev+bounces-6555-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 993C1716E53
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:06:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 547BF2812F9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E2C31EF0;
	Tue, 30 May 2023 20:06:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA6B2D277
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:06:17 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2317BF3;
	Tue, 30 May 2023 13:06:16 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2af278ca45eso51406361fa.1;
        Tue, 30 May 2023 13:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685477174; x=1688069174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gy7g3HmcFJ07k2+S79J+2E5SNsvjTiJvRjtXbmAogd0=;
        b=A8URtGPLrsAUgpVPmcSHEyRdUeR0+DAR1lzp8M2EWxjdIYI6P5C85NucXMMrYYq1bx
         uFrnEBhNCKkWqi0jkTLoTZmnNQ2Q/Vj8eP0olu7MqiiWy700B0g+h7Yq5ZjNYpeOHS7n
         LBqCtDlyJqmBKQdLn7q0PppcuNY+WBFfDuvPhph0QBmt/5L7Tdtwgz0Y8bbZ2VvLOoco
         spGtqRYNbp43iW8JIKKci3Gb90J4NZJqSOE9/Y3FBRkNQ+PNsiTmjdPmKN8EynUVrzTK
         68eMObI35wYQXLc+yAikDnQh6FpPv2x1ROC5o9Tv8rORptarz7AjjKPFefvZe47kDLLu
         BLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685477174; x=1688069174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gy7g3HmcFJ07k2+S79J+2E5SNsvjTiJvRjtXbmAogd0=;
        b=LeoiadC4LETLgKsgW4DR6aDNzYB7mW/prty3B98Yhg/p8Q+V4hvZ2ae+TNTHenmxZz
         EYXcdY/RtsGPdlrma7CX8DNjPF4Km2GV1KNUDptexK9WzrWhjG58132CTC5uaPoHLwn1
         aPAOm9pULxXrGX1lPIDsk0r8+XCq0Wdm4tjZoXiyueakkLEgsQJt4Q6g2o/T9CrDLB/N
         Rz3mNMWVO076z5MSiiz5mN0ZsN5PRKhPZaOx1U8CwYYwCJi36F23hI39g/xGi0lSmyP9
         +DaOvwylI1pTVqyCXVPYVSUHMRdYV6tQDJYkktpuudMkuzwUkzYCjpbFIAONkCq9m4iN
         sSHg==
X-Gm-Message-State: AC+VfDw80/Ba8M0QVgqMxn9GT+x+1yyK7mBgNTberWrIfBQIu5s1+hKj
	ipn29BwCeEWpx/KK/v0ga+oZuyx/ivOHEJeNRvw=
X-Google-Smtp-Source: ACHHUZ5k1qpbdpbHtwSrm5N7oo/aBUz5QZq8DF/6U/8ESwy7n9GyqYF6hSvis1aU8HwJveHgmbXdmsi8sxVEEp1aXl8=
X-Received: by 2002:a2e:9682:0:b0:2ad:aa42:8c0b with SMTP id
 q2-20020a2e9682000000b002adaa428c0bmr1491500lji.35.1685477174136; Tue, 30 May
 2023 13:06:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230424133542.14383-1-johan+linaro@kernel.org> <ZHYHRW-9BN4n4pPs@hovoldconsulting.com>
In-Reply-To: <ZHYHRW-9BN4n4pPs@hovoldconsulting.com>
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date: Tue, 30 May 2023 13:06:01 -0700
Message-ID: <CABBYNZ+ae5h-KdAKwvCRNyDPB3W4nzyuEBzPdw72-8DLb9BAsw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Bluetooth: fix bdaddr quirks
To: Johan Hovold <johan@kernel.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>, 
	Matthias Kaehlcke <mka@chromium.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Johan,

On Tue, May 30, 2023 at 7:25=E2=80=AFAM Johan Hovold <johan@kernel.org> wro=
te:
>
> On Mon, Apr 24, 2023 at 03:35:40PM +0200, Johan Hovold wrote:
> > These patches fixes a couple of issues with the two bdaddr quirks:
> >
> > The first one allows HCI_QUIRK_INVALID_BDADDR to be used with
> > HCI_QUIRK_NON_PERSISTENT_SETUP.
> >
> > The second patch restores the original semantics of the
> > HCI_QUIRK_USE_BDADDR_PROPERTY so that the controller is marked as
> > unconfigured when no device address is specified in the devicetree (as
> > the quirk is documented to work).
> >
> > This specifically makes sure that Qualcomm HCI controllers such as
> > wcn6855 found on the Lenovo X13s are marked as unconfigured until user
> > space has provided a valid address.
> >
> > Long term, the HCI_QUIRK_USE_BDADDR_PROPERTY should probably be dropped
> > in favour of HCI_QUIRK_INVALID_BDADDR and always checking the devicetre=
e
> > property.
>
> > Johan Hovold (2):
> >   Bluetooth: fix invalid-bdaddr quirk for non-persistent setup
> >   Bluetooth: fix use-bdaddr-property quirk
> >
> >  net/bluetooth/hci_sync.c | 30 +++++++++++-------------------
> >  1 file changed, 11 insertions(+), 19 deletions(-)
>
> Any further comments to this series, or can this one be merged for 6.5
> now?

Looks like this was removed from Patchwork since it has passed 30 days
without updates, could you please resend it so CI can pick it up and
test it again.

> Johan



--=20
Luiz Augusto von Dentz

