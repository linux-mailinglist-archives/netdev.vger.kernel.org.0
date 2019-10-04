Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B61CB4AE
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 09:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388451AbfJDHAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 03:00:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31458 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387454AbfJDHAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 03:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570172405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KZaQ85bAMS1LJJUzyDaCo073qZMTd/6G+tXD1HrzLfE=;
        b=BGB2nF6PIEJs0YBVfkzNlzrQUDU33xjzL/OwRCNxce/guJiClSqaKAv+o2BAqbEbLWEmct
        RDcDqEoesZBokHPB7gLXgF7Z8q/MzwCa9FlGJSbmlDCdGsMtZoAmDbbYiXoABbgAkw5gFl
        G4MZgrcJ8MTMSB4NlQpiqgm2RfJNyj8=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-IHacDJuUP_mSJw0Q5x90bQ-1; Fri, 04 Oct 2019 03:00:03 -0400
Received: by mail-lj1-f200.google.com with SMTP id y12so1480387ljc.8
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 00:00:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=KZaQ85bAMS1LJJUzyDaCo073qZMTd/6G+tXD1HrzLfE=;
        b=sPhucWQRbXJioH5ftg5U4bbiTUjg69RKKFma/dai82NGzpHZePZGyQnqhVxMInsXC/
         UeqWSbBLaAqXrTvJ4IznWI4VXHpESi2Yhg26f7XW5ktXvJ/n5pi9yPhtv0s5umeh7Lyb
         eytNGh5RV35Oa0i6mcKcTcIzeeLJUyF6/dSqiw9Uc6ciCWUzssg9F0NHQE6+3SeEYa0I
         pk8YZblspzloiPGT1Sgg7CTKmVykWQvxW4kFnPAOr5mPb2z5RKzOfbCcN/NQz1WfxlxP
         IT7Py1y2jxdoFPCJUcRm/Z0OPEKDwQr3IveHunJ0qCXR2csYZRG0/4xKlL9E0aQeR3ZE
         8rgQ==
X-Gm-Message-State: APjAAAUdzDiFJjibo6BHQtBoxQOKuUvVxG56veiuuhWYveWjHnGGq8Yx
        VM5D2OogHz/S8xDNgVxTPEm/O/OdsG221CCEl262C5KJy7XTFyOS9Fx9p56ku1N058puJ9qTvGd
        htbJUHHtGMHrUZ/PN
X-Received: by 2002:a2e:5b9a:: with SMTP id m26mr8452082lje.183.1570172402486;
        Fri, 04 Oct 2019 00:00:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwl0H0wV7TD9HyuWqUuNHpHT0w6ACEBTMSmq41bxeusN8zqa41S9H9wyS5F6xXI3n6j35QelQ==
X-Received: by 2002:a2e:5b9a:: with SMTP id m26mr8452068lje.183.1570172402266;
        Fri, 04 Oct 2019 00:00:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id v1sm965537lfq.89.2019.10.04.00.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 00:00:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B349318063D; Fri,  4 Oct 2019 09:00:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v3 bpf-next 1/7] selftests/bpf: undo GCC-specific bpf_helpers.h changes
In-Reply-To: <20191003212856.1222735-2-andriin@fb.com>
References: <20191003212856.1222735-1-andriin@fb.com> <20191003212856.1222735-2-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 04 Oct 2019 09:00:00 +0200
Message-ID: <875zl5ov0v.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: IHacDJuUP_mSJw0Q5x90bQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Having GCC provide its own bpf-helper.h is not the right approach and is
> going to be changed. Undo bpf_helpers.h change before moving
> bpf_helpers.h into libbpf.
>
> Acked-by: Song Liu <songliubraving@fb.com>
> Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

