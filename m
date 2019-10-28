Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568E0E77FE
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404249AbfJ1SBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:01:01 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33436 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729738AbfJ1SBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:01:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id c184so7419263pfb.0
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 11:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mFR9DJBz4aaSJA6Lp+Gxf14PeSYZwISp0W0+RRJlLaY=;
        b=TxZ1dYYP5sCvuc/G/vsVQZeFEQV6aPYwbiShE+J0+/hTuDkChBkPUWKH31XeHoyFWP
         mp469jb3ziur13QTCBOSpZypO5WPKrylEZfGFg9Hn16P4v8b8UvpGAQUc91pN2g98Lrj
         vf4JYpxfR2GSy6o83cK2SCNr1rz2EslYifVV5pINWltfakM+8HrZReuL2N+RtebqO860
         oz7CQuGhAXI9o28TJ3u273/VuogvrvQ75DLMVjsppvgzU1PS48PrqX9FPQCiN8A2LXKR
         OuOvW+k1sIcQb63WjURoniXxXjf9YlAyBrNIV7S3Mq6w/1n9UzUxdkIK9wWjEFFlckXg
         G+Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mFR9DJBz4aaSJA6Lp+Gxf14PeSYZwISp0W0+RRJlLaY=;
        b=lL4yEwGIaggj9RKkzPwGOg5vtKfseUtGzH64UKf7S+vOin5wsgj5H82ZUjnBSgEOK9
         cP0tPO0vlXTTou6ijhAcDs7piiou7TaQiDu3jWU/0smnsggax+wLVMznyvkLH9oIDUgd
         YbCS3aMRPKCZzFpkVpes78h/pZLZlC3ixoS9k3KUpb/NTa+ugp5gbG4pRUS2ZRhcltfE
         JUuEXJ27k53QK9X2e4OEZEOA2vWEuGLy7IfHiYe562YmyyiWql6w8I9RwI7xNyjc65pz
         it3RQRipyx0btoPmFU7P4mv2pvkeHaenGLzpOzQcUUKNKVMUeV8rXUB2LjkvA5m7NZlL
         qHqw==
X-Gm-Message-State: APjAAAVfZOeYNQkDBb55iLB6D97WXHLz7KJFHOmW8zu6aqWZ9XPiQ86L
        Xa8m6aSoKFNmGthr1zDck6SMHw==
X-Google-Smtp-Source: APXvYqzPxwLVdq14TKHElmnIG+DCNhkQfxGivfW43j+TLX4y79TdDmbfnHUQXDTexo9uvgwpyylFvg==
X-Received: by 2002:a17:90a:741:: with SMTP id s1mr639682pje.113.1572285660180;
        Mon, 28 Oct 2019 11:01:00 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r19sm11312566pgj.43.2019.10.28.11.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 11:01:00 -0700 (PDT)
Date:   Mon, 28 Oct 2019 11:00:56 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, toke@redhat.com
Subject: Re: [PATCH bpf-next v3 1/2] xsk: store struct xdp_sock as a
 flexible array member of the XSKMAP
Message-ID: <20191028110056.17eea9fb@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191025093219.10290-2-bjorn.topel@gmail.com>
References: <20191025093219.10290-1-bjorn.topel@gmail.com>
        <20191025093219.10290-2-bjorn.topel@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Oct 2019 11:32:18 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> Prior this commit, the array storing XDP socket instances were stored
> in a separate allocated array of the XSKMAP. Now, we store the sockets
> as a flexible array member in a similar fashion as the arraymap. Doing
> so, we do less pointer chasing in the lookup.
>=20
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Damn, looks like I managed to reply to v2.=20

I think the size maths may overflow on 32bit machines on the addition.
