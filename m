Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C906435EA
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 21:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbiLEUng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 15:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiLEUnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 15:43:31 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E8AEE3B
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 12:43:30 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id qk9so1406877ejc.3
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 12:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9qEJFfOgR2et4aLDCUXqyd67PYkCwHrO8dl0qn34Yos=;
        b=A6jhkXo6wq5cct1FstU4Yfb7yApGF8BTvQE4h8HEYORMMBGBR0qHKV3YVZrrpa03vs
         LkI1z8QjgVe+3ynh5TORgXz0K/MEG0q5GZEeUcQslxbA7lnB7m2rDc4JC1HeCbDP86lO
         fqTFBcQD+InTRcW70I8VWirpzINiXniq0b1RzWAX4hseGPC7soQKncRcXbx9slKAeAWw
         vr/lZLqRlfImds8d+xh4/We4NGMPmiOZZTPAmYsWRQEG5Yjfe+qgekVXeH2l1RDGPKWg
         lnAHsYd6rx17Fl0HmzMKtBN89li868FLiIzlV1g6Bmta6YoxytHJwJzVB6rDpCnfs7in
         3JSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qEJFfOgR2et4aLDCUXqyd67PYkCwHrO8dl0qn34Yos=;
        b=mLZUKbHcY68qh4le423/DIto78/JAMg72WcH/2jKt5DThztp03rNN/L1kfqE/7Y36t
         DY9Alx6bGPkXJbMl/MAkw6RbgziGcwx5JkbCKJeIgTyaew7TbX7S7pqeUIBjOVTgGYpw
         O1ZVYjOK8p0QMasZN6AgFWChDnrRO+vFzzgxptDDXNzqbu6esRh9rWBYM+jROMjV0Uql
         nQK6V3d2amPAp72+6qLK0XKAxuvEvg8BKjOVShVRrq3CYVa+YPmOHqOxjXm+aKHl+JhK
         wVmv5FFNhCQJkaPwIK2Nx+6/LH/h8axaO8xsP2UuGwcAd2h3BRtFwPtjk0SWzYRs6HTQ
         Y9IQ==
X-Gm-Message-State: ANoB5pn1I1GppLAY6goDRpcZ+cS4m83DHdtfEFp4FgeF6YBLQnaloRYA
        g5/4BSrMA2Mj3+77z/e7vDQ+SxXBYf0UkQ==
X-Google-Smtp-Source: AA0mqf6h0shDmdGlF1kbOc8RaXSW+kQuTb7XYJs9DDmbU1SmgkXCDVpvVOabrZVmkf3YU7uXkV6IEQ==
X-Received: by 2002:a17:907:9b04:b0:7c0:d125:1fe6 with SMTP id kn4-20020a1709079b0400b007c0d1251fe6mr10997996ejc.514.1670273008662;
        Mon, 05 Dec 2022 12:43:28 -0800 (PST)
Received: from skbuf ([188.26.185.87])
        by smtp.gmail.com with ESMTPSA id f8-20020a056402150800b0046146c730easm192533edw.75.2022.12.05.12.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 12:43:28 -0800 (PST)
Date:   Mon, 5 Dec 2022 22:43:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     netdev@vger.kernel.org
Subject: Re: Using a bridge for DSA and non-DSA devices
Message-ID: <20221205204326.peigjeahfy54t34r@skbuf>
References: <2269377.ElGaqSPkdT@n95hx1g2>
 <20221205190805.vwcv6z7ize3z64j2@skbuf>
 <3213598.44csPzL39Z@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3213598.44csPzL39Z@n95hx1g2>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 09:08:38PM +0100, Christian Eggers wrote:
> No, I didn't. But just to make it clear: Will the DSA framework
> change to "pure software" switching as soon I add the first non-DSA
> slave to an exisiting DSA bridge?

No, DSA doesn't change to pure software switching when foreign interfaces
are added to the bridge. The forwarding decision (hardware or software)
is taken per packet. From the perspective of the DSA switch, a station
behind a foreign bridge port is just behind the CPU port, hence the idea
of managing FDB entries towards that port. Packets forwarded by hardware
are simply not seen by software (if not flooded). Or if they're flooded,
software will set the skb->offload_fwd_mark flag, and this will tell the
bridge that the packet was already flooded to the ksz bridge ports, but
not to other (foreign) bridge ports. So the bridge will clone this skb
and send it to the USB adapter bridge port and what not.

But I'm not sure that you're asking the right question with that bridge,
since you don't seem to need Ethernet bridging with these other technologies.

I don't know what is the most civilized way to solve what you're trying
to achieve ("too many IP addresses when I just want to access the board
over one of the available point-to-point links"?!). Have you considered
putting a unique (routable) IP address on the loopback interface of
your board? If you put 1.2.3.4/32 on lo, Linux should respond to a ping
towards 1.2.3.4 no matter which interface the ICMP request came from.
Granted, the ICMP reply will have the IP address of the connected
interface as source.
