Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2383BEAF
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390013AbfFJVbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:31:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44510 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389193AbfFJVbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:31:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id n2so5685802pgp.11
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MFwHzAYIwvoO2bUhc4VVschRYFnNJxLs9gSB8dq5+Rc=;
        b=PlwlV5aEPBPKSPPBTDzpxdIVp7GjXEPwP79w1R0KZrfnoMZNLMiz0qbm4v6R1LZ6Z8
         rDItnpJOzv0JcW8csnnDhYg28P+n2n8R0m+YN92bjQegLgc7ZfShs+cWKF9MsW3Hisjd
         8eRmIIktL2xaVtkI/lBoigaHbhVwv7B7STfdM4Q0kPY9ueSHInF8GS0Sixduj5nqZAQq
         MkZoK93UkQ8ehlLzpV4HU98uXc9URWwfYoqav7dFyxmXKm1kJs0CfOGjblAGFMNiw4om
         2SwVhwVPH3fcdbSp/NtJIejfFFSXgr7twCSmVbW4dePffL3r27YxSxGX5yOD+irHX2DO
         qCeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MFwHzAYIwvoO2bUhc4VVschRYFnNJxLs9gSB8dq5+Rc=;
        b=WXUeA1R9+XT9l5A5B+fJLIy4t5EI31Xyekwzv/QZqGvB0w5ySJ/NS3g3PU6hWKcVJj
         zkYhhkj+p/fIoOUg9wbslMJhKDUODMAw1GsUJFkWMvVg4/q26jRZZ/tV0d2Oczg3Od3j
         wTMZfZFvZY1YnSsmrjOBrv460+R3PyKmftKHCLRXAEt+zfbKFlJxSqyk2bjW3eWvwvBN
         UDDPULST7RtmFJ7U0D0WokwLkZj4i4mzPmhs2R3WZObffngaSoqeOyFgCpsvYauhAZMU
         ZOSF6vxANQUj5jpU9Oh6UX+qjA7rDKfzLLJY1KIjXkBSWhbBvCzPfiRQbI6KWhThRzuU
         k7dQ==
X-Gm-Message-State: APjAAAUy4JxzbpKoy52/S9U69Hju3MxRWlNvyhLnz7Xsl1qI/9krsMCA
        +BAfUGuAI5433A6l4YTArkhfeFEZwmI=
X-Google-Smtp-Source: APXvYqzLmOFSKoHvsWIYHXVM/rQhIDaNSQ/oupzV6b2iImc5DWT14gHdfGHka/4stUSJ1dJ/kgg6QQ==
X-Received: by 2002:a62:e403:: with SMTP id r3mr45072194pfh.37.1560202301193;
        Mon, 10 Jun 2019 14:31:41 -0700 (PDT)
Received: from [172.27.227.182] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id f13sm408831pje.11.2019.06.10.14.31.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 14:31:40 -0700 (PDT)
Subject: Re: [PATCH net v3 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560016091.git.sbrivio@redhat.com>
 <f5ca22e91017e90842ee00aa4fd41dcdf7a6e99b.1560016091.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <35689c52-0969-0103-663b-c9f909f4c727@gmail.com>
Date:   Mon, 10 Jun 2019 15:31:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <f5ca22e91017e90842ee00aa4fd41dcdf7a6e99b.1560016091.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/19 12:12 PM, Stefano Brivio wrote:
> To avoid dumping exceptions if not requested, we can, in the future, add
> support for NLM_F_MATCH as described by RFC 3549. This would also require
> some changes in iproute2: whenever a 'cache' argument is given,
> RTM_F_CLONED should be set in the dump request and, when filtering in the
> kernel is desired, NLM_F_MATCH should be also passed. We can then signal
> filtering with the NLM_F_DUMP_FILTERED whenever a NLM_F_MATCH flag caused
> it.

NLM_F_MATCH is set today. iproute2 for example uses NLM_F_DUMP for dump
requests and NLM_F_DUMP is defined as:

#define NLM_F_DUMP      (NLM_F_ROOT|NLM_F_MATCH)

further, the kernel already supports kernel side filtering now for
routes. See ip_valid_fib_dump_req.
