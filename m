Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5022E535BF7
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 10:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350089AbiE0Ixa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 04:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350152AbiE0Iwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 04:52:55 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3645C36B;
        Fri, 27 May 2022 01:52:31 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id w14so5820426lfl.13;
        Fri, 27 May 2022 01:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=d50SivsluZ6NgKs+usTsgrAsMJ0dcEpxRZNyKV1rSXs=;
        b=KEjqvKVgBn8GA2gtH494LAiAmb/ydkqhE0qixQQg7udNkBMreayccOL8QGT4+9jwAo
         t8kZxqgSZGtl09ng5HwGDPmcUrry5qYWoQjVCfjWq2U9abNeAOXw82YhtjH3SLyTERU+
         B/N0eFWNvI/SmJsWRZULqMzx8dgQrlM6Bo51fssmhbBIauoZtu3j8cZXvtsOpge73XXu
         tzpAH6CVtudOd4a3v8R0kMgO+jBiyzDf9eFQ693ZBSzocZJwyCE9hTjpmDZsc0qfC9eJ
         8/fP8fRmLPWGAkTswoDCLFgUX9xDlMKhAQOomAKqOWkV12euJV61I3dShddEfEn7HxoV
         qnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=d50SivsluZ6NgKs+usTsgrAsMJ0dcEpxRZNyKV1rSXs=;
        b=0beuBWOtabW2i+M5/asfIvdfjCtfHyAMlLsWz0WOVaKKuo8r7tuWr2xSofIib7QG9q
         s1tXtaZVf+DJh5EkPOTm6HJMOnc17EHshmFP3Amkb4xtRPylW+hCRtip1dK/IBMKykjH
         O4k2qa5Qy4pdAQ8DgBamrqsUJLHtkmpe9Ca1StyJoERznZ18BNdRnZgo9D+D1VhOgNPX
         5a9s1IbFP2hiat/cEeOjkUbYjgt1yXmDEKTqAQzMi33vmuYdyQp+Epyb2USfgcJruiuv
         2JZ9x/hhweKGXYQq7fli2HkGprnO/ZtJ4MPRjfDbsP5bLBCTuH2Lgqj7mYW9qyyPMl1i
         Hubw==
X-Gm-Message-State: AOAM530wqEKPWEfUbPemgW281F1tzZ11B8e9+UWWYpFRVQ+JEw/64BJX
        NwvEltBmOnKh7RkAzerO5M0CR7WXEP1Uxg==
X-Google-Smtp-Source: ABdhPJyX5vZzhLcAN2wrY2aDt2lZJIj7HuWJAQA9EdkuCUm2ulwuRSxecwK2qF8CnhTd0wQ3Cr3Tfw==
X-Received: by 2002:a05:6512:3f8c:b0:45d:cb2a:8779 with SMTP id x12-20020a0565123f8c00b0045dcb2a8779mr30514470lfa.499.1653641549871;
        Fri, 27 May 2022 01:52:29 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id s15-20020a056512314f00b0047255d211fasm772938lfi.297.2022.05.27.01.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 01:52:29 -0700 (PDT)
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
In-Reply-To: <Yo+LAj1vnjq0p36q@shredder>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <Yo+LAj1vnjq0p36q@shredder>
Date:   Fri, 27 May 2022 10:52:27 +0200
Message-ID: <86sfov2w8k.fsf@gmail.com>
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

On tor, maj 26, 2022 at 17:13, Ido Schimmel <idosch@idosch.org> wrote:
> On Tue, May 24, 2022 at 05:21:41PM +0200, Hans Schultz wrote:
>> Add an intermediate state for clients behind a locked port to allow for
>> possible opening of the port for said clients. This feature corresponds
>> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
>> latter defined by Cisco.
>> Locked FDB entries will be limited in number, so as to prevent DOS
>> attacks by spamming the port with random entries. The limit will be
>> a per port limit as it is a port based feature and that the port flushes
>> all FDB entries on link down.
>
> Why locked FDB entries need a special treatment compared to regular
> entries? A port that has learning enabled can be spammed with random
> source MACs just as well.
>
> The authorization daemon that is monitoring FDB notifications can have a
> policy to shut down a port if the rate / number of locked entries is
> above a given threshold.
>
> I don't think this kind of policy belongs in the kernel. If it resides
> in user space, then the threshold can be adjusted. Currently it's hard
> coded to 64 and I don't see how user space can change or monitor it.

In the Mac-Auth/MAB context, the locked port feature is really a form of
CPU based learning, and on mv88e6xxx switchcores, this is facilitated by
violation interrupts. Based on miss violation interrupts, the locked
entries are then added to a list with a timer to remove the entries
according to the bridge timeout.
As this is very CPU intensive compared to normal operation, the
assessment is that all this will jam up most devices if bombarded with
random entries at link speed, and my estimate is that any userspace 
daemon that listens to the ensuing fdb events will never get a chance
to stop this flood and eventually the device will lock down/reset. To
prevent this, the limit is introduced.

Ideally this limit could be adjustable from userspace, but in real
use-cases a cap like 64 should be more than enough, as that corresponds
to 64 possible devices behind a port that cannot authenticate by other
means (printers etc.) than having their mac addresses white-listed.

The software bridge behavior was then just set to correspond to the
offloaded behavior, but after correspondence with Nik, the software
bridge locked entries limit will be removed.
