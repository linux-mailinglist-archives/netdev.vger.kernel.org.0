Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212DA8F11F
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 18:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbfHOQqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 12:46:13 -0400
Received: from foss.arm.com ([217.140.110.172]:46646 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbfHOQqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 12:46:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61DE0360;
        Thu, 15 Aug 2019 09:46:12 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 444BB3F706;
        Thu, 15 Aug 2019 09:46:11 -0700 (PDT)
Date:   Thu, 15 Aug 2019 17:46:09 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     Zhangshaokun <zhangshaokun@hisilicon.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org,
        "huanglingyan (A)" <huanglingyan2@huawei.com>, steve.capper@arm.com
Subject: Re: [PATCH] arm64: do_csum: implement accelerated scalar version
Message-ID: <20190815164609.GI2015@fuggles.cambridge.arm.com>
References: <20190218230842.11448-1-ard.biesheuvel@linaro.org>
 <d7a16ebd-073f-f50e-9651-68606d10b01c@hisilicon.com>
 <20190412095243.GA27193@fuggles.cambridge.arm.com>
 <41b30c72-c1c5-14b2-b2e1-3507d552830d@arm.com>
 <20190515094704.GC24357@fuggles.cambridge.arm.com>
 <440eb674-0e59-a97e-4a90-0026e2327069@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <440eb674-0e59-a97e-4a90-0026e2327069@hisilicon.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 11:14:35AM +0800, Zhangshaokun wrote:
> On 2019/5/15 17:47, Will Deacon wrote:
> > On Mon, Apr 15, 2019 at 07:18:22PM +0100, Robin Murphy wrote:
> >> On 12/04/2019 10:52, Will Deacon wrote:
> >>> I'm waiting for Robin to come back with numbers for a C implementation.
> >>>
> >>> Robin -- did you get anywhere with that?
> >>
> >> Still not what I would call finished, but where I've got so far (besides an
> >> increasingly elaborate test rig) is as below - it still wants some unrolling
> >> in the middle to really fly (and actual testing on BE), but the worst-case
> >> performance already equals or just beats this asm version on Cortex-A53 with
> >> GCC 7 (by virtue of being alignment-insensitive and branchless except for
> >> the loop). Unfortunately, the advantage of C code being instrumentable does
> >> also come around to bite me...
> > 
> > Is there any interest from anybody in spinning a proper patch out of this?
> > Shaokun?
> 
> HiSilicon's Kunpeng920(Hi1620) benefits from do_csum optimization, if Ard and
> Robin are ok, Lingyan or I can try to do it.
> Of course, if any guy posts the patch, we are happy to test it.
> Any will be ok.

I don't mind who posts it, but Robin is super busy with SMMU stuff at the
moment so it probably makes more sense for you or Lingyan to do it.

Will
