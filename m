Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306EC124DB
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 00:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfEBW4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 18:56:13 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34678 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfEBW4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 18:56:13 -0400
Received: by mail-pl1-f196.google.com with SMTP id ck18so1721960plb.1;
        Thu, 02 May 2019 15:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yYIDXzsF5fvEyzgU5d3tO5SefJfzaF9fpPhpJPjIMWI=;
        b=OKBTrfbyTYMGYlbj+6jkYEKZBKOIW02JjJy+SniE2CnpK4qC1E1JHiC84R/MMS8hMK
         sRdYumKZZ3vhO5u086rn2CzBKp9ewJpRM9qhOmgsJIv8m//LHzGEQRGIb5Zkxfsgam9i
         Ghr0iJXzcMvrggQ3EjENnngy2MkGzI3Hps+JUiwwktezQONfaKnkFa858UobXz2BUBHj
         N6pyIw6+rrNA5n3bLYlIJwx0xvnuWX0M4CZlvjQHdBcigfD1vqYzxhFOBLNs29AhWssN
         NR/S5f5rMvTbW8tF4+J+7murVOmvdrXO1RdEKylMeD3zIRVcNXrIKQxgsvsmjCzBMBDi
         hi/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yYIDXzsF5fvEyzgU5d3tO5SefJfzaF9fpPhpJPjIMWI=;
        b=lSzmR1UFf094x5M+3p29FpWn23qG2Ug25W+RtImm61eacHiSrJNtI6sx4B9RYT18QC
         vllBKPqoS2ghOY0zNSj1c9gaqGHhes2IG6e+TfNPQnHuqnx7UVCJ84tFjU9zPE/I+a3A
         OFDiXJ2qye3M2mJlsen9eFIQQYuNCF5YXqHezFxUVcBm9ntVmfg2snlR08LVvQQnA8+8
         EMCutZJ2c1gCrw8hNRKMESvtkVOS85OIIAOaQhHX2Z+DimCKoUyral+58FOHjTOfNTUL
         qL5MMGEe5ooQAGxBmxnPiSQJnNC3nCmSlpC6Cj8bpf59XdayEhS55NZ99PrtqUehhFHA
         m2DQ==
X-Gm-Message-State: APjAAAUbZuo3TmlqYDf4XRBO7ao845PaI2oc8OJ4HCchmC5sX0jedW82
        2Mwg4dFGV90rkQwIkpoD+WfMQiG4
X-Google-Smtp-Source: APXvYqwVbK1OXAG423NH9+vSp6oHPJ9nEAClioZQiyQCf2R0Gm8PoyiNA2bZAPiUJ3tzV8am6r8XQA==
X-Received: by 2002:a17:902:822:: with SMTP id 31mr6430968plk.41.1556837772510;
        Thu, 02 May 2019 15:56:12 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:ac7a:3232:c2d1:fdde? ([2601:282:800:fd80:ac7a:3232:c2d1:fdde])
        by smtp.googlemail.com with ESMTPSA id r138sm327790pfr.2.2019.05.02.15.56.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 15:56:11 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] netlink: add validation of NLA_F_NESTED
 flag
To:     Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
References: <cover.1556806084.git.mkubecek@suse.cz>
 <6b6ead21c5d8436470b82ab40355f6bd7dbbf14b.1556806084.git.mkubecek@suse.cz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <17889318-db59-5c29-fd29-7babe8c63030@gmail.com>
Date:   Thu, 2 May 2019 16:56:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <6b6ead21c5d8436470b82ab40355f6bd7dbbf14b.1556806084.git.mkubecek@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/19 8:15 AM, Michal Kubecek wrote:
> Add new validation flag NL_VALIDATE_NESTED which adds three consistency
> checks of NLA_F_NESTED_FLAG:
> 
>   - the flag is set on attributes with NLA_NESTED{,_ARRAY} policy
>   - the flag is not set on attributes with other policies except NLA_UNSPEC
>   - the flag is set on attribute passed to nla_parse_nested()
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> 
> v2: change error messages to mention NLA_F_NESTED explicitly
> ---
>  include/net/netlink.h | 11 ++++++++++-
>  lib/nlattr.c          | 15 +++++++++++++++
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

