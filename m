Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18FD250B44
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgHXWBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXWBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 18:01:05 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8A8C061574;
        Mon, 24 Aug 2020 15:01:04 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id j13so138975pjd.4;
        Mon, 24 Aug 2020 15:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5dceEFJHLBFtiegpHMWaZEo6cCMQxCzvJQmC92aQl7Y=;
        b=FjgmO0cG/xEzNMicn5lO4NbPeC/wxTC7SKhADUH71xUk9naSqj0UjMlaZDyNKhnEdO
         m2dS3SBTQ0S16fkT0eqgRT9eYCGz9Jc43cndaMDHeneLXcZ7ULrthGI3GfGxfe38QxUb
         kcSETNNDV8n7c8fVIlzc7VQcaA2WT1LsFLuHF6kmRkqSOsBrYz3UdNsN4GqxBBYeOiSF
         g3+Q10hFaZ0Zn2bZ5sBT3no06gMK8he6byi79oYOCwRXZlzjuBWAqEGBA+UIRSjzYR1o
         Jn3s8FblzqLzRRPTUFJ7N3ORV+2qpUnFLHiBpuY4plNVY9a6Wkg0XIcFmWl2OQS14ZOC
         pduA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5dceEFJHLBFtiegpHMWaZEo6cCMQxCzvJQmC92aQl7Y=;
        b=ZuPfAEP51l+GnEa1+NXqGg2j77im4arffz0f/mkzbuJ/oeqKH/5lZE69VAXat6raIv
         yeOrAxMXafd+eQHbG6e6IOSI92Di+6T9wMM6r/WD/JgIF3qCf/oWlx62/Mh0naxQp6iZ
         q9dcN0M5g3wB+/w6klkVHVCsFx1ZBkaKZp3cDknoCNHZNRCi9w6cCe+gEZ3lZWTR1AQM
         ZsvdoGojnRA2uenV1GI/no9zM48LklysvMzt1J4a8CiUMaz8eA4BBnLt7u4r9csSF8zs
         ZM9pDQ8UOFY2773zOAyYQD6I0EbaNRWpjBCKtI6uCI60aKm2EK+nkOAtb+d5kLcWNCez
         N1wg==
X-Gm-Message-State: AOAM532Mc2LezCEGWwnViL+1/EoC0Z0YJfWheH2D3fRnexxxWcRduP2V
        fU4OlUr0IqCGjJ/Mu/71878=
X-Google-Smtp-Source: ABdhPJzB2tD0ttx4dRe0UkSq6u48Qm7pCxLOmniH2qFkAsBtY2ARzs04nub2o5ANmEVeP/vS2qzrIw==
X-Received: by 2002:a17:90a:ac11:: with SMTP id o17mr1044382pjq.145.1598306464525;
        Mon, 24 Aug 2020 15:01:04 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9d35])
        by smtp.gmail.com with ESMTPSA id c143sm13050218pfb.84.2020.08.24.15.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 15:01:03 -0700 (PDT)
Date:   Mon, 24 Aug 2020 15:01:00 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Nicolas Rybowski <nicolas.rybowski@tessares.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        mptcp@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/3] bpf: add MPTCP subflow support
Message-ID: <20200824220100.y33yza2sbd7sgemh@ast-mbp.dhcp.thefacebook.com>
References: <20200821151544.1211989-1-nicolas.rybowski@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821151544.1211989-1-nicolas.rybowski@tessares.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 05:15:38PM +0200, Nicolas Rybowski wrote:
> Previously it was not possible to make a distinction between plain TCP
> sockets and MPTCP subflow sockets on the BPF_PROG_TYPE_SOCK_OPS hook.
> 
> This patch series now enables a fine control of subflow sockets. In its
> current state, it allows to put different sockopt on each subflow from a
> same MPTCP connection (socket mark, TCP congestion algorithm, ...) using
> BPF programs.
> 
> It should also be the basis of exposing MPTCP-specific fields through BPF.

Looks fine, but I'd like to see the full picture a bit better.
What's the point of just 'token' ? What can be done with it?
What are you thinking to add later?
Also selftest for new feature is mandatory.
