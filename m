Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0D277FCF
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 16:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfG1ORT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 10:17:19 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56107 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbfG1ORT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 10:17:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7AB0E20F51;
        Sun, 28 Jul 2019 10:17:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 28 Jul 2019 10:17:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=imap.cc; h=to:cc
        :references:from:subject:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm3; bh=B
        IHCBvWO2TOkIwGGxAKlxL1z0r1aoEL8ILhAm6EA2eI=; b=AJVS490zi45UqECbF
        35RusZdXut3281k42ZaECuROiDu9xKtuT9KYXSS0Gl7uJIwhwRXm7bbHpaH2DSPk
        2KhCiX4cMk8SdkyxXTQV7Jh/wW43i/8dPzDncpEY+8+KMWU9zOAC0Yk512fNfLAC
        JZ6FLzURoeWyhw98Y8R3vcvKPB+l8xUSRHge1sHnQ8D6/5Pbk3zCu+NezDa0omX/
        81qATjeLdIFJT+gIcwj4dqf2RfcOmREWq2+m3XYW0wVMUDhrnfxZzNUqRbAV1p6Y
        xD0coJhIv3IacolEf237Vqz925qWO92ESQDGYsDsBRCyRYSVJu9B8uFsjwvP0dld
        30+wg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=BIHCBvWO2TOkIwGGxAKlxL1z0r1aoEL8ILhAm6EA2
        eI=; b=0niHThofVynDR4lsWzR6hG7lpBoYkU9w5bqTsr1Z7fh7W6EOW0FdKMcK4
        5Oz2ZcAeGufMSqUOCcbSIiJVo3TGfmm7MvX5LC/3Iyy5jAB9dl/MQm4J3qS87ejR
        CuwnvMAd2/qCanOTTnIOPGAqRxiSTscQKvQfX9pFfCr22X9bsN7/QSchFLC1n0j+
        22jrprvDA2Ek4zT02NU+2FdQIESc3dbaGIKxs202muFdR5w6IVgx58BW5nv4pmXC
        eQ5HqpiSFUpQQJMAE26zRUjtOZ4CTYKAJJx/EHJNG8BGqSQ2JMek0ldHfaeAbW93
        9p5oWC8y+V1tGVx80fnflZwEsKh0A==
X-ME-Sender: <xms:ba49XaFAnVmUqUEwuvK-3XZPEJTYHIR3H5yC3KsX8NKIAX6GIYm_Ww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdejmdenucfjughrpefvfhfhuffkffgfgggjtgfgsehtkeertddtfeej
    necuhfhrohhmpefvihhlmhgrnhcuufgthhhmihguthcuoehtihhlmhgrnhesihhmrghprd
    gttgeqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpshhouhhrtggvfhhorhhgvgdr
    nhgvthenucfkphepkeegrddugeejrdegjedrkeejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehtihhlmhgrnhesihhmrghprdgttgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:ba49XXoXHGQU1OafRvcomP96uw5wkbdq6KBEgGHf97-FgjjUyoLJzA>
    <xmx:ba49XW6khFwRuAKrMNjM9LcsmxIxfwZoyubGcbzXb8-brOk1k3viJw>
    <xmx:ba49XV52MGIzbQ0J6sGPrLLu9i-Ph6Ps51P5GdksJY-HiHT1j6MJUA>
    <xmx:bq49XR30GY_JCM7uJbf_myONGKDB5QQ-R6ZhkCxjrcPUsqm9TieuVA>
Received: from [192.168.59.129] (p54932f57.dip0.t-ipconnect.de [84.147.47.87])
        by mail.messagingengine.com (Postfix) with ESMTPA id 505F48005A;
        Sun, 28 Jul 2019 10:17:16 -0400 (EDT)
To:     Paul Bolle <pebolle@tiscali.nl>
Cc:     David Miller <davem@davemloft.net>, Hansjoerg Lipp <hjlipp@web.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Karsten Keil <kkeil@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190726220541.28783-1-pebolle@tiscali.nl>
From:   Tilman Schmidt <tilman@imap.cc>
Openpgp: preference=signencrypt
Autocrypt: addr=tilman@imap.cc;
 keydata= mQENBFOnH60BCADAjDkW8QHkuYEGOCimq/2xhB7Fe0ljGHAoy36bqZJ3mKo6vUVibl7e4QH/
 VxBxYyfM9N2EdxSf8e3g0736oamQTjpvUMcApELTq7RufCxIpjXbV/3ZAzFEf3SbBozfKYA/
 h+sFM+Yy0BF/6NWwC7UgCm2AvV6w6gwHHIQvLED1BeRkD/EH1HmgfgiqJIGlwSqkSTNsUtL6
 WZoBOTNeInj5rl431dz0gJdYs//ZDJ2z35XaljDP8x0Vx4L4Tm1AhZCTt5Qxj9I68WwJv66u
 fz+weZ3MzG7QNVn3YVMzAAD6P8z74NM1EZF6Kg2w319d3lPL9Ba02CcU8o/Jo5/MUEcDABEB
 AAG0H1RpbG1hbiBTY2htaWR0IDx0aWxtYW5AaW1hcC5jYz6JATsEEwECACUCGyMGCwkIBwMC
 BhUIAgkKCwQWAgMBAh4BAheABQJTpyKiAhkBAAoJEFPuqx0v+F+qj8sH/14MtCKDIpUSZ+jz
 2iTbF+szyF+RxgPKch7l4+MaLvthp3y7RvPM1fRsBYkuOvnSf2x2R8bfVAbGo8Agev6RAGce
 KVcmD0VAFDrYbyeM5YveL1TfbIEPYMG4qF0mQok9mhaesDCTk4LfVmmIXqAVOpKUd3Rcw6fc
 xG4nsgclTcj8csg5BJKiLBFyk1qYsEG+2l351qrITDSjzq1Ooq7VugCtYrR4b7kH4UuPUkse
 v4aZOvddsrH57jNBiNZnN71Y7/L3N6DNg8YQir+hRpMS0cc+jhX0GOy3idUCt63t7HZTJadY
 qQy6nh3dIq94kiKFDYpMDVcFmivgLzR3kzHwDFC5AQ0EU6cfrQEIAJ67b2JDD0Y8CwEYOzta
 3NRyL67lj6dzawteFh7/an9fHsdiuEUV0/EHvCQAiD6Gbpc+qNCAkX5l9Q4uNqyvwUouO+Tw
 lqC3lGq3dZxc0ukf1mVbmuoxL8dU76KvjaTexbBphWRY4LJHQGjdf2jZRWPqO9FejSWaD6A5
 Icx5xexf+b66Wj8EibfF+Gw5kzPs9mjZrBpseAVJ+EbNkgx2/yx9oDw25LMycr+MMb61bSfr
 8id8gr+lDXhowgxik30bxLQtpj9UPZgRC4Y2CcyzQqotbOWciY5tpmT5tTv+ddgfQVhinsZP
 KAEK3AIYou27RkkjZ+kFTbnJ4tPKGOW8otMAEQEAAYkBHwQYAQIACQUCU6cfrQIbDAAKCRBT
 7qsdL/hfqlinB/9PBwJIS5+ZGiYblEog2HJFAn7YutnvHxoEoLZRZ/8tfIoCsGI18+OXpull
 YbCaLvXgYCeJjKsB6cY7Ih+xmclmNQmD6hsNvWIxNLEOtWxPCxXwbhvnFKzYiQHADnyyz12k
 uJlb6pT2sdTynl6gVwJz7s9cdipTB/aRaHpiMAUYgxxh8gEpoKmqKFoSwMA0lGozvfr8X9OI
 E8sCWFTs1Gr0Iz4SOJ26vwHSDZO880G+YW9O4l08mTNPBdBoV1auNqfKNF6wW4JQ6Spm6PZm
 26esWpBITo1IxICllLdjNI6DJf2vq8ShqAbb9S7yKClXPDSq+QLpUAKcKizg1UiBP6wS
Subject: Re: [PATCH] gigaset: stop maintaining seperately
Message-ID: <8ac5417d-29f7-664f-1a7f-b86ef5cbe3d3@imap.cc>
Date:   Sun, 28 Jul 2019 16:17:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190726220541.28783-1-pebolle@tiscali.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks to you, Paul, for all your contributions, and specifically for
keeping the driver maintained for four more years after I had to abandon
it for the same reason.

I had a lot of fun working on that driver and I learned a lot in the
course. Now it's time to move on without regrets.

All the best,
Tilman

Am 27.07.2019 um 00:05 schrieb Paul Bolle:
> The Dutch consumer grade ISDN network will be shut down on September 1,
> 2019. This means I'll be converted to some sort of VOIP shortly. At that
> point it would be unwise to try to maintain the gigaset driver, even for
> odd fixes as I do. So I'll stop maintaining it as a seperate driver and
> bump support to CAPI in staging. De facto this means the driver will be
> unmaintained, since no-one seems to be working on CAPI.
> 
> I've lighty tested the hardware specific modules of this driver (bas-gigaset,
> ser-gigaset, and usb-gigaset) for v5.3-rc1. The basic functionality appears to
> be working. It's unclear whether anyone still cares. I'm aware of only one
> person sort of using the driver a few years ago.
> 
> Thanks to Karsten Keil for the ISDN subsystems gigaset was using (I4L and
> CAPI). And many thanks to Hansjoerg Lipp and Tilman Schmidt for writing and
> upstreaming this driver.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  MAINTAINERS | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 783569e3c4b4..e99afbd13355 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6822,13 +6822,6 @@ F:	Documentation/filesystems/gfs2*.txt
>  F:	fs/gfs2/
>  F:	include/uapi/linux/gfs2_ondisk.h
>  
> -GIGASET ISDN DRIVERS
> -M:	Paul Bolle <pebolle@tiscali.nl>
> -L:	gigaset307x-common@lists.sourceforge.net
> -W:	http://gigaset307x.sourceforge.net/
> -S:	Odd Fixes
> -F:	drivers/staging/isdn/gigaset/
> -
>  GNSS SUBSYSTEM
>  M:	Johan Hovold <johan@kernel.org>
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/johan/gnss.git
> 
