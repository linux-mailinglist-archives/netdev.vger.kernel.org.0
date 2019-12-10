Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBB1117EAF
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 05:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfLJECw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 23:02:52 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43177 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfLJECw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 23:02:52 -0500
Received: by mail-wr1-f66.google.com with SMTP id d16so18371613wre.10;
        Mon, 09 Dec 2019 20:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GBZ2UUf/d5CTfHQ5WvVCK1dFeiSiz8Zvk0HK0yLq+9I=;
        b=XSQ1avuhCexaRtjUefvVcYbzWq69d7LmI3kNiSsvEXlO+08U/EFFdAnCVLpQAPgLEP
         hlSJBmgFdFYAnoO7eG4YEdLgj54FYsAdMRLg/+dNOge/d4CUmM+J8fT00h+kSne2tS35
         PA8gQvnBbA+0657B2yoNsIPMxVgHpQkP5lrGKjZdE8rX+vOoA5rU2cEM7ue+Exe2AOOl
         w6bQKv3VUs/vcP2N3gBWnGkGpm27FobfakDk5SfRfBqDPNJhLyZRvxkF2Pr1RkKNGBid
         z8B9ZZZB+ndnCZKuB44k8OflNMSPE/MCqfkNPpon4ov0fjrQt6AGcGJcK4gyP7B2cWTf
         jPtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GBZ2UUf/d5CTfHQ5WvVCK1dFeiSiz8Zvk0HK0yLq+9I=;
        b=so7n4T1ESSeA9yk0A4EZNLt07BQk9r31KM+N19oIbx0ZmhtIguDCPmdxleA8Hg8lfH
         N2u6ApItPk381mYBqndm8VcnH+BDMU99WJgLcGb41ApEd6/yfibWKJWbmZe4vpezbcEy
         FKRLyI4SmM9RL/r83TTnxV+Lz03seS+bxlD3t2TFV07v02lrK34Pk1E7lK2pMSV+tO0U
         8b7AzK5S3ugZp+HcsCJgpnz0298WRhCiFWRD8K+ZdzLeFxn6guBWcI5Dqo0vGQCa12Fa
         8+nsHzyWFhADLbgYnFTlalS5iIiKIEjb3DNnUkIX37/PHNZVN90bE5YYDf5DzPbtCs1K
         YE6A==
X-Gm-Message-State: APjAAAXfyNJ3ABF16eNAbOTAt6neXvaLRRWTFgTuQJe1oaRE+7x34Suu
        xJttbC0onjaVqoGRvcvoKyJwveAIgEHdO8H3HK8=
X-Google-Smtp-Source: APXvYqxNovVit0Io+1SOuILG++pLbanQ0zeYm6LYo7hp42A7bCab1XpYLi+Jzc7N6nujyIufuouesmv3krhZYTeG7iQ=
X-Received: by 2002:a5d:6886:: with SMTP id h6mr485017wru.154.1575950569902;
 Mon, 09 Dec 2019 20:02:49 -0800 (PST)
MIME-Version: 1.0
References: <76df0e4ae335e3869475d133ce201cc93361ce0c.1575870318.git.lucien.xin@gmail.com>
 <20191209.101403.781347318798443818.davem@davemloft.net>
In-Reply-To: <20191209.101403.781347318798443818.davem@davemloft.net>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 10 Dec 2019 12:03:17 +0800
Message-ID: <CADvbK_cVw49RXCnR3ztKC_RzZf=ipoH2a8ZabaAytmPy+0j4jQ@mail.gmail.com>
Subject: Re: [PATCHv2 net] sctp: get netns from asoc and ep base
To:     David Miller <davem@davemloft.net>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 2:14 AM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Mon,  9 Dec 2019 13:45:18 +0800
>
> > Commit 312434617cb1 ("sctp: cache netns in sctp_ep_common") set netns
> > in asoc and ep base since they're created, and it will never change.
> > It's a better way to get netns from asoc and ep base, comparing to
> > calling sock_net().
> >
> > This patch is to replace them.
> >
> > v1->v2:
> >   - no change.
> >
> > Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
>
> This looks like a cleanup rather than a bug fix, so net-next right?
Yes, a cleanup, and net-next should be better.

>
> Otherwise we need a Fixes: tag here and a better explanation in the
> commit message about what problem this fixes.  Are the netns's wrong
> sometimes without this conversion for example?
>
> Thanks.
