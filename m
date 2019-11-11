Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDFE6F6FF3
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 09:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKKIzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 03:55:02 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35249 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfKKIzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 03:55:02 -0500
Received: by mail-lf1-f68.google.com with SMTP id y6so9216634lfj.2
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 00:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=KG554UB1ORd5BSnPyJC3hx3P5Fy8n9UoGQr/WopwYhw=;
        b=RWFTY/GmE3egVq2pj+6t/3Uo2UVyvdrxIrZSaAHkOy7tzeVUGbrNPIkkxuIfXiTjkw
         cAA6wai3LhmYL2Xmzxjy6+5L6GpZHd8ocAzFCO2wv0nBA2AwGH1MmarHMFzGthPxGFlO
         +oPzyVwtvN1MxORG4zuKONxuplLyKBa5oVgLAqVAFCB2gPY9HdLWF9v33EfFSc5VUDuh
         7lf07F/pevfpjgvZbF8iv+8Sk67AeFjI53pIup+Amar0aRyABuIa0QdYBlmc+3LuaMet
         oMX2s12znPU8Ys+WOcsQn4xTPYowhkM4lVXDce9lmuo7ooIQlaNwX1VlMef+KNkqby7P
         q6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=KG554UB1ORd5BSnPyJC3hx3P5Fy8n9UoGQr/WopwYhw=;
        b=AB1KEmUI2+CIDXEcrDBq7lstbNH8biS1JiOtfoihh9N6pmDzGy2ncQkxIOZAwh3rDy
         /sE0lfGYHZv1wMgeW7RvVvYB9CWxAKMm56PUOX92dGtRZGFD+srFyC4lm9P0p+SIeNMJ
         AfkkL1Yi2jbRK7jEEN7qB0zcjBw2Ow/qTJm8Vsefa9RadZ63BouL4K9gAziwNqq3TRi5
         MpN/qfMCdkSmJiL3mCpLMajCLC0CIsMVUGCv0eGPImaKqUb2f0CnSNkpxE8pHisw3b31
         qLLmmUeUPILVbLDElCijQiocOIOZHyIqk1eqWbTgrf9c/lcVTEiAfSzjGg2cTDsxeZ/l
         8Qiw==
X-Gm-Message-State: APjAAAWdwf7a+UpYxgXafjCasA8HmxKuThVN9x6vCsHk75loqXyU9ffH
        IbkkJt3qhM52QIiks7PhEXMq3w==
X-Google-Smtp-Source: APXvYqwzd9rbmzLlM918vPzJl2Y+6mHnBAs+b8zL1e3+XqdvrLgiKth8gwDxh0rw5IZ0xEuUfc0DgQ==
X-Received: by 2002:a19:6d12:: with SMTP id i18mr14821473lfc.153.1573462499663;
        Mon, 11 Nov 2019 00:54:59 -0800 (PST)
Received: from localhost.localdomain (c-413e70d5.07-21-73746f28.bbcust.telenor.se. [213.112.62.65])
        by smtp.gmail.com with ESMTPSA id f25sm6345000lfm.26.2019.11.11.00.54.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 00:54:59 -0800 (PST)
Date:   Mon, 11 Nov 2019 08:59:25 +0100
From:   Anders Roxell <anders.roxell@linaro.org>
To:     paulmck@kernel.org, joel@joelfernandes.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: next-20191108: qemu arm64: WARNING: suspicious RCU usage
Message-ID: <20191111075925.GB25277@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm seeing the following warning when I'm booting an arm64 allmodconfig
kernel [1] on linux-next tag next-20191108, is this anything you've seen
before ?


The code seems to have introduced that is f0ad0860d01e ("ipv4: ipmr:
support multiple tables") in 2010 and the warning was added reacently
28875945ba98 ("rcu: Add support for consolidated-RCU reader checking").


[   32.496021][    T1] =============================
[   32.497616][    T1] WARNING: suspicious RCU usage
[   32.499614][    T1] 5.4.0-rc6-next-20191108-00003-gf74bac957b5c-dirty #2 Not tainted
[   32.502018][    T1] -----------------------------
[   32.503976][    T1] net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!
[   32.506746][    T1] 
[   32.506746][    T1] other info that might help us debug this:
[   32.506746][    T1] 
[   32.509794][    T1] 
[   32.509794][    T1] rcu_scheduler_active = 2, debug_locks = 1
[   32.512661][    T1] 1 lock held by swapper/0/1:
[   32.514169][    T1]  #0: ffffa000150dd678 (pernet_ops_rwsem){+.+.}, at: register_pernet_subsys+0x24/0x50
[   32.517621][    T1] 
[   32.517621][    T1] stack backtrace:
[   32.519930][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.0-rc6-next-20191108-00003-gf74bac957b5c-dirty #2
[   32.523063][    T1] Hardware name: linux,dummy-virt (DT)
[   32.524787][    T1] Call trace:
[   32.525946][    T1]  dump_backtrace+0x0/0x2d0
[   32.527433][    T1]  show_stack+0x20/0x30
[   32.528811][    T1]  dump_stack+0x204/0x2ac
[   32.530258][    T1]  lockdep_rcu_suspicious+0xf4/0x108
[   32.531993][    T1]  ipmr_get_table+0xc8/0x170
[   32.533496][    T1]  ipmr_new_table+0x48/0xa0
[   32.535002][    T1]  ipmr_net_init+0xe8/0x258
[   32.536465][    T1]  ops_init+0x280/0x2d8
[   32.537876][    T1]  register_pernet_operations+0x210/0x420
[   32.539707][    T1]  register_pernet_subsys+0x30/0x50
[   32.541372][    T1]  ip_mr_init+0x54/0x180
[   32.542785][    T1]  inet_init+0x25c/0x3e8
[   32.544186][    T1]  do_one_initcall+0x4c0/0xad8
[   32.545757][    T1]  kernel_init_freeable+0x3e0/0x500
[   32.547443][    T1]  kernel_init+0x14/0x1f0
[   32.548875][    T1]  ret_from_fork+0x10/0x18


Cheers,
Anders
[1] http://people.linaro.org/~anders.roxell/kernel_config-next-20191108.config
