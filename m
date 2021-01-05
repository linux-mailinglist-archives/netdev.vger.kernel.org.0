Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3774A2EA2D6
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 02:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbhAEBSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 20:18:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbhAEBSr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 20:18:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7866E22581;
        Tue,  5 Jan 2021 01:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609809486;
        bh=bNCW2ExZTFDMulfSZENBIK+HIiCHHGazBOmg7ly/4t0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qkB10lCoAbrHN+Ib0vDEMS3iyX/D8Rr5cx8Tl+9Wf1yRwnsFkOl5r23vkBImrVTjC
         P19Y/5d4NCXQlpESmxeWoKfiUthS5V7pYC8+Gw7Nt3ntPLkAHL1OL20+R0cTJ543VW
         dgxgZLrl6i9vKJLSe+WTDlTw8ma/at7ms7iD/HDCMQg2eV+5K1w4qDqxXJpQChC0Yi
         EvGSP+pTy/WTkvzW+xFDWJavliDst6XcTiN7aThVu5A2ggjONh+9X4BeRIMP0jvYmI
         taaHRLkopkCBQXKfv6x94jq8hWI0sA9QYIbUlFaNUOsALg39q/UEBN/ryGP8hbNTI/
         PQVI7OtLMSCxA==
Date:   Mon, 4 Jan 2021 17:18:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] docs: net: fix documentation on .ndo_get_stats
Message-ID: <20210104171805.3b36c490@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210105010327.uc3zftj4sgkpjtwx@skbuf>
References: <20201231034524.1570729-1-kuba@kernel.org>
        <20210104104227.oqx6xt76k5snmhs6@skbuf>
        <20210104095309.28682a9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210105010327.uc3zftj4sgkpjtwx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jan 2021 03:03:27 +0200 Vladimir Oltean wrote:
> On Mon, Jan 04, 2021 at 09:53:09AM -0800, Jakub Kicinski wrote:
> > On Mon, 4 Jan 2021 12:42:27 +0200 Vladimir Oltean wrote:  
> > > And what happened to dev_base_lock? Did it suddenly go away?  
> >
> > I thought all callers switched to RCU. You investigated this in depth,
> > did I miss something? I'm sending this correction because I have a
> > series which adds to other sections of this file and this jumped out
> > to me as incorrect.  
> 
> Well, there's netstat_show from net/core/net-sysfs.c still. I couldn't
> figure why that lock exists, it doesn't seem to protect something in
> particular.

Ah, thanks for pointing that out, in that case I should just add RCU
to the list of locks that may be held.
