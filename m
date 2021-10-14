Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2235942D898
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 13:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhJNL4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 07:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhJNL4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 07:56:39 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A243C061570;
        Thu, 14 Oct 2021 04:54:34 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e12so18623540wra.4;
        Thu, 14 Oct 2021 04:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Qh70ZouKZ85gIbpuXKWewmPLqOEF6lltY7MRU3dhsLQ=;
        b=cn8xR7iiAw7tWLtSnmilwd0CLe4cIYuLcWV6O7XQ5LHFnC/wOFIWN4l3qyN6BY/cdh
         AS/BEtzOkPPJ5YvO0DQPfmbY7qhU9fI/9imeranMOICUU0X4q8sP2J4qAmieeoLD+nhK
         HCTGk05ojGTmiqhKPYB+q8hH1ptSggXPQDx0d06jXoCevxZe4/+UAgsJ7aD4/ClHjIDM
         Uq5d3+wzLafXiIO/rGCntLEJUnvzl5Grh6fujZ9n6G/AzHdjs/mNvee7wuGUcKCbGqZN
         hhAIlxxxWuVoWMEk21U4XseZsNKCBloH6AeNxzN0KJ4c23+pyL9kgi+FRKa4kRWi4HUZ
         5DaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qh70ZouKZ85gIbpuXKWewmPLqOEF6lltY7MRU3dhsLQ=;
        b=T1pACr/10OguqapE/VHYbt/2yLHVbCkyctoSoYkWZkuIOdou4XQGtopkm30+Rh+hk6
         E1QYCN35a7FQWjdWdmlPSoFBU1zbwL3o+Wh9LLxa427aiPuvf0BZtEqhxJe2d9FBsId4
         t2JEwL/mUFgOhA8dP3mGb7F6BZTOM1tb6HQzT+RbJXUyijhQgC0fkzdKk0lVUYEC7txC
         03O8p/S0YKu9JwExR7w4cZVTL35XrRrBlJjHXD1mkUyZZcdZ6/bm3LWL2ZCCY0v/SEIS
         12D9tdqu0NeBRzF9t7iNmAUBGi4ch94M9bDGenwXyy65cA2ly/BMdP2SFzpT4rdCiHdK
         s4Ug==
X-Gm-Message-State: AOAM532K5dh/ir8JIQiz5jYxBMjCYoYIiLnBBiyp5z+NT4dmj05L7RMG
        RiaRwYQubrJoL9bvTKNTUrJcunk9F4g=
X-Google-Smtp-Source: ABdhPJy1ZYZCOFqvLyyp8cFqmb+AwiD6hjCGDA1IY0Kv5GkMzSNmSJNkDkdSXDMvEMcXmypDMbPF0A==
X-Received: by 2002:adf:8bca:: with SMTP id w10mr6144612wra.43.1634212472296;
        Thu, 14 Oct 2021 04:54:32 -0700 (PDT)
Received: from debian64.daheim (p200300d5ff0f7400d63d7efffebde96e.dip0.t-ipconnect.de. [2003:d5:ff0f:7400:d63d:7eff:febd:e96e])
        by smtp.gmail.com with ESMTPSA id c17sm2194410wmk.23.2021.10.14.04.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 04:54:31 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1mazJe-0008WG-Sw;
        Thu, 14 Oct 2021 13:54:30 +0200
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF
 selection
To:     Robert Marko <robimarko@gmail.com>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211009221711.2315352-1-robimarko@gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <ba520cf0-480e-245b-395f-7d3a5f771521@gmail.com>
Date:   Thu, 14 Oct 2021 13:54:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211009221711.2315352-1-robimarko@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/2021 00:17, Robert Marko wrote:
> Some ath10k IPQ40xx devices like the MikroTik hAP ac2 and ac3 require the
> BDF-s to be extracted from the device storage instead of shipping packaged
> API 2 BDF-s.
> 
> This is required as MikroTik has started shipping boards that require BDF-s
> to be updated, as otherwise their WLAN performance really suffers.
> This is however impossible as the devices that require this are release
> under the same revision and its not possible to differentiate them from
> devices using the older BDF-s.
> 
> In OpenWrt we are extracting the calibration data during runtime and we are
> able to extract the BDF-s in the same manner, however we cannot package the
> BDF-s to API 2 format on the fly and can only use API 1 to provide BDF-s on
> the fly.
> This is an issue as the ath10k driver explicitly looks only for the
> board.bin file and not for something like board-bus-device.bin like it does
> for pre-cal data.
> Due to this we have no way of providing correct BDF-s on the fly, so lets
> extend the ath10k driver to first look for BDF-s in the
> board-bus-device.bin format, for example: board-ahb-a800000.wifi.bin
> If that fails, look for the default board file name as defined previously.
> 
> Signed-off-by: Robert Marko <robimarko@gmail.com>
> ---

As mentioned in Robert's OpenWrt Pull request:
https://github.com/openwrt/openwrt/pull/4679

It looks like the data comes from an mtd-partition parser.
So the board data takes an extra detour through userspace
for this.

Maybe it would be great, if that BDF (and likewise pre-cal)
files could be fetched via an nvmem-consumer there?
(Kalle: like the ath9k-nvmem patches)

This would help with many other devices as well, since currently
in OpenWrt all pre-cal data has to be extracted by userspace
helpers, while it could be easily accessible through nvmem.

What do you think?

Cheers,
Christian
