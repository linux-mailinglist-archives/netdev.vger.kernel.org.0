Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024EB65F107
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 17:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbjAEQWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 11:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbjAEQWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 11:22:08 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3832E4E42F
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 08:22:07 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id jr11so30296417qtb.7
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 08:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ffFs6MhOEallo9JreaDhoMujgaZC+42IQ6jp+96uB8w=;
        b=chfT8y0msZkaskvuV7/8nOEOPp9zd2IJZ4h+Bqm8yFlbbArirbxKxYrl8ahe7tCwqM
         xZwOKo2o8v6FEGoIEExZcLq9r8MPTgZn+tH/KgVEcpyH8lggaDWB7DRTv1Q5gblrayKs
         AaSgUBsBeikTN2AwblmVBUGW1NCfL9gkpqStY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ffFs6MhOEallo9JreaDhoMujgaZC+42IQ6jp+96uB8w=;
        b=ZiH4wbRj7sdvu6IBAyG4Jp5FPZM7f06jQ22fJEL2NofIpApVXwykTaMPYZoe4/DbR+
         X4f2zPnwUTmlyWACyD19ziorEsg4KKR0l9M0fKTl2sq771Q5Eax/ci+/pXn1DeCrUji6
         7WmpZZ1r5o3BiPrOHhIdkZBV3IiyzXr33JusD7zjLgmnjQR7o60k2XDzKYL8H+IjvsJu
         qlzj6lYK++oKzUUK4xszutQhGVvhFLsyL9xBJcYAalI94kBXJuEXOB7CzGhEQA9zhhr0
         nOkcWwy8L2pPCspbuKeH7hNdRfDAojkpaiSJGT06MWHy1ouPvt4TPqd5LoSbPNX7vO3X
         6LDQ==
X-Gm-Message-State: AFqh2kpuHRABp2JgudXcY6hzKFPBtB1FfcT7MP5BzL3y1mPJGeTzi6jE
        ACtmFPES1X4riyFfiym9JwbC9w==
X-Google-Smtp-Source: AMrXdXtDytKaVmtg0efflOyXfymcBKXt5koF+tMQJ6ARq++uJEKl8yn91O4CftNKJAXeTMUNP38wpA==
X-Received: by 2002:ac8:7551:0:b0:3a7:f46b:7a82 with SMTP id b17-20020ac87551000000b003a7f46b7a82mr68271708qtr.21.1672935726225;
        Thu, 05 Jan 2023 08:22:06 -0800 (PST)
Received: from C02YVCJELVCG.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id v15-20020a05620a440f00b0070495934152sm25987506qkp.48.2023.01.05.08.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 08:22:05 -0800 (PST)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Thu, 5 Jan 2023 11:22:03 -0500
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Message-ID: <Y7b5K2NCp17xHU/N@C02YVCJELVCG.dhcp.broadcom.net>
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
 <87k0234pd6.fsf@toke.dk>
 <20230103172153.58f231ba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230103172153.58f231ba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

As I mentioned in my mail just a few mins ago, I think this would be a good
model to consider.  All headers (including potentially tunnel headers) could be
in the linear area with the actual packet data in frags.

> A random datapoint is that bpf_xdp_adjust_head() seems 
> to enforce that there is at least ETH_HLEN.
