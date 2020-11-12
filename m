Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D62B2B044E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgKLLtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbgKLLli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:41:38 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C77C0613D6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 03:41:38 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id y17so1600100ejh.11
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 03:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kl9tnH9JsEuY5xR1ZDNEf7fbe3orNGKtQm0f8d9FFN8=;
        b=SjJNEMfZmVVaZ2hOamYxtStOa75uLPmpyaHl1JNBh1bQgQnkcFmNjs0ikRbJbMp1sb
         tBkjGJLL9OpktGykqkkHskmQR4qVL45RIzToHoQTiVrRv+65crWBdISxkddxPktl8GrB
         EFb4p6xrrG1JqLIXVU9Y6ETIGA70z0iR7SUVEnC7AdLrt3bNtFWKJE0GZmtaRsbqx94k
         RszKNQ/dTU2+M4+zA3pZI4FG8FgO5bGBF6KtVIxpYbd9/eMKYg7NGnrbjGSMyqRjw7ZB
         5wvNYpvkTVw5R8fP2BNrkbpcDLob1GHTy+T4Z8Cgk1BegmiFx8TmAMo59zByhU1xFpKq
         IvDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kl9tnH9JsEuY5xR1ZDNEf7fbe3orNGKtQm0f8d9FFN8=;
        b=awUwoXhKvkwBA7QmTiotJc8QjI8I1QVqq1I0zC8eKnuaqHnjm7y7XWHtAeMzkj7U4w
         1PGgRp5KBUCwGaFxYb5ZBio8um7tXmrbyWZw2xkq0K+egbtb7BMsI8MJ/DtutBo9rqu9
         t5Mo8kEq1zOuWrVBgZJjtyrtqKoFZps1L7eaFFGMrimLvePl+a/Na+EBvetCnuuVu+GH
         tpNHTWZRsZKMsw1YhwKS5RX1oQLwKb9oc/2Z1C6be9kGSa6lJeBf+DE9y4V841EqLZHZ
         bTdxEWwBSAwKW4xlXllSVT5IjRCMszDj0FO11DeDqIa2aekTcjKt94MgyNmxuG2YIBEb
         9hzw==
X-Gm-Message-State: AOAM5333H3BPEc0PLZU+LlGJhduYcZ1oSeSV8XCWo48gpRvDP1GfL1tz
        w2/MtF5CJwC4Av2l7tjr4vvPNapIpgzvHZxLU1Yg7g==
X-Google-Smtp-Source: ABdhPJxMeuASqaNc97krYC5AoaVThbcBdJdK5408UkNEwkL9fh4N87sDwky3OpV33fNJcFh8kODSW1Byauv8NiPRv/Q=
X-Received: by 2002:a17:906:14d:: with SMTP id 13mr29245264ejh.516.1605181297002;
 Thu, 12 Nov 2020 03:41:37 -0800 (PST)
MIME-Version: 1.0
References: <1605180879-2573-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1605180879-2573-1-git-send-email-zhangchangzhong@huawei.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Thu, 12 Nov 2020 12:41:26 +0100
Message-ID: <CAMpxmJXy3upa=xMpuTzoNdgCUyuZ7YQ6kSHtuji8hj7xGo5KGQ@mail.gmail.com>
Subject: Re: [PATCH net] net: ethernet: mtk-star-emac: fix error return code
 in mtk_star_enable()
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     nbd@nbd.name, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 12:33 PM Zhang Changzhong
<zhangchangzhong@huawei.com> wrote:
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_star_emac.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> index 1325055..2ebacb6 100644
> --- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> @@ -966,6 +966,7 @@ static int mtk_star_enable(struct net_device *ndev)
>                                       mtk_star_adjust_link, 0, priv->phy_intf);
>         if (!priv->phydev) {
>                 netdev_err(ndev, "failed to connect to PHY\n");
> +               ret = -ENODEV;
>                 goto err_free_irq;
>         }
>
> --
> 2.9.5
>

Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
