Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFFE30A7D9
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 13:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhBAMmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 07:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhBAMmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 07:42:37 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4767C06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 04:41:56 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id b9so4519459ejy.12
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 04:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=9S4rE2iFDZ9TRHIFttCmSlrfherdKedwlaNW+lLsu1g=;
        b=NoSpQk7uIGrXdqE/+HNpCJHLn0KGj+ON4CLMwl9134FXSE6sEj7p2RivV7oM8Qbf5Q
         GV7OY1oyB4+G9mIkffzrO8Ylf+OTFnq5leamUIzirxBHbmZqSIAL8jxw5151biQAnVut
         /DRU8cYs8j56iSi8PEDf4zifxRgshVmzveZPgUxHmy72dpg/RtYKy5NsDi0Meyuuqub6
         7VUnM26ScLNEFwMnEVR4BBCMJ2kylpaEArccp0bD+9SNOG6or/7P1IpgLX2KSGRKVVeu
         Kux/qUU4GFy+25b0nfk3jcc9fFk9pOChrOg73E4TBe0NsKs82UHhNxJEGEi/NlvgsySe
         uGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=9S4rE2iFDZ9TRHIFttCmSlrfherdKedwlaNW+lLsu1g=;
        b=CB5hh8s3tR9Uy49B6vEl1qpa9J+r/F43QSyN8/2tCE5JOktcT2TLX1Qq82us7g9J/3
         +ILDg6quem56lkNz3VAAa2C9SywGj0SSkmGEQRyDGbvhV4dLZF9OuKNL5UC0BxdtjXGa
         1q2zCFZwx0NROfRSBDww9GUakfDr9y0XyAXHMdvgzpEJr+MwucSMpc2mC4ZhOb2GmosR
         Z8vwABPlGGHOo2y7dNvR9yQ5jPaC6KX9TQYlYIi//tRaE3c99E4+VOPDcwyh8j1dCP8M
         Z7fGAivGf8BBAbGjofe3s17MFM9POugNl9uTkzZWwQRRnaX7+vHbYY7t/1HzMqBQNfJT
         xzcQ==
X-Gm-Message-State: AOAM531gWE78sRUzOntEePwmSp5y5f9K0aGs3Q82Um+sVStwBHh8Nxu4
        sAn5h5BXxoaQ4fQ0tpi+dHkFoA2PZxoubnV0SJY=
X-Google-Smtp-Source: ABdhPJx1PHCZQDd392UqzOPB/LBZp04KrmY/vXKUBVwSyjRhh+obAKfOdzELDTC1b8EMN/usgJjJrRmXV/RvX72+vcI=
X-Received: by 2002:a17:906:80d1:: with SMTP id a17mr11275114ejx.93.1612183315707;
 Mon, 01 Feb 2021 04:41:55 -0800 (PST)
MIME-Version: 1.0
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Mon, 1 Feb 2021 20:41:45 +0800
Message-ID: <CADxym3ba8R6fN3O5zLAw-e7q0gjFxBd_WUKjq0hTP+JpAbJEKg@mail.gmail.com>
Subject: make sendmsg/recvmsg process multiple messages at once
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, guys!

I am thinking about making sendmsg/recvmsg process multiple messages
at once, which is possible to reduce the number of system calls.

Take the receiving of udp as an example, we can copy multiple skbs to
msg_iov and make sure that every iovec contains a udp package.

Is this a good idea? This idea seems clumsy compared to the incoming
'io-uring' based zerocopy, but maybe it can help...

Regards
Menglong Dong
