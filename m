Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F167834069A
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 14:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhCRNMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 09:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbhCRNMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 09:12:16 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E9CC06174A;
        Thu, 18 Mar 2021 06:12:15 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k8so5480046wrc.3;
        Thu, 18 Mar 2021 06:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WujOkaxEvEJpD/Zs6YorKOgzT5TSdZcfUYZ1Kr0AUvs=;
        b=WFDv6+KI4ievn0bw8/TI0Vcx3zdiEHcalxY/kLYyMraFjUhqvmaJo8ssV48WF9XVgf
         u1f2YkWB0Q1I83hUvMhmboajCR58YmU1tDprIbneoE0Pwi4Bm+MMWEdhDOaukpoZuJV0
         8V0OkUwXSJYZ13VuC2FHm7eqtu2DkfuPKjcw8aNtzfOijBuR9VeX79GS9ydmbfNk3jtI
         bnBMSdRvM8rYRemjiUrLUN9mz/nFWs8ywyLMdPkT3dZg1/Fl2NfUWIEYIIASQN0B1cBx
         NT6djVphykD84/TzZ3FvMxvHLEfHqAZgMnk6Zqe1EYwCOyGclSsmLEJnTAWlQ16sm8xP
         uLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=WujOkaxEvEJpD/Zs6YorKOgzT5TSdZcfUYZ1Kr0AUvs=;
        b=m4kDd/4yYm1ObEhjEMm7AdHP38aiCgfdT4EWp3uUjbBGdPfqgMPmUyx0TApyJQq4d2
         QslYOeRjw2oO6HPfjDxh/e5KPEUZqPruYcl3qZabPs/f3NZ39lx43Mp04W2AQMGo8DEz
         L0gBMVuvCPboKnCbAqw84zHG++pKgoT5iFDUrC0xPw+iv60ndPTGCYTHKsvMGcjlsvSo
         M2+jF0QYsV+oHxMIMBe/Zv5VC/hwAPQFg0jy24e25QatQAf4xHtMF7tlAdvxky8jmSg1
         0HZn/Jv94JhgZ39zxWw/qURaTmDDPymTPlpVLB5SchGgVfgY5jsFnZ+5D4mEvcw4G4bF
         jFSA==
X-Gm-Message-State: AOAM532i29304YfyWGrCgbC4K5ZhX5Vc3gzTTUCTnEF7WtrTNHuIf//Q
        zXj/bHdMK5E9YLYkJh/dyODu2N9CLNZNpg==
X-Google-Smtp-Source: ABdhPJxuaGHAoNsdXxqYA4Gwaaj7ay4UWogTKp2LdwCtCwifTXAM0dz8wORkuOz10Ds95FaO4rSoyg==
X-Received: by 2002:a05:6000:11cd:: with SMTP id i13mr9476407wrx.417.1616073133634;
        Thu, 18 Mar 2021 06:12:13 -0700 (PDT)
Received: from [192.168.8.170] ([185.69.144.156])
        by smtp.gmail.com with ESMTPSA id o11sm2923726wrq.74.2021.03.18.06.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 06:12:13 -0700 (PDT)
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <cover.1615908477.git.metze@samba.org>
 <47ae1117-0de3-47a9-26a2-80f92e242426@kernel.dk>
 <b2f00537-a8a3-9243-6990-d6708e7f7691@gmail.com>
 <e15f23a2-4efc-c12a-9a4f-b4e3c347ae63@samba.org>
 <c5b26bbe-7d95-ec86-5ddb-c2bd2b6c79a7@gmail.com>
 <903c17f5-4339-7ee8-40fb-34a6974ce597@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Subject: Re: [PATCH 0/2] send[msg]()/recv[msg]() fixes/improvements
Message-ID: <8d9bf2bd-779d-6c5e-915c-88d9750c2f09@gmail.com>
Date:   Thu, 18 Mar 2021 13:08:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <903c17f5-4339-7ee8-40fb-34a6974ce597@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/03/2021 00:15, Stefan Metzmacher wrote:
>>>> Sounds like 2/2 might too, does it?
>>>
>>> Do you think any application really expects to get a SIGPIPE
>>> when calling io_uring_enter()?
>>
>> If it was about what I think I would remove lots of old garbage :)
>> I doubt it wasn't working well before, e.g. because of iowq, but
>> who knows
> 
> Yes, it was inconsistent before and now it's reliable.

Yep, that where my hesitation was coming from, but the case I had
in mind is 

1) send() -> gone to io-wq
2) close the other end
3) send() fails, probably without SIGPIPE (because io-wq)
4) userspace retries send() and inline execution delivers SIGPIPE

But I guess we don't really care. In any case, let's drop stable tag,
maybe? I don't see a reason for it, considering that stable tries hard
to preserve ABI.

-- 
Pavel Begunkov
