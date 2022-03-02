Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E963F4CA0B2
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 10:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiCBJ2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 04:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbiCBJ2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 04:28:17 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6E92B24E
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 01:27:33 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id i8so1694382wrr.8
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 01:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=sNXYqbzlYS8ExVChfTlkQJwDf8g/sztTwE8UBHfQ5+s=;
        b=dPcKJp/Mgf4kJKqA8falTL2ZQw83HS5QlfFavuQpaCh02XuNdge0no36xupVoF6/MP
         TZTAknxjDOvTCT/Xw60r20eanRzk+pWmekIATU+YgFzikrosqAJbhDAT4BHyARUKwSdL
         UgrO0xTorPYlPV6KEmdehTyZjYzKYZhSsgKmnzgOZ97gvJzPZwJSlr3klmyCVFaBzWPm
         Lhy6yW8oagnM3k/TBKspt3JSJe5cuAf3brsd4lfOuZtiKPQoIQ2SjgB/pOwgBue++1wT
         aKWBIvUd0kWO+2zTJfjplIw3vgfxi8RkuzSSXOKefBeycLEzW/RAcd6mLe4Ep5WrDCfE
         Nf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=sNXYqbzlYS8ExVChfTlkQJwDf8g/sztTwE8UBHfQ5+s=;
        b=siE8uMyU2BalsaVxwxFr7rtvsgjmPM1LmyfRIYoUFsNxtYUfjrDnNfGZJzDbfr9TvG
         Anu9axaY2d7c+g+cbRZGuBPEtfnGiiWhJ9Lr1/mfasVLkKzsSmYnpWFKeHaXMwZsVw4E
         X3GtdbdEl5EQvmVYNV2D2SXGSIIc7ZVfuRBmAzWCESV62l8QMcr45cHOuyulUnWUCXmy
         jDttnu5egSJQ8m4SEAos+hl014FzBv2GrZ3nVQD0aDJopcst26fnqMBLUJOjYab8Wrxj
         RhNcDKjHK3jT1GLEJamRjRVS7EnuYbSp7sLL5wYGklED6CEfbSUOfj47S9wzLarlrCE4
         m7kA==
X-Gm-Message-State: AOAM533v863nFhEvB5UnvoYKuQY1BBDUtV1Cfd3U+p0eTX8qb/YAmlqM
        zOwk4R9RjW/iBBoqdQN6+7HuXQVrHGfJYA==
X-Google-Smtp-Source: ABdhPJxFyP4zNepImna1zCBvtMf6ZTVt5apkyE/TWXxPo4ruGwHyNzTQEPKTRRKFoOtcRblcxu8n4g==
X-Received: by 2002:a5d:484c:0:b0:1ef:c216:12e3 with SMTP id n12-20020a5d484c000000b001efc21612e3mr10701722wrs.13.1646213251897;
        Wed, 02 Mar 2022 01:27:31 -0800 (PST)
Received: from ?IPV6:2a01:e0a:b41:c160:b9c1:70a4:f250:68c7? ([2a01:e0a:b41:c160:b9c1:70a4:f250:68c7])
        by smtp.gmail.com with ESMTPSA id l11-20020a5d674b000000b001f047c49e99sm49371wrw.2.2022.03.02.01.27.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 01:27:31 -0800 (PST)
Message-ID: <1735bb6b-8708-43ee-949a-428957d7f917@6wind.com>
Date:   Wed, 2 Mar 2022 10:27:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return
 error"
Content-Language: en-US
To:     Kai Lueke <kailueke@linux.microsoft.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Paul Chaignon <paul@cilium.io>,
        Eyal Birger <eyal.birger@gmail.com>, netdev@vger.kernel.org
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
 <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com>
 <d5e58052-86df-7ffa-02a0-fc4db5a7bbdf@linux.microsoft.com>
 <CAHsH6GsxaSgGkF9gkBKCcO9feSrsXsuNBdKRM_R8=Suih9oxSw@mail.gmail.com>
 <20220301150930.GA56710@Mem>
 <dcc83e93-4a28-896c-b3d3-8d675bb705eb@linux.microsoft.com>
 <20220301161001.GV1223722@gauss3.secunet.de>
 <f2dc1c09-6e3a-0563-491b-1b8de7a8f5ef@linux.microsoft.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <f2dc1c09-6e3a-0563-491b-1b8de7a8f5ef@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 01/03/2022 à 17:44, Kai Lueke a écrit :
> Hi,
>> In general I agree that the userspace ABI has to be stable, but
>> this never worked. We changed the behaviour from silently broken to
>> notify userspace about a misconfiguration.
>>
>> It is the question what is more annoying for the users. A bug that
>> we can never fix, or changing a broken behaviour to something that
>> tells you at least why it is not working.
>>
>> In such a case we should gauge what's the better solution. Here
>> I tend to keep it as it is.
> 
> alternatives are: docs to ensure the API is used the right way, maybe a
> dmesg log entry if wrong usage is detected, and filing bugs where the
> API is used wrong.
I agree with that proposal (dmesg log). Breaking an existing script, even if it
made something wrong is really painful. And maybe this broken xfrm interface was
unused, so everything worked well before the patch and is now broken.

My two cents,
Nicolas
