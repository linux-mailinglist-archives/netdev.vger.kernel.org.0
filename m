Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05550D3921
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 08:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfJKGHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 02:07:00 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39897 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbfJKGG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 02:06:59 -0400
Received: by mail-wr1-f65.google.com with SMTP id r3so10433672wrj.6
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 23:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3c0Nh1nl7bfCKYDWMo6YBu1F2vfCDmy0MmjZnscBG0g=;
        b=WyVKVt5QOLSPRbgNDDvSj2Y0YxDMaLTkTz+Ox7Wk4QgNlzEfXEiSD7kaqsOOZzb1Lo
         LF2tdc8Sl8WLRUepsFc2TV35mao25gY/hIu9GOWfm1E4Rcz1N+2ehwygWpXiQ0GS4QAN
         T33qT5Ck8xXBAUaRTJ5XeKCiuIeHdEvbdPFCNGRKM2Tm2B66Oe7D80FAl8wKU2bIzVDB
         go8bRROgToWLqKOMGHfdaBDbgsGvt3h7Q+AekzwbxlqQkmthRiueUKxAmdyuxDMZpj52
         8JnPxY4/SUR4zYesI5gV8uXomBt/dgHG60goR7m0tUiITI/YobwxUTTH7aERvRSg7lvO
         Sn/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3c0Nh1nl7bfCKYDWMo6YBu1F2vfCDmy0MmjZnscBG0g=;
        b=kFji/BCpfjtcUC6EBO+TKVhCV4lBlU2Whulq3Fg2fuLMsrvpi9VLVUcFPh+0m1TvAz
         SjZRmplycIDdOKjdL/uJy7uZE3PLtIptELdE4rmrAwovfr8q+NwkJe7iWBMZIIq98uF7
         kZubYAzqLt0Z4paQrSLqR6B9ZPvPxIY4yXVffEt1YZ0uSESBNJW8TlNG7cAdp7+5lYhJ
         te3JIbmPIRrs8/Kd9OeaH4oCNZDn3mv3IzsgWgDPv0+p2ckSlvtCmUwGjC1O5LX8xrg+
         AEVlBnpMDJUfkAPfiKK7oTfHhUPe/XjlUAW1I70bTN1Ohj7RhCY9mhyNj2TR5/LYNKQV
         WVOw==
X-Gm-Message-State: APjAAAXx/OOEoTEbk0NYA4UQqZiZR1FZXRrkGUr2p12iRjn6H7mFaYIT
        caOoZwxlaOZccxuSSlZGxPBTGQ==
X-Google-Smtp-Source: APXvYqyB7/z06H6vETxUm8/rkhpQb8b4m12tfU6RIXrGBDuo0eiAZgmNXMQX1rjx2aN/nQgrT/ztMQ==
X-Received: by 2002:a5d:4ecc:: with SMTP id s12mr8554196wrv.73.1570774016719;
        Thu, 10 Oct 2019 23:06:56 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z22sm7618060wmf.2.2019.10.10.23.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 23:06:56 -0700 (PDT)
Date:   Fri, 11 Oct 2019 08:06:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 09/17] ethtool: generic handlers for GET
 requests
Message-ID: <20191011060655.GE2901@nanopsycho>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <b000e461e348ba1a0af30f2e8493618bce11ec12.1570654310.git.mkubecek@suse.cz>
 <20191010135639.GJ2223@nanopsycho>
 <20191010180401.GD22163@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010180401.GD22163@unicorn.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 10, 2019 at 08:04:01PM CEST, mkubecek@suse.cz wrote:
>On Thu, Oct 10, 2019 at 03:56:39PM +0200, Jiri Pirko wrote:
>> Wed, Oct 09, 2019 at 10:59:27PM CEST, mkubecek@suse.cz wrote:

[...]


>> >+			   const struct nlmsghdr *nlhdr, struct net *net,
>> >+			   const struct get_request_ops *request_ops,
>> >+			   struct netlink_ext_ack *extack, bool require_dev)
>> >+{
>> >+	struct nlattr **tb;
>> >+	int ret;
>> >+
>> >+	tb = kmalloc_array(request_ops->max_attr + 1, sizeof(tb[0]),
>> >+			   GFP_KERNEL);
>> >+	if (!tb)
>> >+		return -ENOMEM;
>> >+
>> >+	ret = nlmsg_parse(nlhdr, GENL_HDRLEN, tb, request_ops->max_attr,
>> >+			  request_ops->request_policy, extack);
>> >+	if (ret < 0)
>> >+		goto out;
>> >+	ret = ethnl_parse_header(req_info, tb[request_ops->hdr_attr], net,
>> >+				 extack, request_ops->header_policy,
>> >+				 require_dev);
>> 
>> This is odd. It's the other way around in compare what I would expect.
>> There is a request-specific header attr that contains common header
>> attributes parsed in ethnl_parse_header.
>> 
>> Why don't you have the common header as a root then then have one nested
>> attr that would carry the request-specific attrs?
>> 
>> Similar to how it is done in rtnl IFLA_INFO_KIND.
>
>To me, what you suggest feels much more odd. I thought about it last
>time, I thought about it now and the only reason for such layout I could
>come with would be to work around the unfortunate design flaw of the way
>validation and parsing is done in genetlink (see below).
>
>The situation with IFLA_INFO_KIND is a bit different, what you suggest
>would rather correspond to having only attributes common for all RTNL on
>top level and hiding all IFLA_* attributes into a nest (and the same
>with attributes specific to "ip addr", "ip route", "ip rule" etc.)
>
>> You can parse the common stuff in pre_doit/start genl ops and you
>> don't have to explicitly call ethnl_parse_header.
>> Also, that would allow you to benefit from the genl doit/dumpit initial
>> attr parsing and save basically this whole function (alloc,parse).
>> 
>> Code would be much more simple to follow then.
>> 
>> Still seems to me that you use the generic netlink but you don't like
>> the infra too much so you make it up yourself again in parallel - that is
>> my feeling reading the code. I get the argument about the similarities
>> of the individual requests and why you have this request_ops (alhough I
>> don't like it too much).
>
>The only thing I don't like about the genetlink infrastructure is the
>design decision that policy and corresponding maxattr is an attribute of
>the family rather than a command. This forces anyone who wants to use it
>to essentially have one common message format for all commands and if
>that is not possible, to do what you suggest above, hide the actual
>request into a nest.

But that is fine, the genetlink code would parse the common attributes
for you according to the family, then you inside ethnl_get_doit prepare
(alloc, parse) data for ops->prepare_data and other callbacks, according
to per-request ops->policy and ops->maxattr.

Then the request callbacks would get parsed attrs according to their
type. And you can use similar technique for set dumpit/ops. Would be
neat.


>
>Whether you use one common attribute type for "command specific nest" or
>different attribute for each request type, you do not actually make
>things simpler, you just move the complexity one level lower. You will
>still have to do your own (per request) parsing of the actual request,
>the only difference is that you will do it in a different place and use
>nla_parse_nested() rather than nlmsg_parse().
>
>Rather than bending the message layout to fit into the limitations of
>unified genetlink parsing, I prefer to keep the logical message
>structure and do the parsing on my own.

You are going to still have it but the person looking at the traffic by
nlmon would know what is happening and also you are going to use
genetlink in non-abusive way :)

>

[...]
