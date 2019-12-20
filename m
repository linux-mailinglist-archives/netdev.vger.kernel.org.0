Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97052127EF0
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfLTPDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:03:03 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46375 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfLTPDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:03:03 -0500
Received: by mail-wr1-f66.google.com with SMTP id z7so9675368wrl.13
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 07:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kpkhpCnZiARsQbYoX95Nzfqn4oNqVn/jp3ev7mcT74U=;
        b=h75efUGRKQe8PKx2z4IvOtsza2eVp4ahx0yK1ZO6xnsoqQc6F53XO9FM/G+rj5WDIt
         m3jykAJtxNkoI3P4Vf2i3OGWvZ/SvLxJ5gwrZs9gZ+AbQoWfhO9IMAIAylG41gHkZSOz
         nO1sY0neph6O7z+CarhhUo6pjiWEe5RovNiBruCsrUKfh63JiW/zJJbjPoc80vc/FMdY
         v7mfwKcXcqNcxV//LP+qkJwHCfeOMJB3sXkfpFSktkoJJK+y6ffsGycYdGtArWpLAuPr
         O0MmhE0uxPPYuXfPb0MSf10ilNzOQ1bBVanH6v/RCiRWt0TS8IAqlEKv1e6Ay15t5urW
         E0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kpkhpCnZiARsQbYoX95Nzfqn4oNqVn/jp3ev7mcT74U=;
        b=bRO5KEKF2tb8JCJQrgdsNux2n6/olZlfvkkYexxU4/4SodgOpvfwk/bbBdnPdW2qcl
         1091E5x1dy6RPrPZL3wCEcGFj5+ukbgokxLhZHVlrnWXUgi+Kymh6rhkRAgbi7Aqmnio
         XCCkfu4IeCNv+/kFJbvnhKPald6pUavMI+hbkC66h3akYN4C2I3z8rG+tlWPQ4z83l4L
         W49OpU6QBU+ldETtVYrEIki0+22lznoz8hbKRhHoYmr32NcLqgOcr3w2IUCZ4tII+2uG
         eyBY2LlKbHqJhJ9Lu00t1i7l3bztEbH/UKUfQLzJkJqloLd1tW7FFlOYmjAgx8vTYPIj
         Jt1Q==
X-Gm-Message-State: APjAAAWpaYh6vxCTtWpmM9q+C4s5CZ4TNVMB3AJlpPQk3u68fxBI20E3
        GyFel1WDzoO5E1F9wD8+/mO2rXox
X-Google-Smtp-Source: APXvYqxdBouHDPRyw5RCz0+jBTnTdlm3mQlR8koX2TR/xn0OtqHSmo/exb+2Y2NYlaIzboE/ZWsxyw==
X-Received: by 2002:adf:f244:: with SMTP id b4mr15448318wrp.88.1576854181565;
        Fri, 20 Dec 2019 07:03:01 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id s19sm9817574wmj.33.2019.12.20.07.03.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 07:03:00 -0800 (PST)
Subject: Re: [PATCH net-next v2 00/15] Multipath TCP part 2: Single subflow
To:     David Miller <davem@davemloft.net>,
        mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
References: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
 <20191218.124244.864160487872326152.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1eb6643d-c0c1-1331-4a32-720240d4fd25@gmail.com>
Date:   Fri, 20 Dec 2019 07:03:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191218.124244.864160487872326152.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/18/19 12:42 PM, David Miller wrote:
> From: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Date: Wed, 18 Dec 2019 11:54:55 -0800
> 
>> v1 -> v2: Rebased on latest "Multipath TCP: Prerequisites" v3 series
> 
> This really can't proceed in this manner.
> 
> Wait until one patch series is fully reviewed and integrated before
> trying to build things on top of it, ok?
> 
> Nobody is going to review this second series in any reasonable manner
> while the prerequisites are not upstream yet.
> 


Also I want to point that for some reasons MPTCP folks provide
patch series during the last two weeks of the year.

I don't know about you, but I try to share this time with my family.
So this does not make me being indulgent about MPTCP :/

Thanks.
