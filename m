Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A60128061
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfLTQKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:10:13 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:45680 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfLTQKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 11:10:13 -0500
Received: by mail-wr1-f51.google.com with SMTP id j42so9895152wrj.12
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 08:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QTZi05rzW14Ao5Fr+u3n6JLp4q3ZdJkLJ5mbCXa/Qy8=;
        b=PTY9AZqH/Uz8/xIzNmNhm7ckakbtxpPn/xuHbIL3EF5U5rS9Y1MxGpfAYu1QMsbjwc
         9tPf8XzFKEh2x8QpQ/JgfSkENU6jR2Anf/cHnhBzhpjsOYOLXRegtpSMC1SwJpEPfTHC
         TtlDmN5od23WbJSl1arfE2Lx9pVVTy85rnOgPaRXojttqvqsEY7ldLnpp6bdHX2jcd/e
         46aYRjJJKnaEgyfiWzEJjw9aq6L55518sGK862AGnKnKcfKtQ+gYTr9njzmHHoCFpduu
         Mvpk477VYDqu9VRGHEEDaJEpZT0MEtRde+EkCwFVOtnxhoMecd7R7rMEUgRtKX0cNBwf
         D7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QTZi05rzW14Ao5Fr+u3n6JLp4q3ZdJkLJ5mbCXa/Qy8=;
        b=jYN8338XcbvVRZLRO77jjVpxkkA2rJr3egTC7BjyGqQNuMH1G4x0WMFEmKBawXkOI4
         XCS6PonQ0vdXOckOwvPWLlWeG67g62e2M8gAAY2+BPg91s925S4Rf0Xe5JF8iP8cmrE/
         DdGLf/NI3rtuyHWy44oFQCE9bRPOiHZfGO0IBi2HYFTTHWO/5nqRjgX0aPrmMNCcDYiD
         7CUVNJTXysy8kyVcdiZJ4Flsn8mYvGypr15KEuDywdzdp9288H02/rIBQ72SYfI+Opd3
         Fwvbws2XgLQ6/z383i0bxs0IuXgnPMiTBJdvIk9RVzupryQl4j6LCpKEHLCrJgguBuSx
         UEZw==
X-Gm-Message-State: APjAAAVgIGKO8a8wLZmdO3zw2M7GFTLx6UWcO0/Z8SdQu3Mh1DCwP0Vv
        1AtEdVtY/2Num/KLz/Rk3cw=
X-Google-Smtp-Source: APXvYqy51EgzNkJ0qUWu6EU9EPeUdd8A2866DU+gX8cBeirg/FekZaFbJABceusEMX+8H4U1YsimCQ==
X-Received: by 2002:a5d:65c5:: with SMTP id e5mr15992575wrw.311.1576858212017;
        Fri, 20 Dec 2019 08:10:12 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id s10sm10122640wrw.12.2019.12.20.08.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 08:10:11 -0800 (PST)
Subject: Re: [PATCH net-next v2 00/15] Multipath TCP part 2: Single subflow
To:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
References: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
 <20191218.124244.864160487872326152.davem@davemloft.net>
 <1eb6643d-c0c1-1331-4a32-720240d4fd25@gmail.com>
 <581ec29dccd8d499d7cb2041218c1fcca90da29a.camel@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6df29572-e59d-a8c3-5364-b4568af3115e@gmail.com>
Date:   Fri, 20 Dec 2019 08:10:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <581ec29dccd8d499d7cb2041218c1fcca90da29a.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/20/19 7:51 AM, Paolo Abeni wrote:
> 
> I understand you prefer we will have the next iteration in the new
> year, am I correct?

Yes please, I wont be able to participate in discussions until January 2nd.

Thanks.
