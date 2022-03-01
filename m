Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640574C9157
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 18:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbiCARUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 12:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235186AbiCARUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 12:20:43 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D8513D12
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 09:20:02 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id bx5so14645225pjb.3
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 09:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9x7bVbTmKslH1o+b4w0DypYAmuXcIYWDpO7m/YGx0Qo=;
        b=T6MithCuHZshlDV57jTTWmaPRQiWB3Vu51iHZzs9uMkcD2KiIU0O8SEm0Mud/Bk9q0
         bi+xar/dppgJyefJgnB3QJEKbrup7tlgIr6fmM1v5voTNVSaRIVfJRI4fP7nkTnMgH+j
         lUFrsIQiNbBrT8sPzecjb+GCGn10inOHFOJlT73U1370WeR3SB42d17B+7ZybP++fCIb
         teBW+ABfyi0ogU9O11SabHkjMOeQ0Uv24M1sHgolj+ES6we7hf96BzHiAMWkMSH7hgy+
         Mqf6/n10dJpSgUc521cRXCRKMJn7kUNwDeDN7yT+Ky+j1W/ze+x+1LaU2ijtn2oXJzAt
         0oQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9x7bVbTmKslH1o+b4w0DypYAmuXcIYWDpO7m/YGx0Qo=;
        b=69iNEV1d1tyvtsPzObrBflruFZhfHGM+hsyvmp6neou3vEtHlmMmC/6Tp7i/lfE3at
         b+kZWV3LydBNNdKFlN4YBQ9fA23kB0xtrFsgyC4XamFVaungl7HhSaMd5a25xpunKX06
         FTI3DM6sxSLEMymN70oJpac3HrIr3qiSM71HzGrzkI5aIMHl79fVwQr7szqr70pslruX
         P1uspZKZIuvKFiLQn9B7cY61QYxJRrq5Z/pYVvfjkGyuFEIyvk4UUjh4kHXFyLhM3RIv
         mh6vWRVthFshxf49S/PuMe8qbYT73HmyNhRR75lenj6MvPXulLbN7/rP/8M9Em/dd3HX
         9fFQ==
X-Gm-Message-State: AOAM532gQdKJSdJx4HxyDyXxk9Xb9BTXdhl6AeRucZ4lNZJnm1LionDC
        DlxJlBoMprBDGgWXURwpHmGhXA==
X-Google-Smtp-Source: ABdhPJzr1ItsjT+0FV4MRTJS4f0uhZNMv14qPieGTQIdPmh6Yg3RVpWrsvm7SewNq78ieo9fUMg6XQ==
X-Received: by 2002:a17:902:7086:b0:14f:ee29:5ef0 with SMTP id z6-20020a170902708600b0014fee295ef0mr26224089plk.142.1646155202058;
        Tue, 01 Mar 2022 09:20:02 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id g25-20020a633759000000b0036c4f1f95c4sm13649242pgn.40.2022.03.01.09.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 09:20:01 -0800 (PST)
Date:   Tue, 1 Mar 2022 09:19:59 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 00/10] net: bridge: Multiple Spanning Trees
Message-ID: <20220301091959.4c8a893b@hermes.local>
In-Reply-To: <20220301162142.2rv23g4cyd2yacbs@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
        <20220301162142.2rv23g4cyd2yacbs@skbuf>
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

On Tue, 1 Mar 2022 18:21:42 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> Hi Tobias,
> 
> On Tue, Mar 01, 2022 at 11:03:11AM +0100, Tobias Waldekranz wrote:
> > A proposal for the corresponding iproute2 interface is available here:
> > 
> > https://github.com/wkz/iproute2/tree/mst  
> 
> Please pardon my ignorance. Is there a user-mode STP protocol application
> that supports MSTP, and that you've tested these patches with?
> I'd like to give it a try.

https://github.com/mstpd/mstpd
