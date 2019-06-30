Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927065B0B3
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfF3Qrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:47:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35922 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfF3Qru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 12:47:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so11205324wrs.3
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 09:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ad+ORyQukNoKZ5o4Xh+LDJikFlkx0O7iGfvpK9RGQtY=;
        b=YQYmyfqpWNUyNjsPtv1pq2hhtZZLwBVbVyPzTkyQr3IzKyym9fV6cm65eRrC9M9L3O
         29ZHmZm0iHwYb49WXmDVVVo+7oWXpXeJBu/fba2cvVPjfOpluZjAIt4nOybPulp68PMu
         38vIRISSG127OUXmyJQD5QLlSsHN1t22Rj63g8yS/Dv+enVY9yim9J0f6xUKq5WBtE0R
         Wns8OpNAYwzNYbZB02w3Lw+unBsXWgZRWSs4cCb+kmyfN8UaY4RXPnTSjNKP+09eLqJJ
         D0ug1vukIgiL6dQYHx3PO08J4F7ABy2U4JpIuHuv9Lz96D8MpIWkuvMhfxBsCkln0jMa
         MKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ad+ORyQukNoKZ5o4Xh+LDJikFlkx0O7iGfvpK9RGQtY=;
        b=e9+PY64q9dsCe9KbPZScC+0EfHTY3yYqvbjMghTuuAGlbq8UjpT+/Runclwr6LQiLB
         IDkK0P+zOcx1eLQ8mSjf7ZopXiQ9UsJBZ705aLMNSh7y1lmKq3bpW3nVycrIZ5LXdyoj
         l98mFnZ30vzR3ZlmFaVFk0rri4Lho6RJs5dTPkOxbMvXaaTsre8kC/ppmP0+VEFvlF2B
         m32zO1AzTXCUE2RqcKQ4BnaFDvHC4zGTJi9Re0bwj4QGxTKztl7BaGkdL5cvvpOLWsIt
         ayrVuyVg37KTvCjuAUIMS5rvJGU091KiXxKAu9SCHFaUy84pPCdynbPhRbcEoZBjF7br
         DuhA==
X-Gm-Message-State: APjAAAUB0m/S4ZamnXltKvCc9yWVFaROfgH8YyE/FL7R7F0ILXx8dvix
        f5/s6GkWVzJ3QEZO+6Tl8XsCdA==
X-Google-Smtp-Source: APXvYqwPzNJaTXCvJxRN/umi7zMBGh+HpvuXPy2teNWwQlyGhdn1IDpz+LzD5jgMEFh+1h5iBDh53Q==
X-Received: by 2002:a5d:6389:: with SMTP id p9mr16631536wru.297.1561913268643;
        Sun, 30 Jun 2019 09:47:48 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id y4sm9675280wrn.68.2019.06.30.09.47.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 09:47:48 -0700 (PDT)
Date:   Sun, 30 Jun 2019 19:47:45 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com
Subject: Re: [net-next, PATCH 3/3, v2] net: netsec: add XDP support
Message-ID: <20190630164745.GA11278@apalos>
References: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561785805-21647-4-git-send-email-ilias.apalodimas@linaro.org>
 <20190630162552.GB12704@khorivan>
 <20190630163214.GA10484@apalos>
 <20190630164127.GC12704@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190630164127.GC12704@khorivan>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 07:41:28PM +0300, Ivan Khoronzhuk wrote:
> On Sun, Jun 30, 2019 at 07:32:14PM +0300, Ilias Apalodimas wrote:
> >On Sun, Jun 30, 2019 at 07:25:53PM +0300, Ivan Khoronzhuk wrote:
> >>On Sat, Jun 29, 2019 at 08:23:25AM +0300, Ilias Apalodimas wrote:
> >>>The interface only supports 1 Tx queue so locking is introduced on
> >>>the Tx queue if XDP is enabled to make sure .ndo_start_xmit and
> >>>.ndo_xdp_xmit won't corrupt Tx ring
> >>>
> >>>- Performance (SMMU off)
> >>>
> >>>Benchmark   XDP_SKB     XDP_DRV
> >>>xdp1        291kpps     344kpps
> >>>rxdrop      282kpps     342kpps
> >>>
> >>>- Performance (SMMU on)
> >>>Benchmark   XDP_SKB     XDP_DRV
> >>>xdp1        167kpps     324kpps
> >>>rxdrop      164kpps     323kpps
> >>>
> >>>Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> >>>---
> >>>drivers/net/ethernet/socionext/netsec.c | 361 ++++++++++++++++++++++--
> >>>1 file changed, 334 insertions(+), 27 deletions(-)
> >>>
> >>
> >>[...]
> >>
> >>>+
> >>>+static int netsec_xdp_setup(struct netsec_priv *priv, struct bpf_prog *prog,
> >>>+			    struct netlink_ext_ack *extack)
> >>>+{
> >>>+	struct net_device *dev = priv->ndev;
> >>>+	struct bpf_prog *old_prog;
> >>>+
> >>>+	/* For now just support only the usual MTU sized frames */
> >>>+	if (prog && dev->mtu > 1500) {
> >>>+		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
> >>>+		return -EOPNOTSUPP;
> >>>+	}
> >>>+
> >>>+	if (netif_running(dev))
> >>>+		netsec_netdev_stop(dev);
> >>And why to stop the interface. XDP allows to update prog in runtime.
> >>
> >Adding the support is not limited to  adding a prog only in this driver.
> >It also rebuilts the queues which changes the dma mapping of buffers.
> >Since i don't want to map BIDIRECTIONAL buffers if XDP is not in place,
> >i am resetting the device and forcing the buffer re-allocation
> >
> >Thanks
> >/Ilias
> I don't know the internals, probably it has some dependencies, but here you
> just update the prog and can at least do it when exchange is happening.
> I mean not in case of prog is attached/removed first time.
> In case of prog -> prog it seems doable...
> 
> It ups to you ofc, but I can run smth like:
> ip -force link set dev eth0 xdp obj xdp-example-pass.o sec .text
> and expect it's updated w/o interface reset I mean on new prog.
> 
> I'm not sure, but maintainers can help, conceptually it's supposed to be in
> runtime the prog be update uder rcu as a part of API usage...
It's doable but it means i'd have to change the buffer allocation again. I'd
also prefer mapping FOR_DEVICE only if XDP is not loaded. Most of the drivers do
restart so i'll stick with this for the current version. 
Most of the drivers do restart now so i'll stick to that for now.

Thanks
/Ilias
