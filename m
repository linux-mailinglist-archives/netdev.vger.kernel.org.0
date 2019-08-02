Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C56980179
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406874AbfHBT6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:58:15 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41276 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406865AbfHBT6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:58:13 -0400
Received: by mail-ot1-f67.google.com with SMTP id o101so79316505ota.8
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 12:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zusammenkunft-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j07rAWQ7fbFLjK1wqdyka1zd+w57/1J4NcBWZmVIOkc=;
        b=jedvyc1CWMQwc+wq5TYIb0OGevx43X0NMii5ri4f+ivoV+pC/TKnwIugUA3UJA0GY6
         o4ctzkJMVeFeqVYHDD6pzDtnyQQDIuzUeJoZ6HP8FFsdL7lQRUAAiLmFpfowWEKCv4G4
         IFrKG+K09OUqUmjf+ddhWAeeOFkHjlDSuSbOLLBTi6WH5I96OseYUwhM/gMhF6/nM88g
         GaVxUqEaeBOJyg61xlrYSJiAzgxI57vV/30WlOkBJHtwGdl5g6DHKsikdLGz3krmehbZ
         nraHu7bwpycJIDPmj9ZYeh/7mrj5k+DG4NJZP3wEwoalM0vR/fx9joY/JNvtH0tCB+/4
         bkwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j07rAWQ7fbFLjK1wqdyka1zd+w57/1J4NcBWZmVIOkc=;
        b=G2wynrapIXoTAej+z/V7/CefWBIYZUE9fO7puteNW98XHKQwZuwvi1D+azqMGTDs9K
         Ywe1wECbVAP0Pi5UmAlhdizFvnibW7AbgQ3MdBXBw+kK8AbJbhqFxCYkYUec4BYJ+SPa
         yl0zs+D25FrPQl6ngaQswXVwp5l+aI63+WpJZ1nutyCdHaT3qDVV4GHG+lze2eZfcqDP
         xWXGR4guojURUjgtFItIHnOloILr8/xmtxwXZxUZD652Flsd6+o0T/b3/k7gMmUt5Qmy
         /fms3G9jwUUj5na4+UaiOLySN/Ko/ASzLX7SYBBYir9v9Riq5o5ukAdVBOWkFSYc6Zr0
         Ehug==
X-Gm-Message-State: APjAAAWRRbeFWVQvZkc8d22xnxBwrENOM5VJjh+IE8mrAMW+sFngfNiD
        XL0CbATSSyH+l2SJ9SNAQyeetmV7x9h+HvsgwIQ=
X-Google-Smtp-Source: APXvYqwFIYFgk213xRwSPUyA62GatizbKWkOr35zlAQSAdOS/9LfZ7OYUaWoYL4htAHws8GE3bw4FMQZeyO5fMT2Dic=
X-Received: by 2002:a9d:3788:: with SMTP id x8mr34737763otb.59.1564775892877;
 Fri, 02 Aug 2019 12:58:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4a:41d5:0:0:0:0:0 with HTTP; Fri, 2 Aug 2019 12:58:12 -0700 (PDT)
In-Reply-To: <CADVnQy=dvmksVaDu61+w-qtv2g_iNbWPFgbSJDtx9QaasmHonw@mail.gmail.com>
References: <CABOR3+yUiu1BzCojFQFADUKc5BT2-Ew_j7KFNpjP8WoMYZ+SMA@mail.gmail.com>
 <CADVnQy=dvmksVaDu61+w-qtv2g_iNbWPFgbSJDtx9QaasmHonw@mail.gmail.com>
From:   Bernd <ecki@zusammenkunft.net>
Date:   Fri, 2 Aug 2019 21:58:12 +0200
Message-ID: <CABOR3+zQ0yfbcon6bv5TXrrAomoWLxy101iEXqBycDTrhytDiA@mail.gmail.com>
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory limits
To:     Neal Cardwell <ncardwell@google.com>
Cc:     netdev <netdev@vger.kernel.org>, edumazet@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-02 21:14 GMT+02:00, Neal Cardwell <ncardwell@google.com>:
> What's the exact kernel version you are using?

It is the RHEL errata kernel 3.10.0-957.21.3.el7 (rhsa-2019:1481), i
need to check if there is a newer one.

> Eric submitted a patch recently that may address your issue:
>    tcp: be more careful in tcp_fragment()
>
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=
=3Db617158dc096709d8600c53b6052144d12b89fab
>
> Would you be able to test your workload with that commit
> cherry-picked, and see if the issue still occurs?

It only happens on a customer system in production up to now, so most
likely not.

> That commit was targeted to many stable releases, so you may be able
> to pick up that fix from a stable branch.

The only thing which is a bit strange, this is a Java client, and I am
pretty sure we don=E2=80=99t set a small SO_SNDBUF, if anything it is
increased (I need to verify that).

Not to worry, I guess I can now with your helpful pointer sort that
out with Redhat.

gruss
Bernd
