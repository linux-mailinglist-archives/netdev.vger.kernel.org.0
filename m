Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B898B37B6ED
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 09:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhELHcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 03:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhELHcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 03:32:03 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F643C06175F
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 00:30:55 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso19789953otm.4
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 00:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=goGAZQWt/xZjeiNLdX4jFKkpms+KtyL0rrUqjuEt09o=;
        b=VxISxnaDKdq4LsuBRIZ/SWlRUDZZqPoUwtEs9Ju+d13T0pjWr5UlXRIvemVdkFek66
         cbg91Jzwqjsfwm0AvhdAgX2BnyqVkQM8Mm0zCKl+iXTYHdiuKEklwNId29MnS1oO9ocd
         ANbVIMgk/frhhlIew4iRH3W0oE+R3EwnNk1v4eFISu11nIbPtx0pU6tWAP0sZ4HFQqZI
         EeNOUIxpqjJCh+ILJm5VI29xVSTV1+17NJsAgMBoh8XvqkQjvxLCz0vVyX4uBVnQqopD
         11wmyVv3Xn84JXrjhGsDsypyTYqSYcvWVrUh5d5OzrYUBK4ndnrc1CXeqo2AkxCCisd8
         21zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=goGAZQWt/xZjeiNLdX4jFKkpms+KtyL0rrUqjuEt09o=;
        b=OaYejSOC+bamSsuExXUjEbp+lySwfd4I7IyOnl7qf/2AxmSvvngOXHrHTya40kmrB7
         fS2iRE4dYTOyNA4EKKQfJOXnxJa4kG6ggbxaLv7+xqot13ORv1f1FA5UbHShLMN4U/v+
         95+HyCLX012jrQTszzMVJvNUFJa+adEcSb7KtgOW3f9ZnXq0x97hLJ5mFdoMxzyM+ODR
         uaDDu4eRqY3Ors6apssh4LyFyoefyV148A9sUD3raltBYMuPaP03R+/DlJJwOdG/0Jdh
         Ja5tnQuIEgN3nUSScZZR3GYBfbrVp2AaE5flRJnT23njZlSyO0As09OPD6irUo4hTAJ6
         S1oA==
X-Gm-Message-State: AOAM5306FKpVFPaP/zqLGq/pIQ0lVDxLb90OkW868Sv0aKwt0SiaXor9
        vdknfD9uM1hGjpsnhK64TBLz6raJwnwO6ke1etDZNQ==
X-Google-Smtp-Source: ABdhPJxmla4zRKh1TdSR9fueD0dJAXWxfYMV7+VFPlmiVkMEXhEgSVVnIwhqh4rI4nXK/t8pc8h5RYTBxtJ3EOiJXIc=
X-Received: by 2002:a05:6830:10:: with SMTP id c16mr6461089otp.252.1620804654858;
 Wed, 12 May 2021 00:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <1620744143-26075-1-git-send-email-loic.poulain@linaro.org> <1620744143-26075-2-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1620744143-26075-2-git-send-email-loic.poulain@linaro.org>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Wed, 12 May 2021 09:30:43 +0200
Message-ID: <CAAP7ucJah5qJXpjyP9gYmnYDyBWS7Qe3ck2SCBonJhJB2NgS5A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] usb: class: cdc-wdm: WWAN framework integration
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Oliver Neukum <oliver@neukum.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Loic,

On Tue, May 11, 2021 at 4:33 PM Loic Poulain <loic.poulain@linaro.org> wrote:
>
> The WWAN framework provides a unified way to handle WWAN/modems and its
> control port(s). It has initially been introduced to support MHI/PCI
> modems, offering the same control protocols as the USB variants such as
> MBIM, QMI, AT... The WWAN framework exposes these control protocols as
> character devices, similarly to cdc-wdm, but in a bus agnostic fashion.
>
> This change adds registration of the USB modem cdc-wdm control endpoints
> to the WWAN framework as standard control ports (wwanXpY...).
>
> Exposing cdc-wdm through WWAN framework normally maintains backward
> compatibility, e.g:
>     $ qmicli --device-open-qmi -d /dev/wwan0p1QMI --dms-get-ids
> instead of
>     $ qmicli --device-open-qmi -d /dev/cdc-wdm0 --dms-get-ids
>

I have some questions regarding how all this would be seen from userspace.

Does the MBIM control port retain the ability to query the maximum
message size with an ioctl like IOCTL_WDM_MAX_COMMAND? Or is that
lost? For the libmbim case this may not be a big deal, as we have a
fallback mechanism to read this value from the USB descriptor itself,
so just wondering.

Is the sysfs hierarchy maintained for this new port type? i.e. if
doing "udevadm info -p /sys/class/wwan/wwan0p1QMI -a", would we still
see the immediate parent device with DRIVERS=="qmi_wwan" and the
correct interface number/class/subclass/protocol attributes?

> However, some tools may rely on cdc-wdm driver/device name for device
> detection. It is then safer to keep the 'legacy' cdc-wdm character
> device to prevent any breakage. This is handled in this change by
> API mutual exclusion, only one access method can be used at a time,
> either cdc-wdm chardev or WWAN API.

How does this mutual exclusion API work? Is the kernel going to expose
2 different chardevs always for the single control port? If so, do we
really want to do that? How would we know from userspace that the 2
chardevs apply to the same port? And, which of the chardevs would be
exposed first (and notified first by udev), the wwan one or the
cdc-wdm one?

-- 
Aleksander
https://aleksander.es
