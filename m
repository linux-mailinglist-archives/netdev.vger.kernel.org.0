Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B09672D47
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 01:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjASAPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 19:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjASAP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 19:15:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A70530C8;
        Wed, 18 Jan 2023 16:15:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8912C61AA0;
        Thu, 19 Jan 2023 00:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EE3C433D2;
        Thu, 19 Jan 2023 00:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674087327;
        bh=35I7X2PSLZ3vBy6im40kDuz28tZPma63oL+FlhE9awo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qwOYDfBLhxU5ca3QZacF9ctrxuQkWDwYSARG8U20WL9A3JLcvjgMSKVvjfbL87MT4
         KKVnuOqSxkpDrxOukiCCGP21R9+9CH/vDnq8krIVbSjc5x3hIE1HsoLql/B0hxap4t
         nUrVMmTfyEfWo9BFp+p3yPiWeRjCKXHiue3Q4T3E4Nuc838YcWe+Vq4Qyfg2tmdw0o
         UOjzctu6VYT7uvHmPGLo5nsFQoE1WpN6AhHKRmI+x6QfhTC46EGuemEow3r6WJGtGa
         HlfTpfad6d0nKUolxfYhGf+/lB0UG7Sg4yVM6QRNYL6RfEc7qngSkBsUsW9uEdR5lU
         QfkFEtCPOHqwQ==
Date:   Wed, 18 Jan 2023 16:15:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vadfed@meta.com>
Cc:     "Jiri Pirko" <jiri@resnulli.us>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v5 0/4] Create common DPLL/clock configuration API
Message-ID: <20230118161525.01d6b94f@kernel.org>
In-Reply-To: <DM6PR11MB4657644893C565877A71E1F19BC79@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230117180051.2983639-1-vadfed@meta.com>
        <DM6PR11MB4657644893C565877A71E1F19BC79@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Jan 2023 18:07:53 +0000 Kubalewski, Arkadiusz wrote:
> Based on today's sync meeting, changes we are going to introduce in next
> version:
> - reduce the muxed-pin number (artificial multiplication) on list of dpll's
> pins, have a single pin which can be connected with multiple parents,
> - introduce separated get command for the pin attributes,
> - allow infinite name length of dpll device,
> - remove a type embedded in dpll's name and introduce new attribute instead,
> - remove clock class attribute as it is not known by the driver without
> compliance testing on given SW/HW configuration,
> - add dpll device "default" quality level attribute, as shall be known
> by driver for a given hardware.

I converted the patches to use the spec, and pushed them out here:

https://github.com/kuba-moo/ynl/tree/dpll

I kept the conversion step-by-step to help the readers a bit but
the conversion patches should all be squashed into the main DPLL patch.

The patches are on top of my YNL branch ('main' in that repo). 
I'll post the YNL patches later today, so hopefully very soon they will
be upstream.

Two major pieces of work which I didn't do for DPLL:
 - docs - I dropped most of the kdocs, the copy-n-pasting was too much;
   if you want to keep the docs in the uAPI you need to add the
   appropriate stuff in the spec (look at the definition of
   pin-signal-type for an example of a fully documented enum)
 - the notifications are quite unorthodox in the current 
   implementation, so I faked the enums :S
   Usually the notification is the same as the response to a get.
   IIRC 'notify' and 'event' operation types should be used in the spec.

There is documentation on the specs in
Documentation/userspace-api/netlink/ which should give some idea of how
things work. There is also another example of a spec here:
https://github.com/kuba-moo/ynl/blob/psp/Documentation/netlink/specs/psp.yaml

To regenerate the C code after changes to YAML:

  ./tools/net/ynl/ynl-regen.sh

if the Python script doing the generation dies and eats the files -
bring them back with:

  git checkout drivers/dpll/dpll_nl.c drivers/dpll/dpll_nl.h \
               include/uapi/linux/dpll.h

There is a "universal CLI" script in:

  ./tools/net/ynl/samples/cli.py

which should be able to take in JSON requests and output JSON responses.
I'm improvising, because I don't have any implementation to try it 
out, but something like:

  ./tools/net/ynl/samples/cli.py \
       --spec Documentation/netlink/specs/dpll.yaml \
       --do device-get --json '{"id": 1}'

should pretty print the info about device with id 1. Actually - it
probably won't because I didn't fill in all the attrs in the pin nest.
But with a bit more work on the spec it should work.

Would you be able to finish this conversion. Just LMK if you have any
problems, the edges are definitely very sharp at this point.
