Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CD1377910
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 00:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhEIWp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 18:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhEIWp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 18:45:26 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F82C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 15:44:21 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso12772999otb.13
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 15:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z7LlaMk8ew5Lcgj4itXeK5xYc5MArZgk6UrX2/Ab+/4=;
        b=ntEsGjtDzn++ng4EyzzsekWrjSjuVCxI7kNaC7B8ysPcaHjY8s3MnsEmywYyAS+W7h
         fQ57l7etbAQMq3nlMDuq+3DIwUNcECuDgf6FWdxPy56Z/5t/9CXdHlbdF62UW8DqVWb+
         nRLwoKza9Uo2kP7F5/4XWOs7LqwuJA0lfHBDTfVcKiBdIKpqWJaufHi57U6Mem5oEcK1
         eeZXCjy9C6AkmEFsjiWBk7+YEbzilLTaAuDftrMRYqwX89NjIdGmLm12RGdeK52PiJYU
         MxkkZr91FCs2H0nHryntKjFPFhn0jQY10VlFY26zb13Z9iNVX+aqQBk5tsr/8F4PQ1Ma
         /PCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z7LlaMk8ew5Lcgj4itXeK5xYc5MArZgk6UrX2/Ab+/4=;
        b=Rw6B5RvuKJ/+LuVEVOo7hPoRcmzLu17DNLlWTRNKBKv4vDlqvpAKK072+OC2wqlqx8
         1u30PauPzv/s5Cmo9WJuwR3zElEW2YNp8u3eLSmLTvlIKaQ5HgL/9O6Oyw6Kbv5zIr3c
         JTzHcXbm+vZjLzFM1dYr2EcCjc7EnqkphJJtBoTeuVqQFxF2wzFhvoe9ZgziZVlitZnT
         6BYevplh9xVMRPBcqSTbSERUYExWdGjm4bCpwH0oxEzXV/paa8/SRMXJTjUOKUYsiPkG
         wODB/9EE8EilfGKg8BxgfzeJ2l6AcIc7R6xUaLK/rGaj55Jhm7YoF+WxSPLfM3nzgTc0
         sxMA==
X-Gm-Message-State: AOAM530D8JpOysCXJAyBR6PDgA1Pjxn/L4tfDezacGx1HWhLmVln2PlN
        OutDviFPCIbKPgoFy3e3NO9TFW6+JN4=
X-Google-Smtp-Source: ABdhPJxZ54I86LuY5JCJ5af1GDyTnHjZw7bY0RdO0K8PiKLgY8RuazC/EPkD7toS19s7uhLuT4H5/g==
X-Received: by 2002:a05:6830:2141:: with SMTP id r1mr15005654otd.13.1620600259364;
        Sun, 09 May 2021 15:44:19 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:5d79:6512:fce6:88aa])
        by smtp.googlemail.com with ESMTPSA id q20sm2728026otl.40.2021.05.09.15.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 15:44:18 -0700 (PDT)
Subject: Re: [PATCH iproute2] mptcp: avoid uninitialised errno usage
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org
References: <20210503103631.30694-1-fw@strlen.de>
 <b8d9cc70-7667-d2b3-50b6-0ef0ce041735@gmail.com>
 <20210509222549.GE4038@breakpoint.cc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3fc254ad-4766-a599-3500-ca16bd7d52c6@gmail.com>
Date:   Sun, 9 May 2021 16:44:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210509222549.GE4038@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/21 4:25 PM, Florian Westphal wrote:
> David Ahern <dsahern@gmail.com> wrote:
>> On 5/3/21 4:36 AM, Florian Westphal wrote:
>>> The function called *might* set errno based on errno value in NLMSG_ERROR
>>> message, but in case no such message exists errno is left alone.
>>>
>>> This may cause ip to fail with
>>>     "can't subscribe to mptcp events: Success"
>>>
>>> on kernels that support mptcp but lack event support (all kernels <= 5.11).
>>>
>>> Set errno to a meaningful value.  This will then still exit with the
>>> more specific 'permission denied' or some such when called by process
>>> that lacks CAP_NET_ADMIN on 5.12 and later.
>>>
>>> Fixes: ff619e4fd370 ("mptcp: add support for event monitoring")
>>> Signed-off-by: Florian Westphal <fw@strlen.de>
>>> ---
>>>  ip/ipmptcp.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
>>> index 5f490f0026d9..504b5b2f5329 100644
>>> --- a/ip/ipmptcp.c
>>> +++ b/ip/ipmptcp.c
>>> @@ -491,6 +491,9 @@ out:
>>>  
>>>  static int mptcp_monitor(void)
>>>  {
>>> +	/* genl_add_mcast_grp may or may not set errno */
>>> +	errno = EOPNOTSUPP;
>>> +
>>>  	if (genl_add_mcast_grp(&genl_rth, genl_family, MPTCP_PM_EV_GRP_NAME) < 0) {
>>>  		perror("can't subscribe to mptcp events");
>>>  		return 1;
>>>
>>
>> Seems like this should be set in genl_add_mcast_grp vs its caller.
> 
> I think setting errno in libraries (libc excluded) is a bad design

lib/libnetlink.c, rtnl_talk for example already does. I think it would
be best for the location of the error to set the errno.

Your suggested change here goes way beyond setting a default errno
before calling genl_add_mcast_grp.

> choice.  If you still disagree, then I can respin, but it would get a
> bit more ugly, e.g. (untested!):
> 
> diff --git a/lib/libgenl.c b/lib/libgenl.c
> --- a/lib/libgenl.c
> +++ b/lib/libgenl.c
> @@ -100,20 +100,29 @@ int genl_add_mcast_grp(struct rtnl_handle *grth, __u16 fnum, const char *group)
>  
>  	addattr16(&req.n, sizeof(req), CTRL_ATTR_FAMILY_ID, fnum);
>  
> +	/* clear errno to set a default value if needed */
> +	errno = 0;
> +
>  	if (rtnl_talk(grth, &req.n, &answer) < 0) {
>  		fprintf(stderr, "Error talking to the kernel\n");
> +		if (errno == 0)
> +			errno = EOPNOTSUPP;

you don't list the above string in the output in the commit log. Staring
at rtnl_talk and recvmsg and its failure paths, it seems unlikely that
path is causing the problem.

>  		return -2;
>  	}
>  
>  	ghdr = NLMSG_DATA(answer);
>  	len = answer->nlmsg_len;
>  
> -	if (answer->nlmsg_type != GENL_ID_CTRL)
> +	if (answer->nlmsg_type != GENL_ID_CTRL) {
> +		errno = EINVAL;
>  		goto err_free;
> +	}
>  
>  	len -= NLMSG_LENGTH(GENL_HDRLEN);
> -	if (len < 0)
> +	if (len < 0) {
> +		errno = EINVAL;
>  		goto err_free;
> +	}

EINVAL here is different than what you have in the commit message. Are
one of these the location of the real problem? Seems likely since your
commit log only showed "can't subscribe to mptcp events: Success" and
not any other error strings.

e.g., if CTRL_ATTR_MCAST_GROUPS is NULL, that would be the place to put
the EOPNOTSUPP, but then it too has a string not listed in your commit log.

>  
>  	attrs = (struct rtattr *) ((char *) ghdr + GENL_HDRLEN);
>  	parse_rtattr(tb, CTRL_ATTR_MAX, attrs, len);
> @@ -130,6 +139,10 @@ int genl_add_mcast_grp(struct rtnl_handle *grth, __u16 fnum, const char *group)
>  
>  err_free:
>  	free(answer);
> +
> +	if (ret < 0 && errno == 0)
> +		errno = EOPNOTSUPP;
> +
>  	return ret;
>  }
>  
> 

