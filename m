Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A981A6922B8
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjBJPzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjBJPzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:55:49 -0500
X-Greylist: delayed 1201 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Feb 2023 07:55:49 PST
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9E34B749;
        Fri, 10 Feb 2023 07:55:49 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.nyi.internal (Postfix) with ESMTP id DEAF7581F63;
        Fri, 10 Feb 2023 10:10:36 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 10 Feb 2023 10:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1676041836; x=1676049036; bh=mnmCFBnaIP
        +vBLu9FDqlvqV872F6Sk8/lQSQWnrc9vM=; b=D9Szpp77tFpcX+nFzNso9fAK0G
        RKEY2e2MPcUw+e0HRg7S8ntVkkidfPRiVKiD9NnN/v5CGK69+T3Jead5T43+elxp
        vdEvp0H3wpqmSvLp/EsSqJCUQp8vrbFlGhuwOBExHvxH/ijlvcebCIxq0GFKALZn
        /KTXa55Xl1Nu1lYEE3YUdxKlBRHd9g6snyVPVw7lBXBFuN6X5R9KweBbGyws612U
        HSSwAquhkWClD1qjztFmKSXMeUBJTYaykthTjsQv9cEQMLG0X1HQBvbnyPaoEUzh
        c2j/S3bzXdpbQJtLfGhIn6moBc6uAsb7y1NxF05WugoRrHamBqi8vnM8+LIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676041836; x=1676049036; bh=mnmCFBnaIP+vBLu9FDqlvqV872F6
        Sk8/lQSQWnrc9vM=; b=RHZtaJBO44uX2MARKJxLjffrlpmpVpqRWXHbD0f++4hp
        qcrXlaKY1EA4C+ei9VBulYS+Pr1PaCMRoCiXza+fjmuBbIl7iAHJIIs/u5u04ZwR
        un7ChSUzuQGzTl3Hzcn3+ASNHPbKVMq2pMRwmYsQFsty5c0tZWbMgH4X111G4rXx
        xrYr3PGq6SNbkC1K18wAFFhEzQ4/Mu6MdjeZ0isXHr9XDxecB4/Wj99dyzjdUByn
        eT3ZTxOyQt5xhBlFYcZRRNcG22TQLymxVnFTJ3lR0b/zX8cKrE9YnBJWzellYQHC
        EsEl6lMz3XBzK0jy4OMsMTgRDCrxfrIC1I9MkjiqHw==
X-ME-Sender: <xms:a17mY3P--ZnY9B0YNPVJei5M1XSljO-TrXiC-otvZu9e2Ux-mUMuYw>
    <xme:a17mYx_FBr6stanlZSHdjEh_Yiizs7DAQDRo8eLwZjm4itklqm-Us_lyX4UcEEqKV
    lc2GJafFQdTJPXBJdE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudehhedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:a17mY2Qg8I9CgxEscmfW_KVeyAfpnzZW3vSqA_Kax6WR9loxG21lZw>
    <xmx:a17mY7sOa99lDqlxfSrIsA34dub4d_dg1GrUC46fm4OCcg0OSUjgZQ>
    <xmx:a17mY_cLeUpfTHmXPpf5NVLlLOlkwFqtmEf2CkzJAFgsXIq3rY2cJw>
    <xmx:bF7mYzlxhpbpL2dPNp2_IA_FqJ-2rZBBDGc_SPVtMY4KfbLAmmmu4A>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 2C9A9B60086; Fri, 10 Feb 2023 10:10:35 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-156-g081acc5ed5-fm-20230206.001-g081acc5e
Mime-Version: 1.0
Message-Id: <7493f543-bf02-4bfe-90bd-a01d3c52cb52@app.fastmail.com>
In-Reply-To: <2344ac16-781e-8bfa-ec75-e71df0f3ed28@redhat.com>
References: <1446579994-9937-1-git-send-email-palmer@dabbelt.com>
 <1447119071-19392-1-git-send-email-palmer@dabbelt.com>
 <1447119071-19392-4-git-send-email-palmer@dabbelt.com>
 <2344ac16-781e-8bfa-ec75-e71df0f3ed28@redhat.com>
Date:   Fri, 10 Feb 2023 16:10:16 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Thomas Huth" <thuth@redhat.com>,
        "Palmer Dabbelt" <palmer@dabbelt.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
Cc:     "Alexander Viro" <viro@zeniv.linux.org.uk>,
        aishchuk@linux.vnet.ibm.com, aarcange@redhat.com,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        "Baoquan He" <bhe@redhat.com>, 3chas3@gmail.com, chris@zankel.net,
        dave@sr71.net, dyoung@redhat.com, drysdale@google.com,
        "Eric W. Biederman" <ebiederm@xmission.com>, geoff@infradead.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@kernel.org>,
        iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org,
        "Josh Triplett" <josh@joshtriplett.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        "Max Filippov" <jcmvbkbc@gmail.com>, paulmck@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, "Thomas Gleixner" <tglx@linutronix.de>,
        vgoyal@redhat.com, x86@kernel.org,
        "David Howells" <dhowells@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 03/14] Move COMPAT_ATM_ADDPARTY to net/atm/svc.c
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023, at 15:55, Thomas Huth wrote:
> On 10/11/2015 02.31, Palmer Dabbelt wrote:
>> This used to be behind an #ifdef COMPAT_COMPAT, so most of userspace
>> wouldn't have seen the definition before.  Unfortunately this header
>> file became visible to userspace, so the definition has instead been
>> moved to net/atm/svc.c (the only user).
>> 
>> Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
>> Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
>> Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

It took me a bit to figure out why there is a separate command
code but no special handler for the compat structure, aside from
being in the wrong file it does look correct.

>> +#ifdef CONFIG_COMPAT
>> +/* It actually takes struct sockaddr_atmsvc, not struct atm_iobuf */
>> +#define COMPAT_ATM_ADDPARTY _IOW('a', ATMIOC_SPECIAL+4, struct compat_atm_iobuf)
>> +#endif

We could actually drop the #ifdef here as well, or moving into
the existing #ifdef.

>> +
>>   static int svc_create(struct net *net, struct socket *sock, int protocol,
>>   		      int kern);
>
> The CONFIG_* switch is still there in the atmdev.h uapi header ... could 
> somebody please pick this patch up to fix it?

It should get merged through the netdev tree, as Chas does not have
a separate git tree for drivers/atm.

I don't know what happened to the rest of the series, but if there are
additional patches that got lost, merging them all through either the
asm-generic or the mm tree would work as well.

Any chance you or Palmer could rebase the series to 6.2-rc and
see what remains?

    Arnd
