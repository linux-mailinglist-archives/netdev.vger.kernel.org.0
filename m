Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F96538DCE
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 11:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245280AbiEaJeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 05:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245306AbiEaJe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 05:34:27 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9504490CCA;
        Tue, 31 May 2022 02:34:25 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id i10so1114269lfj.0;
        Tue, 31 May 2022 02:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=gw2op1nbtK3mVTVBPWekT+bSJAQAjZ1vIS0T45KFcIQ=;
        b=iXzsl86GOZS+imC0ArAHsoDuo4IhbRivbe1549gE+1CLhRDLVbYVAAnQEHbcFq81oV
         x2a/pQ779e0xE79rsATIaTBWiEqi3l6fmQhBoHqaXerolirKxgx181e2vUrm6zNeKDd8
         FByKn1yB4UJGpvD6/6WesdI7RvOmE7xR299sKuHbQr/mIc6lSaVxuq8lf7CKYpKt+Whi
         IcAoU1G0kUR+IDBlnXPcUEmhXQ2p6IdPHJw2YhBaICZ5/tewHdA7QasPcMPvn5GEIQxC
         CBAn0nAyc2OHRZfk/YBCtXJRqaQ4fABslZ7cFsN5C/0S94I9Mo6HAQ4hFlva1tif02BQ
         yMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gw2op1nbtK3mVTVBPWekT+bSJAQAjZ1vIS0T45KFcIQ=;
        b=jw5nA424eM4wUB6fh8rH5u4nFaHHa2TPLhhTHrtSkQnrKvrLX0c9/sX94QHfq0mCB0
         Vb3lRzN8gESUKjK8RlWdBfEITk8ao+j97F2V814+50xSrYAGdTgOwTo1w8FCBwJ4zrqN
         iMykMaZ3YJKyVah3SMxiVMchUA9RfYMVD8VKW/geBHw2h2NK7LGMwZISdzadKetGWQqV
         HMLpNWtVNXjDDo3Sqmn5N/qK6WU3QWoDse4cejT0uYVxy4blsoGJq79aCL2aKxmRKDtP
         tcsyF6bmh6RPEPFZsmV1BbeTb8PzTZn+snjVyqZVgVucMm9ZWADkd2Jr1Xh1gKBB7Z/T
         gOXQ==
X-Gm-Message-State: AOAM530W1xZEusfD0ABJDOBCrP2M+ZKtux0ffMCZncZQ+92z8y3vjFUo
        6cBqGq/wN1cOLTXWljUyEzB9C4Ldvho=
X-Google-Smtp-Source: ABdhPJzJ/ak3w0z3FhjqS0lhkcplqcwKg+JYRuQYWd3Ojks/86koCzhsb75WL8GDmEHfwS+cJix4/A==
X-Received: by 2002:a05:6512:33cb:b0:477:aa55:5f3e with SMTP id d11-20020a05651233cb00b00477aa555f3emr44429766lfg.488.1653989663734;
        Tue, 31 May 2022 02:34:23 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id w25-20020a197b19000000b00477c1172063sm2855486lfc.165.2022.05.31.02.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 02:34:23 -0700 (PDT)
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
Date:   Tue, 31 May 2022 11:34:21 +0200
Message-ID: <86sfoqgi5e.fsf@gmail.com>
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

> Just to give you another data point about how this works in other
> devices, I can say that at least in Spectrum this works a bit
> differently. Packets that ingress via a locked port and incur an FDB
> miss are trapped to the CPU where they should be injected into the Rx
> path so that the bridge will create the 'locked' FDB entry and notify it
> to user space. The packets are obviously rated limited as the CPU cannot
> handle billions of packets per second, unlike the ASIC. The limit is not
> per bridge port (or even per bridge), but instead global to the entire
> device.

Btw, will the bridge not create a SWITCHDEV_FDB_ADD_TO_DEVICE event
towards the switchcore in the scheme you mention and thus add an entry
that opens up for the specified mac address?
