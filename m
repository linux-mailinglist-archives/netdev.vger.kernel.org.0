Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4FA41721
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436605AbfFKVsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:48:25 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35555 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436583AbfFKVsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:48:25 -0400
Received: by mail-qt1-f193.google.com with SMTP id d23so16470319qto.2
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 14:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0wfxj3LFUUr+c+qdI/usdCINOleyhfngk+dloc6Qgto=;
        b=Y3dsXDXbAsVOPiUrxYMQ5nP++b+7hfFZPTve2fpdOo3p6IkcQEYSOdz1BAx5Aunx1G
         K+XHQZKLx7K72nse/CXpyGTeZ57QpGu+GmN8qTxsvoRdAkVxbN5jDFjoYKroCUfSPyC4
         rXXNvFB9P3mM1HjUie6mrV2rftK7mwCgxyF+NsqHPVNmuzFpTr0O4spAvrpjwE81kN3/
         GeDX+aYkFGcYtXWjFsNEJF1Met9knbtHJmCR/4+g4okeTbMdhARkBqNn4Spxj0btk/++
         g0j6ibjzqrKnD1DTFl500IRjzqlX/emwx2CC8Fx2xyBX0+niQQwJ21k3tZIdFrcs8g6i
         YkrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0wfxj3LFUUr+c+qdI/usdCINOleyhfngk+dloc6Qgto=;
        b=g9gc05p351MajQl5eMVf5Q85EvWH3SCkYxnh+UMQGDrN8Q9z34H/y1+ndYJeKufqnr
         BG8kr2djAGOy8ylVHh51uCGyrOeS6Aw2RrIYXVo80YHO+iU+eXbBeG+AvYwMJPhhS+JR
         Z+TJ01y1jF9IkDbFSd4ODhjnqPG4eRe6EIjcpd/xCtibOvTkCN8gtRAjTsstd7yMuxvy
         z12C+XnxQpuDr7Nh6NEFcSHB/6pwvF4dsAG5WY8GPBVKGsH2K4mMukqO58uuBzUZba57
         a/M76JJ2k8G8A2V/bSzSon/NtdG1M5pxhZRQkoYYSYNzWnnjnLrKeNzsPW4ykANHuIaP
         qe2A==
X-Gm-Message-State: APjAAAWy3mK8jyN59znNeOtxlriJ3dlCoEsNtn6sX14eQ7DC4KZnzcON
        yd7QENL874FTZ16vNceHEHP7eQ==
X-Google-Smtp-Source: APXvYqxe5DxoGJRezhlA1EvB+gdfkQVkN9irwlX+oQ37t6nIHWvB3ALETSLlhS3xam7zMqBudy9Ing==
X-Received: by 2002:ac8:3811:: with SMTP id q17mr37553257qtb.315.1560289704245;
        Tue, 11 Jun 2019 14:48:24 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k7sm6553993qth.88.2019.06.11.14.48.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 14:48:24 -0700 (PDT)
Date:   Tue, 11 Jun 2019 14:48:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] bpf_xdp_redirect_map: Perform map
 lookup in eBPF helper
Message-ID: <20190611144818.7cf159c3@cakuba.netronome.com>
In-Reply-To: <156026784011.26748.7290735899755011809.stgit@alrua-x1>
References: <156026783994.26748.2899804283816365487.stgit@alrua-x1>
        <156026784011.26748.7290735899755011809.stgit@alrua-x1>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 17:44:00 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> +#define XDP_REDIRECT_INVALID_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS | X=
DP_TX)

It feels a little strange to OR in values which are not bits, even if
it happens to work today (since those are values of 0, 1, 2, 3)...
