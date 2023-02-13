Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A0D694A71
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBMPKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjBMPK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:10:29 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD951E5E6;
        Mon, 13 Feb 2023 07:10:19 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id bt8so7529283edb.12;
        Mon, 13 Feb 2023 07:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g+6NiBwrzMzY0iFEj5SAkgnlwVcJ6rcWHigS8pEBF38=;
        b=ZfieTwOr+sqn+dobtezHop/Fmo/rAXS7NAUx17hb6ZFQ5lExV/uPWzDbSekJbgGzh1
         yzM0lucIFOolljnvXTuxvddj2Kx73gj+Zg7wwniJwgUAsumoATRyJkS2l4z/DXexakZK
         VaRndjH8zowNttv0SiX+3eEsf0dzhhqHfVv6ThsyWaPUd4b2NkLcVKo+BJw+zb8RHcQw
         TaAqG0phoMsaEeUkztCN5Dw5QsIRQjyG3PvGAt7fqFLWRmxh3ZW8IGf+WTs4zejlZtYv
         g1N7fID74/I9rvNKTMVugbhaUdLt1LVMwy5ZrnYrlPyxcXvwoGse0ePgm9iJlh2C3sM0
         2Wfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g+6NiBwrzMzY0iFEj5SAkgnlwVcJ6rcWHigS8pEBF38=;
        b=CKwkO5QGcrok7pvu+kaVxpBbW5M9VtKW2NTXXKJ9/S7VWLyCuDAm49ZWYGKg1buHwx
         ZESZVVR+ZhIzsJSWhfp5GKryCS/2kjppDYjveJ7k5hUXi1VT4RPSQmoansrcoj8NOS3l
         8bOH6TL+xqxrBcGoBdrPDniZzxwx8zuigxRC9o6/5q68FP2Zr9Ja0H8u4tSrpND9kdpi
         nXPXuMEKA4xM3n0/3epherkvdC4n50sDSj9HpoFinbwHUY7fWoUCQBloVm+sKr4GIucT
         NU8Gc5l7I9mVLd08g9vUulVJiQJL6ijvQ7DW50UjSJNPDMpcjU/O59hbdrmiR1aWFPpz
         SWFw==
X-Gm-Message-State: AO0yUKUDmVz70NT7wVG1gvZyoAyZN37aMMC1nhIlYq1oza2dpuosEg4y
        vW1KU8ofp+l/yZTbtpedOyY=
X-Google-Smtp-Source: AK7set8dTFfz1dPwGhl7i63pU30D2uHBEKusrO2akXLuxI/IZLMqDbz8FAEr1pKDGkrrvDaYZgrjWg==
X-Received: by 2002:a50:d601:0:b0:4ac:bce7:370e with SMTP id x1-20020a50d601000000b004acbce7370emr7674377edi.14.1676301018078;
        Mon, 13 Feb 2023 07:10:18 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id g22-20020a170906199600b0087bd629e9e4sm6924576ejd.179.2023.02.13.07.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 07:10:17 -0800 (PST)
Date:   Mon, 13 Feb 2023 17:10:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard van Schagen <richard@routerhints.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Arinc Unal <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next v2] net: dsa: mt7530: add support for changing
 DSA master
Message-ID: <20230213151015.pstwqpcpjk7vr4xq@skbuf>
References: <20230211184101.651462-1-richard@routerhints.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230211184101.651462-1-richard@routerhints.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 11, 2023 at 07:41:01PM +0100, Richard van Schagen wrote:
> Add support for changing the master of a port on the MT7530 DSA subdriver.
> 
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Richard van Schagen <richard@routerhints.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Currently with this driver, the only way for a frame to reach the CPU is
via flooding. The DSA framework can do better: it can configure the driver
to only accept certain whitelisted MAC addresses, which reduces unwanted
traffic to the CPU. But it needs driver level support for some prerequisites,
namely FDB isolation, se see dsa_switch_supports_uc_filtering() and
dsa_switch_supports_mc_filtering().

If somebody decides to add support for RX filtering later to the mt7530 driver,
he might not have access to a setup with multiple CPU ports. So this
might become a blocking issue for him.

Would it make more sense to unlock RX filtering for the mt7530 driver
now, and to make the FDB entries added on the CPU ports work when
multiple CPU ports exist, too? Now seems like the most logical moment to
do that, not later.
