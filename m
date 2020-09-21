Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1D4272CC5
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgIUQed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728743AbgIUQeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 12:34:24 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48478C061755;
        Mon, 21 Sep 2020 09:34:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s12so13471886wrw.11;
        Mon, 21 Sep 2020 09:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EwqPNPGMMD7jZugkeGHNPUgslTiWGHPwKe5jmVOjgzM=;
        b=k92Hm9Mq3cOSa6Iizgmb6g6eu0cp6tsC9vlUcHnDr+eyGjc7d8tl2cs1waeU/5Jc5C
         Q19QEIe7IVgC0bmZqsnVPpjkxCRrfygcpzN2r1jaEept+UU8xAsxxyIVXEOUheDlJXSg
         bQAhTXCNlOp7GDwSrMTlBElKFLqBIjfYcpk0KUwx1okVESBvRGqQYCNXPzMlScBwikhA
         X+aygAa+449GxfoLPkswgJKbNrEOKnEVSJQajPG8RkHqI40wXDNjcKYn33I2ih60EuMa
         J2ObDOyD8s7HGrYunUCQj11JoFL1rOu7R6quKlOKfMGhTkI6wIB1/Oe04WOodzJquTej
         jnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=EwqPNPGMMD7jZugkeGHNPUgslTiWGHPwKe5jmVOjgzM=;
        b=LWIC3FnrMzEkVNcJX/lgIclraMbGK5YK/i+Yfww4qrCz1IvWH1Ydsrc3uyde9v491V
         1wlSmvGDGBYZ6uzSlJVstiD12swy2kX00UXT5EKZ9k3ETMjaikjhuqm3EEqDOnv0vkN8
         tN3Od4cwHbJbfhSILDkaDylOCjTa0kIqiyZcT/IRPNcfxgiCmQMP3wVYCfZz79x/f0Hy
         1CBafMaB9JP4hN0ZlDapeUJbjfKOShyVSq15W6jaGWz1G0LT4RXbepzX2btNyhr4UDeP
         1KsaGuSM+ztNX2oGZOfm9DFi/f3LzNAD/vLsOw4dNR749i5oPqD4y5GBa2BJKYU1sf8m
         4pJw==
X-Gm-Message-State: AOAM530Lq6OEYBXtGA1gWKbiGFySt6sV18AVTbzD2YPK9gY2ftS/8CzB
        BFQW+0y5KR80acW7PkBKSFXILlQgz1Klfg==
X-Google-Smtp-Source: ABdhPJxD3vBKkJ0SpjXPgN8gXctt48HUZS+njjzoFRpi+BFSe0pOOK6itnWY3TleSHxiKn4AbMBMMQ==
X-Received: by 2002:adf:c404:: with SMTP id v4mr599178wrf.17.1600706062651;
        Mon, 21 Sep 2020 09:34:22 -0700 (PDT)
Received: from [192.168.43.240] ([5.100.192.97])
        by smtp.gmail.com with ESMTPSA id r14sm21193916wrn.56.2020.09.21.09.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 09:34:22 -0700 (PDT)
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
To:     David Laight <David.Laight@ACULAB.COM>,
        'Arnd Bergmann' <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-2-hch@lst.de>
 <20200920151510.GS32101@casper.infradead.org>
 <20200920180742.GN3421308@ZenIV.linux.org.uk>
 <20200920190159.GT32101@casper.infradead.org>
 <20200920191031.GQ3421308@ZenIV.linux.org.uk>
 <20200920192259.GU32101@casper.infradead.org>
 <CALCETrXVtBkxNJcMxf9myaKT9snHKbCWUenKHGRfp8AOtORBPg@mail.gmail.com>
 <CAK8P3a37BRFj_qg61gP2oVrjJzBrZ58y1vggeTk_5n55Ou5U2Q@mail.gmail.com>
 <8363d874e503470f8caa201e85e9fbd4@AcuMS.aculab.com>
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
Message-ID: <7fc71d22-e213-b050-75fe-b45adc6bf0d8@gmail.com>
Date:   Mon, 21 Sep 2020 19:31:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8363d874e503470f8caa201e85e9fbd4@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/09/2020 00:13, David Laight wrote:
> From: Arnd Bergmann
>> Sent: 20 September 2020 21:49
>>
>> On Sun, Sep 20, 2020 at 9:28 PM Andy Lutomirski <luto@kernel.org> wrote:
>>> On Sun, Sep 20, 2020 at 12:23 PM Matthew Wilcox <willy@infradead.org> wrote:
>>>>
>>>> On Sun, Sep 20, 2020 at 08:10:31PM +0100, Al Viro wrote:
>>>>> IMO it's much saner to mark those and refuse to touch them from io_uring...
>>>>
>>>> Simpler solution is to remove io_uring from the 32-bit syscall list.
>>>> If you're a 32-bit process, you don't get to use io_uring.  Would
>>>> any real users actually care about that?
>>>
>>> We could go one step farther and declare that we're done adding *any*
>>> new compat syscalls :)
>>
>> Would you also stop adding system calls to native 32-bit systems then?
>>
>> On memory constrained systems (less than 2GB a.t.m.), there is still a
>> strong demand for running 32-bit user space, but all of the recent Arm
>> cores (after Cortex-A55) dropped the ability to run 32-bit kernels, so
>> that compat mode may eventually become the primary way to run
>> Linux on cheap embedded systems.
>>
>> I don't think there is any chance we can realistically take away io_uring
>> from the 32-bit ABI any more now.
> 
> Can't it just run requests from 32bit apps in a kernel thread that has
> the 'in_compat_syscall' flag set?
> Not that i recall seeing the code where it saves the 'compat' nature
> of any requests.
> 
> It is already completely f*cked if you try to pass the command ring
> to a child process - it uses the wrong 'mm'.

And how so? io_uring uses mm of a submitter. The exception is SQPOLL
mode, but it requires CAP_SYS_ADMIN or CAP_SYS_NICE anyway.

> I suspect there are some really horrid security holes in that area.
> 
> 	David.
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

-- 
Pavel Begunkov
