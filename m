Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DAF432635
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhJRSTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhJRSTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:19:46 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAECC06161C;
        Mon, 18 Oct 2021 11:17:35 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id f11so11481640pfc.12;
        Mon, 18 Oct 2021 11:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:content-transfer-encoding:cc:subject:from:to:date
         :message-id:in-reply-to;
        bh=xG2V10dbQxXZRKzxcPNkg2WrjAHWGJ5Nrk2gq2FG3bI=;
        b=bxprCEV0TBO4qcc8Scl8zYwC1Kp5LvDqQ725CQF0noyKm2OoTn9BDl1CdqldvRonMp
         Wyam1lCgAGqltzS143lmf8zMOZvH5FCfUiWhhnbtNWGWTX1/v5frNHxHQdnG5DCD0zwl
         /JoC+JxiqbqJOdcZBOqnyhwhmEmzKGR+Pci6d2KtFUiseW6FqRga6WeElSqtkowLX4mC
         JlXlSnxjvDDuMrA30dA1wnWlod3+BOqqO4qQobsT0z6OjSfFiCiYBx6C76tibscb4QrN
         7ojZRjr1F3dbqN8qJbjnCl3gFuxuFBe58iGvrS0SP8X7Kw24oXINH5nazzUAg0lRrmZX
         xVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:cc
         :subject:from:to:date:message-id:in-reply-to;
        bh=xG2V10dbQxXZRKzxcPNkg2WrjAHWGJ5Nrk2gq2FG3bI=;
        b=j2ZBlpFUpfqwv5EuaKB/Fn21IEVU7Ww9IfHb7oC2nh2fysxeWJTrlnA+8RiKuenERS
         hlaNyw1XrGrRYsLjs/csseXzQIiHCbwyLWnNUyiDgagyKwLONCTat888B0VRUohP6gn8
         h4fErErr2ZMM/qRuueJBbb/Qq/z7uo1UiwEtRjaWXhCrLESKczsW3bGQdHAd0ZKvFV3x
         b+BJW4GBFJpa5/U9lBxchc+6phWOt1v0PFI6+go48xN2og6qwAJFHdw5Y8sKGL3Ye8ll
         2Vl7I4N5rUxTuKzdxuXyJZ3F0+SlWmo9wYXIOlf2vRmAHyE28jhLw/xaauTMJtg3wnmd
         7DXQ==
X-Gm-Message-State: AOAM532iYuPmxG7R5AWMRaPI4ceDRX8+xZRs1WVr7SZ0t8H/S9lmRVgN
        F4IyU4yS01K4+bTCJPwsIIE=
X-Google-Smtp-Source: ABdhPJzUIafIGbVjOnyWZp8mokM3rzQC+UY9Mrc0de1qagY5eE9N8iJEvmY6jGBI8XRHdrwaRcSX+Q==
X-Received: by 2002:a05:6a00:1a8e:b0:44c:5f27:e971 with SMTP id e14-20020a056a001a8e00b0044c5f27e971mr30715410pfv.72.1634581054459;
        Mon, 18 Oct 2021 11:17:34 -0700 (PDT)
Received: from localhost ([117.200.53.211])
        by smtp.gmail.com with ESMTPSA id t3sm13224402pgu.87.2021.10.18.11.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:17:34 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "Vladimir Lypak" <vladimir.lypak@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [PATCH 10/17] net: ipa: Add support for IPA v2.x commands and
 table init
From:   "Sireesh Kodali" <sireeshkodali1@gmail.com>
To:     "Alex Elder" <elder@ieee.org>, <phone-devel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <elder@kernel.org>
Date:   Mon, 18 Oct 2021 23:43:55 +0530
Message-Id: <CF2QJPAQGK4Z.1CL422FA9KAY4@skynet-linux>
In-Reply-To: <b4e13fa5-7ac0-6ce5-28d6-e9946fe039f2@ieee.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Oct 14, 2021 at 4:00 AM IST, Alex Elder wrote:
> On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> > IPA v2.x commands are different from later IPA revisions mostly because
> > of the fact that IPA v2.x is 32 bit. There are also other minor
> > differences some of the command structs.
> >=20
> > The tables again are only different because of the fact that IPA v2.x i=
s
> > 32 bit.
>
> There's no "RFC" on this patch, but I assume it's just invisible.

Eep, I forgot to the tag to this patch

>
> There are some things in here where some conventions used elsewhere
> in the driver aren't as well followed. One example is the use of
> symbol names with IPA version encoded in them; such cases usually
> have a macro that takes a version as argument.

Got it, I'll fix that

>
> And I don't especially like using a macro on the left hand side
> of an assignment expression.
>

That's fair, I'll try comming up with a more clean solution here

Regards,
Sireesh
> I'm skimming now, but overall this looks OK.
>
> -Alex
>
> > Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> > Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> > ---
> >   drivers/net/ipa/ipa.h       |   2 +-
> >   drivers/net/ipa/ipa_cmd.c   | 138 ++++++++++++++++++++++++++---------=
-
> >   drivers/net/ipa/ipa_table.c |  29 ++++++--
> >   drivers/net/ipa/ipa_table.h |   2 +-
> >   4 files changed, 125 insertions(+), 46 deletions(-)
> >=20
> > diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
> > index 80a83ac45729..63b2b368b588 100644
> > --- a/drivers/net/ipa/ipa.h
> > +++ b/drivers/net/ipa/ipa.h
> > @@ -81,7 +81,7 @@ struct ipa {
> >   	struct ipa_power *power;
> >  =20
> >   	dma_addr_t table_addr;
> > -	__le64 *table_virt;
> > +	void *table_virt;
> >  =20
> >   	struct ipa_interrupt *interrupt;
> >   	bool uc_powered;
> > diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
> > index 7a104540dc26..58dae4b3bf87 100644
> > --- a/drivers/net/ipa/ipa_cmd.c
> > +++ b/drivers/net/ipa/ipa_cmd.c
> > @@ -25,8 +25,8 @@
> >    * An immediate command is generally used to request the IPA do somet=
hing
> >    * other than data transfer to another endpoint.
> >    *
> > - * Immediate commands are represented by GSI transactions just like ot=
her
> > - * transfer requests, represented by a single GSI TRE.  Each immediate
> > + * Immediate commands on IPA v3 are represented by GSI transactions ju=
st like
> > + * other transfer requests, represented by a single GSI TRE.  Each imm=
ediate
> >    * command has a well-defined format, having a payload of a known len=
gth.
> >    * This allows the transfer element's length field to be used to hold=
 an
> >    * immediate command's opcode.  The payload for a command resides in =
DRAM
> > @@ -45,10 +45,16 @@ enum pipeline_clear_options {
> >  =20
> >   /* IPA_CMD_IP_V{4,6}_{FILTER,ROUTING}_INIT */
> >  =20
> > -struct ipa_cmd_hw_ip_fltrt_init {
> > -	__le64 hash_rules_addr;
> > -	__le64 flags;
> > -	__le64 nhash_rules_addr;
> > +union ipa_cmd_hw_ip_fltrt_init {
> > +	struct {
> > +		__le32 nhash_rules_addr;
> > +		__le32 flags;
> > +	} v2;
> > +	struct {
> > +		__le64 hash_rules_addr;
> > +		__le64 flags;
> > +		__le64 nhash_rules_addr;
> > +	} v3;
> >   };
> >  =20
> >   /* Field masks for ipa_cmd_hw_ip_fltrt_init structure fields */
> > @@ -56,13 +62,23 @@ struct ipa_cmd_hw_ip_fltrt_init {
> >   #define IP_FLTRT_FLAGS_HASH_ADDR_FMASK			GENMASK_ULL(27, 12)
> >   #define IP_FLTRT_FLAGS_NHASH_SIZE_FMASK			GENMASK_ULL(39, 28)
> >   #define IP_FLTRT_FLAGS_NHASH_ADDR_FMASK			GENMASK_ULL(55, 40)
> > +#define IP_V2_IPV4_FLTRT_FLAGS_SIZE_FMASK		GENMASK_ULL(11, 0)
> > +#define IP_V2_IPV4_FLTRT_FLAGS_ADDR_FMASK		GENMASK_ULL(27, 12)
> > +#define IP_V2_IPV6_FLTRT_FLAGS_SIZE_FMASK		GENMASK_ULL(15, 0)
> > +#define IP_V2_IPV6_FLTRT_FLAGS_ADDR_FMASK		GENMASK_ULL(31, 16)
> >  =20
> >   /* IPA_CMD_HDR_INIT_LOCAL */
> >  =20
> > -struct ipa_cmd_hw_hdr_init_local {
> > -	__le64 hdr_table_addr;
> > -	__le32 flags;
> > -	__le32 reserved;
> > +union ipa_cmd_hw_hdr_init_local {
> > +	struct {
> > +		__le32 hdr_table_addr;
> > +		__le32 flags;
> > +	} v2;
> > +	struct {
> > +		__le64 hdr_table_addr;
> > +		__le32 flags;
> > +		__le32 reserved;
> > +	} v3;
> >   };
> >  =20
> >   /* Field masks for ipa_cmd_hw_hdr_init_local structure fields */
> > @@ -109,14 +125,37 @@ struct ipa_cmd_ip_packet_init {
> >   #define DMA_SHARED_MEM_OPCODE_SKIP_CLEAR_FMASK		GENMASK(8, 8)
> >   #define DMA_SHARED_MEM_OPCODE_CLEAR_OPTION_FMASK	GENMASK(10, 9)
> >  =20
> > -struct ipa_cmd_hw_dma_mem_mem {
> > -	__le16 clear_after_read; /* 0 or DMA_SHARED_MEM_CLEAR_AFTER_READ */
> > -	__le16 size;
> > -	__le16 local_addr;
> > -	__le16 flags;
> > -	__le64 system_addr;
> > +union ipa_cmd_hw_dma_mem_mem {
> > +	struct {
> > +		__le16 reserved;
> > +		__le16 size;
> > +		__le32 system_addr;
> > +		__le16 local_addr;
> > +		__le16 flags; /* the least significant 14 bits are reserved */
> > +		__le32 padding;
> > +	} v2;
> > +	struct {
> > +		__le16 clear_after_read; /* 0 or DMA_SHARED_MEM_CLEAR_AFTER_READ */
> > +		__le16 size;
> > +		__le16 local_addr;
> > +		__le16 flags;
> > +		__le64 system_addr;
> > +	} v3;
> >   };
> >  =20
> > +#define CMD_FIELD(_version, _payload, _field)				\
> > +	*(((_version) > IPA_VERSION_2_6L) ?		    		\
> > +	  &(_payload->v3._field) :			    		\
> > +	  &(_payload->v2._field))
> > +
> > +#define SET_DMA_FIELD(_ver, _payload, _field, _value)			\
> > +	do {								\
> > +		if ((_ver) >=3D IPA_VERSION_3_0)				\
> > +			(_payload)->v3._field =3D cpu_to_le64(_value);	\
> > +		else							\
> > +			(_payload)->v2._field =3D cpu_to_le32(_value);	\
> > +	} while (0)
> > +
> >   /* Flag allowing atomic clear of target region after reading data (v4=
.0+)*/
> >   #define DMA_SHARED_MEM_CLEAR_AFTER_READ			GENMASK(15, 15)
> >  =20
> > @@ -132,15 +171,16 @@ struct ipa_cmd_ip_packet_tag_status {
> >   	__le64 tag;
> >   };
> >  =20
> > -#define IP_PACKET_TAG_STATUS_TAG_FMASK			GENMASK_ULL(63, 16)
> > +#define IPA_V2_IP_PACKET_TAG_STATUS_TAG_FMASK		GENMASK_ULL(63, 32)
> > +#define IPA_V3_IP_PACKET_TAG_STATUS_TAG_FMASK		GENMASK_ULL(63, 16)
> >  =20
> >   /* Immediate command payload */
> >   union ipa_cmd_payload {
> > -	struct ipa_cmd_hw_ip_fltrt_init table_init;
> > -	struct ipa_cmd_hw_hdr_init_local hdr_init_local;
> > +	union ipa_cmd_hw_ip_fltrt_init table_init;
> > +	union ipa_cmd_hw_hdr_init_local hdr_init_local;
> >   	struct ipa_cmd_register_write register_write;
> >   	struct ipa_cmd_ip_packet_init ip_packet_init;
> > -	struct ipa_cmd_hw_dma_mem_mem dma_shared_mem;
> > +	union ipa_cmd_hw_dma_mem_mem dma_shared_mem;
> >   	struct ipa_cmd_ip_packet_tag_status ip_packet_tag_status;
> >   };
> >  =20
> > @@ -154,6 +194,7 @@ static void ipa_cmd_validate_build(void)
> >   	 * of entries.
> >   	 */
> >   #define TABLE_SIZE	(TABLE_COUNT_MAX * sizeof(__le64))
> > +// TODO
> >   #define TABLE_COUNT_MAX	max_t(u32, IPA_ROUTE_COUNT_MAX, IPA_FILTER_CO=
UNT_MAX)
> >   	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_HASH_SIZE_FMASK))=
;
> >   	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK)=
);
> > @@ -405,15 +446,26 @@ void ipa_cmd_table_init_add(struct ipa_trans *tra=
ns,
> >   {
> >   	struct ipa *ipa =3D container_of(trans->dma_subsys, struct ipa, dma_=
subsys);
> >   	enum dma_data_direction direction =3D DMA_TO_DEVICE;
> > -	struct ipa_cmd_hw_ip_fltrt_init *payload;
> > +	union ipa_cmd_hw_ip_fltrt_init *payload;
> > +	enum ipa_version version =3D ipa->version;
> >   	union ipa_cmd_payload *cmd_payload;
> >   	dma_addr_t payload_addr;
> >   	u64 val;
> >  =20
> >   	/* Record the non-hash table offset and size */
> >   	offset +=3D ipa->mem_offset;
> > -	val =3D u64_encode_bits(offset, IP_FLTRT_FLAGS_NHASH_ADDR_FMASK);
> > -	val |=3D u64_encode_bits(size, IP_FLTRT_FLAGS_NHASH_SIZE_FMASK);
> > +
> > +	if (version >=3D IPA_VERSION_3_0) {
> > +		val =3D u64_encode_bits(offset, IP_FLTRT_FLAGS_NHASH_ADDR_FMASK);
> > +		val |=3D u64_encode_bits(size, IP_FLTRT_FLAGS_NHASH_SIZE_FMASK);
> > +	} else if (opcode =3D=3D IPA_CMD_IP_V4_FILTER_INIT ||
> > +		   opcode =3D=3D IPA_CMD_IP_V4_ROUTING_INIT) {
> > +		val =3D u64_encode_bits(offset, IP_V2_IPV4_FLTRT_FLAGS_ADDR_FMASK);
> > +		val |=3D u64_encode_bits(size, IP_V2_IPV4_FLTRT_FLAGS_SIZE_FMASK);
> > +	} else { /* IPA <=3D v2.6L IPv6 */
> > +		val =3D u64_encode_bits(offset, IP_V2_IPV6_FLTRT_FLAGS_ADDR_FMASK);
> > +		val |=3D u64_encode_bits(size, IP_V2_IPV6_FLTRT_FLAGS_SIZE_FMASK);
> > +	}
> >  =20
> >   	/* The hash table offset and address are zero if its size is 0 */
> >   	if (hash_size) {
> > @@ -429,10 +481,10 @@ void ipa_cmd_table_init_add(struct ipa_trans *tra=
ns,
> >   	payload =3D &cmd_payload->table_init;
> >  =20
> >   	/* Fill in all offsets and sizes and the non-hash table address */
> > -	if (hash_size)
> > -		payload->hash_rules_addr =3D cpu_to_le64(hash_addr);
> > -	payload->flags =3D cpu_to_le64(val);
> > -	payload->nhash_rules_addr =3D cpu_to_le64(addr);
> > +	if (hash_size && version >=3D IPA_VERSION_3_0)
> > +		payload->v3.hash_rules_addr =3D cpu_to_le64(hash_addr);
> > +	SET_DMA_FIELD(version, payload, flags, val);
> > +	SET_DMA_FIELD(version, payload, nhash_rules_addr, addr);
> >  =20
> >   	ipa_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
> >   			  direction, opcode);
> > @@ -445,7 +497,7 @@ void ipa_cmd_hdr_init_local_add(struct ipa_trans *t=
rans, u32 offset, u16 size,
> >   	struct ipa *ipa =3D container_of(trans->dma_subsys, struct ipa, dma_=
subsys);
> >   	enum ipa_cmd_opcode opcode =3D IPA_CMD_HDR_INIT_LOCAL;
> >   	enum dma_data_direction direction =3D DMA_TO_DEVICE;
> > -	struct ipa_cmd_hw_hdr_init_local *payload;
> > +	union ipa_cmd_hw_hdr_init_local *payload;
> >   	union ipa_cmd_payload *cmd_payload;
> >   	dma_addr_t payload_addr;
> >   	u32 flags;
> > @@ -460,10 +512,10 @@ void ipa_cmd_hdr_init_local_add(struct ipa_trans =
*trans, u32 offset, u16 size,
> >   	cmd_payload =3D ipa_cmd_payload_alloc(ipa, &payload_addr);
> >   	payload =3D &cmd_payload->hdr_init_local;
> >  =20
> > -	payload->hdr_table_addr =3D cpu_to_le64(addr);
> > +	SET_DMA_FIELD(ipa->version, payload, hdr_table_addr, addr);
> >   	flags =3D u32_encode_bits(size, HDR_INIT_LOCAL_FLAGS_TABLE_SIZE_FMAS=
K);
> >   	flags |=3D u32_encode_bits(offset, HDR_INIT_LOCAL_FLAGS_HDR_ADDR_FMA=
SK);
> > -	payload->flags =3D cpu_to_le32(flags);
> > +	CMD_FIELD(ipa->version, payload, flags) =3D cpu_to_le32(flags);
> >  =20
> >   	ipa_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
> >   			  direction, opcode);
> > @@ -509,8 +561,11 @@ void ipa_cmd_register_write_add(struct ipa_trans *=
trans, u32 offset, u32 value,
> >  =20
> >   	} else {
> >   		flags =3D 0;	/* SKIP_CLEAR flag is always 0 */
> > -		options =3D u16_encode_bits(clear_option,
> > -					  REGISTER_WRITE_CLEAR_OPTIONS_FMASK);
> > +		if (ipa->version > IPA_VERSION_2_6L)
> > +			options =3D u16_encode_bits(clear_option,
> > +					REGISTER_WRITE_CLEAR_OPTIONS_FMASK);
> > +		else
> > +			options =3D 0;
> >   	}
> >  =20
> >   	cmd_payload =3D ipa_cmd_payload_alloc(ipa, &payload_addr);
> > @@ -552,7 +607,8 @@ void ipa_cmd_dma_shared_mem_add(struct ipa_trans *t=
rans, u32 offset, u16 size,
> >   {
> >   	struct ipa *ipa =3D container_of(trans->dma_subsys, struct ipa, dma_=
subsys);
> >   	enum ipa_cmd_opcode opcode =3D IPA_CMD_DMA_SHARED_MEM;
> > -	struct ipa_cmd_hw_dma_mem_mem *payload;
> > +	enum ipa_version version =3D ipa->version;
> > +	union ipa_cmd_hw_dma_mem_mem *payload;
> >   	union ipa_cmd_payload *cmd_payload;
> >   	enum dma_data_direction direction;
> >   	dma_addr_t payload_addr;
> > @@ -571,8 +627,8 @@ void ipa_cmd_dma_shared_mem_add(struct ipa_trans *t=
rans, u32 offset, u16 size,
> >   	/* payload->clear_after_read was reserved prior to IPA v4.0.  It's
> >   	 * never needed for current code, so it's 0 regardless of version.
> >   	 */
> > -	payload->size =3D cpu_to_le16(size);
> > -	payload->local_addr =3D cpu_to_le16(offset);
> > +	CMD_FIELD(version, payload, size) =3D cpu_to_le16(size);
> > +	CMD_FIELD(version, payload, local_addr) =3D cpu_to_le16(offset);
> >   	/* payload->flags:
> >   	 *   direction:		0 =3D write to IPA, 1 read from IPA
> >   	 * Starting at v4.0 these are reserved; either way, all zero:
> > @@ -582,8 +638,8 @@ void ipa_cmd_dma_shared_mem_add(struct ipa_trans *t=
rans, u32 offset, u16 size,
> >   	 * since both values are 0 we won't bother OR'ing them in.
> >   	 */
> >   	flags =3D toward_ipa ? 0 : DMA_SHARED_MEM_FLAGS_DIRECTION_FMASK;
> > -	payload->flags =3D cpu_to_le16(flags);
> > -	payload->system_addr =3D cpu_to_le64(addr);
> > +	CMD_FIELD(version, payload, flags) =3D cpu_to_le16(flags);
> > +	SET_DMA_FIELD(version, payload, system_addr, addr);
> >  =20
> >   	direction =3D toward_ipa ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> >  =20
> > @@ -599,11 +655,17 @@ static void ipa_cmd_ip_tag_status_add(struct ipa_=
trans *trans)
> >   	struct ipa_cmd_ip_packet_tag_status *payload;
> >   	union ipa_cmd_payload *cmd_payload;
> >   	dma_addr_t payload_addr;
> > +	u64 tag_mask;
> > +
> > +	if (trans->dma_subsys->version <=3D IPA_VERSION_2_6L)
> > +		tag_mask =3D IPA_V2_IP_PACKET_TAG_STATUS_TAG_FMASK;
> > +	else
> > +		tag_mask =3D IPA_V3_IP_PACKET_TAG_STATUS_TAG_FMASK;
> >  =20
> >   	cmd_payload =3D ipa_cmd_payload_alloc(ipa, &payload_addr);
> >   	payload =3D &cmd_payload->ip_packet_tag_status;
> >  =20
> > -	payload->tag =3D le64_encode_bits(0, IP_PACKET_TAG_STATUS_TAG_FMASK);
> > +	payload->tag =3D le64_encode_bits(0, tag_mask);
> >  =20
> >   	ipa_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
> >   			  direction, opcode);
> > diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
> > index d197959cc032..459fb4830244 100644
> > --- a/drivers/net/ipa/ipa_table.c
> > +++ b/drivers/net/ipa/ipa_table.c
> > @@ -8,6 +8,7 @@
> >   #include <linux/kernel.h>
> >   #include <linux/bits.h>
> >   #include <linux/bitops.h>
> > +#include <linux/module.h>
> >   #include <linux/bitfield.h>
> >   #include <linux/io.h>
> >   #include <linux/build_bug.h>
> > @@ -561,6 +562,19 @@ void ipa_table_config(struct ipa *ipa)
> >   	ipa_route_config(ipa, true);
> >   }
> >  =20
> > +static inline void *ipa_table_write(enum ipa_version version,
> > +				   void *virt, u64 value)
> > +{
> > +	if (IPA_IS_64BIT(version)) {
> > +		__le64 *ptr =3D virt;
> > +		*ptr =3D cpu_to_le64(value);
> > +	} else {
> > +		__le32 *ptr =3D virt;
> > +		*ptr =3D cpu_to_le32(value);
> > +	}
> > +	return virt + IPA_TABLE_ENTRY_SIZE(version);
> > +}
> > +
> >   /*
> >    * Initialize a coherent DMA allocation containing initialized filter=
 and
> >    * route table data.  This is used when initializing or resetting the=
 IPA
> > @@ -602,10 +616,11 @@ void ipa_table_config(struct ipa *ipa)
> >   int ipa_table_init(struct ipa *ipa)
> >   {
> >   	u32 count =3D max_t(u32, IPA_FILTER_COUNT_MAX, IPA_ROUTE_COUNT_MAX);
> > +	enum ipa_version version =3D ipa->version;
> >   	struct device *dev =3D &ipa->pdev->dev;
> > +	u64 filter_map =3D ipa->filter_map << 1;
> >   	dma_addr_t addr;
> > -	__le64 le_addr;
> > -	__le64 *virt;
> > +	void *virt;
> >   	size_t size;
> >  =20
> >   	ipa_table_validate_build();
> > @@ -626,19 +641,21 @@ int ipa_table_init(struct ipa *ipa)
> >   	ipa->table_addr =3D addr;
> >  =20
> >   	/* First slot is the zero rule */
> > -	*virt++ =3D 0;
> > +	virt =3D ipa_table_write(version, virt, 0);
> >  =20
> >   	/* Next is the filter table bitmap.  The "soft" bitmap value
> >   	 * must be converted to the hardware representation by shifting
> >   	 * it left one position.  (Bit 0 repesents global filtering,
> >   	 * which is possible but not used.)
> >   	 */
> > -	*virt++ =3D cpu_to_le64((u64)ipa->filter_map << 1);
> > +	if (version <=3D IPA_VERSION_2_6L)
> > +		filter_map |=3D 1;
> > +
> > +	virt =3D ipa_table_write(version, virt, filter_map);
> >  =20
> >   	/* All the rest contain the DMA address of the zero rule */
> > -	le_addr =3D cpu_to_le64(addr);
> >   	while (count--)
> > -		*virt++ =3D le_addr;
> > +		virt =3D ipa_table_write(version, virt, addr);
> >  =20
> >   	return 0;
> >   }
> > diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
> > index 78a168ce6558..6e12fc49e45b 100644
> > --- a/drivers/net/ipa/ipa_table.h
> > +++ b/drivers/net/ipa/ipa_table.h
> > @@ -43,7 +43,7 @@ bool ipa_filter_map_valid(struct ipa *ipa, u32 filter=
_mask);
> >    */
> >   static inline bool ipa_table_hash_support(struct ipa *ipa)
> >   {
> > -	return ipa->version !=3D IPA_VERSION_4_2;
> > +	return ipa->version !=3D IPA_VERSION_4_2 && ipa->version > IPA_VERSIO=
N_2_6L;
> >   }
> >  =20
> >   /**
> >=20

