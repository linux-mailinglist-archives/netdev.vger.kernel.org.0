Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C4A44C05C
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 12:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhKJL5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 06:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhKJL5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 06:57:49 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F9DC061766
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 03:55:01 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id h11so4810135ljk.1
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 03:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gJBYeKbyuFnxWRx/yzd9DIfo4zFjEF+kJb4DPlegKoU=;
        b=yvTU+Pn638oDi5a5GEV4t1ihLSjORPtRlQUmlcW7QSm517HNztsIu00bRPycn9Ko2Y
         E8f30nQnMQ5lZH9Nl+tfyq1+xNw6bz8NVy/exMCdJxeZ6u2JUEHxuc5m42mrK/ToWrsh
         GRx+BoJEqwuzwD+O+2Thz8uED4UE/CYIEa4aw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gJBYeKbyuFnxWRx/yzd9DIfo4zFjEF+kJb4DPlegKoU=;
        b=Gghez0yRs6cCZ2UBDdFitF5Ro2kE58IohU8nPkuHbOeWp7UNH4GAXJiRtgB7yJoBC3
         W6wAYSs0cydywqUmSIqTG5knR4uiJ3UG/MZXaMwLJs5kTcUtjCEYZObP6urdF0zvqQbW
         xBSYVHatNI52E+fJbR4R0Fwz6R6NjoHsEVS3VA5Ncik8DW37tyWhfpbAj2EGrSINYff7
         Rp2CcwhxQG2YSXjHP4219dTABrS3fCf+fQyn5f0yZUbMJLe1JGeT6jKiJTxSQw2njEuN
         NWMXra8g/jKiWFONmkifgQmqlcQ+L2m0Zd3i3bNNRbEBKgn/ws8IBz8ve+ex5Y+kO/mA
         ZWEw==
X-Gm-Message-State: AOAM530NpO0CNjZoE9d7TGShZrM9jBQ4XF9+wfDfQH0dKjqeK1aZg+u0
        tWJISe24WAF6TXSNmrIuOVyzgcqPGGDZZ4EcSowrWg==
X-Google-Smtp-Source: ABdhPJy8ULRwKBmn+C3Fc8lyYoeoDPUCQKNOf/5sGl8YbhpO9Sl5ko934GsOxzQhtayRJGOHYFHRqJW2QnN/umJkR2w=
X-Received: by 2002:a2e:b545:: with SMTP id a5mr14883106ljn.510.1636545300069;
 Wed, 10 Nov 2021 03:55:00 -0800 (PST)
MIME-Version: 1.0
References: <20211110111016.5670-1-markpash@cloudflare.com>
In-Reply-To: <20211110111016.5670-1-markpash@cloudflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 10 Nov 2021 11:54:49 +0000
Message-ID: <CACAyw9_eT54_Az5B5pWVL86rii6BpKH8BT_HeKZWq4j4FNZAYg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/2] Get ingress_ifindex in BPF_SK_LOOKUP prog type
To:     Mark Pashmfouroush <markpash@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 at 11:10, Mark Pashmfouroush
<markpash@cloudflare.com> wrote:
>
> BPF_SK_LOOKUP users may want to have access to the ifindex of the skb
> which triggered the socket lookup. This may be useful for selectively
> applying programmable socket lookup logic to packets that arrive on a
> specific interface, or excluding packets from an interface.
>

For the series:

Revieview-by: Lorenz Bauer <lmb@cloudflare.com>

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
