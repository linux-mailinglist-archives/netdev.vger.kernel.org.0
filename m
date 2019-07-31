Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6817CD02
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfGaTlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:41:14 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40323 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfGaTlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:41:14 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so32432714pfp.7
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 12:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QJVnkdedQvruAz8sxf8AgQttfZZBj5Grtod2kJIwZRQ=;
        b=VfC+W2IvI7wijtFT2gyeiqGgsFcNCIlZDt79AmcVwcLQxWpMYIInWwmNmKUvKZrJm4
         4rwGR1mpaiTO9+340+UuSAOVFe361bVNcJGaUxXy3Jhj9OjW4M5ohG0ogWmIUdFOeTO6
         L8XOthBOzahjaefU166t82PswVQ1IXVIWNFA+RsgjKnCcjZ9NxUG8PU80l5gdu7h7RI3
         aKTnG/EV0/aGIYfTOpWrSMTYVi6w5y21HpTbuhZEUrGYpSjld0zpdhf8RJYejKM3kkun
         q1T+YBU4PRTOOu0NwhzqraBECTZe1rkaShNj74m+nWtK7yReAa6tI20AFWQbPORkQIuT
         ebgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QJVnkdedQvruAz8sxf8AgQttfZZBj5Grtod2kJIwZRQ=;
        b=Rr9c15hBclfF4B19/G1Sge2XJH9v6JCxeB1Q8xNBJC6OxEvvyEW6MjYoG0VqpdcW2n
         fbcjIzqMTEd4/EwoYPR4IO6fDCz7OcZ48zu65jvlj2WKQ+5Mu3dwvV94itDlpXuzV4hs
         WAg1RdIRfyMjEVM4RuVHDKGQTeSaWGq1CBVuBvSk0aFot1/SzKgheisBKyJYEWQH+A3D
         7MX7ixngsqI40RKnM/jPf+kNfw7N06BSkYbWrF8lbjJiZNh37UcrTqucAP/lVwdzOtqu
         uaV7Z3+cw8quHCtUnqD9/vVEYGJw+krlekI4XfJ0remTiwC1UUBfQRUnPxn/x6cHrCm3
         Mdaw==
X-Gm-Message-State: APjAAAU9Oqyv8DNG7Ca1sC29ZsKskc7cgz8ANFsL4In29jP4qWUfY/W2
        WcdX+WzOtoL4yGnwAeF5elEbuHdw
X-Google-Smtp-Source: APXvYqwDKjWuZEAA0/cQxMMKXHxqxa5NjVFB+IUAlivSwnlA++9bztleh9vgoSJtmGi48cdBrr8kHA==
X-Received: by 2002:a63:1d0e:: with SMTP id d14mr115256396pgd.324.1564602073660;
        Wed, 31 Jul 2019 12:41:13 -0700 (PDT)
Received: from [172.27.227.172] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id e13sm86390483pff.45.2019.07.31.12.41.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 12:41:12 -0700 (PDT)
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
To:     Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
References: <20190730085734.31504-1-jiri@resnulli.us>
 <20190730085734.31504-2-jiri@resnulli.us>
 <20190730153952.73de7f00@cakuba.netronome.com>
 <20190731192627.GB2324@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
Date:   Wed, 31 Jul 2019 13:41:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190731192627.GB2324@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/19 1:26 PM, Jiri Pirko wrote:
> Wed, Jul 31, 2019 at 12:39:52AM CEST, jakub.kicinski@netronome.com wrote:
>> On Tue, 30 Jul 2019 10:57:32 +0200, Jiri Pirko wrote:
>>> From: Jiri Pirko <jiri@mellanox.com>
>>>
>>> All devlink instances are created in init_net and stay there for a
>>> lifetime. Allow user to be able to move devlink instances into
>>> namespaces.
>>>
>>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>>
>> I'm no namespace expert, but seems reasonable, so FWIW:
>>
>> Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>>
>> If I read things right we will only send the devlink instance
>> notification to other namespaces when it moves, but not
>> notifications for sub-objects like ports. Is the expectation 
>> that the user space dumps the objects it cares about or will
>> the other notifications be added as needed (or option 3 - I 
>> misread the code).
> 
> You are correct. I plan to take care of the notifications of all objects
> in the follow-up patchset. But I can do it in this one if needed. Up to
> you.
> 

seems like it should be a part of this one. If a devlink instance
changes namespaces, all of its associated resources should as well.

Also, seems like you are missing a 'can this devlink instance be moved'
check. e.g., what happens if a resource controller has been configured
for the devlink instance and it is moved to a namespace whose existing
config exceeds those limits?
