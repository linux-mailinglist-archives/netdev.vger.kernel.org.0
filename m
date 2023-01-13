Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D7466990A
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbjAMNup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238573AbjAMNuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:50:22 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C5E736FD
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 05:45:10 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-4bf16baa865so283925557b3.13
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 05:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N9gSuTuOIeRoyvXTslypN3S9Y3n9ZhQxFv0DvHbjXOo=;
        b=XUWtnSngwMqp0UV7+YoSQSR43zlVXU4xZV+OghNp2zfKJqKNZSWd+UoXUp9v9V9uvB
         ffGPgkM6bVmmhPDO8sh0LaGP514Je2D3rR9qM6QE9iWzkKJY7KKgxtXraU1tkwAy9s0Q
         SiybHuuvqpsSllMrAUzECDUxWETqLcic3sRQ09XfY/HkTdOTJFnzTV/T4IW9cG/r3Clu
         dWjoFsMVpqnqojQgsNhZfLDf38ymkZZ8mdyq+4YHqzoreBb3gQDswu46hWUfdIrqNG3H
         TathLmKvrjhS7oOIJ1AwWwFFDhO50clncGTZuQpI880Km2p4YABs/aZZY2fgvA3/EgUM
         znzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N9gSuTuOIeRoyvXTslypN3S9Y3n9ZhQxFv0DvHbjXOo=;
        b=oSLHZ8yQWMncAiAzhkVQGpNiaUIy5DntRzFQ7ZIPMdep88OFuRIIXj5ZzkAwltibH0
         CMQU0B9SDxLyq3KQ3EnQIvwHTOG0KkyyEbiwEbtHXGkhh4x8kNwSAK3kaWHiMHhIp/h7
         xorAE+fNKkCyJoYSMW7iivpsk0dFGxI4+49GkrenbSGw22XQ57sGK+AXlL83QsQyfgGk
         AAGWV6m61VBAkuBoz2Fz00KSTOKWQMOPGAq/DHNCqI17ujYZc0EGS47Snj5kFsvB74F9
         hwHwnAzAK8xQ41UtD56Eb2VSr8jVb7CKlnbdp4Fd6r2u/Hkl98/TQsg2mNV+tGie7QIX
         NCGw==
X-Gm-Message-State: AFqh2kpc4nfsGLKulrhwrsIDXADAW4KdB7cwhRIt/KzIrQcTzNIb9wzZ
        qiXdcE82bhp0D0uqjrxzjafYRqLgXfWI9iYk9xmVCg==
X-Google-Smtp-Source: AMrXdXtJH9fhqngsU/znGp5Pce6WNzdeRxElK/cgmqsxhsBn2wn0OeFj/fgiLxP0V8CiM2Wny3plPb1rZ6Kc6GkYCFs=
X-Received: by 2002:a05:690c:313:b0:37e:6806:a5f9 with SMTP id
 bg19-20020a05690c031300b0037e6806a5f9mr3612977ywb.47.1673617509336; Fri, 13
 Jan 2023 05:45:09 -0800 (PST)
MIME-Version: 1.0
References: <20230113133503.58336-1-sensor1010@163.com>
In-Reply-To: <20230113133503.58336-1-sensor1010@163.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 13 Jan 2023 14:44:58 +0100
Message-ID: <CANn89iKDXQ_nvnXBp5Q99P67AW-jFTNkpEmYdESDWitf0Nt4vw@mail.gmail.com>
Subject: Re: [PATCH v1] wireless/at76c50x-usb.c : Use devm_kzalloc replaces kmalloc
To:     Lizhe <sensor1010@163.com>
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, johannes.berg@intel.com,
        alexander@wetzel-home.de, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Jan 13, 2023 at 2:35 PM Lizhe <sensor1010@163.com> wrote:
>
> use devm_kzalloc replaces kamlloc
>
> Signed-off-by: Lizhe <sensor1010@163.com>
> ---
>  drivers/net/wireless/atmel/at76c50x-usb.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
> index 009bca34ece3..ebd8ef525557 100644
> --- a/drivers/net/wireless/atmel/at76c50x-usb.c
> +++ b/drivers/net/wireless/atmel/at76c50x-usb.c
> @@ -2444,7 +2444,7 @@ static int at76_probe(struct usb_interface *interface,
>
>         udev = usb_get_dev(interface_to_usbdev(interface));
>
> -       fwv = kmalloc(sizeof(*fwv), GFP_KERNEL);
> +       fwv = devm_kzalloc(sizeof(*fwv), GFP_KERNEL);

Have you compiled this patch ?

>         if (!fwv) {
>                 ret = -ENOMEM;
>                 goto exit;
> @@ -2535,7 +2535,6 @@ static int at76_probe(struct usb_interface *interface,
>                 at76_delete_device(priv);
>
>  exit:
> -       kfree(fwv);
>         if (ret < 0)
>                 usb_put_dev(udev);
>         return ret;
> --
> 2.17.1
>
