Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBC059A962
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243422AbiHSXRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244118AbiHSXRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:17:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C6E10EEE8;
        Fri, 19 Aug 2022 16:17:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73225B8280F;
        Fri, 19 Aug 2022 23:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708DCC433D7;
        Fri, 19 Aug 2022 23:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660951028;
        bh=a6on7o8PU4t8G4WjP32E9gT9WScXwK3LS8UJ7XLnZjI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=urIjt71kdChEnFhAxhYcaOaKvKyZI7rx7eY0pmIY3p4jNlytuHh/IemZ0+DPzGg99
         xeErPMxikRMM3ZqPYhP/PryW0hVKHmS5k/On2iZtPr+zFHoQpuuLR9HU7YJao0YTMr
         hDTGjlvC2jLlHPT3Be+5nZjOMGHhgmx7RQ7A5wwxdicpHfDBaQ3PURVwKFYS5zOIb8
         FxqQfp7lm9kSNtkhoDyrapS12OyzNucn/LDTxamIxWflam0ILHEjiG/9+Vv4hE1Kmr
         BpHMMgqb08hfklES9H2bCVwXq8WAYUA5l2Ozq80gvuRXZUPXaONi10fwCDF9TfL9KO
         dSXsu26FER7lw==
Date:   Fri, 19 Aug 2022 16:17:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Jacob Keller <jacob.e.keller@intel.com>,
        johannes@sipsolutions.net, stephen@networkplumber.org,
        sdf@google.com, ecree.xilinx@gmail.com, benjamin.poirier@gmail.com,
        idosch@idosch.org, f.fainelli@gmail.com, jiri@resnulli.us,
        dsahern@kernel.org, fw@strlen.de, linux-doc@vger.kernel.org,
        jhs@mojatatu.com, tgraf@suug.ch, svinota.saveliev@gmail.com,
        rdunlap@infradead.org, mkubecek@suse.cz
Subject: Re: [PATCH v2 2/2] docs: netlink: basic introduction to Netlink
Message-ID: <20220819161706.53c82915@kernel.org>
In-Reply-To: <874jy89co7.fsf@meer.lwn.net>
References: <20220819200221.422801-1-kuba@kernel.org>
        <20220819200221.422801-2-kuba@kernel.org>
        <874jy89co7.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 14:54:48 -0600 Jonathan Corbet wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > Provide a bit of a brain dump of netlink related information
> > as documentation. Hopefully this will be useful to people
> > trying to navigate implementing YAML based parsing in languages
> > we won't be able to help with.
> >
> > I started writing this doc while trying to figure out what
> > it'd take to widen the applicability of YAML to good old rtnl,
> > but the doc grew beyond that as it usually happens.
> >
> > In all honesty a lot of this information is new to me as I usually
> > follow the "copy an existing example, drink to forget" process
> > of writing netlink user space, so reviews will be much appreciated.
> >
> > Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > --
> > Jon, I'm putting this in userspace-api/ I think it fits reasonably
> > well there but please don't hesitate to suggest a better home.  
> 
> That seems like a fine place for it - this is an addition that, I think,
> a lot of people will welcome.
> 
> A couple of nits, feel free to ignore them:
> 
>  - Do you plan to add other netlink documents to that directory in the
>    future?  If not, I'd just make a netlink.rst and not bother with the
>    directory and index.rst.

I do - I'm working on creating protocol specifications (what operations
and attributes family has) in YAML, and at the very least I'll have to
document how to use those specs. And there needs to be some
documentation for the attribute formats.

I've also enlisted help of Peter of the pyroute2 fame to write a Sphinx
plugin which would render the documentation from the YAML specs into
this directory...

>  - I'm not sure that all the :c:member markup buys enough to be worth
>    the clutter.

Right :( I could swear it worked for me in the sk_buff docs, here it
does not actually link to the documentation of the type :S I do like
the consistent formatting tho, so I think I'll keep it either way.

> Regardless, should it be worth something:
> 
> Acked-by: Jonathan Corbet <corbet@lwn.net>
> 
> Thanks for doing this; I've been meaning for years to reverse-engineer
> netlink and write something like this, now I don't have to :)

Thank you! :)
