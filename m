Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD5B1E6E2
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 04:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfEOCoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 22:44:34 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47052 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfEOCoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 22:44:34 -0400
Received: by mail-pg1-f196.google.com with SMTP id t187so533311pgb.13;
        Tue, 14 May 2019 19:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YJqN85hZT4XHxSeUWFYHm0YbU1tsX6DHvhIouN28Ye4=;
        b=VnZOJv05MwaopIk+SOdyqDkZBGMH9yyp4IVyppA9G1t2HvQdiOvLHv688r2eY2HlE0
         +TTmT2v1Z/9rr4g42M8nz8V//x0vaIUvW2pwCsjrS5dOybiB0KHu3zXnkCJazF7AWFkp
         U/VNkbaOHot84y5WmQtwF2cQjecTnsmvG81m0ujNPuEpc/rTwHbKoukmWJcz31j2WMzp
         pmFFtj40B1yRV3WuOE4wDYrLzscXsn/3xOgIyu2/60lCo2lZ1pPyvHnGvhTQ4cyRzpSU
         JS0YF87M8YL4qID7fJBhu3ILkduoxtRXdTDrVIPw/ODVrX17/pAFo9AC3w9syla+AWQY
         Kycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YJqN85hZT4XHxSeUWFYHm0YbU1tsX6DHvhIouN28Ye4=;
        b=tEXB8SokFTzTFYDf4s/Yx0ZigMIBP/g1RXY9r3VoqWlEtfm1oMClbC31OLLW4XsYiO
         07AWNaeT2brc87OACe/N5622igPCtuSFDFWm0M/mebaMykrEVZy82vcKLlX757ycfiKE
         Tpf8ALTKOl8LacNx8mHP2rYic14ow3P/3N8LdvOynAW0O9ZA/e5OXT2zRSj0iH329Olv
         WwyWdKjuBdqP4Mm14NiSacjg6FAn6/yMVgSDzXOADqtuSfRSXkisK1O4TfSQDgAO4nyn
         BFHbRBw4jbRK4Hsz6gx37PjBNyiCh1Zb4mtzP3J+4l6y087Z+zzBc1IYr2yP38GB1lOd
         BaZA==
X-Gm-Message-State: APjAAAVLnmS7bD6aib8bTu30SVxhby31Y02vQKCj0E+FJjffXb40UbeE
        eaawd3xVaPYz1J9R9CNVmzU=
X-Google-Smtp-Source: APXvYqyOmuegB60Ux81UU01RWZnBuUOEkRrzdoJxv+zrxfVHtzjRtu3YKgD/Q+IHLNaELqzXGAzMVQ==
X-Received: by 2002:a63:b1d:: with SMTP id 29mr41505592pgl.103.1557888273742;
        Tue, 14 May 2019 19:44:33 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id g128sm574699pfb.131.2019.05.14.19.44.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 19:44:32 -0700 (PDT)
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20190508171845.201303-1-sdf@google.com>
 <20190508175644.e4k5o6o3cgn6k5lx@ast-mbp> <20190508181223.GH1247@mini-arch>
 <20190513185724.GB24057@mini-arch>
 <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
 <20190514173002.GB10244@mini-arch> <20190514174523.myybhjzfhmxdycgf@ast-mbp>
 <20190514175332.GC10244@mini-arch>
 <CAADnVQLAJ77XS8vfdnszHsw_KcmzrMDvPH0UxVXORN-wjc=rWQ@mail.gmail.com>
 <20190515021144.GD10244@mini-arch>
 <CAADnVQ+LPLfdfkv2otb6HRPeQiiDyr4ZO04B--vrXT_Tu=-9xQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5ed25b81-fdd0-d707-f012-736fe6269a72@gmail.com>
Date:   Tue, 14 May 2019 19:44:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+LPLfdfkv2otb6HRPeQiiDyr4ZO04B--vrXT_Tu=-9xQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/14/19 7:27 PM, Alexei Starovoitov wrote:

> what about activate_effective_progs() ?
> I wouldn't want to lose the annotation there.
> but then array_free will lose it?
> in some cases it's called without mutex in a destruction path.
> also how do you propose to solve different 'mtx' in
> lockdep_is_held(&mtx)); ?
> passing it through the call chain is imo not clean.
> 

Usage of RCU api in BPF is indeed a bit strange and lacks lockdep support.

Looking at bpf_prog_array_copy_core() for example, it looks like the __rcu
in the first argument is not needed, since the caller must have done the proper dereference already,
and the caller knows which mutex is protecting its rcu_dereference_protected() for the writer sides.

bpf_prog_array_copy_core() should manipulate standard pointers, with no __rcu stuff.

The analogy in net/ are probably the rtnl_dereference() users.




