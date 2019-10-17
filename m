Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB10DB71F
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393084AbfJQTNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:13:54 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35190 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfJQTNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:13:54 -0400
Received: by mail-lj1-f194.google.com with SMTP id m7so3744978lji.2;
        Thu, 17 Oct 2019 12:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hiHCI/4xP+6XGRJHYldk491YxrAyryE48lujUbC4WCc=;
        b=eXmeAhvK/sJ3E5EGfYWFSvxHWMNpFBo6jSvkyaZF8GHaTd3kqKxm8DSAYs8GOfM1J8
         zVo/+q9zJxffXkVmU38XS18+IiqmbKBPrNzMyghR3WqpI+SaqDo3MiTXEICbwD1yBn2v
         eoWlXXp0cxW7AGa84prfNjU7orZFOr6lbUf6wuEco8rgdvEdANquIcOaUiJY+HaZRhx3
         e49c0ie44y3ABQAauPkpZwH++6AbBJmkMPRzQb8ezH1xEDqiL+DAVrrKRc3zjQblEgJO
         UOdm3TbWyX4A+9JRe4JGxGGwOFLzXuEuAmURKIoGEoTZT40bcPYLQe0LrTKFGTSccybj
         yq8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hiHCI/4xP+6XGRJHYldk491YxrAyryE48lujUbC4WCc=;
        b=IqHS27qRkiphwnj8sBf2TXLOqVeerDfIABTASB/h3OjFeUC6ex9XQfJ5loXiu2Dd/K
         nAGY8UR4YRp3F5PUud1dQH17U4aOaexwZZZjJisa2BxDRzamregZ1Fglft9dDI6ZZ4Nm
         8JZmax5bFyYiIuWHhcQ9dsThMHc0m4/pV8e3V8JJoBU370i/GuEfGrg+Dxj6Ur+VNQWn
         fWNKu8SLaIN1aKhHkvPIk3ai96wfV9FxMU8xtoYN2YrbO0O0RhPHnxCbltUen9qWK58O
         qZIwT/qYV5MNsWegBkir50JYQq5xE6Nh1QD682b4WEdoNumUNzzo38GsI697w43lvPv0
         db9Q==
X-Gm-Message-State: APjAAAXK6fFtGDZU6Q+tVTp/BvlQWSMfjKbvTCrU6DPiykI+hDRc3IOL
        WjkcUWjrqJsoCPPinnOH7pPoO1U+WubB2bSvfKNMgw==
X-Google-Smtp-Source: APXvYqzLnxmLICCObiOwJhAoidKEfRCd1vFPva3bvftPNBmlqGqrwpBzt6xaV8V+4ZPpbqKCiDXBDFizcUCCnxig0lQ=
X-Received: by 2002:a2e:6c15:: with SMTP id h21mr3560380ljc.10.1571339631812;
 Thu, 17 Oct 2019 12:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191017083752.30999-1-jakub@cloudflare.com> <20191017181812.eb23epbwnp3fo5sg@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191017181812.eb23epbwnp3fo5sg@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Oct 2019 12:13:38 -0700
Message-ID: <CAADnVQ+_i3i2U0A-0w3EcRxAx8v3QVUpgYPqD=bZSZzqA=sV6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Restore the netns after flow
 dissector reattach test
To:     Martin Lau <kafai@fb.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 11:18 AM Martin Lau <kafai@fb.com> wrote:
>
> On Thu, Oct 17, 2019 at 10:37:52AM +0200, Jakub Sitnicki wrote:
> > flow_dissector_reattach test changes the netns we run in but does not
> > restore it to the one we started in when finished. This interferes with
> > tests that run after it. Fix it by restoring the netns when done.
> >
> > Fixes: f97eea1756f3 ("selftests/bpf: Check that flow dissector can be re-attached")
> > Reported-by: Alexei Starovoitov <ast@kernel.org>
> > Reported-by: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > ---
> >  .../bpf/prog_tests/flow_dissector_reattach.c  | 21 +++++++++++++++----
> >  1 file changed, 17 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
> > index 777faffc4639..1f51ba66b98b 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
> > @@ -91,12 +91,18 @@ static void do_flow_dissector_reattach(void)
> >
> >  void test_flow_dissector_reattach(void)
> >  {
> > -     int init_net, err;
> > +     int init_net, self_net, err;
> > +
> > +     self_net = open("/proc/self/ns/net", O_RDONLY);
> > +     if (CHECK_FAIL(self_net < 0)) {
> > +             perror("open(/proc/self/ns/net");
> > +             return;
> > +     }
> >
> >       init_net = open("/proc/1/ns/net", O_RDONLY);
> >       if (CHECK_FAIL(init_net < 0)) {
> >               perror("open(/proc/1/ns/net)");
> > -             return;
> > +             goto out_close;
> Mostly nit.  close(-1) is ok-ish...  The same goes for the "out_close" in
> do_flow_dissector_reattach().
>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Yeah. Not ideal, but applied the fix to bpf-next
to get selftests working again.
Please follow up with any cleanups.
Thanks
