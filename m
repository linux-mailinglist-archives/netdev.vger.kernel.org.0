Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FF24B9B60
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 09:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbiBQIpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 03:45:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238015AbiBQIpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 03:45:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A381222187
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 00:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645087531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l/VQgLhh1DBOYffBqGYngony3TZbnaAH3gw4sPL+y8Y=;
        b=Me+IMdt2NrtQFSPzk+YAPcxkgt8kNUP4zysBg6BaygXHlns4CSCzcNXgV9mhR0A0J30d3d
        8/JlOfp1+2PJrGGCND5Z2CuNL72jUvIFzOi1UhQ8ZEvPPSwcxri9RTZkKlliI0C4HbkTSN
        QyAqL4OgAlZkinPin8c3d2F/cp07lKc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-M0oe2d-ANR-6WlcR3FGz_g-1; Thu, 17 Feb 2022 03:45:30 -0500
X-MC-Unique: M0oe2d-ANR-6WlcR3FGz_g-1
Received: by mail-wm1-f69.google.com with SMTP id ay41-20020a05600c1e2900b0037c5168b3c4so3919930wmb.7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 00:45:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=l/VQgLhh1DBOYffBqGYngony3TZbnaAH3gw4sPL+y8Y=;
        b=av7iK+3tH/wWefOE2ncJUqapdThLDvwZBnglHJmVJ8HQ42Eye0E6z+fv+k+C3n1g+P
         jMEJYOKXhKSDcfPA+AcYBOkuM1QEEuEmQ9+BKT4CslEAfBL71rwHyKGZYUpFg/8BOptT
         hVfGIdbyjAyhaCP2K81h3smglwQ9hN+7iid9TTH41gM/NhsoOL0oyV7UXjDWJiWRFyRl
         N9a3UTvN8sY19KVSTT9uMzy1rECSlTMbcGwxTq2gLJR6oi+fF+RUoeL08lvLQmvNCbif
         4OauFP7O1n2JO3C/DE2zWb1/KMWobd0a/V5gO92j9y5XpSOb0y/FKMzKbAjMXG7I8LmH
         V9eA==
X-Gm-Message-State: AOAM5336yJIjfUjO2rl+bLVFFrSI40B3wVFDfOnqPKZHFBlcunJ+59Oh
        cg08eW4HtFFLJUEoKkfYoOcox1MsTyFUe5Ol5SBpYZ0ZoKwwABEmw/Gh1cyqwG3PFKgLmOVplvb
        0XvziI9fMDHChpfZ0
X-Received: by 2002:a05:600c:4e0a:b0:37b:c548:622a with SMTP id b10-20020a05600c4e0a00b0037bc548622amr5359172wmq.55.1645087529261;
        Thu, 17 Feb 2022 00:45:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxg9hz9QXiPqil98HtD9zdj/RRqil2JJJiJ6kNUJxNsL96+bttpFtCe95wg8+235HI07HM++Q==
X-Received: by 2002:a05:600c:4e0a:b0:37b:c548:622a with SMTP id b10-20020a05600c4e0a00b0037bc548622amr5359148wmq.55.1645087529037;
        Thu, 17 Feb 2022 00:45:29 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-112-206.dyn.eolo.it. [146.241.112.206])
        by smtp.gmail.com with ESMTPSA id z7sm492824wml.40.2022.02.17.00.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 00:45:28 -0800 (PST)
Message-ID: <41a3e6e4f9331c6a0a62fe838fc6f9084a5c89bc.camel@redhat.com>
Subject: Re: [PATCH v3] net: fix wrong network header length
From:   Paolo Abeni <pabeni@redhat.com>
To:     Lina Wang <lina.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        bpf <bpf@vger.kernel.org>,
        Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Feb 2022 09:45:27 +0100
In-Reply-To: <20220217070139.30028-1-lina.wang@mediatek.com>
References: <CAADnVQK78PN8N6c6u_O2BAxdyXwH_HVYMV_x3oGgyfT50a6ymg@mail.gmail.com>
         <20220217070139.30028-1-lina.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2022-02-17 at 15:01 +0800, Lina Wang wrote:
> On Wed, 2022-02-16 at 19:05 -0800, Alexei Starovoitov wrote:
> > On Tue, Feb 15, 2022 at 11:37 PM Lina Wang <lina.wang@mediatek.com>
> > wrote:
> > > 
> > > When clatd starts with ebpf offloaing, and NETIF_F_GRO_FRAGLIST is
> > > enable,
> > > several skbs are gathered in skb_shinfo(skb)->frag_list. The first
> > > skb's
> > > ipv6 header will be changed to ipv4 after bpf_skb_proto_6_to_4,
> > > network_header\transport_header\mac_header have been updated as
> > > ipv4 acts,
> > > but other skbs in frag_list didnot update anything, just ipv6
> > > packets.
> > 
> > Please add a test that demonstrates the issue and verifies the fix.
> 
> I used iperf udp test to verify the patch, server peer enabled -d to debug
> received packets.
> 
> 192.0.0.4 is clatd interface ip, corresponding ipv6 addr is 
> 2000:1:1:1:afca:1b1f:1a9:b367, server peer ip is 1.1.1.1,
> whose ipv6 is 2004:1:1:1::101:101.
> 
> Without the patch, when udp length 2840 packets received, iperf shows:
> pcount 1 packet_count 0
> pcount 27898727 packet_count 1
> pcount 3 packet_count 27898727
> 
> pcount should be 2, but is 27898727(0x1a9b367) , which is 20 bytes put 
> forward. 
> 
> 12:08:02.680299	Unicast to us 2004:1:1:1::101:101   2000:1:1:1:afca:1b1f:1a9:b367 UDP 51196 → 5201 Len=2840
> 0000   20 00 00 01 00 01 00 01 af ca 1b 1f 01 a9 b3 67   ipv6 dst address
> 0000   c7 fc 14 51 0b 20 c7 ab                           udp header
> 0000   00 00 00 ab 00 0e f3 49 00 00 00 01 08 06 69 d2   00000001 is pcount
> 12:08:02.682084	Unicast to us	1.1.1.1	                 192.0.0.4 	 	  UDP 51196 → 5201 Len=2840
> 
> After applied the patch, there is no OOO, pcount acted in order.

To clarify: Alexei is asking to add a test under:

tools/testing/selftests/net/

to cover this specific case. You can propbably extend the existing
udpgro_fwd.sh.

Please explicitly CC people who gave feedback to previous iterations,
it makes easier to track the discussion.

/P

