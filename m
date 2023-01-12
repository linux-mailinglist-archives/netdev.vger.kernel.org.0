Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F9E6668C3
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 03:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbjALCQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 21:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjALCQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 21:16:25 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66668C76D;
        Wed, 11 Jan 2023 18:16:24 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n12so17718163pjp.1;
        Wed, 11 Jan 2023 18:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fspBV6DZyKjfYWdmHZhGcnSsmxAtEkixs60f490utkY=;
        b=lz0TTcOehqmM30rJ87DZaVP4TcmkXJ4XElZqPYvxTeEumyXxy8bzLD60crcJMkshB+
         uEOCv7Pstai1XzyCgnILaW8hBvFLMacpRyCwNN1ciga989YKWDskyRIWglCkstwpESiu
         6HynLO/l4zTuUNWqNTIomHO9c0USPHk9Piqhb6Ej7amTfSVGkL1aKcZT7XGyZjnVy2ND
         tnaHyEqdxowZYWWyiTWWRL+p/hNxYkUOQ7Nsu6X0UavLpiYb843GLcioD1p3nC/SIa8c
         DyznbwQNs8p/1pyDeLW4hjVImKH92uMc6EGAWYyuA4sdUZF+IJSI1g7/DfU5w1v117YV
         A/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fspBV6DZyKjfYWdmHZhGcnSsmxAtEkixs60f490utkY=;
        b=til24rwoNz/rTNfkMzz1HAsLBNYmUhcfH5ma+0PMKI0/96PHlEIfgcXNrVM3Bh6U9U
         6TRas6QYEwCUcm0+Px+CqGe/GI50J5vHMO1H2Za4M6YXBCF+s45zmqAvQGXAipkUTieP
         WHPGTgrdZZ2HGtDVctsgTYT4NJnIHoyRvyLa3ee38OlRMZE3kEg3q2vICuK8B1hEoc/g
         JWCDgCrZ992XFR0oLOJcBoaRlvODIRNh1LWwGuNQfGn0U/qGlT9Emms8ZUc380CUaNMg
         kzvOfk41Uvs8zHrVl4Jm1ogrIw+zBp73hXizCgu/+4HqKncsy73f3MRqgkh4EB0bpg3g
         DTJA==
X-Gm-Message-State: AFqh2kpDeYPiqj+fXpvqh4ON+uo3d8hbs1sNR2vNGal+avv847CKM/OT
        RiOgLY76jPR9jTWd6/ZI2p6e6lgOug0=
X-Google-Smtp-Source: AMrXdXvJaqh5+wZOf42r6QtDq9uvwzg5E7ckITeqapfnVjxU8UrLvL0EU7KsfbN0Wnz03Oa3FvhA9A==
X-Received: by 2002:a17:902:b10d:b0:194:4339:112e with SMTP id q13-20020a170902b10d00b001944339112emr7442075plr.60.1673489783803;
        Wed, 11 Jan 2023 18:16:23 -0800 (PST)
Received: from MacBook-Pro-6.local ([2620:10d:c090:400::5:df0a])
        by smtp.gmail.com with ESMTPSA id b18-20020a170902d51200b00194584647fasm559767plg.158.2023.01.11.18.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 18:16:23 -0800 (PST)
Date:   Wed, 11 Jan 2023 18:16:19 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next v3 11/15] selftests/xsk: get rid of built-in XDP
 program
Message-ID: <20230112021619.m34yf7wf2visdmac@MacBook-Pro-6.local>
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
 <20230111093526.11682-12-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111093526.11682-12-magnus.karlsson@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 10:35:22AM +0100, Magnus Karlsson wrote:
> +xsk_xdp_progs.skel.h-deps := xsk_xdp_progs.bpf.o
...
> diff --git a/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c b/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
> new file mode 100644
> index 000000000000..698176882ac6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
> @@ -0,0 +1,19 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022 Intel */
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_XSKMAP);
> +	__uint(max_entries, 1);
> +	__uint(key_size, sizeof(int));
> +	__uint(value_size, sizeof(int));
> +} xsk SEC(".maps");
> +
> +SEC("xdp") int xsk_def_prog(struct xdp_md *xdp)
> +{
> +	return bpf_redirect_map(&xsk, 0, XDP_DROP);
> +}
...
> +#include "xsk_xdp_progs.skel.h"

Nice. Glad you found it useful. Clearly helps the next patch ;)
