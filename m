Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D8A6C290C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 05:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCUEPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 00:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjCUEOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 00:14:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E01B1FD5;
        Mon, 20 Mar 2023 21:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC3D7B80CA0;
        Tue, 21 Mar 2023 04:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD132C433D2;
        Tue, 21 Mar 2023 04:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679372036;
        bh=x9sqnghMTXViAQe+ndFBJ7uBh+cN+EuxRObADFi+kbw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O8vE2b3uan/PFfwaroSvHDIZ9og4lDIlOQQXf6jWvg5tilDrq7IJLqfz6GbGUh0O3
         Mijd8HCQNGjGEBxguhjdgwMMc5926HGSmqnNiVNMps5vsUEcANmHEkQuKzrrznjMQQ
         TTBD6p9nYDrS83BR1hRf0gOborVvWSTOq0FTNCF7ZgpY6Yo/XLTTNUdcvjtqtWmzdD
         TcYEhAGsxcOeS0p4H60sfGvyFOeu+qlk4Q2AP+x54g81BKuPXeKYnEvivSOHkIsEIL
         LobETxIgueAo0QP/5tm7xS9C/We/SUu3HQHFiNh9gfAJrrpHzw8byZJffj/pweObRa
         NJF7Wq/NFzIgw==
Date:   Mon, 20 Mar 2023 21:13:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Message-ID: <20230320211354.4d0f8654@kernel.org>
In-Reply-To: <20230320210549.081da89b@kernel.org>
References: <20230312022807.278528-1-vadfed@meta.com>
        <20230312022807.278528-2-vadfed@meta.com>
        <ZBCIPg1u8UFugEFj@nanopsycho>
        <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
        <20230320210549.081da89b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 21:05:49 -0700 Jakub Kicinski wrote:
> > Actually this particular one is not needed (also value: 12 on pin above),
> > I will remove those.
> > But the others you are refering to (the ones in nested attribute list),
> > are required because of cli.py parser issue, maybe Kuba knows a better way to
> > prevent the issue?
> > Basically, without those values, cli.py brakes on parsing responses, after
> > every "jump" to nested attribute list it is assigning first attribute there
> > with value=0, thus there is a need to assign a proper value, same as it is on
> > 'main' attribute list.  
> 
> Are you saying the parser gets confused after returning from nested
> parsing? Can you still repro this problem? I don't see any global
> state in _decode()..

Oh, I grokked the attr structure. This should be fixed now.
Commit 7cf93538e087 ("tools: ynl: fully inherit attrs in subsets")

The entire attr structure is a bit off (/ inspired by devlink?)
Why create one huge attribute space with all attributes in it?
Try to find something in the devlink attrs, it's pages long with 
little to no reuse :| Can't pins and devices have their own spaces?

If one has to carry a link to the other you should create a subset
so there is no circular dependency. That's the only potentially tricky
thing I can think of...
