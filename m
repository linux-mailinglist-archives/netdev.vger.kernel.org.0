Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52E030B189
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhBAUYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhBAUYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 15:24:48 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F73C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 12:24:08 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id z6so17994973wrq.10
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 12:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j3SmGzx/9EOdlhzvPKiWPdfm2YAx1SRM88AT7v6eGFI=;
        b=tIZC5w0K4df/LksSV4uLtqigvjIeYt9PEg+bH1NBawWjUvCNvbDpMdY57j2gx0Yzcz
         JuAYf1/Rwi7q3TfwRptRbSc8iKdsdoSNsw2uyWIr4SQMRqzYGsNrn6OugwD99siJ9AFV
         trLAHgugKP1Xjt8uNP95T6uH6ofEyuf+KYmyzDoz4dHkZpWfphTZuxEF5rXbpHCCwxKP
         3KzmYdXTy8pl8PEgnyyQmsxQUimIZdyUriJdDoj11HbHL8kMVWSh/IPrsKB0bX0XAnOM
         0a3qlc9ir/cIPy7LKYBRzGWe59Ws5Q+iDA7Ui3Ir8aaZ5Rms2A9rMyyl7zNI0OkzD+jI
         hPeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j3SmGzx/9EOdlhzvPKiWPdfm2YAx1SRM88AT7v6eGFI=;
        b=tUcUSXHJh4+oWO0HGLwtXW/8kFEnnPVuT3v2dqX7epQFYz0JmMarB7qNqkLhQniiTZ
         5JGGZqHDpCfffQbOFnQN93c4qHEjl/G2jTveYhMNEqDQ9wnpI3E1facOMFcDXlhLl4Zp
         PM4jwXY1EN/52AM6d3q+5F/n/8Zku2coCkWNaB4Bx3hxyeqQE9/LJbYBb1jwo5Z5Aehn
         QdT0ZQdb8beMtLERA9+9dqI5VQfDt3+1r5Bg+LjOqidz7coE1hgWxEZbyt/176mG3u26
         sZzQXeHx1OdqPL9r180oZmlQ9rD5VOSI+IvD9CLqfam/8S1rA+s7WYP42k5ihsLoKWry
         p7jw==
X-Gm-Message-State: AOAM5319Smh3Cs8+DyX+opVP0mKKKLEYIXXRy3GcNFmRDJ5uRiQAonjN
        TJcEnJM0QtarOb0Vc0+6oU+LTYjU/25u7tt/OMY=
X-Google-Smtp-Source: ABdhPJwQg+E1wuuuvQ9Kvzxw1kNzwIoDrzPD3DdBkXoXdzjB1cZ9P3/NWsWi66oIdCnvW5sHO6mgmfs2BYOi5k6z4z4=
X-Received: by 2002:adf:ce89:: with SMTP id r9mr20332352wrn.345.1612211046952;
 Mon, 01 Feb 2021 12:24:06 -0800 (PST)
MIME-Version: 1.0
References: <20201221222502.1706-1-nick.lowe@gmail.com> <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
 <20210201084747.2cb64c3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a7a89e90bf6c3f383fa236b1128db8d012223da0.camel@intel.com>
 <20210201114545.6278ae5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <69e92a09-d597-2385-2391-fee100464c59@bluematt.me>
In-Reply-To: <69e92a09-d597-2385-2391-fee100464c59@bluematt.me>
From:   Nick Lowe <nick.lowe@gmail.com>
Date:   Mon, 1 Feb 2021 20:23:51 +0000
Message-ID: <CADSoG1vn-T3ZL0uZSR-=TnGDdcqYDXjuAxqPaHb0HjKYSuQwXg@mail.gmail.com>
Subject: Re: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
To:     Matt Corallo <linux-wired-list@bluematt.me>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I personally tested with mainline and 5.10, but not 5.4

Best,

Nick
