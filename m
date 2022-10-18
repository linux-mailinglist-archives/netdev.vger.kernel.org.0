Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED77960349D
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 23:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiJRVHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 17:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJRVHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 17:07:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B259A2BB;
        Tue, 18 Oct 2022 14:07:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B414AB81F7E;
        Tue, 18 Oct 2022 21:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21656C433C1;
        Tue, 18 Oct 2022 21:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666127255;
        bh=CorCX6DieBaXhdOzHd++PB5+KL7ocIsH9Ly8VhaxxSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vZtdYqeIzAWR2B3VzuHo2suJBQU3yEdzhupDah4HWp3WYMMo+EYJg4siZlVVyNe8w
         hjNeHHnyQJNsA4otYsaOCob9EvtXCjnvAVHdASXDtc/oSZmhjW9EWIKbWhAVZI/2D9
         fTVMoEkZgFmGoGkUCIuSPkJRr4EHroYpSEdOS8oU=
Date:   Tue, 18 Oct 2022 14:07:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH] wifi: rt2x00: use explicitly signed type for clamping
Message-Id: <20221018140734.b4e012a5c3133c025c1e1e92@linux-foundation.org>
In-Reply-To: <20221018202734.140489-1-Jason@zx2c4.com>
References: <202210190108.ESC3pc3D-lkp@intel.com>
        <20221018202734.140489-1-Jason@zx2c4.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 14:27:34 -0600 "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> On some platforms, `char` is unsigned, which makes casting -7 to char
> overflow, which in turn makes the clamping operation bogus. Instead,
> deal with an explicit `s8` type, so that the comparison is always
> signed, and return an s8 result from the function as well. Note that
> this function's result is assigned to a `short`, which is always signed.

Thanks.  I'll grab this for now to make -next happier.  Stephen will
tell us when the patch (or one like it) appears via the wireless tree.

