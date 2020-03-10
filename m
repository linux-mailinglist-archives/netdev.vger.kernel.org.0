Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D10C117EDDF
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgCJBO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:14:58 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33499 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgCJBO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:14:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay11so4738001plb.0
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 18:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZaCk6N3xQA9PZTrhH6nKX2kGQLQ6zSc6IoJkaIhvpKo=;
        b=tEdEJcHCEbSGfauPYKP0w+sg+i1WZzQSzJhQxYnF8Er6yQKhffLQUmRQ9A1z/pBzCT
         fNKGb79e1+JQKXRm1ypAGVHM17gvo7eZ71LlCFfXX3JVtAk/1wkC9S1FILZFyUFgFSs+
         HhaSeNKjLqrhzqvoxTFnXwByF1q17GGSv/mfcFfbLB084hfKQxjx/tTptq8OtLmy4hm4
         wJjj3JKN1aXNtchQyP6kz5DtbstPYpIpbfGX/f0sCNXolIcKG4NYYDrvqAPZpqbJsF/1
         vR5BG2GZJTJ6HGH/iPvQ31qcnZud6sI2bKuLFq35seK4zHlJisIUKV5im9duGMYC44eR
         zNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZaCk6N3xQA9PZTrhH6nKX2kGQLQ6zSc6IoJkaIhvpKo=;
        b=Pjy/pZrlDQamNbhFrCTaUCgyzPb3pJmk/sVXe2pzPRwBHFzviM1zuFZNHmdXzXnj4P
         oZEzuHnzwl1OYfqPiFw90IavNF0phKkSziolfPsv902fnn+8BsK3hUU/A2HBBYa/2jmP
         +1qsP3AmGdPrM0TdZNyZcVxMF9EIwtxQq4hAhY8Nu1acCTw8wUQjubGtx/S5ue11hO6H
         dVQxLofA3m9xORZrSvY1ThQ+Zj6knJDE/fQdT0pB/hieeGVRebrsIl2A26NwzYWGd73h
         +BJlLcYiD9qKkg/Y1/gXR8CQF4+obD+IETd+tGf7Lxwg8xv0ailyLt4eiLzv5/j/1Ovx
         DmKQ==
X-Gm-Message-State: ANhLgQ01SLwaI7mIPP5sgcbCeezvLb1DcOpopDeaKob7T7mxSmUyzL3Z
        0IuWuV5jaF+WgkOtWN6LKD8=
X-Google-Smtp-Source: ADFU+vvmL+cQUd2NGmUaUoGimdOJ+pbgEhuaLzzil7qwKkBfJsIKRPQRQ0p450Zf0Z41gvDzOr50Fg==
X-Received: by 2002:a17:902:2e:: with SMTP id 43mr18875555pla.326.1583802896190;
        Mon, 09 Mar 2020 18:14:56 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u14sm27515034pgg.67.2020.03.09.18.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 18:14:55 -0700 (PDT)
Subject: Re: [PATCH net] ipvlan: add cond_resched_rcu() while processing
 muticast backlog
To:     David Miller <davem@davemloft.net>, maheshb@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, mahesh@bandewar.net,
        syzkaller@googlegroups.com
References: <20200309225702.63695-1-maheshb@google.com>
 <20200309.180153.196067393732510885.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4f27d898-b054-a276-3ede-66d682fdff38@gmail.com>
Date:   Mon, 9 Mar 2020 18:14:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200309.180153.196067393732510885.davem@davemloft.net>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/20 6:01 PM, David Miller wrote:
> From: Mahesh Bandewar <maheshb@google.com>
> Date: Mon,  9 Mar 2020 15:57:02 -0700
> 
>> If there are substantial number of slaves created as simulated by
>> Syzbot, the backlog processing could take much longer and result
>> into the issue found in the Syzbot report.
>>
>> INFO: rcu_sched detected stalls on CPUs/tasks:
>>         (detected by 1, t=10502 jiffies, g=5049, c=5048, q=752)
>  ...
>>
>> Fixes: ba35f8588f47 (“ipvlan: Defer multicast / broadcast processing to a work-queue”)
>> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
>> Reported-by: syzbot <syzkaller@googlegroups.com>
> 
> Applied and queued up for -stable.


Ok, I will submit a fix on top of it then ;)

Thanks.

