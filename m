Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D02134575
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 15:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgAHO5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 09:57:12 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39627 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgAHO5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 09:57:11 -0500
Received: by mail-lj1-f194.google.com with SMTP id l2so3624535lja.6;
        Wed, 08 Jan 2020 06:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5c3gdZstDi9VJQA9XKvNche9842n21ok7Hxl2V1Sf14=;
        b=CoMokATL+XY/4prIsGWNCi69TTVGodYFQivwEddf1P+0suvCRu7W6GUDYYwUgO4HCc
         cRVOKpGQ5pR6zmvTnbdFhTSC9aczSiGMTEAV6w/HF9ltttsF7NFYT93f3jSlr0K89Sgy
         8vdrNzy80eFg8t3s06x2n2FcWtIOxTku+ywnt4y2w2/0aEEVb8t2POcMnh9tfFNdE6gf
         Q37lVi8PhiMm+1/8MZjkEYEDv3+z3vPG6cLgWnDK9IwhvOmv2Ld4UAjwQlnFxxsfQTBp
         Y1i2Vx2NU+O5XkzPkx9HphOvED3RNZAeYxr5GAGKDMNF4OR0XkWhv60X8/ykv5yLd0SW
         Pw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5c3gdZstDi9VJQA9XKvNche9842n21ok7Hxl2V1Sf14=;
        b=qRPOaSFmTxfbWR2lMPKT6nuy+LHRR0bawkONHEiO1FZC1b5XsyHg9hx/Y6/KdRII9M
         hHUNZO2XJqcr+xBjGKn6ZAkB0/z0wbtZekE57SYx0ND7f//IHK3aCJN7GJlvjjX9hcuS
         sDucus+JQ0MxbiyISDg8KHKp6avi9cnzZsq7VMVYTRCNbKLxOGmLNKerxKC06jioKCLi
         z6E2bNeYci5BzASNqlT4+sePBfiO+3gXQddfrN35GVtTJxiUR8LNxWwRajm0tT1/Pwtv
         na4QXdcdnNfem5iP6X4kpgs2lYBa8r4w9EWjXthrJW6/TRcIzEnQgiWgW9PTB4HEcJ7l
         KdnQ==
X-Gm-Message-State: APjAAAUogJQ8NUQIoB6FV9v74aLDT7trO419EbKSNDM1CtWnP69Lr9+E
        R7cKECUiltZ/VlzGwpv4KJQ=
X-Google-Smtp-Source: APXvYqynUkJlTuZw0VPF6kiqwf03Dj4lZ0q6kKBdbCZ/oIZ5rQ9Lvw4vLGq8jd0PUXthiNfJPm+Nuw==
X-Received: by 2002:a2e:461a:: with SMTP id t26mr3206620lja.204.1578495428974;
        Wed, 08 Jan 2020 06:57:08 -0800 (PST)
Received: from [192.168.2.145] (79-139-233-37.dynamic.spd-mgts.ru. [79.139.233.37])
        by smtp.googlemail.com with ESMTPSA id f11sm1763706lfa.9.2020.01.08.06.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 06:57:08 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: sdio: Fix OOB interrupt initialization on
 brcm43362
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        hdegoede@redhat.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net
References: <20191226092033.12600-1-jean-philippe@linaro.org>
 <16f419a7070.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <141f055a-cd1d-66cb-7052-007cda629d3a@gmail.com>
 <20200106191919.GA826263@myrica>
 <c2bb1067-9b9c-3be1-b87e-e733a668a056@gmail.com>
 <20200107072354.GA832497@myrica>
 <34dbd037-0a40-bf5f-4988-6b821811ffcd@gmail.com>
 <20200108073955.GA896413@myrica>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <2d8508f2-37cd-e142-e3d0-7e825d173e4b@gmail.com>
Date:   Wed, 8 Jan 2020 17:57:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200108073955.GA896413@myrica>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

08.01.2020 10:39, Jean-Philippe Brucker пишет:
> On Tue, Jan 07, 2020 at 07:23:32PM +0300, Dmitry Osipenko wrote:
>>>> Hello Jean,
>>>>
>>>> Could you please clarify whether you applied [1] and then the above
>>>> snippet on top of it or you only applied [1] without the snippet?
>>>
>>> I applied [1] without the snippet
>>>
>>> Thanks,
>>> Jean
>>>
>>>>
>>>> [1] brcmfmac: Keep OOB wake-interrupt disabled when it shouldn't be enabled
>>
>> Will you be able to test *with* the snippet? I guess chances that it
>> will make any difference are not high, nevertheless will be good to know
>> for sure.
> 
> I tested it with the snippet and didn't notice a difference

Okay
