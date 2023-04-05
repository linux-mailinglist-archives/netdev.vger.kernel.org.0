Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EDA6D73B2
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 07:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbjDEFYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 01:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDEFYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 01:24:14 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8533C0A
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 22:24:13 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4A8F43200986;
        Wed,  5 Apr 2023 01:24:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 05 Apr 2023 01:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1680672251; x=1680758651; bh=Kl
        QnGU7QmA/EC6XNHygbudA8yWjsyJUeQJXilc11so8=; b=dO4EEWxYr5H+Zcbgd1
        p0KFaOJFK3HhbgunWaLixk5QbVcezgc7qLJqBGDKu97HB8FG/p4k+KPHUKBuuTwl
        bGQup++YTjjpecmR0L8mrgiL2rNSxasmPZp0m//ZuqyQyVPO5zKMvafDZfKw12MN
        Hj3Y5hra44T6pz9iWd6LL5XdCvK3JZJyc+MH/DalwcT+dXLF0m3gbsnj5OSHHLD/
        55PsCpi8eF2E2bmHvx1q0VkN6Sgq2Ue2/vUCyGfTBaMBmJgbRoNqsbn6fsAPzkdh
        rZPTBWnLhBn2twzxLkeULp5BigIS5JcS0FeQvKgbptKpnv9/dcrfTB+5oNEeI2lm
        heHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680672251; x=1680758651; bh=KlQnGU7QmA/EC
        6XNHygbudA8yWjsyJUeQJXilc11so8=; b=HleWxGMdV0iPZyBSB4Kl3jABt8Ol/
        zK7f9jpmuUHfo7zVxGKK/yNy2bWxOSLtE6/cEP0tBMx4xwAxepIaDwUR/nHPUm7j
        pc2FSfJZIefxeQ1mXVjIXYSJQl5NyDCTxojb/6q4UD+KjA3jL4TLzbSAj4/C8X+S
        c0OUL/xvHlhzV6ktbHSBGdLK4NffoOhSVcE1M5jNgJHpuj5YahVGdJTuU5amtFoV
        hCR5IpGw68dSunzlk/oMair1ZDrzCBOp2z8Cy/mWHJrOhTh2zpRBue28/qb0e+bE
        zpB0ZO4kUG9k1/fzksVdfuClALYn6SwdrfdFOrj0gzXsuTLAWBRz79Rug==
X-ME-Sender: <xms:-wUtZDjX1cNETvjgw1sAqEc6kzAJbp2mCPsccIfC9K6z2NAdncVngA>
    <xme:-wUtZAAP_8Al65IN8YaXVwO7FgP5eq4yZgg7EcrASjnuFHPmXWRV0in9Y3voIUXoe
    V2lkiLoTOSLExdE-Ko>
X-ME-Received: <xmr:-wUtZDG7cx-VnmS0JKDOs2ECocbGy5LP3NbQrvMJE-5geQvlvsTFuWbcBbvX7B-v1heiL72ADQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejtddgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdluddtmdenucfjughrpehffgfhvfevufffjgfkgggtsehttdertddt
    redtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhishhhkhhinhcuoehvlhgrughimh
    hirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrghtthgvrhhnpeeigfdvgeeiieel
    udehueeuueejieeiheegudevhffggeeguddvveduueehueefgeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehvlhgrughimhhirhesnhhikhhi
    shhhkhhinhdrphif
X-ME-Proxy: <xmx:-wUtZAQmhLIPwBunRtGMty5wLeTHrdtJbjQmS_OAnACnHg2js2_AWA>
    <xmx:-wUtZAyMX3ybHsKA3jprNref7K-YAGY4OpQ4nF6CQkDMQdRSj4dZFA>
    <xmx:-wUtZG4FeNBcu1ARMWwb18RNyKcu4pKZZJfw43jkznDNrHJJCx7Zvw>
    <xmx:-wUtZFo5MdnBE6A6gf7oDnxcyWTha3LZwih51TxU15wZYbxs8pJu2Q>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Apr 2023 01:24:07 -0400 (EDT)
References: <20230323060451.24280-1-vladimir@nikishkin.pw>
 <ZBz/FREYO5iho+eO@Laptop-X1>
User-agent: mu4e 1.8.14; emacs 30.0.50
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
        razor@blackwall.org, idosch@nvidia.com, eyal.birger@gmail.com,
        jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v1 1/1 v1] ip-link: add support for
 nolocalbypass in vxlan
Date:   Wed, 05 Apr 2023 13:21:17 +0800
In-reply-to: <ZBz/FREYO5iho+eO@Laptop-X1>
Message-ID: <87ileavr4c.fsf@laptop.lockywolf.net>
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


Hangbin Liu <liuhangbin@gmail.com> writes:

> Hi Vladimir,
>
> For the subject prefix, [PATCH iproute2-next] is enough for the v1 patch.
>
> On Thu, Mar 23, 2023 at 02:04:51PM +0800, Vladimir Nikishkin wrote:
>> Add userspace support for the nolocalbypass vxlan netlink
>> attribute. With nolocalbypass, if an entry is pointing to the
>> local machine, but the system driver is not listening on this
>> port, the driver will not drop packets, but will forward them
>> to the userspace network stack instead.
>> 
>> This commit has a corresponding patch in the net-next list.
>> 
>> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
>> ---
>>  include/uapi/linux/if_link.h |  1 +
>>  ip/iplink_vxlan.c            | 18 ++++++++++++++++++
>>  man/man8/ip-link.8.in        |  8 ++++++++
>>  3 files changed, 27 insertions(+)
>> 
>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>> index d61bd32d..fd390b40 100644
>> --- a/include/uapi/linux/if_link.h
>> +++ b/include/uapi/linux/if_link.h
>> @@ -824,6 +824,7 @@ enum {
>>  	IFLA_VXLAN_TTL_INHERIT,
>>  	IFLA_VXLAN_DF,
>>  	IFLA_VXLAN_VNIFILTER, /* only applicable with COLLECT_METADATA mode */
>> +	IFLA_VXLAN_LOCALBYPASS,
>>  	__IFLA_VXLAN_MAX
>>  };
>>  #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
>
> There is no need to include the uapi header. Stephen will sync it with upstream.
>
> Hi Stephen, should we add this note to the README.devel?
>

Without this change, my code does not compile. I ended up modifying the
header, but not adding it to git. Is this the correct way of doing it?

>> diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
>> index c7e0e1c4..17fa5cf7 100644
>> --- a/ip/iplink_vxlan.c
>> +++ b/ip/iplink_vxlan.c
>> @@ -276,6 +276,12 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
>>  		} else if (!matches(*argv, "noudpcsum")) {
>>  			check_duparg(&attrs, IFLA_VXLAN_UDP_CSUM, *argv, *argv);
>>  			addattr8(n, 1024, IFLA_VXLAN_UDP_CSUM, 0);
>> +		} else if (!matches(*argv, "localbypass")) {
>> +			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);
>> +			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 1);
>> +		} else if (!matches(*argv, "nolocalbypass")) {
>> +			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);
>> +			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 0);
>
> matches is deparated, please use strcmp instead.

Why is strcmp recommended, not strncmp? I remember strcmp being frowned
upon for some potential memory bounds violations.

>
> Thanks
> Hangbin


-- 
Your sincerely,
Vladimir Nikishkin (MiEr, lockywolf)
(Laptop)
--
Fastmail.

