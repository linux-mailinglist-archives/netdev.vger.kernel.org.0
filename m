Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FF0115778
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 19:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfLFS5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 13:57:13 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42346 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfLFS5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 13:57:13 -0500
Received: by mail-lj1-f195.google.com with SMTP id e28so8718234ljo.9
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 10:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MZzVEDKw0xJ1LdZWdLyqF1kAetxtXHX7iNSp25BcsYM=;
        b=SUteSPlq//TtrFZYEjyYZEfNGuxGqmxOjFEVlXgaz5K1Qwn4QYiSuDSCqYTZeGzz2j
         q1A8l8vziiDjmPn27aYu0xSWYIlXzoFnz5DhfCOwQ8hfHNGj7RF7puaMSM1tHoZfMUlj
         u612zQAhF5W0kL7/rPbuyhvTpmD4oNIBmvn6n2eGp8F5/Nfh9C6hjRnbY9VHE/QermLJ
         LsDGXXLyJmhmE2XYgHk1I/v45HSDjeoVO6QaaKRX3SYLeI9QQW2Ahi5UwTF3OGTYi++G
         cPHK9gSdGH+YCdsHz4U3tBdaTL5uTp8WVxcCa/xkItBcdsrbmb5jbd1d4T9/qewq21b+
         IjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=MZzVEDKw0xJ1LdZWdLyqF1kAetxtXHX7iNSp25BcsYM=;
        b=FCOJzQ1WSxJ2ZxatWnNx95Ea3lu4OKJLPqOFAq/TBlbhhp4SFowuMTk0MLfwmQ0bKy
         d0BxYq66Qi9Oi9Kj2RScnc50UNt3kkGUBVhmy+iCi5/g6e7EMk/IkbZKD9+bR6yzxf4M
         JaTfKwAUQNyEaYpLOKbAKqu37UjTg19CCYLPtOtD5u3/tpgqOKSlkkUV1fd26R42OPJv
         WcJGt95avyrUqh2YRxFTuAsntuxLCrYwPAycxu0q+t9Fo5MajEeKfyQH62ncoTvRVKK3
         gH8qv/FIdZnJsvcKs6knpCq3QW3UrAXS8o4nru2ljzb7bGWTogWkf0h3qe/SFaKn0TI9
         Jdvw==
X-Gm-Message-State: APjAAAWlP2MCGPdMU2Qy3U5shkbWW+Xhinxo65X03Qcv0Q6ebUggSu00
        yZl5bzS2334ymnXWpsrTrpCMNkv/N9s=
X-Google-Smtp-Source: APXvYqyUjf9C/RfOj0319esZ9p5iFtsQU5Q9qrxOEL/Ri6qEHBc1tD2EzfbYW13xAMe3+q5rVLmU2Q==
X-Received: by 2002:a2e:9356:: with SMTP id m22mr9735123ljh.160.1575658631283;
        Fri, 06 Dec 2019 10:57:11 -0800 (PST)
Received: from wasted.cogentembedded.com ([2a00:1fa0:4291:257c:a228:1c89:88a1:5b3b])
        by smtp.gmail.com with ESMTPSA id x29sm8078381lfg.45.2019.12.06.10.57.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Dec 2019 10:57:10 -0800 (PST)
Subject: Re: [PATCH net] net: netlink: Fix uninit-value in netlink_recvmsg()
To:     =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20191206134923.2771651-1-haakon.bugge@oracle.com>
 <13b4ccb1-2dec-fc4d-b9da-0957240f7fd7@cogentembedded.com>
 <6255CC20-05DA-41C1-A46D-FE7F6C4A64BD@oracle.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <e24313a2-22c9-18da-4475-733157399975@cogentembedded.com>
Date:   Fri, 6 Dec 2019 21:57:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <6255CC20-05DA-41C1-A46D-FE7F6C4A64BD@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/06/2019 09:45 PM, Håkon Bugge wrote:

>>> If skb_recv_datagram() returns NULL, netlink_recvmsg() will return an
>>> arbitrarily value.
>>
>>   Arbitrary?
> 
> is an adjective.

   Yes. And it goes with the "value" noun.

> Since I described the verb *return*, I assumed the adverb,
> arbitrarily, is correct,

   In that case, it's misplaced, it should go before the verb.

> But english is not my native language.

   Not mine as well. :-)

> Thxs, Håkon

MBR, Sergei

