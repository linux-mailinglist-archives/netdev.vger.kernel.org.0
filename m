Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C934674554
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjASV6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjASV5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:57:18 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D18BBCE07;
        Thu, 19 Jan 2023 13:37:11 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id t7-20020a05683014c700b006864760b1caso2034167otq.0;
        Thu, 19 Jan 2023 13:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U2bzn3AUxAzO0uXr0zukcHj0RPa+4LfNgFTnObuXoT4=;
        b=TGV2yJokhg7YLs+B3CxBassm2CVAVMXq/y2DruM7PGlXfpAHEsXn3mfHbwTR+kJj15
         4A+uB3cVtB5/ugfWnE8XmLMqhIVmSE5ystOUvStb4LjULDKaftbRQLnp0IW3MBN3He9N
         VtAWSzcIL+RQqEvC96wyi2eHgTQ8u7CrUgj/OZ0JrLtqwwMobPo5+AGBeI0MESE+YjYV
         nYjLuA8O8scxEgqe5w8bkaQn9ZNi5avycfMGRu8iFj05dLogQJ/RevLlDsMqZkcUXdzL
         XKLc2b/Y1rXok8AtHjSTxC+dgH5iKoW6iF1qRnWvHV+iJsVfYEIw6AbqLquODPFyWCZm
         1xag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U2bzn3AUxAzO0uXr0zukcHj0RPa+4LfNgFTnObuXoT4=;
        b=ako5en0UH+HYiYKTNjDH75DG+gioi8YtRoxvD7feKKg8yft3JfYUskbVUy0hwKlR+h
         Ac66dRVFkrMlruLsdxOr03q1No2+i5EGt1YhG1LxUqir/roaPKQZZ03l+viP/i4gBOX6
         8aeFhZYr9bWCJ0yyT4kNT996K29ogXAxHl/VSuJBwrIsgS3AhqAxg0AJaIJsq0u8DPCM
         9TRhV1+KZOYXmvZ/vcURR9nFyIooqS4oqmciETZTG5riBOQ9EsBF2yxW8aXV1pvTgpWq
         WlSaKkXGjGyxg+5U1QyOT6O3gZHdBYEl+glz6z3aWDrSblfHGp2mQg9kdoqlnzMQQMG3
         iKXg==
X-Gm-Message-State: AFqh2ko+NtVEGbLTnCzxYmKTz72NDZeGdkkgrOAqcohlq8iQEXIIEkyk
        PkfsOrgDN6Z0Rg0hjjQfK+Q=
X-Google-Smtp-Source: AMrXdXu/Ny1nvTiZ9/kYYp6ZxmA4ED7gomTYnDiqas5KLfkxg3X97ElGDVxbhE2QZWILidNkzYwMuA==
X-Received: by 2002:a05:6830:3375:b0:670:99fe:2dcc with SMTP id l53-20020a056830337500b0067099fe2dccmr6576506ott.18.1674164229668;
        Thu, 19 Jan 2023 13:37:09 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:3243:26ee:68de:6577:af10])
        by smtp.gmail.com with ESMTPSA id i25-20020a9d6259000000b0068649039745sm4987880otk.6.2023.01.19.13.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 13:37:09 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id ABA774AE51A; Thu, 19 Jan 2023 18:37:07 -0300 (-03)
Date:   Thu, 19 Jan 2023 18:37:07 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v3 0/7] Allow offloading of UDP NEW connections
 via act_ct
Message-ID: <Y8m4A7GchYdx21/h@t14s.localdomain>
References: <20230119195104.3371966-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119195104.3371966-1-vladbu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 08:50:57PM +0100, Vlad Buslov wrote:
> Currently only bidirectional established connections can be offloaded
> via act_ct. Such approach allows to hardcode a lot of assumptions into
> act_ct, flow_table and flow_offload intermediate layer codes. In order
> to enabled offloading of unidirectional UDP NEW connections start with
> incrementally changing the following assumptions:
> 
> - Drivers assume that only established connections are offloaded and
>   don't support updating existing connections. Extract ctinfo from meta
>   action cookie and refuse offloading of new connections in the drivers.

Hi Vlad,

Regarding ct_seq_show(). When dumping the CT entries today, it will do
things like:

        if (!test_bit(IPS_OFFLOAD_BIT, &ct->status))
                seq_printf(s, "%ld ", nf_ct_expires(ct)  / HZ);

omit the timeout, which is okay with this new patchset, but then:

        if (test_bit(IPS_HW_OFFLOAD_BIT, &ct->status))
                seq_puts(s, "[HW_OFFLOAD] ");
        else if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
                seq_puts(s, "[OFFLOAD] ");
        else if (test_bit(IPS_ASSURED_BIT, &ct->status))
                seq_puts(s, "[ASSURED] ");

Previously, in order to be offloaded, it had to be Assured. But not
anymore after this patchset. Thoughts?

  Marcelo
