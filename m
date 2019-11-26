Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736F310A586
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 21:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfKZUfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 15:35:34 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45481 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfKZUfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 15:35:34 -0500
Received: by mail-lj1-f193.google.com with SMTP id n21so21765397ljg.12
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 12:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=K4Bc+8eHqvfcdZUohVg+/Nb9ohh1S05Ow4H5opvoqhk=;
        b=hP8MBek+jIyGLD+HG0jW2xvdPV0teuBv/6k2y1ZOfuFlO/HjwikQPbJcxccaCkY4ca
         gjaTQdQJuJuuDe7KXGd7CHEz647Qh6NX9XAIW3c4Z8FK6pZpjhGsPKjwmxaJVD5IlM/X
         Z5/WxylRjt2WqI7WJW+aZcE6o+zYKjTFcMG7c0n8bOuwNbF7ICmk+Fxg7pHQ7dwDF31l
         NmFxlfLTZZuYjXH9EvJKULzXQ8K11aH69Hhg25nRJk/+Jd3ZLFE+87+CG7Iv/YLiH0r1
         8nEtemUANXF+RxlU+k7p/LnGQqcmKLtW90x47b0ZBqnVjm14VykY0TyefIzMoDaXqk0J
         rZ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=K4Bc+8eHqvfcdZUohVg+/Nb9ohh1S05Ow4H5opvoqhk=;
        b=dqkOkOHOTH2EH/XVlRWbo7tVIkPOev9U298/XY1Eosmbp9j7Zq1PIpFpZYW1viD/l7
         573Qje1Wfb1girjUI4FqON0+hi/qneuw6p703Qtx1q3+Y3faQm0euTlay6kMdARtanbV
         LYjjRMKwgIEauIANXD2OnqvVSG0xrveRPgqgKjb8UQvpd3CsH27Yn+aYEDFubFW58d5g
         Y0WJKclX1y8Bt7kWPgpH3WAnnTZpdy3sGC+WAcKjci4bZP1OMSITjT84RsVm+yfSRmQn
         +q5aBG6Nddm6zXzqfCNNB7qBn8agYgU5KLTOpCE11eA01saCnrpMhhK36MnIeo3YKTIM
         CmSw==
X-Gm-Message-State: APjAAAV2mpf2UkNF4uC3RoYpOXOcbvZhgTSZ+SwvbBAb8v4h3O7UAeKx
        wh8TgpVGX22H16s4SJXclCAvGw==
X-Google-Smtp-Source: APXvYqx9IqBt3lkqgKwa8lRqh+EMXV4Z5INEt5vZARRFzhNGU5/ykWOAvkTYwnAGobZix7373gRwCQ==
X-Received: by 2002:a2e:8885:: with SMTP id k5mr11915374lji.98.1574800532208;
        Tue, 26 Nov 2019 12:35:32 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z127sm5839668lfa.19.2019.11.26.12.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 12:35:31 -0800 (PST)
Date:   Tue, 26 Nov 2019 12:35:14 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Prashant Bhole <prashantbhole.linux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC net-next 00/18] virtio_net XDP offload
Message-ID: <20191126123514.3bdf6d6f@cakuba.netronome.com>
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Nov 2019 19:07:26 +0900, Prashant Bhole wrote:
> Note: This RFC has been sent to netdev as well as qemu-devel lists
> 
> This series introduces XDP offloading from virtio_net. It is based on
> the following work by Jason Wang:
> https://netdevconf.info/0x13/session.html?xdp-offload-with-virtio-net
> 
> Current XDP performance in virtio-net is far from what we can achieve
> on host. Several major factors cause the difference:
> - Cost of virtualization
> - Cost of virtio (populating virtqueue and context switching)
> - Cost of vhost, it needs more optimization
> - Cost of data copy
> Because of above reasons there is a need of offloading XDP program to
> host. This set is an attempt to implement XDP offload from the guest.

This turns the guest kernel into a uAPI proxy.

BPF uAPI calls related to the "offloaded" BPF objects are forwarded 
to the hypervisor, they pop up in QEMU which makes the requested call
to the hypervisor kernel. Today it's the Linux kernel tomorrow it may 
be someone's proprietary "SmartNIC" implementation.

Why can't those calls be forwarded at the higher layer? Why do they
have to go through the guest kernel?

If kernel performs no significant work (or "adds value", pardon the
expression), and problem can easily be solved otherwise we shouldn't 
do the work of maintaining the mechanism.

The approach of kernel generating actual machine code which is then
loaded into a sandbox on the hypervisor/SmartNIC is another story.

I'd appreciate if others could chime in.
