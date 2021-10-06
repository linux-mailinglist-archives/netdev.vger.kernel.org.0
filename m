Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3E4424034
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238938AbhJFOjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhJFOjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 10:39:21 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F53EC061749;
        Wed,  6 Oct 2021 07:37:29 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id k13so3078295ilo.7;
        Wed, 06 Oct 2021 07:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yv7yNKcy2en1hk++iJIvYqFYaQbZr8k9gLUhdiF2vRg=;
        b=LHiWOjUUIutPq9q80jg+2pZIVeX+EDcmk5GwDc6qWaIFiRMFKcmnxx2NbiDm3Y2+9T
         RRVn5Z7xrO3jFvkiFpGcjwgbzwhknAq6xzHmU8yxiUfPn/bDZe6qHeoR1Rqicy74y/Rs
         GI+4y2bPhgCAZZpCMmNKPeQmWytHRb74i2TaSEt8bBJASpJifwLJsSVyks+B+P32XR6D
         cBXKc1H02zzMuzq1suKm18nLLmPFZJxnjt6NKVILDdE7E5e6ULDjOvjA+MR4sy1XyRVi
         zW/ZnFDdj+RIW6OLvlQNttjHZrL724/ruv4tSfziOf3FEoEshJ0PYs3MdSFtdglhIprU
         TDyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yv7yNKcy2en1hk++iJIvYqFYaQbZr8k9gLUhdiF2vRg=;
        b=b/js3Z4rN0nSRxMaonYLdFIVcDN7dwG/dGSw8R7gYC/4+6nwGgCeX6DvBlBbaVCdrG
         8uikFNb+k/eCB2zdF8LbOAC4jDtMYLVMuceMXNvfdsvkljB2QyX09xwnZrQSjtnQRpyz
         MGGV8DsF6fAenBsHbKVtCCrBbPwund+8JBX55Uni7QKS8zKcL7exDh7U4tRkXUTwNX2c
         7tOD+vbB1eFvy8NVCttVQweQy3nzAnXkbn/jeXI3e2PXoHL3lgBBkvBr87r9EO84v58o
         3uRoLMRog8wA1vy5b5/bcY+3OCacu65YXUjqBHJnh0OxxEdP/ZOlMNUt0T3djCjdiCO/
         t9qw==
X-Gm-Message-State: AOAM532YSs/JoQA12XNkbRRYeqntiUkHj0EOxvginlbYDNFqVLI5Zc6O
        HcoGoYlFPBicVDARrqT1sXqz3Lxd6W7VdQ==
X-Google-Smtp-Source: ABdhPJwVtBeq1ay0QGpzmxTcVpudO7gBKydsQqJLd2v9mSOUdQKt+zu+qrTyXuwKqxuzYhbUOa56nA==
X-Received: by 2002:a05:6e02:1529:: with SMTP id i9mr1653704ilu.201.1633531048625;
        Wed, 06 Oct 2021 07:37:28 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id w9sm4284946ilq.73.2021.10.06.07.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 07:37:28 -0700 (PDT)
Subject: Re: [PATCH 01/11] selftests: net/fcnal: Fix {ipv4,ipv6}_bind not run
 by default
To:     Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <44c1cf86c0ff6390f438e307a6a956b554a90055.1633520807.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2a09f8b5-1507-ca00-74d1-d6a1d8b848bf@gmail.com>
Date:   Wed, 6 Oct 2021 08:37:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <44c1cf86c0ff6390f438e307a6a956b554a90055.1633520807.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 5:47 AM, Leonard Crestez wrote:
> Inside the TESTS_IPV{4,6} array these are listed as ipv{4,6}_addr_bind
> but test running loop only checks for ipv{4,6}_bind and bind{,6} and
> ignores everything else.
> 
> As a consequence these tests were not run by default, only with an
> explicit -t.
> 
> Fix inside TESTS_IPV{4,6}.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Good catch.

Reviewed-by: David Ahern <dsahern@kernel.org>


