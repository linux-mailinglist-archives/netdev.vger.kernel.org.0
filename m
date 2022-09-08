Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519EC5B2077
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 16:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiIHOZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 10:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiIHOZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 10:25:23 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6D56B160
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 07:25:21 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so2505288pjq.3
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 07:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=SfbCbstGSgSTIymZqpfwCMcXUpAqczGKrm1mzKtCkG8=;
        b=zoE+T2rDxvhBCz1XUMJC3KAjG7vekx1iowtXHR29X4/UvVGP5Y8VX4SJV4ryZaQFMh
         bWkdT+cG7QqkqkSMiADnYH83SF1X2hHSsSp27NuoVsUpywB7U2vV5N0B/DpMhH6SAJxh
         jdLNcsdqjq6hinj7Q+6LdPKEkHG5dLKZ3pMiXbVTgHGOSfyU9gsmHRfnjbrCV/LwCWcU
         sGTsyp11VflNCMhRTmGE+nupSM6DEK9XTmnE80x6MmtkoI6SlPej+vCvSouRZu7itCYO
         CqtZbf16ECLEwmBxPpfDEsrn7BaGYFKnQ6w+cR9YuzcExn8QzEuRl5jhir48zMU201eR
         UNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=SfbCbstGSgSTIymZqpfwCMcXUpAqczGKrm1mzKtCkG8=;
        b=SGnCKzR/gTTXG+SVpo1NWmdirLDRp2W3ixObS3IDEIg+9L8e1mnqMpF4IoilaFuLNj
         oGKBIWIBZJ1UFpTTj+ZLT31ZFAvGHKc61J9exoV3dbaoOMT3u+uUCeMiLHMwRZOLFYId
         RrXN0/q6AvsmgSz0zG8FYrCUXnKHpGQhWH3b2fFq88qeFV9a2PbAVkHE9NRdODaGt16t
         EwQ9Mm8EYjYHTAqO2nLZLx5wZ/tA7wi1IHPpkSqH7yCwVPHx85iTMTS0Eqdjc6+afJa7
         pv7HgIEBTYT2hZEPUlC+KDb0Qr19UzJCMB1mrr7PW3bbS2UrGb+PGSxFb3yEZlhLGBIG
         Vjeg==
X-Gm-Message-State: ACgBeo0dUSUJeU0hPXnVnkKoJLUpmeruZwYe3BBx/OqXr9TzfI2en5OC
        rGQCGL8NMmg8eIrFqcda+DGbwA==
X-Google-Smtp-Source: AA6agR5QgI8Xix9wXWtyWKpr9YmjsN3mGxxYVDQOppQzI/ajtQb22SiqFcBtku41m0mPAFvbLtN+VA==
X-Received: by 2002:a17:90b:4c04:b0:200:5769:22ef with SMTP id na4-20020a17090b4c0400b00200576922efmr4583006pjb.6.1662647121015;
        Thu, 08 Sep 2022 07:25:21 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f21-20020aa79695000000b00540a346477csm1571379pfk.76.2022.09.08.07.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:25:20 -0700 (PDT)
Date:   Thu, 8 Sep 2022 07:25:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change
 DSA master
Message-ID: <20220908072519.5ceb22f8@hermes.local>
In-Reply-To: <403f6f3b-ba65-bdb2-4f02-f9520768b0f6@kernel.org>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
        <20220906082907.5c1f8398@hermes.local>
        <20220906164117.7eiirl4gm6bho2ko@skbuf>
        <20220906095517.4022bde6@hermes.local>
        <20220906191355.bnimmq4z36p5yivo@skbuf>
        <YxeoFfxWwrWmUCkm@lunn.ch>
        <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
        <20220908125117.5hupge4r7nscxggs@skbuf>
        <403f6f3b-ba65-bdb2-4f02-f9520768b0f6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Sep 2022 08:08:23 -0600
David Ahern <dsahern@kernel.org> wrote:

> > 
> > Proposing any alternative naming raises the question how far you want to
> > go with the alternative name. No user of DSA knows the "conduit interface"
> > or "management port" or whatnot by any other name except "DSA master".
> > What do we do about the user-visible Documentation/networking/dsa/configuration.rst,
> > which clearly and consistently uses the 'master' name everywhere?
> > Do we replace 'master' with something else and act as if it was never
> > named 'master' in the first place? Do we introduce IFLA_DSA_MGMT_PORT as
> > UAPI and explain in the documentation "oh yeah, that's how you change
> > the DSA master"? "Ahh ok, why didn't you just call it IFLA_DSA_MASTER
> > then?" "Well...."
> > 
> > Also, what about the code in net/dsa/*.c and drivers/net/dsa/, do we
> > also change that to reflect the new terminology, or do we just have
> > documentation stating one thing and the code another?
> > 
> > At this stage, I'm much more likely to circumvent all of this, and avoid
> > triggering anyone by making a writable IFLA_LINK be the mechanism through
> > which we change the DSA master.  
> 
> IMHO, 'master' should be an allowed option giving the precedence of
> existing code and existing terminology. An alternative keyword can be
> used for those that want to avoid use of 'master' in scripts. vrf is an
> example of this -- you can specify 'vrf <device>' as a keyword instead
> of 'master <vrf>'

Agreed, just wanted to start discussion of alternative wording.
