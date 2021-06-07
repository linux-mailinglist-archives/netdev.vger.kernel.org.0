Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E485639E9F2
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 01:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFGXN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 19:13:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230237AbhFGXN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 19:13:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623107524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P38DCbZ2zirScmfD4aQLmvp8eq+ZG0trhFlH2uXjuyw=;
        b=bI2VF/KksbI13qZ5Iy21IL3mRC/4+v3AVSNE3yWE44TKh68vmo5VuV2KU78X1cvI7PkO3x
        rcbJ4KCLvMX8nTTpS4AipcRL9lRhrbF8Qn9eYE8Z/97cxfCZ6V9hC6SVcD/hKN2dgcysMa
        a+p62bHdkjKQQzW6LYk6WZaWneYsz5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-JQYaIiNKNGqSDW1ZN8by4Q-1; Mon, 07 Jun 2021 19:12:03 -0400
X-MC-Unique: JQYaIiNKNGqSDW1ZN8by4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2919107ACCA;
        Mon,  7 Jun 2021 23:11:50 +0000 (UTC)
Received: from localhost.localdomain (ovpn-114-245.phx2.redhat.com [10.3.114.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E16295C1D1;
        Mon,  7 Jun 2021 23:11:49 +0000 (UTC)
From:   Tom Stellard <tstellar@redhat.com>
To:     andrii@kernel.org
Cc:     ast@fb.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, netdev@vger.kernel.org,
        Tom Stellard <tstellar@redhat.com>
Subject: Re: [PATCH v2 bpf-next 06/11] libbpf: add BPF static linker APIs
Date:   Mon,  7 Jun 2021 23:11:46 +0000
Message-Id: <20210607231146.1077-1-tstellar@redhat.com>
In-Reply-To: <20210313193537.1548766-7-andrii@kernel.org>
References: <20210313193537.1548766-7-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

>+                               } else {
>+                                       pr_warn("relocation against STT_SECTION in non-exec section is not supported!\n");
>+                                       return -EINVAL;
>+                               }

Kernel build of commit 324c92e5e0ee are failing for me with this error
message:

/builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/bpf/bpftool/bpftool gen object /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/bind_perm.linked1.o /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/bind_perm.o
libbpf: relocation against STT_SECTION in non-exec section is not supported!

What information can I provide to help debug this failure?

Thanks,
Tom

