Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58728BBBF
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 16:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbfHMOl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 10:41:26 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46184 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbfHMOlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 10:41:25 -0400
Received: by mail-ot1-f67.google.com with SMTP id z17so54882486otk.13
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 07:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w23bLnFzi9AUagd2zWMhCoNOJMu5/JNXIyHfbAetaCY=;
        b=kifPA4o3I5kT4D+FqZl2V6OZbENN6UEMAKc29EtNHEeqVeWqbWfUUpslgHtO0kc3Br
         K/i8f4ThXKo7ZgXNkM4JJ5DcHdogM9ZGiJlpHrCDFUqDFOiw2wn7W6CDAXcoo8g2Ego3
         IOynHEBM2uEJLVRz/W3BTFzb3Yyb0Lp46ePvubCRved30bb+4bpICzEbSro8jrDEVQhJ
         jmn9slMjlrlIx1nYFrj1rzeUaiQZ2jkiHBSxdtaagtLBtcCl3UdKPOH3jM67tL5cPyRa
         zrI14ShN6JKfUJHLWkq1JBE7kaXZU+/hB54WkOOSS+58NNI3x5zACbM2bjijQQtmznd0
         XUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w23bLnFzi9AUagd2zWMhCoNOJMu5/JNXIyHfbAetaCY=;
        b=F7WmCmvgdCZ9Ga7UMGs0KmpaKjHwPwtJW/aSGwgFcRTHt5rVkn8tVBXBbWjFBeiVpO
         JG87ivuBnGTNQ5mv8Das+UuHICKE8ndHTDxWE5+7M6Y0xOZJDj0wqH3u1Z6ZgMpFcWF6
         kPOpd9ayvPxY7RTTF+nYHbOBI+XdRK731tlfBk2T88Ef4qfnKnIs5iKLYs9XDRDMANr2
         jUfJAQxGoS7fcaQbnfVpthS7aSKh8YYkLS19Dm3PF4EPk9Dfl0YAjmSb2df6aWkgGTTG
         GPI0uxtSvPkbhrb6mEKNSygxxuaY3oo1cLzOZsXQGu5BTlHNI7ki2UtJtjnaic9EwLqo
         dNww==
X-Gm-Message-State: APjAAAWsMsuNBZ8FBDhvGtstcUkl2kfS0YFvOET4Rxyco8q9fWR1bjbp
        oKOqzmg33CfqlkCUxD4VvCG+Cerg
X-Google-Smtp-Source: APXvYqznZNawHjzcZgnQJ5TQBZl3JmnpLAeSPZgXGK6MUC6SIwj5/7TA6A9DcWwIMvba0dIiKoMGWg==
X-Received: by 2002:a6b:ee0f:: with SMTP id i15mr28961075ioh.91.1565707284505;
        Tue, 13 Aug 2019 07:41:24 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:accd:6969:d9bc:8b8c? ([2601:282:800:fd80:accd:6969:d9bc:8b8c])
        by smtp.googlemail.com with ESMTPSA id d6sm24230188iod.17.2019.08.13.07.41.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 07:41:23 -0700 (PDT)
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
To:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org
References: <20190806191517.8713-1-dsahern@kernel.org>
 <20190811.210218.1719186095860421886.davem@davemloft.net>
 <20190812083635.GB2428@nanopsycho>
 <20190812.082802.570039169834175740.davem@davemloft.net>
 <20190813071445.GL2428@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9306e893-cd43-75a0-9a81-fd2ee0dd44c5@gmail.com>
Date:   Tue, 13 Aug 2019 08:41:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190813071445.GL2428@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 1:14 AM, Jiri Pirko wrote:
> Mon, Aug 12, 2019 at 05:28:02PM CEST, davem@davemloft.net wrote:
>> From: Jiri Pirko <jiri@resnulli.us>
>> Date: Mon, 12 Aug 2019 10:36:35 +0200
>>
>>> I understand it with real devices, but dummy testing device, who's
>>> purpose is just to test API. Why?
>>
>> Because you'll break all of the wonderful testing infrastructure
>> people like David have created.
>  
> Are you referring to selftests? There is no such test there :(

I  have one now and will be submitting it after net merges with net-next.

> But if it would be, could implement the limitations
> properly (like using cgroups), change the tests and remove this
> code from netdevsim?

The intent of this code and test is to have a s/w model similar to how
mlxsw works - responding to notifiers and deciding to reject a change.
You are currently adding (or trying to) more devlink based s/w tests, so
you must see the value of netdevsim as a source of testing.
