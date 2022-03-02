Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FE04CA1D0
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 11:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbiCBKIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 05:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237028AbiCBKIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 05:08:43 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFA1DFF5
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 02:07:59 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id bg16-20020a05600c3c9000b00380f6f473b0so2902956wmb.1
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 02:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zc2Kxkwq8yRJOIjT0AKi1HEEsJsOWY9kQ95eThh2v70=;
        b=ecAKqbUejfhOR4GBhQMpQI50QgEqRyNg/QnFeZcpReex2f/aKqpIJhK5D5uM8fAKWF
         mMf0G85D4XF9vE0xLxfF7IiVw6iAd7xy76WbrDFUoHm9U2roE5BFSjaD6rDbUu1nyLDs
         TUSLnUg4xns+ak4kN47GRaBDCiJs28GqnYG0nqw5JNZUjyvWuY6qte9Dl5jC9gDq4POq
         DWkEu69p7F7FmjVZ1US0DD/+mB5Qi8VwuedvAKxN2FVzxj5c0H3I9cSDR4Ftpmt/VfAS
         RZWk1CVThRo0jiotRwXIm+yIw9Cz03uAGiiqgwmCgWlCK4jT6bdRalYJSElqXS5X/Rlm
         UEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zc2Kxkwq8yRJOIjT0AKi1HEEsJsOWY9kQ95eThh2v70=;
        b=DLmiW0pdDXkiOJEfBCy1yb4f04XvRQBeuS9hEWKZMtwDJgsu3VNcrfnWlklgQDfjfx
         /OHNluAAxLs7B9vAG0BA/SfDEtayZkQNxK5d/gVCcUsWaktaADJh4hNtTrNvT4Fyq+pe
         sz3Tnf7oGigTluCPtMcbe8o0hX0YbQQlZFE9nqhyJvzPpQ8EgNk4NnR8RV4L0pgpwLTT
         2t+88W3uE+IlxrVeJHALFnXZlX/9SBZvcvncy08YPexPcLkRXE50uw+6cg2JdH+P9Ysp
         HnSjf5nUX8Nvj6h5dJE+mCZ5yLvdw+SvGM9Js/gdnegbivj44NtWhA/w5uI6ImUz5rOq
         i5vA==
X-Gm-Message-State: AOAM532oeOopfPVu0szsY8j/3RtT/CbwHlqqwfruFWNh3TRtH3CoCPUK
        gN8cFCtXC/uSaLsTrLNScpgzoQ==
X-Google-Smtp-Source: ABdhPJz8M0JUlRrgQnR37WHwsfOfDjkWNajdAFWhrLUoxOp/RJdiuL9DzgCo0omQgu5pxB9pI/a4/w==
X-Received: by 2002:a05:600c:378b:b0:381:67e7:e20c with SMTP id o11-20020a05600c378b00b0038167e7e20cmr10999452wmr.32.1646215677851;
        Wed, 02 Mar 2022 02:07:57 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id i5-20020a1c3b05000000b00382871cf734sm4075730wma.25.2022.03.02.02.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 02:07:57 -0800 (PST)
Date:   Wed, 2 Mar 2022 10:07:55 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <Yh9B+wKDKXHZ6ly/@google.com>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302093446.pjq3djoqi434ehz4@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220302093446.pjq3djoqi434ehz4@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Mar 2022, Stefano Garzarella wrote:

> On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > to vhost_get_vq_desc().  All we have to do is take the same lock
> > during virtqueue clean-up and we mitigate the reported issues.
> > 
> > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> 
> This issue is similar to [1] that should be already fixed upstream by [2].
> 
> However I think this patch would have prevented some issues, because
> vhost_vq_reset() sets vq->private to NULL, preventing the worker from
> running.
> 
> Anyway I think that when we enter in vhost_dev_cleanup() the worker should
> be already stopped, so it shouldn't be necessary to take the mutex. But in
> order to prevent future issues maybe it's better to take them, so:


> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks for the analysis and the review Stefano.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
