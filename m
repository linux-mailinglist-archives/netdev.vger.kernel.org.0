Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA9ECC3EF1
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbfJARrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:47:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45830 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfJARry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:47:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id y72so8537381pfb.12
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 10:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SoOSPipuE33jULe97DufiIcM26KAvulqtCWdOasdfOc=;
        b=Gt56L8w1v5zwU157k7mYgChNAKCLkkvgOLzG56/nYZ8pK5jDXgA0tfvBAzl4lW51oL
         uO+NU+Y33bGvOo3xDJxVhEHTmkmLRtyl/1MK0XaqabPoExaiQmE3WtL93fkjUtqOJpbP
         nS14jOdTR8VA2fAmxsyPy+Y9VPWTceINwAYyGx3tXbzXmCoHd6Wj4/3o192nsMY5CKRm
         +hDIhYWw+4Zb73iaRsO4pX4wG6R1oVB3IAMaSxIvzex3svPTK5Z1CfhQtW2Yu3bSgtDn
         TK5RRfG4856AMFq4SOAx+sFby9HihmUjJvGi8pfg5XdAFXfaH0uQV6h0Z1dmoFuvxoX9
         UFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SoOSPipuE33jULe97DufiIcM26KAvulqtCWdOasdfOc=;
        b=qExFLCm7jXoXCDFurCfjoOuZ/2Mh8GO0k9hZI/jlJJM6mspoCQ/OF0qWTMLFlz122F
         4fqE8wGcaKKhdlSZNMaptWchc7WK9Wdl315M0sS8OS9py6zWzBAwIvMH0YmBqM9oh0yH
         Xg1cjnDRbQW0sgqLQkOxkIiQxlZ6hvm0QU4YWPLRuCH3O6fYkN9GfFd70v02dFVsPweI
         5q4zbIzFXMTEByWBYZLjkb4QDM1n3Z/57fgBhEAR6HxPlhZrC34I2j85dBnE+oDVuenP
         N7kfHvQvoRVLpXIycn+u0/VO2kpPTly4PnKTJ42XS4dckvJDCKz8/dND8RFIb7JhTWmp
         t6CA==
X-Gm-Message-State: APjAAAX+R4Qv07ogZOXRwfsk+sAGkFlT/D45Gk+Dnh+mbNoZ3mEQBN9S
        CIKQXcrUYjp9A1vGa2HVHHbblw==
X-Google-Smtp-Source: APXvYqyakcnmqkudv3y2xd4f1EkwDl0BTY3KUNGODhaZa8QBXhCiE73fXWyT+f7Q5kYz+rtdOTz61Q==
X-Received: by 2002:a63:6e4c:: with SMTP id j73mr31127847pgc.452.1569952073325;
        Tue, 01 Oct 2019 10:47:53 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id b24sm16963529pgs.15.2019.10.01.10.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 10:47:52 -0700 (PDT)
Date:   Tue, 1 Oct 2019 10:47:52 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf 0/2] selftests/bpf: test_progs: don't leak fd in bpf
Message-ID: <20191001174752.GA3223377@mini-arch>
References: <20191001173728.149786-1-brianvv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001173728.149786-1-brianvv@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01, Brian Vazquez wrote:
> This patch series fixes some fd leaks in tcp_rtt and
> test_sockopt_inherit bpf prof_tests.
Thanks! For the series:

Reviewed-by: Stanislav Fomichev <sdf@google.com>

> Brian Vazquez (2):
>   selftests/bpf: test_progs: don't leak server_fd in tcp_rtt
>   selftests/bpf: test_progs: don't leak server_fd in
>     test_sockopt_inherit
> 
>  tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c | 2 +-
>  tools/testing/selftests/bpf/prog_tests/tcp_rtt.c         | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> -- 
> 2.23.0.444.g18eeb5a265-goog
> 
