Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9915850D0
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbiG2NWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbiG2NWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:22:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9036462A5F
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659100964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S1ZSLfhpxpk/I4aEXinzHD6Aua8NgdsueTHhOrE8NlQ=;
        b=C6Ykv3pSXs1I399UUMIonu3gdlXyLwD7vYuXSgmubdbxfworyPfxTd7rRj3eBhGL00h0k2
        FgXdcvykYKQOq2Ff+8gHQxiSWpU1WlwqCnPTp3Zza++IngU/lN6Aqgf1yHeHqDMIugpt/Y
        KD7LAEzEkHrJk9UobfWIJDBT13VjSIw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-2ZfUiPJxOKajJ-qhC9vG-A-1; Fri, 29 Jul 2022 09:22:43 -0400
X-MC-Unique: 2ZfUiPJxOKajJ-qhC9vG-A-1
Received: by mail-wm1-f72.google.com with SMTP id az39-20020a05600c602700b003a321d33238so2198117wmb.1
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:22:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S1ZSLfhpxpk/I4aEXinzHD6Aua8NgdsueTHhOrE8NlQ=;
        b=EL7UWRVm5hp0MSDDpML193VHvYVUpXRjom0ScbBGM7PZ4i7X14TKegx5Um/rq15BjG
         SiCRotNu+uzr2eCFJeNJ5PnnW+9RIwYT5ujJRtc5GbWr1nYpu2x8xMUS1sL2WstkcP2z
         oCYdY+tWEQ9VFspuyj0FySzphXP9oR5j+ZVFFqsULPz/3PDYeFPQBmMUxH7l/f2n85ns
         V4auA+OTAScYbgFfd30ZDPmfv1pNfVjPo/WVgnaP+ANXEtUlB2hR366D7xUZ9+kREiKu
         knu1UH/DsU6iNAWkCBehGSJKbjtnTL8kiDQUHx82sIX0YK8lGxaG2Mo2hN2aubFZckMw
         4nrQ==
X-Gm-Message-State: ACgBeo0OdokHbCILInJ4gOdLEL43uOtTZi3/gEeslDhjop1XbKtpc5S1
        uFGNju+n38x7OJV73l/3cnQMrSszLyVVN1hBveXAUk3RO3klG7R1/J098KUpFwsjE841tcsKBKE
        35pSmZnEdiCBxJ0te
X-Received: by 2002:a5d:414e:0:b0:21e:df60:2bb6 with SMTP id c14-20020a5d414e000000b0021edf602bb6mr2391219wrq.714.1659100962226;
        Fri, 29 Jul 2022 06:22:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5eYIgbxdRoUjEm+7dsP5zYzk6J1t4fBGItde442kCl5QpxMzoq8Fudku785YityCcgMBg3uA==
X-Received: by 2002:a5d:414e:0:b0:21e:df60:2bb6 with SMTP id c14-20020a5d414e000000b0021edf602bb6mr2391205wrq.714.1659100962032;
        Fri, 29 Jul 2022 06:22:42 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003a2e1883a27sm10899654wmq.18.2022.07.29.06.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 06:22:41 -0700 (PDT)
Date:   Fri, 29 Jul 2022 15:22:39 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute-next v4 3/3] f_flower: Introduce PPPoE support
Message-ID: <20220729132239.GC10877@pc-4.home>
References: <20220729085035.535788-1-wojciech.drewek@intel.com>
 <20220729085035.535788-4-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729085035.535788-4-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 10:50:35AM +0200, Wojciech Drewek wrote:
> Introduce PPPoE specific fields in tc-flower:
> - session id (16 bits)
> - ppp protocol (16 bits)
> Those fields can be provided only when protocol was set to
> ETH_P_PPP_SES. ppp_proto works similar to vlan_ethtype, i.e.
> ppp_proto overwrites eth_type. Thanks to that, fields from
> encapsulated protocols (such as src_ip) can be specified.

Acked-by: Guillaume Nault <gnault@redhat.com>

