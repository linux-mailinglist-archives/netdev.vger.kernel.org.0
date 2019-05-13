Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229491B7F9
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 16:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbfEMOTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 10:19:14 -0400
Received: from mail-it1-f173.google.com ([209.85.166.173]:39438 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728867AbfEMOTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 10:19:14 -0400
Received: by mail-it1-f173.google.com with SMTP id 9so13332586itf.4;
        Mon, 13 May 2019 07:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=BR7cJ9GZk8zHfq4YYMWtrjWfaYUkXsMX1HrUM1zaWyY=;
        b=X8uo56Ib9o+Vu8ymkX2/r2gy5DSgPnlJsSsaUvqzWUBESnDw53acSypqRGtkZaeRnm
         y5sbf5dG4Vaxe+i6LJOyCc9huVuGyn36+/ntsaJDTvromCpv730eb7YZKqZaD+br5Xjn
         qGNd+KRdoZVcsYfNBicTPOPfsLvfuhfyTfHDcup7mQWBAYFT8bVa96F3xayWfCXR5wVT
         ++6cQNGf190MDWLGx/ODSXPd1imExZjGAgF7eBt6wVWGzcmJyJjKykcZy5vVMzs0zL+R
         XUxLJpj8Xgfh5bKUgNpGzneteNxaxHoyskZjXWJlutn8XY6WvAZMN4Im8Zo1LLy5tYH9
         PbhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=BR7cJ9GZk8zHfq4YYMWtrjWfaYUkXsMX1HrUM1zaWyY=;
        b=nFfticZD5329Ls40+kRwxfL/ds919mVBMRFmyZ5MV1eQXlPDE/cvA+mS+bOalXUfdu
         xIUq9LMOQYNMfp0tZdAXdkRzJe0H3K8DBlLOqq5G+pXWqosfjLHm6SR8VVmF9DBQvZky
         Q0HXHVJlW+1vpzcXROPFWPxArB9ezDztL0VZfkY6Ft2a5tK6WM60IXObOVK+6dSIGiud
         zx5+vx/T4Jxe7lLUdCTqCUYWXUEXoBOu6ny8FJBK8tfM9V7CyJanDYSitbPsaZ1LBKcf
         U6tyBq8RVVSpMO1cFtIQm1TMrFEsZoYFppGRHziRg6mTt7yNfyCblLrc10ZA+0vbDtu/
         Bsng==
X-Gm-Message-State: APjAAAVyCacdLBtskAZ//B7M94ObpzcSSoa4KXADs8qaUl+4I+KxttHd
        ivkgZTK3Y15qgA2aEweQLQ4YrDJc36c=
X-Google-Smtp-Source: APXvYqxaxC2hocu2aRgSm8qQDJIFeD6if18I39AcZS4M9SuXBL7vsJzo/IxxYjOlHvpIkc86C5xvPQ==
X-Received: by 2002:a24:9c47:: with SMTP id b68mr18156465ite.169.1557757153257;
        Mon, 13 May 2019 07:19:13 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a2sm2988809iok.47.2019.05.13.07.19.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 07:19:12 -0700 (PDT)
Subject: [bpf PATCH 0/3] sockmap fixes 
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 13 May 2019 07:19:02 -0700
Message-ID: <155775710768.22311.15370233730402405518.stgit@john-XPS-13-9360>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A couple fixes for sockmap code. Previously this was bundled with a tls
fix for unhash() path however, that is becoming a larger fix so push
these on their own.

---

John Fastabend (3):
      bpf: sockmap, only stop/flush strp if it was enabled at some point
      bpf: sockmap remove duplicate queue free
      bpf: sockmap fix msg->sg.size account on ingress skb


 net/core/skmsg.c   |    7 +++++--
 net/ipv4/tcp_bpf.c |    2 --
 2 files changed, 5 insertions(+), 4 deletions(-)

--
Signature
