Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF414D119F
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 09:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344774AbiCHIJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 03:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344135AbiCHIJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 03:09:28 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712793D483
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 00:08:30 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id u1so27076656wrg.11
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 00:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=w2kpbDHbmA0uZN+CsMThxfqb9nbhJ8u8Feprw4xNVCo=;
        b=H2fvfqR+I6VM2Kk9IJYxRI4A6ijk4Qn7lQFH2W2PR+olehv6klS+VeDxePKtFAVv7S
         8ygNpmOvYIXEw1Jkyy3vf1JJnxERuP+XaHmS1D4zxXtN2EdyDs7ra39Jt13vr/RQNfP8
         fHCRtN0Qudi90mb33HhTUycYmfmsCLq+k+OPt/4IbfQvQfL/Z/f2gIPMksMlUZLRgkD8
         DU4VmMObglStBQIyHpInbQRCEWzwYPwePXiQ0+mePYzxV2j3z475Kofkfj5CBFw6AG0O
         9pvZkuyTRM9guHFOE+Omp3Pxm3rFlyC8wW4M9fzHgQqGa08mdIaUWy/nC7uUgSRFuYZk
         XCIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=w2kpbDHbmA0uZN+CsMThxfqb9nbhJ8u8Feprw4xNVCo=;
        b=dkJu1dmS9bEoJK9/2Ou0RxuCkSManV/kowG+ry8c7XNgrbJNeGNT6vHbBqj0VfmUM/
         OXyq8gzF3FkrRMUY+h7c9gEUnZEt/Df2wH72qF8e4DKGMUxXm09kZ0sB7iJTX2aSm4Eb
         iP3Jlvaj6D61kh5hD89YHUDvxwM6glsO6EapvxN9/4gzhq76nx6TyL9GDMkPAzNQwaNq
         aQkmBecDGZfJHfY7IURK0/3Q3FgJFtkN+eTv23Hb4khHFE0WkOr0mdlNiXuaqEKsqtko
         GfBned0hzM52fIo3SgXbPyZGBmQDIfOzUj+HOMBNXA1AgIBNCAKM8p29+KTHIrAIR9aO
         jYcg==
X-Gm-Message-State: AOAM531YcPs+5XDAZ8hX6UVPdcDsV5z6Dsb3qWBBTIWRq167StjjMvlf
        dMuhJDImFMs4boPggbex7Enegplr0yVLNjbI
X-Google-Smtp-Source: ABdhPJzxQ/wNPlE0Op8r9v7pQTLfIf/oRM+ZegzSmvEtfz5rbvQrhtQyNtGfUsLEaBrywseYTM9mjA==
X-Received: by 2002:adf:fd50:0:b0:1f0:7a8e:c922 with SMTP id h16-20020adffd50000000b001f07a8ec922mr11353776wrs.166.1646726908942;
        Tue, 08 Mar 2022 00:08:28 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id m18-20020a05600c3b1200b003899d242c3asm1461077wms.44.2022.03.08.00.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 00:08:28 -0800 (PST)
Date:   Tue, 8 Mar 2022 08:08:25 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <YicO+aF4VhaBYNqK@google.com>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <CACGkMEsjmCNQPjxPjXL0WUfbMg8ARnumEp4yjUxqznMKR1nKSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEsjmCNQPjxPjXL0WUfbMg8ARnumEp4yjUxqznMKR1nKSQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 08 Mar 2022, Jason Wang wrote:

> On Tue, Mar 8, 2022 at 3:18 AM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > during virtqueue clean-up and we mitigate the reported issues.
> >
> > Also WARN() as a precautionary measure.  The purpose of this is to
> > capture possible future race conditions which may pop up over time.
> >
> > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> >
> > Cc: <stable@vger.kernel.org>
> > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/vhost/vhost.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 59edb5a1ffe28..ef7e371e3e649 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> >         int i;
> >
> >         for (i = 0; i < dev->nvqs; ++i) {
> > +               /* No workers should run here by design. However, races have
> > +                * previously occurred where drivers have been unable to flush
> > +                * all work properly prior to clean-up.  Without a successful
> > +                * flush the guest will malfunction, but avoiding host memory
> > +                * corruption in those cases does seem preferable.
> > +                */
> > +               WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > +
> 
> I don't get how this can help, the mutex could be grabbed in the
> middle of the above and below line.

The worst that happens in this slim scenario is we miss a warning.
The mutexes below will still function as expected and prevent possible
memory corruption.

> > +               mutex_lock(&dev->vqs[i]->mutex);
> >                 if (dev->vqs[i]->error_ctx)
> >                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
> >                 if (dev->vqs[i]->kick)
> > @@ -700,6 +709,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> >                 if (dev->vqs[i]->call_ctx.ctx)
> >                         eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> >                 vhost_vq_reset(dev, dev->vqs[i]);
> > +               mutex_unlock(&dev->vqs[i]->mutex);
> >         }
> 
> I'm not sure it's correct to assume some behaviour of a buggy device.
> For the device mutex, we use that to protect more than just err/call
> and vq.

When I authored this, I did so as *the* fix.  However, since the cause
of today's crash has now been patched, this has become a belt and
braces solution.  Michael's addition of the WARN() also has the
benefit of providing us with an early warning system for future
breakages.  Personally, I think it's kinda neat.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
