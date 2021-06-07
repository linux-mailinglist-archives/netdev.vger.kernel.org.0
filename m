Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380E739E047
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhFGP1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:27:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230241AbhFGP1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:27:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623079545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=KSxFuzdvnaSD/hQDMG5nZuMDfjyv6JLJ1uBuMDxyf4w=;
        b=KzfybDd+JDzYRYPXxcsSg5Avbi8u7vBEJxGoRxen0GEqQnWMKk8F7aNyd4mqSvatdRqIqS
        0ci9wMmbMulUZdasvq8Ym4FOj6G9EmL/mpA6LgiscHqAItRhiCYybH6oEx5Sg1ViyOmBGI
        rMVQomd0KZPvSeXo9PIqC6s4tBTrZrM=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-ySchBZHwN0q-ciHHbIwqxQ-1; Mon, 07 Jun 2021 11:25:41 -0400
X-MC-Unique: ySchBZHwN0q-ciHHbIwqxQ-1
Received: by mail-io1-f70.google.com with SMTP id s14-20020a5eaa0e0000b02904abce57cb24so9433383ioe.21
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 08:25:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=KSxFuzdvnaSD/hQDMG5nZuMDfjyv6JLJ1uBuMDxyf4w=;
        b=J1KlylZRGPJbRyxg91gKD8pcH5PZoQKqoRL+ZZ5T3UADjuc1HxJOTQSXErx3wKjnMM
         lkKZnjYN2Pynssw8r0j/h1TqQbRfbe07zpDktdPjCmmuHiuKLRb/8He5/xnsXv4GwNVA
         8peTItMe/el67Tzyv8+9TgMU2tVAs90fiMCldRMweMz5cioySbo9VYlrL1RJs4uj3HmZ
         sPX/lNqNA16t/EIIgj62x5623A+R4UfU7hGnXQhhF3KVTVjLyhtcEHkZeswbrbktcq1l
         Olv1yqB8l9ziDQzuRGASsdrL559X08MrYWhUUpgdlYaDtHApf4m/4dvp/Dvi6gt4ACGr
         MH3Q==
X-Gm-Message-State: AOAM531JmOzl2tY/VmXJsLXQfup8UQzpLoOlGMJQfPx0frU/t9QngYbC
        uyr1gOsD2ZroVJiDLAlImugJADxqLKSnZZNqvliqR3HXv7a8vJy7EwdIU2sWHMM4pUm+iuJdHRm
        Mp99SDlPty9Oy9qr0pZBuL47F89d2UFvR
X-Received: by 2002:a5d:914f:: with SMTP id y15mr15048616ioq.196.1623079540933;
        Mon, 07 Jun 2021 08:25:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/M3bz/PQUDGYbDG+aY0xrQFE30oh++RR0qeAAsrGmKMF4B+tsXTrhjQM/a17+qcHJYmHtq1gZlqV7aQlUGzo=
X-Received: by 2002:a5d:914f:: with SMTP id y15mr15048603ioq.196.1623079540738;
 Mon, 07 Jun 2021 08:25:40 -0700 (PDT)
MIME-Version: 1.0
From:   Alexander Ahring Oder Aring <aahringo@redhat.com>
Date:   Mon, 7 Jun 2021 11:25:30 -0400
Message-ID: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
Subject: quic in-kernel implementation?
To:     netdev@vger.kernel.org
Cc:     linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

as I notice there exists several quic user space implementations, is
there any interest or process of doing an in-kernel implementation? I
am asking because I would like to try out quic with an in-kernel
application protocol like DLM. Besides DLM I've heard that the SMB
community is also interested into such implementation.

- Alex

