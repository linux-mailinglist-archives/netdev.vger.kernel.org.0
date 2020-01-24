Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C67231479E4
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 09:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgAXI7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 03:59:34 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38183 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAXI7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 03:59:34 -0500
Received: by mail-lj1-f193.google.com with SMTP id w1so1606124ljh.5
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 00:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kXJCcZwQ4bDTEt7nA7d+aRHc6CGt2LLfVcuLvvHZl/w=;
        b=SnP/e24CSQOPdfuiIYdoNW77jKNm7c9TJWlm1LmQ+lOqniwP4+0jh8l0wz8C5esjSN
         cwLmJbMUe+KviajPKlTcpkLa+w+LkiBoXq58GMLlI0UgL7FHgh62tRq10cj8DLZrIzAE
         FGJiouN130TE4Yjb9C93vYyAvKVggxHcLBonnqi8wTCuF6KqOD2+sIfrFCNVMYipkwqC
         NfmNAOu+Ph8QB1truFuJZF6LaKSv+GFIb/U2yco7zj6hJiL81Pqz86qkq5qYkuJzRO02
         jJv310UcMKtYe/0HsI2hBZuLsFmfSq9xEuNhrzYGIDC9Qkrq0y58Old7WW9ihTwaJJlu
         uwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kXJCcZwQ4bDTEt7nA7d+aRHc6CGt2LLfVcuLvvHZl/w=;
        b=gHRFqMisQsgvqcAl6uQi8HemUPtRpu5LWfX2APosZRd+M+dJlDJL1crytrIU/CL85n
         RfZf2S5PTgtf1DztpVeIEcw8Hj6fzEW+IUJIC2ddB6bejmluDi+Q70//88YSdEjvKie4
         C7rZTLVKoMn/YEKsDKYoIAnV8orAdOl9NQPJfUGDQ2Kf6/16j+7bZ1xDdISnJzkfSwWK
         hy/Ka62Ca+tUEf0FSOg3xmyxjZvDZvFREVrv5WGylGPAvE3sq/t3rt7auyR6JLYVWWTI
         9mlYiLfPFCyHed4x1IhpaXobDCtmZRK2FstiZHJvDItOEAv3AfoXcGTXpsd6aq//EZWN
         b+QQ==
X-Gm-Message-State: APjAAAUwI27V/UXIjyq9VBV4OYfLAnYEx9QtRkw5NYwTxlJ4hBJfnDx5
        Jivw2reX66L62oh+rRXM3i796Q==
X-Google-Smtp-Source: APXvYqxTBmC7gLP7OKCLVTzJmGKjpaOCqfXk4fhdvyp4FY7rdD2w161kwavFm9P08Lske+A/dtieLg==
X-Received: by 2002:a2e:8916:: with SMTP id d22mr1705513lji.19.1579856372500;
        Fri, 24 Jan 2020 00:59:32 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:42e2:c9dd:80a5:7c8e:61b8:822e? ([2a00:1fa0:42e2:c9dd:80a5:7c8e:61b8:822e])
        by smtp.gmail.com with ESMTPSA id o69sm2383608lff.14.2020.01.24.00.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 00:59:31 -0800 (PST)
Subject: Re: [PATCH net] fou: Fix IPv6 netlink policy
To:     Kristian Evensen <kristian.evensen@gmail.com>,
        netdev@vger.kernel.org, dvyukov@google.com
References: <20200123122018.27805-1-kristian.evensen@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <7b55a1b9-f065-d740-833d-c1fd2bb6c484@cogentembedded.com>
Date:   Fri, 24 Jan 2020 11:59:17 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200123122018.27805-1-kristian.evensen@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 23.01.2020 15:20, Kristian Evensen wrote:

> When submitting v2 of "fou: Support binding FoU socket" (1713cb37bf67),

    1713cb37bf67 ("fou: Support binding FoU socket"), like in the Fixes: tag.

> I accidentally sent the wrong version of the patch and one fix was
> missing. In the initial version of the patch, as well as the version 2
> that I submitted, I incorrectly used ".type" for the two V6-attributes.
> The correct is to use ".len".
> 
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Fixes: 1713cb37bf67 ("fou: Support binding FoU socket")
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
[...]

MBR, Sergei
