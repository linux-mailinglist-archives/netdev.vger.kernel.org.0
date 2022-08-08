Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC72C58C859
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 14:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242835AbiHHM2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 08:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242042AbiHHM17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 08:27:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6579DEA4
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 05:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659961676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l68EjihpMW1PjKtRUpt7ucyYQUG0wGAM29WL8EddQq4=;
        b=bymXU2nbHECRCRC4AqWoI8iYEn7FAYm+jLZj1iBqiF4tS06FqzogvVwMuSvLQ8QtykqCLu
        Wf6At6LNNjMJi93jW2bCf1SJQwfRLYZ2It59irJVbJUbVnWazhvapvEODFbwGM/c422RUe
        WqEHyDpzJbEF55NxEY41xvE49TLFcrI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433--GJDh3RBPmu6lR1AbUfAQw-1; Mon, 08 Aug 2022 08:27:55 -0400
X-MC-Unique: -GJDh3RBPmu6lR1AbUfAQw-1
Received: by mail-wm1-f71.google.com with SMTP id j36-20020a05600c1c2400b003a540d88677so1130487wms.1
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 05:27:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l68EjihpMW1PjKtRUpt7ucyYQUG0wGAM29WL8EddQq4=;
        b=YDNJQBYbOU2a1kr1Ut1NulvOqUhawpfQn8nFUxAkuCjeSxs8oVpsLslV6dzT7QTM/g
         LeQT6khaC0IXKNa/NNBTwsnP+KHiCI+wua0OR2eF6LbqyxaIWcpT9D5ntnpi8OCBVzcg
         49CjOdOD4n/N2tFYic7yut+fbAER/cN0DoLRYZA266g6qp14cSTS/aBPLZgeEcMDmh9Q
         /EU+8poFEnff+60XTMpZ5CFDHA3EcTEn1gWvbGdbbeBsZrGOdNwpHFSz25JGZ+uSyTQ5
         9N9OokwW/WHGDBSjc0DVtK0+lqHgXQfkOdOGBaraYpCmD8p7v6DWw0Eub/XQ9rQ/Zt2S
         MEcA==
X-Gm-Message-State: ACgBeo1e+2ELWFYYEy7BgGwJ+3+DhwNToSjOUagWfJMEGp75rI30Hpnz
        MFrvEpY6aDy5J55z4qwoSAlPqzkhI2jvfIProD0BnU8Rp6hLElq9FGEARJskM6YAIBM22QI2Y3A
        bHnXuP+dE+M82VMqX
X-Received: by 2002:adf:ce81:0:b0:220:6245:9cc6 with SMTP id r1-20020adfce81000000b0022062459cc6mr10991938wrn.402.1659961674710;
        Mon, 08 Aug 2022 05:27:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7zKuxil7V7H1JSg2mNNZaPgFdQ6qdjUdoRQloVdd7JNpK8sa4fHUFNDDleC7+bMnpIbqjsBg==
X-Received: by 2002:adf:ce81:0:b0:220:6245:9cc6 with SMTP id r1-20020adfce81000000b0022062459cc6mr10991923wrn.402.1659961674500;
        Mon, 08 Aug 2022 05:27:54 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id m8-20020a7bce08000000b003a4f29d6f69sm20893630wmc.36.2022.08.08.05.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 05:27:53 -0700 (PDT)
Date:   Mon, 8 Aug 2022 14:27:51 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nicolas.dichtel@6wind.com,
        eyal.birger@gmail.com, linux-kernel@vger.kernel.org,
        jesse@nicira.com, pshelar@nicira.com, tgraf@suug.ch
Subject: Re: [PATCH v4 net] geneve: fix TOS inheriting for ipv4
Message-ID: <20220808122751.GB9123@pc-4.home>
References: <20220805190006.8078-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805190006.8078-1-matthias.may@westermo.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 05, 2022 at 09:00:06PM +0200, Matthias May wrote:
> The current code retrieves the TOS field after the lookup
> on the ipv4 routing table. The routing process currently
> only allows routing based on the original 3 TOS bits, and
> not on the full 6 DSCP bits.
> As a result the retrieved TOS is cut to the 3 bits.
> However for inheriting purposes the full 6 bits should be used.
> 
> Extract the full 6 bits before the route lookup and use
> that instead of the cut off 3 TOS bits.

Acked-by: Guillaume Nault <gnault@redhat.com>

