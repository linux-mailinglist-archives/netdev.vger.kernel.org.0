Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB7243024F
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfE3Sws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:52:48 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34510 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfE3Swr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:52:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id c14so2115864pfi.1
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 11:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E00cBdWPt5XSl3kGZJfiVrPQd68E+7Kl37cMO+dstJU=;
        b=stXkU8wyfeXFb8lcnXkbtv/o5+4lY2DgQhjqlKl2wWpQ6GFszqd7UmgtCBaHxy5avb
         9UaOQy9Ly4sAqJx5cETo+aq8ZNWRURcJDNsqOatxvgcGf9wy6AtyMTyrkxDqW6bD1Pz/
         7B30csOAagqaKueUYk9wDpQz6Z6QGguJ5suIjtvyRem7FyHaD5gaxRDSjQ9WnqospKtv
         O+WIyVIfjbwfhR6sbcnRFlBf7C0TtPmggPf2wfQEEk4zSBdap7eZr4rhHxCpOwEWnf5/
         N+6XVuoYfwHVav320MB25JRlHzacb1xo3JgyOw0MvaPbWuMjwoBmvbATFwhJrlat5H0b
         VH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E00cBdWPt5XSl3kGZJfiVrPQd68E+7Kl37cMO+dstJU=;
        b=df2TOmyaTe+2TeuHQQVB5KmHlxU00odERaFbxb9KDlFU4Oo8QBQ46QbijfoTpf81eU
         6AuWvucA8SVQvVnbW6k8iJ7tt1tVlcc3b4G39vaOjZ6PtrD0MQXmrTc2bG2YsNAyX5R0
         3EH4kjx0oNirOuoYlhZRLS2KpfjoCU0f/gAO1fQmQZQKJwYP/6IWWf6xn/r0jy4gUEc+
         3O9n4UGBx+Pv4AqV8hwpKpEg5PcEUhDLHQJUDI/HD4u5APJy4qBtocHp9YfDcsPNHIJH
         yLV3oVLAx6MDU5F1tym7GsQ1jfcnjbJhHWUR0neqNNmZvtJ+61iWjWfFST6Qp43Sltb1
         RipQ==
X-Gm-Message-State: APjAAAUef3IO6rc1sDujBsCt4bwCU+wGauudu3QKIAw0L4I1LDe1ny2j
        YwWu21KpWOTxnOxiH5SokXA=
X-Google-Smtp-Source: APXvYqyzj4fITRSWQRQJOb0rnGCcB7+M524F+ydJ6ldGcNWrAiZFeVQJ7QSF6wi2to4LrwCmy0OSBA==
X-Received: by 2002:a62:b503:: with SMTP id y3mr3076562pfe.4.1559242366975;
        Thu, 30 May 2019 11:52:46 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id k6sm3752408pfi.86.2019.05.30.11.52.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 11:52:45 -0700 (PDT)
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
References: <CAADnVQ+nHXrFOutkdGfD9HxMfRYQuUJwK8UMPGtbrMQBNH4Ddg@mail.gmail.com>
 <d110441b-8d69-0d11-207f-96716d7bc725@gmail.com>
 <CAADnVQJ-aBTFC1BeMiNRD=42qcdw83D_t0zDVzEX+OfFvt7K0g@mail.gmail.com>
 <20190530.110149.956896317988019526.davem@davemloft.net>
 <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
Date:   Thu, 30 May 2019 12:52:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 12:27 PM, Alexei Starovoitov wrote:
> On Thu, May 30, 2019 at 11:01 AM David Miller <davem@davemloft.net> wrote:
>>
>> From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
>> Date: Thu, 30 May 2019 08:18:10 -0700
>>
>>> On Thu, May 30, 2019 at 8:16 AM David Ahern <dsahern@gmail.com> wrote:
>>>>
>>>> On 5/30/19 9:06 AM, Alexei Starovoitov wrote:
>>>>> Huge number of core changes and zero tests.
>>>>
>>>> As mentioned in a past response, there are a number of tests under
>>>> selftests that exercise the code paths affected by this change.
>>>
>>> I see zero new tests added.
>>
>> If the existing tests give sufficient coverage, your objections are not
>> reasonable Alexei.
> 
> I completely disagree. Existing tests are not sufficient.
> It is a new feature for the kernel with corresponding iproute2 new features,
> yet there are zero tests.
> 

Your objection was based on changes to core code ("Huge number of core
changes and zero tests"), not new code paths.

The nexthop code paths are not live yet. More changes are needed before
that can happen. I have been sending the patches in small, reviewable
increments to be kind to reviewers than a single 27 patch set with
everything (the remaining set which is over the limit BTW).

Once iproute2 has the nexthop command (patches sent to the list) AND the
RTA_NHID patches are in, I have this as the final set:

8c0b06b9813e selftests: Add test cases for nexthop objects
ea5c19e4dc7c selftests: Add nexthop objects to router_multipath.sh
3be7b15d1e56 selftests: pmtu: Move running of test into a new function
a896b2206ea5 selftests: pmtu: Move route installs to a new function
cfa48193d0b8 selftests: pmtu: Add support for routing via nexthop objects
3d09a79208b9 selftests: icmp_redirect: Add support for routing via
nexthop objects

That includes:
1. a test script doing functional validation of the nexthop code
(net/ipv4/nexthop.c), along with stack integration (e.g., v6 nexthop
with v4 routes) and traffic (ping).

2. updates to existing exception tests (pmtu and redirect) with the
nexthop obects used for routing

3. updates to the existing router_multipath script with the nexthop
obects used for routing and validating balanced selection in paths.

As always, my patches can be viewed by anyone:
    https://github.com/dsahern/linux

Latest branch is:
   https://github.com/dsahern/linux/tree/5.2-next-nexthops-v14

In addition to the functional and runtime tests listed above:
1. I have all kinds of MPLS and network functional tests that I run. I
have already committed to sending those for inclusion, it is a matter of
time.

2. The FRR team has had a kernel with these patches for 5+ months adding
support for nexthops to FRR. They have their own test suites used for
their development.

3. The patches are included in our 4.19 kernel and subjected to our
suite of smoke and validation tests.
