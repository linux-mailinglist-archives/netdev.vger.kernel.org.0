Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0252ADC99
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbgKJRHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgKJRHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 12:07:52 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3B7C0613CF
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 09:07:52 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id p12so985104ljc.9
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 09:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:to:cc:subject:date:message-id
         :in-reply-to;
        bh=Pp9o5OX51TquD+MYbeAa/QRs/3qQlMMtjPTVS58b7No=;
        b=qhekew2kUCHmjSZK7fCsW36TDfZYoidQt31PSh2JsqpNpgDyIh0e3io/ljIWYrlB/X
         we1BoqWQ9nasIsmrWWjFgIQDfxb6fwAEfPeEwtva5jRXo1LR8PgNThwY3/Q79ZIFdi8p
         i8QLfehO2XY52xUxpttQ0BFzqeZBhW08CS5RUM/cOwwU3gfwS/AS+VcXkRO9TfvIavG+
         qPa8pXFc54zssHLLuBv6m+PHFvjME0OJosxwi8VGCWk9f1o6cKczgCTbwDVTkxEfXOT9
         fqjP97gXy+ADVqmL/xB+qHEjSM0dk3bCNGJ+iSBHVQ26qvbw1pz1rv/FjcMqVfZNPZ9w
         ML8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:to:cc:subject
         :date:message-id:in-reply-to;
        bh=Pp9o5OX51TquD+MYbeAa/QRs/3qQlMMtjPTVS58b7No=;
        b=KkcraCe6BUjdFpYsNLBMb0kUgnZie5MbterUyqzE/yp+lyTBkain08UrEZZ4FQQ1zv
         siLbKQvrrfR8nYQpcGoWJ4MU6eSNG8tCARKBTp8bdbRYJ5wH7/ydH1UUgUu+KucprHrx
         yAF+t7WSHFQiQhWe2jFD/o0E7CJFtVdAAOz+vykDaJ6NCfPuhwtVGkwPfoA5OQpdza6X
         OhiqvYSzWdkLvZlzsE2eN6iq5UkQhh6+yfUw7g8mG7150iWum2RECPMdkNgtfBOdPi3F
         lez+BtVgQ3Lyzb72UnnSD40ZJHZK/fC3tGqLtiC9rTrV1eKFfh8uqfAPGclhVcCWZU2S
         XdLQ==
X-Gm-Message-State: AOAM530eLEHa5VGXzBXrWSeYjf/2JsVY1nEknkYx7Qg4LznhJGjJ3rK/
        +W//81Dxi7E+s3mhsD94JWUCfg==
X-Google-Smtp-Source: ABdhPJwUqu5pAe0wv3SZW5pK44XSfmO/EQVEf00UWK4BnJJCwVAjMPkESyTkmNXFKikIxbsqHnA7Rw==
X-Received: by 2002:a2e:9256:: with SMTP id v22mr8019030ljg.115.1605028070794;
        Tue, 10 Nov 2020 09:07:50 -0800 (PST)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v195sm2173030lfa.266.2020.11.10.09.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 09:07:50 -0800 (PST)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Vladimir Oltean" <olteanv@gmail.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: tag_dsa: Unify regular and ethertype DSA
 taggers
Date:   Tue, 10 Nov 2020 17:57:54 +0100
Message-Id: <C6ZQR6IP6FDI.19PS7RY5FUQIG@wkz-x280>
In-Reply-To: <20201110125906.djgj2nnzdlnudt3w@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue Nov 10, 2020 at 3:59 PM CET, Vladimir Oltean wrote:
> On Tue, Nov 10, 2020 at 10:13:25AM +0100, Tobias Waldekranz wrote:
> > +config NET_DSA_TAG_DSA_COMMON
> > +	tristate
> > +	default n
>
> I think that "default n" is implicit and should be omitted.

Correct, will fix!

> > +/**
> > + * enum dsa_cmd - DSA Command
> > + * @DSA_CMD_TO_CPU: Set on packets that where trapped or mirrored to
>
> s/where/were/

ACK

> > +		/* Construct tagged FROM_CPU DSA tag from 802.1Q tag. */
> > +		dsa_header =3D skb->data + 2 * ETH_ALEN + extra;
> > +		dsa_header[0] =3D (DSA_CMD_FROM_CPU << 6) | 0x20 | dp->ds->index;
>
> What is 0x20, BIT(5)? To denote that it's an 802.1Q tagged frame I
> suppose?
> Could it have a macro?

It could, there are loads of bare shifts and masks inherited from the
old taggers though. I suppose it would be nice to replace them with
symbolic names. Then again they are never used for anything else so
I'm not sure it adds that much. Andrew?

> > -	/*
> > -	 * The ethertype field is part of the DSA header.
> > -	 */
> > +	/* The ethertype field is part of the DSA header. */
>
> Could these comment style changes be a separate patch?

Sure, I'll separate them in v2.

> > +static const struct dsa_device_ops edsa_netdev_ops =3D {
> > +	.name	=3D "edsa",
> > +	.proto	=3D DSA_TAG_PROTO_EDSA,
> > +	.xmit	=3D edsa_xmit,
> > +	.rcv	=3D edsa_rcv,
> > +	.overhead =3D EDSA_HLEN,
>
> Could you reindent these to be aligned?

Yeah, absolutely.

Thanks for the review!
