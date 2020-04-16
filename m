Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986FB1AD097
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbgDPTrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729391AbgDPTri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 15:47:38 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05CCC061A0C;
        Thu, 16 Apr 2020 12:47:37 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id di6so2672492qvb.10;
        Thu, 16 Apr 2020 12:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IiQaPOayJr5kvs71qL3IciXFap6VIqNgrywtbyP8RsQ=;
        b=IAp51LnnxGVluTzeHRtGz8VARjSfnCAjuCl69no0XTQV0d3qD7kTImLBnxzNHa3Qaz
         na2O5C4U+jjVurGny/iDOZP7DQA94WJJIE15Rb4/gs4fk7T88hJvy/x7XP5FuI/qxtzS
         fE+IsXIsd3+fpuBTk0KaVYfSTWlzJqd1ZdHdT0mxwxvIxqN/GBau5aX7oJJ1XqDgxtRt
         8RH8En9BP7eHgxTcJIgI0ZOb3jIcFVwWqRMzeJmrCZgP+dxyJui8/IIyDIioL1xmjqyQ
         YGRKCtfvpQUq5RQanOCJ/F8fcbGYrPtufqKpQbSrvgYq3Ic4DNb5iglB6lPSkPGX2utc
         ux8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IiQaPOayJr5kvs71qL3IciXFap6VIqNgrywtbyP8RsQ=;
        b=Vu6+v4XlBJzyxgDlLz+aXI54l2MyO+7PUQncHbC6P2/wn69pDsmCSBBrP7uACakRcu
         YGq++2hlCsZpUWDAWq5CMMgZ3IjpH13BRX5FdoDrvKIp4kTjuT9/8YFfh04oMyLWH3Y1
         UZ5vgBw/R6btyT5M1xVhJXLD58IxV1/Wijvi3drDSaGLOjMAPpfwCWYMz13ptcwCWlHe
         ypUyhM8WlPKNtMsJsoJ0UliBbe085XA+oajbwmmoktkKqFfl+iR8xDyyHEAkjKTCcGKK
         H1jvQjN16VfBfhr0vNnqYG/OfmgmviOjpCCCGqrdbclSpiMZzVM4PGHxjRSwLBJUiyDe
         PL8g==
X-Gm-Message-State: AGi0Pua8s3WcNGp1RMcC07Kiua+HrWKwgkCiq17wCM1ffvIwTrp9cSpH
        xBSUINojG4Wm7zOaSdyk47+wSvlYPmOiOdV4/TQ=
X-Google-Smtp-Source: APiQypKtquRwWQQXFqOBPvTZeBbMC3tNNdEXbLRDwIg2ysD7zcUg4ZsrG/9Ggfv0t+EXh+ucnxtI3C2lYt6SlX8rXiA=
X-Received: by 2002:a0c:fd8c:: with SMTP id p12mr12042055qvr.163.1587066457100;
 Thu, 16 Apr 2020 12:47:37 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000500e6f05a34ecc01@google.com> <4ba5ee0c-ec81-8ce3-6681-465e34b98a93@iogearbox.net>
 <a9219326-c07c-1069-270c-4bef17ee7b88@fb.com> <20200416102612.GO1163@kadam>
In-Reply-To: <20200416102612.GO1163@kadam>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Apr 2020 12:47:25 -0700
Message-ID: <CAEf4BzY2XwQw0ZMN6PaJtN=DfAMQyMtGuo7dnmVH1embBXmhuw@mail.gmail.com>
Subject: Re: WARNING in bpf_cgroup_link_release
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+8a5dadc5c0b1d7055945@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, KP Singh <kpsingh@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 3:29 AM Dan Carpenter <dan.carpenter@oracle.com> wr=
ote:
>
> On Wed, Apr 15, 2020 at 09:51:40AM -0700, 'Andrii Nakryiko' via syzkaller=
-bugs wrote:
> > On 4/15/20 4:57 AM, Daniel Borkmann wrote:
> > > On 4/15/20 8:55 AM, syzbot wrote:
> > > > Hello,
> > > >
> > > > syzbot found the following crash on:
> > >
> > > Andrii, ptal.
> > >
> > > > HEAD commit:    1a323ea5 x86: get rid of 'errret' argument to
> > > > __get_user_x..
> > > > git tree:       bpf-next
> > > > console output: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-=
3A__syzkaller.appspot.com_x_log.txt-3Fx-3D148ccb57e00000&d=3DDwICaQ&c=3D5VD=
0RTtNlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DT2Ez0XmyIpHmEa_MPTTUOh61=
jMDXqwETtTaTbSe-2M4&s=3D-6XBbsNV1O4X5flrx4Yssfjc56d0qeSHgwHhd92UPJc&e=3D
> > > > kernel config:  https://urldefense.proofpoint.com/v2/url?u=3Dhttps-=
3A__syzkaller.appspot.com_x_.config-3Fx-3D8c1e98458335a7d1&d=3DDwICaQ&c=3D5=
VD0RTtNlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DT2Ez0XmyIpHmEa_MPTTUOh=
61jMDXqwETtTaTbSe-2M4&s=3Ds5-1AlWtSiBvo66WN4_UXoXMGIGIqsoUCrmAnxNnfX0&e=3D
> > > > dashboard link: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-=
3A__syzkaller.appspot.com_bug-3Fextid-3D8a5dadc5c0b1d7055945&d=3DDwICaQ&c=
=3D5VD0RTtNlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DT2Ez0XmyIpHmEa_MPT=
TUOh61jMDXqwETtTaTbSe-2M4&s=3DhAA0702qJH5EwRwvG0RKmj8FwIRm1O8hvmoS7ne5Dls&e=
=3D
> > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > >
> > > > Unfortunately, I don't have any reproducer for this crash yet.
> > > >
> > > > IMPORTANT: if you fix the bug, please add the following tag to the
> > > > commit:
> > > > Reported-by: syzbot+8a5dadc5c0b1d7055945@syzkaller.appspotmail.com
> > > >
> > > > ------------[ cut here ]------------
> > > > WARNING: CPU: 0 PID: 25081 at kernel/bpf/cgroup.c:796
> > > > bpf_cgroup_link_release+0x260/0x3a0 kernel/bpf/cgroup.c:796
> >
> > This warning is triggered due to __cgroup_bpf_detach returning an error=
. It
> > can do it only in two cases: either attached item is not found, which f=
rom
> > starting at code some moreI don't see how that can happen. The other re=
ason
> > - kmalloc() failing to allocate memory for new effective prog array.
>
> If you look at the log file then this was allocation fault injection in
> bpf_prog_array_alloc().

Ah, I see, thanks for pointing this out! So that confirms that it's
not a bug, but just unfortunate result of potentially failing cgroup
BPF program detach code path.

>
> https://syzkaller.appspot.com/x/log.txt?x=3D148ccb57e00000
>
> regards,
> dan carpenter
>
