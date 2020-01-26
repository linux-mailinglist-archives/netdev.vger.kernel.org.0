Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84406149C68
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 20:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgAZTA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 14:00:28 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40216 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgAZTA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 14:00:28 -0500
Received: by mail-io1-f67.google.com with SMTP id x1so7587800iop.7
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 11:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xS1lfhBR0XNW1XsNAxmOMjV9HdMQdS11cdckGlLaDko=;
        b=qKmcDzW5px+uLtoJzMme75AkhnE1D95ABjHKkewyTYtKYT99tl7bhaz4RTetwYIGrZ
         Gi7oC83aNQjcyv/L9jGWJBZ3mhyRo4refWxzGYDvwBZE/Mt41WfEsyvueA+AB7FNxzgF
         qeXtv5IQnwdsECgYeS/ocs2MTjXZnJ8O/m3rzCGu2LF05MYu0R974O3LLi+9uthhEgVg
         HAb1cv1lH2+A2n57961VR75erH+2x8TVyG+9wOPYPKI/g5X2zFAsJH3hYdydgfZfceNM
         DsblGnej70Qjw2AQLj2rcj1gWFdC1KINXfqSzvTRxGjevHwQ1qRautB88uHyen4/L7Ex
         obKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xS1lfhBR0XNW1XsNAxmOMjV9HdMQdS11cdckGlLaDko=;
        b=jsGTChW/UrdBBC/uMvQGfD5aR+V9SEYH5OpMzKfuJx7zMmqXMWeL5k5GfbrFjEI8SI
         uI7MQso87ZZsFW6OJs5mjJFqQ/Nv6ZluuM4SWkXktH/utRUdNejbPtNGR2lcMm2LVqE6
         kaMAWcS91LEVdX64qqLacuMfN/EVp+g8uqsjCHd96rVW0MYkEjXYN1ig9y93U94j1uHF
         OfeQ2kNVtF1J7g1KGEyy/dyp4mgpngLt4jf2CdZYOBZfNBT2Uh8Z8HLYZMO0SWPncyzV
         TKoZx4s+FyZHbTFKCvpcMpf8ISGHrRS1uzio7NeEvLeRkvEmaWkS9tRJgm8Phc5VxQhV
         De5g==
X-Gm-Message-State: APjAAAVobpB/5FiM5XOoWlB/bkATYHJjtuRocfvb/COU3vmkqC2fJ09l
        +29krR4+hIyMnSuSKyCBlLPrhjOD9+H6ShyYtEM=
X-Google-Smtp-Source: APXvYqzRmTZ+Arl1EPhhI/pQYq6Kjd6prHBQcmYzI/Fvlk1i9l6DnVm2CC7drRR2rVH77vFlaHQhnx/n6UbhekGxfIg=
X-Received: by 2002:a02:7092:: with SMTP id f140mr9341660jac.128.1580065227595;
 Sun, 26 Jan 2020 11:00:27 -0800 (PST)
MIME-Version: 1.0
References: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com> <1579887955-22172-5-git-send-email-sunil.kovvuri@gmail.com>
In-Reply-To: <1579887955-22172-5-git-send-email-sunil.kovvuri@gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sun, 26 Jan 2020 11:00:16 -0800
Message-ID: <CAA93jw63P06fc=64tss_GJDsw7N=Ucg3pXai_25eT-EK4FysHA@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] octeontx2-pf: Initialize and config queues
To:     sunil.kovvuri@gmail.com
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kubakici@wp.pl,
        =?UTF-8?Q?Michal_Kube=C4=8Dek?= <mkubecek@suse.cz>,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I guess my question generally is, what form of RED is implemented in
the hardware?

http://mirrors.bufferbloat.net/~jg/RelevantPapers/Red_in_a_different_light.pdf

> +/* RED and drop levels of CQ on packet reception.
> + * For CQ level is measure of emptiness ( 0x0 = full, 255 = empty).
> + */
> +#define RQ_PASS_LVL_CQ(skid, qsize)    ((((skid) + 16) * 256) / (qsize))
> +#define RQ_DROP_LVL_CQ(skid, qsize)    (((skid) * 256) / (qsize))
> +
> +/* RED and drop levels of AURA for packet reception.
> + * For AURA level is measure of fullness (0x0 = empty, 255 = full).
> + * Eg: For RQ length 1K, for pass/drop level 204/230.
> + * RED accepts pkts if free pointers > 102 & <= 205.
> + * Drops pkts if free pointers < 102.
> + */
> +#define RQ_PASS_LVL_AURA (255 - ((95 * 256) / 100)) /* RED when 95% is full */
> +#define RQ_DROP_LVL_AURA (255 - ((99 * 256) / 100)) /* Drop when 99% is full */

I guess my question generally is, what form of RED is implemented in
the hardware?

(what's aura?)

http://mirrors.bufferbloat.net/~jg/RelevantPapers/Red_in_a_different_light.pdf
