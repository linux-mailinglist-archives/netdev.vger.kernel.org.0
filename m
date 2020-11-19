Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38FD2B8A5F
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgKSDNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgKSDNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:13:55 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA310C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:13:53 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id q10so3092745pfn.0
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7dAptKqXNndrJ2yD+CDK7K5JfQTMmCgWlrBOhTXlZlU=;
        b=PCLNgOppAlF62YxrIEFafmvgFT4OmL9a5xn96Bfa1kSzFgJNekomjhGqR8PLQNRmDD
         oDSYUdvftUP6WXHuw3wGaPXut3uBqcDPVcANnlwRRFuNpMhv/m76Cmvx8uACKbzZQpJH
         n0NmGDWtHtZu4/7DamPRGOI6UhGDLzcx9Icy+yavTrqRtpwjZdKYcVrmQjoVj1fmxBFf
         vfQwHdQB+/WD6ZrT6MwF0uATHbufP8yI6yyefWB+JspraYwYwrHOrYSmDDodG9rT9w1r
         llcFRA5dLeCg0J1aVfFtyMLW4hzbQcKh2dZTe9TS1vkVpnwn6YkbNHXIgamf3dimYy5H
         fikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7dAptKqXNndrJ2yD+CDK7K5JfQTMmCgWlrBOhTXlZlU=;
        b=CQW1bwgMKz0DL5rrN+4S+DC9+eKyW9Eu+i3Vy6cxueOO7muglmplY/Jm1+pzy32PEh
         IlfTY8Qq2lKxWrU96D7E6kWIkBeHOeYJS8q+dsqbQSCPk4jWUjqiAU5XbPxRxl4mW2RY
         IBZMbo9drV+p3tuj1Cgg60fXifjvzNhQGEzodPfVkjG7plBiHtlt66KgEGubPjL75Ho7
         DPH37Rps/woVBD80QcDYHntjYGalmbDuBjMu3pZz+RAWH2s1qLKGivLYFMjHdzMdLF/K
         fiO6WaaHBSZzXrwZt6EUmxe8TRsXkIJszUmMtC6iK3D9RpzCrFdjzEzDDppDxkrZmdcQ
         9Gxw==
X-Gm-Message-State: AOAM533N2fPeXMyO3497bEW7RihNz6i+kVFCdvZn4pOHWvhXLyi/H/UE
        Z7PlOH4g+DnSBoThTwZVuuQ=
X-Google-Smtp-Source: ABdhPJzln1+x6pLrAR1E/Nx4ZxIZ05kkmFQFviqIF83/EDPpbo353mGUsi0fXxfLpfJwV7Dy8RaoIw==
X-Received: by 2002:a62:de05:0:b029:197:6c86:dfb3 with SMTP id h5-20020a62de050000b02901976c86dfb3mr7613065pfg.65.1605755633494;
        Wed, 18 Nov 2020 19:13:53 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z8sm26197671pfn.181.2020.11.18.19.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 19:13:52 -0800 (PST)
Subject: Re: [PATCH 06/11] net: dsa: microchip: ksz8795: use phy_port_cnt
 where possible
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kernel@pengutronix.de,
        matthias.schiffer@ew.tq-group.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-7-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9b49d9de-0b83-e30f-2e47-840f47c59549@gmail.com>
Date:   Wed, 18 Nov 2020 19:13:49 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118220357.22292-7-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 2:03 PM, Michael Grzeschik wrote:
> Since the driver can be used on more switches it needs
> to use flexible port count where ever possible.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
