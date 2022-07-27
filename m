Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4775828DC
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbiG0Op4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiG0Opz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:45:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36586B1D0
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 07:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658933153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UPwTphlEofW1gzVyQij5B8duPZwdaVcNitr1RayVqqU=;
        b=IcX5LYesOJLmKfbHOMjFsABILoaZw4n710JmahF7dySwZENvZCyobsOPGIajqNEA6m6YpY
        0TEQ/SSjnnCGcdIuTJ/rCtR50K6aWP51YJ1kPNWU50XN0aYH5uqqKPCMpTV5aP357U4xTn
        l8EJMcFqzCtJxSdTwSuoH8Ah6QYVQIo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-naKc7L-OPTCXptNwGx5UXw-1; Wed, 27 Jul 2022 10:45:52 -0400
X-MC-Unique: naKc7L-OPTCXptNwGx5UXw-1
Received: by mail-wr1-f71.google.com with SMTP id s24-20020adf9798000000b0021ed3f3dd75so522109wrb.15
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 07:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UPwTphlEofW1gzVyQij5B8duPZwdaVcNitr1RayVqqU=;
        b=QFaBTYneolGZrFYv2i85x9W2YjMLGkc0hDng8IHDzqav6kcKpMf0XOMeppSe0GL1Iy
         MpHVTUEOXhCn4FKfbrB0zYz7i+n+hA7axxuv/+RTg+mcOWZm9wWLBb1fnadSGzxTu2zq
         KRkcRhWHvNHgdyOK2Jfw5fxEYyPV7OFDPShdry8HB1C644iUa9K+gNegUedezXzanRx6
         pRS5g4jPhBoK7bf+HLgbrE4xIqetCc7KXf8T8kW5dY8UT/yRxh4H1BEugD6UMsrPsee/
         g/56LBp02osBjtDHDHwtUtcbBwKN+8sVQodGwqc+BplmUeiK2nRkdgESG/oYLbWOoWzz
         dDVQ==
X-Gm-Message-State: AJIora9r+fdGor9ds4RHukfX9KyR9o5P4ktPqfrgrwpkBApgmxDeha74
        YJOdAsIizcRfFXyHMyFe3DVpO5sc07IfSBSi9NeYNhCXZANEsitF/Pi9R4DgPZ6AI6CWNC/3Biu
        OsTNYIPynLdUp8UgG
X-Received: by 2002:a05:600c:3ac4:b0:3a3:19c5:7cb2 with SMTP id d4-20020a05600c3ac400b003a319c57cb2mr3399336wms.63.1658933150780;
        Wed, 27 Jul 2022 07:45:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s6EJaKWyltBC+mMZ+ewmsTuEWGKm93G14zzMdF0IwF3w4YCkILjcZ/BxC2B1sq/Pb8+8Hg6Q==
X-Received: by 2002:a05:600c:3ac4:b0:3a3:19c5:7cb2 with SMTP id d4-20020a05600c3ac400b003a319c57cb2mr3399327wms.63.1658933150598;
        Wed, 27 Jul 2022 07:45:50 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id h18-20020a05600c351200b003a31df6af2esm2693291wmq.1.2022.07.27.07.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 07:45:50 -0700 (PDT)
Date:   Wed, 27 Jul 2022 16:45:48 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nicolas.dichtel@6wind.com,
        eyal.birger@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 net-next] geneve: fix TOS inheriting for ipv6
Message-ID: <20220727144548.GB31646@pc-4.home>
References: <20220724003741.57816-1-matthias.may@westermo.com>
 <20220724003741.57816-3-matthias.may@westermo.com>
 <20220725170519.GD18808@pc-4.home>
 <712bcd84-4dbe-67a6-afa9-ddc01ea27cc8@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <712bcd84-4dbe-67a6-afa9-ddc01ea27cc8@westermo.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 06:29:56PM +0200, Matthias May wrote:
> On 25/07/2022 19:05, Guillaume Nault wrote:
> > On Sun, Jul 24, 2022 at 02:37:41AM +0200, Matthias May wrote:
> > > The current code uses the RT_TOS macro to cut off the 6 DSCP
> > > bits, down to the original 3 TOS bits.
> > > 
> > > Do not use this macro to get the prio for inheriting purposes.
> > 
> > Honestly, this patch is a bug fix and is suitable for the net tree
> > (with appropriate 'Fixes' tag).
> > 
> > Ideally, we'd also fix ip6_dst_lookup_tunnel() (used by bareudp
> > tunnels) and vxlan6_get_route().
> > 
> > Also, mlx5e_tc_tun_update_header_ipv6() and
> > mlx5e_tc_tun_create_header_ipv6() both call RT_TOS() inside
> > ip6_make_flowinfo() and certainly need to be fixed too.
> > 
> 
> Hi Guillaume
> How would i do that?
> Send a v2 to net with the fixes tag on 95caf6f71a999?
> Or just resend to net with the fixes tag on 95caf6f71a999?
> Since there are no actual changes to the patch.

Hi Matthias,

Ideally, send a patch series to net that'd removes RT_TOS() from the
ip6_make_flowinfo() calls in geneve, vxlan and bareudp (one patch for
each protocol, with the appropriate Fixes tag). You can add the IPv4
patch in that series or send it separately, as you see fit.

Alternatively you can just repost this series to net, with a proper
Fixes tag for each patch (and I'll take care of vxlan and bareudp in
a future series).

> This kind of contradicts the statement that IPv4 and IPv6 should behave the same.
> --> v6 would be fixed, but v4 not.

I personally consider the current IPv4 behaviour for TOS inherit option
to be a bug, so, in this case, we can have both IPv4 and IPv6 fixed in
the same tree.

But generally speaking, we have some divergence in how IPv4 and IPv6
treat tos/dsfield. That's because of some historical reasons and it's
not easy to reconciliate both implementations (because of backward
compatibility).

> BR
> Matthias



