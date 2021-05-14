Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A91380AD5
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 15:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhENN6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 09:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhENN6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 09:58:52 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC53C061574;
        Fri, 14 May 2021 06:57:39 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l14so30133430wrx.5;
        Fri, 14 May 2021 06:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:subject:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=64AidklKtzy410V0pglTKLFGmNORBfPabub/NAvEf3A=;
        b=G+RU4vLKaG6EbQVY/jjpW7a8xhWwXD/GpnLOmIHQSWLkjCdWajwk/0NrDHNLShqikY
         AujRmsjGYIBuPG2MlrUQylydrKUPeLE8szDCbRcFSROfXzV3oX2Eq/B5sRhoovXqTW5H
         8/0dSZHHWoZplUuBxHJL7PU1u8tsvQG1RWBrdG6KWQwexwm6Nyo0PM/Y1PZ52+UsoaAy
         6dZxffvKqfsCENW94G7Uj6VnBQavtEGlbXVLu6Ws7OEBn8R1cEzEbB8p3Cc+4vvHnxWX
         YfnogaCbX0Zr+StyhbO6ZBMS8W0+k1P34UZDe6WiGU0bkDlWtVIPisWdescAPdPbVcoa
         6x3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:subject:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=64AidklKtzy410V0pglTKLFGmNORBfPabub/NAvEf3A=;
        b=sVIlY9RTmLCiBmm+WjTgA8ECD68gpeaPh1JnCj0to/mCUBgeX6nRga7JpfYuvlzsuH
         ujTvFuxZEP/y+KaO5CuARnKWPnnBqGPQjaMeYj77W6+WTAOKiT5Pm2Pe5WZpnKZBqTqe
         J7quu6KjYpZ++luHrlVWq6P3pyOk2hri922aSdPELkuAA/kJm8u1qk96VJaGgiD5S6ta
         QkCOBTepsN0yCT340TsYx8QLiZQJ2cIxj6A5KJ+JtgqaGUrvgIkfgPKPlYlxqaO3cl9z
         Ru3ZGqRUCtRKeGnXzrlwlQuaXmFAT7VMn41JeK/C+VMPgiMY+SezxdrcAkoPshjVx2R+
         LrOQ==
X-Gm-Message-State: AOAM532td946FvW78H7JyuGiRoJcyEbLpgoJEH2sJiwB50y8xyR/Cxb1
        bTcbdzsfDz/e+yXkgmyjAAE=
X-Google-Smtp-Source: ABdhPJwn0XDk5r5vhrYkRPn+YTPwixBWC0Cs+pK2BB609anwLLg/9fZhfovjHaV97qDpG5LHuqfFuw==
X-Received: by 2002:a5d:6d81:: with SMTP id l1mr58577922wrs.17.1621000658680;
        Fri, 14 May 2021 06:57:38 -0700 (PDT)
Received: from [192.168.2.202] (pd9e5a369.dip0.t-ipconnect.de. [217.229.163.105])
        by smtp.gmail.com with ESMTPSA id v17sm6509828wrd.89.2021.05.14.06.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 06:57:38 -0700 (PDT)
To:     dave@bewaar.me
Cc:     amitkarwar@gmail.com, davem@davemloft.net, ganapathi017@gmail.com,
        huxinming820@gmail.com, johannes.berg@intel.com, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sharvari.harisangam@nxp.com
References: <ab4d00ce52f32bd8e45ad0448a44737e@bewaar.me>
Subject: Re: [BUG] recursive lock in mwifiex_uninit_sw
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <bf0c987a-8830-0f44-cf82-bd378e87e000@gmail.com>
Date:   Fri, 14 May 2021 15:57:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ab4d00ce52f32bd8e45ad0448a44737e@bewaar.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/21 14:45 AM, dave@bewaar.me wrote:
> A firmware crash of the Marvell 88W8897, which are spurious on Microsoft
> Surface devices, will unload/reset the device. However this can also 
> fail
> in more recent kernels, which can cause more problems since the driver
> does not unload. This causes programs trying to reach the network or
> networking devices to hang which in turn causes a reboot/poweroff to 
> hang.
> 
> This can happen on the following fedora rawhide kernels:
> - 5.12.0-0.rc8.20210423git7af08140979a.193.fc35.x86_64 [1]
> - 5.13.0-0.rc1.20210512git88b06399c9c7.15.fc35.x86_64 [2]
> 
> The latter seems to be more consistent in triggering this behaviour
> (and crashing the firmware). If someone can give me some pointers
> I would gladly help and debug this.

I believe the same issue (with slightly different symptoms) is also
reported in

   https://lore.kernel.org/linux-wireless/98392296-40ee-6300-369c-32e16cff3725@gmail.com/

See also

   https://lore.kernel.org/linux-wireless/522833b9-08c1-f470-a328-0e7419e86617@gmail.com/

for more details.

Regards,
Max
