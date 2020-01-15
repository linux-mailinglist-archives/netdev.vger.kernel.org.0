Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8FE13D097
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 00:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgAOXPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 18:15:35 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37140 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729922AbgAOXPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 18:15:34 -0500
Received: by mail-ot1-f66.google.com with SMTP id k14so17700438otn.4
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 15:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EAoYGvFhZ5rP2jO28pMuNcs6i8F6EVk5mvyZz3RoiIE=;
        b=ZxGW+SYwXgaBDLaRGiPH/7DteZ3y1HfqnadGXiizF/ZcX/u76ZyWay1Ep+Q0MkNWHS
         +XAG7eDTO6K6rGReMsgn2yqg5HjcAuFzjW+8n1qMGc7Mxr+6hZ7R0ISd92qDIOxJrbWu
         OHvqf1j/+DFtMqS5HLpFnfQyLO3cvE4N8+GDlfCqAhkx2HQeNgd2SYaO6qAPmPGXEqeC
         H43l/ny2acehPBRM5/34czzXnh76nn3SWUpuXyRNfahYDNsiZE1/XwE2JszA4E7G98/Q
         6AfJxOq3hS9IN/7iZDIWS2zZBT1fk+xweoJRv7cdaLLBTvRj6nfw0aX5H1hHk1FW5n/f
         YLGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EAoYGvFhZ5rP2jO28pMuNcs6i8F6EVk5mvyZz3RoiIE=;
        b=H6Y2rvK9P5VDrkV90Rd4X8v+tepmQS3CO93oUsRiAVpFF6rHrWtU2dUpbnX3ptP+VB
         KQzTCOMMvlJJdw6XUMoJ6Dp4mTpq+3nTXuHpLxM/fOw/MVWqqbGha61fkHlNvYT7JElq
         WjwYjmty+ylspHnbw23v6n53XLwIvoWXC8KRjTFC5bwAwQLd+i8tM2GgAHDLyF6bk6LG
         QzFgCFhg3WA68JoNrkV4bTe1tWWx8jsd/j8ZzqHtiePD4Hvvfgz0JeDTy1bhNUn8Wd7M
         0kyABTV2P2xfTyqeMP3J5u8v3vz7+XtYxeh4bl8pzVHrBOvujGBLI7XDkA2dwhp4Qzw5
         P/dw==
X-Gm-Message-State: APjAAAVRav1fE3SSt2UH3ktVvUEFqw8TsQkezeh2gvo1N+ROPOm+tCJM
        no/Zx+JRBswxPkc7XmC++lB4Zjs5sYm/BHW0iPkAzH4APqc=
X-Google-Smtp-Source: APXvYqx0NmBGBwSatOqDqfmjKagTTac0vJ8KD3lMa2VHA/jHjvQWEGBi/94UCDm8dyn/lB1DYmp1kxtCVje54DarG8I=
X-Received: by 2002:a9d:da2:: with SMTP id 31mr4354883ots.319.1579130133881;
 Wed, 15 Jan 2020 15:15:33 -0800 (PST)
MIME-Version: 1.0
References: <20200115162039.113706-1-edumazet@google.com>
In-Reply-To: <20200115162039.113706-1-edumazet@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 15 Jan 2020 15:15:22 -0800
Message-ID: <CAM_iQpWQ9+ZpasHfo5gNa0W1zm=5gsgx8iFsjK0CN-GoGUvU2Q@mail.gmail.com>
Subject: Re: [PATCH v3 net] net/sched: act_ife: initalize ife->metalist earlier
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 8:20 AM 'Eric Dumazet' via syzkaller
<syzkaller@googlegroups.com> wrote:
>
> It seems better to init ife->metalist earlier in tcf_ife_init()
> to avoid the following crash :

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
