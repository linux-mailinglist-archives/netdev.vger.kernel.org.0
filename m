Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A7E350FB
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfFDUcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:32:20 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38461 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfFDUcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:32:19 -0400
Received: by mail-pl1-f196.google.com with SMTP id f97so8807309plb.5;
        Tue, 04 Jun 2019 13:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xLHsidjC5TLzbHioLfQ/skWWJtGlKTXo0ay/yNwMEDo=;
        b=awN7mKbeTcY9AsQ8syaHantastQxe52wkpM2tURdsXS/KSq1nrBHZQlSxjo3nrFO3+
         RpgC9UHJ2884dsRAYswNHhjftonjqzU2NbQB0DI+W56XMMU4vjIddip6gwoQqYzHfZMG
         lbhmf1W3uokioh7ji+Thc8qDRU4X9lv4aTPNjGoXY+TBWXxB+G3sxZylJlmkfHerTijA
         cMWXmGptey2qU3G1sS+xPH2UM85/+g0OQGG2+a9vf8i0l5jmQew76xqqWCcy+PfAapSa
         nmGla4Lr2h4aw57qVsCQqSkfYz7kE2fx6saPklMmCo8GujSvcths+i7H+RZA6GaUWjMp
         cmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xLHsidjC5TLzbHioLfQ/skWWJtGlKTXo0ay/yNwMEDo=;
        b=Mev3omk1u3NNhCKrDB8yJRRTPDJHvAmoyeGAvoZ4AH/9FKWs6ITCk72knmPMGBgYuR
         FIH/qKJMLpJmBZJi4+i3E2R2UMLMwyddxLtWSxZDq5vYDi0cyHTvHEzOxh9hS42GgqEW
         IlhxAubfcX0e2qwAgOHpN5qucc+DJZNiol01re5lrSiBqXR3/aIoIAfn0nbsZkS5QDe9
         3PYXxaF3seCJQE8JJwlgjNw5WEZjhnze8CrAjF852gwaqHzoq4iIHeV0m0pUhETwOV9Q
         tQ70nYUuCHXbd6sZuueb2I7vCa4NsYksNuXa8tUWC2zAvnlJMdtyxmVaIiEAlJk7a51N
         l6mQ==
X-Gm-Message-State: APjAAAU/SMU7z+CkDJ8RLIld/8aqCr78pqR+LwM64UjutkACdiIqVrgn
        4ZTAheDS6Ik1s1GJUj19FIJLoF1+
X-Google-Smtp-Source: APXvYqyvIJjRbt1Sc1EJ9hgbD7h4lVdmDsmmzUZTgZFnWuNV2Z6CMyTE2wUNQuX+HUsMvSoKMUrErA==
X-Received: by 2002:a17:902:7e0e:: with SMTP id b14mr13632906plm.257.1559680338779;
        Tue, 04 Jun 2019 13:32:18 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id t18sm17751967pgm.69.2019.06.04.13.32.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 13:32:18 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 02/17] net: dsa: Add teardown callback for
 drivers
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20190604170756.14338-1-olteanv@gmail.com>
 <20190604170756.14338-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <8de3b62d-bb60-fb00-4c03-022b209729d6@gmail.com>
Date:   Tue, 4 Jun 2019 13:32:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190604170756.14338-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2019 10:07 AM, Vladimir Oltean wrote:
> This is helpful for e.g. draining per-driver (not per-port) tagger
> queues.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
