Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD24E61752B
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiKCDll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiKCDlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:41:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820D0165B2;
        Wed,  2 Nov 2022 20:41:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E65C6121D;
        Thu,  3 Nov 2022 03:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A80CC433C1;
        Thu,  3 Nov 2022 03:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667446871;
        bh=nsTfwD5gRN1YSFyu2J0cf3RCKnhDy5xYPwQ07MtcAxk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cWJjytBlmNO3TZmOfdeRYkUNCo7n1TIOowx5NVLPqQEc+Fd0bEY7odMeMRqudSK/7
         gtozysYMAAB6/pzeFPhXkC+P0syy4/QGH+H7rNB7VbW6Cf1hjY/YEl+Xtqrark1Is1
         7cMVgwV6z7H1Dp1LBryzU5S6e09wWNRSbt8+xnuD6uq5gK8YzJK3aCEEHOhWNMEKhA
         jHextKlJmd0pKVio5J+giizZrIPV1/HN89KRAh3cGNuoMyORjy6vKMnYa+vt2Ml+2T
         sfkFVjFcGIV9g1ZdQTD0PuwTE36Z/Ls5N2TAmTfKWTstue4qLBS+W3toZ2nO4ikLCY
         LXUmwlcXrxnPA==
Date:   Wed, 2 Nov 2022 20:41:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc:     jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org,
        Martin Liska <mliska@suse.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH] i40e (gcc13): synchronize allocate/free functions
 return type & values
Message-ID: <20221102204110.26a6f021@kernel.org>
In-Reply-To: <20221031114456.10482-1-jirislaby@kernel.org>
References: <20221031114456.10482-1-jirislaby@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Oct 2022 12:44:56 +0100 Jiri Slaby (SUSE) wrote:
> I.e. the type of their return value in the definition is int, while the
> declaration spell enum i40e_status. Synchronize the definitions to the
> latter.
> 
> And make sure proper values are returned. I.e. I40E_SUCCESS and not 0,
> I40E_ERR_NO_MEMORY and not -ENOMEM.

Let's go the opposite way, towards using standard errno.
