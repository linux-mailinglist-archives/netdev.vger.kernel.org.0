Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E191EB0F3
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgFAVaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgFAVaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 17:30:16 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDA7C061A0E;
        Mon,  1 Jun 2020 14:30:16 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a127so2020618pfa.12;
        Mon, 01 Jun 2020 14:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EQtsk1rZamt+L4G8tYDHjFumIzjgAUFptfaCOMTLs5I=;
        b=LHTvWjrutz5OmoFHv+8kTy28g1WIaPtNCFNvL4PIi/c5iyQNqngHkpRXkWKl2YS0tH
         AZ34Pd3Ihq4s1qKiSfnDH40OK0TxslADyCRtWvY+CYNbxxa4H+uUmzzUW1mPlq31oRye
         RBm6qw+4GTBywfD2wYiUSPjK1J9m5b7mWizFm10Cz1HO64v0OrKIJgArpISdIMXSSKQF
         mDIHt0aUM5D3myvsh7wR+RBKYbD5aoXhsYp9x/EFOBXOJGzl/FaDTKA81Zp6QVE2qODu
         OmKcW4/5RtC1IAXqYV74FI8nQZutBlkdUod8p1cnRsxbHWzd5yPkBL+iYbX6vxGaa4IH
         MhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EQtsk1rZamt+L4G8tYDHjFumIzjgAUFptfaCOMTLs5I=;
        b=Q7iSge2NrGHPlgDEH7x5rQZ0zQcx2SUpu1AUmjLLKfn89zsB/GlbAwedhruHrLCXUn
         sQdtivYS0JpcTL39n2Q+dL7oWjoW3alchne6z1aU+mg4X16w/WbWbrl/MQYDJTOqUaDl
         oyk+eerevVZMgag/h9/F/SAZjevv1czrWyH6HmuOy0zkqmCYo1vS+rtGqZgxIGWGTTds
         GHhHA7iX7lmSmveIq1BmpXnx72f7MOc8vk9kLP3kfLGBscCq64ag7G0lWjltS9SBIsNC
         Xeg4J8YF516AmRCPvWjiv3VN2AoZEXNxPyeLIdbueBaO4Nuc4f3WrgqAtp1i183IKETY
         SF6Q==
X-Gm-Message-State: AOAM533UideugPhV4z2g3wTxMe4EvxtrIomYo74WWp0mh+D1unXzC1S1
        MYGI+vmuABMhOxilZUa6ouU=
X-Google-Smtp-Source: ABdhPJwBHPqoBmC0pQSc5ljm2ImbrYhbzjonGVGhO7XUIA0l/T7D/X1Jy8pcr3VcGWsQ0QMMCfXEJg==
X-Received: by 2002:a63:546:: with SMTP id 67mr21997234pgf.364.1591047015533;
        Mon, 01 Jun 2020 14:30:15 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:514a])
        by smtp.gmail.com with ESMTPSA id j3sm305963pfh.87.2020.06.01.14.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 14:30:14 -0700 (PDT)
Date:   Mon, 1 Jun 2020 14:30:12 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next RFC 2/3] bpf: devmap dynamic map-value storage
 area based on BTF
Message-ID: <20200601213012.vgt7oqplfbzeddzm@ast-mbp.dhcp.thefacebook.com>
References: <159076794319.1387573.8722376887638960093.stgit@firesoul>
 <159076798566.1387573.8417040652693679408.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159076798566.1387573.8417040652693679408.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 05:59:45PM +0200, Jesper Dangaard Brouer wrote:
> +
> +/* Expected BTF layout that match struct bpf_devmap_val */
> +static const struct expect layout[] = {
> +	{BTF_KIND_INT,		true,	 0,	 4,	"ifindex"},
> +	{BTF_KIND_UNION,	false,	32,	 4,	"bpf_prog"},
> +	{BTF_KIND_STRUCT,	false,	-1,	-1,	"storage"}
> +};
> +
> +static int dev_map_check_btf(const struct bpf_map *map,
> +			     const struct btf *btf,
> +			     const struct btf_type *key_type,
> +			     const struct btf_type *value_type)
> +{
> +	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> +	u32 found_members_cnt = 0;
> +	u32 int_data;
> +	int off;
> +	u32 i;
> +
> +	/* Validate KEY type and size */
> +	if (BTF_INFO_KIND(key_type->info) != BTF_KIND_INT)
> +		return -EOPNOTSUPP;
> +
> +	int_data = *(u32 *)(key_type + 1);
> +	if (BTF_INT_BITS(int_data) != 32 || BTF_INT_OFFSET(int_data) != 0)
> +		return -EOPNOTSUPP;
> +
> +	/* Validate VALUE have layout that match/map-to struct bpf_devmap_val
> +	 * - With a flexible size of member 'storage'.
> +	 */
> +
> +	if (BTF_INFO_KIND(value_type->info) != BTF_KIND_STRUCT)
> +		return -EOPNOTSUPP;
> +
> +	/* Struct/union members in BTF must not exceed (max) expected members */
> +	if (btf_type_vlen(value_type) > ARRAY_SIZE(layout))
> +			return -E2BIG;
> +
> +	for (i = 0; i < ARRAY_SIZE(layout); i++) {
> +		off = btf_find_expect_layout_offset(btf, value_type, &layout[i]);
> +
> +		if (off < 0 && layout[i].mandatory)
> +			return -EUCLEAN;
> +
> +		if (off >= 0)
> +			found_members_cnt++;
> +
> +		/* Transfer layout config to map */
> +		switch (i) {
> +		case 0:
> +			dtab->cfg.btf_offset.ifindex = off;
> +			break;
> +		case 1:
> +			dtab->cfg.btf_offset.bpf_prog = off;
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	/* Detect if BTF/vlen have members that were not found */
> +	if (btf_type_vlen(value_type) > found_members_cnt)
> +		return -E2BIG;
> +
> +	return 0;
> +}

This layout validation looks really weird to me.
That layout[] array sort of complements BTF to describe the data,
but double describe of the layout feels like hack.
I'm with Andrii here. Separate array indexed by ifindex or global array
without map_lookup() can be used with good performance.
I don't think such devamp extension is necessary.
