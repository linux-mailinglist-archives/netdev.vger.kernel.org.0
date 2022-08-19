Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23A559A75C
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 23:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351911AbiHSUzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 16:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352232AbiHSUy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 16:54:58 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73018F18;
        Fri, 19 Aug 2022 13:54:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 470E3536;
        Fri, 19 Aug 2022 20:54:49 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 470E3536
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1660942489; bh=xWOa/ksnuQ0rKJ4xU7w7Png09nBZTQgTzh4LK9oTvMU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=lmDPjUw5r75Oi8Ld/z+0F8RAQ06tuatbX7gZkB/keo8BPOlBh9Ncqd00nkNCIMT2m
         978pzqkicZ/AGAmqkJeemKzm4yUM2CZO0XdTJIiwKKkF783bB3FnNf+FhWOjX/yJrT
         36OoVh6B7RTdzCBCMPStlTonCzrhMSFATzg2eEBKZ2eXvl/nM3beAGNHI8gI1tNIBc
         ciHo00cRrEnX/I6thpPCM4Wvn7NNC4KhrRZ/8iLC910KRF+V8JyoNesxfKz3Y/7edw
         eArjfHqRQ91iTHA/dPVd/ebEcUFVo9qYwc4F5RCq8vkPqopkNEDqNlKyvTGmRbEfr2
         OhM/QVkIJAvJg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        johannes@sipsolutions.net, stephen@networkplumber.org,
        sdf@google.com, ecree.xilinx@gmail.com, benjamin.poirier@gmail.com,
        idosch@idosch.org, f.fainelli@gmail.com, jiri@resnulli.us,
        dsahern@kernel.org, fw@strlen.de, linux-doc@vger.kernel.org,
        jhs@mojatatu.com, tgraf@suug.ch, svinota.saveliev@gmail.com,
        rdunlap@infradead.org, mkubecek@suse.cz
Subject: Re: [PATCH v2 2/2] docs: netlink: basic introduction to Netlink
In-Reply-To: <20220819200221.422801-2-kuba@kernel.org>
References: <20220819200221.422801-1-kuba@kernel.org>
 <20220819200221.422801-2-kuba@kernel.org>
Date:   Fri, 19 Aug 2022 14:54:48 -0600
Message-ID: <874jy89co7.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> Provide a bit of a brain dump of netlink related information
> as documentation. Hopefully this will be useful to people
> trying to navigate implementing YAML based parsing in languages
> we won't be able to help with.
>
> I started writing this doc while trying to figure out what
> it'd take to widen the applicability of YAML to good old rtnl,
> but the doc grew beyond that as it usually happens.
>
> In all honesty a lot of this information is new to me as I usually
> follow the "copy an existing example, drink to forget" process
> of writing netlink user space, so reviews will be much appreciated.
>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> Jon, I'm putting this in userspace-api/ I think it fits reasonably
> well there but please don't hesitate to suggest a better home.

That seems like a fine place for it - this is an addition that, I think,
a lot of people will welcome.

A couple of nits, feel free to ignore them:

 - Do you plan to add other netlink documents to that directory in the
   future?  If not, I'd just make a netlink.rst and not bother with the
   directory and index.rst.

 - I'm not sure that all the :c:member markup buys enough to be worth
   the clutter.

Regardless, should it be worth something:

Acked-by: Jonathan Corbet <corbet@lwn.net>

Thanks for doing this; I've been meaning for years to reverse-engineer
netlink and write something like this, now I don't have to :)

jon
