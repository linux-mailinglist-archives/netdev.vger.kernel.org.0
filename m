Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188E43D501F
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 23:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhGYUvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 16:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhGYUvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 16:51:09 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3938EC061757;
        Sun, 25 Jul 2021 14:31:38 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id gn26so7263871ejc.3;
        Sun, 25 Jul 2021 14:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZZflIiB2DoTKcobh1NO9JbdOskY9ZuUpO9VblSztVDU=;
        b=Z6iHfurLI8vbWoI5+fWv/JIjleaRXpMhSoOhLrkFwTfGhwiF2D5jRkJOvQiJINqO/4
         bKYLK0VWrURWAe2Pjpf3T54yhOEak0GcCrFed0YYZWTWsfBiIIkj687GRFVGTBDMCVgD
         Nx+fcEO86EN9ToC3eCf8tMfmEuL8lH0u3ZcTMhuNXyUHVl0TegWdB5ETy48wJvF9QgOj
         o2aX0XqMIRTTxoYFsOSs0PU0Cc45LwOb5E+egA5HgoRog0k97AlvWuDTMaAv6SizNgQc
         eIP+TK5rWKBP/2yUzL/q86r76rpJ1FGldk1QbYOZMka477cp+VKfUy+OrNxxfN1bbTdx
         m8rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZZflIiB2DoTKcobh1NO9JbdOskY9ZuUpO9VblSztVDU=;
        b=qBMHG6H9215mb0HNwdlhv0hzgapetW0g7WD3vuYActI0BCLNRltTQY/bqhK0I5wy8P
         3MAUeP0DeU4Urm6aN1zs1c2wQMcV7ENaYef/OjZEe2nAjsl0TM57FWEGV2nB0TyoT+ll
         dfulIDMAWgJotdiaV7j61gXdDhP7oprzh4Som+djziGkydMESTGk+DHOY/U0/7FOuFFh
         Zu0AExFyRRRIop7DsSjwcF0/NUMLxdPYAfgnLJEsV7xywuaOZMUTPecvzMeWuIsYFqpz
         F/IXopFLvJ5oUUWO+Lms6mKgUts11NlKIKQVFM4CiGWsB1eOPsiYbI2wWoXtQ9NGxSav
         7MEg==
X-Gm-Message-State: AOAM532DswKCJBvozGdK9IrKMMEvt1+o8A10iimh3UlMDfu9605iWCWR
        eE/kJYZ+9OOPTC8lCxJJxsQ9dVW/Ly+lyRzIHbI=
X-Google-Smtp-Source: ABdhPJyyO0Kzq2ppjxpKL8XAJr/CRcXz68N2oXu8vqQw3B23WZzCLDtsFOtzWNaF7w3djEsvXKTLbDm8b+dyd8c4HLw=
X-Received: by 2002:a17:906:6686:: with SMTP id z6mr4153833ejo.539.1627248696694;
 Sun, 25 Jul 2021 14:31:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
 <20210717204057.67495-3-martin.blumenstingl@googlemail.com> <2170471a1c144adb882d06e08f3c9d1a@realtek.com>
In-Reply-To: <2170471a1c144adb882d06e08f3c9d1a@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 25 Jul 2021 23:31:26 +0200
Message-ID: <CAFBinCCqVpqC+CaJqTjhCj6-4rFcttQ-cFjOPwtKFbXbnop3XA@mail.gmail.com>
Subject: Re: [PATCH RFC v1 2/7] rtw88: Use rtw_iterate_vifs where the iterator
 reads or writes registers
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ping-Ke,

On Mon, Jul 19, 2021 at 7:47 AM Pkshih <pkshih@realtek.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Martin Blumenstingl [mailto:martin.blumenstingl@googlemail.com]
> > Sent: Sunday, July 18, 2021 4:41 AM
> > To: linux-wireless@vger.kernel.org
> > Cc: tony0620emma@gmail.com; kvalo@codeaurora.org; johannes@sipsolutions.net; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Neo Jou; Jernej Skrabec; Martin Blumenstingl
> > Subject: [PATCH RFC v1 2/7] rtw88: Use rtw_iterate_vifs where the iterator reads or writes registers
> >
> > Upcoming SDIO support may sleep in the read/write handlers. Switch
> > all users of rtw_iterate_vifs_atomic() which are either reading or
> > writing a register to rtw_iterate_vifs().
> >
> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > ---
> >  drivers/net/wireless/realtek/rtw88/main.c | 6 +++---
> >  drivers/net/wireless/realtek/rtw88/ps.c   | 2 +-
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> > index c6364837e83b..207161a8f5bd 100644
> > --- a/drivers/net/wireless/realtek/rtw88/main.c
> > +++ b/drivers/net/wireless/realtek/rtw88/main.c
> > @@ -229,8 +229,8 @@ static void rtw_watch_dog_work(struct work_struct *work)
> >       rtw_phy_dynamic_mechanism(rtwdev);
> >
> >       data.rtwdev = rtwdev;
> > -     /* use atomic version to avoid taking local->iflist_mtx mutex */
> > -     rtw_iterate_vifs_atomic(rtwdev, rtw_vif_watch_dog_iter, &data);
> > +
> > +     rtw_iterate_vifs(rtwdev, rtw_vif_watch_dog_iter, &data);
>
> You revert the fix of [1].
Thanks for bringing this to my attention!

> I think we can move out rtw_chip_cfg_csi_rate() from rtw_dynamic_csi_rate(), and
> add/set a field cfg_csi_rate to itera data. Then, we do rtw_chip_cfg_csi_rate()
> outside iterate function. Therefore, we can keep the atomic version of iterate_vifs.
just to make sure that I understand this correctly:
rtw_iterate_vifs_atomic can be the iterator as it was before
inside the iterator func I use something like:
    iter_data->cfg_csi_rate = rtwvif->bfee.role == RTW_BFEE_SU ||
rtwvif->bfee.role == RTW_BFEE_MU || iter_data->cfg_csi_rate;
(the last iter_data->cfg_csi_rate may read a bit strange, but I think
it's needed because there can be multiple interfaces and if any of
them has cfg_csi_rate true then we need to remember that)
then move the rtw_chip_cfg_csi_rate outside the iterator function,
taking iter_data->cfg_csi_rate to decide whether it needs to be called


Best regards,
Martin
