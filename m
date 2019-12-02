Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFDAC10EF61
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 19:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfLBSjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 13:39:18 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35695 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbfLBSjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 13:39:17 -0500
Received: by mail-qk1-f196.google.com with SMTP id v23so581661qkg.2;
        Mon, 02 Dec 2019 10:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7AahTmyRrRRUN9KLoDWPPdZMRiFouQHG/IidjTUKsJw=;
        b=Td5CxMCoPWDKuaDcEdMjcqTN0vf3CAF/Zjqj8fxFjZLzpY1VfH/+PukGoU53giP3Nu
         Axn00akXjCoU+4PHFyaJNcocM2XKHkRogTkMArVSVGOjOCEkGNGQ0vK6vSd4cPD/iV97
         bIm2uaxupDqAxFX1DfZafGOXYodXggYv3NwimWlgAlUi8pWJ7wEigTdS1nihZmk/lBE2
         srrTy1AQvRMl5ht7rNzVI7aoWCn9KnTSZ0I2Kit/609gTCkq+ZX+53LgL3ntkFrn77o+
         UxK6/bcf7vGEEwsbxqKRfZUU8mCWbAWb0Es7s0yTs5Ja9/z+c+BNrlqV0VlWddRwuJYu
         ZaVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7AahTmyRrRRUN9KLoDWPPdZMRiFouQHG/IidjTUKsJw=;
        b=m+GO8hUrrMUQ9UpWRo9ME0qjPmX5iEEY9YWULEUAQa5QFw9la5B2jn2KoHdCaDaUIv
         K6fLVGGNJLnTiZzs1bmKq/JkMs48A2ozK3exIRnKkOeM721t26eQy05dxIg6GqSE/Ytz
         Mlma181nOpIn3vCVQKBx72mZEbjkLgvwte4THPsXU7uKbZMp5HqDkAgASq9aqEu0u/Xb
         vjbwIq4jkbITGbVVCeppFO93gkz7pv7Ec49/7urZiM5DGPHJrRehh1duYKwwFgDMVqQ8
         8S6EKgkN5xO8qu0z8GCYsR66xbSZwpd814/2VHItqZ6mFQKS2SqgCujjyYNk3M/q03O3
         FNZA==
X-Gm-Message-State: APjAAAVRxX6mYRTb4K8g1rXS7sxqu51/Q0xyeuestyxbFmjq/pfzVwUX
        XhPKfCrCYXv/CveyvmrkCnM=
X-Google-Smtp-Source: APXvYqwMjunymDtO2f1xnW0eImKIiMUw5EZDJyLFOcySm5duaoG775SJvqdzcK/t1TJ/MGuAXydO/Q==
X-Received: by 2002:a37:658f:: with SMTP id z137mr273840qkb.234.1575311956265;
        Mon, 02 Dec 2019 10:39:16 -0800 (PST)
Received: from localhost.localdomain ([168.181.48.195])
        by smtp.gmail.com with ESMTPSA id b6sm194111qtp.5.2019.12.02.10.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 10:39:15 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C47FAC1B68; Mon,  2 Dec 2019 15:39:12 -0300 (-03)
Date:   Mon, 2 Dec 2019 15:39:12 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>, mvohra@vmware.com,
        netdev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        William Tu <u9012063@gmail.com>,
        Vladislav Yasevich <vyasevich@gmail.com>,
        websitedesignservices4u@gmail.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (3)
Message-ID: <20191202183912.GC377783@localhost.localdomain>
References: <001a114372a6074e6505642b7f72@google.com>
 <000000000000039751059891760e@google.com>
 <CACT4Y+Yrg8JxWABi4CJgBG7GpBSCmT0DHr_eZhQA-ikLH-X5Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Yrg8JxWABi4CJgBG7GpBSCmT0DHr_eZhQA-ikLH-X5Yw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 30, 2019 at 04:37:56PM +0100, Dmitry Vyukov wrote:
> On Sat, Nov 30, 2019 at 3:50 PM syzbot
> <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has bisected this bug to:
> >
> > commit 84e54fe0a5eaed696dee4019c396f8396f5a908b
> > Author: William Tu <u9012063@gmail.com>
> > Date:   Tue Aug 22 16:40:28 2017 +0000
> >
> >      gre: introduce native tunnel support for ERSPAN
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=158a2f86e00000
> > start commit:   f9f1e414 Merge tag 'for-linus-4.16-rc1-tag' of git://git.k..
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=178a2f86e00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=138a2f86e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=34a80ee1ac29767b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=b2bf2652983d23734c5c
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147bfebd800000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d8d543800000
> >
> > Reported-by: syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com
> > Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
> >
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> Humm... the repro contains syz_emit_ethernet, wonder if it's
> remote-triggerable...

The call trace is still from the tx path. Packet never left the system
in this case.
