Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B3531929
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfFAC7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 22:59:20 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40434 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfFAC7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 22:59:20 -0400
Received: by mail-pg1-f196.google.com with SMTP id d30so5041335pgm.7
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 19:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QLks2yf8WIDN/lJQpKbYO8XLRA0o0JKjDoOcOkg3yfU=;
        b=BZ0j079OaMzta1CYXg6VevoLd+O5psq+M+HmUljfrLyMPrsIw89jAvLtbDKj/YWcfj
         qhLIgOCmyW4eJM2LJdoFXIXLcBQE6RGbztuq3g3Q0lfpqAfDPXFzcSpY8AhPGyKh8GFu
         9MwZ07Pq6XsIcl3bbRX77p0gAwXD4vv6qLIqXGoMqmEMgxk+VCUoWR0oGfNizeDAxwzy
         fir8nM87Tcrx//hH9Cq8x2EDra8rs2SBF3aAedHL+u5k2ikNEA4+vhEv43zRsV6DbLIH
         9iLSwt+CBhWpM0V4FLbFGZNaA3l5AKCVNW6yCuxrXbh7bfDZlpifmGFBkL9UQnE6jA6g
         HRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QLks2yf8WIDN/lJQpKbYO8XLRA0o0JKjDoOcOkg3yfU=;
        b=m48BUrL6z76XwuzFCUVegUVWeK2FyU5drRSkcZ7s4dSpwvmGf6/Np1gcINTTzTTSw5
         gPirK6X73qxbP8Lu8AZfmQ7r1XySNGG+z4ZlFDP1SPv8OJ7ALDHUF4Y8RyLfWWxNk5u9
         jEet2SP+hL0cD3RNG1n224v7H9KSMJx41wx9TddZ6vnrrVMeN2siT8rzkKrWpqltDIvY
         div6Q6N54CxDBrZXZuCDr78757bvELC3E9yHNNqDqs/bfMewU/rRMxL239MKCO1eJqAm
         nG32MFx5ctRtTNUqeqSMHMHt7YZuX3DQlEpPCF3xUAdfEIorPqbxV+EfPaxLNWrj9kvd
         bSKA==
X-Gm-Message-State: APjAAAVd3b3emjUdRksL/QLFCO7fYMIeXIVYi2W9CEaouBkJ0g+shNlw
        rcA453LgsG6jhKq6SMdzctM=
X-Google-Smtp-Source: APXvYqzmNnmdsDMhCFHebSdVt3GhldbPA/2zLeh0DUIHGpwEmzbhzNFLmc1xZ4SpK0Mo6w8tNLwAGQ==
X-Received: by 2002:a62:5801:: with SMTP id m1mr14432209pfb.32.1559357960115;
        Fri, 31 May 2019 19:59:20 -0700 (PDT)
Received: from [172.27.227.252] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id ds14sm6396803pjb.32.2019.05.31.19.59.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 19:59:19 -0700 (PDT)
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
References: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
 <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
 <CAADnVQ+KqC0XCgKSBcCHB8hgQroCq=JH7Pi5NN4B9hN3xtUvYw@mail.gmail.com>
 <20190531.142936.1364854584560958251.davem@davemloft.net>
 <ace2225d-f0fe-03b3-12ee-b442265211dd@gmail.com>
 <CAADnVQ+yj28xchvW6jCPfXCneuHxN+0MNHVquA1v10rWQ=dBMQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8da19c41-b4ba-12c2-0f43-676c90037f67@gmail.com>
Date:   Fri, 31 May 2019 20:59:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+yj28xchvW6jCPfXCneuHxN+0MNHVquA1v10rWQ=dBMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/19 8:51 PM, Alexei Starovoitov wrote:
> From single sentence of commit log it's not clear at all
> whether they're related to this thread.
> Will they fail if run w/o this set?
> 

New code in this set (if (fi->nh) {}) can not be tested yet. It can not
be tested until the final patch that wires up nexthops with fib entries.

Old code in this set (else {}) is tested by existing selftests.
