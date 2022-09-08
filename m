Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A1D5B23B7
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiIHQjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIHQjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:39:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741E41F601
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 09:39:34 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so2873764pja.4
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 09:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=OwHciG7ex8dodC3J/5yHv+BVmz6SUa+eNOifiznwE3c=;
        b=b+ZBF/kmaH3qKs5QEp3zt4TWY6dc6aB5pwk6RGl05nYn0ukkOlEx/a9z1g7KcnfRvX
         cGbN++NgjcJRDMSdtqQcJdDh4imu7KfYkR16yTMAVTO4fDRZBBh2Pacw15B5pG7yVTmF
         wHWhGZq0ET0016AHUG27keeiE0+Wt/RCEM5JOQ5LUXcJf4TFTRblUxTR1ZB6HJQoCoXS
         jjDDo189lq9fmz5LkRanAHZKLJxIjEIy6K2QL4W4bcoJ1CI9c7H942WG4rx7PmvIR8su
         Dk+dxAEkIHkuMbfVhHxttLvkuQvCeZGyVzg+odJ3Elbg8cqUwIPU2+pxAgPvkEKTUHBm
         ko/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=OwHciG7ex8dodC3J/5yHv+BVmz6SUa+eNOifiznwE3c=;
        b=YsBVgZxDDb1ojcmWMDwQDfFVnGuFAtQEdUuCyatS1k296gQdd0ZzlvlWnQshJsXOrx
         J0MDofLO/l5nMl3XtcDAuJxQT8fPzzXBDqvVI7vECQ1HcoB1m3Ri4dbRIBEjm4nHVMzO
         eP+OpbBzHiINge1aOtTJhAtk+sov2e3W5/5wMyX2/uiDOCF61ztBP1hgqOKFdcDXF0W/
         Q1Nemr9T+M0xZrY5ocmL8Q3s0qp1qPU6aL82kiDsarKHgxJOPhDMb+AzFjhP7JP8k7tD
         o7xmtif3ddWUpiN+/CZudQB8IapJChLQT1At/7KrA0Quo5MJbyc7Sq5eCjNOFOlRW1mv
         6MoQ==
X-Gm-Message-State: ACgBeo3vWt1yMBW8W3xlqzEjQyEZGeBxdx8e1I9fB6L0QYdLBs0eFTxj
        OmnORyIAvLAi46wdR8AXbTsnvCrP8OLuPA==
X-Google-Smtp-Source: AA6agR6uWy7WTQ0lF8oQqbn7YzQ0jYb2MXQbJwHE7UONXm6OH8jOmRl3xOtr0NhmrM8V4jgykQjNGQ==
X-Received: by 2002:a17:902:b681:b0:176:6471:8ee6 with SMTP id c1-20020a170902b68100b0017664718ee6mr9863927pls.8.1662655173816;
        Thu, 08 Sep 2022 09:39:33 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id 4-20020a620504000000b00537b1aa9191sm15415174pff.178.2022.09.08.09.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 09:39:33 -0700 (PDT)
Date:   Thu, 8 Sep 2022 09:39:31 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change
 DSA master
Message-ID: <20220908093931.7034067b@hermes.local>
In-Reply-To: <857e2dd4-cbc6-613c-c8e1-b3ff5d13dc47@gmail.com>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
        <20220906082907.5c1f8398@hermes.local>
        <20220906164117.7eiirl4gm6bho2ko@skbuf>
        <20220906095517.4022bde6@hermes.local>
        <20220906191355.bnimmq4z36p5yivo@skbuf>
        <YxeoFfxWwrWmUCkm@lunn.ch>
        <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
        <20220908125117.5hupge4r7nscxggs@skbuf>
        <403f6f3b-ba65-bdb2-4f02-f9520768b0f6@kernel.org>
        <20220908072519.5ceb22f8@hermes.local>
        <20220908161104.rcgl3k465ork5vwv@skbuf>
        <857e2dd4-cbc6-613c-c8e1-b3ff5d13dc47@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Sep 2022 09:35:03 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> On 9/8/2022 9:11 AM, Vladimir Oltean wrote:
> > On Thu, Sep 08, 2022 at 07:25:19AM -0700, Stephen Hemminger wrote:  
> >> On Thu, 8 Sep 2022 08:08:23 -0600 David Ahern <dsahern@kernel.org> wrote:  
> >>>> Proposing any alternative naming raises the question how far you want to
> >>>> go with the alternative name. No user of DSA knows the "conduit interface"
> >>>> or "management port" or whatnot by any other name except "DSA master".
> >>>> What do we do about the user-visible Documentation/networking/dsa/configuration.rst,
> >>>> which clearly and consistently uses the 'master' name everywhere?
> >>>> Do we replace 'master' with something else and act as if it was never
> >>>> named 'master' in the first place? Do we introduce IFLA_DSA_MGMT_PORT as
> >>>> UAPI and explain in the documentation "oh yeah, that's how you change
> >>>> the DSA master"? "Ahh ok, why didn't you just call it IFLA_DSA_MASTER
> >>>> then?" "Well...."
> >>>>
> >>>> Also, what about the code in net/dsa/*.c and drivers/net/dsa/, do we
> >>>> also change that to reflect the new terminology, or do we just have
> >>>> documentation stating one thing and the code another?
> >>>>
> >>>> At this stage, I'm much more likely to circumvent all of this, and avoid
> >>>> triggering anyone by making a writable IFLA_LINK be the mechanism through
> >>>> which we change the DSA master.  
> >>>
> >>> IMHO, 'master' should be an allowed option giving the precedence of
> >>> existing code and existing terminology. An alternative keyword can be
> >>> used for those that want to avoid use of 'master' in scripts. vrf is an
> >>> example of this -- you can specify 'vrf <device>' as a keyword instead
> >>> of 'master <vrf>'  
> >>
> >> Agreed, just wanted to start discussion of alternative wording.  
> > 
> > So are we or are we not in the clear with IFLA_DSA_MASTER and
> > "ip link set ... type dsa master ..."? What does being in the clear even
> > mean technically, and where can I find more details about the policy
> > which you just mentioned? Like is it optional or mandatory, was there
> > any public debate surrounding the motivation for flagging some words,
> > how is it enforced, are there official exceptions, etc?  
> 
> The "bonding" driver topic has some good context:
> 
> https://lkml.iu.edu/hypermail/linux/kernel/2010.0/02186.html

On another mail thread, discussed naming with the IEEE 802 committee.
And they said master/slave is not used in either the current version
of the bridging or bonding standards.
