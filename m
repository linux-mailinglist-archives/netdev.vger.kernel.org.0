Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06774B538B
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 19:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbfIQRDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 13:03:20 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37801 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728702AbfIQRDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 13:03:20 -0400
Received: by mail-pf1-f195.google.com with SMTP id y5so2524068pfo.4;
        Tue, 17 Sep 2019 10:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=udsY9Bp2m5z8jBkGZjMz6n586Nv18MrVRKTMzJRSlKA=;
        b=CMfL2Vfnz3ZUzfb5OufroCe8otqbnUCzQBGWSEK6wSWNEws46Tn6kFYCRDPtnlcHcd
         1w6/zP80PObrKMLwR8PlPDlechU4Ts4mF2Rm+CFJG7BZ09eW4q+kDioqZv00s1QQHSpP
         y+cNhlzLntpw5nE6aD8XlECxOXffte59k9CUDW/OK1O/AcwT6KyVYCGG9HwLz3MeLsTe
         rnmb+6x5pP7ARDU4jlIUVEzIloU+i5BBdW7SCS4LkMiaD00im3YoLJcDLDKuvmE3u98r
         I6va5e7HltFUMjshivgWm10veXELJ8sAYDypEuQ/OAUDDHq6exHq2HjXOwkdMj+JmXG1
         dZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=udsY9Bp2m5z8jBkGZjMz6n586Nv18MrVRKTMzJRSlKA=;
        b=XAzQ2WYV7OrHI9IJEwNpTESKLyK42V0Vk8NXunkP+4KzE2Kgj1oWGvuueXxw1kFvCM
         y2ukrnb/doMwd9C9/8ml8KAS3P2b7LtZJBoX+xqKQdeZtLEGzBMF8JhuZjpbDSIKvTZL
         uFTvaPnxPZViq0gjtZLJQxFOaWkx9ogaCvOGgvkvXtKlqDJxeGlnx19xeju25D6FzsSv
         Cd/RE4roePF9tUxj8SuwVAmXyZHhN+6a5EMEpzyqBJCAoMHkdGqZMOBeJugnVbUEKFlZ
         I+cB5mjrQeJNmTYnJ9fbMJkkD7uBQ7izuJe/diUiXCRP8T2RTsF98+Oh6UnX7Vhzqf4J
         XvgQ==
X-Gm-Message-State: APjAAAUIZuKJBoZoxCwqYxCJQkbei2VDTnPIl3W0fm5Tn1ZwG81sfuxj
        ko7jS2GJ4lEUnSOZ/6yO/7RybkxLHCdiF+FUZos=
X-Google-Smtp-Source: APXvYqxFEK77plJKGGIiq4+gona03laNJSu63v6wIesm1gEXhgNCvux0i1jX7XWB1P/D70jDYQXrsYTGzbNrBYSpd+M=
X-Received: by 2002:a17:90b:294:: with SMTP id az20mr1869546pjb.16.1568739799399;
 Tue, 17 Sep 2019 10:03:19 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000029a3a00592b41c48@google.com> <CAM_iQpX0FAvhcZgKjRd=3Rbp8cbfYiUqkF2KnmF9Pd0U4EkSDw@mail.gmail.com>
 <vbfk1a7cooq.fsf@mellanox.com>
In-Reply-To: <vbfk1a7cooq.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 17 Sep 2019 10:03:08 -0700
Message-ID: <CAM_iQpWNSdx59iTTNO6GdyZ6NBAMD8=wON6Q7dvnhiX50pwEvQ@mail.gmail.com>
Subject: Re: BUG: sleeping function called from invalid context in tcf_chain0_head_change_cb_del
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     syzbot <syzbot+ac54455281db908c581e@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Petr Machata <petrm@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "yhs@fb.com" <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 1:27 AM Vlad Buslov <vladbu@mellanox.com> wrote:
> Hi Cong,
>
> Don't see why we would need qdisc tree lock while releasing the
> reference to (or destroying) previous Qdisc. I've skimmed through other
> scheds and it looks like sch_multiq, sch_htb and sch_tbf are also
> affected. Do you want me to send patches?

Yes, please do.
