Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5273421C508
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 18:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgGKQJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 12:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgGKQJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 12:09:32 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73649C08C5DD;
        Sat, 11 Jul 2020 09:09:32 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id w17so6439406otl.4;
        Sat, 11 Jul 2020 09:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qf07YRov7SfUOXWzDXUHuM7xMPAN7Piv/E000SBlNFU=;
        b=ggJQ2solKBn76Lp4qQiFF/06ZAIL/U/B47K7vJ03+TFG50Km4wUQbE2oaAKTR1Jlvu
         mFX/pCl1IADinOW8zdu0QLX82bhtp6PKZxtlE/3dxoTzFIXysuMoTegyON3urAs54wwM
         7X5/NffHlc+wE36jp1RcVfDSuECfHJXhoy6RclmNSV7dx3kTIQ49kTJ/j6R8EIfqtseQ
         qSddhf+2oFaC/KRcE7n12ewIVDY+jG+tu9BGtdyC6YkqtsMhv8MOz4DuPCYclxEwwV5q
         3QFchQYJkv3LqLPg2DkBfRZB6iCIzJPjS56yIyCs3GkEUFfkKizH7XfXIqPk9u0fo3Xo
         gz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qf07YRov7SfUOXWzDXUHuM7xMPAN7Piv/E000SBlNFU=;
        b=K2t/LdIsRxOj9j+5kl2sFbHEwJBqfWTazkk2COmnwnE7i9PZDFFixB3yc7hJxTzJbX
         Em0GoeadiqutE1IrnCf1GQ8wYF5sT7fe2T1k/tZXZOsI4DlnR1IXQyp4noI3wakLqqgm
         QWa4H2fGNMqD/mqCDU13BvlborLJ7PSfklizkSgkRPrIDR2aYlU/CWswFk7iDr4SjWMr
         3E+ZuLeKzVfd0uPwMf+sE+NGOjyPrgm0QHHvNEdK1NBMnwaeujCtCH6X0ZMhANkCkIQ6
         b8L4MPgZfTclDs+aJ116wTSvX3ao+sgu4E+1pFrecgzReJcH/DgwMe6gNoWgVAzOVWHn
         0bcw==
X-Gm-Message-State: AOAM530VgvUhzHCofQ1yeGUNT7eowk9kwGr7IU8lLySJNpz5CXPs5VSx
        tDk2FqApJuoRavdjhifZmao=
X-Google-Smtp-Source: ABdhPJzfOWcU4xfNAiLN664e4qCaxn2HXHza1c9nYzoGu6gyrkz4kWgPWcueMiBzeQM2LlfDNaDwXw==
X-Received: by 2002:a9d:6acf:: with SMTP id m15mr2706065otq.40.1594483771751;
        Sat, 11 Jul 2020 09:09:31 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:b906:515d:5842:4217])
        by smtp.googlemail.com with ESMTPSA id h4sm1760664otq.66.2020.07.11.09.09.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 09:09:31 -0700 (PDT)
Subject: Re: [PATCHv6 bpf-next 1/3] xdp: add a new helper for dev map
 multicast support
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200709013008.3900892-2-liuhangbin@gmail.com>
 <efcdf373-7add-cce1-17a3-03ddf38e0749@gmail.com>
 <20200710065535.GB2531@dhcp-12-153.nay.redhat.com>
 <2212a795-4964-a828-4d63-92394585e684@gmail.com>
 <20200711002632.GE2531@dhcp-12-153.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <53bd6672-f70d-086c-7155-d0136b6e8364@gmail.com>
Date:   Sat, 11 Jul 2020 10:09:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200711002632.GE2531@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 6:26 PM, Hangbin Liu wrote:
>>
>> The point of DEVMAP_HASH is to allow map management where key == device
>> index (vs DEVMAP which for any non-trivial use case is going to require
>> key != device index). You could require the exclude map to be
>> DEVMAP_HASH and the key to be the index allowing you to do a direct
>> lookup. Having to roam the entire map looking for a match does not scale
>> and is going to have poor performance with increasing number of entries.
>> XDP is targeted at performance with expert level of control, so
>> constraints like this have to be part of the deal.
> 
> Yes, if we have this constraints the performance should have some improvement.
> 
> Do you think we should do it right now or in later performance update patch.
> 

It needs to be in the same release as the initial patches. Easiest to
include with the initial set, but a followup is fine if it happens
before this dev cycle is over.
