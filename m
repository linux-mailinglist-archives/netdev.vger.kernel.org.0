Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54B959204E
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 17:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiHNPAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 11:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiHNPAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 11:00:10 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C211186C6
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 08:00:08 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gj1so5049884pjb.0
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 08:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc;
        bh=XQA6Qdev95W6e7bt6VMzbTx1WxefPEEfvHpSRK7VfRU=;
        b=ZFVN71Pn2WFQUIwHKtYob+jH0er3E+VAwpLEvmr7uhF3vyOsl7Ucf04Uh0gh1rYWQ/
         lQ3dmMPe/hjsJQXLISDo87lQ/P3aML9JEpuu2L/9hE6cWkRnjyCzcDYmGR4g6S1zDxoo
         kqNaZ95fPa21hrOgyiFCtUwh1u8CS1oFoQwyqcNodDxn2HzABz08mYq6ZtckDshqXn2u
         5TMU7/kmzHX1zxDo0qndsRVsdsBkyssMNE+qom/Erv7q/ASdSGuBfnHw61RGxQqkalun
         qAM8u4GIM5P+mY6y75eqQGrJ8h1zG5gF/D+/sqGTDlkOSAnuz6HKXCjUBjZumhwXqW8e
         CKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=XQA6Qdev95W6e7bt6VMzbTx1WxefPEEfvHpSRK7VfRU=;
        b=UoxOxbreA91hhy3aGTKcFhRRlACCb4njJXFQQf3tu6VrcBzBX0kXmvJ/eKgwICpmHl
         Om+oU+/tsWq+5CGFQCCrRR4Boj7mzvL0S9yfYNCRm0CeME/q7c3QUpvbbpb/PN8C85cF
         pOHNPyjXr3XRm/5duipZGZ5nZcWcHohyTRf9ubJoVvKdZhPZcF3g6K8YH30sbj/95TFo
         FlvOb2u4HzyijFCQOUS9wuF6muBjUAYKL0Qcmhx0XG5l4dQkRvC6DWD9PoXgcOq73Dgv
         DbyvPySu6ATxfhgnB83bqV53kyzPcWBeyCCrUXcu5FAJ/umJJJSh0rlxFLdZYJo/hGyI
         XRTw==
X-Gm-Message-State: ACgBeo1m+hAPIm7F5/kjyyYqbofeZgCuiAu/RF/GoV2DHXLbcWSO3+bh
        3e41QOHQUxeHoK05U9LLx+TXJw==
X-Google-Smtp-Source: AA6agR4wJBxteVZaBJVv19VFtx1WEtLyW9r7iqsY+z3nFZPqp0b1C3Ur/lmnYM6fZCv291sj0DFePQ==
X-Received: by 2002:a17:90b:4a06:b0:1f4:e4fc:91ed with SMTP id kk6-20020a17090b4a0600b001f4e4fc91edmr14329750pjb.152.1660489207387;
        Sun, 14 Aug 2022 08:00:07 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id p4-20020a1709026b8400b001712c008f99sm5485284plk.11.2022.08.14.08.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 08:00:07 -0700 (PDT)
Date:   Sun, 14 Aug 2022 08:00:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuznet@ms2.inr.ac.ru,
        cascardo@canonical.com, linux-distros@vs.openwall.org,
        security@kernel.org, dsahern@gmail.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH net 1/1] net_sched: cls_route: disallow handle of 0
Message-ID: <20220814080005.2c071546@hermes.local>
In-Reply-To: <20220814112758.3088655-1-jhs@mojatatu.com>
References: <20220814112758.3088655-1-jhs@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 14 Aug 2022 11:27:58 +0000
Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> Follows up on:
> https://lore.kernel.org/all/20220809170518.164662-1-cascardo@canonical.com/
> 
> handle of 0 implies from/to of universe realm which is not very
> sensible.
> 
> Lets see what this patch will do:
> $sudo tc qdisc add dev $DEV root handle 1:0 prio
> 
> //lets manufacture a way to insert handle of 0
> $sudo tc filter add dev $DEV parent 1:0 protocol ip prio 100 \
> route to 0 from 0 classid 1:10 action ok
> 
> //gets rejected...
> Error: handle of 0 is not valid.
> We have an error talking to the kernel, -1
> 
> //lets create a legit entry..
> sudo tc filter add dev $DEV parent 1:0 protocol ip prio 100 route from 10 \
> classid 1:10 action ok
> 
> //what did the kernel insert?
> $sudo tc filter ls dev $DEV parent 1:0
> filter protocol ip pref 100 route chain 0
> filter protocol ip pref 100 route chain 0 fh 0x000a8000 flowid 1:10 from 10
> 	action order 1: gact action pass
> 	 random type none pass val 0
> 	 index 1 ref 1 bind 1
> 
> //Lets try to replace that legit entry with a handle of 0
> $ sudo tc filter replace dev $DEV parent 1:0 protocol ip prio 100 \
> handle 0x000a8000 route to 0 from 0 classid 1:10 action drop
> 
> Error: Replacing with handle of 0 is invalid.
> We have an error talking to the kernel, -1
> 
> And last, lets run Cascardo's POC:
> $ ./poc
> 0
> 0
> -22
> -22
> -22
> 
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
