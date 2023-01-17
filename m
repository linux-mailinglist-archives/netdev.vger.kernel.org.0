Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD71466DC3A
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbjAQLWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbjAQLWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:22:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160741EFDF
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673954463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sUaR9EuJQ722Qjg+jDdqsDmti3UAjpDnLrAS+eD+8r0=;
        b=FUDEZuIIpEC5qSxhp+7tCmBpsWdEEnls56I7Ln/LRY2fou64TfhcS//fEnOxuovuxvqYfH
        qBWvfqUphfkY0UkjMiLOXLkZyD3yg6jDYrvvyEPnFD1AkUjCrWje3lugJIG3VEI6DP1Ev2
        ei1Bw6Ws1+vdTQHE1RSBrpian4JowIM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-33-kIVjtxRsNwe8QFp1MS4ZSA-1; Tue, 17 Jan 2023 06:21:01 -0500
X-MC-Unique: kIVjtxRsNwe8QFp1MS4ZSA-1
Received: by mail-qv1-f69.google.com with SMTP id df6-20020a056214080600b00534fe2ad5a3so2646862qvb.11
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:21:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sUaR9EuJQ722Qjg+jDdqsDmti3UAjpDnLrAS+eD+8r0=;
        b=7aD4zPFo6QIdFU0nV1JWqxA2ruGDmX/B5u6dWcXHG4noiXzcMOoUE64gDGdOs12UO6
         Zti12n7bprV/5G1hB2ZCdXnpWB48qWIaGJiGJoH8W/PNbh/6hTiIPUXI8TZKAPaEOpEs
         /oUdRZYT6HY+6y74GBHhgrfJZnypqpqaCz/FKojtY4cNmgm7OnAGq7cp3n4u2hL3So1l
         hisOP7+f3lLdAf60gW1gbZvWpVGQPJ+f+8tnbk9XTLbSS36/0VALS/kzYS/QoykP59KK
         e1HAms5VrkkzTSyp1BNar/kjDQn5DZqyOHY6g5XjVVCjPfM8ct35hEyt0+iy+26pd6t6
         hOnA==
X-Gm-Message-State: AFqh2koPqYVYN+6uSpR6fippTlQoWju8G8Ei46mhGq5cell4Skc3fhXl
        PdwwyWfgD9qEw3hIObs5ThscFYVYA1Em56UvnrUEtipTSEunairEmPGmceoYZh0Zc3gMLAFEDPi
        lgwu4WubfTwjiIKYQ
X-Received: by 2002:ac8:554c:0:b0:3b0:2fa:8a90 with SMTP id o12-20020ac8554c000000b003b002fa8a90mr2609329qtr.8.1673954461046;
        Tue, 17 Jan 2023 03:21:01 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt3g9znHLI4tjv+/AcW3zUi3J4h1c2DIOYwVIER9fYZLfiX4jAuQ+1gSZPYorkNWqXewbVuFQ==
X-Received: by 2002:ac8:554c:0:b0:3b0:2fa:8a90 with SMTP id o12-20020ac8554c000000b003b002fa8a90mr2609310qtr.8.1673954460843;
        Tue, 17 Jan 2023 03:21:00 -0800 (PST)
Received: from debian (2a01cb058918ce00e96a110028ee7c10.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:e96a:1100:28ee:7c10])
        by smtp.gmail.com with ESMTPSA id bk3-20020a05620a1a0300b006ff8ac9acfdsm202193qkb.49.2023.01.17.03.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 03:21:00 -0800 (PST)
Date:   Tue, 17 Jan 2023 12:20:57 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net] l2tp: prevent lockdep issue in l2tp_tunnel_register()
Message-ID: <Y8aEmeorHCmRNccR@debian>
References: <20230117110131.1362738-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117110131.1362738-1-edumazet@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 11:01:31AM +0000, Eric Dumazet wrote:
> lockdep complains with the following lock/unlock sequence:
> 
>      lock_sock(sk);
>      write_lock_bh(&sk->sk_callback_lock);
> [1]  release_sock(sk);
> [2]  write_unlock_bh(&sk->sk_callback_lock);
> 
> We need to swap [1] and [2] to fix this issue.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

