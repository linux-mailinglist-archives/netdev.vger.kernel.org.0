Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C222214870
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 21:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgGDTlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 15:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgGDTlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 15:41:19 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAAAC061794;
        Sat,  4 Jul 2020 12:41:18 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t4so16681718iln.1;
        Sat, 04 Jul 2020 12:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oaguPC34T7R0o5+DoNQSjRDr1tEmYY+rGX3DoLh4xf8=;
        b=UqQlaqT7Hr64mfOELSvx1Wr9DuwUyUEsOQFLfZLOzCNJEbzYE+7u+wQFpS+2aYI5XU
         JBmMm3PyTEmTUd+hQDkw/w393xyUdgyaaQL+rgpTTTvsUuf0XUxvtP6X9iYLY/LaeuuB
         HI5S3DYdndoix8ToVO30hJjXgLULga2v/wd3m8Syav7o2hfOP9/CAGOOFYBVXhSVIUWr
         czNTCHLDr2U0Bv0Fk6Tkng8KosYcdMZTaJMcBIgDc1jLRknGgrxddMasIUql60sjBffi
         tLaUYWSTq0M3wvGsTJ3bf+u5+C76wUmolpkFPwuomPtOQspzOYGxQdCYtbIZw590E++2
         skwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oaguPC34T7R0o5+DoNQSjRDr1tEmYY+rGX3DoLh4xf8=;
        b=bDYgHdcl9S61VqchsKh1nws/+i8FK5SQYaZ6lzIQmc+JmT80bCrNc2Ff+Wtsb2g1S/
         H9P4nAMtpuM59e82wn6/kkSo3O4lw5SgMu8bsrxX1BuMPie0Ar30Wyz2bFxdbtqcrQXb
         UX2ezFVxrL9FJmWjdcXha43TjQTOd++P6fQOuLa50js5t4usZnNWuS9bliy7wUUXri7s
         7IW9p7noCEv1xyhdO7iA0kFxDEBU1obkwHqY3o3Fli5dfbsXzTL8l2y2KYjpcKCdiKH7
         G68WrWxVkyLefgUc4zda2yF5Scf0f0I9zsYigYsF/L5PKpe1TCtj/dF4poScnqz0WcMp
         dJiA==
X-Gm-Message-State: AOAM5326eCKZ1n/YJllvOaQ5HvXR4Yznl7s4z6L0FtIDU2gw34lCwnQV
        +6dUAD9X0JsnoRf3wyxLrKLrScAUWayZnl4x1gI=
X-Google-Smtp-Source: ABdhPJxGQ+LYo3TE+w36gxfg8i5q9yhsP7/TsFl8gmY2pnj2YuCnzhl+fTmdgR3HZI5R6GxehmEzDItEiyvIcTdNi8g=
X-Received: by 2002:a92:5a05:: with SMTP id o5mr17808012ilb.237.1593891678038;
 Sat, 04 Jul 2020 12:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200703182010.1867-1-bruceshenzk@gmail.com> <CAKgT0Uc0sxRmADBozs3BvK2HFsDAcgzwUKWHyu91npQvyFRM1w@mail.gmail.com>
 <CAHE_cOvFC4sjVvVuC-7A8Zqw6=uJP5AAUmZOk5sQ=7bD+ePpgA@mail.gmail.com>
In-Reply-To: <CAHE_cOvFC4sjVvVuC-7A8Zqw6=uJP5AAUmZOk5sQ=7bD+ePpgA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 4 Jul 2020 12:41:07 -0700
Message-ID: <CAKgT0UdFPjD5YEBjVxkgCc65muNnxq54QPt3iBzm60QY46BCTA@mail.gmail.com>
Subject: Re: [PATCH] net: fm10k: check size from dma region
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 4, 2020 at 9:37 AM Zekun Shen <bruceshenzk@gmail.com> wrote:
>
> On Sat, Jul 04, 2020 at 09:05:48AM -0700, Alexander Duyck wrote:
> > The upper limitation for the size should be 2K or FM10K_RX_BUFSZ, not
> > PAGE_SIZE. Otherwise you are still capable of going out of bounds
> > because the offset is used within the page to push the start of the
> > region up by 2K.
> PAGE_SIZE can drop the warning, as the dma allocated size is PAGE_SIZE.

Yes, but the point I was getting at is that if you are just going to
squelch the warning, but leave the code broken then the warning isn't
of any use and might as well be discarded. Either you limit the value
to 2K which is what the hardware is expected to max out at anyway, or
you just skip the warning and assume hardware will do the right thing.
I'm not even sure this patch is worth the effort if it is just using
some dummy value that is still broken and simply squelches the
warning.

Could you provide more information about how you are encountering the
error? Is this something you are seeing with an actual fm10k device,
or is this something found via code review or static analysis?

> > If this is actually fixing the warning it makes me wonder if the code
> > performing the check is broken itself since we would still be
> > accessing outside of the accessible DMA range.
> The unbounded size is only passed to fm10k_add_rx_frag, which expects
> and checks size to be less than FM10K_RX_HDR_LEN which is 256.
>
> In this way, any boundary between 256 and 4K should work. I could address
> that with a second version.

I was referring to the code in the DMA-API that is generating the
warning being broken, not the code itself. If you can tell me how you
are getting to the warning it would be useful.

Anything over FM10K_RX_BUFSZ will break things. I think that is what
you are missing. The driver splits a single 4K page into 2 pieces and
then gives half off to the stack and uses the other half for the next
receive. If you have a value over 2K you are going to be overwritting
data in another buffer and/or attempting to access memory outside the
DMA region. Both of which would likely cause significant issues and
likely panic the system.
