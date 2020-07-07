Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A79921748B
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 18:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgGGQ5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 12:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbgGGQ5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 12:57:35 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E9DC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 09:57:35 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id x9so8085432ybd.4
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 09:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kMDEOIr0THXc3WyieJWxgLCDbYgTB/Bk4L+GxmNkBG8=;
        b=THinOuxvBphdK1ZtX5In6rDEXdUmSd4jvIIGl79qPFGA+sEH+gu8ZgXzdiZMV3X3jL
         27pX+k/BGgwBiapcTQkLx/iF2AG9q+wGCsakWjCsL0yuNHiEwO2UYX4OVcPa8W2gvsHm
         6Fh3aKW1kE0CBuAHvRmQ7C3GMU2ZdRgNKE8V7RiyU2WVfyOREIFi3N3bCU9iLQGok+vm
         f8qAg8LVec9MbCvtOiGJ71Oe74BWmCpIQCdFykOeyQ4Gdx8x+9AgxloIHQOWh1OpVShz
         XeOLq3KIm+2w71E4MP7aNICjeMxUJ7AELclf3sYJpmFnh02hkzxgt2D/ffkuRX8XgATD
         S1pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kMDEOIr0THXc3WyieJWxgLCDbYgTB/Bk4L+GxmNkBG8=;
        b=k/9t+A7aiVG2QXOHJ8oADpV8I6S7YiB9naCaiUJKzranAVwesGwbssla8wp+Hllj/E
         98vBRMzooRpcqYDU4WqnCHw19wfLJ7MjtHLSzwV+jqXT8QhjOCxOeamU3Dce1bOFVgqq
         Y8PTxQ358UyN0w58LACLER2gLCbj5ACkxV5wauCBV0M+v3yvHGO6sSj/+d9Tb/IdfNjq
         8bO4tQBkJqEekVY+xj5q2wdsqmI9hWgyqIQysw5WDW+Vd7bda0HFjqO7v81NazNNzLR0
         mUW3HXgvAS5N4EpJrk4MWpvYYjDXMNQYy2JqbSrkKJ/EO7x8iqKlZTu8eVww5tdJAqtb
         1CEA==
X-Gm-Message-State: AOAM5321b5nlTNEyLX6N32knvCpLhLlRVtdbpXjdA+M9iQVG7l4JI6ks
        YEvNMoIC99spAtttOHuKp7FduH4i4ZtY7ZUvKik=
X-Google-Smtp-Source: ABdhPJxGGDOoJOyZqUZbMYzXBLLZ6/4h6iDZaOqUJqFyKhC1+8BnS4rkrtgV7avjYGKDHjxKpaTqfXCaHBhqcc5chkU=
X-Received: by 2002:a25:2e48:: with SMTP id b8mr83705147ybn.56.1594141054827;
 Tue, 07 Jul 2020 09:57:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200702221923.650779-1-saeedm@mellanox.com> <20200702221923.650779-6-saeedm@mellanox.com>
 <CAJ3xEMgjLDrHh5a97PTodG7UKbxTRoQtMXxdYDUKBo9qGzdcrA@mail.gmail.com>
 <20200705071911.GA148399@mtl-vdi-166.wap.labs.mlnx> <CAJ3xEMje5d_Ffn05jDfY--jwNb9QZn8yS8MJcmy8zdxWzyc=FQ@mail.gmail.com>
 <20200707145737.GA10261@mtl-vdi-166.wap.labs.mlnx>
In-Reply-To: <20200707145737.GA10261@mtl-vdi-166.wap.labs.mlnx>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 7 Jul 2020 19:57:23 +0300
Message-ID: <CAJ3xEMjomdtx_BvTzzkPF6kNVadsNQGRnu3=46jkfhFfJvgq7w@mail.gmail.com>
Subject: Re: [net 05/11] net/mlx5e: Hold reference on mirred devices while
 accessing them
To:     Eli Cohen <eli@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 5:57 PM Eli Cohen <eli@mellanox.com> wrote:
> On Mon, Jul 06, 2020 at 09:13:06AM +0300, Or Gerlitz wrote:
> > On Sun, Jul 5, 2020 at 10:19 AM Eli Cohen <eli@mellanox.com> wrote:
> >
> > so what are we protecting here against? someone removing the device
> > while the tc rule is being added?
> >
> Not necessairly. In case of ecmp, the rule may be copied to another
> eswitch. At this time, if the mirred device does not exsist anymore, we
> will crash.
>
> I saw this problem at a customer's machine and this solved the problem.
> It was an older kernel but I think we have the same issue here as well.
> All you have is the ifindex of the mirred device so what I did here is
> required.

Repeating myself, why do it in the driver and not higher in the tc stack?
if I got you correctly, the same problem can happen for sw only (skip-hw) rules
