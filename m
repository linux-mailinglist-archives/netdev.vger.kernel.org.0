Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D21C5F5A03
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 20:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiJESmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 14:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiJESlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 14:41:55 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A218169D
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 11:40:25 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id p3-20020a17090a284300b0020a85fa3ffcso2143545pjf.2
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 11:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=dB/mLDPvddSrAOBjDKTbLlR3uh0ZH57qh/dtZrjjag8=;
        b=HPh3rH28cH1ISMMyraM/Zk/HU3Vf4F4itg1n1ginrO9IEW808laa6i4YjatABM4XsD
         /yzJvBou5oGm2E2bU8DgudA+2IwhTFXaTVtRmmtyBB6YTcssDXqvlxLB6BN+GJhIa+/W
         79pekj24nQTZhhGy0Xl2SR3IEe4PQCrz+SwEA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=dB/mLDPvddSrAOBjDKTbLlR3uh0ZH57qh/dtZrjjag8=;
        b=jZy0ZOdhY2yjGjaGCXuxbaBGS/mfDDqrwybd2h1ZIiJozGxIzSF46O4JaafOBnU74S
         5BztYfca6skdf2J5G8sfyExpT/8j9558704Kl27GRFHMpvqYcGuljAD+9jPyxFxZRXTP
         rSakEXotRbfRStjCN+HXZNUBbkrSqJFa6xmX1djDBAeskNMCThc4lKxmi14nGTOUf3iL
         HZjsma7Wr241NAEBZxDWyMYsFBRGiKv/ovRW4EMK0KxhhkN8rW0aagRiS210mhJnVwhg
         gaTN/PQOp7A4q0LJ/HuAk4hNj0PtPa0lN3oeT8AILT04LMpdr36EtVtqvltlwMNFsuPB
         NdbQ==
X-Gm-Message-State: ACrzQf3PlyMZabPze1ujx9ft9Ey8PG4AUZsHLdw5T9sx+cwyFTZyPBo/
        3BAZg4on1Y67h1ecKL5HLAdTSQ==
X-Google-Smtp-Source: AMsMyM7gwXg6Gwz4+ig5i+7VvjMOLYrh5xTxKqZzZpNNN8dTdPMmCkAEsKOWi7nPRryVxYIfXVB1Zw==
X-Received: by 2002:a17:902:b693:b0:178:5fa6:4b3 with SMTP id c19-20020a170902b69300b001785fa604b3mr712778pls.63.1664995225034;
        Wed, 05 Oct 2022 11:40:25 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id b9-20020a630c09000000b00434e1d3b2ecsm45380pgl.79.2022.10.05.11.40.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 11:40:24 -0700 (PDT)
Date:   Wed, 5 Oct 2022 11:40:22 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anthony.l.nguyen@intel.com
Subject: Re: [next-queue 1/3] i40e: Store the irq number in i40e_q_vector
Message-ID: <20221005184021.GA15277@fastly.com>
References: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
 <1664958703-4224-2-git-send-email-jdamato@fastly.com>
 <Yz1chBm4F8vJPkl2@boxer>
 <20221005170019.GA6629@fastly.com>
 <aab58471-096d-db50-36f2-493a14e0e6da@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab58471-096d-db50-36f2-493a14e0e6da@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 11:25:32AM -0700, Jesse Brandeburg wrote:
> On 10/5/2022 10:00 AM, Joe Damato wrote:
> >On Wed, Oct 05, 2022 at 12:29:24PM +0200, Maciej Fijalkowski wrote:
> >>On Wed, Oct 05, 2022 at 01:31:41AM -0700, Joe Damato wrote:
> >>>Make it easy to figure out the IRQ number for a particular i40e_q_vector by
> >>>storing the assigned IRQ in the structure itself.
> >>>
> >>>Signed-off-by: Joe Damato <jdamato@fastly.com>
> >>>---
> >>>  drivers/net/ethernet/intel/i40e/i40e.h      | 1 +
> >>>  drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
> >>>  2 files changed, 2 insertions(+)
> >>>
> >>>diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
> >>>index 9926c4e..8e1f395 100644
> >>>--- a/drivers/net/ethernet/intel/i40e/i40e.h
> >>>+++ b/drivers/net/ethernet/intel/i40e/i40e.h
> >>>@@ -992,6 +992,7 @@ struct i40e_q_vector {
> >>>  	struct rcu_head rcu;	/* to avoid race with update stats on free */
> >>>  	char name[I40E_INT_NAME_STR_LEN];
> >>>  	bool arm_wb_state;
> >>>+	int irq_num;		/* IRQ assigned to this q_vector */
> >>
> >>This struct looks like a mess in terms of members order. Can you check
> >>with pahole how your patch affects the layout of it? Maybe while at it you
> >>could pack it in a better way?
> >
> >OK, sure. I used pahole and asked it to reorganize the struct members,
> >which saves 24 bytes.
> 
> Hi Joe, thanks for your patches,
> 
> Saving 24 bytes is admirable, but these structures are generally optimized
> in access pattern order (most used at the top) and not so much for "packing
> efficiency" especially since it has that alignment directive at the bottom
> which causes each struct to start at it's own cacheline anyway.
> 
> 
> >
> >I'll update this commit to include the following reorganization in the v2 of
> >this set:
> >
> >$ pahole -R -C i40e_q_vector i40e.ko
> >
> >struct i40e_q_vector {
> >	struct i40e_vsi *          vsi;                  /*     0     8 */
> >	u16                        v_idx;                /*     8     2 */
> >	u16                        reg_idx;              /*    10     2 */
> >	u8                         num_ringpairs;        /*    12     1 */
> >	u8                         itr_countdown;        /*    13     1 */
> >	bool                       arm_wb_state;         /*    14     1 */
> >
> >	/* XXX 1 byte hole, try to pack */
> >
> >	struct napi_struct         napi;                 /*    16   400 */
> >	/* --- cacheline 6 boundary (384 bytes) was 32 bytes ago --- */
> >	struct i40e_ring_container rx;                   /*   416    32 */
> >	/* --- cacheline 7 boundary (448 bytes) --- */
> >	struct i40e_ring_container tx;                   /*   448    32 */
> >	cpumask_t                  affinity_mask;        /*   480    24 */
> >	struct irq_affinity_notify affinity_notify;      /*   504    56 */
> >	/* --- cacheline 8 boundary (512 bytes) was 48 bytes ago --- */
> >	struct callback_head       rcu;                  /*   560    16 */
> >	/* --- cacheline 9 boundary (576 bytes) --- */
> >	char                       name[32];             /*   576    32 */
> >
> >	/* XXX 4 bytes hole, try to pack */
> >
> >	int                        irq_num;              /*   612     4 */
> 
> The right spot for this debug item is at the end of the struct, so that part
> is good.
> 
> >
> >	/* size: 616, cachelines: 10, members: 14 */
> >	/* sum members: 611, holes: 2, sum holes: 5 */
> >	/* last cacheline: 40 bytes */
> >};   /* saved 24 bytes! */
> 
> I'd prefer it if you don't do two things at once in a single patch (add
> members / reorganize).
> 
> I know Maciej said this is a mess and I kind of agree with him, but I'm not
> sure it's a priority for your patch set to fix it now, especially since
> you're trying to add a debugging assist, and not performance tuning the
> code.
> 
> If you're really wanting to reorganize these structs I'd prefer a bit more
> diligent effort to prove no inadvertent side effects (like maybe by turning
> up the interrupt rate and looking at perf data while receiving 512 byte
> packets. The rate should remain the same (or better) and the number of cache
> misses on these structs should remain roughly the same. Maybe a seperate
> patch series?

I honestly did think that reorganizing the struct was probably out of scope
of this change, so if you agree so I'll drop this change from the v2 and
keep the original which adds irq_num to the end of the struct.
