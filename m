Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B10A597395
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240737AbiHQQFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240759AbiHQQEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:04:53 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17159FABC
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 09:04:25 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id y3so18109590eda.6
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 09:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=U5jw3QHa+iaIPk1CEpZnETysV2acYZOZO5IcpVoLmmM=;
        b=DAPJSc/u2ev6bYXSBrTqwGZ4PaTl8WKl6DiAoyMnKBgA+8zqmrgKU4aVMESdOKZMZT
         SYoGZEdZ4zKG6vHrMZHRGM9k/zEgGqHhynaxUWM7PoNiqiL3sqU34A1ORMMSy9lm01+p
         xih4rucikfbN8PfPcI3ROoqXZHnqdlxXa7TQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=U5jw3QHa+iaIPk1CEpZnETysV2acYZOZO5IcpVoLmmM=;
        b=meyRDyyllWq2DXxUA4hUVRHsvLVIddSTmQSea5aBiMMVZYQD5ehr9HtOMsQvuhn8B8
         t/MeS1SYKpLYm52kSRPFfo7YgxmWBxzl1InQXQ0gYcrxc0M6h8Royxm7ecQzspnLLGz4
         luop7IIO2+DMEj5rZTu3ub06Eq6lu10asDke8Yd+vMVTNNcOddxzHFKfXGzncwTX5Twr
         LgXcBlXB3LcTXDlcmdYSlDPRv/ccq+fQ9E1OtwVnmWRzaJ/dywjE9QxRT4CRQWxV+iGH
         hBXpjXZcovMfHD7vE6CvBKyEXnXjHV4aTANWstXVVwZal4t5dD3weU1v0jRLj8Eggzdt
         D8cg==
X-Gm-Message-State: ACgBeo3b+gz5LKl2018do+fW4WluzouKp0H9OurscWcVY6mu5YnIPiFe
        BVgdi+n/jd00QtdG/kt9NlPUOKGO1OPJETSY43Q=
X-Google-Smtp-Source: AA6agR6rYYOUFRP4WVlX2UjaHOD8ztr2vOdTjdBBUraZ6qlxzp2JqQXsVHBkHsvfe3VrrNEthtVnIA==
X-Received: by 2002:a05:6402:90a:b0:443:8b10:bcad with SMTP id g10-20020a056402090a00b004438b10bcadmr16960788edz.416.1660752263380;
        Wed, 17 Aug 2022 09:04:23 -0700 (PDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id h17-20020a056402095100b0043aba618bf6sm10987687edz.80.2022.08.17.09.04.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 09:04:23 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso1161139wmb.2
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 09:04:22 -0700 (PDT)
X-Received: by 2002:a05:600c:2195:b0:3a6:b3c:c100 with SMTP id
 e21-20020a05600c219500b003a60b3cc100mr2523659wme.8.1660751916369; Wed, 17 Aug
 2022 08:58:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220815113729-mutt-send-email-mst@kernel.org>
 <20220815164503.jsoezxcm6q4u2b6j@awork3.anarazel.de> <20220815124748-mutt-send-email-mst@kernel.org>
 <20220815174617.z4chnftzcbv6frqr@awork3.anarazel.de> <20220815161423-mutt-send-email-mst@kernel.org>
 <20220815205330.m54g7vcs77r6owd6@awork3.anarazel.de> <20220815170444-mutt-send-email-mst@kernel.org>
 <20220817061359.200970-1-dvyukov@google.com> <1660718191.3631961-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1660718191.3631961-1-xuanzhuo@linux.alibaba.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 17 Aug 2022 08:58:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wghjyi5cyDY96m4LtQ_i8Rdgt9Rsmd028XoU6RU=bsy_w@mail.gmail.com>
Message-ID: <CAHk-=wghjyi5cyDY96m4LtQ_i8Rdgt9Rsmd028XoU6RU=bsy_w@mail.gmail.com>
Subject: Re: upstream kernel crashes
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        James.Bottomley@hansenpartnership.com, andres@anarazel.de,
        axboe@kernel.dk, c@redhat.com, davem@davemloft.net,
        edumazet@google.com, gregkh@linuxfoundation.org,
        jasowang@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@roeck-us.net, martin.petersen@oracle.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org,
        kasan-dev@googlegroups.com, mst@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 11:47 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> +       BUG_ON(num != virtqueue_get_vring_size(vq));
> +

Please, no more BUG_ON.

Add a WARN_ON_ONCE() and return an  error.

           Linus
