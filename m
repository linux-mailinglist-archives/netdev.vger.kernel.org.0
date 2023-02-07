Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47A068DD32
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjBGPjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjBGPjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:39:19 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0238AD10;
        Tue,  7 Feb 2023 07:39:16 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 810E45C01F9;
        Tue,  7 Feb 2023 10:39:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 07 Feb 2023 10:39:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1675784353; x=1675870753; bh=yEjHaMomca
        0kATRC+saxqIPfLTowwRyDeWn9gU/2KSU=; b=J/uVQ1KjjI+/aPSI94Gt/slGOp
        Loji0nYu/wHAOIkHD4DCBKX996QSF8qonIGI7akXP7tD/lzPizUjJ3h1JV8CSCWP
        UqZsS98iyL0JIHXt3ssYnIEe8N9HN8kegOOMXRAnN/3yPJlxzBVR4ZdRDCiyXAzw
        3modny4sUkE6yDVmQBjlNJ5Lz0/eW650QiEWXp0frMCvpakYCWPbRMCdSTP+4Pol
        W70eh8/XPaw3hgPVVfGcdCJCddmQNWvEKBT+9FVyEq3fn1ErKbMu4hJ+uYvIVxAU
        ZG/F0KGE7CB1UpgxPMGdKMWKmM4dHbiFRSFeXYtwlWz9Tp1lZNtW+DQfCRwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675784353; x=1675870753; bh=yEjHaMomca0kATRC+saxqIPfLTow
        wRyDeWn9gU/2KSU=; b=SqxR39b+lgiNmDOg56Yx5q+HunWsk/FIhjjZTfvvn2pm
        kH0XwOZyk5UHbf1RBnCD7YgyhZLTsi05G/qs2f7du1LJ8Kn7zIjvFHQDw4NX0AWl
        bwXKJzwfHg6xbqqCvThiVLQM2r0wCLuWZYB2OQmumApj2GIAqZAReXU2hMsXS23C
        bdYO3MEcB8pOzQJB+m/zxP9yIVZlcOpRN168Tb29aE3gftHnCfrT1yMEYE7nO9h6
        4ZTaKVnn9LtS9OenuoCkHMHA/X04htMbAr419+h5wHhtAnL/i2DCeJAS1wJ9zVNK
        9LwOuPG+utO7uWqOffCEtB9c8EN58muzmIbBHm5PoQ==
X-ME-Sender: <xms:oXDiY9zkL9QoQIOB-Oz1G74xMLNBEALJ9nq9ycnJrQQjqXnVTB7Ccw>
    <xme:oXDiY9Q1yGqGO21LLRTLmZBZBVq3rcr-5nA5RsHUU2QCj0cW1j8rxIRHDd-IOVwfj
    -7ryUI9YjoiS7NRg0I>
X-ME-Received: <xmr:oXDiY3W7a8ZC6GEcWBSNA1znHRPQtiI3vVLiPd1q2z06KxO3w6NH02RxxU3hkkoxp-nqZEV9zTa_lSkAZhsmEXZW>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegkedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomheprfgvthgv
    rhcuffgvlhgvvhhorhihrghsuceophgvthgvrhesphhjugdruggvvheqnecuggftrfgrth
    htvghrnheptddvueefgffgvdejffdtgfdugeekheegteehieelleehvefhhefggeduffdu
    geeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpohhpvghnsghmtgdrohhrghdpgh
    hithhhuhgsrdgtohhmpdgumhhtfhdrohhrghdpfihikhhiphgvughirgdrohhrghenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehpvghtvghrse
    hpjhgurdguvghv
X-ME-Proxy: <xmx:oXDiY_haCdGGifJ7ASff49LlsAe_ZQMjcFziFPV7dMMH5kiA2zRONg>
    <xmx:oXDiY_BPmpEVmyxPLvnDxhwRw1S2GRkSYUye38iP4or9Fs2SHcG8iw>
    <xmx:oXDiY4JFrPQih_MbN_tgLoiMaCqNmCIe7ILS1EwRojWE4XflPhuoPw>
    <xmx:oXDiYz1rhEGK5tQ9qksiubXA_otjSu_e8bvVFWFbczJEIfCGczsNMQ>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Feb 2023 10:39:12 -0500 (EST)
Date:   Tue, 7 Feb 2023 09:39:10 -0600
From:   Peter Delevoryas <peter@pjd.dev>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, joel@jms.id.au,
        gwshan@linux.vnet.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 1/1] net/ncsi: Fix netlink major/minor version
 numbers
Message-ID: <Y+JwnldWtWvMijZ5@pdel-mbp.dhcp.thefacebook.com>
References: <20230202175327.23429-1-peter@pjd.dev>
 <20230202175327.23429-2-peter@pjd.dev>
 <Y94jElt1s0vxBi8p@corigine.com>
 <Y+IKJkwuCfqG/1Y7@pdel-mbp>
 <Y+IPeD4O2t1AN/02@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+IPeD4O2t1AN/02@corigine.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 09:44:40AM +0100, Simon Horman wrote:
> On Tue, Feb 07, 2023 at 02:21:58AM -0600, Peter Delevoryas wrote:
> > On Sat, Feb 04, 2023 at 10:19:14AM +0100, Simon Horman wrote:
> > > Hi Peter,
> > > 
> > > A very interesting patch. My review below is based on the information
> > > in it, and the references you've provided (thanks for those!). My prior
> > > knowledge of this specific topic is, however, limited.
> > 
> > Well, regardless of your familiarity, I think all your comments are really
> > good!
> 
> Happy to help.
> 
> > > First, regarding the subject. I see your reasoning in the cover-letter.
> > > But this is perhaps not really a netlink issue, so perhaps:
> > > 
> > > [PATCH net-next] net/ncsi: correct version decoding
> > 
> > Agreed, my cover-letter reasoning was not very strong, I'll update the patch
> > title. I guess I won't submit a "v2" version, I'll just start again from v1,
> > but I'll certainly link back to this series through lore.kernel.org in the
> > cover letter.
> > 
> > > 
> > > On Thu, Feb 02, 2023 at 09:53:27AM -0800, Peter Delevoryas wrote:
> > > > The netlink interface for major and minor version numbers doesn't actually
> > > > return the major and minor version numbers.
> > > > 
> > > > It reports a u32 that contains the (major, minor, update, alpha1)
> > > > components as the major version number, and then alpha2 as the minor
> > > > version number.
> > > > 
> > > > For whatever reason, the u32 byte order was reversed (ntohl): maybe it was
> > > > assumed that the encoded value was a single big-endian u32, and alpha2 was
> > > > the minor version.
> > > > 
> > > > The correct way to get the supported NC-SI version from the network
> > > > controller is to parse the Get Version ID response as described in 8.4.44
> > > > of the NC-SI spec[1].
> > > > 
> > > >     Get Version ID Response Packet Format
> > > > 
> > > >               Bits
> > > >             +--------+--------+--------+--------+
> > > >      Bytes  | 31..24 | 23..16 | 15..8  | 7..0   |
> > > >     +-------+--------+--------+--------+--------+
> > > >     | 0..15 | NC-SI Header                      |
> > > >     +-------+--------+--------+--------+--------+
> > > >     | 16..19| Response code   | Reason code     |
> > > >     +-------+--------+--------+--------+--------+
> > > >     |20..23 | Major  | Minor  | Update | Alpha1 |
> > > >     +-------+--------+--------+--------+--------+
> > > >     |24..27 |         reserved         | Alpha2 |
> > > >     +-------+--------+--------+--------+--------+
> > > >     |            .... other stuff ....          |
> > > > 
> > > > The major, minor, and update fields are all binary-coded decimal (BCD)
> > > > encoded [2]. The spec provides examples below the Get Version ID response
> > > > format in section 8.4.44.1, but for practical purposes, this is an example
> > > > from a live network card:
> > > > 
> > > >     root@bmc:~# ncsi-util 0x15
> > > >     NC-SI Command Response:
> > > >     cmd: GET_VERSION_ID(0x15)
> > > >     Response: COMMAND_COMPLETED(0x0000)  Reason: NO_ERROR(0x0000)
> > > >     Payload length = 40
> > > > 
> > > >     20: 0xf1 0xf1 0xf0 0x00 <<<<<<<<< (major, minor, update, alpha1)
> > > >     24: 0x00 0x00 0x00 0x00 <<<<<<<<< (_, _, _, alpha2)
> > > > 
> > > >     28: 0x6d 0x6c 0x78 0x30
> > > >     32: 0x2e 0x31 0x00 0x00
> > > >     36: 0x00 0x00 0x00 0x00
> > > >     40: 0x16 0x1d 0x07 0xd2
> > > >     44: 0x10 0x1d 0x15 0xb3
> > > >     48: 0x00 0x17 0x15 0xb3
> > > >     52: 0x00 0x00 0x81 0x19
> > > > 
> > > > This should be parsed as "1.1.0".
> > > > 
> > > > "f" in the upper-nibble means to ignore it, contributing zero.
> > > > 
> > > > If both nibbles are "f", I think the whole field is supposed to be ignored.
> > > > Major and minor are "required", meaning they're not supposed to be "ff",
> > > > but the update field is "optional" so I think it can be ff.
> > > 
> > > DSP0222 1.1.1 [4], section 8.4.44.1, is somewhat more informative on this
> > > than DSP0222 1.0.0 [1]. And, yes, I think you are correct.
> > > 
> > > > I think the
> > > > simplest thing to do is just set the major and minor to zero instead of
> > > > juggling some conditional logic or something.
> > > > 
> > > > bcd2bin() from "include/linux/bcd.h" seems to assume both nibbles are 0-9,
> > > > so I've provided a custom BCD decoding function.
> > > > 
> > > > Alpha1 and alpha2 are ISO/IEC 8859-1 encoded, which just means ASCII
> > > > characters as far as I can tell, although the full encoding table for
> > > > non-alphabetic characters is slightly different (I think).
> > > 
> > > Yes, that seems to be the case. Where 'slightly' is doing a lot of work
> > > above. F.e. the example in DSP0222 1.1.1 uses 'a' = 0x41 and 'b' = 0x42.
> > > But in ASCII those code-points are 'A' and 'B'.
> > 
> > Oh, yes, thanks for noticing this, I don't think I did. You're right, the
> > example from the spec with lowercase 'a' and 'b' makes it clear that it's _not_
> > just ASCII.
> > 
> > > 
> > > > I imagine the alpha fields are just supposed to be alphabetic characters,
> > > > but I haven't seen any network cards actually report a non-zero value for
> > > > either.
> > > 
> > > Yes, this corresponds to the explanation in DSP0222 1.1.1.
> > > 
> > > > If people wrote software against this netlink behavior, and were parsing
> > > > the major and minor versions themselves from the u32, then this would
> > > > definitely break their code.
> > > 
> > > This is my main concern with this patch. How did it ever work?
> > > If people are using this, then, as you say, there may well be trouble.
> > > But, OTOH, as per your explanation, it seems very wrong.
> > 
> > +1. I'm not sure that people are using this. I think people are using the NCSI
> > netlink interface, but mostly for sending commands or receiving notifications.
> > 
> > https://gerrit.openbmc.org/c/openbmc/phosphor-networkd/+/36592
> > https://github.com/facebook/openbmc/blob/082296b3cc62e55741a8af2d44a1f0bc397f4e88/common/recipes-core/ncsid-v2/files/ncsid.c
> > 
> > > 
> > > > 
> > > > [1] https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.0.0.pdf
> > > > [2] https://en.wikipedia.org/wiki/Binary-coded_decimal
> > > > [2] https://en.wikipedia.org/wiki/ISO/IEC_8859-1
> > > 
> > > [4] https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.1.1.pdf
> > > 
> > > > Fixes: 138635cc27c9 ("net/ncsi: NCSI response packet handler")
> > > > Signed-off-by: Peter Delevoryas <peter@pjd.dev>
> > > > ---
> > > >  net/ncsi/internal.h     |  7 +++++--
> > > >  net/ncsi/ncsi-netlink.c |  4 ++--
> > > >  net/ncsi/ncsi-pkt.h     |  7 +++++--
> > > >  net/ncsi/ncsi-rsp.c     | 26 ++++++++++++++++++++++++--
> > > >  4 files changed, 36 insertions(+), 8 deletions(-)
> > > > 
> > > > diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
> > > > index 03757e76bb6b..374412ed780b 100644
> > > > --- a/net/ncsi/internal.h
> > > > +++ b/net/ncsi/internal.h
> > > > @@ -105,8 +105,11 @@ enum {
> > > >  
> > > >  
> > > >  struct ncsi_channel_version {
> > > > -	u32 version;		/* Supported BCD encoded NCSI version */
> > > > -	u32 alpha2;		/* Supported BCD encoded NCSI version */
> > > > +	u8   major;		/* NCSI version major */
> > > > +	u8   minor;		/* NCSI version minor */
> > > > +	u8   update;		/* NCSI version update */
> > > > +	char alpha1;		/* NCSI version alpha1 */
> > > > +	char alpha2;		/* NCSI version alpha2 */
> > > 
> > > Splitting hairs here. But if char is for storing ASCII, and alpha1 and
> > > alpha2 are ISO/IEC 8859-1, then perhaps u8 is a better type for those
> > > fields?
> > 
> > Oh, that's a good point, you're not splitting hairs, you're correct, I should
> > change it to u8 and convert it to an ASCII char for display.
> 
> Yeah. I think it is up to whatever consumes the attribute - user-space -
> to figure out how to display it.
> 
> > > >  	u8  fw_name[12];	/* Firmware name string                */
> > > >  	u32 fw_version;		/* Firmware version                   */
> > > >  	u16 pci_ids[4];		/* PCI identification                 */
> > > > diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
> > > > index d27f4eccce6d..fe681680b5d9 100644
> > > > --- a/net/ncsi/ncsi-netlink.c
> > > > +++ b/net/ncsi/ncsi-netlink.c
> > > > @@ -71,8 +71,8 @@ static int ncsi_write_channel_info(struct sk_buff *skb,
> > > >  	if (nc == nc->package->preferred_channel)
> > > >  		nla_put_flag(skb, NCSI_CHANNEL_ATTR_FORCED);
> > > >  
> > > > -	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MAJOR, nc->version.version);
> > > > -	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MINOR, nc->version.alpha2);
> > > > +	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MAJOR, nc->version.major);
> > > > +	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MINOR, nc->version.minor);
> > > 
> > > Maybe for backwards compatibility, NCSI_CHANNEL_ATTR_VERSION_MAJOR and
> > > NCSI_CHANNEL_ATTR_VERSION_MINOR should continue to be used in the old,
> > > broken way? Just a thought. Not sure if it is a good one.
> > 
> > Yeah, probably a good idea. Another way would be to keep the same NCSI
> > attribute name, but use a kernel config to control the behavior. That seems
> > complicated and error prone though.
> > 
> > If you're trying to have a userspace netlink program that's portable to
> > multiple linux images, changing the behavior of the version attributes
> > significantly like that through a kernel config would be completely opaque to
> > the userspace program.
> 
> Yes, I don't think we should use that approach.
> IMHO, the idea is for the interface to be consistent.
> 
> > Having separate attribute names makes it easy to just ignore whichever
> > attribute isn't available (doesn't return a response/etc).
> 
> Yes, if we want compatibility I think that is the way to go.
> 
> > I'm not totally sure what the attribute names should be, but I'm sure we can
> > figure something out. I'll just post something and you guys can comment on it
> > if I choose something weird.
> 
> Good plan.
> 
> > > In any case, I do wonder if all the extracted version fields, including,
> > > update, alpha1 and alpha2 should be sent over netlink. I.e. using some
> > > new (u8) attributes.
> > 
> > Probably, yeah. I'll include this in the next update.
> > 
> > > 
> > > >  	nla_put_string(skb, NCSI_CHANNEL_ATTR_VERSION_STR, nc->version.fw_name);
> > > >  
> > > >  	vid_nest = nla_nest_start_noflag(skb, NCSI_CHANNEL_ATTR_VLAN_LIST);
> > > > diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h
> > > > index ba66c7dc3a21..c9d1da34dc4d 100644
> > > > --- a/net/ncsi/ncsi-pkt.h
> > > > +++ b/net/ncsi/ncsi-pkt.h
> > > > @@ -197,9 +197,12 @@ struct ncsi_rsp_gls_pkt {
> > > >  /* Get Version ID */
> > > >  struct ncsi_rsp_gvi_pkt {
> > > >  	struct ncsi_rsp_pkt_hdr rsp;          /* Response header */
> > > > -	__be32                  ncsi_version; /* NCSI version    */
> > > > +	unsigned char           major;        /* NCSI version major */
> > > > +	unsigned char           minor;        /* NCSI version minor */
> > > > +	unsigned char           update;       /* NCSI version update */
> > > > +	unsigned char           alpha1;       /* NCSI version alpha1 */
> > > >  	unsigned char           reserved[3];  /* Reserved        */
> > > > -	unsigned char           alpha2;       /* NCSI version    */
> > > > +	unsigned char           alpha2;       /* NCSI version alpha2 */
> > > 
> > > Again, I wonder about u8 vs char here. But it's just splitting hairs.
> > 
> > Yeah, I guess I was using "unsigned char" because it seemed like all the
> > structs are using "unsigned char" instead of "u8", but it really probably
> > should be a u8 from the start. Especially true for the major, minor, and update
> > fields.
> 
> Maybe it is better for consistency. I am unsure.
> 
> > > >  	unsigned char           fw_name[12];  /* f/w name string */
> > > 
> > > Also, not strictly related to this patch, but in reading
> > > DSP0222 1.1.1 [4], section 8.4.44.3 I note that the firmware name,
> > > which I assume this field holds, is also ISO/IEC 8859-1 encoded
> > > (as opposed to ASCII). I wonder if there are any oversights
> > > in that area in the code.
> > 
> > Oh! Hrrrrmmm yeah. Ugh. I guess I'll leave that alone for now, I think people
> > are actually building stuff that queries the firmware version, and higher level
> > tooling is probably checking specific string values, and they might not be case
> > insensitive.
> > 
> > People can't actually compile userspace programs against this directly, so
> > changing this internal header struct field would be fine, but if we actually
> > change the firmware name string appearance so that it becomes ALL_CAPS instead
> > of lowercase/etc, that behavior change might break something.
> 
> I think as long as the value ends up in user-space - byte for byte
> accurate. Then user-space can future out what to do with it.
> So perhaps things are ok here. In any case, it's not strictly
> related to this patch. So let's leave it for now.
> 
> > > >  	__be32                  fw_version;   /* f/w version     */
> > > >  	__be16                  pci_ids[4];   /* PCI IDs         */
> > > > diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> > > > index 6447a09932f5..7a805b86a12d 100644
> > > > --- a/net/ncsi/ncsi-rsp.c
> > > > +++ b/net/ncsi/ncsi-rsp.c
> > > > @@ -19,6 +19,19 @@
> > > >  #include "ncsi-pkt.h"
> > > >  #include "ncsi-netlink.h"
> > > >  
> > > > +/* Nibbles within [0xA, 0xF] add zero "0" to the returned value.
> > > > + * Optional fields (encoded as 0xFF) will default to zero.
> > > > + */
> > > 
> > > I agree this makes sense. But did you find reference to this
> > > being the BCD encoding for NC-SI versions? I feel that I'm missing
> > > something obvious here.
> > 
> > This is transcribing a few lines from the spec into comments: I might want to
> > just quote the spec directly, and reference the section and document name
> > instead.
> > 
> > "The value 0xF in the most-significant nibble of a BCD-encoded value indicates
> > that the most significant nibble should be ignored and the overall field
> > treated as a single digit value."
> > 
> > "A value of 0xFF in the update field indicates that the entire field is not
> > present. 0xFF is not allowed as a value for the major or minor fields."
> > 
> > DSP0222 1.1.1 8.4.44.1 NC-SI Version encoding
> 
> I think quoting the spec is good.
> And the treatment of 0xF and 0xFF is clear to me.
> But what I am still a little unclear on the treatment of [0xA, 0xE].

Oh, right. I guess it's undefined behavior.

I guess my thought was that we could probably just map [0xA, 0xE] to a zero nibble

But, perhaps we should also emit a warning or error of some kind when that happens.

And, perhaps we should make the entire *byte* zero in that case, to avoid
producing some kind of partial value that the users weren't intending.

I guess I'll try that: I'll make sure the entire byte is 0, and add an error
trace so users can see the raw value.

- Peter

> 
> > > The code below looks good to me: I think it matches your reasoning above :)
> > 
> > :)
> > 
> > > 
> > > > +static u8 decode_bcd_u8(u8 x)
> > > > +{
> > > > +	int lo = x & 0xF;
> > > > +	int hi = x >> 4;
> > > > +
> > > > +	lo = lo < 0xA ? lo : 0;
> > > > +	hi = hi < 0xA ? hi : 0;
> > > > +	return lo + hi * 10;
> > > > +}
> > > > +
> > > >  static int ncsi_validate_rsp_pkt(struct ncsi_request *nr,
> > > >  				 unsigned short payload)
> > > >  {
> > > > @@ -804,9 +817,18 @@ static int ncsi_rsp_handler_gvi(struct ncsi_request *nr)
> > > >  	if (!nc)
> > > >  		return -ENODEV;
> > > >  
> > > > -	/* Update to channel's version info */
> > > > +	/* Update channel's version info
> > > > +	 *
> > > > +	 * Major, minor, and update fields are supposed to be
> > > > +	 * unsigned integers encoded as packed BCD.
> > > > +	 *
> > > > +	 * Alpha1 and alpha2 are ISO/IEC 8859-1 characters.
> > > > +	 */
> > > >  	ncv = &nc->version;
> > > > -	ncv->version = ntohl(rsp->ncsi_version);
> > > > +	ncv->major = decode_bcd_u8(rsp->major);
> > > > +	ncv->minor = decode_bcd_u8(rsp->minor);
> > > > +	ncv->update = decode_bcd_u8(rsp->update);
> > > > +	ncv->alpha1 = rsp->alpha1;
> > > >  	ncv->alpha2 = rsp->alpha2;
> > > >  	memcpy(ncv->fw_name, rsp->fw_name, 12);
> > > >  	ncv->fw_version = ntohl(rsp->fw_version);
> > > > -- 
> > > > 2.30.2
> > > > 
