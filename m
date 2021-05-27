Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C003937B1
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 22:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhE0U7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 16:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhE0U7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 16:59:47 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF5CC061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:58:12 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v12so1175543wrq.6
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmussen.co.za; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=CmWR8LebRVk/hHZdy4hbTW1LsYCdd/r2B+rOCuvGIsc=;
        b=Zt+SWNuYY4shs8vA6nRiDqi6ahdQyUJKlebwlZVhrzX9eWAJlWV5W1mD1WvuwXTUfp
         R/XwIPHZjg7epEDabFUhWP5cvFVENH2O7/QlFp+I/YUKr3xvcO72/L90/L5WKXVBlkl9
         8DkS1YAyFVUHTrrN3mIeSEy1LqV5GIut3RGmo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=CmWR8LebRVk/hHZdy4hbTW1LsYCdd/r2B+rOCuvGIsc=;
        b=o6dIR4xq8ZnHIsueBTBexpbZ4dB84V255Kl5vAQ1NjmJc6j1ncL95VRtPFFcWntp6Z
         Mn/xb0Q8i1HLaUxvDn5aZx9l+mzKC+RuGFtk53Amy44fzhUj44OBQo6wWt77s+buIUAo
         NiA3MpAih0OFTBIZkjkYUpwYWY2iIIGbL+inchkHQ3vL2k71DwZ/hs3EP8vTZUM10SWV
         o8cAvAfDc1Smzzx+qiTRDU/D30mOutycHqtXCFSFu3FoK/guU/BJM8TQLrQDnd51ZEz9
         plUIYcBWISyNM0oSJT4skNtcQ4RjMDFeVxnG8flSAvCQT0F8LYiNQ3GoAGu3BtFCLvqs
         3a6g==
X-Gm-Message-State: AOAM533mSw+zhCdYgPXwVDufDgyarU8hQRmyKMd/dd2vkdvK3d43uy8X
        EOHakmscC1jFvtXZnKV/ohKSqqdjYOJgcRtxCz2USFplKK/pcw==
X-Google-Smtp-Source: ABdhPJxhXXKgMyHQDZDEwIpO4dXf3zDwAN9WfPfyPzFv+vA3JzE3A1os4E8cq9I9oqvuWYKi12lmoHUiYgt/ZdNFU14=
X-Received: by 2002:a5d:48ce:: with SMTP id p14mr5407964wrs.170.1622149091086;
 Thu, 27 May 2021 13:58:11 -0700 (PDT)
MIME-Version: 1.0
From:   Norman Rasmussen <norman@rasmussen.co.za>
Date:   Thu, 27 May 2021 13:58:00 -0700
Message-ID: <CAGF1phaw5pe5y2acaoT2FqtMbZ0KXbzkg9ANAJoH=PVG=zJc7A@mail.gmail.com>
Subject: iproute2: ip address add prefer keyword confusion
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 78d04c7b27cf ("ipaddress: Add support for address metric")
added "priority" and "preference" as aliases for the "metric" keyword,
but they are entirely undocumented.

I only noticed because I was adding addresses with a preferred
lifetime, but I was using "pref" as the keyword. The metric code was
added _above_ the lifetime code, so after the change "pref" matches
"preference", instead of "preferred_lft".

Is there an existing way to deal with conflicts between keyword
prefixes? Should "prefer" (or shorter) fail with a clear error
instead? Should the metric code have been added below the lifetime
code? Should it be moved or is it too late?

-- 
- Norman Rasmussen
 - Email: norman@rasmussen.co.za
 - Home page: http://norman.rasmussen.co.za/
