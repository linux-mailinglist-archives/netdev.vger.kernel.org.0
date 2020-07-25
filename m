Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E7322D54D
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 07:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgGYF6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 01:58:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38159 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbgGYF6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 01:58:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1D6465C012D;
        Sat, 25 Jul 2020 01:58:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 25 Jul 2020 01:58:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=NAfg5uNULqdE3UVUsrBrauPhrY/
        FhLHsqmtBKoZLlwg=; b=GaNj2KIxLCe52Jw8AKy/OJ1sv6K7Q7q01PTvS1ghZJr
        i2Z1XapHlCs3qU1PvurQCf8NwMJVvwcPgviEDzhLppTxvbG/oDMIFwGGVduq7XIX
        ZwqV4JyBsZtXTQaFMRrcnTSgF5jFTGFXRFOHFdYFfZ7MVnXVVsVrOi1EdwHGw4tA
        5bYAxWNXfDmNWGBOdA73kwEaRrE2DZn5uIZhVQwbOr9/EONLwLxJ5SN3Xcmnxnd5
        10LfnLBOs54LZyjW6zhBZgBCMfut6zJeIuV+YJmuAH86jO8ZVtgd/lM/s6k5eiUR
        9EY4LMMKtJN9KTkizMS1CzyxqOtTurdXHCa4vZn7VHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=NAfg5u
        NULqdE3UVUsrBrauPhrY/FhLHsqmtBKoZLlwg=; b=Q35a7uux7NMSyNsRfymz9n
        UGHVPAoC1MfBoV4exwo/ULhcV2LuKs9iYin1q4okMx91uUesMFB4gtjIG0t5WR+t
        wddNmNGoN4BF8h5q2XNX7+zJZXZm5g3uD6PceLa7ohy550eeUdaf7Of5uTTlE3zm
        vzQA79+pXkv7TbvaWSeoy0+cIYVbdmBuH1IvTZ+r3MAJBUETt0UWS7zPggMk8yWn
        /q5XLddCLGugkUkJFl3K59o8CkiHdCK8LTFw2LWUjxdxU3ugObCZrbck9AT4TOXy
        bTvNvskvUI0MF5IAJQQ0+TTc+yCrvSrI7QEwagyhuDGNf1KGEEiLKpOAFW2HxTTQ
        ==
X-ME-Sender: <xms:D8obX6HBDvjMtiuUweBe-Ml3dj_6FRm2JnRPt9GD2Oh1evk1lXgGJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrheeggddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:D8obX7UzoUZ1U6Tg-PRv8GovlL3Z9hpGsdTIoPWugAX-SYWTmZaAFA>
    <xmx:D8obX0L6U39-ZHMrVVUSGnr_MQyVfsqP8-RwXK2iSn5lcbH6UlXpfA>
    <xmx:D8obX0FGVN-bsbO1vYdrhsoYEy4FWiFy0l5d4NLenixtgry01Q859w>
    <xmx:EMobX6ezBcjugYPdC8kLFQD-o0wrAs_v4CRyVlpYO_HYdpfxhau1ag>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C2223060067;
        Sat, 25 Jul 2020 01:58:39 -0400 (EDT)
Date:   Sat, 25 Jul 2020 07:58:40 +0200
From:   Greg KH <greg@kroah.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        'Eric Dumazet' <edumazet@google.com>,
        'Willy Tarreau' <w@1wt.eu>,
        Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: UDP data corruption in v4.4
Message-ID: <20200725055840.GD1047853@kroah.com>
References: <KL1P15301MB028018F5C84C618BF7628045BF740@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <KL1P15301MB028018F5C84C618BF7628045BF740@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 02:21:06AM +0000, Dexuan Cui wrote:
> Hi,
> The v4.4 stable kernel (currently it's v4.4.231) lacks this bugfix:
> 327868212381 ("make skb_copy_datagram_msg() et.al. preserve ->msg_iter on error")
> , as a result, the v4.4 kernel can deliver corrupt data to the application
> when a corrupt UDP packet is closely followed by a valid UDP packet:
> when the same invocation of the recvmsg() syscall delivers the corrupt
> packet's UDP payload to the application's receive buffer, it provides the
> UDP payload length and the "from IP/Port" of the valid packet to the 
> application -- this mismatch makes the issue worse.
> 
> Details:
> 
> For a UDP packet longer than 76 bytes (see the v5.8-rc6 kernel's
> include/linux/skbuff.h:3951), Linux delays the UDP checksum verification
> until the application invokes the syscall recvmsg().
> 
> In the recvmsg() syscall handler, while Linux is copying the UDP payload
> to the application's memory, it calculates the UDP checksum. If the
> calculated checksum doesn't match the received checksum, Linux drops the
> corrupt UDP packet, and then starts to process the next packet (if any),
> and if the next packet is valid (i.e. the checksum is correct), Linux will
> copy the valid UDP packet's payload to the application's receiver buffer.
> 
> The bug is: before Linux starts to copy the valid UDP packet, the data
> structure used to track how many more bytes should be copied to the
> application memory is not reset to what it was when the application just
> entered the kernel by the syscall! Consequently, only a small portion or
> none of the valid packet's payload is copied to the application's receive
> buffer, and later when the application exits from the kernel, actually
> most of the application's receive buffer contains the payload of the
> corrupt packet while recvmsg() returns the length of the UDP payload of
> the valid packet.
> 
> For the mainline kernel, the bug was fixed by Al Viro in the commit 
> 327868212381, but unluckily the bugfix is only backported to the
> upstream v4.9+ kernels. I hope the bugfix can be backported to the
> v4.4 stable kernel, since it's a "longterm" kernel and is still used by
> some Linux distros.
> 
> It turns out backporting 327868212381 to v4.4 means that some 
> Supporting patches must be backported first, so the overall changes
> are pretty big...
> 
> I made the below one-line workaround patch to force the recvmsg() syscall
> handler to return to the userspace when Linux detects a corrupt UDP packet,
> so the application will invoke the syscall again to receive the following valid
> UDP packet (note: the patch may not work well with blocking sockets, for
> which typically the application doesn't expect an error of -EAGAIN. I
> guess it would be safer to return -EINTR instead?):
> 
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1367,6 +1367,7 @@ csum_copy_err:
>         /* starting over for a new packet, but check if we need to yield */
>         cond_resched();
>         msg->msg_flags &= ~MSG_TRUNC;
> +       return -EAGAIN;
>         goto try_again;
> }
> 
> 
> Eric Dumazet made an alternative that performs the csum validation earlier:
> 
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1589,8 +1589,7 @@ int udp_queue_rcv_skb(struct sock *sk, struct
> sk_buff *skb)
>                 }
>         }
> 
> -       if (rcu_access_pointer(sk->sk_filter) &&
> -           udp_lib_checksum_complete(skb))
> +       if (udp_lib_checksum_complete(skb))
>                 goto csum_error;
> 
>         if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
> 
> I personally like Eric's fix and IMHO we'd better have it in v4.4 rather than
> trying to backport 327868212381.

Does Eric's fix work with your testing?  If so, great, can you turn it
into something I can apply to the 4.4.y stable tree and send it to
stable@vger.kernel.org?

thanks,

greg k-h
