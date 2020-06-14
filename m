Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABC41F8A14
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 20:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgFNS3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 14:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgFNS3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 14:29:46 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAC3C05BD43
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 11:29:46 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id w18so15469929iom.5
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 11:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yfs7e4NvAJzVgfHa8t7wQvMlJdIEcQhvmiD7X4ee2Ws=;
        b=vYvx4bkpeU1dE9cizDm1Q1iF2gkDtlqHaH/3Gj49EWKJCfW0MFcF7v2aRrp8OCOQLt
         qoeKM59ZUtoglTcoJTGh3aa2I2r1/kwSswgLOUjvYSA5LuAbYGPepZ0XEKZL2Xm3MhWi
         Pxm7pZtBHpcJQzsQnugb4TnYRc84eqMriT+/4XETdNO/wJRcNwa1+G3Cbpv8Uu77PZGq
         x0qJ/rIhHgNHeDGGrgtz4gVBKK+JvdnbJI0xZ1Mp4tv1URGZNowk6eSR7OuxuvCp2Bt8
         hZTQ38WLAg3Nr873+d5BkUmYll6aa136x69su0PDV7EK5FrSnPhbJtt6EwehBaB0M1fi
         IQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yfs7e4NvAJzVgfHa8t7wQvMlJdIEcQhvmiD7X4ee2Ws=;
        b=ZxFL6l+uaCy0i1sPBLz1uIct6XV6YB4Puk8fTGR2v/T2y/yxRY7VO8FmWAeTfNBXgl
         c2br1qRnXPf7BxtKhaX8/TIdkpM4r5zpHwwMZqW3Tmu4SG6YC+4qFL4UijqU0BvnS6/I
         A4DUIoxNZVmV0mcM2TgrHvoyI610djlCW1k5SYJW8NLxtqXlH27HOrIZDD7zUDmJbCgc
         9ZP4xNJnDQWlziDFSdAkhPlIfPz0AgVGEQOnF574n0OePw408IxhcavizlWC8Z4cH0pc
         7Xr7pcZ2iuUOM7QduF5ip//nutC/9/cw08vZs+qFTuU0MJbTqqk2NzxstBqdyjejDpa2
         O6WQ==
X-Gm-Message-State: AOAM532C7+xktybqH5rd+tOd7b0vl+D+rEFwx5i5OHaI5pc3qBYLitUW
        ui2R6dq6npNS5bx+EtoYRueTmg43oUeYW3B7E1NEqw==
X-Google-Smtp-Source: ABdhPJzUa0KLg/mrXVLJFzPCdq0eYJhilZCtaQRAhLNry+xTImSXPTliX8n8j7tNHgxynrFbd2lzv3VfUt77O/5ikxU=
X-Received: by 2002:a05:6638:216:: with SMTP id e22mr18242120jaq.16.1592159385400;
 Sun, 14 Jun 2020 11:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAMtihapJKityT=urbrx2yq-csRQ4u7Vcosrf0NzUZtrHfmN0cQ@mail.gmail.com>
In-Reply-To: <CAMtihapJKityT=urbrx2yq-csRQ4u7Vcosrf0NzUZtrHfmN0cQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 14 Jun 2020 11:29:34 -0700
Message-ID: <CAM_iQpUKQJrj8wE+Qa8NGR3P0L+5Uz=qo-O5+k_P60HzTde6aw@mail.gmail.com>
Subject: Re: BUG: kernel NULL pointer dereference in __cgroup_bpf_run_filter_skb
To:     =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000098111d05a80f7e43"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000098111d05a80f7e43
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Sun, Jun 14, 2020 at 5:39 AM Dani=C3=ABl Sonck <dsonck92@gmail.com> wrot=
e:
>
> Hello,
>
> I found on the archive that this bug I encountered also happened to
> others. I too have a very similar stacktrace. The issue I'm
> experiencing is:
>
> Whenever I fully boot my cluster, in some time, the host crashes with
> the __cgroup_bpf_run_filter_skb NULL pointer dereference. This has
> been sporadic enough before not to cause real issues. However, as of
> lately, the bug is triggered much more frequently. I've changed my
> server hardware so I could capture serial output in order to get the
> trace. This trace looked very similar as reported by Lu Fengqi. As it
> currently stands, I cannot run the cluster as it's almost instantly
> crashing the host.

This has been reported for multiple times. Are you able to test the
attached patch? And let me know if everything goes fine with it.

I suspect we may still leak some cgroup refcnt even with the patch,
but it might be much harder to trigger with this patch applied.

Thanks.

--00000000000098111d05a80f7e43
Content-Type: text/x-patch; charset="US-ASCII"; name="cgroup_sk_alloc.diff"
Content-Disposition: attachment; filename="cgroup_sk_alloc.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kbfehg0l0>
X-Attachment-Id: f_kbfehg0l0

ZGlmZiAtLWdpdCBhL2tlcm5lbC9jZ3JvdXAvY2dyb3VwLmMgYi9rZXJuZWwvY2dyb3VwL2Nncm91
cC5jCmluZGV4IDZjOWM2YWM4MzkzNi4uYzAxMjQ1YTE5ZWEyIDEwMDY0NAotLS0gYS9rZXJuZWwv
Y2dyb3VwL2Nncm91cC5jCisrKyBiL2tlcm5lbC9jZ3JvdXAvY2dyb3VwLmMKQEAgLTY0MzgsOSAr
NjQzOCw2IEBAIHZvaWQgY2dyb3VwX3NrX2FsbG9jX2Rpc2FibGUodm9pZCkKIAogdm9pZCBjZ3Jv
dXBfc2tfYWxsb2Moc3RydWN0IHNvY2tfY2dyb3VwX2RhdGEgKnNrY2QpCiB7Ci0JaWYgKGNncm91
cF9za19hbGxvY19kaXNhYmxlZCkKLQkJcmV0dXJuOwotCiAJLyogU29ja2V0IGNsb25lIHBhdGgg
Ki8KIAlpZiAoc2tjZC0+dmFsKSB7CiAJCS8qCkBAIC02NDUzLDYgKzY0NTAsOSBAQCB2b2lkIGNn
cm91cF9za19hbGxvYyhzdHJ1Y3Qgc29ja19jZ3JvdXBfZGF0YSAqc2tjZCkKIAkJcmV0dXJuOwog
CX0KIAorCWlmIChjZ3JvdXBfc2tfYWxsb2NfZGlzYWJsZWQpCisJCXJldHVybjsKKwogCS8qIERv
bid0IGFzc29jaWF0ZSB0aGUgc29jayB3aXRoIHVucmVsYXRlZCBpbnRlcnJ1cHRlZCB0YXNrJ3Mg
Y2dyb3VwLiAqLwogCWlmIChpbl9pbnRlcnJ1cHQoKSkKIAkJcmV0dXJuOwo=
--00000000000098111d05a80f7e43--
