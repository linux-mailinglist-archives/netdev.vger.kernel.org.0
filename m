Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFE023A97F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHCPgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgHCPgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:36:36 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6BDC06174A;
        Mon,  3 Aug 2020 08:36:35 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id l6so35485425qkc.6;
        Mon, 03 Aug 2020 08:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nvWJip6U44QszLIikVERj3UX67+D3C36RfLEv+lWO9I=;
        b=TSPOSRkfgYG1NThwdebAyP9AAu29x7aWvlPBL1vv9dEELf5VPUpIDA3wYwnpYsnnoW
         PWLox5ac3eWL6GZHWqVw7b8EVPBJKbo4S6+QxVUErZq3iprdOR2a2BfrvS44BfYnSzv0
         wBgDvnEhJwj0d9I0HmETM240/JYl3zLRi9p1QiL2C8qXxw+ubwii+SncWSmp5bOxsTWm
         js+yQIX0CzWWuAfOEQAMNLr2ODVvXNB+HiU5H8FfB1Mfv7emjK9l98WaANtbYhYTdV3w
         uaNq9QydhvN7WJEIT+0jgzFdabqHPDSJgh/idg3rwsn4XXCa+Q/MLlsL6tgBro1O2o2d
         lt6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nvWJip6U44QszLIikVERj3UX67+D3C36RfLEv+lWO9I=;
        b=akmNCItrPiGIM/8AIaqbsEukGmJ+GEQjU1JvzIi6gz48vUlZVhLru7ZJHOICr6PFSa
         2yQulcV/Rq4CSOkm0xAfo4YWXjIVwG5t8bDipdUNCYZQzuMa/mjiNGRNZwWfBjjB2LX6
         7gk5/pEQGU5oW8W12YJfrrgdTP2TMzvzGQLe48o0BnTZBZdjMWHNzpiO1nzepgQF74pN
         N8d9L3YVb3HzTga7kuZXUM51Petk5q+JMxuOZoLZKBqZPAMb/Ifqx/ZMpYxDioimiILd
         ykodTVFD1/wXZjGSLQxjidU30XFBJUIRtYGxUiL6Ppa3Sdslowm2muEi0uqn8jNAJZOx
         wBbg==
X-Gm-Message-State: AOAM530aYBWzrVJFG1Zf1A2EzcadUTDCU6gBRNlt4I5GOa+KXGryEVo2
        JTUtzC0wf+t4IzXeWy4Rcq4=
X-Google-Smtp-Source: ABdhPJzZJ/lKYEBklmX6unXV/fucqAjFtSQL7QAbbM2UZ2PNFH8VHEvaab+EHUJa0I72CsLmrgdhmQ==
X-Received: by 2002:a37:553:: with SMTP id 80mr15924893qkf.291.1596468995065;
        Mon, 03 Aug 2020 08:36:35 -0700 (PDT)
Received: from supreme ([2804:14c:1a1:217b:9469:41a3:f900:755c])
        by smtp.gmail.com with ESMTPSA id u37sm23271753qtj.47.2020.08.03.08.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 08:36:34 -0700 (PDT)
Date:   Mon, 3 Aug 2020 12:36:30 -0300
From:   Rodrigo Madera <rodrigo.madera@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Christoph Hellwig <hch@lst.de>, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net] net/bpfilter: initialize pos in
 __bpfilter_process_sockopt
Message-ID: <20200803153630.GA2809@supreme>
References: <20200730160900.187157-1-hch@lst.de>
 <20200730161303.erzgrhqsgc77d4ny@wittgenstein>
 <03954b8f-0db7-427b-cfd6-7146da9b5466@iogearbox.net>
 <20200801194846.dxmvg5fmg67nuhwy@ast-mbp.dhcp.thefacebook.com>
 <c166831a-d506-3a4e-80ed-f0474079770d@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c166831a-d506-3a4e-80ed-f0474079770d@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 04:56:35PM +0200, Daniel Borkmann wrote:
> On 8/1/20 9:48 PM, Alexei Starovoitov wrote:
> 
> Several folks reported that with v5.8-rc kernels their console is spammed with
> 'bpfilter: write fail' messages [0]. Given this affected the 5.8 release and
> the fix was a one-line change, it felt appropriate to route it there. Why was
> a4fa458950b4 not pushed into bpf tree given it was affected there too? Either
> way, we can undo the double pos assignment upon tree sync..

Just as a side note, please note it was more than spamming on the console.

It prevented the subsystem from working at all.

Best regards,
Madera

