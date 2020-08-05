Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A637A23C2CB
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 02:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgHEA5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 20:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgHEA5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 20:57:04 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB472C06174A;
        Tue,  4 Aug 2020 17:57:03 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t10so18990627plz.10;
        Tue, 04 Aug 2020 17:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=bhDRRuMUZJmJyL9zgp5AqACLBinGyiK0gmH069V3fXU=;
        b=pQGsJj0QBRUtZXR934yZQe4v797BzeR27Xph29lGnBvOmrDivJZuQAqcoRdCYYvJRF
         G/yT40nA214wAdFUjG6sHHJF2vk3Rx/d38RIjnfvue/5P0bDnH1ru5kwoNcofzOIN2QD
         aWF+hkHVX04ouEjcCtQjF0d3PMnAByCdz9M/KATB9jzI+XbRBySGLmYD0HkiiHhf6fzD
         2ls4IhuQPD3jVYO+RXMihhDf+KUxw1cmUKnT66DiwOqYT9kFjneQvsLdwQKc+P5uIWa8
         lQMxd4rvqK9/BVZCD8pci3chwOL3lYgJPf1N4G5RvyDCVlTM04oEEGJ8Ta3HyUhVAgbC
         WJDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bhDRRuMUZJmJyL9zgp5AqACLBinGyiK0gmH069V3fXU=;
        b=Q2smAaR3DRrsk6QuLaHpU5B1uzjrw8fvHQW/Qi8lcvDsuSeXuqJjCWqXkZWL5A8b1V
         qoxDnzGbsyHL3VD++RSljOcU13qumTkVHBAXdxK6Lrv2iFxaf3fGz7jacmJ/r+DbLDX3
         wNY9KxnyNrZRUHANCzN1wZzBdnSffIxjr6mql3XZOB2vlVlXSvy8dGr2UqztTG+kIQc/
         bhwEMNQd5VCVp7iSBfQmsIFBIgNLXFCBaw/ezcLSW/Ed/yDVTM7tT1tUE7QwiAHBTxS+
         jnjeErH7lwROtY/HSc5jYeZotBhVPtVUEMst2FVFs9mVrmZibnOWz87gm/MhsVoO3sUL
         siSA==
X-Gm-Message-State: AOAM532G+dggqxXnyaQ5YXYkG00ALWBdKVmAb7Yu8WgkfTqMEMCNwguo
        XfKwR8gK+JReNMHzmCiQZlpEBpE0DQStYr/l
X-Google-Smtp-Source: ABdhPJwMa7WaJKDrMeRZnTwKdcVaF7UYxUC74UQ8uqEjzx+bZ+x3SasOmdPW5ut7T3UGSZovF0c2hA==
X-Received: by 2002:a17:90a:fb50:: with SMTP id iq16mr767772pjb.177.1596589022467;
        Tue, 04 Aug 2020 17:57:02 -0700 (PDT)
Received: from ?IPv6:2001:569:7bc3:ce00:5952:a8fa:9027:e42f? (node-1w7jr9qsv51t9ys73lhzuy4a7.ipv6.telus.net. [2001:569:7bc3:ce00:5952:a8fa:9027:e42f])
        by smtp.gmail.com with ESMTPSA id v16sm506214pgn.90.2020.08.04.17.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 17:57:01 -0700 (PDT)
Subject: Flaw in "random32: update the net random state on interrupt and
 activity"
From:   Marc Plumb <lkml.mplumb@gmail.com>
To:     tytso@mit.edu, w@1wt.eu
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
Message-ID: <aef70b42-763f-0697-f12e-1b8b1be13b07@gmail.com>
Date:   Tue, 4 Aug 2020 17:57:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willy and Ted,

This commit has serious security flaws 
f227e3ec3b5cad859ad15666874405e8c1bbc1d4


TL;DR This change takes the seed data from get_random_bytes and 
broadcasts it to the network, thereby destroying the security of 
dev/random. This change needs to be reverted and redesigned.


It is inefficient:

This function is called from an interrupt context, so there is no chance 
of a CPU switch, therefore the this_cpu_add function should be 
__this_cpu_add. This is a sign that the patch may have been rushed and 
may not be suitable for a stable release.


It is fixing the wrong problem:

The net_rand_state PRNG is a weak PRNG for the purpose of avoiding 
collisions, not to be unguessable to an attacker. The network PRNG does 
not need secure seeding. If you need a secure PRNG then you shouldn't be 
using the net_rand_state PRNG. Please reconsider why you think that this 
change is necessary.

It dramatically weakens dev/random:

Seeding two PRNGs with the same entropy causes two problems. The minor 
one is that you're double counting entropy. The major one is that anyone 
who can determine the state of one PRNG can determine the state of the 
other.

The net_rand_state PRNG is effectively a 113 bit LFSR, so anyone who can 
see any 113 bits of output can determine the complete internal state.

The output of the net_rand_state PRNG is used to determine how data is 
sent to the network, so the output is effectively broadcast to anyone 
watching network traffic. Therefore anyone watching the network traffic 
can determine the seed data being fed to the net_rand_state PRNG. Since 
this is the same seed data being fed to get_random_bytes, it allows an 
attacker to determine the state and there output of /dev/random. I 
sincerely hope that this was not the intended goal. :)

Thank you
Marc
