Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0517911A69
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 15:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfEBNk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 09:40:28 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:38792 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBNk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 09:40:28 -0400
Received: by mail-it1-f194.google.com with SMTP id q19so3421786itk.3;
        Thu, 02 May 2019 06:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7lTOIb797ZbgM37YhSzuOttlU06SmTOl4wegncATLZk=;
        b=BHpTILKlTctQL2DRgAjqWw5ranFKQcCqUM2wzLyQt8LnOkc4ohbC0twXEKth2S2FBO
         cyBN3DJHClKL4DkM0iZrOkdMutYfyhsa5MP6NI/bkLMSw1bThxmrcTgAEQ5tTB/CDnY+
         zrDNJyUdBosptp6bd6kv7b8dd8J9/jdMJS58JhcZAb7NPVwTnkvbvv/Myv2DhBIxGBMW
         XG0vF1IVU0SoG8cbkzV1xZLNPzKoElwJY8kSfPH7CbEexqV8vPGi/ZDnIE59U8poodYb
         NPkN6IBDD/C8RInHryahrCyH3S3Bbf+V3s69PwUTAo34E8nL67SuPAJmEE/1B3E4g6c0
         5CDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7lTOIb797ZbgM37YhSzuOttlU06SmTOl4wegncATLZk=;
        b=OKrytRUbvl7H7Ch6oL+5H1XCarrdDUVA5q3rx/CX5o21gJ0k88ZcLU3rrWto+NGryN
         FsVF0+GminQ3S+zD71WOiKyp+qqDFqToRraLsCLTlkrF1zjsnYyG/Wy4rL701ovhlT/D
         GG7Hs5LAPah0BbkaQwDWEOv4yXPhKibREPFui4s8BJ7GTdCQx5d/MhZG2+ajnWLP/07e
         /prdG4kE+ToBf3aF1RzTW2f7LH7zOkLMyEGL7QzewvK7UElGORknubosZQIibJsFeahG
         4z8JVHTi7yqrArrmC08+h/fS8J3EyrI1j9YYSxx6TbeWEyh5QXJKT5eN8iz82VGEeUT4
         rFOw==
X-Gm-Message-State: APjAAAXbb/uDIUqOj8R4eCT/HDmhCB8RYeV1CGxHyJOQHk8UjwvjjZ/z
        c6RWWtSk+3uaJ6vMiGSCqWkr98yZ
X-Google-Smtp-Source: APXvYqzmARoJzyiWlYiKjPHMnD+vGj78ZzSCinREjqZLDiNQ8VG6wT4s7ju9ovV9W0XlVqh/nw7Zmw==
X-Received: by 2002:a24:fa88:: with SMTP id v130mr2481013ith.122.1556804427420;
        Thu, 02 May 2019 06:40:27 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:7d41:7f77:8419:85e7? ([2601:282:800:fd80:7d41:7f77:8419:85e7])
        by smtp.googlemail.com with ESMTPSA id v64sm4655286ita.4.2019.05.02.06.40.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 06:40:26 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] netlink: add validation of NLA_F_NESTED flag
To:     Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1556798793.git.mkubecek@suse.cz>
 <75a0887b3eb70005c272685d8ef9a712f37d7a54.1556798793.git.mkubecek@suse.cz>
 <3e8291cb2491e9a1830afdb903ed2c52e9f7475c.camel@sipsolutions.net>
 <20190502131416.GE21672@unicorn.suse.cz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b11f899b-bfbf-7205-7b96-b8a974447662@gmail.com>
Date:   Thu, 2 May 2019 07:40:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190502131416.GE21672@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/19 7:14 AM, Michal Kubecek wrote:
>>> @@ -1132,6 +1136,10 @@ static inline int nla_parse_nested(struct nlattr *tb[], int maxtype,
>>>  				   const struct nla_policy *policy,
>>>  				   struct netlink_ext_ack *extack)
>>>  {
>>> +	if (!(nla->nla_type & NLA_F_NESTED)) {
>>> +		NL_SET_ERR_MSG_ATTR(extack, nla, "nested attribute expected");
>>
>> Maybe reword that to say "NLA_F_NESTED is missing" or so? The "nested
>> attribute expected" could result in a lot of headscratching (without
>> looking at the code) because it looks nested if you do nla_nest_start()
>> etc.
> 
> How about "NLA_F_NESTED is missing" and "NLA_F_NESTED not expected"?
> 

That is much better to me.
