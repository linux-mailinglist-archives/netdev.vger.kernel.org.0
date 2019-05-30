Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 546892FF2A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 17:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfE3PQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 11:16:01 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40505 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3PQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 11:16:01 -0400
Received: by mail-pf1-f196.google.com with SMTP id u17so4160394pfn.7
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 08:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oN8Kq+v7NkO+TuKIOTfhFR8ZS3wUbjn87py1wvH3U1g=;
        b=ehMNOMM/liGKcCgkzxJmdjAYY20nmliEpENKMUqguIAbLNvso08Rgf1bdca3qz+hqF
         aVUVHxYfPpiRmg0bY0Eyyi3OUTu34GOJnSEMwmY4cV35ZV8u07JDHsaTv/p0LxqXlee7
         SrmYFdI/agJRJpJiIo4qzGr/OZto7UUt4bV2sgcULTabLcExXJ0/eGY4ZdZCwREt+Kz4
         Xnp9E+QOA9/euVrr7IxqAIHxRlZi5dFzsEGod85GgZ3x91+4YLHp9UT6wPlWippkoBat
         0NTd14sWbMzrNCzmiBw5n/1l+owqcD+2sDBo1JobW+TDo3EPfcbT0UCwHvZdOD3qv/2e
         zMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oN8Kq+v7NkO+TuKIOTfhFR8ZS3wUbjn87py1wvH3U1g=;
        b=nUzqL28gZ5douHFodBILb5PYs8psxkFIDasl7Xce8FzcfBe1v60kcBO+jnq4zuexYy
         JVOMTuZT+DtdD88Y7UAgq6CRg3LP7icpT9pzOrW3cNcbtBXkYJ7DH4c9PIZOC2QHyxAa
         P/7jaPKqIauyh2BAXMY1osYr1CoNbpy4j/pU5ucU8YHTDb+kG5a5EILqGEhLhWhnIRFQ
         UdEMGXdqdtdQ4yejF+BuuUz9ReNKytdhxK+fV8CV4hIC2FFei7t92w/zdD3gsC0MLQJo
         PqNiinIx5ItiFmxFzX5vl5eXdUgd5jEkPjTChytA2MP9FSgt35ApTLbAiF0fLLDjMJaf
         HcKg==
X-Gm-Message-State: APjAAAVLcYGj5ACGWS8XD8vUJ+bqKdDBKC9lVX8lf8URS/HIhjwBsy9I
        b7pNWKfQeePcJD5bvFgW9D8=
X-Google-Smtp-Source: APXvYqx/m+25o+O9DBDO/+a61dJFYuVSGMgIReWS2a6undQ76dBcY/Zs8p3CV4kAlTMRmaLU2jE9Aw==
X-Received: by 2002:a17:90a:b890:: with SMTP id o16mr4001356pjr.60.1559229360872;
        Thu, 30 May 2019 08:16:00 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id k6sm3357029pfi.86.2019.05.30.08.15.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 08:15:59 -0700 (PDT)
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
References: <20190530030800.1683-1-dsahern@kernel.org>
 <CAADnVQ+nHXrFOutkdGfD9HxMfRYQuUJwK8UMPGtbrMQBNH4Ddg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d110441b-8d69-0d11-207f-96716d7bc725@gmail.com>
Date:   Thu, 30 May 2019 09:15:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+nHXrFOutkdGfD9HxMfRYQuUJwK8UMPGtbrMQBNH4Ddg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 9:06 AM, Alexei Starovoitov wrote:
> Huge number of core changes and zero tests.

As mentioned in a past response, there are a number of tests under
selftests that exercise the code paths affected by this change.
