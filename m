Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957E4673080
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjASEni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjASEmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 23:42:31 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC18193DE;
        Wed, 18 Jan 2023 20:40:19 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id m12so727210qvt.9;
        Wed, 18 Jan 2023 20:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FYHy7LFhouoyw1lMkkYCJ4FEetLKb0c3tZXxxcGO/JM=;
        b=QsoYiT+zoPznSy5rXctnGY81xSrEEaj21VLFYej+yr0am6eR+rFtE+OffbgLM0WttQ
         1nUZmM1A25SdED2ca8519mXVD17mFX1Jco9UEJXlLtUtbOZ0CEpiwwyCWCtWVGynEA1A
         sAavVfWour0uL1+fgff2G3XC16R+L/XUsv7TrKXnNRRNk5loGiXvi3oJy+YfZ9dQRKW7
         faSRNfz/FIki+Ub5RcLaj8aeJKAo8rmrirB0cVhWR7i+7toL9DcNps4UX98Pip15Mz/k
         ASczeYXh+/ysLOEOHqykSYUe1omTUtqjP2Rz5WQ9J00kjrl60eT1lJJCI5m6BbFHdif2
         Adjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYHy7LFhouoyw1lMkkYCJ4FEetLKb0c3tZXxxcGO/JM=;
        b=KCiB3r3BWd3XVEtl57UIDbsZUPScnZ6Q9LW6VqadkfE02SgE6ox1DcRCZ9uZ08oepB
         Qg52R7iOsifQ03QYk7cBvpq3MIcH41WhiOKddWPGXEfIOrAaEqhrSTtamU8Je6IrL8qv
         MipJDTm+6CAm0S2VxSM7P8BjL4OUK8CRoMvfqAIZWRDfOTXHSrNfiXbrqYixF9oH+d2p
         uQedAuYeGEFwEBlydw8W7ZpC48qhh8QI7cpZAdBgY7WUKjtqWhZ8Y7xxVqcZeBZXy0zv
         OfSWkIpc5XYNMYIaE9ZKky9ygMWak1vbcYkMCkVfm85sc0cWLCxsLOC6dVv6/gXMPRmE
         CliA==
X-Gm-Message-State: AFqh2kqjrFF0boD0mPcml8dCvr71JNumon+4tDdrCHvtlOFaFeKsnadP
        r8kLxEMEZ+lEo63i9QlmqmBEplEae10+dA==
X-Google-Smtp-Source: AMrXdXsIdeiOBG8dpuZ2noaoIgiFvg26E8dclP8RRZBu9WQpEk4FomK+RpCm2yy+4pqoUC5Me4bIaQ==
X-Received: by 2002:a05:6808:2109:b0:35e:9270:7b0e with SMTP id r9-20020a056808210900b0035e92707b0emr5365345oiw.29.1674101760318;
        Wed, 18 Jan 2023 20:16:00 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:3243:26ee:68de:6577:af10])
        by smtp.gmail.com with ESMTPSA id i10-20020a54408a000000b00364a415f0bbsm9339679oii.39.2023.01.18.20.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 20:15:59 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id DC4644ADF5A; Thu, 19 Jan 2023 01:15:57 -0300 (-03)
Date:   Thu, 19 Jan 2023 01:15:57 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v2 1/7] net: flow_offload: provision conntrack
 info in ct_metadata
Message-ID: <Y8jD/R8RxgPiOgzs@t14s.localdomain>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-2-vladbu@nvidia.com>
 <Y8a5AOxlm5XsrYtT@t14s.localdomain>
 <Y8a6JCG6iUFTr1Q1@t14s.localdomain>
 <87edrtcbks.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edrtcbks.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 07:28:09PM +0200, Vlad Buslov wrote:
> On Tue 17 Jan 2023 at 12:09, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > On Tue, Jan 17, 2023 at 12:04:32PM -0300, Marcelo Ricardo Leitner wrote:
> >> On Fri, Jan 13, 2023 at 05:55:42PM +0100, Vlad Buslov wrote:
> >> ...
> >> >  struct flow_match {
> >> > @@ -288,6 +289,7 @@ struct flow_action_entry {
> >> >  		} ct;
> >> >  		struct {
> >> >  			unsigned long cookie;
> >> > +			enum ip_conntrack_info ctinfo;
> >> >  			u32 mark;
> >> >  			u32 labels[4];
> >> >  			bool orig_dir;
> >> > diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> >> > index 0ca2bb8ed026..515577f913a3 100644
> >> > --- a/net/sched/act_ct.c
> >> > +++ b/net/sched/act_ct.c
> >> > @@ -187,6 +187,7 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
> >> >  	/* aligns with the CT reference on the SKB nf_ct_set */
> >> >  	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
> >>                                                    ^^^^^^^^^^^
> >
> > Hmm. Thought that just came up and still need to dig into, but wanted
> > to share/ask already. Would it be a problem to update the cookie later
> > on then, to reflect the new ctinfo?
> 
> Not sure I'm following, but every time the flow changes state it is
> updated in the driver since new metadata is generated by calling
> tcf_ct_flow_table_fill_actions() from nf_flow_offload_rule_alloc().

Whoops.. missed to reply this one.

I worried that the cookie perhaps was used a hash index or so, and
with such update on it, then maybe the key would be changing under the
carpet. Checked now, I don't see such issue.

I guess that's it from my side then. :)

> 
> >
> >> 
> >> >  	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
> >> > +	entry->ct_metadata.ctinfo = ctinfo;
> >> 
> >> tcf_ct_flow_table_restore_skb() is doing:
> >>         enum ip_conntrack_info ctinfo = cookie & NFCT_INFOMASK;
> >> 
> >> Not sure if it really needs this duplication then.
> >> 
> >> >  
> >> >  	act_ct_labels = entry->ct_metadata.labels;
> >> >  	ct_labels = nf_ct_labels_find(ct);
> >> > -- 
> >> > 2.38.1
> >> > 
> 
