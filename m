Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605E85F58B7
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 19:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiJERA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 13:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJERA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 13:00:27 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D0034988
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 10:00:23 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 204so1516176pfx.10
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 10:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=au1kA5hld7SkJ8lIxI50iUwiPh/h0u31U6B95ziOiHM=;
        b=TelhG5NwX3P85y8PrEz49ytEkVweIRamZfOlW07n6b5o9hJWnOwigq+27N5MjEI9Ak
         UmrYdpite5ZXBN8VMyj1WW5GLBXj+hQIezarNh67PZoFWykIhmCPzgZs0LF/PCJYuFIQ
         cdYDQuYIbpVZxRF+v1Jc5YVx3rhTmKY+vLaJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=au1kA5hld7SkJ8lIxI50iUwiPh/h0u31U6B95ziOiHM=;
        b=ZZZSkDs83HMCGyNQsDCopfpeHjwQEjbhS3DR5/ospcgywxPaiPtRi6Ne32hvVGensB
         1mbTAfBCZgjvkHtGgY+9oZmp8qBvtcJgPpWO4ewWMLmNjMLN7BiUMGLYKumACGh/MVZz
         PsfFQObKLm9Dow6RRw+1ja3nTfHw3rLaJPoJzkCKA1Kl+ecETAKlTAxnB7wmY3uwsxft
         zNApKW0+X4MJwGBn5eovbrpXTlgya5b+ObsG0ALnissdgr2bFllnmImywf/TRf9a4n8g
         iW8+B+Gw46Wfkg+EKm9kfLXToE/2/MA18w60kJhOzesHfdNEl7v/48UtgXt07QEBw3Ef
         2eQA==
X-Gm-Message-State: ACrzQf0KS9zdybBQCqwuE5G856YFQ9l2QsJ43Lqp7sdcHnzO/h5gYVyh
        iVgqW5BuFwu6n4I5JJ5CuYvE2YCzwtBcGQ==
X-Google-Smtp-Source: AMsMyM7QZ4kJNKIrcCc/FeutU8sGvLk5sS0wAN4IZ+8P56VwMvakguRxakpUmtHyQDLRPPjCib6HvQ==
X-Received: by 2002:a05:6a00:1d83:b0:561:d2f8:b86d with SMTP id z3-20020a056a001d8300b00561d2f8b86dmr726089pfw.57.1664989223228;
        Wed, 05 Oct 2022 10:00:23 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id h13-20020aa796cd000000b0053eec4bb1b1sm6844904pfq.64.2022.10.05.10.00.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 10:00:22 -0700 (PDT)
Date:   Wed, 5 Oct 2022 10:00:20 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com
Subject: Re: [next-queue 1/3] i40e: Store the irq number in i40e_q_vector
Message-ID: <20221005170019.GA6629@fastly.com>
References: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
 <1664958703-4224-2-git-send-email-jdamato@fastly.com>
 <Yz1chBm4F8vJPkl2@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz1chBm4F8vJPkl2@boxer>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 12:29:24PM +0200, Maciej Fijalkowski wrote:
> On Wed, Oct 05, 2022 at 01:31:41AM -0700, Joe Damato wrote:
> > Make it easy to figure out the IRQ number for a particular i40e_q_vector by
> > storing the assigned IRQ in the structure itself.
> > 
> > Signed-off-by: Joe Damato <jdamato@fastly.com>
> > ---
> >  drivers/net/ethernet/intel/i40e/i40e.h      | 1 +
> >  drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
> >  2 files changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
> > index 9926c4e..8e1f395 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e.h
> > +++ b/drivers/net/ethernet/intel/i40e/i40e.h
> > @@ -992,6 +992,7 @@ struct i40e_q_vector {
> >  	struct rcu_head rcu;	/* to avoid race with update stats on free */
> >  	char name[I40E_INT_NAME_STR_LEN];
> >  	bool arm_wb_state;
> > +	int irq_num;		/* IRQ assigned to this q_vector */
> 
> This struct looks like a mess in terms of members order. Can you check
> with pahole how your patch affects the layout of it? Maybe while at it you
> could pack it in a better way?

OK, sure. I used pahole and asked it to reorganize the struct members,
which saves 24 bytes.

I'll update this commit to include the following reorganization in the v2 of
this set:

$ pahole -R -C i40e_q_vector i40e.ko

struct i40e_q_vector {
	struct i40e_vsi *          vsi;                  /*     0     8 */
	u16                        v_idx;                /*     8     2 */
	u16                        reg_idx;              /*    10     2 */
	u8                         num_ringpairs;        /*    12     1 */
	u8                         itr_countdown;        /*    13     1 */
	bool                       arm_wb_state;         /*    14     1 */

	/* XXX 1 byte hole, try to pack */

	struct napi_struct         napi;                 /*    16   400 */
	/* --- cacheline 6 boundary (384 bytes) was 32 bytes ago --- */
	struct i40e_ring_container rx;                   /*   416    32 */
	/* --- cacheline 7 boundary (448 bytes) --- */
	struct i40e_ring_container tx;                   /*   448    32 */
	cpumask_t                  affinity_mask;        /*   480    24 */
	struct irq_affinity_notify affinity_notify;      /*   504    56 */
	/* --- cacheline 8 boundary (512 bytes) was 48 bytes ago --- */
	struct callback_head       rcu;                  /*   560    16 */
	/* --- cacheline 9 boundary (576 bytes) --- */
	char                       name[32];             /*   576    32 */

	/* XXX 4 bytes hole, try to pack */

	int                        irq_num;              /*   612     4 */

	/* size: 616, cachelines: 10, members: 14 */
	/* sum members: 611, holes: 2, sum holes: 5 */
	/* last cacheline: 40 bytes */
};   /* saved 24 bytes! */
