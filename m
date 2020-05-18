Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4261F1D7B99
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 16:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgEROor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 10:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgEROor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 10:44:47 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711C1C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 07:44:47 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a14so4702805ilk.2
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 07:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mioqfSLROkwx+ObgGrCwfre0joazrl6J2Xsd1mlenG8=;
        b=gg5V8iONYBEEB+7EdIcrheqrgX/c4M4doAhQmDRqPJ8iStmGQtVGuTerWKapoFp16b
         8dn7PlCmdgO6iBXq8S6GAcEPqTCIqENsW4OU4ffHl6I0iVnGrZS4keTsJAw4mMxVpWLa
         DLextFtYMvGx+F0u4VCjStJ704NANlr07xmPjkX5uZkv8DsLkqFW+4iIzPsXPRQB8zvF
         z2l9Mk4Ij8XmROTUxIL2m5qe6ChiFrm31+W8rlqpUqLvXb8jUWxNSYRLtO7mMOFxdb8B
         /R17J3zOlvQ+bIX1fd2+jIkGjXDWSRMH99WcxruxbnMox9Xy9ySBLSSwtlFPg6TgkaHD
         A9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mioqfSLROkwx+ObgGrCwfre0joazrl6J2Xsd1mlenG8=;
        b=hwfig5YUpZtYu8+8TVM40Nz49UV0Rmbpwt9meF3MOXsN3qePmVgQnw3KX2TXVv7/fT
         u8WBHIX56AjtdCFTNRBq/EfZG/jlAGNCloXacrY1DJVVQvwizwYvCGjQTr8Yxb3rRNgJ
         aDpSqnvqJ01aSTkevtUCBkkgcaTt1cdIhPu/QeHyPENOaSctL+QF84i8ePGbTozs/iDx
         PcsLK8s/x1j80siMYF9IDgeR53g4WnGIIyZ3bjeUVQpRBBIwE4kcbhiP++MTBGj/xdUs
         TXx44b61+Vx/UE6C7Zkaerusd461g0+4oNSck1joCbs5DCj7rhh+UzkYZAkqVnl0VZbZ
         xjjg==
X-Gm-Message-State: AOAM531a+0Wl/yfPqFZIdLE/miVaUFnK4D88md6od6R9o4dfgTEGUot6
        iq244GGAv4IFv26/OjJHf90=
X-Google-Smtp-Source: ABdhPJwrGaDB64aceT7VB+oV0MoDTMDjHQSihDyI4wGPbPHIWhYHLn6MqdqVEZ0GWBk2t8amvsMIUA==
X-Received: by 2002:a92:5cc1:: with SMTP id d62mr6843103ilg.95.1589813086795;
        Mon, 18 May 2020 07:44:46 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:40b2:61fc:4e6d:6e7b? ([2601:282:803:7700:40b2:61fc:4e6d:6e7b])
        by smtp.googlemail.com with ESMTPSA id v70sm4901995ilk.84.2020.05.18.07.44.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 07:44:46 -0700 (PDT)
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <87lflppq38.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com>
Date:   Mon, 18 May 2020 08:44:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87lflppq38.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 3:08 AM, Toke Høiland-Jørgensen wrote:
> I can see your point that fixing up the whole skb after the program has
> run is not a good idea. But to me that just indicates that the hook is
> in the wrong place: that it really should be in the driver, executed at
> a point where the skb data structure is no longer necessary (similar to
> how the ingress hook is before the skb is generated).

Have you created a cls_bpf program to modify skbs? Have you looked at
the helpers, the restrictions and the tight management of skb changes?
Have you followed the skb from create to device handoff through the
drivers? Have you looked at the history of encapsulations, gso handling,
offloads, ...? I have and it drove home that the skb path and xdp paths
are radically different. XDP is meant to be light and fast, and trying
to cram an skb down the xdp path is a dead end.

> 
> Otherwise, what you're proposing is not an egress hook, but rather a
> 'post-REDIRECT hook', which is strictly less powerful. This may or may
> not be useful in its own right, but let's not pretend it's a full egress
> hook. Personally I feel that the egress hook is what we should be going
> for, not this partial thing.

You are hand waving. Be specific, with details.

Less powerful how? There are only so many operations you can do to a
packet. What do you want to do and what can't be done with this proposed
change? Why must it be done as XDP vs proper synergy between the 2 paths.
