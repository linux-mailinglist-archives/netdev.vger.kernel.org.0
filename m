Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7699058D94D
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 15:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbiHINVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 09:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238977AbiHINVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 09:21:47 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4242D2AEC
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 06:21:46 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id w19so22177066ejc.7
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 06:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=kCTiqnFNAqQS+jD6GnofJbNSqiRf66kp9c7QVWfP1sQ=;
        b=BhxEGG53eZEGbTgloYggbHjvLiX1201xT3BQFJwuo9rovW8AE4RlRMi+vm1dPsO3i5
         xmj9+UCWS1baOc4UcpzLL0VOug9CVT2FzaIeAaCCKfvNUDc6GvXIWkwmJYkEP9Ix3PIk
         NLEdafAGOsCCEWSUw3A7hliqJ4uFUXFKTVddV6dr4YsNhuOWI8U5cHGJrp+BkvACww+A
         01XcA9LGyRPzHZCpPLosQf+e5sulkIh30gguz0AcB7uBcNY8HI7bj+mKdWYUA3fjKm0Y
         PKXMvgPsfbGn/Q3rwhxQkckNuMYpIXnc58wb9QS9TKbkw31HbK0oUy/DBwuuHcgA0Jne
         JZiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=kCTiqnFNAqQS+jD6GnofJbNSqiRf66kp9c7QVWfP1sQ=;
        b=6ZWm9OtJwOpTjZLwgQGpGqnOVrNE4qgmOf4l34AFpQBFyx10kAhGU1YaewW9XK0CPc
         xshB8MCyKV8yRxuKQoYfoNBd4gxMEAUpVf6KWSrLyVpUUDEAFO0tiZSV6tuN7p+cAiel
         Cfs+ViMVdcw14M5XiplV17fKLqJSkWYrqnn5GkWHd1i0VZKx0pAV6BeAB9KIDrUs0PiT
         sVkODYZ+6A9u4ht15r6n8gBBh1L+9+URxcX/I06m28tVkt1hrkSNH7y4zkVpBLE193sC
         6QxbRPAMcMHXyNnMe/QgyOXm4qf0Mr9mHAsLKd5R2kieLkFlNOUqMTwSrtCeO3Swjk8R
         wvlw==
X-Gm-Message-State: ACgBeo2gP0nSQWqmCq2Ry8A8pODT+BcQIqX/kmjzxiDyGnfgaV54/GlB
        U6SG5sYscwk4gyhrt4M6zVFWlBI3/1c=
X-Google-Smtp-Source: AA6agR7HDkyR4B6hHSPpSv4G/qsxKAxqPDAYh5r3YHLXSHH1Nud8cNMnt+R2nk9TBDzNjD9IKKkhqA==
X-Received: by 2002:a17:906:4fc3:b0:72e:eab4:d9d7 with SMTP id i3-20020a1709064fc300b0072eeab4d9d7mr16687010ejw.599.1660051304894;
        Tue, 09 Aug 2022 06:21:44 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id x25-20020aa7d6d9000000b00435a62d35b5sm6011789edr.45.2022.08.09.06.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 06:21:44 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] sfc: allow more flexible way of adding
 filters for PTP
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20220809092002.17571-1-ihuguet@redhat.com>
 <20220809092002.17571-2-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <77ad1f68-c83a-eb86-36aa-bf1b8f089d1f@gmail.com>
Date:   Tue, 9 Aug 2022 14:21:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220809092002.17571-2-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/2022 10:20, Íñigo Huguet wrote:
> In preparation for the support of PTP over IPv6/UDP and Ethernet in next
> patches, allow a more flexible way of adding and removing RX filters for
> PTP. Right now, only 2 filters are allowed, which are the ones needed
> for PTP over IPv4/UDP.
> 
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>

(But you'll probably need to wait and respin when net-next reopens.)
