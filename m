Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93696C8839
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjCXWUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjCXWUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:20:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD744125AE;
        Fri, 24 Mar 2023 15:20:05 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o11so3167047ple.1;
        Fri, 24 Mar 2023 15:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679696405;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uw/mlldsPCKVj1OJnJvUTzXxJFdP/KcS+usue63idys=;
        b=mLy0S8Bwo+8G5DTEurknx/IfLwlVH8NPlT6r/HYfFhlta9SjHz6SlNGb69hnwxavU3
         iWbbzi0mDWZgb+XsykfhkhF0qA4wGRDnoJI7KlseHkUi+Wmneutmx+whQLEu083lsVKp
         Dq8cRObA/mkbgBSWqLPChEiq3acCyqjka5EgiCeNY1CjI/onV/7fnQB9O/WayE2TToJQ
         fUppuHe5xsVavy/KKGQfvzrHqfqKTkzDEGJli7gLWyIyeVqZmEcAYZrTIbmtsAKj9MCO
         7Y7i/Z/wfXlNnXpvDl7ELdseO3sswe6GyXq8kbXuy/8apMGuwKO0qneFmoMsyeTSKiTg
         e0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679696405;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uw/mlldsPCKVj1OJnJvUTzXxJFdP/KcS+usue63idys=;
        b=ABEJ5/LAdVmDKKKSeBkPv9Vmxm/dEIF+TtdoLEANuTWAowI7RdW5LFJiNqDJPNuyeo
         B1y6b6O5OOI0SM45UivWsMI19G43eyMNhhS5x16ji8mjEckVxsyveeCX6dICHAZyFua9
         Hs5h2fPCP5CJgUwaIJXWZEH+Rf7QiQjXjzhtySYYxuGmOqvkoAN4mdvSbGL79xydzudg
         0X1hTi8wcWvP1zFS4oDgKArOO5cw5X8ZDtxzT2LtKm3MCl9+RnIW75HScXjOSOuX3wPe
         4EVllo+vZE2EIiNSz7qprzroCQnV6NCKTLDAK8VU3FagUx0B69m/qBSrxGXMe+ikJCJs
         QLqw==
X-Gm-Message-State: AAQBX9fddCHDVk9cORN8A+RKcKsPtiz0PDfAGjhn8nQCWBJkJxfMVAOc
        TeTw02brUSb8ZgK93GtQVgE=
X-Google-Smtp-Source: AKy350ZYns4X4CH+1R80x9UNHytasL5irGo+Oh5YZswIWFeZEvkcZQzugCjIO4HzuhZRuWBYUmaK/g==
X-Received: by 2002:a17:903:2303:b0:19a:7f4b:3ef6 with SMTP id d3-20020a170903230300b0019a7f4b3ef6mr4788645plh.3.1679696405067;
        Fri, 24 Mar 2023 15:20:05 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id io20-20020a17090312d400b001a1faeac240sm4232394plb.186.2023.03.24.15.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 15:20:04 -0700 (PDT)
Message-ID: <f2f410bc-57f4-09b3-2d89-1991e52f9cb3@gmail.com>
Date:   Fri, 24 Mar 2023 15:19:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v2 2/6] net: dsa: microchip: ksz8: fix ksz8_fdb_dump()
 to extract all 1024 entries
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
References: <20230324080608.3428714-1-o.rempel@pengutronix.de>
 <20230324080608.3428714-3-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230324080608.3428714-3-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 01:06, Oleksij Rempel wrote:
> Current ksz8_fdb_dump() is able to extract only max 249 entries on
> the ksz8863/ksz8873 series of switches. This happened due to wrong
> bit mask and offset calculation.
> 
> This commit corrects the issue and allows for the complete extraction of
> all 1024 entries.
> 
> Fixes: 4b20a07e103f ("net: dsa: microchip: ksz8795: add support for ksz88xx chips")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

