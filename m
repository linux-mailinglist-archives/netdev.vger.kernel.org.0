Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E265930AC6D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 17:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhBAQP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 11:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbhBAQPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 11:15:23 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F00C06174A;
        Mon,  1 Feb 2021 08:14:42 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id a20so10599838pjs.1;
        Mon, 01 Feb 2021 08:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oe9kyxs1vAX/uhUOjLvSRTrrpJNRpCHgV3q3Ra/fPlI=;
        b=ftDEwVWojYxl00NqeNgdsQPlGCHIBg9DH+l7sy8IYd265AqJ48Wq9qdDTLcfWtBfHg
         SydNN2Fki+4FWKcIs+47Y4TNFN6kChxWYRh1KH7vQJ8S72cvL/q74WCYqxunfrkbnYQe
         +fzSBITqpRCl3zxUezpAwtBbNAzcrHOupprKpvbZLY3aZdm3bC63uPiDxwNqeJmsSah0
         pv1W2dPBpYKFfkATUNJAayGLkCaLQN0kNBQn8fBKJMKRDWheXudgCSGEQ3W/q9sxVlN/
         WZHAkqXZ0TYhhlC264IG/5kuRNfLwSyPfEmHQi+q79r5Y9xVTybwdlMagM/EDRfYWGEY
         yF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oe9kyxs1vAX/uhUOjLvSRTrrpJNRpCHgV3q3Ra/fPlI=;
        b=qt5/zmSuEyGQhwljGp6tmDI7GH5X+QU5VWDzoubju52TX7TfbI1e7mmo7AaGQ++oIl
         Miha30TxdCzrKzeU6WnQGF6UjLkX0j9WgdHJcEqLbEBbHSCN5BIexMShdPrJ6HhT7dKy
         aW3co8dn5wNwuStZlBTFbnRAxHzaQCuj98k7nX+DvU8td254TXmjCfN3o7DxODK6MJiA
         925iSErnqvctboaAc0NHzIEtNSAKfnsZuOrU7kM3eZH+ModKDR+tgdrZg2W7T5BtwsQy
         uQ2Z7zyS0YqVIaOH7cWRMn8//cOV2HXjWmA1FKw8+5iNU6/NqAvxYBeo16u8aUTcgXjB
         zntQ==
X-Gm-Message-State: AOAM533Ox+GwiAZ+xNLzMRhqwn2BizpUYC8t2Z1cvhiiKhl4x/V4U/yb
        Fp1oSSKvpcd1N3u4rY6jXaKIKSHQFvGkBnNuRckMnWlrhmo=
X-Google-Smtp-Source: ABdhPJxT6Mxmrz5OerQe235Y2SgSMqeIpwXqfTzNlzHlwdrw98+9dxUJHindUHj4W1Q58OPz8L7ysGA5UuEAZD1Ggj0=
X-Received: by 2002:a17:90a:5403:: with SMTP id z3mr18184163pjh.198.1612196082127;
 Mon, 01 Feb 2021 08:14:42 -0800 (PST)
MIME-Version: 1.0
References: <20210201055706.415842-1-xie.he.0141@gmail.com> <4d1988d9-6439-ae37-697c-d2b970450498@linux.ibm.com>
In-Reply-To: <4d1988d9-6439-ae37-697c-d2b970450498@linux.ibm.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 1 Feb 2021 08:14:31 -0800
Message-ID: <CAJht_EOw4d9h7LqOsXpucADV5=gAGws-fKj5q7BdH2+h0Yv9Vg@mail.gmail.com>
Subject: Re: [PATCH net] net: lapb: Copy the skb before sending a packet
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 6:10 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
>
> This sounds a bit like you want skb_cow_head() ... ?

Calling "skb_cow_head" before we call "skb_clone" would indeed solve
the problem of writes to our clones affecting clones in other parts of
the system. But since we are still writing to the skb after
"skb_clone", it'd still be better to replace "skb_clone" with
"skb_copy" to avoid interference between our own clones.
