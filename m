Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285813DF1C1
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbhHCPqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236970AbhHCPqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:46:51 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC7CC061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 08:46:38 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id x7so28677576ljn.10
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 08:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4ZETZZClJt1Rw9UxIUCgI6DmKCNdMLcoSqvkSP7HJzE=;
        b=B0FspG/RflmwPJQrIsupIDdCfnaTBpzz9G0m5eCUBJQikVLa2PhKoog5OHS2bd1vul
         IS5RJJkcdkXLYrTCu9joMl3e6t5xeymaH/wvIOFMB8pzPzwwutt0lpNVtjUku+4Y2wCI
         pk+BomlewNOnoSGiFf085z91Hc8Ck0vxnfESIgCcuGSPc0qhNI32EekQnPMwrD2Kazd3
         im1NXWZPEjdICMGtQbMFJkJicBmVhszNgT69aMdCxR8D86eJ8CZCzL9VKIeP5+u0UCXA
         JhkQBqxI60H6YcmWTnRjqzHYGKlxcv0qRdliaMq+leO3M6kpaR1+IED3laS+JkNwZs9r
         va+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ZETZZClJt1Rw9UxIUCgI6DmKCNdMLcoSqvkSP7HJzE=;
        b=rCUe99LggiEhcNVuxk8jxKfK6GohPKFxD4OJPN0W7aIp+8lvJcF3NAVrFFkonlUDKN
         jpoyXwnRa4eNr3PKEeIXhQSD4xMee33YopjX5gDLYa4WUxAbHfEmtsoo4yI4bh6Nyhn1
         j68qgUE7z3qCpzC+PH0Pkp+7TJvoWWhC+mqZp9KsOy/KpRk5Apn6ZIS2Zl/D6erOHB9O
         UGoDh3XWIln64SaiU90pyBsr/6DRbv30KGo1AY2GFnOoUFlJBGhz2f70Keflx9fWzt0S
         sK79t3tenFBDWfpsbkpL7Qdq1WDUuc2++gL9UYEQgLjKeqQe1xpZwyGuEvQdfJ9PsFNi
         0zRg==
X-Gm-Message-State: AOAM531OBfHE+O4pVTto6HUCJNaHiB7och0cYEmuMWnKqKEbuWjKDl9a
        wozBsmGF3rvySVkKUhJ52HU=
X-Google-Smtp-Source: ABdhPJzf1so5A21cDmaxk16Tz0MPaD9lDoDgrVubDu16lBm52h+EPsVdCDqmzgvbR/nhNau+R9iByA==
X-Received: by 2002:a2e:9911:: with SMTP id v17mr14796732lji.392.1628005597315;
        Tue, 03 Aug 2021 08:46:37 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.235])
        by smtp.gmail.com with ESMTPSA id e21sm1398627lfq.240.2021.08.03.08.46.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 08:46:36 -0700 (PDT)
Subject: Re: [PATCH net 1/2] net: usb: pegasus: Check the return value of
 get_geristers() and friends;
To:     netdev@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Petko Manolov <petkan@nucleusys.com>
References: <20210803150317.5325-1-petko.manolov@konsulko.com>
 <20210803150317.5325-2-petko.manolov@konsulko.com>
 <eeb03520-f57a-1c78-fe84-0b72edea371f@gmail.com> <YQlkh54HdqQYZenw@carbon>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <58f9122f-3ad3-9d6b-7ae3-5d5a83f19334@gmail.com>
Date:   Tue, 3 Aug 2021 18:46:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQlkh54HdqQYZenw@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 6:45 PM, Petko Manolov wrote:
> On 21-08-03 18:28:55, Pavel Skripkin wrote:
>> On 8/3/21 6:03 PM, Petko Manolov wrote:
>> > From: Petko Manolov <petkan@nucleusys.com>
>> > 
>> > Certain call sites of get_geristers() did not do proper error handling.  This
>> > could be a problem as get_geristers() typically return the data via pointer to a
>> > buffer.  If an error occured the code is carelessly manipulating the wrong data.
>> > 
>> > Signed-off-by: Petko Manolov <petkan@nucleusys.com>
>> 
>> Hi, Petko!
>> 
>> This patch looks good to me, but I found few small mistakes
> 
> Yeah, the patch was never compiled.  Sorry about it.  v2 is coming up.
> 

BTW: should this also go to stable with Fixes: 1da177e4c3f4 
("Linux-2.6.12-rc2")?


With regards,
Pavel Skripkin
