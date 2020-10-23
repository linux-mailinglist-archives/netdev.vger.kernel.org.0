Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95891296C27
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 11:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461532AbgJWJdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 05:33:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S461523AbgJWJdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 05:33:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603445598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhjktOBoRTQaSYJPiSgNw60+MzGJGvfEgx56IsafvOg=;
        b=gZhw/q0ZC/Wkt/7MpUoTB9P+Vm3DhGSHRSS0Uy1nXDtcSFm0LM1BSvZbLvtJKNUYhYkmfP
        mKAUYNl8mLUVz1Zby8tVyDjwvm54un9A8Bdy5BysREnRya36bi2N/jV8Dn1o+VHp2Mz7wz
        X3ogQYweIwW4ilGyk8wIvO+STnLs/64=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-nQyyDPGvNzOP6fG0QUnz3A-1; Fri, 23 Oct 2020 05:33:15 -0400
X-MC-Unique: nQyyDPGvNzOP6fG0QUnz3A-1
Received: by mail-wr1-f72.google.com with SMTP id v5so390312wrr.0
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 02:33:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dhjktOBoRTQaSYJPiSgNw60+MzGJGvfEgx56IsafvOg=;
        b=SLf5BHRdb9BBFjlLMKCLVyHcAO0/OI8FOdNQM0csToMOBMp28bisJVTEGobxUtgqee
         HsuL6EguaVZvAqOo6Xs1kqAv1HOm+zTxPABMNTGot4LJmMCMYyGMM/37vyqaKq0XOFn9
         KVxPbVoHD+PIyXwttLEA4Ka0ovWwyi3N3ZIdoZOvlZLnWb9H3tVMM/0inKoZ2uaUBXDi
         2r9t5qn7WWoZsurJdVUEfhmLH/1AelAwGyfrp6R7p4dV1VHxy9bHHqgl3NcVJF38+xq6
         x4eGdHi8hD6j+IbaL1+rF2DC779kZrEJ6r729+HR6qzsJnaSwHkpOdKbxHqb789Tw/yJ
         ueQw==
X-Gm-Message-State: AOAM533DOBckQw1gAi1+Jei/m5l3xHDYsWc/vqVGgtSWrH8padaIZC7J
        ee+BkMWO8Rq2c7f3fBk1d6llt/wiFD1H+RudFLKy2/CEL05Sl1jD4ik0RKTG5QL/hloNdZn/pbV
        Gw7fBH3xQYEDM4x2F
X-Received: by 2002:a1c:4306:: with SMTP id q6mr1448475wma.189.1603445591336;
        Fri, 23 Oct 2020 02:33:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw03dE4BvokvwSb4DY1v456I8rv/1zCQjMQg386djUX5vLasV/K1FS7SwEMTZT11Lnp0+2jXQ==
X-Received: by 2002:a1c:4306:: with SMTP id q6mr1448442wma.189.1603445591095;
        Fri, 23 Oct 2020 02:33:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q8sm2147629wro.32.2020.10.23.02.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 02:33:10 -0700 (PDT)
To:     Peter Zijlstra <peterz@infradead.org>,
        Josh Don <joshdon@google.com>,
        g@hirez.programming.kicks-ass.net
Cc:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Xi Wang <xii@google.com>
References: <20201023032944.399861-1-joshdon@google.com>
 <20201023071905.GL2611@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] sched: better handling for busy polling loops
Message-ID: <ef03ceac-e7dc-f17a-8d4d-28adf90f6ded@redhat.com>
Date:   Fri, 23 Oct 2020 11:33:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201023071905.GL2611@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/10/20 09:19, Peter Zijlstra wrote:
>> +	/*
>> +	 * preemption needs to be kept disabled between prepare_to_busy_poll()
>> +	 * and end_busy_poll().
>> +	 */
>> +	BUG_ON(preemptible());
>> +	if (allow_resched)
>> +		preempt_enable();
>> +	else
>> +		preempt_enable_no_resched();
> NAK on @allow_resched
> 

Since KVM is the one passing false, indeed I see no reason for the
argument; you can just use preempt_enable().  There is no impact for
example on the tracking of how much time was spent polling; that
ktime_get() for the end of the polling period is done before calling
end_busy_poll().

Paolo

