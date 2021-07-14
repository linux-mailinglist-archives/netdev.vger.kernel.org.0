Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398723C7EB4
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 08:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbhGNGwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 02:52:24 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:41869 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237948AbhGNGwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 02:52:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E27DB320094D;
        Wed, 14 Jul 2021 02:49:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 14 Jul 2021 02:49:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=bP1/cBYeuMNK/c5k+fKj/Q99fkh
        7RiYVSrPag0irGtQ=; b=poEridcrjUHBrhOUx8YueatE02fDYQR32sjqpiQ9Acw
        LFco/lHIL6dVwSMHRDqKkuqx83uD1dLiQjqppqdvrWJ9tstk1W2tqNHKPEEGhoq/
        Mw922kiJm0URJ/I9Fx+TGBenML19B1UMvu+A0o/vlStXp3wYaConwAzqH9wgcWAb
        29LJjUzP9Kvtx6IMxg1V344ukS8h+LXQZKYxwAx1hQx4krxZi3FObpCN775I7Oiy
        +SOrKdYWKhXNRg8BmH6bfhaqRzuFZonFxAL4ABlenbzC8EZ8TrrFaBp5RluxAQUF
        eWRl70jedQExt8XvbKBqEzXFYLdfKzUNJHpfb7iLlIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=bP1/cB
        YeuMNK/c5k+fKj/Q99fkh7RiYVSrPag0irGtQ=; b=VD7FSFDQesigsOdkCLIo1C
        /Gs2H795wsPU5UeySU6cxb5IJHRYz3Zv6+oDdscMIDVbyCd1SLp9va+NMOIQDoxJ
        TNywinxN1dkbNSsli6ZA/Dgm/pUciQilpVZuNPcHGQdFlHfFN7GKbqQlOy3qMf+V
        GoWXwMmMQrM5Z8FY/TQdW6zTdHoOo+GZzGAsbbHJK0jwDV2MkAtYreLRvkVSRq+9
        sndLbdmT9ZupUKMQYa0f8o/EGc1/XSFopjV2g/YEhgAdXrasROgWOoO0ZXVTCgOK
        XzUZtmNVlIEPkDR9+FlVi7uksW+4aWF786hVWBW344QtuIBUOVRWCv3IwS/Pu/WA
        ==
X-ME-Sender: <xms:94juYJn4O64L1YDsZAMsrsMFLApHAYdzgyx5tnwp8IHRkWIgMffDNw>
    <xme:94juYE1r5DNkjce9m7PjKKX8nitUjDY5IRJkl7c3xXtrDZs1-nS2EVToVyXbzwty5
    hVOyo2Q_5DtuA>
X-ME-Received: <xmr:94juYPo1Bfl0dXU6GkkKcadbusNEoqvU0q7lUeNds7_PqrdvAYtgZMyTWzsUQ6VAbQBIFQ96v_ZyNrb4gY1D9jBpxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudejgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevudeghe
    eiheehffeihfduudefkeehheefhedukeejtdeghedvtdetheelleevkeenucffohhmrghi
    nhepthhruhgvrdhnvghtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:94juYJkDEon795_YfQ4UjraLORRoNCscXPxQFzubVAmDDgyXgn5bSg>
    <xmx:94juYH3CNse6nZVq0s5BfamPtSBDj-D81Oz635GXotyR4-7wgo3aPg>
    <xmx:94juYIu5LzfnZuTH_a9bWNC3v6pskTFN-LG_dh-7HaZB0NFbqaQDdg>
    <xmx:94juYBq27GXBWHhl_52kkpUBNLvRZXNCYY2l9EZuUPGPG3IVcD8IwQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Jul 2021 02:49:26 -0400 (EDT)
Date:   Wed, 14 Jul 2021 08:49:25 +0200
From:   Greg KH <greg@kroah.com>
To:     Xiaochen Zou <xzou017@ucr.edu>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH 0/1] can: fix a potential UAF access in
 j1939_session_deactivate()
Message-ID: <YO6I9cvLuYUg+mM7@kroah.com>
References: <aa64ef28-35d8-9deb-2756-8080296b7e3e@ucr.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa64ef28-35d8-9deb-2756-8080296b7e3e@ucr.edu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 01:21:44PM -0700, Xiaochen Zou wrote:
> 
> Xiaochen Zou (1):
>   can: fix a potential UAF access in j1939_session_deactivate(). Both
>     session and session->priv may be freed in
>     j1939_session_deactivate_locked(). It leads to potential UAF read
>     and write in j1939_session_list_unlock(). The free chain is
> 
> j1939_session_deactivate_locked()->j1939_session_put()->__j1939_session_release()->j1939_session_destroy().
>     To fix this bug, I moved j1939_session_put() behind
>     j1939_session_deactivate_locked(), and guarded it with a check of
>     active since the session would be freed only if active is true.
> 
>  net/can/j1939/transport.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> -- 
> 2.17.1


Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch was attached, please place it inline so that it can be
  applied directly from the email message itself.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
