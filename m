Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC8B3C363B
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 21:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhGJTCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 15:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhGJTCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 15:02:49 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95E7C0613DD;
        Sat, 10 Jul 2021 12:00:03 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t9so13592758pgn.4;
        Sat, 10 Jul 2021 12:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BJuMdlRegU6c4IoT80+Hf4u+yimmB2m/LlvX83xivuA=;
        b=X0LZRxQKK0Mz48vT5dMKJ0JkoVmSfLojCa7etzsRLxmsLkTL9gbvu6EAaM9Blu7IAk
         m8B6WjxZioN8QmlqUO6h5SPXINJHQlSU2wyVECGeHdTJdlGg7buxWyH96uWTJun+jhqE
         GA/D9Cj/q91PNj1yuMWb83n0qDImgcDGKU+3KF6fFFf3ooA6A4/UGEWlVdGxcAdlKZTC
         AmulIPL1Ff/okiTIPCMfxBosEh+GCArwRAf3GwWTZe28zZ+AqicidaPfSMSk0WrHNG3M
         oe5hj58gIbqJMHsw/mjPjV76GrJYKEufw347koNlKm/w/1iWtKCad3URzCQRj6RuDYgk
         x1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BJuMdlRegU6c4IoT80+Hf4u+yimmB2m/LlvX83xivuA=;
        b=B7zxCJgfYx5/8DCYpHU/UWODAyPxYC9Vk6GHMJrq+kjfKbGY7tgl/Pk1Djg83paLNi
         bOjZmR9o2aOL04i8efVi0wdi5gLGKOCSp6xrkyi/jqZaXj1dLYgWCXxJje7G2jMuw0kk
         05VwWpACK5ilZazxMlbNPtRoLLZy7nZh98UQu8qgK/4FRrRHcO6OmamGkf6REx46TNOG
         PitP/tfWOZRdvREbJHy0IZLaAE2XNWPyyX5rtLmvlntyQB2a89GtZ/5C22ARHwPez0Tm
         TD3ahXYgKELYYX2rXNPALR20/l8aeU5GCvHkt3p7/Z+5U72C4mXTWBUqgxrXjl8/kkfE
         DfVQ==
X-Gm-Message-State: AOAM532hOkgu5lZp7x8/uaGGgraNrZAdWRU/zn4vArkOsCa0EUqrQiGE
        aVhUMf9DupXUoOM+TDVoyic/6wm7+zKVZt4UIEI=
X-Google-Smtp-Source: ABdhPJxjgRuZqFlr62Qu4wAJMre/xKOIFAllkx7XqUTffn+aTD9323xmoHIv3HbPlnxbz9+ptAPTtNi0MSmtrShjZv4=
X-Received: by 2002:a62:dd83:0:b029:30f:d69:895f with SMTP id
 w125-20020a62dd830000b029030f0d69895fmr44489708pff.17.1625943603288; Sat, 10
 Jul 2021 12:00:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com>
 <a7f11cc2-7bef-4727-91b7-b51da218d2ee@nbd.name> <YNtdKb+2j02fxfJl@kroah.com>
 <872e3ea6-bbdf-f67c-58f9-4c2dafc2023a@nbd.name> <CAHQn7pJY4Vv_eWpeCvuH_C6SHwAvKrSE2cQ=cTir72Ffcr9VXg@mail.gmail.com>
 <56afa72ef9addbf759ffb130be103a21138712f9.camel@sipsolutions.net>
 <CAHQn7pLxUt03sgL0B2_H0_p0iS0DT-LOEpMOkO_kd_w_WVTKBA@mail.gmail.com> <YOk/QNc0X71cF6Id@kroah.com>
In-Reply-To: <YOk/QNc0X71cF6Id@kroah.com>
From:   Davis Mosenkovs <davikovs@gmail.com>
Date:   Sat, 10 Jul 2021 21:59:51 +0300
Message-ID: <CAHQn7p+J9V=w5O+dH2bmeWSCrF3=ojL_HBMbY5XPAm4NuZ5Ysg@mail.gmail.com>
Subject: Re: Posible memory corruption from "mac80211: do not accept/forward
 invalid EAPOL frames"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-10 at 09:33 Greg Kroah-Hartman (<gregkh@linuxfoundation.org>) wrote:
>
>
> Please resend and cc: the stable@vger.kernel.org list so these can
> actually be applied.
>
> You have read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> right?
>
> thanks,
>
> greg k-h
Thank you!
I have read the article, added cc: stable@vger.kernel.org to e-mail
headers and (with proper kernel versions) in sign-off area.
The new patches are:
https://lore.kernel.org/r/20210710183710.5687-1-davis@mosenkovs.lv
https://lore.kernel.org/r/20210710183745.5740-1-davis@mosenkovs.lv
https://lore.kernel.org/r/20210710183807.5792-1-davis@mosenkovs.lv

Best regards,
Davis
