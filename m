Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B277F6D73AE
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 07:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjDEFTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 01:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDEFTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 01:19:01 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584523AB0
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 22:19:00 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 4153A320027A;
        Wed,  5 Apr 2023 01:18:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 05 Apr 2023 01:18:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1680671938; x=1680758338; bh=Op
        x2IrhrGU9rqtGc87W+Tp35z/qUnw/Fv86rLrrP0vk=; b=TYiXEPhWCx6A7P6EZj
        uZBsL12J452n6L7O2ZmDMxg0yhKt4aFzbD/Zv3bQOzXohdYi/Ed4O47mS3lDZbSD
        RNxGwFxCTRDmdLSRVX81Q9SL8vzKcgknT/qrYsCghRwi+3jcePANKTj6VVZt3N5X
        LFUCxOEhlfMabuqrPX8QFplwEDghz++GxWbCvogJc1/kWDDuZ+6/6bgWufHHaUEM
        srfjhvqwmARWL0fKPJsEBBuXvQdxlXdk9iSNyHRLU9qZNpjQXLkaNDLvHBahdM7L
        ow9rQTdsJyayCThTtDOEdgpYoLBQB/HPH9erH8vBTzl/HJ0CmjCbPsl3gsxf0kKJ
        ABWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680671938; x=1680758338; bh=Opx2IrhrGU9rq
        tGc87W+Tp35z/qUnw/Fv86rLrrP0vk=; b=itp1i5pwde7yJShiu+S9ZSr+S25ye
        SosU0y8Q5l6LuBlu/aMiGHhg8ejFJxTgp2EKGdMktn21CdO3VfujTXgragYdbWCu
        slb+l+Lg+NmLe/ATAmq7SB/tfZzllbo7LI3kTTHpFS/9X6dU0fr+MmyRnzIznkWg
        5gOWXqYVyRkT2hBuvz8SxVL0ISgNv5d7KVi/hJxtTL3yrqo4UYvFeB8C298tw9eM
        4U7gNOT8vUKjb4chyiix838+j1MX6FhsaKv1IN1DNnRKBcmVI4GLDLzmWopvZOwX
        AJwGs4cNcA5XpByjeGSz7bhgkHQaLZRZM37AH4L7dpJP+xvxwQx6q8Qzg==
X-ME-Sender: <xms:wgQtZCCGp33tiZdIk1JK-7wOFgQvEvSUCXmBw8nQ3WaVeQrOPu5j9A>
    <xme:wgQtZMj3SrBTHIr7N_FyrUdiIB4zw64q3fP9VTr9breaxyoK8IGY8ijxIp2yoiGZi
    Os6_mMqd22zzWiFkSY>
X-ME-Received: <xmr:wgQtZFmIST4I-6-f6OmQN-8yNd9JdZS7JBDOCiM2TlJEzOlg2cBcm1iJR09ahyfY40Jdcm6n4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejtddgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdljedmnecujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttder
    tdenucfhrhhomhepgghlrgguihhmihhrucfpihhkihhshhhkihhnuceovhhlrgguihhmih
    hrsehnihhkihhshhhkihhnrdhpfieqnecuggftrfgrthhtvghrnhepiefgvdegieeiledu
    heeuueeujeeiieehgeduvefhgfeggeduvdevudeuheeufeegnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepvhhlrgguihhmihhrsehnihhkihhs
    hhhkihhnrdhpfi
X-ME-Proxy: <xmx:wgQtZAxwvrrp7sAC9X2gpveH9q5YiigjmLEI7L3GruhjFkm6gHfEYw>
    <xmx:wgQtZHRBFIt-zMqr5rXcgo0gMZyv7AW8cnMp52Rut1hOqTkOeXy4ng>
    <xmx:wgQtZLayRNq_GbeFZwO-c-r15LS4E4sle2ENmOXp2KR1tYkOUyx4Mw>
    <xmx:wgQtZAQEApJiJkrnuwOlaKRcbg3ARkH7dr-DwuJQ6lHiVp_Vell8-Q>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Apr 2023 01:18:54 -0400 (EDT)
References: <20230323042608.17573-1-vladimir@nikishkin.pw>
 <ZBxycrxU93mhgkAT@corigine.com>
User-agent: mu4e 1.8.14; emacs 30.0.50
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
        razor@blackwall.org
Subject: Re: [PATCH net-next v5] vxlan: try to send a packet normally if
 local bypass fails
Date:   Wed, 05 Apr 2023 13:05:02 +0800
In-reply-to: <ZBxycrxU93mhgkAT@corigine.com>
Message-ID: <87o7o2vrd0.fsf@laptop.lockywolf.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Simon Horman <simon.horman@corigine.com> writes:

> I'm a bit unsure about the logic around dst_release().
> But assuming it is correct, perhaps this is a slightly

Let me try to defend this logic.

In the previous version, if the destination is local (the first "if"),
then there is no need to keep the address in memory any more, hence the
address was free()'d at the beginning of the "if" (and was not freed
after the "if", because the address was still needed at the userspace
part.)

With this patch, the "localbypass" creates one more branch inside that
"if", which is handing over the processing logic to the userspace (which
has no free()). The older two branches _inside_ the "if" (vxlan
found/vxlan not found) are still terminating, and therefore have one
call to free() each.

Ido Schimmel <idosch@idosch.org> writes:

> Also, please add a selftest under tools/testing/selftests/net/. We
> already have a bunch of VXLAN tests that you can use as a reference.

I have added a file
tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
, which is written on the basis of test_vxlan_mdb.sh

Some tests do have a "testing framework" for enumerating and running
tests (for example, those in ./forwarding/lib.sh), and some do not. I
have used the simplest one.

-- 
Your sincerely,
Vladimir Nikishkin (MiEr, lockywolf)
(Laptop)
--
Fastmail.

