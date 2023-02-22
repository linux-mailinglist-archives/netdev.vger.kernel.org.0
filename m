Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F5D69F955
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 17:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjBVQwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 11:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjBVQwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 11:52:54 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FBD1BE1
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 08:52:49 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id nt5-20020a17090b248500b00237161e33f4so7025274pjb.4
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 08:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677084768;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dtnYuPsYH76l9YZ6s6fg0KX7EyzKyKMQbokJzkHVSwE=;
        b=HZ4bf/zn7n1LASaPt1MKcRgn6rRw4hu052PqLbGesxb+0JKvkWIAAWdSseRcDHUedj
         YZminyFGmtba0F7u69F9sBHiS7Mqk9cRYXnojcIW9WQM48NY8Oqv93KpLINsaHv8scaG
         +m8Mo9Ckax0ibhB4z5sX0QiTaiPeNJNRwDvWpcge37dKF0Vyr1ZYuof8x/wtCoP7fm90
         3q+Yh3HW6ECyORJmgwrp79Ta4XCR9yivMzE8jrudNdAWYFFe6Pek0p7uHG0BwOAOzXmy
         rJlh/p3z3cG/Z2t13Vpz0L9VMz9OKeTmorlmzWlL+kJ0PG7XxN1WucrrhNp9zFQHR9kk
         TRbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677084768;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dtnYuPsYH76l9YZ6s6fg0KX7EyzKyKMQbokJzkHVSwE=;
        b=1HVVdoSxpGR+xYrY+EC1n9Omz2vaFU4QOOmGZKFOTF7SmaTKkiybZxAkDSJDliyrme
         l7kqz4ztWcVuhqrsv9QkFzS9duKf2miT9tqCLMZ0vItN9AZfcg92jqUWw7fx7O2lilft
         0uptDNND5ckHhR4GnnHgqNAMdNeI3iML/lGVV4VN4F38Ydwd4fb1aqbEARfnpv6tmcZB
         c1xW1zf1G1qswwhrkowXQjFiuf+tiN9AgiAPBguuxLdIkjbHRF51b0adhLHtisaRt1Lz
         oEyIdFQXdGPLmmt/DeGYL3iDjCgFUMDXiV4wJFCNmvSaYdHqoZm57j98H0AfvRXA34Eu
         4VEQ==
X-Gm-Message-State: AO0yUKVLLh6DRnajEDwRmugjieo4xTZNceOgv97sqe8O+CrUZdgdTR4S
        udyrls8q8MMLCtvwdCHv8Jk=
X-Google-Smtp-Source: AK7set8lnjesmIIQqhn6xdsjaLovuPkRZxYs7NDUqbenzc8x8K2GAR8kj/1yyve1p6lY9fDBmqoFvg==
X-Received: by 2002:a17:902:e80d:b0:19a:a2e7:64de with SMTP id u13-20020a170902e80d00b0019aa2e764demr9590820plg.0.1677084768638;
        Wed, 22 Feb 2023 08:52:48 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y14-20020a170902b48e00b00199536fbc6fsm2782046plr.280.2023.02.22.08.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 08:52:47 -0800 (PST)
Date:   Wed, 22 Feb 2023 08:52:45 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH net-next v4 3/4] sfc: support unicast PTP
Message-ID: <Y/ZIXRf1LEMBsV9r@hoboy.vegasvil.org>
References: <20230221125217.20775-1-ihuguet@redhat.com>
 <20230221125217.20775-4-ihuguet@redhat.com>
 <c5e64811-ba8a-58d3-77f6-6fd6d2ea7901@linux.dev>
 <CACT4oudpiNkdrhzq4fHgnNgNJf1dOpA7w5DfZqo6OX1kgNpcmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4oudpiNkdrhzq4fHgnNgNJf1dOpA7w5DfZqo6OX1kgNpcmQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 03:41:51PM +0100, Íñigo Huguet wrote:

> The reason is explained in a comment in efx_ptp_insert_multicast filters:
>    Must filter on both event and general ports to ensure
>    that there is no packet re-ordering

There is nothing wrong with re-ordering.  Nothing guarantees that
datagrams are received in the order they are sent.

The user space PTP stack must be handle out of order messages correct
(which ptp4l does do BTW).

Thanks,
Richard
