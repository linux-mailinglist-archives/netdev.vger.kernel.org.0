Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06F358B121
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 23:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241383AbiHEV3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 17:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbiHEV3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 17:29:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E250E1AD9C;
        Fri,  5 Aug 2022 14:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 956C2B82A52;
        Fri,  5 Aug 2022 21:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8ECC433C1;
        Fri,  5 Aug 2022 21:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659734990;
        bh=o8MrkRNH8exb0xg5BIhv2xSoaNY7N7ELV/PMQTWE4EY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JVjhwBBjV0+2ochcTgD5JezgC+ljWdERjXfpplMQTWoZzxTJMF4lcHRadsCXoz9pl
         eMilodksQg/he5ApiEv+hunV4SwW5nYiYztyDsMZPs8QNZT6BUkOiSOitraXtjcWbY
         JdigO5apsaQ14nX/81ubwDlfHGZG17fCQynwe2416wh6RO0N2a8A3HFifh8BRz/igE
         QO3iDzi6lY4HdfJ+hLHBqCb6mJkHz8RBCO9KSl0pkTEJPNMBLTq9TU82lSHuv7GTJW
         qB4GPsl9v+XnBKPJWd4YnThWfrWBV962ydsOvOPjFTMGyqYyKgY2utnvDG9YwuuJOg
         cDkzjpAWDYOyA==
Date:   Fri, 5 Aug 2022 14:29:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
Subject: Re: [PATCH net 1/2] s390/qeth: update cached link_info for ethtool
Message-ID: <20220805142948.4dc2a1dd@kernel.org>
In-Reply-To: <7735d444-5041-ccde-accc-5a69af2f2731@linux.ibm.com>
References: <20220803144015.52946-1-wintera@linux.ibm.com>
        <20220803144015.52946-2-wintera@linux.ibm.com>
        <YuqR8HGEe2vWsxNz@lunn.ch>
        <dae87dee-67b0-30ce-91c0-a81eae8ec66f@linux.ibm.com>
        <YuvEu9/bzLGU2sTA@lunn.ch>
        <20220804132742.73f8bfda@kernel.org>
        <7735d444-5041-ccde-accc-5a69af2f2731@linux.ibm.com>
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

On Fri, 5 Aug 2022 09:05:47 +0200 Alexandra Winter wrote:
> >> Since this is for net, than yes, maybe it would be best to go with a
> >> minimal patch to make your backwards around code work. But for
> >> net-next, you really should fix this properly.   
> > 
> > Then again this patch doesn't look like a regression fix (and does not
> > have a fixes tag). Channeling my inner Greg I'd say - fix this right and
> > then worry about backports later.   
> This patch is a pre-req for [PATCH net 2/2] s390/qeth: use cached link_info for ethtool
> 2/2 is the regression fix.
> Guidance is welcome. Should I merge them into a single commit?
> Or clarify in the commit message of 1/1 that this is a preparation for 2/2?

Ohh, now it makes far more sense, I see. Could you please add a line to
patch 1 saying that it's a pre-req for the next change, separated out
for ease of review? Hopefully the backport does not get confused and
pulls in both of them...
