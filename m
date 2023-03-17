Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C871D6BEEEB
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCQQxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCQQxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:53:47 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077B336FEB
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:53:43 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v25so1576090wra.12
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679072021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KJIzqRDlIl5u/pNsNO+CkEW5Nyckm1onTwJJM1lb0r8=;
        b=6kSjS2QkIjCrWzBaEUeLZw68U8S19D9GtBrF/6R/LWzmSbVfAc/JHsxDReb9//IroS
         FK9sPCSmTASM/OZ1LXFILcbLADtPp0YZx430/wFv75VuKN2HxeXj/cB7wJtBRshFT2wu
         tfb0wi60dWTxRIlEhN/xHxfQUKoZv+d7SrcWpOclVGuwnqsPukLlFYGz7NJqPkh8Kxpt
         ifYwioMT/t2j1J7sB5V/I8CXT5nlpUX4Dk5bXnCUkgJX2y3c0WMfHSu+OTvNdybNjp/G
         OiXGIvsazDKF/sQ18V2Zv56Dsh2FEWtN9mW6Z/VGoG9/cvQnaiERyh6wlawGN0+p2Ei5
         e9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679072021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJIzqRDlIl5u/pNsNO+CkEW5Nyckm1onTwJJM1lb0r8=;
        b=Cn8HoKWktsfrwgqoTl38JN7r7xd6ASeFVcUYVplYtnQ/UrkEy1+BK2e/zIHGKyayTg
         XaB2hERDmXFPvjzlOgFRufvkY16tghOUqLyM5yhT3XqkmodNc/hWOpnlsvNf0Wg37li/
         wppTNhJJTZOkYHHaNxvgAXRzanYO6aZWj9IPXXA13bvY6nk7giwh1iDxZ5vghSvyCtR9
         aNDTAJwwUpmKo+03yo2ZXxB6N/eo1/D/H/nnDRk12gRAVKkZQWbX4ePRBj7GC9JRG4ib
         YjLJxw6sQhXfUWscpCbittCd/q1I1bctw/mQgI5KwqoQVNkN1sIXSTVB+AUC2QiXAj70
         qx4A==
X-Gm-Message-State: AO0yUKWCfTL9hTCVGuyaCmPaga2PCBB4wE9Wv6jkek2eyf190DBkDEmK
        t4QfuROvFgOGl1/rBoYlX/eizQRgjJBOBVl4LsU=
X-Google-Smtp-Source: AK7set8pHjCt/e8bd28Q05BYNst8oP4BR1BhOm9Du0zyjX/0NuEZ5lD0gvmfBxWXSsHHdYWk6b/DVA==
X-Received: by 2002:adf:e743:0:b0:2ce:ae55:340a with SMTP id c3-20020adfe743000000b002ceae55340amr7217485wrn.48.1679072021420;
        Fri, 17 Mar 2023 09:53:41 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c8-20020adfe708000000b002cde626cd96sm2351673wrm.65.2023.03.17.09.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 09:53:40 -0700 (PDT)
Date:   Fri, 17 Mar 2023 17:53:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Message-ID: <ZBSbE+8p/u9hl0JI@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-2-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:02AM CET, vadfed@meta.com wrote:
>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>

[...]


>+      name: device-get
>+      doc: |
>+        Get list of DPLL devices (dump) or attributes of a single dpll device
>+      attribute-set: dpll
>+      flags: [ admin-perm ]
>+

[...]


>+    -
>+      name: pin-get
>+      doc: |
>+        Get list of pins and its attributes.
>+        - dump request without any attributes given - list all the pins in the system
>+        - dump request with target dpll - list all the pins registered with a given dpll device
>+        - do request with target dpll and target pin - single pin attributes
>+      attribute-set: dpll
>+      flags: [ admin-perm ]

Any particular reason to have admin cap required for get operations?
If not, please remove.

