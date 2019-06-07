Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A673990C
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbfFGWjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:39:48 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35047 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbfFGWjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 18:39:48 -0400
Received: by mail-pl1-f195.google.com with SMTP id p1so1345421plo.2
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 15:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZtFMnrFjgCQiJ/Xtrjwklu5967W8ntMVmsVjXNz+UZc=;
        b=ErKT9ZJkJEhRK5bz0jrqifszUsXky3c0Rry+zLksnJfg/1I1I9JZOdfIr4qAUcLh4s
         Vcd5wJCALGen7EPOe6MzzIbXGOmTF1XkN/4fpnygaBgAf0grm+gA+MWe4HQc8mWfZ5/x
         crfK8ghwxfKncY4cJ0bGetZ0gEJPs6bUsS6OfblA+wwnVc61ZOILdqjj6wKCFjHbYRTm
         oG8BEO18CReckd2aejk+46tq4jq5OgUnH+OJ5u4I4SxSosjLQwFXxHsapUGURocIgtxR
         RQxQpkSP9qSXP9MYZ1A0Ws+/bHjGta4boCQSGvewzs2PEqGhl9DfuYpY6Af2XqgdSGk3
         z7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZtFMnrFjgCQiJ/Xtrjwklu5967W8ntMVmsVjXNz+UZc=;
        b=JZvGbvBkEQb/Tyyxsk1ipebhDWXibD3aJhBxGJnLjSuwwf4MCpcxxPdUPzpLcjt6iS
         GArytUaxZginbU361WTa6xowPEdi1dyj4dCP6l4hSKV76xZ9CWUn0z0AhZFn9+rFj5ao
         yyyEFIuJyNWt4/xy0YxHbYCARkr5OXOQZrnOek/Bwi1pBYwyP39/qXB4krKJOBowQm1j
         7Vkc2burAVMykGMBu7BIted8lcbCSNQhHtoumY03UsDtGv34/wMps5UyB9ag67ybjDAT
         ATEJWI/C/JBme7uivxTvhdXp52bXsFwqN1h/BhKawjgp0MY6EZDTrHhL8NqbSJocPqzD
         vzMQ==
X-Gm-Message-State: APjAAAXr02ZWnbwmwgOLdJIjJ+TpwISsn55kdCcByO2cKY8m3sOhMxwp
        V2QxmND/hh/MikKTaLY1hyQ=
X-Google-Smtp-Source: APXvYqy1gdFLivTFUjwydb4MRowEzVR1cvB3gHk70nTvY8iRqbIvs+dNmv9tYtOHH5A1IpcQp8l5Bg==
X-Received: by 2002:a17:902:467:: with SMTP id 94mr2918300ple.131.1559947187282;
        Fri, 07 Jun 2019 15:39:47 -0700 (PDT)
Received: from [172.27.227.254] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id j7sm3074746pfa.184.2019.06.07.15.39.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 15:39:46 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 07/20] ipv6: Handle all fib6_nh in a nexthop
 in exception handling
To:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        idosch@mellanox.com, Martin KaFai Lau <kafai@fb.com>,
        Stefano Brivio <sbrivio@redhat.com>
References: <20190607150941.11371-1-dsahern@kernel.org>
 <20190607150941.11371-8-dsahern@kernel.org>
 <CAEA6p_BcqXPKtshmsrpZMCrwz1TNzz0Wtoccu61gHuUg74Tx+Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3a7ea5b0-07cb-791a-171d-93047e365473@gmail.com>
Date:   Fri, 7 Jun 2019 16:39:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_BcqXPKtshmsrpZMCrwz1TNzz0Wtoccu61gHuUg74Tx+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/19 4:05 PM, Wei Wang wrote:
>> @@ -1835,6 +1848,24 @@ static int fib6_nh_remove_exception(const struct fib6_nh *nh, int plen,
>>         return err;
>>  }
>>
>> +struct fib6_nh_excptn_arg {
>> +       struct rt6_info *rt;
>> +       int             plen;
>> +       bool            found;
>> +};
>> +
>> +static int rt6_nh_remove_exception_rt(struct fib6_nh *nh, void *_arg)
>> +{
>> +       struct fib6_nh_excptn_arg *arg = _arg;
>> +       int err;
>> +
>> +       err = fib6_nh_remove_exception(nh, arg->plen, arg->rt);
>> +       if (err == 0)
>> +               arg->found = true;
>> +
>> +       return 0;
>> +}
>> +
> Hi David,
> Why not return 1 here to break the loop when
> fib6_nh_remove_exception() successfully removed the rt?
> 

will change. update will drop the found arg and let rc == 1 indicate an
entry was found.

