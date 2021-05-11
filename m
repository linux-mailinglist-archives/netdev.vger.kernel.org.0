Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB2A379CEF
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhEKCaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhEKCaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:30:08 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D345AC061574;
        Mon, 10 May 2021 19:29:02 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id d25-20020a0568300459b02902f886f7dd43so2837444otc.6;
        Mon, 10 May 2021 19:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hNWWxfqzdzivp0T2mn0yrmpXvyG7CbHJPTrnit9thI0=;
        b=GCJofEO9zpa4oAvqeWVyuPnwewnpzN0EEmlstnl1InnGKeDaSJHk29P2Oet/R/97RG
         VbbwSY4shu3C0U1v9aV6LOD2X3kvrzpaRT46tuYg/6A/UjpKQpkhjEWKDsmDZ0xqhD8z
         y8AyXkYZZLwOwETEvPdRdP5B+Dh+TH7Jk/orIUMTM7fKHczWgcNUot28dIKYUlbEaXhO
         DFesGGGdrKhzmF/ZyUky2iuZRsmyeOfDZjNcYPJSjJ+TzVcL4zR+4TzOS2x8fEGAq0tw
         yMTzMyShXlALASF8/MHo49C7GkWmq0A1bGDBJ4PmOIN9jeb+0AUwW9hddXlknyhxGNeN
         Bc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hNWWxfqzdzivp0T2mn0yrmpXvyG7CbHJPTrnit9thI0=;
        b=jiuKrMjnTCgvdN766FMIhNpPtsyktljjPmgPaGJT/7dVrAJ5us0VxUcFIFnbbPf7I7
         jgUT5+bRs8+AucnImaik5XlcePbc0LaBkrsjpIqgV4kSn/EjIiM1OmLCyFp23Pwt3uSD
         7+pbnuaxDLorO6HszY1nnzfSZPtsez9EeaWodTphcBsjXW+9z6rvlY2cJ4g9mVhT3t8v
         hlpo2fJ8z8QA/rN2w1AoCsduT8ETWD0hz23JPR4FD10uIGXN5m8aM4eetAc1IASywSYm
         XsA20OqRRFcuuRKGyblXO0plMlKoibPW3U5QSfvMN2G1uYa3avsEZEesjkYlx/hWNt3q
         jN7Q==
X-Gm-Message-State: AOAM532w0VcSeOluYU/4GX6DXlC6XA3J2YGMJcNHbB2GVuTYqcv7FE/+
        0w3hFZUaRMjjRgedHGDfrJ7ydI/0g5ENgA8IAeed02o+5Kc=
X-Google-Smtp-Source: ABdhPJyIA4RKGtGWkp/soJyuWad7+eiHgfgSQ54pnGNZgXx5somstsepgm+xG/VExDnn6IXUhf2uq/gv0L3xeUAdERg=
X-Received: by 2002:a05:6830:349b:: with SMTP id c27mr6353737otu.251.1620700142190;
 Mon, 10 May 2021 19:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAPFHKzezkWSjZtkU-0h2D8q=uW5QEBvZcbcw91dwta24=VU+tA@mail.gmail.com>
In-Reply-To: <CAPFHKzezkWSjZtkU-0h2D8q=uW5QEBvZcbcw91dwta24=VU+tA@mail.gmail.com>
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
Date:   Mon, 10 May 2021 22:28:36 -0400
Message-ID: <CAPFHKzcxgxG_VxaS12r61Zj25TLnBQ=M2AcqRdWV7MZMZAirbw@mail.gmail.com>
Subject: Backport: "net: Only allow init netns to set default tcp cong to a
 restricted algo"
To:     stable@vger.kernel.org
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Please apply upstream git commit 8d432592f30f ("net: Only allow init
netns to set default tcp cong to a restricted algo") to the stable
trees.

Thanks,
Jonathon Reinhart
