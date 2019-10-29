Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7DEE82EE
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 09:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfJ2IGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 04:06:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33019 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726246AbfJ2IGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 04:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572336359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YaB5XtQ/QGZvr2h5W63rFZo7WkD/6qyYty4a6W3kSYg=;
        b=UvTBEIG492F20bAPkAMLKh0+H2y5TpmjZcQ/o6U3/oaC4wTbSQLcl54csdINddRoYpxbsd
        WRbw1Iy3N1AlO2pQZv8Aib/ZIMUQleNxiqTiDt8z/+iVOevjaCqsttaEpLbU4N4W05RIEa
        I534G9d1SFE8gyXHykazjvZS/H1QaWY=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-YBUi7P3JNi2I4hbtwyYoDg-1; Tue, 29 Oct 2019 04:05:57 -0400
Received: by mail-lf1-f72.google.com with SMTP id r21so2565716lff.1
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 01:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rLGoW7SRG4SMfs2KFUdiBrGDzI0FTu0D10Lnaw21e2w=;
        b=VG5VbNfZ5XKfa+pVYdaGfSZyYgtOMb0Wmo1n6ApUtj2iEPobWWcQFWUokg77w6/wEC
         Il2qvc1zhX0UfV3MNpfNmHdzXyfOfgadfJMJROQB7Lnj5AacENZVTE6/8AfMJQLZOxGD
         tnw0F0ZJFnEHwDmZxchv0wabp0uR+cwjfp5VzMOuLi62DViygZmJtI7D1eT1XqizKAHv
         MNTCDcVfqkNGOSRAW/RZsoDjGlWgevNca25TsOq5cIELUPnf0V0mN34bJsLxXAtRv2P6
         TrV7+cxCJjWROoS0/3gTKD4fOoRTpzBcuL8qDd3rCoqFk/ZWD0ihyboegmW4WdBHUhS0
         5RLQ==
X-Gm-Message-State: APjAAAXqLOgukY/l8UrNUbtwd8zLCl2Q1q/Ps10r0zIpmKpjoD1Rr4c9
        /CglfvrXJLid7PsFJpmXLoSRL/H+v1903PdPo3Dwj+QjDE3668gM3r0xduWleZqgTOiRj47g7MI
        7KgUtBAoYZL/RYq7P
X-Received: by 2002:a05:651c:ce:: with SMTP id 14mr1507306ljr.23.1572336356448;
        Tue, 29 Oct 2019 01:05:56 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzJsOBMRDixarYBapn4qSz+u/tA8XqjuW+RpKGFNawFnUPPOXneS0LHPE70VJ/fIbfF/6PbNA==
X-Received: by 2002:a05:651c:ce:: with SMTP id 14mr1507294ljr.23.1572336356300;
        Tue, 29 Oct 2019 01:05:56 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b23sm7638795lfj.49.2019.10.29.01.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 01:05:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 719931818B6; Tue, 29 Oct 2019 09:05:54 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Subject: Re: [PATCH bpf-next] libbpf: don't use kernel-side u32 type in xsk.c
In-Reply-To: <20191029055953.2461336-1-andriin@fb.com>
References: <20191029055953.2461336-1-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 29 Oct 2019 09:05:54 +0100
Message-ID: <87ftjcrn6l.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: YBUi7P3JNi2I4hbtwyYoDg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> u32 is a kernel-side typedef. User-space library is supposed to use __u32=
.
> This breaks Github's projection of libbpf. Do u32 -> __u32 fix.

I've always wondered about this, actually. Why are they different?

-Toke

