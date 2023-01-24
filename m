Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5179367A3E3
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 21:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbjAXU2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 15:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjAXU2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 15:28:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818E76A51
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 12:28:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34C67B816B7
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 20:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA23C433EF;
        Tue, 24 Jan 2023 20:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674592081;
        bh=1rWo2gVFCT7QVVmUxqzdOhYbMaH9XfT5CDozwm7NQrk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RAkEtqME/g5HPD3EqT9y0QTJK7MhCN8INgZrUtwFtM5QOds0hQ9Af6E2ZtApEAO3o
         rS2tEWsnnl6xrSmpMlY0femzPWDjJ8QUQwz+8gM0sf3WkV4zK0zxPO7fPAgemxiaRK
         BaIWdULJtNQOpQmRSlJrtEHau89eFa5ePqH9ZhoE=
Date:   Tue, 24 Jan 2023 12:28:00 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     kernel test robot <lkp@intel.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        amd-gfx@lists.freedesktop.org,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 a54df7622717a40ddec95fd98086aff8ba7839a6
Message-Id: <20230124122800.a8c3affd99d6d916a10a1479@linux-foundation.org>
In-Reply-To: <63d00931.j+gAM+ywiXvJX7wP%lkp@intel.com>
References: <63d00931.j+gAM+ywiXvJX7wP%lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Jan 2023 00:37:05 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: a54df7622717a40ddec95fd98086aff8ba7839a6  Add linux-next specific files for 20230124
> 
> Error/Warning: (recently discovered and may have been fixed)
> 
> ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/fsl-edma.ko] undefined!
> ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/idma64.ko] undefined!
> drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_dp_training.c:1585:38: warning: variable 'result' set but not used [-Wunused-but-set-variable]
> 
> Unverified Error/Warning (likely false positive, please contact us if interested):
> 
> ...
>
> mm/hugetlb.c:3100 alloc_hugetlb_folio() error: uninitialized symbol 'h_cg'.

	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);

The warning looks to be bogus.  I guess we could put a "= NULL" in
there to keep the compiler quiet?

