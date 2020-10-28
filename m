Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7017729DCD8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgJ2Acm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:32:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30743 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387433AbgJ1W2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:28:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603924125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wApZcyyCg/oHvQuw/XW+jOLHSnrOSTRGBkRyfmnnuNo=;
        b=fekCzrqXAdg5Q4oFFYv5tWJ6oD7aVUZMQb0ICgdDHmb4UAAkjtwWlcZvnY6VEBHZeJli0H
        T14Qtk/lN1bAXtgNopTIiWT9ynrPuetGDfehv6FjvFgD4Wgih1pE4ulLlWNzqxe3XXvHWN
        a1PGNqpjMhbUpqGBXXQ614jJIiB4NI4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-m4dF6TzlMOS1-7QsYM3iVQ-1; Wed, 28 Oct 2020 18:28:44 -0400
X-MC-Unique: m4dF6TzlMOS1-7QsYM3iVQ-1
Received: by mail-qk1-f199.google.com with SMTP id k188so650974qke.3
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:28:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=wApZcyyCg/oHvQuw/XW+jOLHSnrOSTRGBkRyfmnnuNo=;
        b=OHImO8NNhq3dBIjGFcVFhy6Y4MkobKadaUVPdHWC1EYpZLpOJAJmoMVZgAq1nP5ixI
         E1TztLEk3jkbA8M56tp4i48pK829wZfxHmEzAYCp4FKTvJQb++I9zir+eyvo6VJcPHhN
         CK8pxhChkNwIgmoZmTfmkbW7mIc4wK+mGx9hlGwP0bkVtsdnzBrX7oedS0incwyDPPHn
         QRaVGpxRazWeHv2M00C6uz9VqLfkqpMzmKwQ7i5EkVUU1eIrWPiMwEtcWT+XTEsVSdpP
         rPWtGahY3SaLArWkLeWBp8sgLZdzP6ytxL1LgdY0ZgljvX2nuvt6qVmUoOjEZVlg5L35
         JBRA==
X-Gm-Message-State: AOAM533BF4Pd+S9hO39LNwxffTbML31PZELH4Omu30UBBr39QwekYIS4
        PBM+YgnY6IZuIdJN1escmdgocW7jA/Qe/oypJx44F3BSGpDIfGe74uTNO+xFjecdjyfy2zlsXaH
        0lldiNm0s5JJm6MrG
X-Received: by 2002:a0c:9e0e:: with SMTP id p14mr1219955qve.25.1603924123523;
        Wed, 28 Oct 2020 15:28:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwq9yyBSFxRxsVFnZ8IGw0Fts+hBOX/aebL+kXk1aaU6kEom8zA0qdvrPB2Hx90ZyB0KN/Pbw==
X-Received: by 2002:a0c:9e0e:: with SMTP id p14mr1219935qve.25.1603924123248;
        Wed, 28 Oct 2020 15:28:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 29sm423854qks.28.2020.10.28.15.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 15:28:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DE5FF181CED; Wed, 28 Oct 2020 23:28:40 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii@kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: add struct bpf_redir_neigh forward
 declaration to BPF helper defs
In-Reply-To: <20201028181204.111241-1-andrii@kernel.org>
References: <20201028181204.111241-1-andrii@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 28 Oct 2020 23:28:40 +0100
Message-ID: <87eelim1d3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii@kernel.org> writes:

> Forward-declare struct bpf_redir_neigh in bpf_helper_defs.h to avoid
> compiler warning about unknown structs.
>
> Fixes: ba452c9e996d ("bpf: Fix bpf_redirect_neigh helper api to support s=
upplying nexthop")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Ah! I did actually include that in my local tree at some point, but
guess it never made it into the patch; sorry about that!

I guess this should go into the bpf tree, rather than bpf-next, no?

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

