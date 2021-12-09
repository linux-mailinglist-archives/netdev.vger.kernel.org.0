Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F9C46F3F9
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 20:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhLITfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 14:35:25 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:43389 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhLITfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 14:35:24 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D36ED3201D29;
        Thu,  9 Dec 2021 14:31:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 09 Dec 2021 14:31:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+NI5GP
        6UkM5zGu2Ef2fmeetuNAEpLvERTiKS5bvhQ3M=; b=bSiwuJAjh1Rzw/ExEhzqDW
        p3SqH12mR7i/ss8eXJN2OQuCQdRPK7jRAb9tlmiD/dpEQcOa31Bn2hMlTOXZzO/D
        RHah+1y3o6LD+c84ru0r/MAaNTe85PoIHcrIDEIzPkktD1hjYiAHpPcooJVK/70P
        otcZkOFvAFuG6us2siU6IO+7gSWg69shkQxfMeaJrqdPezW6NfKWRJDhRxsCvUaj
        +ASh7XZzTNSVLrRk5SUDdPkDg5NrBYS9hhF4TJUs5OrKvx2xDyBlfe0ptepbtH1W
        t9aSly5c7UbTCEEXbHDFqF7UuonUxuLwkZbCEN453JLG+Vz0zlyZW5A1KTgxv1HA
        ==
X-ME-Sender: <xms:pFmyYaNGj_j8L1XX8l_doXIgCNAmAEMaPZHl-fNcm3Wmd-TILuupHQ>
    <xme:pFmyYY-hsU5_NBfnlMpkUOvt6ZIHKHjUXdH_BRGIduHEBn4dsOnd13YQWY4-wwiJ7
    7AP-LhDAZzb8Ik>
X-ME-Received: <xmr:pFmyYRSc_AFTHoJSVJE5A7NhcOHmQ2WtkaewRYk1qinqYstX21H62xlTcUZVdJT8gm9FsAiC_9AmC0bw3P7iifDFCHqopQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrkedtgdduvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgvefgveeuudeuffeiffehieffgfejleevtdetueetueffkeevgffgtddugfek
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:pFmyYavYG0xGiZRCmRmiAQy_SQqCoTHRoN1Nky2AYVkkDx6bt2cxbQ>
    <xmx:pFmyYSenbLCS2oXM3-_s7idSjLMkokapMnQep44J_eW0J3ayXYwt-g>
    <xmx:pFmyYe3RSieqYXFf0uNrwHsiK0Uv5XHw9_oWr6phKGMJ33_kBjwzTg>
    <xmx:pVmyYR6PjPyXgp5OgMeABLcD_g_d7a948Nrn7nTAyJlA4oJAILgN2Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Dec 2021 14:31:48 -0500 (EST)
Date:   Thu, 9 Dec 2021 21:31:44 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bpf: return EOPNOTSUPP when JIT is needed and not
 possible
Message-ID: <YbJZoK+qBEiLAxxM@shredder>
References: <20211209134038.41388-1-cascardo@canonical.com>
 <61b2536e5161d_6bfb2089@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61b2536e5161d_6bfb2089@john.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 11:05:18AM -0800, John Fastabend wrote:
> Thadeu Lima de Souza Cascardo wrote:
> > When a CBPF program is JITed and CONFIG_BPF_JIT_ALWAYS_ON is enabled, and
> > the JIT fails, it would return ENOTSUPP, which is not a valid userspace
> > error code.  Instead, EOPNOTSUPP should be returned.
> > 
> > Fixes: 290af86629b2 ("bpf: introduce BPF_JIT_ALWAYS_ON config")
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > ---
> >  kernel/bpf/core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index de3e5bc6781f..5c89bae0d6f9 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -1931,7 +1931,7 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
> >  		fp = bpf_int_jit_compile(fp);
> >  		bpf_prog_jit_attempt_done(fp);
> >  		if (!fp->jited && jit_needed) {
> > -			*err = -ENOTSUPP;
> > +			*err = -EOPNOTSUPP;
> >  			return fp;
> >  		}
> >  	} else {
> > -- 
> > 2.32.0
> > 
> 
> It seems BPF subsys returns ENOTSUPP in multiple places. This fixes one
> paticular case and is user facing. Not sure we want to one-off fix them
> here creating user facing changes over multiple kernel versions. On the
> fence with this one curious to see what others think. Haven't apps
> already adapted to the current convention or they don't care?

Similar issue was discussed in the past. See:
https://lore.kernel.org/netdev/20191204.125135.750458923752225025.davem@davemloft.net/
