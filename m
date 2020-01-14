Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4702213B15F
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 18:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgANRwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 12:52:31 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35199 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgANRwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 12:52:31 -0500
Received: by mail-lf1-f67.google.com with SMTP id 15so10534320lfr.2
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 09:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DSwJDN8tvKZIB15Co+RV4TjQqizFvEQ1g5xhaUGMxvM=;
        b=BxuIw7llM5VJ5Foo76K6dEzNdP/AoQSUESBDwYDOo/GzWwHehjwLp44avxKn67rQP4
         a9BsJXhkVJ5/SfNjUBZBWRVoMxodH6+t8I4+07dys6oUnl/uTK57Fs6T7z8xFwSsvwu0
         C4i8KCHQR1kwSFo3imo6IqI7+FgOp25qxxJBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DSwJDN8tvKZIB15Co+RV4TjQqizFvEQ1g5xhaUGMxvM=;
        b=G1FzVTMGT1qwdvO7XuspPr6ADkN2eILjmMTm5bqRecg7zRyxs7KB/mDGX0hvc8dveO
         WpjaN3X3MkIexDvg+bZoxB6rDoFFBXQ933NlFvoLf6EYVHgEkAjhA0OVWV2Zgt3vGYsn
         h8Qfi4JdYF1YxDym9thWKc2e9/ripQS3Oeb6x/3rrRVQOrbRMz472k+uMKRPfghk3hRi
         LE2vW0kqTOyMLk/AjjBHlCq6K9DiEuMox/SgPc9FWCXAXrD5fK2rItGan3uImN0SQK24
         d8xfeFKB9WWBQ+ivSzwnbOmYnLcbHfKkG7dgUoB4i7CXLdG7GihGWCXXeHV2UTcQkOlB
         SL8w==
X-Gm-Message-State: APjAAAVRMmP7xbs2iL5d1sFo7CXTpuJZTZCvAeM2rQG/Clbc0pt/iRiK
        F5ipbqyAsrmutOPJrtLjAKw/fg==
X-Google-Smtp-Source: APXvYqyZmFT5TWZSmX4q8zW9ZMDHt7BfreCFFdL1gB1A1XHgyV+RG7FHFhHQJvxinyuJEFinalnzzA==
X-Received: by 2002:ac2:5147:: with SMTP id q7mr2550922lfd.87.1579024349496;
        Tue, 14 Jan 2020 09:52:29 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t20sm7774941ljk.87.2020.01.14.09.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 09:52:28 -0800 (PST)
Subject: Re: [PATCH net-next 3/8] net: bridge: vlan: add rtm definitions and
 dump support
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
 <20200113155233.20771-4-nikolay@cumulusnetworks.com>
 <20200114055544.77a7806f@cakuba.hsd1.ca.comcast.net>
 <076a7a9f-67c6-483a-7b86-f9d70be6ad47@gmail.com>
 <00c4bc6b-2b31-338e-a9ad-b4ea28fc731c@cumulusnetworks.com>
 <344f496a-5d34-4292-b663-97353f6cfa94@cumulusnetworks.com>
 <d5291717-2ce5-97e0-6204-3ff0d27583c5@gmail.com>
 <aa9878d2-22d7-3bcd-deae-cf9bccd4226e@cumulusnetworks.com>
 <473cb0a5-f6ad-ccd3-9186-02713f9cb92f@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <71fd75c5-3bb2-abf8-4977-50911d49e142@cumulusnetworks.com>
Date:   Tue, 14 Jan 2020 19:52:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <473cb0a5-f6ad-ccd3-9186-02713f9cb92f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/01/2020 18:53, David Ahern wrote:
> On 1/14/20 9:50 AM, Nikolay Aleksandrov wrote:
>> Ah fair enough, so nlmsg_parse() would be better even without attrs.
> 
> that was the intention. It would be a good verification of the theory if
> you could run a test with a larger ancillary header.
> 

Just did, works like expected. Tested all sorts of wrong messages and attributes,
they get properly validated and thrown out.

Sending v2 in a minute. :)

Thanks!


