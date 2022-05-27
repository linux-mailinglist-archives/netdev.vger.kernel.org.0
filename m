Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A355365A0
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 18:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354209AbiE0QCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 12:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354255AbiE0QCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 12:02:16 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6141B14AF61;
        Fri, 27 May 2022 09:01:10 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id m11so5418053ljc.1;
        Fri, 27 May 2022 09:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=2phuWBtcTkzKGfEFPcHjL5qNni//IzOpMEfDTaY87Dg=;
        b=a/6lEtQeNSwtgd+B0HQwGamPbSXYBak0YscNWlZH2/cUpwdbbAjCMlEDfXxPMCmOrv
         C+4+F0Z4eYHmr3iiuXdmt5mZ63JjkJlfLjAAAaciLrMQQRSxV9AHtoP3rSCsNUJtqdHI
         FlUW5jUaj6AUAs6lTwHCbeEbdjL+NbmODSkcWbukTJ6GMWwdAYtg5ZUaGIeoz8ADApXv
         scpsabiUuF162UFICurltoKqm8/0kcfzUpxxe/6aYV3VdvJGbK3o+EwnMdMVkv5Eq7yM
         TyFCOAZWRb4lDVyaDzF8Hhkfm70+iMyBVKw3U67S2GVj5jnyVIaeU++KAmPOT0wMrN0L
         RJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2phuWBtcTkzKGfEFPcHjL5qNni//IzOpMEfDTaY87Dg=;
        b=PKdm5Z3QFjRc9UjkUyGI2plEcNajEoig6lho/dAbl8FxUqNeb05q/xiOx4ibpaIhv2
         Q2/mWP+WDyjJXyxGVREqG08quZEObXQLkop2+cC2fkF/7WrIi813ruXX55FJNdA7jWzG
         iaquPBTi4RUsFY1JfFb2LXENAaHxE1f2n6jkKoQb7ke0qH0YpnBvBMcNj28bI8AujX28
         2wqsTY4nRpth7qoB6dzDOv47hYkGIcKRAqdm0f7+UpOVX0Qh6NCEXbxDfNAupouxhiJ1
         rnozJbafBJvVQM7WLF5YrC1M4xJwbrLVZCwJk9CU2V9fsas7vy2ZzyIzR81JQzMXZmz8
         N2fg==
X-Gm-Message-State: AOAM533RjMJh1fWKiv2WtQ1/GHpbIUotJpvNcbu3O071g2viKylvXmqY
        B4LtK/zKLOaY8XogNH3dLpiCuUnevgXZ/g==
X-Google-Smtp-Source: ABdhPJycHoLeVBSFT6HYlEmAjtp5jZp5ZTK0nv+yLI/11Jm6IOTFbrJhS9SBvMptdgirewqC4QKNzQ==
X-Received: by 2002:a2e:81ca:0:b0:255:44a9:8bea with SMTP id s10-20020a2e81ca000000b0025544a98beamr140022ljg.205.1653667258651;
        Fri, 27 May 2022 09:00:58 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id i20-20020a0565123e1400b0047426f59b33sm916670lfv.252.2022.05.27.09.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 09:00:58 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
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
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
In-Reply-To: <YpCgxtJf9Qe7fTFd@shredder>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <Yo+LAj1vnjq0p36q@shredder> <86sfov2w8k.fsf@gmail.com>
 <YpCgxtJf9Qe7fTFd@shredder>
Date:   Fri, 27 May 2022 18:00:56 +0200
Message-ID: <86a6b33qyv.fsf@gmail.com>
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

>
> As far as the bridge is concerned, locked entries are not really
> different from regular learned entries in terms of processing and since
> we don't have limits for regular entries I don't think we should have
> limits for locked entries.
>
> I do understand the problem you have in mv88e6xxx and I think it would
> be wise to hard code a reasonable limit there. It can be adjusted over
> time based on feedback and possibly exposed to user space.
>
> Just to give you another data point about how this works in other
> devices, I can say that at least in Spectrum this works a bit
> differently. Packets that ingress via a locked port and incur an FDB
> miss are trapped to the CPU where they should be injected into the Rx
> path so that the bridge will create the 'locked' FDB entry and notify it
> to user space. The packets are obviously rated limited as the CPU cannot
> handle billions of packets per second, unlike the ASIC. The limit is not
> per bridge port (or even per bridge), but instead global to the entire
> device.

Ahh, I see. I think that the best is for those FDB entries to be created
as dynamic entries, so that user-space does not have to keep track of
unauthorized entries.
Also the mv88e6xxx chipsets have a 'hold at one' feature, for authorized
entries, so that if a device goes quiet after being authorized the
driver can signal to the software bridge and further to userspace that
an authorized device has gone quiet, and the entry can then be
removed. This though requires user added dynamic entries in the ATU, or
you can call it synthetically 'learned' entries.
