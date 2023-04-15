Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1499A6E323A
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 18:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjDOQCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 12:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDOQCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 12:02:37 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D371E120;
        Sat, 15 Apr 2023 09:02:35 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50506111a6eso3234471a12.1;
        Sat, 15 Apr 2023 09:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681574554; x=1684166554;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZFaBZbGTLI7mmllrP+a+GARwM4nfHLzyRuhAkCEC5J4=;
        b=hPZjPuj0v7BHjyFOoou+iVUeKPz5/pG+uCZcshfcKPw0R3PGPnvYCIC2vD7delbtdz
         eVWhf1s6wkrGV2AlQ6hqMuElxBU/6zPL/vtRciCy7A1SfpHRsrwJZjSBsfMA2Cod6mAd
         4IGoLqHE9waZtR3IAAVD1t2QazW82mZEQRNwoi/o40rFkZywPABoiAAkADXrScyvaPnc
         cowGwTSKfuekhLnCg8/JrrxCATJfHCe9UXEUXIVtTLA+2ZYATWKw+kvnTFaE8HqoZfcp
         VVDYOwluQIFay78EBmvzC0A8QqPWWlj+8EBZ9HyiSkaJRNoJqs0YJJvXcLWM8zViqn2e
         6pIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681574554; x=1684166554;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFaBZbGTLI7mmllrP+a+GARwM4nfHLzyRuhAkCEC5J4=;
        b=SY07elUROFLOk/9lFgc3ngIlTMFeg52TcE7IK0HNiYuIHo0vJTYhWs9o9r2HiEkDdi
         8vllLkURpNgiBhgPCuhjjDDVQ2rbDIfay32iMl6p6YHw0F/fI9NULu5126JjR8d/rsxo
         1y1dr3QSPe0EnfxJt7+TzDNWipRY9GE1ExMunTKb/58h9tdVPTR9+k2d3sszHNu47Zvf
         5jQ0gKdr9wIEjnXqN8nJqXBTuEnzFgfvaAh53fUsp48xHEjevGUncPTlVv8OGDP/gnol
         OGzxUj/6ypYBionfQN/O/iZU/dNm+5OyDvwpweE2f7aYS/agFBWbMrftOD56ji10Ity2
         Vr3A==
X-Gm-Message-State: AAQBX9c4gS0aSU+jsCuR7zGArIBFp6H4meG9191B1V2UKAXlBiYvpqgV
        BseUNurfrU4SEvRGSMt07fk=
X-Google-Smtp-Source: AKy350Y+itPPwg3srajb3EfOX7KbwfdvotqWNvipp2HO1r93bJrMD/1H/QshtxXncu2Evz4pLQPcsg==
X-Received: by 2002:aa7:c1ce:0:b0:4fc:6475:d249 with SMTP id d14-20020aa7c1ce000000b004fc6475d249mr8934467edp.3.1681574553815;
        Sat, 15 Apr 2023 09:02:33 -0700 (PDT)
Received: from shift.daheim (pd9e29911.dip0.t-ipconnect.de. [217.226.153.17])
        by smtp.gmail.com with ESMTPSA id bo25-20020a0564020b3900b005067d129267sm2516937edb.39.2023.04.15.09.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 09:02:33 -0700 (PDT)
Received: from localhost ([127.0.0.1])
        by shift.daheim with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1pniMD-0003Y1-00;
        Sat, 15 Apr 2023 18:02:33 +0200
Message-ID: <a7895e73-70a3-450d-64f9-8256c9470d25@gmail.com>
Date:   Sat, 15 Apr 2023 18:02:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] ath9k: fix calibration data endianness
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230415150542.2368179-1-noltari@gmail.com>
 <87leitxj4k.fsf@toke.dk>
Content-Language: de-DE
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <87leitxj4k.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 4/15/23 17:25, Toke Høiland-Jørgensen wrote:
> Álvaro Fernández Rojas <noltari@gmail.com> writes:
> 
>> BCM63xx (Big Endian MIPS) devices store the calibration data in MTD
>> partitions but it needs to be swapped in order to work, otherwise it fails:
>> ath9k 0000:00:01.0: enabling device (0000 -> 0002)
>> ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
>> ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
>> ath: phy0: Unable to initialize hardware; initialization status: -22
>> ath9k 0000:00:01.0: Failed to initialize device
>> ath9k: probe of 0000:00:01.0 failed with error -22
> 
> How does this affect other platforms? Why was the NO_EEP_SWAP flag set
> in the first place? Christian, care to comment on this?

I knew this would come up. I've written what I know and remember in the
pull-request/buglink.

Maybe this can be added to the commit?
Link: https://github.com/openwrt/openwrt/pull/12365

| From what I remember, the ah->ah_flags |= AH_NO_EEP_SWAP; was copied verbatim from ath9k_of_init's request_eeprom.

Since the existing request_firmware eeprom fetcher code set the flag,
the nvmem code had to do it too.

In theory, I don't think that not setting the AH_NO_EEP_SWAP flag will cause havoc.
I don't know if there are devices out there, which have a swapped magic (which is
used to detect the endianess), but the caldata is in the correct endiannes (or
vice versa - Magic is correct, but data needs swapping).

I can run tests with it on a Netzgear WNDR3700v2 (AR7161+2xAR9220)
and FritzBox 7360v2 (Lantiq XWAY+AR9220). (But these worked fine.
So I don't expect there to be a new issue there).

The older platform_data code has a "endian_check" flag in
the ath9k_platform_data struct:
<https://github.com/torvalds/linux/blob/master/include/linux/ath9k_platform.h#L38>
Which enables the check and the endian-swapping (though it's disabled by default).

Cheers,
Christian
