Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD4B5850CA
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbiG2NW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbiG2NW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:22:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51D4861B30
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659100945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aidh9Jkt9QsphrYa09zViAKNrqLHKNGC9Crh8UMei0s=;
        b=QpLvr+B3bKmAucN6Eg+S1/18t4739h6cMRQm0zur+QYxUrIFKS8CWUXOgyhFSvcOWK3WN2
        c/73By/C0WTmX1+vDouylXt3NudRetLPMbUoss/7g31gLFt3IxBhXF9EdybpDfTChvI6zD
        tiVUQ1yygywxToJ+itoqyda8cusS3sU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-EFEvKMkXOtufcf8CSfCfEQ-1; Fri, 29 Jul 2022 09:22:24 -0400
X-MC-Unique: EFEvKMkXOtufcf8CSfCfEQ-1
Received: by mail-wm1-f69.google.com with SMTP id v132-20020a1cac8a000000b003a34081050bso4001906wme.3
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:22:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aidh9Jkt9QsphrYa09zViAKNrqLHKNGC9Crh8UMei0s=;
        b=YJySNjcvs5aOBQvzN8z83GghyNjiRrGGijiayMdOMoBNUfXR2HtdTtQ426V5XvC57i
         +xFC9NntbDhJ7iBQEi2/bHk8vwOFVjFa+drFUuwVi0OLAfG2LpbSeBs+3MEXAXDmM8Sh
         im3qsv16Nfq8wnZwCAxiibmZPQ+r7U86o4mYSuqIWhYu6tLc4JCF2BCfDPljAd+A1+SL
         nm0ESxeko2mXGfEbC7yHn8Yhv4aY0ELSFJVSTAVgXXYafkVODrxLpa8EKPd27wwRMJgH
         4l1UOOi2KwysOsa2SnfuWcgfaVzTKf/vRNwONqi4JGLgvh65CjfsDw/tTVoQWQ8kagdl
         /UNw==
X-Gm-Message-State: ACgBeo3ardJpnkR8VHZORGqG417g6yO+Yvcjiz+phgpoMMagMZm9WaHj
        sST6Cen4DCiDoSLvmem/D2D2eu7cS45JIxSRA7zp/NYgUKqdTsgWWnYiJKkWcxarLN1fIPLROvZ
        QwtZDdz3kBvlG4cuL
X-Received: by 2002:adf:f90d:0:b0:20c:de32:4d35 with SMTP id b13-20020adff90d000000b0020cde324d35mr2438750wrr.583.1659100942740;
        Fri, 29 Jul 2022 06:22:22 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7oDMFNXrBCMxBO/DMD/cHkkoGPwjcHn3oqdGJCuH+iPzZxHfOTqlA/5K9ycDyokc0uwMaKzQ==
X-Received: by 2002:adf:f90d:0:b0:20c:de32:4d35 with SMTP id b13-20020adff90d000000b0020cde324d35mr2438741wrr.583.1659100942495;
        Fri, 29 Jul 2022 06:22:22 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id r10-20020a05600c284a00b003a3561d4f3fsm4178184wmb.43.2022.07.29.06.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 06:22:21 -0700 (PDT)
Date:   Fri, 29 Jul 2022 15:22:20 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute-next v4 2/3] lib: Introduce ppp protocols
Message-ID: <20220729132220.GB10877@pc-4.home>
References: <20220729085035.535788-1-wojciech.drewek@intel.com>
 <20220729085035.535788-3-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729085035.535788-3-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 10:50:34AM +0200, Wojciech Drewek wrote:
> PPP protocol field uses different values than ethertype. Introduce
> utilities for translating PPP protocols from strings to values
> and vice versa. Use generic API from utils in order to get
> proto id and name.

Acked-by: Guillaume Nault <gnault@redhat.com>

