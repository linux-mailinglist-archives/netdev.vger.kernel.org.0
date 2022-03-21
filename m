Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50724E32EE
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 23:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiCUWry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 18:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiCUWrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:47:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E612636E819;
        Mon, 21 Mar 2022 15:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D205B81A4D;
        Mon, 21 Mar 2022 22:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C557C340F8;
        Mon, 21 Mar 2022 22:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647900223;
        bh=Q7gazwmOiF1+pGMUPd49Zh6pNO4LTkSrTEg1R9lEwig=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UcdkgUCRnjf+T4JeLeEPezb1Ad/rZaYpJCzlzw+MAAsHZhewgbzIci6bVvXeWCs3C
         NzLq0oOHw++hHBtel/l5NqWbtchprKX2E14ME0S7FxWGfQvfi7reAx0ZORM37A0AFS
         4XjpUf2TOohmM14Hs9nJ99b1zg9xmXHgBi8RZgF7Rq9IxmH7SW14mSK9MQBLb9eELd
         7XFOSDInMs4wfF8UxggDApnwTbmYaeaFdMIpzIKYrkeRFrJbRlEcBna5w7AimpJSLk
         Ah3ogsoHbm7In2pe4B/cEo5qE2fknhVVv35bIDnqPjdO/wY6ZRoSiubeWOg2KKj67b
         6HqQcv3FYlyrA==
Received: by mail-yb1-f171.google.com with SMTP id z8so30552512ybh.7;
        Mon, 21 Mar 2022 15:03:43 -0700 (PDT)
X-Gm-Message-State: AOAM53198xCckhrOc75EsO+z744t/vpjDxCgYcQH61yC3eBCY4R3tamZ
        gnJbi8J2ITYvz2wC+9x5ENVg26ptNpkMecKnH9Q=
X-Google-Smtp-Source: ABdhPJwUdLaKpQIQDkJmLsTAFWXPlXvioL7Q/635HKNveO8Z14I2OOLoc+cD3XHJ0vLQNRs6TluOSbPrGrvsR6WLsik=
X-Received: by 2002:a25:8b81:0:b0:629:17d5:68c1 with SMTP id
 j1-20020a258b81000000b0062917d568c1mr23210434ybl.449.1647900222062; Mon, 21
 Mar 2022 15:03:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
 <20220318161528.1531164-7-benjamin.tissoires@redhat.com> <CAPhsuW64x8_m1pNN9gC8LA8ajAmy+5O3y+iOaC7ixSXU=J624Q@mail.gmail.com>
 <CAO-hwJL+A5hqzGBCVCtp4diuM-_Aii+HAKNfz5oMZBTHCQrEkQ@mail.gmail.com>
In-Reply-To: <CAO-hwJL+A5hqzGBCVCtp4diuM-_Aii+HAKNfz5oMZBTHCQrEkQ@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 21 Mar 2022 15:03:31 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7W_pGHFb4MyZHaFk9TV9zYaLXoTS_0hLoeqGOB8htRBg@mail.gmail.com>
Message-ID: <CAPhsuW7W_pGHFb4MyZHaFk9TV9zYaLXoTS_0hLoeqGOB8htRBg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 06/17] HID: allow to change the report
 descriptor from an eBPF program
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
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 9:20 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Fri, Mar 18, 2022 at 10:10 PM Song Liu <song@kernel.org> wrote:
> >
> > On Fri, Mar 18, 2022 at 9:17 AM Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> > >
> > > Make use of BPF_HID_ATTACH_RDESC_FIXUP so we can trigger an rdesc fixup
> > > in the bpf world.
> > >
> > > Whenever the program gets attached/detached, the device is reconnected
> > > meaning that userspace will see it disappearing and reappearing with
> > > the new report descriptor.
> > >
> > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > >
> > > ---
> > >
> > > changes in v3:
> > > - ensure the ctx.size is properly bounded by allocated size
> > > - s/link_attached/post_link_attach/
> > > - removed the switch statement with only one case
> > >
> > > changes in v2:
> > > - split the series by bpf/libbpf/hid/selftests and samples
> > > ---
> > >  drivers/hid/hid-bpf.c  | 62 ++++++++++++++++++++++++++++++++++++++++++
> > >  drivers/hid/hid-core.c |  3 +-
> > >  include/linux/hid.h    |  6 ++++
> > >  3 files changed, 70 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
> > > index 5060ebcb9979..45c87ff47324 100644
> > > --- a/drivers/hid/hid-bpf.c
> > > +++ b/drivers/hid/hid-bpf.c
> > > @@ -50,6 +50,14 @@ static struct hid_device *hid_bpf_fd_to_hdev(int fd)
> > >         return hdev;
> > >  }
> > >
> > > +static int hid_reconnect(struct hid_device *hdev)
> > > +{
> > > +       if (!test_and_set_bit(ffs(HID_STAT_REPROBED), &hdev->status))
> > > +               return device_reprobe(&hdev->dev);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > >  static int hid_bpf_pre_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
> > >  {
> > >         int err = 0;
> > > @@ -92,6 +100,12 @@ static int hid_bpf_pre_link_attach(struct hid_device *hdev, enum bpf_hid_attach_
> > >         return err;
> > >  }
> > >
> > > +static void hid_bpf_post_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
> > > +{
> > > +       if (type == BPF_HID_ATTACH_RDESC_FIXUP)
> > > +               hid_reconnect(hdev);
> > > +}
> > > +
> > >  static void hid_bpf_array_detach(struct hid_device *hdev, enum bpf_hid_attach_type type)
> > >  {
> > >         switch (type) {
> > > @@ -99,6 +113,9 @@ static void hid_bpf_array_detach(struct hid_device *hdev, enum bpf_hid_attach_ty
> > >                 kfree(hdev->bpf.device_data);
> > >                 hdev->bpf.device_data = NULL;
> > >                 break;
> > > +       case BPF_HID_ATTACH_RDESC_FIXUP:
> > > +               hid_reconnect(hdev);
> > > +               break;
> > >         default:
> > >                 /* do nothing */
> > >                 break;
> > > @@ -116,6 +133,9 @@ static int hid_bpf_run_progs(struct hid_device *hdev, struct hid_bpf_ctx_kern *c
> > >         case HID_BPF_DEVICE_EVENT:
> > >                 type = BPF_HID_ATTACH_DEVICE_EVENT;
> > >                 break;
> > > +       case HID_BPF_RDESC_FIXUP:
> > > +               type = BPF_HID_ATTACH_RDESC_FIXUP;
> > > +               break;
> > >         default:
> > >                 return -EINVAL;
> > >         }
> > > @@ -155,11 +175,53 @@ u8 *hid_bpf_raw_event(struct hid_device *hdev, u8 *data, int *size)
> > >         return ctx.data;
> > >  }
> > >
> > > +u8 *hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size)
> > > +{
> > > +       int ret;
> > > +       struct hid_bpf_ctx_kern ctx = {
> > > +               .type = HID_BPF_RDESC_FIXUP,
> > > +               .hdev = hdev,
> > > +               .size = *size,
> > > +       };
> > > +
> > > +       if (bpf_hid_link_empty(&hdev->bpf, BPF_HID_ATTACH_RDESC_FIXUP))
> >
> > Do we need to lock bpf_hid_mutex before calling bpf_hid_link_empty()?
> > (or maybe we
> > already did?)
>
> The mutex is not locked before this call, indeed.
>
> However, bpf_hid_link_empty() is an inlined function that just calls
> in the end list_empty(). Given that all the list heads are created
> just once for the entire life of the HID device, I *think* this is
> thread safe and does not require mutex locking.

Hmm.. I guess you are right.

>
> (I might be wrong)
>
> So when first plugging in the device, if there is a fighting process
> that attempts to add a program, if the program managed to insert
> itself before we enter this code, then the list won't be empty and we
> will execute BPF_PROG_RUN_ARRAY(), and if not, well, we ignore it and
> wait for reconnect().
>
> But now I am starting to wonder if I need to also protect
> BPF_PROG_RUN_ARRAY() under bpf_hid_mutex...

I think this is not necessary.

Thanks,
Song
