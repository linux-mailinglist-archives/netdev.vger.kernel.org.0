Return-Path: <netdev+bounces-8527-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2B5724754
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:11:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93C8F280FCC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E75F02A9CD;
	Tue,  6 Jun 2023 15:11:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBCE37B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:11:37 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFBBE40;
	Tue,  6 Jun 2023 08:11:30 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f7353993cbso23937115e9.0;
        Tue, 06 Jun 2023 08:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686064289; x=1688656289;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fCd3lkwQUjAtQAbzUB28HjKPWXHFoc2L/9jgru84Ov0=;
        b=ish0zYwfcnWBf23xCA7LmIgG4NTvS7zwkirPatfbITtkHga5J2dnUELsXYRmHw0hBK
         2yPxou7r4G8wvcn8AR4AyXg+7jdpQBAemLF0oJCAhgyfqkAzU9XbDmR/85SxX/z2Yu5b
         cliNfhOvw2b42Wl5gHv75Ld69bHmzetlxrL47ffbcjjlsy2IbAdK1AX5V2ERve3MCx+5
         7OBjY/tNIlVjhAu/YnqWiVEgSp0jMPOJqi6HEoMxfrcqUVFn7bAcWr55PpJHLqXYRHcm
         AtnPEMnI9zN3rABTomPwziKyxWMqDZrEAg5p04xZSzUXONqtjhuOqX8WlVneJAOjZ9uE
         LejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686064289; x=1688656289;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fCd3lkwQUjAtQAbzUB28HjKPWXHFoc2L/9jgru84Ov0=;
        b=Bqjt3DQryeo5TeR4OuMrS6gUJHt5mbsYVHPbpI3DRK+QBTTqu0AyTXpC3JdXTdQ7ua
         iNEfe17CUhwX6FalKeW1S/nW2Wo/0soQ84pYukbU6af72K5nODp/F7gl5h76F7rZqyf5
         MUMhVvWXTnJdtad7bKRADB24JN4aElJXRDHbahMOKnp+zvGVDZFJve+9h+QucaRFqSkb
         fJ3PJ5e0MnIuHQ1+JAv1BQa/LBib4BNGX7FXdrvjsTeKgdX+lfOiP3XoaVHc0OcMvzh8
         WXCK3/0bU0ExIEseteWi+4vKNtgGGucPT8XnQZwSqUAyWHWuw9XgFQOCOpWxn40WlO99
         UKIg==
X-Gm-Message-State: AC+VfDyrhcFb4Zy2wQwm1kT/HQg14LN47I/nv/OYpgL2sqU8iH8lRyes
	QpBq1SemmwdMt70PmNhWMn8=
X-Google-Smtp-Source: ACHHUZ7kQjKHWOPBn6JXoALqEPZQHEH2+LHU26Wrp2SsYPhNJLZsybqPxUZc7kMF/pLrl02otLjVKA==
X-Received: by 2002:a7b:c3d4:0:b0:3f4:1ce0:a606 with SMTP id t20-20020a7bc3d4000000b003f41ce0a606mr2131867wmj.1.1686064288726;
        Tue, 06 Jun 2023 08:11:28 -0700 (PDT)
Received: from ?IPV6:2a01:c22:6ea0:1800:989b:ff6a:75e0:288d? (dynamic-2a01-0c22-6ea0-1800-989b-ff6a-75e0-288d.c22.pool.telefonica.de. [2a01:c22:6ea0:1800:989b:ff6a:75e0:288d])
        by smtp.googlemail.com with ESMTPSA id m14-20020a7bcb8e000000b003f7ba52eeccsm6762911wmi.7.2023.06.06.08.11.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 08:11:28 -0700 (PDT)
Message-ID: <7aa7af7f-7d27-02bf-bfa8-3551d5551d61@gmail.com>
Date: Tue, 6 Jun 2023 17:11:27 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Content-Language: en-US
To: Patrick Thompson <ptf@google.com>, LKML <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, nic_swsd@realtek.com
References: <20230606140041.3244713-1-ptf@google.com>
 <CAJs+hrHAz17Kvr=9e2FR+R=qZK1TyhpMyHKzSKO9k8fidHhTsA@mail.gmail.com>
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] r8169: Disable multicast filter for RTL_GIGA_MAC_VER_46
In-Reply-To: <CAJs+hrHAz17Kvr=9e2FR+R=qZK1TyhpMyHKzSKO9k8fidHhTsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06.06.2023 16:15, Patrick Thompson wrote:
> For added context I came across this issue on this realtek adapter:
> 10ec:8168:103c:8267. The device erroneously filters multicast packets
> that I can see with other adapters using the same netdev settings.
> 
> 
> On Tue, Jun 6, 2023 at 10:00 AM Patrick Thompson <ptf@google.com> wrote:
>>
>> MAC_VER_46 ethernet adapters fail to detect IPv6 multicast packets
>> unless allmulti is enabled. Add exception for VER_46 in the same way
>> VER_35 has an exception.
>>
>> Signed-off-by: Patrick Thompson <ptf@google.com>
>> ---
>>
>>  drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 4b19803a7dd01..96245e96ee507 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -2583,7 +2583,8 @@ static void rtl_set_rx_mode(struct net_device *dev)
>>                 rx_mode |= AcceptAllPhys;
>>         } else if (netdev_mc_count(dev) > MC_FILTER_LIMIT ||
>>                    dev->flags & IFF_ALLMULTI ||
>> -                  tp->mac_version == RTL_GIGA_MAC_VER_35) {
>> +                  tp->mac_version == RTL_GIGA_MAC_VER_35 ||
>> +                  tp->mac_version == RTL_GIGA_MAC_VER_46) {
>>                 /* accept all multicasts */
>>         } else if (netdev_mc_empty(dev)) {
>>                 rx_mode &= ~AcceptMulticast;
>> --
>> 2.41.0.rc0.172.g3f132b7071-goog
>>

Thanks for the report and the patch. I just asked a contact in Realtek
whether more chip versions may be affected. Then the patch should be
extended accordingly. Let's wait few days for a response.

I think we should make this a fix. Add the following as Fixes tag
and annotate the patch as "net" (see netdev FAQ).

6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")


