Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FABB7B1D8
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 20:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbfG3SXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 14:23:31 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:33778 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729237AbfG3SXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 14:23:31 -0400
Received: by mail-vs1-f65.google.com with SMTP id m8so44300450vsj.0
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 11:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=+mm7ggqib75+gCQNS2OtRtf2rOtKbYsSYJtjao7SH+k=;
        b=DJ2wtehi4cz8PN1iPq1b9xwCm9l0jxTcM9JD1gyrD1CbDdmKdSXRyFxzXX//H6E0HP
         SFDZYE8CcczD62x5VtTrXIxWR6Qx9IMaliy+RuXc7XYYqOJuBNxwiPlCfgUtgwJyyimh
         SqYd2R7GjHahdNQBTsqnVpynzTUVS0THVrvojViU9yD9UXqmea6JKO5GgMby6dWQWI1X
         ThWvpQ2yT0PBwBAtakfzcUpVrbXxv7Yu3ZS2ONk4qW2GYCPdnnDPxN3AigKQU7+5DTRf
         DGJIUB5bNDf1COOT2Q0gHRE8+e6m+Y5tlSX5VYAa9MHTrK7L9gbZS8+BL5izZLPK28Nf
         9C/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=+mm7ggqib75+gCQNS2OtRtf2rOtKbYsSYJtjao7SH+k=;
        b=Pm1/0iZ5eqDmTDP2CGlulGyMB27feqZjuug6w8ty/E5dfKfkRHcQRgIDWRNisJWqeq
         SEzZ71fbXTBl9K39e4e7jlOU6VRtm1h0L3d9w9f/1yHDnyNx+/H0ekHekXwt52cBRoB9
         LQCaoapomigCzTkR28CBRc4GTWlouwk9bpCZItJ8N8sOD7UelSoAGcF/46wBB0qioTi/
         jAe6ai3wOCnNklFgw/cl5vN09jpfUa7NLmDc4/PTCs13RV4dijZ8GwiDCKoMKVxJfeQi
         mHBxewplvGP532a1yTQQtyKQNgG0AnEZbK00RztSusfENKvoesIkyBczXdaw55F13uH2
         gRcA==
X-Gm-Message-State: APjAAAX+N+gsxZHKHQgvzTCcT/tTeIqcshr/ZJhxp/wRSRNLddIpIEzH
        jKIMzBLUKnuKe6GLVMd/HQkA4bfcrRwXs5xTznJ1Gw==
X-Google-Smtp-Source: APXvYqyG0G8OGlPyKzBoetnG8p/OVArlyjlTInZU7Qey/vfCaOxNIOkAQkh3eBQJpTqAuZYbAdSY23dMfbcyBp76XRU=
X-Received: by 2002:a67:8a46:: with SMTP id m67mr74811963vsd.160.1564511007736;
 Tue, 30 Jul 2019 11:23:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:2616:0:0:0:0:0 with HTTP; Tue, 30 Jul 2019 11:23:27
 -0700 (PDT)
X-Originating-IP: [2003:cb:cf28:4e01:875b:b91a:d236:3bf6]
In-Reply-To: <20190730.102434.1438984182304969810.davem@davemloft.net>
References: <20190730131357.30697-1-dkirjanov@suse.com> <20190730.102434.1438984182304969810.davem@davemloft.net>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 30 Jul 2019 21:23:27 +0300
Message-ID: <CAOJe8K2GLouoZuLjgRbstjCAgbJPsyLjxa94wZ3PTVRWOLaDPA@mail.gmail.com>
Subject: Re: [PATCH] net: usb: pegasus: fix improper read if get_registers() fail
To:     David Miller <davem@davemloft.net>
Cc:     petkan@nucleusys.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/19, David Miller <davem@davemloft.net> wrote:
> From: Denis Kirjanov <kda@linux-powerpc.org>
> Date: Tue, 30 Jul 2019 15:13:57 +0200
>
>> get_registers() may fail with -ENOMEM and in this
>> case we can read a garbage from the status variable tmp.
>>
>> Reported-by: syzbot+3499a83b2d062ae409d4@syzkaller.appspotmail.com
>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
>
> Why did you post this patch twice?  What is different between the two
> versions?
>
Looks like it was the issue with git send-email. Sorry about that.
Do you want me to figure out the reason and resend?
