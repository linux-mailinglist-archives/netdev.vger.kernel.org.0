Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF61E2AAC67
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 18:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgKHREy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 12:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHREx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 12:04:53 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7930CC0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 09:04:53 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id 7so8917647ejm.0
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 09:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=9pM4dR7c7GHpnHcSyJz1kUXqEeJnTJY5PcW9SEF/h4g=;
        b=bQl6Nv2Af036PkAj3bDo5p+ZCIu7qfRvUEDlIBCtOp11I0coHkh3TNPO2Vi24xk3UD
         y7afgVF7z1STKQCS4m9Chkxmd1kRXZyqiid3ob1nbFtfHMmFwuZgxnL6tt0wNA+Gm3r3
         eQbQzjUE4b4i5SUN4P3nQlbGSrpB1VTJKWtrtw7cxITZqTGEBt9NlnuLxvecQbMLr5YM
         IlKgqNZk0gRDR6/S6a/AqBub5j8Sqrsp6Z2Sob27NrR0SdT7WkbVwA7+63cp1ZwplCS2
         +rFVj49mGOSmXVBJzIqbW+m2AyQDMpM85SYcAypvp6yqhV+whoAgTZ3uC5eVd7Z7yWQ4
         tQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9pM4dR7c7GHpnHcSyJz1kUXqEeJnTJY5PcW9SEF/h4g=;
        b=qnHubKEivHlOnvTbQNe01mR/7TXxl4jUfl78M120lDwXbYM6KO1hW0ZHr/ZNfK0RuY
         Jd+95jmjqJ7ki05iR5gpe2S9vQmjkQUrvzSmh9JhRZ++Ue4ybefyJm1/0rWmKGapf+/1
         u0En2HTsmIU0MSgMJ88YkVZ3jMaoR99ie27qTCk+YTTUsyHTpOozypaH2Q/BRh/rCrD3
         5G36ooDSMf39qW2fZIjhm52J0fW2YG1T7C5AHZ2vX8gma7jG5DR/Bq4qDEY1La94cz+z
         TV8SqI0TLjEX0gWWYnzc6FCv3I+UhV2fWlWj56+9otvwI0GE3A3l8C0BqfO4JOCIvj0k
         3N4g==
X-Gm-Message-State: AOAM533KFGMCEhjqxIlHknQFlXB0/hPIYx3G673DUKc9tmzSqaZ4HrSI
        WfLaP9Mxn7K35/7XVJhNRALHKziYWkM1vIHtCQx8RIbXZedLS5C0xN4=
X-Google-Smtp-Source: ABdhPJwDKZIQ+20QfvZxQxudSRy6cehlGa7yuRtK5HsGbiiEYA0pxFj5g2Hs5lKJDECsA3TcvXAMDqLQVQA11HPoG3Y=
X-Received: by 2002:a17:906:9458:: with SMTP id z24mr11789665ejx.318.1604855091835;
 Sun, 08 Nov 2020 09:04:51 -0800 (PST)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Sun, 8 Nov 2020 17:04:41 +0000
Message-ID: <CAM1kxwjkJndycnWWbzBFyAap9=y13DynF=SMijL1=3SPpHbvdw@mail.gmail.com>
Subject: MSG_ZEROCOPY_FIXED
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi all,

i'm seeking input / comment on the idea of implementing full fledged
zerocopy UDP networking that uses persistent buffers allocated in
userspace... before I go off on a solo tangent with my first patches
lol.

i'm sure there's been lots of thought/discussion on this before. of
course Willem added MSG_ZEROCOPY on the send path (pin buffers on
demand / per send). and something similar to what I speak of exists
with TCP_ZEROCOPY_RECEIVE.

i envision something like a new flag like MSG_ZEROCOPY_FIXED that
"does the right thing" in the send vs recv paths.

Victor
