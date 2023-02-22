Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0FD69FABC
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 19:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjBVSG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 13:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjBVSG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 13:06:28 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDFC2A99C
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 10:06:27 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id h16so34130727edz.10
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 10:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PRDOt2qu/dfM5NlqFRT/LBtNaDR5jAu6FY5uATawLoE=;
        b=SHWYT52ypnu4eRCSFZ/jlumk61dL2Lqei7h/M0Y98jbykQoW9v4jTkZXLs20z0k8lE
         dWP3BuVDzdxtnSrrv7TAkrJKqvl3kGznG0km0MyVBUl+S+Cn5I7uCygGGjwTEQDZrrRQ
         wMYFYae++UQM0Kmj5Nzu3UEFPmH3k2YOAXCWmUFWWPjEdtNvTPdZRBL7J9Z+6Y7PwGHp
         jb/8lctqLVqb0cQMnZfIWwKr+3BTRumOZqK9K5NoRTjG8CH29fGkE619N/cVB0KKAm2W
         QjpGjwsLjSbIH3CEzWy+jvbSHQ8d90Bj5Uuda+vo+RSHo58eTAXQMpDvXmiywLFfnOJa
         Q3ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRDOt2qu/dfM5NlqFRT/LBtNaDR5jAu6FY5uATawLoE=;
        b=44ow/4OiMkybYVFtTUNecso36tT1erimSQwz1DtD4wvyQxhMzudWukHKgP00sydJhg
         wE/I1PtqhzVRtYaj5qJUdo/BYNkLbmd3+hUzkby6Fq6BJwi+IValv9Bf1eA0B3oTOijf
         rt+PFRvj8bIp7thmpdbnYJxHombopjIT3ZPGy8uzhPZ7tib+CDbTaN/kMEFJQB213U0J
         P1FvQhib/G2BQdA6esSu54FGMudRDgDQBp5tGmyafJm0zHYDwXRN9uG1p+zZY/zERv+n
         fy01rt1BICbCIw3UkBLHnbKs3O2UucMhngdAhq+akpEVqDdAh6ZovHdd29c0vnW1/Di1
         AN8g==
X-Gm-Message-State: AO0yUKUqOmhLOCuUjjJNshTrZWUokzs5yP3L3QnHKNZkjxEexvbfhosK
        MBIozNG2MLVncQ8NLZoIIuI=
X-Google-Smtp-Source: AK7set+huwO441C4FkjlzyxkGQaddY9fda0JmHd1kzy6y7Aza4rGBA7hZiHGTKAFocXgcYi1nVvwag==
X-Received: by 2002:aa7:d705:0:b0:4ac:89b:b605 with SMTP id t5-20020aa7d705000000b004ac089bb605mr11087879edq.22.1677089185771;
        Wed, 22 Feb 2023 10:06:25 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id 28-20020a508e5c000000b004af515d2dd8sm2499742edx.74.2023.02.22.10.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 10:06:25 -0800 (PST)
Date:   Wed, 22 Feb 2023 20:06:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230222180623.cct2kbhyqulofzad@skbuf>
References: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
 <20230218205204.ie6lxey65pv3mgyh@skbuf>
 <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
 <trinity-4025f060-3bb8-4260-99b7-e25cbdcf9c27-1676800164589@3c-app-gmx-bs35>
 <20230221002713.qdsabxy7y74jpbm4@skbuf>
 <trinity-105e0c2e-38e7-4f44-affd-0bc41d0a426b-1677086262623@3c-app-gmx-bs54>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-105e0c2e-38e7-4f44-affd-0bc41d0a426b-1677086262623@3c-app-gmx-bs54>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 06:17:42PM +0100, Frank Wunderlich wrote:
> without Arincs Patch i got 940Mbit on gmac0, so something seems to affect the gmac when port5 is enabled.

which patch?
