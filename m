Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B006B279241
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgIYUg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:36:26 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:35731 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbgIYUgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 16:36:19 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2020 16:36:19 EDT
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id E8CCB8C2;
        Fri, 25 Sep 2020 15:46:15 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute4.internal (MEProxy); Fri, 25 Sep 2020 15:46:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        stressinduktion.org; h=mime-version:message-id:in-reply-to
        :references:date:from:to:cc:subject:content-type; s=fm1; bh=qCuo
        QpCgvJl5FFBZqJAbGwHxALLtScR9/aZbYtT+lJs=; b=g03MUGsi0X/YTAdHVV5D
        9Wj8i0O2QfIeceOXKF2iU/NApN8ni8mpM/0+XAaEHYz0z/x3BTWxqLADqk8e118f
        3K/oMq4pLznM2cA3cN/9n5ZYaryjGu3oDncpLcgPqyJFjdc6NLUtKCA7fXMqzERS
        wlJHuELVv/Ks/y9epufGqOP83zqXiQYM1UZUwS5pzPfNfSJuod449fZAmZRYu2NI
        pSIKo7RgnoV3Y/oRvTJh95jlldjCmYMHfDtKdkFjY/gUmrbVd9IFtgHb449YBP65
        5qFUvU47iVOvrDaYFQFCiSDoUsCKrsrsubgmDZ2cc7Wil+qWeSX3nK3Pp422ESG5
        2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qCuoQp
        CgvJl5FFBZqJAbGwHxALLtScR9/aZbYtT+lJs=; b=mNF8GoFSR3DWsu51nlSP4Q
        +MToIQ9jyC/c/n8SGuAhwxnqcIFJGZHgdw5qAeBn+gud00ud1W/6txhlu6NrcN/E
        4GBZZ3cAfJBg+rmeP7DiUz7ktj/35bXwmenCuqjus2ZD7Orj7ArsEgVrl6rYFiEl
        pozIvDU/7RL6Ixq546rIxGkKBTq9Ict/ukmxmlnTpVEa5O+wXep91H5noTTJaiL5
        L40FaFceKuFjG+lGC0kSOn94KyU6ZU9WMR4Op9R4BKMISnJ44OOxqvLGE1AIEBNW
        1JVaqzzrfKdNH8pknGgBzylHhbpVMRmYAszVJgZ1uMnaJWB0CugWLPik3mC4Lbhw
        ==
X-ME-Sender: <xms:BkluX0Gldusylu6wyPzDmldtaZy37GvE15gsBNfmxeuBDP-soabqtA>
    <xme:BkluX9Xe3teYZPqcjhQlehk0AohC-Qi4ZICZbEngIngF7YhoGtnz-CVAiesP3PRyT
    EL9D7X595sy692p1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtgddufeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreerjeenucfhrhhomhepfdfjrghn
    nhgvshcuhfhrvgguvghrihgtucfuohifrgdfuceohhgrnhhnvghssehsthhrvghsshhinh
    guuhhkthhiohhnrdhorhhgqeenucggtffrrghtthgvrhhnpedvfffgieffvddtkeffffef
    ueelhfeivedvhfejgeeigfegtefghfeikeehheevudenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehhrghnnhgvshesshhtrhgvshhsihhnughu
    khhtihhonhdrohhrgh
X-ME-Proxy: <xmx:BkluX-KW1D_Im9SH6h8UZ7KCo5q8KRgiVE02wn0rprlHjeO0FswiwQ>
    <xmx:BkluX2G2Toa_W9-Q88b6Lb75-35EUM7a58S1gJy_f-kpyolI6znslA>
    <xmx:BkluX6WRDmPh3VAZJjEqnS4ZbvVGOP1Uj5jM3qMw1zaezQnCk4fuSA>
    <xmx:B0luX4zwujt86Sn6YdvxMyPO9ZMpHwUXvyFRKiTAdsMUjX93Zpl2AA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C7337E00ED; Fri, 25 Sep 2020 15:46:13 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.0-355-g3ece53b-fm-20200922.004-g3ece53b9
Mime-Version: 1.0
Message-Id: <2ab7cdc1-b9e1-48c7-89b2-a10cd5e19545@www.fastmail.com>
In-Reply-To: <20200914172453.1833883-2-weiwan@google.com>
References: <20200914172453.1833883-1-weiwan@google.com>
 <20200914172453.1833883-2-weiwan@google.com>
Date:   Fri, 25 Sep 2020 21:45:53 +0200
From:   "Hannes Frederic Sowa" <hannes@stressinduktion.org>
To:     "Wei Wang" <weiwan@google.com>,
        "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     "Jakub Kicinski" <kuba@kernel.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, "Felix Fietkau" <nbd@nbd.name>
Subject: =?UTF-8?Q?Re:_[RFC_PATCH_net-next_1/6]_net:_implement_threaded-able_napi?=
 =?UTF-8?Q?_poll_loop_support?=
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Happy to see this work being resurrected (in case it is useful). :)

On Mon, Sep 14, 2020, at 19:24, Wei Wang wrote:
>
> [...]
>
> +static void napi_thread_start(struct napi_struct *n)
> +{
> +	if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
> +		n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
> +					   n->dev->name, n->napi_id);
> +}
> +

The format string is only based on variable strings. To ease a quick
grep for napi threads with ps I would propose to use "napi-%s-%d" or
something alike to distinguish all threads created that way.

Some other comments and questions:

Back then my plan was to get this somewhat integrated with the
`threadirqs` kernel boot option because triggering the softirq from
threaded context (if this option is set) seemed wrong to me. Maybe in
theory the existing interrupt thread could already be used in this case.
This would also allow for fine tuning the corresponding threads as in
this patch series.

Maybe the whole approach of threaded irqs plus the already existing
infrastructure could also be used for this series if it wouldn't be an
all or nothing opt-in based on the kernel cmd line parameter? napi would
then be able to just poll directly inline in the interrupt thread.

The difference for those kthreads and the extra threads created here
would be that fifo scheduling policy is set by default and they seem to
automatically get steered to the appropriate CPUs via the IRQTF_AFFINITY
mechanism. Maybe this approach is useful here as well?

I hadn't had a look at the code for a while thus my memories might be
wrong here.

Thanks,
Hannes
