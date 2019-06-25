Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2B354D5F
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfFYLSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:18:54 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37072 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730461AbfFYLSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 07:18:53 -0400
Received: by mail-qt1-f196.google.com with SMTP id y57so17927637qtk.4
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 04:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5xP+/lbbNKJS6FvjfKkxMtl3Jp0XYzuubfJqacbrv6Q=;
        b=1Ms3dh1nR5FeH7NazWf4Q2CgZN0IuyL0tq9c8Wu1znG4Gy3p1TYG94Fq2er0JNnqKq
         w6Jh0MKU/MrEMGDpp/UmyUG28PZ3x0V7oouZXjxvkOypnRwfj+50kNdSZrW6Eo3NSLm9
         LU4ZtjdcsUSJJTA2KTd00tbKrI2uYW4RISz9Y0RB4WQvXOuAPizOM6YzOwYXKt3IyQzx
         usBVH0dCbziEwZFdLhT0/7E88twebngG6cdPAswUlBMruCkSlmyYVWvI+aWBG5RXb2Z4
         h8MD1Jj2BZ2nnflydMqdJyVnSY+IKUc6AlYW8tvJ5MGf8/4DwGyJXSC8x8AB4BOTNs4t
         jWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5xP+/lbbNKJS6FvjfKkxMtl3Jp0XYzuubfJqacbrv6Q=;
        b=F3nHp1sELmM0vOgpQhoxzUZKMSQ1ZEOC9JiL2lP1QMVRAlgbVsvTpOGRchdoXncUEH
         NcIFHepLd1GNnXlaFJ8X2pEjLmVzynUSAb7va3xJyfz9QhLO7bvdPg5kPxnP1bC4Jn+Z
         Rq5q8Qjx3mqO508sut8pzW8TBnokidErPmlEziEUgZYYPFTAN6uvZvpgi0TEcc+KnHah
         uTcmb8wnrFOjbSNjln0SUFnBrOKFDmf1q/cEmGAfjWRpN4C9zhHhMxLXDiShlI0qNE1G
         C7gNAFF8zKNj/GkLS8UoWZe5n3GzLFidIxMzRSo9YvRyM80ny/5YPRWxh1GSVovdVOpm
         XcBw==
X-Gm-Message-State: APjAAAXmN56azAzSnu6Ec32WFLcjvJOA4kUCuMJeC+0YCzLdyntpz4hB
        XAdyiTYUnBwqlt87DiNyJaWorg==
X-Google-Smtp-Source: APXvYqz/ATmcWBIrhVb5FndPBZsQZ1yf/WIxn83UU/AAUm3RWNveeypeRhRPAH52KkNjqhK+p7VXIQ==
X-Received: by 2002:ac8:41d1:: with SMTP id o17mr59545945qtm.17.1561461533065;
        Tue, 25 Jun 2019 04:18:53 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id o38sm7781924qte.5.2019.06.25.04.18.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 04:18:52 -0700 (PDT)
Subject: Re: [PATCH net-next 0/2] Track recursive calls in TC act_mirred
To:     John Hurley <john.hurley@netronome.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, fw@strlen.de, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
References: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <108a6e4b-379c-ba43-5de0-27e31ade3470@mojatatu.com>
Date:   Tue, 25 Jun 2019 07:18:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-24 6:13 p.m., John Hurley wrote:
> These patches aim to prevent act_mirred causing stack overflow events from
> recursively calling packet xmit or receive functions. Such events can
> occur with poor TC configuration that causes packets to travel in loops
> within the system.
> 
> Florian Westphal advises that a recursion crash and packets looping are
> separate issues and should be treated as such. David Miller futher points
> out that pcpu counters cannot track the precise skb context required to
> detect loops. Hence these patches are not aimed at detecting packet loops,
> rather, preventing stack flows arising from such loops.

Sigh. So we are still trying to save 2 bits?
John, you said ovs has introduced a similar loop handling code;
Is their approach similar to this? Bigger question: Is this approach
"good enough"?

Not to put more work for you, but one suggestion is to use skb metadata
approach which is performance unfriendly (could be argued to more
correct).

Also: Please consider submitting a test case or two for tdc.

cheers,
jamal

