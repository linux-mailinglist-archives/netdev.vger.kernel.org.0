Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7446D7B50
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 13:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbjDEL3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 07:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237919AbjDEL3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 07:29:18 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D185BAB
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 04:29:11 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D6945C01BC;
        Wed,  5 Apr 2023 07:29:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 05 Apr 2023 07:29:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1680694148; x=1680780548; bh=KB
        cLYYmEXwWAHbj6ZFbS4JCjQBeFXBjB2zedfp7MWjc=; b=aU57HbcmEj70y81Yca
        fMWosph9gYkiGJK4Ukd1AuZ8lMoIiff2pWalotiMhCOb52HopuH5BFt+2op6/kFF
        70otAUV34SMYnJHo+Ml1t/X2gUB06REQyoYQuraIQw+kA5XvhmJcvNHnGHIhGHAh
        E4TAIyhvqi/8JpMXF/IskBTqmSAXWM6JTuhx9GAtZH8klaxAcidVVFJIlY2m7OXw
        7lIJrmGExNoi4a3Qr07apzzta5bPCHpCjyiPGLWjsNtj6EerTRqmcnpYPgh6iVTn
        YuW2uU0ZVwN7Pdt8ROKqKUJ24U089PF51YGcN25aVXSs6eLwWzyMp5TdrL+GbQ9A
        fGMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680694148; x=1680780548; bh=KBcLYYmEXwWAH
        bj6ZFbS4JCjQBeFXBjB2zedfp7MWjc=; b=BkKTB7cyAUZZKdhVfOUB7d2cXNlkL
        tRrho7+5aJMp28GMJWHdB6VZo6BMaNAB6Xvv5XJtYPDhLcgoss/X30TGE31N9+vy
        Kc8uw6jkwANEpU9toDERzPz4Am4BD9DANr4kskmXXVALDC+Ey7q4IQcDSHSgST2L
        7Qkto5X0nO0OEubShNncEwL05doY8L1aRXVjr2ks2jPVN/BUIeIP2D+AwelusY6a
        81w/c+jSb9owGP/nxklF6QvpHCOFk2D8hWg4SUoaheqp/zMPwFcboeFWKI+vuqtj
        H4U2+24cileMebKUh63JYD8HmZxRtjbHGYS14L7O/49N73nxODDhE/rdA==
X-ME-Sender: <xms:hFstZH1payAlkSIOFafpY5vh5BEYfIRivuZXfAmD1V7lPMTcAOHl9A>
    <xme:hFstZGFUtDscCZTPHE7JWLpjmd7nSzkqEw-Iwb1K8ifcerQi53VBLjMAcED1jtqBb
    cfT8pYB6qZNUxcjrE4>
X-ME-Received: <xmr:hFstZH5rY06g6XQnIzZXO1aSFJCelEFsBVkB34zJ9er8CpyLUOa8gs_mBt4MeN2KqcEO2Yl8Hns>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejuddggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdluddtmdenucfjughrpehffgfhvfevufffjgfkgggtsehttdertddt
    redtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhishhhkhhinhcuoehvlhgrughimh
    hirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrghtthgvrhhnpeeigfdvgeeiieel
    udehueeuueejieeiheegudevhffggeeguddvveduueehueefgeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehvlhgrughimhhirhesnhhikhhi
    shhhkhhinhdrphif
X-ME-Proxy: <xmx:hFstZM1k81O4Eu8ly_w4WO-uQov-cG2wYEx9tp25t_vWE8pd8aZrXA>
    <xmx:hFstZKHdcVqq7DcC2bukCZ7gO4HVWs8U_eoDdu6yD9G74PWwaocnkA>
    <xmx:hFstZN-f7D4vgMeE4zVmuzWg6I_BcIHtbhrJlzD5Ho0cteotLVwfAw>
    <xmx:hFstZN24zx8L-7K84HwwT9cmcLaq0fGkl5YAr1-Kov_4FI45N1boBg>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Apr 2023 07:29:05 -0400 (EDT)
References: <20230323042608.17573-1-vladimir@nikishkin.pw>
 <ZBxycrxU93mhgkAT@corigine.com> <87o7o2vrd0.fsf@laptop.lockywolf.net>
 <ZC1LYEp8anZWkRFq@corigine.com>
User-agent: mu4e 1.8.14; emacs 30.0.50
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
        razor@blackwall.org
Subject: Re: [PATCH net-next v5] vxlan: try to send a packet normally if
 local bypass fails
Date:   Wed, 05 Apr 2023 19:24:56 +0800
In-reply-to: <ZC1LYEp8anZWkRFq@corigine.com>
Message-ID: <878rf6va81.fsf@laptop.lockywolf.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Simon Horman <simon.horman@corigine.com> writes:

> On Wed, Apr 05, 2023 at 01:05:02PM +0800, Vladimir Nikishkin wrote:
>> 
>> Simon Horman <simon.horman@corigine.com> writes:
>> 
>> > I'm a bit unsure about the logic around dst_release().
>> > But assuming it is correct, perhaps this is a slightly
>> 
>> Let me try to defend this logic.
>> 
>> In the previous version, if the destination is local (the first "if"),
>> then there is no need to keep the address in memory any more, hence the
>> address was free()'d at the beginning of the "if" (and was not freed
>> after the "if", because the address was still needed at the userspace
>> part.)
>> 
>> With this patch, the "localbypass" creates one more branch inside that
>> "if", which is handing over the processing logic to the userspace (which
>> has no free()). The older two branches _inside_ the "if" (vxlan
>> found/vxlan not found) are still terminating, and therefore have one
>> call to free() each.
>
> Hi Vladimir,
>
> thanks for your response.
>
> I do still feel that the code I proposed is slightly nicer
> and in keeping with general kernel coding practices.
> But I do also concede that is a highly subjective position.
>
> I do agree that your code is correct, within the scope of what the patch
> seeks to achieve.  And I do not object to you keeping it as is if that is
> your preference.
>
> ...

Hello, Simon

I have integrated all of your suggestions in v6. This response was only
to justify the correctness of the dst_release() call, which is not a
self-evident thing.

-- 
Your sincerely,
Vladimir Nikishkin (MiEr, lockywolf)
(Laptop)
--
Fastmail.

