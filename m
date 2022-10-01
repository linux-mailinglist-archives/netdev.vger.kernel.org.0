Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFDC5F1C05
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 13:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiJALpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 07:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiJALpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 07:45:08 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445F511C3D;
        Sat,  1 Oct 2022 04:45:04 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b2so13862366eja.6;
        Sat, 01 Oct 2022 04:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Mr7X2WnFPUKxw49YLL1+0tXDMwH946yH3S0ttQDPmfQ=;
        b=odTgrjAO/C/Ba+rKFx4oG8ymfKRZ3xdBqsQN8G2NnRG3lAmrOKrC22fIwPgeird/BP
         KkG+D6DmcTiPXyyUIwoUDl+ZwzeocB+hXLWM8NHISWQCfrTbXgf4YXZaHOqLY+dl09+n
         7KTXaV98iYTW/IDi/wLatEDZe3JupQc0SzmQqkKbu8I4/CPWD8/DRb4jVJzOWoaEadRM
         K1wEDxMvR6bIT18uGIMXH2C1Y5kkY9DyFp0qCEeivH3X9FhxJJfVy7/Xy5S+svlxT9cR
         HfSk6awiuN9nHgWtDCL94Z6jrU+UFIfIAPL3kAHSdy2fg+4Fpqnf7uO5Ckp3f+uXeKIr
         xbBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Mr7X2WnFPUKxw49YLL1+0tXDMwH946yH3S0ttQDPmfQ=;
        b=L7CJCzFsf4t9060HvvKAKcf3sSC3awwsReeiJKcOD1qliDox6Xq0Y/n3iqYf6A6c0F
         X5xqIYs5Xsm+P46rB218aux+ZbkfRMGT5RUj1iBSXRLhYWdowPjRmC3ePyrvdPIvCyGi
         Dczyl97ER68+J6Bl3zDNDaJ6uXcxS1EYVLoPU1P1QeejCXb5gWpKcwhB4Jb3MzZTZ77Z
         TPQIXTySK1slgA0TOuyq+VR5RiR65RfnYJ8fi4Bn+EE5HDUXJxDpSrVWbIZ8EK5CaohG
         3W3pIy+Z9W1ZKcFF/6/e62AoXLnkci2r8fj+VCwNMhokpl2vCnvpjYGyR/O0DPltRbKa
         JAiQ==
X-Gm-Message-State: ACrzQf2XueYoySE3cl6ws1DK0XicFFxF0bJ5t/LVrKLTjH9o1ysYr6sK
        GOrelWpnnA74CWP1C11CDPk=
X-Google-Smtp-Source: AMsMyM4LewyPrAYgiZ3F0uulV2j5Jrz6BmalD7P4y+9jUOX2982b4b/uLYG3BQaC7dJfgMDWDNDSQQ==
X-Received: by 2002:a17:907:70b:b0:740:ef93:2ffb with SMTP id xb11-20020a170907070b00b00740ef932ffbmr9219256ejb.93.1664624702600;
        Sat, 01 Oct 2022 04:45:02 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id la11-20020a170907780b00b00741a0c3f4cdsm2581140ejc.189.2022.10.01.04.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 04:45:01 -0700 (PDT)
Date:   Sat, 1 Oct 2022 14:44:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jianghaoran <jianghaoran@kylinos.cn>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH V2] taprio: Set the value of picos_per_byte before fill
 sched_entry
Message-ID: <20221001114458.mjt3qkollggmgdwo@skbuf>
References: <20220928065830.1544954-1-jianghaoran@kylinos.cn>
 <20220928065830.1544954-1-jianghaoran@kylinos.cn>
 <20221001080626.464349-1-jianghaoran@kylinos.cn>
 <20221001080626.464349-1-jianghaoran@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221001080626.464349-1-jianghaoran@kylinos.cn>
 <20221001080626.464349-1-jianghaoran@kylinos.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jianghao,

On Sat, Oct 01, 2022 at 04:06:26PM +0800, jianghaoran wrote:
> If the value of picos_per_byte is set after fill sched_entry,
> as a result, the min_duration calculated by length_to_duration is 0,
> and the validity of the input interval cannot be judged,
> too small intervals couldn't allow any packet to be transmitted.
> It will appear like commit b5b73b26b3ca ("taprio:
> Fix allowing too small intervals") described problem.
> Here is a further modification of this problem.
> 
> example configuration which will not be able to transmit:
> 
> tc qdisc replace dev enp5s0f0 parent root handle 100 taprio \
>               num_tc 3 \
>               map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>               queues 1@0 1@1 2@2 \
>               base-time  1528743495910289987 \
>               sched-entry S 01 9 \
> 	      sched-entry S 02 9 \
> 	      sched-entry S 04 9 \
>               clockid CLOCK_TAI
> 
> Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
> Signed-off-by: jianghaoran <jianghaoran@kylinos.cn>
> ---

I think this is just a symptomatic treatment of a bigger problem with
the solution Vinicius tried to implement.

One can still change the qdisc on an interface whose link is down, and
the determination logic will still be bypassed, thereby allowing the 9
ns schedule intervals to be accepted as valid.

Is your problem that the 9 ns intervals will kill the kernel due to the
frequent hrtimers, or that no packets will be dequeued from the qdisc?

If the latter, I was working on a feature called queueMaxSDU, where one
can limit the MTU per traffic class. Packets exceeding the max MTU are
dropped at the enqueue() level (therefore, before being accepted into
the Qdisc queues). The problem here, really, is that we accept packets
in enqueue() which will never be eligible in dequeue(). We have the
exact same problem with gates which are forever closed (in your own
example, that would be gates 3 and higher).

Currently, I only added support for user space to input queueMaxSDU into
the kernel over netlink, as well as for the basic qdisc_drop() mechanism
based on skb->len. But I was thinking that the kernel should have a
mechanism to automatically reduce the queueMaxSDU to an even lower value
than specified by the user, if the gate intervals don't accept MTU sized
packets. The "operational" queueMaxSDU is determined by the current link
speed and the smallest contiguous interval corresponding to each traffic
class.

In fact, if you search for vsc9959_tas_guard_bands_update(), you'll see
most of the logic already being written, but just for an offloading
device driver. I was thinking I should generalize this logic and push it
into taprio.

If your problem is the former (9ns hrtimers kill the kernel, how do we
avoid them?), then it's pretty hard to make a judgement that works for
all link speeds (taprio will still accept the interval as valid for a
100Gbps interface, because theoretically, the transmission time of
ETH_ZLEN bytes is still below 9 ns. I don't know how one can realistically
deal with that in a generic way.

Given that it's so easy to bypass taprio's restriction by having the
link down, I don't think it makes much sense to keep pretending that it
works, and submit this as a bug fix :)

I was going to move vsc9959_tas_guard_bands_update() into taprio anyway,
although I'm not sure if in this kernel development cycle. If you're
interested, I can keep you on CC.
