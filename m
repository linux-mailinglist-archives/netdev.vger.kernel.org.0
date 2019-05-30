Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 315E82F8C1
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 10:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfE3IwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 04:52:05 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35846 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfE3IwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 04:52:05 -0400
Received: by mail-lj1-f195.google.com with SMTP id m22so5046376ljc.3
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 01:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PrcaO8hV9cWJOebcFdO5/p3ywdQGcjF3D+tLScZ5ESw=;
        b=BjTpd1GaUW+r+Iq4Zgf6n5pX48pPy+sPac5i98L0KZTzaVAqnWxpkTeD25CKOLJ5nM
         ylna4JTMAiIAgXLRNBQGL04k4UtWdDPbRjfWenmlwp+pyf4loel+rbHd8NpbPocQnjxK
         FKZCJSQJTOQRhnKYsaJUyHSxotZfU073AwxSuaANGzROQoGgDOpHLO4/iEDckiyxVN1i
         vvQzUFe9sBb4QIPl86xUD02oqLjA9os/USs2OmVDCidFOCPOSImdRrDwaQvoET9Cx2dp
         S838obXP5Cwvle2k/Oa9rdw4zF0E6IWT9d5SuUIFtzY9qm69zMF7LyTAnS3KHJFHMIpN
         nSzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PrcaO8hV9cWJOebcFdO5/p3ywdQGcjF3D+tLScZ5ESw=;
        b=gZuEI3Z40mjRoOoMk9XlHd4rSTMEjzNE6R0s76eMW7UG3CKL4eo+7uoUbd4g75kGrz
         +EaS0Tx0iByNnX+LyHOh3xcchduweprZpO4RZ/f9bF7Amj4PuTZNbcQ9c3XjjJVirrb+
         e9gQJ66PX9eFKKHDZ6hKzfFyUQLr0CUbW8vWZTxRXCR0anzEj3utbb2JUORPyw4zSycq
         kZqJc1BoctrQMUae96+Wrz4VZtAFsdkhve5a82DmLfE8dGAb4oXNWhY0WNqpSqVMW3HB
         WAspYY0WCACjKhNipHA8qKCrSXw9a5AjKZUmy4Eq7e+4Er5zCJ0KObHZ0UQoElvc3pGH
         6L1Q==
X-Gm-Message-State: APjAAAXBL9WMqWsHjKG7LFMrR9RdtVE8W3iJbdNW5pvwEe6+xg5pBXRf
        32B6tiI9FsdMKKW8rCz0VvWJnP62h6Y=
X-Google-Smtp-Source: APXvYqxAWsV5+K10qColmXk9JfYCBlhOK3x1Gadic8ps2ypXW9EGUx6zQ8UjvY0+XEKXM+aP+tteNg==
X-Received: by 2002:a2e:9b0b:: with SMTP id u11mr1394972lji.57.1559206323689;
        Thu, 30 May 2019 01:52:03 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.85.229])
        by smtp.gmail.com with ESMTPSA id y9sm356778ljc.2.2019.05.30.01.52.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 01:52:03 -0700 (PDT)
Subject: Re: [PATCH net-next 6/7] tg3: Use napi_alloc_frag()
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
References: <20190529221523.22399-1-bigeasy@linutronix.de>
 <20190529221523.22399-7-bigeasy@linutronix.de>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <6ee556c6-c885-d6bb-eaae-d8497594fbd6@cogentembedded.com>
Date:   Thu, 30 May 2019 11:51:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190529221523.22399-7-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 30.05.2019 1:15, Sebastian Andrzej Siewior wrote:

> tg3_alloc_rx_data() uses netdev_alloc_frag() for sbk allocation. All
                                                    ^^^ skb?

> callers of tg3_alloc_rx_data() either hold the tp->lock lock (which is
                                                      ^^^^^^^^^
    Sort of tautological.

> held with BH disabled) or run in NAPI context.
> 
> Use napi_alloc_frag() for skb allocations.
> 
> Cc: Siva Reddy Kallam <siva.kallam@broadcom.com>
> Cc: Prashant Sreedharan <prashant@broadcom.com>
> Cc: Michael Chan <mchan@broadcom.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
[...]

MBR, Sergei
