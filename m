Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAC740F39A
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 09:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244197AbhIQH4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 03:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241682AbhIQH4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 03:56:07 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A931C061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 00:54:45 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u18so11929005wrg.5
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 00:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lEMrqRFvHCI9WtSnFZ5s8+gUDEo4Nn3YrG808Z17kgI=;
        b=QswdL5/FhK5Rp3rDkkEIprXBS/oma/8BSVGzD0SEmCp/5s3SoFkFuoqjL9Pr8914tP
         4p7W3lQnkwN3IFcvtURsJNwQF3nr/PecaE5adANsmJov76IPMGWqADX35LX5BQ1aM8CR
         FZzk45t1oKQMrYBBhMO3DGek9GO0wQAtqZkdLc4Sv3Rr18Cs+R1zEiravNdWZkKAv3jl
         rYLCw8eMMPlwqHtin3o+v1xbx9gsKNZ2rC6ZkdLeywvKObgP+IMz8LEuEj3gs0rWCMrj
         hWqd20YVb3b/ozOKnFKK/hZ+EF9CHwtMk3rDt/tDsjYcsdaAwWJVuWWSFBDPQpc7SPVn
         NmwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lEMrqRFvHCI9WtSnFZ5s8+gUDEo4Nn3YrG808Z17kgI=;
        b=Pdku00jhfUF3jZmaV6cn4RfouDQ3UPOyApIoY/5QJDHzvMgX67t6Or7Yx62ZOU3JFM
         Nl7RVE8a0vf39Pdfd/s38/Yyw8oGdG0zYKoykPf6FjVd0C8JKbp/VCafm7mJZLFl3AkT
         InrYtiNTnASBTWfmQRfAb1EZ8HQCM+NAHXzOAuAInAGrfZrd6obm1n3oijGKwRsY+QiD
         h/9BE14Bi97e9oXW/z+MLcwd+Q28xE0jmFkDujBdRZUvAf1Tzd706PMrJ9BmtLqhJ45/
         q0vvm47fedgPyKFdAYD3KWyyu2xDJUogwKP0IVMTcI4fuqRfROEsFQl6GaWemv16uD9a
         KYlg==
X-Gm-Message-State: AOAM532z3QG+vP/0pbf20Qlfl2TMX4E/E6CoaEbnSfDjgPm+Q9Y98NZ5
        zh6V8XkPGbdVHeJPfvgs3bBNore9QRqEHw==
X-Google-Smtp-Source: ABdhPJyGGxFMPJSNf2JAd0TEWa/U4XoPzRIjTAlYAQMXZjVQEMMLJ4FbanL/NxlPm4PoceVNavDK6g==
X-Received: by 2002:a5d:4a08:: with SMTP id m8mr10239714wrq.263.1631865283824;
        Fri, 17 Sep 2021 00:54:43 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:c55c:1af:42ea:ba9e? ([2a01:e0a:410:bb00:c55c:1af:42ea:ba9e])
        by smtp.gmail.com with ESMTPSA id i27sm9801959wmb.40.2021.09.17.00.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 00:54:43 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec v3 0/2] xfrm: fix uapi for the default policy
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, antony.antony@secunet.com,
        netdev@vger.kernel.org
References: <20210908072341.5647-1-nicolas.dichtel@6wind.com>
 <20210914144635.6850-1-nicolas.dichtel@6wind.com>
 <20210917070610.GB1407957@gauss3.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <abc75aeb-d23f-99ca-60f4-382675f11557@6wind.com>
Date:   Fri, 17 Sep 2021 09:54:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210917070610.GB1407957@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 17/09/2021 à 09:06, Steffen Klassert a écrit :
> On Tue, Sep 14, 2021 at 04:46:32PM +0200, Nicolas Dichtel wrote:
>> This feature has just been merged after the last release, thus it's still
>> time to fix the uapi.
>> As stated in the thread, the uapi is based on some magic values (from the
>> userland POV).
>> Here is a proposal to simplify this uapi and make it clear how to use it.
>> The other problem was the notification: changing the default policy may
>> radically change the packets flows.
>>
>> v2 -> v3: rebase on top of ipsec tree
>>
>> v1 -> v2: fix warnings reported by the kernel test robot
>>
>> Nicolas Dichtel (2):
>>   xfrm: make user policy API complete
>>   xfrm: notify default policy on update
> 
> Applied, thanks a lot Nicolas!
> 
Thanks Steffen. I will write the follow up patch once the ipsec tree is merged
into ipsec-next.


Regards,
Nicolas
