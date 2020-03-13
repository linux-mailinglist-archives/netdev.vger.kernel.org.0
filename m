Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05C21840CA
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 07:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCMGOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 02:14:00 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52527 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgCMGOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 02:14:00 -0400
Received: by mail-wm1-f68.google.com with SMTP id 11so8603001wmo.2
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 23:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JduRkudgkxc5/Ub53X3j/qWRo+lor5OBNJ1jLBBHY8o=;
        b=Mpjc/Qy5/iJip1DvTX6jJIRuJc0jVKhgYVs8y8/V+vMXJYPz7Q1p1zdubAuC1260JV
         QakI8tjhK+jZFoGDhtb0URlOfOt0OK9sYfuuovmJRC2e1h4WamfweJ78nNiHjxaaCd6v
         KkxRVF7q72nzQP9RV1HQy2fpqIQwWiM3eJnGCTSpDMP/wMpLwxrI2sXQfp9gouZnwKDf
         fttOLiLKCmV6ePVj2Sa2I+ykUs0AV7Bn1dsfLKx4WQ+fTua8XizY9V1USTowrWf2iCUc
         5eKCQXQiv/fPHRarjp2ek3q2npHh/w0QH952JFZvgkSnXw523QiJ0mgbm6y3UvvjMv44
         xtoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JduRkudgkxc5/Ub53X3j/qWRo+lor5OBNJ1jLBBHY8o=;
        b=KGG6wiAs5RbjrK7oILEYpIn7wemtbq+3r+cX28MkgHsCBda+87lLpCy7AzvP1Bfw/B
         iSK6Kxs0JjSfkiehqLQsrGEJGITBuH7pF+AdUqbSWyNLYKQvJ9MeBGTGqZifss+ib4S7
         WRVfedjSPohif/1vP2UXqBcjWvGa1w3wTzBlwjJHIu52bq9hYZZlLYgHwjTatdDoIvIE
         28QO2C8B3ZqG+PHQbwJVIRDEQeNjHddbt1AVEAAko8/h5jFgmhVp+EoYv/jFvDaUg5ju
         PT17CD0VEZNbbxGUm57WdJtgaNxSIuoEh4veLTr4uu+Mb1H7IBVHIsZ8zJt+nAEcOB2B
         kIZA==
X-Gm-Message-State: ANhLgQ3zbjh/BWIQy9zxyPAI+ln83bYLcRUYchMUdPgfegkaz3y7uHCf
        PVoygQ5Hxxfb0fzke7Ynj84=
X-Google-Smtp-Source: ADFU+vt0vwjP1SSPTdcpY79NeyOmPnvmefvYQ3aRdEAt/aJ3wr7mq7ZNz/9o1vWWVvUZ2qZxwZo9gw==
X-Received: by 2002:a1c:81c3:: with SMTP id c186mr8589787wmd.62.1584080038089;
        Thu, 12 Mar 2020 23:13:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:c9b7:bad8:eb25:3491? (p200300EA8F296000C9B7BAD8EB253491.dip0.t-ipconnect.de. [2003:ea:8f29:6000:c9b7:bad8:eb25:3491])
        by smtp.googlemail.com with ESMTPSA id u25sm15269133wml.17.2020.03.12.23.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 23:13:57 -0700 (PDT)
Subject: Re: [PATCH net-next 13/15] net: r8169: reject unsupported coalescing
 params
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        cooldavid@cooldavid.org, sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        rmk+kernel@armlinux.org.uk, mcroce@redhat.com,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, mlindner@marvell.com,
        stephen@networkplumber.org, christopher.lee@cspi.com,
        manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        nic_swsd@realtek.com, bh74.an@samsung.com, romieu@fr.zoreil.com
References: <20200313040803.2367590-1-kuba@kernel.org>
 <20200313040803.2367590-14-kuba@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <47da46a6-0336-c9d2-3949-d19f8a752136@gmail.com>
Date:   Fri, 13 Mar 2020 07:13:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200313040803.2367590-14-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.03.2020 05:08, Jakub Kicinski wrote:
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
> 
> This driver did not previously reject unsupported parameters.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Heiner Kallweit <hkallweit1@gmail.com>
