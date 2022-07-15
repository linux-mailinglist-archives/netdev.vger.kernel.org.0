Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B255769DE
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiGOWXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiGOWXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:23:39 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4541A7;
        Fri, 15 Jul 2022 15:23:35 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 90C58C022; Sat, 16 Jul 2022 00:23:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657923813; bh=PA1XLzA+X+7Omx/bLhTMXHBWmn+90LA2dEeJ5jfpAvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WUJBYGl+CgPAzZc8RMrI6fXDv7ua37rO5Pmj7gVOC+1wytTZOnsdCF+B71Q4BtFsO
         PGyg5C8RfUniW5WvH1lgGuOgjmb4sVVm4FP51Gbot9ai36g2kpvFeg08UBoclGoerT
         ybMN8inxYEmOL8J0UjEVdeWW9XD8HHQnFBp5UzbRPWy4mgr2owuVS3C5JL5ydGDHpT
         lLWBlqoUmtjj8u0o+uDMzJoxYpjnX8LMEey2Zbc1vUg2mpGi3f6azj+wHsq+Ih3iEk
         SYSYfvcpZ5YPTgJPL8Bh0/jdWxRZ1OotmInLQNurRTSktIANssTkHHSQJcIPk4Wl9h
         1kHWwUcZumKGg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 246B1C009;
        Sat, 16 Jul 2022 00:23:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657923812; bh=PA1XLzA+X+7Omx/bLhTMXHBWmn+90LA2dEeJ5jfpAvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VfUMDNihhK0WiIVpdCa40ke/0w0jNUShNaLNI6EvWrDYSCWqJwrk5xvDhIl8GN7ru
         b46YKkqbsrzLGou3BeuZm1fWLpX5AaUtSn6jq6QHEwoGoJ++4mm/2OEukBTiYtxah+
         b1pUu29AyYq31TQTYSRYrw9XaNrGdDK+i7hXonr3A4yGSJTZZlTy0dMSQ809FRDeb4
         NGCnasGXs0vGCrKYCoW/qHGT2M3Gl4i0teZh9vfFhIUFA00814SicWL83owsUNVHGo
         9igP884sOxZrRwmHhQVrfdC9ZLWynuatSUPyMtzz76xaaff+yz93v0dpmqO0C1y1Vj
         lnkAtAQOJs6mw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 2bb1e746;
        Fri, 15 Jul 2022 22:23:24 +0000 (UTC)
Date:   Sat, 16 Jul 2022 07:23:09 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Tyler Hicks <tyhicks@linux.microsoft.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/9p: Initialize the iounit field during fid
 creation
Message-ID: <YtHozaPd8UV4fRX8@codewreck.org>
References: <20220710141402.803295-1-tyhicks@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220710141402.803295-1-tyhicks@linux.microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tyler Hicks wrote on Sun, Jul 10, 2022 at 09:14:02AM -0500:
> Ensure that the fid's iounit field is set to zero when a new fid is
> created. Certain 9P operations, such as OPEN and CREATE, allow the
> server to reply with an iounit size which the client code assigns to the
> p9_fid struct shortly after the fid is created by p9_fid_create(). On
> the other hand, an XATTRWALK operation doesn't allow for the server to
> specify an iounit value. The iounit field of the newly allocated p9_fid
> struct remained uninitialized in that case. Depending on allocation
> patterns, the iounit value could have been something reasonable that was
> carried over from previously freed fids or, in the worst case, could
> have been arbitrary values from non-fid related usages of the memory
> location.
> 
> The bug was detected in the Windows Subsystem for Linux 2 (WSL2) kernel
> after the uninitialized iounit field resulted in the typical sequence of
> two getxattr(2) syscalls, one to get the size of an xattr and another
> after allocating a sufficiently sized buffer to fit the xattr value, to
> hit an unexpected ERANGE error in the second call to getxattr(2). An
> uninitialized iounit field would sometimes force rsize to be smaller
> than the xattr value size in p9_client_read_once() and the 9P server in
> WSL refused to chunk up the READ on the attr_fid and, instead, returned
> ERANGE to the client. The virtfs server in QEMU seems happy to chunk up
> the READ and this problem goes undetected there.
> 
> Fixes: ebf46264a004 ("fs/9p: Add support user. xattr")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>

Thanks for the v2, looks good to me and tested quickly so I've queued it
up.
(and thanks all the fixes lately and for the reminder, too many patches
lately I thought I had already taken it... Feel free to send 'pings' on
the list)

Since the next merge window is close (probably starts next week-ish) I
won't bother with a separate PR for 5.19; it's been 12 years it can wait
another week.

--
Dominique
