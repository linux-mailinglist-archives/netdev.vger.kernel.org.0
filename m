Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1325289CC8
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 02:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgJJAqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 20:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729049AbgJJAao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 20:30:44 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760C7C0613D2;
        Fri,  9 Oct 2020 17:30:43 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id j30so10086277lfp.4;
        Fri, 09 Oct 2020 17:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ty+ydKc6NArTmdw0ynMVkoG1pdUz3plOfrBzn6vzV94=;
        b=sUoGzyKB4RBKnjoki6cSN68d75n63HF5VxfOHLJ7HnLQUbRfH1aIQYyxrzlZIMBFTH
         G7IC871twUuGmEPdN3DNbke7BYM6dP3UPbPqwwgdwe7uvFHGOAp8Wr1guk+ZD5aCFDpn
         y2R6uY9feIvn8gBWSQoxsKCyjk3TbwfqBp3KfPZVWyvlY41gyaPJbIduD8XUEMwSPmLa
         BB9MN5S2/Obx7VHqm0H1sAqS/e2cGL2lJYuO8w7aLUaJmNGo8ONVowl+yFChWlV+K2Hn
         SUJWVkocLmrjRGwg2ZjcCaZ9DUEHx00ZUBpxuDbYXN8A6fhCuMdiNwm1MaqhbDaWFT1l
         j4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ty+ydKc6NArTmdw0ynMVkoG1pdUz3plOfrBzn6vzV94=;
        b=fHVhIf0lG8kQC6VhqUXnC/6cutvx3Vvspf66nl/Jau8dvHsIu4/vR95WjqBCgSHxMf
         GTBtWuAfZ5v4Ld1S8QjiZoS84rvbnhTRCwDaOwTdV+pVYnYaPGsZRfQZsyvtKuoIUAZU
         6JvT0uSNImU1WJ9C4sWuHqhYLtFrDf0JbuS00+pq/xVG0X4/dLOdOFWJ2iJL2YpXe/fj
         3PwQfuqpHZzERqGVdMXkOpMtg3HCPXtWLcqCVE+UmFBwL77vayT6X0lr8Yw8R1KAmcxs
         cnx28Np3VNy6X0mD2BRh6RqKiE75R3cFyiyp5m4W0HRGYXNVocdbtNin0XJfnwsCANdj
         a2ig==
X-Gm-Message-State: AOAM532UoYXi730Mwp6dnisdulFpEyOvvs0Z++nRwh+2H8v4hjsrObW9
        HQSiKCo2Sxl8c/7J3GnMOeHNpolsaaLK8E+6TZE1bAOvLvs=
X-Google-Smtp-Source: ABdhPJy7Enftq8MwsKqHGvfuJBmYVHr4jVD/Du8L76iewWXJlDchezhtdH+cZ8DxLLApw7pfYtKPV442TK89uxqqGek=
X-Received: by 2002:ac2:4548:: with SMTP id j8mr4820644lfm.470.1602289841930;
 Fri, 09 Oct 2020 17:30:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201009103121.1004-1-ceggers@arri.de>
In-Reply-To: <20201009103121.1004-1-ceggers@arri.de>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Fri, 9 Oct 2020 17:30:30 -0700
Message-ID: <CABeXuvpg4EkuWyOUEU-4F5Hd_iF7pjGX=K8KmMVZGWTt0P_EkQ@mail.gmail.com>
Subject: Re: [PATCH net 1/2] socket: fix option SO_TIMESTAMPING_NEW
To:     Christian Eggers <ceggers@arri.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linux Network Devel Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 3:32 AM Christian Eggers <ceggers@arri.de> wrote:
>
> The comparison of optname with SO_TIMESTAMPING_NEW is wrong way around,
> so SOCK_TSTAMP_NEW will first be set and than reset again. Additionally
> move it out of the test for SOF_TIMESTAMPING_RX_SOFTWARE as this seems
> unrelated.

The SOCK_TSTAMP_NEW is reset only in the case when
SOF_TIMESTAMPING_RX_SOFTWARE is not set.
Note that we only call sock_enable_timestamp() at that time.

Why would SOCK_TSTAMP_NEW be relevant otherwise?

-Deepa
