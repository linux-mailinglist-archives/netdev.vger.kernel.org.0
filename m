Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A135A386F8F
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346117AbhERBq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbhERBq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:46:26 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FD5C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:45:08 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id u144so8285597oie.6
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZJziYTAXbYyxOHrtPdcHZrzuuy3KIyx0KXWoSjbfokk=;
        b=C+h5MwwlIjbPPYNuXpniPnFtLItjzCXkLc2p/CJAcMxiSz1MrBFNdWtZt2B7XD9GKx
         FAsZp2bPQ6V8iHLE8wsjiPCUftf6TcfNTgBZD6C+7P9QunaQjX4vx6hBcxwx0Ji6QT5Z
         eCt4ot5xhba01zrmUVjXzra9A9b7YHkqt4S5hLHgSoQraYvuZGvaOlMcFRUp0Et8rPsY
         O8q61jQMr56guDsikVitQXT0NhSHOOkcLaSbp7+mu73WK8xjGXTONn8SPuqaN1l+LhK2
         Lt+2Q9cJbnnZnl/ohGHSBkyzlpXYYKX9BZ2VUnz5FtiToQqB4LqZVV2hjrWHdagkFtBp
         0RHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZJziYTAXbYyxOHrtPdcHZrzuuy3KIyx0KXWoSjbfokk=;
        b=W5EJ3W07vYo8M7bXJh9aPsDMJQZ4wb7cbD2OOHTBo8Qc/rIpimhHb1swCj2wjdbZYJ
         A37+9BQn6PoR9Arjgbsn/E6T6OQTp3LghNpACnIzz7OMCcS3plnaC1xKEQrdQHg16E7L
         obfxfp9CK1Ka6kLwVFugp/OEg8GCoND6evp6qmPufgtElyer4Mv5p09p2zhrzeg991wA
         d3t/5I0hES7lAaKr2p+KPG2D7rMqvQ9IsOJhD1wCp5Dr2x6cycNZC9HmSEg52e72opVq
         9psKH6NIgKpXCAFBN/QDtkRJ+PGjf/JhJiBABur+KJD+n7cuBpqoWmz1Z9CgBh4f/KZF
         xNmw==
X-Gm-Message-State: AOAM530HDei28QAynP9/t6mQ3G+F0SAtVl7KGB4okOCAlukl/2i80OUU
        K873629w3cs9Ps9PW2OPyEs=
X-Google-Smtp-Source: ABdhPJwiDNx5Pk8t0FNUg24FK6p4VJsyLCi/n0nJ1TLIg1JJU95rck5qKO4GEd5iU/D7CXEnVVZ0Qw==
X-Received: by 2002:a54:4385:: with SMTP id u5mr1524784oiv.30.1621302308390;
        Mon, 17 May 2021 18:45:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id j16sm3496119otn.55.2021.05.17.18.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 18:45:08 -0700 (PDT)
Subject: Re: [PATCH net-next 07/10] ipv6: Add custom multipath hash policy
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com
References: <20210517181526.193786-1-idosch@nvidia.com>
 <20210517181526.193786-8-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c5125dc6-2f0e-1678-5fdd-eb99273858bf@gmail.com>
Date:   Mon, 17 May 2021 19:45:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517181526.193786-8-idosch@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 12:15 PM, Ido Schimmel wrote:
> Add a new multipath hash policy where the packet fields used for hash
> calculation are determined by user space via the
> fib_multipath_hash_fields sysctl that was introduced in the previous
> patch.
> 
> The current set of available packet fields includes both outer and inner
> fields, which requires two invocations of the flow dissector. Avoid
> unnecessary dissection of the outer or inner flows by skipping
> dissection if none of the outer or inner fields are required.
> 
> In accordance with the existing policies, when an skb is not available,
> packet fields are extracted from the provided flow key. In which case,
> only outer fields are considered.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  Documentation/networking/ip-sysctl.rst |   2 +
>  net/ipv6/route.c                       | 125 +++++++++++++++++++++++++
>  net/ipv6/sysctl_net_ipv6.c             |   3 +-
>  3 files changed, 129 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


