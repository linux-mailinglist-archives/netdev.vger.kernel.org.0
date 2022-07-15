Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8AF575ACD
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiGOFJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiGOFJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:09:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDB327FE5
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7DE56222E
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CE3C3411E;
        Fri, 15 Jul 2022 05:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657861761;
        bh=yvAg4KSzig5ABXn9qcj2z3OyhAGX176rTprjRd+0eio=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WzcihojN89Sa3qqXZ83q7GlrEYqWmCLPowBMXlYFmcykElGdhDpfAZhDKFPSYVGcq
         wsPtgcquZcmz5vjAzUK0ICDks2IcY/8RhiOD/PbE05TytgtPno/5MDsGUNQpgRXH+7
         Rg1IsrPajmAHO8rlpq+skKd7AhwqosYbl2dsrHE8sExPgq5YwRbmndF9h3pZigTrK0
         LcW10oG+ilEA24x5PLnY0TMAfKr5Puld/UuA3fKI+AP4vrdNqomTvN4WSHADcmIQDn
         ysH1vQc0kplPuqXdxXP2nXyU3kHyWDQap7sZCEE4jDwvLGY46pab42JrdL/yVrNUlU
         QrbUxlgeNTbjg==
Date:   Thu, 14 Jul 2022 22:09:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Paul Greenwalt <paul.greenwalt@intel.com>,
        netdev@vger.kernel.org, Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 1/3] ice: add support for Auto FEC with FEC
 disabled
Message-ID: <20220714220919.4167f8b5@kernel.org>
In-Reply-To: <20220714180311.933648-2-anthony.l.nguyen@intel.com>
References: <20220714180311.933648-1-anthony.l.nguyen@intel.com>
        <20220714180311.933648-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 11:03:09 -0700 Tony Nguyen wrote:
> The default Link Establishment State Machine (LESM) behavior does not
> allow the use of FEC disabled if the media does not support FEC
> disabled. However users may want to override this behavior.
> 
> Add ethtool private flag allow-no-fec-modules-in-auto to allow Auto FEC
> with no-FEC mode.
> 
> 	ethtool --set-priv-flags ethX allow-no-fec-modules-in-auto on|off

No more priv flags for FEC config please. Use the ethtool --set-fec API
and extend it as needed.
