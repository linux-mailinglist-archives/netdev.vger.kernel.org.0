Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509C1497584
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 21:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240085AbiAWUea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 15:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240057AbiAWUe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 15:34:28 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96262C06173B;
        Sun, 23 Jan 2022 12:34:27 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id r14so9945533wrp.2;
        Sun, 23 Jan 2022 12:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YZxT4uV4PwpwGlJaj3MnvyKTfRRb+lSbjvia5bSbrQQ=;
        b=cYizXUgsgne72pKUwH7zQjLmVYeUz7tVVlp0uMv+2rTKF8Zn706uR0rUjEZmppttrX
         5CwaoIa9rOP7rcoTu3zqnwhAYnhfA23rI1k80KkCRz629R+XVShxW/jRsbWeEOma6IpW
         PTOvPwkhN3taJx5AyfBb2u4MUhOvl2834GPbxR/bJ+xVK8pkBfLHalbFRxiRC0RUXfLw
         rihjSUxr6LQC7LxEZ8pzzoXstfJans1Pz2ZkIW5TYuYuSvNlBfovgh8MJ9LcOkie7ZKV
         2vf6O+A8t0mkB40XaZ29amH7iB+YFwS8vxOcUaLZ3yweRkhBhDccpaAyxsgiBy7QraLQ
         mLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YZxT4uV4PwpwGlJaj3MnvyKTfRRb+lSbjvia5bSbrQQ=;
        b=ApOMJrPURRL12d9tHt33zuK9EIWTYsJMa3vl/ix4j9CuzCOP4bLZay6s2f5hrvK9gj
         R8KeyFGWR8hgyDRfMrNYNrBac0Tvsr0/Qpfy7y9fFhgbRKL6DTwa3S/sNsmZTAE9mmbH
         ydEbb1+CJah6OwquQB9RAQFMph+6Buc1V3l7BK0hYJQdF/xBOl7H/fP9t2K6bs17++Li
         ah8E2wfo55Keu2q9zmJ4YWjO3IIAAvFykQXkuHB3yF+V6mUxRkRRKawPnKApcJelChTC
         rKcQNwBn/gVxRsxkbQL9+hSOdw6qU7f4vDCn2xoGEIfh4F8gPT2WdFES8ln2RU8gQnNT
         lTNA==
X-Gm-Message-State: AOAM531QuYP2WrxYIXMDfvnKLrVv0dfcA/nZu/3wrAYBXd3Fkj/Ti3Yc
        TzMmP9eFl0LLdmGA2lVI818J6VzKjmnGewBMlXb9CMOLnY0=
X-Google-Smtp-Source: ABdhPJyl4DWssv39RVRPUw/5XlZsZKDNGqtAHyO/Ap6YhAZ2hQ/+a2szc0PnZT3ltnwO50ZM10bVeP6Kq9sywYfdpq0=
X-Received: by 2002:a05:6000:18ac:: with SMTP id b12mr1439007wri.81.1642970066074;
 Sun, 23 Jan 2022 12:34:26 -0800 (PST)
MIME-Version: 1.0
References: <20220120112115.448077-1-miquel.raynal@bootlin.com> <20220120112115.448077-2-miquel.raynal@bootlin.com>
In-Reply-To: <20220120112115.448077-2-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 23 Jan 2022 15:34:14 -0500
Message-ID: <CAB_54W5k-AUJhcS0Wf7==5qApYo3-ZAU7VyDWLgdpKusZO093A@mail.gmail.com>
Subject: Re: [wpan-next v2 1/9] net: ieee802154: hwsim: Ensure proper channel
 selection at probe time
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Drivers are expected to set the PHY current_channel and current_page
> according to their default state. The hwsim driver is advertising being
> configured on channel 13 by default but that is not reflected in its own
> internal pib structure. In order to ensure that this driver consider the
> current channel as being 13 internally, we can call hwsim_hw_channel()
> instead of creating an empty pib structure.
>
> We assume here that kvfree_rcu(NULL) is a valid call.
>
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/mac802154_hwsim.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
>
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> index 8caa61ec718f..795f8eb5387b 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -732,7 +732,6 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
>  {
>         struct ieee802154_hw *hw;
>         struct hwsim_phy *phy;
> -       struct hwsim_pib *pib;
>         int idx;
>         int err;
>
> @@ -780,13 +779,8 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
>
>         /* hwsim phy channel 13 as default */
>         hw->phy->current_channel = 13;
> -       pib = kzalloc(sizeof(*pib), GFP_KERNEL);
> -       if (!pib) {
> -               err = -ENOMEM;
> -               goto err_pib;
> -       }
> +       hwsim_hw_channel(hw, hw->phy->current_page, hw->phy->current_channel);

Probably you saw it already; this will end in a
"suspicious_RCU_usage", that's because of an additional lock check in
hwsim_hw_channel() which checks if rtnl is held. However, in this
situation it's not necessary to hold the rtnl lock because we know the
phy is not being registered yet.

Either we change it to rcu_derefence() but then we would reduce the
check if rtnl lock is being held or just simply initial the default
pib->channel here to 13 which makes that whole patch a one line fix.

- Alex
