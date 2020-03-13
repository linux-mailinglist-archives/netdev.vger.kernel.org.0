Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04559184592
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 12:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgCMLGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 07:06:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21269 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726426AbgCMLGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 07:06:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584097594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8JqjugNXeLsU+Y6Z3jk4nYx9HtuFRA+GU+dvsI1O8Uw=;
        b=ghWUGogZ6rxYcKdG3OWQq4e+5Bms1GWp4lwF7o5kfPuikM6uKHAyKXkoC3YmcKCTjsFJrT
        JqtnFEtbQkJ/se1oX0mkeRy+GF4sWq7WFhTtNM6uL7JAOD290vNOFbWEeDlh1s+TjLjG1U
        IXDMS9DP6huX69N06MESf0kBroBlR8c=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-dqiFs1k4Nj6RdDoZAQqNRQ-1; Fri, 13 Mar 2020 07:06:33 -0400
X-MC-Unique: dqiFs1k4Nj6RdDoZAQqNRQ-1
Received: by mail-ed1-f70.google.com with SMTP id d12so7580789edq.16
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 04:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8JqjugNXeLsU+Y6Z3jk4nYx9HtuFRA+GU+dvsI1O8Uw=;
        b=QD2jsSL/ru2AhKumov9aNWJwvAEhJhkbYa6WiOIY3pCOw45vASJx6SdoSo2uJSrdLX
         sy7I5CkGo8tcYig18RXmdkKwxucybxxeI+U3PFVLOmPNepIk/FkJqqUlVbZbCOYqLxB+
         UCBI0UWSeKYZFKQ9lJ2m8lCGNIxk3ITdcR7qsEvET0uZN7MDw/6/ggYVTm9Qv1nrG8cB
         D+8bYRNB8l+TkKeSNUwi6uBEE8Vh9L9dNx6Px5y/WTrc2BtVT2943ePizhLaZ8qjpEbT
         ZgxpG+ZKWsk7H56mKFUWaeZ9iAC+V9tmAy4hDr63j4PDuULafdJiRPUDBiOU5L4og5Vx
         QD5w==
X-Gm-Message-State: ANhLgQ37jFWgV+AuCAD+8qwfzCnyc1OLHnO7gt0r/mrmPkZ/5ryyncE0
        d4J/MMBgm3J6DfaLHhHUfLo7Tcea+YCY1kpAvnjs+pX4gMwbqy3SLYF94tAJ6gXifO/m4Ri7YjN
        oO+oTZzcAY54shTUGYhqOxFhwx3+NDp2b
X-Received: by 2002:a17:906:5612:: with SMTP id f18mr10447667ejq.69.1584097591887;
        Fri, 13 Mar 2020 04:06:31 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuqTbynFI4gDX3u8Q2ReBayqRif9LWNVGDi+wLAYG13fIjkbqZ6EQDWlw6/Yq36mhOZvzE1Uk2AOLPo48MllDs=
X-Received: by 2002:a17:906:5612:: with SMTP id f18mr10447641ejq.69.1584097591607;
 Fri, 13 Mar 2020 04:06:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200313040803.2367590-1-kuba@kernel.org> <20200313040803.2367590-5-kuba@kernel.org>
In-Reply-To: <20200313040803.2367590-5-kuba@kernel.org>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 13 Mar 2020 12:05:55 +0100
Message-ID: <CAGnkfhwSFNrHFyAv+F9uopc_zokhzxm6GiAZxYcWLu1P6Tbhrg@mail.gmail.com>
Subject: Re: [PATCH net-next 04/15] net: mvpp2: reject unsupported coalescing params
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, kernel-team@fb.com,
        cooldavid@cooldavid.org, sebastian.hesselbarth@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, mlindner@marvell.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        christopher.lee@cspi.com, manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        nic_swsd@realtek.com, hkallweit1@gmail.com, bh74.an@samsung.com,
        romieu@fr.zoreil.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 5:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
>
> This driver did not previously reject unsupported parameters.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 6b9c7ed2547e..1fa60e985b43 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -4384,6 +4384,8 @@ static const struct net_device_ops mvpp2_netdev_ops = {
>  };
>
>  static const struct ethtool_ops mvpp2_eth_tool_ops = {
> +       .supported_coalesce_params = ETHTOOL_COALESCE_USECS |
> +                                    ETHTOOL_COALESCE_MAX_FRAMES,
>         .nway_reset             = mvpp2_ethtool_nway_reset,
>         .get_link               = ethtool_op_get_link,
>         .set_coalesce           = mvpp2_ethtool_set_coalesce,
> --
> 2.24.1
>

Acked-by: Matteo Croce <mcroce@redhat.com>

-- 
Matteo Croce
per aspera ad upstream

