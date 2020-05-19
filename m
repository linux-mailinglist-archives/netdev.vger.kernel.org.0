Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C571D9E52
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 19:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgESR5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 13:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgESR5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 13:57:00 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42B5C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 10:57:00 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 19so511630oiy.8
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 10:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1Imt22fDb9rnr1PM83spQEypfOoKpDmdt07ir12ZROw=;
        b=EIsN0lIbnGIseCKOMt9BxMm/yWGyBEmTV5UMfUPoo/OqAhixo/cmfRZ8PLapt9xQAZ
         EvY8ivhjEUN2ugOhTzS3I8IPZB6ohdVmRnkDraf4nPeoXjr2jlvsgFiCxDxsByl9TAXQ
         pAmhmUFyOz0yzlDkcJuU3bzN7xpeS8Ai+ZaI1hUZUr4jdgg90ce8y7m1UKN3zaaVqGm6
         3+Y2WR81+fMMC9ZgpPZmu4UDVhOzY6TRWNNskcuJ/bp86b/rP7UOsPWMJMbyTWcMTzEM
         1Y9OWUyxLmR6V0GXOKY/bJb0RMQ31GUUFH0WpDj3S6aFg7zjL7rYSEI2+ALKMOmWHTt+
         e+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1Imt22fDb9rnr1PM83spQEypfOoKpDmdt07ir12ZROw=;
        b=YlxbiJpR4KjGHYKBRi2uiefctLyxMtzMdDBQvVFGKLq2auFL2ur7tUg53SSr1kE803
         BK57kNvQZz7tY5QNBGU/Do8dAJsGgobvidVpvSVPPheuReJTKROtK1MhfDo3K6i+Slgy
         V36ub6S/UzXup7/H3vLbybKKFZEwhhX/TfOcJ28k7o1m9dZ7cz0yHVYMjVrSB94vuzxu
         4UY/nkh6Ncjn9CTHs67xyCPDFte5dQpchJKs87UVaKXDaZwLbHl17kdZ4/NCT/oV4is/
         EpyY4G8Tmo2+FkZ+fomdAjEAk9zt/Tg1LDrdCie5FsXMd8mNPQkC78LAHKdSK7xsheql
         rCKQ==
X-Gm-Message-State: AOAM53162apI8FMxGImpuQX/RVTmbVb7Ax3XNxPtUaLzEqJLQel4T0As
        HEtFoninZg/uCp24Hgz848q6MIAsqClmBV8ZC2se/Z47k3g=
X-Google-Smtp-Source: ABdhPJzgwKLsqnNnvVUXLg0MZzc0QWm3E3MHSTVw3p+KUEEpHEvY7nr10nCYRLd4eIXwnt9PpMLWSbeltwjkXP9DJPY=
X-Received: by 2002:aca:e1d6:: with SMTP id y205mr474943oig.142.1589911020044;
 Tue, 19 May 2020 10:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
 <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
 <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
 <CAM_iQpW8xSpTQP7+XKORS0zLTWBtPwmD1OsVE9tC2YnhLotU3A@mail.gmail.com>
 <CANxWus-koY-AHzqbdG6DaVaDYj4aWztj8m+8ntYLvEQ0iM_yDw@mail.gmail.com>
 <CANxWus_tPZ-C2KuaY4xpuLVKXriTQv1jvHygc6o0RFcdM4TX2w@mail.gmail.com>
 <CAM_iQpV0g+yUjrzPdzsm=4t7+ZBt8Y=RTwYJdn9RUqFb1aCE1A@mail.gmail.com>
 <CAM_iQpWLK8ZKShdsWNQrbhFa2B9V8e+OSNRQ_06zyNmDToq5ew@mail.gmail.com>
 <CANxWus8YFkWPELmau=tbTXYa8ezyMsC5M+vLrNPoqbOcrLo0Cg@mail.gmail.com>
 <CANxWus9qVhpAr+XJbqmgprkCKFQYkAFHbduPQhU=824YVrq+uw@mail.gmail.com>
 <CAM_iQpV-0f=yX3P=ZD7_-mBvZZn57MGmFxrHqT3U3g+p_mKyJQ@mail.gmail.com>
 <CANxWus8P8KdcZE8L1-ZLOWLxyp4OOWNY82Xw+S2qAomanViWQA@mail.gmail.com>
 <CAM_iQpU3uhQewuAtv38xfgWesVEqpazXs3QqFHBBRF4i1qLdXw@mail.gmail.com>
 <CANxWus9xn=Z=rZ6BBZBMHNj6ocWU5dZi3PkOsQtAdgjyUdJ2zg@mail.gmail.com>
 <CAM_iQpWPmu71XYvoshZ3aAr0JmXTg+Y9s0Gvpq77XWbokv1AgQ@mail.gmail.com>
 <CANxWus9vSe=WtggXveB+YW_29fD8_qb-7A1pCgMUHz7SFfKhTA@mail.gmail.com>
 <CANxWus8=CZ8Y1GvqKFJHhdxun9gB8v1SP0XNZ7SMk4oDvkmEww@mail.gmail.com>
 <CAM_iQpXjsrraZpU3xhTvQ=owwzSTjAVdx-Aszz-yLitFzE5GsA@mail.gmail.com>
 <CAM_iQpV_ebQjZuwhxhHSatcjNXzGBgz0JDC+H-nO-dXRkPKKUQ@mail.gmail.com>
 <CANxWus-9gjCvMw7ctG7idERsZd7WtObRs4iuTUp_=AaJtHbSgg@mail.gmail.com>
 <CAM_iQpW-p0+0o8Vks6AOHVt3ndqh+fj+UXGP8wtfi9-Pz-TToQ@mail.gmail.com>
 <CANxWus9RgiVP1X4zK5mVG4ELQmL2ckk4AYMvTdKse6j5WtHNHg@mail.gmail.com>
 <CAM_iQpXR+MQHaR-ou6rR_NAz-4XhAWiLuSEYvvpVXyWqHBnc-w@mail.gmail.com>
 <CANxWus8AqCM4Dk87TTXB3xxtQPqPYjs-KmzVv8hjZwaAqg2AYQ@mail.gmail.com>
 <CAM_iQpWbjgT0rEkzd53aJ_z-WwErs3NWHeQZic+Vqn3TvFpA0A@mail.gmail.com> <CANxWus8GQ-YGKa24iQQJbWrDnkQB9BptM80P22n5OLCmDN+Myw@mail.gmail.com>
In-Reply-To: <CANxWus8GQ-YGKa24iQQJbWrDnkQB9BptM80P22n5OLCmDN+Myw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 19 May 2020 10:56:47 -0700
Message-ID: <CAM_iQpV71mVNn30bgOzGyjxKeD+2HS+MwJBdrq8Vg-g2HzM1aA@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 1:04 AM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
> >
> > Let me think how to fix this properly, I have some ideas and will provi=
de
> > you some patch(es) to test soon.
>
> Sure, I'll wait. I have plenty of time now with the main problem fixed :-=
)

Can you help to test the patches below?
https://github.com/congwang/linux/commits/qdisc_reset2

I removed the last patch you previously tested and added two
more patches on top. These two patches should get rid of most
of the unnecessary resets. I tested them with veth pair with 8 TX
queues, but I don't have any real physical NIC to test.

Thanks.
