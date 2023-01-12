Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398A5667A17
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbjALP6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240328AbjALP5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:57:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B181630C
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 07:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673538463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KRE5893iX04jrGywKNs0iqtC9XhdTqoDhy9dIOaS4B0=;
        b=dgbRe/WYQHoa+UbXC9xT/9QsDvkn6b7pnrDmorcPxJ6Puh1V8fMFFwdYkQqer4oo1YdBNw
        PGxSq2ceNaCLsA8GsQRm5Jq3Tu014wwfKKWB3GAUoE42n2scwt3Y5w93JmFkMcdo/Var6F
        juD4VouaXoHU+JSZfNzp3VTcBrutIII=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-362-PKFbPZ40Om2sfufIr7_OQw-1; Thu, 12 Jan 2023 10:47:42 -0500
X-MC-Unique: PKFbPZ40Om2sfufIr7_OQw-1
Received: by mail-wm1-f72.google.com with SMTP id q21-20020a7bce95000000b003d236c91639so4405386wmj.8
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 07:47:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KRE5893iX04jrGywKNs0iqtC9XhdTqoDhy9dIOaS4B0=;
        b=BOwnWaCOrWSENFX5JlsN74vpClsGWN6BcpnSi1tM2PZrjDXvl5cHhJLDjKJJHChynV
         fElFSjOvEYisytZYB7O7gscW5WheskvRgIBi5MPpjwmerejW3wh8G3fiUQJTXaB3OGKf
         vymrkoi/6baTcnWGSr+oXfk2aMU5Vz+g2EiU8E1zGuYHqPjkjJPV6o+6tC8CFRXI65hd
         wwI5qSCnRAGYb8epYYrmLLx+Zs9huP9oeSXZLYL6LCL223Y/MR/Uy2q42pFlkO2OhWir
         jJsgHRWLb7C+dDgMjTmlP8yH6PFOC8RLvJnTKvzkFNFJ77NOu7NswtOgejXsWgOb+cPN
         gDrg==
X-Gm-Message-State: AFqh2kq9PI1Fh2MmoF06T08L4Nbi+fVb11IzXiYF2rCvM4TlpJyKxD3f
        4ttl/zpdBiyFhg6hv5d7BkP3Pkr8IcIxyy6qY7udxXWhFABro2ZepgMcP7eqaasDNZmkBcII2Ui
        g4bHBlL10y6R1TEga
X-Received: by 2002:a05:600c:354c:b0:3da:10e6:b79c with SMTP id i12-20020a05600c354c00b003da10e6b79cmr3055896wmq.24.1673538460986;
        Thu, 12 Jan 2023 07:47:40 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuGt9Xp38VuihuiQSwcLY4/Te4d2ubEUq6EvNtdkAysW0dGE5N4524IEcewJLaHgKiOFsh+PQ==
X-Received: by 2002:a05:600c:354c:b0:3da:10e6:b79c with SMTP id i12-20020a05600c354c00b003da10e6b79cmr3055879wmq.24.1673538460719;
        Thu, 12 Jan 2023 07:47:40 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-183.dyn.eolo.it. [146.241.113.183])
        by smtp.gmail.com with ESMTPSA id hg11-20020a05600c538b00b003cf6a55d8e8sm21422831wmb.7.2023.01.12.07.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 07:47:39 -0800 (PST)
Message-ID: <47d9b00c664dbaabd8921a47257ffc3b7c5a1325.camel@redhat.com>
Subject: Re: [PATCH net 2/2] net/af_packet: fix tx skb network header on
 SOCK_RAW sockets over VLAN device
From:   Paolo Abeni <pabeni@redhat.com>
To:     =?ISO-8859-1?Q?Herv=E9?= Boisse <admin@netgeek.ovh>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Jan 2023 16:47:38 +0100
In-Reply-To: <Y8Am5wAxC48N12PE@quaddy.sgn>
References: <20230110191725.22675-1-admin@netgeek.ovh>
         <20230110191725.22675-2-admin@netgeek.ovh>
         <fa5895ae62e0f9c1eb8f662295ca920d1da7e88f.camel@redhat.com>
         <Y8Am5wAxC48N12PE@quaddy.sgn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-01-12 at 16:27 +0100, Hervé Boisse wrote:
> On Thu, Jan 12, 2023 at 01:48:51PM +0100, Paolo Abeni wrote:
> > I'm unsure I read correctly the use case: teh user-space application is
> > providing an L2 header and is expecting the Linux stack to add a vlan
> > tag? Or the linux application is sending packets on top of a vlan
> > device and desire no tag on the egress packet? or something else?
> 
> The userland app does not care about the device being a VLAN one or not. Just a regular Ethernet device on which to send raw frames.
> This means the app provides a standard 14 byte Ethernet header on the socket and does not matter about any VLAN tag.
> 
> Then, the goal is to be able to alter those packets at the qdisc level with tc filters.
> But, when such packets are sent on top of a VLAN device whose real device does not support VLAN tx offloading, the bad position of the skb network header makes this task impossible.
> 
> To give a concrete example, here are few commands to show the problem easily:
> 
> # modprobe dummy
> # ip link add link dummy0 dummy0.832 type vlan id 832
> # tc qdisc replace dev dummy0.832 root handle 1: prio
> # tc filter del dev dummy0.832
> # tc filter add dev dummy0.832 parent 1: prio 1 protocol ip u32 match u8 0 0 action pedit pedit munge ip tos set 0xc0
> # ip link set dummy0 up
> # ip link set dummy0.832 up
> 
> Then start an application that uses AF_PACKET+SOCK_RAW sockets over the VLAN device:
> 
> # dhclient -v dummy0.832
> 
> If you look at the emitted packets on dummy0, you will see that the 0xc0 byte of the IPv4 TOS/DSCP field is not set.
> Instead, the 0xc0 tos byte is written 4 bytes too far, in the last byte of the IPv4 Identification field.

I understand, thanks. Still is not clear why the user-space application
would attach to dummy0.832 instead of dummy0.

With your patch the filter will match, but the dhcp packet will reach
the wire untagged, so the app will behave exactly as it would do
if/when attached to dummy0.

To me it looks like the dhcp client has a bad configuration (wrong
interface) and these patches address the issue in the wrong place
(inside the kernel).

Cheers,

Paolo

