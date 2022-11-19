Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063746308C8
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiKSBwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiKSBvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:51:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560EB12638
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 17:31:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 088CEB825BB
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 01:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A261C433D6;
        Sat, 19 Nov 2022 01:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668821488;
        bh=/ko9OPNsEr86JhLmq1Hb4Jg4iZcZkp9aQZ23Tuc9AjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VCMoLgEv/VLrBXbXWaAsLdhWgTchgQPbvc7bAdA1I/wkwIHwF/V8TqzR6DO8jO9xd
         EvV4AdYrsM0w/mNH5ba83PZSdh6ACRvHlJRGf0M5Enb1Fr0hydzwju+JzC9enZvl9O
         nn3uZb/pukuWNDLc5QDvKi+vFCkcTaHamUrSQcD4s8I6W8fTDh2pt8cO1UZrNiofVr
         ITbmzHHdrrWzCyl6Oetqxci8JJIwvOPpgcDIJ6z6OlofiXPtSGHh0R2lT2bZVKuoXW
         xYiEM0kOJEHhVI1aVq/r5xnhTU76RJm+Xm9sSHJzKO/NDmd39rpxToV12hxg9QKKPY
         Tekeur1P9kfuw==
Date:   Fri, 18 Nov 2022 17:31:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 5/8] devlink: refactor
 region_read_snapshot_fill to use a callback function
Message-ID: <20221118173127.2c4def01@kernel.org>
In-Reply-To: <20221117220803.2773887-6-jacob.e.keller@intel.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
        <20221117220803.2773887-6-jacob.e.keller@intel.com>
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

On Thu, 17 Nov 2022 14:08:00 -0800 Jacob Keller wrote:
> +			     struct __always_unused netlink_ext_ack *extack)

clang points out this is not a great placement for __always_unused
