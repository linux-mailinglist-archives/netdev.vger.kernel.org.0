Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489B733FDC7
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 04:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhCRDZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 23:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhCRDZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 23:25:01 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FAEC06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 20:25:01 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so3907550oto.2
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 20:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7tSF1AK3KquRfTNXwP6DhlFDNuW+4BLEDUPb7CHNWps=;
        b=F90R/qrfED2WA5Ribm0E1vl1wJyDq+YfbNBYGDsgEzD8L0ReuE/DUzm+/vTpG+lc4X
         NlfLyPBKwf+E1+dds3ZcNO7lckIlaP65+wyz/GjAxFxLsT2pWlOZeZ0kzUOsECxZjkZJ
         zsC7vR1/8pIKn9bEpgyOPzapaeHBtHjbg9Cvo11NuOYah4UB2GXbR5P7RIn3xJMHgQIx
         cC8Fk6Irm3AiPhEi4eqrqmM00zl4nvQqAiLctXqEqU7HP1Aim+IPdQYEOUAUN6H8jWFq
         yMKmNP+pGPwTLuSL4GBv0ceg1boq68rtOxMJK1YFpAXydETrs3sSZWD+ZxQXhQF73YgW
         P+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7tSF1AK3KquRfTNXwP6DhlFDNuW+4BLEDUPb7CHNWps=;
        b=GfBjExNUClWaJ3q4Fm28eU7+xMGh9hRzNEqBwLc2D8QM9HHLkYRGMhrr6tUhqV+lvu
         9dEZFSQU+QkhT6c5rFiQoPgNGTCJW/lbuzvQdk2BqBikCDVvBLrsO8nni4AoFLwW+OiT
         CxSRELG6ZDsowWWIwivuqcjYHoS13duD5Vyq9XEEtrV0qJqrJ/W3YU5wSOkC/7TiVkIh
         SLMPPltLkUdwbpYFS0JcPqop1Z24bkeZCAFFxH+tt+jdxZl9R1iAuHtmZvLXA63+eaos
         QN5Bel+XNEZFY/peTy7tenOQ+72alL+v13Pdc4WQSoPvohFUHQRrysl1kRa08vvEaVRw
         DLKw==
X-Gm-Message-State: AOAM532jk6CwS6oQD251O+tswVu/UfcKM0w1/6D0xvMdPqcypFPVcT+M
        q5s9dtkCbvlOOtijFFyutA8=
X-Google-Smtp-Source: ABdhPJzrwXw351O8jKFxqTmA3D5+ubNB59Dz9hQuvBR5QOauVH0mYPm71alWd6r5t/FTAGiNbs5SgA==
X-Received: by 2002:a9d:7f8a:: with SMTP id t10mr5722357otp.239.1616037900491;
        Wed, 17 Mar 2021 20:25:00 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id l190sm251843oig.39.2021.03.17.20.24.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 20:25:00 -0700 (PDT)
Subject: Re: [PATCH V4 net-next 5/5] icmp: add response to RFC 8335 PROBE
 messages
To:     David Miller <davem@davemloft.net>, andreas.a.roeseler@gmail.com
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dsahern@kernel.org
References: <a30d45c43a24f7b65febe51929e6fe990a904805.1615738432.git.andreas.a.roeseler@gmail.com>
 <202103150433.OwOTmI15-lkp@intel.com>
 <72c4ccfc219c830f1d289c3d4c8a43aec6e94877.camel@gmail.com>
 <20210317.201948.1069484608502867994.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <34107111-5293-2119-cfc7-8156c43ae555@gmail.com>
Date:   Wed, 17 Mar 2021 21:24:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210317.201948.1069484608502867994.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/21 9:19 PM, David Miller wrote:
> From: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> Date: Wed, 17 Mar 2021 22:11:47 -0500
> 
>> On Mon, 2021-03-15 at 04:35 +0800, kernel test robot wrote:
>> Is there something that I'm not understanding about compiling kernel
>> components modularly? How do I avoid this error?
> 
>>
> You cannot reference module exported symbols from statically linked code.
> y
> 

Look at ipv6_stub to see how it exports IPv6 functions for v4 code.
There are a few examples under net/ipv4.
