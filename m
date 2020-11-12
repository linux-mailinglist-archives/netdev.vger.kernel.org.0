Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5D72B1030
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 22:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgKLVYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 16:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgKLVYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 16:24:51 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C297C0613D1;
        Thu, 12 Nov 2020 13:24:51 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id y9so6653884ilb.0;
        Thu, 12 Nov 2020 13:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KY+fetJTQ0uyCyC4GA+dEDEYAXCIGrxen39IRgYS6L8=;
        b=GwljVyP4hvV93LMSxoQHAebf2Z+7b/QgdHM26IokLnoVqsnp7H8UPGSpEhQKEk+cwW
         fdULth7FFs+UDDmgaItz/oe1Ryolx1wO/zxsv6ch77akS/lPA+UwzzDgOzxNAO8pfU1B
         9dwhKVjeQgKU4IfwPtnh/4cvFa2jYcal/elOScx9Z0GY1AznZrEs8s2Imsh80v23y2Cd
         QWOvNnV7eeGWVmtMnJCccsTkE3o+abC8ou83FANpg8qthjzhY/zZ1G2KfilmHKCH6K+i
         Uk+uUSm+XP7z4t+aPrRcV9nUoeQog4ZbCV2oS7nTg+3gNT9u80ivUOfMzkBKANSuDoQb
         AatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KY+fetJTQ0uyCyC4GA+dEDEYAXCIGrxen39IRgYS6L8=;
        b=UMJti7honoN7jCsZuR0tBUUwI2tgEUDui3Qh2D1zP7UOg3MIsxAz7GQYWEs4An0nVV
         6cFYIzZJ1CDMlMVz5LWFrvY3gTURwZhVkCoBKfHLaOVZNWkL/dZ2pNTgndS9gaZ3gEzW
         ZRDDmu8pA/mSYSIUa/h0HHTqB0fgpWVeHh42uPDIfUPhM+hATUsCt7sGy6a40ymtEL8Y
         TwDH+yQ1Pf1JyXPyFjarGnRYFB/CxWYyj1ct8enoF4LccXIGl7ujnvsuCeqJ7TCWRjf7
         L++zUxKbVO4Y6S6ex4J2LaBulg65VzJ8xeVoQxjTn3PWpeYieYtHXWY9c3QghIvuUF36
         4Vbg==
X-Gm-Message-State: AOAM532msYsN3XcKu/BMSHKiIayYCsk4fFbVZv8A9xIyOFgto1jtfdhp
        GKnqArgN+mL+l3u1j7gHKDcCqOWgU2rzT3omrYmEUjqmHmY=
X-Google-Smtp-Source: ABdhPJyL0UQdN73jPdrnrLf6VUA7E/x1Jqni2Gpc+qRTC5TQ1bSBKHJFiu7Robbt9bkU9tonm24gQPb6hGh/w90bELk=
X-Received: by 2002:a92:ca86:: with SMTP id t6mr1168266ilo.95.1605216290662;
 Thu, 12 Nov 2020 13:24:50 -0800 (PST)
MIME-Version: 1.0
References: <20201111071404.29620-1-naveenm@marvell.com> <20201111071404.29620-4-naveenm@marvell.com>
In-Reply-To: <20201111071404.29620-4-naveenm@marvell.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 12 Nov 2020 13:24:39 -0800
Message-ID: <CAKgT0Uc64qDVMm3HfXmyPoGYJezaKzEBzw76u6xXkpRqBCXGzA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 03/13] octeontx2-af: Generate key field bit
 mask from KEX profile
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, saeed@kernel.org,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, hkelam@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 11:24 PM Naveen Mamindlapalli
<naveenm@marvell.com> wrote:
>
> From: Subbaraya Sundeep <sbhatta@marvell.com>
>
> Key Extraction(KEX) profile decides how the packet metadata such as
> layer information and selected packet data bytes at each layer are
> placed in MCAM search key. This patch reads the configured KEX profile
> parameters to find out the bit position and bit mask for each field.
> The information is used when programming the MCAM match data by SW
> to match a packet flow and take appropriate action on the flow. This
> patch also verifies the mandatory fields such as channel and DMAC
> are not overwritten by the KEX configuration of other fields.
>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>

A few minor spelling issues, otherwise it looks fine.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

> ---
>  drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  48 ++
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  38 ++
>  .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  11 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 562 +++++++++++++++++++++
>  5 files changed, 658 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
> index 2f7a861d0c7b..ffc681b67f1c 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
> @@ -9,4 +9,4 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
>
>  octeontx2_mbox-y := mbox.o rvu_trace.o
>  octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
> -                 rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o
> +                 rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o rvu_npc_fs.o
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
> index 91a9d00e4fb5..0fe47216f771 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
> @@ -140,6 +140,54 @@ enum npc_kpu_lh_ltype {
>         NPC_LT_LH_CUSTOM1 = 0xF,
>  };
>
> +/* list of known and supported fields in packet header and
> + * fields present in key structure.
> + */
> +enum key_fields {
> +       NPC_DMAC,
> +       NPC_SMAC,
> +       NPC_ETYPE,
> +       NPC_OUTER_VID,
> +       NPC_TOS,
> +       NPC_SIP_IPV4,
> +       NPC_DIP_IPV4,
> +       NPC_SIP_IPV6,
> +       NPC_DIP_IPV6,
> +       NPC_SPORT_TCP,
> +       NPC_DPORT_TCP,
> +       NPC_SPORT_UDP,
> +       NPC_DPORT_UDP,
> +       NPC_SPORT_SCTP,
> +       NPC_DPORT_SCTP,
> +       NPC_HEADER_FIELDS_MAX,
> +       NPC_CHAN = NPC_HEADER_FIELDS_MAX, /* Valid when Rx */
> +       NPC_PF_FUNC, /* Valid when Tx */
> +       NPC_ERRLEV,
> +       NPC_ERRCODE,
> +       NPC_LXMB,
> +       NPC_LA,
> +       NPC_LB,
> +       NPC_LC,
> +       NPC_LD,
> +       NPC_LE,
> +       NPC_LF,
> +       NPC_LG,
> +       NPC_LH,
> +       /* ether type for untagged frame */
> +       NPC_ETYPE_ETHER,
> +       /* ether type for single tagged frame */
> +       NPC_ETYPE_TAG1,
> +       /* ether type for double tagged frame */
> +       NPC_ETYPE_TAG2,
> +       /* outer vlan tci for single tagged frame */
> +       NPC_VLAN_TAG1,
> +       /* outer vlan tci for double tagged frame */
> +       NPC_VLAN_TAG2,
> +       /* other header fields programmed to extract but not of our interest */
> +       NPC_UNKNOWN,
> +       NPC_KEY_FIELDS_MAX,
> +};
> +
>  struct npc_kpu_profile_cam {
>         u8 state;
>         u8 state_mask;
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> index 1724dbd18847..7e556c7b6ccf 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> @@ -15,6 +15,7 @@
>  #include "rvu_struct.h"
>  #include "common.h"
>  #include "mbox.h"
> +#include "npc.h"
>
>  /* PCI device IDs */
>  #define        PCI_DEVID_OCTEONTX2_RVU_AF              0xA065
> @@ -105,6 +106,36 @@ struct nix_mce_list {
>         int                     max;
>  };
>
> +/* layer meta data to uniquely identify a packet header field */

s/meta data/metadata/

> +struct npc_layer_mdata {
> +       u8 lid;
> +       u8 ltype;
> +       u8 hdr;
> +       u8 key;
> +       u8 len;
> +};
> +

<snip>

> +       /* Handle header fields which can come from multiple layers like
> +        * etype, outer vlan tci. These fields should have same position in
> +        * the key otherwise to install a mcam rule more than one entry is
> +        * needed which complicates mcam space management.
> +        */
> +       etype_ether = &key_fields[NPC_ETYPE_ETHER];
> +       etype_tag1 = &key_fields[NPC_ETYPE_TAG1];
> +       etype_tag2 = &key_fields[NPC_ETYPE_TAG2];
> +       vlan_tag1 = &key_fields[NPC_VLAN_TAG1];
> +       vlan_tag2 = &key_fields[NPC_VLAN_TAG2];
> +
> +       /* if key profile programmed does not extract ether type at all */

s/ether type/Ethertype/

> +       if (!etype_ether->nr_kws && !etype_tag1->nr_kws && !etype_tag2->nr_kws)
> +               goto vlan_tci;
> +
> +       /* if key profile programmed extracts ether type from one layer */

Same issue here and a few other places, replace "ether type" with "Ethertype".


> +       if (etype_ether->nr_kws && !etype_tag1->nr_kws && !etype_tag2->nr_kws)
> +               key_fields[NPC_ETYPE] = *etype_ether;
> +       if (!etype_ether->nr_kws && etype_tag1->nr_kws && !etype_tag2->nr_kws)
> +               key_fields[NPC_ETYPE] = *etype_tag1;
> +       if (!etype_ether->nr_kws && !etype_tag1->nr_kw
>
