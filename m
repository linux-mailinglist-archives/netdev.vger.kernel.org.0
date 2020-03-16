Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0BC187285
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 19:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732405AbgCPSju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 14:39:50 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:35234 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732373AbgCPSju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 14:39:50 -0400
Received: by mail-oi1-f175.google.com with SMTP id k8so17505455oik.2;
        Mon, 16 Mar 2020 11:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V5MeuyFn7e4mHxz4tUSn4H5NtYvN6rAxu8E1UQB7qo4=;
        b=S3Gb++k8PoCDq6ifZEeU4qJ/0KlyGBByMVRGxXfM72hsqEcyydhCrEoXiAJv7o6h/u
         L9SCDx8RMPG3rA1msIWyy3z3D2mbE145EJhO/OVxAtzXvsvPCkScDbk5DSXmITfbgTN0
         FgX6w31IKLLlImlOzMruRnVc/paNk6RbMmbO3BG0NJ3bHtW7IIhDfgg3Lo41dCCBmdt/
         Jfxd17e8u7GmITyg8zrXvQhlI1hzyeS4L3y+dE8V1N9wlcuwL/ceoh68IYkw9txWRcut
         3adipUOJFUbhzboD32vln4B3fJ3e9wtlZKw5rd53P2LK7SkK0ZVcOnqIIq8Bz6LXPsmw
         zsEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V5MeuyFn7e4mHxz4tUSn4H5NtYvN6rAxu8E1UQB7qo4=;
        b=gMhS/S2ewEsbrCzs8WcDZ+8iRHJqh8n74cTuQCIbWv7CZGT7DpwhKf3+VVFzdqC5Ki
         BtTKgnqixKFkXnApvskwlgENC+qjmtYcGNR8aeJuXWePcekZYkZlRBc+m+EXvDuxBKWB
         vjkAMFxU/5MSpSQa+fAsmFeaW2mq8s8TrgkesPTBWLJBgfuIsSQO1HPaasC91qflOYqV
         InxwEFvxjSwCVKv1XnIlmDjcA+BaCotmosnVNsCUojiLjmwmktVfTcFPIyxm6SXK1gnX
         rupuElGNGZ8BYR2uHXAYVaufWpHZQDmt6FI4nPfLj/77wDoTteUyEcmA52Jj7X1oe+9p
         AY5w==
X-Gm-Message-State: ANhLgQ3QR0yfI/VArPuFKRo4N474dYtSaRHrnviYEjJEEyh5m0C7CYF+
        fkU7lBfN8XqUWGGB3fKkcyNsUSgcQS2LFgjezXpI+WNcuyY=
X-Google-Smtp-Source: ADFU+vtxax4sSazwm4CJkAHb7CssKVL/gjbJsY7S66yrglZsJKGmaXZTcIJY0Y+V1UxYvLU3ecg6g/3bSLJPEvaetyc=
X-Received: by 2002:aca:d489:: with SMTP id l131mr681627oig.5.1584383989691;
 Mon, 16 Mar 2020 11:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000696eaf05a0877436@google.com>
In-Reply-To: <000000000000696eaf05a0877436@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 16 Mar 2020 11:39:38 -0700
Message-ID: <CAM_iQpV9eLSBrrFwEkznwSjVeShLQAfA+aOjwJf==kEm8B+Utg@mail.gmail.com>
Subject: Re: WARNING: refcount bug in __tcf_action_put
To:     syzbot <syzbot+91aff155f11242aeafbe@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: net_sched: keep alloc_hash updated after hash allocation
