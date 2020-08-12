Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAAFB24243B
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 05:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgHLDSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 23:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgHLDSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 23:18:36 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A442C06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 20:18:36 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id j7so578124oij.9
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 20:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MdKGJKB2EXRL7pXO+Z2arfLldh3zaEqkeF9uPAzikWo=;
        b=VnwjEq/t4XKFoWSRzV7R851Bks0IFGbFRWMcpVnLA/ild3+mWgyKX2TulnehrmwtPA
         TsZwsjHAXfrr2HhyNCgFJl5faGWzgcYExHLShk6HZTWHudYzCQ4AxmbxcKAn/gEIaTvN
         GFBLn5kE/DR8DRCAIN2OOdMTElCkTA39Lp8tJIka9u58URirBfa7T8e6KiVR3PMd/Obs
         sGJEqqYMtbRO24qhfEUk0UUWP+4FL7xJOZA9Tc9rCloRuPzVNsPJzrV53/6aRmU63Gaq
         cYyazKou1ctgL9DOxsrk47wnXCb11rV1P+Th25HNmNrft0gdb5W9mpvqaYwPA4sQ2RzQ
         h51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MdKGJKB2EXRL7pXO+Z2arfLldh3zaEqkeF9uPAzikWo=;
        b=NfFqei4rSCHdc3HBP046YtTKXHtAEGTiEfZ/k9A/cy9UJPW16fy/oyfzfhnPcfjsYu
         Ixc15uK7kxdeBHwkIzRiW0/JanDeERAbTLZ+q6tqbmczCN5vOv00vWgp0mPXgJsDnesO
         jWRFuLjHlZ9Ev/E1VbxiSz0tjkN/gYUhpI9lnOrRbCQ6JQ/v+6isEHgIHTLQBhEd5Lfj
         nB9KP3S7dKmZ2fomO+DbxNE78OsHd3gNofSAgBCJ3iykJD1crDQyBulmrhs/KVlxp7XB
         b1CiclPmvXIylSLDPCc8VYoE3GgKYKc6HR29QMQWB+c6RRQuqtmuYizY8RmNi1apKdd/
         +BmA==
X-Gm-Message-State: AOAM532gJri0vM/iUWoaehK50u9ipPEC/m8gZWb94aBh18SZRIi6mtKN
        /3658j+SeUqMLLIkeqPbYhOCyUyZ
X-Google-Smtp-Source: ABdhPJyNkqx5H8pYkL5HZzXM/uX3GAkGWffvCDRdJVZOFIzSyMPQlH/vco70Jz0QRH4voVGh9bOAAw==
X-Received: by 2002:a05:6808:601:: with SMTP id y1mr6082895oih.22.1597202315681;
        Tue, 11 Aug 2020 20:18:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:c1d8:5dca:975d:16e])
        by smtp.googlemail.com with ESMTPSA id r15sm152524oor.35.2020.08.11.20.18.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 20:18:35 -0700 (PDT)
Subject: Re: [PATCH net] net: accept an empty mask in
 /sys/class/net/*/queues/rx-*/rps_cpus
From:   David Ahern <dsahern@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Alex Belits <abelits@marvell.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20200812013440.851707-1-edumazet@google.com>
 <5b61d241-fedb-f694-c0a1-e46b0dedab66@gmail.com>
Message-ID: <236b4f44-70a0-834e-441b-cd50eb3c0051@gmail.com>
Date:   Tue, 11 Aug 2020 21:18:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <5b61d241-fedb-f694-c0a1-e46b0dedab66@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/20 9:16 PM, David Ahern wrote:
> On 8/11/20 7:34 PM, Eric Dumazet wrote:
>> We must accept an empty mask in store_rps_map(), or we are not able
>> to disable RPS on a queue.
> 
> 0 works. Is that not sufficient?
> 

To re-phrase:
    echo 0 > /sys/class/net/*/queues/rx-*/rps_cpus

works to disable rps. I don't get the difference in what you are
changing here.
