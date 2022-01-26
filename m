Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479DE49D63D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 00:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiAZXh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 18:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiAZXh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 18:37:26 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB8EC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:37:26 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id d188so1542107iof.7
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=uPaXjQanz7oeDUKpe/z0iPCdQNj59OiPJFZ5vJw6ihE=;
        b=YNA7zKwvDX9sk6DBI/l4OMGHB+Q18jiM1ZC1LrdYXL7tU1/4wN0/Lnz0I3/irlFtZc
         H2xn+WFv/RhbUxSSfaS+EsafWqm2uZYoA17JhCRLuF9RVb1t2Rb/tCV/xdFApVRYY6lW
         KsYQngh5p+Cv+TUYVaSNtMjs/Y18toL5spyuFaLXddbjEtSmOoPME36/9f1w3jnoBc9V
         oX8yvUE+QTRrMSGymwjC91iM+8qUXf38iX9vN+RGYLO+7TfPpZdEJzfdEgk/cehnzNYf
         I2v4ZbcAf8OnFhT/nuFm98VQcrumJxyba8+WkVSsC0Vbu3oNeYgomnW/i7B/SIwvj6tB
         8hFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=uPaXjQanz7oeDUKpe/z0iPCdQNj59OiPJFZ5vJw6ihE=;
        b=NscKXOgMbjedlMbcwrLSNg1J45cWUykOAga3JE9zTqK69un/LiGE/+Qa3awuwk6rG2
         N9WvbkbV6TBHLwqCOHpqqUqECJwL7Zef9M9cUuKdJa6DKqIppaaAL+gsWFn17O9U9MK4
         JCFBHn9sB50a6ebrEi7bVhiaqtYs7jh9bx1wzqu+7LopUG++eewSFdkW46RqWiDlT2Ip
         iksos6dhTUx01GyC5+N6hchOPKxc0ZfWHMbEIs1A9jhPpSZhm4Jqw4GVzAZY/b449HlX
         i6HJ5RxUSAS5NI0v4QeIS+B8QSdDpm2POuNpHs/+JpPv5BYYTqbW/+E4hhhqt+9bJo/g
         wZaA==
X-Gm-Message-State: AOAM5328B3PNvQIs8iLn1BIDCqsL9gmmf/bn7Zruqv7rDLXwpP+f78g4
        W6pNnMOxl/OYSV3nLGHjxgxlhA==
X-Google-Smtp-Source: ABdhPJzy/zp+ZiEqoJ3Sg8od8PKnru1w3M6rUO7uHarx4gTzshd68UBnEKZrOKL6c96nJQae7/Okmg==
X-Received: by 2002:a6b:d80c:: with SMTP id y12mr578892iob.31.1643240245398;
        Wed, 26 Jan 2022 15:37:25 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id o11sm11205991ilm.20.2022.01.26.15.37.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 15:37:24 -0800 (PST)
Message-ID: <36491c9e-c9fb-6740-9e51-58c23737318f@linaro.org>
Date:   Wed, 26 Jan 2022 17:37:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: IPA monitor (Final RFC)
Content-Language: en-US
From:   Alex Elder <elder@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
 <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org> <YeLk3STfx2DO4+FO@lunn.ch>
 <c9db7b36-3855-1ac1-41b6-f7e9b91e2074@linaro.org>
 <20220118103017.158ede27@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <f02ad768-2c8e-c8ed-e5f6-6ee79bf97c06@linaro.org>
In-Reply-To: <f02ad768-2c8e-c8ed-e5f6-6ee79bf97c06@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In previous messages I explained how the Qualcomm IP Accelerator

(IPA) sometimes has the ability to replicate all packets it

processes, and supply those replicated packets to the main

application processor (AP).  I initially suggested using a network

device as the interface for this, but after some discussion, Jakub

recommended using a debugfs file to supply these packets.



Below is basically a specification for the design I'll use.  It is

what I intend to implement, so if anyone has any objection, please

voice it now.  I'll be sending this code out for review in the

coming few weeks.


Thank you.

					-Alex


- A new debugfs directory "qcom_ipaX" will be created for each IPA

   instance (X = IPA device number).  There's normally only going to

   be one of these, but there is at least one SoC that has two.

     /sys/kernel/debug/qcom_ipa0/

- If an IPA instance supports a "monitor endpoint", a "monitor" file

   will be created in its "qcom_ipaX" directory.

     /sys/kernel/debug/qcom_ipa0/monitor

- The "monitor" file is opened exclusively (no O_EXCL needed).  An

   attempt to open that file when it's already open produces EBUSY.

- The monitor file is read-only (S_IRUSR), and does not support seeks.

- Once opened, "monitor packets" (which consist of a fixed size

   status header, followed by replicated packet data) will be

   accumulated in *receive* buffers.  If a replicated packet is

   large, it will have been truncated by hardware to reduce

   monitoring bandwidth.

- Once opened, reads to the monitor file are satisfied as follows:

     - If no receive buffers have accumulated, the read will block

       until at least one monitor packet can be returned.

     - If the file is opened with O_NONBLOCK, a read that would block

       will return EAGAIN instead of blocking.

     - A read that blocks is interruptible.

     - A valid monitor packet is supplied to user space at most once.

     - Only "complete" monitor packets are supplied to the reader.

       I.e., a status header will always be supplied together with

       the packet data it describes.

     - A *read* buffer will be filled with as many monitor packets as

       possible.  If they'll fit in the read buffer, all accumulated

       monitor packets will be returned to the reader.

     - If the read buffer has insufficient room for the next

       available monitor packet, the read request returns.

     - If any monitor packet received from hardware is bad, it--along

       with everything beyond it in its page--will be discarded.

         - The received data must be big enough to hold a status

           header.

         - The received data must contain the packet data, meaning

           packet length in the status header lies within range.

