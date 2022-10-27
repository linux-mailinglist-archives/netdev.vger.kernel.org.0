Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050F46100C2
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbiJ0Syz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234709AbiJ0Syw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:54:52 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D551DA64
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:54:51 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id k2so7338725ejr.2
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BQuwvZ0/9dY0GWC1deK+iLpoPEtXJ8MjgV+KMyTr02w=;
        b=NCfVTe6aS2V3Ws5llhc9KTTRluD3vYBWdCqXDkYDwmBoJ3SdjE9FEOcEXUBo8Q3e37
         4eXavp7fRjCpWyEfttl+Ztf0TuQNrW6c/q1Y7niRRMTpNIceaWuVjPxz8mVhdhQ1Vmfu
         vx1mMlJ3y7ODhR4Qtr88kZY0+1vlJ3VKiLbzSw8VhhLXV5C31IKoUvbfPIQSj46u8FaX
         eOEAlTCU8FYjLrgTaTeQKCBNbWDm1WXuGATUKOBqHAAQ71JenLVAmrZEXB8Mo1JmyW/Y
         bKN0WGUzSjqgwBG8FcamOaLBzlSX5tbXGTArDnnVZWUJh9f2RoIpH7Mvu3hYFwZYrpwW
         QcEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQuwvZ0/9dY0GWC1deK+iLpoPEtXJ8MjgV+KMyTr02w=;
        b=E5oaAUH01Jt7Rj6Fo7AHb10yRYEofmC109t1ZSrdtOVrZSSGGgVPG5DIJw72R+gqEj
         GUsnk7X4D3Jv3GJcZuH5Cfx9Gs2OsYyWYaukelPo0OrZ2AsDEz2CF2YIdlGRQpqmTlvl
         v5WjSSPyJ6B+iTnIHHeeY5il+OQRgUFVfmz+qFe/gVOEmNnKEGtPBtdIbI+y66/tgv6I
         dFIwhBdETYiqfjhBhiDvyH9XlCU0yqHNN1NndudxX3r9FKtsJeEFMPIJrigZZWnfGbX8
         pu0Ga5NqSRgPRHg+G2HsbA4TPZnotwwLrO2saIw1iSgnm63BORXb99V+q+Qctj/vhOfs
         Xe6w==
X-Gm-Message-State: ACrzQf25/109YE7mHnTDc7oEvD1i6Sr0qlqAY8vFk/7AXZkeOqvs8LUx
        FDRnIazWE2g2ZIA3e1PzJbc=
X-Google-Smtp-Source: AMsMyM4ap7YbuxrL1NQi5tJE7hsFQkcGsDHQ2z8rHRJ4Fk+M2nB23RbvN6HPaeELj3VyFthEcsVQig==
X-Received: by 2002:a17:906:2681:b0:783:6a92:4c38 with SMTP id t1-20020a170906268100b007836a924c38mr44013035ejc.75.1666896889807;
        Thu, 27 Oct 2022 11:54:49 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id p25-20020a056402075900b00457b5ba968csm1404302edy.27.2022.10.27.11.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 11:54:49 -0700 (PDT)
Date:   Thu, 27 Oct 2022 21:54:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net
Subject: Re: [PATCH v5 net-next] net: ftmac100: support mtu > 1500
Message-ID: <20221027185447.kd6sqvf4xrdxis56@skbuf>
References: <20221024175823.145894-1-saproj@gmail.com>
 <20221027113513.rqraayuo64zxugbs@skbuf>
 <CABikg9z5uuo9qdcuR4p29Y6W=rGBQedUV4GWB2C+6=6APAtTNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9z5uuo9qdcuR4p29Y6W=rGBQedUV4GWB2C+6=6APAtTNQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 07:59:11PM +0300, Sergei Antonov wrote:
> On Thu, 27 Oct 2022 at 14:35, Vladimir Oltean <olteanv@gmail.com> wrote:
> > Does the attached series of 3 patches work for you? I only compile
> > tested them.
> 
> I have tested your patches. They fix the problem I have. If they can
> make it into mainline Linux - great. Thanks for your help!

Do you mind submitting these patches yourself, to get a better
understanding of the process? You only need to make sure that you
preserve the "From:" field (the authorship), and that below the existing
Signed-off-by line, you also add yours (to make it clear that the
patches authored by me were not submitted by me). Like this:

| From: Vladimir Oltean <vladimir.oltean@nxp.com>
| 
| bla bla
| 
| Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com> <- same as author
| Signed-off-by: Sergei Antonov <saproj@gmail.com> <- patch carried by X
| ...etc
| when patch is merged, the netdev maintainer adds his own sign off at
| the end to indicate that the patch went through his own hands

I would do the same if I was the one submitting the series; I would add
my sign-off to patch 3/3, which has your authorship.

> A remark on 0002-net-ftmac100-report-the-correct-maximum-MTU-of-1500.patch:
> I can not make a case for VLAN_ETH_HLEN because it includes 4 bytes
> from a switch and ftmac100 is not always used with a switch.

Why do you think that? What VLAN are you talking about? 802.1Q or
802.1ad? What VLAN ID? Where does it come from, where do you see it?

VLAN_ETH_HLEN in patch 2 has nothing to do with a switch. I tried to
preserve the functionality of the driver as best I could. It accepts
skb->len on TX up to 1518, and it drops in hardware packets with a
skb->len larger than 1514 on RX (this includes L2 header, and is
measured before the eth_type_trans() call; the latter consumes ETH_HLEN
bytes and thus, skb->len becomes 1500).

A VLAN in the real sense (ip link add link eth0 name eth0.100 type vlan id 100)
does not increase the MTU of eth0 specifically because the 802.1Q header
is part of the L2 overhead, and not part of the L2 payload. So this is
why drivers could have a valid reason to subtract the VLAN header length
from the maximum packet size (which is total L2 length).

There's no way, really, to reconcile the fact that the driver can
transmit VLAN-tagged frames with an L2 payload length of 1500 bytes but
it cannot receive them (or at least I think that it can't, based on what
you said; maybe the hardware is smart and makes an exception for the
VLAN header on RX, letting packets with a size of up to 1522 bytes
length + CRC to be accepted?). In any case, 1500 is the MTU value that
the driver supports as of patch 2 (given the definition of MTU as L2
payload length)  and I wanted to make that absolutely clear by bringing
in sync what is reported with what is supported, prior to making any
other change to the max_mtu.
