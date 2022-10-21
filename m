Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2824E607E26
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 20:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJUSOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 14:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiJUSOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 14:14:19 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1021F26553E;
        Fri, 21 Oct 2022 11:14:18 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z97so8890683ede.8;
        Fri, 21 Oct 2022 11:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IWT32hn/5on9JQFLZ9CdZqyFkNpfjrGX5X1sBaET02U=;
        b=P9hSCaa39i9JGj/5fhpGAGKqV0qNaEhqet8DmdqurbIDP+fWwaBweSZJ3/S6bAi2DE
         p+eq7oKJ/RDCYh9wf+nabFJSnwsdceArXMizkG598uRi7agL1PsnxpKJR3QOGe9LGUsr
         zmlp8/3/NqI+V1i2nDa+LoUbsVbsT7TecGgNHY9btlLCVLiBhuGwippKH5FV3uy6EKQf
         py5P3IgoKNZRscRUy9euAQkfpmI26lMxdGlz6ZIjmzgrS22NPAK4YVPfYhIgDowxprq/
         ViQgGv3cTTio2/IhXMiDB1cCyYpWLgr0OA+yXjiHyGL9TQD3FZitvAZZYL5w3Dv4WD/K
         D/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IWT32hn/5on9JQFLZ9CdZqyFkNpfjrGX5X1sBaET02U=;
        b=0IIUGq2/m1jNRNM78VX6acbMB2gcrT5vIVpu2YM+fqxsuFSjn7DHk64uODO5K3Vr/s
         1NbbTt/fkBexvgfHZgVRmuTOh0REclXfv1/EfrwVhVoRFTmYD92SbIFqZ+HQJXURg1WM
         ZiapQJo4MG5w6hR+1qkIAhkMUVbK/TmPMRecxWE4JhQ5hb28Dqaho0UXDFXy5oeglaT7
         2k5ZkrpPkygbceUUCRxRGX+9RyrB/NHeaNfT4TBYZOS4tdkjvLc0FbhN3TjSA2C3EfUn
         1kQxYUuBHrJMBR8PiG0HCv+ARdlR0wRcw2wjK9qY67YsxsouVIpLJE5Nl6ve3l+6AmCa
         rcmg==
X-Gm-Message-State: ACrzQf3QDvrNObTuk9ocG726vZxN+AjStVT4H9OnkYZmv3gM8AyU1Fdz
        u78y+A5rHgBFhcRn3I5r9lM=
X-Google-Smtp-Source: AMsMyM7EHFMooNaoQGzQ5R9JFO+S5r0igTZjt4d8ThXihB+ZZ0Av9ErxITHmAdRMMZTwcRJFugdAAw==
X-Received: by 2002:a17:907:b05:b0:78d:9bc9:b96f with SMTP id h5-20020a1709070b0500b0078d9bc9b96fmr16306095ejl.468.1666376056317;
        Fri, 21 Oct 2022 11:14:16 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id kw15-20020a170907770f00b00741383c1c5bsm11797572ejc.196.2022.10.21.11.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 11:14:15 -0700 (PDT)
Date:   Fri, 21 Oct 2022 21:14:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221021181411.sv52q4yxr5r7urab@skbuf>
References: <20221020132538.reirrskemcjwih2m@skbuf>
 <2565c09bb95d69142522c3c3bcaa599e@kapio-technology.com>
 <20221020225719.l5iw6vndmm7gvjo3@skbuf>
 <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
 <20221021112216.6bw6sjrieh2znlti@skbuf>
 <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
 <20221021163005.xljk2j3fkikr6uge@skbuf>
 <d1fb07de4b55d64f98425fe66156c4e4@kapio-technology.com>
 <20221021173014.oit3qmpkrsjwzbgu@skbuf>
 <b88e331e016ad3801f1bf1a0dec507f3@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b88e331e016ad3801f1bf1a0dec507f3@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 07:39:34PM +0200, netdev@kapio-technology.com wrote:
> Well, with this change, to have MAB working, the bridge would need learning on
> of course, but how things work with the bridge according to the flags, they
> should also work in the offloaded case if you ask me. There should be no
> difference between the two, thus MAB in drivers would have to be with
> learning on.

Am I proposing for things to work differently in the offload and
software case, and not realizing it? :-/

The essence of my proposal was to send a bug fix now which denies
BR_LEARNING to be set together with BR_PORT_LOCKED. The fact that
link-local traffic is learned by the software bridge is something
unintended as far as I understand.

You tried to fix it here, and as far as I could search in my inbox, that
didn't go anywhere:
https://lore.kernel.org/netdev/47d8d747-54ef-df52-3b9c-acb9a77fa14a@blackwall.org/T/#u

I thought only mv88e6xxx offloads BR_PORT_LOCKED, but now, after
searching, I also see prestera has support for it, so let me add
Oleksandr Mazur to the discussion as well. I wonder how they deal with
this? Has somebody come to rely on learning being enabled on a locked
port?


MAB in offloading drivers will have to be with learning on (same as in
software). When BR_PORT_LOCKED | BR_LEARNING will be allowed together
back in net-next (to denote the MAB configuration), offloading drivers
(mv88e6xxx and prestera) will be patched to reject them. They will only
accept the two together when they implement MAB support.

Future drivers after this mess has been cleaned up will have to look at
the BR_PORT_LOCKED and BR_LEARNING flag in combination, to see which
kind of learning is desired on a port (secure, CPU based learning or
autonomous learning).

Am I not making sense?
