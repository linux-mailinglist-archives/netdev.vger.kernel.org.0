Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AF852D300
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 14:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238192AbiESMvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 08:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238253AbiESMu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 08:50:57 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EC82EA1E;
        Thu, 19 May 2022 05:50:44 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s14so4695078plk.8;
        Thu, 19 May 2022 05:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EW4kz6CXBaV3ibI8sRiKBbNSrNIU2gGAvOl1c9GCA5A=;
        b=NXOEMpN8VHSSxuzD8OhheRfA/nO6/F5NanEvkm6nGdpKu7KUTxlSa6+BaqHdgrXw/L
         CjOUvFf+WisM0vdaTsghojO4vHXYW+v2bzY4MJdce1Q6EKvllM46XOFk4P2tQuMrEWd0
         irfumm565ohtetRB1oZ3tTXAWKLZudq5+yQnKiiibpfOTIXu8O1UnwHPIo2qgul3+Gy9
         TvlTfXRu3J7Vr/srKqw4Jv/ieBHUn5puZOfw3pAriSAGnKjCRIOM38KpD7Ldp0blBtC+
         bXK/Rhwcz7T0lgWuQ5GFMhU14b4cqEcU3My2oQn7E7sTGAXNMM88I2yM8IV/J7JdLrBK
         KAqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EW4kz6CXBaV3ibI8sRiKBbNSrNIU2gGAvOl1c9GCA5A=;
        b=3l1OKJGuUObjXHC+kNxUXFmnmfw1TCUKbj4Q9nN57A/ugKm1bttcHk6ZzOpK5tF8Yb
         UF5Uab5s1mNEYnXkQXYQe9OD9uI3OnmWSlpRkaVd9N/hFCKE5p2GQL6wU5fuSbEJHAqW
         a1a8MPiVWZ+ykmlcsA8ZztjcoavYlSiZSShNGrLXeeADIKyYwGxs9g18sE17lFCNtu9s
         92UIbPzwOMCU9JKL48Q9RyRTT126VS4KipUT7DtDgBV9EpjipzfhrDSssit+5TRe8GbO
         yHasKHbH9EgqM9timVk/iXkSK5fS6zybFVursQDQE6m16IPK6LOOJ3Ogc7gYARLxzs8A
         TZJQ==
X-Gm-Message-State: AOAM530CWQK2j/0gCCWyavqvFEMLfV1INeTGpt9bJTdNgWP0mTgi09Cr
        2SgL0ItD3X/WhSbSgvOL5xw=
X-Google-Smtp-Source: ABdhPJwuecxu64WFzoeLRc5BKxhGfxJe/o1QjJj1lLqRZNzps7/YHljclBGtgCml19XlLCSDFqpuxw==
X-Received: by 2002:a17:90a:e388:b0:1df:ac20:df7d with SMTP id b8-20020a17090ae38800b001dfac20df7dmr5699859pjz.208.1652964643884;
        Thu, 19 May 2022 05:50:43 -0700 (PDT)
Received: from localhost ([14.139.187.71])
        by smtp.gmail.com with ESMTPSA id c15-20020a63ea0f000000b003c14af50615sm3485750pgi.45.2022.05.19.05.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 05:50:43 -0700 (PDT)
Date:   Thu, 19 May 2022 18:21:32 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH bpf-next v5 12/17] selftests/bpf: add tests for
 bpf_hid_hw_request
Message-ID: <20220519125132.lm4ztduemzyvystf@apollo.legion>
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
 <20220518205924.399291-13-benjamin.tissoires@redhat.com>
 <20220518222055.zh7hvexbqlctvotw@apollo.legion>
 <CAO-hwJLxqYC9AUrfjMX1sPdSrt7EguWt9diwadJ9UZe-XGKFJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-hwJLxqYC9AUrfjMX1sPdSrt7EguWt9diwadJ9UZe-XGKFJw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 05:42:40PM IST, Benjamin Tissoires wrote:
> On Thu, May 19, 2022 at 12:20 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Thu, May 19, 2022 at 02:29:19AM IST, Benjamin Tissoires wrote:
> > > Add tests for the newly implemented function.
> > > We test here only the GET_REPORT part because the other calls are pure
> > > HID protocol and won't infer the result of the test of the bpf hook.
> > >
> > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > >
> > > ---
> > >
> > > changes in v5:
> > > - use the new hid_bpf_allocate_context() API
> > > - remove the need for ctx_in for syscall TEST_RUN
> > >
> > > changes in v3:
> > > - use the new hid_get_data API
> > > - directly use HID_FEATURE_REPORT and HID_REQ_GET_REPORT from uapi
> > >
> > > changes in v2:
> > > - split the series by bpf/libbpf/hid/selftests and samples
> > > ---
> > >  tools/testing/selftests/bpf/prog_tests/hid.c | 114 ++++++++++++++++---
> > >  tools/testing/selftests/bpf/progs/hid.c      |  59 ++++++++++
> > >  2 files changed, 155 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
> > > index 47bc0a30c275..54c0a0fcd54d 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/hid.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/hid.c
> > > @@ -77,12 +77,23 @@ static unsigned char rdesc[] = {
> > >       0xc0,                   /* END_COLLECTION */
> > >  };
> > >
> > > +static u8 feature_data[] = { 1, 2 };
> > > +
> > >  struct attach_prog_args {
> > >       int prog_fd;
> > >       unsigned int hid;
> > >       int retval;
> > >  };
> > >
> > > +struct hid_hw_request_syscall_args {
> > > +     __u8 data[10];
> > > +     unsigned int hid;
> > > +     int retval;
> > > +     size_t size;
> > > +     enum hid_report_type type;
> > > +     __u8 request_type;
> > > +};
> > > +
> > >  static pthread_mutex_t uhid_started_mtx = PTHREAD_MUTEX_INITIALIZER;
> > >  static pthread_cond_t uhid_started = PTHREAD_COND_INITIALIZER;
> > >
> > > @@ -142,7 +153,7 @@ static void destroy(int fd)
> > >
> > >  static int uhid_event(int fd)
> > >  {
> > > -     struct uhid_event ev;
> > > +     struct uhid_event ev, answer;
> > >       ssize_t ret;
> > >
> > >       memset(&ev, 0, sizeof(ev));
> > > @@ -183,6 +194,15 @@ static int uhid_event(int fd)
> > >               break;
> > >       case UHID_GET_REPORT:
> > >               fprintf(stderr, "UHID_GET_REPORT from uhid-dev\n");
> > > +
> > > +             answer.type = UHID_GET_REPORT_REPLY;
> > > +             answer.u.get_report_reply.id = ev.u.get_report.id;
> > > +             answer.u.get_report_reply.err = ev.u.get_report.rnum == 1 ? 0 : -EIO;
> > > +             answer.u.get_report_reply.size = sizeof(feature_data);
> > > +             memcpy(answer.u.get_report_reply.data, feature_data, sizeof(feature_data));
> > > +
> > > +             uhid_write(fd, &answer);
> > > +
> > >               break;
> > >       case UHID_SET_REPORT:
> > >               fprintf(stderr, "UHID_SET_REPORT from uhid-dev\n");
> > > @@ -391,6 +411,7 @@ static int open_hidraw(int dev_id)
> > >  struct test_params {
> > >       struct hid *skel;
> > >       int hidraw_fd;
> > > +     int hid_id;
> > >  };
> > >
> > >  static int prep_test(int dev_id, const char *prog_name, struct test_params *test_data)
> > > @@ -419,27 +440,33 @@ static int prep_test(int dev_id, const char *prog_name, struct test_params *test
> > >       if (!ASSERT_OK_PTR(hid_skel, "hid_skel_open"))
> > >               goto cleanup;
> > >
> > > -     prog = bpf_object__find_program_by_name(*hid_skel->skeleton->obj, prog_name);
> > > -     if (!ASSERT_OK_PTR(prog, "find_prog_by_name"))
> > > -             goto cleanup;
> > > +     if (prog_name) {
> > > +             prog = bpf_object__find_program_by_name(*hid_skel->skeleton->obj, prog_name);
> > > +             if (!ASSERT_OK_PTR(prog, "find_prog_by_name"))
> > > +                     goto cleanup;
> > >
> > > -     bpf_program__set_autoload(prog, true);
> > > +             bpf_program__set_autoload(prog, true);
> > >
> > > -     err = hid__load(hid_skel);
> > > -     if (!ASSERT_OK(err, "hid_skel_load"))
> > > -             goto cleanup;
> > > +             err = hid__load(hid_skel);
> > > +             if (!ASSERT_OK(err, "hid_skel_load"))
> > > +                     goto cleanup;
> > >
> > > -     attach_fd = bpf_program__fd(hid_skel->progs.attach_prog);
> > > -     if (!ASSERT_GE(attach_fd, 0, "locate attach_prog")) {
> > > -             err = attach_fd;
> > > -             goto cleanup;
> > > -     }
> > > +             attach_fd = bpf_program__fd(hid_skel->progs.attach_prog);
> > > +             if (!ASSERT_GE(attach_fd, 0, "locate attach_prog")) {
> > > +                     err = attach_fd;
> > > +                     goto cleanup;
> > > +             }
> > >
> > > -     args.prog_fd = bpf_program__fd(prog);
> > > -     err = bpf_prog_test_run_opts(attach_fd, &tattr);
> > > -     snprintf(buf, sizeof(buf), "attach_hid(%s)", prog_name);
> > > -     if (!ASSERT_EQ(args.retval, 0, buf))
> > > -             goto cleanup;
> > > +             args.prog_fd = bpf_program__fd(prog);
> > > +             err = bpf_prog_test_run_opts(attach_fd, &tattr);
> > > +             snprintf(buf, sizeof(buf), "attach_hid(%s)", prog_name);
> > > +             if (!ASSERT_EQ(args.retval, 0, buf))
> > > +                     goto cleanup;
> > > +     } else {
> > > +             err = hid__load(hid_skel);
> > > +             if (!ASSERT_OK(err, "hid_skel_load"))
> > > +                     goto cleanup;
> > > +     }
> > >
> > >       hidraw_fd = open_hidraw(dev_id);
> > >       if (!ASSERT_GE(hidraw_fd, 0, "open_hidraw"))
> > > @@ -447,6 +474,7 @@ static int prep_test(int dev_id, const char *prog_name, struct test_params *test
> > >
> > >       test_data->skel = hid_skel;
> > >       test_data->hidraw_fd = hidraw_fd;
> > > +     test_data->hid_id = hid_id;
> > >
> > >       return 0;
> > >
> > > @@ -693,6 +721,54 @@ static int test_hid_change_report(int uhid_fd, int dev_id)
> > >       return ret;
> > >  }
> > >
> > > +/*
> > > + * Attach hid_user_raw_request to the given uhid device,
> > > + * call the bpf program from userspace
> > > + * check that the program is called and does the expected.
> > > + */
> > > +static int test_hid_user_raw_request_call(int uhid_fd, int dev_id)
> > > +{
> > > +     struct test_params params;
> > > +     int err, prog_fd;
> > > +     int ret = -1;
> > > +     struct hid_hw_request_syscall_args args = {
> > > +             .retval = -1,
> > > +             .type = HID_FEATURE_REPORT,
> > > +             .request_type = HID_REQ_GET_REPORT,
> > > +             .size = 10,
> > > +     };
> > > +     DECLARE_LIBBPF_OPTS(bpf_test_run_opts, tattrs,
> > > +                         .ctx_in = &args,
> > > +                         .ctx_size_in = sizeof(args),
> > > +     );
> > > +
> > > +     err = prep_test(dev_id, NULL, &params);
> > > +     if (!ASSERT_EQ(err, 0, "prep_test()"))
> > > +             goto cleanup;
> > > +
> > > +     args.hid = params.hid_id;
> > > +     args.data[0] = 1; /* report ID */
> > > +
> > > +     prog_fd = bpf_program__fd(params.skel->progs.hid_user_raw_request);
> > > +
> > > +     err = bpf_prog_test_run_opts(prog_fd, &tattrs);
> > > +     if (!ASSERT_EQ(err, 0, "bpf_prog_test_run_opts"))
> > > +             goto cleanup;
> > > +
> > > +     if (!ASSERT_EQ(args.retval, 2, "bpf_prog_test_run_opts_retval"))
> > > +             goto cleanup;
> > > +
> > > +     if (!ASSERT_EQ(args.data[1], 2, "hid_user_raw_request_check_in"))
> > > +             goto cleanup;
> > > +
> > > +     ret = 0;
> > > +
> > > +cleanup:
> > > +     cleanup_test(&params);
> > > +
> > > +     return ret;
> > > +}
> > > +
> > >  void serial_test_hid_bpf(void)
> > >  {
> > >       int err, uhid_fd;
> > > @@ -720,6 +796,8 @@ void serial_test_hid_bpf(void)
> > >       ASSERT_OK(err, "hid_attach_detach");
> > >       err = test_hid_change_report(uhid_fd, dev_id);
> > >       ASSERT_OK(err, "hid_change_report");
> > > +     err = test_hid_user_raw_request_call(uhid_fd, dev_id);
> > > +     ASSERT_OK(err, "hid_change_report");
> > >
> > >       destroy(uhid_fd);
> > >
> > > diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
> > > index ee7529c47ad8..e3444d444303 100644
> > > --- a/tools/testing/selftests/bpf/progs/hid.c
> > > +++ b/tools/testing/selftests/bpf/progs/hid.c
> > > @@ -10,6 +10,13 @@ extern __u8 *hid_bpf_get_data(struct hid_bpf_ctx *ctx,
> > >                             unsigned int offset,
> > >                             const size_t __sz) __ksym;
> > >  extern int hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, u32 flags) __ksym;
> > > +extern struct hid_bpf_ctx *hid_bpf_allocate_context(unsigned int hid_id) __ksym;
> > > +extern void hid_bpf_release_context(struct hid_bpf_ctx *ctx) __ksym;
> > > +extern int hid_bpf_hw_request(struct hid_bpf_ctx *ctx,
> > > +                           __u8 *data,
> > > +                           size_t len,
> > > +                           enum hid_report_type type,
> > > +                           int reqtype) __ksym;
> > >
> > >  struct attach_prog_args {
> > >       int prog_fd;
> > > @@ -56,3 +63,55 @@ int attach_prog(struct attach_prog_args *ctx)
> > >                                         0);
> > >       return 0;
> > >  }
> > > +
> > > +struct hid_hw_request_syscall_args {
> > > +     /* data needs to come at offset 0 so we can do a memcpy into it */
> > > +     __u8 data[10];
> > > +     unsigned int hid;
> > > +     int retval;
> > > +     size_t size;
> > > +     enum hid_report_type type;
> > > +     __u8 request_type;
> > > +};
> > > +
> > > +SEC("syscall")
> > > +int hid_user_raw_request(struct hid_hw_request_syscall_args *args)
> > > +{
> > > +     struct hid_bpf_ctx *ctx;
> > > +     int i, ret = 0;
> > > +     __u8 *data;
> > > +
> > > +     ctx = hid_bpf_allocate_context(args->hid);
> > > +     if (!ctx)
> > > +             return 0; /* EPERM check */
> > > +
> > > +     /* We can not use the context data memory directly in the hid_bpf call,
> > > +      * so we rely on the PTR_TO_MEM allocated in the hid_bpf_context
> > > +      */
> > > +     data = hid_bpf_get_data(ctx, 0 /* offset */, 10 /* size */);
> > > +     if (!data)
> > > +             goto out; /* EPERM check */
> > > +
> >
> > If I'm reading this right, you need more than just returning PTR_TO_MEM. Since
> > this points into allocated ctx, nothing prevents user from accessing data after
> > we do hid_bpf_release_context.
>
> oops. I missed that point.
>
> TBH, ideally I wanted to directly pass args->data into
> hid_bpf_hw_request(). But because args is seen as the context of the
> program, I can not pass it to the kfunc arguments.
> I would happily prevent getting a data pointer for a manually
> allocated context if I could solve that issue. This would save me from
> calling twice  __builtin_memcpy.

Oh, is that why you need to do this? So if you were able to pass args->data, you
wouldn't need this hid_bpf_get_data? kfunc does support taking PTR_TO_CTX (i.e.
args in your case), I am not sure why you're not passing it in directly then.
Did you encounter any errors when trying to do so? The only requirement is that
args offset must be 0 (i.e. passed as is without increment).

>
> That doesn't change the fact that you are correct and the PTR_TO_MEM
> in kfunc code should be fixed.
> But right now, I am not sure what you mean below and I'll need a
> little bit more time to process it.
>
> Cheers,
> Benjamin
>
> >
> > The ref_obj_id of ctx needs to be transferred to R0.ref_obj_id, and R0.id needs
> > to be assigned another id distinct from the ref_obj_id.
> >
> > My idea would be to give this type of function a new set, and handle this case
> > of transferring ref_obj_id into R0. See is_ptr_cast_function in verifier.c.
> > Shouldn't be too much code. You could even use the bpf_kfunc_arg_meta to store
> > the ref_obj_id (and ensure only one referenced register exists among the 5
> > arguments).
> >
> > > +     __builtin_memcpy(data, args->data, sizeof(args->data));
> > > +
> > > +     if (args->size <= sizeof(args->data)) {
> > > +             ret = hid_bpf_hw_request(ctx,
> > > +                                      data,
> > > +                                      args->size,
> > > +                                      args->type,
> > > +                                      args->request_type);
> > > +             args->retval = ret;
> > > +             if (ret < 0)
> > > +                     goto out;
> > > +     } else {
> > > +             ret = -7; /* -E2BIG */
> > > +             goto out;
> > > +     }
> > > +
> > > +     __builtin_memcpy(args->data, data, sizeof(args->data));
> > > +
> > > + out:
> > > +     hid_bpf_release_context(ctx);
> > > +
> > > +     return ret;
> > > +}
> > > --
> > > 2.36.1
> > >
> >
> > --
> > Kartikeya
> >
>

--
Kartikeya
