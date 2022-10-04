Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446D25F402D
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 11:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiJDJpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 05:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiJDJnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 05:43:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B019F5A176
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 02:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664876428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uj5bALTca+WFCQfuz8lBQZVzEpzCqENBWHeeO/HgPYc=;
        b=cMph2JR4ny9QAG43s0/4QrL5Bf5qRqLoNnA9ihku5/UQTKbsjX0t2nak/mqUmoqZ/UIJRH
        WPcqsKaCwbmjjWro2ApHt8P9jh3U/5kmw1NjX4e0PYNWtateFXCxByHGodPZf1GXClQRj8
        awEg4Mh8vqEojxxDq4wFyXV8OXaW85g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-133-JWILzqGsOeC67QTlWmblUg-1; Tue, 04 Oct 2022 05:40:25 -0400
X-MC-Unique: JWILzqGsOeC67QTlWmblUg-1
Received: by mail-wm1-f71.google.com with SMTP id i132-20020a1c3b8a000000b003b339a8556eso7593812wma.4
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 02:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=uj5bALTca+WFCQfuz8lBQZVzEpzCqENBWHeeO/HgPYc=;
        b=a3w4vdXecR4+2y13/nu3PFgkoZEsoYG6I76HZy2ErWMjzbv3HEdWMXu7FtmDxqEen3
         ZuxsIoWpXBMwsZ3SS1vWMwd55HJ4a/095B6Uo/7MnU+mP6x4VuzWTcnTBKlaQCSkeg4x
         q+FK4kzZM6CvixlYj3Tawxqx8WqkWwlNBPrrIWXm/FaxNYkblP2/TsMu74WXj86zbJjj
         olmqZmmXQxsTfrCWutJqlTN2bgByqV9/UhEqwGP4hgqi4zrut02BczU1VLvwbvxtJ+4n
         9ApLVOCdiIX7SB6t8pVMBLfYldMJR98FRpN2CJCJqRaogRjMdiZwtrw7dVlQk773lTBN
         30mQ==
X-Gm-Message-State: ACrzQf2JcBo/SwBXxCQQQ6xBHcJ6pWSUreO9hFL+PLNKFXNOrxUBmbvx
        HXMaOVd6TiCkHiEcoEGNfs6FhDV0kaF8UuUB2sO//Y6uFQ5RkQAXBFqszYI/JXSZiMV8iMxIXps
        y9nEszOjFdffts5+d
X-Received: by 2002:a05:6000:18a5:b0:22c:943d:221 with SMTP id b5-20020a05600018a500b0022c943d0221mr15423925wri.562.1664876424323;
        Tue, 04 Oct 2022 02:40:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5hcE6qC0H75TXnOvPgxuFjhES0iwGhjrB/gggCyIE6cBTWXkWebpqkYpxIAHB6z2mb0nUg6A==
X-Received: by 2002:a05:6000:18a5:b0:22c:943d:221 with SMTP id b5-20020a05600018a500b0022c943d0221mr15423909wri.562.1664876424080;
        Tue, 04 Oct 2022 02:40:24 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-71.dyn.eolo.it. [146.241.97.71])
        by smtp.gmail.com with ESMTPSA id g18-20020a056000119200b002206203ed3dsm11837799wrx.29.2022.10.04.02.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 02:40:23 -0700 (PDT)
Message-ID: <f13ce6d44d881498214093452fc78d2fe0cdf1b7.camel@redhat.com>
Subject: Re: [PATCH net v3 2/2] selftests: add selftest for chaining of tc
 ingress handling to egress
From:   Paolo Abeni <pabeni@redhat.com>
To:     Paul Blakey <paulb@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 04 Oct 2022 11:40:22 +0200
In-Reply-To: <1664706272-10164-3-git-send-email-paulb@nvidia.com>
References: <1664706272-10164-1-git-send-email-paulb@nvidia.com>
         <1664706272-10164-3-git-send-email-paulb@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-10-02 at 13:24 +0300, Paul Blakey wrote:
> This test runs a simple ingress tc setup between two veth pairs,
> then adds a egress->ingress rule to test the chaining of tc ingress
> pipeline to tc egress piepline.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> ---

whoops... I forgot an important item: you should add the new test to
the net self-tests Makefile:

TEST_PROGS += test_ingress_egress_chaining.sh

Thanks!

Paolo

