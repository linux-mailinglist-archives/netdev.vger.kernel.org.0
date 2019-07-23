Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1362671DCB
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391107AbfGWReE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:34:04 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33519 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388408AbfGWReD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 13:34:03 -0400
Received: by mail-pl1-f195.google.com with SMTP id c14so20820917plo.0;
        Tue, 23 Jul 2019 10:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=RvkJCESD/CzjFS1KF/Km/SwmbhukObYIhQgynXRi43Y=;
        b=OFvJt7jM5i+5flNvPymUu2grjKYxQLI+Ue38nlnfmT9uKM8LzKoZup+x5xVh8Ey7UD
         q4ahJ/wr4tHijZz4awmUMuRAI1dQAJqxZhO+QMNqOjvFYhB6Y/4GlaKhyLKD35H7dUol
         Uy4K+/6bxiHcxghZedGjlpNTFbwvMv4+ixJoosTU8yDa1hrUb4Q/Wgjqi3amLPgFGYOK
         Bkry6Ytx9Yxy4/m97IDI+bHOgbYy/7FP9ybFRfjZUiqPe/XEt21rtN3j+mLK3wjIuvMX
         tbRWOocUuR+pURAJdMxExJnJPV8WahdQxZMty1g7oYioNc1Vy638hbvkedO6GInDMVT3
         95Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=RvkJCESD/CzjFS1KF/Km/SwmbhukObYIhQgynXRi43Y=;
        b=IYvMahxzsAAnGCK+CLhSIWlE3CC624wLYk9ACTOeRBBObvS9NpQCynsA9iNI5qW4+/
         1s4FERBVR1OTLqR7mH9vluC1hL3mx3W7lneKLXjXNKQyK/iNeVxt7kxWrQKJQVqk0lgI
         S84kGH0YzY2VVugpByzX6a+dM+zs4R/uIr7/VxNMl87cKf6gEdPPwPMVEnv5ug8Df5tg
         ukFMFdTQFjV7LxPVrwGS++KdqwvStIVdckgCFZu5ke0dRWrKDV7zDub6W+d2Y0oQarNp
         COfy81dbznyV2e2sJTIA9tDzlBdrl7JfSDEWgu4HoF7017BvylZ3w4c+OD36k4dRBHnU
         EwfQ==
X-Gm-Message-State: APjAAAV8DUJ1vwwUmCDeNRArpLM061TionOt2JX1e1JrJvmbFP6JRHLG
        ctm2IDvhOz4eCDvCX9tFiZQ=
X-Google-Smtp-Source: APXvYqwGQLiTfDI9SBHWYaZ9CwHrfVyV37jq8D6e5I6AkYOX2lZLeDWIDHgJf7h1Rvimw3Dng5QcJA==
X-Received: by 2002:a17:902:848b:: with SMTP id c11mr81172081plo.217.1563903242938;
        Tue, 23 Jul 2019 10:34:02 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c69sm54574734pje.6.2019.07.23.10.33.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 10:34:02 -0700 (PDT)
Date:   Tue, 23 Jul 2019 10:33:51 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     syzbot <syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     airlied@linux.ie, alexander.deucher@amd.com,
        amd-gfx@lists.freedesktop.org, ast@kernel.org, bpf@vger.kernel.org,
        christian.koenig@amd.com, daniel@iogearbox.net,
        david1.zhou@amd.com, dri-devel@lists.freedesktop.org,
        dvyukov@google.com, john.fastabend@gmail.com, leo.liu@amd.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Message-ID: <5d3744ff777cc_436d2adb6bf105c41c@john-XPS-13-9370.notmuch>
In-Reply-To: <0000000000002cec2e058e5c7e63@google.com>
References: <5d37433a832d_3aba2ae4f6ec05bc3a@john-XPS-13-9370.notmuch>
 <0000000000002cec2e058e5c7e63@google.com>
Subject: Re: Re: kernel panic: stack is corrupted in pointer
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote:
> > Dmitry Vyukov wrote:
> >> On Wed, Jul 17, 2019 at 10:58 AM syzbot
> >> <syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com> wrote:
> >> >
> >> > Hello,
> >> >
> >> > syzbot found the following crash on:
> >> >
> >> > HEAD commit:    1438cde7 Add linux-next specific files for 20190716
> >> > git tree:       linux-next
> >> > console output:  
> >> https://syzkaller.appspot.com/x/log.txt?x=13988058600000
> >> > kernel config:   
> >> https://syzkaller.appspot.com/x/.config?x=3430a151e1452331
> >> > dashboard link:  
> >> https://syzkaller.appspot.com/bug?extid=79f5f028005a77ecb6bb
> >> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >> > syz repro:       
> >> https://syzkaller.appspot.com/x/repro.syz?x=111fc8afa00000
> 
> >>  From the repro it looks like the same bpf stack overflow bug. +John
> >> We need to dup them onto some canonical report for this bug, or this
> >> becomes unmanageable.
> 
> > Fixes in bpf tree should fix this. Hopefully, we will squash this once  
> > fixes
> > percolate up.
> 
> > #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
> 
> ">" does not look like a valid git branch or commit.
> 

try again,

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
