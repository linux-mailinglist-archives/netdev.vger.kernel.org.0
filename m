Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96F13FAA87
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 11:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbhH2JvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 05:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbhH2JvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 05:51:00 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254D3C061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 02:50:09 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id y23so10394337pgi.7
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 02:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=ovcAeZ13ZHOu6BcywDUrdBUHduRlUxTit4mA+T3Nydk=;
        b=Az1ufBXEhAWw3YwcGn017qmTNJA9d9pRSC/0AQaFazhLo5Es4uaWVesKAYHoabRoAa
         Tx1LESwOC+WpUCPEUu03uxAd5tfeQKMHsgrI1+7NXuaoCkxOAmYJBy1Jz6biJXDDauOX
         NEYtERoGPllymub0bLN1+JhEzYm6zdieUHU9ilBbmBXLip/AkOEz1cCP+uo1lTn6nSre
         ak95g4AAOpQ6rc51hPBIJkvrw3eMCgXZu4SLV8R4lIyOyT6OqthadvUvSpKllbN+X62o
         jp3enaOgiL+Sqme/yY++3hElemOhCgoxw72CgCKgnQglOeLxOIRA0IIWHEwV3nMwBQN1
         /vQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ovcAeZ13ZHOu6BcywDUrdBUHduRlUxTit4mA+T3Nydk=;
        b=iPrgo7yCZ4YUIHOumAoGclDRY8Vy7X2bSYgyIdwc738/KPXDgBQaYJnl9zT8gbQumV
         Dj0JPt4gdx4sBZgEP5i7Wa5E+J4KcKB3gPVPxD7qhx4GA3mBTJ1oQsJoQWx+ePw+klzy
         D43PcZbTggKeliI4kPwTH2QJEdNDp7ACK2bUmNkZBbfahzlLabQfjc9XoaaogABltgdm
         8Zn1iNG56Ws4l4dBdTsmz8b6VqAwOQN92HjfZDrBGwTnSK1KFbhehEvNdBSDTbR6zi/Q
         oPTERT/XVsdG9z0LG6jj7W22n3z3+tIWxIWaMGmhjbumkjHUqE1Lmv0CarpO6dTl3U6E
         2uvA==
X-Gm-Message-State: AOAM5337/4NM8U4RNjyQ5BUTj63ypxgJr7yEnCQmT13Itz0GgW0iVlQx
        Vz7Wm6Rv6DcH/0EZtyeMIfuCRgvTN9jHYA==
X-Google-Smtp-Source: ABdhPJx15mAbX8uyVuiRM3St6je6KdpiXVH3lv+AhSfEI0bJO2bXSwlJ6uqQKKiMw1vUlco9wrG2jw==
X-Received: by 2002:a63:b1a:: with SMTP id 26mr15962502pgl.12.1630230608575;
        Sun, 29 Aug 2021 02:50:08 -0700 (PDT)
Received: from lattitude ([49.206.114.245])
        by smtp.gmail.com with ESMTPSA id me10sm16885729pjb.51.2021.08.29.02.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 02:50:08 -0700 (PDT)
Date:   Sun, 29 Aug 2021 15:19:53 +0530
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [iproute2] concern regarding the color option usage in "bridge" &
 "tc" cmd
Message-ID: <20210829094953.GA59211@lattitude>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen, David,

Recently I have added a commit 82149efee9 ("bridge: reorder cmd line arg parsing
to let "-c" detected as "color" option") in iproute2 tree bridge.c which aligns
the behaviour of the "bridge" cmd with the "bridge" man page description w.r.t
the color option usage. Now I have stumbled upon a commit f38e278b8446 ("bridge:
make -c match -compressvlans first instead of -color") that was added back in
2018 which says that "there are apps and network interface managers out there
that are already using -c to prepresent compressed vlans".

So after finding the commit f38e278b8446, now I think the man page should have
fixed instead of changing the bridge.c to align the behaviour of the "bridge" cmd
with the man page. Do you think we can revert the bridge.c changes 82149efee9,
so that the "bridge" cmd detects "-c" as "-compressedvlans" instead of "-color"?

If we are reverting the commit 82149efee9, then "-c" will be detected as
"-compressedvlans" and I will send out a patch to change the "bridge" man page
to reflect the new "bridge" cmd behaviour. If we are not reverting the commit
82149efee9, then "-c" will be detected as "-color" and I will send a out a patch
to change the "bridge" cmd help menu to reflect the current "bridge" cmd behaviour.
Please share your thoughts.

And also regarding the "tc" cmd, in the man/man8/tc.8 man page, the "-c" option
is mentioned to be used as a shorthand option for "-color", but instead it is
detected as "-conf". So here also, we need to decide between fixing the man page
and fixing the "tc" cmd behaviour w.r.t to color option usage.

I understand that "matches()" gives a lot of trouble and I see that you both are
now preferring full "strcmp()" over "matches()" for newly added cmd line options.

Thanks
Gokul
