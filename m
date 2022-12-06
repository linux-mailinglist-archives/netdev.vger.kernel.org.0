Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D087643BDD
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 04:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbiLFDZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 22:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiLFDZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 22:25:32 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD3426491
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 19:25:31 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id v206so17023266ybv.7
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 19:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AKJzTSPul8/j3MyLaE2xrXTHUnSF7/qO/iMEvPanhDU=;
        b=pXsRP/muPixgPgpApdfx2zzo2Nz+lBxrKQHxqrRCthLKNZ2crC8GAAjRzSA6A6T5Hf
         pAVM4u4Lx36XUObSklFX5hE5EvM+FHOvifQsS/0mj7ZnQC5PDDDrtDkPfq6WalfYcgPY
         fLWXG2SVqcGrTmGDN+6X98E7IT6+OzPXZCk1E+yZgXKWev3uxnd3K9aUa2M6SCIp9K5N
         MmgL05KHppQlF9V9c0veCO6lsz5NtDWBfsSamJZK1rx6JMLftuxPKSetFoHtYnU5PL2U
         8G/kgSHqd2163R4AVEXTBS+hHOAPwAtlsEWb13vplQiKmy9UvqZSJUtCO2wDchmVnlT0
         o/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AKJzTSPul8/j3MyLaE2xrXTHUnSF7/qO/iMEvPanhDU=;
        b=sWaNgPteIDr5E2IhF6swus8NH/YdSJ71ShxMkUT9D+jRENVUtjSpX+B6IcQLwrHnLu
         PJkYmfn6QGHzLnbQRf23ipRrwXHX6C2t/rr3BE4w/9bTuEFg/HwW0emcivmQKImPNnGz
         GUItti3mWF2iIDwvu+j+HW+a0XzaDk8YnGe1urSEGsD7L97bGPVFWGxVzL0YGlBz02Eo
         yoJHiL+0idn30cYTVFNMKwi2B9MlCpTr3KmtTIeG4tFTVHMl4wJ+1+1viVaVaGfi5ACA
         8nwqFXKKb3tAqgVuzhWkMs2NxePjfjld+t9c2Ot+Q/rGDcAvqoKXv5siM1QDxc0H6+Fx
         uQWQ==
X-Gm-Message-State: ANoB5pnOQ94dPjztirVu5ZoOe2bftlzYjnqlS8yjj4EEGBkd+SEU7wv0
        CPB2IP5a+SwwnNJtQJ/cx3KRA1LhmBZEWQvxWxvyHA==
X-Google-Smtp-Source: AA0mqf594ivJ3BTsU6fqWS6VRaRdPTTuSP9SntrG898GVOEKYwd8cVEHP52MklA/q2orIcR7ku8IrrzVVE9OG2bPQTg=
X-Received: by 2002:a05:6902:1004:b0:6fe:d784:282a with SMTP id
 w4-20020a056902100400b006fed784282amr11916628ybt.598.1670297130482; Mon, 05
 Dec 2022 19:25:30 -0800 (PST)
MIME-Version: 1.0
References: <20221206032055.7517-1-liuhangbin@gmail.com>
In-Reply-To: <20221206032055.7517-1-liuhangbin@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 6 Dec 2022 04:25:19 +0100
Message-ID: <CANn89iKDLcJ6exhwh87Y_w-RTXodUxMLx2Mav2PgonPMG4PVSw@mail.gmail.com>
Subject: Re: [PATCH net] bonding: get correct NA dest address
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 4:21 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> In commit 4d633d1b468b ("bonding: fix ICMPv6 header handling when receiving
> IPv6 messages"), there is a copy/paste issue for NA daddr. I found that
> in my testing and fixed it in my local branch. But I forgot to re-format
> the patch and sent the wrong mail.
>
> Fix it by reading the correct dest address.
>
> Fixes: 4d633d1b468b ("bonding: fix ICMPv6 header handling when receiving IPv6 messages")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  drivers/net/bonding/bond_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index f298b9b3eb77..b9a882f182d2 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3247,7 +3247,7 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
>                 goto out;
>
>         saddr = &combined->ip6.saddr;
> -       daddr = &combined->ip6.saddr;
> +       daddr = &combined->ip6.daddr;
>

Indeed, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
