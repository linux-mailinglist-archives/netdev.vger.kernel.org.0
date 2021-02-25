Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C86325275
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhBYPa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhBYPaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 10:30:55 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE49C061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 07:29:18 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id q9so5268810ilo.1
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 07:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N/p0Ouq5Gx5/1pe82Ydybk60Eu2zL8qEPa4Wa2rPVwg=;
        b=Q6+pKjJiyFU6c9v41N/6toFCdHsI3u7cOCHS03gUhNVzG9N6YGsyp4c62iLbeRtCKc
         jGKUGEUYKjzydBI1DTAwf96O66YgY5YigP4jGjGRYhAY1v9ef8+YueIpelUe810Y8Hdq
         x1b0T9mi1R79EVu9LN3oKpQaKS4+SbnaZ44iM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N/p0Ouq5Gx5/1pe82Ydybk60Eu2zL8qEPa4Wa2rPVwg=;
        b=sSTs+poIPm7DLKmfkKbQCMFIAaSiqmRZf/zFQbaqA9QO0/L8+fO3TgvV4ajWaR5WP/
         m6Vg9i9784qQ0L56wOoIXuXlckQkNvislC1XJQKUow8nq2q+yRFQ3fDImmDF7HIm9qf5
         6LbKu3K0YE336GTvMAW86Na+tT/1n4SyV6xn8Y59IKmJp0v06AN3ikG9h0bbRDgB5qsQ
         FRGBOAc1T7DsdQlrIp6H8kwIkzKJ53YA2492zy0vRChO6VCLu23AJZ4uIH5BJez8lGL9
         srG2Aq3V1rTAtFYv+cfaRrMpEdoJXclK55uMzYC7BKVW+UQCnUcV+47TJCk/UdcV2fwq
         /hEg==
X-Gm-Message-State: AOAM531Qooc4NwMB/FtSU5ALSLG1G6j3DHmJZM1KZF46F54q2rY/tLcG
        uywHYhuWzFr4ZRJlM1orlL+AvklMepVmVg==
X-Google-Smtp-Source: ABdhPJxsToSaxizKtwqi9lsBXnLvmKOPMx+LDkUYyYK+j8fc4p4BFVmTX8eUbkovQYZ/PsaVEp9Usg==
X-Received: by 2002:a05:6e02:c2d:: with SMTP id q13mr2834677ilg.83.1614266958252;
        Thu, 25 Feb 2021 07:29:18 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k11sm3288063ilo.8.2021.02.25.07.29.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 07:29:17 -0800 (PST)
Subject: Re: [PATCH net-next v3 2/3] net: ethernet: rmnet: Support for
 downlink MAPv5 checksum offload
To:     Jakub Kicinski <kuba@kernel.org>,
        Sharath Chandra Vurukala <sharathv@codeaurora.org>
Cc:     davem@davemloft.net, elder@kernel.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1614110571-11604-1-git-send-email-sharathv@codeaurora.org>
 <1614110571-11604-3-git-send-email-sharathv@codeaurora.org>
 <20210224102307.4a484568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <866808f2-d6aa-f887-a11d-8d9ec741188d@ieee.org>
Date:   Thu, 25 Feb 2021 09:29:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210224102307.4a484568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/21 12:23 PM, Jakub Kicinski wrote:
> On Wed, 24 Feb 2021 01:32:50 +0530 Sharath Chandra Vurukala wrote:
>> +/* MAP CSUM headers */
>> +struct rmnet_map_v5_csum_header {
>> +#if defined(__LITTLE_ENDIAN_BITFIELD)
>> +	u8  next_hdr:1;
>> +	u8  header_type:7;
>> +	u8  hw_reserved:7;
>> +	u8  csum_valid_required:1;
>> +#elif defined(__BIG_ENDIAN_BITFIELD)
>> +	u8  header_type:7;
>> +	u8  next_hdr:1;
>> +	u8  csum_valid_required:1;
>> +	u8  hw_reserved:7;
>> +#else
>> +#error	"Please fix <asm/byteorder.h>"
>> +#endif
>> +	__be16 reserved;
>> +} __aligned(1);
> 
> This seems to be your first contribution so let me spell it out.
> 
> In Linux when maintainers ask you to do something you are expected
> to do it.
> 
> You can leave the existing bitfields for later, but don't add another.

As I offered, I will implement changes to the existing
code to use masks in place of these C bit-fields.

I will try complete this within the next week.  If it
looks good it could serve as an example of how to go
about it.

					-Alex
