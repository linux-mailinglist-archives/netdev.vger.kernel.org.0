Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA72EECD
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 04:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbfD3Chz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 22:37:55 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45510 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729882AbfD3Chz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 22:37:55 -0400
Received: by mail-ed1-f68.google.com with SMTP id g57so4340270edc.12
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 19:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fnREn9dGyvlSodTLCRoAxPFeIY6fhnUk2MrrlpNaYxE=;
        b=d6pyMU+B1Zb/cr1s7m5osmXJi43FH9dZFq19iEpf2aqqKlVWjed20Fffx2ixQR24Pu
         gTct4Y5AAodLyik19KED4xKnAvt01aEaI6eaOJ4oj9KQQZq/PHt6FGFbZC/LdeMgyle+
         TytiVpP85haTzPUamJ86KtS5WytCowDJJzGGMBPN0ulge29nJJkbwPeqjKtX9YLZ5WU3
         CTV/Q2AuUld5AQbJVqXACAwOFb0boQi6EK/jj9GvkSh3DaY78o9xEkQwl8e8e1F3hgwg
         urhpbSh9ATvwbUFW/d0oNcrqoXIyvfaNrmpvXYkAYygiUajlRVSHY9uecBz7LnByP/rO
         fSGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fnREn9dGyvlSodTLCRoAxPFeIY6fhnUk2MrrlpNaYxE=;
        b=ity0OO2tM7F8IM5M3Z9Lbjt7Ah4pVEX2DoS8lBxzW0/H03UeLuDPmg29xxo6MYsye3
         622AbhVjTkE9O7OV/tatoqS2scVy4aSUTIy4VG7gIWyT1GcCM+jNYQpdShMdm1xmQ7SV
         dFk3L3NkYOvMgnGb2JQdQyYpefYWS72n7yAg08gKAcCF/VEG5RywSGNVTuO38r1HJ3E1
         IGV911FKHeVp6qrQki8aLAvbYoEfzoMau31GccNvEq+CHf2K3hfmxXHoW+4u3mThLAQr
         OwzTaGJ826+6c/zDXTL+7SvWawZNeKVpYYae7eS6sAnuf+goe+cQHQG6jdG7xq8/pSIV
         hi2w==
X-Gm-Message-State: APjAAAXrWoL+wPdv1lLrTNG9wapCgI6KjWTt5/G0ZIGiekOs65eUMd/q
        goE+4b48zMVv8iEuNxA4+74=
X-Google-Smtp-Source: APXvYqytI+wmRyr+STphszeHC9kMxlxKtCgHcWJYHYAmOU4W5uTPORKjAzexiHPE7TgZPkvv0xSwhg==
X-Received: by 2002:a17:906:28d1:: with SMTP id p17mr10399981ejd.133.1556591873886;
        Mon, 29 Apr 2019 19:37:53 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c23sm1123945ejr.78.2019.04.29.19.37.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 19:37:53 -0700 (PDT)
Date:   Tue, 30 Apr 2019 10:37:40 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] selftests: fib_rule_tests: Fix icmp proto with ipv6
Message-ID: <20190430023740.GJ18865@dhcp-12-139.nay.redhat.com>
References: <20190429173009.8396-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429173009.8396-1-dsahern@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 10:30:09AM -0700, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> A recent commit returns an error if icmp is used as the ip-proto for
> IPv6 fib rules. Update fib_rule_tests to send ipv6-icmp instead of icmp.
> 
> Fixes: 5e1a99eae8499 ("ipv4: Add ICMPv6 support when parse route ipproto")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Yes, I also found this issue and have the same patch in my pipeline...

There are two other issues with the fib_rules_tests. The first is the test
didn't check the nfail and will always return 0. I will post the fix later.

An other issue is The IPv4 rule 'from iif' check test failed while IPv6
passed. I haven't found out the reason yet.

# ip -netns testns rule add from 192.51.100.3 iif dummy0 table 100
# ip -netns testns route get 192.51.100.2 from 192.51.100.3 iif dummy0
RTNETLINK answers: No route to host

    TEST: rule4 check: from 192.51.100.3 iif dummy0           [FAIL]

# ip -netns testns -6 rule add from 2001:db8:1::3 iif dummy0 table 100
# ip -netns testns -6 route get 2001:db8:1::2 from 2001:db8:1::3 iif dummy0
2001:db8:1::2 via 2001:db8:1::2 dev dummy0 table 100 metric 1024 iif dummy0 pref medium

    TEST: rule6 check: from 2001:db8:1::3 iif dummy0          [ OK ]

Thanks
Hangbin
