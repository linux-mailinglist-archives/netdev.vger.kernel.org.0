Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF6355B0C3
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfF3QvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:51:25 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34918 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfF3QvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 12:51:25 -0400
Received: by mail-lj1-f193.google.com with SMTP id x25so10628877ljh.2
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 09:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O/MGbrE0ui3UYq/4WK+wu51diRhJVV0ae++5treckzg=;
        b=dJ3DB7Om8/+PiViwe7GGouID6CRTz0WmIYw/DtDzYDLMu80NoOxANZx1JLCj5LSIKZ
         /lhr32lAMiH/OQhQxyr7Dl4Soh1q5uOnSgxoaY8sLNlUNefZRNWEE1pKlmBLW+EMS2dH
         H0iH+Bb6jJ5na2MSgblOxrS6O8TL2N9yiKHY2ir7Kic5pJ59vCoiLC0WoFuX34Q7qS3J
         LMT6ksH/77ix7UrVVtdagSOkz3KFaICWGkNj5qtP82O+4/XNYndZdak8XGkHt6hpbEbN
         sNMe+JNuqO+vPlHAiKkwaUfUqLD9Wse5OtAyNXgLUagFs1hyfHz8hXeeAXaU5RlsBZQ/
         4rAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=O/MGbrE0ui3UYq/4WK+wu51diRhJVV0ae++5treckzg=;
        b=ZyN1rswdTSQ0rQYBB2jWvxuNM4N+ZCgh3YkQHCq9QoApLhO9NzXLRyQL5KbtDiCiWV
         6TeUT0sMz+tDK3e4aTRzbOP46BpBTpHN1OjlUlRFnqyZC71tl0Naa6AeVTM6lLh78lPw
         5QVfgfervH7ht4GTYCfnzd2FIoGVdysHIVVozFNLhUpdSjUPQ2E66ySz4kgJtluaseEw
         9JQNuMxUh1TO0F7NM9igyr1KylGLExfVT2XgvxQDurBSTlgE+bfKE5PModi8pQAwBza2
         ksGqKjeRWPLCVhboZDNPvH9jbPLNsm8NvnGg2kADyItR7AwS7h9uzH0LmlZGHqoTva2j
         C6cA==
X-Gm-Message-State: APjAAAV9BRnWiL/X+tzk0GNYrmqJvl3NvCCl1o2DYkQG1PoC8F3iSfJH
        FV+QII4hnrMaJSC/Wr+d8K4TBg==
X-Google-Smtp-Source: APXvYqx+9n46HP35O9hdRmzsfd77GKKw6ZX2P2RJpjpfipYroHeRTkUTsWHFhuqjLVEMEF9mxUY0CQ==
X-Received: by 2002:a2e:1201:: with SMTP id t1mr11364300lje.153.1561913483383;
        Sun, 30 Jun 2019 09:51:23 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id u18sm2765052ljj.32.2019.06.30.09.51.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 30 Jun 2019 09:51:22 -0700 (PDT)
Date:   Sun, 30 Jun 2019 19:51:20 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com
Subject: Re: [net-next, PATCH 3/3, v2] net: netsec: add XDP support
Message-ID: <20190630165119.GE12704@khorivan>
References: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561785805-21647-4-git-send-email-ilias.apalodimas@linaro.org>
 <20190630162552.GB12704@khorivan>
 <20190630163214.GA10484@apalos>
 <20190630164127.GC12704@khorivan>
 <20190630164745.GA11278@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190630164745.GA11278@apalos>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 07:47:45PM +0300, Ilias Apalodimas wrote:
>On Sun, Jun 30, 2019 at 07:41:28PM +0300, Ivan Khoronzhuk wrote:
>> On Sun, Jun 30, 2019 at 07:32:14PM +0300, Ilias Apalodimas wrote:
>> >On Sun, Jun 30, 2019 at 07:25:53PM +0300, Ivan Khoronzhuk wrote:
>> >>On Sat, Jun 29, 2019 at 08:23:25AM +0300, Ilias Apalodimas wrote:
>> >>>The interface only supports 1 Tx queue so locking is introduced on
>> >>>the Tx queue if XDP is enabled to make sure .ndo_start_xmit and
>> >>>.ndo_xdp_xmit won't corrupt Tx ring
>> >>>
>> >>>- Performance (SMMU off)
>> >>>
>> >>>Benchmark   XDP_SKB     XDP_DRV
>> >>>xdp1        291kpps     344kpps
>> >>>rxdrop      282kpps     342kpps
>> >>>
>> >>>- Performance (SMMU on)
>> >>>Benchmark   XDP_SKB     XDP_DRV
>> >>>xdp1        167kpps     324kpps
>> >>>rxdrop      164kpps     323kpps
>> >>>
>> >>>Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>> >>>---
>> >>>drivers/net/ethernet/socionext/netsec.c | 361 ++++++++++++++++++++++--
>> >>>1 file changed, 334 insertions(+), 27 deletions(-)
>> >>>
>> >>
>> >>[...]
>> >>
>> >>>+
>> >>>+static int netsec_xdp_setup(struct netsec_priv *priv, struct bpf_prog *prog,
>> >>>+			    struct netlink_ext_ack *extack)
>> >>>+{
>> >>>+	struct net_device *dev = priv->ndev;
>> >>>+	struct bpf_prog *old_prog;
>> >>>+
>> >>>+	/* For now just support only the usual MTU sized frames */
>> >>>+	if (prog && dev->mtu > 1500) {
>> >>>+		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
>> >>>+		return -EOPNOTSUPP;
>> >>>+	}
>> >>>+
>> >>>+	if (netif_running(dev))
>> >>>+		netsec_netdev_stop(dev);
>> >>And why to stop the interface. XDP allows to update prog in runtime.
>> >>
>> >Adding the support is not limited to  adding a prog only in this driver.
>> >It also rebuilts the queues which changes the dma mapping of buffers.
>> >Since i don't want to map BIDIRECTIONAL buffers if XDP is not in place,
>> >i am resetting the device and forcing the buffer re-allocation
>> >
>> >Thanks
>> >/Ilias
>> I don't know the internals, probably it has some dependencies, but here you
>> just update the prog and can at least do it when exchange is happening.
>> I mean not in case of prog is attached/removed first time.
>> In case of prog -> prog it seems doable...
>>
>> It ups to you ofc, but I can run smth like:
>> ip -force link set dev eth0 xdp obj xdp-example-pass.o sec .text
>> and expect it's updated w/o interface reset I mean on new prog.
>>
>> I'm not sure, but maintainers can help, conceptually it's supposed to be in
>> runtime the prog be update uder rcu as a part of API usage...
>It's doable but it means i'd have to change the buffer allocation again. I'd
>also prefer mapping FOR_DEVICE only if XDP is not loaded. Most of the drivers do
>restart so i'll stick with this for the current version.
>Most of the drivers do restart now so i'll stick to that for now.
I have nothing against it to be merged. Just pay attention on
XDP_FLAGS_UPDATE_IF_NOEXIST or update it layter or now...ups to your.

>
>Thanks
>/Ilias

-- 
Regards,
Ivan Khoronzhuk
