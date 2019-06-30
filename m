Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5CD15B0CB
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 19:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfF3RJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 13:09:53 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:47055 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfF3RJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 13:09:53 -0400
Received: by mail-lj1-f194.google.com with SMTP id v24so10605319ljg.13
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 10:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LLJrD8JYs5KsEL/iLCC6WW1KFABkE/KzgcfULbMS7Xs=;
        b=mt2vpAdM4bVLbQjd7IMxabaybyizFv8HqS3rDD50yWjIxDH5OmbekmFrIAEvsFDul8
         CEPCyOQThXMRcqAMIesLvsPxV3AVohBvEtUgvt2lEaQl3+quzBBB4lFeXlWQTa7BLzc5
         j+Pxuvp4uErDNO4U6tF/6LiU/jmqP0Gcs/Q+PgdkH8zNu/PDpedK6dEZv4Xnu7AhRGae
         2Uh6/CNOa0/jmiKThNJ6ETZLeXTvBJNoAzm4TaNhsaNFfw1sNBWHdzOez3SRzETJ6bmF
         cU58pcQoaL6vjPWlzmF6kKpomwJ9bwIyoJ/d7cs0rvYyiMFJqWly3l3fcfOql3bxrcvZ
         S0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LLJrD8JYs5KsEL/iLCC6WW1KFABkE/KzgcfULbMS7Xs=;
        b=r2YwzVUJ8ZVngSwh0efrzMmMbOkjEscTmEe/4dAZ5w3m1fLexdw3gRlSoNtxFfdOMz
         NsMaPFPYvOpMIt/WXux5F0l8Uuy7mTn9yZzaqw/DnV+dPwvZZERbjOnXntYJbi1JDLPA
         01b8nRRkcfS8M4hoE64c6WzxlR2qZRG4VjtB/sMXWH60DwZPHw2c2ggp5cTWBo5i/HFv
         NBTtFU38ohC1ch/d0sE56nUXPibdRccwQKlk3EHhRQidvL46JrQpo5US81cLSE11LNZj
         veiu5x+QC7KPH1S8DIVyHbZFYkZ4wXLP5ixFdD1jRcX4uwpXd2qFoCnOVt/IwejKyAM7
         cXyg==
X-Gm-Message-State: APjAAAUPMBq413aKCv4gL5eG6yLD8tNV5wHhWApRx/Q5F2E1x7LE06hP
        Oty6tg5nOM4qVh6GyNYP+8c+hA==
X-Google-Smtp-Source: APXvYqwRauOwZ0eKCWIoD8S09QJFTBXfPlJv/QJxwHPQzkcPRPrBFtIwVkrcHrqRX+t9lohei4ADIw==
X-Received: by 2002:a2e:9657:: with SMTP id z23mr11304727ljh.116.1561914591190;
        Sun, 30 Jun 2019 10:09:51 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id v22sm2265332lfe.49.2019.06.30.10.09.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 30 Jun 2019 10:09:51 -0700 (PDT)
Date:   Sun, 30 Jun 2019 20:09:48 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com
Subject: Re: [net-next, PATCH 3/3, v2] net: netsec: add XDP support
Message-ID: <20190630170948.GF12704@khorivan>
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
In case prog -> prog update you don't need to do anyting,
just exchange prog, That's it.

You can add it later, if you want. np.

-- 
Regards,
Ivan Khoronzhuk
