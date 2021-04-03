Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F37353414
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 15:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbhDCNDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 09:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhDCNDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 09:03:24 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122DBC0613E6;
        Sat,  3 Apr 2021 06:03:22 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id r12so10722880ejr.5;
        Sat, 03 Apr 2021 06:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=veRpL9tBr0pNWw7yRlNqrHJnx67HGYjm6FOr/5mrA9Q=;
        b=ldkBwfZohSu2YLTPvfeMp4b2V4WFRBfhaBuYVITZzzsiQee+bo4nvWZFpyctuCUg+b
         rL1H2+DLMtSG2nXxGRMY6j95UkINMaTI3stsNqortErMlK+Ht1x6u4Bd92XNC5K1RkWG
         Hlot0wR7Lf3o87bg8E/TIXYFDq9kOgzYTsJeLf9bBmYmebCNLrcRigh5CWu+wrZPVG+k
         ZZdOtBl/JRN13AcFytZQPL/hV9ZCBbHyEVf3rS3OHxhgsGMjJqnffmR0TEWnLX+ea4r5
         9CxqpjfvZII5g3t+XExhSHyjCcOVKVWKSSfNYFVyShlpaQiZqChV7GclQor3QdW7jm0V
         rN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=veRpL9tBr0pNWw7yRlNqrHJnx67HGYjm6FOr/5mrA9Q=;
        b=KpJPD0fPJGEz1u7xy1FEYCqCZWtjQjVk/WnF6Em8GUynyI63toHym3hW0q1JrTYqX4
         h+MVOaYKRdmAc9feRJJ2ov4F5h/1bVxhCaiwSpQNc7ezYZAruYVdpvPsCvpcAzkDRhST
         EmVq2uzJ27BsIPJkH/lhpq2vvS9/eKJIey4OhUDHjPZOIOAyAe5pDcrKpWxi6Q+8DXjH
         /6UrB5McwaBT+TIrbCHqH/NVLQZQoCl7U1pmXYWRktjnfSxyTRa2zCfyQuZT0/0MF6e/
         kPYeC3ihSsNvoCctW5TU2ple4jwxetbjOG5zYIVmV75alRMAcgMsMksgrwPegD8hxpBF
         zLHA==
X-Gm-Message-State: AOAM533Njj64OKhYREK4RDtij10jCi6/v/5LwGeRE0QDCgbWx2YDU/cJ
        drjEqQyj3M5GwQWI9V7nThA=
X-Google-Smtp-Source: ABdhPJwRTg/uNesR+yk1lrDveX1KcjTfNamVbpJvpSD7aa0tlnOgIBu2ews+mS2XUvfuqUJwjbHU2A==
X-Received: by 2002:a17:906:4e91:: with SMTP id v17mr18749152eju.331.1617455000535;
        Sat, 03 Apr 2021 06:03:20 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q25sm7097778edt.51.2021.04.03.06.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 06:03:20 -0700 (PDT)
Date:   Sat, 3 Apr 2021 16:03:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/9] net: dsa: tag_ar9331: detect IGMP and
 MLD packets
Message-ID: <20210403130318.lqkd6id7gehg3bin@skbuf>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403114848.30528-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Sat, Apr 03, 2021 at 01:48:41PM +0200, Oleksij Rempel wrote:
> The ar9331 switch is not forwarding IGMP and MLD packets if IGMP
> snooping is enabled. This patch is trying to mimic the HW heuristic to take
> same decisions as this switch would do to be able to tell the linux
> bridge if some packet was prabably forwarded or not.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

I am not familiar with IGMP/MLD, therefore I don't really understand
what problem you are trying to solve.

Your switch has packet traps for IGMP and MLD, ok. So it doesn't forward
them. Must the IGMP/MLD packets be forwarded by an IGMP/MLD snooping
bridge? Which ones and under what circumstances?
