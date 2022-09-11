Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928505B5040
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 19:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiIKR0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 13:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIKR0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 13:26:47 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE1C9FF8;
        Sun, 11 Sep 2022 10:26:45 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 628DD5C0114;
        Sun, 11 Sep 2022 13:26:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 11 Sep 2022 13:26:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1662917202; x=1663003602; bh=MBOUayWj+N
        jcGUjEpse8JVxeT00YM4+lBCIWidSYzDI=; b=SthgmOhB7x2aMqLjnfZL+GIiSn
        tJBcX95UVYaIm5U9fN48h5YtynuzLe6Wa/89UARX6Dn+BPJauBX7fNcdZUQNr1rJ
        oNx1rn39XKyjkcFYwwxVoDaZtz4e2cuKau0SYuaMWcodwVH9wyO/9AS6SQGTf5mu
        H0dJT5N4yGYCY2YXXwBnbzNSScnwY06Oyhw6PRFn0O0Vhg1o+V9T1nrtXXIElZVr
        FvZ6Lg924HArftF4PBZCOrIuAg/ohRZ2abXiHc4zlkDiI1hCYuthmnOGtC3WBLIN
        FXaVeAkTr0IWw+fdZmShVksY25jNJWCU+xar/+yKBeUyUIBS+IiseHTB9vqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1662917202; x=1663003602; bh=MBOUayWj+NjcGUjEpse8JVxeT00Y
        M4+lBCIWidSYzDI=; b=qy7jrtjno6aZhG3s4pOt/EoCLQ/tyV9OlvTLqP0DoTJJ
        /wdNmb/asuYe7MdZWE+UuAg+eE8qhPv1DUfDw2ybI3MFn5MVdxAnqUSJUgpj7Mbw
        rbkA31NuhL5ZSMaTZ4dcgcIn9+3KzpNyYYL/99k1y6rki2+l9TkKtz/LmIKmtfVx
        OCtnzaUF82ERc2C2L/uT42PL4DQ2LOU/Y4Znbup08dwkzVv2iLlz2HgxuZWjG7iF
        oznlZJeFdZ4vMantZWQJJFVMZtiJhtWvsU9nXYRtIOABzhV6Jobrnt1n9f5ZrYiZ
        OV/jOT2tW3DGggKSGqh0MQp7Jj8FTaiAN2/Q5RUVqQ==
X-ME-Sender: <xms:URoeY7kMFJ5K8Uw5MxYqPQdAcSDaqHCICz8hN0g2kz9g0yD-gS1DZA>
    <xme:URoeY-28ecJWIOyFXBhYdpeJ1TPSfmhWuMy1JSCd8eT2gtXKzBz3ryQZD43WCxJnN
    oDgYxNDGIJhh5O5gA>
X-ME-Received: <xmr:URoeYxq3btW0evAm1xePgyaCoKRN4OfXUVnlztEr9vlCaJX48SF_Jqr96Cs3LcTMPfd0ZnU1qwy3EHqIEih5H5Y9Gsk9fmY6YTMPy5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedutddgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdefhedmnecujfgurhepff
    fhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpeevuddugeeihfdtff
    ehgffgudeggeegheetgfevhfekkeeileeuieejleekiedvgfenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:URoeYzm-gPU5ExdBLS1A04bwf_WLiDRoXhPDmg1i7TY6u4YgIt1cSQ>
    <xmx:URoeY534hzlXyX-dp7Kd4xJUTJrIUiu_hzyVdujt_5w84ecQQl9n9w>
    <xmx:URoeYyuF5H-bfcWd4P3O2wI4rT_HH25WyAdfh7qP1bMmq07837p-hA>
    <xmx:UhoeYyvsAcNB1exoxpfqyL_ye9wJ2osVRfAJh57buTsEKCm96jRjiQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Sep 2022 13:26:39 -0400 (EDT)
Date:   Sun, 11 Sep 2022 11:26:36 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 0/6] Support direct writes to nf_conn:mark
Message-ID: <20220911172636.rq7makycmwvlwmhc@kashmir.localdomain>
References: <cover.1662568410.git.dxu@dxuuu.xyz>
 <CAP01T77JFBiO84iezH4Jh++vu=EEDf63KepK_jKFmjgjrHPgmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP01T77JFBiO84iezH4Jh++vu=EEDf63KepK_jKFmjgjrHPgmw@mail.gmail.com>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kumar,

On Sat, Sep 10, 2022 at 02:27:38AM +0200, Kumar Kartikeya Dwivedi wrote:
> On Wed, 7 Sept 2022 at 18:41, Daniel Xu <dxu@dxuuu.xyz> wrote:
> >
> > Support direct writes to nf_conn:mark from TC and XDP prog types. This
> > is useful when applications want to store per-connection metadata. This
> > is also particularly useful for applications that run both bpf and
> > iptables/nftables because the latter can trivially access this metadata.
> >
> > One example use case would be if a bpf prog is responsible for advanced
> > packet classification and iptables/nftables is later used for routing
> > due to pre-existing/legacy code.
> >
> 
> There are a couple of compile time warnings when conntrack is disabled,
> 
> ../net/core/filter.c:8608:1: warning: symbol 'nf_conn_btf_access_lock'
> was not declared. Should it be static?
> ../net/core/filter.c:8611:5: warning: symbol 'nfct_bsa' was not
> declared. Should it be static?
> 
> Most likely because extern declaration is guarded by ifdefs. So just
> moving those out of ifdef should work.
> I guess you can send that as a follow up fix, or roll it in if you end
> up respinning.

Hmm, I don't see how filter.c ever #include's nf_conntrack_bpf.h. So
you'd think that the warning would always be present regardless of
CONFIG_NF_CONNTRACK setting.

FWIW I can't reproduce the warning even with CONFIG_NF_CONNTRACK=n.

Maybe the extern declarations should be in include/linux/filter.h
anyways? Might be cleaner. WDYT?

> Otherwise, for the series:
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Thanks!

Daniel
