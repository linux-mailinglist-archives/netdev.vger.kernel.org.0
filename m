Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A56416DA1
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 10:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244668AbhIXIXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 04:23:11 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:54242
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244633AbhIXIXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 04:23:08 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 052E540192
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 08:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632471695;
        bh=JWgjuZfGDaWPsjxjtj1IRAaOEbXBqacMg+TIH6edpzE=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=hyAkTak5UHsEP9cmrIz68TktB82uNvwLRFBxQGXCZXgChdXDHmGZwRMYjy/iU69zN
         qpIYraT14F/4zn5siJK1/4oa7ao5EDLX0dTvO/lXEVfh/pyyiu8kpBRK2OJBPyZppk
         C6LF46Vm8FYKZQ+WAKxVjSFcmFmmZn4qp4U3WOnxK06ffdJmTAlLoO2R+rf3LvVTeY
         VuR5qiwDhSjl6SAkfWBtPIq2leP03A+lCfG4NPqvJ8fVYOIK5y36Dk9UYxkGHFVALX
         r5ZmNeolvqDlSd4hqV0m/uil2u1ThMjNJ6+Ao8tN+jnL5OvStOotZfFWwhrt3sswWG
         CASWCb1xgNkHg==
Received: by mail-wr1-f70.google.com with SMTP id r15-20020adfce8f000000b0015df1098ccbso7427336wrn.4
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 01:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JWgjuZfGDaWPsjxjtj1IRAaOEbXBqacMg+TIH6edpzE=;
        b=151DzohTOW2FRphLzn56vcG6PJWk3UzmD0UxW3Hv6Cn0s2tR2tns3JbelRGJN+WL88
         3VfJoKSYgZg+FuiN4K/oMkmp9tq7gZLIQTZXjYqmTbfnm4lJYSgUozdk+8yGC2hFieTa
         tPp6UB4WUuV0l+7exIPTZsvMi9bHlkKasKiSf/8mOgp0d4gfTQHcZWYT2zhWD2oLKWtL
         M5gjVKud0p2hgX+XKjE+HG21Zj3fil9LCsfE29mOnJMoih0G9F34K7/j+usriMLU2Wbc
         GuIpH/vZbgD967Lgkm5s0vz0ukXSIFRB4EZKuFsQKhxUdhRUtn35Hf2fMqSNoh5MRVo0
         Az1A==
X-Gm-Message-State: AOAM5325EBuhXTtyiPPzzGlAY1w3/CbEmLe+KtDVaeeo5jAWqRkV+sQ1
        kx39wHn0+X+SNvA7cWmpp7LcrWeVCTyxnGrUXVb75ncQVy01kqD2AnWrMll5z4WNLWJ1sGEmmh0
        mT1rPjrb6xc3FWSZAYbL9LD4lTQGY0HcLaw==
X-Received: by 2002:a05:6000:18a4:: with SMTP id b4mr10027146wri.288.1632471694743;
        Fri, 24 Sep 2021 01:21:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdrzw0Jz4NtTwhrP+xRL1oW5GyOxY0dFEjjzkD3TJJJHosDjKQ0GZ/gx4xSgDXjtotA3E2Fw==
X-Received: by 2002:a05:6000:18a4:: with SMTP id b4mr10027137wri.288.1632471694616;
        Fri, 24 Sep 2021 01:21:34 -0700 (PDT)
Received: from [192.168.0.134] (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id r5sm7319637wrm.79.2021.09.24.01.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 01:21:34 -0700 (PDT)
Subject: Re: [PATCH net] nfc: avoid potential race condition
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20210923065051.GA25122@kili>
 <3760c70c-299c-89bf-5a4a-22e8d564ef92@canonical.com>
 <20210923122220.GB2083@kadam>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <47358bea-e761-b823-dfbd-cd8e0a2a69a6@canonical.com>
Date:   Fri, 24 Sep 2021 10:21:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210923122220.GB2083@kadam>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/09/2021 14:22, Dan Carpenter wrote:
> On Thu, Sep 23, 2021 at 09:26:51AM +0200, Krzysztof Kozlowski wrote:
>> On 23/09/2021 08:50, Dan Carpenter wrote:
>>> This from static analysis inspired by CVE-2021-26708 where there was a
>>> race condition because it didn't lock_sock(sk) before saving
>>> "vsk->transport".  Here it is saving "llcp_sock->local" but the concept
>>> is the same that it needs to take the lock first.
>>
>> I think the difference between this llcp_sock code and above transport,
>> is lack of writer to llcp_sock->local with whom you could race.
>>
>> Commits c0cfa2d8a788fcf4 and 6a2c0962105ae8ce causing the
>> multi-transport race show nicely assigns to vsk->transport when module
>> is unloaded.
>>
>> Here however there is no writer to llcp_sock->local, except bind and
>> connect and their error paths. The readers which you modify here, have
>> to happen after bind/connect. You cannot have getsockopt() or release()
>> before bind/connect, can you? Unless you mean here the bind error path,
>> where someone calls getsockopt() in the middle of bind()? Is it even
>> possible?
>>
> 
> I don't know if this is a real issue either.
> 
> Racing with bind would be harmless.  The local pointer would be NULL and
> it would return harmlessly.  You would have to race with release and
> have a third trying to release local devices.  (Again that might be
> wild imagination.  It may not be possible).

Indeed. The code looks reasonable, though, so even if race is not really
reproducible:

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
