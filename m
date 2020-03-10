Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C185B180C67
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbgCJXdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:33:42 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:32934 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgCJXdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:33:42 -0400
Received: by mail-qk1-f193.google.com with SMTP id p62so401525qkb.0
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 16:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WbIZPPKvpx/jhkjCW+lXh6CBTzQBIW9/JLvy8GQbB/0=;
        b=faHHxeE1NazmO5mWpQfuDXPa5YqzpwkDS8MCQV7zl3FGINElv1qBNnKYBP6WJmbSXD
         0eTGoSgNXCqsRjoCQERGjRkiGSJ85UTgs3KgKM6eJz+aw2Cw5Wg96HSgnpGwtGk6X57E
         pbicUQERg9i1HGpPtd5wTeyJV0GF6kldAgrmud45x0xj4XlPqcmc+4sElBG+ocQPQZeN
         1CibB7BP2wtbTcomYbKzIPXqNTztEaP5upqRiJ2xlZQVGo4fBAp5ewl+gNPD6km+1MN+
         p12KzMkUHxTSCcUxO7uouizS/EOvD6nYa3YG1JcQ2aecmnA16SEme+Y3fU9zH+vXuHIm
         hfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WbIZPPKvpx/jhkjCW+lXh6CBTzQBIW9/JLvy8GQbB/0=;
        b=XG6Qs/ig6D3pMyhbzHNIv0DjPkmqbgfnb7LBXVo2fALL5gWFtj1OsE87lZ08BhKYmZ
         1hmP/NOFkzh+DyLycFdF3Ag8y+bkfd6vfJD4xUsGtYJrQHMsyBB8RuvuiYThNUmrVjAP
         hXkabJ4/B/NXh3pdAE7yKto8Q/YpvW4rRHnk99QkyZekqsk0TWYQuuo6ZEQJv6GVuN9O
         JvM1g5ZlB6GZrNpW6wAYwCGr/nvBJHFuEe5JPZvzvuBTGn15eLcdTvrfxUUcDiAEaHF3
         KgTqrXtogx2EaYL+iHbtXf8NVBNJlF6D/tUJtuirT2fV39H6G0oItLYHPhJ6CqHqp1Jv
         bIPw==
X-Gm-Message-State: ANhLgQ0NSY+RU94dkh9Ltdb/+/Ceo+WKEpM0e2+rUJ0NGQyEKuMhW6XM
        urrH4yTGu7vazErbEOnOlek=
X-Google-Smtp-Source: ADFU+vsVCEhHntdz/ONdkYS0y5uqBZURAkQmkpXOB9pGDKBy4w1XJtBo1chypubDiEMT5AqnB9HfGw==
X-Received: by 2002:a37:79c6:: with SMTP id u189mr326938qkc.96.1583883221005;
        Tue, 10 Mar 2020 16:33:41 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b876:5d04:c7e4:4480? ([2601:282:803:7700:b876:5d04:c7e4:4480])
        by smtp.googlemail.com with ESMTPSA id i4sm6924968qtr.41.2020.03.10.16.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 16:33:40 -0700 (PDT)
Subject: Re: [PATCH] ip link: Prevent duplication of table id for vrf tables
To:     Donald Sharp <sharpd@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Stephen Worley <sworley@cumulusnetworks.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20200307205916.15646-1-sharpd@cumulusnetworks.com>
 <b36df09f-2e15-063e-4b58-1b864bed8751@gmail.com>
 <CAK989ycxqKU0wYZdfNsMKVOtS_ENg+jhuYu5np7Hd-NdKLo4AQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1b4d5428-75f8-debb-983d-3ec4d63f8257@gmail.com>
Date:   Tue, 10 Mar 2020 17:33:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAK989ycxqKU0wYZdfNsMKVOtS_ENg+jhuYu5np7Hd-NdKLo4AQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/20 6:16 AM, Donald Sharp wrote:
> David -
> 
> I'm more than a bit confused about this stance.  I've been repeatedly
> told by the likes of you, Roopa, and Nikolay that we cannot modify the
> kernel behavior.  I get that, so that leaves me with user space
> responses.  I went this route because not allowing the end user to
> make this mistake would have saved us a stupid amount of time from
> having to debug/understand/rectify ( rinse repeat for every incident
> ).  A warning wouldn't have saved us here since this was all automated
> and a warning won't generate any actionable return codes from using
> `ip link add...`.  If the argument is that other people are doing it
> wrong too, point me at them and I'll submit patches there too.  In
> other words a user management problem that the kernel/iproute2 hog
> ties me from being actually able to stop mistakes when they happen is
> an interesting response.
> 
> Part of this is that the routing stack considers vrf completely
> independent and we don't have duplicate labels to identify the same
> table( nor can I think of a good use case where this would be even
> advisable and if you can please let me know as that I want to
> understand this ).  We have a set of actions we perform when we
> receive routing data from the kernel and if we don't act on the right
> vrf we've broken routing.  This routing data sent over the netlink bus
> is the tableid, if we can't stop users from making mistakes, can we
> modify the netlink code actually send us disambiguous data then and
> include the label as well as part of the route update?

As you know multiple tables existed long before VRF devices. The VRF
device provides the programmatic API for an end-to-end solution. To name
a few:
- moving packets (ingress via device A which is in VRF B to look up in
table C),
- applications (bind this socket to VRF B, a name for the table id), and
- assorted notifications like device enslave / removal.

I did think about the multiple devices pointing to the same table during
development, and at that time I did not see a reason to prevent it.
Ultimately, the kernel does not care which is why I say it is a
userspace problem.

Yes, people make mistakes and tests will typically use ip for scripting.
Existing behavior allows it, and we can't break that. Given where we are
any change needs to be opt in.

For example, your patch can generate a 'WARNING: you are doing something
unexpected or wrong' message. From there what comes to mind is the
compiler option Werror - make warnings fatal. e.g., for iproute2, it
could a new top-level option  (ip -Werror) so that you can alias it
(alias ip='ip -Werror') and then iproute2 has a warning function to
display warnings to the user that when Werror is passed that function
does exit(1) to cause the command to fail.
