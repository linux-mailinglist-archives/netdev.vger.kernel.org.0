Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FF43D37AB
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhGWIpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGWIpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 04:45:25 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7530C061575;
        Fri, 23 Jul 2021 02:25:57 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ga41so2599558ejc.10;
        Fri, 23 Jul 2021 02:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FB3AqglCoLXT/Z22dR2tyxUlBgErLMHulIf7evT83VQ=;
        b=GRNJGlPn9WbmOWkppKf8rxFmSHhoprrr3fuaDOwQFyo0Sjuzc3GbOp31OkNf20c9yw
         nC4OfiLlZZtBMkl3h5ylX7IbFIXknwviRSCqJVPh7+AD7NcpZD05R7kH3AUU7chn+KKO
         0FmNBAMQfdzddRYrSehctXKgeR7zw382Vyoyt+PkImmXew5K3mjXDUmo4kl9re8PNar8
         M8/SerCH987rO8yJuAt+zD333EHmn6qSeAe/TEs9wJwkWJo+SMU7xgDpMIMl3C/aVxrM
         +tP/bePHbDYPPe6edbieR5RGtYeSzGScN0z0AAu6UdMd20kUVcpuofgp2z3fRYkofqJA
         iIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FB3AqglCoLXT/Z22dR2tyxUlBgErLMHulIf7evT83VQ=;
        b=oVLa1OvyguJIQO5kjfViByLOF97aQb/r3Oq4vP2RZQbMo7/8mSaEsM7PIrTyCAdZJa
         Jf/du5hKruoDMRwXHt+BSNVzAFUxRMDYLjOJdRRqd7sbFKWD9I5tqzfOLvC2zDcs5otR
         I7lq3W1k2XT18JcB0CkdJ8v9FfiDE8QZmpq2RngHlxt0HMfOXS+1uwkF0hQeUjV87TxK
         aC+cBsG1GHvKFlTbMBA12wf+n6uYd13PLywTYXHHp3To6zx1nXnqdYUQX9r5CIhaRbSd
         swQPAWss8hx1y2snYocsklofXzDDIYrJsyCv36k2LAzN6UDSL2xJ/6BC35LtMN/O/hjE
         kZ5g==
X-Gm-Message-State: AOAM5321BVQ4fmt+0xo38CRsgBTnsw/eTYbWPCSvcYDyr1EZJfnUdWDu
        FfnLWaBF63SKYcidJOCh78rDwG9loTDGCLHz1hg=
X-Google-Smtp-Source: ABdhPJyWb/3efTBph4+zgG/RGwECZ6alS/cy0yHRiSgYm1166Dbwpd7gSShUSWJQ5lwE4pb+KipgSk2cpLGuqzjpKhU=
X-Received: by 2002:a17:906:eda7:: with SMTP id sa7mr3822014ejb.135.1627032356226;
 Fri, 23 Jul 2021 02:25:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210723050919.1910964-1-mudongliangabcd@gmail.com> <6fa2aecc-ab64-894d-77c2-0a19b524cc03@gmail.com>
In-Reply-To: <6fa2aecc-ab64-894d-77c2-0a19b524cc03@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Fri, 23 Jul 2021 17:25:29 +0800
Message-ID: <CAD-N9QXO4bX6SzMNir0fin0wVAZYhsS8-triiWPjY+Rz2WCy1w@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: free the object allocated in wiphy_apply_custom_regulatory
To:     xiaoqiang zhao <zhaoxiaoqiang007@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 5:18 PM xiaoqiang zhao
<zhaoxiaoqiang007@gmail.com> wrote:
>
>
>
> =E5=9C=A8 2021/7/23 13:09, Dongliang Mu =E5=86=99=E9=81=93:
> > The commit beee24695157 ("cfg80211: Save the regulatory domain when
> > setting custom regulatory") forgets to free the newly allocated regd
> > object.
> >
> > Fix this by freeing the regd object in the error handling code and
> > deletion function - mac80211_hwsim_del_radio.
> >
> > Reported-by: syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com
> > Fixes: beee24695157 ("cfg80211: Save the regulatory domain when setting=
 custom regulatory")
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >  drivers/net/wireless/mac80211_hwsim.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wirele=
ss/mac80211_hwsim.c
> > index ffa894f7312a..20b870af6356 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.c
> > +++ b/drivers/net/wireless/mac80211_hwsim.c
> > @@ -3404,6 +3404,8 @@ static int mac80211_hwsim_new_radio(struct genl_i=
nfo *info,
> >       debugfs_remove_recursive(data->debugfs);
> >       ieee80211_unregister_hw(data->hw);
> >  failed_hw:
> > +     if (param->regd)
> > +             kfree_rcu(get_wiphy_regdom(data->hw->wiphy));
> >       device_release_driver(data->dev);
>
> hw->wiphy->regd may be NULL if previous reg_copy_regd failed, so how abou=
t:
> if (hw->wiphy->regd)
>         rcu_free_regdom(get_wiphy_regdom(hw->wiphy))

Previously I would like to use this API(rcu_free_regdom), but it is
static and located in non-global header file - reg.h.

>
> >  failed_bind:
> >       device_unregister(data->dev);
> > @@ -3454,6 +3456,8 @@ static void mac80211_hwsim_del_radio(struct mac80=
211_hwsim_data *data,
> >  {
> >       hwsim_mcast_del_radio(data->idx, hwname, info);
> >       debugfs_remove_recursive(data->debugfs);
> > +     if (data->regd)
> > +             kfree_rcu(get_wiphy_regdom(data->hw->wiphy));
> this is not correct, because ieee80211_unregister_hw below will free
> data->hw_wiphy->regd

Can you point out the concrete code releasing regd? Maybe the link to elixi=
r.

> >       ieee80211_unregister_hw(data->hw);
> >       device_release_driver(data->dev);
> >       device_unregister(data->dev);
> >
