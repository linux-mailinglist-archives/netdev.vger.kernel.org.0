Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05B34FC216
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 18:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343777AbiDKQWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 12:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242124AbiDKQWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 12:22:36 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1C730555
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 09:20:19 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id i27so31955833ejd.9
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 09:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=InkQAWOi5kUIzfoFQv0gHI/AUZPdTU0YUvjCx4nxJOg=;
        b=XA9zMvhfBsJlCa84lL55lvakm7Z8ytBs99rA7pXMy//nwKS0mQ5JbF/6JKTQyDqU1p
         frV5Rsl9/tPK8rehDGGQjTlCjZx485FVJdvAX1bCFVeglKqVh9erp/8fNdSCH+kyHwmJ
         L6qmit2/R7LZEcWtiR/NQbDHc6deX0HF1jtrCWey/xQ1ij1GVq21vR/mUsyqfr/GLjnc
         G8+Lmqlck5V7KFCVXFywD1GAiA5m8YjAXh9XH4ocnUCUbpGG9CUyYzBzC2mJ+Gft6D39
         G7ZIfz+BbTkV5AJywsER5bku51OS+R4rZwQ6IKaNI9bejuH9DXm+VA8bFB0Zsk6Gpi7Q
         YNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=InkQAWOi5kUIzfoFQv0gHI/AUZPdTU0YUvjCx4nxJOg=;
        b=apuj0VRDVBwFeZfuey38I5Mq/5ElEgwMDp9K5wtZxUN/SQySQ/Nmc4WJXreyWpjyDK
         6psnAr8hlHYVsMR/RwMBpDy1lxtNO6Nqczc9MQqcgGshdL51WNI9jSozZh1/TP98L8qx
         s/ksCioe4R4vNYquT7LUxbUd2Z6MIVaabj29rVqWADxs8GRV8Q81zQfLqF8gJRxY+Dzn
         VYU4wbil/QtVpWPR68vH3a7jjZe1hsd9zvJFNkjoQ38Mt/GqPMxAaungl54NxT3/QaUY
         1Ms5H97JlknsIokx99EnAijvGo1VjVgvVDSDXDve1vCH6i0uMEpJF1OuBvWbdjrWkMTL
         rsgQ==
X-Gm-Message-State: AOAM5303ENpbyJYQOtrnntZ9S84mX5VUnTy0N4aE28ubEKC95rrEIbAk
        RZzBaGmfxesucWW640UpFy1Y0PO4zTQ=
X-Google-Smtp-Source: ABdhPJy8e643ISAyFBH5RUPCSngdIfgWZTCpo3zdfLN5my/+ipF0f0ES2w4lrJTpWg0Hw8qtCTfPBw==
X-Received: by 2002:a17:906:7c5:b0:6e8:7c6f:4f49 with SMTP id m5-20020a17090607c500b006e87c6f4f49mr8580756ejc.378.1649694017774;
        Mon, 11 Apr 2022 09:20:17 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id qf21-20020a1709077f1500b006e84ee40742sm4135048ejc.218.2022.04.11.09.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 09:20:17 -0700 (PDT)
Date:   Mon, 11 Apr 2022 19:20:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: What is the purpose of dev->gflags?
Message-ID: <20220411162016.sau3gertosgr6mtu@skbuf>
References: <20220408183045.wpyx7tqcgcimfudu@skbuf>
 <20220408115054.7471233b@kernel.org>
 <20220408191757.dllq7ztaefdyb4i6@skbuf>
 <797f525b-9b85-9f86-2927-6dfb34e61c31@6wind.com>
 <20220411153334.lpzilb57wddxlzml@skbuf>
 <cb3e862f-ad39-d739-d594-a5634c29cdb3@6wind.com>
 <20220411154911.3mjcprftqt6dpqou@skbuf>
 <41a58ead-9a14-c061-ee12-42050605deff@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41a58ead-9a14-c061-ee12-42050605deff@6wind.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 06:10:49PM +0200, Nicolas Dichtel wrote:
> 
> Le 11/04/2022 à 17:49, Vladimir Oltean a écrit :
> > On Mon, Apr 11, 2022 at 05:43:01PM +0200, Nicolas Dichtel wrote:
> >>
> >> Le 11/04/2022 à 17:33, Vladimir Oltean a écrit :
> >> [snip]
> >>> Would you agree that the __dev_set_allmulti() -> __dev_notify_flags()
> >>> call path is dead code? If it is, is there any problem it should be
> >>> addressing which it isn't, or can we just delete it?
> >> I probably miss your point, why is it dead code?
> > 
> > Because __dev_set_allmulti() doesn't update dev->gflags, it means
> > dev->gflags == old_gflags. In turn, it means dev->gflags ^ old_gflags,
> > passed to "gchanges" of __dev_notify_flags(), is 0.
> I didn't take any assumptions on dev->gflags because two functions are called
> with dev as parameter (dev_change_rx_flags() and dev_set_rx_mode()).

You mean ops->ndo_change_rx_flags() or ops->ndo_set_rx_mode() are
expected to update dev->gflags?

> Even if __dev_notify_flags() is called with 0 for the last arg, it calls
> notifiers. Thus, this is not "dead code".

The relevant "changes" (dev->flags & old_flags) of the net_device which
may have changed from __dev_set_allmulti() are masked out from
call_netdevice_notifiers(), are they not?

	if (changes & IFF_UP) {
		/* doesn't apply */
	}

	if (dev->flags & IFF_UP &&
	    (changes & ~(IFF_UP | IFF_PROMISC | IFF_ALLMULTI | IFF_VOLATILE))) {
	               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	               these changes are masked out
