Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7602B1400
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgKMBtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgKMBtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 20:49:20 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C88DC0613D1;
        Thu, 12 Nov 2020 17:49:20 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id e17so7133190ili.5;
        Thu, 12 Nov 2020 17:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BQ92Puz7Cr5zbxxhdU4HMv90FO1qF0BkLsv9lFfnF3k=;
        b=HFQJ8sxKC2Qn8cEAtKP4CJbAUDwp5yBnAGS5WnzCljXjiay3j8zYQsPVA1jhBkjew9
         +5reySojxxlu+gRhMF1TPfYA2UYPj+1BHqeXkg9RoZMyzosaPqRbWFQRHi+C0RO0BDgX
         l5XbHI5g9Jm5w9+QwSux4aozdLOVSikkhh14KfbXem/o8VVFnXfS9OIA9R8xThYC7DRn
         xZGL018MfEz2tOrJyALF3BEAlqvjo/W/4Xyt87UGj9QI7M1k1Bhbq8QrboxvsxglD/gg
         uEvQYl2pkygoX95yJLXgzdQOutDX+6+MARQ0VYhEtwdfkJFWMP7s8iIxmFrMoCSIkv9r
         MIeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BQ92Puz7Cr5zbxxhdU4HMv90FO1qF0BkLsv9lFfnF3k=;
        b=FgyjbmZMlaOsYDXcWqkeXdXrhDq6fsn9jI3ugQ/1HNeuXtY8I+rzw4R8675Tiqv8e0
         KTZ7KIo7i+2O7DnVzrWAu5Cqgc6y1rQGQ7WdfJmBzjDG4fsxvLpNOOkh5axXPQ6bwkEh
         TSdxySgHh/sjB0lsrWlioJ50lcMr8wr2UQEB/8LYozCXzx6yZ7ex/0NlibFAv6HSi2tz
         D24p6rnfWZ8HsbhsbQuv3PJmXUmNAFIG4l3LVYz1o175D4Dk2F8y6/s67G1MLup04GZT
         VaknXrq26mRcTncHx8Gb8HKMfSUcKwFv5HVH3pb11sYkEhwI6hNjWidHxe55blVn8m6S
         IOZQ==
X-Gm-Message-State: AOAM532igOPGbJhFyNDOb1+jRx5DTMDEIxkDuwwMugj4k3z6meEle4S3
        lUZT8AaJQA9wFu88dzUh+h8=
X-Google-Smtp-Source: ABdhPJzkkk3xzv4PmW1qRXxBP75rUHdOGQ6w8L3d1Cf6ejaUSKzTxWrPo8AOflsLg3C9LlSBztayTQ==
X-Received: by 2002:a92:1904:: with SMTP id 4mr168754ilz.110.1605232159709;
        Thu, 12 Nov 2020 17:49:19 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:48d4:cfcb:64d6:19e8])
        by smtp.googlemail.com with ESMTPSA id r16sm3457717ioc.45.2020.11.12.17.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 17:49:18 -0800 (PST)
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4 behavior
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
 <20201107153139.3552-5-andrea.mayer@uniroma2.it>
 <20201110151255.3a86afcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201113022848.dd40aa66763316ac4f4ffd56@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <34d9b96f-a378-4817-36e8-3d9287c5b76b@gmail.com>
Date:   Thu, 12 Nov 2020 18:49:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201113022848.dd40aa66763316ac4f4ffd56@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/20 6:28 PM, Andrea Mayer wrote:
> The implementation of SRv6 End.DT4 differs from the the implementation of SRv6
> End.DT6 due to the different *route input* lookup functions. For IPv6 is it
> possible to force the routing lookup specifying a routing table through the
> ip6_pol_route() function (as it is done in the seg6_lookup_any_nexthop()).

It is unfortunate that the IPv6 variant got in without the VRF piece.
