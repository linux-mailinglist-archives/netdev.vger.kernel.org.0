Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EF6529903
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 07:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbiEQFTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 01:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiEQFTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 01:19:38 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482394248F;
        Mon, 16 May 2022 22:19:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id oe17-20020a17090b395100b001df77d29587so1392496pjb.2;
        Mon, 16 May 2022 22:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HGxZBKb/3ekC1p29+M5pY+8bLNl1xB/+3c3RkyhR34k=;
        b=XdRNsZ2twmwVx7hhoVomoZWNcrZ3pcblOIVKVaS1N/vWQqBgcmmrqzJKNEz4OoZhoQ
         mhJDqdpbSvEWyzzfgz8bcwggIiqCTiZCqUpqOUaCMb40Iwlx3xmFbwK9TmkiV2fYKInD
         S/9BCGENGHC12h4/5KgYPbcnduPfIyG+zYq/jCcYArziQ319vOHeoXHP7/bGi3Od4PAW
         1QJY6fb8Og/7gQ4050RJwtS43uTzOVRnLIisjuK1Jd2b1Pb8LGCJEnBEj6sOw0bg6fcl
         oJD6RfEhMmYdGmcuKRO2EWpHsUvIugO1iV9+r6Zs4bSGD7NEp50gPU2Gwa6fNDVExZ2Q
         e8og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HGxZBKb/3ekC1p29+M5pY+8bLNl1xB/+3c3RkyhR34k=;
        b=h3yi8LVw4Las7bJ9aiYxfqIJjbuUFw6gIC5VOLHQt4LmJ8ZEggUTQsVgT2QaaOzS/e
         CSAtSpFsw7l4lVPbGA19QRXP2/kFrAIPbJz5VKLhA13EQLT9EizmgUDj0+stMPD8Owb5
         rliLsuUXUJ4XBVfO9kI12YWE4myM/qiHLbbXc+a6DJUqnbZqff1gGlcE7pqtqrvmAW2e
         2gVRIMcIOJ4A4j2ZFzXoJ+NPExC+aaHw42zRdPyXKtVvhZg7oj1l/6E+AytKYAZ9mRx/
         b6yOw+qCTljB8vW8l8DoaSn2wXc0m1n4Bh5Ff+a6hQDFj0fNwZ5hLur3Lk6n4pOJ3QZu
         QWpA==
X-Gm-Message-State: AOAM5339voiMvcGLgzgcTA0eRCvefTtNhnsLWllP/3e9fgTGZztJKyg1
        iemePxNrnEcnBkqqqaR9ShcOwp8uJeg+ICRctsb1hQcTBGhZhw==
X-Google-Smtp-Source: ABdhPJxdl1+BkSItOx4mfYPN2Pq1PxPcjJ5hqIyGIaMFzzXpudrP61PO2Lp6hc4mA2FM5gGX4atQsc8Xeg3liu2s+7Q=
X-Received: by 2002:a17:902:8203:b0:15f:4423:6e9c with SMTP id
 x3-20020a170902820300b0015f44236e9cmr21038627pln.25.1652764776757; Mon, 16
 May 2022 22:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
 <20220513224827.662254-6-mathew.j.martineau@linux.intel.com> <20220517013217.oxbpwjilwr4fzvuv@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220517013217.oxbpwjilwr4fzvuv@kafai-mbp.dhcp.thefacebook.com>
From:   Geliang Tang <geliangtang@gmail.com>
Date:   Tue, 17 May 2022 13:19:38 +0800
Message-ID: <CA+WQbwuenfY9Pxet6g0Tvo++JOAmU98+QymuWVsi-2iRpPq3oQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 5/7] selftests/bpf: verify token of struct mptcp_sock
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> =E4=BA=8E2022=E5=B9=B45=E6=9C=8817=E6=97=A5=
=E5=91=A8=E4=BA=8C 09:32=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, May 13, 2022 at 03:48:25PM -0700, Mat Martineau wrote:
> [ ... ]
>
> > +/*
> > + * Parse the token from the output of 'ip mptcp monitor':
> > + *
> > + * [       CREATED] token=3D3ca933d3 remid=3D0 locid=3D0 saddr4=3D127.=
0.0.1 ...
> > + * [       CREATED] token=3D2ab57040 remid=3D0 locid=3D0 saddr4=3D127.=
0.0.1 ...
> How stable is the string format ?
>
> If it happens to have some unrelated mptcp connection going on, will the =
test
> break ?

Hi Martin,

Yes, it will break in that case. How can I fix this? Should I run the
test in a special net namespace?

'ip mptcp monitor' can easily run in a special net namespace:

ip -net ns1 mptcp monitor

But I don't know how to run start_server() and connect_to_fd() in a
special namespace. Could you please give me some suggestions about
this?

Thanks,
-Geliang

>
> > + */
> > +static __u32 get_msk_token(void)
> > +{
> > +     char *prefix =3D "[       CREATED] token=3D";
> > +     char buf[BUFSIZ] =3D {};
> > +     __u32 token =3D 0;
> > +     ssize_t len;
> > +     int fd;
> > +
> > +     sync();
> > +
> > +     fd =3D open(monitor_log_path, O_RDONLY);
> > +     if (!ASSERT_GE(fd, 0, "Failed to open monitor_log_path"))
> > +             return token;
> > +
> > +     len =3D read(fd, buf, sizeof(buf));
> > +     if (!ASSERT_GT(len, 0, "Failed to read monitor_log_path"))
> > +             goto err;
> > +
> > +     if (strncmp(buf, prefix, strlen(prefix))) {
> > +             log_err("Invalid prefix %s", buf);
> > +             goto err;
> > +     }
> > +
> > +     token =3D strtol(buf + strlen(prefix), NULL, 16);
> > +
> > +err:
> > +     close(fd);
> > +     return token;
> > +}
> > +
>
