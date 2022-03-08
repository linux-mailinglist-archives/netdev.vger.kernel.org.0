Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FAB4D1444
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 11:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345637AbiCHKJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 05:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiCHKJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 05:09:48 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4761220CB
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 02:08:51 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 7-20020a05600c228700b00385fd860f49so1155352wmf.0
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 02:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SkUfNfh3Db7trPuKU1cr1xzPGmDu+V01w8HeZZrfZF4=;
        b=TcEZ7SnCqx+88Ek0cWwzw0I0uG+pFNYXYTSd6/FUBFUNJcDZChkJJ7aym8/zsrh9wP
         0WJgPgrTgga9nbrft6Qq3nPhOdr+MPh3ve1ACFwiAtZ1rDXFoxerrnct9JfMVDD9vNBu
         OVt7YNvg58Lpaq4XSGltz3TE2P1VPLaSGGWj0ekHuYkbs1y0QLp2/q2TKPBPjgaBgYZm
         FndSCehbwzLESjJjkPoLr143+oqKI3+53ODsNc2UrDsJ7JxHh88NLirt+Z0q4CIxGxz3
         Vghz+IB7ZlQCNmZ0+SdIERYZwTdCaLnVmvnqMTFRhkSMoqNHWVB32uO4XfMp6DyYlqXs
         OZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SkUfNfh3Db7trPuKU1cr1xzPGmDu+V01w8HeZZrfZF4=;
        b=n//rTeQGZrTcjRRCBAMcZ0FYV/bQ8nV1ycQ9A9PN0oxjfSn1T7vYZjKOuFn3sWDsV3
         W+bUGqWlvmk5TAUmqW2cd11hnZwyVq/46Qi3yTT49MqmwXvH15GDqS0pp+TZOIQE1d0l
         UHcS8tmvcHZFl7XDBHHp6q2JDJkplDsjjSu4I5T7rg6jslvEmgjONTCa6s0+4+NO0KR5
         SFjuCO4Yq1qPwi6TbEQUfJXP/AbYBapeyJubMwBDuwPkY8qN5jVJ5PLdscOGpzx8cyFc
         s95vdZMZbyzq2JV+KsPN5S/vlg7pyxGIkus7Kqx4G+TmqXWmmUaSaETnnyfZgJkzGQUd
         9+Ng==
X-Gm-Message-State: AOAM5328nsBYbTIKgbu+bqEDUIci8TdMiCa7kn8jxAWfnCyuwIQrHikF
        EHd8SfvSNVfhzGSVHudMYHlBeg==
X-Google-Smtp-Source: ABdhPJyrzL3jGMmbS7hVKMZbspK5xUkBY1M3etbicBcGEMsABnOdM650d1NvL9CixlA6YyPMGo+S2Q==
X-Received: by 2002:a1c:6a08:0:b0:388:73a2:1548 with SMTP id f8-20020a1c6a08000000b0038873a21548mr2868053wmc.163.1646734130240;
        Tue, 08 Mar 2022 02:08:50 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id u14-20020adfed4e000000b001e3323611e5sm12978222wro.26.2022.03.08.02.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 02:08:49 -0800 (PST)
Date:   Tue, 8 Mar 2022 10:08:47 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <YicrL1RXZhXXsA6t@google.com>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
 <YicPXnNFHpoJHcUN@google.com>
 <Yicalf1I6oBytbse@kroah.com>
 <Yicer3yGg5rrdSIs@google.com>
 <YicolvcbY9VT6AKc@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YicolvcbY9VT6AKc@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 08 Mar 2022, Greg KH wrote:

> On Tue, Mar 08, 2022 at 09:15:27AM +0000, Lee Jones wrote:
> > On Tue, 08 Mar 2022, Greg KH wrote:
> > 
> > > On Tue, Mar 08, 2022 at 08:10:06AM +0000, Lee Jones wrote:
> > > > On Mon, 07 Mar 2022, Greg KH wrote:
> > > > 
> > > > > On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > > > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > > > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > > > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > > > 
> > > > > > Also WARN() as a precautionary measure.  The purpose of this is to
> > > > > > capture possible future race conditions which may pop up over time.
> > > > > > 
> > > > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > > > 
> > > > > > Cc: <stable@vger.kernel.org>
> > > > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > ---
> > > > > >  drivers/vhost/vhost.c | 10 ++++++++++
> > > > > >  1 file changed, 10 insertions(+)
> > > > > > 
> > > > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > > > index 59edb5a1ffe28..ef7e371e3e649 100644
> > > > > > --- a/drivers/vhost/vhost.c
> > > > > > +++ b/drivers/vhost/vhost.c
> > > > > > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > > >  	int i;
> > > > > >  
> > > > > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > > > > +		/* No workers should run here by design. However, races have
> > > > > > +		 * previously occurred where drivers have been unable to flush
> > > > > > +		 * all work properly prior to clean-up.  Without a successful
> > > > > > +		 * flush the guest will malfunction, but avoiding host memory
> > > > > > +		 * corruption in those cases does seem preferable.
> > > > > > +		 */
> > > > > > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > > > > 
> > > > > So you are trading one syzbot triggered issue for another one in the
> > > > > future?  :)
> > > > > 
> > > > > If this ever can happen, handle it, but don't log it with a WARN_ON() as
> > > > > that will trigger the panic-on-warn boxes, as well as syzbot.  Unless
> > > > > you want that to happen?
> > > > 
> > > > No, Syzbot doesn't report warnings, only BUGs and memory corruption.
> > > 
> > > Has it changed?  Last I looked, it did trigger on WARN_* calls, which
> > > has resulted in a huge number of kernel fixes because of that.
> > 
> > Everything is customisable in syzkaller, so maybe there are specific
> > builds which panic_on_warn enabled, but none that I'm involved with
> > do.
> 
> Many systems run with panic-on-warn (i.e. the cloud), as they want to
> drop a box and restart it if anything goes wrong.
> 
> That's why syzbot reports on WARN_* calls.  They should never be
> reachable by userspace actions.
> 
> > Here follows a topical example.  The report above in the Link: tag
> > comes with a crashlog [0].  In there you can see the WARN() at the
> > bottom of vhost_dev_cleanup() trigger many times due to a populated
> > (non-flushed) worker list, before finally tripping the BUG() which
> > triggers the report:
> > 
> > [0] https://syzkaller.appspot.com/text?tag=CrashLog&x=16a61fce700000
> 
> Ok, so both happens here.  But don't add a warning for something that
> can't happen.  Just handle it and move on.  It looks like you are
> handling it in this code, so please drop the WARN_ON().

Happy to oblige.

Let's give Micheal a chance to speak, then I'll fix-up if he agrees.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
