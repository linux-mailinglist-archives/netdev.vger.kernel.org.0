Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C2C6CD236
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjC2GnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2GnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:43:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8FE1722;
        Tue, 28 Mar 2023 23:43:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 176E561A4F;
        Wed, 29 Mar 2023 06:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88C4C433D2;
        Wed, 29 Mar 2023 06:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680072186;
        bh=iwWij85irzDMzCfXOcpjNW3gLpqW6nbVsvgino6SOmU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=i3+rANPe13C+z+HfBKiy99laV8UjrGWB3RgwC6022ya7qqAxZWlnlrOVFhzCSNkMt
         gJumZFtW4t5s7dBKMMMf/MeJVH/go1HwTszNcYntiQl/u9J626uTHE4xrqGCcUsWUT
         KbjS13ZmV3erq+w0J7ZvwDMdMoRm1BA3ESz5Tl4fQiABY+Il0Y4oQsFi12UkLT/OFj
         cL86e6CMHGSoxU+/E5uK8zVWKK2CwF9KO1TEkVLz+HwG1KSKjODB3VasljEHoUvafr
         oAR977aBGHfSLEbryLrI3t34kw6uaUeMndnNv4N5kUEiRvfhncFPRv/c16KIW7RduD
         19TgmU4cQdLfA==
Date:   Wed, 29 Mar 2023 08:43:01 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Matthew Bobrowski <repnop@google.com>,
        linux-kernel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] pidfd: add pidfd_prepare()
Message-ID: <20230329-strenuous-vindicate-214a05c6ea2e@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230327-pidfd-file-api-v1-0-5c0e9a3158e4@kernel.org>
 <20230328154516.5qqt7uoewdzwb37m@wittgenstein>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 27 Mar 2023 20:22:50 +0200, Christian Brauner wrote:
> This adds the pidfd_prepare() helper which allows the caller to reserve
> a pidfd number and allocates a new pidfd file that stashes the provided
> struct pid.
> 
> This will allow us to remove places that either open code this
> functionality e.g., during copy_process() or that currently call
> pidfd_create() but then have to call close_fd() because there are still
> failure points after pidfd_create() has been called.
> 
> [...]

Jan, thanks for the reviews.

I've picked this up now. Please note that this series is considered stable and
has thus been tagged. The reason is that the SCM_PIDFD work in the networking
depends wants to depend on this work. So they'll get a stable tag,

tree: git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git
branch: pidfd.file.api
tag: pidfd.file.api.v6.4

[1/3] pid: add pidfd_prepare()
      commit: 7021c1b14f83d9151ecaf976eaa6c1d5c6bb5dc7
[2/3] fork: use pidfd_prepare()
      commit: 761ce43fda7ebcdf1b1aa8e797ec83fae0e34c47
[3/3] fanotify: use pidfd_prepare()
      commit: 909939fc167d82cf09cd93ae44e968be916b6e41

Thanks!
Christian
