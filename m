Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5AD4804A1
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 21:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbhL0Ulg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 15:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbhL0Ulf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 15:41:35 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8B7C06173E
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 12:41:35 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id a9so14677524qvd.12
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 12:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HEblb4NcyHjgy+hG9JwZ6BIZVjaEPFiRSkzq3qx7O5s=;
        b=M/svcAs3jlY7Prg+Rl0odk2/+T3H8QS/j5nMgvetdX84NaIF7xbTfhi4VdGuYCX9+A
         VmmiFd6D/iJBKddKyF3YLVsIgv4bL8pVAupR4aaqdh6guUyltbRs3/GSQec43AhLZQkw
         beoYT6ZrH8VZJm4n3ifkfmUnpGVYBswrtMuYJ3dqVz3+GUPXKSBmWw7S6vwTmp1PF1Y0
         zonOjmtfnwMbZn0Ly1s3Prg56tt2yfLJ+C14D0Vrb+QTgcDuIZf2+jd3OfY0RFuKKP2N
         +zySZ6jZoHt1igci4tJB3eLLAcDV013yfLCyK7CEZXDjF1loBKwTviRNZ5T0s0AwEPhy
         ymaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HEblb4NcyHjgy+hG9JwZ6BIZVjaEPFiRSkzq3qx7O5s=;
        b=os7Iqg8QoQnnLn92Agr+2PhltLQRsifO7DP2n9IPbBSavFAyJFBD/Rt+xMotaSU+p9
         XMFITWvC6Pf5/+3QR7PPbwKLeJKkTNDNcrW9oFiiCf7U6AWxqZ3ASHmXqn70vyKN66X4
         mNSK65Le/08hAu8HDQP1LjMUWLLi6Oe/98+2btu2LZR3vLAlGq3SWdPaAjFKbtMVgOij
         YeMfxaP5JHIYw9trwxVjvckfwg2ExFXgyOjkihIM6vQEMYaqoJZjnndKHCWzqhWh1q+v
         xwbQghuXdFj9tDfXsAZmatsY+lztZsAoJhPOMVJrsds/wfkD/TtVlrVg4/NsqK2q883Y
         ANtQ==
X-Gm-Message-State: AOAM533Pl2M1UOrFQiPWarbqO6dsv0hnKStjoq3x0IJw+4l1hOq4WJDm
        YEbyVyblBYVC7F3+I8Q06XxmCQ==
X-Google-Smtp-Source: ABdhPJypWnA4YaLiN2H5DrhKGjxH1UB/Yn66D6fjJc5aYNghXRDHGDaSbM+RG1KrwWk07f3qu059QA==
X-Received: by 2002:a05:6214:4019:: with SMTP id kd25mr16808588qvb.59.1640637694032;
        Mon, 27 Dec 2021 12:41:34 -0800 (PST)
Received: from [10.0.0.29] (pool-96-236-39-10.albyny.fios.verizon.net. [96.236.39.10])
        by smtp.gmail.com with ESMTPSA id b6sm14125137qtk.91.2021.12.27.12.41.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Dec 2021 12:41:33 -0800 (PST)
Message-ID: <4cdfcc90-67c4-1cf2-1fca-76376a122454@sladewatkins.com>
Date:   Mon, 27 Dec 2021 15:41:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] qlge: rewrite qlge_change_rx_buffers()
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Adam Kandur <sys.arch.adam@gmail.com>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev
References: <CAE28pkNNsUnp4UiaKX-OjAQHPGjSNY6+hn-oK39m8w=ybXSO6Q@mail.gmail.com>
 <YcnA8LBwH1X/xqKt@kroah.com>
 <152c8d76-af2b-2ea3-4f15-faf2670d8e73@sladewatkins.com>
 <YcnRg9AYfSgC1pBE@kroah.com>
From:   Slade Watkins <slade@sladewatkins.com>
In-Reply-To: <YcnRg9AYfSgC1pBE@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/27/2021 9:45 AM, Greg KH wrote:
> On Mon, Dec 27, 2021 at 09:15:36AM -0500, Slade Watkins wrote:
>> --
>> This email message may contain sensitive or otherwise confidential
>> information and is intended for the addressee(s) only. If you believe
>> to have received this message in error, please let the sender know
>> *immediately* and delete the message. Thank you for your cooperation!
>>
> 
> Now deleted.

my bad! I have separate signatures set for mailing lists but for some
reason it didn't remove that blurb.

it's fixed for the future.

sorry about that.
slade
