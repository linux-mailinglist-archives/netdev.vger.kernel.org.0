Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4CA583CF4
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236139AbiG1LRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235617AbiG1LRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:17:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A49F6611F
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659007019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gRkr8FElQJTQO7ryAbyJtV9cBZFdKZnke/CbnwuOpEg=;
        b=QzPO+O9Q2PHQCC2IwN8z9jo6GMsTTtAMzvaSvH/JECmx5dfD2SbGlaKRMO1k5Zm9yZXB7e
        vynLe+tYW4ngssYdu6dVw6/FM1Uvwe8tYUkYMRtXjJ5iRmp+HRiRDerf0vSr8u3nIVfJJR
        RHuasd/Wn7JeejDu6K9n5QwsO6Qmtko=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-_t9jW2n9NfSb_2O3xxlXVg-1; Thu, 28 Jul 2022 07:16:58 -0400
X-MC-Unique: _t9jW2n9NfSb_2O3xxlXVg-1
Received: by mail-wm1-f71.google.com with SMTP id 131-20020a1c0289000000b003a3497306a8so1032081wmc.9
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:16:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gRkr8FElQJTQO7ryAbyJtV9cBZFdKZnke/CbnwuOpEg=;
        b=svsY3Whz1NRGxy9SuN4u3VCEBHYac5imB6DPuQMzkSeSbDe/peXTQkyCTuvvKBW2t2
         voz6R11v2SuIV2ieXvtaBctVMdXKYV/1SaacsvBGGdosqnvQwMEqvNK17S9CgYmvUrAU
         IRBGl6IdH26ri1pfw8fwewe7NpzzHH+lTRV03QoN1kChmUAojku0wF/+o+ecfdTiZEF9
         6seIn2kksbloe5/jbIsfLl9MdsxyBbXWDaJol2YqDyjLR3bo4De0N+ISkGgJPsAIap+G
         C1Z0G0EBU1I9t1yq8uDZRe0K7tiN3J0z54tEdFOwSDFOjz3ugp93nNqXCAr6+J4RYlMq
         FMGw==
X-Gm-Message-State: AJIora/JxBGfstjJGJqqIGUI0DrSk3u80Jm7Fm6ehVsrBV12izxoO9M3
        7q/5rWVhZh9NGJ1aaAm2lTmpqt1mloF/QXylwWg+8Ru7Z9Y1xJ+J8B1EOhcKIGUH73VLahcMzqn
        wATgZcTlI6K3WGAmW
X-Received: by 2002:a1c:7915:0:b0:3a3:11a3:7452 with SMTP id l21-20020a1c7915000000b003a311a37452mr6243104wme.27.1659007017023;
        Thu, 28 Jul 2022 04:16:57 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s4yJmZr6GanQ8qu7jkm8lwvND8rNssB7frNx6bNplNpuEeVHzXPRL5ItqZ7SoRf9fS+ibHnw==
X-Received: by 2002:a1c:7915:0:b0:3a3:11a3:7452 with SMTP id l21-20020a1c7915000000b003a311a37452mr6243080wme.27.1659007016708;
        Thu, 28 Jul 2022 04:16:56 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id k19-20020a05600c1c9300b003a2e2a2e294sm1092599wms.18.2022.07.28.04.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 04:16:56 -0700 (PDT)
Date:   Thu, 28 Jul 2022 13:16:54 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute-next v3 1/3] lib: refactor ll_proto functions
Message-ID: <20220728111654.GD18015@pc-4.home>
References: <20220728110117.492855-1-wojciech.drewek@intel.com>
 <20220728110117.492855-2-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728110117.492855-2-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 01:01:15PM +0200, Wojciech Drewek wrote:
> Move core logic of ll_proto_n2a and ll_proto_a2n
> to utils.c and make it more generic by allowing to
> pass table of protocols as argument (proto_tb).
> Introduce struct proto with protocol ID and name to
> allow this. This wil allow to use those functions by
> other use cases.

Acked-by: Guillaume Nault <gnault@redhat.com>

