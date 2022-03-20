Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184544E1964
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 02:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244627AbiCTByd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 21:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbiCTByc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 21:54:32 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E103F892;
        Sat, 19 Mar 2022 18:53:10 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so4188889pjf.1;
        Sat, 19 Mar 2022 18:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0kdePg8fbLCsR4bHxRYPcJiT3QmeXnSHIseCWuQOMGQ=;
        b=Dsl1Ny7AWCR1AbBZ9wnOmmdIF2tkZHbNYOdX1Ie+rKA/Bj66PCpyWfPS5WYJlsYneY
         8Fh7ty67qjYn4lqlJsdpMgMG1LIqD9goD5vv1MF5B4aJS3c47qyerYMw1LkmhvuXkGVn
         fXA4p6jfXo5mpvgcQPe/fMXTXDFMuxRs2qu7JK8ksK3uQUezkLv14aV7glnqRUkANaaE
         eu96e9F7bq6uJ90o1jrHH75DWxLPNOHhOnlN/M8K2zT15p0gHzJZnhVx/+Vign4Asq8R
         dfy9BYURR8SoZcJUKHDWkqvq9ybe3t0hgzO0c8r7WDB6ZE/ej4sXYpA+1oCaWktrds0Y
         OtOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0kdePg8fbLCsR4bHxRYPcJiT3QmeXnSHIseCWuQOMGQ=;
        b=LZsp6IBBLNocpFrkwl3Llzst2HhheUzWIxjJejBSDSA8BmmFDs1WCF/Qj4Nd23JCJ7
         aTHyyYUfTDw6knbhkCNSIRAKx+khw4rXIuQe4d3DhMFPo6u+HrfF5D0r+4kRyMrNDV1L
         aD8NDC8Nmj+iMTFdkZvYOPeWKGvgnRSssqGMQNrXcddMJcbBLvcwqBJGFQsgjeQdeZPS
         64xH3J4s8wAnW5VLgZZ9k82LzE2A8+tN65e6cOzau7iEn7NWbu7tiViKsuFKDhH06bGR
         xaZNpUCxCSaC8GvUgApFaFZn7X3B1Y/jq2H6+fPcEDnO2UE5Sn/srOLxnUsSEGlI8JP4
         zglQ==
X-Gm-Message-State: AOAM5300ot3/HPTjSea6q2Pz1AVUFq9jfQCKXf5Rqv2cm5DeSSopJG/Y
        wXDz0+//Wr4bq0NVVb2wY4Y=
X-Google-Smtp-Source: ABdhPJwDKvZ2+4zEnJ2D+50OQLagrRDm9AMJl2zg0HXmdjwvAQc9GdWpGAlRfpUaKhv0QKLYaW61GQ==
X-Received: by 2002:a17:902:a415:b0:153:a1b6:729f with SMTP id p21-20020a170902a41500b00153a1b6729fmr6542471plq.52.1647741189915;
        Sat, 19 Mar 2022 18:53:09 -0700 (PDT)
Received: from localhost.localdomain ([183.157.215.81])
        by smtp.googlemail.com with ESMTPSA id oo16-20020a17090b1c9000b001b89e05e2b2sm12859101pjb.34.2022.03.19.18.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 18:53:09 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     jakobkoschel@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, kvalo@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pizza@shaftnet.org, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] cw1200: remove an unneeded NULL check on list iterator
Date:   Sun, 20 Mar 2022 09:53:02 +0800
Message-Id: <20220320015302.6883-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <EFA8A102-59B2-4FC6-AB2E-CA8311E11635@gmail.com>
References: <EFA8A102-59B2-4FC6-AB2E-CA8311E11635@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Mar 2022 01:47:26 +0100, Jakob Koschel
<jakobkoschel@gmail.com> wrote:  
> I don't think this is fixing anything here. You are basically just removing
> a check that was always true.

Yes.

> 
> I'm pretty sure that this check is here to check if either the list is empty or no
> element was found. If I'm not wrong, some time ago, lists where not circular but
> actually pointed to NULL (or the head was NULL) so this check made sense but doesn't
> anymore.
> 
> The appropriate fix would be only setting 'item' when a break is hit and keep
> the original check.

You are right if that is the author's original intention. I will fix it in PATCH v2.

> 
> > 			unsigned long tmo = item->queue_timestamp + queue->ttl;
> > 			mod_timer(&queue->gc, tmo);
> > 			cw1200_pm_stay_awake(&stats->priv->pm_state,
> > -- 
> > 2.17.1
> > 
> > 
> 
> I've made those changes already and I'm in the process of upstreaming them in an organized
> way, so maybe it would make sense to synchronize, so we don't post duplicate patches.

Ok, I will cc you when sending related patches to avoid duplication.
I hope you can do the same, thank you.

Here are the 9 patches I have sent, so you don't have to reinvent th wheel:
https://lore.kernel.org/all/20220319102222.3079-1-xiam0nd.tong@gmail.com/
https://lore.kernel.org/all/20220319073143.30184-1-xiam0nd.tong@gmail.com/
https://lore.kernel.org/all/20220319063800.28791-1-xiam0nd.tong@gmail.com/
https://lore.kernel.org/all/20220319053742.27443-1-xiam0nd.tong@gmail.com/
https://lore.kernel.org/all/20220319052350.26535-1-xiam0nd.tong@gmail.com/
https://lore.kernel.org/all/20220319044416.24242-1-xiam0nd.tong@gmail.com/
https://lore.kernel.org/all/20220319043606.23292-1-xiam0nd.tong@gmail.com/
https://lore.kernel.org/all/20220319042657.21835-1-xiam0nd.tong@gmail.com/
https://lore.kernel.org/all/20220316075153.3708-1-xiam0nd.tong@gmail.com/

--
Xiaomeng Tong
