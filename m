Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AA12FC1DF
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 22:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbhASVH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 16:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729269AbhASVHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 16:07:45 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B292C061573;
        Tue, 19 Jan 2021 13:07:05 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id d203so22757605oia.0;
        Tue, 19 Jan 2021 13:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bI9O4gXECEhLzXiXAgFSdcS043puoSoTAoBEYsqI9aU=;
        b=ZjZ7PtKpisQxNWuNL1Z9j+9dU3KkXBOMLigP4q/hGYf6NbpP5cwrfwcxo6jBZIKREE
         Md9Yf+DNJ5c8vfMh0Ntp7uKWVRQ65NVycfwpCx1YvkxmzPVC/fuUkbAZUpw7cUqUk5s4
         YWvIeifAd4efmPIDNsQmQkZKzLioQCzMEkiT8MU51fxwZ87/yXROodLw+TIdwAfTR/jl
         0l4lLa1M5FCzoyAKTNkUrAP0HqPpXPwkswHoXiI+Kx9wmRjpf8a/TS01Bytzxf1/9TxD
         k2tUb22p/VvCDj/ymdNdcLQ3WNDXnaf0nxLA/Xgxd1kbXpv+0t9DXXPDt9NexGG9J0nZ
         VkAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bI9O4gXECEhLzXiXAgFSdcS043puoSoTAoBEYsqI9aU=;
        b=bSjKHdt15xfByroLxYUPcKas99qVaEtmy6cLVCDr2X8LSvVroLg8fx1Z9ALb8n9Fzh
         Uio+kdPI6vaUfQa5AfZQ00tMHey4Pqs2kVblxEf39NO/PVY/SqLJe0ppM2/rwVjxk66l
         kZOUs7S9+J5DL+6JdMD4WujD+eYN59qLrhJEfNnFqhLgvqLxGQR6cZzatRC15Ep3bFB2
         yUYSbqaY8lMo5romFpfJHocTdt6bLmDB4/UPKH7bemc05LZAvE7undzhJSNp+sTon51J
         TrgORwK3XpitBeyRBJ+mYkY3m20Z9dnnFnTZt7ay4qzlMS91ehi9L5tU8Mf8aR9/Yg36
         o1TA==
X-Gm-Message-State: AOAM533CqgdN/81meFyrP/ZgQkbBK00ZlylLb2K9szsvNbTcl3iuuPD3
        6KOWlR3IMs4ge7vk3dYPAxKCfkZhW+9Y2s2mZ6Q=
X-Google-Smtp-Source: ABdhPJzP8agke9mNUh+M7I02wT86sV46MklTN5fKvkD2sPu5BYLEGSsjobnjjR35YW2jlpeXZtMq+PaezlKIW09AGyo=
X-Received: by 2002:aca:909:: with SMTP id 9mr1042589oij.69.1611090424693;
 Tue, 19 Jan 2021 13:07:04 -0800 (PST)
MIME-Version: 1.0
References: <20210119122237.2426878-1-qais.yousef@arm.com>
In-Reply-To: <20210119122237.2426878-1-qais.yousef@arm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 Jan 2021 13:06:53 -0800
Message-ID: <CAADnVQ+6UB42mbWUVPAsPis1DWBP2N=t6yfZZbJqenUNCsd6pg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/2] Allow attaching to bare tracepoints
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 4:22 AM Qais Yousef <qais.yousef@arm.com> wrote:
>
> Changes in v3:
>         * Fix not returning error value correctly in
>           trigger_module_test_write() (Yonghong)
>         * Add Yonghong acked-by to patch 1.

Applied. Thanks
