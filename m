Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26880DE245
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfJUCms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:42:48 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37938 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfJUCms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:42:48 -0400
Received: by mail-pl1-f193.google.com with SMTP id w8so5871270plq.5;
        Sun, 20 Oct 2019 19:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XWPIJFxOGHMjMlk9kcsicPPRMtWH0cKi1FZ4irNP4UU=;
        b=Q2KI6+o1iX9YCGqzOAxbO/hsrRde46xjf5t9nExPGHIYW7/5vTVN43YYE0wClfKTEj
         qY6J3lLN/SiGaUe8Nk8mqt7r2loOYy+cHzfLnnV9tCIFaThjD7I8Tlv8EMrZ5rTQSsxg
         RDNidf+Pjh9E6Ui1w0Hzt74y/1Dz479VZnUmEERzlslgGcNX5/VbWhkDvem+0BF4ZL2L
         xBPUGoqkTY+VL4GMukDvFcvAA2gESdCpxacYEfq2T6IRYalk6ejk0S8yExsmWTmgiP4W
         CTuscc/H+aROMJq/ku5sm/qZu8571aTIeO/02pbG8ApOw4cMRoYxUloAsf8oE2vUYGcu
         CacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XWPIJFxOGHMjMlk9kcsicPPRMtWH0cKi1FZ4irNP4UU=;
        b=oN9eYzM9p6NELAIsUouczadEkcFgdecBwUayGw4mLLYZ+2UNgUmZk5ElrtVpg1QMBD
         giRm5DI8/uQNvN2IgPStoo/8X6H6hfkD01E46s4GYv9EZuH+kDvyc3g8DOAaHva+NGIg
         3fhb5Rec7daM/6kzu72UrIpAC5mYkEk/cKGbfXJSrW4N/AJyk9Qz4orVCc1s6nYJbKPP
         wcjsC6U2NMIK/JlvYSOP5IzC4tTghEOthSM2XGn+ofJk5b9neuJYSawDWwwqdDwuRNUM
         FXgbRRcn8HIG9/NGMZ7C8/cQ1hCoEG6oQ3CreAoWZCB26KmchcgP6hEF/BLaLN6tj4OW
         wRXw==
X-Gm-Message-State: APjAAAUpTG7oEdjDZ12YRWjrBjmTh4ErYrl8PMon43Ls8gQQOycRFYow
        CSu8OpR3x6uxm4rjGWLlnhaWRxUS
X-Google-Smtp-Source: APXvYqxMb67+OUS5oEDrRWPc4JYkjikQ3lgMubupOFGlqCZPInWQm5yzi1cwMCpTslB8QIknRFZn1w==
X-Received: by 2002:a17:902:a584:: with SMTP id az4mr21498091plb.74.1571625767407;
        Sun, 20 Oct 2019 19:42:47 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id w5sm12690029pfn.96.2019.10.20.19.42.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:42:46 -0700 (PDT)
Subject: Re: [PATCH net-next 06/16] net: dsa: use ports list for routing table
 setup
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-7-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0a6e157f-75f0-045f-4ae0-0381816bba6f@gmail.com>
Date:   Sun, 20 Oct 2019 19:42:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-7-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Use the new ports list instead of accessing the dsa_switch array
> of ports when iterating over DSA ports of a switch to set up the
> routing table.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
