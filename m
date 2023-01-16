Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC0C66BC74
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjAPLIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjAPLIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:08:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DF035B2
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673867272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ou7W/MLVD0XUHERqDAdo1P7Ixwm/WV/MWWKoOCoO0mM=;
        b=hNJObR24ziL/aZuhnxwwuA6se5SZ5drL74XPbPwoIPvmIgExdMEWsgMtOz/1b0V+zEzOJI
        /wAYa9LKuOwDoTgYH4frBdSCJHgteFmKa6ZWosxWZNpjaj9drQUwZQlP9d+mwkP67gXlhy
        74jgCsIxKffZMzG/uGfTchtk/rQTo0Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-382-JHczFyjJOz6mIhV-QwYMPg-1; Mon, 16 Jan 2023 06:07:50 -0500
X-MC-Unique: JHczFyjJOz6mIhV-QwYMPg-1
Received: by mail-wr1-f72.google.com with SMTP id j11-20020adfa54b000000b002bd9b1e1656so3638502wrb.15
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:07:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ou7W/MLVD0XUHERqDAdo1P7Ixwm/WV/MWWKoOCoO0mM=;
        b=y26wTt+hTtpRXa5rduGaFXV8739VMKqTbraMXBM33dtIK6O6mNOqDm9kHMreimjCva
         PFKDSA+rZ0zE/3vfLimaeAuSdSvnxpidCvaOp2cFBR6gVY51zfsMeNARLEmrEYFzRFJD
         jF35xqaxbtyvyOu0yYjzCOP2+pyySUiG5RPJJOgzBs8xLDxUVhNUNCEKpNx9SMqdAezm
         VZo5EANpRlrBrQsZrnLEbr1QLc9k18gLJ6El5hgy1SLTw6RFuIWRx+BvXt4KCE9daIXh
         xcpuy5Q6lfCojWC8mhjCP/sE6UhEMLMF05qUtGALtEPVPsuXyxH/9nq7cGtnJtWY6BMY
         3eZA==
X-Gm-Message-State: AFqh2kptZdxw2pz0fPOYH1sYy2PzRnNtikiO5ghMMeqrbrOBmlb76Pvs
        ilv+dAQxZ+0Qo1znZAIwpbvZBZSoMwa1hwksCI2yF8iOKs5xCdfhpNrRI8fw1NeMhiOYHko/I1P
        etYwJL9kAduT+EVYz
X-Received: by 2002:a05:600c:3509:b0:3cf:93de:14e8 with SMTP id h9-20020a05600c350900b003cf93de14e8mr65505045wmq.39.1673867269775;
        Mon, 16 Jan 2023 03:07:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsJN0SjEMeiUUvmkA3mPprzAdwk08lmcX0e90kW9etAymCCTM496dYSQtbe83wnu8Y7eqD6Rw==
X-Received: by 2002:a05:600c:3509:b0:3cf:93de:14e8 with SMTP id h9-20020a05600c350900b003cf93de14e8mr65505033wmq.39.1673867269566;
        Mon, 16 Jan 2023 03:07:49 -0800 (PST)
Received: from debian (2a01cb058918ce0062ec02bb72e8945c.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:62ec:2bb:72e8:945c])
        by smtp.gmail.com with ESMTPSA id r16-20020a05600c35d000b003d2157627a8sm40912681wmq.47.2023.01.16.03.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 03:07:48 -0800 (PST)
Date:   Mon, 16 Jan 2023 12:07:46 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, saeed@kernel.org, tparkin@katalix.com,
        Cong Wang <cong.wang@bytedance.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net v3 1/2] l2tp: convert l2tp_tunnel_list to idr
Message-ID: <Y8UwAjFsY9QWbQMl@debian>
References: <20230114030137.672706-1-xiyou.wangcong@gmail.com>
 <20230114030137.672706-2-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230114030137.672706-2-xiyou.wangcong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 07:01:36PM -0800, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> l2tp uses l2tp_tunnel_list to track all registered tunnels and
> to allocate tunnel ID's. IDR can do the same job.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

