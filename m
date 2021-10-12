Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA05429DA5
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 08:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhJLGZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 02:25:13 -0400
Received: from verein.lst.de ([213.95.11.211]:40093 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232431AbhJLGZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 02:25:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1403768BFE; Tue, 12 Oct 2021 08:23:10 +0200 (CEST)
Date:   Tue, 12 Oct 2021 08:23:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ralf Baechle <ralf@linux-mips.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Thomas Osterried <thomas@osterried.de>,
        linux-hams@vger.kernel.org
Subject: Re: [PATCH] ax25: Fix use of copy_from_sockptr() in
 ax25_setsockopt()
Message-ID: <20211012062309.GD17407@lst.de>
References: <YVXkwzKZhPoD0Ods@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVXkwzKZhPoD0Ods@linux-mips.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 06:24:35PM +0200, Ralf Baechle wrote:
> The destination pointer passed to copy_from_sockptr() is an unsigned long *
> but the source in userspace is an unsigned int * resulting in an integer
> of the wrong size being copied from userspace.
> 
> This happens to work on 32 bit but breaks 64-bit where bytes 4..7 will not
> be initialized.  By luck it may work on little endian but on big endian
> where the userspace data is copied to the upper 32 bit of the destination
> it's most likely going to break.
> 
> A simple test case to demonstrate this setsockopt() issue is:

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
