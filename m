Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4036B408B
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 14:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjCJNg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 08:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCJNg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 08:36:57 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03C210D329;
        Fri, 10 Mar 2023 05:36:55 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id cy23so20404638edb.12;
        Fri, 10 Mar 2023 05:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678455414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fF6dAIDj+uVyHBsn9QKyWfa4FJOS/uyNw5ttJ+sPzcQ=;
        b=qiTEvhVQnsW5MRh9NLhcq+ddgbRUPLD2t9GyEBSuvp+P3qubK1AESBPhuBAFzipIls
         EJE+J1P1MbRI3rguCmBi66b61coWbUgSj9/8LmbGkIcmKl+SN3acMn3U1qsueFnl/u/0
         JBefRnOBzx1ZiHgeLWQUTMZv7tzPw4b7JKP5hSETiQQdfiKgnH2Rr2e0qu1hbmc30tQU
         CLzTc+VrBRiwDUvrtWqKOAMN16db8LcMAfBWNhpPtrwBb3nOKAlJKA9DAdzY2v0gs4BI
         udOhvzz+J8U1tTlxumNzECZrGLbKtXCPvkIabgzKn3I8BpbfzXyJsBtmbofbWL0/0aph
         QLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678455414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fF6dAIDj+uVyHBsn9QKyWfa4FJOS/uyNw5ttJ+sPzcQ=;
        b=eq8y99fDQR4flqwEBZyf8UrBwZpNQpw/3jc0Zzuuut2RRiHE7sONqDccaA4FbrddUP
         Z5wi4hrEtOyMohJoDExWwHx0HiQJIJ1qPjzdN6iioA8Ry3MmBNVkxGfz0FtkwrcoTwxJ
         jWwiqUFHuikL03N/PSEi3cIdl1Nrs2/ZZxWh2q7cwU4amCSAnUM5hTR91dpNz7vAvapd
         Peds6YGEzlNaSDSZuozdVIypDj3dbGX2MrkAertbuo7FtHwU+fv3n2F5hMF3wW7SEOk0
         T+40iFfmqgCKWE32pG/2lXg8Vvt67quTHkpZDDva/3TFOQtm/4oZk70qsfrOG1iXOZhq
         gpwA==
X-Gm-Message-State: AO0yUKVSKBTAsideaupqVJdcuiqY515DGL1hGEp1KssoHx3Qexyg++yz
        sz2YDhkHn3QBjAOiEafLEso=
X-Google-Smtp-Source: AK7set8XCaYfUjVa92XaxkgsXmYJ94mXtcsadsofsX0yKl9NVjm8XURygRCBdhsXh0qjgSsniqj7Tg==
X-Received: by 2002:a50:ec96:0:b0:4af:59c0:744a with SMTP id e22-20020a50ec96000000b004af59c0744amr25297197edr.24.1678455414168;
        Fri, 10 Mar 2023 05:36:54 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id 12-20020a508e4c000000b004af720b855fsm19949edx.82.2023.03.10.05.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 05:36:53 -0800 (PST)
Date:   Fri, 10 Mar 2023 15:36:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] dsa: marvell: Provide per device information about
 max frame size
Message-ID: <20230310133651.pfqldx6jdgssbe54@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-2-lukma@denx.de>
 <20230310120235.2cjxauvqxyei45li@skbuf>
 <20230310141719.7f691b45@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310141719.7f691b45@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 02:17:19PM +0100, Lukasz Majewski wrote:
> > > For example mv88e6185 supports max 1632 bytes, which is now
> > > in-driver standard value.  
> > 
> > What is the criterion based on which 1632 is the "in-driver standard
> > value"?
> 
> It comes from the documentation I suppose. Moreover, this might be the
> the "first" used value when set_max_mtu callback was introduced.

I'm not playing dumb, I just don't understand what is meant by
"in-driver standard value". Is it the return value of mv88e6xxx_get_max_mtu()
for the MV88E6185 chip? Because I understood it to be somehow the value
returned by default, for chips which don't have a way to change the MTU
(because of the "standard" word).

> > > On the other hand - mv88e6250 supports 2048 bytes.  
> > 
> > What you mean to suggest here is that, using the current
> > classification from mv88e6xxx_get_max_mtu(), mv88e6250 falls into the
> > "none of the above" bucket, for which the driver returns 1522 -
> > VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN // 1492. But it truly
> > supports a maximum frame length of 2048, per your research.
> > 
> 
> And this cannot be easily fixed.
> 
> I could just provide callback to .set_max_frame_size in mv88e6250_ops
> and the mv88e6250 would use 1632 bytes which would prevent errors.
> 
> However, when I dig deeper - it turned out that this value is larger.
> And hence I wanted to do it in "right way".

Correct, I'm not debating this. I'm just saying, as a reader of this
patch set in linear order, that the justification is not obvious.

> > I have also noticed that you have not acted upon my previous review
> > comment:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20230106101651.1137755-1-lukma@denx.de/
> > 
> > | 1522 - 30 = 1492.
> > | 
> > | I don't believe that there are switches which don't support the
> > standard | MTU of 1500 ?!
> > | 
> > | >  		.port_base_addr = 0x10,
> > | >  		.phy_base_addr = 0x0,
> > | >  		.global1_addr = 0x1b,
> > | 
> > | Note that I see this behavior isn't new. But I've simulated it, and
> > it | will produce the following messages on probe:
> > | 
> > | [    7.425752] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY
> > [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL) | [
> >   7.437516] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU
> > to 1500 on port 0 | [    7.588585] mscc_felix 0000:00:00.5 swp1
> > (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514
> > SyncE] (irq=POLL) | [    7.600433] mscc_felix 0000:00:00.5: nonfatal
> > error -34 setting MTU to 1500 on port 1 | [    7.752613] mscc_felix
> > 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:00.3:12] driver
> > [Microsemi GE VSC8514 SyncE] (irq=POLL) | [    7.764457] mscc_felix
> > 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 2 | [
> > 7.900771] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY
> > [0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=POLL) | [
> >   7.912501] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU
> > to 1500 on port 3 | | I wonder, shouldn't we first fix that, and
> > apply this patch set afterwards?
> > 
> > I guess I will have to fix this now, since you haven't done it.
> 
> I do agree with Russel's reply here.

It's possible that Russell might have slightly misunderstood my quoted
reply here, because he said something about a PHY.

> Moreover, as 6250 and 6220 also have max frame size equal to 2048
> bytes, this would be fixed in v6 after getting the "validation"
> function run.

The problem with this kind of fix is that it should go to the "net" tree;
it removes a user-visible warning that could have been avoided.

OTOH, the kind of "fix" for 6250 and 6220 is different. It is
sub-optimal use of hardware capabilities. That classifies as net-next
material.

The 2 go to different kernel branches.

> This is the "patch 4" in the comment sent by Russel (to fix stuff which
> is already broken, but it has been visible after running the validation
> code):
> 
> https://lists.openwall.net/netdev/2023/03/09/233

I will get there.. eventually.
