Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874C329684A
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 03:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374295AbgJWBVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 21:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374285AbgJWBVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 21:21:45 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD43DC0613D2
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 18:21:43 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id o26so64458ejc.8
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 18:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aoxn8RZh5GwLX2OTvbY4F3fYrAFarAXAp+zyIW9UVc0=;
        b=bWPmglrUmUWeh/iJB7I1EBJU+TdBzoO9kJeAZdj0Mj7vyjbv9DyccX5Lt+lUFusiZw
         HWpqEJDPjpY3Pe66lK3CAkBsqcDG1SzJroJ/TrLWOH68lnkP3CHZa96739LkvB31F0p2
         UKaI6v6FS6fL3igL3m2SvuN8QdEUHemh+0A+WspZbjpxU8NlNH1xji6y4zYUku/PAtIG
         VlsE4Z2Vr2DxmyRQoiSH2mQuJn6k9T8lU/ZuPxibEI768Vlsje7dAVkK4A+TJ9+adHG8
         +FBZ1+GlJF4yKcmomBogElmJ3P88v835veafFeBLgDo8obHbAFEfQjagR4wLw4RxeZia
         Dx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aoxn8RZh5GwLX2OTvbY4F3fYrAFarAXAp+zyIW9UVc0=;
        b=Oj4bkBEjj8bPI6Rfe3pkOTs1nOG+FVaY1TPVk53yQJyss4kl9aUSn3ys38EG9uzNOV
         dikab+pytVuKlK2ggmtNGIjsHJD4zp39Nlm299oP1/73x3fO+QUvxVcHGdbtMyIoTgca
         5bLXOX3Pxgu7xIVu5hYmtzESxcJsnkr8XF67MLwSZnmA+YzlZ6Go7lgIug8g70z/Lull
         ISIHGvoHH4lglrbl6VBO9CdxXxOJsrLXvUeG1i6CFs4QquDX91d/JnGsFoTt08tJX0nY
         IrR1YOsIlFH140Tu62Rh00Crla8JUG4nzsSbByQliKy75SkxvwjVWTT3su3FHOAxJaFw
         DUrQ==
X-Gm-Message-State: AOAM531lApQ0odSnT5oPzp7DU1qFAqiQoXOiAoxJy4Fx8q+GaY6NTM2y
        hQswpZqyLmwkbZAo7+67NJPE/Q7nHG7MjPBGqNs6
X-Google-Smtp-Source: ABdhPJzDtfnYw+rfKgxc4a8mUFIh6ll/aQ2+0itoJxliGHEeO3L/XBWkrOQEYSixIJb79O9lCBjh5YKgmDlUs8u/x/U=
X-Received: by 2002:a17:906:25cc:: with SMTP id n12mr4813564ejb.488.1603416102090;
 Thu, 22 Oct 2020 18:21:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <6e2e10432e1400f747918eeb93bf45029de2aa6c.1593198710.git.rgb@redhat.com>
 <CAHC9VhSCm5eeBcyY8bBsnxr-hK4rkso9_NJHJec2OXLu4m5QTA@mail.gmail.com>
 <20200729194058.kcbsqjhzunjpipgm@madcap2.tricolour.ca> <CAHC9VhRUwCKBjffA_XNSjUwvUn8e6zfmy8WD203dK7R2KD0__g@mail.gmail.com>
 <20201002195231.GH2882171@madcap2.tricolour.ca> <20201021163926.GA3929765@madcap2.tricolour.ca>
In-Reply-To: <20201021163926.GA3929765@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 22 Oct 2020 21:21:31 -0400
Message-ID: <CAHC9VhRb7XMyTrcrmzM3yQO+eLdO_r2+DOLKr9apDDeH4ua2Ew@mail.gmail.com>
Subject: Re: [PATCH ghak90 V9 05/13] audit: log container info of syscalls
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 12:39 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Here is an exmple I was able to generate after updating the testsuite
> script to include a signalling example of a nested audit container
> identifier:
>
> ----
> type=3DPROCTITLE msg=3Daudit(2020-10-21 10:31:16.655:6731) : proctitle=3D=
/usr/bin/perl -w containerid/test
> type=3DCONTAINER_ID msg=3Daudit(2020-10-21 10:31:16.655:6731) : contid=3D=
7129731255799087104^3333941723245477888
> type=3DOBJ_PID msg=3Daudit(2020-10-21 10:31:16.655:6731) : opid=3D115583 =
oauid=3Droot ouid=3Droot oses=3D1 obj=3Dunconfined_u:unconfined_r:unconfine=
d_t:s0-s0:c0.c1023 ocomm=3Dperl
> type=3DCONTAINER_ID msg=3Daudit(2020-10-21 10:31:16.655:6731) : contid=3D=
3333941723245477888
> type=3DOBJ_PID msg=3Daudit(2020-10-21 10:31:16.655:6731) : opid=3D115580 =
oauid=3Droot ouid=3Droot oses=3D1 obj=3Dunconfined_u:unconfined_r:unconfine=
d_t:s0-s0:c0.c1023 ocomm=3Dperl
> type=3DCONTAINER_ID msg=3Daudit(2020-10-21 10:31:16.655:6731) : contid=3D=
8098399240850112512^3333941723245477888
> type=3DOBJ_PID msg=3Daudit(2020-10-21 10:31:16.655:6731) : opid=3D115582 =
oauid=3Droot ouid=3Droot oses=3D1 obj=3Dunconfined_u:unconfined_r:unconfine=
d_t:s0-s0:c0.c1023 ocomm=3Dperl
> type=3DSYSCALL msg=3Daudit(2020-10-21 10:31:16.655:6731) : arch=3Dx86_64 =
syscall=3Dkill success=3Dyes exit=3D0 a0=3D0xfffe3c84 a1=3DSIGTERM a2=3D0x4=
d524554 a3=3D0x0 items=3D0 ppid=3D115564 pid=3D115567 auid=3Droot uid=3Droo=
t gid=3Droot euid=3Droot suid=3Droot fsuid=3Droot egid=3Droot sgid=3Droot f=
sgid=3Droot tty=3DttyS0 ses=3D1 comm=3Dperl exe=3D/usr/bin/perl subj=3Dunco=
nfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=3Dtestsuite-160329067=
1-AcLtUulY
> ----
>
> There are three CONTAINER_ID records which need some way of associating w=
ith OBJ_PID records.  An additional CONTAINER_ID record would be present if=
 the killing process itself had an audit container identifier.  I think the=
 most obvious way to connect them is with a pid=3D field in the CONTAINER_I=
D record.

Using a "pid=3D" field as a way to link CONTAINER_ID records to other
records raises a few questions.  What happens if/when we need to
represent those PIDs in the context of a namespace?  Are we ever going
to need to link to records which don't have a "pid=3D" field?  I haven't
done the homework to know if either of these are a concern right now,
but I worry that this might become a problem in the future.

The idea of using something like "item=3D" is interesting.  As you
mention, the "item=3D" field does present some overlap problems with the
PATH record, but perhaps we can do something similar.  What if we
added a "record=3D" (or similar, I'm not worried about names at this
point) to each record, reset to 0/1 at the start of each event, and
when we needed to link records somehow we could add a "related=3D1,..,N"
field.  This would potentially be useful beyond just the audit
container ID work.

--=20
paul moore
www.paul-moore.com
