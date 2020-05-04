Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F027A1C4714
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgEDTdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDTdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:33:08 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE2AC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 12:33:08 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id i16so12413118ils.12
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 12:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=SEbdPwqRAasYyNpg4eFYjzgVXBWwiiV5AEKzbZCi4s0=;
        b=FJkdNcNXWif/Sx/NR/ZGd4T/bq+9yWpdJSKMhOXLuDrAPPerYEk3MQgFTl7w8C6Cwd
         hUsWiQl50rB5YU888cfE0jCR0TNc3myH0R8q/4CM3h8WzuqyJhcRRLWQQQ1uenP9KpcG
         c61fWbArCKHDzdt+mg2tEZgzJ6kKV7+ldb2MQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=SEbdPwqRAasYyNpg4eFYjzgVXBWwiiV5AEKzbZCi4s0=;
        b=RVg9to2tOSKiamNjr+nvuxeAbhcm4EfStGfdwkJlhs0eLh+6g8xC+raR3Ce3AMvi4P
         +QVpWCE9yXEA/4Y/fKsVg+BnDejEHUkVWpLqNtrJ/M4m7OfIGedIDqT41IQW1wEW3oGm
         T3W1gDvNJyttgHomIh+iZR/d2Zkm3VOSFqAFhDIz1qEjgd/1XqXuqjByb5yZicpBcq7N
         y0ggL3ojdvyb96RU3kwcj3p4Pv5hMalR/yPwRO6JDXLXhQsDHoyr+7x0DNImso9o8DVA
         PuQyZAU5POjlT+VFgr62Ng9Fyj1tlKdWMmavq60AFTAejTNY1s6dnmEbDTydOElw6ALB
         z4oQ==
X-Gm-Message-State: AGi0PuYliTawVGXdT/hUtQ5f6KhhUy5chi1oVlxQDuba2Gi87TERmWGV
        1scd4l8kJO6M0oubhQR6bjsmrCXRqZCRV3iYyPbFLw==
X-Google-Smtp-Source: APiQypJxpVS3225HPBeHCoWpTAMWvNuTP51rbLsG2iK5ZjvP7vv4l8p6P/T3hFru85WvZ60S7SFT7qgeJtpI6kRW/r0=
X-Received: by 2002:a92:607:: with SMTP id x7mr3045ilg.218.1588620787332; Mon,
 04 May 2020 12:33:07 -0700 (PDT)
MIME-Version: 1.0
From:   Jonathan Richardson <jonathan.richardson@broadcom.com>
Date:   Mon, 4 May 2020 12:32:55 -0700
Message-ID: <CAHrpVsUFBTEj9VB_aURRB+=w68nybiKxkEX+kO2pe+O9GGyzBg@mail.gmail.com>
Subject: bgmac-enet driver broken in 5.7
To:     zhengdejin5@gmail.com
Cc:     davem@davemloft.net, Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Commit d7a5502b0bb8b (net: broadcom: convert to
devm_platform_ioremap_resource_byname()) broke the bgmac-enet driver.
probe fails with -22. idm_base and nicpm_base were optional. Now they
are mandatory. Our upstream dtb doesn't have them defined. I'm not
clear on why this change was made. Can it be reverted?

Thanks,
Jon
