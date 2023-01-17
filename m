Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C0266E1B1
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbjAQPJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjAQPJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:09:31 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC14402EF;
        Tue, 17 Jan 2023 07:09:27 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id j16-20020a056830271000b0067202045ee9so17976750otu.7;
        Tue, 17 Jan 2023 07:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TfAfhanzXfBs5e60B4ddov63nTWwre3PQSRW15sW7nY=;
        b=ZRq3t6zo8CAt2Y4hvrlw1zFMAH9Fu/VOMpgwS5AXMO2TEbrSGx+e2dXR1qo7vRV8ch
         kr7uVrnzb0rt+pJyylTgoD0ZiK6WNceqPhiSO6P4JnzbJvBgTg5443TRxo7HftfON5CI
         +n4PQ4ssGqhFQ27tLqLBWH65/4fteSSly4Xk2Fdc+7m76sZ3lBVX4ETqs0vpWOK62uUz
         Sut2Q1zSuVOM3hwxonfa3IBZMoRouD2jyYZGWIibGqoa6tpMYbjW7GkENP8UOAfqNUk0
         04bQbV9LLldjpMKzUEmYkcbLBBFtrU6+UUT8qbW2ljFCywycUwaQi+DqcfLYLSiTjeqf
         LlTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfAfhanzXfBs5e60B4ddov63nTWwre3PQSRW15sW7nY=;
        b=32VbwSm2LbOURSzvRhLxtT+Q+K9x/+OLG78jvmVO8HzdHSLAkwADJz6cMGhabBLM9h
         dUx50pOuJg3AnFaFcwEeHMLc0cblJZiPnYv0E7HMREmcaj6gNmUVRZ2lmTFNg9uMxFZJ
         P7Zd+4DHjQui74mw8Gd9OSrf9IRTCB2oksgV8RtB6Dpodc596LJOOBvVBSd+HlCRH1dC
         o6Ur6B/ystrkx+KBuWherK4+PZzR0Yd1PwzlAM70pOdncx+2gjeSolx1+lWDBzu9ZGbo
         INfL6RFJrY19ldpVwKVKW6KSZE97p3Tjdf28wNzkDybpevIj7DsuCF2xTXNyi8uROpma
         DnNw==
X-Gm-Message-State: AFqh2kq201kcHoj1yIMmbu5MnGZx+ZZRhBy8AbliiXpMCG6dkZWs5QIU
        5aGFU48GB6fIBIwtNtK3t9mkYLzmxLo=
X-Google-Smtp-Source: AMrXdXsCthi1G21x0vT9XXepYmRa1J747J7sZxYCroLg3HSfnl+aLJJEPM0OoDwP14OTmotU32wB0w==
X-Received: by 2002:a9d:4e81:0:b0:66d:68ab:2882 with SMTP id v1-20020a9d4e81000000b0066d68ab2882mr1645048otk.11.1673968167117;
        Tue, 17 Jan 2023 07:09:27 -0800 (PST)
Received: from t14s.localdomain ([177.220.174.155])
        by smtp.gmail.com with ESMTPSA id bt25-20020a05683039d900b0066e80774203sm16890577otb.43.2023.01.17.07.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 07:09:26 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 057DB4AD1F9; Tue, 17 Jan 2023 12:09:25 -0300 (-03)
Date:   Tue, 17 Jan 2023 12:09:24 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v2 1/7] net: flow_offload: provision conntrack
 info in ct_metadata
Message-ID: <Y8a6JCG6iUFTr1Q1@t14s.localdomain>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-2-vladbu@nvidia.com>
 <Y8a5AOxlm5XsrYtT@t14s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8a5AOxlm5XsrYtT@t14s.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 12:04:32PM -0300, Marcelo Ricardo Leitner wrote:
> On Fri, Jan 13, 2023 at 05:55:42PM +0100, Vlad Buslov wrote:
> ...
> >  struct flow_match {
> > @@ -288,6 +289,7 @@ struct flow_action_entry {
> >  		} ct;
> >  		struct {
> >  			unsigned long cookie;
> > +			enum ip_conntrack_info ctinfo;
> >  			u32 mark;
> >  			u32 labels[4];
> >  			bool orig_dir;
> > diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> > index 0ca2bb8ed026..515577f913a3 100644
> > --- a/net/sched/act_ct.c
> > +++ b/net/sched/act_ct.c
> > @@ -187,6 +187,7 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
> >  	/* aligns with the CT reference on the SKB nf_ct_set */
> >  	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
>                                                    ^^^^^^^^^^^

Hmm. Thought that just came up and still need to dig into, but wanted
to share/ask already. Would it be a problem to update the cookie later
on then, to reflect the new ctinfo?

> 
> >  	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
> > +	entry->ct_metadata.ctinfo = ctinfo;
> 
> tcf_ct_flow_table_restore_skb() is doing:
>         enum ip_conntrack_info ctinfo = cookie & NFCT_INFOMASK;
> 
> Not sure if it really needs this duplication then.
> 
> >  
> >  	act_ct_labels = entry->ct_metadata.labels;
> >  	ct_labels = nf_ct_labels_find(ct);
> > -- 
> > 2.38.1
> > 
