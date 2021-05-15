Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CB4381478
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 02:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbhEOATE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 20:19:04 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40166 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhEOATD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 20:19:03 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621037870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3//YKyDTOzQQ/JmkKrDGfiJu7W4VA7pems6JpHer+D8=;
        b=l/g5/pifVgUzbTwPa6IkOmPPnauzAg9Xz06mqVvIiOF+lpTTrbumL3Ch7O4RGfZ09o7s9Y
        4+olkpDbWEy0FyyycBcMJ9m6ji4ndlj3r7wtLg/YI21NKgtT/2tWlHZ/ccK9QihFgQyFN2
        jL9Vm6IC33aa4TXh5zAWzjOT7SfwxMvbuZeqGRnsjSIbiUl+mnkIu1JEZU9NZKqrJRJBoA
        Of+X7m/bhg3ev0tEiHL4ZpfFnruovJr40GEkqHCMWbabeUjG8878N4JuGvANKzpBZSK3Rq
        ztO5etD9ly3v5zZqkWHeLilhm2RDrHud+4L7q2MPWI/LRrTJHVg0ZSt7l0BIUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621037870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3//YKyDTOzQQ/JmkKrDGfiJu7W4VA7pems6JpHer+D8=;
        b=8IQySqrlHXaTcLlyx0CxiXZWzMkUiZ5RRe4ON1QzZW73f44g0GgYLMwXMzYK9WqmMEUufD
        ktnZwBC+tagOxcAg==
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        simon.horman@netronome.com, oss-drivers@netronome.com,
        bigeasy@linutronix.de, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 1/2] net: add a napi variant for RT-well-behaved drivers
In-Reply-To: <20210514222402.295157-1-kuba@kernel.org>
References: <20210514222402.295157-1-kuba@kernel.org>
Date:   Sat, 15 May 2021 02:17:50 +0200
Message-ID: <87y2cg26kx.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14 2021 at 15:24, Jakub Kicinski wrote:
>  
> +void __napi_schedule_irq(struct napi_struct *n)
> +{
> +	____napi_schedule(this_cpu_ptr(&softnet_data), n);

Not that I have any clue, but why does this not need the
napi_schedule_prep() check?

Thanks,

        tglx
