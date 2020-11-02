Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4003A2A3010
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgKBQlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgKBQlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 11:41:05 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5E3C0617A6;
        Mon,  2 Nov 2020 08:41:05 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r10so11240532pgb.10;
        Mon, 02 Nov 2020 08:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=gVScNhg3nwSxNUg/MgfwzotEdUV9MD/rwLFJFqF4KkY=;
        b=ozIK3MB34COjNhsEolV6Im+wdPQSNM2a9DrXoHDCBTmKDqTZRq4rKwEDE4fc9Foo2E
         drGDMGJe9zjkwJRZhAUSPpsqmIXn9sa44qJ8S8VhZ7o6EFuRZ24zdy6dcQtZipSIUtUT
         F6vltHHB9Tsd07KzL81OZF+qBD+jMz6OyGcsJtoAe0ALVKr2ishjGWd3UETyoaVG6HPI
         MNM4i3ppIzXUuUQrBJhr5l5ouCiTYGQPucUBzba/UcSCUfrOosFnHU+2uyNgIjSdgyJ4
         BCUp3iEDGMKQFUSPMN13AWyhcf6njkfO6DmMOvEqYy6+b48QGPiWZjKaYMAFu8vHKguF
         FpHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=gVScNhg3nwSxNUg/MgfwzotEdUV9MD/rwLFJFqF4KkY=;
        b=OwzpSCIKYL2GDjtraRFRUyKbbLPgm/aqwWJ+wRuOAMrHUixuy/SEBTVTcA5C2y9IC0
         wldNmF/NKZjAgHgFBWnb7k09P2zw1uI/CMPoChzW4OW6c9gZR9T615OqN5lbMrlvAR+w
         y0yqnNCQnJbntyScFbSAFtFWx7Ej6qPM6NWPbMjvaI0zIdnKrWNvkxXiq7ErWNRcVRUt
         dPDy1K8dL1xvAVDpsfl+S2pZLYvN62GP/Y8FVCwIinRT30ZWgV2ap4vMB5Z3eeLDGU1+
         xZc4cC1dKFa9/b6x/PQXEiEz4Hv7VwaoDG5GYN/l1a1qt6df3GROArInRZKit6lGuDar
         2+IQ==
X-Gm-Message-State: AOAM532LD/1Jr8snZuwbFsueITFWC4JFwpv4sVShmr/PEcgP9vt2M1LZ
        AbxfNWcPKLXRyHyNWs2I2xZVJPTCo90K7DyfiuM=
X-Google-Smtp-Source: ABdhPJwOzMbyY75elEDngKQ6pj7PwgayDj5owOPqp10tiA7jB3AWJfZi2U9zYHWZC09YfXWcEeb5RA==
X-Received: by 2002:a17:90a:5c82:: with SMTP id r2mr18207842pji.69.1604335264336;
        Mon, 02 Nov 2020 08:41:04 -0800 (PST)
Received: from [192.168.0.104] ([49.207.221.93])
        by smtp.gmail.com with ESMTPSA id s145sm3272429pfs.187.2020.11.02.08.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 08:41:02 -0800 (PST)
Subject: Re: [PATCH v3] net: usb: usbnet: update __usbnet_{read|write}_cmd()
 to use new API
To:     Oliver Neukum <oneukum@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20201029132256.11793-1-anant.thazhemadam@gmail.com>
 <20201031213533.40829-1-anant.thazhemadam@gmail.com>
 <11476cd1da8b63f75d39bd5b8e876ad3968a1903.camel@suse.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <c50d24f5-0ed3-4361-0830-619367a3c99e@gmail.com>
Date:   Mon, 2 Nov 2020 22:10:57 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <11476cd1da8b63f75d39bd5b8e876ad3968a1903.camel@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 02/11/20 3:10 pm, Oliver Neukum wrote:
> Am Sonntag, den 01.11.2020, 03:05 +0530 schrieb Anant Thazhemadam:
>> Currently, __usbnet_{read|write}_cmd() use usb_control_msg().
>> However, this could lead to potential partial reads/writes being
>> considered valid, and since most of the callers of
>> usbnet_{read|write}_cmd() don't take partial reads/writes into account
>> (only checking for negative error number is done), and this can lead to
>> issues.
>>
> Hi,
>
> plesae send this as a post of its own. We cannot take a new set
> as a reply to an older set.
>
> 	Regards
> 		Oliver
>

Got it. I will do that.

Thanks,
Anant
