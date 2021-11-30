Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995F2462940
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 01:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbhK3Auq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 19:50:46 -0500
Received: from mail-qk1-f172.google.com ([209.85.222.172]:34774 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhK3Aup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 19:50:45 -0500
Received: by mail-qk1-f172.google.com with SMTP id t6so24997447qkg.1;
        Mon, 29 Nov 2021 16:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=taVuMg7QGnXLVw89RVaLZa5HlvvUY9Y8F3Bmfo83nQA=;
        b=GNf6lgvdWJF05h9PXjIU05wxA7QU8Rr3FG3GHhvIm37gJoPKP+ji9ix8OhHgf14cEo
         0dmWCDJqKuWRiWLjRpFskGn/pGeoRCUlgfW8zK4JmWnLLVcYC9Qx5odlNFl6/Hsz8ash
         ifp2nuWeLrwxMcURKDfAI618ws6L4OZlLi/F6q5lw/b9GsyDEUVmSTQMY0YMbwvse3hJ
         CvyxT7k8OyZIQUNPEN3ncIrY55Fz0+XR6SoA2+cM2gbx5ht+l57oqU0CBWbkrodVwKLo
         4HkoRyej3SZWqb3aeYzRrZNzie2jnF4GmRwSAy+yKpS2tQVquovlm6d7QQavimEbHpsR
         ddqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=taVuMg7QGnXLVw89RVaLZa5HlvvUY9Y8F3Bmfo83nQA=;
        b=T4C5HPZSaxRPnWGn1s+AvUoCETMECLKkGoRFj2SV8zuK42RgHNi65ZfIOldN3WRSqs
         lVWk6bRIXwMOd9xJ57mDGhaEFJeeIflucO1rKnmgedHXKX2gE9lawoEC0eQNcRSYtJYL
         YkHsvLajGxUqH8mTvLLCiqg0eaeIQWnWmyA9ZeETcs6Z4tB+X5KDfmdXnLJ4bvmC8on1
         KYLGs4+cljzUvG80ASSK53lbLEuXI0KOTT7Os3Op2N0UfRN7tQIoDfYufe7gk1BP52ob
         vrZ4SjdrnNrtSHkhFtYaM7w67nUIh4jOwI9VsjjtYdeTGs2jpE8xc5CykHvaQ12q7zce
         jI1A==
X-Gm-Message-State: AOAM530TSjI8Sm3eM7SaJktkfWUf6H4yVAq1DJdH2ekgZUCg7FkHPm3O
        y2XRFBWW+I9P2QPeGgmCoDdHTpM/UQ==
X-Google-Smtp-Source: ABdhPJymPq3+noSIJMUnISULM5HTtAhJhMd69rslP7ZCnnFpV+iykVhpbVE97aOE9LhXddOM6Ztj+g==
X-Received: by 2002:a05:620a:15c8:: with SMTP id o8mr44309577qkm.385.1638233186816;
        Mon, 29 Nov 2021 16:46:26 -0800 (PST)
Received: from bytedance (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id c22sm9504658qtd.76.2021.11.29.16.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 16:46:25 -0800 (PST)
Date:   Mon, 29 Nov 2021 16:46:22 -0800
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] selftests/fib_tests: ping from dummy0 in
 fib_rp_filter_test()
Message-ID: <20211130004622.GA4051@bytedance>
References: <20211129225230.3668-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129225230.3668-1-yepeilin.cs@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Mon, Nov 29, 2021 at 02:52:30PM -0800, Peilin Ye wrote:
> For example, suppose ping is using a SOCK_RAW socket for ICMP messages.
> When receiving ping replies, in __raw_v4_lookup(), sk->sk_bound_dev_if
> is 3 (dummy1), but dif (skb_rtable(skb)->rt_iif) says 2 (dummy0), so the
> raw_sk_bound_dev_eq() check fails.  Similar things happen in
> ping_lookup() for SOCK_ICMP sockets.
		    ^^^^^^^^^
I actually meant "SOCK_DGRAM".  Will fix in v2 soon.  Sorry about it.

Thanks,
Peilin Ye

