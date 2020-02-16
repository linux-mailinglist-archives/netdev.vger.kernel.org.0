Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1692160394
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgBPKeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:34:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25872 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726774AbgBPKeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:34:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581849241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AyZPiWK74GL/snEzHEB39Hj1J71bF2CTXG08laECY4o=;
        b=AU7zjrKZs4CfcI2GTsVjKBtFrvU7obj2JjsNIGApETBD9dHmIYcjzP1F7TPHHm8p6MC5s7
        JacBADf+iU3AWju7BiZ/ix7PwRwQEL7pcbxlIgqp5q7bJAyDIjOUh83HLM74j7J5MxRoO6
        zBWiCX6fkMh6PJ/S1vz4/N2Ab1NTZTI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-Euo2Q0oSPKCpntbdbskwgw-1; Sun, 16 Feb 2020 05:33:59 -0500
X-MC-Unique: Euo2Q0oSPKCpntbdbskwgw-1
Received: by mail-lf1-f71.google.com with SMTP id x23so1433948lfc.5
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 02:33:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=AyZPiWK74GL/snEzHEB39Hj1J71bF2CTXG08laECY4o=;
        b=MrrENb3A2DeB3X6FblDVZy72xLqz4pLNHGAMKTF+63Bmbbi/+YQ+mAbtbMntIQXB8F
         tRqP65miXW9nDiEXOTAgauPkhtE8L8RPh0CWBr8mxlQx8E/8Lwc8AjTJQbC/1e1GWltg
         CriLXJB8OzQt9/NeefigkmPCDLLMVqKPUxNj/43JFckorrOl5OzYvYrGJYWaxpomULN/
         le7YYqJcP9KKDazFUGgO+hBor4oaW9snAoZFNrnwGPbpvL2K7I/0rGlB+Unkru97oY81
         exjIgfu5MYmGSSUUUrdev5QsrKzZfVOz8MQPE9zWExCLHkV0YnE0bCCLklc3qqnamsoJ
         ocYA==
X-Gm-Message-State: APjAAAXCOk3rRxrTgK5ezD1pAEXEjnaatrtx0vVei8+tzEO1uO7+mzG/
        8LbOwiKP8af0Uw4kFlcGyISoBdN4EKNujSGHjz8ZoeXYKUkJxQqjdijl0OXngkZFj9x818kohCc
        ZlS6v+X5tZOGNEVLo
X-Received: by 2002:ac2:5979:: with SMTP id h25mr5823557lfp.203.1581849237882;
        Sun, 16 Feb 2020 02:33:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqz5CGpNlEjzA8D5rxS5gBw73IyHetdr4xNVSJIqqTnMYikH1e1wBtykq/V+h6jiwZNsqfmBaA==
X-Received: by 2002:ac2:5979:: with SMTP id h25mr5823536lfp.203.1581849237634;
        Sun, 16 Feb 2020 02:33:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a12sm6454240ljk.48.2020.02.16.02.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2020 02:33:56 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DED0E180371; Sun, 16 Feb 2020 11:33:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org
Cc:     jonathan.lemon@gmail.com, lorenzo@kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: page_pool: API cleanup and comments
In-Reply-To: <20200216094056.8078-1-ilias.apalodimas@linaro.org>
References: <20200216094056.8078-1-ilias.apalodimas@linaro.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 16 Feb 2020 11:33:55 +0100
Message-ID: <87k14mbz3g.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ilias Apalodimas <ilias.apalodimas@linaro.org> writes:

> Functions starting with __ usually indicate those which are exported,
> but should not be called directly. Update some of those declared in the
> API and make it more readable.
>
> page_pool_unmap_page() and page_pool_release_page() were doing
> exactly the same thing. Keep the page_pool_release_page() variant
> and export it in order to show up on perf logs.
> Finally rename __page_pool_put_page() to page_pool_put_page() since we
> can now directly call it from drivers and rename the existing
> page_pool_put_page() to page_pool_put_full_page() since they do the same
> thing but the latter is trying to sync the full DMA area.
>
> Also update netsec, mvneta and stmmac drivers which use those functions.
>
> Suggested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Thanks for the house cleaning :)

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

