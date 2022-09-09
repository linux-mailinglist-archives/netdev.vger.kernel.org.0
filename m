Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5645B2E84
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 08:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiIIGJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 02:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiIIGJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 02:09:55 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E044067162
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 23:09:53 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t65so656490pgt.2
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 23:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=CrIdT/7dPd0gy1P4My4eeGW4QDYAuACsDJbpkmJSPEk=;
        b=EqRXsBRQLxfPAeK78SsNE2Xt7RoWLtToLObeh2UD0voQh3PjXFWvoppqaAxBRm1zal
         z2vtXAAMT10Ax/6jeSbZPriQB1I8Vr65nbhgoGH4fLm1qj9KFrPW1q1Lnwv1UblymRBT
         m7Bfi4BG2GY5kzllRMDX8BkCfRsAvepP/p1uQiHfDr0nK62rssqHF9yB9TwEz7Z52OlB
         k33EivXgbpcf3y/GWSHDlLIqHuMMAbuYxpdgH+iUXqQontel0AtWaM6cgi+V5mKS9N5x
         FEWP22VeDvzDBV6SWuE7TzulLyFYynRQ6ChkaWfWvg2c84sPKjudRHmhnaXl82H3yAn3
         NMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=CrIdT/7dPd0gy1P4My4eeGW4QDYAuACsDJbpkmJSPEk=;
        b=iDfAuCvI4q6cg3IitY9KuAwM/vbsFRVsmKlEsvXCPECKOXcgVkBr5Kl8r+159n64Iz
         jFZBNQlPklnRPceehygWREikpF52u8UbZfGizCndByO1UUfY8vzE2dmR+KexpWWwBDGW
         pBP1q5VPBgZGCWOJkpg3/IVF1kzXKPnlAMe+TyOk2f9x3FMflSFEKVWldA6Rfio/VO6w
         Q2VucfIJjmFR95oZxW01c7U2E2b4i3jn4fIbfPhOF6kzCNZe8iuxqdAzXMsvcQ0l0Lfk
         qP8ryazR9+Nk8d1Mx2UTLb7C5S0VqIujWu0JM4hOiwEFyVdbhV3lGtR/6nepY4TsJ4no
         XhYQ==
X-Gm-Message-State: ACgBeo1eSIG9KfzLirzw48bomo/ZzIo4Vlvodk0r4ZpOiQMwc4ZQTkkb
        cE/FTmx8D4k/SHOc95B4klou1jrR1dI=
X-Google-Smtp-Source: AA6agR7y5SXUqvXZLcSxeRGo2n6d6uCeFsvcg4KDGnr2TLfa8Dv65lk4SiDazFKdo1D0frqKOC+hyQ==
X-Received: by 2002:a63:e516:0:b0:434:9462:69cd with SMTP id r22-20020a63e516000000b00434946269cdmr10190625pgh.503.1662703793251;
        Thu, 08 Sep 2022 23:09:53 -0700 (PDT)
Received: from localhost ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id u10-20020a62d44a000000b0053e4cfc5440sm722663pfl.29.2022.09.08.23.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 23:09:52 -0700 (PDT)
Date:   Fri, 9 Sep 2022 15:09:50 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Message-ID: <YxrYrhSRayY03ahF@d3>
References: <20220906082907.5c1f8398@hermes.local>
 <20220906164117.7eiirl4gm6bho2ko@skbuf>
 <20220906095517.4022bde6@hermes.local>
 <20220906191355.bnimmq4z36p5yivo@skbuf>
 <YxeoFfxWwrWmUCkm@lunn.ch>
 <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
 <20220908125117.5hupge4r7nscxggs@skbuf>
 <403f6f3b-ba65-bdb2-4f02-f9520768b0f6@kernel.org>
 <20220908072519.5ceb22f8@hermes.local>
 <20220908161104.rcgl3k465ork5vwv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220908161104.rcgl3k465ork5vwv@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-08 16:11 +0000, Vladimir Oltean wrote:
> On Thu, Sep 08, 2022 at 07:25:19AM -0700, Stephen Hemminger wrote:
> > On Thu, 8 Sep 2022 08:08:23 -0600 David Ahern <dsahern@kernel.org> wrote:
> > > > Proposing any alternative naming raises the question how far you want to
> > > > go with the alternative name. No user of DSA knows the "conduit interface"
> > > > or "management port" or whatnot by any other name except "DSA master".
> > > > What do we do about the user-visible Documentation/networking/dsa/configuration.rst,
> > > > which clearly and consistently uses the 'master' name everywhere?
> > > > Do we replace 'master' with something else and act as if it was never
> > > > named 'master' in the first place? Do we introduce IFLA_DSA_MGMT_PORT as
> > > > UAPI and explain in the documentation "oh yeah, that's how you change
> > > > the DSA master"? "Ahh ok, why didn't you just call it IFLA_DSA_MASTER
> > > > then?" "Well...."
> > > > 
> > > > Also, what about the code in net/dsa/*.c and drivers/net/dsa/, do we
> > > > also change that to reflect the new terminology, or do we just have
> > > > documentation stating one thing and the code another?
> > > > 
> > > > At this stage, I'm much more likely to circumvent all of this, and avoid
> > > > triggering anyone by making a writable IFLA_LINK be the mechanism through
> > > > which we change the DSA master.  
> > > 
> > > IMHO, 'master' should be an allowed option giving the precedence of
> > > existing code and existing terminology. An alternative keyword can be
> > > used for those that want to avoid use of 'master' in scripts. vrf is an
> > > example of this -- you can specify 'vrf <device>' as a keyword instead
> > > of 'master <vrf>'
> > 
> > Agreed, just wanted to start discussion of alternative wording.
> 
> So are we or are we not in the clear with IFLA_DSA_MASTER and
> "ip link set ... type dsa master ..."? What does being in the clear even
> mean technically, and where can I find more details about the policy
> which you just mentioned? Like is it optional or mandatory, was there
> any public debate surrounding the motivation for flagging some words,
> how is it enforced, are there official exceptions, etc?

There are more details in
Documentation/process/coding-style.rst, end of §4.
