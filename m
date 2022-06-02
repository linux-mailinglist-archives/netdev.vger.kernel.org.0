Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401FD53B5D6
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 11:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbiFBJRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 05:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiFBJRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 05:17:20 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE7985EC6;
        Thu,  2 Jun 2022 02:17:18 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id s6so6813165lfo.13;
        Thu, 02 Jun 2022 02:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=x/BMPJiscOCJwChDcnTSf5xiDyx/TDj8W0/luATDtZM=;
        b=dlrHFDqdCh4D5XYD3LFF4bau4fjpwDa9QQeUEQnqjyacR8JSdJyEyqbAAhE5xs/9eo
         hbpywzBbcbbelctEIH3HvNwRbz+hkSHLTzD+g5ueE+or5NO32R15l2mqvbN/1Dwje5Bz
         h4w40/5gcmUcg2ST+QtF23Eoogki5rZA50RnWqjQOtkBotDm6XVT8hQCD0qLLbE43ZI7
         Ald8xd1yQwGSOTPjZvDSrm+lVnipzA/iFPdVyoW8Thz2nbriIH4KocuqC2LJkgOSaNSQ
         b8q+OTbw3oIKnLnNw+65ewXePQYLl8PZZ4m4E5LLpcbDQTn+C3/HUid64m5sB0DhmMQV
         KQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=x/BMPJiscOCJwChDcnTSf5xiDyx/TDj8W0/luATDtZM=;
        b=1FVitTFRXoSUpabYzHXsRcuB2dQgC1vQH3K1lLGrUkqycY66kS+x1JpNTCrPeK5iKt
         E2pTf6/rYY+dvJCWIjWiRDtaAgS2+ErtbTCDwQolCYm8CtrDrvM12xfQJ6rKC+llEbQy
         FqyYkl1/ZygNw3jmnHTRYEJmMFas6kIAnnRRoJoa+jgOomtCpyYW+/5+21kqv8TLnYUB
         zWFFk5LDT78o0RyHJ5tLj+j0x1xZzAFHIMBh3eV4Xg2NYJH2HQT79JOkzyCosT7bTzwO
         B2pQPvIAAWKrfPzn14+4cK5gL3fOxsFAB8HunAhfqJP4WubM8Ajh9h6ovLEYdTyweG5E
         IWyg==
X-Gm-Message-State: AOAM530IGRtq4e5WZiLIN3QMZFHtWaxTiCPI3JEns6qk8QUTChkvCAn3
        Cyc4wSmV6z79DOVC5Kg1ED1Ist2XjvGccg==
X-Google-Smtp-Source: ABdhPJyL8UcdmpF/l5y5K8HPvwVK1AZch6rwxEsr9rb2Vk8D6jkGykjQBWg93hwnagPcENwKtaVSng==
X-Received: by 2002:a05:6512:32c1:b0:478:6e6c:53a5 with SMTP id f1-20020a05651232c100b004786e6c53a5mr38322355lfg.435.1654161436489;
        Thu, 02 Jun 2022 02:17:16 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.28])
        by smtp.gmail.com with ESMTPSA id w6-20020a05651204c600b0047906bad093sm809482lfq.173.2022.06.02.02.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 02:17:16 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
In-Reply-To: <YpYk4EIeH6sdRl+1@shredder>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <Yo+LAj1vnjq0p36q@shredder> <86sfov2w8k.fsf@gmail.com>
 <YpCgxtJf9Qe7fTFd@shredder> <86sfoqgi5e.fsf@gmail.com>
 <YpYk4EIeH6sdRl+1@shredder>
Date:   Thu, 02 Jun 2022 11:17:12 +0200
Message-ID: <86y1yfzap3.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tis, maj 31, 2022 at 17:23, Ido Schimmel <idosch@nvidia.com> wrote:
> On Tue, May 31, 2022 at 11:34:21AM +0200, Hans Schultz wrote:
>> > Just to give you another data point about how this works in other
>> > devices, I can say that at least in Spectrum this works a bit
>> > differently. Packets that ingress via a locked port and incur an FDB
>> > miss are trapped to the CPU where they should be injected into the Rx
>> > path so that the bridge will create the 'locked' FDB entry and notify it
>> > to user space. The packets are obviously rated limited as the CPU cannot
>> > handle billions of packets per second, unlike the ASIC. The limit is not
>> > per bridge port (or even per bridge), but instead global to the entire
>> > device.
>> 
>> Btw, will the bridge not create a SWITCHDEV_FDB_ADD_TO_DEVICE event
>> towards the switchcore in the scheme you mention and thus add an entry
>> that opens up for the specified mac address?
>
> It will, but the driver needs to ignore FDB entries that are notified
> with locked flag. I see that you extended 'struct
> switchdev_notifier_fdb_info' with the locked flag, but it's not
> initialized in br_switchdev_fdb_populate(). Can you add it in the next
> version?

An issue with sending the flag to the driver is that port_fdb_add() is
suddenly getting more and more arguments and getting messy in my
opinion, but maybe that's just how it is...

Another issue is that
bridge fdb add MAC dev DEV master static
seems to add the entry with the SELF flag set, which I don't think is
what we would want it to do or?
Also the replace command is not really supported properly as it is. I
have made a fix for that which looks something like this:

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6cbb27e3b976..f43aa204f375 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -917,6 +917,9 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
                if (flags & NLM_F_EXCL)
                        return -EEXIST;
 
+               if (flags & NLM_F_REPLACE)
+                       modified = true;
+
                if (READ_ONCE(fdb->dst) != source) {
                        WRITE_ONCE(fdb->dst, source);
                        modified = true;

The argument for always sending notifications to the driver in the case
of replace is that a replace command will refresh the entries timeout if
the entry is the same. Any thoughts on this?
