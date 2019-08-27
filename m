Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74579E9C2
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbfH0NoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:44:03 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43176 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfH0NoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 09:44:02 -0400
Received: by mail-io1-f65.google.com with SMTP id 18so46313765ioe.10
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 06:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0SXtnfz0dn5DkRp8heQpvCkrGKfMqJl/+g667zq5qk4=;
        b=UXbkhCmF37ahs0ngWkF0fqc1CLos0uD/VchI7Hnn118FKRA/hKHoiOCIyCSLffBaK4
         2yBYJ4WOzHsjjo/RhIP53BUZVSjOJBf+/hWLvgr3X5pmygfSTBAmftxQYWmsUWXM9bFk
         gJ6Ol04eytrA1oYwotLSSnvreaFCBx1woBH/3GjFQ7vdN6uRKPHabd1AQFOzU80okeXJ
         CgfT6J+APQ0mrNCczZVpvUEYubJs/oCAmUx68tCFMdg0xYgNwVFDzbm1IQX7Rm7CCHK5
         /vZzH2/iwLZKwbR++onGXJWQLSBzCWxR5e1ltW7gZT1ORPPPz2ZgeULMARgMc1mu91A3
         E4fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0SXtnfz0dn5DkRp8heQpvCkrGKfMqJl/+g667zq5qk4=;
        b=YYt1kvuIwO6q3ow7GkQhaUGYcXmofFnGB2uc7N5SfEOutzrP7YrrvWEg8cEiOuC0Bt
         jF6UcZgFwOTNqSlAxxaSM9r1PE0dvkJ6X2Xdrf5P9REJbh8BJNfG3rGRbB13E+0OwCXe
         A+3r+MfhN0u68hObO+gDLZ2xq6nSUOZLx2aYtnIoKdbFWKLooneXgMzcmP1vL3eHdLC+
         jGv2JEBZXzFVzVTqTeNpm48IosrKkdJtsSO7imupIvNWSheysyUSivFpylKkcoPhpu+o
         MgSAc7m7A4r1S52wDahVtlLqbjygUxUk1DFqY5wpylhvd5R/ZOLrZE/qo/te8nzvOnua
         sfNQ==
X-Gm-Message-State: APjAAAW7oIG6rk4qxQZg/tpYlJ0HMxiBynDT9+zknuYpRobZrDYjdvyM
        YAX2MMZwlV2Wcgw5ITc9TB4=
X-Google-Smtp-Source: APXvYqzRGorO7N3VF816MoaQDa6ELWp7Y13v8DxTqHbnSvoOLjP6+kaCs/0O2kWsx9oXrTpyQDDz9A==
X-Received: by 2002:a05:6602:22ce:: with SMTP id e14mr714197ioe.290.1566913441990;
        Tue, 27 Aug 2019 06:44:01 -0700 (PDT)
Received: from [172.16.99.109] (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id p12sm14411918ioh.72.2019.08.27.06.44.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 06:44:00 -0700 (PDT)
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
References: <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
 <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
 <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
 <20190812083139.GA2428@nanopsycho>
 <b43ad33c-ea0c-f441-a550-be0b1d8ca4ef@gmail.com>
 <20190813065617.GK2428@nanopsycho> <20190826160916.GE2309@nanopsycho.orion>
 <20190826095548.4d4843fe@cakuba.netronome.com>
 <5d79fba4-f82e-97a7-7846-fd1de089a95b@gmail.com>
 <20190827045542.GE29594@unicorn.suse.cz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fb1d7bce-a3c3-44bf-54dc-51237c40efd3@gmail.com>
Date:   Tue, 27 Aug 2019 07:43:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190827045542.GE29594@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/19 10:55 PM, Michal Kubecek wrote:
> On Mon, Aug 26, 2019 at 03:46:43PM -0600, David Ahern wrote:
>> On 8/26/19 10:55 AM, Jakub Kicinski wrote:
>>> On Mon, 26 Aug 2019 18:09:16 +0200, Jiri Pirko wrote:
>>>> DaveA, Roopa. Do you insist on doing add/remove of altnames in the
>>>> existing setlist command using embedded message op attrs? I'm asking
>>>> because after some time thinking about it, it still feels wrong to me :/
>>>>
>>>> If this would be a generic netlink api, we would just add another couple
>>>> of commands. What is so different we can't add commands here?
>>>> It is also much simpler code. Easy error handling, no need for
>>>> rollback, no possibly inconsistent state, etc.
>>>
>>> +1 the separate op feels like a better uapi to me as well.
>>>
>>> Perhaps we could redo the iproute2 command line interface to make the
>>> name the primary object? Would that address your concern Dave and Roopa?
>>>
>>
>> No, my point is exactly that a name is not a primary object. A name is
>> an attribute of a link - something that exists for the convenience of
>> userspace only. (Like the 'protocol' for routes, rules and neighbors.)
>>
>> Currently, names are changed by RTM_NEWLINK/RTM_SETLINK. Aliases are
>> added and deleted by RTM_NEWLINK/RTM_SETLINK. Why is an alternative name
>> so special that it should have its own API?
> 
> There is only one alias so that it makes perfect sense to set it like
> any other attribute. But the series introduces a list of alternative
> names. So IMHO better analogy would be network addresses - and we do
> have RTM_NEWADDR/RTM_DELADDR for them.

RTM_*ADDR manage network layer addresses. Those are anchored to a device
but not direct attributes describing the device.

The device names are just alternative (human friendly) references to a
specific device hence they should be direct link attributes.
