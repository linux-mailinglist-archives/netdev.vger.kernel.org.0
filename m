Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680561E93AB
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgE3Un5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729297AbgE3Un4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:43:56 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FB3C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:43:54 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u26so9197667wmn.1
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=If+m7s5QT86zwGZwyEMq/bnMcdRM07dV/oFjIvy0mP8=;
        b=Bk8FUFM5MqSPNF+DRbnzsE17VkaDebGU1Z2NArX2fK6gOJ9++BPMrXoHqrtW2fxGlO
         z6S9iGQ02QEUxX490Q4FYL47kwmfoEme0HqcdYFVZrMb/RqeUwgOtrvSkygyLz4HE0RU
         HUrNZ7z+Kdd45APg0/O/cFFP5VMRVgFKHk6VRAoIEHmUeXhQAiJQlaKlHTkBdbRAINpj
         D/zdyaNpL3R9KxnlISWS8naOgCymuFh9Wa5of9u3ZGSbjpFn3B32gMPDspRIfZvLtjZb
         960awIG5jAT3Sa4FmF24C4Un+c7MgFqucrMGlLpMzKi9ny3DUG/CpeQyrg7I/tFj0yZK
         SL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=If+m7s5QT86zwGZwyEMq/bnMcdRM07dV/oFjIvy0mP8=;
        b=q4zQl1YF7wrCybSE2OuMX+C3oQtIH+Zz0pjevhpj8FYpdaMyKlvJMHdzJwXOwvQeof
         5FVyAEA5wFuG5wA0bNVG2yLtGpd66rBqDaU7wc1nOMByZbAYOE+/GuZ6nTi2nkqv2wzT
         ef20asIW2trhzm3vn3QVgrW9jHcTrE4u7nUwiNdsQnOsNpbLTl+XEtLf5lFbJcnCbQtE
         InXNDmmnWtWg0OVu/paA3Xn8H/sqBLHzRz8PdA3MRomMp1smoJhyK0NdyiVt2MVNIgJs
         oISOJqWevj8wtNNm5DiQk0N0nHaBHVeLEma4K1ble+jdhVzn2/0b8JD2LCMwqY3s6WlV
         ZgiA==
X-Gm-Message-State: AOAM531gFVLee5S9GGgqE6Wz6y3VWfSv+pZyAEHj7T41fr73RjvuMtjw
        VpHbKY1Z3yhELEGRLN6JprY=
X-Google-Smtp-Source: ABdhPJwA2CqPLWb8eAcDFjXQDGMZdHfGb0Q6OPmZd9AwfH3G68GoQWYghxTmF9APif9LH98ajVqRKw==
X-Received: by 2002:a1c:5a86:: with SMTP id o128mr14986910wmb.77.1590871433602;
        Sat, 30 May 2020 13:43:53 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id b18sm14486684wrn.88.2020.05.30.13.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 13:43:53 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 02/13] net: dsa: felix: set proper link speed
 in felix_phylink_mac_config
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2cfb7e23-cfe5-4a95-b52e-78e1697ddbfa@gmail.com>
Date:   Sat, 30 May 2020 13:43:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530115142.707415-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 4:51 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> state->speed holds a value of 10, 100, 1000 or 2500, but
> SYS_MAC_FC_CFG_FC_LINK_SPEE and DEV_CLOCK_CFG_LINK_SPEED expect a value
> in the range 0, 1, 2 or 3.
> 
> Even truncated to 2 bits, we are still writing incorrect values to the
> registers, but for some reason Felix still works.
> 
> On Seville (which we're introducing now), however, we need to set
> correct values for the link speed into the MAC registers. Do that now.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
