Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975C1105BF7
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfKUV3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:29:47 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:40373 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfKUV3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:29:47 -0500
Received: by mail-il1-f196.google.com with SMTP id v17so917249ilg.7;
        Thu, 21 Nov 2019 13:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=VLu1PIc6pmlku/Q8epaZRy/2fDcU3T/yGg/spbWkpcw=;
        b=RIdPTtBQHXhAFCsyVU7V1Pl7hB5NkCPT7OkTuji00DZEtMGHiaucSvq81aKCU/MdIT
         EMzNtly1s+a6hmc8T9rtK2QSTztl7EOiIdwMJsl6tN5Rx884qpGxknbH1l/abSdSHdNg
         y4ac1Z378gErTB9amZ6MBq4zvW+h/GiIYsvLVS7jePIDrV48oLN+xF+ozHIDR+pYdDaa
         PtmXhcpOH/17d3hZuXVHbqoQMGZ0auAsI8KpptQrMPWDY4WkRWQsh6uW+z/yBKyB3PnF
         1wK58VmB7F3AHky2sk3fewJhWP4+5dB0Q29useKPwslxDG6M3e5W+PVkTVAORZsLmUdk
         5CvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=VLu1PIc6pmlku/Q8epaZRy/2fDcU3T/yGg/spbWkpcw=;
        b=JGT5zDFiCStBMAd9QC3boxct9Z5Y2C+8k5CB6hkj9FmLL04q6SIb688Vj16r6mrGy1
         L2YioHeztQ+9idhekfopybWdSWqgjl4hAGM7UJ9ZSLQ8Q/ONRMu36OIWpY3TO1NkCa9C
         RO2OGIGWWMTSiS8JI1k0kQ4OfIAQtYRedBZauiA9Nu+q98ZqlQbs09oOmZklLwVVy3bb
         wMu3GytrQqIlRuf/V8A4HL98x46IAGwJ1n0yL2j4HDKaHm0okhDtSf9lkIw9NHfvu01/
         ni/MOGMfcz1EksumIAOcYxrpdszss/tEUA3DRAybou0yWGwPptUQMVGobqWwALl9HH74
         3Suw==
X-Gm-Message-State: APjAAAVvcpPA6BbIuz9Zp5O64aMFdGY/bTlKwcRQMDvjC6PvThuDxMCr
        Da0ldETHUt1/hfONMTzff6k=
X-Google-Smtp-Source: APXvYqzyqVajM5tEtF4LH+k2TA1NwOUVIigIb+rC/llEZZBpEqVc6BeHgYcYiv+CbFTNlDowOCrfkg==
X-Received: by 2002:a92:9c95:: with SMTP id x21mr12600786ill.115.1574371786808;
        Thu, 21 Nov 2019 13:29:46 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f2sm1367477iog.30.2019.11.21.13.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 13:29:45 -0800 (PST)
Date:   Thu, 21 Nov 2019 13:29:38 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <5dd701c21871b_4e932af130aba5bc48@john-XPS-13-9370.notmuch>
In-Reply-To: <20191121133612.430414-1-toke@redhat.com>
References: <20191121133612.430414-1-toke@redhat.com>
Subject: RE: [PATCH] xdp: Fix cleanup on map free for devmap_hash map type
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Tetsuo pointed out that it was not only the device unregister hook that=
 was
> broken for devmap_hash types, it was also cleanup on map free. So bette=
r
> fix this as well.
> =

> While we're add it, there's no reason to allocate the netdev_map array =
for
              ^^^
              at
> DEVMAP_HASH, so skip that and adjust the cost accordingly.

Beyond saving space without pulling these apart the free would have gotte=
n
fairly ugly.

> =

> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devi=
ces by hashed index")
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  kernel/bpf/devmap.c | 74 ++++++++++++++++++++++++++++-----------------=

>  1 file changed, 46 insertions(+), 28 deletions(-)

small typo in commit message otherwise

Acked-by: John Fastabend <john.fastabend@gmail.com>=
