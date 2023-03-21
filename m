Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051BA6C2DA7
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 10:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjCUJKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 05:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCUJKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 05:10:40 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFB33A85;
        Tue, 21 Mar 2023 02:10:34 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id y5so16210373ybu.3;
        Tue, 21 Mar 2023 02:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679389833;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1naR9VgFK/CRVn0pFs+TG3gFfORX42gFmCzJOm4FT5s=;
        b=V2Hsq91CBcj4Sq2XpdLP0d+BTsMhf+dNqrqpprgcBXsX0it8vNwpXGu7UNT6VsEuTI
         sP67h+uE9ZU+u0xoG3jSFqKnVitOvgV2hdp3SW2n1dAGMgnojlwsYnwoSy+gUPuXe+Dk
         csvSg+SUgnQk0Ke74bSJQem1BJ5rfHnElRTHxfn4CtNMw8yJgRHqsClNRPsc5+Rq+Ctz
         FVd7uQceqsWlMWkbHoyOLIKBZGgZojBfZD8lyqAjRD60pf5BHQkev6uSA8SHXbIBOGs6
         68ee7fGEZRGpKtgthPFXNuzjv4RooTIpObj3ubzuLDdCH5NduRkinqDvkOJovssx3pqU
         +6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679389833;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1naR9VgFK/CRVn0pFs+TG3gFfORX42gFmCzJOm4FT5s=;
        b=xtg8f2V672rWYcNq3Qp03rErUx3/cYS0FGV6j9gZc2nHe/q1PiVUt9x+34SdoebtVr
         4t6UgNcrgIKj38p8DoYLe6+qub79pBz1uQ8nK9sU5SJTapYN1GDvVHetPpzflCz8kqSI
         5vn7jBjLmy4v36d3StIWegdYW03BCOzC3OTtjgtdIHTC0NQ31C7PoinE120aZmjVFPKt
         oyijK89kjIngr0EWuynCe5f79enaltnOaGGHg5K2HzKc2MUKQd2w9hfmesamne+8eRum
         ey0b5X22NNaWeT/q/MyRzdRrIdQ7yYvLCaz5nrXHGkK3SxW5rRru89uhheDQ7aEAxaO8
         j3lQ==
X-Gm-Message-State: AAQBX9c4O/QwZAY0qUhE9Y3y7aCrnCiAfMHoSyH0avs9BQD2Cfn0o6cl
        hkXmFughugu6ZrwKOmA/5pM8PK5R7j3QR7ga+Ew=
X-Google-Smtp-Source: AKy350bOGXAX9HSyWlXVprdERaGHVsqXcSIgyEknmRaBkIwQ672kz9f6VJHLNkM+gCa0jBu6dbTnqzx8D9FgrAh9cZU=
X-Received: by 2002:a25:8c89:0:b0:b6c:2d28:b3e7 with SMTP id
 m9-20020a258c89000000b00b6c2d28b3e7mr886226ybl.9.1679389833380; Tue, 21 Mar
 2023 02:10:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:199d:b0:490:be1c:c35a with HTTP; Tue, 21 Mar 2023
 02:10:33 -0700 (PDT)
In-Reply-To: <6f7e9b8c-6256-e7dd-b130-8e1429610faa@gmail.com>
References: <20230320155024.164523-1-noltari@gmail.com> <20230320155024.164523-5-noltari@gmail.com>
 <6f7e9b8c-6256-e7dd-b130-8e1429610faa@gmail.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Tue, 21 Mar 2023 10:10:33 +0100
Message-ID: <CAKR-sGcB-GgeRe=7_WYffQmppmzZTweRrxL848MG=_LMUuMedw@mail.gmail.com>
Subject: Re: [PATCH 4/4] net: dsa: b53: add BCM63268 RGMII configuration
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     andrew@lunn.ch, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Excuse me for my previous email in HTML, but I forgot Android Gmail
app uses HTML)

2023-03-20 21:00 GMT+01:00, Florian Fainelli <f.fainelli@gmail.com>:
> On 3/20/23 08:50, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
>> BCM63268 requires special RGMII configuration to work.
>>
>> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
>> ---
>>   drivers/net/dsa/b53/b53_common.c | 6 +++++-
>>   drivers/net/dsa/b53/b53_regs.h   | 1 +
>>   2 files changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/dsa/b53/b53_common.c
>> b/drivers/net/dsa/b53/b53_common.c
>> index 6e212f6f1cb9..d0a22c8a55c9 100644
>> --- a/drivers/net/dsa/b53/b53_common.c
>> +++ b/drivers/net/dsa/b53/b53_common.c
>> @@ -1240,8 +1240,12 @@ static void b53_adjust_63xx_rgmii(struct dsa_swit=
ch
>> *ds, int port,
>>   		break;
>>   	}
>>
>> -	if (port !=3D dev->imp_port)
>> +	if (port !=3D dev->imp_port) {
>> +		if (is63268(dev))
>> +			rgmii_ctrl |=3D RGMII_CTRL_MII_OVERRIDE;
>
> AFAICT the override bit is defined and valid for both 63268 and 6318,

Should we add a specific ID for the 6318?
I don't know if it's different enough from the 63268 to need a special
treatment such as is6318()...

> essentially whenever more than one RGMII control register for port 4,
> but also for other ports, it seems like the bit becomes valid. The
> comment I have says that the override bit ensures that what is populated
> in bits 5:4 which is the actual RGMII interface mode is applied. That
> mode can be one of:
>
> 0b00: RGMII mode
> 0b01: MII mode
> 0b10: RVMII mode
> 0b11: GMII mode

This is interesting since we never set those bits in the bcm63xx
enetsw controller...
Should we add configuration for those bits in future patches?
Which SoCs hace those bits? Only 6318 and 63268 or every 63xx has them?

>
> even though this is not documented as such, I suspect that the override
> bit does not only set the mode, but also ensures that the delays are
> also applied.
>
> Once you update patch 3, this LGTM and you may add:
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>
> For your v2. Thanks!
> --
> Florian
>
>

--
=C3=81lvaro
