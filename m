Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8A968C4D6
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjBFRax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjBFRai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:30:38 -0500
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFF911E98
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:29:40 -0800 (PST)
Received: by mail-qt1-f171.google.com with SMTP id cr22so13631176qtb.10
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 09:29:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w/LaKIf+3pRA4MyQMhbr3PlVOqptn/pf/udFxon0+9Y=;
        b=iuiDH6ySPEzfb+PgnNPqhifrnL0a/EcqQEC1hrCAVZFHlQO3zdye/N/eCWg3PAYwsH
         54HpLNv91guX7nxZzSJeIZMfDD3XrA3O7Kpnbg0CA7CLoPps73GzV4MSPoYBU760x3A4
         cRtAY58J8e7w1KVSl7bs5t+gnKSM6J8kLNe9QPIsZSSbgG7lRQpsmLKmvlpHeF0/Gr5Q
         hheEKYRACeUgZnyFTH43Ir6D4GGoB92OwTcwTLAirKGA/ykn0lhuXOWIZN4YxLbBWdIf
         DbHLQLwNCfwTK6di+fB3tPg87aMDHOVksAmasARbA79Lc8ODDK8TI9pU2ONpymkGy5wo
         CqjQ==
X-Gm-Message-State: AO0yUKWoTUCkWjxgglDAAwBQKffqRTQCsA+kZMn0k5sryqIxI7vQ2wU0
        hPDQv1iWPPH6V1OlIBLpkGke
X-Google-Smtp-Source: AK7set/ae55jb9i/baaW/xLk4b7RJtQzOV+41D/ChSc6zOFdBQ9usaCQZSB0nyipHZthrt6kgVy39g==
X-Received: by 2002:a05:622a:c7:b0:3ba:1398:c68d with SMTP id p7-20020a05622a00c700b003ba1398c68dmr150769qtw.16.1675704579799;
        Mon, 06 Feb 2023 09:29:39 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net. [68.160.166.30])
        by smtp.gmail.com with ESMTPSA id b13-20020ac844cd000000b003ba1ccba523sm3956815qto.93.2023.02.06.09.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 09:29:39 -0800 (PST)
Date:   Mon, 6 Feb 2023 12:29:38 -0500
From:   Mike Snitzer <snitzer@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Subject: Re: [PATCH 11/17] dm: Remove completion function scaffolding
Message-ID: <Y+E5AkiVTbjgXWjs@redhat.com>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOydu-007zio-0W@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pOydu-007zio-0W@formenos.hmeau.com>
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06 2023 at  5:22P -0500,
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> This patch removes the temporary scaffolding now that the comletion
> function signature has been converted.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Mike Snitzer <snitzer@kernel.org>
