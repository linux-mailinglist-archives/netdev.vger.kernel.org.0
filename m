Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F78299559
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 19:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789817AbgJZSbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 14:31:13 -0400
Received: from mail-il1-f180.google.com ([209.85.166.180]:37163 "EHLO
        mail-il1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1789788AbgJZSbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 14:31:13 -0400
Received: by mail-il1-f180.google.com with SMTP id y17so9300938ilg.4
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 11:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qAuXtCZ1nObeoquZ9U21V3Ue3Af7UFXHHz+eFFbVJPc=;
        b=Rjxp75qKMkIyI0jQNKmaKnT4tuCP5bQFYYx8eHgxQ8DLtVQmPqlSvD/UKuql5hIo4n
         gb1afoneyDYJhF15Z9Vk1GvxiYuLDjMHWk8ptpEyvYTEYS8Lyh2wSCJW7LSED1Oatq1e
         PI19Ln5yAAO2LAWj043+hGltU/O1TRp3rJdMr44yez9yCqoTUFAr1LooyadUMtoleWlT
         5Q1l5uQED7wexuLqxxSSnRGFdgnlJftdwfi0G+mK1D4loumyIYVbcyKkaOG535MZLMXI
         56Te8us3mebjRqO7V+rKb9xmIke78FYoSZDZvS4O/1r9XwglE/wl4q9Tk5TBwG1wSacO
         rd8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qAuXtCZ1nObeoquZ9U21V3Ue3Af7UFXHHz+eFFbVJPc=;
        b=pImMUeJHhXEQfmYzFC77/xctR08Qi8u6X96Bu4axoi8fS4l1JMlVUyY4Lp22Qs7w2m
         fKh+hGXNI+/mCixtkxlIpN2VAkqgBgWpVQ3/z5E3Y7MpOI0/3hTJGJP1itkHiuSVEOoo
         NI50O4C4F470NDLDOkgVSoeAO910WWDHyD1rLnCcan8hEbni6MLqvzuPcSmDjjKd1J3C
         kpS+noV7VJxlaE/vo/tnwAKxqw6eAo2kVvsfsRYVyJpT+ZihcN2s5F5Lk2M2S5Bh84Rl
         s3dnVqfaHg8yiw8QcwEtAHX2FR2Yw/UYki7wA8CqLFbmLv97Gen+yHGBjCLjP20J88VS
         eMwQ==
X-Gm-Message-State: AOAM530m5j9urS5FClk6XZ8o5WxQNyKzkasy8UPZBThlGb9Dcuiz/+fl
        8toLg6r7Pg0rCBIxVcijVSbLvbQD0sw=
X-Google-Smtp-Source: ABdhPJyeIQWIMpUEe6k7Ddo4BoPplx7tDLNQN5DMyjv0KHHOGC2518cOpmoTTTdu5mhO3IAL51qvAA==
X-Received: by 2002:a05:6e02:60c:: with SMTP id t12mr1508557ils.297.1603737071115;
        Mon, 26 Oct 2020 11:31:11 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:8943:dd42:1a04:cb54])
        by smtp.googlemail.com with ESMTPSA id w15sm4367258ilm.57.2020.10.26.11.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 11:31:10 -0700 (PDT)
Subject: Re: arping stuck with ENOBUFS in 4.19.150
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <9bede0ef7e66729034988f2d01681ca88a5c52d6.camel@infinera.com>
 <e09b367a58a0499f3bb0394596a9f87cc20eb5de.camel@infinera.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <777947a9-1a05-c51b-81fc-4338aca3af26@gmail.com>
Date:   Mon, 26 Oct 2020 12:31:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <e09b367a58a0499f3bb0394596a9f87cc20eb5de.camel@infinera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/20 6:58 AM, Joakim Tjernlund wrote:
> Ping  (maybe it should read "arping" instead :)
> 
>  Jocke
> 
> On Thu, 2020-10-22 at 17:19 +0200, Joakim Tjernlund wrote:
>> strace arping -q -c 1 -b -U  -I eth1 0.0.0.0
>> ...
>> sendto(3, "\0\1\10\0\6\4\0\1\0\6\234\v\6 \v\v\v\v\377\377\377\377\377\377\0\0\0\0", 28, 0, {sa_family=AF_PACKET, proto=0x806, if4, pkttype=PACKET_HOST, addr(6)={1, ffffffffffff},
>> 20) = -1 ENOBUFS (No buffer space available)
>> ....
>> and then arping loops.
>>
>> in 4.19.127 it was:
>> sendto(3, "\0\1\10\0\6\4\0\1\0\6\234\5\271\362\n\322\212E\377\377\377\377\377\377\0\0\0\0", 28, 0, {​sa_family=AF_PACKET, proto=0x806, if4, pkttype=PACKET_HOST, addr(6)={​1,
>> ffffffffffff}​, 20) = 28
>>
>> Seems like something has changed the IP behaviour between now and then ?
>> eth1 is UP but not RUNNING and has an IP address.
>>
>>  Jocke
> 

do a git bisect between the releases to find out which commit is causing
the change in behavior.
