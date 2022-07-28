Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A92583CF8
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbiG1LRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236300AbiG1LRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:17:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DB97664CF
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659007039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cTVzDc/Etmh4Gp7l1AB0glbg0gvXbjCtPcXVujhYdsM=;
        b=KlW7KeCaLc7ORkKYNgsIf7+gaBnwpI1zhsmojrpUR5IC/FOO3oKKjJiuoQvIWXFlei+QcU
        j3d88Cs5poGlqmY0n5WtBH4fOGyfIlCJ4DUgzIf+pX8Oowb5tsOk0PnPy9Icj7uhE5A3JZ
        JDlNIZi7so4TDOdE1cXGZ4OxOPCDtkg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-2N_emp4RPRCBYtRMnqNhvg-1; Thu, 28 Jul 2022 07:17:18 -0400
X-MC-Unique: 2N_emp4RPRCBYtRMnqNhvg-1
Received: by mail-wr1-f69.google.com with SMTP id d27-20020adfa41b000000b0021ee714785fso295651wra.18
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:17:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cTVzDc/Etmh4Gp7l1AB0glbg0gvXbjCtPcXVujhYdsM=;
        b=X9P0VfAaxhKCrwSVa31H3bt5CJEUzhVs+xd2ZA4yETepMAcljScmAYHFnUOYjksBXj
         UMWC3DO5u86oiu1OfpKg4rcj5qty9IQJGByHG4sXcYUWSlBGWHW/n8AfvOsiQGYdz19y
         UJxaUqMaMIYE2wnBF/1g3hybUKBjLCaqqhefOq2ZIkVj1k681z9LLXHGVYwQEHN5DEWh
         sRLGokUn50CHvF/3g/ui7/3fQhzg52SjDAAVJ987k513dsiaKYLmkigPseMHayZHpTqY
         rf/U9wvhW3hcvAsp4vxiMUyW/Qlw6d513JuZBL9UdZTt8Ly+SmcnS7X+IF+JN4JqZA7c
         Yk6Q==
X-Gm-Message-State: AJIora9//cQRk9ExGVGaAV1ngURNk1Vem/wqcD+ofAi/cFviuk98okq2
        IUuFNtkveFo2T79g86aDK3IXi7Nn46b0k0efA7gZcvlX7w1V4KHBwtqttKgwJl5q3OgQB/mgDoI
        oIEIaCNmNEsyNoE+o
X-Received: by 2002:a05:600c:cd:b0:3a3:f40:8776 with SMTP id u13-20020a05600c00cd00b003a30f408776mr6318060wmm.9.1659007037016;
        Thu, 28 Jul 2022 04:17:17 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v0fh0mnaNFWWwptxeYeiGdHLkaX4l89Ts0g2jiveSPWOsx09VtMDjpNT5WBiKB0Ap5IUWxAw==
X-Received: by 2002:a05:600c:cd:b0:3a3:f40:8776 with SMTP id u13-20020a05600c00cd00b003a30f408776mr6318034wmm.9.1659007036558;
        Thu, 28 Jul 2022 04:17:16 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id l18-20020a7bc452000000b003a2e655f2e6sm916740wmi.21.2022.07.28.04.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 04:17:16 -0700 (PDT)
Date:   Thu, 28 Jul 2022 13:17:14 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute-next v3 2/3] lib: Introduce ppp protocols
Message-ID: <20220728111714.GE18015@pc-4.home>
References: <20220728110117.492855-1-wojciech.drewek@intel.com>
 <20220728110117.492855-3-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728110117.492855-3-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 01:01:16PM +0200, Wojciech Drewek wrote:
> PPP protocol field uses different values than ethertype. Introduce
> utilities for translating PPP protocols from strings to values
> and vice versa. Use generic API from utils in order to get
> proto id and name.

Acked-by: Guillaume Nault <gnault@redhat.com>

