Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C1A6E1CB2
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 08:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjDNGdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 02:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDNGdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 02:33:00 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAEA1FFD;
        Thu, 13 Apr 2023 23:32:57 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id w24so6793525wra.10;
        Thu, 13 Apr 2023 23:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681453976; x=1684045976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wu9t9qkvRho3a2+VOvYAw+ny13P5sPBLocJ00Zos1+0=;
        b=i63ZUmiwp2QsF62nyzrRiuqkcWRkBgu7ZE8QFGne5qA0EbAWUXmsXYiwkglPOu2+cy
         qR/z8rlRj8h6RysuwTOHiT2yl/0MD6ZmPKvSZxLDTp6uavfTYO/rnH0IkqUr+b9Mn5sD
         97XiWJJdD0nBIYcTpdy97CkOzOelbBMjj4Veedlc8kV9FIGcV6Z0MCapKrm5gCz4MQNH
         FU7okbbo/sZC8PIoD2ELnt+/udpzRtwk8xFAyoO9dUzKV/3FUMeCL78EENTUNL/pX1HI
         qutoq/8j7SEf66WZzYPbuYhVbYukC7amlqka7D5f2Hl0IV9pYkkntCr9L3LNc9CYDy6/
         CvUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681453976; x=1684045976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wu9t9qkvRho3a2+VOvYAw+ny13P5sPBLocJ00Zos1+0=;
        b=MywIC9loIKJsAPDQ1eYnEkJX/BO6L52km7H0yiOmazNHFeAEimpUoW+r2gPhUgXXSn
         kBSvKrVfDlF23/R7245/UclDvno93XRVSooU4FU1DL7qRTE+q9QON63OxWM3IVu75t/k
         0klNPqmFbANxPinRwu5dshZvCuwQuBwaKk1AfAQyFSE/cGCPVcRwB2Z36YoW/Q+3VTwd
         bYhGPIhJ4vEWloYCFckMdBg45VnwigKf0keTexomKy0kHCa0rcLd4wtZWy5+8hYd9T7k
         Kvkx1zexR7KcMjCAn+B5l/nuyZmPCWvDWqM/w7XPV2wok2xD2UoGbLbdvdkqzaZO/CHz
         WG+w==
X-Gm-Message-State: AAQBX9cKxyfewZiOQqfxragkZwMmJG/6EIrqpJjb7UG8DObcwL3PPa54
        4C71wpoe+65HQ/FB5NRPZ28=
X-Google-Smtp-Source: AKy350ZAC/ZKvfRKMwL4WNCGIl+3kXoSut0GX7Q8mBQCMiu8Rxu9pJXuSdeX+M49NzprIM6KcWBQsA==
X-Received: by 2002:a5d:43c4:0:b0:2c5:5687:5ed5 with SMTP id v4-20020a5d43c4000000b002c556875ed5mr3220704wrr.18.1681453975545;
        Thu, 13 Apr 2023 23:32:55 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id j11-20020a05600c190b00b003f09c34fa4csm7283184wmq.40.2023.04.13.23.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 23:32:55 -0700 (PDT)
Date:   Fri, 14 Apr 2023 09:32:51 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     Haoyi Liu <iccccc@hust.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        hust-os-kernel-patches@googlegroups.com, yalongz@hust.edu.cn,
        Dongliang Mu <dzm91@hust.edu.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/ipv6: silence 'passing zero to
 ERR_PTR()' warning
Message-ID: <11c76aa6-4c19-4f1d-86dd-e94e683dbd64@kili.mountain>
References: <20230413101005.7504-1-iccccc@hust.edu.cn>
 <a3e202ed-a50f-2a0f-082b-ec0313be096e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3e202ed-a50f-2a0f-082b-ec0313be096e@kernel.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 06:32:24PM -0600, David Ahern wrote:
> On 4/13/23 4:10 AM, Haoyi Liu wrote:
> > Smatch complains that if xfrm_lookup() returns NULL then this does a
> > weird thing with "err":
> 
> xfrm_lookup is a wrapper around xfrm_lookup_with_ifid which returns
> either either a valid dst or ERR_PTR(err).

Also it can return NULL.

net/xfrm/xfrm_policy.c
  3229                  dst = dst_orig;
  3230          }
  3231  ok:
  3232          xfrm_pols_put(pols, drop_pols);
  3233          if (dst && dst->xfrm &&
                    ^^^
"dst" is NULL.

  3234              dst->xfrm->props.mode == XFRM_MODE_TUNNEL)
  3235                  dst->flags |= DST_XFRM_TUNNEL;
  3236          return dst;
                ^^^^^^^^^^^
  3237  

So in the original code what happened here was:

net/ipv6/icmp.c
   395          dst2 = xfrm_lookup(net, dst2, flowi6_to_flowi(&fl2), sk, XFRM_LOOKUP_ICMP);
   396          if (!IS_ERR(dst2)) {

xfrm_lookup() returns NULL.  NULL is not an error pointer.

   397                  dst_release(dst);
   398                  dst = dst2;

We set "dst" to NULL.

   399          } else {
   400                  err = PTR_ERR(dst2);
   401                  if (err == -EPERM) {
   402                          dst_release(dst);
   403                          return dst2;
   404                  } else
   405                          goto relookup_failed;
   406          }
   407  
   408  relookup_failed:
   409          if (dst)
   410                  return dst;

dst is not NULL so we don't return it.

   411          return ERR_PTR(err);

However "err" is not set so we do return NULL and Smatch complains about
that.

Returning ERR_PTR(0); is not necessarily a bug, however 80% of the time
in newly introduced code it is a bug.  Here, returning NULL is correct.
So this is a false positive, but the code is just wibbly winding and so
difficult to read.

   412  }

regards,
dan carpenter
