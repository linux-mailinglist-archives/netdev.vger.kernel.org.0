Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C121E89530
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 03:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfHLBh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 21:37:29 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35622 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfHLBh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 21:37:28 -0400
Received: by mail-ot1-f68.google.com with SMTP id g17so2501317otl.2
        for <netdev@vger.kernel.org>; Sun, 11 Aug 2019 18:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lGmeiupklCEvwpqaN75h65oe9dnCdi0AMir4+yMeSZM=;
        b=fA20yvELRY1UKXe+meBYwgPm2fh4pIppGXCPBxIq4D1Cn032F058XrI8moBgaiFS9o
         YFoiXO3ZUZEDrD2SfAf7N2aEpXFNWUhAiwF7OAlA8eGo5xCcQ+eS/MMk5aDcYKlJx0M1
         CejBU/xTDHi2JajODMIPziGbdz99L+3udQsYHV2pblzm2l1/txzmzXOVles77bt92Hv5
         6W+DJqleCnz+ht3kd9VnKo1S1NhudUl0D/CT70chgq7WPO81PTGhIuSWZt7CqsSnp+x4
         6A9v2oXyWjEfj/ZSoBq2Unm8ElBsH7Ww7/e+9nA4GWJ9zkrTYBnN8xhCLQ8Qm70CKW/V
         x1Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lGmeiupklCEvwpqaN75h65oe9dnCdi0AMir4+yMeSZM=;
        b=bu37KHAQIsv6O5eLlaUbVSONivonRINSgugVSpgNMtE0gWHXO5a9bEN5vdTz7L1Sxa
         a2frjxrHOeGCXApS1GMnwA4icrFcZa289j1FZ8dhQ0BV7A+cB6b3KOPQZdLxaGwQZ37/
         IcgcgTlHjzsJQQuoevdY1cjfuYF9EtICC2wDFdp3pqgR3/PCd5QZbx4X8Y1Gx/BZbo0B
         WBC5NGiu/m76oWh9VZR4Il7O49awvTVBJkoShQeOuBse5sKZC/QmatfFZEn0QeN40Sch
         fLQFuHWpqRHFQQa8/GN2WXuHpqMmkEzy7Us91wMUHFZp6WyGnI27Jn/769P2Qg5xDcga
         hiZA==
X-Gm-Message-State: APjAAAUgarpAqL9TquoKxKkZaC7pEUutKt34hJtdWolgEbkmaClTtPRc
        gzv0duw8KjZ1GhgWjaGI8io=
X-Google-Smtp-Source: APXvYqwimJ44iI0Hrea8734cPlCaaIF9UN+p3Lg1ne1PdJwDFdYZd/pB+VW88ShadGBCbk75XKYlrQ==
X-Received: by 2002:a5d:9d89:: with SMTP id 9mr16302335ion.212.1565573847856;
        Sun, 11 Aug 2019 18:37:27 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:1576:e0d9:527d:c4bb? ([2601:282:800:fd80:1576:e0d9:527d:c4bb])
        by smtp.googlemail.com with ESMTPSA id n22sm148358027iob.37.2019.08.11.18.37.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 18:37:27 -0700 (PDT)
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
From:   David Ahern <dsahern@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
 <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
Message-ID: <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
Date:   Sun, 11 Aug 2019 19:37:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/19 7:34 PM, David Ahern wrote:
> On 8/10/19 12:30 AM, Jiri Pirko wrote:
>> Could you please write me an example message of add/remove?
> 
> altnames are for existing netdevs, yes? existing netdevs have an id and
> a name - 2 existing references for identifying the existing netdev for
> which an altname will be added. Even using the altname as the main
> 'handle' for a setlink change, I see no reason why the GETLINK api can
> not take an the IFLA_ALT_IFNAME and return the full details of the
> device if the altname is unique.
> 
> So, what do the new RTM commands give you that you can not do with
> RTM_*LINK?
> 


To put this another way, the ALT_NAME is an attribute of an object - a
LINK. It is *not* a separate object which requires its own set of
commands for manipulating.
