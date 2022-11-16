Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9179B62B352
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 07:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbiKPGej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 01:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbiKPGeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 01:34:13 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE276350
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 22:34:12 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id r18so15780996pgr.12
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 22:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7sDRpLdmqWlqw9y1I7Uwv2V53s1I6IJ54R+A4B1PuzY=;
        b=iYS17VRspUQqHDhXHxRpBwd8Wenoq/d7qY/oIiLFBgGrRZtVtefm4cDa5QXcl+EVPE
         sDlT4GIHYMeAlZgDOPsmIW8HXRFkoeZ28KuKL50UTaul1YleRv3Op40Kg/mdU5+Xs/P3
         AyiObIPjwfU0x59Z5sj6aPerJpWTHnU8jv1cPSajZ+9+QYU6a3X1vD6nwvZrOVc0mU2n
         vK2Ez4j2TujzCVlgFB90oPEvWNs8Tq5YlGkOYQ4eXVi0uom4PiB+q4/6gAjUqi7SpA1E
         D8aP8Sp92w3GG5KeZzosuN9lpFczyaN6JiaRwcICoKJ+wKXH7VZAQeFaz0wteLofyK98
         dyPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7sDRpLdmqWlqw9y1I7Uwv2V53s1I6IJ54R+A4B1PuzY=;
        b=OF2y631BxWs1Ot5EgsI/93ajVMXVYE16ud1agxMOqvgUltiEzofHLBC/FZ/7DhkxB0
         S9piITPcbZNB8f3kcttBZdvL/c4DnLCU39n1OjtPvrPTJdVCdoA/E7cm/rmkEU/AVxt3
         hL14Zo+gafUwN8s5rcNrm6DRmMWg9pNWaPA5si9aqnRYnklM0+GU1l3Tq8WDXoGV0hQc
         GX93yMWY9GQicKH3dsCvd5AvjE3upt9yi9M5oaCyZK/+zfnsUFi6lTs8PLRKlvRY3Xzl
         dDTOlVR20+oRKFS23nV8juR5JKqQmkVAU06F+F6UUrqjvYb4YOWB/XsVXGRKT2ALnvL5
         fVMw==
X-Gm-Message-State: ANoB5pl0dVxc9796tezWLJ4lLMsTiH6V+WS0fvdBinzGwbMKxEVDpWPX
        qRjW2T0Ey2HpDKa37WFZQMw=
X-Google-Smtp-Source: AA0mqf5h6Yl0gXFJ9xEdVpymg4TZC3gK9VqPZAVW+N3FtRgaXp69uvcLh87cJGNmKJrRyN0yjRePNw==
X-Received: by 2002:a62:e818:0:b0:56b:bba4:650a with SMTP id c24-20020a62e818000000b0056bbba4650amr22283755pfi.4.1668580452264;
        Tue, 15 Nov 2022 22:34:12 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i6-20020a17090332c600b0017a09ebd1e2sm11321483plr.237.2022.11.15.22.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 22:34:11 -0800 (PST)
Date:   Wed, 16 Nov 2022 14:34:06 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
Message-ID: <Y3SEXh0x4G7jNSi9@Laptop-X1>
References: <20221109014018.312181-1-liuhangbin@gmail.com>
 <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com>
 <17540.1668026368@famine>
 <CANn89i+eZwb3+JO6oKavj5yTi74vaUY-=Pu4CaUbcq==ue9NCw@mail.gmail.com>
 <19557.1668029004@famine>
 <CANn89iKW60QdMRbpyaYry4Vdfxm41ifh4qFt1azU5FCYkUJBiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKW60QdMRbpyaYry4Vdfxm41ifh4qFt1azU5FCYkUJBiA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 01:48:11PM -0800, Eric Dumazet wrote:
> On Wed, Nov 9, 2022 at 1:23 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
> >
> > Eric Dumazet <edumazet@google.com> wrote:
> > >Quite frankly I would simply use
> > >
> > >if (pskb_may_pull(skb, sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr))
> > > instead of  skb_header_pointer()
> > >because chances are high we will need the whole thing in skb->head later.
> >
> >         Well, it was set up this way with skb_header_pointer() instead
> > of pskb_may_pull() by you in de063b7040dc ("bonding: remove packet
> > cloning in recv_probe()") so the bonding rx_handler wouldn't change or
> > clone the skb.  Now, I'm not sure if we should follow your advice to go
> > against your advice.
> 
> Ah... I forgot about this, thanks for reminding me it ;)

Hi David,

The patch state[1] is Changes Requested, but I think Eric has no object on this
patch now. Should I keep waiting, or re-send the patch?

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20221109014018.312181-1-liuhangbin@gmail.com/

Thanks
Hangbin
