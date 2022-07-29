Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5DD5850CB
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbiG2NWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236585AbiG2NWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:22:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A0B867589
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659100925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t6UzigSQFA8q+j5Mgybx5TG7Kh6S2/0Tk4l4AGfLU+g=;
        b=QK33aGKAspW98wdpTN+gJms0w+3FjKYr+eD2mLVWY1QAYbG8FQD4hxTtbsqXasEpnMiRC8
        vChihY33VNtNd5seLI2vmEZKGNeyhH7V9xHAelbBzzGa/5Yx37xW1DDwzgT+shtUxXuWu+
        DvJavyeX+qJUmqRm2080ZxaQKL7CuLU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-zp8ES1eKODSiunI_-BOYIQ-1; Fri, 29 Jul 2022 09:22:04 -0400
X-MC-Unique: zp8ES1eKODSiunI_-BOYIQ-1
Received: by mail-wr1-f69.google.com with SMTP id t12-20020adfba4c000000b0021e7440666bso1197585wrg.22
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t6UzigSQFA8q+j5Mgybx5TG7Kh6S2/0Tk4l4AGfLU+g=;
        b=bO5UjnFQRDzwbr8FuXUfnH3haZUpXJD70JRV5HxPFEzvDG10eUp8FYRgg7mgtb0SJR
         uyMC59WI3D0kgZVltdE/N3z2aEekPf1E1/cV/DciE/tCkKCo7uO/8LfsuN3R+2GgJvNm
         5Xv+BIBuS+zyGn1+k/poz8z1m+hB/ZwoI69xSm75mRWQEbffRJyLCnaGt6jWrutwukFc
         HPkdmL37uzz3Cn9nXAZ33Lvj9bFGL6u3ZORXpR4dloIoV1AndJrucSsAXyWnc7yhIqiD
         8mCXsC/4nNk3Jnx6GX0Q0v7PHaDR9OEcgULCLFsFmGZG7KHw8jXnrrL+QjxdQdenSpOj
         wQwQ==
X-Gm-Message-State: ACgBeo1banxnlFRM6jW2nh6qKvG/R+I66MI2kJ7Fmzloziv9D1beO8xO
        OEDi3cfWV6lxlv6fKjQRXckrbTyG7qLUrJ+vOnB7wjceMjSj4qmLTOgtFw/n9Q/k56Zz1W7kX5M
        g7g7vEeAASOeHjyK2
X-Received: by 2002:a05:6000:1446:b0:21d:cfe1:67a0 with SMTP id v6-20020a056000144600b0021dcfe167a0mr2460331wrx.91.1659100922901;
        Fri, 29 Jul 2022 06:22:02 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6vMLExZMR9DLQHEIfD69cIW4FOfQ7hMlIt7PzoBBRvYs9I3k6RxRbVuvyE2vhWytx09BTt5A==
X-Received: by 2002:a05:6000:1446:b0:21d:cfe1:67a0 with SMTP id v6-20020a056000144600b0021dcfe167a0mr2460315wrx.91.1659100922635;
        Fri, 29 Jul 2022 06:22:02 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id b14-20020a056000054e00b0021f1522c93bsm1191846wrf.45.2022.07.29.06.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 06:22:02 -0700 (PDT)
Date:   Fri, 29 Jul 2022 15:22:00 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute-next v4 1/3] lib: refactor ll_proto functions
Message-ID: <20220729132200.GA10877@pc-4.home>
References: <20220729085035.535788-1-wojciech.drewek@intel.com>
 <20220729085035.535788-2-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729085035.535788-2-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 10:50:33AM +0200, Wojciech Drewek wrote:
> Move core logic of ll_proto_n2a and ll_proto_a2n
> to utils.c and make it more generic by allowing to
> pass table of protocols as argument (proto_tb).
> Introduce struct proto with protocol ID and name to
> allow this. This wil allow to use those functions by
> other use cases.

Acked-by: Guillaume Nault <gnault@redhat.com>

