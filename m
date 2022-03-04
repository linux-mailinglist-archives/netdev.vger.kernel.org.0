Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337E64CD7A2
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 16:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbiCDPXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 10:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240256AbiCDPXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 10:23:24 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D057113A
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 07:22:36 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id q7-20020a7bce87000000b00382255f4ca9so6866321wmj.2
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 07:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4W8I3tuoGx81FDxurpr4MQTsgqMFmG2Aaynw/Q1B6WQ=;
        b=k+JiVAPhTAqF+YhhbFY6K4lLY0h6PsOG37nRSTtxjgjMYEjnkXYdM8ue2neMxbOUMd
         glwEwfVtimdk+5VC7t8ggYeOnY3vFNqk37zudCmGNA4+TNvkYjDYVQfjCV/CAIs4sI1J
         /RItdEOsUsK896yZv7ixVficdL48rnKo0v23B8y3bqasDUYTfBDPjodUEJZo6Kl1HVaW
         oca1BIl3h2lxf5XDiEo0TxQNabbqWAne5cV6MTt5iEUN98Z4cS/ySDOn2UOyIMNL8ya6
         vMWMoiSWViYt5GdRRB1HTkWWjm+3YfM+dp8FkzuUCx/WVBqB1GR5Uk7s0Qbv2E2XVoS8
         Z+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4W8I3tuoGx81FDxurpr4MQTsgqMFmG2Aaynw/Q1B6WQ=;
        b=fHfMM5xRX245kvUfnI/OtO+eyrOeadQcZhDEkzspsvE/y57iyCWqmn0VUtc9HsNfJx
         qHHKQedPXPQC6nGK6MS056nSSoUyswA9YPZBl+oVPBSyMvB3IOmaVW4w8u5ATg5+/69k
         iRODWt63z+k1xpjCQPf0Lndig6nKSefA+MVekvsj+Gdx5nhEGh/6lhtlqvrdnGWSH3pP
         eM8MQ97aUv+aYmmWIxPCC6OAsFwUd9jW1uEYI6yeYUMmI4R5E0MYeenry8jx8loW8XUP
         eYuKCNRtpcxtqus/UCSOcXdU2Xd0sbFIx5CVDWJGIlMQfO8Axm9h8sJC5e5VNECkuk1G
         QXmg==
X-Gm-Message-State: AOAM530hh5zzenkewVBWE4Vaq/TaPZEItUn9+bQoOxWuI3DaU0nqgbcr
        h51yuPDA6xjBDQ4F+TRnH4WU3w==
X-Google-Smtp-Source: ABdhPJxyPmGIr1XY/Q8xeCKdKIUg6uvyxv3uFluaInb3jO0pRYMOkp8CabliJMJWznAUeyx6sVvC7g==
X-Received: by 2002:a7b:c4c7:0:b0:381:874e:30a9 with SMTP id g7-20020a7bc4c7000000b00381874e30a9mr7932742wmk.53.1646407354614;
        Fri, 04 Mar 2022 07:22:34 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id z2-20020a056000110200b001e7140ddb44sm4809507wrw.49.2022.03.04.07.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 07:22:34 -0800 (PST)
Date:   Fri, 4 Mar 2022 15:22:32 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <YiIuuHwY194VlLPx@google.com>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220303235937-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220303235937-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Mar 2022, Michael S. Tsirkin wrote:

> On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > to vhost_get_vq_desc().  All we have to do is take the same lock
> > during virtqueue clean-up and we mitigate the reported issues.
> > 
> > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > 
> > Cc: <stable@vger.kernel.org>
> > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> So combine with the warning patch and update description with
> the comment I posted, explaining it's more a just in case thing.

Will do.  Plan is to submit this on Monday.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
