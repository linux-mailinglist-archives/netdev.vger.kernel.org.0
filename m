Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF3B400291
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 17:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhICPt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 11:49:59 -0400
Received: from mail-ej1-f45.google.com ([209.85.218.45]:35658 "EHLO
        mail-ej1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235573AbhICPt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 11:49:56 -0400
Received: by mail-ej1-f45.google.com with SMTP id i21so12973806ejd.2
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 08:48:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=aRW+efJr5EiukU/nii4HCdxx9cVb3w4SYgOLWtSxZ6c=;
        b=FlrAGE6JtgN2x+W85gGArf4SpNPxKcCxRDukndX2HLLeutB4YzzZOjUhVV010QQjaK
         IUTJNEOLR+Rrh9PaGqfasKhjZRFkltBP4QWRWJ5P6icSeNkSfpyg2+o6T2O8sQWy1ZSq
         Eo7z1j9BdVI2BneJPCLZRYBsKxZNjE+WPUugYk9htUznuwyL+4kiw71m1REnm/0O6Zkn
         CZxXtjgVdfD+cLGMvwS53kh5MRYiWm+xa2l3Hv4oRj0O0soKa+oA5gfdw81fp2XxoXjd
         EJNy+uSkqquiYKpapcpjyZArEXEDi5U3IAHq9kantkk7rn2EsVU6wFbAnzTDtuToW4pY
         3aMA==
X-Gm-Message-State: AOAM5339FGkP2+rlTth8Lb9sprsS4AWBpLbU/E4XDygO7m2iHt7f6pDV
        nwwNGhOOPCtklGk3jj0yoQJZxoLWi6l6mlwQK6zpXaiL
X-Google-Smtp-Source: ABdhPJzZmq3nab7KVEJXT90+mYV6DB03Qc2JtikR/q89wIUKjvB0ywCVqQTAsQKNVr07nb7PJg7uYKwWEpoGcJOiKd4=
X-Received: by 2002:a17:907:20d1:: with SMTP id qq17mr4959603ejb.439.1630684135555;
 Fri, 03 Sep 2021 08:48:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAD6Lk=r=mCMPb3YyKHMKtLENteRPsGw2L4Axy5kdVvnd2j29Zw@mail.gmail.com>
In-Reply-To: <CAD6Lk=r=mCMPb3YyKHMKtLENteRPsGw2L4Axy5kdVvnd2j29Zw@mail.gmail.com>
From:   Andy Walker <camtarn@camtarn.org>
Date:   Fri, 3 Sep 2021 16:48:45 +0100
Message-ID: <CAD6Lk=r8Yf8_09X31bcLECEKmy3gS5rKDKt+pVHfyNk2_NMHTA@mail.gmail.com>
Subject: TBF man page: peakrate must be greater than rate
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I was struggling with the following command line:
tc qdisc add dev eth1 parent 1:1 handle 10: tbf rate 10.0kbit maxburst
10kb latency 50ms peakrate 10kbit mtu 1600
RTNETLINK answers: Invalid argument

When I altered peakrate to be 10.1kbit, tbf accepted its parameters.

Looking in dmesg, I found the following:

sch_tbf: peakrate 1250 is lower than or equals to rate 1250

The man page does not specify that peakrate needs to be greater than
rate. This would probably be a useful addition, as it's easy to assume
that the two can/should be set to the same value for precise rate
limiting.

Thanks,
Andy
