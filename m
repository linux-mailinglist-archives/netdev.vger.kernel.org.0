Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C653F164ECD
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgBSTWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:22:11 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32794 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgBSTWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 14:22:10 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so597648pgk.0
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 11:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H9pCFwuo9zE6GfNpx/e5ax8ezAT4LdlBX6w0zbvDBCk=;
        b=rVa1BjdKBggikcAUBlcsbSNt9vYf7uad4eJ7919Bj/p/TlHPaGIup1MYfC802odltd
         b+6rNHVcfrStUE+gSbXP9UqGCuT7RbHZZwSdMfUPCC2REZK8B6Yjz6SSnHMrf412+wCf
         guStlvorMdvAeNuX2vCN/ZHjsSzXqD48hwuazWbOh5Jk3936jPe4OlmISzoS0SJOWv9S
         WEGTuKqVDAN0Wmjg17wAYZJemMC3azGmzLqyItK9LGNMkHZ8s4EgUWjfBXyoR82wBtEH
         3m+vKnGiO/Jlh6ZkFJLhC+ymMe5KOcle4brEOrqj/K8x1LAVEKZdXH3KAe9XFLsOwUQb
         LReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H9pCFwuo9zE6GfNpx/e5ax8ezAT4LdlBX6w0zbvDBCk=;
        b=TYTHA8qgFn96b28FYuR5SorzJYrtabyC6wotRYq6m3GK+qyoIVNvrH9+OPSgiGIOu9
         DGzCYJ/158CTShv3gENMYFs746DNIjkgZsq5iEnBpXdTX5Mfr87iHAA88LmBaL+L01qd
         Y+dTZ0P9jGSk/CjdkFok0ggRovXEd+3l/jy3T1uzj7Ua+bBvnqbQm/C+VmE9xguyT0sE
         TOKsnQCXfWDdvaD1w+0pmVVt8/onbIYCF0mkZMBP5UHJwYqYfjYzumrUxeIcjB10g0v5
         DVYTLkrLKtiKLIji1MGgTujjYRbAfnK9SI9zf6Su3Cpv9mvF8lhkjHhU9qyp3t7Axm2R
         wWkQ==
X-Gm-Message-State: APjAAAWmR9w9v1WMrUlqEuezEEPyy7RaNs27tzt3y/ng8AUy6FfeGEyQ
        yX7nRHXdj074/0T8TSCMmgOZg3Vwc4qG3xkn/fcjdw==
X-Google-Smtp-Source: APXvYqwBJAVEzBBw7QYqYE2ycFLWnQLr6S/vPkwZnfozmnWwZ/DvaNIQ7b0nIGJtJESnFnJ9ZcVvbyV1YYUEvMNhx1M=
X-Received: by 2002:a62:37c7:: with SMTP id e190mr28407282pfa.165.1582140128959;
 Wed, 19 Feb 2020 11:22:08 -0800 (PST)
MIME-Version: 1.0
References: <20200219144442.Bluez.v2.1.I145f6c5bbf2437a6f6afc28d3db2b876c034c2d8@changeid>
In-Reply-To: <20200219144442.Bluez.v2.1.I145f6c5bbf2437a6f6afc28d3db2b876c034c2d8@changeid>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 19 Feb 2020 11:21:57 -0800
Message-ID: <CAKwvOd=dT9FHwCbJ5959wy_k5cw37Tm-tLw+Lk3jmqHWYpOQug@mail.gmail.com>
Subject: Re: [Bluez PATCH v2] bluetooth: fix passkey uninitialized when used
To:     Howard Chung <howardchung@google.com>
Cc:     linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 10:45 PM 'Howard Chung' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> This issue cause a warning here
> https://groups.google.com/forum/#!topic/clang-built-linux/kyRKCjRsGoU
>
> Signed-off-by: Howard Chung <howardchung@google.com>

It can be helpful to just include the text from the warning in the
commit message, for future patches, then a "Link" tag (below) to the
report.  Also,if you use Marcel's suggestions, it's polite to add a
`Suggested-by` tag.

Link: https://groups.google.com/forum/#!topic/clang-built-linux/kyRKCjRsGoU
Reported-by: kbuild test robot <lkp@intel.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>

>
> ---
>
> Changes in v2:
> - refactor code
>
>  net/bluetooth/smp.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> index 50e0ac692ec4..929e0bebaf80 100644
> --- a/net/bluetooth/smp.c
> +++ b/net/bluetooth/smp.c
> @@ -2115,7 +2115,7 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
>         struct l2cap_chan *chan = conn->smp;
>         struct smp_chan *smp = chan->data;
>         struct hci_conn *hcon = conn->hcon;
> -       u8 *pkax, *pkbx, *na, *nb;
> +       u8 *pkax, *pkbx, *na, *nb, confirm_hint;
>         u32 passkey;
>         int err;
>
> @@ -2179,13 +2179,12 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
>                  */
>                 if (hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
>                                  hcon->role)) {
> -                       err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
> -                                                       hcon->type,
> -                                                       hcon->dst_type,
> -                                                       passkey, 1);
> -                       if (err)
> -                               return SMP_UNSPECIFIED;
> -                       set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
> +                       /* Set passkey to 0. The value can be any number since
> +                        * it'll be ignored anyway.
> +                        */
> +                       passkey = 0;
> +                       confirm_hint = 1;
> +                       goto confirm;
>                 }
>         }
>
> @@ -2206,9 +2205,11 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
>         err = smp_g2(smp->tfm_cmac, pkax, pkbx, na, nb, &passkey);
>         if (err)
>                 return SMP_UNSPECIFIED;
> +       confirm_hint = 0;
>
> +confirm:
>         err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst, hcon->type,
> -                                       hcon->dst_type, passkey, 0);
> +                                       hcon->dst_type, passkey, confirm_hint);
>         if (err)
>                 return SMP_UNSPECIFIED;
>
> --

-- 
Thanks,
~Nick Desaulniers
