Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A3A55CDD9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbiF0OqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 10:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237514AbiF0OqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 10:46:16 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6E3DF65;
        Mon, 27 Jun 2022 07:46:14 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i18so17029262lfu.8;
        Mon, 27 Jun 2022 07:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LUcZmkTGR5Hh6C+2kCtH4XekfuDCWDdiu6aLWv9Bsvc=;
        b=bsPG5e6pSA54rPqXT/iG2JQkmpub79669Ga7QL7JTWZMGl9RnNaHE8Jeonlpw/N9+x
         zKu7VxfkFdEDaC8YdNx165AUkCsKJ23tmjMePbt814goc5Sj/GbwIpsfUfkNupx29Zo0
         u+QI/m8Ejf5qNPjjprjSvoixrfmEcLhdyA8f9xGz2W9lAhu6NsXhYFm22t0Kscu8WKzM
         rMMN5hE72xUJN4GBMyhG7ZBzVkC2XJ0WfOXCHtBEFtqlZTHR4PPL5g8/ZsaNWoFE4Dza
         UIAnVrGZsdr8o3RZZS30SQPKbjmC1jORZ5DRQdLwErj+ORRpJ44plrdGgRyQdnYUPTMm
         oeOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LUcZmkTGR5Hh6C+2kCtH4XekfuDCWDdiu6aLWv9Bsvc=;
        b=OeP9l3EH4CjFCkTfLN8Bf+nE1yIyA5r4E+Fvqt2IyH3/LTQ5rxMDHkf5UQcHdAAZwR
         j/2GFjsS4iEOhMnGKkT32J+AoDhr4mhs2yfAPHFjDvFWAPUJM60Pw5FfzuLT2hWSOfp+
         fc1qa3hRsrkWhM6XRmmviH/XKgx5qSRuBr3vhvJaRr/InAjlT4+pj3NSIYnA1dzr3w+y
         KNg9WlDUB/42oCStvt6ko2yPHtExxbB8BjmpSVX7oZCJSgifEqy+E7tydQy6+w1mhxCN
         8MJY6gf0NZLa0wOalTE0ZWpMEmAVVwlDgPd9k57CC998pShazQzFMo0ol5kMNt4fLY/M
         1beA==
X-Gm-Message-State: AJIora/DFKN+nWd+irRlna3lLsO4dI5ZlRXgvuVIjBr0Ey84WYmAEWjF
        ZqihKBDflUnwoZozk2Yw9L0=
X-Google-Smtp-Source: AGRyM1tEjNUY1M3nmtsa+tlN070CxCzLPFktJ7wQV4c4x+FiWp+SfX/XIX/XRE1+28iHiBZzkjw0vg==
X-Received: by 2002:a05:6512:3e16:b0:47f:9d6d:c7e3 with SMTP id i22-20020a0565123e1600b0047f9d6dc7e3mr9221730lfv.393.1656341172695;
        Mon, 27 Jun 2022 07:46:12 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.63])
        by smtp.gmail.com with ESMTPSA id c2-20020ac25f62000000b00478f3fe716asm1828735lfc.200.2022.06.27.07.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 07:46:11 -0700 (PDT)
Message-ID: <4d08b849-3e79-7c82-803c-51c251344c7a@gmail.com>
Date:   Mon, 27 Jun 2022 17:46:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] net: ocelot: fix wrong time_after usage
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <YoeMW+/KGk8VpbED@lunn.ch>
 <20220520213115.7832-1-paskripkin@gmail.com> <YojvUsJ090H/wfEk@lunn.ch>
 <20220521162108.bact3sn4z2yuysdt@skbuf> <20220624171429.4b3f7c0a@fixe.home>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220624171429.4b3f7c0a@fixe.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/22 18:14, Clément Léger wrote:
> So I actually tested and added logging to see if the CH_SAFE
> register bits are set for the channel on the first iteration. From
> what I could test (iperf3 with huge/non huge packets, TCP/UDP), it
> always return true on the first try. So since I think Pavel solution
> is ok to go with.
> 
> However, since ocelot_fdma_wait_chan_safe() is also called in the napi
> poll function of this driver, I don't think sleeping is allowed (softirq
> context) and thus I would suggest using the readx_poll_timeout_atomic()
> function instead.
> 
> Regarding the delay to wait between each read, I don't have any
> information about that possible value, the datasheet only says "wait
> for the bit to be set" so I guess we'll have to live with an
> approximate value.
> 

Thank you for testing!

I will update update v3 with _atomic variant



Thanks,
--Pavel Skripkin
