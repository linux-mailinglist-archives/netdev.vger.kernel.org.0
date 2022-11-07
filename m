Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E4261FA7B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiKGQup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiKGQuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:50:25 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AF92253B
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 08:50:18 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id u11so17194903ljk.6
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 08:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=cc:to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GgzzWqrBpFMjyv/cMeIb5f7bPeTWAWqiSMHL1sdKRZ4=;
        b=huYNwGsDAALHfmyw7HfLONQCj8S0phBsrkDf8EQHhijiBMn8rTTrlzY5Yd/Klh7rR7
         htqkTwXoCeL8SGAq2ZlB/sn9Ma+FY4frUZtCCCIxENbLksp92tJHfllGjmGT31SIKows
         2Q67ivT6/OuTKMmB7x/Rab9Wo9Y6hiTwp1VRfPAgED+NCLCEVL0WtDbyhMKxH+6nqnlk
         +TA1DVN7ruq0c1LOz6MLw+UmSC7HDY2AOTwHcxcuvPulTyChfF+oK6xyXb0MRfafwSqU
         3j7uLEOnqbevjB8zZouiR8Gn4QNCPNX+FGciwMQeFdLMXp8Cuag4giJjfBz8Y2baDju6
         0n/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GgzzWqrBpFMjyv/cMeIb5f7bPeTWAWqiSMHL1sdKRZ4=;
        b=2FftnHflZpoX/a7Ews+ERAKZfVP8J2hmdM/0Bu2j9YTzpMb3b1c3i5d7pxhmpNflMo
         WoNrdOABxdpsWEz8beOthY/yBem2RULUZ2oG+o+w3b1wbDe495twhSaIdA9Q7hrdZzcr
         pvOrrgxIptagJmEPE/SphZtHSHItoY4tOJ9hNu9MtonI+ByHJVdFL9ZNWuGundEOVUzM
         I/5LxziwOemsI15myN5GG2Kndsn3p4Cxf/MyLMrbxN1I1nnCCjW8DYgJdtOVp5V/jfZJ
         eeeqi/zb0RWT1eQ6MJ3ndLe98+QgdT0o+2nEZG8zzBeO1/ORNQAEqDh1uEmUD/f8Jhb0
         kSSw==
X-Gm-Message-State: ACrzQf3CAn78L5Wnv3kheQuVkOmA3RTWuDIUKrc5RH1ByDIfjtCWSXrA
        MG5ovTz6ZXxBVY8qnGD4Au7nu8VJA6HTvHgqgDhCMA==
X-Google-Smtp-Source: AMsMyM65SlztnP9Ct0bgLPz+q5rSv2J153dMKpZM+l3V8ZvJOVKapOFZ1C8Mg40ZeRniUljX/R7Wv4sbyZqgHbnLfOE=
X-Received: by 2002:a2e:9d4a:0:b0:277:86b:e23d with SMTP id
 y10-20020a2e9d4a000000b00277086be23dmr18720277ljj.193.1667839816173; Mon, 07
 Nov 2022 08:50:16 -0800 (PST)
MIME-Version: 1.0
References: <20221104163339.227432-1-marex@denx.de> <87o7tjszyg.fsf@kernel.org>
 <7a3b6d5c-1d73-1d31-434f-00703c250dd6@denx.de> <877d06g98z.fsf@kernel.org> <afe318c6-9a55-1df2-68b4-d554d4cecd5a@denx.de>
In-Reply-To: <afe318c6-9a55-1df2-68b4-d554d4cecd5a@denx.de>
Reply-To: martin.fuzzey@flowbird.group
From:   "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
Date:   Mon, 7 Nov 2022 17:50:05 +0100
Message-ID: <CANh8QzxiJYAttQx=Jgufwq=bxe7s9X-6o1gpd=nBbxsw3VX+Jg@mail.gmail.com>
Subject: Re: [PATCH v5] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via
 control port
To:     Marek Vasut <marex@denx.de>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Nov 2022 at 15:44, Marek Vasut <marex@denx.de> wrote:
> I'm afraid this RSI driver is so poorly maintained and has so many bugs,
> that, there is little that can make it worse. The dealing I had with RSI
> has been ... long ... and very depressing. I tried to get documentation
> or anything which would help us fix the problems we have with this RSI
> driver ourselves, but RSI refused it all and suggested we instead use
> their downstream driver (I won't go into the quality of that). It seems
> RSI has little interest in maintaining the upstream driver, pity.
>

Yes I've had similar problems with RSI.

It seems things have gone downhill a lot since RSI was taken over by
Silabs and the people who wrote the driver initially left.
The last mainline patches from anyone at Redpine / Silabs seem to date
back to 2019.

But https://github.com/SiliconLabs/RS911X-nLink-OSD/blob/master/ReleaseNotes_OSD.pdf
 it still says in the latest (March 2022) version
"The contents of this driver will be submitted to kernel community
continuously" which does not seem to be the case.

> I've been tempted to flag this driver as BROKEN for a while, to prevent
> others from suffering with it. Until I send such a patch, you can expect
> real fixes coming from my end at least.

We still use it too but haven't run into the issue this patch
addresses as we are still on wpa supplicant 2.9
If we run into any more problems I'll try to fix and upstream but, due
to all the above, I have already recommended internally that we move
to other hardware for future devices.

Martin
