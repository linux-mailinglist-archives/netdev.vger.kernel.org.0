Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16FA57116
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 20:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfFZSyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 14:54:25 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41771 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZSyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 14:54:25 -0400
Received: by mail-pl1-f195.google.com with SMTP id m7so1914613pls.8;
        Wed, 26 Jun 2019 11:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cX41cOnVZeZMVlmKnsvAA5YFj9FWf2swy8pRbFzxe5c=;
        b=PPGa7ZulhbuaXu4mLGvsRzaDh7YtzSdYCoKWgwo08VJUNseiYnLmSqrniIhnUfkzqB
         Z8RsMk4u2B+vskj5Ab+D78QEbBE1LrMxHM9E0KAhz63klgslpSaUOjAvqGAl6/1PDEuX
         e8SEE068Va2CBfcSCjMNOWe73arbpYYw9EfJ3KLeSjgY8V/2QVYueDYWQkTA8oLrHOfF
         kNTG+STuCRi3oKt7WncgI6McBIrQ85mn6I/5Rbr1ymTXEv92CBANUpYZtGYF3DtxT64a
         GIjLbQiQu4nuNpoZHU5Ar8X1hMupR+9abAYSd3CDbsLLsEdf9h+pL31Cas6v3Ow2DO1H
         X5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cX41cOnVZeZMVlmKnsvAA5YFj9FWf2swy8pRbFzxe5c=;
        b=YFzFKLArj3W8Dd41iMo2UgeJburMl7Jw4mwzAkWIEf5/thi5irb5+kFn4mEWwRnfqB
         eEFB6jAA5x/uLt2E9zdGtFwZgsKDzoMiEOymP4B65oTQU9rrh7JY7OL69wALtdn7wYPV
         A90Pm2SelmrxkSWYMuh9aCPbcN/Hl5t5o0SFGXSAwBn9BDfBcP8aX+AA/9qxB0kgzeRM
         SyjSg1NVUorCfguliqO1z2jmtCcSXLUe+BFRQ7xFbif2hOyxTW47271JUw7zeM3rJHXc
         Vc2ffdR7D7H1z1Br/H5JLu+NMr43j4h/W17SAgyV/x/HLrQTXoC0m56DV9rPpU/OH2Xr
         gG0Q==
X-Gm-Message-State: APjAAAUPJVYN5rtLKZ63RWpqtNSKW7dC1fk9j3jp0jTaahscToe3FLnA
        ts14WLOu/vJzuiLtQd4NmQY=
X-Google-Smtp-Source: APXvYqwDvrB+mv/dnmwhiF+eTL8yDQUO8ZbAikd+dv3rP3XevfUc5XVjBo1M9f5lM/Q2T1i9nRfWvg==
X-Received: by 2002:a17:902:27a8:: with SMTP id d37mr7186805plb.150.1561575264513;
        Wed, 26 Jun 2019 11:54:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::1:6c67])
        by smtp.gmail.com with ESMTPSA id z2sm17193407pgg.58.2019.06.26.11.54.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 11:54:23 -0700 (PDT)
Date:   Wed, 26 Jun 2019 11:54:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v8 1/9] bpf: implement getsockopt and setsockopt
 hooks
Message-ID: <20190626185420.wzsb7v6rawn4wtzd@ast-mbp.dhcp.thefacebook.com>
References: <20190624162429.16367-1-sdf@google.com>
 <20190624162429.16367-2-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624162429.16367-2-sdf@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 09:24:21AM -0700, Stanislav Fomichev wrote:
> Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
> 
> BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.

getsockopt side looks good to me.
I tried to convince myself that readonly setsockopt is fine for now,
but it feels we need to make it writeable from the start.
I agree with your reasoning that doing copy_to_user is no good,
but we can do certainly do set_fs(KERNEL_DS) game.
The same way as kernel_setsockopt() is doing.
It seems quite useful to modify 'optval' before passing it to kernel.
Then bpf prog would be able to specify sane values for SO_SNDBUF
instead of rejecting them.
The alternative would be to allow bpf prog to call setsockopt
from inside, but sock is locked when prog is running,
so unlocking within helper is not going to be clean.
wdyt?

