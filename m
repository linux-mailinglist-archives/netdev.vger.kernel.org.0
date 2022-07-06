Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A084C56896D
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbiGFN3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbiGFN3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:29:50 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B14220F3;
        Wed,  6 Jul 2022 06:29:49 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id q8so6015897ljj.10;
        Wed, 06 Jul 2022 06:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iG3AipQilfKuzKYwYhwqMs5yIfTtS592Uv9tC2e+5zg=;
        b=OEUv/cFSDJM+foTCDim/T3cc3IZE2e/1ltzUcZlawkCnaiBFbRzC+OqKhW6rprzStm
         AgzNYb86PiwD+g9H7CweK556mPP+7LDddRqSZLIdLGF0qEatc31Ruh6RCW1o9pdn95GQ
         zdd5dfKxEv6nTUdHVbL2KuGX8G/zxP1uVeixydyr7+Dc8V0+9yQjcqPj0CPKbIPscr3o
         1K5GKaJlKrfF3LQyO1Sy/xC+CyqAuCXFj22kDzSNb/cmWxqzWCPPbYjJdkQ4PhXpOBip
         T8m+2GRUjcK9TWOhzJU0HawY3V47k6Hpj/sEyP1TuZ10BC+S/zFLzcyLlzMUM1/p52xu
         JOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iG3AipQilfKuzKYwYhwqMs5yIfTtS592Uv9tC2e+5zg=;
        b=1yNVOd3VkEVELacsasxP54CySCd4Yam+xXJIjKvXYtTv62fLlsLKtF4NNspUXe1Fbn
         x0z+SUd973jEa0dv9u4+twOIayQo8GtafTqT44g6ABtv6OANFzeZNBRDgq1EUcKvTypU
         a+pKnbX27mPhNlh6yivyyF5i96+cLqywrUSnFke0YwN4o1JKsON9FxTWO9jnYsCyPOIW
         xNw6nDGwt1FhwlybCYtrO45zJeUnPTG6mQgZF3zLuaQBmjWvnss8L+X6fwp2uQe7SDf7
         +psMtiojVtr7yk+NqMgHubOwoBfBLM9pBi2CJT5Chd4SU2NOlvMyxj6+BTd4JVjs8QhQ
         3aPA==
X-Gm-Message-State: AJIora/kVBytI7CSvM3vKQa1Zm3ed0vEO220a87PqBbppWXRAJ4dryEP
        SObIchtsF+950CQa5kqLoLg=
X-Google-Smtp-Source: AGRyM1s9JuaMX0+6/OvWmt4rbkwOyWZwEWNEGno5g4V0BLC1qKGGoMHtZJe1u80z+BZaZOYr40oEkA==
X-Received: by 2002:a2e:a901:0:b0:25d:244e:842c with SMTP id j1-20020a2ea901000000b0025d244e842cmr8562397ljq.406.1657114187213;
        Wed, 06 Jul 2022 06:29:47 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.63])
        by smtp.gmail.com with ESMTPSA id a1-20020a056512390100b00477c164293csm3281194lfu.79.2022.07.06.06.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 06:29:46 -0700 (PDT)
Message-ID: <12431b93-a614-0525-b581-01aa540748e6@gmail.com>
Date:   Wed, 6 Jul 2022 16:29:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3] net: ocelot: fix wrong time_after usage
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "clement.leger@bootlin.com" <clement.leger@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
References: <20220706105044.8071-1-paskripkin@gmail.com>
 <20220706131300.uontjopbdf72pwxy@skbuf>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220706131300.uontjopbdf72pwxy@skbuf>
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

Hi Vladimir,

Vladimir Oltean <vladimir.oltean@nxp.com> says:
> Can you please indent the arguments to the open bracket?
> 

Sure thing! I've just sent a v4.

Thank you for review



Thanks,
--Pavel Skripkin
