Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AD13517E8
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbhDARnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234646AbhDARiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:38:54 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7CBC0613A7;
        Thu,  1 Apr 2021 04:31:37 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u5so2355546ejn.8;
        Thu, 01 Apr 2021 04:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=e1k2jFYVkUvY3qWo/yAEsqj9pQAfQ8BRhGPE3QKDHv0=;
        b=ZD433zJpfpq8cjtLjUhQxT9js3k/QQGKl5g41mZuchqReVJ+Lx1mxySZAsVFruartF
         EJoddJcA7fSZURn3ZEOdpLEqoHjF+MfRrFGGbIYMOZUTAGx3laYJPzj1xCBbsAyf3C/H
         n2jNpdpjR2fw/hEF+C8RlJ5oAcQrwxBrFCSxfqGb2OxoDwqAnuv4LauIyIRbQxUt7RSe
         HcDAHaP/h1ThuRCY1jMESHKCZbWJ/moYLx0L3Id/ZKCc15ag1kcKcYclVWv7j0Jtngxo
         i6WxQjRqAd4ymc8tUHArsHf9LpxpzuUFo2pVh7V/SP+YHTjRj3Ck/ojMFCWmf9TZcqek
         39Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=e1k2jFYVkUvY3qWo/yAEsqj9pQAfQ8BRhGPE3QKDHv0=;
        b=B77nw9l/2pStZqercd5nO0zsRNHlezdtQvBFbJEEYo1HJl5rNMpJuI9im/Jsdgn0T6
         l1i4kVLtorm22WTRIpbb/PV94ddrn5tI+K20DPSw0K6BXzODLjpH083zQEURFnSxpVo9
         UNjZlWg91NETdgI+GPP5dWaNhSGbhbaUEU2B2JEoijG6j3UhLyycC+XAf/f9ylo9+FPN
         gSUZHrkhb4XypqAp4kCiHmwiN2ZZoFCaKequiyGA714QwebHQ9HSPrjWu9gutvAzHZDl
         vvYnOY098vgeolnWWTivYJDuEhPupTYa3NmjX+SIBnN3xeNkVzdeHh5QPUHHFKphks9Q
         b+zw==
X-Gm-Message-State: AOAM532TcNjgmoboAmLYuynot+hnE8Flwe2OR6bBaVxG3X+zaVV9hT8c
        m5uwRoRqM515ITsP4EOtRhg=
X-Google-Smtp-Source: ABdhPJwbi48m1/vFhq9T6E4IJ05n1xEWnSphH1wrGflu34S3LVoiLfwRvf10Y32RxuY8g9HZ7MSs+Q==
X-Received: by 2002:a17:907:7249:: with SMTP id ds9mr8775707ejc.9.1617276696365;
        Thu, 01 Apr 2021 04:31:36 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id u13sm2746993ejn.59.2021.04.01.04.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 04:31:35 -0700 (PDT)
Date:   Thu, 1 Apr 2021 14:31:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexander Duyck <alexander.duyck@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 9/9] net: enetc: add support for XDP_REDIRECT
Message-ID: <20210401113133.vzs3uxkp52k2ctla@skbuf>
References: <20210331200857.3274425-1-olteanv@gmail.com>
 <20210331200857.3274425-10-olteanv@gmail.com>
 <87blaynt4l.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87blaynt4l.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 01:26:02PM +0200, Toke Høiland-Jørgensen wrote:
> > +int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
> > +		   struct xdp_frame **frames, u32 flags)
> > +{
> > +	struct enetc_tx_swbd xdp_redirect_arr[ENETC_MAX_SKB_FRAGS] = {0};
> > +	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> > +	struct enetc_bdr *tx_ring;
> > +	int xdp_tx_bd_cnt, i, k;
> > +	int xdp_tx_frm_cnt = 0;
> > +
> > +	tx_ring = priv->tx_ring[smp_processor_id()];
> 
> What mechanism guarantees that this won't overflow the array? :)

Which array, the array of TX rings?
You mean that it's possible to receive a TC_SETUP_QDISC_MQPRIO or
TC_SETUP_QDISC_TAPRIO with num_tc == 1, and we have 2 CPUs?
Well, yeah, I don't know what's the proper way to deal with that. Ideas?
