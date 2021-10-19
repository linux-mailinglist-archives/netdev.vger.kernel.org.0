Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96A7433CFC
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 19:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhJSRJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 13:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbhJSRJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 13:09:16 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDC6C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:07:03 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id o83so5980195oif.4
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tRUzeHjn1JScYsy8o3opbyIOuIsB/FtwNfAyTowowWw=;
        b=F832Pj/VWsWXq14tuowyPd+60g+tsKelOOjTQIFcBFAP/emkcy+rJkb3RhvyHAMBQx
         oTaTU7qmIcc+o6biGXLnm8ai3mBaEULu/q1CiaNG+LvPn11thXJ0j2jxR87BY6MN2kcF
         aXv8rFCEi9eHsCol+2ZxiCrh7kVm4do4XZHz0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tRUzeHjn1JScYsy8o3opbyIOuIsB/FtwNfAyTowowWw=;
        b=2Z2C5H4TUvxGzUv9hMoTmQ86Y8JAMOaAfT13hVjyUAWzu0/IyXU8FPAICEhyjg/vWD
         bth6W0oi70eZ674yOURs59W7P9uEsEk+xelIdxVKn56o93PP191L9tICKNzQqehqOLmD
         mtoZSHthxnlXYoIACKIwDpNuoknUMm4t1dX+lZ218hl6V3fCKd8/H5fAl0b82jw6i7Jz
         WGclCSP6Lyp19sufakCa1iUEFYDLoYkMlSOrSrvY5C2lR1y/dfIK4Ni6rHVdvSd9USRf
         IRVK5sX0JD3uKLhIQuzbztKIsAHDzeqVgnBDXB86OM/D/HI8cdckNkmdxof+z22v7G18
         ClXw==
X-Gm-Message-State: AOAM531B9a2Ge2HxooN3U3rGWnASq19gjRKJS1s4xqxGf47a1EKvyRJQ
        G3KSdX0ydy/ZuhNvy6ozPNPUAnZeoCPnIw==
X-Google-Smtp-Source: ABdhPJybP5TGYcGzp7geyxlsPcq+kX1h1HadQ6kSrbMaTpONME8mv+Z7Ref8LPcXzmkXuhHfa5+iig==
X-Received: by 2002:aca:3c87:: with SMTP id j129mr5271598oia.157.1634663222663;
        Tue, 19 Oct 2021 10:07:02 -0700 (PDT)
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com. [209.85.167.174])
        by smtp.gmail.com with ESMTPSA id l19sm497368otu.11.2021.10.19.10.07.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 10:07:01 -0700 (PDT)
Received: by mail-oi1-f174.google.com with SMTP id r6so5982193oiw.2
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:07:00 -0700 (PDT)
X-Received: by 2002:aca:603:: with SMTP id 3mr5184997oig.117.1634663219994;
 Tue, 19 Oct 2021 10:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211019033101.27658-1-wanjiabing@vivo.com> <1ae64510-0519-4852-a2a0-5c32490a195c@gmail.com>
In-Reply-To: <1ae64510-0519-4852-a2a0-5c32490a195c@gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 19 Oct 2021 10:06:45 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNbLHDJ4Z8DNzNuxVJuqgKoKJynedXdnUP_1_Vvxgvc+A@mail.gmail.com>
Message-ID: <CA+ASDXNbLHDJ4Z8DNzNuxVJuqgKoKJynedXdnUP_1_Vvxgvc+A@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: Fix divide error in mwifiex_usb_dnld_fw
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kael_w@yeah.net,
        syzbot+4e7b6c94d22f4bfca9a0@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 9:04 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On 10/18/21 8:31 PM, Wan Jiabing wrote:
> > --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> > @@ -693,7 +693,7 @@ static int mwifiex_write_data_sync(struct mwifiex_adapter *adapter, u8 *pbuf,
> >       struct usb_card_rec *card = adapter->card;
> >       int actual_length, ret;
> >
> > -     if (!(*len % card->bulk_out_maxpktsize))
> > +     if (card->bulk_out_maxpktsize && !(*len % card->bulk_out_maxpktsize))
>
>
> Are you sure this fix is not working around the real bug ?
>
> In which cases bulk_out_maxpktsize would be zero ?
>
> If this is a valid case, this needs to be explained in the changelog.

I'm with Eric here. This was a bug reported by a fuzzer, which throws
invalid input at the driver. The right answer is likely that we should
reject such invalid input when we receive it -- i.e., we should fail
to probe() the device if it has invalid capabilities. In particular,
we should fail to probe if wMaxPacketSize==0.

I was thinking of sending such a patch myself, but I don't have any
USB mwifiex hardware to test, so I deferred. It's probably pretty low
risk anyway, though.

Brian
