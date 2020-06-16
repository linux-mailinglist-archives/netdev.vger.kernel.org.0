Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BF01FB9D2
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732545AbgFPQHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730426AbgFPPrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:47:20 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8547C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:47:20 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t21so14608070edr.12
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=73aIY/LXErMgQ2L+mUUsaqmNocwnsmcGVQ05txUsy5w=;
        b=h6Vr0XcBFwbnMKG9CkfRExmwjlKImK2hpthtODpP3Jv0GuA5/6BOWbMiiXE4Ty0xgS
         /eLbmW+xWcswqVRvWjvM/yVyaPhlIdSGNZL1PM9IAfrC6eP/D5I7ptoiXU32w/uq8Jvb
         VVQptMEB5x+EeY2HSSF5xCMLhSR6IkXcK8CNKWTjcDxdDEKNkGcfcTizeBYgtOvk4pc9
         IG9BGN+xiEqtcpBmu7DRls91x6E8CV6lka5+WTuHVdWQ+HzK6DFDsmVWyGSjF53viVbl
         /jPyi3LKxQu5YSlKjSEAJkol0Lpp489vT1Qx8hmFweSVKqgjhqz9icmVM4dTREYNghoI
         F2cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=73aIY/LXErMgQ2L+mUUsaqmNocwnsmcGVQ05txUsy5w=;
        b=CEhIp0zpkeKeTKdrtIKSUvd4+IPbDIKqaeqKKxc03GmJcSNMBj5bV3Yj0jVnJ+YqMY
         B21VORrjYKQqoV7e8wU7QNsVvHevpQbvZbpSUPAZx9WPO2z9T91qruxorTFiVEc8RXm1
         9m+iQ+QL8jPyyDuX9rWJ4JjCU1C3J3QMQ2wH7OrboAoo3fukr1Mpg3pOQvD+kmtoDx8o
         FG1kjxcYxR2I+osR/bsDRIZfWK4SvrZ6uzNxyQJlPY+ZQ4CbKUIFSzRZthMR94yqckyK
         dRYOyo3exQJuhTfslQt16CIU9rBHRv5qq5smSdsqZvQv29lYllXO/FAuMi70JFTpyCVc
         rG8A==
X-Gm-Message-State: AOAM533Hxc2Rjn/nDwGXUg2unAP0dYGmBHGTcTpfZUAIzJRrLqjk021K
        +3iNkuBL0tjJa+qlVl1FUkXJBg==
X-Google-Smtp-Source: ABdhPJw+5qkITEPe/6eVUCGwOeh2bvQkl5yOkl8JEnAXdplXBprnMtLWEUOlTB9WNN9RAAv6xmOseQ==
X-Received: by 2002:aa7:d0cb:: with SMTP id u11mr3033390edo.381.1592322439284;
        Tue, 16 Jun 2020 08:47:19 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id k2sm11486130ejc.20.2020.06.16.08.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 08:47:18 -0700 (PDT)
Date:   Tue, 16 Jun 2020 17:47:17 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org,
        vladbu@mellanox.com
Subject: Re: [PATCH net v3 2/4] flow_offload: fix incorrect cb_priv check for
 flow_block_cb
Message-ID: <20200616154716.GA16382@netronome.com>
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
 <1592277580-5524-3-git-send-email-wenxu@ucloud.cn>
 <20200616105123.GA21396@netronome.com>
 <aee3192c-7664-580b-1f37-9003c91f185b@ucloud.cn>
 <20200616143427.GA8084@netronome.com>
 <565dd609-1e20-16f4-f38d-8a0b15816f50@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <565dd609-1e20-16f4-f38d-8a0b15816f50@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 11:18:16PM +0800, wenxu wrote:
> 
> 在 2020/6/16 22:34, Simon Horman 写道:
> > On Tue, Jun 16, 2020 at 10:20:46PM +0800, wenxu wrote:
> >> 在 2020/6/16 18:51, Simon Horman 写道:
> >>> On Tue, Jun 16, 2020 at 11:19:38AM +0800, wenxu@ucloud.cn wrote:
> >>>> From: wenxu <wenxu@ucloud.cn>
> >>>>
> >>>> In the function __flow_block_indr_cleanup, The match stataments
> >>>> this->cb_priv == cb_priv is always false, the flow_block_cb->cb_priv
> >>>> is totally different data with the flow_indr_dev->cb_priv.
> >>>>
> >>>> Store the representor cb_priv to the flow_block_cb->indr.cb_priv in
> >>>> the driver.
> >>>>
> >>>> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
> >>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
> >>> Hi Wenxu,
> >>>
> >>> I wonder if this can be resolved by using the cb_ident field of struct
> >>> flow_block_cb.
> >>>
> >>> I observe that mlx5e_rep_indr_setup_block() seems to be the only call-site
> >>> where the value of the cb_ident parameter of flow_block_cb_alloc() is
> >>> per-block rather than per-device. So part of my proposal is to change
> >>> that.
> >> I check all the xxdriver_indr_setup_block. It seems all the cb_ident parameter of
> >>
> >> flow_block_cb_alloc is per-block. Both in the nfp_flower_setup_indr_tc_block
> >>
> >> and bnxt_tc_setup_indr_block.
> >>
> >>
> >> nfp_flower_setup_indr_tc_block:
> >>
> >> struct nfp_flower_indr_block_cb_priv *cb_priv;
> >>
> >> block_cb = flow_block_cb_alloc(nfp_flower_setup_indr_block_cb,
> >>                                                cb_priv, cb_priv,
> >>                                                nfp_flower_setup_indr_tc_release);
> >>
> >>
> >> bnxt_tc_setup_indr_block:
> >>
> >> struct bnxt_flower_indr_block_cb_priv *cb_priv;
> >>
> >> block_cb = flow_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
> >>                                                cb_priv, cb_priv,
> >>                                                bnxt_tc_setup_indr_rel);
> >>
> >>
> >> And the function flow_block_cb_is_busy called in most place. Pass the
> >>
> >> parameter as cb_priv but not cb_indent .
> > Thanks, I see that now. But I still think it would be useful to understand
> > the purpose of cb_ident. It feels like it would lead to a clean solution
> > to the problem you have highlighted.
> 
> I think The cb_ident means identify.  It is used to identify the each flow block cb.
> 
> In the both flow_block_cb_is_busy and flow_block_cb_lookup function check
> 
> the block_cb->cb_ident == cb_ident.

Thanks, I think that I now see what you mean about the different scope of
cb_ident and your proposal to allow cleanup by flow_indr_dev_unregister().

I do, however, still wonder if there is a nicer way than reaching into
the structure and manually setting block_cb->indr.cb_priv
at each call-site.

Perhaps a variant of flow_block_cb_alloc() for indirect blocks
would be nicer?
