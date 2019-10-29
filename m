Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D01E828A
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 08:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfJ2HdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 03:33:05 -0400
Received: from mail.jv-coder.de ([5.9.79.73]:57316 "EHLO mail.jv-coder.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfJ2HdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 03:33:04 -0400
Received: from [10.61.40.7] (unknown [37.156.92.209])
        by mail.jv-coder.de (Postfix) with ESMTPSA id 8456D9F655;
        Tue, 29 Oct 2019 07:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jv-coder.de; s=dkim;
        t=1572334381; bh=m2LAJqvz5BHhT0hEXJpcsiP/gHskrUk9SC7/ECwsvhE=;
        h=Subject:To:From:Message-ID:Date:MIME-Version;
        b=J1VKZqoBtr+17CR4/Lkmq8HUDVR+ov75UtOmaUZxGm/50kl12zerVuWFr2Mq43l+3
         OZsmsXOTDyGHeMo+JekEgdvbN4zFwUDnI8s3T8yK9MGHzFXj+WlHhd1bjq+mCP0mtG
         p6eSgAmJAhG2hvSrvkjNuHlKu2taFx4kcNYHZ3zE=
Subject: Re: [PATCH v2 1/1] xfrm : lock input tasklet skb queue
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Tom Rix <trix@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CACVy4SUkfn4642Vne=c1yuWhne=2cutPZQ5XeXz_QBz1g67CrA@mail.gmail.com>
 <20191024103134.GD13225@gauss3.secunet.de>
 <ad094bfc-ebb3-012b-275b-05fb5a8f86e5@jv-coder.de>
 <20191025094758.pchz4wupvo3qs6hy@linutronix.de>
 <202da67b-95c7-3355-1abc-f67a40a554e9@jv-coder.de>
 <20191025102203.zmkqvvg5tofaqfw6@linutronix.de>
 <5b45c8f6-1aa2-2e1e-9019-a140988bba80@jv-coder.de>
 <20191028151447.xwtyh6hfwfvzwmmu@linutronix.de>
From:   Joerg Vehlow <lkml@jv-coder.de>
Message-ID: <5575bb95-b89a-727d-0587-9c462f1fddef@jv-coder.de>
Date:   Tue, 29 Oct 2019 08:33:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191028151447.xwtyh6hfwfvzwmmu@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,HELO_MISC_IP,RDNS_NONE autolearn=no
        autolearn_force=no version=3.4.2
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.jv-coder.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 2019-10-28 11:44:57 [+0100], Joerg Vehlow wrote:
>> I was unable to reproduce it with 5.2.21-rt13. Do you know if something
>> changed in network scheduling code or could it be just less likely?
> the softirq/BH handling has been rewritten in the v5.0-RT cycle,
> v5.0.19-rt11 to be exact. So if that the cause for it (which I hope)
> then you should be able to trigger the problem before that release and
> not later.
>
I testes again with 5.0.19-rt10 and 5.0.19-rt11  and I am pretty sure
the bug wasfixed by the changes in rt11. I was able to reproduce it with
rt10 within secondsand unable to reproduce it at all in several minutes on
rt11. Will 4.19 rt patches receive anymore updates? Is it possible to 
backport
the changes to softirq/BH habdling from 5.0.16-rt11 to 4.19?
