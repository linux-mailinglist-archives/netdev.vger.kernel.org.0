Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46284473C02
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 05:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhLNEeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 23:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhLNEeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 23:34:11 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0688C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 20:34:11 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso15088501pjl.3
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 20:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XSA2SJggC9/slMH5/oQwEY85NgRQL6FYKWVw3WL8Ius=;
        b=g+UbB151yw+bbvL9GDhSgpDOy6pkoasurQziqclVVNOVqbOQiiDCavG9RiRisAaa8z
         RA6Y+1o9n9jjW8eDZJLHNLSxHUC1bJxEiqSBHjhJqU0fA/0lR7LsjHv3UkgxleLgTvp4
         U0ca+t9wh0p3t+mtdqXlLGwVZwsu6k43Oo+2+vkRlE+BitMhBAxsXAsBv8Dw5EPAmjIL
         gbUfacFHBC4SSYpjVyrQGrg3d3wF4HdD+/Yv9mO3Q/a39xdYn77G4TjlWWsPlZs/lWCU
         RVCtsC0yZI/mkec4R3SmGa70vDOkzx5fNLZViBWv30io/xjE+oTGFQDeDlF2fgEmb8HV
         JoTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XSA2SJggC9/slMH5/oQwEY85NgRQL6FYKWVw3WL8Ius=;
        b=CWkyHA9cUFytyyFphnUZwnvjHJfrl4l71Cs4OMX/M+V7OB1CQc4Mktffz+GQcFGEGg
         taPuXXUjKJivLIyLlE4O+oS3DDe9L/nGD8+zIm6xXastwihkpQZeVKkHIrlGMkft/fV8
         b7zQh0ivBqjmcEmEd8mZlt4vqWz1Fxi74p2OvbIvXE3An2kUO5/X1qoJQzoz9DrM/nt3
         6rCPJ9S1wCpZ01Sboh59RM+/ErF8YwQEzOy5WLvdZYSfhvWNVY27r5USikj/XcYutQp2
         J22xhfloZZ5B+mRGQPC1/xEPK8Odt+s0hUojdypGQr0HLazfgthI2O0MDq8uQqZkmJSk
         /uhg==
X-Gm-Message-State: AOAM5321GQC1SdyOfLxzNi1BkTCy3V+aobCuLPJWKKM6W/rdyhQuiHnd
        Fzxtku5MiiVBqEGLOuFIDog=
X-Google-Smtp-Source: ABdhPJwZtkGLHlhq+aii/HY2Gp3jQkRSm+ykNzIXfBI2g9HKPj/igJAFIHYy/02lvU3wxQkOiBx+zw==
X-Received: by 2002:a17:90b:3e84:: with SMTP id rj4mr2956473pjb.199.1639456451181;
        Mon, 13 Dec 2021 20:34:11 -0800 (PST)
Received: from [192.168.2.179] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s24sm13407462pfm.100.2021.12.13.20.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 20:34:10 -0800 (PST)
Message-ID: <bd159d52-a86a-4ef2-0640-b2766f63d3f6@gmail.com>
Date:   Mon, 13 Dec 2021 20:34:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next 1/3] net: dsa: tag_sja1105: fix zeroization of
 ds->priv on tag proto disconnect
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
References: <20211214014536.2715578-1-vladimir.oltean@nxp.com>
 <20211214014536.2715578-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211214014536.2715578-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/13/2021 5:45 PM, Vladimir Oltean wrote:
> The method was meant to zeroize ds->tagger_data but got the wrong
> pointer. Fix this.
> 
> Fixes: c79e84866d2a ("net: dsa: tag_sja1105: convert to tagger-owned data")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
