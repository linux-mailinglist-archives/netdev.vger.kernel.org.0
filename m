Return-Path: <netdev+bounces-1484-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E116FDF69
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:00:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E69111C20D8C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45A412B93;
	Wed, 10 May 2023 14:00:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4FC20B54
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:00:28 +0000 (UTC)
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1185D2D7F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:00:26 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-61b6101a166so35041496d6.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683727225; x=1686319225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HRCJpwqWGcqtdTEwoX6kBh7SM0XgFuzSzPyJUQTAkt0=;
        b=QI2Q4d5SB5YuGZN198s54NmzPn6kiKESRBnW5TM4D5/a22b+F3D0ArmvqYMUAGrgeR
         GfqwZmXKOi+C4wraXsLcIu1Pnn3bDUFINGHbjxiUG8ffbYXbaGeel/kizzg4hB4oH7rd
         CBP5ueoqOguowPQ8q8JOjEnbGVdZuN3jxIN80pqaVJX9GLn66vmWIc3Q2T3NjF+1dw1d
         ntPUvV8E+xknWHfCE8X+zu4fSnuzpsR5FkTjx0LntNdrptpH1kRvWxw9QqC4WJ5H1F5B
         6Wcprh03G67mTOp/PLNR6MweTPlTr0i3m20sV7lPHOj/Rwxe+n5Xk6FE/yOzrf8hfwze
         kebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683727225; x=1686319225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HRCJpwqWGcqtdTEwoX6kBh7SM0XgFuzSzPyJUQTAkt0=;
        b=ks4QPTkIPSKOHSrlJuo1JACsSUagjPv5+upV3p0wNo1PfP8GgUrRljwD3OMLuZRj0V
         fBGCKaLXZbBkf8pFqnAA8qadNwyQxw2/8f5mn6LY7y6l9+eIzfRHhfZlWFkiBhODi+Cw
         02wkVgjvbPaa9YKLSfUEmZm6MFahWBtFlamwuTbhxYKopFPQhKhWeB+j6p2RMB8mCZWO
         st34yEGjZrVaiTUdULT44SMZ5mBNJv+yWZCRVdH/1Bus8tsRIIk3ovVsC5/uWv2hT0uF
         4f0CW06B4TV5iPddv2FAuQJ8EyTpAsk4Hy7c5XZz0ZtFRjA06WWfcgZB9HuihOcy0bRE
         c85w==
X-Gm-Message-State: AC+VfDzS644kC8PKQphahUiA9DdG9uMzdP6KLKtcas1akbOChVhXVCNX
	wR3ZxibozXPNjQJqTyDtlfl9DdjruUv3nBLYu0A=
X-Google-Smtp-Source: ACHHUZ4OOOOMIjFNHqT/9hpuXt3ZdkGoASu+QiGGrG7qx7FjnNAubpccFc3qH5nK2s4Ux7szUjj751v2EhqGiHwf3WI=
X-Received: by 2002:a05:6214:5282:b0:61b:6906:f275 with SMTP id
 kj2-20020a056214528200b0061b6906f275mr26325067qvb.7.1683727224886; Wed, 10
 May 2023 07:00:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <E1pwhbd-001XUm-Km@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pwhbd-001XUm-Km@rmk-PC.armlinux.org.uk>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 10 May 2023 16:59:48 +0300
Message-ID: <CAHp75Vd+qZxEoU22_PGjgBAsG4UqQvOTrv0TQe3RJim_nP6oBQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: phylink: constify fwnode arguments
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 2:03=E2=80=AFPM Russell King (Oracle)
<rmk+kernel@armlinux.org.uk> wrote:
>
> Both phylink_create() and phylink_fwnode_phy_connect() do not modify
> the fwnode argument that they are passed, so lets constify these.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Thank you!

> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 11 ++++++-----
>  include/linux/phylink.h   |  5 +++--
>  2 files changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index a4111f1be375..cf53096047e6 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -708,7 +708,7 @@ static int phylink_validate(struct phylink *pl, unsig=
ned long *supported,
>  }
>
>  static int phylink_parse_fixedlink(struct phylink *pl,
> -                                  struct fwnode_handle *fwnode)
> +                                  const struct fwnode_handle *fwnode)
>  {
>         struct fwnode_handle *fixed_node;
>         bool pause, asym_pause, autoneg;
> @@ -819,7 +819,8 @@ static int phylink_parse_fixedlink(struct phylink *pl=
,
>         return 0;
>  }
>
> -static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *=
fwnode)
> +static int phylink_parse_mode(struct phylink *pl,
> +                             const struct fwnode_handle *fwnode)
>  {
>         struct fwnode_handle *dn;
>         const char *managed;
> @@ -1441,7 +1442,7 @@ static void phylink_fixed_poll(struct timer_list *t=
)
>  static const struct sfp_upstream_ops sfp_phylink_ops;
>
>  static int phylink_register_sfp(struct phylink *pl,
> -                               struct fwnode_handle *fwnode)
> +                               const struct fwnode_handle *fwnode)
>  {
>         struct sfp_bus *bus;
>         int ret;
> @@ -1480,7 +1481,7 @@ static int phylink_register_sfp(struct phylink *pl,
>   * must use IS_ERR() to check for errors from this function.
>   */
>  struct phylink *phylink_create(struct phylink_config *config,
> -                              struct fwnode_handle *fwnode,
> +                              const struct fwnode_handle *fwnode,
>                                phy_interface_t iface,
>                                const struct phylink_mac_ops *mac_ops)
>  {
> @@ -1809,7 +1810,7 @@ EXPORT_SYMBOL_GPL(phylink_of_phy_connect);
>   * Returns 0 on success or a negative errno.
>   */
>  int phylink_fwnode_phy_connect(struct phylink *pl,
> -                              struct fwnode_handle *fwnode,
> +                              const struct fwnode_handle *fwnode,
>                                u32 flags)
>  {
>         struct fwnode_handle *phy_fwnode;
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index 71755c66c162..02c777ad18f2 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -568,7 +568,8 @@ void phylink_generic_validate(struct phylink_config *=
config,
>                               unsigned long *supported,
>                               struct phylink_link_state *state);
>
> -struct phylink *phylink_create(struct phylink_config *, struct fwnode_ha=
ndle *,
> +struct phylink *phylink_create(struct phylink_config *,
> +                              const struct fwnode_handle *,
>                                phy_interface_t iface,
>                                const struct phylink_mac_ops *mac_ops);
>  void phylink_destroy(struct phylink *);
> @@ -577,7 +578,7 @@ bool phylink_expects_phy(struct phylink *pl);
>  int phylink_connect_phy(struct phylink *, struct phy_device *);
>  int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 f=
lags);
>  int phylink_fwnode_phy_connect(struct phylink *pl,
> -                              struct fwnode_handle *fwnode,
> +                              const struct fwnode_handle *fwnode,
>                                u32 flags);
>  void phylink_disconnect_phy(struct phylink *);
>
> --
> 2.30.2
>


--=20
With Best Regards,
Andy Shevchenko

