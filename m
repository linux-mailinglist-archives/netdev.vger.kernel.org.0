Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C656E570E0
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 20:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfFZSmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 14:42:05 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43826 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZSmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 14:42:05 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so3500762qto.10;
        Wed, 26 Jun 2019 11:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Olj9NsjnjAh6Tgg1Gwb5/K9RkM45q8z0K/+i0cP8wzg=;
        b=EvAnFbPEg0X7cpYb3EbofwUPNzzwsOui0ix43g0aW36mg6i5bi8mlxqtZmeCYtmCKg
         nuoPHRFIH9H7Kdhf86icxQWknITSdksL1shAWdGNPUjLdJEEvzssXIQzvybyb2ej12uB
         A1Cs8JWV0OcWuw7FML8QkcDKv6L7bomcktsue5WD3T9lagr0IQHTaJoXYQ0lNfNlZsjm
         Nb00u3pFKs/OCjxYPIaKdo6LwA+LaX5+NDEMyFnEg7ke8CzYXBW0rnww1Xy09V4cmO7n
         rtrZgW7yxYXgTo2ShM7OffuhYK3zsgAnxmOOj0AWOeT9Z/Q+nxR794R0jr7MnGPdyyt5
         WYJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Olj9NsjnjAh6Tgg1Gwb5/K9RkM45q8z0K/+i0cP8wzg=;
        b=F3t7/QsdV0dg4S+odAqcL4GhIvNt5lwm8HLIzGtxXSg5spDqDdIQPFAv5eVp4wTYAR
         PA1odMgarLGdWhQqT8LcUVvv0+LabA2Pq6+fwEbOXoWTKlA6LGQwBnoVRF0SWSECSmUH
         ScnQVbPYvk22f62NBfX1m1EiyxZpJWZdVrTZ1i1ixuc6UlNCytPs2uZ87qfTpvlcmMdz
         c5THCMLqAWun2g33VemklagneBemf7zTt/4r9Py6InguOvarHcRg6xvhTVuWYLpc/+w2
         I4RO8yQiAo++D5pg/oQBfv0RYUl+RNcatr+QLwwXHK1lH7tFiwWTQjTX9+DxBruDVjgh
         aftQ==
X-Gm-Message-State: APjAAAURRXFSbL3QRD0PCDVqya/Zyi6k9H3FdJuO+G25vlkDsKJKh0cx
        dSeXWvAtm8EZAdUhBMciLW9cRCd6/7jedvWcQKk=
X-Google-Smtp-Source: APXvYqx9fJI7HkqIEv4QMf4ebGG5Xscc0XJezem0IoEEm+2aYGHpEDiuhFvZ4/rb1mqfZ5YGfTYjpgfzBbi83hdNsZQ=
X-Received: by 2002:ac8:1725:: with SMTP id w34mr915626qtj.117.1561574524261;
 Wed, 26 Jun 2019 11:42:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190626061235.602633-1-andriin@fb.com> <877e98d0hp.fsf@toke.dk>
In-Reply-To: <877e98d0hp.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 Jun 2019 11:41:53 -0700
Message-ID: <CAEf4BzZozWBanXnjJguYT46v8huAS7Wz44MHFHJkAPBZbT-i6A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/3] libbpf: add perf buffer abstraction and API
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 4:55 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > This patchset adds a high-level API for setting up and polling perf buf=
fers
> > associated with BPF_MAP_TYPE_PERF_EVENT_ARRAY map. Details of APIs are
> > described in corresponding commit.
> >
> > Patch #1 adds a set of APIs to set up and work with perf buffer.
> > Patch #2 enhances libbpf to supprot auto-setting PERF_EVENT_ARRAY map s=
ize.
> > Patch #3 adds test.
>
> Having this in libbpf is great! Do you have a usage example of how a
> program is supposed to read events from the buffer? This is something we
> would probably want to add to the XDP tutorial

Did you check patch #3 with selftest? It's essentially an end-to-end
example of how to set everything up and process data (in my case it's
just simple int being sent as a sample, but it's exactly the same with
more complicated structs). I didn't bother to handle lost samples
notification, but it's just another optional callback with a single
counter denoting how many samples were dropped.

Let me know if it's still unclear.

>
> -Toke
