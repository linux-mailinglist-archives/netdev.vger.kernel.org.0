Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11253DB9F8
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 16:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239161AbhG3ODz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 10:03:55 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:57646
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239137AbhG3ODm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 10:03:42 -0400
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id D07443F23A
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627653816;
        bh=/Gja+i0Dvjadolanru2/enXX4OvFq4ZgMqAnNw717vc=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=NBOOc40k5NX1vGoaEp6ZNk7Mp2HeNNIunG5yagIO/xHIzryyLxbbi+0CSVlAvG2Os
         NnzES+hrPZwyKBAX0cpf7mRHbQenx0+aZ7uuPSZwr+QFTAKmFMyUmn165DbGIYaGzN
         15j0TIrnEa6g8zwIGq/Hfh1quvis1gcPTg78ft7EJ4lJ3o5av1+NmUdL7qCNqFQRZY
         s1ucKVRlr5AjibKtXZC/iR9p79UJJS6LB2L4EosGwiJR+3NNLMvjfTJKNFp/GHb8o4
         Yr5tVQoUTV/gf8L604uuIEk5Q/fkoiDX8y3dbmE1frYqKiXcP3/5qvZnXRSvMuwGsr
         V0P46f32PD2DA==
Received: by mail-ej1-f72.google.com with SMTP id kq12-20020a170906abccb0290591922761bdso1861569ejb.7
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Gja+i0Dvjadolanru2/enXX4OvFq4ZgMqAnNw717vc=;
        b=mm+EgxAgaEp+/+jWBtUoF5NV0uG2xOBk+xB5vBnFZGuvYJquhqsfFH1sIWA0RXkFBY
         ZvqllEWxH4uMQamIPZhykVEBuZt8ZOkGDaiDQAuaTe/uKlYo3D2Zy+Misbtc0ZBXRYc8
         Idc61tpmD145nA9pt1QW8yEf7V8XPzFYkkQJwEgTvWE+5RHHKYkcyEPkF97W+D0kLd0l
         upFbGPqJw+9QGiM807VTcMyepLFpkSZHmTci9a0P9/T6yBo+17EJJ7q4RpD/2NhOMPLJ
         ibr35iHkkS9OFakQNkqXGqmR8NttdE5EPVJxY/nNfs+iwuFU0EbJDA/9dWlEQuxvFqv4
         hvVw==
X-Gm-Message-State: AOAM530PevnK7XCHrWQ1s8SqdoSuuzy07K8p3AsyNNWI8GtmIBypl8en
        MmrLoQk0lqBT5mgEDj7PXg8ppECFfQKxlE+Wz4THD/TbQoatR9irDhdweeaCct5akXy2GyA4dJb
        1/+Pmj5Smqo8uGS0+bX9F6bqm0JS6KXWIpQ==
X-Received: by 2002:a17:907:c26:: with SMTP id ga38mr2672506ejc.38.1627653814545;
        Fri, 30 Jul 2021 07:03:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWNcPSq0sChCf8yeGm1VCDTCj5y7YK0ZOAnQUkLnjkO9q0Hq9IldEhamlXvjbuzBlZKUTmgQ==
X-Received: by 2002:a17:907:c26:: with SMTP id ga38mr2672213ejc.38.1627653809436;
        Fri, 30 Jul 2021 07:03:29 -0700 (PDT)
Received: from [192.168.8.102] ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id w6sm765114edd.22.2021.07.30.07.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 07:03:28 -0700 (PDT)
Subject: Re: [PATCH v2 7/8] nfc: hci: pass callback data param as pointer in
 nci_request()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210730065625.34010-1-krzysztof.kozlowski@canonical.com>
 <20210730065625.34010-8-krzysztof.kozlowski@canonical.com>
 <20210730064922.078bd222@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <53f89bae-fcb5-8e7c-0b03-effa156584fe@canonical.com>
 <20210730065830.547df546@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <6f609952-cf76-58f9-1917-f06f3f376843@canonical.com>
Date:   Fri, 30 Jul 2021 16:03:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210730065830.547df546@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/07/2021 15:58, Jakub Kicinski wrote:
> On Fri, 30 Jul 2021 15:56:19 +0200 Krzysztof Kozlowski wrote:
>> On 30/07/2021 15:49, Jakub Kicinski wrote:
>>> This generates a bunch of warnings:
>>>
>>> net/nfc/nci/core.c:381:51: warning: Using plain integer as NULL pointer
>>> net/nfc/nci/core.c:388:50: warning: Using plain integer as NULL pointer
>>> net/nfc/nci/core.c:494:57: warning: Using plain integer as NULL pointer
>>> net/nfc/nci/core.c:520:65: warning: Using plain integer as NULL pointer
>>> net/nfc/nci/core.c:570:44: warning: Using plain integer as NULL pointer
>>> net/nfc/nci/core.c:815:34: warning: Using plain integer as NULL pointer
>>> net/nfc/nci/core.c:856:50: warning: Using plain integer as NULL pointer  
>>
>> Indeed. Not that code before was better - the logic was exactly the
>> same. I might think more how to avoid these and maybe pass pointer to
>> stack value (like in other cases).
>>
>> The 7/8 and 8/8 could be skipped in such case.
> 
> We don't usually take parts of series, would you mind resending first 6
> or respinning with the warnings addressed?

Sure, no problem.


Best regards,
Krzysztof
