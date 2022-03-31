Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5B14EDBAE
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 16:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237547AbiCaOaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 10:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237548AbiCaOaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 10:30:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF2BB4BFDF
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 07:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648736900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rerbpDqpUKtFLQla8//GkeQbIxlwX2DmPOc0DYBJFEo=;
        b=LhEeL90dFB9CClazgX3zsU1U5s7gJjmnCb7eJiBaTcNj98anGk0xj95/tTXa2qCxDS1B1R
        eM8ZrKRfQ2uoOCqw7I4bJtA8uZOQnAPc5lIBPmR2gypQygyv1XrF6twi9njDTPyzxZvU2O
        F01FQogcul6mer35tNGJhZlYd/2SEAI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-IG2Ouwb3PRmEHoPt0kCShQ-1; Thu, 31 Mar 2022 10:28:18 -0400
X-MC-Unique: IG2Ouwb3PRmEHoPt0kCShQ-1
Received: by mail-wm1-f69.google.com with SMTP id n19-20020a7bcbd3000000b0038c94b86258so1224429wmi.2
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 07:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rerbpDqpUKtFLQla8//GkeQbIxlwX2DmPOc0DYBJFEo=;
        b=XTWwYd7rV//7mVE8HBWEzKB9di62SSFr+nLR1L+vQ7Cn6JZ1Gzpw+9OLvb7AK/Yy8b
         FT5GEaTHDMNxv2Nv+vus2E43kI8V9zx0KSoKGmxf3Dneja1PwRMVUVm7F7laIjHOb4ML
         P29xan1HzFac4a42xGM/CewcaHmcpfnlWOKDvQh2ihWtUaiWy7N/iPQGRJ6kO/d+lgHg
         1RFXo34U6BI60jeR+4yvaQt9gtVpM+YCT0cExTfSRm6QrP7OTrdZyuatoo+E4ypIht5a
         SsZ6PvzqCCUFM9OwZ8nakXE65cZzSB6Lu1zOpRiN/In1QgkPez/yWbZP6/e0+KQ0dX2R
         22cg==
X-Gm-Message-State: AOAM532eoiCchgNUH3yr7s+I2itkaPYIJkM5NszDyvk0QvG5sJcI0u7U
        +4DRNm/JC0RAKveGo1AoRsYdd3693P3fjEex+1rYhefF1yza6YcKInCC5fSec+GWaZJ7SpeDq85
        YHAjK57DgcoyaUg4/
X-Received: by 2002:a05:600c:3511:b0:38c:d035:cddb with SMTP id h17-20020a05600c351100b0038cd035cddbmr4956801wmq.74.1648736896976;
        Thu, 31 Mar 2022 07:28:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwioXJeQ7LueaCVhNXFGZxilHyx9T4pfG1BWSs78svKYnYqLgVd2D5QBzbRmgdM7ZuCiG/jsg==
X-Received: by 2002:a05:600c:3511:b0:38c:d035:cddb with SMTP id h17-20020a05600c351100b0038cd035cddbmr4956782wmq.74.1648736896716;
        Thu, 31 Mar 2022 07:28:16 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-142.dyn.eolo.it. [146.241.243.142])
        by smtp.gmail.com with ESMTPSA id o10-20020a5d47ca000000b00203fb25165esm23932923wrc.6.2022.03.31.07.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 07:28:16 -0700 (PDT)
Message-ID: <c80aa031a57d1d4a98dc3fbc98863d35e5fc9b58.camel@redhat.com>
Subject: Re: [PATCH net] tipc: use a write lock for keepalive_intv instead
 of a read lock
From:   Paolo Abeni <pabeni@redhat.com>
To:     Niels Dossche <dossche.niels@gmail.com>,
        tipc-discussion@lists.sourceforge.net
Cc:     netdev@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hoang Le <hoang.h.le@dektech.com.au>
Date:   Thu, 31 Mar 2022 16:28:15 +0200
In-Reply-To: <20220329161213.93576-1-dossche.niels@gmail.com>
References: <20220329161213.93576-1-dossche.niels@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-03-29 at 18:12 +0200, Niels Dossche wrote:
> Currently, n->keepalive_intv is written to while n is locked by a read
> lock instead of a write lock. This seems to me to break the atomicity
> against other readers.
> Change this to a write lock instead to solve the issue.
> 
> Note:
> I am currently working on a static analyser to detect missing locks
> using type-based static analysis as my master's thesis
> in order to obtain my master's degree.
> If you would like to have more details, please let me know.
> This was a reported case. I manually verified the report by looking
> at the code, so that I do not send wrong information or patches.
> After concluding that this seems to be a true positive, I created
> this patch. I have both compile-tested this patch and runtime-tested
> this patch on x86_64. The effect on a running system could be a
> potential race condition in exceptional cases.
> This issue was found on Linux v5.17.
> 
> Fixes: f5d6c3e5a359 ("tipc: fix node keep alive interval calculation")
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> ---
>  net/tipc/node.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/tipc/node.c b/net/tipc/node.c
> index 6ef95ce565bd..da867ddb93f5 100644
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -806,9 +806,9 @@ static void tipc_node_timeout(struct timer_list *t)
>  	/* Initial node interval to value larger (10 seconds), then it will be
>  	 * recalculated with link lowest tolerance
>  	 */
> -	tipc_node_read_lock(n);
> +	tipc_node_write_lock(n);

I agree with Hoang, this should be safe even without write lock, as
tipc_node_timeout() is the only function modifying keepalive_intv, and
such function is invoked only by a timer, so we are guaranteeded there
are no possible concurrent updates...

>  	n->keepalive_intv = 10000;
> -	tipc_node_read_unlock(n);
> +	tipc_node_write_unlock(n);
>  	for (bearer_id = 0; remains && (bearer_id < MAX_BEARERS); bearer_id++) {
>  		tipc_node_read_lock(n);

...otherwise we have a similar issue here: a few line below
keepalive_intv is updated via tipc_node_calculate_timer(), still under
the read lock

Thanks!

Paolo

