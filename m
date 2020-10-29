Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F20A29EEA4
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgJ2Oo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbgJ2Oo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 10:44:28 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E23C0613D3
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 07:44:28 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id o18so3316774edq.4
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 07:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=htJryfkjuiAKFHlEy+hEl2GKhIMRmqAYSuUSBMAcs20=;
        b=pkHs+xSH3PMDKxA8AFAFWmQbOqPgMPgdsZXaYjNQPmczG77aNdAxkW7EQDfaYrW6RT
         xLDlz/D79m0uOdWDWldlzMqUMs4KIzH68LEeccwDSM1vvbfhEau8MYohJ/juxXNC0X9r
         67XnhBbkdHus12gcc3VsoZgnqAj9Kn/WAO9iKyBwVt6NacCqtO2bDMmcNwoCvkLyUl2D
         CDx7DHg8wVg25VRF20QM/uQ+RG2PlRKMaFo5mTXls06UX25t53L6RM+I6nuhZonB0ytz
         8dtxsWvc4+rGK/SqqWZfmWlIShS3PbTNWdDPra1uKqVn7ODnKD+DbPDuHXmqDNkyTsGf
         xu4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=htJryfkjuiAKFHlEy+hEl2GKhIMRmqAYSuUSBMAcs20=;
        b=rC+/o2iIK4BFh8iQ3tdEUdF1972DH3vg8nTCpIMKpZC64Ai2fXEU+4MRtGHHKlsb3b
         UTq2HNTwadKRyC3dOnSKpSZO1GvnP0OSlx4Zsj02eKaa7WO1TRarR9weekLbmYhESqUO
         kuyIQb/i0x1kYIHm3u1VS7md7WdjIVuR0NpTjJR2xaKXZCat63Acgenwb5scijeDrmsP
         /iV4o00X+bXf50oPVLGMbdDErEdl3VXiYT3iazWZ2y9s3aEsrwsO+g7GsKJahEuJK5W4
         SO8eYRQecqIYKiK2tgcERH8FKdMbnQAOUEpdS6iWU2hoNbdXjr/PtU7K5+g/vHuteXp2
         hHBA==
X-Gm-Message-State: AOAM532rnJrsxh2pOao+pMxPsx/usYaVunzngekkpBCcc87NNx19r9wi
        xLuqUWB0JIfu6xscs5MGRJ5bXv9t9EIz8uzYYFoOgw==
X-Google-Smtp-Source: ABdhPJzUSomkNT8XyMbXwvlAc2Dv4y1Gt8TF/7nNLimNlwPv+JSZYrBfqTctMs/H1Pifh5Fv4JKzleXcRbySm/ZSEio=
X-Received: by 2002:a50:da8b:: with SMTP id q11mr1647515edj.73.1603982666878;
 Thu, 29 Oct 2020 07:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201023123754.30304-1-david.verbeiren@tessares.net>
 <20201027221324.27894-1-david.verbeiren@tessares.net> <CAEf4Bzb84+Uv1dZa6WE5Eow3tovFqL+FpP8QfGP0C-QQj1JDTw@mail.gmail.com>
In-Reply-To: <CAEf4Bzb84+Uv1dZa6WE5Eow3tovFqL+FpP8QfGP0C-QQj1JDTw@mail.gmail.com>
From:   David Verbeiren <david.verbeiren@tessares.net>
Date:   Thu, 29 Oct 2020 15:44:10 +0100
Message-ID: <CAHzPrnEfDLZ6McM+OMBMPiJ1AT9JZta1eognnnowbtT9_pHGMw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: zero-fill re-used per-cpu map element
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 11:55 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
> Looks good, but would be good to have a unit test (see below). Maybe
> in a follow up.

Here is the associated new selftest, implementing the sequence you
proposed (thanks for that!), and also one for LRU case:
https://lore.kernel.org/bpf/20201029111730.6881-1-david.verbeiren@tessares.net/

I hope I did it in the "right" framework of the day.
