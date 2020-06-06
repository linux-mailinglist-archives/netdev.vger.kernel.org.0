Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BDB1F05A8
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 10:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgFFIBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 04:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgFFIBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 04:01:52 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE164C08C5C2
        for <netdev@vger.kernel.org>; Sat,  6 Jun 2020 01:01:51 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id h3so11877702ilh.13
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 01:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H9s4Cn6x25Mwxly7j5HSs7lyVv14gMvk2foDD00s10Y=;
        b=exfP01bYz0smaoOoMLG1eWuqxmVx//10sVuVhLlDNCPGkSCdsGV+dM+2LpQO01KFwl
         eJDxQRt6Dd2g0K0ChtcMNzvG1q6acOUntisyOwdL3h5FGK52jBxaL04dWynZWDydbP2Q
         0V9/f6pQcotxGXFrdpsV7ZEZ0Tb9GeK3iN8pMCzxPzrehPOww5Ud6YlTHnS5yW0BISjq
         2Evo9sAWi88XcxDGmounClQtT084jlfbCvRIDeGDU/dnT0Z/iPJCf11ErxT5s6CcQ/pg
         bs1kucz5FvJUoE+sTz9dPeEBWRkqp/MNkQUbV3jxld1CYIjRZmlc3K/uNBNs5bj+sp21
         nGeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H9s4Cn6x25Mwxly7j5HSs7lyVv14gMvk2foDD00s10Y=;
        b=JH+18tz088dzoMHsliJnYjNumnqOmF+oVaZ1G7hKe+vQGna7ir8hOyk+5KiL/ohsbk
         19b4ArdVEYFbSHYDhVSYpSBAGoZaMPjHec1kghE/jRDlhMR/9AzULtfW84VovIGQPyL3
         Bf5C22D5lnTyr1h7V/WFBIeIzCm+NQUprqXnwetpkaRenEiv/V5z0D74cGqPWxAPV/yO
         bR8eGwLjJk+5G2PvTEUPIrg6Uc6iX1FavScl5vJKdelf66dib5XRDuZcuV3tCx/CPLkm
         kiXCVgWjqy716nvjKx/crHBup0QN4EmnpgkIuYka20YKrtlP1nQretn9KNgolTOp1LOr
         6K0g==
X-Gm-Message-State: AOAM530VHvjQUBUBpUmTYDW0Pp89bmL7BS21cWicxVvIKvHIwmCr6dm9
        5sRWWNu8DMczU7JIMFfOP5ojCcpFLXyJNIfFSCujZt2m
X-Google-Smtp-Source: ABdhPJxqswSRzNsAbVLT/qEeSs+UsQgBSMnRDgz3tiEKTvH1MP9NJdw1n+2uaHR4Q910j8n934OicJvp6bbPX2UmYtk=
X-Received: by 2002:a92:9e5a:: with SMTP id q87mr12372703ili.84.1591430510614;
 Sat, 06 Jun 2020 01:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200605000748.31442-1-tseewald@gmail.com> <20200605013632.781-1-tseewald@gmail.com>
 <CAARYdbiGzOOXcU5ny3hM2VxV4944mUYt-H5uzyq9w+230Xdriw@mail.gmail.com>
In-Reply-To: <CAARYdbiGzOOXcU5ny3hM2VxV4944mUYt-H5uzyq9w+230Xdriw@mail.gmail.com>
From:   Tom Seewald <tseewald@gmail.com>
Date:   Sat, 6 Jun 2020 03:01:39 -0500
Message-ID: <CAARYdbjkoKDYQbVAtYZuHAwPWFEZDRe3qHBrW-dosCq7C7_Jrg@mail.gmail.com>
Subject: Re: [PATCH v2] cxgb4: Fix 'defined but not used' warning for cxgb4_uld_in_use()
To:     netdev@vger.kernel.org, tseewald <tseewald@gmail.com>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like this has already been fixed in net, sorry for the noise.
