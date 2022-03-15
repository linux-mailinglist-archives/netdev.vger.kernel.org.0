Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F251A4DA0C3
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 18:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350387AbiCOREZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 13:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237460AbiCOREZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 13:04:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FEFE65BD
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647363791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Jw/lpacLpo5DYktMebusJ8yB8R69yJCZ2uGaoaoQg0=;
        b=Gn7wrCqp8CST1oxHfqJ5EUygP+ETlXxh5lp10B9u7JLbPUtJ4vThiHA5cZNrnpdD7SeFMl
        2YbMIY1FCck6xfqyXq8WDAfxlnJ4AIWtqvR2rXYM4OzsMQryU4z3kMbehwtghY4G1znVpU
        f/YhJff7qYJKJGhB2Thu+Xjb92eVtQA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-SKfDWko9PWS5EoLXTIQFRg-1; Tue, 15 Mar 2022 13:03:10 -0400
X-MC-Unique: SKfDWko9PWS5EoLXTIQFRg-1
Received: by mail-pl1-f199.google.com with SMTP id n17-20020a170902f61100b001538c882549so2462079plg.18
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:03:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Jw/lpacLpo5DYktMebusJ8yB8R69yJCZ2uGaoaoQg0=;
        b=h+nfH/ZhFE11oSIBPXl0l4sSjqsHnLgLBGAUB912Dop1u7g5Z6/7yPWvDzMSVK0SsI
         pnqlo8huj1CBRXnbUIyVl5njbQJhC1FWJsjGUAx4sG8xj/M5wQAJYqKEipD5yIjTpirV
         eYaJaFr9ukGL7rdc7HuVHNecE+p0II9PRkp6heJWhgYVfvdfh1LEIUYfTkxsghGQSjZe
         U1QU784+cS+aBwwpR+b8GH3UcxTh/jBsw14oyXcIzz7tPVXg1thSC3DCUCnBoziXjFpI
         4NxgQBk59RO2Aa3ZbZA+DVcrtgilOorPDzZpprGaN4dlbopJC81t/mBq6CpibjdUFqNY
         BjBQ==
X-Gm-Message-State: AOAM531HH2bbYDQQgptu3xCzBeQtYTsLVpyTiq2ea8o7/CkbSswhTvO9
        frtwobfFH6pgrDeb1cZz+lOZ1l2Vr5OmCsvRqUi+DUGuqnj8biSOM3vQEw2oWT2vPKirS+c7vy1
        6MXiRW1tZJG9bmmXR/rO5Wy9OsoGxd2sp
X-Received: by 2002:a17:902:9308:b0:14e:def5:e6b5 with SMTP id bc8-20020a170902930800b0014edef5e6b5mr28994079plb.73.1647363788645;
        Tue, 15 Mar 2022 10:03:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwkSlWhefGkomKa+ET4d+8DI5dHK+kmIh6mqdVwNC6vXuvNiRZC0hFIJKt52FwtwMmUYaDWU7i3K55DyfEm38=
X-Received: by 2002:a17:902:9308:b0:14e:def5:e6b5 with SMTP id
 bc8-20020a170902930800b0014edef5e6b5mr28994051plb.73.1647363788283; Tue, 15
 Mar 2022 10:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-15-benjamin.tissoires@redhat.com> <e1acd50f-fe67-14a8-846f-66b52e77abc0@linux.intel.com>
In-Reply-To: <e1acd50f-fe67-14a8-846f-66b52e77abc0@linux.intel.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue, 15 Mar 2022 18:02:57 +0100
Message-ID: <CAO-hwJK=S5jpqbScWrkhAWGUaZKtuKiNvspidWfs7xS4tAHjQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 14/28] selftests/bpf: add tests for
 hid_{get|set}_data helpers
To:     Tero Kristo <tero.kristo@linux.intel.com>
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
        Joe Stringer <joe@cilium.io>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 5:51 PM Tero Kristo <tero.kristo@linux.intel.com> wrote:
>
> Hi Benjamin,
>
> On 04/03/2022 19:28, Benjamin Tissoires wrote:
> > Simple test added here, with one use of each helper.
> >
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >
> > ---
> >
> > changes in v2:
> > - split the patch with libbpf left outside.
> > ---
> >   tools/testing/selftests/bpf/prog_tests/hid.c | 65 ++++++++++++++++++++
> >   tools/testing/selftests/bpf/progs/hid.c      | 45 ++++++++++++++
> >   2 files changed, 110 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
> > index 91543b8078ca..74426523dd6f 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/hid.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/hid.c
> > @@ -297,6 +297,68 @@ static int test_hid_raw_event(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
> >       return ret;
> >   }
> >
> > +/*
> > + * Attach hid_set_get_data to the given uhid device,
> > + * retrieve and open the matching hidraw node,
> > + * inject one event in the uhid device,
> > + * check that the program makes correct use of bpf_hid_{set|get}_data.
> > + */
> > +static int test_hid_set_get_data(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
> > +{
> > +     int err, hidraw_ino, hidraw_fd = -1;
> > +     char hidraw_path[64] = {0};
> > +     u8 buf[10] = {0};
> > +     int ret = -1;
> > +
> > +     /* attach hid_set_get_data program */
> > +     hid_skel->links.hid_set_get_data =
> > +             bpf_program__attach_hid(hid_skel->progs.hid_set_get_data, sysfs_fd);
> > +     if (!ASSERT_OK_PTR(hid_skel->links.hid_set_get_data,
> > +                        "attach_hid(hid_set_get_data)"))
> > +             return PTR_ERR(hid_skel->links.hid_set_get_data);
> > +
> > +     hidraw_ino = get_hidraw(hid_skel->links.hid_set_get_data);
> > +     if (!ASSERT_GE(hidraw_ino, 0, "get_hidraw"))
> > +             goto cleanup;
> > +
> > +     /* open hidraw node to check the other side of the pipe */
> > +     sprintf(hidraw_path, "/dev/hidraw%d", hidraw_ino);
> > +     hidraw_fd = open(hidraw_path, O_RDWR | O_NONBLOCK);
> > +
> > +     if (!ASSERT_GE(hidraw_fd, 0, "open_hidraw"))
> > +             goto cleanup;
> > +
> > +     /* inject one event */
> > +     buf[0] = 1;
> > +     buf[1] = 42;
> > +     send_event(uhid_fd, buf, 6);
> > +
> > +     /* read the data from hidraw */
> > +     memset(buf, 0, sizeof(buf));
> > +     err = read(hidraw_fd, buf, sizeof(buf));
> > +     if (!ASSERT_EQ(err, 6, "read_hidraw"))
> > +             goto cleanup;
> > +
> > +     if (!ASSERT_EQ(buf[2], (42 >> 2), "hid_set_get_data"))
> > +             goto cleanup;
> > +
> > +     if (!ASSERT_EQ(buf[3], 1, "hid_set_get_data"))
> > +             goto cleanup;
> > +
> > +     if (!ASSERT_EQ(buf[4], 42, "hid_set_get_data"))
> > +             goto cleanup;
> > +
> > +     ret = 0;
> > +
> > +cleanup:
> > +     if (hidraw_fd >= 0)
> > +             close(hidraw_fd);
> > +
> > +     hid__detach(hid_skel);
> > +
> > +     return ret;
> > +}
> > +
> >   /*
> >    * Attach hid_rdesc_fixup to the given uhid device,
> >    * retrieve and open the matching hidraw node,
> > @@ -395,6 +457,9 @@ void serial_test_hid_bpf(void)
> >       err = test_hid_raw_event(hid_skel, uhid_fd, sysfs_fd);
> >       ASSERT_OK(err, "hid");
> >
> > +     err = test_hid_set_get_data(hid_skel, uhid_fd, sysfs_fd);
> > +     ASSERT_OK(err, "hid_set_get_data");
> > +
> >       err = test_rdesc_fixup(hid_skel, uhid_fd, sysfs_fd);
> >       ASSERT_OK(err, "hid_rdesc_fixup");
> >
> > diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
> > index 2270448d0d3f..de6668471940 100644
> > --- a/tools/testing/selftests/bpf/progs/hid.c
> > +++ b/tools/testing/selftests/bpf/progs/hid.c
> > @@ -66,3 +66,48 @@ int hid_rdesc_fixup(struct hid_bpf_ctx *ctx)
> >
> >       return 0;
> >   }
> > +
> > +SEC("hid/device_event")
> > +int hid_set_get_data(struct hid_bpf_ctx *ctx)
> > +{
> > +     int ret;
> > +     __u8 *buf;
> > +
> > +     buf = bpf_ringbuf_reserve(&ringbuf, 8, 0);
>
> Ordering of patches is probably wrong, it seems the ringbuf is defined
> in patch #21 but used here.
>
> Also, this usage of ringbuf leads into running out of available memory
> in the buffer if used for long time, it is not evident from the test
> case written here but I spent a couple of hours debugging my own BPF
> program that used ringbuf in similar way as what is done here. Basically
> the producer idx is increased with the bpf_ringbuf_reserve / discard,
> but the consumer index is not if you don't have a consumer in place.

Oh, that's good to know.

FWIW, on v3, we won't have to use a ringbuf at all. This is a new API
break (sorry for that), but I think this will be better in the long
run.
I have chosen to use the hid_bpf_get_data() from [0]. The net
advantage is that we get a pointer to the internal buffer that can be
of any size, and we can even re-inject that same pointer into
bpf_hid_raw_request() without having to use another buffer.

I'm currently working on the documentation part and small fixes now
that the big rewrite with that implementation is now done.

Cheers,
Benjamin

>
> I ended up using a global statically allocated buffer for the purpose
> for now.
>
> -Tero
>

[0] https://lore.kernel.org/linux-input/CAO-hwJJqP5iivQZOu0LTYa1D5OuM_aVi=LH27Udc_VYkbFsrww@mail.gmail.com/

