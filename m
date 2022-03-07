Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B574D066F
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 19:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244719AbiCGSYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbiCGSYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:24:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F91085BC2;
        Mon,  7 Mar 2022 10:23:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BCB86132C;
        Mon,  7 Mar 2022 18:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EF2C340F9;
        Mon,  7 Mar 2022 18:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646677428;
        bh=CS4P4e6QC0dUdnxHehPTl5+rFZM2fucKmx3loJHj/iE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ffv6OZy6+JZpPO3lSvUF9pq/MQsS36/mvR8gcmuk+Ax4+sCL5HmbZFpbeRplVobaX
         uNTGVxZOSfFpDStLOkY2Gv4T2Og868F09ZW8vaNG0fH0uhJouLy8S/HelBl0W8oUGs
         r6XwpPfS1g+jBbHLeTKArSQVbyO2/6A60X5PU+LaLw+/mjfjb4jGJk5Uos3OWR2bng
         9oUinZZFXg0NcSNqwfSXu5+b9gaG3rQTnkt6ohrSeuJ3VDWbRceUgqFFYsu03CEvFO
         DSK5KHhbnhu/en6xNHrRONQunStl7B/7GAW2sXKhZy90b11FYLG3CaYSUMHfqYfzO4
         9askWT4WfvERw==
Received: by mail-yb1-f182.google.com with SMTP id h126so32787865ybc.1;
        Mon, 07 Mar 2022 10:23:48 -0800 (PST)
X-Gm-Message-State: AOAM532YvSPIA2K9oIBByh/vonX+E2v2/yma5GiUyuAMNa8C897fbrIc
        K9DeWFnBFPkAzTe6Le/MattYA4+JQSRsnzFoslY=
X-Google-Smtp-Source: ABdhPJxqtMkZ9saT/BmU+QIFTsB5APsQLwF9DsDqE1wKcE1TLJ7FHJGyrSsR8flj+fzTBul5Tbm/TOxw6GV9a74dEDk=
X-Received: by 2002:a05:6902:1ca:b0:624:e2a1:2856 with SMTP id
 u10-20020a05690201ca00b00624e2a12856mr8958927ybh.389.1646677427301; Mon, 07
 Mar 2022 10:23:47 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-2-benjamin.tissoires@redhat.com> <CAPhsuW4otgwwDN6+xcjPXmZyUDiynEKFtXjaFb-=kjz7HzUmZw@mail.gmail.com>
 <CAO-hwJJjDMaTXH9i1UkO7Qy+sbNprDyW67cRp8HryMMWMi5H9w@mail.gmail.com>
In-Reply-To: <CAO-hwJJjDMaTXH9i1UkO7Qy+sbNprDyW67cRp8HryMMWMi5H9w@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 7 Mar 2022 10:23:36 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4wnsd0oQ3a_OqNVw4-0+fJyZm1f+nA1QRBW-pByKDPYg@mail.gmail.com>
Message-ID: <CAPhsuW4wnsd0oQ3a_OqNVw4-0+fJyZm1f+nA1QRBW-pByKDPYg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 01/28] bpf: add new is_sys_admin_prog_type() helper
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, Sean Young <sean@mess.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 5, 2022 at 2:07 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Sat, Mar 5, 2022 at 12:12 AM Song Liu <song@kernel.org> wrote:
> >
> > On Fri, Mar 4, 2022 at 9:30 AM Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> > >
> > > LIRC_MODE2 does not really need net_admin capability, but only sys_admin.
> > >
> > > Extract a new helper for it, it will be also used for the HID bpf
> > > implementation.
> > >
> > > Cc: Sean Young <sean@mess.org>
> > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > >
> > > ---
> > >
> > > new in v2
> > > ---
> > >  kernel/bpf/syscall.c | 14 +++++++++++++-
> > >  1 file changed, 13 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > index db402ebc5570..cc570891322b 100644
> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -2165,7 +2165,6 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
> > >         case BPF_PROG_TYPE_LWT_SEG6LOCAL:
> > >         case BPF_PROG_TYPE_SK_SKB:
> > >         case BPF_PROG_TYPE_SK_MSG:
> > > -       case BPF_PROG_TYPE_LIRC_MODE2:
> > >         case BPF_PROG_TYPE_FLOW_DISSECTOR:
> > >         case BPF_PROG_TYPE_CGROUP_DEVICE:
> > >         case BPF_PROG_TYPE_CGROUP_SOCK:
> > > @@ -2202,6 +2201,17 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
> > >         }
> > >  }
> > >
> > > +static bool is_sys_admin_prog_type(enum bpf_prog_type prog_type)
> > > +{
> > > +       switch (prog_type) {
> > > +       case BPF_PROG_TYPE_LIRC_MODE2:
> > > +       case BPF_PROG_TYPE_EXT: /* extends any prog */
> > > +               return true;
> > > +       default:
> > > +               return false;
> > > +       }
> > > +}
> >
> > I am not sure whether we should do this. This is a behavior change, that may
> > break some user space. Also, BPF_PROG_TYPE_EXT is checked in
> > is_perfmon_prog_type(), and this change will make that case useless.
>
> Sure, I can drop it from v3 and make this function appear for HID only.
>
> Regarding BPF_PROG_TYPE_EXT, it was already in both
> is_net_admin_prog_type() and is_perfmon_prog_type(), so I duplicated
> it here, but I agree, given that it's already in the first function
> there, CPA_SYS_ADMIN is already checked.

I think with current code, a user with CAP_BPF, CAP_NET_ADMIN, and
CAP_PERFMON (but not CAP_SYS_ADMIN) can load programs of type
BPF_PROG_TYPE_EXT. But after the patch, the same user will not be
able to do it. Did I misread it? It is not a common case though.
