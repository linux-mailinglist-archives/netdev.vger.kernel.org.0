Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CD21BBB94
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 12:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgD1Ks0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 06:48:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21723 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726312AbgD1Ks0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 06:48:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588070905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P5Zy6MY1lit5ibuHW3UQvtHO3CqtEhEXXGm3gncifMQ=;
        b=YfuR1FvPPf5fbov4PRkG/WCg5LD4x7t5YP3arr6q3784xXaxA8mODiLOA3hPdrDidUIJ7H
        rv8g1KfyxtXy/7iiKlz7p2RBrgVlSmyH3D9E2s9QiuHl97l24NEt+mWhmdUI0NCy+cjmJY
        d2KKqIEjdpI8o/Ns6gvNV8Y09gWBmBM=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-DmdglW34NOOWrsSWIdw7ZQ-1; Tue, 28 Apr 2020 06:48:23 -0400
X-MC-Unique: DmdglW34NOOWrsSWIdw7ZQ-1
Received: by mail-lf1-f71.google.com with SMTP id l6so8789809lfk.2
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 03:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=P5Zy6MY1lit5ibuHW3UQvtHO3CqtEhEXXGm3gncifMQ=;
        b=s3UkoiSvhW7px/HsnSdPsXOzfSFveFOzmOGc0qV2mYElXFYSujGyIjvkljFxMhR9e7
         pUsLBekVDKULtigo7bUwghBoVMmL2UOZ1B3GehH84UBgB8CBIZX0iCMxeqXKwT7alXES
         Zyp4D0YhWKJ4t4/Bb+f26PB7yK4GcwVyA8g7g57zxk7W6LspqhOoSXxj9/91O6SX2Y9L
         jwz+MpLSu9zXVyNID+fxIxhhbnYzVvIkbYqebHs9q0LuZ4g6+EnvHucQdsKfDqok5OX+
         BkPtOQwDzCcOY8ozVnLPwFmQmifCLatym7YipiRyfwGPs8NEA5hwjdMO/CAynEJwV6b1
         kFWQ==
X-Gm-Message-State: AGi0PuYu0dbTwaWfUe7e4LDYeeSp1gZWwpl+6ERhpKcbQ6yyvnY/hhnX
        dXCos6JT82R89RQwnPQzEBrFdd5yCuvfeY/Qn8/fVcoS8MYcFI4/4xyK3eTYMStLIzpdltdxptW
        hdMS9Hdjw8C0QimpO
X-Received: by 2002:a19:c385:: with SMTP id t127mr18633989lff.117.1588070901853;
        Tue, 28 Apr 2020 03:48:21 -0700 (PDT)
X-Google-Smtp-Source: APiQypIW3bJR+0Ocu75lOY0jfrtgbDFx4U8HPiSf2InAtZjQyAv3duSStl2T7mTfbKCYlL1c+vgCEQ==
X-Received: by 2002:a19:c385:: with SMTP id t127mr18633978lff.117.1588070901688;
        Tue, 28 Apr 2020 03:48:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g22sm11329734ljl.17.2020.04.28.03.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 03:48:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6E6971814FF; Tue, 28 Apr 2020 12:48:19 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/3] libbpf: refactor map creation logic and fix cleanup leak
In-Reply-To: <20200428064140.122796-3-andriin@fb.com>
References: <20200428064140.122796-1-andriin@fb.com> <20200428064140.122796-3-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 28 Apr 2020 12:48:19 +0200
Message-ID: <87blnbx4wc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Factor out map creation and destruction logic to simplify code and especi=
ally
> error handling. Also fix map FD leak in case of partially successful map
> creation during bpf_object load operation.
>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF o=
bjects")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Good catch on the fd leak!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

