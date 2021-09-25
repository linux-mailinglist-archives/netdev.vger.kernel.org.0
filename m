Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C429418033
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 09:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhIYHaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 03:30:55 -0400
Received: from mout.gmx.net ([212.227.15.15]:32783 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhIYHay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 03:30:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632554949;
        bh=yFDb4A4/GKbkjkwFKbZYWrHFDEh/iWmCyJIjxuX4JRg=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=lQyskH9jAMoAMLP8KqTdBeTKpV2iLZwv9fcEazU1jz5jWCygaADc7xZwfFAZEjnLo
         1jJYQTYic+gVR9HzrtX8ZkdhujDOT5frDs2ZcM2w4DjwxOVD2CffTpNRbLQ1XY2VX5
         BhGKBvloCZNnLPiwdQ1srgr/fbFocg/0tWEFRWg8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from titan ([79.150.72.99]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MPog5-1mGVJX2PCN-00Mpcl; Sat, 25
 Sep 2021 09:29:08 +0200
Date:   Sat, 25 Sep 2021 09:28:56 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Len Baker <len.baker@gmx.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: DR, Prefer kcalloc over open coded arithmetic
Message-ID: <20210925072856.GA1660@titan>
References: <20210905074936.15723-1-len.baker@gmx.com>
 <202109202105.9E901893@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202109202105.9E901893@keescook>
X-Provags-ID: V03:K1:klFNjD6m3a+ozEsOsMiNydZCSb43iYDcQ8ER9QidygMym4OfgPs
 D9DtkkRLi3ZZLQzUoPdPvUueBxaFGJ09EFhSOAnovKo0oykH/2m9ht2LYjSVkBHikPUR/NO
 nwHLaiuNX4XKvYtw+U9zh58/aH0ruKUtDK/R+ySTuwYChsrS/OdTQn5vGO1WTIx1QZNEL9S
 hrGDj9gq/rqkARZauO9VA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Mtn6d7yNuYc=:QIJZrerQqy1JFr3BD4QVi1
 8Hs+Gy7pD5ODJrHge8xFCB0aTtWpuEGp2Rm3LDZMAQOODunpOKMG4goWxz1pWF1dTJ5jjUR6T
 iljjCjAmHCYgAbsVBtBuu5us00hz7bKnuimm4yAbuncpeS/IDHIJAKTfBBIkLPo0cIPQ81Z9p
 IMCpUvtBaHVtNwIhHZuZQb1OOPt4/G9ExyJp+kj6+7Epg5Y5himx4sJkWaQuQpr2lHQeK81oD
 gZ7r+JYhbfsl2m1HV0FXiMX6boItp5EEM+OWSo2JhYPNb4TP+WtbjsEf3gaciIPwWMGoOxTTi
 pNBU8houNdiwCmqvUpLcM0I9aAAOSX8jzVfTIKrga3qiRNZpyTsKVy+Omg44DSSKr82kyIYHB
 RjmUm5jhQxJ/rkJVRQ8Ug2ytlz71BF1pogB8+Xf9BiChyG4gWj6fkrQEXQ8GyrmASry+yXnSk
 gpSFN9eHBC6rAfpDzpt5CGBdVbBUjkagDmjjJpDtYADRKxEhzU0OILeL/NgqrfeyLzU8400vk
 9WngvC8jeNhhzX00Xw7uq1QC50Og/z2n482Tm567np0uqPI0bCCplXWeZVNxe5q1yAIqyNUbb
 16BkZFRT49ejfWLW0+g94xe0jSYyKHjIPjl1Z6EZ+i0C9c4a+H49BtYw6pccvQziFbvTrcKmM
 mndA//4qjzFP77acRB80LcuVyXGRrdQZNNCJj8bTDwrKbG/ZgM7mhrfg48C+inV116saPeWwk
 gFVZObGd03nmRqC/9r5fPOPeH5OP4HjHhYi0K1CZawZlcfTXRUkh0QVwQCch0YPyj/3v/aT6m
 71kULj2Qy/IIm9HqDOsUA6eIIZfu4t6+xuV/JFiLro1uuW/K4upm2SjAJeW3hMy1gOaWket3V
 dssrnEbJ855YZQ9RWyhJozq8mRrCbTzmDBXmWHjHEArDT3NbEa/EIUNf5yXcIgLpUGUui7pNv
 2L7FPM6s3cTdvMurH5cUUI4OQitLhtjrF5dlWDLB5qhbZoH2lxYws3UIiEoTdIMio3TOKpRhE
 6sQ2UP3LF0MBMTzowXUY7UPsJGF5cUxhvoj84DciCxH4fynRAC2bqqGMKBrg+KD1C34M5NS2R
 bMIaeMkGzVJil0=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Sep 20, 2021 at 09:06:35PM -0700, Kees Cook wrote:
> >
> > -	ref_actions =3D kzalloc(sizeof(*ref_actions) * num_of_dests * 2, GFP=
_KERNEL);
> > +	if (unlikely(check_mul_overflow(num_of_dests, 2u, &ref_act_cnt)))
> > +		goto free_hw_dests;
> > +
> > +	ref_actions =3D kcalloc(ref_act_cnt, sizeof(*ref_actions), GFP_KERNE=
L);
>
> In the future, consider array3_size(), but this is fine too. :)

Ok, thanks for the advise.

Regards,
Len
