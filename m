Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FE31D7C1E
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgERPAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERPAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:00:32 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B40BC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:00:32 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id h10so10861612iob.10
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=St0XOfKMZeET6pBPld7O8v25pNt751gRsZIgxhPamRE=;
        b=D0rBGGhfh9ddjRGJCC2WT/Lr+gAcswb1Vujpk1s2GtJU4tpOzz/uf+1y29I4c7JSOm
         o71yfrfL66HnhUtyISXoym30FTrVyw4n5ZxzxUa7KgWbCElrCvwZpm5//zw984WX4nvH
         p+hlf8rwQMU7aS7oNe3/pl/TCfc2s6gqGtflA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=St0XOfKMZeET6pBPld7O8v25pNt751gRsZIgxhPamRE=;
        b=tN+t0UpKPp9MQwZ3haUJb3YkDQwkjhm9Jfc9qaW/ljTV8oJiPOc7Wjz/Wclx8aZxWh
         Ud+I64jdn2JjsPuQS9u3p6MhICFIcO4prJenw1UKsaLXWO1mHW5US2B3hYikabLMNd8j
         ezBi2dZRl7wjILUtQ0etQp3Ps5kSIePR2IQNw9lugNcpMcFdgbFHpWmdnJBM1F5nrQ7+
         FUCca6SaL33QJRiPcZMrtoJ2hfZKL5uy1ORiSyt3+kFjEBMgEAjCbsg56Mkx+m3KNJoq
         tbQpb3x1alwNKl1nXRaBf/higNUG/QH533Dk2J4Y+93o4S9zRx8wgJHSsbYCySrXHkQc
         nM9g==
X-Gm-Message-State: AOAM533AitGfJchfBVvHfoQzBSLDIJIoRxLdpgpyG4JebSq9cA8wpsZn
        +1hw0xwUTGacUDKfKmuKnuJigA==
X-Google-Smtp-Source: ABdhPJzDcfTOWmWKIJ6HodA4E+KpW3cEphwvAbx/tdc1Mem8F6bjZs2owKDuECxK1hEaGv/MLSlVcw==
X-Received: by 2002:a02:7f42:: with SMTP id r63mr6649100jac.32.1589814031154;
        Mon, 18 May 2020 08:00:31 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id l7sm4890345ilh.54.2020.05.18.08.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 08:00:29 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ipa: Remove ipa_endpoint_stop{,_rx_dma}
 again
To:     Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Cc:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200508194132.3412384-1-natechancellor@gmail.com>
 <20200508225213.5e109221@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <fdb0b789-bee0-e3a1-546f-24ff94da2dd2@ieee.org>
Date:   Mon, 18 May 2020 10:00:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200508225213.5e109221@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/20 12:52 AM, Jakub Kicinski wrote:
> On Fri,  8 May 2020 12:41:33 -0700 Nathan Chancellor wrote:
>> When building arm64 allyesconfig:
>>
>> drivers/net/ipa/ipa_endpoint.c: In function 'ipa_endpoint_stop_rx_dma':
>> drivers/net/ipa/ipa_endpoint.c:1274:13: error: 'IPA_ENDPOINT_STOP_RX_SIZE' undeclared (first use in this function)
>> drivers/net/ipa/ipa_endpoint.c:1274:13: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/net/ipa/ipa_endpoint.c:1289:2: error: implicit declaration of function 'ipa_cmd_dma_task_32b_addr_add' [-Werror=implicit-function-declaration]
>> drivers/net/ipa/ipa_endpoint.c:1291:45: error: 'ENDPOINT_STOP_DMA_TIMEOUT' undeclared (first use in this function)
>> drivers/net/ipa/ipa_endpoint.c: In function 'ipa_endpoint_stop':
>> drivers/net/ipa/ipa_endpoint.c:1309:16: error: 'IPA_ENDPOINT_STOP_RX_RETRIES' undeclared (first use in this function)
>>
>> These functions were removed in a series, merged in as
>> commit 33395f4a5c1b ("Merge branch 'net-ipa-kill-endpoint-stop-workaround'").
>>
>> Remove them again so that the build works properly.
>>
>> Fixes: 3793faad7b5b ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
>> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> Applied, thank you!

First, I want to apologize for not responding to this earlier.  There
are some problems with my mail filters and am only now starting to go
through some of these messages...

Thank you Nathan for the fix and Arnd for the review, and Jakub for
merging it.

> I think I already said this, but would be great if IPA built on x86
> with COMPILE_TEST..

Yes I intend to add this but it was not as simple as I had hoped
and other things have had priority; sorry about that.  Soon.

					-Alex

