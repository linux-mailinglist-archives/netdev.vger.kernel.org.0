Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A2F4E4240
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbiCVOtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238609AbiCVOsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:48:40 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB78976E06;
        Tue, 22 Mar 2022 07:47:11 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id e16so16011467lfc.13;
        Tue, 22 Mar 2022 07:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Wb2ma3uVeIWnLHFtR3kKOKEIt80yrxzBwcG4cgGN60c=;
        b=mHSjbQq+OgyRwkqECYu3nqz5ujv01cV7cVXHUmooouQxNKsFWEUB4s48v5dviHz9Yd
         wBNrq5OIK0l2Lrh/4XmltSFrCs3Xvi7JTxfWj62cCOb0hQy0lSLzhCLOyuN881QCjJ+j
         YliwuttuJ4nuFGCdYsQoeawBMgz9neTb/DTmwE3WI//X98k9NoSvnmq9n9hl+DgR1RuU
         2EXvCywQEvcQK6VIKGAUFRHzLPUNy69o1hDrKTLjMsHVKCwS6WM6+xDX595GinO9ubbL
         URUnRL8fTTOM/Cc2Y1Wvf4akOeL6bE13ryIiTrDbw2TlyonSk2MmqzLNbJq9X/0Qc6jW
         3cfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Wb2ma3uVeIWnLHFtR3kKOKEIt80yrxzBwcG4cgGN60c=;
        b=GaooPlg+qSp3VPAF7BLBfylLKxgby35wH+MlTTxtxgeV0eO0xlXZG00Yvp14kH8FP3
         qGbYR3r96ENmjxc6MSyiKYkto7SsvQlyqN/8NY5hO4ROWOpI7cukX//RS1hRXC0B5QZg
         KXjc7wbog1bQjmkxNjn1PRf1PVejWz0eXPgTxX7A/+y6QGM6QvOt5lPgwMujAXLHB99l
         sCiW9lYC0i94qaeQkOR0+f8pv9DnoT7FCNEDR9xL6LbrColRhH8bDRrAEWIkB4F6xAhp
         lrMcnTnpiNpodkUgLyNRDkeVGvjO10ebLSYSmRih2tVYJuLiR2gWFNfqPfw3UJZyN2aq
         dyFw==
X-Gm-Message-State: AOAM531L6CEFgF8w+0gi0nXJTo07tudm9pQ1xxuIlaFx9NQe0+4KYKa1
        3dXv4IXtEX81yEjbwmvgtTk=
X-Google-Smtp-Source: ABdhPJza5+qDIUgZlsYxL349CWJBQ13kC9g3HL7gLt26EQE8U0XWtKHGzDJSUk/i7YGp4UdGj6nfNw==
X-Received: by 2002:a05:6512:a8e:b0:44a:2db0:8045 with SMTP id m14-20020a0565120a8e00b0044a2db08045mr6747464lfu.30.1647960428432;
        Tue, 22 Mar 2022 07:47:08 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id g2-20020a2ea4a2000000b0024983b1a8dcsm755478ljm.105.2022.03.22.07.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:47:07 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <86ee2ujf61.fsf@gmail.com>
References: <20220317153625.2ld5zgtuhoxbcgvo@skbuf>
 <86ilscr2a4.fsf@gmail.com> <20220317161808.psftauoz5iaecduy@skbuf>
 <8635jg5xe5.fsf@gmail.com> <20220317172013.rhjvknre5w7mfmlo@skbuf>
 <86tubvk24r.fsf@gmail.com> <20220318121400.sdc4guu5m4auwoej@skbuf>
 <86pmmjieyl.fsf@gmail.com> <20220318131943.hc7z52beztqlzwfq@skbuf>
 <86a6dixnd2.fsf@gmail.com> <20220322110806.kbdb362jf6pbtqaf@skbuf>
 <86ee2ujf61.fsf@gmail.com>
Date:   Tue, 22 Mar 2022 15:47:05 +0100
Message-ID: <86r16u6o46.fsf@gmail.com>
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

On tis, mar 22, 2022 at 14:21, Hans Schultz <schultz.hans@gmail.com> wrote:
> On tis, mar 22, 2022 at 13:08, Vladimir Oltean <olteanv@gmail.com> wrote:
>> On Tue, Mar 22, 2022 at 12:01:13PM +0100, Hans Schultz wrote:
>>> On fre, mar 18, 2022 at 15:19, Vladimir Oltean <olteanv@gmail.com> wrote:
>>> > On Fri, Mar 18, 2022 at 02:10:26PM +0100, Hans Schultz wrote:
>>> >> In the offloaded case there is no difference between static and dynamic
>>> >> flags, which I see as a general issue. (The resulting ATU entry is static
>>> >> in either case.)
>>> >
>>> > It _is_ a problem. We had the same problem with the is_local bit.
>>> > Independently of this series, you can add the dynamic bit to struct
>>> > switchdev_notifier_fdb_info and make drivers reject it.
>>> >
>>> >> These FDB entries are removed when link goes down (soft or hard). The
>>> >> zero DPV entries that the new code introduces age out after 5 minutes,
>>> >> while the locked flagged FDB entries are removed by link down (thus the
>>> >> FDB and the ATU are not in sync in this case).
>>> >
>>> > Ok, so don't let them disappear from hardware, refresh them from the
>>> > driver, since user space and the bridge driver expect that they are
>>> > still there.
>>> 
>>> I have now tested with two extra unmanaged switches (each connected to a
>>> seperate port on our managed switch, and when migrating from one port to
>>> another, there is member violations, but as the initial entry ages out,
>>> a new miss violation occurs and the new port adds the locked entry. In
>>> this case I only see one locked entry, either on the initial port or
>>> later on the port the host migrated to (via switch).
>>> 
>>> If I refresh the ATU entries indefinitly, then this migration will for
>>> sure not work, and with the member violation suppressed, it will be
>>> silent about it.
>>
>> Manual says that migrations should trigger miss violations if configured
>> adequately, is this not the case?
>>
> Yes, but that depends on the ATU entries ageing out. As it is now, it works.
>
>>> So I don't think it is a good idea to refresh the ATU entries
>>> indefinitely.
>>> 
>>> Another issue I see, is that there is a deadlock or similar issue when
>>> receiving violations and running 'bridge fdb show' (it seemed that
>>> member violations also caused this, but not sure yet...), as the unit
>>> freezes, not to return...

I have now verified that it is only on miss violations that the problem
occurs, so it seems that there is a deadlock (with 'bridge fdb show')
somehow with the nl lock that the handling of ATU miss violations
acquires.

>>
>> Have you enabled lockdep, debug atomic sleep, detect hung tasks, things
>> like that?
>
> No, I haven't looked deeper into it yet. Maybe I was hoping someone had
> an idea... but I guess it cannot be a netlink deadlock?
