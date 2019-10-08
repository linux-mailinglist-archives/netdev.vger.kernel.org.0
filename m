Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05B5CF546
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 10:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbfJHIsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 04:48:24 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45586 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729986AbfJHIsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 04:48:24 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so23972656qtj.12;
        Tue, 08 Oct 2019 01:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MY4d1ba2zC1BN01TeBYHV60s3GX0/irz8Swh1uPMXP8=;
        b=aCJ8pSVtQ/U1L8wcP9oHKAbjxpiP8iI8fn1kXix2WytIIRPrEu8v53j3T9naHLdP8Q
         kHKOMWUJGa+RljS2uB2PX1v4+gvcaE+bNHLCuFC/f+5SxGEj0S8ktoF6ACGn2Ord30f7
         SlgrsuV6p3oZZvJIIbTbURYoVVPKBc+tMa/co/759O+nGWw801HwHT4kvpzwzpuWeuyF
         vebalQ9HJDcKqOakm3esCTS/0aLlP5/6oKC7rFZsvQLOzD//PLdnOcEdENI3JylArZ4p
         /oWAl8eIMdQ7ccLtkBe369YFHwWLVSZNZXc484m+ftNDYRsKxQJ/oFvFcxmQcmm/+nZD
         xMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MY4d1ba2zC1BN01TeBYHV60s3GX0/irz8Swh1uPMXP8=;
        b=D6N9beWoOReFmdXLc6fj2h8ukDgGMTz/h/qbNvZyQBVo6nf5faSCnBpU9q+j5T1gWO
         oS7WYraZg8gn/IgXT8XuTp4dh/XS78ITPczEECVyD192em77tcoAj9TBII7y0luBtHqf
         4fJbw+IYmFdvq87kqKmsUBw1/7JRvZULoLplWZa+2ODFUvJ0ZtiLrKoEfjma4PE4gKjk
         ja1lUdI3Nzijqs96XKyosXDbJA0rcfK15Q6i34IgAOrbnkq9UKqxZBIxlB+EazfMDwTI
         TiX6ABAzkxCIDJHyXvPIrf+0OOxtCU4YERvrwU99/EutyU7A44aAj3/EAcgqXjsA3Aaw
         fhYg==
X-Gm-Message-State: APjAAAXACFf+3wOflq41Tffyr2yZZo0NKAqYBLaY0K2Qc3O7vuhuMoPb
        wL4nFQ8HV3qmJ94vrUjIK5IqTKsJm//jFEzX1Uw=
X-Google-Smtp-Source: APXvYqyOh6QlIbokS5MEgFiaev+14npMRHwMv+J5TDQiMb2e7DxPxPjQ2ryPNAmkHP6KwX7zfLRFdCSSy6mqY23kmx0=
X-Received: by 2002:ac8:3f96:: with SMTP id d22mr35343389qtk.36.1570524503583;
 Tue, 08 Oct 2019 01:48:23 -0700 (PDT)
MIME-Version: 1.0
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
 <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
 <875zkzn2pj.fsf@toke.dk> <CAJ+HfNhcvRP34L3px6ipAsCiZdvLXG02brecwB=T-sXMaT5yRw@mail.gmail.com>
In-Reply-To: <CAJ+HfNhcvRP34L3px6ipAsCiZdvLXG02brecwB=T-sXMaT5yRw@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 8 Oct 2019 10:48:12 +0200
Message-ID: <CAJ+HfNgEC=3MOe4YK_NNzRu6g_srKjWOCaCt09cU51avhWJKMg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive packets
 directly from a queue
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 at 10:47, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> =
wrote:
>
[...]
>
> The dependent-read-barrier in READ_ONCE? Another branch -- leave that
> to the branch-predictor already! ;-) No, you're right, performance
> impact here is interesting. I guess the same static_branch could be
> used here as well...
>

...and I think the READ_ONCE can be omitted.
