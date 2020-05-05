Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D131C61A2
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgEEUKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728512AbgEEUKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:10:04 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F419C061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 13:10:04 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id z17so50513oto.4
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 13:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oHTwlgdwogMaMauWudijcuKhbWcUeWAm3wC8aKEGoGs=;
        b=GHjgCMOe8Ff1xkRGxZmhuI8ghIbPLW4dHl0dpKobopTJc41in+IJyncK1tVxF5/LTr
         gS0y4bPI+KFvs6u0ZVGO8Xy4BB7RzQbtdWZYKei/co/Yv2QoyDhsXnMTcPvAjApflxuF
         zHChxFMlDnfpUW3q4zmAjkwdVkZ5/gteZDjP0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oHTwlgdwogMaMauWudijcuKhbWcUeWAm3wC8aKEGoGs=;
        b=nwopzW1fHLEuQX9lwGpkuCd9wbcdK/wmmjmT5FRP/o3vrQQz/C5T0TDSNahsKBnLKd
         qwLFW2l1MCucoqfgl7d0CRft0kh9HllnUMbVZKmzU7ukFqFYVRz7bBY2+WDNUnnetOuE
         0i2myrQHaiEEbETzxnEHp5vcCDBBR9/Ga+SEsW212Bh8eng5uE8o6uuDKQc8iYhJe3+Y
         FDOD3OyVNa95/4z1PAqHPeBb6DJm/u4kgRbjmjYEGDXTDkxDQF+Nrwz31RJ+6QBiAjot
         9bXgLXIfFjt3kXUnpNkqre29fpn7yTyInJdoDtcBBNLTqEv4jEpYePXgKW3fneI4mnr4
         FyqQ==
X-Gm-Message-State: AGi0PubqA9LkFTs+Hz1EgnmXX2+inRLdBrZMJQkF8h05wXE7rS1enjwM
        8CAKjGPDJezVQ1VImBM3SFP28N1JaCerOKZvyyXtaw==
X-Google-Smtp-Source: APiQypJStawP9vJJqKbd5Qx2KNsVl70G0sQGOdwSYIg9LgR2Vh53MnSwYthujuHw5vVqN7DzpLyygyD5ljNHsxM2Aq8=
X-Received: by 2002:a05:6830:1e1c:: with SMTP id s28mr3549585otr.207.1588709403259;
 Tue, 05 May 2020 13:10:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200505162559.14138-1-jwi@linux.ibm.com> <20200505162559.14138-11-jwi@linux.ibm.com>
 <20200505102149.1fd5b9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a19ccf27-2280-036c-057f-8e6d2319bb28@linux.ibm.com> <20200505112940.6fe70918@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6788c6f1-52cb-c421-7251-500a391bb48b@linux.ibm.com>
In-Reply-To: <6788c6f1-52cb-c421-7251-500a391bb48b@linux.ibm.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Tue, 5 May 2020 13:09:27 -0700
Message-ID: <CAKOOJTzfbo9NJpOWpNn5B-oQ_yTvc7-ZxJP6dWvCV46p0z-T3A@mail.gmail.com>
Subject: Re: [PATCH net-next 10/11] s390/qeth: allow reset via ethtool
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 12:57 PM Julian Wiedmann <jwi@linux.ibm.com> wrote:

> It's a virtual device, _none_ of them make much sense?!

Why not introduce a new reset bit that captures the semantics of
whatever qeth_schedule_recovery does?

Regards,
Edwin Peer
