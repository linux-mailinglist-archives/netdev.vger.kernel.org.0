Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28657253C9
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 17:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbfEUPVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 11:21:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33098 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbfEUPVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 11:21:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id d9so6133347wrx.0
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 08:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eACrsUBROPuC8VwDn/1aL2QjTnVuQXoWcioI/Ms6bUA=;
        b=eAh1N5RKUQPLqUanzZDlsmb4LvpP2WjYQGT+fqJcsud4Ft/S0CBuY8H1EG9d3u0l8B
         UFE8vdDG2ITUNqQIKrk4qIS7TYG9mY/qHM0RXIUlLs8p4pV2mB0f1vNSK6Ywtk28Aw+h
         Qto9qbWKmJAT1i5AcGos7IRI8BruJTmkOzbe7GuWtE/Bd4dj7m2GpnQOut5bQjK6FUci
         HJASwH0JH6VTsL/MXuFwwhdZuvmEPPXaaOLlf21H7UOQTvlxnykM9I+8iJPocSLfGrtD
         AZZx0zaEig0BEcoFqgdpHNOD8Mq8ipjyrwkqXz04S1038WDXq5iBGGVVccXMts3XvCvB
         6w4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eACrsUBROPuC8VwDn/1aL2QjTnVuQXoWcioI/Ms6bUA=;
        b=NvNyJTdklp2zpHUzjF7TGkzk6DwPnEI6fnSciFex3Ubc1QDSDiIFFIxdSPXV2E2zKn
         GpzEeVgd46+ICBCo0hHHPhq05zS6TjtLwgQq6Y32yXBRvCfsLbxwU4/Mu0cbZIldXhYO
         +OwZhDpgAi9p+w2N+IYdgVGmy6NT6NxN7R43X7MPYN/4D0OJ3dWd4nEnMaqzApR5xaxj
         pR6qRxNWvLdV1DCMSMgr0ZY4etf1+hQlO0Ai6yhxiM8sgjXuI+0HMIx0YD+D8ytrA0dK
         F3kh5Mjbf1Tp72lzv1isDmbsO7KmGo6VOBw1uKJXxIb08eoK5Vw9jH4cfwnvXsFV4T4i
         sHag==
X-Gm-Message-State: APjAAAVMK82/dJXxDicrcslDWWt+Z4j/P6MN8m4E45HXM037JIdHfkFv
        +LpbQVeUHObdLYLNk23nQDchfA==
X-Google-Smtp-Source: APXvYqylHW7972z3u1Yor1R2rG+g+fD++XeK59HKf445zx78l8hN2qABYSUZCv/0xMWuGnrimm+evA==
X-Received: by 2002:a5d:51d0:: with SMTP id n16mr38333038wrv.167.1558452106939;
        Tue, 21 May 2019 08:21:46 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i15sm25178402wre.30.2019.05.21.08.21.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 08:21:46 -0700 (PDT)
Date:   Tue, 21 May 2019 17:21:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v2 net 2/2] net: core: generic XDP support for stacked
 device
Message-ID: <20190521152145.GA2165@nanopsycho.orion>
References: <20190519031046.4049-1-sthemmin@microsoft.com>
 <20190519031046.4049-3-sthemmin@microsoft.com>
 <20190520091105.GA2142@nanopsycho>
 <20190520090405.69b419e5@hermes.lan>
 <20190521061536.GB2210@nanopsycho.orion>
 <20190521074553.12329dd5@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521074553.12329dd5@hermes.lan>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 21, 2019 at 04:45:53PM CEST, stephen@networkplumber.org wrote:
>On Tue, 21 May 2019 08:15:36 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> +	if (static_branch_unlikely(&generic_xdp_needed_key)) {
>> +		int ret2;
>> +
>> +		preempt_disable();
>> +		rcu_read_lock();
>> +		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
>> +		rcu_read_unlock();
>> +		preempt_enable();
>> +
>> +		if (ret2 != XDP_PASS)
>> +			return NET_RX_DROP;
>> +	}
>> +
>
>rcu_read_lock is already held by callers of __netif_receive_skb_core

Sure, the purpose of the draft was just to show the idea.
