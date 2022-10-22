Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02482608DBE
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 16:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJVOuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 10:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJVOt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 10:49:59 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3457EFD7;
        Sat, 22 Oct 2022 07:49:57 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a67so15961467edf.12;
        Sat, 22 Oct 2022 07:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FXANfOozsR8ZWtJEknyWv/BQc+quoG2zfT6HYPTQF5o=;
        b=YsopUazClirccbXPzAAfSeCAEE5h62Jqu8W0jsjUhsLNTN4dTn2w3UC1YFTUZuuPsa
         gHYXm/WHBKBdbp/XSQlQEaSuIWH1HNSAJXf89FQlBbUHnaNSXBszl/t4S7BjnH7NIp5M
         SXjEuGavThZDBG4/N61IpZztZU3VbzNQGVDaMHz3xX/N6e2q8JMQSWq1C7NDLPWw3Qqg
         O8l2UrYfhr3z9jAF9gEItJkagPBvjQUHHyOdgQ+P8zJJbXwWqFCWEnh59t8KavBc6QWQ
         INpXNlK29ET+d6gO6F8VCgKinp7DkXi+bsnDX2sZxrwNnX9V964X/O34lX+1e7IQkchk
         uuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FXANfOozsR8ZWtJEknyWv/BQc+quoG2zfT6HYPTQF5o=;
        b=SqkQxTAVTcf1lE+0L50joNCbjoiwxLLbT+WPooSsbP1c21SIJk4SSg7CuIZ5nWVXmL
         Rnz3KRW4pnuch0E663qphdnBQ+A+75DuqPOipKcoa2l3lw0hLh4+X/nsrZECCROsw+R+
         yvWftCmquLnQVdHIuEkx/VQuShAsUjCrBuaJBzUDoYYNgRjYofGfgvr3qm4QAelCgFjE
         ++qUrupPIgRrgjl3iAwWupdfprYhwBz2dvP1MAziMjAvC+vfVoHzmZRZlOh1PacXtFd9
         AbmSqjmFTqa7rWusiJBrOrub8SJOB9dDXHNfIqL9iPDLYo5aDLwDQJSZlHqz1Ec7igKv
         H0jw==
X-Gm-Message-State: ACrzQf04kGMKkwHKkp94VMPwJhgFTuOA602H6xqck5TWD0EDxcw2f6oh
        pYstnO+GXqrY2FwDzvT9fr0=
X-Google-Smtp-Source: AMsMyM4r60hxK1s59BiS5G0AlmT5m7tS1FwRfTCOCXlg6bUPLgP+Hx9y5QBGUNw+ku2VFA6Qeh7sAA==
X-Received: by 2002:a17:907:7d8b:b0:78e:2534:4fd3 with SMTP id oz11-20020a1709077d8b00b0078e25344fd3mr20714928ejc.141.1666450195961;
        Sat, 22 Oct 2022 07:49:55 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id y16-20020a056402171000b0044e937ddcabsm217699edu.77.2022.10.22.07.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 07:49:55 -0700 (PDT)
Date:   Sat, 22 Oct 2022 17:49:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@kapio-technology.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org,
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
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221022144951.v2twgp2lcnhnbhrv@skbuf>
References: <20221020225719.l5iw6vndmm7gvjo3@skbuf>
 <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
 <20221021112216.6bw6sjrieh2znlti@skbuf>
 <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
 <20221021163005.xljk2j3fkikr6uge@skbuf>
 <d1fb07de4b55d64f98425fe66156c4e4@kapio-technology.com>
 <20221021173014.oit3qmpkrsjwzbgu@skbuf>
 <b88e331e016ad3801f1bf1a0dec507f3@kapio-technology.com>
 <20221021181411.sv52q4yxr5r7urab@skbuf>
 <Y1P0/gYdvrk+W866@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1P0/gYdvrk+W866@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 22, 2022 at 04:49:50PM +0300, Ido Schimmel wrote:
> I will try to summarize what I learned from past discussions because I
> think it is not properly explained in the commit messages.
> 
> If you look at the hostapd fork by Westermo [1], you will see that they
> are authorizing hosts by adding dynamic FDB entries from user space, not
> static ones. Someone from Westermo will need to confirm this, but I
> guess the reasons are that a) They want hosts that became silent to lose
> their authentication after the aging time b) They want hosts to lose
> their authentication when the carrier of the bridge port goes down. This
> will cause the bridge driver to flush dynamic FDB entries, but not
> static ones. Otherwise, an attacker with physical access to the switch
> and knowledge of the MAC address of the authenticated host can connect a
> different (malicious) host that will be able to communicate through the
> bridge.

Not only is it not well explained, but Hans said back in February that
"in the common case you will want to use static entries":
https://lore.kernel.org/lkml/867da5viak.fsf@gmail.com/

> 
> In the above scenario, learning does not need to be on for the bridge to
> populate its FDB, but rather for the bridge to refresh the dynamic FDB
> entries installed by hostapd. This seems like a valid use case and one
> needs a good reason to break it in future kernels.

Before suggesting any alternatives, I'd like to know more details about
how this will work in practice, because I'm aware of the limitations
that come with DSA not syncing its hardware FDB with the software bridge.

So you add a dynamic FDB entry from user space, it gets propagated to
hardware via SWITCHDEV_FDB_ADD_TO_DEVICE, and from there on, they have
completely independent ageing timers.

You'll still suffer interruptions in authorization, if the software FDB
entry expires because it was never refreshed (which will happen if
traffic is forwarded autonomously and not seen by software). And at this
stage, you could just add static FDB entries which you periodically
delete from user space, since the effect would be equivalent.

If the mitigation to that is going to involve the extern_learn flag, the
whole point becomes moot (for mv88e6xxx), since FDB refreshing does not
happen in the bridge driver in that case (so the learning flag can be
whatever).

> 
> Regarding learning from link-local frames, this can be mitigated by [2]
> without adding additional checks in the bridge. I don't know why this
> bridge option was originally added, but if it wasn't for this use case,
> then now it has another use case.

There is still the problem that link-local learning is on by default
(follows the BR_LEARNING setting of the port). I don't feel exactly
comfortable with the fact that it's easy for a user to miss this and
leave the port completely insecure.

> 
> Regarding MAB, from the above you can see that a pure 802.1X
> implementation that does not involve MAB can benefit from locked bridge
> ports with learning enabled. It is therefore not accurate to say that
> one wants MAB merely by enabling learning on a locked port. Given that
> MAB is a proprietary extension and much less secure than 802.1X, we can
> assume that there will be deployments out there that do not use MAB and
> do not care about notifications regarding locked FDB entries. I
> therefore think that MAB needs to be enabled by a separate bridge port
> flag that is rejected unless the bridge port is locked and has learning
> enabled.

I had missed the detail that dynamic FDB entries will be refreshed only
with "learning" on. It makes the picture more complete. Only this is
said in "man bridge":

       learning on or learning off
              Controls whether a given port will learn MAC addresses
              from received traffic or not. If learning if off, the
              bridge will end up flooding any traffic for which it has
              no FDB entry. By default this flag is on.

Can live with MAB being a separate flag if it comes to that, as long as
'learning' will continue to have its own specific meaning, independent
of it (right now that meaning is subtle and undocumented, but makes sense).

> Regarding hardware offload, I have an idea (needs testing) on how to
> make mlxsw work in a similar way to mv88e6xxx. That is, does not involve
> injecting frames that incurred a miss to the Rx path. If you guys want,
> I'm willing to take a subset of the patches here, improve the commit
> message, do some small changes and submit them along with an mlxsw
> implementation. My intention is not to discredit anyone (I will keep the
> original authorship), but to help push this forward and give another
> example of hardware offload.
> 
> [1] https://github.com/westermo/hostapd/commit/10c584b875a63a9e58b0ad39835282545351c30e#diff-338b6fad34b4bdb015d7d96930974bd96796b754257473b6c91527789656d6ed
> [2] https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=c74a8bc9cf5d6b6c9d8c64d5a80c5740165f315a

I think it would be very nice if you could do that. As a middle ground
between mv88e6xxx and mlxsw, I can also try to build a setup on ocelot
(which should trap frames with MAC SA misses in a similar way to mlxsw,
but does also not sync its FDB with the bridge, similar to the mv88e6xxx.
Not sure what to do with dynamic FDB entries).

If only I would figure out how to configure that hostapd fork (something
which I never did before).

Hans, would it be possible to lay out some usage instructions for this fork?
