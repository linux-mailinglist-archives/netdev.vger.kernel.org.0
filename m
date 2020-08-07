Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B4E23F49F
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 23:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgHGVwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 17:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHGVwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 17:52:17 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5CBC061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 14:52:17 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t4so3007152iln.1
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 14:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KwJhJkRkVep7Pv+VF6AFA8zMHTfejBP0YvxNMgM3PU8=;
        b=BCTM/Q63NQPzdviFOqJWsRLXkUJwa2CNVbORKA19Bog3XfH7KvkR2l5QRJZHgxi1se
         P95rkrYVFWFf/asGt/6vlhWaBEBhSSrt2x279iMdhUIaisTrBfN9oaYvyVMXHI8v5MsX
         zxfxP62Y94HYo6U4MAt9nCwTlmejgJ+nlDzYOOC8GaFEayk68fdEwOAnX10BIyoWfHcP
         Bb0nlQHW9rhW4wstYEn4AvQB16j2VRSrr4NEn/1Yjj40VJGD3ENBc+ino1QmTQB/bU8v
         +vn9rP38wh7jDUWOUq4285hx7S9OkGNI1NxfK50p0vOm1A0lG1TWghbJXkoqvEpuj/pL
         hCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KwJhJkRkVep7Pv+VF6AFA8zMHTfejBP0YvxNMgM3PU8=;
        b=fmdMoshhc/NT3BieoeFAoW+itke1tUM8G0JEOCUPGuJwmJfQDi6ervved5Nz07Zezq
         b4vIgKFvMdwsxxLyvseF0yxstl5i4q+n7MWy1uwsRsoAlCZqZyCSiShi2GNNfO7vVxXh
         CtTuW64dC5wLX6VzHg1XJEgUsSDHGUQIKj+BR1w53F4WZBVja5YHU2oq3T5rDTTVJ6tc
         ILpv3UgdeiZB9hJGzx8U0M3fwb+YU/yEiqLLBF3OJuZuh6c3CL0HgQZt/YKqv0DfrfEt
         LPseFpRmSR0FkZqtQBp+95ko0z9JTHkHNVLhkFywv+akIF5B5SAUVWv1tFOmOoVZEKGp
         9iLg==
X-Gm-Message-State: AOAM530CdSPUNVQA6gN+e+GV9f6y5xe8ATY42o0+yXmdEhiJL8fbxiXd
        Uq5hPR06H6Hk3lmS3dG6GW7bozdoZvwP5k1ZpyE=
X-Google-Smtp-Source: ABdhPJxgW87WTAaOKPgjrtVBtnewi83UbZPHC603EfifCn7+cIVisy+5mrbVTErcUPbYTqmNlQT+nyu14UpiQ4MLu/o=
X-Received: by 2002:a92:9116:: with SMTP id t22mr6363832ild.305.1596837136463;
 Fri, 07 Aug 2020 14:52:16 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com> <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
In-Reply-To: <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 7 Aug 2020 14:52:04 -0700
Message-ID: <CAM_iQpVAAanutBPXL366kUEbY9Q9LKDFtB32_LkStM0wcuW11w@mail.gmail.com>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
To:     =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>
Cc:     Gregory Rose <gvrose8192@gmail.com>, bugs <bugs@openvswitch.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Netdev <netdev@vger.kernel.org>, joel@joelfernandes.org
Content-Type: multipart/mixed; boundary="00000000000048a33e05ac509e65"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000048a33e05ac509e65
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 7, 2020 at 8:33 AM Johan Kn=C3=B6=C3=B6s <jknoos@google.com> wr=
ote:
>
> On Tue, Aug 4, 2020 at 8:52 AM Gregory Rose <gvrose8192@gmail.com> wrote:
> >
> >
> >
> > On 8/3/2020 12:01 PM, Johan Kn=C3=B6=C3=B6s via discuss wrote:
> > > Hi Open vSwitch contributors,
> > >
> > > We have found openvswitch is causing double-freeing of memory. The
> > > issue was not present in kernel version 5.5.17 but is present in
> > > 5.6.14 and newer kernels.
> > >
> > > After reverting the RCU commits below for debugging, enabling
> > > slub_debug, lockdep, and KASAN, we see the warnings at the end of thi=
s
> > > email in the kernel log (the last one shows the double-free). When I
> > > revert 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 ("net: openvswitch:
> > > fix possible memleak on destroy flow-table"), the symptoms disappear.
> > > While I have a reliable way to reproduce the issue, I unfortunately
> > > don't yet have a process that's amenable to sharing. Please take a
> > > look.
> > >
> > > 189a6883dcf7 rcu: Remove kfree_call_rcu_nobatch()
> > > 77a40f97030b rcu: Remove kfree_rcu() special casing and lazy-callback=
 handling
> > > e99637becb2e rcu: Add support for debug_objects debugging for kfree_r=
cu()
> > > 0392bebebf26 rcu: Add multiple in-flight batches of kfree_rcu() work
> > > 569d767087ef rcu: Make kfree_rcu() use a non-atomic ->monitor_todo
> > > a35d16905efc rcu: Add basic support for kfree_rcu() batching
> > >
> > > Thanks,
> > > Johan Kn=C3=B6=C3=B6s
> >
> > Let's add the author of the patch you reverted and the Linux netdev
> > mailing list.
> >
> > - Greg
>
> I found we also sometimes get warnings from
> https://elixir.bootlin.com/linux/v5.5.17/source/kernel/rcu/tree.c#L2239
> under similar conditions even on kernel 5.5.17, which I believe may be
> related. However, it's much rarer and I don't have a reliable way of
> reproducing it. Perhaps 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 only
> increases the frequency of a pre-existing bug.

It seems clear we have a double free on table->mask_array when
the reallocation is triggered on the destroy path.

Are you able to test the attached patch (compile tested only)?
Also note: it is generated against the latest net tree, it may not be
applied cleanly to any earlier stable release.

Thanks!

--00000000000048a33e05ac509e65
Content-Type: text/x-patch; charset="US-ASCII"; name="openvswitch.diff"
Content-Disposition: attachment; filename="openvswitch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kdkrkrbl0>
X-Attachment-Id: f_kdkrkrbl0

ZGlmZiAtLWdpdCBhL25ldC9vcGVudnN3aXRjaC9mbG93X3RhYmxlLmMgYi9uZXQvb3BlbnZzd2l0
Y2gvZmxvd190YWJsZS5jCmluZGV4IDhjMTI2NzVjYmI2Ny4uY2M3ODU5ZGI0NDVhIDEwMDY0NAot
LS0gYS9uZXQvb3BlbnZzd2l0Y2gvZmxvd190YWJsZS5jCisrKyBiL25ldC9vcGVudnN3aXRjaC9m
bG93X3RhYmxlLmMKQEAgLTI5NCw3ICsyOTQsNyBAQCBzdGF0aWMgaW50IHRibF9tYXNrX2FycmF5
X2FkZF9tYXNrKHN0cnVjdCBmbG93X3RhYmxlICp0YmwsCiB9CiAKIHN0YXRpYyB2b2lkIHRibF9t
YXNrX2FycmF5X2RlbF9tYXNrKHN0cnVjdCBmbG93X3RhYmxlICp0YmwsCi0JCQkJICAgIHN0cnVj
dCBzd19mbG93X21hc2sgKm1hc2spCisJCQkJICAgIHN0cnVjdCBzd19mbG93X21hc2sgKm1hc2ss
IGJvb2wgZGVzdHJveSkKIHsKIAlzdHJ1Y3QgbWFza19hcnJheSAqbWEgPSBvdnNsX2RlcmVmZXJl
bmNlKHRibC0+bWFza19hcnJheSk7CiAJaW50IGksIG1hX2NvdW50ID0gUkVBRF9PTkNFKG1hLT5j
b3VudCk7CkBAIC0zMTQsNiArMzE0LDExIEBAIHN0YXRpYyB2b2lkIHRibF9tYXNrX2FycmF5X2Rl
bF9tYXNrKHN0cnVjdCBmbG93X3RhYmxlICp0YmwsCiAJcmN1X2Fzc2lnbl9wb2ludGVyKG1hLT5t
YXNrc1tpXSwgbWEtPm1hc2tzW21hX2NvdW50IC0xXSk7CiAJUkNVX0lOSVRfUE9JTlRFUihtYS0+
bWFza3NbbWFfY291bnQgLTFdLCBOVUxMKTsKIAorCWlmIChkZXN0cm95KSB7CisJCWtmcmVlKG1h
c2spOworCQlyZXR1cm47CisJfQorCiAJa2ZyZWVfcmN1KG1hc2ssIHJjdSk7CiAKIAkvKiBTaHJp
bmsgdGhlIG1hc2sgYXJyYXkgaWYgbmVjZXNzYXJ5LiAqLwpAQCAtMzI2LDcgKzMzMSw4IEBAIHN0
YXRpYyB2b2lkIHRibF9tYXNrX2FycmF5X2RlbF9tYXNrKHN0cnVjdCBmbG93X3RhYmxlICp0Ymws
CiB9CiAKIC8qIFJlbW92ZSAnbWFzaycgZnJvbSB0aGUgbWFzayBsaXN0LCBpZiBpdCBpcyBub3Qg
bmVlZGVkIGFueSBtb3JlLiAqLwotc3RhdGljIHZvaWQgZmxvd19tYXNrX3JlbW92ZShzdHJ1Y3Qg
Zmxvd190YWJsZSAqdGJsLCBzdHJ1Y3Qgc3dfZmxvd19tYXNrICptYXNrKQorc3RhdGljIHZvaWQg
Zmxvd19tYXNrX3JlbW92ZShzdHJ1Y3QgZmxvd190YWJsZSAqdGJsLCBzdHJ1Y3Qgc3dfZmxvd19t
YXNrICptYXNrLAorCQkJICAgICBib29sIGRlc3Ryb3kpCiB7CiAJaWYgKG1hc2spIHsKIAkJLyog
b3ZzLWxvY2sgaXMgcmVxdWlyZWQgdG8gcHJvdGVjdCBtYXNrLXJlZmNvdW50IGFuZApAQCAtMzM3
LDcgKzM0Myw3IEBAIHN0YXRpYyB2b2lkIGZsb3dfbWFza19yZW1vdmUoc3RydWN0IGZsb3dfdGFi
bGUgKnRibCwgc3RydWN0IHN3X2Zsb3dfbWFzayAqbWFzaykKIAkJbWFzay0+cmVmX2NvdW50LS07
CiAKIAkJaWYgKCFtYXNrLT5yZWZfY291bnQpCi0JCQl0YmxfbWFza19hcnJheV9kZWxfbWFzayh0
YmwsIG1hc2spOworCQkJdGJsX21hc2tfYXJyYXlfZGVsX21hc2sodGJsLCBtYXNrLCBkZXN0cm95
KTsKIAl9CiB9CiAKQEAgLTQ3MCw3ICs0NzYsNyBAQCBzdGF0aWMgdm9pZCB0YWJsZV9pbnN0YW5j
ZV9mbG93X2ZyZWUoc3RydWN0IGZsb3dfdGFibGUgKnRhYmxlLAogCQkJdGFibGUtPnVmaWRfY291
bnQtLTsKIAl9CiAKLQlmbG93X21hc2tfcmVtb3ZlKHRhYmxlLCBmbG93LT5tYXNrKTsKKwlmbG93
X21hc2tfcmVtb3ZlKHRhYmxlLCBmbG93LT5tYXNrLCAhY291bnQpOwogfQogCiBzdGF0aWMgdm9p
ZCB0YWJsZV9pbnN0YW5jZV9kZXN0cm95KHN0cnVjdCBmbG93X3RhYmxlICp0YWJsZSwKQEAgLTUy
MSw5ICs1MjcsOSBAQCB2b2lkIG92c19mbG93X3RibF9kZXN0cm95KHN0cnVjdCBmbG93X3RhYmxl
ICp0YWJsZSkKIAlzdHJ1Y3QgbWFza19jYWNoZSAqbWMgPSByY3VfZGVyZWZlcmVuY2VfcmF3KHRh
YmxlLT5tYXNrX2NhY2hlKTsKIAlzdHJ1Y3QgbWFza19hcnJheSAqbWEgPSByY3VfZGVyZWZlcmVu
Y2VfcmF3KHRhYmxlLT5tYXNrX2FycmF5KTsKIAorCXRhYmxlX2luc3RhbmNlX2Rlc3Ryb3kodGFi
bGUsIHRpLCB1ZmlkX3RpLCBmYWxzZSk7CiAJY2FsbF9yY3UoJm1jLT5yY3UsIG1hc2tfY2FjaGVf
cmN1X2NiKTsKIAljYWxsX3JjdSgmbWEtPnJjdSwgbWFza19hcnJheV9yY3VfY2IpOwotCXRhYmxl
X2luc3RhbmNlX2Rlc3Ryb3kodGFibGUsIHRpLCB1ZmlkX3RpLCBmYWxzZSk7CiB9CiAKIHN0cnVj
dCBzd19mbG93ICpvdnNfZmxvd190YmxfZHVtcF9uZXh0KHN0cnVjdCB0YWJsZV9pbnN0YW5jZSAq
dGksCg==
--00000000000048a33e05ac509e65--
