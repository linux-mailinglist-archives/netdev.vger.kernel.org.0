Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A44DE3781A
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 17:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfFFPfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 11:35:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44272 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfFFPfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 11:35:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so1717170pfe.11
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 08:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l6FDxu9hyC/mGWOTQpbxThS/YbL/meYSzef/1Ox1fkM=;
        b=D7YeS4hWqkDPToQ15Ey4Dx7kgxZyNjgoo5cU3LhYgwEoygNnKrRJ9dnBe+yNqAcN6x
         9s8a3HY2INizWJ/Z1q0vKsf3rqOQW3SpFsJjAYnAIwNCHHZ83XMcUg7fbrwPRRZ8ns0z
         E3v3HSoobu/eI0LyABAbi+vJsdRu5a5FyivdaptL9LFqsrozJ5Fxv+6nMtpyP3sXdBLM
         s06rIT01ETyH5B3JV/5YnIVX8tNfEUxIIXFyNEtPy4zkUUXyWpwwwps05dUdhJZxsiYs
         7EszFAD9JA4GFDbTnisISjWw0et7QMInSY/M62YWKhQC0gRls5JGBU1gYODWCUMHpMrM
         v4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l6FDxu9hyC/mGWOTQpbxThS/YbL/meYSzef/1Ox1fkM=;
        b=sY3gVYgFQb/7GT2VufEdBPV1s959ra8aj0IQEb/DNXMUhrtS591esOES8al3ZCLoYK
         fRrbK9JXJiWEwK8xmqp14dLd9QRrBkefF6WAsGHL82xjx598v7UTJrxXJcD26sMGbHrU
         tB5QUfjqRNVL5BeyoOZRcv7P2F+7VlerwZTdeyfThUc/2fEDLnVuLe9NKg/tW5iPnuO5
         6dv+wblFSy/A14lBpTdy0aZdQwCn+Jc+t3wLONCFMFDJkoxd7xfez027O/uIHs0/NL1K
         HHL2XI+6sAFx5vumziS1oC+kcZbCi+s9TkTE05beSZUMfqrDct7PMVdj2g05jqMPG3Sz
         ZiQA==
X-Gm-Message-State: APjAAAUnXClf8j8TQsrZ82US4GgIjZ/0Fp4MsCw6SEchkfIin5wsOuEP
        HKI2HdY+p3WG4l2J9Rc0Pr9Jdi4xAmA=
X-Google-Smtp-Source: APXvYqxqVU9Gk6yDgVrx9HNJ7OIO7jq4PtVV6y6pqFIuszajQrtaPW4yrtjIOLVC1aTdhjF9r/5S2Q==
X-Received: by 2002:a63:a449:: with SMTP id c9mr3945698pgp.149.1559835333429;
        Thu, 06 Jun 2019 08:35:33 -0700 (PDT)
Received: from [172.27.227.242] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id y6sm6071115pfo.38.2019.06.06.08.35.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 08:35:32 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: fix the check before getting the cookie in
 rt6_get_cookie
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net
References: <49388c263f652f91bad8a0d3687df7bb4a18f0da.1559473846.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ea598247-5f96-2455-063a-dc23d7313f85@gmail.com>
Date:   Thu, 6 Jun 2019 09:35:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <49388c263f652f91bad8a0d3687df7bb4a18f0da.1559473846.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/19 5:10 AM, Xin Long wrote:
> In Jianlin's testing, netperf was broken with 'Connection reset by peer',
> as the cookie check failed in rt6_check() and ip6_dst_check() always
> returned NULL.

Any particular test or setup that is causing the reset? I do not see
that problem in general.

