Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06F28105719
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 17:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfKUQdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 11:33:16 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:35629 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfKUQdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 11:33:16 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8BD475306;
        Thu, 21 Nov 2019 11:33:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 21 Nov 2019 11:33:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=nHWHTDLVdOX1uKKYN8BXRNsJUsY
        isZ2RlAbvZf+iPwU=; b=b3374WAEob5A+fRL+rZ+069sr+JtdUKxgKB/ToCBPRL
        r3dZ5ayl7aXJWzmP3MUbfp0+sP87QtczbOMsyFzLSk+Yl5tLrnnBuxLzUINt0Wui
        T1n00awDYzQU5pWmeo9nIPXI3cbBMvKZNSwbtJYN/N6oIpWl5ZJXS7YZO2VzbLvY
        RtLlYFjEDtty+lEE/5ndz3j4bMfPOG0xAIRxQdAInTLYxHnH24MK++2jOiN2KnyE
        gcTfCp52z4mqkiXg9LC0FKO3Q/GXJLxa6DwtWBG+bHoZhM5K3uUs1m5nOT69nhtF
        SQXranVQ8oLWOU1RpbewPv3Hl3UD60YdhKdpwP2M8eQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nHWHTD
        LVdOX1uKKYN8BXRNsJUsYisZ2RlAbvZf+iPwU=; b=rx8RIxy5FU8XfaUY3DEDwz
        wFN5FnToTX9OiZCMr1cSXv8uzPMZox+KlAk8KymZjv7a28nF+hnwGeBWl8g7sW4v
        uF0ylic0iT/Zv906gdK+ZDary5J1VHXiDt/lrOTgWtV1ZeDEqCUxG9WM6yyl1ZcF
        eIFKH0CPQ9AuOO404pMZ4cHclhV/6r/Tn1036KEkRV+zffdSICLVmAIOHvc3HH3p
        KKGHjHianpJBI6ornp+KIRpZ8kYrzhHQCu6mgXajr/kgQ4S1O1zZxeVkUG8PzlVn
        k8QdOvWg1h2/tsHIjZlbXCv08ZS7TIt5MqYc5tBWK+zngpgBwNNP3GHoWkcO2Tew
        ==
X-ME-Sender: <xms:SbzWXfqUIP-Ex0KyewkmRcGyfkMbSaQLzfc-gYBKxwrCCcCw2xYNlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudehvddgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttd
    ertddtredvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucfkphepvddujedrieekrdegledrjedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:SbzWXdK_Bz-xJCLPXMCeSbZGcOjeKLubzDwVAjgZpcbKQHqw-tZ61w>
    <xmx:SbzWXS8ziwxJ6RgcWbeRx7WoZLP_d8xkcUyC4N1VNE6iYRUQjf2igA>
    <xmx:SbzWXRICWCwmJwkNcZ6JkoZ2Gwo7_lzEGFyiPQcSQ5VCkVqMPTQaXA>
    <xmx:SrzWXWnHSDGmJVjsKjytHt0DRejx3cxEnDQfSRgCXyU93ikhbMutmg>
Received: from localhost (unknown [217.68.49.72])
        by mail.messagingengine.com (Postfix) with ESMTPA id 830958005C;
        Thu, 21 Nov 2019 11:33:12 -0500 (EST)
Date:   Thu, 21 Nov 2019 17:33:09 +0100
From:   Greg KH <greg@kroah.com>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, jikos@kernel.org,
        benjamin.tissoires@redhat.com, dmitry.torokhov@gmail.com,
        Jes.Sorensen@gmail.com, kvalo@codeaurora.org, johan@kernel.org,
        linux-input@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] drivers: usb: consolidate USB vendor IDs in one include
 file
Message-ID: <20191121163309.GA651886@kroah.com>
References: <20191121161742.31435-1-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121161742.31435-1-info@metux.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 05:17:42PM +0100, Enrico Weigelt, metux IT consult wrote:
> Instead of redefining usb vendor IDs in several places, consolidate
> into one include file: include/linux/usb/usb_ids.h

No, please no.

There's a specific reason we do not have this, unlike other operating
systems.  It's because merges are a pain, and touching the "big one
file" ends up rebuilding too many things.

Read the top of the pci-ids.h file for why I do not want to see us do
this for any other type of id.  It's best to leave them where they are
used, right in the driver itself.

thanks,

greg k-h
