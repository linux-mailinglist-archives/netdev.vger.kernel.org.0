Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20EA19D8A9
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfHZVqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:46:47 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45206 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfHZVqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:46:47 -0400
Received: by mail-qk1-f195.google.com with SMTP id m2so15353357qki.12
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m2RoDAl69yHA+Fnr1r5R7nX/fZq7Q3LRW1DYhQ7NXVk=;
        b=mV8KAJBjqOtsgJ4S/kv6FPT5r7JHl2NHaglKPpgarftPslKPy52aSipOsUGoBcgDV7
         s4XUx3SG03S22uoZ937wLqu1CQoFO5OlGdkmMjfszF+gFQo/UYWW1DenDl6Q+CljG1Au
         61tQ4B42xLPA/OC3fsYyX/fdx6hQqS+yzs6Pso1SRZ1J3OQFRTv9dtDuIEJu/las4lmc
         k3xqaL9GhbZFZuwmfruaYUrdHNXv5Le2cA2xsYB6uxniochZ28UbJLBwRDmdic3ek/pf
         /OhQ92gKqbZNrBXccHDEHtDjJdLo1usxOGwBpfulaYewtGoelgDZxV0hAN3aoycFHTqo
         8qmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m2RoDAl69yHA+Fnr1r5R7nX/fZq7Q3LRW1DYhQ7NXVk=;
        b=i+nNPVmg9buMY0ftL0NJtq7KvNNRPF5WrmeSljobvZ+xk62GZZHzblE2r+4JVQnx/y
         eEfM3UqKqN7L2ciYClkXArbf3bfSYpetBu/qZ2IocTmHxuJpxBW3HhUcY28o8klSm9K4
         1Q/i0spimyUaR937pZuCRJAiPmfkBL7e8A2zdh41zOZSypMvNf7qDPFRbrgXlfXTCnNp
         CqxaXIUvYPkoRM6YoEYteUjFCx0HHkL7O7eyqfE7qhkm81g3cTvTu/1GJeDT4dL3kfmH
         dH9hy0DjeQwju2449+OyaIVbCSIRJOzcZbSV32tBT0Mgk2UzHxR8WcWvKvSrdrTEhDs2
         OF2A==
X-Gm-Message-State: APjAAAXknnHEAh9AtVGI9hu8u07Amb8c9GJckQQJ62ZtcVs3UnrCbhhW
        zKOmC6zMFDXwg9e80tk5lrk=
X-Google-Smtp-Source: APXvYqwcIYp9KzsF0hTGzFwcB9jyyL46s35jGUa0DeQwftF0P/oS3J8aOykHp4di7u5RdGuGusAYiw==
X-Received: by 2002:ae9:f404:: with SMTP id y4mr18560210qkl.112.1566856006633;
        Mon, 26 Aug 2019 14:46:46 -0700 (PDT)
Received: from Davids-MacBook-Pro.local (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id f12sm6526246qkm.18.2019.08.26.14.46.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:46:45 -0700 (PDT)
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
References: <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
 <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
 <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
 <20190812083139.GA2428@nanopsycho>
 <b43ad33c-ea0c-f441-a550-be0b1d8ca4ef@gmail.com>
 <20190813065617.GK2428@nanopsycho> <20190826160916.GE2309@nanopsycho.orion>
 <20190826095548.4d4843fe@cakuba.netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5d79fba4-f82e-97a7-7846-fd1de089a95b@gmail.com>
Date:   Mon, 26 Aug 2019 15:46:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826095548.4d4843fe@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/19 10:55 AM, Jakub Kicinski wrote:
> On Mon, 26 Aug 2019 18:09:16 +0200, Jiri Pirko wrote:
>> DaveA, Roopa. Do you insist on doing add/remove of altnames in the
>> existing setlist command using embedded message op attrs? I'm asking
>> because after some time thinking about it, it still feels wrong to me :/
>>
>> If this would be a generic netlink api, we would just add another couple
>> of commands. What is so different we can't add commands here?
>> It is also much simpler code. Easy error handling, no need for
>> rollback, no possibly inconsistent state, etc.
> 
> +1 the separate op feels like a better uapi to me as well.
> 
> Perhaps we could redo the iproute2 command line interface to make the
> name the primary object? Would that address your concern Dave and Roopa?
> 

No, my point is exactly that a name is not a primary object. A name is
an attribute of a link - something that exists for the convenience of
userspace only. (Like the 'protocol' for routes, rules and neighbors.)

Currently, names are changed by RTM_NEWLINK/RTM_SETLINK. Aliases are
added and deleted by RTM_NEWLINK/RTM_SETLINK. Why is an alternative name
so special that it should have its own API?

If only 1 alt name was allowed, then RTM_NEWLINK/RTM_SETLINK would
suffice. Management of it would have the same semantics as an alias -
empty string means delete, non-empty string sets the value.

So really the push for new RTM commands is to handle an unlimited number
of alt names with the ability to change / delete any one of them. Has
the need for multiple alternate ifnames been fully established? (I don't
recall other than a discussion about parallels to block devices.)
