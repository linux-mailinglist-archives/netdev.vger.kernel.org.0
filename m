Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0E866209F
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbjAIIxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236827AbjAIIwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:52:35 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF56F13F4B;
        Mon,  9 Jan 2023 00:45:10 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id C26E05C0105;
        Mon,  9 Jan 2023 03:44:59 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 09 Jan 2023 03:44:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1673253899; x=1673340299; bh=L1F91mJJga
        KEg4dA8VxYJyoEo2s3t1TaV8Gb51DrVJU=; b=c+yD51YQT1KcIPDSyG+sEiRosP
        SOi1ni3XbV0xomqi04Ch8TVCuQJ3B/QItBmlGAOAQwu5KzimWGwhc2srPMKvACX6
        N7ax/LAtlIhf+znFdLRoiR6StDyX54QVHS6p9hH+MMk33PEmgZQIUNx5xfbIPu6H
        /uLR6lHuxn2KTV4tz01v++x8nZm0mReVXtw1eM1dRXVQjZibM9vK7zuhzewdG9nT
        VleYvpbxIxt3zZxc1SEd6pYjuV/JamyD0glpFtwB2F9Z+SrWW5HNitBaoCIOYUaZ
        g3BUYm7Dlc0OPVjHXbIyjvNLY5htnPQSQqIVPJZSufXEzPkByLv+JtvMcaeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1673253899; x=1673340299; bh=L1F91mJJgaKEg4dA8VxYJyoEo2s3
        t1TaV8Gb51DrVJU=; b=ZiKrV3MFCykUfVE8xmG3AHGV8oJHU/cBsh2dQ40lItqJ
        AidADxCuYx0p5qzZEyIodeCHoN6lc713IUjk3jnLTGuzH1Hlm1gVsUbuMxqr/N9J
        thttf859jCtUzYZdzmCt957Ya5B/oJbkdQ5u9QjNWEpWLpHqLwZvT4PZ+dD0YuXc
        hfMoz8AmVz1enhCbxcbBuB4S2NbhTrblbrSp5tzDRMCanVxO0PY5fTsPC5kHc+39
        6g1K1nhu8+Ulzx1TPPUmLaiIX+rUqTC+jLmTbsIAVsgkgR1ucXhQM+oettAmpCiG
        rJ/ifu3rwbSR6gRf3x1FC5FuZhQg2FIFnCJLX/nobA==
X-ME-Sender: <xms:CtS7YxoHtx6hBDXGY9xaHF_cIlwngqsvDWAsLZJJWrft_oFWFH6oyw>
    <xme:CtS7Yzp-PeQ6HfG3PFv6SEZ73GXpK74SOS-VjsY_J9RFz59kV6XFtDFuQHlgm9QCg
    MT35paLjK3qxb5yGdc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrkeehgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:C9S7Y-Mybw79_IvAt8yeEtEICRMgaJCiN4CxUNL0SxccioUi9oWXZg>
    <xmx:C9S7Y84IOBXkKL72V9YA6SAa7SSyk5TXTUeeVAtk9kFnasWxkwAgGg>
    <xmx:C9S7Yw6Y8F7TwRXetSPyFlfjwvI57X9X7WZfhuhBfTlyKN1GvfPN9A>
    <xmx:C9S7Y_YKS1MRRAkDIclVe8aoNSkHStLU1FA1zSPRCNJJ9zXhOux08Q>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E992AB60086; Mon,  9 Jan 2023 03:44:58 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1185-g841157300a-fm-20221208.002-g84115730
Mime-Version: 1.0
Message-Id: <c44bd7e8-68ff-44f8-b50b-4d27b4fe29dc@app.fastmail.com>
In-Reply-To: <ad6efc07-1706-a8e2-1478-45124838a043@kernel.org>
References: <20220818004357.375695-1-stephen@networkplumber.org>
 <07786498-2209-3af0-8d68-c34427049947@kernel.org>
 <po9s7-9snp-9so3-n6r5-qs217ss1633o@vanv.qr>
 <ad6efc07-1706-a8e2-1478-45124838a043@kernel.org>
Date:   Mon, 09 Jan 2023 09:44:38 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Jiri Slaby" <jirislaby@kernel.org>,
        "Jan Engelhardt" <jengelh@inai.de>
Cc:     "Stephen Hemminger" <stephen@networkplumber.org>,
        Netdev <netdev@vger.kernel.org>,
        "David Ahern" <dsahern@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Nicholas Piggin" <npiggin@gmail.com>,
        "Christophe Leroy" <christophe.leroy@csgroup.eu>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>, "Borislav Petkov" <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Neeraj Upadhyay" <quic_neeraju@quicinc.com>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        "Damien Le Moal" <damien.lemoal@opensource.wdc.com>,
        "Muchun Song" <songmuchun@bytedance.com>,
        "Akhmat Karakotov" <hmukos@yandex-team.ru>,
        "Antoine Tenart" <atenart@kernel.org>,
        "Xin Long" <lucien.xin@gmail.com>,
        "Juergen Gross" <jgross@suse.com>,
        "Hans de Goede" <hdegoede@redhat.com>,
        "Nathan Fontenot" <nathan.fontenot@amd.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Suma Hegde" <suma.hegde@amd.com>, "Chen Yu" <yu.c.chen@intel.com>,
        "William Breathitt Gray" <vilhelm.gray@gmail.com>,
        "Xie Yongji" <xieyongji@bytedance.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        "Alexandre Ghiti" <alexandre.ghiti@canonical.com>,
        "Chuck Lever" <chuck.lever@oracle.com>,
        "Jeff Layton" <jlayton@kernel.org>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        "Nikolay Aleksandrov" <razor@blackwall.org>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Menglong Dong" <imagedong@tencent.com>,
        "Petr Machata" <petrm@nvidia.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Roopa Prabhu" <roopa@nvidia.com>,
        "Yuwei Wang" <wangyuweihx@gmail.com>,
        "Shakeel Butt" <shakeelb@google.com>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Wang Qing" <wangqing@vivo.com>, "Yu Zhe" <yuzhe@nfschina.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH net-next] Remove DECnet support from kernel
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 9, 2023, at 09:34, Jiri Slaby wrote:
> On 09. 01. 23, 9:14, Jan Engelhardt wrote:
>> On Monday 2023-01-09 08:04, Jiri Slaby wrote:
>
> Right, we used to keep providing also defines and structs in uapi 
> headers of removed functionality. So that the above socket would 
> compile, but fail during runtime.
>
> I am not biased to any solution. In fact, I found out trinity was fixed 
> already. So either path networking takes, it's fine by me. I'm not sure 
> about the chromium users, though (and I don't care).

Chromium and some of the others look like automatically generated
lists of files and the rest seem to have compile-time checks.

From a brief look at all the packages in the debian codesearch
link you provided, I don't see any that are likely to cause
problems aside from trinity.

    Arnd
