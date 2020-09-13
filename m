Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625A5267E26
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 08:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgIMGVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 02:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgIMGU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 02:20:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB336C061573;
        Sat, 12 Sep 2020 23:20:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j34so9103882pgi.7;
        Sat, 12 Sep 2020 23:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=oSqDnSurul1SEUdPfy/k5oKwDRKz1lqnIF0nSiq8EfM=;
        b=akCmZ/9Nebui2eLyF0x28+sRrco8/cMSEJFnvpd+8P7Jz1k7z6uC+PTbvU+vCuMe/p
         G6TUewI7fu6WEuZS2dD5zB34ER4PvygORHE0PlhW7oPEYdYuGTE5lmJHQAq8bm/wKDB6
         q3BgXkqy1X/241LZFPFK0mhssBxffFSR6pTqPSmyoCSmbjRg7HWiem1rEEH32431q3aF
         X42a3cxV0QVNsh/10z7MgsxANGWQDnZlBpAcGIB2Mv4kk/Aekh2ro8Jvt2EAj7/YdDJ4
         8dGcn9pAMtLqfDeLco0SRuIJmwSbFe0ocspsyywjzttDfKISum7YwLGdqnt/f8K9rj6A
         43tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oSqDnSurul1SEUdPfy/k5oKwDRKz1lqnIF0nSiq8EfM=;
        b=J5yxf3QfY9LHb3uqnPrXiYYGyjbU8KNAZu/wCsN9M00x2hCFoc6RLUXk1R41nboNWT
         Ju3lO58yoH+q6ZoGPKGpn/pFi9EueCr7E2NCEheaaW6nWwo6ztJ53TwYvCVTY557gx2h
         QHtLvBf3vGdjk0iHXMO1ar/WxbaKKN5W0rAD9wm18cl9jJgE0j/8zjp6A3k0F2y6QkJQ
         y4jnAG9XSAcGqPmEArusK2wvMWnQtso/PHAbR1PKr57kXXaKDAPbBpyu26bqXSe82Djj
         HOuiEWDbBpop6A40rav6WqAfVl9OJrWAxJqt4//zU+L+i2uIZY89Uc+mOLFZtvGGbbPo
         z4YA==
X-Gm-Message-State: AOAM530nOw7qxqqx2JT/lQNAyg+2nBLRpM4YXc+cmgcGs6LlDx3K7WAk
        XCPS7E/vzfj8+K8aXFn4whk=
X-Google-Smtp-Source: ABdhPJwp5fFXpDXs+77u4RzzJOB/E/gElAzOw+O6qZWhP8oGIspsUZNfxr6ClFMkE+oplQc/U6Sj5w==
X-Received: by 2002:aa7:9892:: with SMTP id r18mr8741441pfl.107.1599978056909;
        Sat, 12 Sep 2020 23:20:56 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.209.61])
        by smtp.gmail.com with ESMTPSA id x9sm7031293pfj.96.2020.09.12.23.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2020 23:20:56 -0700 (PDT)
Subject: Re: [Linux-kernel-mentees] [PATCH] net: fix uninit value error in
 __sys_sendmmsg
To:     Greg KH <greg@kroah.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20200913055639.15639-1-anant.thazhemadam@gmail.com>
 <20200913061351.GA585618@kroah.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <89526337-9657-8f4d-3022-9f2ad830fbe9@gmail.com>
Date:   Sun, 13 Sep 2020 11:50:52 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200913061351.GA585618@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13/09/20 11:43 am, Greg KH wrote:
> On Sun, Sep 13, 2020 at 11:26:39AM +0530, Anant Thazhemadam wrote:
>> The crash report showed that there was a local variable;
>>
>> ----iovstack.i@__sys_sendmmsg created at:
>>  ___sys_sendmsg net/socket.c:2388 [inline]
>>  __sys_sendmmsg+0x6db/0xc90 net/socket.c:2480
>>  
>>  that was left uninitialized.
>>
>> The contents of iovstack are of interest, since the respective pointer
>> is passed down as an argument to sendmsg_copy_msghdr as well.
>> Initializing this contents of this stack prevents this bug from happening.
>>
>> Since the memory that was initialized is freed at the end of the function
>> call, memory leaks are not likely to be an issue.
>>
>> syzbot seems to have triggered this error by passing an array of 0's as
>> a parameter while making the initial system call.
>>
>> Reported-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
>> Tested-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
>> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>> ---
>>  net/socket.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/socket.c b/net/socket.c
>> index 0c0144604f81..d74443dfd73b 100644
>> --- a/net/socket.c
>> +++ b/net/socket.c
>> @@ -2396,6 +2396,7 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
>>  {
>>  	struct sockaddr_storage address;
>>  	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
>> +	memset(iov, 0, UIO_FASTIOV);
>>  	ssize_t err;
>>  
>>  	msg_sys->msg_name = &address;
> I don't think you built this code change, otherwise you would have seen
> that it adds a build warning to the system, right?
>
> :(
My apologies. I think I ended up overlooking the build warning. Thank you for pointing that out.
If everything else looks good, I'd be happy to send in a v2 that fixes this build warning.

Thanks,
Anant
