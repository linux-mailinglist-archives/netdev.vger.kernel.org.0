Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756BB1A0430
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 03:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgDGBK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 21:10:59 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]:45018 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgDGBK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 21:10:59 -0400
Received: by mail-qt1-f177.google.com with SMTP id x16so1470940qts.11;
        Mon, 06 Apr 2020 18:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/2H3dcTf/9mtyytc4VxWkttiXAhxmMmKoWzraeVc+fE=;
        b=LNKM4EpmQwvlAAEN/03bO4uDnduS/Lf2gou1KbQFHm2rug9Hys6/pFJKB4sd7ayI7j
         OXYRqW8OmUQS/H6j7pTeMCfFgBNW8gl4e/WTRrmObYtkUtp12DFGI/MGTZXjCcM2H/yV
         fQQNFk662v1SM1S6TjeDTd21rAXYJPcsC/jvXaA/319JcB/sYmMMyZiZmlgMN1DZ7ITJ
         8wtcvcwmPsV7+mfp/WuxK/IEt/qI/bImcYp8w282xDZWMNjAlbKOuwbpYTpEEUihrOQd
         8X1q3OpSTNe+JfynE5MjRoyJWff65L3Hjm+bVgJJkUj0gNo/Af++B60V70Eml0a4v67E
         2YcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/2H3dcTf/9mtyytc4VxWkttiXAhxmMmKoWzraeVc+fE=;
        b=LXKSt8Hs5r3EoHA1Jj2XF6BLUy+JwzsYb4LEJvFFw3Ryjyog4SWowN9FC9kxWcasqx
         eZSYXGiQKzNXgQ2plx8KEyvmdr+sPNNQOBXCS9mSJxnOTvDAa1JjCSydB4qfA+DZ+gO1
         UESBFLn0Ix5mgPOK9ENvhzfiU9Zeb9tcdhXciDJEurPBtKtwyFtFMiBQuyuQpEdlki1+
         VzM9+z16CIUjZ2PfTZMuBIK2UBQx45Wl6vIkKInuaOERp0p8gHTXF+FuNf3MT/KLP3PN
         A5OAl8qE6gvYsG0ezmiXQqv5sBt5kUvyS9zbjG5rF7nXbW324v0tKtEQvjmUFmwj2Fnc
         uUvQ==
X-Gm-Message-State: AGi0PuZjkiIWsuffQtvHCC+GLAHArDVdL8esfmr4fVkxgLerq5KDX2A1
        QrTmWB6xaf/S3KdLdv/V5rM=
X-Google-Smtp-Source: APiQypK0eThyQA+uYkHIe40uxcfWJvpuZ4dUHyIxr9rkc/T9fLeoKGIUXv6tKQ57z5bmPbeGla1L2A==
X-Received: by 2002:ac8:424a:: with SMTP id r10mr51112qtm.167.1586221858034;
        Mon, 06 Apr 2020 18:10:58 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c091:480::84df])
        by smtp.gmail.com with ESMTPSA id p38sm16866087qtf.50.2020.04.06.18.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 18:10:57 -0700 (PDT)
Date:   Mon, 6 Apr 2020 18:10:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com
Subject: Re: [RFC 0/3] bpf: Add d_path helper
Message-ID: <20200407011052.khtujfdamjtwvpdp@ast-mbp.dhcp.thefacebook.com>
References: <20200401110907.2669564-1-jolsa@kernel.org>
 <20200402142106.GF23230@ZenIV.linux.org.uk>
 <20200403090828.GF2784502@krava>
 <20200406031602.GR23230@ZenIV.linux.org.uk>
 <20200406090918.GA3035739@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406090918.GA3035739@krava>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 06, 2020 at 11:09:18AM +0200, Jiri Olsa wrote:
> 
> is there any way we could have d_path functionality (even
> reduced and not working for all cases) that could be used
> or called like that?

I agree with Al. This helper cannot be enabled for all of bpf tracing.
We have to white list its usage for specific callsites only.
May be all of lsm hooks are safe. I don't know yet. This has to be
analyzed carefully. Every hook. One by one.
in_task() isn't really a solution.

At the same time I agree that such helper is badly needed.
Folks have been requesting it for long time.
