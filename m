Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2705D5B9F1E
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiIOPoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiIOPoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:44:06 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB1483BFD;
        Thu, 15 Sep 2022 08:44:05 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id s10so22056958ljp.5;
        Thu, 15 Sep 2022 08:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=MTL0p90qhzvaa9Qy56q//m1syQEZ7USkfPoHOhnC+Jk=;
        b=i4LRwgaaHJksuuObJshFcKX+A8JNBcL+Ao+YGHOdxMOCYShEucRokxxF6gOHrXTJHa
         YR++plI15/TCx9YyE0mL8MbPscbkG/3bNcqcD/mxXVj529K9j/K9KTWdux7g41+xi+9z
         iUyusKCJEGpkr+pq8hcndXL9cm2FKfIlZ56kRietnjgf6/RHtWfr2yX4SKFtejcaDBYE
         7GWawXejycAX8ArJ6fTbFNJVMFJfgc1tNZZcK6haqy2n3KE/aeC6bZWaGoVZ+snXWL0d
         Ei8vmUclBUcceGA+2uKXNCDSP1QlaN3mX9FfXne5aS2EGTkpfntCGVADIHE5MSVMf2En
         xCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=MTL0p90qhzvaa9Qy56q//m1syQEZ7USkfPoHOhnC+Jk=;
        b=nUtEUWcbRtQ4+7cD/oE5nndkYOG+JJ8SYOXQP4QLtAZ9id3/jYqx4qHKDJ22Kcn3b5
         uTxS9gZK1b2rZ28WnDAmDAEwEf5eCfbrvwjTyXZEjSuCeeSx7yg+eaTP2IJDCZZjdeRY
         vbIcv8NPjtF0XDodp3sWJ3Cdd7tYUB1P6GvZSfcIFmRoJ5dyl/R/eDHmwQw9cujkvl0M
         1uTBScVVdBAi3XKWBRgqUTulsBj2lRU7wXwZinLK9W9WsbC/Wz/HqPaq946K7RxWskiu
         inUC1kXx/9+2RrcLCk3Yb1WBZxmLjgGCq/2pPRIEUJlioJEWKbh+Z/4sWiee/9p85tfD
         0kBQ==
X-Gm-Message-State: ACrzQf22t8MH8D2c+gZ8uGYYX9meRE61OJizk4Qh2inqaJr/PHba00oa
        EIlXlnmPMyPuaOX8XhgQZx8=
X-Google-Smtp-Source: AMsMyM4mMip9R4TrOPWPmHEJYLs0UBjYnWs4kk4CsebSxVXPFnhwWHIwh1bmvU/AflVI3wAdUerAFg==
X-Received: by 2002:a05:651c:1611:b0:261:e11c:c2ef with SMTP id f17-20020a05651c161100b00261e11cc2efmr108775ljq.340.1663256643779;
        Thu, 15 Sep 2022 08:44:03 -0700 (PDT)
Received: from home.paul.comp (paulfertser.info. [2001:470:26:54b:226:9eff:fe70:80c2])
        by smtp.gmail.com with ESMTPSA id o20-20020ac24bd4000000b0049c29292250sm1748961lfq.149.2022.09.15.08.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 08:44:03 -0700 (PDT)
Received: from home.paul.comp (home.paul.comp [IPv6:0:0:0:0:0:0:0:1])
        by home.paul.comp (8.15.2/8.15.2/Debian-22) with ESMTP id 28FFi0gJ021928;
        Thu, 15 Sep 2022 18:44:01 +0300
Received: (from paul@localhost)
        by home.paul.comp (8.15.2/8.15.2/Submit) id 28FFhwaf021927;
        Thu, 15 Sep 2022 18:43:58 +0300
Date:   Thu, 15 Sep 2022 18:43:58 +0300
From:   Paul Fertser <fercerpav@gmail.com>
To:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ncsi: Add Intel OS2BMC OEM command
Message-ID: <YyNIPjNX9MCI3zkK@home.paul.comp>
References: <20220909025716.2610386-1-jiaqing.zhao@linux.intel.com>
 <YxrWPfErV7tKRjyQ@home.paul.comp>
 <8eabb29b-7302-d0a2-5949-d7aa6bc59809@linux.intel.com>
 <Yxrun9LRcFv2QntR@home.paul.comp>
 <36c12486-57d4-c11d-474f-f26a7de8e59a@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36c12486-57d4-c11d-474f-f26a7de8e59a@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Sep 13, 2022 at 10:12:06AM +0800, Jiaqing Zhao wrote:
> On 2022-09-09 15:43, Paul Fertser wrote:
> > On Fri, Sep 09, 2022 at 03:34:53PM +0800, Jiaqing Zhao wrote:
> >>> Can you please outline some particular use cases for this feature?
> >>>
> >> It enables access between host and BMC when BMC shares the network connection
> >> with host using NCSI, like accessing BMC via HTTP or SSH from host. 
> > 
> > Why having a compile time kernel option here more appropriate than
> > just running something like "/usr/bin/ncsi-netlink --package 0
> > --channel 0 --index 3 --oem-payload 00000157200001" (this example uses
> > another OEM command) on BMC userspace startup?
> > 
> 
> Using ncsi-netlink is one way, but the package and channel id is undetermined
> as it is selected at runtime. Calling the netlink command on a nonexistent
> package/channel may lead to kernel panic.

That sounds like a bug all right. If you can reproduce, it's likely
the fix is reasonably easy, please consider doing it.

> Why I prefer the kernel option is that it applies the config to all ncsi
> devices by default when setting up them. This reduces the effort and keeps
> compatibility. Lots of things in current ncsi kernel driver can be done via
> commands from userspace, but I think it is not a good idea to have a driver
> resides on both kernel and userspace.

How should the developer decide whether to enable this compile-time
option for a platform or not? If it's always nice to have why not
add the code unconditionally? And if not, are you sure kernel compile
time is the right decision point? So far I get an impression a sysfs
runtime knob would be more useful.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
