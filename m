Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAA5324BE7
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 09:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbhBYIS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 03:18:58 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:53193 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235637AbhBYISr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 03:18:47 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8EF312C0;
        Thu, 25 Feb 2021 03:17:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 25 Feb 2021 03:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=qt+vntldzwyeMOu10ICDLcV+PMh
        3Jo+VnYJ5MArvW1E=; b=lTaK1RxOWJbr5v3GpRGfbr/SrPHeKDaC5vimhKvYF8V
        R91yQvxODJV4JxzEmaQWZLrAocvxkW8TmU7C2CE4wAFRZMOd05dYH4ieJ1Yte5T/
        cDI1l8QpTtTtLdbqka2eq8/6Fr6yk6ycih2N6dUnUp7MbqEdCVP2pmTqg9Km0Nby
        BvpxkqWRcx0U4Po3Vb3VXy65nvZ2t1gJ/dfPbiXlbgP3phyyWFTMO+bcXFzZ1/do
        D5sJQxshBH3bRXQFnSSExvHukAH7ORRQ8N5C5dGdzgmx6WxDTwejE3Mbyf+6wo4i
        GDtASt6lJFmHWxDWHkWEB3RGK9oQrBSbSvmyv6nm7hA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qt+vnt
        ldzwyeMOu10ICDLcV+PMh3Jo+VnYJ5MArvW1E=; b=YBU2keiRAyYXEnTMs6zhLH
        YHSsrKLrT26eyIxG3+JlxBbvo3yRQQbcRKeLKiOPyZky/2I4GZaa1GaXAXY5zyol
        KYqq6a6eN/SJKMgOtYPPBtRptvWaC0Wa975ge2LMRgaZRTo+uSe8/QgF+kOxXVmH
        UTIOK/XeFuHQRUjINs6ukU6CaBKFb0PJeW3NGyuH0lNszcimLTIvpczPDb4QmKDI
        gAX08VWMGV8xvOXTyzCMByTHfOfIDVpoNA3U6aedUfZlqg3lv78aRgJAZFXeIebz
        6gMtuFVy6SCsY8ICWphA8/VLNXdl2ukAeIX1pw+7407Ywn5ONgcjbbmtzbRtIfZQ
        ==
X-ME-Sender: <xms:NV03YPAVkSS0Z6MOKCi0sjsOAhLw-D95-QF8HCQjiD4K1EhYIUwTwQ>
    <xme:NV03YFgTsoxD4NNrVTMwAczVPdz1fdRTf26YsvDDqR5QdSo0eGZWIKb-rfiZWcEWf
    4iAJoC36VBIGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeekgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NV03YKmkswGwJOiEjKDD7YPCStd2qSg5ZPX0IYFZ77dgAsGW7bEYwQ>
    <xmx:NV03YBxeHL7stO0u5a-bI5Gm4uuCRpAZywAvr1pqskQR3Hba-lFsbA>
    <xmx:NV03YET-tLSVGzKZPvvANJTb1x5f8I6__A7YQ8zeL_OzmVV2bGSP6g>
    <xmx:Nl03YJQjp9P5TCrZ2UZj-UWGFUPAAOZWZ7muSGT-S8OI6_s6d5KvOw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0648924005E;
        Thu, 25 Feb 2021 03:17:56 -0500 (EST)
Date:   Thu, 25 Feb 2021 09:17:54 +0100
From:   Greg KH <greg@kroah.com>
To:     Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        daichi1.fukui@toshiba.co.jp, nobuhiro1.iwamatsu@toshiba.co.jp,
        Corinna Vinschen <vinschen@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [PATCH v4.4.y, v4.9.y] igb: Remove incorrect "unexpected SYS
 WRAP" log message
Message-ID: <YDddMnkytDS76mYN@kroah.com>
References: <20210225005406.530767-1-punit1.agrawal@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225005406.530767-1-punit1.agrawal@toshiba.co.jp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 09:54:06AM +0900, Punit Agrawal wrote:
> From: Corinna Vinschen <vinschen@redhat.com>
> 
> commit 2643e6e90210e16c978919617170089b7c2164f7 upstream
> 
> TSAUXC.DisableSystime is never set, so SYSTIM runs into a SYS WRAP
> every 1100 secs on 80580/i350/i354 (40 bit SYSTIM) and every 35000
> secs on 80576 (45 bit SYSTIM).
> 
> This wrap event sets the TSICR.SysWrap bit unconditionally.
> 
> However, checking TSIM at interrupt time shows that this event does not
> actually cause the interrupt.  Rather, it's just bycatch while the
> actual interrupt is caused by, for instance, TSICR.TXTS.
> 
> The conclusion is that the SYS WRAP is actually expected, so the
> "unexpected SYS WRAP" message is entirely bogus and just helps to
> confuse users.  Drop it.
> 
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> Acked-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
> [ Due to confusion about stable rules for networking the request was
> mistakenly sent to netdev only[0]. Apologies if you're seeing this
> again. ]

No signed-off-by: from you?  :(

