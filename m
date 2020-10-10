Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DD728A1FF
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbgJJWxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgJJSoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:44:13 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41008C08EC69;
        Sat, 10 Oct 2020 11:44:12 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id b193so9246562pga.6;
        Sat, 10 Oct 2020 11:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=gynpyUuQDJw4i2zEOnQ/TzhcGgZ8EQ2u4/0CzfNkcPA=;
        b=PP8wruc20jQM8T83GoLi/Knij4+w2yw9tO1aTlXlcIsTYNXpJyAV8Kfeq2zkxwSHFu
         bJDH3Qv2ziU1I6RrSFSyCujLEyo1GAEqoODxL5gwNVaoMfCnBiRtxcH4g2izXFZy90bz
         1H+su+nHeimqvt98MprOMJPquTyyWz8CvfnGRRA5c9IIK4Mt1AJ3FoCPRbPo2Mw4KqDh
         J7B1rv7L5U42qX78zV9UA0H34TrmKTnFd08PecGMaqX90TyN7ZCqc35JMAnp912MJYRC
         IZ1hIE4V68kwMSeFOAvcz6t+T5DpRNLf69Z97oh3HkMoO4VFhbye5je/i1dBWIjRjyxQ
         p4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=gynpyUuQDJw4i2zEOnQ/TzhcGgZ8EQ2u4/0CzfNkcPA=;
        b=hxfwg8v9AYYxFsiG8q6lhr8Lkt1zzQjsWSx4viPqmO2S7zSa9kdjPkCw2kIzs1RW+h
         Le5UfXjiEJBhiZuFKuC91OOq/UdJYvrcDXZuGnGhc1a9MscVQCLbVk0xhzyVLVIamkIa
         VHa2PL78d4bcBlwD++5NKAsOw4ZKz/5m6FKEB54SsOlSjKOowHsf6JEubDhNhaDI1scw
         ds4Eeow9/6gqQA8pKVNaJX+6qpS7C2RFJ41ryov9lKT8XOqXW6sPI/6x5wk7NxUWTxMk
         4laNkuUneJNVropi25MYt/UwN6AjoQsHqTBmOO1QQn3DBhD3cXvavABCeUHt0eh/Pd32
         61zg==
X-Gm-Message-State: AOAM530cFcoNDqnMIBbV55xcxRml2tJRo9z8V1eo6AXT6mzHoqsaoPwT
        evLYo8DzBNpyUYUT1bkTbsAOe2/R3iejbl6M0nw=
X-Google-Smtp-Source: ABdhPJxb3+zbTfMJcsyP1PxCgumZYXS1XW5ek5s8hcWpHWs2UUAnHPFE+FPOSUMIZEmMuR/zho2IAQ==
X-Received: by 2002:a17:90a:c297:: with SMTP id f23mr8599068pjt.72.1602355451020;
        Sat, 10 Oct 2020 11:44:11 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.200.2])
        by smtp.gmail.com with ESMTPSA id u69sm16023601pfc.27.2020.10.10.11.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 11:44:10 -0700 (PDT)
Subject: Re: [PATCH] net: usb: rtl8150: don't incorrectly assign random MAC
 addresses
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
 <20201010095302.5309c118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0de8e509-7ca5-7faf-70bf-5880ce0fc15c@gmail.com>
 <20201010111645.334647af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <e772b9f0-f5cd-c50b-86a7-fde22b6e13e3@gmail.com>
Date:   Sun, 11 Oct 2020 00:14:05 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201010111645.334647af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/10/20 11:46 pm, Jakub Kicinski wrote:
> On Sat, 10 Oct 2020 23:34:51 +0530 Anant Thazhemadam wrote:
>> On 10/10/20 10:29 pm, Jakub Kicinski wrote:
>>> On Sat, 10 Oct 2020 12:14:59 +0530 Anant Thazhemadam wrote:  
>>>> get_registers() directly returns the return value of
>>>> usb_control_msg_recv() - 0 if successful, and negative error number 
>>>> otherwise.  
>>> Are you expecting Greg to take this as a part of some USB subsystem
>>> changes? I don't see usb_control_msg_recv() in my tree, and the
>>> semantics of usb_control_msg() are not what you described.  
>> No, I'm not. usb_control_msg_recv() is an API that was recently
>> introduced, and get_registers() in rtl8150.c was also modified to
>> use it in order to prevent partial reads.
>>
>> By your tree, I assume you mean
>>     https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/
>> (it was the only one I could find).
>>
>> I don't see the commit that this patch is supposed to fix in your
>> tree either... :/
>>
>> Nonetheless, this commit fixes an issue that was applied to the
>> networking tree, and has made its way into linux-next as well, if
>> I'm not mistaken.
> I mean the networking tree, what's the commit ID in linux-next?
>
> Your fixes tag points to f45a4248ea4c, but looks like the code was
> quite correct at that point.


Ah, my apologies. You're right. It doesn't look like those helpers have made
their way into the networking tree yet.

(This gets mentioned here as well,
    https://www.mail-archive.com/netdev@vger.kernel.org/msg357843.html)

The commit ID pointed to by the fixes tag is correct.
The change introduced by said commit looks right, but is logically incorrect.

get_registers() directly returns the return value of usb_control_msg_recv(),
and usb_control_msg_recv() returns 0 on success and negative error number
otherwise.

(You can find more about the new helpers here
    https://lore.kernel.org/alsa-devel/20200914153756.3412156-1-gregkh@linuxfoundation.org/ )

The commit ID mentioned introduces a change that is supposed to copy over
the ethernet only when get_registers() succeeds, i.e., a complete read occurs,
and generate and set a random ethernet address otherwise (reading the
commit message should give some more insight).

The condition that checks if get_registers() succeeds (as specified in f45a4248ea4c)
was,
    ret == sizeof(node_id)
where ret is the return value of get_registers().

However, ret will never equal sizeof(node_id), since ret can only be equal to 0
or a negative number.

Thus, even in case where get_registers() succeeds, a randomly generated MAC
address would get copied over, instead of copying the appropriate ethernet
address, which is logically incorrect and not optimal.

Hence, we need to modify this to check if (ret == 0), and copy over the correct
ethernet address in that case, instead of randomly generating one and assigning
that.
Hope this helps.

Thanks,
Anant


