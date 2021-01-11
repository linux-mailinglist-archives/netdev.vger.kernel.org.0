Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5036B2F1A60
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 17:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733156AbhAKQCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 11:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728440AbhAKQCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 11:02:47 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E2DC061794
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 08:02:07 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id d203so20654277oia.0
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 08:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2Mc0Vq6UCJUNk8q4pFfqdR3OG/5A8wKpaTsnBQEgPro=;
        b=Iu7QmIlxR8k2jhZb6AkgoF1vCpOJmH59JG0RXqqCsbBRXJ0kuq8uJxNfLr87K5cvbs
         Y2iIi08IiKxI6ZWDNV5ROX/LiACa4XlzDSNXm6LvBMTAivsaWmzjA8qzRlMJE2iOQYHX
         CFKtK3bBHU454HP9C+j0fmPCdqZZNzvpqP2Ab7CT9k0j6AEylvAlEUzkhKZxIjXgY2F9
         DO5lV/3ZMeEAZab3MSKiCJ5cp9H0mEA7DI2e54a3eGAicNuMqp53lLbgi9Bw1dR02lvR
         5ZneuuoHtWpw8cSA/daqMoEgAezJsEu52NwanQ274bc6/YBlOZt/HXJrNEEaYtHDpyMx
         pq8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Mc0Vq6UCJUNk8q4pFfqdR3OG/5A8wKpaTsnBQEgPro=;
        b=WwCjQmkmAdZUQThGc8ojDiySZCqTBmIdVaYlxC73k7tXPeFdj8QVJt+cBv+dY3k0Qq
         /KMmINlYN9XNzVqJ9CXe2pdYRoxRJCdoeBDdmeV5M1p7uSSH3WllxHeryD3yfGYzPMVa
         n4oFiVs6caBlA1onD8LZhy4Ufc5KMZRTKn3Cz5uc0vUo9khFTSzlMssyO09wImAsAjNN
         y9N1U74Y+XXtTv7n9JxGx2oNLjwLLJFDf4ZjCUTqbAZSm1+FWxw7VdlqYeVbhTemJoul
         7RwCrAWL+e0GzD1wby6L0SsxxhfBqeB6g+hzxsjknm5p4f6fgS5oF6a8K/VoKvlPK+DC
         krYQ==
X-Gm-Message-State: AOAM531cz+KRKZ90K453UkvG04fzcow1kZsClJOhvdDjMPZN8X2L9apO
        1Y/tOBeJyfwi+ma9fdEG0AiLo9JH6sU=
X-Google-Smtp-Source: ABdhPJyCrvTs92ko1L+hjYseFaINOez0skFCvVFEo/dwGq2/BUJWDnMSS8PiFQYWPlW+MTODEgiIkg==
X-Received: by 2002:a54:4489:: with SMTP id v9mr35844oiv.154.1610380926331;
        Mon, 11 Jan 2021 08:02:06 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id g5sm32580otq.43.2021.01.11.08.02.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 08:02:05 -0800 (PST)
Subject: Re: [PATCH iproute2] tc: flower: fix json output with mpls lse
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <1ef12e7d378d5b1dad4f056a2225d5ae9d5326cb.1608330201.git.gnault@redhat.com>
 <20210107164856.GC17363@linux.home>
 <20210107091352.610abd6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <31cfb1dc-1e93-e3ed-12f4-f8c44adfd535@gmail.com>
 <20210111105744.GA13412@linux.home>
 <68d32b59-4678-d862-c9c5-1d1620ad730a@gmail.com>
 <20210111154422.GC13412@linux.home>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <80bab0bc-3c02-b6d1-3e67-90fdab912864@gmail.com>
Date:   Mon, 11 Jan 2021 09:02:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111154422.GC13412@linux.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 8:44 AM, Guillaume Nault wrote:
> On Mon, Jan 11, 2021 at 08:30:32AM -0700, David Ahern wrote:
>> On 1/11/21 3:57 AM, Guillaume Nault wrote:
>>> Okay, but, in the end, should I repost this patch?
>>
>> I think your patches are covered, but you should check the repo to make
>> sure.
> 
> This patch ("tc: flower: fix json output with mpls lse") doesn't appear
> in the upstream tree.
> 
ok, you'll need to re-send.
