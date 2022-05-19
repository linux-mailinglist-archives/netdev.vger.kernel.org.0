Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7648E52DC9C
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242978AbiESSSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240855AbiESSSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:18:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF6C88CB0E
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 11:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652984280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CCe4jzkEM21jgBEAbYUjXJxP7mWaBW+jz2xznXdsy+I=;
        b=RuPr1C3HHVhYWb0EvnMn3BYXswEcW3kqLR0hFm9QGuelLdUSRhygsl8YPmJT38R6W41W+p
        o+srbXoOjf1eUmoy2o0Ny9iJrcGl5UkiidDNpZXvTs/0o608T385Z7X8FI2RbdyC7PCf3r
        foOlpv1s+o+cAxb31hBA7hEbGq4bnGw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-h7jOeViUPHu3gu-YjzgWDw-1; Thu, 19 May 2022 14:17:59 -0400
X-MC-Unique: h7jOeViUPHu3gu-YjzgWDw-1
Received: by mail-qv1-f72.google.com with SMTP id w6-20020a05621404a600b00461c740f357so4942334qvz.6
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 11:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CCe4jzkEM21jgBEAbYUjXJxP7mWaBW+jz2xznXdsy+I=;
        b=4MOwsyajPzPNCyHJeDMHQWiZPddQMRdU+VEmt+DdT/E129pEsMvH7G+e08Gy5ob7yf
         kLsXavk9KArA7FQ+vfHvaVcizgRRRUQHuEaF4Vk3UmiL8rO/InghEm6JyeuuwiE3Y/J6
         ZrJK3sYHXLEbqJUJfpR24NhJYywpy1nemhBchFBkPTUbMsy3YiDhGhyQaHhQfQvAvL6o
         0ifv/hRLVMLnyWfQb0R7yWEwmCkF3IVEoT82lR5clVvr2VLY5ruydXLpkOn+w3GAhIUm
         6Zpc9G0aTci/K/mVV/ahFMSyYf1Hun0VUf4+pu+ymPh5AyMRD+XOznrnyOOembffOzgM
         yg+A==
X-Gm-Message-State: AOAM532iKPuVBsuGjEyWFWk881qG8PLo2YezlHA50wB8Rr0z/R7d08ji
        9HiZOAVqdgbtruJg7QFPXJqMgji4GRlk39dZJdFA9otS5JiU2vOt9ofpaoRGSnhTJjykCPKwzbJ
        tguq7iL73FvusHp7y
X-Received: by 2002:a05:620a:2943:b0:6a0:11b6:3a71 with SMTP id n3-20020a05620a294300b006a011b63a71mr3954549qkp.719.1652984279153;
        Thu, 19 May 2022 11:17:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTwxBQRbW5CXzavBWzZt+6Xg7JO8uFoYY0eybwSqD5ztTjROukyftoK04mSMAGDwdI3zcVSg==
X-Received: by 2002:a05:620a:2943:b0:6a0:11b6:3a71 with SMTP id n3-20020a05620a294300b006a011b63a71mr3954535qkp.719.1652984278883;
        Thu, 19 May 2022 11:17:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id v64-20020a376143000000b006a32baf67aasm1687002qkb.27.2022.05.19.11.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 11:17:58 -0700 (PDT)
Message-ID: <3ecbe9d60f555266fe09d5a8c657b87d6f7564b8.camel@redhat.com>
Subject: Re: [PATCH net v3] net: macb: Fix PTP one step sync support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Harini Katakam <harini.katakam@xilinx.com>,
        nicolas.ferre@microchip.com, davem@davemloft.net,
        richardcochran@gmail.com, claudiu.beznea@microchip.com,
        kuba@kernel.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        radhey.shyam.pandey@xilinx.com
Date:   Thu, 19 May 2022 20:17:54 +0200
In-Reply-To: <20220518170756.7752-1-harini.katakam@xilinx.com>
References: <20220518170756.7752-1-harini.katakam@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-18 at 22:37 +0530, Harini Katakam wrote:
> PTP one step sync packets cannot have CSUM padding and insertion in
> SW since time stamp is inserted on the fly by HW.
> In addition, ptp4l version 3.0 and above report an error when skb
> timestamps are reported for packets that not processed for TX TS
> after transmission.
> Add a helper to identify PTP one step sync and fix the above two
> errors. Add a common mask for PTP header flag field "twoStepflag".
> Also reset ptp OSS bit when one step is not selected.
> 
> Fixes: ab91f0a9b5f4 ("net: macb: Add hardware PTP support")
> Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

I'm sorry, but I cut the -net PR to Linus too early for this, so the
fix will have to wait for a little more (no need to repost!) and even
more pause will be required for the net-next follow-up.

Sorry for the inconvenince,

Paolo

