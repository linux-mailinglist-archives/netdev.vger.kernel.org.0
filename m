Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EFA2524CC
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 02:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgHZApc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 20:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbgHZApc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 20:45:32 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFC6C061574;
        Tue, 25 Aug 2020 17:45:32 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id x24so181108otp.3;
        Tue, 25 Aug 2020 17:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3/FdbAJD7BVKy5XahgLzv+uucXfdZpA+XZQ5pa4d864=;
        b=bBeuV+csDJ4A2tR0keDdrTv9hablIvV5K9WJotu/UnH1q5gAqaCi6IZFp4qas/XxHZ
         5vPlX2EJM8/qDjp9NPefU0YtNF1DWg2otIGdxsSN3QelAcPbI4/hgIIjNU6zId6re5J7
         Dra0ggk+Lmu0g3f255OB6svP8Dtqn6Zag34TCp0pxBZJxR9I5sdMYMIJP05VvNnXVGTK
         5Kxg2Lbkj51Fj4oeQTgCTzz+ZQOtwCMPEW7XSr0FA7bDogM4TedOGdap/bm8UCqRemzX
         utkBbBLCxYtKKNDEkTz8zx93MnKz4FG38aOb1odUkVmzfU/5mnRBG4wjhfLkvylE02PD
         Viow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3/FdbAJD7BVKy5XahgLzv+uucXfdZpA+XZQ5pa4d864=;
        b=VbuWkGu+8JidRAf/3NaXccSEN6xD7ZrqnpNMTFlgiPAxYJ3ok/ylKN1HfiIKD37TmQ
         TDvGkB0Pzgz8eFCJ8EDs+fH4zimX39SmoTIskaYuLG5sfGKGYFBtB8crYNt6VOpRT8rz
         hpjk94JLis3jPGrTuXmjJ3HwAf1lkV0aEeQ+xnobLtKDGSfOvD4Fy9Q6RyZ4XtnZrD/X
         6L3ooVi1P5UX7D+4SpYquCPnvTZa5U6vlViwCdg5/pMWPImFvlniPWliH3dVhnA0YOmK
         +aISl6B+vdnet9c0HybIdlXthaHoRK98fxgHBHw8p6+CdOB0/ijT+oeHmvn2WBiV/DUL
         TdNQ==
X-Gm-Message-State: AOAM532PUf0+vgspHo+5sAouElQPntCMZgDMKMsEthIhbhgc74uJ+lQ7
        EoPXGteW1iB+F8KTbFjLoG0=
X-Google-Smtp-Source: ABdhPJwpQ4MR/gBTilv7N6/jG0RY+5DGluTWhReFvF70UYOf+9YnGR4r+gKt7J+zT9fcWLDPOAyG7g==
X-Received: by 2002:a9d:b82:: with SMTP id 2mr8289582oth.202.1598402731384;
        Tue, 25 Aug 2020 17:45:31 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:a5be:ea41:732d:f3d6])
        by smtp.googlemail.com with ESMTPSA id e7sm131281otj.28.2020.08.25.17.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 17:45:30 -0700 (PDT)
Subject: Re: [net-next v5 1/2] seg6: inherit DSCP of inner IPv4 packets
To:     Ahmed Abdelsalam <ahabdels@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     andrea.mayer@uniroma2.it
References: <20200825160236.1123-1-ahabdels@gmail.com>
 <efaf3273-e147-c27e-d5b8-241930335b82@gmail.com>
 <75f7be67-2362-e931-6793-1ce12c69b4ea@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <71351d27-0719-6ed9-f5c6-4aee20547c58@gmail.com>
Date:   Tue, 25 Aug 2020 18:45:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <75f7be67-2362-e931-6793-1ce12c69b4ea@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/20 5:45 PM, Ahmed Abdelsalam wrote:
> 
> Hi David
> 
> The seg6 encap is implemented through the seg6_lwt rather than
> seg6_local_lwt.

ok. I don't know the seg6 code; just taking a guess from a quick look.

> We can add a flag(SEG6_IPTUNNEL_DSCP) in seg6_iptunnel.h if we do not
> want to go the sysctl direction.

sysctl is just a big hammer with side effects.

It struck me that the DSCP propagation is very similar to the TTL
propagation with MPLS which is per route entry (MPLS_IPTUNNEL_TTL and
stored as ttl_propagate in mpls_iptunnel_encap). Hence the question of
whether SR could make this a per route attribute. Consistency across
implementations is best.

> Perhaps this would require various changes to seg6 infrastructure
> including seg6_iptunnel_policy, seg6_build_state, fill_encap,
> get_encap_size, etc.
> 
> We have proposed a patch before to support optional parameters for SRv6
> behaviors [1].
> Unfortunately, this patch was rejected.
> 

not sure I follow why the patch was rejected. Does it change behavior of
existing code?

I would expect that new attributes can be added without affecting
handling of current ones. Looking at seg6_iptunnel.c the new attribute
would be ignored on older kernels but should be fine on new ones and
forward.

###

Since seg6 does not have strict attribute checking the only way to find
out if it is supported is to send down the config and then read it back.
If the attribute is missing, the kernel does not support. Ugly, but one
way to determine support. The next time an attribute is added to seg6
code, strict checking should be enabled so that going forward as new
attributes are added older kernels with strict checking would reject it.
