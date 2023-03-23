Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A526C5F7C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 07:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjCWGJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 02:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjCWGJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 02:09:40 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292305FE2
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 23:09:39 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id DB2CA320091D;
        Thu, 23 Mar 2023 02:09:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 23 Mar 2023 02:09:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1679551777; x=1679638177; bh=E3
        SAW9Sy9deLcg5f1PFdImyGzI8X5ylryD7ed4hMqm4=; b=dUESN/LQS3r6t4Cyi2
        fwMabWxWc8YWY/PgLpfSB9EOz2lCGmTIIkTDvx2G5EwK3CDlovmrmg1dISAcf0++
        7hOfszsYo5E8MQe60ZU+aaWI0Cc7oGPz6fIyWaaQID6+R8e7t+jpDglmya3rP4Qf
        16/OCUuZgf/owtq/P/Ao0zIqVMrnUikCo9pwkK+6QrnWt4sD1bbko3JFHMO0o69/
        83fgW5HvxdXhejsv399xXTOZUuej0hfkgVp5Sh6isfBS1J9cduhdiDUQkAf28FRk
        Wem0ZMUix887F9CJ4DZL7KgIe3MOiOGB36SWwuOuRtnO+EPdwlXGBqA3lNszwAYe
        sJ5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1679551777; x=1679638177; bh=E3SAW9Sy9deLc
        g5f1PFdImyGzI8X5ylryD7ed4hMqm4=; b=aWJS28UpXvQr9Fc95wb38afDk5Ajj
        /cOjXMTot9eG6oUvPw87Wr+td/BNUxolF3nDvICHRjmhP86d/dBBqiNSkQ/UxfSp
        drTtxlqSskLI9GQrVctUcY7ejcM0hQK8ym17EAiA7urzSal3YdXuGJepaaHcHz4B
        W+QBbbzvhv414xX4+Of99NC8oMaldSGfiFmBlu5Viz4w50T5aFIUVOBRWCg72zmc
        9j7Rm7qEV7y0UstVr1BlVotK0EWCu4wMUUfGE3N7YxfZBggYn4HUVZsRhUGKO67v
        8u5dGxS9j8ZcuksnvCRDQb7MsjbxPe6i/O8M4+3wUhOaOh5IepboJgrVA==
X-ME-Sender: <xms:Ie0bZOGqPDc2Mfie2iF4mcgbdDJVXEH08cNydn4zdzXq4G3IjZEIGQ>
    <xme:Ie0bZPUDvfMdCuPuM--aYoFJM-yy6XCqt4tebAU1_vclEDTuH9UM38HYEzVv9Yvod
    skY_9vMbZjSyY04ezo>
X-ME-Received: <xmr:Ie0bZIIlRayO4iKSUhcAS22h-3ZSvISCnqDBJbFLM1YJrx-Oa99m4F5V78TuWrR9TfKH-3U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdegfedgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdluddtmdenucfjughrpehffgfhvfevufffjgfkgggtsehttdertddt
    redtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhishhhkhhinhcuoehvlhgrughimh
    hirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrghtthgvrhhnpeeigfdvgeeiieel
    udehueeuueejieeiheegudevhffggeeguddvveduueehueefgeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehvlhgrughimhhirhesnhhikhhi
    shhhkhhinhdrphif
X-ME-Proxy: <xmx:Ie0bZIEw3w0fOfLyGHe2HqZ519T_SQKYJ34a0abKXZr0XHrUiCuw0w>
    <xmx:Ie0bZEVRyz7IX2l8uGbevAms1ScAq67goj0HUMtP9UmkSWMvRGEVCw>
    <xmx:Ie0bZLM0GKpWlX6ZkoEllJuYrjtlT_gUInVWOadFoos7t7DU9-b8fw>
    <xmx:Ie0bZHF1c_pOkkuo90Qf1uZpAcq3976S7mWn0sptQbG9Iov2JOQC6Q>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Mar 2023 02:09:33 -0400 (EDT)
References: <20230322070414.21257-1-vladimir@nikishkin.pw>
 <ZBq7yv0W5MqhqYnm@shredder>
 <928a2124-e8c8-471f-feda-0651d6465e57@blackwall.org>
User-agent: mu4e 1.8.6; emacs 29.0.50
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
        gnault@redhat.com
Subject: Re: [PATCH net-next v4] vxlan: try to send a packet normally if
 local bypass fails
Date:   Thu, 23 Mar 2023 14:07:22 +0800
In-reply-to: <928a2124-e8c8-471f-feda-0651d6465e57@blackwall.org>
Message-ID: <875yasgfs6.fsf@laptop.lockywolf.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Nikolay Aleksandrov <razor@blackwall.org> writes:

> On 22/03/2023 10:26, Ido Schimmel wrote:
>> On Wed, Mar 22, 2023 at 03:04:14PM +0800, Vladimir Nikishkin wrote:
>>> --- a/Documentation/networking/vxlan.rst
>>> +++ b/Documentation/networking/vxlan.rst
>>> @@ -86,3 +86,16 @@ offloaded ports can be interrogated with `ethtool`::
>>>        Types: geneve, vxlan-gpe
>>>        Entries (1):
>>>            port 1230, vxlan-gpe
>>> +
>>> +=================
>>> +Sysctls
>>> +=================
>>> +
>>> +One sysctl influences the behaviour of the vxlan driver.
>>> +
>>> + - `vxlan.disable_local_bypass`
>>> +
>>> +If set to 1, and if there is a packet destined to the local address, for which the
>>> +driver cannot find a corresponding vni, it is forwarded to the userspace networking
>>> +stack. This is useful if there is some userspace UDP tunnel waiting for such
>>> +packets.
>> 
>> Hi,
>> 
>> I don't believe sysctl is the right interface for this. VXLAN options
>> are usually / always added as netlink attributes. See ip-link man page
>> under "VXLAN Type Support".
>> 
>> Also, please add a selftest under tools/testing/selftests/net/. We
>> already have a bunch of VXLAN tests that you can use as a reference.
>> 
>> Thanks
>
> Right, that is what I meant when I suggested making it optional.
> Sorry for not being explicit. Please use vxlan netlink attributes.
>
> Cheers,
>  Nik

Sorry for misunderstanding. I have send two patches to the mailing list,
one for the kernel, and one for the ip-link. If this is the correct way
to do it, I will write a test case. I wouldn't want to test something
which is incorrect by design. Sorry for so many wrong attempts.

-- 
Your sincerely,
Vladimir Nikishkin (MiEr, lockywolf)
(Laptop)
--
Fastmail.

