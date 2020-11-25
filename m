Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6ED02C3B8F
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 10:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgKYJGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 04:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgKYJGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 04:06:21 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C023C0613D6
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 01:06:21 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id k1so1686681eds.13
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 01:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v4gNQmDRHbR01jUPm5SYwLaqDhJEPbPGmwjuf8wFdX8=;
        b=kpPifnF6YK8KEwZbf7ulYTIOe65yvPOgYzVylt2M23h/mjcCibmfUmC+bERkFtDYzY
         pqVdfd/+KgOI6WZAKoNHZxwoY2pH1CG+Ll10ZeBNVTyoP8DFx1MeT5yyk0MJnatBa3mP
         f+GImqlX72fKrEJ1V6LDZ4w37gGa+v5Znwi0wkWkG6u/6ZMNLDh1EwaJhcj11jPPvAfX
         vZsDgoUtw5Jw6L+0xvD8Jf7OGmSlAABpifFIqNYR1PJRccXqK4wm3fhHdk5uygvyYVIo
         7NLyU2fiH970XHNHJPaSKOLk1XZHjDUt+oNDMamoiVJdelAWHdaYH2QcHyCdLqCTjfP2
         ZUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v4gNQmDRHbR01jUPm5SYwLaqDhJEPbPGmwjuf8wFdX8=;
        b=nDJ7hpzhLIVNvaqc4XePJe0QdJLC2bI/juNPokazTT7xw9fmoBl4dGVp7qs3/Y1HCW
         SRx35vTAmiLwOA0D0Ya0viWEltPL7FVTDLEIgB2li2M6M3aBoAylh2g9Ib/1wwnRjnqW
         JCfASWFELNc+B80ejFwKyp/DtQFWcH/hCeRGLwkYO5jFiocrkq1mXewx1f04EVljgP1N
         7qzTZVWBnVCQyxZJ5c4pkMDVCcvR2cRsLbUyZG9Xfj6wen3bhBDaA/4DJi20xdbiqvPO
         pVVFRjoHPwusYUUEVMyc9ah1es3M9DQtFkbnI1he95Icwp/UB33dJyOXqePyG9h3oKJ+
         AnVA==
X-Gm-Message-State: AOAM533Zw/tGMlL8iqGGZ84AG6UYJPgMbiu5X20yskVCn8vJcFOv72Y3
        0MPJDATpLsxGZFes4UqrqrvzE5wkv2Y=
X-Google-Smtp-Source: ABdhPJxwSAnZ+nf5yhBT04qrDGVstKwu9//EGa3SSFc8pBIRpUPMGJWkTirjVj+PBN1ktrKrXKRRUQ==
X-Received: by 2002:a50:c04c:: with SMTP id u12mr1241414edd.188.1606295179876;
        Wed, 25 Nov 2020 01:06:19 -0800 (PST)
Received: from [192.168.0.110] ([77.127.85.120])
        by smtp.gmail.com with ESMTPSA id d23sm819443edp.36.2020.11.25.01.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 01:06:19 -0800 (PST)
Subject: Re: [PATCH net] netdevice.h: Fix unintentional disable of ALL_FOR_ALL
 features on upper device
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20201123141256.14208-1-tariqt@nvidia.com>
 <CANn89iKRVyTZg-tNQvo_Ub-RZ_A+OOQQY8Py3J9fx=NOZXF9Qw@mail.gmail.com>
 <9bf8ba40-cd40-2af6-d358-48dd98526434@gmail.com>
 <CANn89iK8MXp0QmZbBKdMDHxi7A4afrVdBtgQq7cSY5SRefwraA@mail.gmail.com>
 <20201125032549.GA13059@gondor.apana.org.au>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <329952c5-b208-1781-5604-2b408796ec90@gmail.com>
Date:   Wed, 25 Nov 2020 11:06:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201125032549.GA13059@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/25/2020 5:25 AM, Herbert Xu wrote:
> On Tue, Nov 24, 2020 at 11:48:35AM +0100, Eric Dumazet wrote:
>>
>> Well, the 'increment' part was suggesting the function was adding
>> flags, not removing them.
> 
> The idea of the increment part is that we're adding a constituent
> device, not that we're adding features.  There have always been
> features which were conjunctions, i.e., they must be supported by
> all underlying devices for them to be enabled on the virtual device.
> 
> Your use of the increment function is unusual, as you're not adding
> features that belong to one underlying device, but rather you're
> trying to enable a feature on the virtual device unconditionally.
> 
>> We might ask Herbert Xu if we :
>>
>> 1) Need to comment the function, or change its name to be more descriptive.
>> 2) Change the behavior (as you suggested)
>> 3) Other choice.
> 
> I think Tariq's patch is fine, although a comment should be added
> to netdev_add_tso_features as this use of the increment function
> is nonstandard.
> 

Thanks Herbert, I'll add a comment and re-spin.

> Thanks,
> 
