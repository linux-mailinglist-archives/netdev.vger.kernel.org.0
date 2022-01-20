Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE25495056
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353350AbiATOhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbiATOhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 09:37:45 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306B1C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 06:37:45 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f21so29520734eds.11
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 06:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6Ky7e2JTg7oiP9Jy3YWZ+HBrS/zKPzm5WUdAsQWaSIQ=;
        b=JpiEm2+ReEiGmPE8ytt7H4kFTm7fMFTBFNYkJRcDyEBWBi+keLXiTdkweOsBkoAnXQ
         Y/tJvg/7HiCwXkugPGYVjZ5P6S66VtdrMwTmyQtXnldehKtqEm2cHyavc3WHqmStQ92w
         BUNQYlW76naRu4EcIV059BH/R2qs5C13vcqjXDa7NUQLqpSfWD3kJeydmx3N3Ilmt7cc
         LL8094oDh36ufa2cNIZsFU/MmdAVQX9F0PhNR5Y9//7U4fAyiY3rtEXF8KmLZ/a+FCpa
         SjtJNQNl/tTDNTc/IArRxoUC2bNhE08ocvB53dD3ZJw/GpYCIXolW1M9PILNTMWkd/0I
         cADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6Ky7e2JTg7oiP9Jy3YWZ+HBrS/zKPzm5WUdAsQWaSIQ=;
        b=3fRxm12EO0lpPqOvAx7SQdR1wZovXjWFunD33+LcP1xQvit/mTuS12Qm9s84XMP5ST
         xteEv0r0YnYYG5TdW4UdJ4gDmb6R8al93CabMU0YZDK6Urji8GyU6BbaQzIP6ILLeh2W
         o8vLiTyEbFViRpyI4APa1pRB/exG91pWzVyREHJYIDj0tNdB5y/p2IRrPWDBC8MSaUmB
         8ZZCskldmytsXtT9HGvhV6hSG8XvpWyBIIvBI8KMZ1Nrz/yTRhDJ7Hs6N2HruH2Hp6ps
         ER3Hz/enzUMsZJL/RIDA3UURmP9K3NlKxGJ+LK5qi8GnABeJTOuCpg1tEbuXoILbvZvI
         tLAA==
X-Gm-Message-State: AOAM533GC5qllb0GItF2Az/zf+0Ake0UcjJ87lMu0Z0XkU+CppifLV6E
        ugVtUwRWF2pOs2EfH3rjLEU=
X-Google-Smtp-Source: ABdhPJyc0yMaeR2VhTgN926+Ds7u/m2z8gjR7qNFy7MEb0TBmbnYAWrTttY+6kQbxxWkbYkytXaQvQ==
X-Received: by 2002:a17:906:56ca:: with SMTP id an10mr2062059ejc.717.1642689463736;
        Thu, 20 Jan 2022 06:37:43 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id f4sm1089075ejh.93.2022.01.20.06.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 06:37:43 -0800 (PST)
Date:   Thu, 20 Jan 2022 16:37:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
Subject: Re: [PATCH net-next v4 02/11] net: dsa: realtek: rename realtek_smi
 to realtek_priv
Message-ID: <20220120143742.dcfhp5vzx2o6jimr@skbuf>
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-3-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220105031515.29276-3-luizluca@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 12:15:06AM -0300, Luiz Angelo Daros de Luca wrote:
> In preparation to adding other interfaces, the private data structure
> was renamed to priv. Also, realtek_smi_variant and realtek_smi_ops
> were renamed to realtek_variant and realtek_ops as those structs are
> not SMI specific.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
