Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83BC18C928
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 09:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgCTIsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 04:48:16 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:33350 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726527AbgCTIsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 04:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584694094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kuU6eXxKFxUXML143fYL9OeD0B6kZs/JQK09NJI7vaw=;
        b=HnPSJ2DA6MOY1e191jgMa+dTnvR7h7VP15JIbwuUTo+6b4jvOpWRdZpkzeXCt6RV/KzyVi
        i9QqMUAamtD0o1ajzh4AZmGK7gKWbyeWNpLpIUlRXJlwK2XcOioUydTzSa0rVRd30FGl54
        hnBvkTgDvenRM71dkkfl42KctRQm3wM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-kl-absMMPp2gZYgMdwDbSA-1; Fri, 20 Mar 2020 04:48:12 -0400
X-MC-Unique: kl-absMMPp2gZYgMdwDbSA-1
Received: by mail-wr1-f69.google.com with SMTP id q18so2305104wrw.5
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 01:48:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kuU6eXxKFxUXML143fYL9OeD0B6kZs/JQK09NJI7vaw=;
        b=uRBtHl3RdpBjSowgvwahpBFCzl7F1EAICH5BaaiIqbmbO2i8uyPGV4qWlm2r7d2GV5
         ixkRfMA89Ij1/ejuX1u+L8B4Zqd1tqvNsukN0Zfq8j77JNkCDzL6UFh1LlejSwF6HFzH
         2CHtmKUKy7ELd1CIk0qNnE0kUifj7vABIpc31k5x97x4t25C0LqlKWtj4o1FOeJ5DKzV
         irLYZ9joOM73+QepmH+mPRahifg4u+TlYEHE3DDz5N3TL3TPRyn/Vnp+oZlhxlnTJmJj
         FJJ1qInkKmWe7RbLWEveL0HGoIAkeNZniaSLK9A2mWUOnnBkoKczCezvwF58DK92S82F
         ZBKw==
X-Gm-Message-State: ANhLgQ2YEK1OjsHhakdkURShgqCk5JmnAd/Bgl7n9NYVuXbL2Q9gmIkX
        IgRh6/GJVn9VdLRbDf01tmT6XbV5KRHIZ6/oSh8f/RKDR3jPQsvYR5hlApr6eIbubnoe/UPjjvo
        /ZWA7IE8FkdOXTvxT
X-Received: by 2002:a5d:5503:: with SMTP id b3mr9889313wrv.419.1584694091705;
        Fri, 20 Mar 2020 01:48:11 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtUfvpi3QB5T7t/kkB8+Fdi79oHe5zW4N9NEpIQZDcnacftEUtknDYjj5ex995wkUKbqfkTKA==
X-Received: by 2002:a5d:5503:: with SMTP id b3mr9889271wrv.419.1584694091424;
        Fri, 20 Mar 2020 01:48:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d124sm2748648wmd.37.2020.03.20.01.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 01:48:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3B6BB180371; Fri, 20 Mar 2020 09:48:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk> <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 20 Mar 2020 09:48:10 +0100
Message-ID: <875zez76ph.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>=20
>> While it is currently possible for userspace to specify that an existing
>> XDP program should not be replaced when attaching to an interface, there=
 is
>> no mechanism to safely replace a specific XDP program with another.
>>=20
>> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, which can=
 be
>> set along with IFLA_XDP_FD. If set, the kernel will check that the progr=
am
>> currently loaded on the interface matches the expected one, and fail the
>> operation if it does not. This corresponds to a 'cmpxchg' memory operati=
on.
>>=20
>> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to explicitly
>> request checking of the EXPECTED_FD attribute. This is needed for usersp=
ace
>> to discover whether the kernel supports the new attribute.
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> I didn't know we wanted to go ahead with this...

Well, I'm aware of the bpf_link discussion, obviously. Not sure what's
happening with that, though. So since this is a straight-forward
extension of the existing API, that doesn't carry a high implementation
cost, I figured I'd just go ahead with this. Doesn't mean we can't have
something similar in bpf_link as well, of course.

> If we do please run this thru checkpatch, set .strict_start_type,

Will do.

> and make the expected fd unsigned. A negative expected fd makes no
> sense.

A negative expected_fd corresponds to setting the UPDATE_IF_NOEXIST
flag. I guess you could argue that since we have that flag, setting a
negative expected_fd is not strictly needed. However, I thought it was
weird to have a "this is what I expect" API that did not support
expressing "I expect no program to be attached".

-Toke

