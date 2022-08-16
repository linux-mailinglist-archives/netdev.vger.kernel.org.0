Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2EA59650A
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbiHPV72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237242AbiHPV71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:59:27 -0400
X-Greylist: delayed 88633 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 Aug 2022 14:59:25 PDT
Received: from forward502p.mail.yandex.net (forward502p.mail.yandex.net [77.88.28.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D041831EF9
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 14:59:25 -0700 (PDT)
Received: from vla1-aa6bc93a06fb.qloud-c.yandex.net (vla1-aa6bc93a06fb.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3a21:0:640:aa6b:c93a])
        by forward502p.mail.yandex.net (Yandex) with ESMTP id 949AAB8128E;
        Wed, 17 Aug 2022 00:59:21 +0300 (MSK)
Received: by vla1-aa6bc93a06fb.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id g8ionaD8Rn-xKiiwstN;
        Wed, 17 Aug 2022 00:59:21 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1660687161;
        bh=oN9jq4tb1VPMQixnYItXgq/IlvPMh4sxTy9rUkcUd4o=;
        h=Cc:References:Date:Message-ID:In-Reply-To:From:To:Subject;
        b=qfeJbd0cBVrDmXuU++oBrtKQEFBOF5jx4HdS4P497cczZCsF+oAOeCPJSoYI84YnN
         3tn8YbYJYgHg36XJQ0V6QW8c51V6vROqpYSSbqUHBSJrbWK9nPv7IIGZJH1Qxqmev+
         jwoTInBa2lu90B1UzOj07FB/pbEOmqYMwIA/eKyo=
Authentication-Results: vla1-aa6bc93a06fb.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Subject: Re: [PATCH v2 1/2] fs: Export __receive_fd()
To:     David Laight <David.Laight@ACULAB.COM>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
References: <0b07a55f-0713-7ba4-9b6b-88bc8cc6f1f5@ya.ru>
 <3a8da760-d58b-04fe-e251-e0d143493df1@ya.ru>
 <e3e2fe6a2b8f4a65a4e28d9d7fddd558@AcuMS.aculab.com>
From:   Kirill Tkhai <tkhai@ya.ru>
Message-ID: <c6c1d83c-abe1-3ad4-ccfe-1adf2d8cef1d@ya.ru>
Date:   Wed, 17 Aug 2022 00:59:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <e3e2fe6a2b8f4a65a4e28d9d7fddd558@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.08.2022 11:03, David Laight wrote:
> From: Kirill Tkhai
>> Sent: 15 August 2022 22:15
>>
>> This is needed to make receive_fd_user() available in modules, and it will be used in next patch.
>>
>> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
>> ---
>> v2: New
>>  fs/file.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/file.c b/fs/file.c
>> index 3bcc1ecc314a..e45d45f1dd45 100644
>> --- a/fs/file.c
>> +++ b/fs/file.c
>> @@ -1181,6 +1181,7 @@ int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
>>  	__receive_sock(file);
>>  	return new_fd;
>>  }
>> +EXPORT_SYMBOL_GPL(__receive_fd);
> 
> It doesn't seem right (to me) to be exporting a function
> with a __ prefix.

I don't think so.

$git grep "EXPORT_SYMBOL(__\|EXPORT_SYMBOL_GPL(__" | wc -l
1649
