Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B1035E94D
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhDMWz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhDMWzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 18:55:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8C5C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 15:55:33 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso11464022pji.3
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 15:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=PeN81Pk7NHS/sFAwHrIrx5yG5gdE6k+VRFKTb5GbTts=;
        b=ngLgUI/hJ6LXV8iqIuLYqx0mAEYcnrSME04j3JQPfekNYWBA2yZeh64M7mQ5xy7A55
         1tFgvw9l1USCnXofKzAn09yeRdmY7cWMTknZL+eon///CLds2OZ0nOB7/SikmtlWtEGJ
         WSmrveR3aUJLwCwQpyIi6iKJzKSmHm1SPYvX7u708S9Y+J4zA22dHxo9KBCGQYxOV25e
         rmrSdmn+zeEccfo6aT0w6pr9biGWj70+i52QOOjuYlY73JIguYPa6VXpYw6q7KVqJE20
         DtBSpqnLQeIjSKi42LCXycZNhTf9Jdrt6txW/isaUuSmviCIGdOD9YF1HTP2lobAR7L8
         B5/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=PeN81Pk7NHS/sFAwHrIrx5yG5gdE6k+VRFKTb5GbTts=;
        b=a0cr8Q7TyMO4mSixVyMdv3Yh8lZ8itk7HjtJe1ShqhuSuWIZh2AGJYPUUk09Oo0bUw
         4Aht/BHjFq+CSxIm4tsYDb7ogfQkyG1i4fjK+VfnOz/oVSqNbjsSeO7K9q3FnMLrMRaD
         PZIeAGnsva1xDmZ6LLQPiTtAzZ26G4EYb716fVlNU1znRN10CfsYsTYhNuWfbDKo8hOD
         3q2miqLaPFg5iKNb4lodzQBdj1xJwqow7Q4IYOZJQ9isoyR6CWQ233j5n3983jJteuhd
         DX4A2ky8R6Pg0BtMDhdc2AyxxA4iM93iW86qLP+U9WPEbYP+nnmfJCsz/8eQTSBl9CWG
         G9MQ==
X-Gm-Message-State: AOAM533iLUKEujgfdHGXePkRi+jyhYa8Qwl5jYaUSrLkHt00Dbqgqi2e
        vqKEee/lU0EDDMvlzTHJICGI4uEv3wnFYrXnXSU=
X-Google-Smtp-Source: ABdhPJz06rkxkxdgXua9ywFh+PHDZ1RTbyReFwWLL6KSWCH5fQMB0fdIH6ckx7mzbVIIcjwhMYlZL8pfYVuStulZNgU=
X-Received: by 2002:a17:903:22c7:b029:e6:faf5:eb3a with SMTP id
 y7-20020a17090322c7b02900e6faf5eb3amr34818185plg.23.1618354532615; Tue, 13
 Apr 2021 15:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <4FE5BFAB-1988-4CA9-9B97-CEF73396B4EC@purdue.edu>
In-Reply-To: <4FE5BFAB-1988-4CA9-9B97-CEF73396B4EC@purdue.edu>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 13 Apr 2021 15:55:21 -0700
Message-ID: <CAJht_EN-7OPijuS4kjqL71tfQHcg_aa9c9SZSQBmSvcNP5fFow@mail.gmail.com>
Subject: Re: A data race between fanout_demux_rollover() and __fanout_unlink()
To:     "eyal.birger@gmail.com" <eyal.birger@gmail.com>,
        "yonatanlinik@gmail.com" <yonatanlinik@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 1:51 PM Gong, Sishuai <sishuai@purdue.edu> wrote:
>
> Hi,
>
> We found a data race in linux-5.12-rc3 between af_packet.c functions fano=
ut_demux_rollover() and __fanout_unlink() and we are able to reproduce it u=
nder x86.
>
> When the two functions are running together, __fanout_unlink() will grab =
a lock and modify some attribute of packet_fanout variable, but fanout_demu=
x_rollover() may or may not see this update depending on different interlea=
vings, as shown in below.
>
> Currently, we didn=E2=80=99t find any explicit errors due to this data ra=
ce. But in fanout_demux_rollover(), we noticed that the data-racing variabl=
e is involved in the later operation, which might be a concern.
>
> ------------------------------------------
> Execution interleaving
>
> Thread 1                                                        Thread 2
>
> __fanout_unlink()                                               fanout_de=
mux_rollover()
> spin_lock(&f->lock);
>                                                                         p=
o =3D pkt_sk(f->arr[idx]);
>                                                                         /=
/ po is a out-of-date value
> f->arr[i] =3D f->arr[f->num_members - 1];
> spin_unlock(&f->lock);
>
>
>
> Thanks,
> Sishuai

CC'ing more people.
