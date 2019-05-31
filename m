Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A8A31762
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 01:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfEaXAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 19:00:16 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38887 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfEaXAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 19:00:16 -0400
Received: by mail-lj1-f194.google.com with SMTP id o13so11083792lji.5
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 16:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R6AakFEfT07RKGQjtU57G+Mi06fjxrW46LtUHEWscX4=;
        b=UdqZ6v0xW/ZPZI7rfZNyoQWpFuu/Dvj8IN2xtnDAPTX97Ifm9GE29ZZGLxyqa/iYZ4
         rcW2doIiMnJjEYD8YHPZeBmeYw+/pF+7ufxy43Ajo6/T1K3jr+2pVZMH3vAfYHucEpi5
         8KaToYGMYAnolAxiqpavrhqxAujTLEgOy5wYLdGxZU6GLfatAVHJQ2Tg01q8q0X6qGNd
         cvMdOyIrYD4kp5dHSVPpHRvmnPayZKvtxCSI1aZfKMsjl1X/eLrDLMuyr0pSD8N/+0W1
         /DJb6GKmvK2DjPvRgAoWeRBJylaxDlUW6HBWawCb3DzMx8wad8MxyX9f6zHog+XwZFvd
         oQtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=R6AakFEfT07RKGQjtU57G+Mi06fjxrW46LtUHEWscX4=;
        b=D58V1TnM9IdF/4Lemf+f+MtnMghmTsEDGVC1qWyY0l3N9bozqzWy6gYe+LO8xYoUML
         Gwi2SyOlH1WG/vTYTiW5VOsfVEGwDCdxj2/mCnoOgWl1Xk9Wx9r0xEuhgrzA1Yi5F1MG
         fVEFlUOzQ/MkTXUl2//rgPanakgSz9SrKQzXellLVgotlUXu+BTA2b1JbOCDQ0nBN7Fc
         vmdkhcSnoCXQTRxVBwc0zfmyutTRENRbuIuMPTKAYQAHHbiOgBIU3KAjAsoPkE7etJDq
         tM52Nngv0YeoWv8ujM1Tm6WePHQJdJG1Xzha5JRee+qK/TniSln92pX++NBhh7S0RD4Y
         SgTQ==
X-Gm-Message-State: APjAAAVtAF7ivuhbeLMYjQanE12srV8uN4MCfijVqT5fuv35DjxcdKMn
        uWT0QAKBeYATDrpqpacstmVB8w==
X-Google-Smtp-Source: APXvYqwADy+ePnz+6LSmTnDgiozSJUl6IJ2AdwyOS/QcPm0Gp1mY0/Eivedv8uAM3H8DjK98nJn7WQ==
X-Received: by 2002:a2e:2b8d:: with SMTP id r13mr7429874ljr.162.1559343613223;
        Fri, 31 May 2019 16:00:13 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id r14sm1468168lff.44.2019.05.31.16.00.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 16:00:12 -0700 (PDT)
Date:   Sat, 1 Jun 2019 02:00:10 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "brouer@redhat.com" <brouer@redhat.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH v2 net-next 7/7] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190531230008.GA15675@khorivan>
Mail-Followup-To: Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
 <20190530182039.4945-8-ivan.khoronzhuk@linaro.org>
 <20190531174643.4be8b27f@carbon>
 <20190531162523.GA3694@khorivan>
 <20190531183241.255293bc@carbon>
 <20190531170332.GB3694@khorivan>
 <a65de3a257ab5ebec83e817c092f074b58b9ae47.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a65de3a257ab5ebec83e817c092f074b58b9ae47.camel@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 10:08:03PM +0000, Saeed Mahameed wrote:
>On Fri, 2019-05-31 at 20:03 +0300, Ivan Khoronzhuk wrote:
>> On Fri, May 31, 2019 at 06:32:41PM +0200, Jesper Dangaard Brouer
>> wrote:
>> > On Fri, 31 May 2019 19:25:24 +0300 Ivan Khoronzhuk <
>> > ivan.khoronzhuk@linaro.org> wrote:
>> >
>> > > On Fri, May 31, 2019 at 05:46:43PM +0200, Jesper Dangaard Brouer
>> > > wrote:
>> > > > From below code snippets, it looks like you only allocated 1
>> > > > page_pool
>> > > > and sharing it with several RX-queues, as I don't have the full
>> > > > context
>> > > > and don't know this driver, I might be wrong?
>> > > >
>> > > > To be clear, a page_pool object is needed per RX-queue, as it
>> > > > is
>> > > > accessing a small RX page cache (which protected by
>> > > > NAPI/softirq).
>> > >
>> > > There is one RX interrupt and one RX NAPI for all rx channels.
>> >
>> > So, what are you saying?
>> >
>> > You _are_ sharing the page_pool between several RX-channels, but it
>> > is
>> > safe because this hardware only have one RX interrupt + NAPI
>> > instance??
>>
>> I can miss smth but in case of cpsw technically it means:
>> 1) RX interrupts are disabled while NAPI is scheduled,
>>    not for particular CPU or channel, but at all, for whole cpsw
>> module.
>> 2) RX channels are handled one by one by priority.
>
>Hi Ivan, I got a silly question..
>
>What is the reason behind having multiple RX rings and one CPU/NAPI
>handling all of them ? priority ? how do you priorities ?
Several.
One of the reason, from what I know, it can handle for several cpus/napi but
because of errata on some SoCs or for all of them it was discarded, but idea was
it can. Second it uses same davinci_cpdma API as tx channels that can be rate
limited, and it's used not only by cpsw but also by other driver, so can't be
modified easily and no reason. And third one, h/w has ability to steer some
filtered traffic to rx queues and can be potentially configured with ethtool
ntuples or so, but it's not implemented....yet.

>
>> 3) After all of them handled and no more in budget - interrupts are
>> enabled.
>> 4) If page is returned to the pool, and it's within NAPI, no races as
>> it's
>>    returned protected by softirq. If it's returned not in softirq
>> it's protected
>>    by producer lock of the ring.
>>
>> Probably it's not good example for others how it should be used, not
>> a big
>> problem to move it to separate pools.., even don't remember why I
>> decided to
>> use shared pool, there was some more reasons... need search in
>> history.
>>
>> > --
>> > Best regards,
>> >  Jesper Dangaard Brouer
>> >  MSc.CS, Principal Kernel Engineer at Red Hat
>> >  LinkedIn: http://www.linkedin.com/in/brouer

-- 
Regards,
Ivan Khoronzhuk
