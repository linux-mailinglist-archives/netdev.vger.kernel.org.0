Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B528653D1B
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 09:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbiLVIoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 03:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbiLVIoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 03:44:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99D7264BE
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 00:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671698602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KNeBYmXuI57DgCzyGIVCTcmPzwc5WTW5DEjmav8+hVE=;
        b=WBGJaCfwyy1XMcuanNditZ70P0bZNPJNaTypgu5NPJn+MYQ4qMQINx4JS4fYvD8UtD47kS
        pR7NT4nBrY2dZYSgULcxjlKdC346nQ81IsV282m+t7rdtM2slCnACH1DXLsoxFxSKpR5EL
        2Tr8DR5mMel4x1uETswKnXi8QjaSaKA=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-349-3GjC4isGNuWkhRQ-bpQGFA-1; Thu, 22 Dec 2022 03:43:21 -0500
X-MC-Unique: 3GjC4isGNuWkhRQ-bpQGFA-1
Received: by mail-ot1-f72.google.com with SMTP id y14-20020a0568301d8e00b00670641b451bso684439oti.15
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 00:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KNeBYmXuI57DgCzyGIVCTcmPzwc5WTW5DEjmav8+hVE=;
        b=zsc+OvI417DQ3043NlnEtiyrl3tV7jOJAjVBMO6OC0fvqwEVily5khtuHoYP/yUI8m
         zeBO5QSUCzLMwcE3LPeqO0l9upLujlzECCNntHhMQuZh8fXkH86DZMErAlcbFw/UwqJI
         UM78D7wKf38oO2gz9l95tIAj7tbmHYTt208P90D3KZSskhEXP/uDRL8hwYsLzigFXaHP
         +7xXPmZaqMMjgVAnSm75OqHS1dXgIjDXnZ0lQ5k+d62bUDFvEk5oHci7P0MowjV3fHXv
         OaNYVlqJFB0tXswtIy/nna5h0As0NHqwGd9ZLi6vquOsdmh3hRrYtZB4eW8IH5ekpnpr
         GniQ==
X-Gm-Message-State: AFqh2kpP8Yu9YL/FJYwIfDUmzT/gFH0O6Tzs/K1OtdA9hAC8OBEn0zdi
        7fXEjbfGYMFKDzfXoM/kgRZNbGfmuU6pDWGGFw3zRX+S/0YCmpQJ322Blfw0EZsF05xMLedzpYr
        JjDRhA+MjKiseyuz/TTQZxX0qS9upJVLh
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id u19-20020a056870441300b00144a97b1ae2mr266526oah.35.1671698600457;
        Thu, 22 Dec 2022 00:43:20 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvArZS7BpYzOO0P/QwDDxpof+Qjh3fZ82zc2Zf58dXBN/RrZIhzXz+A2ykZuG4V9/h7aE61hCJ8AzusgQCz9j4=
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id
 u19-20020a056870441300b00144a97b1ae2mr266519oah.35.1671698600234; Thu, 22 Dec
 2022 00:43:20 -0800 (PST)
MIME-Version: 1.0
References: <20221222060427.21626-1-jasowang@redhat.com> <20221222060427.21626-5-jasowang@redhat.com>
 <CAJs=3_D6sug80Bb9tnAw5T0_NaL_b=u8ZMcwZtd-dy+AH_yqzQ@mail.gmail.com>
In-Reply-To: <CAJs=3_D6sug80Bb9tnAw5T0_NaL_b=u8ZMcwZtd-dy+AH_yqzQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 22 Dec 2022 16:43:09 +0800
Message-ID: <CACGkMEv4YxuqrSx_HW2uWgXXSMOFCzTJCCD_EVhMwegsL8SoCg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq command
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     mst@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        eperezma@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alvaro:

On Thu, Dec 22, 2022 at 2:44 PM Alvaro Karsz <alvaro.karsz@solid-run.com> wrote:
>
> Hi Jason,
>
> Adding timeout to the cvq is a great idea IMO.
>
> > -       /* Spin for a response, the kick causes an ioport write, trapping
> > -        * into the hypervisor, so the request should be handled immediately.
> > -        */
> > -       while (!virtqueue_get_buf(vi->cvq, &tmp) &&
> > -              !virtqueue_is_broken(vi->cvq))
> > -               cpu_relax();
> > +       virtqueue_wait_for_used(vi->cvq, &tmp);
>
> Do you think that we should continue like nothing happened in case of a timeout?

We could, but we should not depend on a device to do this since it's
not reliable. More below.

> Shouldn't we reset the device?

We can't depend on device, there's probably another loop in reset():

E.g in vp_reset() we had:

        while (vp_modern_get_status(mdev))
                msleep(1);

> What happens if a device completes the control command after timeout?

Maybe we could have a BAD_RING() here in this case (and more check in
vq->broken in this case).

Thanks

>
> Thanks
>
> Alvaro
>

