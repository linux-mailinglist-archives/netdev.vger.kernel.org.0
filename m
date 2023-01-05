Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE0F65F190
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 17:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbjAEQ5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 11:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbjAEQ5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 11:57:41 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A0F4D491
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 08:57:40 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y5so714623pfe.2
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 08:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qklyOCxfCUcZboToekn30enOfFtg7jdWSCtxv11/91E=;
        b=AiwVgqhYbXcvon+g4I18+p2ZxDc2xlVSSlD6YWWeB8L5uI3QVj8A/TzN8w+l51zT2m
         EqZS6q5EpeAJTVCTTyBmVtRmGOZJZ0xKKb4dc3tTanc2ycrk5BpH/4hq0KLOw+si6JBV
         H28ZGrCzLw6ZyA4tolPJTHU3EFl5B8L7l0VxY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qklyOCxfCUcZboToekn30enOfFtg7jdWSCtxv11/91E=;
        b=IrZsK+tFNYVjAGMGLnDhUO7plNBK10zEaN6YG8eD2dIDJV6hld/tUZWf6CHXq6w5eR
         a3v8NcwW1rT8AVDsHIOJ+2biNfHlaIFFRVCBYrKoIcJPk9cvP+m3ImhijXLLYQjHx/kh
         fNnGpPDYC/C3bPTDJbvOoxe2p9vCpVhD2PaglSFo+PhygBcGTRfAzjJe15UDLADoo6Kd
         yjm6+lznGkvPVYGjBjchLPIKAOpy7qbNAtpGK9V1BuFETrniFDAxNpVNc6HH3/KvY0ZP
         mveDZ3OH9vGU2vqVyus2n9JxqOpQxkgGen/IsnhTdbQuCpTBtwk5ZhT4uDSDwABfQ84f
         H43w==
X-Gm-Message-State: AFqh2kqv+WgG27g+bkT0Qu8tOIopbApYNL3k+cuqD+9ev5DPesDnhf8T
        bvcDPQ84gg4ZurOYjLtJiI9PdA==
X-Google-Smtp-Source: AMrXdXuMNeGVN/9ui5XXdTjmRUvXi3k8EKEyY5mCV5EvSQWxjAogVicLZMkHTQUitTf98cfkChSJ6A==
X-Received: by 2002:a05:6a00:1906:b0:580:9d4a:4e1c with SMTP id y6-20020a056a00190600b005809d4a4e1cmr56998227pfi.3.1672937859663;
        Thu, 05 Jan 2023 08:57:39 -0800 (PST)
Received: from C02YVCJELVCG.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7948d000000b005765df21e68sm14519513pfk.94.2023.01.05.08.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 08:57:39 -0800 (PST)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Thu, 5 Jan 2023 11:57:32 -0500
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Message-ID: <Y7cBfE7GpX04EI97@C02YVCJELVCG.dhcp.broadcom.net>
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
 <87k0234pd6.fsf@toke.dk>
 <20230103172153.58f231ba@kernel.org>
 <Y7U8aAhdE3TuhtxH@lore-desk>
 <87bkne32ly.fsf@toke.dk>
 <a12de9d9-c022-3b57-0a15-e22cdae210fa@gmail.com>
 <871qo90yxr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871qo90yxr.fsf@toke.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 04:43:28PM +0100, Toke Høiland-Jørgensen wrote:
> Tariq Toukan <ttoukan.linux@gmail.com> writes:
> 
> > On 04/01/2023 14:28, Toke Høiland-Jørgensen wrote:
> >> Lorenzo Bianconi <lorenzo@kernel.org> writes:
> >> 
> >>>> On Tue, 03 Jan 2023 16:19:49 +0100 Toke Høiland-Jørgensen wrote:
> >>>>> Hmm, good question! I don't think we've ever explicitly documented any
> >>>>> assumptions one way or the other. My own mental model has certainly
> >>>>> always assumed the first frag would continue to be the same size as in
> >>>>> non-multi-buf packets.
> >>>>
> >>>> Interesting! :) My mental model was closer to GRO by frags
> >>>> so the linear part would have no data, just headers.
> >>>
> >>> That is assumption as well.
> >> 
> >> Right, okay, so how many headers? Only Ethernet, or all the way up to
> >> L4 (TCP/UDP)?
> >> 
> >> I do seem to recall a discussion around the header/data split for TCP
> >> specifically, but I think I mentally put that down as "something people
> >> may way to do at some point in the future", which is why it hasn't made
> >> it into my own mental model (yet?) :)
> >> 
> >> -Toke
> >> 
> >
> > I don't think that all the different GRO layers assume having their 
> > headers/data in the linear part. IMO they will just perform better if 
> > these parts are already there. Otherwise, the GRO flow manages, and 
> > pulls the needed amount into the linear part.
> > As examples, see calls to gro_pull_from_frag0 in net/core/gro.c, and the 
> > call to pskb_may_pull() from skb_gro_header_slow().
> >
> > This resembles the bpf_xdp_load_bytes() API used here in the xdp prog.
> 
> Right, but that is kernel code; what we end up doing with the API here
> affects how many programs need to make significant changes to work with
> multibuf, and how many can just set the frags flag and continue working.
> Which also has a performance impact, see below.
> 
> > The context of my questions is that I'm looking for the right memory 
> > scheme for adding xdp-mb support to mlx5e striding RQ.
> > In striding RQ, the RX buffer consists of "strides" of a fixed size set 
> > by pthe driver. An incoming packet is written to the buffer starting from 
> > the beginning of the next available stride, consuming as much strides as 
> > needed.
> >
> > Due to the need for headroom and tailroom, there's no easy way of 
> > building the xdp_buf in place (around the packet), so it should go to a 
> > side buffer.
> >
> > By using 0-length linear part in a side buffer, I can address two 
> > challenging issues: (1) save the in-driver headers memcpy (copy might 
> > still exist in the xdp program though), and (2) conform to the 
> > "fragments of the same size" requirement/assumption in xdp-mb. 
> > Otherwise, if we pull from frag[0] into the linear part, frag[0] becomes 
> > smaller than the next fragments.
> 
> Right, I see.
> 
> So my main concern would be that if we "allow" this, the only way to
> write an interoperable XDP program will be to use bpf_xdp_load_bytes()
> for every packet access. Which will be slower than DPA, so we may end up
> inadvertently slowing down all of the XDP ecosystem, because no one is
> going to bother with writing two versions of their programs. Whereas if
> you can rely on packet headers always being in the linear part, you can
> write a lot of the "look at headers and make a decision" type programs
> using just DPA, and they'll work for multibuf as well.

The question I would have is what is really the 'slow down' for
bpf_xdp_load_bytes() vs DPA?  I know you and Jesper can tell me how many
instructions each use. :)

Taking a step back...years ago Dave mentioned wanting to make XDP
programs easy to write and it feels like using these accessor APIs would
help accomplish that.  If the kernel examples use bpf_xdp_load_bytes()
accessors everywhere then that would accomplish that.

> But maybe I'm mistaken and people are just going to use the load_bytes
> helper anyway because they want to go deeper than whatever "headers" bit
> we'll end up guaranteeing is in the linear part?
