Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B27305BED
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313036AbhAZWxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728667AbhAZEwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 23:52:01 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B874AC061573
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 20:50:45 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id n42so15119529ota.12
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 20:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o2VnHVENp8hgPn8vNR8RZ51FnncsYEg+d1uQ80GoX88=;
        b=eHsDw8U2kDf4c0P7ETAuquOdhdmIOeFlYhgUWAFTdD4N4S+XVfdGi8dJ9ysxKcqoZx
         xTCWG/svnl/GlbhdvJvWaVB+XLioaHK8Qxc/6tUkn04TPRe1JNLVtF9RH4oXGjo0S0eM
         JIbKpXLXVGIUswS/gPDfurYV+u8LVw6CQ9USxg9oCf6S94402UseY1TnNjemLI3MioMD
         eemt/JkZ8Cl8p4ccXJTgJbbd+ZDwLUzPdU2LJ3cyOY6Qbx46B+p1IFfo+Ksi1s/JR9X7
         gzSGABmUYUAo3gc8htm2XFap5iLbHKUur5DGxOzb/FJVgRe2UCcRZs50tuvjHqfwu0JG
         UhBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o2VnHVENp8hgPn8vNR8RZ51FnncsYEg+d1uQ80GoX88=;
        b=J2x1y+pmWloaCYvx2Q6OBU6dR/TpO82N6Gg3YEwhnUdKm2q6rbTvBpeDC1Or9cZ8CT
         1zNWb8d94lkGYC5xavfEp+Ci3axjmi7fI5mcyY05kSOeSwDTNxUGxIX6NfWplaYQU+n0
         IfOpstP3HJoLw1IIdwZ6IDDcing7PXVTQgV0wzh3MWS5GcUoum4TkyX+z2SYHG1tJjq9
         Q/oNLldjsh/NwRbrjeBYU9OgnyhNMb67usNv5Utxi3o/KlwUJ3q/pcsR2zuQeH1D7/8z
         YWsjuG/Z0wU6DQTELNDy70G8DeTtKC/kbee5x5r/ctL2uAdUh0ObmiVS8SQEa65yNLPs
         qePw==
X-Gm-Message-State: AOAM5326rl57LThUyfIj5AIMd/tbq29QQ8SfEMzwTwRsZ7ivsJUDwcHJ
        KGrlxI2di4Bm9qc1/dW0Em8=
X-Google-Smtp-Source: ABdhPJxlTt4dFO/bb9y2ZPCdpF6XJ4byh7YWKgJ7tkyqXH31cJTLyvmQ6dTtoQmmctE7BM0sxr2PTg==
X-Received: by 2002:a9d:6002:: with SMTP id h2mr2887521otj.312.1611636645097;
        Mon, 25 Jan 2021 20:50:45 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f5f4:6dbf:d358:29ee])
        by smtp.googlemail.com with ESMTPSA id t12sm1472808ooi.45.2021.01.25.20.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 20:50:44 -0800 (PST)
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute list
 in nla_nest_end()
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
 <20210123045321.2797360-2-edwin.peer@broadcom.com>
 <1dc163b0-d4b0-8f6c-d047-7eae6dc918c4@gmail.com>
 <CAKOOJTwKK5AgTf+g5LS4MMwR_HwbdFS6U7SFH0jZe8FuJMgNgA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8002ed1c-0941-c6f8-b3b8-c7114b2665c2@gmail.com>
Date:   Mon, 25 Jan 2021 21:50:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAKOOJTwKK5AgTf+g5LS4MMwR_HwbdFS6U7SFH0jZe8FuJMgNgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/21 1:42 PM, Edwin Peer wrote:
> On Sat, Jan 23, 2021 at 11:14 AM David Ahern <dsahern@gmail.com> wrote:
> 
>>> Marking truncated attributes, such that user space can determine
>>> the precise attribute truncated, by means of an additional bit in
>>> the nla_type was considered and rejected. The NLA_F_NESTED and
>>> NLA_F_NET_BYTEORDER flags are supposed to be mutually exclusive.
>>> So, in theory, the latter bit could have been redefined for nested
>>> attributes in order to indicate truncation, but user space tools
>>> (most notably iproute2) cannot be relied on to honor NLA_TYPE_MASK,
>>> resulting in alteration of the perceived nla_type and subsequent
>>> catastrophic failure.
>>
>> Did you look at using NETLINK_CB / netlink_skb_parms to keep a running
>> length of nested attributes to avoid the need to trim?
> 
> I did not, but thinking about it now, I don't think that's necessarily
> the way to go. We shouldn't be concerned about the cost of iterating
> over the list and trimming the skb for what should be a rare exception
> path. Ideally, we want to make sure at compile time (by having correct
> code) that we don't ever exceed this limit at run time. Perhaps we
> should investigate static analysis approaches to prove nla_len can't
> be exceeded?

It's not a rare exception path if VF data is dumped on every ip link
dump request. I think you would be surprised how often random s/w does a
link dump.

As for the static analysis, the number of VFs is dynamic so impossible
to detect at compile time. Limiting the number of VFs to what can fit
would be a different kind of regression.

> 
> Tracking the outer nest length during nla_put() would provide for
> convenient error indication at the precise location where things go
> wrong, but that's a fair amount of housekeeping that isn't free of
> complexity and run time cost either. Instead of rarely (if ever)
> undoing work, we'll always do extra work that we hardly ever need.
> 
> Then, if nla_put() can detect nesting errors, there's the issue of
> what to do in the case of errors. Case in point, the IFLA_VFINFO_LIST
> scenario would now require explicit error handling in the generator
> logic, because we can't fail hard at that point. We would need to be
> sure we propagate all possible nesting errors up to a common location
> (probably where the nest ends, which is where we're dealing with the
> problem in this solution), set the truncated flag and carry on (for
> the same net effect the trim in nla_nest_end() has). If there are
> other cases we don't know about today, they might turn from soft fails
> into hard errors, breaking existing user space. Truncating the list is
> the only non-obtrusive solution to any existing brokenness that is
> guaranteed to not make things worse, but we can't know where we need
> to do that apriori and would need to explicitly handle each case as
> they come up.

Yes, tracking the errors is hard given the flow of netlink helpers, but
ultimately all of the space checks come down to:

	if (unlikely(skb_tailroom(skb) < nla_total_size(attrlen)))
		return -EMSGSIZE;

so surely there is a solution. There are only a few entry points to
track space available (open coded checks deserve their fate) which can
be used to track overflow, nesting and multiple layers of nesting to
then avoid the memcpy in __nla_put, __nla_put_64bit, and __nla_put_nohdr

> 
> Hard errors on nest overflow can only reliably work for new code. That
> is, assuming it is tested to the extremes when it goes in, not after
> user space comes to rely on the broken behavior.
> 
> Regards,
> Edwin Peer
> 

