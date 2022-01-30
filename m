Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363024A3A98
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 22:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344117AbiA3VkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 16:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242760AbiA3VkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 16:40:19 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF251C061714;
        Sun, 30 Jan 2022 13:40:18 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ka4so36536742ejc.11;
        Sun, 30 Jan 2022 13:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rIsQmiCYLNWlEDt7j0E7mZU87pG2DkpHuzF5PvCdiJg=;
        b=NeOjQDxixyaZwWdkgZDXDFvksKjZYcEyncdgFZm7N4ZYMk7lzV86mQhC0VSFy//eZT
         1yixt5xvqP+eHVrrwQtVcHsHEVViBYo1nNvR/v1zqWJ7o2eCkiBGXKMS+TCTf+w2f+tq
         XzdFnOxHDLY8YNfNCElr5gxwVRVQej+vFz4hF9EqLhyUq5JzSEAPOpS8waYiwFqSsE4z
         uuRjn/QO++bJ19fZYk9Z/M9h+PXLzO6kixr+Zsm1AE/7ZwIy2tHHxUXWqL2WToSGrJqO
         pRB3admZ4LtSRu5gjuw4WHuM3Fg/+iYWB8cV91aONhzh19EKqeonzGMrVYlU0Sw2p43j
         bxcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rIsQmiCYLNWlEDt7j0E7mZU87pG2DkpHuzF5PvCdiJg=;
        b=aoq7rpnczeR6it3CM/wWPdVcvxjt1yqwTJjNMlWmNgGW8rlI3OGxqhT1tHEjBI6Y8I
         2o4pgFfH9PxkYl+ItBOr5a7E0APKbE05cazdiV3mF/7kGfeKKKDlXBP9Qh1OrRu7/0Xt
         wUWkJC7RVeNyK2u+klYq47xvRtsQjtNminuT/wH9jGjYKA9zJSO7UkdieoyXN+NrXCTM
         lNSpfgowh3n+DAOKChIwN5a/88IwcSaSA5+cHLh/vXISKQaV1fbkN+2zRQlrPnWDlpii
         NvdZiovAwqSRhRHjzXrZBzdsPwiTY8iQh8lI7C16N0Qm0biJeFFM6OthS+wTFUl1J5W6
         3lag==
X-Gm-Message-State: AOAM530Czf3s5t74QMK++k2XamL8GORxYIUhdQQbnRvlUeEQxCgczHMK
        PnI3/COXpVgz2XOvJC6+mwHNZl8ruKa+Qj6E5d4=
X-Google-Smtp-Source: ABdhPJxXlS15ErRcsLX0t7qINUkTOvPGy9q2BXQi9sgDktA7CNItfeZWd2hK29DVWwnklpQb3sufYabIFP6jxYigf90=
X-Received: by 2002:a17:907:1c9d:: with SMTP id nb29mr15277424ejc.281.1643578817092;
 Sun, 30 Jan 2022 13:40:17 -0800 (PST)
MIME-Version: 1.0
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
 <423f474e15c948eda4db5bc9a50fd391@realtek.com> <CAFBinCBVEndU0t-6d5atE31OFYHzPyk7pOe78v0XrrFWcBec9w@mail.gmail.com>
 <5ef8ab4f78e448df9f823385d0daed88@realtek.com> <CAFBinCDjfKK3+WOXP2xbcAK-KToWof+kSzoxYztqRcc=7T1eyg@mail.gmail.com>
 <53bea965043548539b995514d36f48e5@realtek.com>
In-Reply-To: <53bea965043548539b995514d36f48e5@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 30 Jan 2022 22:40:06 +0100
Message-ID: <CAFBinCBcgEKB3Zak9oGrZ-azqgot691gFSRGGeOP-hr4e+9C4Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ed Swierk <eswierk@gh.st>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ping-Ke,

On Fri, Jan 28, 2022 at 1:51 AM Pkshih <pkshih@realtek.com> wrote:
[...]
>
> > >
> > > To avoid this, we can add a flag to struct rtw_vif, and set this flag
> > > when ::remove_interface. Then, only collect vif without this flag into list
> > > when we use iterate_actiom().
> > >
> > > As well as ieee80211_sta can do similar fix.
> > >
>
> I would prefer my method that adds a 'bool disabled' flag to struct rtw_vif/rtw_sta
> and set it when ::remove_interface/::sta_remove. Then rtw_iterate_stas() can
> check this flag to decide whether does thing or not.
That would indeed be a very straight forward approach and easy to read.
In net/mac80211/iface.c there's some cases where after
drv_remove_interface() (which internally calls our .remove_interface
op) will kfree the vif (sdata). Doesn't that then result in a
use-after-free if we rely on a boolean within rtw_vif?

[...]
> > For the interface use-case it's not clear to me how this works at all.
> > rtw_ops_add_interface() has (in a simplified view):
> >     u8 port = 0;
> >     // the port variable is never changed
> >     rtwvif->port = port;
> >     rtwvif->conf = &rtw_vif_port[port];
> >     rtw_info(rtwdev, "start vif %pM on port %d\n", vif->addr, rtwvif->port);
> > How do multiple interfaces (vifs) work in rtw88 if the port is always
> > zero? Is some kind of tracking of the used ports missing (similar to
> > how we track the used station IDs - also called mac_id - in
> > rtw_dev->mac_id_map)?
>
> The port should be allocated dynamically if we support two or more vifs.
> We have internal tree that is going to support p2p by second vif.
I see, thanks for clarifying this!


Best regards,
Martin
