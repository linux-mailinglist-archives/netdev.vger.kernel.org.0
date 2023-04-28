Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9DB6F2126
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 01:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346524AbjD1XSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 19:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjD1XSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 19:18:44 -0400
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B7630D2
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 16:18:42 -0700 (PDT)
Received: from sparky.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 7546420033;
        Sat, 29 Apr 2023 07:18:33 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1682723915;
        bh=1vpRwQZveUaRFPJ9474Rr0E9ttZIrC7z9IazBTVg71E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References;
        b=JKxiDE6hvkTdExxDd/qnZVjHhtAxyREwPSlDscqFC27eJsOj1iebZINLMtzUgC1Vj
         FE1sGArkvw2YIBn5hDjs/T+xEEH5TXQlzMHpBZkdKC9jTFK8CM3NTBYAnp2fSSsHFI
         J6exMi7k5eza8Am6RW2tjFHLSBimOhi5NpoCTHyWSKWYggd/wcBShnpbVP2AspuipV
         FST10ekus3kUlW0X/yZwOLDYzYwGv8p9wXA6LE9QR+im1bCRZyIrzn0dvk5QxdSafH
         ydt0rtkiQ0xPrcFLoEMdAIKIC+/3/YRuZwcLwo1gf16WoZZ/9Me564RO01OMUZ6VaD
         42bjmfO7LVf/A==
Message-ID: <00357b1aff6d9be445f070172feb969639274a21.camel@codeconstruct.com.au>
Subject: Re: [RFC PATCH v1 0/1] net: mctp: MCTP VDM extension
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     "Richert, Krzysztof" <krzysztof.richert@intel.com>,
        matt@codeconstruct.com.au
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Date:   Sat, 29 Apr 2023 07:18:32 +0800
In-Reply-To: <31b56a8b-d3a8-1a28-f612-34c9a4ddb2ee@intel.com>
References: <20230425090748.2380222-1-krzysztof.richert@intel.com>
         <aceee8aa24b33f99ebf22cf02d2063b9e3b17bb3.camel@codeconstruct.com.au>
         <67d9617d-4f77-5a1c-3bae-d14350ccaed5@intel.com>
         <61b1f1f0c9aab58551e98ba396deba56e77f1f89.camel@codeconstruct.com.au>
         <4ab1d6c1-d03b-d541-39a0-263e73197521@intel.com>
         <ce269480332ed97c153d61452ee93829d4df5c73.camel@codeconstruct.com.au>
         <31b56a8b-d3a8-1a28-f612-34c9a4ddb2ee@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

> Not sure if I follow you, please let me ask additional questions.
> =C2=A0
> >=20
> > =C2=A0A) we keep the DSP0236 specified behaviour in the kernel; allowin=
g a
> > =C2=A0=C2=A0=C2=A0=C2=A0bind on a PCI/IANA vendor type, but not the sub=
type
> >=20
> > =C2=A0B) we add a "vendor mark" field to the sockaddr_mctp_vendor_ext; =
an
> > =C2=A0=C2=A0=C2=A0=C2=A0arbitrary u32. Sockets can specify a vendor mar=
k value during bind()
> > =C2=A0=C2=A0=C2=A0=C2=A0so that they receive packets with a specific ma=
rk. This allows us
> > =C2=A0=C2=A0=C2=A0=C2=A0to reject duplicate bind()s on the same mark va=
lue.
> but such "vendor mark" is not actually PCI/IANA ? Or maybe by=20
> "vendor mark" you think about u32 which is always just after=20
> PCI/IANA in received packet?=20

No, it's not part of the on-the-wire data of the packet at all, and not
specified by any standard; it's system-internal. The PCI/IANA vendor IDs
still appear in the packet as per DSP0236, the mark functionality just
covers the subtype use-case.

The mark is just an arbitrary u32 (or whatever type we choose) that gets
set on the skb when the packet is routed for local input.

Vendors using a subtype mechanism would have a little BPF code that
applies a mark to the packet, by looking at whatever subtype format that
vendor packet uses (from your case: a u8 that appears in the second
byte). The mark value does not need to match the subtype value; the mark
just needs to be unique against the vendor-id for that specific system.

Then, the userspace program implementing that subtype protocol would
bind() with:

 - the MCTP type 0x7e/0x7f;
 - the PCI/IANA value specific to that vendor
 - the mark set to the value set above (ie, defined by what the BPF
   sets)

... and hence only receive packets for that specific vendor id and
subtype.

Would that work?

Cheers,


Jeremy
