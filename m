Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90BC31E640
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 07:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhBRGRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 01:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhBRGKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 01:10:06 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D81FC061574;
        Wed, 17 Feb 2021 22:09:05 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id u20so875294iot.9;
        Wed, 17 Feb 2021 22:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=atQAOiXOaMqgkt/WAy6i7CPw9uCPqigPDIhb+m8D4Y8=;
        b=nxC60e/uUY4jw8+FJ0kmQWgUsuJGK5wdf9HeGp2FM0gZei3SirMeYsXmQ8XlDIR04l
         L6mtzeOBsFhv9c2EKURuPpuOXsfGgZQLLZmCyDAfnP2HTft3XWGKKqX2DWiMvs3WNdZ+
         EutwcGVe9QKoXc4bwbY5A/zwZM5ajqgNseOweUvPgGfgM/gVSOYvwm/4FzGan29lH4cO
         S5GZopYOy0XuXQ9LbvdyyJyd0pS63ylKBXmx1jgutD99r5lmBWCG76ANFPOfblwNjDnz
         a4q4n9jIesPN5al1RmTCCFbBFprYVSGYqpYJB27XgjWpD9y/jDzOHEMjlKrT5/eFeIfi
         4zTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=atQAOiXOaMqgkt/WAy6i7CPw9uCPqigPDIhb+m8D4Y8=;
        b=tp8h5FO0kNIx2ROeLvRw/4Z6ajrWwPrEC1f0XoMeIA6QHO3ToYS/1YqqgtU2CjtPPK
         iL0ZGzJNoFtStW6BLGq1Za4FrTbNcv4/zRgCcG1bcPlaF61E7CWc3isAimy1Y2YcONf2
         8EcqLeXxY5sJL9Qlg7U4ofWznSLAkqy16f17mlAU9Qu3tV15oEbAhPZf+RNoWsLKqTgf
         +dhC1EM/YR08Cqk5e8U05uVCp2ueqjfAmdn86vzTqqOfzG/HN9OvkZgNynuZ+8L9xuIm
         z9T+AIyfSUQIBzlRNnUmpqgCHuIXMBowM78fPajLg+IOWqAfQs5Fr4VMKuTfGbJnCe70
         4WUw==
X-Gm-Message-State: AOAM533BwbcEOPgICCnMRCEoTZajr2IZhm0c21oF9bAZ51HJ7vICivzw
        eGr/HyiAQ6o3vzAF0zp9LfY=
X-Google-Smtp-Source: ABdhPJyWEr2p5NJfyVcac6POCKwY2UVRF2my+lH+aP4hrOuC6NQOqiSfIPl7hpFEPYSDm9t0Vn/2vQ==
X-Received: by 2002:a05:6638:33a0:: with SMTP id h32mr3133952jav.143.1613628544803;
        Wed, 17 Feb 2021 22:09:04 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id w5sm3220548ilj.40.2021.02.17.22.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 22:09:04 -0800 (PST)
Date:   Wed, 17 Feb 2021 22:08:55 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexander Lobakin <alobakin@pm.me>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Alexander Lobakin <alobakin@pm.me>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <602e0477af4c2_1f0ef2088e@john-XPS-13-9370.notmuch>
In-Reply-To: <20210217120003.7938-1-alobakin@pm.me>
References: <20210217120003.7938-1-alobakin@pm.me>
Subject: RE: [PATCH v7 bpf-next 0/6] xsk: build skb by page (aka generic
 zerocopy xmit)
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin wrote:
> This series introduces XSK generic zerocopy xmit by adding XSK umem
> pages as skb frags instead of copying data to linear space.
> The only requirement for this for drivers is to be able to xmit skbs
> with skb_headlen(skb) == 0, i.e. all data including hard headers
> starts from frag 0.
> To indicate whether a particular driver supports this, a new netdev
> priv flag, IFF_TX_SKB_NO_LINEAR, is added (and declared in virtio_net
> as it's already capable of doing it). So consider implementing this
> in your drivers to greatly speed-up generic XSK xmit.

[...]
 
> ---------------- Performance Testing ------------
> 
> The test environment is Aliyun ECS server.
> Test cmd:
> ```
> xdpsock -i eth0 -t  -S -s <msg size>
> ```
> 
> Test result data:
> 
> size    64      512     1024    1500
> copy    1916747 1775988 1600203 1440054
> page    1974058 1953655 1945463 1904478
> percent 3.0%    10.0%   21.58%  32.3%
> 

For the series, but might be good to get Dave or Jakub to check
2/6 to be sure they agree.

Acked-by: John Fastabend <john.fastabend@gmail.com>
