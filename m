Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D06C2529ED
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgHZJ0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:26:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24458 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728067AbgHZJ0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:26:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598433975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=agp/hO3HA0Z0hfUFtsmDs9RtARVSFqoaGKCQpLnO2Ok=;
        b=N3JpjTIMh+iF8460yynV+pLkmnMcPXdYwvu19bISB5HwlBZPmWa0piNz6Z5meC4FQ1dfhQ
        KomH+Kb/Ih9TdITv+90qXk7kCQ39nn4NCMohXWk98o/MtJjIK5J5zxn+ALU8SKG6ZP06vH
        FIJYIdSmxfHRNed6d9eyC6Sz7upxdCQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-F-M6_ezKM320m4_B7My6OA-1; Wed, 26 Aug 2020 05:26:13 -0400
X-MC-Unique: F-M6_ezKM320m4_B7My6OA-1
Received: by mail-wm1-f71.google.com with SMTP id b73so552363wmb.0
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:26:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=agp/hO3HA0Z0hfUFtsmDs9RtARVSFqoaGKCQpLnO2Ok=;
        b=hqODzDLLaQTfMDuugxyzxOtLk0jf1TaFlXkNvL7byrxQq9Q0A+Jms7XTqDcmhN1SUc
         UHK+yS8sPuZc0uqO00Q6AAopXSHfgpXR243YybaLxvUZA5MfZoSHJSmjXQTtRS8dgEQW
         J8CziaJwAVAass3ah7v5QL7BeIJ5lHcJm4FYkVfzy4W2W0QF1IcYzetfeeQd939IR0ZM
         mTLnAwQHVADU34tUJe7jiYPKIE69J1m2yW7zubrMbkhsrw7I+X597S7pZacs4u1rOCTX
         2E5yn6bZcDA76MvAqWSY9sBCwQOhAl+g+rufuPV6+3reZlLd1DCWGx3amFgNrSzpEexy
         g45g==
X-Gm-Message-State: AOAM5336dsG4poyval7CIPlBn4GYkQ04QocxfVU+WuT8M8Puql8KKszk
        ofgvCuLUuTHNIFm1Phucm83cVEnY2qixN+sNe6pwiCiyL0XG0N2C1Ma9rzpipeyCKCn8YqzDi+L
        OBA35IkahpoVx/PGN
X-Received: by 2002:a1c:f402:: with SMTP id z2mr5905008wma.87.1598433972521;
        Wed, 26 Aug 2020 02:26:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjBNfA0JkDm5pSERTTkgDewo1suo1L4gWLGvbKyUyxju95Q1RgGFF9tew89G/0ciNae8pP+A==
X-Received: by 2002:a1c:f402:: with SMTP id z2mr5904993wma.87.1598433972345;
        Wed, 26 Aug 2020 02:26:12 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j8sm4780813wrs.22.2020.08.26.02.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:26:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 638F2182B6D; Wed, 26 Aug 2020 11:26:11 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Udip Pant <udippant@fb.com>, Udip Pant <udippant@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 0/4] bpf: verifier: use target program's
 type for access verifications
In-Reply-To: <20200825232003.2877030-1-udippant@fb.com>
References: <20200825232003.2877030-1-udippant@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 26 Aug 2020 11:26:11 +0200
Message-ID: <87wo1lwyfg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Udip Pant <udippant@fb.com> writes:

> This patch series adds changes in verifier to make decisions such as gran=
ting
> of read / write access or enforcement of return code status based on
> the program type of the target program while using dynamic program
> extension (of type BPF_PROG_TYPE_EXT).
>
> The BPF_PROG_TYPE_EXT type can be used to extend types such as XDP, SKB
> and others. Since the BPF_PROG_TYPE_EXT program type on itself is just a
> placeholder for those, we need this extended check for those extended
> programs to actually work with proper access, while using this option.
>
> Patch #1 includes changes in the verifier.
> Patch #2 adds selftests to verify write access on a packet for a valid=20
> extension program type
> Patch #3 adds selftests to verify proper check for the return code
> Patch #4 adds selftests to ensure access permissions and restrictions=20
> for some map types such sockmap.

Thanks for fixing this!

For the series:
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

