Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDC71359FE
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 14:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbgAINXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 08:23:11 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:42841 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgAINXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 08:23:11 -0500
Received: by mail-qv1-f67.google.com with SMTP id dc14so2913155qvb.9;
        Thu, 09 Jan 2020 05:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gHn0DTphjj03asL3iOA7THQryvYrwo9Swn5bZMEu/Uo=;
        b=b9C+6E6yblXFpvQVBMn7gtrDQWz729YAwVEOl+5LFkbKdWVFNG9+9P1Z4o3jl+3moX
         o/8h48cBrHsjQJ38tt1gb9ZktrB8H+m6wLKAeRe/p+VtnU19DC53uz+Xjf2nDOtK5QeS
         s/1QDQAzrS9OJGn1cnzCCSvBcAk28XuZO9Wk2yOTtOuQpMJb9QThp2TUi1aQhV2jv2hJ
         0fDOaGXD/WGX8xfNF8NdNK9f3bCFNKK4zXVGAaCOFZdYkiB3TmqJmVkpVGDhvyTPOteL
         RVSNFwWYI446zE73eXLEleBwMiJexQPHb7qZnqrD2x1kRmEs1dEg9WSp+B2xu2vQGQGN
         FpMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gHn0DTphjj03asL3iOA7THQryvYrwo9Swn5bZMEu/Uo=;
        b=O5tWhiK0bnSM8u+PHSOht83dn/tkfnmXB7JOZlq1tUAYb2b9gmnl4Rs1HF20ostgVu
         TjoywWOUdTs+Er0UTesgEzCI/T9KJOKkZPxo9AHxD54jkHdrbfZ3zatAutN7Eq2p6snS
         jKFRlJqH41iZkkItpMgovrQTYCxxQf7r2XUQ5OfkRMYFtlqr7tL5zOQXzGvzHLpmWARs
         O23Xe/o1l9nEAeuI2kyUeTaAnfyiNmnUXT0rcu+Hh7qnZr5jAc3Re1c8nBbQgEUaxD9S
         ZJGb56QSsWjCDhEgsASZjL7BR0KJTPQn5sOf7EoE08U24ny6loKECq/sPyRMF7IIdupm
         pB6A==
X-Gm-Message-State: APjAAAVedLfGuifzuGTLWN0D1t0jWAkW8NcHKH9O0KiARAMY3JWpK/g5
        onL9hqVwzw5a5dfwDfxEo0Y=
X-Google-Smtp-Source: APXvYqzRJEThNlX0fsuuLm2WmQbGJXLyGL76XM7lMYUKN6wZ/0iULCQ/rvx1/+CYO5gmklP08MRlzQ==
X-Received: by 2002:a0c:e58e:: with SMTP id t14mr8629177qvm.131.1578576190161;
        Thu, 09 Jan 2020 05:23:10 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id r28sm3419391qtr.3.2020.01.09.05.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 05:23:09 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 71A0740DFD; Thu,  9 Jan 2020 10:23:07 -0300 (-03)
Date:   Thu, 9 Jan 2020 10:23:07 -0300
To:     Martin Lau <kafai@fb.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 01/11] bpf: Save PTR_TO_BTF_ID register state
 when spilling to stack
Message-ID: <20200109132307.GA32252@kernel.org>
References: <20200109003453.3854769-1-kafai@fb.com>
 <20200109004424.3894196-1-kafai@fb.com>
 <9EC7DCC9-B219-4545-BA93-E2AC0569C843@kernel.org>
 <20200109054701.bog4btwk4724gwfw@kafai-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109054701.bog4btwk4724gwfw@kafai-mbp>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jan 09, 2020 at 05:47:06AM +0000, Martin Lau escreveu:
> On Wed, Jan 08, 2020 at 10:06:44PM -0300, Arnaldo Carvalho de Melo wrote:
> > On January 8, 2020 9:44:24 PM GMT-03:00, Martin KaFai Lau <kafai@fb.com> wrote:
> > >This patch makes the verifier save the PTR_TO_BTF_ID register state
> > >when
> > >spilling to the stack.
> > 
> > You say what it does, but not why that is needed :-/
> It is the same as other existing bpf_reg_type (i.e. the above switch
> cases in is_spillable_regtype()).
> 
> When a register spills to the stack, the verifier decides if the reg's
> state can be saved (i.e. what the is_spillable_regtype() is checking).
> If the state is not saved, the verifier cannot recognize its state
> later.

Thanks for the explanation, I suggest that next time you include it in
the cset comment, to help make sense of the patch by having a why + how
to match with the actual patch.

- Arnaldo
 

> > - Arnaldo
> > >
> > >Acked-by: Yonghong Song <yhs@fb.com>
> > >Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > >---
> > > kernel/bpf/verifier.c | 1 +
> > > 1 file changed, 1 insertion(+)
> > >
> > >diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > >index 6f63ae7a370c..d433d70022fd 100644
> > >--- a/kernel/bpf/verifier.c
> > >+++ b/kernel/bpf/verifier.c
> > >@@ -1916,6 +1916,7 @@ static bool is_spillable_regtype(enum
> > >bpf_reg_type type)
> > > 	case PTR_TO_TCP_SOCK:
> > > 	case PTR_TO_TCP_SOCK_OR_NULL:
> > > 	case PTR_TO_XDP_SOCK:
> > >+	case PTR_TO_BTF_ID:
> > > 		return true;
> > > 	default:
> > > 		return false;
> > 

-- 

- Arnaldo
