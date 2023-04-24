Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87936ED765
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 00:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbjDXWEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 18:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjDXWEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 18:04:09 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE1A1B9;
        Mon, 24 Apr 2023 15:04:08 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63f167e4be1so1121817b3a.1;
        Mon, 24 Apr 2023 15:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682373847; x=1684965847;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F7BMzd9IGTXbAkWoDgqMr1C1t+RDvyDeCnFQaVFy2Ic=;
        b=jE7BTGeekyPv5R4gNSfcoGJYsOZ+dScFrqIhkNA1U7N8o1rHAG4jEuUevD27WycQ4a
         JXgHKYxSYZO28Th4cVqL3g6RLS0d004ffykbTpbo06eYrWlvphtSGvcp8ESaBizWWntn
         fGpZjhLEEMW+fmowANPjDP5L2W9iDbd2UPnmIZ1k+4zALIy/DvcDA0wNniuxIpgHPd64
         YvKyaOa5/fUV+aSBxmC+IZPfbtozML0gAJ1OaMKcaU+o07UV/gRWCqESxnmu4ZW1mHq7
         MyLSlVUQUy64qgWPQKAvNKxgaM14GrkWgNjPF7hPky5DyEN+c2UHjfE4UEukTga1X0Jr
         7iuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682373847; x=1684965847;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F7BMzd9IGTXbAkWoDgqMr1C1t+RDvyDeCnFQaVFy2Ic=;
        b=N0iC/SvX9awz2BM1kFN3FLrLU4EZjqGSFKfqu2KdzOH1c2YXRY0T7J8rarVk5C7QJl
         HSsXkSUs4IXVhZIVV90vNCzanAk4URK8o/mu6CgPgI06Lkjc5uBMi2yNCkJtdfJ41bg6
         3x5xnHLt3hvvf5VtNwa5ccYxS0qq5HqotVy75/nAPJOtNH9zwaqf5lQvJ/coMA+losxa
         G/JDg/jAbfXrtWCU8kvzPQPnxbREw4Z6ZFrqzOXvqU4bhnft97/qnE8BZ8ZXC0LEHpsN
         RXcqfloVGG/F/Y654Z68FkJUMtY43Pa8r6zpmwiBLYxdNg2EltsQSL5RoRgLDEL3XgKf
         ap1w==
X-Gm-Message-State: AAQBX9cuh5on+GEXB2jXLN2irSJ1ss76I9Xtt/ck1ii7nBrFAOT6oXp3
        n9lCLms62jkVOC8Yti2JMti4gGaG08c=
X-Google-Smtp-Source: AKy350agqemkF0lxJRRKAYXow70Y8BGpPgVhAvsUd/v4KcBZ5t6x7tham8zgVLVQE1TpUAphrEr8UQ==
X-Received: by 2002:a05:6a20:394f:b0:f1:1ab5:5076 with SMTP id r15-20020a056a20394f00b000f11ab55076mr352775pzg.2.1682373847531;
        Mon, 24 Apr 2023 15:04:07 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id g7-20020aa78747000000b0063f15cc9c38sm6581463pfo.99.2023.04.24.15.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 15:04:06 -0700 (PDT)
Date:   Mon, 24 Apr 2023 15:04:05 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Stern, Avraham" <avraham.stern@intel.com>
Cc:     "Greenman, Gregory" <gregory.greenman@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: pull-request: wireless-next-2023-03-30
Message-ID: <ZEb81aNUlmpKsJ6C@hoboy.vegasvil.org>
References: <20230330205612.921134-1-johannes@sipsolutions.net>
 <20230331000648.543f2a54@kernel.org>
 <ZCtXGpqnCUL58Xzu@localhost>
 <ZDd4Hg6bEv22Pxi9@hoboy.vegasvil.org>
 <ccc046c7e7db68915447c05726dd90654a7a8ffc.camel@intel.com>
 <ZEC08ivL3ngWFQBH@hoboy.vegasvil.org>
 <SN7PR11MB6996329FFC32ECCBE4509531FF669@SN7PR11MB6996.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN7PR11MB6996329FFC32ECCBE4509531FF669@SN7PR11MB6996.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 01:33:19PM +0000, Stern, Avraham wrote:
> hi Richard,
> 
> I will try to clarify.
> 
> 
> > > Then, the timestamps are added to the rx/tx status
> >> via mac80211 api.
> 
> > Where?  I don't see that in the kernel anywhere.
> 
> > Your WiFi driver would need to implement get_ts_info, no?
> 
> so, the rx/tx timestamp is put in the skb hwstamps field, and the ack (tx/rx) timestamp is put in the mac80211 rx/tx status.
> if you follow mac80211/cfg80211 patches sent earlier, you'll see that mac80211 uses these to fill cfg80211_rx_info and cfg80211_tx_status with
> the timestamps.

Um, no, I haven't seen those.

> eventually, these are sent to userspace in nl80211_send_mgmt() and nl80211_frame_tx_status() as part of the frame's meta data.
> 
> since wifi uses management frames for time sync, the timestamping capability is also advertised using nl80211 capability (NL80211_ATTR_MAX_HW_TIMESTAMP_PEERS).
> implementing get_ts_info() doesn't seem right since it's usually queried over a data socket, and the wifi driver doesn't timestamp data frames (since these are not used
> for time sync over wifi).

Okay, so you are creatively making some kind of back door for wifi.  Whatever.

> >> Actually, we already have a functional implementation of ptp4l
> >> over wifi using this driver support.
> 
> > Why are changes needed to user space at all?
> 
> As you mentioned, time sync over wifi leverages the existing FTM protocol, which is different from the protocols used over ethernet.
> In particular, FTM uses management frames unlike the ethernet protocols that use data frames.
> So obviously for ptp4l to support time sync over wifi, it will need to implement the FTM protocol (sending FTM frames via nl80211 socket) and use the kernel APIs added here

ptp4l isn't doing to implement anything without my ok.

Thanks,
Richard
