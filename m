Return-Path: <netdev+bounces-1798-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 725BF6FF2D2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2029F28179F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB8A19BCC;
	Thu, 11 May 2023 13:30:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0BC1F920
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:30:40 +0000 (UTC)
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E4C100CF
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:30:36 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-76c56d0e265so22659439f.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683811836; x=1686403836;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GagP7dGEsB8f4VeTk9g08cCn+Bpf4rw+5QHs8QtGsMg=;
        b=yGeKXjyCfg5L4XDFjFhWs9lgN4QSL8tmb8+0xMiQQ0arHOki8iitVX7EISQWj0+QVI
         2H7h+cMyc6K0LGciWSN6VtMK4MuYevDvEO8BHU7csHVuzo8g+dfO+CwkDs/PzVIjY8IZ
         bVUixdNH9BAwnQy5wbuTyxlbC5JOfD1aXZo29x2oHwd3g68+ZE4iGP89qSoKXh8R+oEF
         1dTc/2FrXFjMC0QB2zYKIljW9h2/7tCwVgiurI2pvT2FbFywO9U+UpV0Wzu4Ef6DUcRo
         hu1+SunfOacW5Ozv+2J7UxAZx4NoE3SlUqDHBJcVIno07ItAHi99bIq2E26nHb5YsEGP
         DH3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683811836; x=1686403836;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GagP7dGEsB8f4VeTk9g08cCn+Bpf4rw+5QHs8QtGsMg=;
        b=UURnaIaDRMJJ6o2Nr8ILZ0CL7DutysfQCO/GY1zwWrjWmzyqIi6LUL281xkXvl2YLq
         dHQFTDPy/xaKtRb+HA6iAZlQ/zI9aRUEu7RhhLd5fAbnMqA0DiB1RlsxH70TrccS7TTa
         rXYrVS1+Nwd3Mx/AddHhPqMXdx21UKz8FtKXMDjVwk1Cw9QKTYQzAYvlQdRyWZ5S/cRl
         oDBSl1UB4go6HiUfLvjo2bxe+GklkZesKxegWV86Uebbqd9ZVJV5bN3SJAk0ZN9ZoXda
         pw2TRxEGda0IuM3DaiSsvRGh/laMwYnAAPJ7kgsF+8M1cFKPn/V3unoO/twUtlIF/Cbi
         98SA==
X-Gm-Message-State: AC+VfDypAH4zdiY5Kxc4GSTjwHkzElaIiVFjsKe9kyB9gchbGMN/8xea
	UxdGj7Ash+/JYUOcIxBAbIZvDUaId53C9GNUGcg=
X-Google-Smtp-Source: ACHHUZ4MHMU9b5Cv2YlpiTyRoXuZIQepO5P1T4InbNnZjf7znwRvSlnKqKRNdZGPIl42vxaPHgzoxw==
X-Received: by 2002:a05:6602:150c:b0:769:8d14:7d15 with SMTP id g12-20020a056602150c00b007698d147d15mr14533660iow.0.1683811836190;
        Thu, 11 May 2023 06:30:36 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p9-20020a5d9849000000b00760ad468988sm4253637ios.24.2023.05.11.06.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 06:30:35 -0700 (PDT)
Message-ID: <0155e071-6e67-bcca-1a82-e1a79b86da52@kernel.dk>
Date: Thu, 11 May 2023 07:30:34 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/3] net: set FMODE_NOWAIT for sockets
Content-Language: en-US
To: Paolo Abeni <pabeni@redhat.com>, io-uring@vger.kernel.org
Cc: torvalds@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netdev@vger.kernel.org
References: <20230509151910.183637-1-axboe@kernel.dk>
 <20230509151910.183637-2-axboe@kernel.dk>
 <9e16ad625a6ba27c2e491d147dbed2c22a8b378b.camel@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9e16ad625a6ba27c2e491d147dbed2c22a8b378b.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/11/23 2:03?AM, Paolo Abeni wrote:
> On Tue, 2023-05-09 at 09:19 -0600, Jens Axboe wrote:
>> The socket read/write functions deal with O_NONBLOCK and IOCB_NOWAIT
>> just fine, so we can flag them as being FMODE_NOWAIT compliant. With
>> this, we can remove socket special casing in io_uring when checking
>> if a file type is sane for nonblocking IO, and it's also the defined
>> way to flag file types as such in the kernel.
>>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  net/socket.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/socket.c b/net/socket.c
>> index a7b4b37d86df..6861dbbfadb6 100644
>> --- a/net/socket.c
>> +++ b/net/socket.c
>> @@ -471,6 +471,7 @@ struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname)
>>  		return file;
>>  	}
>>  
>> +	file->f_mode |= FMODE_NOWAIT;
>>  	sock->file = file;
>>  	file->private_data = sock;
>>  	stream_open(SOCK_INODE(sock), file);
> 
> The patch looks sane to me:
> 
> Reviewed-by: Paolo Abeni <pabeni@redhat.com>
> 
> I understand the intention is merging patch via the io_uring tree? If
> so, no objections on my side: hopefully it should not cause any
> conflicts with the netdev tree.

If it's fine with you guys, then yeah that would make my life easier.
Risk of conflicts should be very low, and trivial if it does occur.
Thanks for the review!

-- 
Jens Axboe


