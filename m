Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C460C313292
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 13:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhBHMlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 07:41:13 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54307 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231956AbhBHMj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 07:39:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9E6465C0069;
        Mon,  8 Feb 2021 07:38:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 07:38:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=fAIQMsT6jn1p/Ouj/vH4YmpVXRC
        rcCIsVFko/r/lJkA=; b=HLNeS3snr9gr6d3Gfo1utIpp/70vDy80YWh5+P1oKD7
        TW0iLbW2aeZrQHY3rSR0aMo0AUO1YC0+eghNYZL3pYciXJZiNLlQeb1HybIAcj4P
        bEBjihdDcfWL698O0wrsLa2JH3hPKdkD2KBuFJ5nPGV7oWz0sVQwJEIeoNfkJlgy
        R/HqKh9CYmT9ulvYd9sJjJcaEKqn1jtUOOsCiaO4qj8sR6iHovIEUyEFYfO3/YZN
        PPzqBt29QZtPX7zHO6N1YisTUwB+bLK6cM8ggkD3XhnC2BZ5hQWpVI89bDOMd8bA
        v2MVQANJvcyNMbJ/qbnOsykHH8sSpVN8+fkNkKNztJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fAIQMs
        T6jn1p/Ouj/vH4YmpVXRCrcCIsVFko/r/lJkA=; b=cls8WGrXXQq3X5zfiDjqnD
        VMxfdnC39emwa5roK72uq0iI1bx8hLXbfTTyZY9sI2K7S4/Vsa2rFzrDXIPVGhOm
        Eyh3eUciv+hygChTIdVswGsvSswD9NJfQqJ7+6TBjToeeOm6s65AXinz3wQEKL7x
        uEugMLRcN/THdNwvu6LaFng2kQJr9GWa+FVhnZmufHdJ4yfMI0Sr1HgThGyjvipq
        I+cq4sSg8bowolyUnRSHf/vkaoyzk8LOTz2tTXXnO7SLmyPgLT1Mmr4J+fftcURX
        a1aW0hDUvwiNVDot8o0xvwjes4wyLPLnKykxCcb9xqcJKrQte5MxX7o1tWpThkGw
        ==
X-ME-Sender: <xms:0zAhYFj5dSRE82JysO7JiA0uA2txl-WPVmIdT2SacnT03y5XMZMmMQ>
    <xme:0zAhYKBWVvlWRCjifwLPpYn_zW-I0e-NKho46LlmA80c0nK1OCzZnMX8m1MgLGrUc
    DL9gHBSwsGRjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:0zAhYFH6dk4M7JLzN_7aCTcbvH_scatm0ESrjfTo5ZfMcNhDg3Yocw>
    <xmx:0zAhYKTGHJNuEqPiPrQXOb4Ntlli6uk_EQeTcPxp1dpl_s-Ah6idAw>
    <xmx:0zAhYCywKxEbaQWmI5rWo9VAJ-j2o4KG3LMjJgpvfLYHjS4VaRaCFg>
    <xmx:0zAhYN8WNODfdOdfniTVBt1maY-gJGT7LqMZ1Hx5bp2xx2MB-7GzQg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2492240057;
        Mon,  8 Feb 2021 07:38:42 -0500 (EST)
Date:   Mon, 8 Feb 2021 13:38:40 +0100
From:   Greg KH <greg@kroah.com>
To:     Jason Andryuk <jandryuk@gmail.com>
Cc:     stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org
Subject: Re: Stable request: iwlwifi: mvm: don't send RFH_QUEUE_CONFIG_CMD
 with no queues
Message-ID: <YCEw0Ey8JuHjFVOz@kroah.com>
References: <CAKf6xpueeG-c+XV6gYu_H_DXNkR11+_v54hgv=vukuy+Tcb+LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKf6xpueeG-c+XV6gYu_H_DXNkR11+_v54hgv=vukuy+Tcb+LQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 09:19:07AM -0500, Jason Andryuk wrote:
> Hi,
> 
> commit 64f55156f7adedb1ac5bb9cdbcbc9ac05ff5a724 upstream
> 
> The requested patch allows the iwlwifi driver to work with newer AX200
> wifi cards when MSI-X interrupts are not available.  Without it,
> bringing an interface "up" fails with a Microcode SW error.  Xen PCI
> passthrough with a linux stubdom doesn't enable MSI-X which triggers
> this condition.
> 
> I think it's only applicable to 5.4 because it's in 5.10 and earlier
> kernels don't have AX200 support.
> 
> I'm making this request to stable and CC-ing netdev since I saw a
> message [1] on netdev saying:
> """
> We're actually experimenting with letting Greg take networking patches
> into stable like he does for every other tree. If the patch doesn't
> appear in the next stable release please poke stable@ directly.
> """
> 
> Thanks,
> Jason
> 
> [1] https://lore.kernel.org/netdev/20210129193030.46ef3b17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

Now queued up.

thanks,

greg k-h
