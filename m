Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF0045B0AF
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfF3Qld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:41:33 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36215 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfF3Qlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 12:41:32 -0400
Received: by mail-lf1-f65.google.com with SMTP id q26so7138797lfc.3
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 09:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jPVGx15Z50Lc5RRq2NY8cWjOaQWp2BwPoZbsTBiBqRw=;
        b=Iei0c2wEhCtx9e3jgrOdFdEcLu0nZ/WyLrssxqdPjtc7XoOd2vW/itZdwG8WX7dwrJ
         1vmN5SFOBBneAYnez4UNCOHUuMdZtnqttva0lFJ+QeTBmLjvP7N+mk9POmyj3rHx9oxz
         /4obBRhQ/Z+8OegeTTSZvfMgCUBRClArrkj1SmwWe02+Z7/y/NAzKFZYCxu3LpD2iHaw
         j4ytorlTm8+AkRUKKmaSGuBfdCDw8Q9dyQbnREiSSC7Wl4n2vl8R36P8yEG/XB+vDIPG
         1dcsire/PkxkkJE3UG+7vjafG/7Kyv40n8dSx2AzigwiSNL3bQcBTicRU1jP+OSIVeLU
         zSRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jPVGx15Z50Lc5RRq2NY8cWjOaQWp2BwPoZbsTBiBqRw=;
        b=g2R9QawuvT0PAtwASSTzyC2Cm0yHtsdKGIWfpfb9kjQAuYKc63OGlq6oMQxSF+ONWE
         OW5q/wZ3qQ0NQPNVnLSt69o68bpo4s68Fbq6HQa8BCY7QHbpnqT6eRwWhtAo0aN2b0WL
         XQ451Mzh9I9dKUUtreV1rJBj8hc4AA+AqZo/EVk4W14O0r05w2nbt5TtKhy6KTW7KL8A
         XWMHSmHHO0vv45X55PPQ8c474aQAjwcs8ywa1uGQDjd8pZVfeGBYxJNlmFmks+VsflwJ
         xAgus5eWEXsUw6+sO+7gCrXpwdZHrAINIc+ZHoHjtUsLzVlpZI22rGRUST9fhbvHFvqe
         U7Ig==
X-Gm-Message-State: APjAAAUDajosZAlMWgzmN7AFqc7RegQjO0RuPHO0GmlunCPTlrvpcVwC
        6PrbVrt6g4hFWJn3/KlF0WZxjA==
X-Google-Smtp-Source: APXvYqy3MYEwCcweREaAH05+SQ/+lYeDo6DNDeJCZPcKmfjnrHfPjvXXOZ0VLSbXN5j9FCFau9lPYA==
X-Received: by 2002:ac2:419a:: with SMTP id z26mr6087253lfh.21.1561912890968;
        Sun, 30 Jun 2019 09:41:30 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id v21sm2724475lje.10.2019.06.30.09.41.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 30 Jun 2019 09:41:30 -0700 (PDT)
Date:   Sun, 30 Jun 2019 19:41:28 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com
Subject: Re: [net-next, PATCH 3/3, v2] net: netsec: add XDP support
Message-ID: <20190630164127.GC12704@khorivan>
References: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561785805-21647-4-git-send-email-ilias.apalodimas@linaro.org>
 <20190630162552.GB12704@khorivan>
 <20190630163214.GA10484@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190630163214.GA10484@apalos>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 07:32:14PM +0300, Ilias Apalodimas wrote:
>On Sun, Jun 30, 2019 at 07:25:53PM +0300, Ivan Khoronzhuk wrote:
>> On Sat, Jun 29, 2019 at 08:23:25AM +0300, Ilias Apalodimas wrote:
>> >The interface only supports 1 Tx queue so locking is introduced on
>> >the Tx queue if XDP is enabled to make sure .ndo_start_xmit and
>> >.ndo_xdp_xmit won't corrupt Tx ring
>> >
>> >- Performance (SMMU off)
>> >
>> >Benchmark   XDP_SKB     XDP_DRV
>> >xdp1        291kpps     344kpps
>> >rxdrop      282kpps     342kpps
>> >
>> >- Performance (SMMU on)
>> >Benchmark   XDP_SKB     XDP_DRV
>> >xdp1        167kpps     324kpps
>> >rxdrop      164kpps     323kpps
>> >
>> >Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>> >---
>> >drivers/net/ethernet/socionext/netsec.c | 361 ++++++++++++++++++++++--
>> >1 file changed, 334 insertions(+), 27 deletions(-)
>> >
>>
>> [...]
>>
>> >+
>> >+static int netsec_xdp_setup(struct netsec_priv *priv, struct bpf_prog *prog,
>> >+			    struct netlink_ext_ack *extack)
>> >+{
>> >+	struct net_device *dev = priv->ndev;
>> >+	struct bpf_prog *old_prog;
>> >+
>> >+	/* For now just support only the usual MTU sized frames */
>> >+	if (prog && dev->mtu > 1500) {
>> >+		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
>> >+		return -EOPNOTSUPP;
>> >+	}
>> >+
>> >+	if (netif_running(dev))
>> >+		netsec_netdev_stop(dev);
>> And why to stop the interface. XDP allows to update prog in runtime.
>>
>Adding the support is not limited to  adding a prog only in this driver.
>It also rebuilts the queues which changes the dma mapping of buffers.
>Since i don't want to map BIDIRECTIONAL buffers if XDP is not in place,
>i am resetting the device and forcing the buffer re-allocation
>
>Thanks
>/Ilias
I don't know the internals, probably it has some dependencies, but here you
just update the prog and can at least do it when exchange is happening.
I mean not in case of prog is attached/removed first time.
In case of prog -> prog it seems doable...

It ups to you ofc, but I can run smth like:
ip -force link set dev eth0 xdp obj xdp-example-pass.o sec .text
and expect it's updated w/o interface reset I mean on new prog.

I'm not sure, but maintainers can help, conceptually it's supposed to be in
runtime the prog be update uder rcu as a part of API usage...


-- 
Regards,
Ivan Khoronzhuk
