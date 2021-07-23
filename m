Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8113D33F9
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 07:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhGWEgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 00:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhGWEgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 00:36:32 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92164C061575;
        Thu, 22 Jul 2021 22:17:05 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id hq13so1870043ejc.7;
        Thu, 22 Jul 2021 22:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4fI8ac75Jl7XkViy3WmvkEADCAEIISOht2OQ8lV/JwY=;
        b=QOMUzuWEbDWtxSPRyKcMbBPR4hijoobas5DF7t8nAUQIH2jYK6jE1Xui5vPVm9RHqL
         S5jXKRo26bk3aQPVjuyVcMO3PLWwa8vsFs76PyXEV0ovS75DyHI0rq3p9joduEGCUlG5
         SfETEmGG293f3H5ompvDlXIYHSuZOxxPBZLlkdL+m7//kFGtZ64tPqK2mwJDEKDCe6JW
         Mi6GAvcGmfIOTbj28LbuX9yghzqAcQ2GyhZp6Rt6pjiuBfxzKLZEXgil2YcILNtq4So9
         ubNIXkYNxbhjje6GpSGtifYjemhzvTsZtWbitbOyxgsGlLDtw3w+VaUGfB7lvgsBdgdA
         YRtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4fI8ac75Jl7XkViy3WmvkEADCAEIISOht2OQ8lV/JwY=;
        b=iz4+qVQY+6RcGidEjM5RwAyy/owG6P1OF0zQiR2Vx8lraKJELQxs9p1FDVKaM09Xy4
         1oqGV5bQSQ85LC7vSSav6dniBJYt8vmoARaKyMNQLJAgVifvqe54K0E6eHJ2s4ozLqfc
         8d0vgFGrvauEpFdhtJJy0YhBAwu9LOOMb/bEvu6dLfWgJa/7+clDlEZSx+6S+4+YgqF3
         CFudHA3qt2jrZTSwANbTV/VsyJHLcX/PsEGfFcl1+OwZZMf+wRSn8wRf0mRo8E/GtbJe
         lnpxuSCiQ7UZ/fkTeSmPDZMbSXo24ds7yJgdf0B6OLmZDlocedYWVKZlx75C1ZM2B93Y
         GWwQ==
X-Gm-Message-State: AOAM532SL5KVbCI7SXPDopaMckPVp/USWFjlkxMFNm0DCfthModmmGEy
        BSnhuXsoAwFkBTvNmXde0NrC+v0zzxb3kdbyMKE=
X-Google-Smtp-Source: ABdhPJwGBmgX0TfAcA05Q95agluIQrElbzEpwJKnItPJoS50x3rQc1cay9rXaObVWzQ+yRkHEKfdxd0SXUPJfAw1oiU=
X-Received: by 2002:a17:906:eda7:: with SMTP id sa7mr3123620ejb.135.1627017423990;
 Thu, 22 Jul 2021 22:17:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Fri, 23 Jul 2021 13:16:37 +0800
Message-ID: <CAD-N9QXYLr5CfpQFggTLu5u9+3JHdXnz76sFNsZ2OAc838zWAg@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: free the object allocated in wiphy_apply_custom_regulatory
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>
Cc:     syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 1:09 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> The commit beee24695157 ("cfg80211: Save the regulatory domain when
> setting custom regulatory") forgets to free the newly allocated regd
> object.
>
> Fix this by freeing the regd object in the error handling code and
> deletion function - mac80211_hwsim_del_radio.
>
> Reported-by: syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com
> Fixes: beee24695157 ("cfg80211: Save the regulatory domain when setting custom regulatory")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index ffa894f7312a..20b870af6356 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -3404,6 +3404,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
>         debugfs_remove_recursive(data->debugfs);
>         ieee80211_unregister_hw(data->hw);
>  failed_hw:
> +       if (param->regd)
> +               kfree_rcu(get_wiphy_regdom(data->hw->wiphy));

Here kfree_rcu supports only 1 parameter. But some example code uses
the 2nd parameter: rcu_head or rcu. For example,

static void rcu_free_regdom(const struct ieee80211_regdomain *r)
{
        ......
        kfree_rcu((struct ieee80211_regdomain *)r, rcu_head);
}

If this patch has any issues, please let me know.

>         device_release_driver(data->dev);
>  failed_bind:
>         device_unregister(data->dev);
> @@ -3454,6 +3456,8 @@ static void mac80211_hwsim_del_radio(struct mac80211_hwsim_data *data,
>  {
>         hwsim_mcast_del_radio(data->idx, hwname, info);
>         debugfs_remove_recursive(data->debugfs);
> +       if (data->regd)
> +               kfree_rcu(get_wiphy_regdom(data->hw->wiphy));
>         ieee80211_unregister_hw(data->hw);
>         device_release_driver(data->dev);
>         device_unregister(data->dev);
> --
> 2.25.1
>
