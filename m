Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A006055E864
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346851AbiF1Op4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240816AbiF1Opz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:45:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4B62E6A6;
        Tue, 28 Jun 2022 07:45:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id w19-20020a17090a8a1300b001ec79064d8dso16166726pjn.2;
        Tue, 28 Jun 2022 07:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=C2TU20f4wyf+zfFLwfO6epS0rxwd11FopiHGQ1fLJg0=;
        b=Qbk41NY+109uhYB0wE2Vp9QhBtBKgM28fP5hp2db400M31o0U2JNe04q/578gXbzmC
         H7FB0pW50UtrLqOcthINdYew44afyKK0FyL5bTDtuhcvECfHT4Owex35U70tq0XO7pDB
         KBGxa/5jTZHaXCJ9PYO/+kt54KqhQJOOIH7jQ/w3t5iA5oySbw+qFiw8TOWIjSnxBy2g
         zq4tC7yXWT4kwWSvm8uK1ztLdu8gNQ88yM26qaac76k6GqUMF1e5sN10b1DSbk131PPq
         McMfFYsTzKdWukS4Nsri0JJ9siX3ZoLkbvpHNc1Sfu1SslHwAaqKdReuLHjN0CbeJyK7
         FWFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C2TU20f4wyf+zfFLwfO6epS0rxwd11FopiHGQ1fLJg0=;
        b=RhGcEhFYcf12Ldpzm23xCNBUlm0VnWBAkXr1ChCuku/2HAkZfhnrju67tdQw85WM3l
         i8YI5QZVHfv0ITds+M6ZYTHFVZR45XdR6TmWX1OK9c2mgpYSj3jLPINAwl+O68qdUuVa
         0+fyEzgYiajpQ40GRGJewa9fPnKK0e9PE+ukLoga4xJ+8I8093TusBrRPsFssRZwfwhK
         zA5ECQcGK8r2WcT3Hy2O3Zr9OW7e4e1MhEfvTXQgOqQa1LC8AzxAn6l2NJPr2ehyksTb
         N/izD+/XuD4IiR1cES7sHKZVg+GL7iQ+fuaugLdNkXiEKW+2e8yZ0N1DgHtBEA0/vsGC
         +dJQ==
X-Gm-Message-State: AJIora+tz4VIY5jGz6p8HU98JNOqrTirrdZGetkn71Rf7BVwiy7/we4x
        fUW96L14f+nPsg6J9wddzkw=
X-Google-Smtp-Source: AGRyM1vV84aJuh8gGSEdhBSzQNEe3Hud6oMcLzucjqsa5H4gWdc/CaYL7BIILLS7iOowABQZ/gB9xg==
X-Received: by 2002:a17:903:2452:b0:16a:3b58:48fd with SMTP id l18-20020a170903245200b0016a3b5848fdmr5288887pls.67.1656427554722;
        Tue, 28 Jun 2022 07:45:54 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c569:fa46:5b43:1b1e? ([2600:8802:b00:4a48:c569:fa46:5b43:1b1e])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902680600b00163ffe73300sm9386192plk.137.2022.06.28.07.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 07:45:54 -0700 (PDT)
Message-ID: <b43dde07-84da-c0a2-2aef-163cdbfecf26@gmail.com>
Date:   Tue, 28 Jun 2022 07:45:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2 1/4] net: dsa: add get_pause_stats support
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        UNGLinuxDriver@microchip.com
References: <20220628085155.2591201-1-o.rempel@pengutronix.de>
 <20220628085155.2591201-2-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220628085155.2591201-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/2022 1:51 AM, Oleksij Rempel wrote:
> Add support for pause stats
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
