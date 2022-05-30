Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B84E538910
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 01:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242821AbiE3XEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 19:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242741AbiE3XEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 19:04:44 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6581553A6E
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 16:04:43 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 129so6940363pgc.2
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 16:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wvsx9QOw3yKY3DiRpplNW+C33EXyoaZ7VSxWs8/Uvyk=;
        b=TklPa8OkLrZVPTjtJUc3CF3PwrSBCZoa3Pk2AgZiDu7qGmRTZZeCH9riyvhku4/B/d
         6T+dCWLbDDUUqr19ZjaoZCU/NXFyuxVrpsHwMvte8+MnIlB0qNv7sqhBHJLyj+c73FEt
         qwZlmD0IBKNJws+Qep9dkx57Pjwox42IldMBtv51FC4lZRWFJ6Bh+l/ABpA11mhomi6L
         Jl+vO54A0VAO20mtOO+sxvGPbKCn1ZWfVJnKvswG8xTfS5VC2hhNTDSyjdhTtF0qEopE
         2WA1Hw4NCTRhDhr6B/gqj+AfDLzvb8OuvnBFOovcprw//jbqvARnwfMFXH69VyoXUBJx
         K/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wvsx9QOw3yKY3DiRpplNW+C33EXyoaZ7VSxWs8/Uvyk=;
        b=Qhbt/I57rCzrZA3d0MJBZ4tDIn3mZF28LjUrMW2UI4unqQ/nXpJ914gmmQydI99rme
         MGBvlFy0Rk3g1IVjD5X9eAtxbIp02qp1xGBLZMGrJqEjb76YKzRNnLZLUBLurgSPH+s7
         BP9tBn49RC0GX0X2wJwlU7upALBo+MVYmErbx06/W572n+i819TPBRW+fDmjvstyZCvy
         OOVJq36B8525HROV1Il4MILUXQQ4UPq8bgLcv1Xmea+xcIVJIFl/5783L8qc2qylt5Uz
         kfgtbcn1/D0p9AH61lQo+dbujAXM5HM+3vEb3O4EKwLf7zs522IE0oToIz6ZsUIRiVPc
         rWEA==
X-Gm-Message-State: AOAM533142+h0PA9WJKVMq07VO3CXph9lo/0WZeTmb5gpNxrBB7uIyQS
        +7ulrL2wIgR7yjd8iSMOs3k=
X-Google-Smtp-Source: ABdhPJyirqQ/Dhafaj8hSDoggSfKjcfkMqg7Ir+dk/Y1f+sVG7CXJ0k+6AjAZLDiOGGlF5pz0+38fg==
X-Received: by 2002:a63:a06:0:b0:3c2:3345:bf99 with SMTP id 6-20020a630a06000000b003c23345bf99mr50311969pgk.477.1653951882899;
        Mon, 30 May 2022 16:04:42 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902f78600b001635c9e7f77sm9740181pln.57.2022.05.30.16.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 16:04:42 -0700 (PDT)
Date:   Mon, 30 May 2022 16:04:39 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, kernel-team@fb.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [PATCH net-next v5 2/2] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220530230439.GA22405@hoboy.vegasvil.org>
References: <20220518223935.2312426-1-jonathan.lemon@gmail.com>
 <20220518223935.2312426-3-jonathan.lemon@gmail.com>
 <20220529003447.GA32026@hoboy.vegasvil.org>
 <20220530170744.zs6urci5lcytl2j4@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530170744.zs6urci5lcytl2j4@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 10:07:44AM -0700, Jonathan Lemon wrote:
> On Sat, May 28, 2022 at 05:34:47PM -0700, Richard Cochran wrote:
> > On Wed, May 18, 2022 at 03:39:35PM -0700, Jonathan Lemon wrote:
> > 
> > > +static int bcm_ptp_adjtime_locked(struct bcm_ptp_private *priv,
> > > +				  s64 delta_ns)
> > > +{
> > > +	struct timespec64 ts;
> > > +	int err;
> > > +
> > > +	err = bcm_ptp_gettime_locked(priv, &ts, NULL);
> > > +	if (!err) {
> > > +		set_normalized_timespec64(&ts, ts.tv_sec,
> > > +					  ts.tv_nsec + delta_ns);
> > 
> > This also takes a LONG time when delta is large...
> 
> Didn't we just go through this?  What constitutes a "large" offset here?
> The current version seems acceptable to me:

When the PHY boots, it starts from time zero.

Then as a client it needs to adjust to today, something like:

1653951762.413809006 or Mon May 30 16:02:42 2022

(that means adding 1,653,951,762,413,809,006 nanoseconds)

Try that and see how long it takes to apply the adjustment.

Thanks,
Richard
