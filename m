Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA306601A1
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbjAFN5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjAFN5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:57:10 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2196ADBA
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:57:09 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id 3so1507625vsq.7
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 05:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=soEyyt7+ke/EsbfgoWOrqE55snldr7SLoTwPDy3CMeY=;
        b=AkkNad1rjTGucAaU2dHBnnW+cBKWYZyAhZx6HNrp856hl3FeP7Atubf4FrRXomaJUV
         mxuDZb+FVqgIXOXroOj6P8Gy3QwMLUeAJR3SDg1A3K0FXA/ntjx5lU8JAE9e8/1cxdms
         p1qF/vttIVleWlJHQzyu0wB1yTf9AiPMXjJxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=soEyyt7+ke/EsbfgoWOrqE55snldr7SLoTwPDy3CMeY=;
        b=kCknZKHpeOAoGOLDOlBRsN1B1PvWrbbKULp2Si3XlMVgQ5Lc+WRNEV1fvbl2Vibff9
         RjjTGuZ12g347rB9kNVsrbJl3abIN4OB0qu6JJ0MwnNOILWuIGcRgmJi432l9XTZgA4q
         JG4z/L2E7VoIN6qIizUxZf7c70KW0AuZeU5wVfmiKV1BKAOsSJPoheAVKLIdna7IpShD
         DToqX9rc1ltR9w1lhN/iiqK2WyemnAKi3RYrDthx8kixKcM+iotTKgyAkBe6NmYFmfPU
         APKIbE3p50uqvujQSWLrbvoqbor4dV+7dd8iwDzPNaE3JBAR/648xHbc7IEjE5nKpqCE
         2MYQ==
X-Gm-Message-State: AFqh2koV3SrxijZCL2aoNf2lSOOcwTlHvb2MaB2W73QnyRhuk9g5JfgL
        p+nZ1bL2flntsqI4BiZUOoIE6A==
X-Google-Smtp-Source: AMrXdXtVbNTx+ftJZ+o859NRgn8LDUvAQikRdJRoKsOkfUGoqNvqym3cn+XI39mMoDvFpPPYmd1PuQ==
X-Received: by 2002:a67:f749:0:b0:3ca:b9:928 with SMTP id w9-20020a67f749000000b003ca00b90928mr19734815vso.33.1673013428446;
        Fri, 06 Jan 2023 05:57:08 -0800 (PST)
Received: from C02YVCJELVCG ([136.56.52.194])
        by smtp.gmail.com with ESMTPSA id bs15-20020a05620a470f00b006b61b2cb1d2sm554675qkb.46.2023.01.06.05.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 05:57:07 -0800 (PST)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Fri, 6 Jan 2023 08:56:59 -0500
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        lorenzo.bianconi@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Message-ID: <Y7goqzGAb+dk8KIw@C02YVCJELVCG>
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
 <87k0234pd6.fsf@toke.dk>
 <20230103172153.58f231ba@kernel.org>
 <Y7U8aAhdE3TuhtxH@lore-desk>
 <87bkne32ly.fsf@toke.dk>
 <a12de9d9-c022-3b57-0a15-e22cdae210fa@gmail.com>
 <871qo90yxr.fsf@toke.dk>
 <Y7cBfE7GpX04EI97@C02YVCJELVCG.dhcp.broadcom.net>
 <20230105101642.1a31f278@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105101642.1a31f278@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 10:16:42AM -0800, Jakub Kicinski wrote:
> On Thu, 5 Jan 2023 11:57:32 -0500 Andy Gospodarek wrote:
> > > So my main concern would be that if we "allow" this, the only way to
> > > write an interoperable XDP program will be to use bpf_xdp_load_bytes()
> > > for every packet access. Which will be slower than DPA, so we may end up
> > > inadvertently slowing down all of the XDP ecosystem, because no one is
> > > going to bother with writing two versions of their programs. Whereas if
> > > you can rely on packet headers always being in the linear part, you can
> > > write a lot of the "look at headers and make a decision" type programs
> > > using just DPA, and they'll work for multibuf as well.  
> > 
> > The question I would have is what is really the 'slow down' for
> > bpf_xdp_load_bytes() vs DPA?  I know you and Jesper can tell me how many
> > instructions each use. :)
> 
> Until we have an efficient and inlined DPA access to frags an
> unconditional memcpy() of the first 2 cachelines-worth of headers
> in the driver must be faster than a piece-by-piece bpf_xdp_load_bytes()
> onto the stack, right?

100% 

Seems like we are back to speed vs ease of use, then?

> > Taking a step back...years ago Dave mentioned wanting to make XDP
> > programs easy to write and it feels like using these accessor APIs would
> > help accomplish that.  If the kernel examples use bpf_xdp_load_bytes()
> > accessors everywhere then that would accomplish that.
> 
> I've been pushing for an skb_header_pointer()-like helper but 
> the semantics were not universally loved :)

I didn't recall that -- maybe I'll check the archives and see what I can
find.

