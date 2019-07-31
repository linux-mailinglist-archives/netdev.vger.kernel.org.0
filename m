Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC3C7CE13
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbfGaUUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:20:21 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44708 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaUUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 16:20:21 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so30950188plr.11
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 13:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hm0b2a50zsx9SMW26Lk6rJLyM9N3iHtyBOKgo6vAhHc=;
        b=JniX8PZ5DEe/oxH5lcwnWCgktkDUXgvr77unxvyoRsxDglTjIOfnTNG8azWXvQdmMD
         66uS0D1lK6LXlnA/1WABFh+YFlPEh+Y5+rpXVFYUdTJxdJp5OdVe52hlKK+S+VS4lsQK
         k10fRzOdU9qtyYCYi9O3VYqFV2ghezdEU2oG91PYUlctRNfhQ3/m6lioTEvlOIvZXhQU
         53iwqnBwDQHJBsu0l+LiuFcwesGbVERbwDxg5hR8xIW7RirR2q6Twcv5nqYyODSstJXI
         5E70RmE6JzpCf4cHWV1NZ2pnYLaCdJQyN4bDcneQZhbP+qOOpcCmU44CqCJ5s75nzN4P
         Iyzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hm0b2a50zsx9SMW26Lk6rJLyM9N3iHtyBOKgo6vAhHc=;
        b=oUbwwP6EEGhceoyPZjBtTpXbiSVg827zsdHCi1ecxVoEqvSkqJrasbwUtQOoxZ3KgT
         Q0MXPMH07RTUVFzJHe9JGQiH0xzyU0khlvdnm6TPhQ7RQvGqYwlDdyvyrQaZzTXvQLnY
         CvXOtsvAofduN7YeTkV864EIsBIqfiMznFO0NIU81Qxk4MMOws1c7lZLNJIdwioU+UKY
         qv6qtWVV/bKiwNUC+1nPetyZJXhblig1pix+IUE0kkTOXBZbGh2WtzOe1TymhZJRXPg+
         FxsEsMbcvCE3GZeEHtBniNfIxE16I8hUcCUUf7ejY6ntAu60PZv+roxPcTmGhBySN3Ha
         G7EA==
X-Gm-Message-State: APjAAAWVMHgFvaXuAka/JlvUk5QWZZY416BQQV+Xhdl9S+FhExDKRxmv
        fMM/4kfvk+OPQHNbCJ5tJwI=
X-Google-Smtp-Source: APXvYqz5g4e+h9wLJaMDFvnutmqkVJt+licUHzuOK1PMjvlzSoNIY0dOGW3fGepck6COINbN12M46Q==
X-Received: by 2002:a17:902:2bc5:: with SMTP id l63mr126231909plb.30.1564604420650;
        Wed, 31 Jul 2019 13:20:20 -0700 (PDT)
Received: from [172.27.227.172] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id s11sm67484579pgv.13.2019.07.31.13.20.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 13:20:19 -0700 (PDT)
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
From:   David Ahern <dsahern@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
References: <20190730085734.31504-1-jiri@resnulli.us>
 <20190730085734.31504-2-jiri@resnulli.us>
 <20190730153952.73de7f00@cakuba.netronome.com>
 <20190731192627.GB2324@nanopsycho>
 <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
 <20190731194502.GC2324@nanopsycho>
 <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
 <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
Message-ID: <05ec935f-2375-13fe-95b0-f80ca74ccca2@gmail.com>
Date:   Wed, 31 Jul 2019 14:20:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/19 1:58 PM, David Ahern wrote:
> On 7/31/19 1:46 PM, David Ahern wrote:
>> On 7/31/19 1:45 PM, Jiri Pirko wrote:
>>>> check. e.g., what happens if a resource controller has been configured
>>>> for the devlink instance and it is moved to a namespace whose existing
>>>> config exceeds those limits?
>>>
>>> It's moved with all the values. The whole instance is moved.
>>>
>>
>> The values are moved, but the FIB in a namespace could already contain
>> more routes than the devlink instance allows.
>>
> 
> From a quick test your recent refactoring to netdevsim broke the
> resource controller. It was, and is intended to be, per network namespace.
> 

Specifically this commit:

commit 5fc494225c1eb81309cc4c91f183cd30e4edb674
Author: Jiri Pirko <jiri@mellanox.com>
Date:   Thu Apr 25 15:59:42 2019 +0200

    netdevsim: create devlink instance per netdevsim instance

    Currently there is one devlink instance created per network namespace.
    That is quite odd considering the fact that devlink instance should
    represent an ASIC. The following patches are going to move the devlink
    instance even more down to a bus device, but until then, have one
    devlink instance per netdevsim instance. Struct nsim_devlink is
    introduced to hold fib setting.

    The changes in the fib code are only related to holding the
    configuration per devlink instance instead of network namespace.

broke the intent of the resource controller clearly stated in the
original commit

commit 37923ed6b8cea94d7d76038e2f72c57a0b45daab
Author: David Ahern <dsa@cumulusnetworks.com>
Date:   Tue Mar 27 18:22:00 2018 -0700

    netdevsim: Add simple FIB resource controller via devlink

...
    Currently, devlink only supports initial namespace. Code is in place to
    adapt netdevsim to a per namespace controller once the network namespace
    issues are resolved.

And discussed here based on the RFC and v1 of the original patchset:

https://lore.kernel.org/netdev/03eade79-1727-3a31-8e31-a0a7f51b72cf@cumulusnetworks.com/

and

https://lore.kernel.org/netdev/a916f016-5d8b-3f56-0a84-95d1712bec4c@cumulusnetworks.com/

This is a regression that needs to be fixed.
