Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B541A6EE3
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 00:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389456AbgDMWIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 18:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727851AbgDMWIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 18:08:16 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CAEC0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 15:08:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x3so4897494pfp.7
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 15:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=FF+Fz+9YKhuS9t/ErqAtvW/o7QoRO2fyz0y6XXQzGKE=;
        b=n0qJvEtJoPzuJx7lFwu9K4lba1F2aReUSvWm3xFHdtW+EEe9fyoI9PQpR0RAKBQV3K
         MAxArp/k1t0m/+fEOPjhNiwDf9bQL6ja81XfZNDieTa9EcvVedVQu/1kMnqMBcN1Y5Ll
         LF4Z5OhVM0JytoZA9qlsRJJRWysXjkj68RNxU1VuwN217w1P3up92M85JDBXdKb5vkwa
         KFTUhUdtiMdKb2Xg5N/yy3cqu07IaYmFkyqUJ90zScjIKCLSL8nXjQvuTp22t/gJWa49
         y7f9Cfl+qo/lV/Ll31RqeKZ9kVFfzdCOHykH6NxL9Hu2j4UHitDOEdURrIkGpb2DUd9S
         jEfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FF+Fz+9YKhuS9t/ErqAtvW/o7QoRO2fyz0y6XXQzGKE=;
        b=g2zT0mdKt8+5EOH6WpNdPfoEPl0zRLI2wag/ccUmHDFCb7vDCo2czvoPz7F93cQKH8
         bOChupZU0LFJ955os+sZd78FBT2ouDyxcfkFM5yz0qlQx0K+MZwDMdpFKkSkN1TvOoPY
         QAe35Wu+yxS2U5zNX3/xP8IU/FaVnJMWqEuTATpjjFtDRjliI6aomCSUOkK8tmAMqNr4
         p4hWrhg4L1Som+jzl81jYWafuovLaZEmMpdHz7yXvHU4Yk2lZDC0zxmCBvYBmqywlIXH
         9XcrRDUdfgU5PIxTHhkBIHUSYdwTZxLaY7Mf55XEHVt30d7XsDOatv8Nesck5QXFf6iz
         Bt1w==
X-Gm-Message-State: AGi0PuZdkHvY+r16Hu0p8W4Bjnp4oLTQfvolNVIGdEMHmVMd1EtWpc0S
        aNP2Jpig1Pih72eIpTyAeOg=
X-Google-Smtp-Source: APiQypJHhRbiIqAIRyHhLvc2ygQv//SdIoFxvRyVCha2t8JQ87y+9pEqv8DJPP4faK4n20F1pYymRg==
X-Received: by 2002:a62:fc51:: with SMTP id e78mr20319680pfh.155.1586815696346;
        Mon, 13 Apr 2020 15:08:16 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:23b9])
        by smtp.gmail.com with ESMTPSA id o15sm10109870pjp.41.2020.04.13.15.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 15:08:15 -0700 (PDT)
Date:   Mon, 13 Apr 2020 15:08:13 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf] xdp: Reset prog in dev_change_xdp_fd when fd is
 negative
Message-ID: <20200413220813.zfft3e44kqnehlrh@ast-mbp.dhcp.thefacebook.com>
References: <20200412133204.43847-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200412133204.43847-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 12, 2020 at 07:32:04AM -0600, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> The commit mentioned in the Fixes tag reuses the local prog variable
> when looking up an expected_fd. The variable is not reset when fd < 0
> causing a detach with the expected_fd set to actually call
> dev_xdp_install for the existing program. The end result is that the
> detach does not happen.
> 
> Fixes: 92234c8f15c8 ("xdp: Support specifying expected existing program when attaching XDP")
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Toke Høiland-Jørgensen <toke@redhat.com>

Argh. Thanks for the fix.

Toke, please review.
