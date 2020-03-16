Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F58187397
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 20:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732500AbgCPTsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 15:48:05 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:37209 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbgCPTsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 15:48:04 -0400
Received: by mail-oi1-f169.google.com with SMTP id w13so19198698oih.4;
        Mon, 16 Mar 2020 12:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gmf6IFRjpSX4UmNYPdLrHJndBgHmddXwR9Ebepw6Kis=;
        b=ZZX5/mtQ4Ymm+bzCRblc7VnA8dzj+9dRq6R/DSXJx3sfkPfjUc9ObTL+KQvqAJKQ3Y
         aYo27QAb5SBINMlJcgxDan8M/tq2pjjKeopBG3uE+IOv6obIZIj3cC3METJ9RhLG+pyj
         LT0nD2hCVEYCyKrWQcFIAU8TPoQLXSYiGCDV4M7SVv/XIOwlfykOGNXmPpOETd46XFPS
         8gdubWEJn1xZSqcqLziSeesYHZsPedyxUN+0vCJtlGfTRETFUe4XeJiNrPoVOdzoKS36
         opnNEhjfNjTiej3nLvf2iRKznMZXZqvI2DoYhS1Od1Y1PBswRROdFAx1yc1VXpnTuVNB
         86PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gmf6IFRjpSX4UmNYPdLrHJndBgHmddXwR9Ebepw6Kis=;
        b=M6jvfQrdsI/sKrwF/twp3OCBvuZNTfmtSGgRKhYP9x5REvrOym27KJZkdlha2EAWzk
         uZyzdmkXd1ZTx5PsM6J8BKPklbubfE1mjay0YlDn4bk013OPPzmNApfYPq8Tr0QZzHx9
         6AU9JrILHmPdAG0H/07OUxUOIaV9o/5W+z8mw8DVCO90Mwf2/906p+iP5ULR6T/wYiVv
         maRK58pVp44yKNwajSFw5L+TOupSmkGCQWxZtD2+GfSq7pF9LQY1iCEKQtTG5Q7zXft2
         CrHXLUjIUQTxjCQ8tvVbyPZnl0GklMvI/TTkrffPm8Pb0Ch/QrFSaSeUlt6ncslauC3o
         iZHQ==
X-Gm-Message-State: ANhLgQ2YhLhcUqqPIwFzfPsrwUZPtDkzJAiy5vuXLHAtsWiKF8PNG5A4
        ct0cby7E7C9vPmtBm71gxorYCzbIZL1tx+n8N5M=
X-Google-Smtp-Source: ADFU+vu3e+BAypw5BF+UC15bybXKNCSkNC/k8bcnEqHVhOsvvmJ1cAODT1vr1OqWqhET4541h7kSEGUmRIjsmoiYAkk=
X-Received: by 2002:aca:ecd0:: with SMTP id k199mr935567oih.60.1584388084207;
 Mon, 16 Mar 2020 12:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000efa06005a0879722@google.com>
In-Reply-To: <000000000000efa06005a0879722@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 16 Mar 2020 12:47:53 -0700
Message-ID: <CAM_iQpVj0Oe-oNTRLQidoKOAuKB9Yh=VNjxWba+1Sv+9idEF3A@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in tcindex_dump
To:     syzbot <syzbot+653090db2562495901dc@syzkaller.appspotmail.com>
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

#syz fix: net_sched: hold rtnl lock in tcindex_partial_destroy_work()
