Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A605A566F7B
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 15:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiGENkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 09:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGENkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 09:40:20 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2638B9FE03;
        Tue,  5 Jul 2022 06:01:27 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id h23so21446499ejj.12;
        Tue, 05 Jul 2022 06:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uXbdRIl5DzPqCBpkjfmAYzOPOvQhWBeO3fgrDd46Stc=;
        b=RSLvcXnZdh41tMK3A2h1Y+CAwnI5xlcprV5yeyh/tOU6V7KGfWqaaXJk3fHHk4AViG
         9/pmvB50xQzC35QJyyu75tLydGjD/0lxmjTLuKk0gvBBXsM7grav0+KBve22d9wIY28c
         MedTuHfMaMky6Gz5fpIYanN3scLauCwM4VlfQaCbBwb1uctqn7OoPESE1gNQLyOgdio4
         jdmvr39SGgo1c6GTsL6Z7p2/BvAays06D1r55mCrMs8k6zjbDNNCmul+Ai55AArRRAdn
         Ba9dYvYVBmBA3WumR6Xk4VIQIenn7pzEspXlLgAx53kExAWYYi0hBVgzHs10xjzOrVSc
         R6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uXbdRIl5DzPqCBpkjfmAYzOPOvQhWBeO3fgrDd46Stc=;
        b=bGIcIf7cI/3+aC/ECUzSoKNbQVRGnVn12tM0uNQzykCl9eCxrbMM2SoSGnTsVLO0yh
         O3spEfMuF631xVHRCDnoQ2vpHsTgWs2HOEFm91FQZ+4Rdh+bNcdjQPHVg2H2Ny+2tMsi
         7TbJh5alDnv2Ai08z+w9mElgX8aMHVEKMLcyjvlbwlr9W8NEHqWwNnBWp35s2zxR9g0F
         DL0lMU/pnE3F10xxMgKEqDLgDzbkVhE84Lsf+tODv6fybPyVoeORzsDuJh5h2MqQ8Ax1
         B5IwC3wg/JucunJ8WBUx4bMhbskf6lfE1VvbmfKh2/y90btHXt/24jVlFyepsxdGiyDV
         AeSg==
X-Gm-Message-State: AJIora/t1acQT8efZETR/ec65ZNNQZQ0DFa7EVA3xJhQscQ0GimSQH3a
        b3sb4CNJylCJfilejxgOSzU=
X-Google-Smtp-Source: AGRyM1tyXt75C0imlO+ODXhX4VOUWgsDA8ADYBrg8+NFoNxS3ufFXHp7GbNPqFefRLS3p1AKYawfBg==
X-Received: by 2002:a17:907:60cc:b0:722:e564:eb11 with SMTP id hv12-20020a17090760cc00b00722e564eb11mr33325255ejc.736.1657026086139;
        Tue, 05 Jul 2022 06:01:26 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:8f3:2ee8:92a4:9ada? ([2a04:241e:502:a09c:8f3:2ee8:92a4:9ada])
        by smtp.gmail.com with ESMTPSA id p5-20020a17090653c500b00722e8c47cc9sm8072612ejo.181.2022.07.05.06.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 06:01:25 -0700 (PDT)
Message-ID: <324c9844-1ecb-60c0-c976-16627dff1815@gmail.com>
Date:   Tue, 5 Jul 2022 16:01:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: Shrink sock.sk_err sk_err_soft to u16 from int
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Joanne Koong <joannelkoong@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <74c6f54cd3869258f4c83b46d9e5b95f7f0dab4b.1656878516.git.cdleonard@gmail.com>
 <248071bc915140d8c58669b288c15c731407fa76.camel@redhat.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <248071bc915140d8c58669b288c15c731407fa76.camel@redhat.com>
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

On 7/5/22 13:31, Paolo Abeni wrote:
> On Sun, 2022-07-03 at 23:06 +0300, Leonard Crestez wrote:
>> These fields hold positive errno values which are limited by
>> ERRNO_MAX=4095 so 16 bits is more than enough.
>>
>> They are also always positive; setting them to a negative errno value
>> can result in falsely reporting a successful read/write of incorrect
>> size.
>>
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>> ---
>>   include/net/sock.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> I ran some relatively complex tests without noticing issues but some corner
>> case where this breaks might exist.
> 
> Could you please explain in length the rationale behind this change?
> 
> Note that this additionally changes the struct sock binary layout,
> which in turn in quite relevant for high speed data transfer.

The rationale is that shrinking structs is almost always better. I know 
that due to various roundings it likely won't actually impact memory 
consumption unless accumulated with other size reductions.

These sk_err fields don't seem to be in a particularly "hot" area so I 
don't think it will impact performance.

My expectation is that after a socket error is reported the socket will 
likely be closed so that there will be very few writes to this field.

--
Regards,
Leonard
