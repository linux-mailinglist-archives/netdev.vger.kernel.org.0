Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8835B6C582A
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjCVUxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbjCVUxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:53:02 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8B435B4;
        Wed, 22 Mar 2023 13:52:39 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c18so20401027ple.11;
        Wed, 22 Mar 2023 13:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679518358;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CWlpBm7vrzYxnF70yu+Dqd4NQ9SDIdN+19JogqnAdig=;
        b=DO60S/FF7O+sG/Ce44mbbn0TqBH1Y/ojc2R0nKjGG0QyTLfUsQ9tuij8rLNUWYngs/
         LWmcsTrgRIstcg9LEpEnevlD6PMPttTao2qNYZZS8lutOwMGbhCpqXm9iyksyPERWoqE
         6cW+vsW4ObbBUkvwwxpy6Wr5qxznTs5zs6uA8WWi6NG5NZa0Bm4eHqXo0J6NtWM2LjpP
         7//xubxam2Wox9wjZRUXNeZl5hLXPC3SbmB/kXVvYWV1ctUCCOkp1ZVkFW9390jIyTDc
         PgobKK4aQbmcsCscRuON8Ls6Zumng6GP/q1dDmRLnoQfFqLxtZeclv963qacw3hCAVUb
         adnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679518358;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CWlpBm7vrzYxnF70yu+Dqd4NQ9SDIdN+19JogqnAdig=;
        b=ZCWJkGbR2nS67j2RgUDzmyDGXjB7Che/A9+q5nokM72NEfdUTJ1b4a7sQW9vumyOWf
         Uf+lYE1BguFbLVwS7s5mjNMbevJ076/MSbL0mz3HIWqsJubrn77P3/VWxhi2qVHVYhGN
         9ycyfGI8+uyHr27QfOMwAot40K6bPJxJ/9MJUQPtVB2xiJy0krRdkU7dmr/JhBvgHM75
         0AcrJ+MI08EwAJq7WvYiGrFWGmP4H/mQeKPYlbt6P+4yHzr76+O79jvHQj06EvzRpX2n
         fjs/nZXMuajl/f+Tt/ZrJKPjcNcqe16YEi/cQaIVVgWpntYqdrxzpS18J0pyH/7ZGz+t
         NKSA==
X-Gm-Message-State: AO0yUKV6gfycpNxrh/0i0kn3//bmSm59MjIrgIARQShl7abmvWBJunhA
        NvQQiAkSObx/FfG5YGkaTJChiqkjmFFGEYyr0+M=
X-Google-Smtp-Source: AK7set9HXCo9Zi3blVgad1JSkWd/MuPeOF8vMBc5PjJt4UmJi2GLT3Iy+EpN5dB3VIuMF9CIHvf8QGOAfygOf9zT6BI=
X-Received: by 2002:a17:903:2347:b0:1a0:5402:b17b with SMTP id
 c7-20020a170903234700b001a05402b17bmr1655554plh.0.1679518358570; Wed, 22 Mar
 2023 13:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <ZBskz06HJdLzhFl5@hyeyoo> <55057734-9913-8288-ad88-85c189cbe045@lwfinger.net>
In-Reply-To: <55057734-9913-8288-ad88-85c189cbe045@lwfinger.net>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Wed, 22 Mar 2023 21:52:27 +0100
Message-ID: <CAOiHx=n7EwK2B9CnBR07FVA=sEzFagb8TkS4XC_qBNq8OwcYUg@mail.gmail.com>
Subject: Re: [BUG v6.2.7] Hitting BUG_ON() on rtw89 wireless driver startup
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 at 18:03, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> On 3/22/23 10:54, Hyeonggon Yoo wrote:
> >
> > Hello folks,
> > I've just encountered weird bug when booting Linux v6.2.7
> >
> > config: attached
> > dmesg: attached
> >
> > I'm not sure exactly how to trigger this issue yet because it's not
> > stably reproducible. (just have encountered randomly when logging in)
> >
> > At quick look it seems to be related to rtw89 wireless driver or network subsystem.
>
> Your bug is weird indeed, and it does come from rtw89_8852be. My distro has not
> yet released kernel 6.2.7, but I have not seen this problem with mainline
> kernels throughout the 6.2 or 6.3 development series.

Looking at the rtw89 driver's probe function, the bug is probably a
simple race condition:

int rtw89_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
{
    ...
    ret = rtw89_core_register(rtwdev); <- calls ieee80211_register_hw();
    ...
    rtw89_core_napi_init(rtwdev);
    ...
}

so it registers the wifi device first, making it visible to userspace,
and then initializes napi.

So there is a window where a fast userspace may already try to
interact with the device before the driver got around to initializing
the napi parts, and then it explodes. At least that is my theory for
the issue.

Switching the order of these two functions should avoid it in theory,
as long as rtw89_core_napi_init() doesn't depend on anything
rtw89_core_register() does.

FWIW, registering the irq handler only after registering the device
also seems suspect, and should probably also happen before that.

Regards
Jonas
