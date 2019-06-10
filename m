Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F8C3BF72
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389836AbfFJWYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:24:42 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42184 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388842AbfFJWYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:24:41 -0400
Received: by mail-qt1-f194.google.com with SMTP id s15so12224716qtk.9
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ZZTpeDRORjV0nyxbNNGLjE/GLXKZO6sNN1Vra2yosmw=;
        b=ScMWjR5/nJAYssewEAjjFgcZE2SfE8zR62K7wh74u4A2nJwO4kqeZ3X8X4oa4UWR20
         sxhLio6aCospg9EA694s5QxKYbQdDIKsWzUxWLFUNoM6E51RWlOYwalAOXjETN6bSHjr
         jLllSXgX1b5cfxzwAJg3cu1lfGHVQuYNnNxNqmdH5boqCnzUFzoAq23lGCSlc0B0HmPy
         3XP5prfFF1Q5x8eEYCffmapQDKv2lkVHW4Qag52uHGzmGKvNfgDXXJRMevQwp8pr4lAX
         4+LQKroQrz5a/hE3t6mD2bx4LLTERV2N+MNpsqWe6rSfX5IOpoXA6dngfDGRDRWIVyia
         4SRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ZZTpeDRORjV0nyxbNNGLjE/GLXKZO6sNN1Vra2yosmw=;
        b=RLM70aF7eOpd+emX0NoBIF95iRi4aiEppORTEzfou1t+6J+/+8ixkrTF7A3sN2MHK+
         C9w0Z42QuFZattp2WRDg5cwV+5liC9pbM5n46YUB8fdocngyLBUPw1eheJlWUB94htvA
         9bV+C+VUBTk0DjMaSNTbKf52PSRc/N1eMueClfgPKU13pdYkUwQEq6s3ZM3uKG0tpo0u
         ufPg8C12XQma3bfbcNB/2tEw37h5SevCGtace3q+oxf8vjaVIVSr6/sLAS9UIzv6nJw5
         /H+jqEVowaESHk0213t2ZyxiHihBgBCgsymo+QCG6q+7hwunG3cL/aVFgGZwZQxg6K73
         +HZw==
X-Gm-Message-State: APjAAAWYLZr5YvhqY3UwHwqR8FpDf972M0Dg+1IUdzaKEuJ4NduSYwLX
        YzXqv0gFaLib2aweTHqpLjTdVQ==
X-Google-Smtp-Source: APXvYqwjUooaVBXa4+Fz8YPrkeAxBhkmMSqnGS0cpqs0S4sX71JBwZy/H0MP0eTnJchBgOyWveEHOQ==
X-Received: by 2002:ac8:1796:: with SMTP id o22mr57140249qtj.98.1560205480769;
        Mon, 10 Jun 2019 15:24:40 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b203sm5248455qkg.29.2019.06.10.15.24.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 15:24:40 -0700 (PDT)
Date:   Mon, 10 Jun 2019 15:24:33 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, toke@redhat.com,
        brouer@redhat.com, bpf@vger.kernel.org, saeedm@mellanox.com
Subject: Re: [PATCH bpf-next v3 0/5] net: xdp: refactor XDP program queries
Message-ID: <20190610152433.6e265d6c@cakuba.netronome.com>
In-Reply-To: <20190610160234.4070-1-bjorn.topel@gmail.com>
References: <20190610160234.4070-1-bjorn.topel@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jun 2019 18:02:29 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> Jakub, what's your thoughts on the special handling of XDP offloading?
> Maybe it's just overkill? Just allocate space for the offloaded
> program regardless support or not? Also, please review the
> dev_xdp_support_offload() addition into the nfp code.

I'm not a huge fan of the new approach - it adds a conditional move,
dereference and a cache line reference to the fast path :(

I think it'd be fine to allocate entries for all 3 types, but the
potential of slowing down DRV may not be a good thing in a refactoring
series.
