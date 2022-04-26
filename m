Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB46510B36
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 23:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355393AbiDZV3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 17:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355412AbiDZV3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 17:29:01 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC6A20F4D;
        Tue, 26 Apr 2022 14:25:53 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e24so2729259pjt.2;
        Tue, 26 Apr 2022 14:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EyILSFoZw2cbm/C5h87Ay+c0TJOaiR07UrHL1H0LCnM=;
        b=DMZmdertktNaXEzTee8aLIoFs4LmAQt647J1tHewuIBirT1LuBLcGunbVEcIQpLghU
         a0pVnYeHErYAByH2e7FXHNnEveKi2TzoFoA29mTaHPwQO7tv5srujxfjnjZ416OzzDyv
         Zk4A+U3U4zU7uUf1bTaIMGcdvhezpZHoPt4HKrB4bwKPTNsvwl9GJenFLfXYue8VioL4
         FnyJUW/n0FWO62VFnHgQMy7S6s5e3iT1zbpiu0xjbsHQfU7K3kXxkukQqaprAPkctbpp
         CfhkpRSKdB4SeesOTLvJaKK0TfRXCqiFlPhCZFdw7S4k6GPkRVnns5o4kWeAklbIEycA
         vdtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EyILSFoZw2cbm/C5h87Ay+c0TJOaiR07UrHL1H0LCnM=;
        b=CsJBRKtCLd1Jd4TSBlWIEiEFYPkMQQ1YajKXRrBcqJiEiDusHaW0D3j91KtDBU8ALh
         3jrjjcilkdBEb2/anohppoJ5sqwNYBi54Svw0MdrOiJKwCubVUCh3jrdrWANir37Z8jV
         GPeznsHHwmEDklB/mBKWeieDmoDyrg+11imREqKST72HOFQkMXgedj3OGf1vYm04AHJe
         en7Iujvb0uKyR7AZQaWA70PEm4lMAVm+FwAdo7TGA5FBsT35M/bQzsOcrIeJS1dh4q4K
         uYHyLiNf+WQC2b/yKpEbLVBgDuR77OBN9Mu3KWe5k91C9UlZfv5+agxj5DBcM44zt4pV
         IU+w==
X-Gm-Message-State: AOAM530QaRy/H9XXAa+gtluPV54+c7VBJPsaKmT7CzDE7Y8n3EtTjDHz
        9kyCOuy/8OucF/8D0HH/5l00Lkk5ytE=
X-Google-Smtp-Source: ABdhPJxuN1vfIHqo+zDex1Hl0NbquGDM8pq87fwQNKG/vFy90O4uVVhXMPSCwaNZagCLJwoo/TwlIw==
X-Received: by 2002:a17:902:f64c:b0:156:7ceb:b579 with SMTP id m12-20020a170902f64c00b001567cebb579mr24625125plg.73.1651008352601;
        Tue, 26 Apr 2022 14:25:52 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id gw19-20020a17090b0a5300b001d97f7fca06sm4729325pjb.24.2022.04.26.14.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 14:25:52 -0700 (PDT)
Date:   Tue, 26 Apr 2022 14:25:50 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS
 support
Message-ID: <20220426212550.GB17420@hoboy.vegasvil.org>
References: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 03:32:53PM -0400, Min Li wrote:
> Use TOD_READ_SECONDARY for extts to keep TOD_READ_PRIMARY
> for gettime and settime exclusively
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  drivers/ptp/ptp_clockmatrix.c    | 303 +++++++++++++++++++++++++--------------
>  drivers/ptp/ptp_clockmatrix.h    |   5 +
>  include/linux/mfd/idt8a340_reg.h |  12 +-
>  3 files changed, 209 insertions(+), 111 deletions(-)

Acked-by: Richard Cochran <richardcochran@gmail.com>
