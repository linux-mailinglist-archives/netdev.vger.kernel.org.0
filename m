Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2669F4D61D1
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348670AbiCKMxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348674AbiCKMxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:53:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9872C3CA51;
        Fri, 11 Mar 2022 04:52:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 345E761DC6;
        Fri, 11 Mar 2022 12:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04605C340E9;
        Fri, 11 Mar 2022 12:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647003162;
        bh=yVLn41c5+OmAhF07C0IcMA+qxMjUL7G9BKfqUwoeRAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Le2TVtCAmYRijW+sXgghJUa040dd7jMokcAAbnZ1XIPesWGY4pvu2B7I2pS4+RNd3
         U3IFw5aqVCkyBBxaCHv4JH489D9nNwUey3lKtBCVvP/5DpGRbx17u8mMjRchwSQnlW
         SyCUg6GltebRxgq4RlroZvTFOHUqNtNgcLmIbJDk=
Date:   Fri, 11 Mar 2022 13:52:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
Message-ID: <YitGFzeRHyzksYH4@kroah.com>
References: <20211217165552.746-1-manishc@marvell.com>
 <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
 <BY3PR18MB46129282EBA1F699583134A4AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <e884cf16-3f98-e9a7-ce96-9028592246cc@molgen.mpg.de>
 <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
 <BY3PR18MB4612C2FFE05879E30BAD91D7AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <CAHk-=whXCf43ieh79fujcF=u3Ow1byRvWp+Lt5+v3vumA+V0yA@mail.gmail.com>
 <BY3PR18MB46124F3F575F9F7D1980E76BAB0C9@BY3PR18MB4612.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR18MB46124F3F575F9F7D1980E76BAB0C9@BY3PR18MB4612.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 12:11:45PM +0000, Manish Chopra wrote:
> > -----Original Message-----
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > Sent: Thursday, March 10, 2022 3:48 AM
> > To: Manish Chopra <manishc@marvell.com>
> > Cc: Paul Menzel <pmenzel@molgen.mpg.de>; kuba@kernel.org;
> > netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>; Alok Prasad
> > <palok@marvell.com>; Prabhakar Kushwaha <pkushwaha@marvell.com>;
> > David S. Miller <davem@davemloft.net>; Greg KH
> > <gregkh@linuxfoundation.org>; stable@vger.kernel.org;
> > it+netdev@molgen.mpg.de; regressions@lists.linux.dev
> > Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
> > 7.13.21.0
> > 
> > On Wed, Mar 9, 2022 at 11:46 AM Manish Chopra <manishc@marvell.com>
> > wrote:
> > >
> > > This has not changed anything functionally from driver/device perspective,
> > FW is still being loaded only when device is opened.
> > > bnx2x_init_firmware() [I guess, perhaps the name is misleading] just
> > request_firmware() to prepare the metadata to be used when device will be
> > opened.
> > 
> > So how do you explain the report by Paul Menzel that things used to work and
> > no longer work now?
> > 
> 
> The issue which Paul mentioned had to do with "/lib/firmware/bnx2x/* file not found" when driver probes, which was introduced by the patch in subject,
> And the commit e13ad1443684 ("bnx2x: fix driver load from initrd") fixes this issue. So things should work as it is with the mentioned fixed commit.
> The only discussion led by this problem now is why the request_firmware() was moved early on [from open() to probe()] by the patch in subject.
> I explained the intention to do this in my earlier emails and let me add more details below - 
> 
> Note that we have just moved request_firmware() logic, *not* something significant which has to do with actual FW loading or device initialization from the
> FW file data which could cause significant functional change for this device/driver, FW load/init part still stays in open flow.
> 
> Before the patch in subject, driver used to only work with fixed/specific FW version file whose version was statically known to the driver function at probe() time to take
> some decision to fail the function probe early in the system if the function is supposed to run with a FW version which is not the same version loaded on the device by another PF (different ENV).
> Now when we sent this new FW patch (in subject) then we got feedback from community to maintain backward compatibility with older FW versions as well and we did it in same v2 patch legitimately,
> just that now we can work with both older or newer FW file so we need this run time FW version information to cache (based on request_firmware() return success value for an old FW file or new FW file)
> which will be used in follow up probe() flows to decide the function probe failure early If there could be FW version mismatches against the loaded FW on the device by other PFs already
> 
> So we need to understand why we should not call request_firmware() in probe or at least what's really harmful in doing that in probe() if some of the follow up probe flows needs
> some of the metadata info (like the run time FW versions info in this case which we get based on request_firmware() return value), we could avoid this but we don't want
> to add some ugly/unsuitable file APIs checks to know which FW version file is available on the file system if there is already an API request_firmware() available for this to be used.
> 
> Please let us know. Thanks.

I think you are asking "why can't we call request_firmware() at probe
time?", right?

If so, try it and see why it fails.  Build the driver into the kernel
image, do not use an initramfs, and see what happens.

Again, wait until open() to call it, then you have a working userspace,
including a filesystem where the firmware actually will be.  Before
then, you might not.

thanks,

greg k-h
