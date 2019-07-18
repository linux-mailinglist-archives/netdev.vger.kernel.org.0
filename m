Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8E06D264
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 18:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfGRQwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 12:52:37 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41696 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbfGRQwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 12:52:37 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so27865358qtj.8
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 09:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6Z8ZblcEDGJiFTraika0ZhtMow6CiMXco/UOv2Tyjq8=;
        b=VreUP1I4Yn1ODKbtlaq4OhmxqhR5tloHcoxCMvjUhDX09/B/xQVDf3IhVFTE3yptsZ
         o4wLRygSoc/zLoxf+7aWqtJ/7VYeslZUeCyyFFmwjITs7ETg/v8Uxj6LiUvmChdnta/a
         hWaqa4gZAykFkW00Bv1r2sT9DTiizFeo25aNJ5ZjuDoS2/g1cTxFa1dyLtqZdQmE+yKT
         pHJY23N5ayQlro8hKJnqMdskdyGG++l9juOd47RQ5SxnZtlVbJf2RFpY6TwMrAS1c9k2
         CUZC5TxMQ88f7qdsWV9FE4FROjdlDmSDHgHJb8D691wDAlgv+wLysjxjiuFtUH/lZTbe
         KcNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6Z8ZblcEDGJiFTraika0ZhtMow6CiMXco/UOv2Tyjq8=;
        b=DNnZeejzZDzgjarzYWBVfLbde33FRZAtdwARbezL4puE5PhKvmVOKTsgySqyK2oGnf
         C1wAHxTESliKt2enXiXGWA2ZXLxr1gNK9TUr0//fIzBKFth44fLph2p1DAm22PbihHQ0
         8W2TOnuYbbgiatee0/yfvhqnRgpR78f4JtSHVnX3/BsELRtJQ3zpssQPZFpdZAJSi0Vm
         t/qlXAQuS5aElEYOsTLHyAGST10qIpwez9Opa0oBFq/114epwlgyGt/3rwT4xMijvini
         TWyFJybI+pjGx9JxFqJAWrRb6HW0wtx8o52oSTFSszuuQE7Q1cpcvzHGRmqWeeS2GCSP
         JZww==
X-Gm-Message-State: APjAAAX4IWeGmwN9rRKwln+I33QjNOQm7o6DLYsM4H3uUbp6Ogwn6V+V
        +QB6oG5zofrq8n8i18du6ejFzm/GqQq3gQ==
X-Google-Smtp-Source: APXvYqyN0ENnaUtojMTDCQ3zEn41aBxeF7IzHx4Rb4W0jI9WAjwarDyRgh34AOVQVkaMcv7EJNNSDg==
X-Received: by 2002:ac8:19ac:: with SMTP id u41mr32428543qtj.46.1563468756448;
        Thu, 18 Jul 2019 09:52:36 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:7fee:c1f1:6380:7c32:8066])
        by smtp.gmail.com with ESMTPSA id x2sm12599780qkc.92.2019.07.18.09.52.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 09:52:35 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 2BBC6C0918; Thu, 18 Jul 2019 13:52:33 -0300 (-03)
Date:   Thu, 18 Jul 2019 13:52:33 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next iproute2 v2 0/3] net/sched: Introduce tc
 connection tracking
Message-ID: <20190718165233.GT3390@localhost.localdomain>
References: <1562832867-32347-1-git-send-email-paulb@mellanox.com>
 <9286cbad-6821-786a-6882-d2bf56b3cf05@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9286cbad-6821-786a-6882-d2bf56b3cf05@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 03:00:34PM +0000, Paul Blakey wrote:
> Hey guys,
> 
> any more comments?

From my side, just the man page on tc-ct(8) that is missing.
Everything else seems to be in place.

Thanks,
Marcelo
