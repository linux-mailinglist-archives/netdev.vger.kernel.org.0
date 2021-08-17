Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE743EEED7
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 16:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238187AbhHQO5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 10:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbhHQO5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 10:57:46 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEA2C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 07:57:13 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id bj40so32317685oib.6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 07:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yv1qYYLhRD1NW2g1uB02R9u05IJGaCnltMYC2697Fak=;
        b=GZh2duqIOssE/Nr/hBD8CVUbJM823P9lXaHaasoVMkTWcMx6ZpTUYPd0POwEOaD10/
         bA6obL+moDtkqxs42grgyGIQ8U1iB71DNI1+TMHYXTAQ7asFIFN/wbu7yfz730YKM8Jj
         WiipyQZFHxKFh4yxD2efDTGG3xBZgFomYSmsi262wakcHzUpBB+OrNINh3/5N13G+gkq
         OMAucVzXE8lJHSROgOftxdOKqPUPitr+UicAh3acBEs6vzK8YKmO5Ty7huyFXeL5MhZh
         beNYxWPr3xCCxtKRtRsT5iujLOR3PcnkR/UiyxeGBXQWsAX3MPBQ4mdUchD+w6oUrMBY
         C80Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yv1qYYLhRD1NW2g1uB02R9u05IJGaCnltMYC2697Fak=;
        b=eDwH6E5J0aBnJuNJ5yVi3zJyxWtK0yYyhsUSGpdwwhDP1JMRJIEbfH6PeKQNlmdxZw
         oObJXbcgTxT9aVW8crOAQRHBkqA8J2xxnwtrSM5lSH7ihqZf0bThKKfHZDRByLdgriRk
         8gH74TcBJkcBTl0FFIzCk8hOTUBLVjOZWe7ob70N8bTCzVo9M0Xb/fxCEIVSs2bfSQXV
         Kg2oi1/WFiSE3jGjUuvYYrkbqk/voo9MYd+WDwxD3+NMQ/n3gIqzc4PeizwA9IKhoj1X
         WCBWSGu62w6GDzPTMh5iCwblRmcIgl+iMFWjsTaxqX4M+ifeh3A19sKC/U+BlTvxnGkB
         r9Sw==
X-Gm-Message-State: AOAM5304FvIKuRo/vHIzV2bRFQ4zXPSzQM4YNarJaiNLEGOUkYUl1loz
        /srWBIpog13mXGr1grTYFilEdfT4EyY=
X-Google-Smtp-Source: ABdhPJxu3jWrvMJ4A2a9zk3LDEoiwt5YIpDie4j/7kWA8p2FwSic/wTD4GqYvqwdXK8BO/5O8S9wzg==
X-Received: by 2002:a05:6808:657:: with SMTP id z23mr2903085oih.113.1629212232577;
        Tue, 17 Aug 2021 07:57:12 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.6.112.214])
        by smtp.googlemail.com with ESMTPSA id b11sm463560ooi.0.2021.08.17.07.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 07:57:12 -0700 (PDT)
Subject: Re: ss command not showing raw sockets? (regression)
To:     Jakub Kicinski <kuba@kernel.org>, Jonas Bechtel <post@jbechtel.de>
Cc:     netdev@vger.kernel.org
References: <20210815231738.7b42bad4@mmluhan>
 <20210816150800.28ef2e7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1dafd125-cd9f-f05c-a133-80d72b2fe99b@gmail.com>
Date:   Tue, 17 Aug 2021 08:57:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210816150800.28ef2e7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/21 4:08 PM, Jakub Kicinski wrote:
> On Sun, 15 Aug 2021 23:17:38 +0200 Jonas Bechtel wrote:
>> I've got following installation:
>> * ping 32 bit version
>> * Linux 4.4.0 x86_64 (yes, somewhat ancient)
>> * iproute2  4.9.0 or 4.20.0 or 5.10.0
>>
>> With one ping command active, there are two raw sockets on my system:
>> one for IPv4 and one for IPv6 (just one of those is used).
>>
>> My problem is that
>>
>> ss -awp
>>
>> shows 
>> * two raw sockets (4.9.0)
>> * any raw socket = bug (4.20.0)
>> * any raw socket = bug (5.10.0)
> 
> Could you clarify how the bug manifests itself? Does ss crash?

I take it kernel version is constant and iproute2 version changes,
correct? Can you download the source and do a git bisect?

> 
>> So is this a bug or is this wont-fix (then, if it is related to
>> kernel version, package maintainers may be interested)?

