Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9017AD3935
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 08:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfJKGLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 02:11:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40166 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfJKGLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 02:11:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id b24so8913739wmj.5
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 23:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8nnHdbTQ16topfNyNvCbsM6+K1YLerkiNwgQ4142ujw=;
        b=Mc2YpNHQOWFIW4IjHMeujvyMfto0miF/ys2ftnO5wl6IlW4k1M5P/hgrU6QF+S+zne
         c6Q0jb1kdLTV8/wjXqKQ7ThP7kePqzQCf5emF+o3ZPpbnOGoXwOOIQ4X5m4VHjRhEsqR
         TuIY0oElP34DrB86M37i9Iu7BMeH2Y8hcGotJp5gSQ0eGKFkxqOAfoCWCi2nepDbZA7j
         VHMRVQu8ez9H3dpvpN8KzlJX3McvczI1g5xUKtLj9TZJShDHUenKhRE3KfmvxzV6rq0r
         ujqbClIcRYWHW0TqYcGvnErylMA5Q9MFf0Y1Z9NG+NRsROq4GA+TbCD5FTpWUBbncFeQ
         ByAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8nnHdbTQ16topfNyNvCbsM6+K1YLerkiNwgQ4142ujw=;
        b=O2SvDDFmh/WftLK6UvfTYTeKGudnLvFLCS/rLkviW0tgeJgPJT5prgn+V07vYRYupH
         Z8SJp/NOOSpMd5zRe0rKjG/VhBjWOUjrM/7pWV8CjC6BthTr4W5ZhXCO0H6ImN9Vq5Al
         NNYu2NEna2UzmPTiEYRDI1qrTAWHw9i22dSWYrpYBWCx5l4bnDcmO79atayBy0IEKlxO
         HkNWlM7XN5e5mqsO6Ez60HWwUnqFTGfM5sDIdOobPx0tHpFuTEk9cvzvc9RjPVXWYd9H
         D6+AKKahZzhKMQoTUow6Pb/sl/QhkwNy2Ir/WdseMJvHAxElIRdze+AzGMf8APLGMAye
         kHJw==
X-Gm-Message-State: APjAAAXpusNMgUQC+aBC8IJflBYi+f5a+eZ8g8bD9Ordv+u6DsCyIPUo
        Aeg2veTg98P74xY4Q8c5wEoqcA==
X-Google-Smtp-Source: APXvYqzJmfJGGAPKwvnppyTzbfzLxh8vOPMMhMObO6CIiiO7HVL4AbgLA3hiYEFwpH+Q9aMHW9SiOQ==
X-Received: by 2002:a7b:c44f:: with SMTP id l15mr1703059wmi.121.1570774266123;
        Thu, 10 Oct 2019 23:11:06 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id m7sm9545306wrv.40.2019.10.10.23.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 23:11:05 -0700 (PDT)
Date:   Fri, 11 Oct 2019 08:11:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] genetlink: do not parse attributes for
 families with zero maxattr
Message-ID: <20191011061105.GF2901@nanopsycho>
References: <20191010103402.36408E378C@unicorn.suse.cz>
 <20191010102102.3bc8515d@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010102102.3bc8515d@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 10, 2019 at 07:21:02PM CEST, jakub.kicinski@netronome.com wrote:
>On Thu, 10 Oct 2019 12:34:02 +0200 (CEST), Michal Kubecek wrote:
>> Commit c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing
>> to a separate function") moved attribute buffer allocation and attribute
>> parsing from genl_family_rcv_msg_doit() into a separate function
>> genl_family_rcv_msg_attrs_parse() which, unlike the previous code, calls
>> __nlmsg_parse() even if family->maxattr is 0 (i.e. the family does its own
>> parsing). The parser error is ignored and does not propagate out of
>> genl_family_rcv_msg_attrs_parse() but an error message ("Unknown attribute
>> type") is set in extack and if further processing generates no error or
>> warning, it stays there and is interpreted as a warning by userspace.
>> 
>> Dumpit requests are not affected as genl_family_rcv_msg_dumpit() bypasses
>> the call of genl_family_rcv_msg_doit() if family->maxattr is zero. Do the
>> same also in genl_family_rcv_msg_doit().
>> 
>> Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
>> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
>> ---
>>  net/netlink/genetlink.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>> 
>> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
>> index ecc2bd3e73e4..1f14e55ad3ad 100644
>> --- a/net/netlink/genetlink.c
>> +++ b/net/netlink/genetlink.c
>> @@ -639,21 +639,23 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
>>  				    const struct genl_ops *ops,
>>  				    int hdrlen, struct net *net)
>>  {
>> -	struct nlattr **attrbuf;
>> +	struct nlattr **attrbuf = NULL;
>>  	struct genl_info info;
>>  	int err;
>>  
>>  	if (!ops->doit)
>>  		return -EOPNOTSUPP;
>>  
>> +	if (!family->maxattr)
>> +		goto no_attrs;
>>  	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
>>  						  ops, hdrlen,
>>  						  GENL_DONT_VALIDATE_STRICT,
>> -						  family->maxattr &&
>>  						  family->parallel_ops);
>>  	if (IS_ERR(attrbuf))
>>  		return PTR_ERR(attrbuf);
>>  
>> +no_attrs:
>
>The use of a goto statement as a replacement for an if is making me
>uncomfortable. 
>
>Looks like both callers of genl_family_rcv_msg_attrs_parse() jump
>around it if !family->maxattr and then check the result with IS_ERR().
>
>Would it not make more sense to have genl_family_rcv_msg_attrs_parse()
>return NULL if !family->maxattr?

Okay. Sounds fine to me.

>
>Just wondering, if you guys prefer this version I can apply..
>
>>  	info.snd_seq = nlh->nlmsg_seq;
>>  	info.snd_portid = NETLINK_CB(skb).portid;
>>  	info.nlhdr = nlh;
>> @@ -676,8 +678,7 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
>>  		family->post_doit(ops, skb, &info);
>>  
>>  out:
>> -	genl_family_rcv_msg_attrs_free(family, attrbuf,
>> -				       family->maxattr && family->parallel_ops);
>> +	genl_family_rcv_msg_attrs_free(family, attrbuf, family->parallel_ops);
>>  
>>  	return err;
>>  }
