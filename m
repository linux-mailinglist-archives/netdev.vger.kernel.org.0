Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DD1264F1A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgIJTen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:34:43 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40130 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbgIJTds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:33:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id x123so5272705pfc.7;
        Thu, 10 Sep 2020 12:33:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E825qm/7EG/v1qMJRENDdr8UrJ7c6Yo1KshoI/I0ueg=;
        b=RHO8ZaK3FlihxqjCxq6T3hxIjMvu1amZ9KskbVEwh84B8cbMQiqFOfHhA8pG/xlr0B
         qOXi8rrDMayttEX070fhGlwp0c2G3fJnbTRMfPGa8D6NPCv5QmntaQH9ATY42kVk++cJ
         l168ikQY/ShNuJfXdaLW6IC+3CK4Dvbq6DSDlImPCyI74LpatrUii+7+DyAx6gL8CWkf
         Z78HkgBv8qRO0YgtQW7ViCKIC2hoMdqtClk65/vJZVnYWQA0MnotrjC1P4PtBh89+Mfy
         5OlupzTh/1Qw/ImKMMcP5s3Nqv10h4CBscfLJZo9qUMYhKMklzbajpMIkmv55YW98grm
         TpwA==
X-Gm-Message-State: AOAM531PJApI1N+OPJcp82IH4SSkWyNyHB7eE0WSQEkgg7DKzMWRnqMt
        TJK78DIi/ayVjxLqAAyHLx4=
X-Google-Smtp-Source: ABdhPJwkAXtdVJDC5/PQROYD2FplK9h+zyPV3N2nLTb28vrgLb0yHjLqShdxF8N1anfjedmdVafZXQ==
X-Received: by 2002:a17:902:ee15:: with SMTP id z21mr4329526plb.103.1599766427635;
        Thu, 10 Sep 2020 12:33:47 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1162:1ac0:17a6:4cc6:d1ef])
        by smtp.gmail.com with ESMTPSA id y7sm5525188pgk.73.2020.09.10.12.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:33:47 -0700 (PDT)
Date:   Thu, 10 Sep 2020 12:33:45 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     Lucy Yan <lucyyan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Moritz Fischer <mdf@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dec: de2104x: Increase receive ring size for
 Tulip
Message-ID: <20200910193345.GA28525@archbook>
References: <20200910190509.81755-1-lucyyan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910190509.81755-1-lucyyan@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 12:05:09PM -0700, Lucy Yan wrote:
> Increase Rx ring size to address issue where hardware is reaching
> the receive work limit.
> 
> Before:
> 
> [  102.223342] de2104x 0000:17:00.0 eth0: rx work limit reached
> [  102.245695] de2104x 0000:17:00.0 eth0: rx work limit reached
> [  102.251387] de2104x 0000:17:00.0 eth0: rx work limit reached
> [  102.267444] de2104x 0000:17:00.0 eth0: rx work limit reached
> 
> Signed-off-by: Lucy Yan <lucyyan@google.com>
Reviewed-by: Moritz Fischer <mdf@kernel.org>
> ---
>  drivers/net/ethernet/dec/tulip/de2104x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
> index cb116b530f5e..2610efe4f873 100644
> --- a/drivers/net/ethernet/dec/tulip/de2104x.c
> +++ b/drivers/net/ethernet/dec/tulip/de2104x.c
> @@ -85,7 +85,7 @@ MODULE_PARM_DESC (rx_copybreak, "de2104x Breakpoint at which Rx packets are copi
>  #define DSL			CONFIG_DE2104X_DSL
>  #endif
>  
> -#define DE_RX_RING_SIZE		64
> +#define DE_RX_RING_SIZE		128
>  #define DE_TX_RING_SIZE		64
>  #define DE_RING_BYTES		\
>  		((sizeof(struct de_desc) * DE_RX_RING_SIZE) +	\
> -- 
> 2.28.0.526.ge36021eeef-goog
> 

Thanks,
Moritz
