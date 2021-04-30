Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6991A36FC5B
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 16:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhD3O2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 10:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhD3O2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 10:28:05 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F49C06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 07:27:15 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso62672063otb.13
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 07:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dZcLbYYkitcjWuFzCcWQcGe3S05bR2wnS05HymxiqAM=;
        b=X156JNyLhuXH1fEVz8Jf9dHynFNDemQePjn6eUTQlsq98p7PU+dl9C0UZkrYmJpmhQ
         pvNC/ZRO3UHDdYOJOYOiBd9zPQ215afuVQ/IaGBG6eSbvthsbqjMzdeOugZxPJsvpGge
         /itESKuS/GMjxEbRFWT1EM6qA0/sJ1AAe3S9jStuE6Rmg8ZYZ1OGFFvWeJDBx+eHEuKG
         3GB8RsCQel1jkoVXPbvwh3rgpYbOc5seYzBERHBlOzE8iL1c7KbMhVKtNTI2wTtn3/jT
         K7Nc8bLOPXOrsA2wEpUu6J431bFrOfH70HJfIoaKtfdcFW7RYdCc+Y5B6ODaAMhryvVc
         CWWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dZcLbYYkitcjWuFzCcWQcGe3S05bR2wnS05HymxiqAM=;
        b=dvVxvrtQ7Xop1qXxlpt/98ckR6b9Mi60+6bj7lL3OQ/pWtpf2WCm+p9uCxxCfSJm4R
         TqBAdJiw5fnf2CruhNSrhISh4aHx3t0tE1lBKHNWybeCsW84HNLBEGGlP2929a6gOmZ2
         A+MH+9Jd/B9/PyGjkIPyw+qMr32MEWxkoqAWZZ+z9LKt2Tv1DUwD+El4DqpDFH3ydUmT
         eoxuWPMvHNTDGqP72tl+ZUeOZtU09z6EFQ/YTo39q/P8p1z5LS4xnsbANggE2Sd0LNoG
         zvlyS6/hkpwsDV4xaa1U0DIVinrIV2G7oAWgTmTcIlJcgI25HKHGMetplUVMlWd2TGQK
         WPqw==
X-Gm-Message-State: AOAM531WvrYbbbEeyBh+263NLhRvCNWhO8517yW09FVoYq3daX84RiR7
        U33Kxjg9dcn32cmqqHfrWiXQ5PmDsPY=
X-Google-Smtp-Source: ABdhPJwhwdV45wwCcqNT8v17C97Zz0EbqXiL4soYkFtD9uWQedyQeNK23ZelBL8iOkwFgXf2T0LyFg==
X-Received: by 2002:a9d:6317:: with SMTP id q23mr3705527otk.151.1619792835280;
        Fri, 30 Apr 2021 07:27:15 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id p64sm818329oib.57.2021.04.30.07.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 07:27:15 -0700 (PDT)
Subject: Re: [PATCH iproute2] mptcp: make sure flag signal is set when add
 addr with port
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        David Ahern <dsahern@kernel.org>
Cc:     mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Jianguo Wu <wujianguo106@163.com>, netdev@vger.kernel.org
References: <ea7d8eb1-5484-09dc-aa53-cf839b93bc73@163.com>
 <6ec00dc5-de95-566d-f292-d43a3f5cf6cb@tessares.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0544c818-1537-7a7e-0a86-8d0c28aa4797@gmail.com>
Date:   Fri, 30 Apr 2021 08:27:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <6ec00dc5-de95-566d-f292-d43a3f5cf6cb@tessares.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/21 3:35 AM, Matthieu Baerts wrote:
> On 23/04/2021 12:24, Jianguo Wu wrote:
>> From: Jianguo Wu <wujianguo@chinatelecom.cn>
>>
>> When add address with port, it is mean to send an ADD_ADDR to remote,
>> so it must have flag signal set.
>>
>> Fixes: 42fbca91cd61 ("mptcp: add support for port based endpoint")
>> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
> 
> I see on patchwork[1] that this patch is marked as "Accepted". But I
> cannot find it in 'main' branches from iproute2-next.git and
> iproute2.git repos.
> 
> Did I miss it somewhere?

no idea what happened

> 
> If it is not too late, here is a ACK from MPTCP team:
> 
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> 

I'll add the Ack and apply.

