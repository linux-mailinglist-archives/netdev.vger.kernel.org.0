Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35B93BBE10
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 16:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhGEOUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 10:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhGEOUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 10:20:21 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4806AC061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 07:17:44 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1m0PPo-0002sz-O8; Mon, 05 Jul 2021 16:17:40 +0200
Date:   Mon, 5 Jul 2021 16:17:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [iproute PATCH] tc: u32: Fix key folding in sample option
Message-ID: <20210705141740.GI3673@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>
References: <20210202183051.21022-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202183051.21022-1-phil@nwl.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Feb 02, 2021 at 07:30:51PM +0100, Phil Sutter wrote:
> In between Linux kernel 2.4 and 2.6, key folding for hash tables changed
> in kernel space. When iproute2 dropped support for the older algorithm,
> the wrong code was removed and kernel 2.4 folding method remained in
> place. To get things functional for recent kernels again, restoring the
> old code alone was not sufficient - additional byteorder fixes were
> needed.
> 
> While being at it, make use of ffs() and thereby align the code with how
> kernel determines the shift width.
> 
> Fixes: 267480f55383c ("Backout the 2.4 utsname hash patch.")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Seems this patch fell off the table? Or was there an objection I missed?

FWIW, the related kernel selftests patch[1] which asserts this patch's
change is upstream already.

Cheers, Phil

[1] 373e13bc63639 ("selftests: tc-testing: u32: Add tests covering
sample option")
