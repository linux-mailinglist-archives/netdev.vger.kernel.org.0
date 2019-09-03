Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFAB0A70BE
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 18:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbfICQm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 12:42:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40605 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICQm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 12:42:29 -0400
Received: by mail-wm1-f65.google.com with SMTP id t9so208618wmi.5
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 09:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ylZs7DGz6wpCCyGME6HbynOFCxReGxvj5XhEN84pHoM=;
        b=pUGypGucWx4oyiuFrl6lLsgWRNnmS9lExOIY6U74FwIOJ4dlBZWA5+PMleOaHsmV/T
         kCAv3fioOfwf2ARMU3oEDGT0QpHQjZvkMPt4Zf6d5g4gDY/2IfOW8hSvn6Q6Nf1Pz712
         JnrxdUVWPmijha6FVqHoMzder/jpjwXTKjLx7fxFVjFuugJgD3C3Vts1TogWIB0y0DZQ
         +IwrE1n8tbjUx1zUOW8XZ32FIFhvcS1Pcm1jU8mvBHqAwtsObTynEWuOzW3gE7g0s7I+
         0aYLnwVHqFVwUKBOusSJc4k/p0ReeQrw+UW1brvgBhv9FiOL4j4dgE0VC86HLwWQBZ/2
         NL0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ylZs7DGz6wpCCyGME6HbynOFCxReGxvj5XhEN84pHoM=;
        b=pnKPTxwx4ovPGjNWoLpeUbYdH+zSLX2cSIuVJsihAv8YK7viLrz2xEONTzLcoBIBaG
         fjRvuXsdzrjYx0ihXi1pEEDOBA9fDP6FGS4TlvB4GqsArkLuaR9bGzCc3h6zdnE7f4tL
         0N1UhrtOrDk9N+Qrg67N8mPg/y0pwoDZrCCSRphEpnaibzC8c/nWLwQqrVIxaPCqQ2OA
         f4ZzgwApBvN9cRcGAqQjh6M6qxmNNIAqepoQ9o65xyFjXqCSaaUYOgR3RxZM3+AkVrZz
         PgEryzb2Bioz1Vel/huZBEM3dsWfu5TwpSV5cX8+TcVA725PakdBZlzEoiQY7wqnVPCK
         Goqg==
X-Gm-Message-State: APjAAAXs3Ci6Gclg9Yj/oepvn5jb/VWFIrJeSNt89HqZXIPfzGlDl0MW
        ArD9s/vCK2ErjYJ7f3JKHLapCJsg
X-Google-Smtp-Source: APXvYqzotxQSfmOnbsgHHQ+gyTNQXYXrESn1ZjN6WOezhqmQ4/IqlrUs7JiVgGceyuxKhplEdcIFNg==
X-Received: by 2002:a1c:984b:: with SMTP id a72mr202995wme.149.1567528948074;
        Tue, 03 Sep 2019 09:42:28 -0700 (PDT)
Received: from [192.168.8.147] (83.173.185.81.rev.sfr.net. [81.185.173.83])
        by smtp.gmail.com with ESMTPSA id l62sm156714wml.13.2019.09.03.09.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 09:42:27 -0700 (PDT)
Subject: Re: [PATCH] Clock-independent TCP ISN generation
To:     Cyrus Sh <sirus.shahini@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net
Cc:     shiraz.saleem@intel.com, jgg@ziepe.ca, arnd@arndb.de,
        netdev@vger.kernel.org, sirus@cs.utah.edu
References: <70c41960-6d14-3943-31ca-75598ad3d2d7@gmail.com>
 <fa0aadb3-9ada-fb08-6f32-450f5ac3a3e1@gmail.com>
 <bf10fbfb-a83f-a8d8-fefc-2a2fd1633ef8@gmail.com>
 <2cbd5a8f-f120-a7df-83a3-923f33ca0a10@gmail.com>
 <e3bf138f-672e-cefa-5fe5-ea25af8d3d61@gmail.com>
 <492bb69e-0722-f6fc-077a-2348edf081d8@gmail.com>
 <e02c0aac-05c5-e0a4-9ae1-57685a0c3160@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3fc44b3a-3ac0-d008-272a-e7acb98ad761@gmail.com>
Date:   Tue, 3 Sep 2019 18:42:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e02c0aac-05c5-e0a4-9ae1-57685a0c3160@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/19 6:27 PM, Cyrus Sh wrote:
> 
> 
> On 9/3/19 10:17 AM, Eric Dumazet wrote:
> 
>> Do you have a real program showing us how this clock skew can be used practically ?
> This is a well studied issue. You can take a look at this presentation as an
> example:
> http://caia.swin.edu.au/talks/CAIA-TALK-080728A.pdf

2008 ? Really ?

I do not want an example, I want a proof that current systems are
exhibiting all the needed behavior.

I do not have time to spend hours reading old stuff based
on old architectures.

> 
>> You will have to convince people at IETF and get a proper RFC 
> No I won't. A lot of these standards have been written at a time that anonymity
> networks were not of big importance. Now that they are, we try to lessen the
> negative impacts of some RFC deficiencies by improving the implementation. It's
> up to you whether to want to keep using a problematic code that may endanger
> users or want to do something about it since we won't insist on having a patch
> accepted.
> 

Then this is the end. linux wont change something as fundamental without
proper feedback from the community.

