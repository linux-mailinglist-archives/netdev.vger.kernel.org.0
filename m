Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F68767C8D
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 02:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbfGNA3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 20:29:21 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44875 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728742AbfGNA3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 20:29:21 -0400
Received: by mail-io1-f66.google.com with SMTP id s7so28157586iob.11
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 17:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fkhvfQ6T3SnfPb9oplxSk5QRUte1FbyCfHytK73HPQ0=;
        b=buNB6BpQK5bQB/ZqDaQ8td6ZCVqQ64Qn6zD3XSSuX+RZuYEDw3yKQs7EPjOCtijAtb
         4ZneFCxK+iGiBSvbn938qL4Uzh5XFIfIn+OuM5eQKAvui0KpFkXbuPyl30LBQmQakBoc
         w/NkWIZ/Z5Oi7eZoLYLuFK9zbSOaYAifQwtQfAoRDh8MXaSafC6eMXjFgZFR0mBcwYRM
         r/gZ1A+1i7nDSfP7YfGZnAbp681WQ53o1jKNZTG7qWXFXz3jhSioYuTv6QPk7IgeXbgY
         vAjHr9ieWujS0i3jm0fV3AVgylCtDODDbFu2ub+0OvMPsDlvZcS7ouwpWnwNUDfs/3tN
         ovow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fkhvfQ6T3SnfPb9oplxSk5QRUte1FbyCfHytK73HPQ0=;
        b=UXMAT4uEpmnJJe53nG9TciF5nywkF2DJhEL7KZUv3NOMH31SESd+Q/3VQuEYijRmtH
         5xyYEmhJktq1ViwalecZuJtVl8565IiXhki7j9s4V95ylMvrJS6T5f/XPrinal/CVcEK
         zCo4vxPO0cVrtlvu8hOQLGkCDghMu2cPOv3BLRF58mGVZP5lq5vml5n2L5PCbn0b+rEy
         afVBXxjgvGhKS0ukQzU+HWpPZbodDn2NZNfqiV3dXjw8iC/pMNJrTUGD9wuzyUzf8LNM
         o1i2ikUi58IaZ4kSHA/EqZ40/QbIHTFPpgL/Pzcd3K5AFZZNKIFgqFzcytXIA0TFqkfn
         i6mg==
X-Gm-Message-State: APjAAAWedrRv1ewDXCYXLZelps6624z6Cbg5TbPyaunLzwtMheFNQfqa
        Zf3nKKupYjBCr+qdtHkjFvr9KKsz
X-Google-Smtp-Source: APXvYqwjbATyeCclBkw5Ag5vmUJGB2YWmbFmJ+2+HYErjY3nFmldRxxaIzl5UpnshXQvGg/lD7mVGw==
X-Received: by 2002:a6b:7401:: with SMTP id s1mr17167555iog.67.1563064160184;
        Sat, 13 Jul 2019 17:29:20 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:184d:26dc:d796:2ec1? ([2601:282:800:fd80:184d:26dc:d796:2ec1])
        by smtp.googlemail.com with ESMTPSA id d25sm13429033iom.52.2019.07.13.17.29.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 17:29:18 -0700 (PDT)
Subject: Re: [Patch net] fib: relax source validation check for loopback
 packets
From:   David Ahern <dsahern@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>
References: <20190712201749.28421-2-xiyou.wangcong@gmail.com>
 <8355af23-100f-a3bb-0759-fca8b0aa583b@gmail.com>
Message-ID: <128233e2-aa2c-d2a0-6249-68fd927a299f@gmail.com>
Date:   Sat, 13 Jul 2019 18:29:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <8355af23-100f-a3bb-0759-fca8b0aa583b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/19 4:42 PM, David Ahern wrote:
> On 7/12/19 2:17 PM, Cong Wang wrote:
>> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
>> index 317339cd7f03..8662a44a28f9 100644
>> --- a/net/ipv4/fib_frontend.c
>> +++ b/net/ipv4/fib_frontend.c
>> @@ -388,6 +388,12 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
>>  	fib_combine_itag(itag, &res);
>>  
>>  	dev_match = fib_info_nh_uses_dev(res.fi, dev);
>> +	/* This is rare, loopback packets retain skb_dst so normally they
>> +	 * would not even hit this slow path.
>> +	 */
>> +	dev_match = dev_match || (res.type == RTN_LOCAL &&
>> +				  dev == net->loopback_dev &&
> 
> The dev should not be needed. res.type == RTN_LOCAL should be enough, no?
> 

nevermind, I see why you have the dev check.
