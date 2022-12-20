Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E7E651E38
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 10:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiLTJ7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 04:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbiLTJ5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 04:57:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74101080
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 01:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671530107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36v9eIqOtmXW1ZSheam36DDMJjGMXu5DS4zdG9maZXs=;
        b=MSPaAFmoK9HrXpY24awfm1qOMLPKss0W98a47LEyQaQpIQWT2x0Nyk2uycep8i1FLg5PsN
        O+w2sO6DYnmgcu4HcfndOLj/A3+Sn+t7ZUc5bsVew52103U6+rDzE1igS+8PzadVM8Ip2K
        W1rUaetu4zpraFXvCRfrReE7B/RR6uQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-210-0L0bGi6hOBGWwZjfeVsDAg-1; Tue, 20 Dec 2022 04:55:05 -0500
X-MC-Unique: 0L0bGi6hOBGWwZjfeVsDAg-1
Received: by mail-qt1-f199.google.com with SMTP id d12-20020ac851cc000000b003a8118f79daso5295856qtn.19
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 01:55:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=36v9eIqOtmXW1ZSheam36DDMJjGMXu5DS4zdG9maZXs=;
        b=hgsBMQmx8nA7NdGRNjW07tmWWyBhrNBUxflJPfFqSfaRQTtorsj3ANONStWk2orSYz
         RWZi9cWiV0Gb8PkIDX5tD3LeZyGZel4K4PHFcP9qy+F1MGlUQlqS6LFaywDOCw1WqPG8
         bSIFMSaNYE25QWXjOXvOV8tQdzPb/UurSGL3CvGPC+Ps6fLgCQaYpy6hHO+vYcAjxKhx
         4VT3vKZOZ+STzBIIr50SNt7qByYNVYcvsp7aULJb3MlXuBurT4yjW8eFR/ycqaeOEo9n
         7TPAxEVJoWerR+sTOCe1PV1p1yMEddKQtvsHfkEnez1q26bteTW96pxLJ4B+J2In40dO
         T/eg==
X-Gm-Message-State: ANoB5pnG//W2aq8jpalfKUwDBlxBsiUg8m4U/W8av3DFhtv8CAEP3Ytv
        P1YleIW1nfkvVb1prPLeMv70p2kbyOLEB/gtHvqHuLyQVbjGttY3g8mpyr+A6Lnxxf0U+4VcW1y
        LOWzVIKWwha19cFOw
X-Received: by 2002:ac8:41d6:0:b0:3a8:2fba:b02d with SMTP id o22-20020ac841d6000000b003a82fbab02dmr30133713qtm.51.1671530104965;
        Tue, 20 Dec 2022 01:55:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6JjsSuk0iWxynV9ghauiRi1SAvVj+2H64vuGKXaLQGDeP0ED3WnR97+VIG44nyFjZCFTGgXQ==
X-Received: by 2002:ac8:41d6:0:b0:3a8:2fba:b02d with SMTP id o22-20020ac841d6000000b003a82fbab02dmr30133700qtm.51.1671530104725;
        Tue, 20 Dec 2022 01:55:04 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id x21-20020ac85395000000b003a50248b89esm7297454qtp.26.2022.12.20.01.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 01:55:04 -0800 (PST)
Message-ID: <71c526c6bf99171fef334ab9d51f78777e7b9df5.camel@redhat.com>
Subject: Re: [PATCH] qed: allow sleep in qed_mcp_trace_dump()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Caleb Sander <csander@purestorage.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org
Cc:     Joern Engel <joern@purestorage.com>
Date:   Tue, 20 Dec 2022 10:55:00 +0100
In-Reply-To: <20221217175612.1515174-1-csander@purestorage.com>
References: <20221217175612.1515174-1-csander@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-12-17 at 10:56 -0700, Caleb Sander wrote:
> By default, qed_mcp_cmd_and_union() waits for 10us at a time
> in a loop that can run 500K times, so calls to qed_mcp_nvm_rd_cmd()
> may block the current thread for over 5s.
> We observed thread scheduling delays of over 700ms in production,
> with stacktraces pointing to this code as the culprit.

IMHO this is material eligible for the net tree...

> 
> qed_mcp_trace_dump() is called from ethtool, so sleeping is permitted.
> It already can sleep in qed_mcp_halt(), which calls qed_mcp_cmd().
> Add a "can sleep" parameter to qed_find_nvram_image() and
> qed_nvram_read() so they can sleep during qed_mcp_trace_dump().
> qed_mcp_trace_get_meta_info() and qed_mcp_trace_read_meta(),
> called only by qed_mcp_trace_dump(), allow these functions to sleep.
> It's not clear to me that the other caller (qed_grc_dump_mcp_hw_dump())
> can sleep, so it keeps b_can_sleep set to false.

...but we need a suitable Fixes tag here. Please repost specifying the
target tree into the subject and adding the relevant tag, thanks!

Paolo

