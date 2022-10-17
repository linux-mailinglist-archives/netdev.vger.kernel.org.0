Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBD460130D
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 17:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiJQPzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 11:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJQPzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 11:55:41 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB95227FD2
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 08:55:40 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bj12so25876295ejb.13
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 08:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3BHceDag9Md4/a5AqUKH6++D1DzVF43eei0OiRnI+yI=;
        b=I1qwSyou8GB/VV8v+uoEDcHl9csn1qo7LgNYVX2TWu4A0OaMPY6b/Gtlb+1Sfhum/m
         EPC9NblW6sUrOUgt/TUClXXaOwD3fjS95AK2X9eukfA3w9p8ZMaEqbynCqnIICY85NNd
         MMYzgRJWKdrBJ+Vth0YIxTMTK1G78c0Hux7sEIu49FYwP2GVFwXScbadLqxNn/C3Rx9e
         2ayFGDRDTYPx63saNggUejyzxnm7GcJ91TH30TsNRUNAJbf7m8q5TKPWC9vvpxhnzkrs
         s6XF4lFi6QBDhIDuvDcR2sB3Bm26Zz+Su3c5mFrmVlkEtupGNolJmnpSP2ehY+fKeanT
         RSWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3BHceDag9Md4/a5AqUKH6++D1DzVF43eei0OiRnI+yI=;
        b=OLDm24tO4s+hnTGFQBgKSDA4oHrpmRzu0U1Qg7yNk8aejwDwth/w4qbUjWAKH0cUWo
         ooHkeOlhVKtQAYBPRxnI+FtgMoDd/ddLPLCXjeExM/eCmBpLMlv2xQtaNtPUE5cU/+gP
         Q2ZWxavk/6zxoNMtTJk4tUqUpK3XecvkT4jZwTy2i430WF/5eactInSzwBKawzdH0JHQ
         /OAJLin4rtTtCSOJXykRjzqENcZIKw+jKpOBmji2xrtomRDmWrbDnpz3eynAncCnQg37
         9UbL4xQwZN6GPyKysZg65keueW62w0m5U0GPMVpQ0xUogWK8Q12SIhqzsRUhvwALeBIv
         WP/w==
X-Gm-Message-State: ACrzQf0mWBEOkiZW8Qnn4V9jwMC+e7J0lZE/L0CrSqnj69KVa0hojJ5C
        2uS6BgjJIglr7u25kvSJVMFayzKmGv0=
X-Google-Smtp-Source: AMsMyM4PpI5qdDWISK+s6Qwsss+BYOJr8hx9PCownWwgSXe4nQnjWo8FDjEhx461F2PnuSVXANz39g==
X-Received: by 2002:a17:907:2c44:b0:78d:4e67:ca5d with SMTP id hf4-20020a1709072c4400b0078d4e67ca5dmr9237699ejc.397.1666022138969;
        Mon, 17 Oct 2022 08:55:38 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id r2-20020a1709061ba200b0078d76ee7543sm6196493ejg.222.2022.10.17.08.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 08:55:38 -0700 (PDT)
Date:   Mon, 17 Oct 2022 18:55:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net] net: ftmac100: support frames with DSA tag
Message-ID: <20221017155536.hfetulaedgmvjoc5@skbuf>
References: <20221013155724.2911050-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013155724.2911050-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 06:57:24PM +0300, Sergei Antonov wrote:
> Fixes the problem when frames coming from DSA were discarded.
> DSA tag might make frame size >1518. Such frames are discarded
> by the controller when FTMAC100_MACCR_RX_FTL is not set in the
> MAC Control Register, see datasheet [1].
> 
> Set FTMAC100_MACCR_RX_FTL in the MAC Control Register.
> For received packets marked with FTMAC100_RXDES0_FTL check if packet
> length (with FCS excluded) is within expected limits, that is not
> greater than netdev->mtu + 14 (Ethernet headers). Otherwise trigger
> an error. In the presence of DSA netdev->mtu is 1504 to accommodate
> for VLAN tag.

Which VLAN tag do you mean? Earlier you mentioned a tail tag as can be
seen and parsed by net/dsa/tag_trailer.c. Don't conflate the two, one
has nothing to do with the other.

I think this patch is at the limit of what can reasonably be considered a
bug fix, especially since inefficient use of resources does not constitute
a bug in itself. And the justification provided in the commit message
certainly does not help its cause.

DSA generally works on the assumption that netdev drivers need no change
to operate as DSA masters. However, in this particular case, it has
historically operated using the "wishful thinking" assumption that
dev_set_mtu(master, 1504) will always be enough to work, even if this
call fails (hence the reason for making its failure non-fatal).

More context (to supplement Andrew's message from Message-ID Y0gcblXFum4GsSve@lunn.ch:
https://patchwork.ozlabs.org/project/netdev/patch/20200421123110.13733-2-olteanv@gmail.com/

My humble opinion is that "reasonable and noninvasive changes"
for drivers to work as DSA masters is a more desirable goal, and hence,
not every master <-> switch pair that doesn't work out of the box should
be considered a bug.

Here's how I would approach your particular issue:

1. retarget from "net" to "net-next"

2. observe the ftmac100 code. The RX_BUF_SIZE macro is set to 2044, with a
   comment that it must be smaller than 0x7ff.

3. compare with the datasheet. There it can be seen that RXBUF_SIZE is
   an 11-bit field, confirming that packets larger than 2048 bytes must
   be processed as scatter/gather (multiple BDs).

4. back to the code, the driver does not support scatter gather processing,
   but it does not push the MTU limit as far as single-buffer RX can go, either.
   It puts it to a quite random 1518, inconsistent in itself to the FTL
   field which drops frames with MTU larger than 1500 (so dev->mtu values between
   1500 and 1518 are incorrectly handled).
   It could go as far as 2047 - VLAN_ETH_HLEN, and the Frame Too Long
   bit should be unset to allow this.

5. the code currently relies on the FTL field to not trigger the BUG_ON()
   right below, if scatter/gather frames are received. But the FTL bit
   needs to go. I would completely remove the ftmac100_rxdes_frame_too_long()
   check from the fast path, instead of your approach to just make it
   more complicated. If you simply call ftmac100_rx_drop_packet() instead
   of BUG_ON() when receiving a BD which is non-final, you get a simpler
   way of protecting against multi-buffer frames, while not having to
   rely on the comparison between frame length and netdev->mtu at all.
   (side note: it isn't a problem if you receive larger frames than the
   MTU, as long as you receive the frames <= than the MTU).

6. Actually implement the ndo_change_mtu() for this driver, and even though you
   don't make any hardware change based on the precise value, you could do one
   important thing. Depending on whether the dev->mtu is <= 1500 or not, you could
   set or unset the FTL bit, and this could allow for less CPU cycles spent
   dropping S/G frames when the MTU of the interface is standard 1500.

With these changes, you would leave the ftmac100 driver in a more civilized
state, you wouldn't need to implement S/G RX unless you wanted to, and
as a side effect, it would also operate well as a DSA master.
