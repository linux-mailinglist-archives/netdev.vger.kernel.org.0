Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B7D664DCB
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjAJVAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbjAJVAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:00:05 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FC65A881;
        Tue, 10 Jan 2023 13:00:03 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id cf18so25563613ejb.5;
        Tue, 10 Jan 2023 13:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jMS9tdEfjQspwf8bB3Cerq4FNAfZvZjgP75R58Ynns0=;
        b=Z8FY3kivlVlJBtxOwHUgE6Tf2kh4W+JhtZmPlhrGGlLT96Y04Xy2O4m35j+6sjAhSt
         +Bx6W7SUQGTBRxtesvTphf4mdKUQ9z9gbqyGk+i66j7xPgSTaKzr6vSQNLF8driZKIo8
         8riFjGB+kk9MNalRI+SWj+k3C3OBeFr2K5uXmwMZms4KGiTVNDIMYd1Vo2Xb9xEiBjvB
         KzPjYvjs1filB9krLsqS8dexzXWE3UnPmz3s+addCGL1IXRQG/fHDUV43SdKIzUcINVS
         ZX9R8VAKXJWIxVE82neiFllH4W9CTau5Dv5MIs1S3cc0B1QjS5Y0P6jVKqFL6Bh5bxWS
         HfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jMS9tdEfjQspwf8bB3Cerq4FNAfZvZjgP75R58Ynns0=;
        b=EmziFm/WpVkDU/e5nc5pdF+hCUB/YWnMqdxF5QDVILngkjeuk4urW7Q8J38e6l0Feh
         2MkhddeMEXFx60xw29B6j+u0Jz/psh61SXIn4yDL3dEKySRy2Qt5vouVMM4tB+sVYPbB
         ozyW17HvaiOI5B5vdzlCAMPRNJwP3emOSVK1J0AL/V39oCJJ3ulG3dyPrmHN+JCW9g61
         dMfh2U9SJwmZAokxZtL/wxZMm3qmrUbmbEpt+RM89Qgj0Tvj55CbByikpZ9uVldP5b77
         vy7dulh1PjKP5S4HM4CnxvnM5mJ1BR7FbGsf5BgWgYrDKHBuK2f7MKPi/FVlyIbwxp35
         h6Uw==
X-Gm-Message-State: AFqh2krE6pLrevi+n+GdEhUwhQ5dTl0ED7z9mkBzPEb7WqDpL4YwgWIO
        2yFfKJiBIbiI+0u2g/Po5J0=
X-Google-Smtp-Source: AMrXdXvo+ftZzz0FVfBjJyIknrQ4EGeQEtHORbQ0JTXvaj3GmUHz++5AoOVaiWa6p19zUWM0HyyCog==
X-Received: by 2002:a17:906:3451:b0:857:b916:94bd with SMTP id d17-20020a170906345100b00857b91694bdmr2535090ejb.60.1673384401799;
        Tue, 10 Jan 2023 13:00:01 -0800 (PST)
Received: from localhost ([185.246.188.67])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709061f1600b0081bfc79beaesm5360564ejj.75.2023.01.10.13.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 13:00:01 -0800 (PST)
Date:   Tue, 10 Jan 2023 22:59:55 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andy Gospodarek <gospo@broadcom.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Message-ID: <Y73Ry+nNqOkeZtaj@dragonfly.lan>
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
 <87k0234pd6.fsf@toke.dk>
 <20230103172153.58f231ba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230103172153.58f231ba@kernel.org>
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 05:21:53PM -0800, Jakub Kicinski wrote:
> On Tue, 03 Jan 2023 16:19:49 +0100 Toke Høiland-Jørgensen wrote:
> > Hmm, good question! I don't think we've ever explicitly documented any
> > assumptions one way or the other. My own mental model has certainly
> > always assumed the first frag would continue to be the same size as in
> > non-multi-buf packets.
> 
> Interesting! :) My mental model was closer to GRO by frags 
> so the linear part would have no data, just headers.
> 
> A random datapoint is that bpf_xdp_adjust_head() seems 
> to enforce that there is at least ETH_HLEN.

Also bpf_xdp_frags_increase_tail has the following check:

	if (!rxq->frag_size || rxq->frag_size > xdp->frame_sz)
		return -EOPNOTSUPP;

However, I can't seem to find where the `frag_size > frame_sz` part is
actually used. Maybe this condition can be dropped? Can someone shed
some light?

BTW, Tariq, we seem to have missed setting frag_size to a non-zero
value. Could you check that increasing the tail indeed doesn't work on
fragmented packets on mlx5e? I can send a oneliner to fix that.
