Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528CA1D44FF
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 06:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgEOExC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 00:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725899AbgEOExC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 00:53:02 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB599C061A0C;
        Thu, 14 May 2020 21:53:01 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 202so689471lfe.5;
        Thu, 14 May 2020 21:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h48uFiuApzrrtytARBwBFh4O/Y26ZJ45KR4t6rCKXhY=;
        b=nbEpq8plNHNrP3M5oh7L0iwX8OWvhTOVBx5F+lcGcLNSdFkKEJA/EmM9IYIKQDpFWL
         YAiYX3wqE/CAFuOpRAjRVkl2ymVNDfbJMUfal0pq7enGN4PdOgJF3x+0kkoWC0zCoZYt
         G+XLB3NXQXXzwDU4L1Zr+443HU4jcxSVnfC0C5DStSx8i/OgeYwv8KcooG7QWXDm8qQ+
         bb2fyxaRhl40F76a9lB0BbHt3Uzfl5o9RhB7qBOaWONMpT9kdTc7tYd884ZNy5JVXpmi
         XlpaWJXC4DkYY2qkecZErYKJITHzziLCJCDOgEUJzI9UW/2PbvmAzaqqsvaJJT2NmKOy
         AAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h48uFiuApzrrtytARBwBFh4O/Y26ZJ45KR4t6rCKXhY=;
        b=Um715SR0YOv1Pk5Y5DvNWUpEpW8QUngREJMUtoJdefjrxr80m+ckhDQ+UDAS7XYAjK
         /684pSZqjTm817HkWWC420fbI/odF7/CZpslFVtaemI/D0asLNmfEUSS9fbztSS/DKTx
         IXlYiXxTZ5gX+xMSdRL6cDHhCgwYiP+SwK3xucZ8VJBkc+u5Vo09MQlZ+wwCNDxT5ud6
         qOuOJ8oSdnHp6/n2qed1TSxyHBqnsMfnFd3vYWx6+PG6MkIjOwtEf2jvHGovrO/8uCGl
         stEFnnlfp6k7qLnOLeO3IBrpuNaVAwBQ2f8I1roaqr6zm5pktleHl7wVS2YCCej4D1E6
         sPlQ==
X-Gm-Message-State: AOAM532ffyJ0aK8Ed+3Kcs3xjs/h1nAh1cftOeY2b33j7R2ZXp0XzjWk
        hRELNiI5CPw6iSx+FlGAQFoSdkbvVupUx1hE3Bc=
X-Google-Smtp-Source: ABdhPJyP0V0haxIUqsTD2Al6SIVcQ4pO/Bln8qjGUmZ2HEe1EErpfcGxdrLX73m7XCGUfUaRM92WSn5ZZMEr80h8yDI=
X-Received: by 2002:a19:84:: with SMTP id 126mr328289lfa.174.1589518380066;
 Thu, 14 May 2020 21:53:00 -0700 (PDT)
MIME-Version: 1.0
References: <158945314698.97035.5286827951225578467.stgit@firesoul>
In-Reply-To: <158945314698.97035.5286827951225578467.stgit@firesoul>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 May 2020 21:52:48 -0700
Message-ID: <CAADnVQLnrqDHxnUNwPea-FmNBwNq3eFYpDuk5FQ88J+qdSN-WQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 00/33] XDP extend with knowledge of frame size
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 3:49 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> (Patchset based on net-next due to all the driver updates)
>
> V4:
> - Fixup checkpatch.pl issues
> - Collected more ACKs

Applied to bpf-next. Thanks
