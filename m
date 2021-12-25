Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F5C47F43A
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 19:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhLYSX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 13:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhLYSX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Dec 2021 13:23:57 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F1EC061401;
        Sat, 25 Dec 2021 10:23:57 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id e128so14360244iof.1;
        Sat, 25 Dec 2021 10:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=76GQIt0sZ1We5Jshemf66kFRSNu6kCz1Xq1pIPR9qK0=;
        b=AGpOyQ7LoDyVAAKtGuejoG/4bZAVsFUFaq6dt3Gm71r9Oacr9Cz9it/BV6II7ygRiC
         FUKBMAVj8A5WIaCItvTALfMZXSKB07PBZHvo6oxSgNNKz0gf37MgxBEh0Wdni+CaR+QI
         LeBtPqARd4uMucPtmSVIlY6FHDt+jGu2EyBojq/bmVTZTKQ/KLQDqVfBfs4WKTKKSow3
         tyGxnuBCrANzBVCSrfP2wihDcF+/EGOKjI1jEhNyndqLs2UTLCVCEEYFqHUgSet8D+QD
         peGCwR/I4wlEoBaazeRKw/7OgMSzKJW79GlESuD/yjfBVgXQ49uEJnoDI2iq8s3sbcMn
         cahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=76GQIt0sZ1We5Jshemf66kFRSNu6kCz1Xq1pIPR9qK0=;
        b=V1+h0A5bEjP3gnUWVKOtNbYqvtb09oq6hMq+yJtg4rVGpDvjBgA/XkbIjWzw4FaXZB
         qelRNm3S4Px0TYHIzzcBrjmMmz7TdxeMidRZ/AZ0BQkZPietrj02tHVPmgdnzG2qnfR5
         QkS/WWjWzwBvme88Y6KYWAdV4+68fR3+Bi9Mq22rzbmJFPBLKlmkalK78aMT0a+1k1zF
         ozAW7qcDHGo2zxJi2VqAZLWkhnoSkRwLtl23UlLC3WXxy/IEmoQSPuiz53ovh3mtVWHI
         h2w12+ZMEhR7TIJnO8c2HV4yBiFGsY4xAVKj+Vde4RrrWAq6OVJyIdIBHAap4pqY9lAz
         beoQ==
X-Gm-Message-State: AOAM533shO9RdXdW0+nnXpgkdbF7GFnd9oYlMWOEAYycwVDr27GL5GFQ
        Kp18XPZzT6FlnbacggKqcrca7uR34hManLxZex/Kb3MAOOO3nw==
X-Google-Smtp-Source: ABdhPJw5R8R8n+cHJuC6jOxQ4tFL1IHe1BHVHu2GEmwDcwEWZlVnosK4C9bANjTaOdKc3crMLwGnTJXU3JV9nPs9wbg=
X-Received: by 2002:a05:6638:1456:: with SMTP id l22mr4841012jad.306.1640456636186;
 Sat, 25 Dec 2021 10:23:56 -0800 (PST)
MIME-Version: 1.0
References: <20211221015751.116328-1-sashal@kernel.org> <20211221015751.116328-7-sashal@kernel.org>
In-Reply-To: <20211221015751.116328-7-sashal@kernel.org>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 25 Dec 2021 19:23:19 +0100
Message-ID: <CA+icZUXqtz5CbuC_gOMgJRCuLbsnSO0gsB7zS0ZwMQW3PBOCAw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.15 07/29] nl80211: reset regdom when reloading regdb
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Finn Behrens <me@kloenk.dev>, Finn Behrens <fin@nyantec.com>,
        Johannes Berg <johannes.berg@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 2:58 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Finn Behrens <me@kloenk.dev>
>
> [ Upstream commit 1eda919126b420fee6b8d546f7f728fbbd4b8f11 ]
>
> Reload the regdom when the regulatory db is reloaded.
> Otherwise, the user had to change the regulatoy domain
> to a different one and then reset it to the correct
> one to have a new regulatory db take effect after a
> reload.
>
> Signed-off-by: Finn Behrens <fin@nyantec.com>
> Link: https://lore.kernel.org/r/YaIIZfxHgqc/UTA7@gimli.kloenk.dev
> [edit commit message]
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This requires [1] to fix this warning:

net/wireless/reg.c:1137:23: warning: implicit conversion from
enumeration type 'enum nl80211_user_reg_hint_type' to different
enumeration type 'enum nl80211_reg_
initiator' [-Wenum-conversion]

[PATCH] nl80211: remove reload flag from regulatory_request

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git/patch/?id=37d33114240ede043c42463a6347f68ed72d6904

> ---
>  include/net/regulatory.h |  1 +
>  net/wireless/reg.c       | 27 +++++++++++++++++++++++++--
>  2 files changed, 26 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/regulatory.h b/include/net/regulatory.h
> index 47f06f6f5a67c..0cf9335431e07 100644
> --- a/include/net/regulatory.h
> +++ b/include/net/regulatory.h
> @@ -83,6 +83,7 @@ struct regulatory_request {
>         enum nl80211_dfs_regions dfs_region;
>         bool intersect;
>         bool processed;
> +       bool reload;
>         enum environment_cap country_ie_env;
>         struct list_head list;
>  };
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index df87c7f3a0492..61f1bf1bc4a73 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -133,6 +133,7 @@ static u32 reg_is_indoor_portid;
>
>  static void restore_regulatory_settings(bool reset_user, bool cached);
>  static void print_regdomain(const struct ieee80211_regdomain *rd);
> +static void reg_process_hint(struct regulatory_request *reg_request);
>
>  static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
>  {
> @@ -1098,6 +1099,8 @@ int reg_reload_regdb(void)
>         const struct firmware *fw;
>         void *db;
>         int err;
> +       const struct ieee80211_regdomain *current_regdomain;
> +       struct regulatory_request *request;
>
>         err = request_firmware(&fw, "regulatory.db", &reg_pdev->dev);
>         if (err)
> @@ -1118,8 +1121,27 @@ int reg_reload_regdb(void)
>         if (!IS_ERR_OR_NULL(regdb))
>                 kfree(regdb);
>         regdb = db;
> -       rtnl_unlock();
>
> +       /* reset regulatory domain */
> +       current_regdomain = get_cfg80211_regdom();
> +
> +       request = kzalloc(sizeof(*request), GFP_KERNEL);
> +       if (!request) {
> +               err = -ENOMEM;
> +               goto out_unlock;
> +       }
> +
> +       request->wiphy_idx = WIPHY_IDX_INVALID;
> +       request->alpha2[0] = current_regdomain->alpha2[0];
> +       request->alpha2[1] = current_regdomain->alpha2[1];
> +       request->initiator = NL80211_USER_REG_HINT_USER;
> +       request->user_reg_hint_type = NL80211_USER_REG_HINT_USER;
> +       request->reload = true;
> +
> +       reg_process_hint(request);
> +
> +out_unlock:
> +       rtnl_unlock();
>   out:
>         release_firmware(fw);
>         return err;
> @@ -2690,7 +2712,8 @@ reg_process_hint_user(struct regulatory_request *user_request)
>
>         treatment = __reg_process_hint_user(user_request);
>         if (treatment == REG_REQ_IGNORE ||
> -           treatment == REG_REQ_ALREADY_SET)
> +           (treatment == REG_REQ_ALREADY_SET &&
> +            !user_request->reload))
>                 return REG_REQ_IGNORE;
>
>         user_request->intersect = treatment == REG_REQ_INTERSECT;
> --
> 2.34.1
>
