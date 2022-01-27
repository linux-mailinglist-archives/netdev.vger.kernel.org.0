Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203E949EDD3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 22:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240951AbiA0VxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 16:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbiA0VxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 16:53:02 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EC9C061714;
        Thu, 27 Jan 2022 13:53:02 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id c24so5668582edy.4;
        Thu, 27 Jan 2022 13:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d5LRRB0uqm/WR5U/+eN4GjzzHTNXrtcy+Y+FfjmNOg8=;
        b=MCqfRrjSHkuK7W6k74FWNoXR16maAPl8kP2eOeRYCZ6qOuOm0Gg64dYj471IEp8QPN
         J5zMO0GKccZY6MfQ+mxBTG9rK1+8HBnz2daAqonONnN4R+uzHYY//fwzjxB+cWjNzLyN
         OP9zpuSvLXq6nnzxMqVow4bhR9Tv544ZkQKBqyEs9Zke7PQYPnuxdu8D0rqmFaJX+JvQ
         0UaOsh2Bp/CT5Vwzcpnz2ecpwFaPmD1TPqfDAFuTo2zlTA2l8IaRZ05Oh3LydUiozvAz
         obrM43ZGdBza30K8kVNpiLt8Fj9GSQIwCldizBURlN4UYHBYp+HDun1sLm3UYDHcENo2
         FM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d5LRRB0uqm/WR5U/+eN4GjzzHTNXrtcy+Y+FfjmNOg8=;
        b=7XRQMsOC/gXPUdCC54dikbmBci0+jZeH2uN3kGdyFNxN4spOPqv28Dg13ZxR5U5cR5
         TPqrKFIyBouQzMUlK8nozhGJQzfc+uxe8kFhe0jWUVb4/joaQWHJdPa31OeJzqaVUxKn
         cYpvZdMg5/WfXg8GHe/89TlwiRI4+pbx8B/AUF7tDvox6/5bUrJda1EzyMO0ubJOcu6d
         rh23SgTO7EtBCsa92KpbvtPyEaLG79QMZn//nsVkm9AYwyLqruSScDMvby/y1K4c7gjg
         UMCz7CEYUXxrBZE9akZ0/7/BnbGTf5NFnPhN4Gjxzjr7u/OcnzeM5E5m0X+FnY7VqYUW
         Th2A==
X-Gm-Message-State: AOAM533lgPTVVTn8BnefNnwwLM73d0CxWdKjo3uuMx4QyOfpU9GU00w+
        9TfzBMMZeGXUpCvEf81j5GLUH8i3tvvTROgekHS2cdBgIWk=
X-Google-Smtp-Source: ABdhPJzc2dhIVgVmPkviLDO7e/v7aguAYMhH6I/AnZjWb6ofb0HEACO5XoaOdWIFSiDLVLEy7t3jP4Hk+rLeNCv4ahU=
X-Received: by 2002:a05:6402:510b:: with SMTP id m11mr5413186edd.290.1643320380653;
 Thu, 27 Jan 2022 13:53:00 -0800 (PST)
MIME-Version: 1.0
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
 <423f474e15c948eda4db5bc9a50fd391@realtek.com> <CAFBinCBVEndU0t-6d5atE31OFYHzPyk7pOe78v0XrrFWcBec9w@mail.gmail.com>
 <5ef8ab4f78e448df9f823385d0daed88@realtek.com>
In-Reply-To: <5ef8ab4f78e448df9f823385d0daed88@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 27 Jan 2022 22:52:49 +0100
Message-ID: <CAFBinCDjfKK3+WOXP2xbcAK-KToWof+kSzoxYztqRcc=7T1eyg@mail.gmail.com>
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

On Mon, Jan 24, 2022 at 3:59 AM Pkshih <pkshih@realtek.com> wrote:
[...]
> > It seems to me that we should avoid using the mutex version of
> > ieee80211_iterate_*() because it can lead to more of these issues. So
> > from my point of view the general idea of the code from your attached
> > patch looks good. That said, I'm still very new to mac80211/cfg80211
> > so I'm also interested in other's opinions.
> >
>
> The attached patch can work "mostly", because both callers of iterate() and
> ::remove_interface hold rtwdev->mutex. Theoretically, the exception is a caller
> forks another work to iterate() between leaving ::remove_interface and mac80211
> doesn't yet free the vif, but the work executes after mac80211 free the vif.
> This will lead use-after-free, but I'm not sure if this scenario will happen.
> I need time to dig this, or you can help to do this.
>
> To avoid this, we can add a flag to struct rtw_vif, and set this flag
> when ::remove_interface. Then, only collect vif without this flag into list
> when we use iterate_actiom().
>
> As well as ieee80211_sta can do similar fix.
>
> > > So, I add wrappers to iterate rtw_iterate_stas() and rtw_iterate_vifs() that
> > > use _atomic version to collect sta and vif, and use list_for_each() to iterate.
> > > Reference code is attached, and I'm still thinking if we can have better method.
> > With "better method" do you mean something like in patch #2 from this
> > series (using unsigned int num_si and struct rtw_sta_info
> > *si[RTW_MAX_MAC_ID_NUM] inside the iter_data) are you thinking of a
> > better way in general?
> >
>
> I would like a straight method, for example, we can have another version of
> ieee80211_iterate_xxx() and do things in iterator, like original, so we just
> need to change the code slightly.
>
> Initially, I have an idea we can hold driver lock, like rtwdev->mutex, in both
> places where we use ieee80211_iterate_() and remove sta or vif. Hopefully,
> this can ensure it's safe to run iterator without other locks. Then, we can
> define another ieee80211_iterate_() version with a drv_lock argument, like
>
> #define ieee80211_iterate_active_interfaces_drv_lock(hw, iter_flags, iterator, data, drv_lock) \
> while (0) {     \
>         lockdep_assert_wiphy(drv_lock); \
>         ieee80211_iterate_active_interfaces_no_lock(hw, iter_flags, iterator, data); \
> }
>
> The driv_lock argument can avoid user forgetting to hold a lock, and we need
> a helper of no_lock version:
>
> void ieee80211_iterate_active_interfaces_no_lock(
>         struct ieee80211_hw *hw, u32 iter_flags,
>         void (*iterator)(void *data, u8 *mac,
>                          struct ieee80211_vif *vif),
>         void *data)
> {
>         struct ieee80211_local *local = hw_to_local(hw);
>
>         __iterate_interfaces(local, iter_flags | IEEE80211_IFACE_ITER_ACTIVE,
>                              iterator, data);
> }
>
> However, as I mentioned theoretically it is not safe entirely.
>
> So, I think the easiest way is to maintains the vif/sta lists in driver when
> ::{add,remove }_interface/::sta_{add,remove}, and hold rtwdev->mutex lock to
> access these lists. But, Johannes pointed out this is not a good idea [1].
Thank you for this detailed explanation! I appreciate that you took
the time to clearly explain this.

For the sta use-case I thought about adding a dedicated rwlock
(include/linux/rwlock.h) for rtw_dev->mac_id_map.
rtw_sta_{add,remove} would take a write-lock.
rtw_iterate_stas() takes the read-lock (the lock would be acquired
before calling into ieee80211_iterate_...). Additionally
rtw_iterate_stas() needs to check if the station is still valid
according to mac_id_map - if not: skip/ignore it for that iteration.
This could be combined with your
0001-rtw88-use-atomic-to-collect-stas-and-does-iterators.patch.

For the interface use-case it's not clear to me how this works at all.
rtw_ops_add_interface() has (in a simplified view):
    u8 port = 0;
    // the port variable is never changed
    rtwvif->port = port;
    rtwvif->conf = &rtw_vif_port[port];
    rtw_info(rtwdev, "start vif %pM on port %d\n", vif->addr, rtwvif->port);
How do multiple interfaces (vifs) work in rtw88 if the port is always
zero? Is some kind of tracking of the used ports missing (similar to
how we track the used station IDs - also called mac_id - in
rtw_dev->mac_id_map)?


Thank you again and best regards,
Martin
