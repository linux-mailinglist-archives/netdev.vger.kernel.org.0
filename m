Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCF3A19F1
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 14:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfH2MWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 08:22:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51522 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfH2MWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 08:22:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id k1so3504705wmi.1
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 05:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TYtJEpH7i1k+Hvk7FcSM7aiLe8P0Bs6E8TF55lur8eo=;
        b=p2hdxd2gabZGZPEsoU/kn1v7xsJCVgYYUg7GmQIP5nB1FV5aGzXtV67XsalZ2ZyxMI
         UGZjBn0V9TN2UsvBYGAPHQji7LoUlNTUVAQEs3rjSJ2gxce7APmfs8M+1LcYYcCGg+S4
         Phl2yk24z2H8oyCLAX92sJcuZkwlq82nJuuOViBOpYnG5hAvt6omg+9NzYoGsFFoHVlP
         cCMYFiF4yv47u7Fe/24Z1bXHW4B+TUZXZmQECUpfY50Zu2lUAkxgpGkHIueBWFVsmfG9
         9ESkBtnfl2jtof8s9gHUvrLwr9JBslzybuaO65AnNxIKFLrNBpvfX6uxYEtxz0ayZ5wI
         U2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TYtJEpH7i1k+Hvk7FcSM7aiLe8P0Bs6E8TF55lur8eo=;
        b=fMfflIMf3MBT3fMMy79MPp3MK6/zfF6R6Rki09w6YtKlIgw+3/4A6X6y2psBbtgfMz
         oOiQvOwiTkw4W1PsB/LiKpWwn5z+pPjJEGZyIKXpUmiY0wkI1rI1Ed7EBUkYmSK+Ot2/
         DAqVLPtKqQ7lvXzki4NsZCezGqE4eJccDDc8mb6mAIlPtlh3eMaKijIQ7CiMrD02IZkx
         we5qJgWSGUoRKeTd63GfhcW3w0Rk18vEhrdb7D4d/qSdAJm/xDqSxZP6o6GqAUywU3OU
         EKRBygpYH5vHocsP1mk10eNORxzrfnstnYXqQwHrprhZ22jE9Mnqvw3o9qEpop008S5B
         cfeA==
X-Gm-Message-State: APjAAAWFOymY270I65ZcEB8hGHiO+urcL9BvUAc7gNXNexOWmCjOmrmC
        8V/FNkZf0lHHjn93ioud1yI=
X-Google-Smtp-Source: APXvYqxX02AC9M/LCHJMzTwetQ9KdU4xTV/YCFZUUcwKgDzPESumM15b0LEwlg19d8iV17SLKvlTWg==
X-Received: by 2002:a1c:750f:: with SMTP id o15mr11683512wmc.67.1567081364670;
        Thu, 29 Aug 2019 05:22:44 -0700 (PDT)
Received: from pixies (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id w13sm5547118wre.44.2019.08.29.05.22.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Aug 2019 05:22:43 -0700 (PDT)
Date:   Thu, 29 Aug 2019 15:22:41 +0300
From:   Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        shmulik@metanetworks.com, eyal@metanetworks.com
Subject: Re: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
Message-ID: <20190829152241.73734206@pixies>
In-Reply-To: <88a3da53-fecc-0d8c-56dc-a4c3b0e11dfd@iogearbox.net>
References: <20190826170724.25ff616f@pixies>
        <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
        <20190827144218.5b098eac@pixies>
        <88a3da53-fecc-0d8c-56dc-a4c3b0e11dfd@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 14:10:35 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> Given first point above wrt hitting rarely, it would be good to first get a
> better understanding for writing a reproducer. Back then Yonghong added one
> to the BPF kernel test suite [0], so it would be desirable to extend it for
> the case you're hitting. Given NAT64 use-case is needed and used by multiple
> parties, we should try to (fully) fix it generically.
> 

Thanks Daniel.

Managed to write a reproducer which mimics the skb we see on prodction,
that hits the exact same BUG_ON.

Submitted as a separate RFC PATCH to bpf-next.
Tested on v5.0.y (and fwd ported to net-next for submission).

Daniel, please use this reproducer.

Do note that the test assigns:

+	skb_shinfo(skb[0])->gso_size = 1288;

which is the *mangled* gso_size value, to mimic the works of
bpf_skb_proto_4_to_6().

When setting 'gso_size = 1288 + 20' (the *original* gso_size of the
GROed skb prior bpf_skb_proto_4_to_6), the test passes successfully and
we don't hit the mentioned BUG_ON.

Best,
Shmulik
