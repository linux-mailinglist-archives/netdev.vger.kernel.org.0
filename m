Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA4113B83
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 20:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfEDSKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 14:10:09 -0400
Received: from mail-yw1-f54.google.com ([209.85.161.54]:33403 "EHLO
        mail-yw1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfEDSKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 14:10:09 -0400
Received: by mail-yw1-f54.google.com with SMTP id q11so7076003ywb.0
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 11:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mXOXOJeVSZvS/w/hmPIrIDg1hMBvVABCiMG4bWgnNEo=;
        b=q0MAA5d75zNjkXF66zI0BDxqjBLY4sBVKkHKtehPKvNRmqx1SsrOtMkqwyxKVtUUH5
         7+bhgrAclpLRcYKFDNExVyYPGYWsuIjr8NXrH9UU1bO0iiPbEpUuwIEmd9qMtxTnaFDm
         fg5KrahfqOkM5IJ2+FHJA+o5uxD6rJkbdEeKNOg38ORs0kX3x1O8Sa0avjfArXcnE3ga
         6e12QwUom1X4DbKFkwgIVxOsci1mEYJgKYLuS5CV/frukcUZIISP9uXQGl+xHDUEswyO
         71dPFxARyCxQKovGYDOlK7ggdSJR9t0bVh+4GvAJSKYJ4Rn8Cjt5eUEMbmRk6Tgv9or3
         J8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mXOXOJeVSZvS/w/hmPIrIDg1hMBvVABCiMG4bWgnNEo=;
        b=Hd3dVBJ84MsHUwuUy1am7YrvYUafIAuQ87G71dhF37RSvqy3LHExTOJ5E/HdW4x6Sj
         Z1P2/Xu011o6gR3BasypoNRV5XADE5HQTync4mvu0F34368u1igXzcNmWveD0STU7Mh7
         JdI0GrV8GWOqVO8B/JocRX0Iu/vr4wDwCL34WxgqtqfM8imohmvoVOJLi8JDS6s5GbPw
         SS8qTb7vDbSfQLqIaFnP/KMZB0YLdVKUlLI8V4QoMMJUodxQG4xfJqrFUNY582IhY8WS
         QK+vEhwQTR/IGh4nkmC8DWWC+f0mY4D9tua1Dd2dHwhgfZ6/LHk7iMSwIL4hqMyl8Xl4
         rlgg==
X-Gm-Message-State: APjAAAU9rPv9shvYnrCMkXMhg72xHK8smA1SneoJmOx1F2d/PxPfsM9k
        YdxBwJYNOClz8nAlQFHVslUmTaJ8VJhT4qBokJe40w==
X-Google-Smtp-Source: APXvYqzeTCX+YEDaySfBPQ0ZpsBGoDPb8W1x6XrKJ69jeCOSJr8YJu+OR9u/UQWnAxKitEu6FcXrl6V8divm44nohIc=
X-Received: by 2002:a25:c281:: with SMTP id s123mr11550653ybf.401.1556993408079;
 Sat, 04 May 2019 11:10:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190502180610.10369-1-xiyou.wangcong@gmail.com>
 <4d2d89b1-f52b-a978-75a5-39522e3eef05@gmail.com> <CAM_iQpV4CJVXP0STJs-MWREkU1uxg5HsvMpTkiRfpK7Smz-J9g@mail.gmail.com>
In-Reply-To: <CAM_iQpV4CJVXP0STJs-MWREkU1uxg5HsvMpTkiRfpK7Smz-J9g@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 4 May 2019 14:09:56 -0400
Message-ID: <CANn89iKhyVk8AfAdKJUPho7bKiZ9Aqa3aovrgTbUBft+8gDeig@mail.gmail.com>
Subject: Re: [Patch net-next] sch_htb: redefine htb qdisc overlimits
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 4, 2019 at 1:49 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:

> Sure, v2 is coming. :)

Another possibility would to reuse existing sch->qstats.overlimits ?
