Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A55F465688
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245282AbhLATix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbhLATiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:38:51 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1A3C061574;
        Wed,  1 Dec 2021 11:35:30 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u11so18515679plf.3;
        Wed, 01 Dec 2021 11:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=VSsVFWntTE7c4RiAbESHCx0AGg9CBW9/QGJqS0X9jIQ=;
        b=koR/F2dhOFSTeQfeKCRb86Y+ZSFgu6AJc8p8GQi6UkmfL+ZT6AluQY1VEusXrdet0z
         Nun9QcGUEiCVo7BKXL6CBLPaLEXZPzH4/N159MCHyTuCCASGIp0krtr7js+CBJ8t+G5S
         QjwLGXsiRepAP/dKpgS3/ZFtlfm5zTvC3E2KGsRagvA7XvPVjhGMF/BuFd4bG2+nGQDb
         1UlvJvMggbCLZEZGPbGgrI0EjHILEr0GzHrTXsPeLbZ37VXqvmzH5IvHUbwQLb02qzVh
         CuuuRhOZWD40Sugsp9GuppQcRjhvVhWkXQc1FjHMoEoYEkJ3UdKxLPIOM6TNj5Py51/Q
         VEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VSsVFWntTE7c4RiAbESHCx0AGg9CBW9/QGJqS0X9jIQ=;
        b=uyuYxfzlYNVtT0uTTnQ6d4s0BNB2OlkcJupxDIvpcFQyTW6r518znKFborRr0O/Ojw
         NJjQfAyXVyD9JG/fat/IDzT3h6Nwjb8CdWkh5ZOwGBidQoUEy+fO8ySSbiDlx5tnkMwF
         +fPPuF4OCeC0TzNrYNjoVseROfUgWVJNWFq13+M6bNWiJTElLXIwCoJKKixfEfXx5V0x
         VjhjcZE+ZF8BwVDEHqpOb74vnQuIfC16qFLJXFlHbKdydAZduasTytT+aMja8/GV+GKg
         FWcrWqv6V3W44PrP18DBKX/N4l8eNDaC/tpEnUCgQ1bbslFo0LnRx5yDP1lz0cMegWhG
         oaPw==
X-Gm-Message-State: AOAM530/HuI9Q2UhIlhkqVYJj1P3j9SII6n5gRST9iz07RGVK5/U6gEH
        ei3E6pmMe4IWpDEoea2JpuD01dgbaw==
X-Google-Smtp-Source: ABdhPJwPzikQOQSO9fQi5ca2JZqe56DT2SwLlF1BD5JP5rLc18v8yM4tJTVpoZIPrPt/XggjAHNV5w==
X-Received: by 2002:a17:90b:4c0f:: with SMTP id na15mr294164pjb.222.1638387330094;
        Wed, 01 Dec 2021 11:35:30 -0800 (PST)
Received: from bytedance ([4.7.18.210])
        by smtp.gmail.com with ESMTPSA id k8sm600474pfc.197.2021.12.01.11.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 11:35:29 -0800 (PST)
Date:   Wed, 1 Dec 2021 11:35:27 -0800
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] selftests/fib_tests: Rework fib_rp_filter_test()
Message-ID: <20211201193527.GA27000@bytedance>
References: <20211130004905.4146-1-yepeilin.cs@gmail.com>
 <20211201004720.6357-1-yepeilin.cs@gmail.com>
 <42b5ebde-2a36-3956-d6dd-bd50e18ff6dc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42b5ebde-2a36-3956-d6dd-bd50e18ff6dc@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, Dec 01, 2021 at 11:00:26AM -0700, David Ahern wrote:
> On 11/30/21 5:47 PM, Peilin Ye wrote:
> >  ┌─────────────────────────────┐    ┌─────────────────────────────┐
> >  │  network namespace 1 (ns1)  │    │  network namespace 2 (ns2)  │
> >  │                             │    │                             │
> >  │  ┌────┐     ┌─────┐         │    │  ┌─────┐            ┌────┐  │
> >  │  │ lo │<───>│veth1│<────────┼────┼─>│veth2│<──────────>│ lo │  │
> >  │  └────┘     ├─────┴──────┐  │    │  ├─────┴──────┐     └────┘  │
> >  │             │192.0.2.1/24│  │    │  │192.0.2.1/24│             │
> >  │             └────────────┘  │    │  └────────────┘             │
> >  └─────────────────────────────┘    └─────────────────────────────┘
> 
> if the intention of the tests is to validate that rp_filter = 1 works as
> designed, then I suggest a simpler test. 2 namespaces, 2 veth pairs.
> Request goes through one interface, and the response comes in the other
> via routing in ns2. ns1 would see the response coming in the 'wrong'
> interface and drops it.

Quite the opposite - the goal is to make sure that commit 66f8209547cc
("fib: relax source validation check for loopback packets") _prevents_
packets from being dropped when rp_filter = 1 in this corner case, as I
mentioned in the commit message.

In order to test this corner case, I need a packet that:

  1. was received on lo;
  2. has a local source IP address (other than lo's 127.0.0.1/8, which
     is 192.0.2.1 in this case);
  3. has no dst attached to it (in this case since it was redirected
     from veth).

See __fib_validate_source():

+       dev_match = dev_match || (res.type == RTN_LOCAL &&
+                                 dev == net->loopback_dev);
					      ^^^^^^^^^^^^
This relaxed check only applies to lo, and I do need to redirect packets
from veth ingress to lo ingress in order to trigger this.

Thanks,
Peilin Ye

