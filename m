Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716086A1873
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 10:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjBXJCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 04:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjBXJCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 04:02:04 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5FB65327
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 01:02:03 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id t25-20020a1c7719000000b003eb052cc5ccso1172689wmi.4
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 01:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Af6WgvNmT0NBYX8KqecaHyOsDyRmwtzc0PE54IF/OYI=;
        b=V0FMUdyBn05OpoYB9M0WT7jUMm6YDMR9tpu4gkUIB2PGrJx7geBF6sbCWM7zr/MviE
         xOqz43FV0el3YD12ZcdQ1yYcE76+pjWy3psYDazlwK5hLk3ONGZLqpO9g6cgyWTcIKna
         YGfDRMgDROC28MkxDllCZejshz8ih69ouSsWvBozLIsFObR/j5IcIwIkbSFfYLZUDRW5
         hxvOGoy9cKHPv22fShrncm4BKUaGvcuyA48qtnY//7o2O2nFL9JDHCRDKKzBWYcdOYnJ
         dBJjEJd07LHP3Rb0XZSsme4dsEz43fX+GC8acpyQINoAbqsGW8Ck12vpgv5LbvzdYonr
         w0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Af6WgvNmT0NBYX8KqecaHyOsDyRmwtzc0PE54IF/OYI=;
        b=XGjjbN/ZIxYxJRLSOO5TgM8m5TgUeP9v086r2wmD/Ey4G0v+m4m9nyMz91deS9FA1t
         n5MexdN2hlEhgC/VMavSETklZ8DfTtVU1iiJZm2sRVP6ss94MyyqBZ9OxyQIQn8oetEL
         aM5yOAy+4zYZ8RvVLd2vwfi2P/wpuaBrDWVdG9SgcXuBiqff3Ezsy95K4TOB3Y1Tdwqe
         nb/lWqa1G9X6Pskoke+7iwih3HGqL6isJ1+dSyO98ZK/MI7wPsNxN04/S9Il/yWEyxpr
         gRfrQJ/W3tEnxTR+k9xfQ78pu4AiiozoDKPVQHY3GjiUjUDuLhtb2ZEqybZodCuh909W
         6uiQ==
X-Gm-Message-State: AO0yUKXxRuXYHCnJDrKcRai3zPpurjrTqdyURnmvYKtMTUzo9ozSIJ/n
        4+zimemxku6pdrZIcfFPyvQ0Q718B3Y=
X-Google-Smtp-Source: AK7set+hjS9d8bl6+iqpQCZuz71UZdHk3zuYXOVw+26opVrBQe2wQaJuE+0srI8UYIi4zmMr3LFdzA==
X-Received: by 2002:a1c:4c14:0:b0:3de:1d31:1042 with SMTP id z20-20020a1c4c14000000b003de1d311042mr11988835wmf.23.1677229321571;
        Fri, 24 Feb 2023 01:02:01 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id ay31-20020a05600c1e1f00b003e209186c07sm2099367wmb.19.2023.02.24.01.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 01:02:01 -0800 (PST)
Date:   Fri, 24 Feb 2023 09:01:59 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH net-next v4 3/4] sfc: support unicast PTP
Message-ID: <Y/h8w80liiVmw3Ap@gmail.com>
Mail-Followup-To: Richard Cochran <richardcochran@gmail.com>,
        =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, ecree.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230221125217.20775-1-ihuguet@redhat.com>
 <20230221125217.20775-4-ihuguet@redhat.com>
 <c5e64811-ba8a-58d3-77f6-6fd6d2ea7901@linux.dev>
 <CACT4oudpiNkdrhzq4fHgnNgNJf1dOpA7w5DfZqo6OX1kgNpcmQ@mail.gmail.com>
 <Y/ZIXRf1LEMBsV9r@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y/ZIXRf1LEMBsV9r@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 08:52:45AM -0800, Richard Cochran wrote:
> On Wed, Feb 22, 2023 at 03:41:51PM +0100, Íñigo Huguet wrote:
> 
> > The reason is explained in a comment in efx_ptp_insert_multicast filters:
> >    Must filter on both event and general ports to ensure
> >    that there is no packet re-ordering
> 
> There is nothing wrong with re-ordering.

I disagree. If re-ordering can be avoided that is a good thing.

> Nothing guarantees that
> datagrams are received in the order they are sent.

True, but they usually are.

> The user space PTP stack must be handle out of order messages correct
> (which ptp4l does do BTW).

This takes CPU time. If it can be avoided that is a good thing, as
it puts less pressure on the host. It is not just about CPU load, it
is also about latency.

Martin
