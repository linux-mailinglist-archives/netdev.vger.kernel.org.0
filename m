Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718D31F0550
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 08:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgFFGEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 02:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgFFGEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 02:04:33 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A137C08C5C2
        for <netdev@vger.kernel.org>; Fri,  5 Jun 2020 23:04:33 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id r2so12823232ioo.4
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 23:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MIcOQ0jKTtLwX3j/jtOKaBmAMU9PmSJyu59cyw7ncN4=;
        b=IQZhm4ABNbtuVN/opYNyMnOlGTWUVdvS5dNl3r1d74izc1t8wXJVGyDSjjd0SIcAGg
         Kt2vw32tUWc5XJEfHF9h/XJTjAEMDDXkr8jcHn1j8DlWihE1PCRzX1O2uSy5AjObMUZH
         a6HLEP4z58ZC7OIkb86R7PKEMjyCLlk9P9u7Hm6SMmbroOqh3mi2jYF8nmRO4gZKgjFC
         P+pMXxT3IoiyVwETHdHA/s2WX+gSYGgQzhITEUdbo8zkpyHHF+a9eXL2Fhf1bRYy408Z
         5wD1lqxCjyjYYN0rLWZkCTyTNUbsmbDZoowumiGY3EM/ttgZQiYa/pKJs9u+CvW/TVs8
         yH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MIcOQ0jKTtLwX3j/jtOKaBmAMU9PmSJyu59cyw7ncN4=;
        b=JOieScoIso0Ij1UVvVI3WfY8ZMVx76Uu3cjxt6sFGLojTQX8yI0zJOQIQ5qdWcQ9nr
         zsbx6wxJccIRFkpgRbZInRvkhP9vgaqcBXxZ66TZ0GGYhtQaX2DAk8TpsgDdH9jkwD1Z
         68bEQTzb5oB0/4ctfT4dk0olhuwuei4sNjb1TbCOp9hyKNdcY1KkYGQBUvvqlPoKSgEL
         Ri9gPyeonBCEPUqdKO2KFK3muqcfKVICTyVltxRrlPUTTMgsuqDWLV9UZq+qsRkah9sG
         dUxELklVn0MYtqhdgBCqs5gmsqBD1qUIuQboVk92ui1X5zj2gbD3xdcy2ngMrbt4YHbE
         LOWQ==
X-Gm-Message-State: AOAM531MWUUBglRSygAaBBEHy84TL6sstNcXDY6fmFBk2sztbWhTePSi
        L7IOfgAfx1khrznNKTp+/3bnakttfnHA3HjY0KrNzHGO
X-Google-Smtp-Source: ABdhPJw0MerEiHoLLDu00EdxHIcjMXyuiqbZn3IVo2aKKQ2LSCy6zhTFMxHUWoF888boTGHFgMNgGCFIUMfycck7lWo=
X-Received: by 2002:a5e:c112:: with SMTP id v18mr11879308iol.37.1591423472236;
 Fri, 05 Jun 2020 23:04:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200605000748.31442-1-tseewald@gmail.com> <20200605013632.781-1-tseewald@gmail.com>
In-Reply-To: <20200605013632.781-1-tseewald@gmail.com>
From:   Tom Seewald <tseewald@gmail.com>
Date:   Sat, 6 Jun 2020 01:04:21 -0500
Message-ID: <CAARYdbiGzOOXcU5ny3hM2VxV4944mUYt-H5uzyq9w+230Xdriw@mail.gmail.com>
Subject: Re: [PATCH v2] cxgb4: Fix 'defined but not used' warning for cxgb4_uld_in_use()
To:     netdev@vger.kernel.org
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, tseewald <tseewald@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This doesn't apply to the net GIT tree.
Apologies, this fix is for net-next. Let me know if I should resend.

Thanks
