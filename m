Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF0621F3F5
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgGNOYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgGNOYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:24:46 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE33C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 07:24:45 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ls15so1673063pjb.1
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 07:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xRXcz6lJumCqtAK1sMm3c6pssF2/7Iv7wk3aJ5Rjjjk=;
        b=nAt+8N9A/QAbk8LT/E9I+bkWDYZR57ldSJsBmsMz9LBZQo7Ct1y3GFw/ad9TySK9yS
         60MaeYk4B130/uod9gIipMKxpPfFejl39rmduv6vpE/Xd+eCOL/3qKNf0DFuMSBtSmHF
         XApmoqqsVWuUEKuX+od5MdYpR2cPRe5Rptev2h27A7izJVV3RsegLadPOT+wIINY+5dp
         uR0hu1DuZPcD5QXHEvcx8mE0XTJ5IMT9n9CbH4skbv4nUYDRea1s0znWfEhc/cYaRMFa
         Tox5JPzeywVVVucwoyDad8n8+SnNKVt+KIReVqgyKOzNQI5GcJgBXqkFcQx3C6vzIjLp
         EqDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xRXcz6lJumCqtAK1sMm3c6pssF2/7Iv7wk3aJ5Rjjjk=;
        b=MpZeyWXp9P5gTcloaKosFwlkIYDR+lcWlDnLGK5jCgCj9wpBA8y9jLhq3a0L3ziO6J
         AjkZL9KIT+860JA8Re1fPp0M6qFPLBU+IOY94GbpyySZAAWZED8dv05RATPGsnqTHlod
         WnvQ+oKzrguXfAvRla84WN8/bDAvwBCZL+WMcvgApq5ohzbLC1jUL0U732lYesv1GgqQ
         Lv6SC7wfAtGg2gXvgBbKLPTuC7bU+PrOPB5Zc6ts/mP3UFCsZWq8Jyc5sM9H7+p0MuJw
         L6OzSszqPXn53j4XquknkHEQBsudD8dx1H1irg+g2OBX0gJ/PRE+2UPLwLoS6WL0guxI
         snPQ==
X-Gm-Message-State: AOAM533YbyLscRgBMgWpe7X/sA2yhEccE0ycZ8ci1wCjT8yWQKswWyC/
        MJqJDhzvdCDR3N39tDc+uQA=
X-Google-Smtp-Source: ABdhPJx+D6k7S7VQPgmJqSi61mmDMFb9pZNcc+TQHRVq2MCWmRZiDNs+VWZUKBIeu04Y4Pqyp4CBGg==
X-Received: by 2002:a17:902:c389:: with SMTP id g9mr3967929plg.317.1594736685489;
        Tue, 14 Jul 2020 07:24:45 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id bf11sm2828336pjb.48.2020.07.14.07.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 07:24:44 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: sched: Do not pass root lock
 Qdisc_ops.enqueue
To:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
References: <cover.1594732978.git.petrm@mellanox.com>
 <217e5a6059349f72e82697decc180ed9b46b066a.1594732978.git.petrm@mellanox.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <efa8d345-6457-3bcf-4fc3-f1e5e81f34a6@gmail.com>
Date:   Tue, 14 Jul 2020 07:24:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <217e5a6059349f72e82697decc180ed9b46b066a.1594732978.git.petrm@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/14/20 6:32 AM, Petr Machata wrote:
> The reason for this was to make visible the dangerous possibility that
> enqueue drops the lock. The previous patch undoes the lock dropping, and
> therefore this patch can be reverted.
> 
> Signed-off-by: Petr Machata <petrm@mellanox.com>

Wow, I have not seen that this stuff actually went in net-next.

Please make this a proper revert of
aebe4426ccaa4838f36ea805cdf7d76503e65117 ("net: sched: Pass root lock to Qdisc_ops.enqueue")


git revert aebe4426ccaa4838f36ea805cdf7d76503e65117
