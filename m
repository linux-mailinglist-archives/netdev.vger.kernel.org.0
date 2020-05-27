Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649391E4286
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 14:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgE0MjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 08:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729919AbgE0MjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 08:39:10 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D63BC08C5C1;
        Wed, 27 May 2020 05:39:10 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q24so1476968pjd.1;
        Wed, 27 May 2020 05:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cNOcuDRmAg9W+Ilz7Xfca09ahL9N+UWy02PGGnf96EQ=;
        b=iIoAWEEfsTTQlC4b85tbUnew0L5PF+2vid+TiL+M4Oy26yYzMNA9xKZtL9VXI34DBW
         c56wYH4BZikqN8GN5vHsWLF5ZBnlCpIqFV8nTNvZbk/SIz/pRlsouWLzuAe9aemCh2bL
         LTK7u3Dx/YIGZ6Coma7Kp/lIcXoRBSQNyrns0xGysmw8qovS538/m6s76Vlhl4mC5By9
         GEV77e/rqPiZyyw26Vsd00z7B1FfDxJSdUsHiO1jFFT2OmeF+523hn6XgqgsEkeL2cXN
         0oiLzIH40kKuZBhme8JerS0K3dCzpZAQIJ5TDHgbyM+x9zuiV8OTxXw9vtKQp/0Uvwzw
         7Vlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cNOcuDRmAg9W+Ilz7Xfca09ahL9N+UWy02PGGnf96EQ=;
        b=pDlweMWkQF9cT7GtH1rZ3W8MoLgRnKqMSqpMuEIjfyFiCFdQGfubfYX02FWomQNgi7
         zCBDQtojmaZVGzuYQPVMMja+Z9Qif09PUfIULCI5oXX2p36h5bhIKCukbtdJFOOLrRcb
         rNvJnfNU+JUEvjQ68rXO49FS8nSqjQ7ZQ5EnxzHPm49qmf6Nzr59+oHD4gII60+o4DeD
         oculnja8WPn0I8hDwjowzPIe9oa9zMZyoMV4RKhSCj+djgrVmLRsie4bG1DJ2zRxNvj1
         jHdg/J7POm9p9UZ+OaB1+bvQ3GVed82jysOCE19oBNRiZJkawmbof3j8jEgbFiT7CMJO
         2C8w==
X-Gm-Message-State: AOAM531gvDc91TwMYnw2cig548k37DIRLoW4ixlUUuK8HxlMHnEJsgB9
        5Nm/YYv3qLr/1rskPk9QGGw=
X-Google-Smtp-Source: ABdhPJxIUMIO6trfpPAR6lWOc9IVk96ID3Uk2TR5iyHdA6cQg8aOHP2SJNMmK2pNBSr7jhwFvQwaTA==
X-Received: by 2002:a17:90a:1a90:: with SMTP id p16mr4492000pjp.185.1590583149637;
        Wed, 27 May 2020 05:39:09 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q12sm2139236pfn.129.2020.05.27.05.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 05:39:08 -0700 (PDT)
Date:   Wed, 27 May 2020 20:38:58 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Message-ID: <20200527123858.GH102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200526140539.4103528-1-liuhangbin@gmail.com>
 <87zh9t1xvh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zh9t1xvh.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 12:21:54PM +0200, Toke Høiland-Jørgensen wrote:
> > The example in patch 2 is functional, but not a lot of effort
> > has been made on performance optimisation. I did a simple test(pkt size 64)
> > with pktgen. Here is the test result with BPF_MAP_TYPE_DEVMAP_HASH
> > arrays:
> >
> > bpf_redirect_map() with 1 ingress, 1 egress:
> > generic path: ~1600k pps
> > native path: ~980k pps
> >
> > bpf_redirect_map_multi() with 1 ingress, 3 egress:
> > generic path: ~600k pps
> > native path: ~480k pps
> >
> > bpf_redirect_map_multi() with 1 ingress, 9 egress:
> > generic path: ~125k pps
> > native path: ~100k pps
> >
> > The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we loop
> > the arrays and do clone skb/xdpf. The native path is slower than generic
> > path as we send skbs by pktgen. So the result looks reasonable.
> 
> How are you running these tests? Still on virtual devices? We really

I run it with the test topology in patch 2/2. The test is run on physical
machines, but I use veth interface. Do you mean use a physical NIC driver
for testing?


BTW, when using pktgen, I got an panic because the skb don't have enough
header room. The code path looks like

do_xdp_generic()
  - netif_receive_generic_xdp()
    - skb_headroom(skb) < XDP_PACKET_HEADROOM
      - pskb_expand_head()
        - BUG_ON(skb_shared(skb))

So I added a draft patch for pktgen, not sure if it has any influence.

index 08e2811b5274..fee17310c178 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -170,6 +170,7 @@
 #include <linux/uaccess.h>
 #include <asm/dma.h>
 #include <asm/div64.h>         /* do_div */
+#include <linux/bpf.h>

 #define VERSION        "2.75"
 #define IP_NAME_SZ 32
@@ -2692,7 +2693,7 @@ static void pktgen_finalize_skb(struct pktgen_dev *pkt_dev, struct sk_buff *skb,
 static struct sk_buff *pktgen_alloc_skb(struct net_device *dev,
                                        struct pktgen_dev *pkt_dev)
 {
-       unsigned int extralen = LL_RESERVED_SPACE(dev);
+       unsigned int extralen = LL_RESERVED_SPACE(dev) + XDP_PACKET_HEADROOM;
        struct sk_buff *skb = NULL;
        unsigned int size;

> need results from a physical setup in native mode to assess the impact
> on the native-XDP fast path. The numbers above don't tell much in this
> regard. I'd also like to see a before/after patch for straight
> bpf_redirect_map(), since you're messing with the fast path, and we want
> to make sure it's not causing a performance regression for regular
> redirect.

OK, I will write a test with 1 ingress + 1 egress for bpf_redirect_map_multi.
Just as Eelco said.
> 
> Finally, since the overhead seems to be quite substantial: A comparison
> with a regular network stack bridge might make sense? After all we also
> want to make sure it's a performance win over that :)

OK, Will do it.

Thanks
Hangbin
