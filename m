Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371895A70E3
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 00:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiH3WgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 18:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiH3WgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 18:36:08 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEE765646;
        Tue, 30 Aug 2022 15:36:07 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e7so5312600ilc.5;
        Tue, 30 Aug 2022 15:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=isZjHDiHzy0/kCoZ8oyrkIrlQ2Sb2B/u+7KxfGkOIrg=;
        b=M2ytLh9nqpOk5aNDGrusWccSRNqzBtVzaKOkBdyrmC2dClHQsq+zjyo+JWrkCjtvXo
         0szu/HbqqKiJe5RB7DvwtRbLoWDytCDL1rYOTqRDGaUDel1hka0Alzbh4HOItM5Fvrbc
         S87EDc5cZSd2D8vyoWz7OIPW/8+/VX1OxhtuaCd7DNJ9aUTIzJUwWizcc5zAQ1Czbvey
         4FkqqN9iswFGY1jOZOupQcuv9DAA3bplvHniFmn+QAU3CHPQ23+06VsPvGqeWGjP+aG9
         sGiJwoRTYu27Xk9FcC5eo7whRBkXxPuFEQs4+SZ4BUaLJAPvoC86A2KZu6ONf/8+Pkon
         pT8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=isZjHDiHzy0/kCoZ8oyrkIrlQ2Sb2B/u+7KxfGkOIrg=;
        b=niSt4XmYAFrStWY2DztzkNZW0mPH06deUB8nkYqh/b33jGjbotVnUB6TugpyMsMxhZ
         Ml/z02fE7PMG3z3t0eClBUQRSIisetpp9I2eDwJrk30j3fpIaC4BlKnKSkhLS2eGYHqz
         OSPs2v1xsDBFdnAuDUuo+G7WFVFwRsD1kbccHUDUFdoRiOitCmMsrgRAeo9jlY2Qwngc
         tyIKGUUqy+bU979V/amcGOwIhDF2wJLVtuSBbEfoiJ2nCZ9VCkvekPDhO8Gb9odheC34
         SzockB/ng/lIhJVCjkjsdcMIXTDJiMmMSj56uf+bXYL9CiASUimxAklhoGCrHaO5XETt
         hVjA==
X-Gm-Message-State: ACgBeo0vDn4sb+p0TA9dBVG3+bDvoomXaklK6wycXViBryrBLnxwPKLb
        duoW2W4TiNpTvUQQ3yGkzScjqxtNPPZ2M0czX3bwcOwbyFOE4g==
X-Google-Smtp-Source: AA6agR7rSdwBgLwZzpdhwEuTG0ACljTRvp1d8M57LIvYdThqXcm7X6ETfUSUyUPkXQLvRMv0ugB9pIlNxqIipnW8Pbg=
X-Received: by 2002:a05:6e02:1a0b:b0:2df:5c44:9796 with SMTP id
 s11-20020a056e021a0b00b002df5c449796mr13760096ild.145.1661898966626; Tue, 30
 Aug 2022 15:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220719014704.21346-2-antonio@openvpn.net> <20220803153152.11189-1-antonio@openvpn.net>
 <CAHNKnsQnHAdxC-XhC9RP-cFp0d-E4YGb+7ie3WymXVL9N-QS6A@mail.gmail.com> <20220812114427.05f7393a@hermes.local>
In-Reply-To: <20220812114427.05f7393a@hermes.local>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 31 Aug 2022 01:35:54 +0300
Message-ID: <CAHNKnsRg_=QNoi1Uj748Tv7=KKy6pdF9R7mVM45m-99VoZCvmg@mail.gmail.com>
Subject: Re: [RFC v2] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Antonio Quartulli <antonio@openvpn.net>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Stephen,

On Fri, Aug 12, 2022 at 9:44 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Fri, 12 Aug 2022 21:34:33 +0300
> Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>> What is the purpose of creating and destroying interfaces via RTNL,
>> but performing all other operations using the dedicated netlink
>> protocol?
>>
>> RTNL interface usually implemented for some standalone interface
>> types, e.g. VLAN, GRE, etc. Here we need a userspace application
>> anyway to be able to use the network device to forward traffic, and
>> the module implements the dedicated GENL protocol. So why not just
>> introduce OVPN_CMD_NEW_IFACE and OVPN_CMD_DEL_IFACE commands to the
>> GENL interface? It looks like this will simplify the userspace part by
>> using the single GENL interface for any management operations.
>
> RTNL is netlink. The standard way to create network devices should
> be available with newlink message as in:
>
>  # ip link add dev myvpn type ovpn <options>

If you do not mind, then I would like to say that RTNL is not a
standard way, but a common way to create a virtual network interface.

The RTNL ability to create network devices is very useful for
standalone interface types (VLANs, GRE, etc.). But there are other
types that require much more care to be brought into a usable state.
E.g., WLAN devices can only be managed by GENL. Even L2TP that can be
created with ip(8) actually utilizes the GENL based interface and
completely ignores RTNL.

An OpenVPN network device created with ip-link(8) will remain useless
until the control daemon establishes a connection, negotiates params,
adds a peer, etc. And all these actions should be performed using a
separate GENL interface. I mean that the RTNL support in the OpenVPN
module is a dead-end.

That is why I suggested Antonio to save his time by ignoring the
network interface creation with RTNL and focus on the GENL interface.
Using only the GENL-based interface will also simplify development of
the control daemon. Does this strategy sound reasonable in this
particular context?

--
Sergey
