Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD97491F53
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 07:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbiARGS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 01:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiARGS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 01:18:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EACC061574;
        Mon, 17 Jan 2022 22:18:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26A85B81239;
        Tue, 18 Jan 2022 06:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A35AC00446;
        Tue, 18 Jan 2022 06:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642486735;
        bh=/Kg/V15qvD9097UjeHQH9T/5bs3t+YX4FfEIQpJUP74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tR2+zoaB2EOti3ougjTtT7EZA5S9cUo5ar4gEczEtXfSw9DPLy/qdsvC9Ub47ljT8
         equF1hBvXhKmuaODBbO45zF+dkWuSQC/H2w110iabdHzBTvn0lDU+W7kUYM7zn8o16
         k1GXwviBwDFCtZsASWrsOXZzOhZObXaUD5W+Nbas=
Date:   Tue, 18 Jan 2022 07:18:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, oneukum@suse.com, robert.foss@collabora.com,
        freddy@asix.com.tw, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
Subject: Re: [PATCH RFT] net: asix: add proper error handling of usb read
 errors
Message-ID: <YeZbzM6TDCIEvCUc@kroah.com>
References: <20220105131952.15693-1-paskripkin@gmail.com>
 <d2a4ad77-3ade-9319-f99c-82201c4268e5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2a4ad77-3ade-9319-f99c-82201c4268e5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 10:31:21PM +0300, Pavel Skripkin wrote:
> On 1/5/22 16:19, Pavel Skripkin wrote:
> > Syzbot once again hit uninit value in asix driver. The problem still the
> > same -- asix_read_cmd() reads less bytes, than was requested by caller.
> > 
> > Since all read requests are performed via asix_read_cmd() let's catch
> > usb related error there and add __must_check notation to be sure all
> > callers actually check return value.
> > 
> > So, this patch adds sanity check inside asix_read_cmd(), that simply
> > checks if bytes read are not less, than was requested and adds missing
> > error handling of asix_read_cmd() all across the driver code.
> > 
> > Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
> > Reported-and-tested-by: syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > ---
> 
> gentle ping :)

It's the middle of a merge window, and you ask for testing before it can
be applied?

confused,

greg k-h
