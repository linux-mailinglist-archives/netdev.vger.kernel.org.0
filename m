Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3B961885C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 20:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiKCTMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 15:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiKCTMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 15:12:16 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF691D673
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 12:12:15 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id h10so1795037qvq.7
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 12:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vDRNfHt5NwW+vw46voAusU6fqv++X34FYf8oD8NJwt8=;
        b=fZcjnKXo4eOc37wpQlloahFMNKoZCwyfhSZB5fvF2+tByyOOg29wsvir+SRNstSFuj
         shJcK/YExkIQvwfBk6l+wT6zdpwefIhHMi1S/4qDj+OkD3vUq0PZQhUk3tvfhPhdqAsO
         nz066ru5XdWDM6leApkIYQ1qTxHsSiKmS+iTnlQs+jF16mkUuqKKNG54V00zU5fK6cIg
         5Xb4I44aO358Jdu5+YH6MIdhtpFiqFYY2D77HzTrbpgmaYnc+1S4TKbJffnhl8kG83RV
         /Qtcmo+O4OKvcPHSTgFhhuprVs8fVjOV7JbpKNvNF/XoFMQoFbOshVxb6IPCjMTH4Api
         UtIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDRNfHt5NwW+vw46voAusU6fqv++X34FYf8oD8NJwt8=;
        b=S830tTAUMIjlafnyZ/kuOSHn94qE1Chz3ds2WLpIu8rFZ6TxnElgJrq56UGY8P3upQ
         vEBlTxPclLwQOTAuAqLJOamjgMyHbTdugr/kZV3B0Z8yD18tjuEtGZDeN1pMh8yB7Gh+
         EahgVTzDY9VJJ4PTcZz7+5xyd/T94Fz8cM0lTI6M6Atq02fsQECmGt/FYab+PeiGj/ip
         8xogYV9K60e5w5eWMWPIh/ivjUA8Y23UaAGDd13WwLBi86bcW9PgoOoUcTSZ25zEFjCs
         rYUyI1AbPnNT8wPJ+bvRrQhgNUDHEbNGwP1qjgZ6bdgCqtJhPCNjblv8TMoWK+609oZK
         +ftg==
X-Gm-Message-State: ACrzQf3IWnABJvig3zXCdZVV6TJzXdc3amnkD+cG38r+L7JGux5oZlgk
        r2B43gM+nzuBzdn6rbDPDfU=
X-Google-Smtp-Source: AMsMyM76x9qAWqRyBDc+nVcBU6JjgLDIt1+/RMlyZugI6C1cie7ELbvlnam67CFfp8cHvMTnOOiE/Q==
X-Received: by 2002:a05:6214:dac:b0:4bb:5901:38b1 with SMTP id h12-20020a0562140dac00b004bb590138b1mr28538011qvh.18.1667502734573;
        Thu, 03 Nov 2022 12:12:14 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:4d91:6911:634f:5b22])
        by smtp.gmail.com with ESMTPSA id 145-20020a370b97000000b006eeb3165565sm1239334qkl.80.2022.11.03.12.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 12:12:13 -0700 (PDT)
Date:   Thu, 3 Nov 2022 12:12:11 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, jiri@resnulli.us, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, wizhao@redhat.com,
        peilin.ye@bytedance.com
Subject: Re: [RFC net-next] net/sched: act_mirred: allow mirred ingress
 through networking backlog
Message-ID: <Y2QSi5CIkwLtEfm1@pop-os.localdomain>
References: <0b153a5ab818dff51110f81550a4050538605a4b.1667252314.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b153a5ab818dff51110f81550a4050538605a4b.1667252314.git.dcaratti@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 10:44:26PM +0100, Davide Caratti wrote:
> using TC mirrred in the ingress direction, packets are passed directly
> to the receiver in the same context. There are a couple of reasons that
> justify the proposal to use kernel networking backlog instead:
> 
> a) avoid the soft lockup observed with TCP when it sends data+ack after
>    receiving packets through mirred (William sees them using OVS,
>    something similar can be obtained with a kselftest [1)]

Do you have a pointer to the original bug report? The test case you
crafted looks unreal to me, a TCP socket sending packets to itself does
not look real.


> b) avoid packet drops caused by mirred hitting MIRRED_RECURSION_LIMIT
>    in the above scenario
> 
> however, like Cong pointed out [2], we can't just change mirred redirect to
> use the networking backlog: this would break users expectation, because it
> would be impossible to know the RX status after a packet has been enqueued
> to the backlog.
> 
> A possible approach can be to extend the current set of TC mirred "eaction",
> so that the application can choose to use the backlog instead of the classic
> ingress redirect. This would also ease future decisions of performing a
> complete scrub of the skb metadata for those packets, without changing the
> behavior of existing TC ingress redirect rules.
> 

From users' point of view, why do we need to care about this
implemention detail when picking TC mirred action?


Thanks.
